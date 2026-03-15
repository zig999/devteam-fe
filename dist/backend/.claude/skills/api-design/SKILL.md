---
name: skill-api-design
description: Templates, naming conventions, and quality rules for API specifications. Covers endpoint maps, request/response schemas, error codes, data models, authentication, and business rules. Loaded by orchestrator-dev when activating the API Design Agent.
user-invocable: false
---

# SKILL: API Design Specification

## Propósito
Esta skill define os templates, convenções de nome e checklist de qualidade para o API Design Agent produzir especificações de API consistentes, completas e prontas para o Developer Agent.

---

## Convenção de nome dos arquivos

```
{WORK_DIR}/api-spec-epic-XX.md
```

Onde `XX` é o número do Epic em minúsculas com zero à esquerda:
- EPIC-01 → `api-spec-epic-01.md`
- EPIC-02 → `api-spec-epic-02.md`

> Use sempre o identificador numérico do Epic, não o nome descritivo, para garantir referência estável.

---

## Customização via CLAUDE.md

Antes de produzir qualquer especificação, extraia do `{WORK_DIR}/CLAUDE.md`:

| O que procurar | Para usar em |
|---|---|
| Framework backend (Express, Fastify, NestJS, Django, FastAPI...) | Padrões de rota e decorators |
| ORM/ODM (Prisma, TypeORM, Sequelize, Mongoose, SQLAlchemy...) | Modelos de dados |
| Banco de dados (PostgreSQL, MongoDB, MySQL...) | Tipos de campo e constraints |
| Padrão de autenticação (JWT, OAuth, API Key...) | Headers e middleware de auth |
| Padrão de versionamento de API (v1, v2...) | Prefixo de rotas |
| Terminologia de domínio | Nomes de recursos e campos |

---

## Template canônico de endpoint

```markdown
### Endpoint: [Verbo] /api/v1/[recurso]

**Story(ies):** US-XX
**Descrição:** [O que este endpoint faz — em linguagem do domínio]
**Autenticação:** [Requerida | Pública] — [tipo: Bearer JWT / API Key / etc.]
**Autorização:** [Roles permitidos, ou "qualquer usuário autenticado"]

---

#### Request

**Headers:**
| Header | Valor | Obrigatório |
|--------|-------|-------------|
| Authorization | Bearer {token} | Sim |
| Content-Type | application/json | Sim (POST/PUT/PATCH) |

**Path Parameters:**
| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| id | string (UUID) | Identificador do recurso |

**Query Parameters:**
| Parâmetro | Tipo | Padrão | Descrição |
|-----------|------|--------|-----------|
| page | number | 1 | Número da página |
| limit | number | 20 | Itens por página (máx 100) |
| sort | string | "createdAt" | Campo de ordenação |
| order | "asc" \| "desc" | "desc" | Direção da ordenação |

**Body (JSON):**
```json
{
  "campo": "tipo — descrição e validações",
  "campo2": "tipo — descrição e validações"
}
```

**Validações:**
- `campo`: obrigatório, string, min 3 caracteres, max 255
- `campo2`: opcional, number, min 0

---

#### Response

**Sucesso (200/201):**
```json
{
  "data": {
    "id": "uuid",
    "campo": "valor",
    "createdAt": "ISO 8601",
    "updatedAt": "ISO 8601"
  }
}
```

**Lista com paginação (200):**
```json
{
  "data": [],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 150,
    "totalPages": 8
  }
}
```

---

#### Erros

| Status | Código | Quando | Mensagem |
|--------|--------|--------|----------|
| 400 | VALIDATION_ERROR | Payload inválido | "Campo X é obrigatório" |
| 401 | UNAUTHORIZED | Token ausente ou expirado | "Token de autenticação inválido" |
| 403 | FORBIDDEN | Usuário sem permissão | "Sem permissão para este recurso" |
| 404 | NOT_FOUND | Recurso não existe | "[Recurso] não encontrado" |
| 409 | CONFLICT | Duplicata ou conflito de estado | "[Recurso] já existe" |
| 422 | UNPROCESSABLE_ENTITY | Regra de negócio violada | "[Descrição da regra]" |
| 500 | INTERNAL_ERROR | Erro inesperado | "Erro interno do servidor" |

**Formato padrão de erro:**
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Campo X é obrigatório",
    "details": [
      { "field": "campo", "message": "é obrigatório" }
    ]
  }
}
```

