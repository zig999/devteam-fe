---
name: skill-qa-docs
description: Testing types, severity criteria, edge-case checklist, accessibility verification, and documentation patterns for front-end QA. Covers unit, component, integration (MSW), and E2E tests with Vitest, Testing Library, and Playwright. Loaded by orchestrator-dev when activating the QA & Docs agent.
user-invocable: false
---

# SKILL: QA & Docs

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
| APIs externas consumidas pelo front | Casos de borda de resposta de API |

---

## Escopo de verificação por tipo de Story

> Consulte a tabela unificada de **testes obrigatórios por tipo de Story** na `standards/SKILL.md`. Aplique apenas as verificações obrigatórias para o tipo da Story — não execute checklist universal em Stories de escopo reduzido.

---

## Papel do QA Agent em relação aos testes

O Developer entrega testes junto com o código. O QA Agent **não escreve testes** — ele valida cobertura, qualidade e execução.

| Atividade | Quem faz |
|---|---|
| Escrever testes unitários e de componente | Developer |
| Escrever testes de integração com API mockada | Developer |
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
| **Unitário** | Funções utilitárias puras, hooks, lógica de transformação de dados | Jest, Vitest |
| **Componente** | Renderização, props, estados, eventos e comportamentos de componentes isolados | Testing Library + Vitest/Jest |
| **Integração** | Fluxos entre múltiplos componentes, estado global, respostas de API mockadas | Testing Library + MSW |
| **E2E** | Fluxos completos do ponto de vista do usuário navegando na aplicação | Playwright, Cypress |
| **Manual** | Comportamentos visuais, responsividade, acessibilidade percebida, fluxos de exceção difíceis de automatizar | Checklist no relatório |

---

## Matriz de testes — como preencher

O QA preenche a matriz com base nos testes **entregues pelo Developer**, não com testes criados pelo QA.

Para cada critério de aceite: localize o teste no `us-XX-entrega.md` (seção "Testes escritos") e registre na matriz. Se não existir, registre ausência como BUG.

```markdown
| ID    | Cenário                                    | Tipo        | Prioridade | Arquivo de teste               | Resultado |
|-------|--------------------------------------------|-------------|------------|-------------------------------|-----------|
| T-01  | [Given/When/Then do critério de aceite 1]  | Componente  | Alta       | `component.spec.tsx` (L.42)   | ✅ Passou  |
| T-02  | [Given/When/Then do critério de aceite 2]  | Integração  | Alta       | `page.spec.tsx` (L.88)        | ✅ Passou  |
| T-03  | Borda: prop nula em [componente X]         | Componente  | Média      | `component.spec.tsx` (L.61)   | ✅ Passou  |
| T-04  | Borda: lista vazia retornada pela API      | Integração  | Média      | ❌ Ausente                     | BUG-01    |
| T-05  | Borda: API retorna erro 500                | Integração  | Alta       | `page.spec.tsx` (L.102)       | ✅ Passou  |
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
**Arquivo/componente:** `caminho/arquivo.ts` (linha aproximada se souber)

**Passos para reproduzir:**
1. [estado inicial do sistema]
2. [ação executada]
3. [próxima ação se necessário]

**Resultado atual:**
[O que acontece de fato — seja específico: mensagem de erro, valor retornado, comportamento visual]

**Resultado esperado:**
[O que deveria acontecer segundo o critério de aceite ou comportamento óbvio]

**Evidência:**
[Log de erro, screenshot, payload de resposta — copie literalmente]
```

---

## Padrão de documentação

### Quando documentar

| Mudança | Onde documentar |
|---|---|
| Novo componente reutilizável | JSDoc/TSDoc na definição + props documentadas (nome, tipo, obrigatório, descrição) |
| Nova página ou fluxo de navegação | Seção no `README.md` ou `docs/pages.md` |
| Novo hook customizado | JSDoc com exemplo de uso e parâmetros |
| Nova variável de ambiente | `.env.example` + `docs/configuracao.md` |
| Contrato de API consumido (endpoint, payload, erros esperados) | `docs/api-contracts.md` — apenas o contrato consumido, não a implementação |
| Script de setup ou build | `docs/runbooks/nome-do-script.md` |

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
 * Retorna null se não encontrado (não lança exceção).
 *
 * Use getUserOrThrow() se o contexto exige que o usuário exista.
 *
 * @example
 * const user = await getUser("usr_abc123");
 * if (!user) return res.status(404).json({ error: "User not found" });
 */
function getUser(id: string): Promise<User | null> { ... }
```

---

## Definição de Done — checklist completo

Uma Story só pode ir para `Concluído` quando **todos** os itens abaixo estiverem marcados:

**Testes:**
- [ ] Todos os critérios de aceite têm pelo menos um teste correspondente
- [ ] Todos os testes de prioridade Alta estão passando
- [ ] Casos de borda do checklist universal foram verificados
- [ ] Nenhum bug de severidade Crítica ou Alta está em aberto

**Documentação:**
- [ ] Novos componentes reutilizáveis documentados (props, estados, eventos)
- [ ] Novos hooks customizados documentados com exemplo de uso
- [ ] `README.md` atualizado se o comportamento visível da aplicação mudou
- [ ] Contratos de API consumidos documentados em `docs/api-contracts.md` (se novos)
- [ ] Variáveis de ambiente novas adicionadas ao `.env.example`

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
| T-01  | [descrição]                   | Unitário    | Alta       | ✅ Passou   |
| T-02  | [descrição]                   | Manual      | Alta       | ❌ Falhou   |
| T-03  | Borda: [descrição]            | Unitário    | Média      | ✅ Passou   |

---

## Bugs encontrados

[lista com template de bug report, ou "Nenhum bug encontrado"]

---

## Casos de borda — resultado

- ✅ Input nulo — tratado corretamente
- ❌ Lista vazia — retorna 500 em vez de []  → BUG-01
- ⚠️ Timeout de rede — sem feedback visual (baixa severidade, registrado)

---

## Documentação gerada/atualizada

- `docs/api-contracts.md` — contrato do endpoint GET /products documentado (payload e erros esperados)
- `src/components/ProductCard/ProductCard.tsx` — JSDoc adicionado com props e exemplo de uso

---

## Recomendação

[Aprovado] Story pode ir para Concluído.
[Reprovado] Retornar ao Developer Agent com BUG-01 e BUG-02 para correção.
```
