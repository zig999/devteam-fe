---
name: skill-development
description: Coding standards, commit conventions, folder structure, naming rules, and error handling patterns for front-end implementation. Covers React, TypeScript, and feature-based architecture. Loaded by orchestrator-dev when activating the Developer agent.
user-invocable: false
---

# SKILL: Development

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
feat/US-XX    ← para Stories tipo 🆕 Nova feature, 🔀 Melhoria, 🎨 Ajuste visual
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
```

Prefira commits por módulo de UI quando a Story envolver múltiplos componentes ou telas (ex: primeiro `feat(US-05): add ProductCard component`, depois `feat(US-05): add ProductList page`, depois `feat(US-05): add product store`).

---

## Convenções de nomenclatura

| Elemento | Padrão | Exemplo |
|---|---|---|
| Arquivos | kebab-case | `user-profile.component.tsx` |
| Componentes | PascalCase | `UserProfile` |
| Funções/hooks | camelCase | `useUserProfile()` |
| Constantes | SCREAMING_SNAKE | `MAX_ITEMS_PER_PAGE` |
| Variáveis | camelCase | `isLoading` |
| Tipos/Interfaces | PascalCase | `UserProfile`, `UserProfileProps` |
| Testes | mesmo nome + `.spec` ou `.test` | `user-profile.component.spec.tsx` |

> Convenções do `CLAUDE.md` prevalecem (ver regra de precedência no orchestrator-core).

---

## Estrutura de pastas padrão

```
src/
├── components/          ← componentes reutilizáveis
│   └── [componente]/
│       ├── [componente].tsx
│       ├── [componente].types.ts
│       └── __tests__/
│           └── [componente].spec.tsx
├── pages/               ← telas (uma pasta por rota/tela)
│   └── [pagina]/
│       ├── index.tsx
│       └── [pagina].spec.tsx
├── hooks/               ← custom hooks
├── store/               ← estado global (ex: Zustand, Redux, Context)
├── services/            ← funções de consumo de API externa (fetch/axios)
├── types/               ← tipos e interfaces globais
└── utils/               ← funções utilitárias puras
```

> Adapte conforme a estrutura definida no `CLAUDE.md`.

---

## Testes obrigatórios e critérios de qualidade

> Consulte a `standards/SKILL.md` para a tabela de testes obrigatórios por tipo de Story e os critérios de qualidade de teste. Testes fazem parte da entrega — o QA Agent não escreve testes, ele valida a cobertura dos testes que você entregou.

---

## Tratamento de erros

Toda função que pode falhar deve:

1. Usar tipos de erro explícitos — evite `throw new Error("algo deu errado")`
2. Diferenciar erros operacionais (esperados, ex: 404 da API) de erros de programação (bugs)
3. Nunca silenciar erros com `catch {}` vazio
4. Propagar o contexto: `throw new Error("fetchUser failed", { cause: err })`

```typescript
// ❌ Ruim
try {
  const data = await fetch("/api/users/" + id).then(r => r.json());
  return data;
} catch (e) {
  throw new Error("erro");
}

// ✅ Bom
try {
  const res = await fetch("/api/users/" + id);
  if (!res.ok) throw new ApiError(`fetchUser(${id}) returned ${res.status}`);
  return res.json();
} catch (err) {
  throw new ApiError(`fetchUser(${id}) failed`, { cause: err });
}
```

---

## Casos de borda

> Consulte o **checklist universal** na `standards/SKILL.md`. Para toda função implementada, trate os cenários aplicáveis e documente no arquivo de entrega.

**Padrões de tratamento:**

| Cenário | Como tratar |
|---|---|
| Input nulo ou undefined | Guard clause no início da função |
| Lista vazia | Retornar `[]`, nunca `null` |
| Recurso não encontrado | Retornar `null` ou lançar `NotFoundError` (documentar qual) |
| Chamada de API retorna erro (4xx/5xx) | Lançar erro tipado com status, nunca deixar propagar como `unknown` |
| Dados fora do range esperado | Validar na entrada (DTO/schema) antes de processar |

---

## Proibições explícitas

- ❌ `console.log` no código de produção (use o logger configurado no projeto)
- ❌ Credenciais, tokens ou URLs de ambiente hardcoded
- ❌ `any` em TypeScript sem comentário justificando
- ❌ Imports não utilizados
- ❌ Código comentado (delete, não comente)
- ❌ `TODO` sem referência à Story ou issue (`// TODO(US-12): remover após migração`)
- ❌ Alterar código fora do escopo da Story sem criar Story técnica separada

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

## Critérios de aceite — rastreabilidade
- [x] Given X, When Y, Then Z → implementado em `arquivo.ts`, função `nomeFunc()`
- [ ] Given A, When B, Then C → **não implementado** — motivo: [explicação]

## Casos de borda tratados
- Input nulo em `getUser()` → retorna 404
- Lista vazia → retorna `[]`

## Pontos de atenção para o QA
- [comportamentos que merecem atenção especial nos testes]

