# Plan de Implementación — RAG Chat System

**Versión:** 1.0  
**Fecha:** 2026-04-03  
**Repo propuesto:** `hbuddenberg/rag-chat`

---

## Fase 1: Backend Core (Día 1)

### 1.1 Setup del proyecto
- [ ] Crear repo `hbuddenberg/rag-chat` (privado)
- [ ] Estructura de carpetas
- [ ] `requirements.txt` con dependencias
- [ ] `app/config.py` con settings (env vars)
- [ ] `app/main.py` con FastAPI app

### 1.2 ChromaDB + Embeddings
- [ ] `app/services/embeddings.py` — wrapper para embeddings (local + OpenAI)
- [ ] `app/models/database.py` — ChromaDB client singleton
- [ ] Tests: crear colección, insertar chunks, query

### 1.3 File Parser
- [ ] `app/services/file_parser.py`
  - [ ] PDF (PyMuPDF/pymupdf)
  - [ ] DOCX (python-docx — paragraphs + tables)
  - [ ] XLSX (openpyxl — all sheets)
  - [ ] PPTX (python-pptx — slides + shapes + tables)
  - [ ] TXT, MD, CSV, JSON, TOML, YAML (built-in + pyyaml + tomllib)
  - [ ] All code files (30+ extensions, auto-encoding)
  - [ ] Images OCR (Pillow + Tesseract: PNG, JPG, GIF, BMP, TIFF, WEBP)
  - [ ] Video Frame OCR (OpenCV: MP4, AVI, MKV, MOV, WEBM)
  - [ ] System: install tesseract + tesseract-data-spa/eng

### 1.4 Chunker
- [ ] `app/services/chunker.py` — RecursiveCharacterTextSplitter
  - chunk_size: 1000, overlap: 200
  - Metadata por chunk (file_name, collection, chunk_index)
- [ ] Test: chunking de documento de prueba

### 1.5 API de Files
- [ ] `POST /api/files/upload` — multipart upload + parse + chunk + store
- [ ] `GET /api/files/{collection}` — listar documentos
- [ ] `DELETE /api/files/{file_id}` — eliminar documento y chunks

### 1.6 API de Collections
- [ ] `POST /api/collections` — crear colección
- [ ] `GET /api/collections` — listar con stats
- [ ] `DELETE /api/collections/{id}` — eliminar colección completa
- [ ] `GET /api/collections/{id}/stats` — documentos, chunks, tamaño

**Checkpoint:** Backend funcional, puedo subir archivos y consultar ChromaDB vía API.

---

## Fase 2: Motor RAG (Día 2)

### 2.1 Retriever
- [ ] `app/services/retriever.py`
  - Embed query → ChromaDB similarity search
  - Top-k configurable (default: 5)
  - Filtrar por colección
  - Retornar chunks con scores y metadata

### 2.2 Generator
- [ ] `app/services/generator.py`
  - Provider: Ollama (local) u OpenAI
  - System prompt template
  - Context building (concatenar chunks truncados)
  - Streaming de respuestas
  - Source citation (archivo + chunk)

### 2.3 RAG Engine (orchestrator)
- [ ] `app/services/rag_engine.py`
  - Pipeline: query → embed → retrieve → build context → generate
  - Chat history management (last N messages)
  - Error handling (no context found, LLM timeout)
  - Logging de queries y retrieval scores

### 2.4 Chat API
- [ ] `POST /api/chat` — query con streaming (SSE)
  - Request: {message, collection, session_id}
  - Response: SSE stream (text deltas) + sources
- [ ] `GET /api/chat/history/{session_id}` — historial

### 2.5 Integración Ollama
- [ ] Configurar Ollama en el NUC (si no está)
- [ ] Pull modelo: `ollama pull llama3`
- [ ] Test: query → retrieve → generate local

**Checkpoint:** RAG funcional vía API/curl. Subo un PDF, hago una pregunta, recibo respuesta con fuentes.

