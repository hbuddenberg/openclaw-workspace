# PRD — RAG Chat System

**Versión:** 1.0  
**Fecha:** 2026-04-03  
**Autor:** Karina Schneider (RedQueen)  
**Estado:** Draft

---

## 1. Resumen

Sistema RAG (Retrieval-Augmented Generation) que permite a los usuarios **cargar documentos desde un chat**, almacenarlos en **ChromaDB** para vectorización, y **consultar la información** mediante una interfaz web tipo chat. El sistema compila la información de múltiples archivos y responde preguntas basándose en el contexto recuperado.

## 2. Problema

Los equipos trabajan con múltiples fuentes de información dispersas (PDFs, documentos, logs, código). No existe una forma rápida de cargar archivos, indexarlos y consultarlos sin configurar pipelines complejos.

## 3. Objetivos

- **Carga simple:** Subir archivos arrastrando o desde el chat (PDF, TXT, MD, DOCX, CSV, JSON, código)
- **Almacenamiento vectorial:** ChromaDB como backend de embeddings
- **Consulta conversacional:** Chat web que responde usando el contexto recuperado
- **Compilación multi-documento:** Combinar información de múltiples archivos para responder
- **Gestión de colecciones:** Crear/eliminar/consultar colecciones de documentos

## 4. Usuarios

| Perfil | Necesidad |
|--------|-----------|
| Data Engineer (Hans) | Consultar documentación técnica, logs, especificaciones |
| Equipo TI Partner | Buscar info de clientes, procesos internos |
| Personal | Almacenar y consultar documentos personales |

## 5. Funcionalidades

### 5.1 Chat Web
- Interfaz tipo chat (similar a ChatGPT/OpenClaw)
- Input de texto para consultas
- Botón/boton de arrastrar para subir archivos
- Historial de conversación por sesión
- Indicador de fuentes utilizadas en cada respuesta
- Código syntax highlighted cuando la respuesta incluye código

### 5.2 Carga de Documentos
- **Formatos soportados (sin límite):**
  - **Documentos Office:** PDF, DOCX, XLSX, PPTX
  - **Datos:** CSV, JSON, YAML, YML, TOML
  - **Texto plano / código:** TXT, MD, LOG, PY, JS, TS, SQL, HTML, XML, SH, C, CPP, JAVA, GO, RS, RB, PHP, y todos los lenguajes comunes
  - **Imágenes (OCR):** PNG, JPG, JPEG, GIF, BMP, TIFF, WEBP — extracción de texto vía Tesseract OCR (español + inglés)
  - **Vídeos (Frame OCR):** MP4, AVI, MKV, MOV, WEBM — samplea frames cada 5s y ejecuta OCR en cada frame
- Chunking automático con overlap configurable
- Extracción de texto (PyMuPDF, python-docx, python-pptx, openpyxl, Pillow+Tesseract, OpenCV)
- Metadata: nombre original, fecha de carga, colección, tamaño
- Preview del documento antes/después de cargar

### 5.3 Almacenamiento (ChromaDB)
- Colecciones separadas por tema/proyecto
- Embeddings: modelo configurable (default: sentence-transformers/all-MiniLM-L6-v2)
- Persistencia en disco
- Chunking strategy: recursive character splitting (1000 chars, 200 overlap)
- Soporte para embeddings custom (OpenAI, local)

### 5.4 Motor RAG
- Retrieval: cosine similarity, top-k configurable
- Reranking opcional (cross-encoder)
- Prompt template configurable
- Context window management (max tokens del contexto)
- Fuente citada en cada respuesta (archivo + chunk number)
- Streaming de respuestas

### 5.5 Gestión
- CRUD de colecciones
- Listar documentos en una colección
- Eliminar documentos individuales
- Stats: cantidad de chunks, tokens, documentos por colección
- Exportar/importar colecciones

## 6. No Funcionales

| Requisito | Especificación |
|-----------|---------------|
| Latencia consulta | < 3s para respuestas (incluyendo retrieval) |
| Latencia carga | < 10s para documento de 100 páginas |
| Concurrencia | Mínimo 5 usuarios simultáneos |
| Almacenamiento | ChromaDB persistente en disco |
| Stack | Python (backend), React/HTMX (frontend) |
| Despliegue | Docker o systemd en NUC |
| Seguridad | Sin auth por ahora (red local), preparado para agregar |

## 7. Stack Técnico (Propuesto)

```
Backend:  FastAPI (Python 3.12+)
DB:       ChromaDB (persistente)
LLM:      z.ai (GLM-5-turbo) / OpenAI API / Ollama (local)
Embeddings: sentence-transformers (all-MiniLM-L6-v2, local)
Frontend:  HTMX + TailwindCSS
File parsing: PyMuPDF, python-docx, python-pptx, openpyxl, Pillow+Tesseract OCR, OpenCV (video frames)
```

## 8. Hitos

| # | Hito | Estimación |
|---|------|-----------|
| 1 | Backend API + ChromaDB + carga de archivos | 1 día |
| 2 | Motor RAG (retrieval + generation) | 1 día |
| 3 | Frontend chat (HTMX + Tailwind) | 1 día |
| 4 | Gestión de colecciones + UI admin | 0.5 día |
| 5 | Dockerfile + despliegue en NUC | 0.5 día |
| **Total** | | **4 días** |

## 9. Métricas de Éxito

- Carga y query funcional en < 5s para docs de 50 páginas
- Búsqueda relevante (top-3 contiene la respuesta correcta en 80%+ de casos)
- Zero-config para empezar (solo `docker-compose up`)