## Dependências de backend
- **Relatório:** `us-XX-backend-pendencias.md` | Nenhuma pendência
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
| `caminho/arquivo.spec.tsx` | Critérios de aceite 1 e 2; borda: input nulo |
| `caminho/hook.spec.ts` | Critério 3; borda: lista vazia |
```

---

## Verificação de dependências de backend

Antes de iniciar a implementação, o Developer deve mapear **todos os endpoints e serviços de backend** que a Story precisa consumir.

### Como verificar

1. Extraia da Story e da UI Spec todas as ações que implicam comunicação com o servidor (salvar, buscar, deletar, atualizar, autenticar, etc.)
2. Para cada ação, identifique o endpoint esperado (método HTTP, rota, payload, resposta)
3. Busque no projeto de backend (ou na documentação de API referenciada no `CLAUDE.md`):
   - Arquivos de rotas / controllers
   - Definições OpenAPI / Swagger
   - Contratos de API documentados
   - Serviços / resolvers GraphQL
4. Classifique cada endpoint:
   - **✅ Disponível** — encontrado e compatível com o contrato esperado
   - **⚠️ Parcial** — existe mas com contrato diferente do necessário (faltam campos, formato divergente, etc.)
   - **❌ Ausente** — não localizado em nenhuma fonte

### Quando gerar o relatório

Gere o arquivo `{WORK_DIR}/us-XX-backend-pendencias.md` sempre que houver **ao menos um endpoint classificado como ⚠️ Parcial ou ❌ Ausente**.

### Template de relatório de pendências de backend

Salvar em `{WORK_DIR}/us-XX-backend-pendencias.md`:

```markdown
# Pendências de Backend: US-XX — [Título da Story]

**Data:** YYYY-MM-DD
**Story:** US-XX
**Responsável frontend:** Developer Agent
**Status geral:** 🔴 Bloqueio parcial | 🟡 Implementável com mocks | 🔴 Bloqueio total

---

## Resumo

[Breve descrição do que a Story precisa do backend e o estado atual das dependências]

---

## Endpoints necessários

### 1. [Nome descritivo da operação]

| Campo | Valor |
|---|---|
| Método | `GET` / `POST` / `PUT` / `DELETE` / `PATCH` |
| Rota esperada | `/api/v1/recurso` |
| Payload (request) | `{ campo: tipo }` ou N/A |
| Resposta esperada | `{ campo: tipo }` |
| Status | ✅ Disponível / ⚠️ Parcial / ❌ Ausente |
| Onde foi buscado | [arquivos, docs ou fontes consultadas] |

**Detalhes (se ⚠️ ou ❌):**
- O que está faltando ou divergente
- Impacto no frontend (qual funcionalidade fica comprometida)

### 2. [Próximo endpoint...]

_(repetir para cada endpoint necessário)_

---

## Ações tomadas no frontend

| Endpoint ausente | Ação no frontend |
|---|---|
| `POST /api/v1/recurso` | Mock criado em `services/recurso.mock.ts` |
| `GET /api/v1/outro` | Dados estáticos em `__mocks__/outro.json` |

---

## Recomendações para o time de backend

- [ ] Criar endpoint `POST /api/v1/recurso` — [descrição do contrato necessário]
- [ ] Ajustar resposta de `GET /api/v1/outro` para incluir campo `novoAtributo: string`
- [ ] [Outras recomendações]

---

## Impacto na entrega

- **O que funciona sem o backend:** [funcionalidades que rodam com mock]
- **O que fica bloqueado:** [funcionalidades que dependem de integração real]
- **Quando o backend estiver pronto:** remover mocks marcados com `// TODO(US-XX)` e testar integração
```

---

## Checklist pré-entrega

- [ ] Todos os critérios de aceite foram endereçados (mesmo os não implementados, com justificativa)
- [ ] Nenhuma das proibições explícitas foi violada
- [ ] Casos de borda obrigatórios foram tratados
- [ ] **Cada critério de aceite tem ao menos um teste correspondente**
- [ ] **Casos de borda tratados no código têm teste correspondente**
- [ ] Seção "Testes escritos" preenchida no arquivo de entrega
- [ ] Verificação de dependências de backend executada (Passo 1B)
- [ ] Se há pendências de backend: relatório `us-XX-backend-pendencias.md` gerado e Orchestrator notificado
- [ ] Arquivo de entrega gerado em `{WORK_DIR}/us-XX-entrega.md`
- [ ] Status da Story no `backlog.md` atualizado para `Em teste`
- [ ] Trabalhando na branch correta (`feat/US-XX`, `fix/US-XX` ou `refactor/US-XX`)
- [ ] Commits seguem o padrão semântico (incluindo `test(US-XX):` para commits de teste)
- [ ] **Nenhum push realizado** — push é responsabilidade do Orchestrator-Dev
- [ ] Se for correção pós-QA: apenas os bugs do relatório foram alterados — comportamentos aprovados intocados
- [ ] Orchestrator-Dev notificado da conclusão
