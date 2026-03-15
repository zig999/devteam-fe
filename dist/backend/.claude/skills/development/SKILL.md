---
name: skill-development
description: Coding standards, commit conventions, folder structure, naming rules, and error handling patterns for back-end implementation. Covers routes, controllers, services, repositories, models, and middleware. Loaded by orchestrator-dev when activating the Developer agent.
user-invocable: false
---

# SKILL: Development (Backend)

## Propósito
Esta skill define como o Developer Agent deve estruturar, nomear, organizar e entregar código — garantindo consistência entre Stories e previsibilidade para o QA Agent.

---

## Customização via CLAUDE.md

> Regra de precedência definida no `orchestrator-core.md`. Não repetida aqui.

Antes de criar qualquer arquivo, extraia do `CLAUDE.md`:

| O que procurar | Para usar em |
|---|---|
| Estrutura de pastas do projeto | Onde criar os arquivos novos |
| Convenções de nomenclatura | Nomes de arquivos, classes, funções |
| Framework/biblioteca de testes | Como escrever e rodar os testes |
| Logger configurado | Substituir `console.log` |
| Padrão de erro customizado | Classes de erro a estender |
| Variáveis de ambiente já definidas | Evitar hardcode e duplicatas |
| ORM/ODM configurado | Padrão de models e migrations |
| Padrão de validação (Zod, Joi, class-validator...) | Schemas de input |

Se o `CLAUDE.md` não cobrir algum ponto, use os padrões desta skill e documente a decisão no arquivo de entrega.

---

## Fluxo obrigatório antes de codar

```
1. Ler a Story completa (narrativa + todos os critérios de aceite)
2. Ler os arquivos listados como dependência na entrega anterior (se houver)
3. Mapear os contratos de interface que a Story vai tocar ou criar
4. Escrever o plano em comentário no topo do primeiro arquivo criado
5. Só então começar a implementação
```

Se qualquer passo revelar uma ambiguidade bloqueante → **pare e registre no arquivo de entrega antes de continuar**.

---

## Branch e commits

### Branch por Story

Antes de qualquer implementação, crie uma branch a partir de `main`:

```
feat/US-XX    ← para Stories tipo 🆕 Nova feature, 🔀 Melhoria
fix/US-XX     ← para correções vindas do QA
refactor/US-XX ← para Stories tipo 🔧 Refactoring
```

**Regras:**
- Trabalhe exclusivamente na branch da Story — nunca commite direto em `main`
- **Nunca faça push** — o push é responsabilidade exclusiva do Orchestrator-Dev, após aprovação do QA
- Commite localmente com a frequência que quiser

### Formato de commits

Prefixo semântico obrigatório:

```
feat(US-XX): [descrição do que foi adicionado]
fix(US-XX):  [descrição do que foi corrigido]
refactor(US-XX): [descrição da melhoria sem mudança de comportamento]
test(US-XX): [descrição dos testes adicionados]
docs(US-XX): [atualização de documentação]
migration(US-XX): [descrição da migration criada]
```

Prefira commits por camada quando a Story envolver múltiplos módulos (ex: primeiro `feat(US-05): add user model and migration`, depois `feat(US-05): add user repository`, depois `feat(US-05): add user service`, depois `feat(US-05): add user controller and routes`).

---

## Convenções de nomenclatura

| Elemento | Padrão | Exemplo |
|---|---|---|
| Arquivos | kebab-case | `user-profile.service.ts` |
| Classes | PascalCase | `UserProfileService` |
| Funções/métodos | camelCase | `getUserById()` |
| Constantes | SCREAMING_SNAKE | `MAX_RETRY_ATTEMPTS` |
| Variáveis | camelCase | `isActive` |
| Tipos/Interfaces | PascalCase | `CreateUserInput`, `UserResponse` |
| Tabelas DB | snake_case (plural) | `user_profiles` |
| Colunas DB | snake_case | `created_at` |
| Rotas API | kebab-case (plural) | `/api/v1/user-profiles` |
| Variáveis de ambiente | SCREAMING_SNAKE | `DATABASE_URL` |
| Testes | mesmo nome + `.spec` ou `.test` | `user-profile.service.spec.ts` |

> Convenções do `CLAUDE.md` prevalecem (ver regra de precedência no orchestrator-core).

---

## Estrutura de pastas padrão

