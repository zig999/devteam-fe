# CLAUDE.md — [Nome do Projeto]

> **Como usar este arquivo:** Preencha as seções marcadas com `[...]` antes de ativar qualquer agente. As seções de stack, arquitetura e regras já estão preenchidas e não devem ser alteradas sem revisão técnica.

---

## Domínio do Produto

> Preencha esta seção antes de ativar qualquer agente. Os times de UX e Dev dependem desta descrição para entender o contexto do que estão construindo.

```
Produto: [Nome do produto]
Descrição: [O que o produto faz em 2-3 frases]
Tipo: [API REST / GraphQL / Microsserviço / Monolito / Worker / etc.]
Consumidores: [Quem consome esta API — frontend, mobile, outros serviços, integrações externas]
Contexto de uso: [Quando e como os consumidores acessam — ex: alta frequência, batch processing, real-time, etc.]
```

---

## Personas

> Preencha antes de ativar o time de UX. O Planner também usa estas personas para criar User Stories. Use nomes reais, não genéricos como "usuário" ou "admin".

```
### [Nome da Persona 1]
Quem é: [cargo, contexto profissional]
Objetivo principal no produto: [o que ela precisa conseguir fazer]
Maior frustração atual: [o que a impede ou incomoda hoje]
Critério de sucesso: [como ela sabe que o produto está funcionando para ela]

### [Nome da Persona 2]
Quem é: [...]
Objetivo principal: [...]
Maior frustração: [...]
Critério de sucesso: [...]
```

---

## APIs Expostas

> Liste as APIs que este backend expõe. Os agentes usam esta seção para entender o escopo do que está sendo construído.

```
- [Nome da API]: [base path] — [o que fornece]
- [Nome da API]: [base path] — [o que fornece]
```

## Integrações Externas Consumidas

> Liste os serviços externos que o backend consome.

```
- [Nome do serviço]: [URL base / SDK] — [o que fornece]
- [Nome do serviço]: [URL base / SDK] — [o que fornece]
```

---

## Agentes de Desenvolvimento

Este projeto usa dois times de agentes Claude para desenvolvimento:

### Time UX
Responsável por pesquisa de UX, geração de propostas e definição da experiência do usuário.
Produz: `ux.md` — documento de personas, jornadas e princípios que guia todo o desenvolvimento.

### Time Dev
Responsável por planejamento, especificação de API, implementação e testes.
Sequência: Planner → API Design Agent → Developer → QA & Docs

### Como ativar

**Início de qualquer sessão de trabalho:**
```
Leia o CLAUDE.md, o WORKSPACE.md, e os logs em {WORK_DIR}/.
Use as instruções do agent-orchestrator-root.md para avaliar o estado
atual do projeto e recomendar a próxima ação.
```

**Arquivos dos agentes:** pasta `agents/` do repositório de agentes.

**Configuração obrigatória antes de começar:**
Preencha o `WORKSPACE.md` com o caminho absoluto do projeto:
```
WORK_DIR: /caminho/absoluto/para/este/projeto
```

---

## Stack e Versões

> Preencha com a stack do seu projeto backend. Exemplos abaixo — ajuste conforme necessário.

- **Runtime:** [Node.js 20+ / Python 3.12+ / Go 1.22+ / etc.]
- **Framework:** [Express / Fastify / NestJS / FastAPI / Django / Gin / etc.]
- **Linguagem:** [TypeScript 5.5+ / Python / Go / etc.]
- **ORM/ODM:** [Prisma / TypeORM / Sequelize / SQLAlchemy / GORM / etc.]
- **Banco de dados:** [PostgreSQL 16+ / MongoDB 7+ / MySQL 8+ / etc.]
- **Validação:** [Zod / Joi / class-validator / Pydantic / etc.]
- **Autenticação:** [JWT / OAuth2 / API Key / etc.]
- **Cache:** [Redis / Memcached / In-memory / etc.]
- **Fila/Mensageria:** [BullMQ / RabbitMQ / SQS / Kafka / etc.]
- **Testes:** [Jest / Vitest / pytest / go test / etc.]
- **Bundler/Runner:** [tsx / ts-node / nodemon / uvicorn / etc.]

