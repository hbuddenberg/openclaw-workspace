# Token Optimization

*Adaptado para setup con z.ai + OpenClaw en NUC*

## Regla Principal

Cada mensaje envía TODO el contexto: historial + memories instruction + system prompt + tool definitions. Context grande = tokens gastados en cada interacción.

## Optimización de Modelos

### Modelo correcto por tarea
| Tarea | Modelo | Costo/quality |
|-------|--------|---------------|
| Chat Hans (coordinación) | glm-5-turbo | Alto/alto |
| Subagentes (código, docs, UX) | glm-4.5-air | Medio/alto |
| Tasks simples (formateo, checks) | glm-4.5-flash | Gratis/suficiente |
| Investigación largo contexto | glm-4.7 | Medio/alto |

### Context windows
| Modelo | Context | Max output |
|--------|---------|------------|
| glm-5-turbo | 202,800 | 131,100 |
| glm-4.7 | 204,800 | 131,072 |
| glm-4.5-air | 131,072 | 98,304 |
| glm-4.5-flash | 131,072 | 98,304 |

## Gestión de Memoria

### Instruction memories (auto-inyectadas en CADA mensaje)
- Máximo 4-5 entries, ~200 tokens total
- Solo reglas universales: estilo, tono, delegación, hard lines
- Todo lo demás → `context` o `fact` (buscado on-demand, no auto-inyectado)

### Cuándo resetear sesión
| Largo | Tokens/msg | Acción |
|-------|-----------|--------|
| < 10 msgs | ~5-10k | Seguir |
| 10-20 msgs | ~20-30k | Seguir, ser conciso |
| 20-30 msgs | ~40-60k | ⚠️ Sugerir reset si cambió tema |
| 30+ msgs | ~80k+ | 🔄 Resetear al cambiar tema |

**Regla:** Session reset al cambiar de proyecto o tema. 10 msgs enfocados >>> 50 msgs dispersos.

## Lectura de Archivos

- **Siempre** usar `offset` y `limit` para archivos grandes
- Un archivo de 500 líneas leído completo = 500 líneas de tokens en CADA mensaje subsiguiente
- **Regla:** Si necesito 20 líneas de un archivo de 500, usar offset/limit

## Batching

- 5 preguntas en 1 mensaje = 1 envío de contexto
- 5 mensajes con 1 pregunta cada = 5 envíos de contexto
- **Regla:** Agrupar preguntas. Si Hans manda varias cosas juntas, responder todo junto.

## Tips Específicos

### Para subagentes
- Usar modelo más barato (glm-4.5-flash para tasks simples)
- Los subagentes no cargan la misma memoria que el main agent
- Tasks bien definidos = menos tokens ida y vuelta

### Para el main agent
- No narrar tool calls obvios (ahorra tokens output)
- Respuestas cortas cuando Hans comunica corto
- NO_REPLY cuando no hay nada que decir (0 tokens)