```
src/
├── routes/              ← definição de rotas/endpoints
│   └── [recurso].routes.ts
├── controllers/         ← handlers HTTP (recebe request, retorna response)
│   └── [recurso].controller.ts
├── services/            ← regras de negócio
│   └── [recurso].service.ts
├── repositories/        ← acesso a dados (queries, ORM calls)
│   └── [recurso].repository.ts
├── models/              ← definições de entidade/schema do banco
│   └── [recurso].model.ts
├── middleware/           ← middleware compartilhado (auth, logging, error handler)
│   ├── auth.middleware.ts
│   ├── error-handler.middleware.ts
│   └── validation.middleware.ts
├── validators/          ← schemas de validação de input (Zod, Joi, etc.)
│   └── [recurso].validator.ts
├── migrations/          ← scripts de migração de banco
│   └── YYYYMMDDHHMMSS-[descricao].ts
├── config/              ← configuração da aplicação
│   ├── database.ts
│   ├── env.ts
│   └── app.ts
├── types/               ← tipos e interfaces globais
│   ├── api.ts
│   └── index.ts
├── utils/               ← funções utilitárias puras
│   └── [utilidade].ts
└── __tests__/           ← testes (espelha a estrutura de src/)
    ├── integration/
    │   └── [recurso].integration.spec.ts
    └── unit/
        ├── [recurso].service.spec.ts
        └── [recurso].repository.spec.ts
```

> Adapte conforme a estrutura definida no `CLAUDE.md`.

---

## Testes obrigatórios e critérios de qualidade

> Consulte a `standards/SKILL.md` para a tabela de testes obrigatórios por tipo de Story e os critérios de qualidade de teste. Testes fazem parte da entrega — o QA Agent não escreve testes, ele valida a cobertura dos testes que você entregou.

---

## Tratamento de erros

Toda função que pode falhar deve:

1. Usar tipos de erro explícitos — evite `throw new Error("algo deu errado")`
2. Diferenciar erros operacionais (esperados, ex: recurso não encontrado) de erros de programação (bugs)
3. Nunca silenciar erros com `catch {}` vazio
4. Propagar o contexto: `throw new AppError("createUser failed", { cause: err })`

```typescript
// ❌ Ruim
try {
  const user = await db.user.findUnique({ where: { id } });
  return user;
} catch (e) {
  throw new Error("erro");
}

// ✅ Bom
async function getUserById(id: string): Promise<User> {
  const user = await db.user.findUnique({ where: { id } });
  if (!user) throw new NotFoundError(`User ${id} not found`);
  return user;
}
```

### Camadas de erro

| Camada | Responsabilidade |
|---|---|
| Controller | Captura erros do service, mapeia para HTTP status code |
| Service | Lança erros de negócio (NotFound, Conflict, ValidationError) |
| Repository | Lança erros de dados (ConnectionError, QueryError) |
| Middleware (error handler) | Captura todos os erros não tratados, formata resposta padrão |

---

## Casos de borda

> Consulte o **checklist universal** na `standards/SKILL.md`. Para toda função implementada, trate os cenários aplicáveis e documente no arquivo de entrega.

**Padrões de tratamento:**

| Cenário | Como tratar |
|---|---|
| Input nulo ou undefined | Validar na camada de validação (schema), antes de chegar ao service |
| Lista vazia | Retornar `{ data: [], pagination: {...} }`, nunca `null` |
| Recurso não encontrado | Lançar `NotFoundError` no service → controller retorna 404 |
| Dados duplicados | Capturar unique constraint violation → retornar 409 Conflict |
| Transação falha parcialmente | Usar transaction/rollback — nunca deixar dados inconsistentes |
| Payload maior que o permitido | Limitar no middleware (body size limit) |
| Rate limiting atingido | Retornar 429 com header `Retry-After` |

---

## Proibições explícitas

- ❌ `console.log` no código de produção (use o logger configurado no projeto)
- ❌ Credenciais, tokens ou URLs de ambiente hardcoded
- ❌ `any` em TypeScript sem comentário justificando
- ❌ Imports não utilizados
- ❌ Código comentado (delete, não comente)
- ❌ `TODO` sem referência à Story ou issue (`// TODO(US-12): adicionar cache`)
- ❌ Alterar código fora do escopo da Story sem criar Story técnica separada
- ❌ Queries SQL raw sem parametrização (risco de SQL injection)
- ❌ Secrets em logs ou mensagens de erro retornadas ao cliente
- ❌ Migrations destrutivas sem reversão (sempre forneça `up` e `down`)

---

## Template de arquivo de entrega

Salvar em `{WORK_DIR}/us-XX-entrega.md`:

```markdown
# Entrega: US-XX — [Título]

**Data:** YYYY-MM-DD
**Status:** Implementado | Implementado com ressalvas

## O que foi feito
[Descrição em linguagem natural — o que o sistema faz agora que antes não fazia]

## Arquivos criados
- `caminho/arquivo.ts` — [responsabilidade do arquivo]

## Arquivos modificados
- `caminho/outro.ts` — [o que mudou e por quê]

## Migrations criadas
- `migrations/YYYYMMDDHHMMSS-descricao.ts` — [o que a migration faz]

## Critérios de aceite — rastreabilidade
- [x] Given X, When Y, Then Z → implementado em `arquivo.ts`, função `nomeFunc()`
- [ ] Given A, When B, Then C → **não implementado** — motivo: [explicação]

## Casos de borda tratados
- Input nulo em `createUser()` → retorna 400 com validação
- Recurso duplicado → retorna 409 Conflict

## Pontos de atenção para o QA
- [comportamentos que merecem atenção especial nos testes]

## Dependências de infraestrutura
- **Relatório:** `us-XX-infra-pendencias.md` | Nenhuma pendência
- **Mocks criados:** [lista de arquivos mock] | Nenhum

## Dívidas técnicas geradas
- [lista] | Nenhuma
```