---

## Princípios da Stack

- Separação clara entre camadas (routes → controllers → services → repositories)
- Tipagem forte end-to-end
- Validação na fronteira (input validation no controller/middleware)
- Regras de negócio isoladas nos services
- Acesso a dados encapsulado nos repositories
- Erro handling centralizado via middleware

## Regras de Arquitetura

- O projeto é **exclusivamente backend**.
- Toda organização deve seguir uma estrutura **em camadas** (layered architecture).
- Cada camada tem responsabilidade única e não deve ultrapassar seus limites.
- Controllers apenas recebem request e retornam response — sem regra de negócio.
- Services concentram toda a lógica de negócio.
- Repositories são a única camada que acessa o banco de dados.
- Models/Entities definem a estrutura dos dados — sem lógica de negócio complexa.
- Middleware compartilhado fica isolado (auth, logging, error handling, rate limiting).
- Toda integração com serviços externos deve passar por uma camada explícita (clients/adapters).
- Não fazer queries SQL diretamente em controllers ou services — usar repositories.

## Estrutura de Pastas

```
src/
│
├─ config/                        # configuração da aplicação
│  ├─ database.ts                 # conexão com banco
│  ├─ env.ts                      # validação de variáveis de ambiente
│  └─ app.ts                      # setup do framework (middleware, plugins)
│
├─ routes/                        # definição de rotas/endpoints
│  ├─ user.routes.ts
│  ├─ auth.routes.ts
│  └─ index.ts                    # aggregador de rotas
│
├─ controllers/                   # handlers HTTP
│  ├─ user.controller.ts
│  └─ auth.controller.ts
│
├─ services/                      # regras de negócio
│  ├─ user.service.ts
│  └─ auth.service.ts
│
├─ repositories/                  # acesso a dados
│  ├─ user.repository.ts
│  └─ base.repository.ts
│
├─ models/                        # entidades/schemas do banco
│  ├─ user.model.ts
│  └─ index.ts
│
├─ middleware/                     # middleware compartilhado
│  ├─ auth.middleware.ts
│  ├─ error-handler.middleware.ts
│  ├─ validation.middleware.ts
│  └─ rate-limiter.middleware.ts
│
├─ validators/                    # schemas de validação de input
│  ├─ user.validator.ts
│  └─ auth.validator.ts
│
├─ migrations/                    # scripts de migração de banco
│  └─ YYYYMMDDHHMMSS-descricao.ts
│
├─ types/                         # tipos e interfaces globais
│  ├─ api.ts                      # tipos de request/response
│  └─ index.ts
│
├─ utils/                         # funções utilitárias puras
│  ├─ hash.ts
│  ├─ date.ts
│  └─ pagination.ts
│
├─ clients/                       # clientes para serviços externos
│  ├─ payment.client.ts
│  └─ email.client.ts
│
├─ jobs/                          # workers, cron jobs, consumers de fila
│  └─ send-email.job.ts
│
└─ main.ts                        # entrypoint da aplicação
```

---

## Naming Conventions

| Elemento               | Convenção                                      | Exemplo                              |
|------------------------|------------------------------------------------|--------------------------------------|
| Diretórios             | `kebab-case`                                   | `user-profile/`                      |
| Arquivos               | `kebab-case` com sufixo de camada              | `user-profile.service.ts`            |
| Classes                | `PascalCase`                                   | `UserProfileService`                 |
| Funções/métodos        | `camelCase`                                    | `getUserById`                        |
| Interfaces             | `IPascalCase`                                  | `IUserRepository`                    |
| Types                  | `PascalCase`                                   | `CreateUserInput`                    |
| DTOs / Schemas         | `PascalCaseSchema` ou `PascalCaseDto`          | `CreateUserSchema`, `UserResponseDto`|
| Enums                  | `PascalCase` (membros em `UPPER_SNAKE_CASE`)   | `UserRole.ADMIN`                     |
| Endpoints (API)        | `kebab-case`, plural                           | `/api/v1/user-accounts`              |
| Variáveis / funções    | `camelCase`                                    | `getUserById`                        |
| Constantes             | `UPPER_SNAKE_CASE`                             | `MAX_RETRY_ATTEMPTS`                 |
| Tabelas DB             | `snake_case`, plural                           | `user_profiles`                      |
| Colunas DB             | `snake_case`                                   | `created_at`                         |
| Variáveis de ambiente  | `UPPER_SNAKE_CASE`                             | `DATABASE_URL`                       |
| Testes                 | `*.spec.ts` ou `*.test.ts`                     | `user.service.spec.ts`               |