---

## Fase 3: Frontend (Día 3)

### 3.1 Layout base
- [ ] `templates/base.html` — HTMX layout + TailwindCSS
- [ ] Sidebar: lista de colecciones + botón "Nueva colección"
- [ ] Main area: chat container
- [ ] Responsive (mobile-friendly)

### 3.2 Chat Interface
- [ ] `templates/index.html`
  - Messages container (scroll auto)
  - Input bar con textarea (auto-resize)
  - Botón upload de archivos (drag & drop zone)
  - Send con Enter (Shift+Enter = nueva línea)
- [ ] HTMX: `hx-post="/api/chat"` con SSE streaming
- [ ] Source pills: click → modal con chunk completo
- [ ] Empty state: "Sube archivos o selecciona una colección"

### 3.3 File Upload UX
- [ ] Drag & drop zone sobre el chat
- [ ] Botón 📎 para seleccionar archivos
- [ ] Upload progress indicator
- [ ] Toast: "Archivo cargado (N chunks)" o error
- [ ] Preview: lista de archivos en la colección

### 3.4 Collections Management
- [ ] `templates/collections.html`
  - Lista de colecciones con stats
  - Crear colección (modal)
  - Ver documentos dentro
  - Eliminar colección/documento (confirm)
- [ ] HTMX: CRUD completo sin recargar página

### 3.5 Estilos
- [ ] Dark theme por defecto (matching OpenClaw aesthetic)
- [ ] Code syntax highlighting en respuestas (highlight.js)
- [ ] Markdown rendering en respuestas (markdown-it)
- [ ] Animaciones sutiles (fade-in de mensajes)

**Checkpoint:** Interfaz web completa y funcional. Chat + upload + collections.

---

## Fase 4: Polish + Deploy (Día 4)

### 4.1 Docker
- [ ] `Dockerfile` (Python 3.11 slim)
- [ ] `docker-compose.yml` (app + volumes)
- [ ] `.dockerignore`
- [ ] Test: `docker-compose up` → todo funciona

### 4.2 Systemd (opcional, NUC)
- [ ] Service file para NUC
- [ ] Nginx reverse proxy (puerto 80 → 8000)
- [ ] Auto-start on boot

### 4.3 UX Improvements
- [ ] Session management (sidebar con chats pasados)
- [ ] Exportar conversación (MD, JSON)
- [ ] Búsqueda fuzzy en colecciones
- [ ] Stats dashboard (docs, chunks, queries)

### 4.4 Testing
- [ ] Test con 5 tipos de archivo (PDF, DOCX, XLSX, PPTX, CSV)
- [ ] Test con imagen (OCR)
- [ ] Test con video (frame OCR)
- [ ] Test con documento grande (100+ páginas)
- [ ] Test con múltiples colecciones
- [ ] Test de carga: 10 archivos simultáneos
- [ ] Test de retrieval accuracy (preguntas específicas)

### 4.5 Documentación
- [ ] README.md con instrucciones de instalación
- [ ] API docs (FastAPI auto-genera)
- [ ] Config example (config.yaml.example)

---

## Dependencias

```
# requirements.txt
fastapi==0.115.*
uvicorn[standard]==0.34.*
chromadb==1.0.*
sentence-transformers==4.1.*
pymupdf==1.25.*
python-docx==1.1.*
python-multipart==0.0.20
openai==1.68.*           # optional, for OpenAI provider
httpx-sse==0.4.*
jinja2==3.1.*
pyyaml==6.0.*
```

## Opcional / Futuro

- [ ] Autenticación (JWT o API keys)
- [ ] Webhook integration (auto-ingest desde URLs)
- [ ] OCR para imágenes escaneadas (tesseract)
- [ ] Reranking con cross-encoder
- [ ] Multi-tenant (aislar datos por usuario)
- [ ] Plugin: conectar a OpenClaw como skill
- [ ] Embeddings en GPU (aceleración)
