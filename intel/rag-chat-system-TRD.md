# TRD — RAG Chat System

**Versión:** 1.0  
**Fecha:** 2026-04-03  
**Autor:** Karina Schneider (RedQueen)  
**Estado:** Draft

---

## 1. Arquitectura

```
┌─────────────────────────────────────────────────────┐
│                   Navegador                         │
│            (HTMX + TailwindCSS)                     │
└──────────────────────┬──────────────────────────────┘
                       │ HTTP/WebSocket
                       ▼
┌─────────────────────────────────────────────────────┐
│                 FastAPI Backend                     │
│                                                     │
│  ┌──────────┐  ┌──────────┐  ┌──────────────────┐  │
│  │  Chat    │  │  Files   │  │   Collections   │  │
│  │  Router  │  │  Router  │  │   Router        │  │
│  └────┬─────┘  └────┬─────┘  └───────┬──────────┘  │
│       │             │                │             │
│  ┌────▼─────────────▼────────────────▼──────────┐  │
│  │              RAG Engine                       │  │
│  │  ┌─────────┐  ┌──────────┐  ┌────────────┐  │  │
│  │  │ Chunker │→│ Retriever│→│  Generator │  │  │
│  │  └─────────┘  └──────────┘  └────────────┘  │  │
│  └─────────────────────┬────────────────────────┘  │
│                        │                           │
│  ┌─────────────────────▼────────────────────────┐  │
│  │              ChromaDB                        │  │
│  │         (persistente en disco)               │  │
│  └──────────────────────────────────────────────┘  │
│                                                     │
│  ┌──────────────────────────────────────────────┐  │
│  │           File Storage (/data/uploads)       │  │
│  └──────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────┘
```

## 2. Componentes

### 2.1 Backend (FastAPI)

**Estructura:**
```
rag-chat/
├── app/
│   ├── main.py              # FastAPI app entrypoint
│   ├── config.py            # Settings (env vars)
│   ├── routers/
│   │   ├── chat.py          # /api/chat endpoints
│   │   ├── files.py         # /api/files endpoints
│   │   └── collections.py   # /api/collections endpoints
│   ├── services/
│   │   ├── rag_engine.py    # RAG orchestration
│   │   ├── chunker.py       # Document chunking
│   │   ├── retriever.py     # ChromaDB queries
│   │   ├── generator.py     # LLM prompt + response
│   │   ├── file_parser.py   # Parse ALL formats (Office, images, video, code)
│   │   ├── ocr.py            # Tesseract OCR (images + video frames)
│   │   └── embeddings.py    # Embedding model wrapper
│   ├── models/
│   │   ├── schemas.py       # Pydantic models
│   │   └── database.py      # ChromaDB client
│   ├── templates/
│   │   ├── base.html        # HTMX layout
│   │   ├── index.html       # Chat interface
│   │   └── collections.html # Collections management
│   └── static/
│       ├── style.css        # Tailwind output
│       └── app.js           # HTMX extensions
├── data/
│   ├── chroma_db/           # ChromaDB persistence
│   └── uploads/             # Original files
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
└── README.md
```

### 2.2 APIs

#### Chat
```
POST /api/chat
  Body: { "message": string, "collection": string, "session_id": string }
  Response: { "response": string, "sources": [{file, chunk_id, score}] }
  Stream: SSE para streaming de respuesta

GET /api/chat/history/{session_id}
  Response: [{role, content, sources, timestamp}]
```

#### Files
```
POST /api/files/upload
  Body: multipart/form-data (files[] + collection)
  Response: { "files": [{name, chunks, status}] }

GET /api/files/{collection}
  Response: [{id, name, chunks, size, created_at}]

DELETE /api/files/{file_id}
  Response: { "status": "deleted" }
```

#### Collections
```
POST /api/collections
  Body: { "name": string, "description": string }
  Response: { "id", "name", "doc_count" }

GET /api/collections
  Response: [{id, name, doc_count, chunk_count, created_at}]

DELETE /api/collections/{collection_id}
  Response: { "status": "deleted" }

GET /api/collections/{collection_id}/stats
  Response: { documents, chunks, total_tokens, size_mb }
```

### 2.3 File Parser — Formatos Soportados

| Categoría | Formatos | Motor |
|-----------|----------|-------|
| **Documentos** | PDF, DOCX, XLSX, PPTX | PyMuPDF, python-docx, openpyxl, python-pptx |
| **Datos** | CSV, JSON, YAML, YML, TOML | built-in, pyyaml, tomllib |
| **Código/Texto** | TXT, MD, LOG, PY, JS, TS, SQL, HTML, XML, SH, C, CPP, JAVA, GO, RS, RB, PHP, y 30+ lenguajes | Auto-encoding (UTF-8, Latin-1, UTF-16) |
| **Imágenes (OCR)** | PNG, JPG, JPEG, GIF, BMP, TIFF, WEBP | Pillow + Tesseract (spa+eng) |
| **Vídeo (Frame OCR)** | MP4, AVI, MKV, MOV, WEBM | OpenCV → sample 1 frame/5s (max 20) → OCR cada frame |

