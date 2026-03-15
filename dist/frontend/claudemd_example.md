# CLAUDE.md — [Nome do Projeto]

> **Como usar este arquivo:** Preencha as seções marcadas com `[...]` antes de ativar qualquer agente. As seções de stack, arquitetura e regras já estão preenchidas e não devem ser alteradas sem revisão técnica.

---

## Domínio do Produto

> Preencha esta seção antes de ativar qualquer agente. Os times de UX e Dev dependem desta descrição para entender o contexto do que estão construindo.

```
Produto: [Nome do produto]
Descrição: [O que o produto faz em 2-3 frases]
Tipo: [Dashboard / Aplicação web / Portal / Ferramenta interna / etc.]
Usuários principais: [Quem usa o produto e com que objetivo]
Contexto de uso: [Quando e como os usuários acessam — ex: uso diário no trabalho, acesso mobile ocasional, etc.]
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

## APIs Externas Consumidas

> Liste as APIs que o front-end consome. Os agentes usam esta seção para saber o que existe como caixa-preta e para documentar contratos em `docs/api-contracts.md`.

```
- [Nome da API]: [URL base] — [o que fornece]
- [Nome da API]: [URL base] — [o que fornece]
```

> ⚠️ O front-end consome estas APIs — não as implementa. Nenhum agente deste time desenvolve backend.

---

## Agentes de Desenvolvimento

Este projeto usa dois times de agentes Claude para desenvolvimento:

### Time UX
Responsável por pesquisa de UX, geração de propostas e definição da experiência do usuário.
Produz: `ux.md` — documento de personas, jornadas e princípios que guia todo o desenvolvimento.

### Time Dev
Responsável por planejamento, especificação visual, implementação e testes.
Sequência: Planner → UI Agent → Developer → QA & Docs

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

- **React 19+** com Vite 6+ como bundler e dev server
- **TypeScript 5.5+** obrigatório em todos os arquivos
- **Tailwind CSS v4+** para estilização — sem CSS modules
- **shadcn/ui** (CLI atual) para componentes de interface baseados em Radix UI
- **Radix UI** como primitives acessíveis para componentes complexos (dialog, dropdown, etc.)
- **TanStack Query** v5 para gerenciamento de dados assíncronos (server state)
- **React Router v7** ou TanStack Router para roteamento da aplicação
- **React Hook Form v7+** para gerenciamento de formulários
- **Zod v3+** para validação de schemas e tipagem de dados
- **Zustand v5+** para estado global simples (client state)
- **Lucide React** para ícones do sistema
- **Sonner** para notificações (toast)
- **Framer Motion** para animações e micro-interações
- **Vite** é o bundler e dev server do projeto, responsável por executar o ambiente de desenvolvimento e gerar o build otimizado da aplicação frontend para produção.
---

## Princípios da Stack

- Utility-first styling usando apenas Tailwind
- Componentes desacoplados e reutilizáveis (shadcn + Radix)
- Separação entre client state e server state
- Tipagem forte end-to-end com TypeScript
- Arquitetura orientada a features (feature-based structure)

## Regras de Arquitetura

- O projeto é **exclusivamente frontend**.
- Toda organização deve seguir uma estrutura **feature-based**.
- Cada feature deve concentrar sua própria lógica, componentes, hooks, queries e tipagens.
- Componentes globais e reutilizáveis devem ficar fora das features, em `components/`.
- Não criar lógica de negócio espalhada em páginas.
- Páginas devem atuar apenas como ponto de composição de layout e features.
- Toda integração com APIs deve passar por uma camada explícita de serviços.
- Não fazer chamadas HTTP diretamente dentro de componentes visuais.
- Separar claramente:
  - **server state** → TanStack Query
  - **client state** → Zustand
  - **form state** → React Hook Form

## Estrutura de Pastas

```
src/
│
├─ app/                         # configuração global da aplicação
│  ├─ router/                   # configuração de rotas (React Router / TanStack Router)
│  │  └─ router.tsx
│  ├─ providers/                # providers globais
│  │  ├─ query-provider.tsx
│  │  ├─ theme-provider.tsx
│  │  └─ index.tsx
│  └─ app.tsx                   # componente raiz da aplicação
│
├─ pages/                       # páginas principais (entrada das rotas)
│  ├─ dashboard/
│  │  └─ dashboard-page.tsx
│  ├─ users/
│  │  └─ users-page.tsx
│  └─ settings/
│     └─ settings-page.tsx
│
├─ features/                    # lógica de domínio organizada por feature
│  ├─ users/
│  │  ├─ components/
│  │  ├─ hooks/
│  │  ├─ services/
│  │  ├─ queries/
│  │  ├─ types.ts
│  │  └─ index.ts
│  │
│  ├─ auth/
│  │  ├─ components/
│  │  ├─ hooks/
│  │  ├─ services/
│  │  ├─ queries/
│  │  └─ types.ts
│  │
│  └─ analytics/
│     ├─ components/
│     ├─ hooks/
│     ├─ services/
│     ├─ queries/
│     └─ types.ts
│
├─ components/                  # componentes reutilizáveis da aplicação
│  ├─ ui/                       # componentes shadcn/ui (button, card, dialog…)
│  ├─ layout/                   # layout da aplicação
│  │  ├─ sidebar.tsx
│  │  ├─ header.tsx
│  │  └─ app-layout.tsx
│  └─ common/                   # componentes genéricos
│     ├─ page-header.tsx
│     └─ data-table.tsx
│
├─ hooks/                       # hooks reutilizáveis globais
│  ├─ use-debounce.ts
│  ├─ use-pagination.ts
│  └─ use-theme.ts
│
├─ services/                    # integração com APIs externas
│  ├─ api-client.ts             # axios / fetch client
│  └─ endpoints.ts
│
├─ store/                       # estado global (Zustand)
│  ├─ auth-store.ts
│  └─ ui-store.ts
│
├─ lib/                         # utilitários da aplicação
│  ├─ utils.ts                  # helpers genéricos
│  ├─ format.ts                 # formatação (datas, números)
│  └─ constants.ts
│
├─ styles/
│  └─ global.css                # Tailwind + tokens do tema
│
├─ types/                       # tipos globais TypeScript
│  ├─ api.ts
│  └─ index.ts
│
├─ assets/                      # imagens, logos, ícones
│
└─ main.tsx                     # entrypoint do Vite
```

---

## Naming Conventions

| Elemento               | Convenção                                      | Exemplo                              |
|------------------------|------------------------------------------------|--------------------------------------|
| Diretórios             | `kebab-case`                                   | `user-profile/`                      |
| Componentes (arquivo)  | `PascalCase`                                   | `UserCard.tsx`                       |
| Hooks (arquivo)        | `camelCase` com prefixo `use`                  | `useUserData.ts`                     |
| Funções utilitárias    | `camelCase`                                    | `formatCurrency.ts`                  |
| Interfaces             | `IPascalCase`                                  | `IUserCardProps`                     |
| Types                  | `PascalCase`                                   | `CreateUserInput`                    |
| DTOs / Schemas (Zod)   | `PascalCaseSchema`                             | `CreateUserSchema`                   |
| Enums                  | `PascalCase` (membros em `UPPER_SNAKE_CASE`)   | `UserRole.ADMIN`                     |
| Endpoints (API)        | `kebab-case`, plural                           | `/api/v1/user-accounts`              |
| Variáveis / funções    | `camelCase`                                    | `getUserById`                        |
| Constantes             | `UPPER_SNAKE_CASE`                             | `MAX_RETRY_ATTEMPTS`                 |
| Stores (Zustand)       | `camelCase` com sufixo `Store`                 | `useUserStore`                       |
| Query keys (TanStack)  | `UPPER_SNAKE_CASE` ou array literal            | `USER_KEYS.list()` / `['users']`     |
| Rotas (React Router)   | `kebab-case`                                   | `/user-settings`                     |
| Arquivos de rota       | `kebab-case` ou convenção do framework         | `user-settings.tsx` / `route.tsx`    |
| Componentes shadcn/ui  | `PascalCase` (conforme gerado pelo CLI)        | `Button`, `Dialog`, `DropdownMenu`   |
| Variáveis CSS/Tailwind | `kebab-case` (custom properties)               | `--color-primary`                    |
| Testes                 | `*.spec.ts` ou `*.test.ts`                     | `UserCard.spec.tsx`                  |
| Storybook              | `*.stories.tsx`                                | `UserCard.stories.tsx`               |

---

## TypeScript

- Nunca usar `any`. Preferir `unknown` com type guards quando o tipo é incerto.
- Sempre tipar os retornos de funções explicitamente.
- Usar `interface` para objetos de domínio e `type` para unions e utilitários.
- Criar tipos centralizados em `src/types/` e importar de lá.

```ts
// ✅ Correto
interface AcessoTotal {
  mes: string
  total: number
  variacao: number
}