---

#### Regras de negócio

- [Regra 1 — ex: "Apenas o criador ou admin pode deletar este recurso"]
- [Regra 2 — ex: "Status só pode transicionar de 'rascunho' para 'publicado', nunca o inverso"]

---

#### Notas técnicas

- [Referência a middleware, interceptor, guard ou decorator específico do framework]
- [Considerações de performance: paginação, cache, índices necessários]
```

---

## Template de modelo de dados

```markdown
## Modelos de dados

### [NomeDoModelo]

**Tabela/Collection:** `nome_tabela`
**Story(ies):** US-XX, US-YY

| Campo | Tipo | Nullable | Default | Descrição |
|-------|------|----------|---------|-----------|
| id | UUID | Não | auto-generated | Identificador único |
| nome | VARCHAR(255) | Não | — | Nome do recurso |
| status | ENUM('draft','published','archived') | Não | 'draft' | Estado atual |
| createdAt | TIMESTAMP | Não | now() | Data de criação |
| updatedAt | TIMESTAMP | Não | now() | Última atualização |
| deletedAt | TIMESTAMP | Sim | null | Soft delete |

**Índices:**
- `idx_nome_tabela_status` — (status) — busca por status
- `idx_nome_tabela_created` — (createdAt DESC) — listagem ordenada

**Relacionamentos:**
- `belongs_to` → OutroModelo (FK: outro_modelo_id)
- `has_many` → ModeloFilho

**Constraints:**
- UNIQUE(campo_a, campo_b) — [motivo da constraint]
```

---

## Template de mapa de endpoints (obrigatório no início do documento)

```markdown
## Mapa de endpoints

| Endpoint | Método | Story(ies) | Autenticação | Tipo |
|----------|--------|-----------|--------------|------|
| /api/v1/[recurso] | GET | US-XX | Bearer JWT | Novo |
| /api/v1/[recurso] | POST | US-XX | Bearer JWT | Novo |
| /api/v1/[recurso]/:id | PUT | US-YY | Bearer JWT | Novo |
| /api/v1/[recurso]/:id | DELETE | US-YY | Admin only | Novo |
```

---

## Estrutura final do `api-spec-epic-XX.md`

```markdown
# API Spec — EPIC-XX: [Nome do Epic]

_Criado em: YYYY-MM-DD_
_Referência UX: {WORK_DIR}/ux.md_
_Stories cobertas: US-XX, US-YY, US-ZZ_

---

## Mapa de endpoints
[tabela de endpoints x stories]

---

## Especificações de endpoint
[uma seção por endpoint com template canônico]

---

## Modelos de dados
[uma seção por modelo com template canônico]

---

## Regras de negócio consolidadas
[lista de todas as regras de negócio, agrupadas por domínio]

---

## Dúvidas em aberto
[itens marcados com ⚠️ que precisam de resposta antes do Developer]
```

---

## Checklist de qualidade antes de entregar

- [ ] Todos os endpoints do Epic estão mapeados (nenhuma Story liberada sem seus endpoints especificados)
- [ ] Cada endpoint tem cenários de erro documentados (mínimo: 400, 401, 404, 500)
- [ ] Schemas de request e response usam terminologia do domínio (sem nomes genéricos)
- [ ] Validações de input estão explícitas para cada campo do body
- [ ] Modelos de dados incluem índices, constraints e relacionamentos
- [ ] Regras de negócio estão documentadas com condições e consequências claras
- [ ] Autenticação e autorização estão especificadas para cada endpoint
- [ ] Formato de paginação está padronizado entre todos os endpoints de lista
- [ ] Formato de erro está padronizado entre todos os endpoints
- [ ] Dúvidas em aberto estão marcadas com `⚠️`
- [ ] Nome do arquivo segue a convenção: `{WORK_DIR}/api-spec-epic-XX.md`

---

## Regras de qualidade

| Regra | Ação se violada |
|---|---|
| Endpoint sem cenário de erro | Marcar como `⚠️` e não liberar para Developer |
| Endpoint sem autenticação especificada | Marcar como `⚠️` e não liberar para Developer |
| Campo sem tipo ou validação | Corrigir antes de entregar |
| Nome de recurso genérico ("item", "data") | Substituir com terminologia do domínio |
| Epic grande (5+ Stories) — entrega parcial | Especificar quais Stories podem avançar; nunca liberar Story com endpoint parcialmente especificado |
