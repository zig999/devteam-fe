---
name: skill-qa-docs
description: Testing types, severity criteria, edge-case checklist, and documentation patterns for back-end QA. Covers unit, integration, and E2E tests for routes, services, repositories, and middleware. Loaded by orchestrator-dev when activating the QA & Docs agent.
user-invocable: false
---

# SKILL: QA & Docs (Backend)

## Propósito
Esta skill define como o QA & Docs Agent deve estruturar testes, classificar bugs, verificar casos de borda e produzir documentação que sobrevive à rotatividade de time.

---

## Customização via CLAUDE.md

> Regra de precedência definida no `orchestrator-core.md`. Não repetida aqui.

Antes de testar, extraia do `CLAUDE.md`:

| O que procurar | Para usar em |
|---|---|
| Framework de testes configurado | Escolha de ferramenta na matriz |
| Padrão de nomenclatura de testes | Nome dos arquivos `.spec` / `.test` |
| Onde fica a documentação do projeto | Onde salvar docs gerados |
| ORM/banco de dados | Estratégia de setup/teardown de testes |

---

## Escopo de verificação por tipo de Story

> Consulte a tabela unificada de **testes obrigatórios por tipo de Story** na `standards/SKILL.md`. Aplique apenas as verificações obrigatórias para o tipo da Story — não execute checklist universal em Stories de escopo reduzido.

---

## Papel do QA Agent em relação aos testes

O Developer entrega testes junto com o código. O QA Agent **não escreve testes** — ele valida cobertura, qualidade e execução.

| Atividade | Quem faz |
|---|---|
| Escrever testes unitários de services e repositories | Developer |
| Escrever testes de integração de rotas/endpoints | Developer |
| Escrever testes de regressão em bugfixes | Developer |
| Executar os testes e capturar resultado | QA (se tiver acesso ao bash) |
| Validar que cada critério de aceite tem teste | QA |
| Validar que os testes testam o comportamento certo | QA |
| Identificar casos de borda sem cobertura de teste | QA |
| Reportar ausência ou qualidade insuficiente de teste como BUG | QA |

### Critérios de qualidade de teste

> Consulte a tabela de **critérios de qualidade de teste** na `standards/SKILL.md`. Use-a como referência ao validar os testes entregues pelo Developer.

---

## Tipos de teste e quando usar cada um

| Tipo | Quando usar | Ferramenta sugerida |
|---|---|---|
| **Unitário** | Funções de service, regras de negócio, validações, transformações de dados | Jest, Vitest, pytest |
| **Integração** | Rotas/endpoints (request → response), middleware chain, repository com banco real ou in-memory | Supertest + Jest, httptest, pytest + TestClient |
| **E2E** | Fluxos completos cross-service, health checks, flows de autenticação completos | Supertest, pytest, Postman/Newman |
| **Manual** | Cenários de concorrência, performance sob carga, fluxos que exigem infraestrutura real | Checklist no relatório |

---

## Matriz de testes — como preencher

O QA preenche a matriz com base nos testes **entregues pelo Developer**, não com testes criados pelo QA.

Para cada critério de aceite: localize o teste no `us-XX-entrega.md` (seção "Testes escritos") e registre na matriz. Se não existir, registre ausência como BUG.

```markdown
| ID    | Cenário                                    | Tipo        | Prioridade | Arquivo de teste                    | Resultado |
|-------|--------------------------------------------|-------------|------------|-------------------------------------|-----------|
| T-01  | [Given/When/Then do critério de aceite 1]  | Integração  | Alta       | `__tests__/integration/user.spec.ts` (L.42) | ✅ Passou  |
| T-02  | [Given/When/Then do critério de aceite 2]  | Unitário    | Alta       | `__tests__/unit/user.service.spec.ts` (L.88)| ✅ Passou  |
| T-03  | Borda: input nulo em createUser            | Unitário    | Média      | `__tests__/unit/user.service.spec.ts` (L.61)| ✅ Passou  |
| T-04  | Borda: recurso duplicado (409)             | Integração  | Média      | ❌ Ausente                           | BUG-01    |
| T-05  | Borda: request sem autenticação (401)      | Integração  | Alta       | `__tests__/integration/user.spec.ts` (L.102)| ✅ Passou  |
```

Prioridade Alta → deve passar para aprovar a Story.
Prioridade Média/Baixa → ausência gera ressalva, não reprovação automática.

---

## Casos de borda e classificação de severidade

> Consulte a `standards/SKILL.md` para:
> - **Checklist universal de casos de borda** — lista completa de cenários a verificar
> - **Classificação de severidade de bugs** — critérios e impacto na Story

---

## Template de bug report