---

## Template de arquivo de entrega — seção de testes

Adicionar ao `us-XX-entrega.md`:

```markdown
## Testes escritos

| Arquivo | Cobre |
|---|---|
| `__tests__/unit/user.service.spec.ts` | Critérios de aceite 1 e 2; borda: input nulo |
| `__tests__/integration/user.integration.spec.ts` | Critério 3; borda: duplicata |
```

---

## Verificação de dependências de infraestrutura

Antes de iniciar a implementação, o Developer deve mapear **todos os serviços e recursos de infraestrutura** que a Story precisa.

### Como verificar

1. Extraia da Story e da API Spec todas as dependências de infraestrutura (banco de dados, filas, cache, serviços terceiros, storage, etc.)
2. Para cada dependência, verifique se a configuração **já existe** no projeto:
   - Variáveis de ambiente definidas
   - Clients/connections configurados
   - Docker compose / scripts de setup
3. Classifique cada dependência:
   - **✅ Disponível** — configuração encontrada e funcional
   - **⚠️ Parcial** — existe mas com configuração incompleta
   - **❌ Ausente** — não localizada em nenhuma fonte

### Quando gerar o relatório

Gere o arquivo `{WORK_DIR}/us-XX-infra-pendencias.md` sempre que houver **ao menos uma dependência classificada como ⚠️ Parcial ou ❌ Ausente**.

### Template de relatório de pendências de infraestrutura

Salvar em `{WORK_DIR}/us-XX-infra-pendencias.md`:

```markdown
# Pendências de Infraestrutura: US-XX — [Título da Story]

**Data:** YYYY-MM-DD
**Story:** US-XX
**Status geral:** 🔴 Bloqueio parcial | 🟡 Implementável com mocks | 🔴 Bloqueio total

---

## Resumo

[Breve descrição do que a Story precisa de infraestrutura e o estado atual]

---

## Dependências necessárias

### 1. [Nome do serviço/recurso]

| Campo | Valor |
|---|---|
| Tipo | Database / Queue / Cache / External API / Storage |
| Configuração esperada | [variáveis de ambiente, connection string, etc.] |
| Status | ✅ Disponível / ⚠️ Parcial / ❌ Ausente |
| Onde foi buscado | [arquivos, configs ou fontes consultadas] |

**Detalhes (se ⚠️ ou ❌):**
- O que está faltando ou divergente
- Impacto na implementação

---

## Ações tomadas

| Dependência ausente | Ação no código |
|---|---|
| Redis cache | Mock em memória com Map() |
| External payment API | Stub retornando sucesso fixo |

---

## Recomendações

- [ ] Configurar variável `REDIS_URL` no `.env`
- [ ] Adicionar serviço Redis ao docker-compose
- [ ] [Outras recomendações]
```

---

## Checklist pré-entrega

- [ ] Todos os critérios de aceite foram endereçados (mesmo os não implementados, com justificativa)
- [ ] Nenhuma das proibições explícitas foi violada
- [ ] Casos de borda obrigatórios foram tratados
- [ ] **Cada critério de aceite tem ao menos um teste correspondente**
- [ ] **Casos de borda tratados no código têm teste correspondente**
- [ ] Seção "Testes escritos" preenchida no arquivo de entrega
- [ ] Verificação de dependências de infraestrutura executada (Passo 1B)
- [ ] Se há pendências de infra: relatório `us-XX-infra-pendencias.md` gerado e Orchestrator notificado
- [ ] Arquivo de entrega gerado em `{WORK_DIR}/us-XX-entrega.md`
- [ ] Status da Story no `backlog.md` atualizado para `Em teste`
- [ ] Trabalhando na branch correta (`feat/US-XX`, `fix/US-XX` ou `refactor/US-XX`)
- [ ] Commits seguem o padrão semântico (incluindo `test(US-XX):` para commits de teste)
- [ ] **Nenhum push realizado** — push é responsabilidade do Orchestrator-Dev
- [ ] Migrations incluem `up` e `down`
- [ ] Queries parametrizadas (sem concatenação de strings em SQL)
- [ ] Nenhum secret em logs ou respostas de erro
- [ ] Se for correção pós-QA: apenas os bugs do relatório foram alterados — comportamentos aprovados intocados
- [ ] Orchestrator-Dev notificado da conclusão