---

## TypeScript

- Nunca usar `any`. Preferir `unknown` com type guards quando o tipo é incerto.
- Sempre tipar os retornos de funções explicitamente.
- Usar `interface` para objetos de domínio e `type` para unions e utilitários.
- Criar tipos centralizados em `src/types/` e importar de lá.

```ts
// ✅ Correto
interface User {
  id: string
  name: string
  email: string
  role: UserRole
}

// ❌ Errado
const data: any = await fetchData()
```

---

## Regras de Controllers
- Controllers são finos — recebem request, validam, chamam service, retornam response.
- Toda validação de input deve acontecer antes de chamar o service (via middleware ou schema).
- Controllers nunca acessam o banco diretamente.
- Controllers não contêm regras de negócio.
- Erros do service são capturados e mapeados para HTTP status codes.

## Regras de Services
- Services concentram toda a lógica de negócio.
- Services recebem dados já validados — não validam input.
- Services não conhecem HTTP (sem req, res, status codes).
- Services lançam erros de domínio (NotFoundError, ConflictError, etc.).
- Services chamam repositories para acesso a dados e clients para integrações externas.

## Regras de Repositories
- Repositories são a única camada com acesso direto ao banco.
- Queries complexas ficam no repository, não no service.
- Repositories retornam entidades de domínio, não objetos do ORM.
- Toda query deve ser parametrizada (nunca concatenar strings).

## Regras de Middleware
- Auth middleware valida token e popula `req.user`.
- Validation middleware aplica schemas e rejeita payloads inválidos.
- Error handler middleware captura erros não tratados e formata resposta padrão.
- Rate limiter middleware protege endpoints sensíveis.

## Regras de Migrations
- Toda migration tem `up` e `down`.
- Migrations destrutivas (drop column, drop table) requerem confirmação.
- Nunca editar uma migration já executada — criar uma nova.
- Nome do arquivo: `YYYYMMDDHHMMSS-descricao-curta.ts`

---

## Regras de TypeScript
- Não usar any, exceto em casos extremamente justificados.
- Toda resposta de API deve ter tipo definido.
- Toda validação de entrada deve usar schema (Zod, Joi, class-validator).
- Preferir tipos e interfaces simples e legíveis.
- Não duplicar tipos já existentes.
- Tipos locais de um módulo devem permanecer dentro do próprio módulo.
- Tipos compartilhados devem ir para types/.

## Regras de Dados e API
- Toda chamada a banco deve estar em repositories/.
- Toda integração externa deve estar em clients/.
- Keys de cache devem ser padronizadas e previsíveis.
- Evitar lógica de transformação pesada diretamente no controller.
- Transformações de dados devem ficar em helpers ou services.

## Regras de Qualidade
- Todo código novo deve ser legível e consistente com o padrão existente.
- Evitar comentários óbvios.
- Comentar apenas decisões não triviais.
- Remover código morto.
- Não deixar TODO sem contexto.
- Toda alteração deve preservar coesão arquitetural.
- Sempre preferir simplicidade antes de abstração.

## Regras para o Claude Code
- Sempre gerar código aderente à stack definida neste documento.
- Sempre usar TypeScript (ou a linguagem definida na stack).
- Nunca fazer queries SQL sem parametrização.
- Nunca colocar regra de negócio complexa dentro de controllers.
- Sempre respeitar a separação entre routes, controllers, services, repositories e models.
- Ao criar novos endpoints, primeiro pensar em:
1. rota
2. controller
3. service
4. repository
5. model/migration
6. validação
7. tipagem
8. testes
- Ao gerar código, manter compatibilidade com o ORM e framework configurados.
- Ao propor bibliotecas novas, justificar brevemente o motivo.
- Evitar adicionar dependências sem necessidade real.