```markdown
### BUG-XX: [Título curto e descritivo]

**Severidade:** Crítica | Alta | Média | Baixa
**Story relacionada:** US-XX
**Arquivo/módulo:** `caminho/arquivo.ts` (linha aproximada se souber)

**Passos para reproduzir:**
1. [request HTTP ou estado inicial]
2. [ação executada — endpoint, payload, headers]
3. [próxima ação se necessário]

**Resultado atual:**
[O que acontece de fato — status code, body, erro em log]

**Resultado esperado:**
[O que deveria acontecer segundo o critério de aceite ou API spec]

**Evidência:**
[Log de erro, response body, stack trace — copie literalmente]
```

---

## Padrão de documentação

### Quando documentar

| Mudança | Onde documentar |
|---|---|
| Novo endpoint | OpenAPI/Swagger ou `docs/api.md` — método, rota, request, response, erros |
| Novo service com regra de negócio complexa | JSDoc/TSDoc na classe/função |
| Nova variável de ambiente | `.env.example` + `docs/configuracao.md` |
| Nova migration | Comentário na migration explicando o motivo |
| Novo middleware reutilizável | JSDoc com exemplo de uso e configuração |
| Script de setup ou deploy | `docs/runbooks/nome-do-script.md` |

### Qualidade de documentação

Boa documentação responde:
1. **O quê** — o que esse código faz
2. **Por quê** — por que existe (especialmente se não é óbvio)
3. **Como usar** — exemplo concreto de uso

❌ Documentação ruim:
```typescript
// Retorna o usuário
function getUser(id: string) { ... }
```

✅ Documentação boa:
```typescript
/**
 * Busca um usuário pelo ID interno do sistema.
 * Lança NotFoundError se não encontrado.
 *
 * @example
 * const user = await userService.getUserById("usr_abc123");
 */
async function getUserById(id: string): Promise<User> { ... }
```

---

## Definição de Done — checklist completo

Uma Story só pode ir para `Concluído` quando **todos** os itens abaixo estiverem marcados:

**Testes:**
- [ ] Todos os critérios de aceite têm pelo menos um teste correspondente
- [ ] Todos os testes de prioridade Alta estão passando
- [ ] Casos de borda do checklist universal foram verificados
- [ ] Nenhum bug de severidade Crítica ou Alta está em aberto
- [ ] Testes de integração cobrem cenários de sucesso e erro

**Documentação:**
- [ ] Novos endpoints documentados (request, response, erros)
- [ ] Novos services com regras complexas documentados
- [ ] Variáveis de ambiente novas adicionadas ao `.env.example`
- [ ] Migrations documentadas com motivo da alteração

**Segurança:**
- [ ] Queries parametrizadas (sem concatenação SQL)
- [ ] Nenhum secret em logs ou respostas de erro
- [ ] Autenticação e autorização validadas nos endpoints novos

**Rastreabilidade:**
- [ ] Relatório de QA gerado em `{WORK_DIR}/us-XX-qa.md` com número de rodada
- [ ] Bugs registrados com severidade e passos para reproduzir
- [ ] Status da Story no `backlog.md` atualizado para `Concluído`
- [ ] Orchestrator-Dev notificado do veredicto final

**Protocolo de rodadas:**
- Rodada 1 → resultado normal
- Rodada 2 → verificar se apenas os bugs apontados foram corrigidos
- Rodada 3+ → sinalizar ao humano antes de continuar; pode indicar problema no critério de aceite

---

## Template de relatório QA

Salvar em `{WORK_DIR}/us-XX-qa.md`:

```markdown
# QA Report: US-XX — [Título da Story]

**Data:** YYYY-MM-DD
**Rodada:** 1 | 2 | 3
**Veredicto:** ✅ Aprovado | ⚠️ Aprovado com ressalvas | ❌ Reprovado

---

## Matriz de testes

| ID    | Cenário                        | Tipo        | Prioridade | Resultado  |
|-------|-------------------------------|-------------|------------|------------|
| T-01  | [descrição]                   | Integração  | Alta       | ✅ Passou   |
| T-02  | [descrição]                   | Unitário    | Alta       | ❌ Falhou   |
| T-03  | Borda: [descrição]            | Unitário    | Média      | ✅ Passou   |

---

## Bugs encontrados

[lista com template de bug report, ou "Nenhum bug encontrado"]

---

## Casos de borda — resultado

- ✅ Input nulo — validação retorna 400
- ❌ Recurso duplicado — retorna 500 em vez de 409  → BUG-01
- ⚠️ Request sem auth — retorna 401 (ok, mas mensagem genérica)

---

## Segurança — verificação

- ✅ Queries parametrizadas — verificado
- ✅ Nenhum secret em logs — verificado
- ⚠️ Rate limiting — não implementado (registrado como dívida)

---

## Documentação gerada/atualizada

- `docs/api.md` — endpoint POST /users documentado
- `.env.example` — variável DATABASE_URL adicionada

---

## Recomendação

[Aprovado] Story pode ir para Concluído.
[Reprovado] Retornar ao Developer Agent com BUG-01 e BUG-02 para correção.
```