// ❌ Errado
const data: any = await fetchData()
```

---

## Regras de Componentização
- Criar componentes pequenos, coesos e reutilizáveis.
- Um componente deve ter uma responsabilidade principal.
- Evitar componentes muito longos.
- Quebrar componentes acima de complexidade visual ou lógica relevante.
- Componentes de UI devem ser preferencialmente:
	- declarativos
	- previsíveis
	- controlados por props
- Evitar acoplamento entre componentes de features diferentes.
- Não duplicar componentes visuais já existentes no shadcn/ui sem justificativa clara.
________________________________________
## Regras de Estilo e UI
- Não usar CSS Modules.
- Não usar CSS solto por componente, exceto quando estritamente necessário.
- Priorizar classes utilitárias do Tailwind.
- Centralizar tokens de tema, cores e variáveis no tema global.
- Manter consistência visual entre espaçamentos, bordas, radius, shadow e tipografia.
- Sempre reutilizar componentes base antes de criar variações novas.
- Variantes visuais devem ser padronizadas.
- Ícones devem usar Lucide React.
________________________________________
## Regras de TypeScript
- Não usar any, exceto em casos extremamente justificados.
- Toda prop de componente deve ter tipagem explícita.
- Toda resposta de API deve ter tipo definido.
- Toda validação de entrada/saída relevante deve usar Zod.
- Preferir tipos e interfaces simples e legíveis.
- Não duplicar tipos já existentes.
- Tipos locais de uma feature devem permanecer dentro da própria feature.
- Tipos compartilhados devem ir para types/.
________________________________________
## Regras de Dados e API
- Toda chamada a backend deve estar em services/ ou dentro da camada de serviço da feature.
- Toda leitura assíncrona deve usar TanStack Query.
- Toda mutação deve usar TanStack Query mutation.
- Keys de query devem ser padronizadas e previsíveis.
- Evitar lógica de transformação pesada diretamente no componente.
- Transformações de dados devem ficar em helpers, selectors ou hooks.
- Não usar useEffect para buscar dados que pertencem ao TanStack Query.
________________________________________
## Regras de Estado
- Não usar Zustand para dados vindos do backend que já são gerenciados por TanStack Query.
- Zustand deve ser reservado para casos como:
	- sidebar aberta/fechada
	- filtros persistidos localmente
	- preferências de interface
	- estado temporário global de UX
- Evitar stores grandes e genéricas.
- Cada store deve ter propósito claro e escopo pequeno.
________________________________________
## Regras de Formulário
- Todo formulário relevante deve usar React Hook Form.
- Toda validação deve ser feita com Zod.
- Mensagens de erro devem ser claras e por campo.
- Não controlar manualmente formulários complexos com useState.
- Normalização de dados deve acontecer antes do envio.
________________________________________
## Regras de Rotas
- Toda rota deve estar centralizada na configuração de router.
- Páginas devem representar rotas reais.
- Features não devem conhecer a estrutura global de rotas além do necessário.
- Rotas protegidas, layouts e wrappers devem ficar em app/router ou app/providers.
________________________________________
## Regras de Hooks
- Hooks reutilizáveis globais devem ficar em hooks/.
- Hooks específicos de uma feature devem ficar dentro da própria feature.
- Hooks devem começar com use.
- Hooks não devem misturar responsabilidades demais.
- Evitar hooks que escondam comportamento excessivamente mágico.
________________________________________
## Regras de Nomeação
- Usar nomes claros, curtos e sem abreviações desnecessárias.
- Arquivos de componentes: kebab-case.tsx
- Componentes React: PascalCase
- Hooks: use-nome.ts ou useNome no símbolo exportado
- Stores: nome-store.ts
- Services: nome-service.ts
- Queries: nome-queries.ts
- Tipos locais: types.ts
- Testes de componente/unitário: nome-do-arquivo.spec.tsx (na pasta __tests__/ ao lado do arquivo)
- Testes E2E: nome-do-fluxo.spec.ts (na pasta e2e/ na raiz)
________________________________________
## Regras de Qualidade
- Todo código novo deve ser legível e consistente com o padrão existente.
- Evitar comentários óbvios.
- Comentar apenas decisões não triviais.
- Remover código morto.
- Não deixar TODO sem contexto.
- Toda alteração deve preservar coesão arquitetural.
- Sempre preferir simplicidade antes de abstração.
________________________________________
## Regras para o Claude Code
- Sempre gerar código aderente à stack definida neste documento.
- Sempre usar TypeScript.
- Nunca sugerir CSS Modules.
- Nunca buscar dados com fetch direto dentro do JSX.
- Nunca colocar regra de negócio complexa dentro de componentes de apresentação.
- Sempre respeitar a separação entre pages, features, components, services e store.
- Ao criar novas telas, primeiro pensar em:
1.	rota
2.	página
3.	feature
4.	componentes
5.	serviço
6.	query
7.	tipagem
- Ao criar componentes, preferir composição em vez de duplicação.
- Ao gerar código, manter compatibilidade com Tailwind v4 e shadcn/ui.
- Ao propor bibliotecas novas, justificar brevemente o motivo.
- Evitar adicionar dependências sem necessidade real.


## Testes

### Frameworks configurados

| Tipo | Ferramenta | Quando usar |
|------|-----------|-------------|
| Unitário / Componente | **Vitest** + **Testing Library** (`@testing-library/react`) | Funções puras, hooks, componentes isolados |
| Integração | **Vitest** + **MSW** (`msw`) para mock de API | Fluxos entre componentes, estado global, respostas de API mockadas |
| E2E | **Playwright** | Fluxos completos de usuário navegando na aplicação |
| Manual | Checklist no relatório de QA | Comportamentos visuais, responsividade, acessibilidade perceptiva |

### Nomenclatura de arquivos de teste

- Unitário / Componente: `[nome].spec.tsx` — na pasta `__tests__/` ao lado do arquivo testado
- E2E: `[fluxo].spec.ts` — em `e2e/` na raiz do projeto

### Logger

Não há logger customizado. Use `console.error` para erros reais em produção. Nunca use `console.log` em código commitado.

### Padrão de erro

Não há classe de erro customizada. Lance erros nativos com mensagem descritiva:
```ts
throw new Error(`fetchUsers failed: ${err.message}`)
```

---

## Documentação

### Onde salvar documentação gerada pelos agentes

| Conteúdo | Local |
|----------|-------|
| Contratos de API consumidos (payload, erros esperados) | `docs/api-contracts.md` |
| Componentes reutilizáveis (props, estados, eventos) | JSDoc/TSDoc no próprio arquivo |
| Hooks customizados | JSDoc com `@example` no próprio arquivo |
| Novas páginas ou fluxos relevantes | `docs/pages.md` |
| Variáveis de ambiente novas | `.env.example` + comentário inline |

### Localização dos artefatos gerados pelos agentes

> Os agentes gravam seus artefatos (contexto, backlog, UX, entregas, logs) diretamente em `{WORK_DIR}`, conforme configurado no `WORKSPACE.md`. Não misture artefatos de agentes com código-fonte do projeto.

---

## Sistema de Design

> Usado pelo UI Agent para especificar telas e pelo Developer para implementá-las.

- **Biblioteca de componentes:** `shadcn/ui` (baseada em Radix UI)
- **Referência de componentes:** use sempre o nome do componente shadcn ao especificar — ex: `<Button variant="outline">`, `<Dialog>`, `<Select>`, `<DataTable>`
- **Ícones:** Lucide React exclusivamente
- **Estilização:** Tailwind CSS v4 — utility-first, sem CSS Modules
- **Animações:** Framer Motion para micro-interações
- **Notificações:** Sonner para toasts
- **Tokens do tema:** definidos em `src/styles/global.css` (ver seção de tema abaixo)

---

## Qualidade de Código

- **ESLint** com `@typescript-eslint` habilitado.
- **Prettier** com configuração compartilhada no repositório.
- Sem `console.log` em código commitado — usar `console.error` apenas para erros reais.
- Nomes de variáveis e funções sempre em inglês; textos visíveis ao usuário em português.
- Commits seguindo **Conventional Commits** (`feat:`, `fix:`, `chore:`, `refactor:`, `style:`).

---

## NPM
- Só instale packages com autorização explícita do usuário.

---

## GIT Commands - CRITICAL CONSTRAINTS — Violation = Task Failure
Para todos os comandos GTI
- You are FORBIDDEN from using `&&`, `||`, `;`, or `|` inside any single Bash call.
- Chaining git commands in one Bash call is a **critical error** that invalidates the entire commit.
- Each Bash call MUST contain exactly ONE git command and nothing else.
- Before every Bash call, verify mentally: "Does this call contain only one command?" If not, split it.

---

## Abaixo está somente a configuração do theme, pensada para React 19 + Vite 6 + TypeScript + Tailwind v4 + shadcn/ui.
Convenção de uso
```
className="
  bg-glass
  text-white
  border border-white/10
  rounded-2xl
  shadow-card
"
```

Cores semânticas já prontas
	--background: fundo principal
	--foreground: texto principal
	--card: superfície padrão
	--muted-foreground: texto secundário
	--primary: teal principal
	--destructive: vermelho principal
	--chart-*: gráficos
	--sidebar-*: sidebar no padrão shadcn

Gradientes do tema
- gradient-primary: amarelo → vermelho
- gradient-accent: teal → teal escuro
- gradient-card: gradiente quente para destaque
- bg-app: fundo geral da aplicação

---