**Nota:** No hay límite de formatos. Cualquier archivo se intenta parsear como texto. Imágenes y vídeos usan OCR.

### 2.4 RAG Engine Pipeline

```
1. QUERY
   User message → Embed query → ChromaDB similarity search (top-k=5)

2. CONTEXT BUILD
   Retrieved chunks → Sort by relevance → Build context string
   → Truncate to max_context_tokens (4000)

3. GENERATION
   System prompt + Context + Chat history + User query → LLM
   → Stream response with sources

4. PROMPT TEMPLATE
   [System]: You are a helpful assistant. Answer based ONLY on the provided context.
   If the answer is not in the context, say so clearly.
   
   [Context]:
   {retrieved_chunks_with_sources}
   
   [Chat History]:
   {last_n_messages}
   
   [User]: {query}
```

### 2.4 Chunking Strategy

```python
RecursiveCharacterTextSplitter(
    chunk_size=1000,
    chunk_overlap=200,
    separators=["\n\n", "\n", ". ", " ", ""],
    length_function=len,
)
```

Metadata por chunk:
```json
{
  "file_name": "doc.pdf",
  "file_id": "uuid",
  "collection": "docs",
  "chunk_index": 0,
  "total_chunks": 15,
  "created_at": "2026-04-03T10:00:00Z"
}
```

### 2.5 Embeddings

| Modelo | Dim | Velocidad | Calidad | Requiere API? |
|--------|-----|-----------|---------|---------------|
| all-MiniLM-L6-v2 | 384 | ~1ms/doc | Bueno | No (local) |
| all-mpnet-base-v2 | 768 | ~3ms/doc | Excelente | No (local) |
| text-embedding-3-small | 1536 | ~50ms/doc | Excelente | Sí (OpenAI) |

Default: `all-MiniLM-L6-v2` (local, rápido, sin costo)

### 2.6 LLM Providers

```python
# Ollama (local, sin costo)
OLLAMA_BASE_URL=http://localhost:11434
OLLAMA_MODEL=llama3

# OpenAI (requiere API key)
OPENAI_API_KEY=sk-...
OPENAI_MODEL=gpt-4o-mini
```

### 2.7 Frontend (HTMX + Tailwind)

**Diseño:**
- Layout: sidebar (colecciones) + main area (chat)
- Chat: messages container + input bar + file upload button
- Drag & drop zone para archivos
- Source pills debajo de cada respuesta (click → ver chunk)
- Toast notifications para upload status

**HTMX Patterns:**
- `hx-post="/api/chat"` con `hx-trigger="submit"`
- `hx-ext="sse"` para streaming de respuestas
- `hx-get="/api/chat/history"` para paginación
- `hx-swap="beforeend"` para nuevos mensajes

## 3. Data Model (ChromaDB)

```
Collection: {user_defined_name}
├── Document: {file_id}
│   ├── Chunks: []
│   │   ├── id: {file_id}_{chunk_index}
│   │   ├── embedding: vector[384]
│   │   ├── document: "chunk text..."
│   │   └── metadata: {file_name, collection, chunk_index, ...}
│   └── Metadata: {name, size, created_at}
```

## 4. Configuración

```yaml
# config.yaml
app:
  host: 0.0.0.0
  port: 8000
  debug: false

chroma:
  persist_directory: ./data/chroma_db

embeddings:
  provider: local          # local | openai
  model: all-MiniLM-L6-v2
  openai_api_key: ""       # solo si provider=openai

llm:
  provider: ollama         # ollama | openai
  ollama_base_url: http://localhost:11434
  ollama_model: llama3
  openai_api_key: ""
  openai_model: gpt-4o-mini
  max_context_tokens: 4000
  temperature: 0.1

rag:
  top_k: 5
  chunk_size: 1000
  chunk_overlap: 200

files:
  upload_dir: ./data/uploads
  max_file_size_mb: 50
  allowed_extensions:
    - pdf, txt, md, csv, json
    - docx, xlsx
    - py, js, ts, sql, yaml, yml, toml
    - html, xml
```

## 5. Seguridad

- Sin autenticación (red local por ahora)
- Validación de extensiones de archivo
- Límite de tamaño de archivo (50MB)
- Sanitización de inputs en ChromaDB queries
- CORS restringido a localhost
- Path traversal protection en file uploads

## 6. Deployment

### Docker
```yaml
# docker-compose.yml
services:
  rag-chat:
    build: .
    ports:
      - "8000:8000"
    volumes:
      - ./data:/app/data
    environment:
      - LLM_PROVIDER=ollama
      - OLLAMA_BASE_URL=http://host.docker.internal:11434
```

### Systemd (NUC)
```ini
[Unit]
Description=RAG Chat System
After=network.target

[Service]
User=hbuddenberg
WorkingDirectory=/opt/rag-chat
ExecStart=/opt/rag-chat/.venv/bin/uvicorn app.main:app --host 0.0.0.0 --port 8000
Restart=always

[Install]
WantedBy=multi-user.target
```