---

## Testes

### Frameworks configurados

| Tipo | Ferramenta | Quando usar |
|------|-----------|-------------|
| Unitário | **[Jest / Vitest / pytest]** | Funções de service, regras de negócio, validações, utils |
| Integração | **[Supertest + Jest / TestClient + pytest]** | Rotas/endpoints (request → response), middleware chain |
| E2E | **[Supertest / pytest / Newman]** | Fluxos completos cross-service |
| Manual | Checklist no relatório de QA | Cenários de concorrência, performance, fluxos com infra real |

### Nomenclatura de arquivos de teste

- Unitário: `[nome].spec.ts` — em `__tests__/unit/`
- Integração: `[nome].integration.spec.ts` — em `__tests__/integration/`
- E2E: `[fluxo].e2e.spec.ts` — em `__tests__/e2e/`

### Logger

[Defina o logger do projeto — ex: Pino, Winston, ou logger nativo do framework]
Nunca use `console.log` em código commitado.

### Padrão de erro

[Defina as classes de erro customizadas — ex:]
```ts
class AppError extends Error {
  constructor(message: string, public statusCode: number, public code: string) {
    super(message);
  }
}

class NotFoundError extends AppError {
  constructor(resource: string) {
    super(`${resource} not found`, 404, "NOT_FOUND");
  }
}

class ConflictError extends AppError {
  constructor(message: string) {
    super(message, 409, "CONFLICT");
  }
}
```

---

## Documentação

### Onde salvar documentação gerada pelos agentes

| Conteúdo | Local |
|----------|-------|
| Endpoints expostos (request, response, erros) | `docs/api.md` ou OpenAPI/Swagger |
| Services com regras de negócio complexas | JSDoc/TSDoc no próprio arquivo |
| Variáveis de ambiente novas | `.env.example` + comentário inline |
| Migrations | Comentário no topo da migration |
| Scripts de setup/deploy | `docs/runbooks/` |

### Localização dos artefatos gerados pelos agentes

> Os agentes gravam seus artefatos (contexto, debate, UX, backlog, entregas e logs) diretamente em `{WORK_DIR}`, conforme configurado no `WORKSPACE.md`. Não misture artefatos de agentes com código-fonte do projeto.

---

## Segurança

- **Queries parametrizadas** — nunca concatenar input do usuário em SQL
- **Secrets** — nunca em logs, respostas de erro ou versionados no git
- **Autenticação** — todo endpoint que não é público deve validar token
- **Autorização** — validar permissões por role/scope no middleware
- **Rate limiting** — endpoints públicos e de autenticação devem ter limite
- **CORS** — configurar origins permitidos explicitamente
- **Helmet/headers de segurança** — ativar headers padrão de segurança

---

## Qualidade de Código

- **ESLint** com `@typescript-eslint` habilitado (ou equivalente da stack).
- **Prettier** com configuração compartilhada no repositório.
- Sem `console.log` em código commitado — usar logger configurado.
- Nomes de variáveis e funções sempre em inglês; mensagens de erro ao cliente podem seguir a língua do produto.
- Commits seguindo **Conventional Commits** (`feat:`, `fix:`, `chore:`, `refactor:`, `migration:`).

---

## NPM / Dependências
- Só instale packages com autorização explícita do usuário.

---

## GIT Commands - CRITICAL CONSTRAINTS — Violation = Task Failure
Para todos os comandos GIT
- You are FORBIDDEN from using `&&`, `||`, `;`, or `|` inside any single Bash call.
- Chaining git commands in one Bash call is a **critical error** that invalidates the entire commit.
- Each Bash call MUST contain exactly ONE git command and nothing else.
- Before every Bash call, verify mentally: "Does this call contain only one command?" If not, split it.

---

## Variáveis de Ambiente

> Liste as variáveis de ambiente do projeto abaixo:

```env
# Aplicação
PORT=3000
NODE_ENV=development

# Banco de dados
DATABASE_URL=postgresql://user:pass@localhost:5432/dbname

# Autenticação
JWT_SECRET=your-secret-here
JWT_EXPIRES_IN=7d

# [Adicione mais conforme necessário]
```
