---
name: orchestrator-dev-protocols
description: Context mounting protocols, Epic integration, feedback loops, and tech-debt management for backend. Loaded by orchestrator-core only when activating sub-agents or running advanced protocols.
user-invocable: false
---

# Orchestrator-Dev — Protocolos (Backend)

> Carregue este arquivo apenas quando precisar montar o prompt de um sub-agente ou executar um protocolo avançado (integração de Epic, retrabalho, tech-debt).

---

## Protocolo de montagem de contexto

| Agente | Arquivo de instrução | Skills obrigatórias |
|--------|---------------------|-------------------|
| Planner | `.claude/agents/dev/planner.md` | `.claude/skills/planning/SKILL.md` |
| API Design Agent | `.claude/agents/dev/api-designer.md` | `.claude/skills/api-design/SKILL.md` |
| Developer | `.claude/agents/dev/developer.md` | `.claude/skills/development/SKILL.md` + `.claude/skills/standards/SKILL.md` |
| QA & Docs | `.claude/agents/dev/qa-docs.md` | `.claude/skills/qa-docs/SKILL.md` + `.claude/skills/standards/SKILL.md` |

**Regra:** o agente nunca é invocado sem suas skills. Quando há mais de uma skill (ex: Developer e QA recebem `standards/SKILL.md` além da específica), **todas** devem ser incluídas. O prompt de ativação já contém tudo.

**Convenção de API specs:** `{WORK_DIR}/api-spec-epic-XX.md` (ex: EPIC-01 → `api-spec-epic-01.md`).

**Estrutura do prompt de ativação:**
```
Leia em paralelo:
- {WORK_DIR}/CLAUDE.md
- [dados relevantes — veja extração abaixo]
- .claude/agents/dev/[agente].md
- .claude/skills/[nome]/SKILL.md

[instrução da tarefa]
```

> **QA & Docs:** não inclua `ux.md` no contexto inicial (leitura lazy). Inclua o tipo da Story e o output de testes obrigatoriamente.

---

## Extração de contexto (redução de tokens)

**Nunca passe arquivos inteiros** quando apenas um trecho é relevante.

### Developer Agent

Copie no prompt (não passe o arquivo):
```
## Story alvo (extraído do backlog.md)
[bloco completo da US-XX: título, narrativa, critérios de aceite, tipo, estimativa, dependências, módulos afetados]

## API Spec — endpoints desta Story (extraído de api-spec-epic-XX.md)
[apenas as seções de endpoints da Story alvo]
```

### API Design Agent

Copie no prompt:
```
## Epic e Stories alvo (extraído do backlog.md)
[bloco EPIC-XX com objetivo e suas Stories]

## Contexto UX relevante (extraído de ux.md)
### Personas
[apenas as do Epic]
### Jornadas relevantes
[apenas as do Epic]
### Princípios de UX
[incluir sempre — costumam ser curtos]
```

### QA & Docs Agent

Copie no prompt (mesmo padrão do Developer):
```
## Story alvo (extraído do backlog.md)
[bloco completo da US-XX: título, narrativa, critérios de aceite, tipo, estimativa, dependências, módulos afetados]

## Resultado de execução dos testes
[output capturado pelo Orchestrator]
```

### Planner Agent

- **Sessão inicial** (backlog ausente): `ux.md` **completo**
- **Retomada**: apenas seções de Epics ainda não presentes no backlog + personas

---

## Short mode (Stories subsequentes)

**Quem decide:** o Orchestrator-Dev, automaticamente. Ao montar o contexto de um sub-agente, verifique no log se já houve ativação anterior do **mesmo agente** para o **mesmo Epic**. Se sim, use short mode.

A partir da **2ª Story de um mesmo Epic**, o modelo já internalizou os templates. Substitua a skill completa por um lembrete compacto no prompt:

```
Skills já carregadas na Story anterior deste Epic.
Lembrete: use o mesmo formato de entrega (us-XX-entrega.md) e padrões de teste (standards/SKILL.md).
Referência rápida: commits semânticos, proibições (console.log, any, hardcode), checklist pré-entrega.
```

Inclua a skill completa **apenas na 1ª Story** de cada Epic ou quando o agente mudar (ex: primeira vez que o QA é ativado).

---

## Protocolo de integração de Epic

Quando todas as Stories de um Epic atingirem `Concluído`:

1. Acione **QA & Docs** com:
   - Todos os `us-XX-entrega.md` do Epic
   - Todos os `us-XX-qa.md` do Epic
   - `{WORK_DIR}/api-spec-epic-XX.md` — coerência de contratos
   - `{WORK_DIR}/ux.md` — aderência às jornadas
2. Verificações:
   - [ ] Stories funcionam em sequência (fluxo end-to-end)
   - [ ] Sem quebra de contrato entre Stories
   - [ ] Consistência de API preservada (endpoints não conflitantes)
   - [ ] Jornada do ux.md implementada como um todo
3. Se reprovar: bug técnico → Developer, incoerência UX → humano
4. Registrar como `Em teste — integração (rodada N)`
5. Só marcar Epic `✅ Concluído` após aprovação

---

## Protocolo de retrabalho (feedback loop)

Quando QA reprova:

1. Separar bugs por severidade:
   - **Crítica / Alta** → bloqueiam; ciclo de correção imediato
   - **Média** → ressalvas; ficam pendentes para Story de melhoria separada
   - **Baixa** → registradas; sem ação

2. Para Crítica/Alta, classificar:
   - **Bug técnico** → Developer com prompt: _"Corrija apenas os bugs listados. Não altere comportamentos aprovados."_
   - **Problema de UX** → escalar ao humano

3. Após correção → QA novamente com histórico completo
4. Registrar rodada: `Em teste (rodada N)`
5. Na 3ª rodada → escalar ao humano
6. Durante aguardo → continuar com outras Stories independentes; registrar o bloqueio no log

---

## Protocolo de tech-debt

**Quem cria:** o Orchestrator-Dev, ao processar o `us-XX-entrega.md` que contenha a seção "Dívidas técnicas geradas".
**Quando:** imediatamente após o QA aprovar a Story (antes do push).
**Onde:** `{WORK_DIR}/tech-debt.md` (criado automaticamente na primeira ocorrência).

Adicionar ao `{WORK_DIR}/tech-debt.md`:
```markdown
## [US-XX] — [Título] — [data]
- **[Bloqueante | Não bloqueante]** — [descrição]
- **Status:** Pendente | Endereçado em US-YY
```

- **Bloqueante:** impede Stories futuras → criar Story 🔧 Refactoring P0 no backlog **imediatamente**, antes de avançar para a próxima Story dependente
- **Não bloqueante:** registrar no tech-debt.md → revisar ao final de cada Epic e decidir com o humano se gera Story dedicada ou permanece como registro

---

## Protocolo de push e merge

O Developer Agent **nunca faz push**. O controle de push e merge em `main` é responsabilidade exclusiva do Orchestrator-Dev.

### Após QA aprovar uma Story

1. Verifique que a branch `feat/US-XX` (ou `fix/`, `refactor/`) existe e tem commits locais
2. Faça push da branch para o remote:
   ```
   git push -u origin feat/US-XX
   ```
3. Pergunte ao humano se deseja fazer **squash merge** em `main`:
   ```
   ✅ Story US-XX aprovada pelo QA.

   Branch: feat/US-XX
   Commits: [quantidade] commits locais

   Como deseja fazer o merge em main?

   1. Squash merge — unifica em um único commit: "feat(US-XX): [título da Story]"
   2. Merge padrão — preserva todos os commits individuais
   3. Ainda não — merge depois
   ```
4. Após o merge, delete a branch:
   ```
   git branch -d feat/US-XX
   git push origin --delete feat/US-XX
   ```

### Após QA reprovar uma Story

- **Não faça push.** O Developer corrige na mesma branch local.
- O ciclo se repete até aprovação.

---

## Protocolo de cleanup — `_temp/`

Arquivos intermediários que já foram consumidos devem ser movidos para `{WORK_DIR}/_temp/`. Crie a pasta se não existir. **Nunca delete — apenas mova.**

**Trigger:** o Orchestrator-Dev executa o cleanup **imediatamente após cada evento listado abaixo**, antes de prosseguir para a próxima decisão.

### Após Planner concluir (`backlog.md` gerado)
Mover para `_temp/`:
- `{WORK_DIR}/context.md`

### Após Story concluída (QA aprovado, status `Concluído`)
Mover para `_temp/`:
- `{WORK_DIR}/us-XX-entrega.md`
- `{WORK_DIR}/us-XX-qa.md`
- Quaisquer `{WORK_DIR}/bug##.md` ou `{WORK_DIR}/improve##.md` que foram endereçados pela Story concluída

### Após Epic concluído (integração aprovada)
Mover para `_temp/`:
- `{WORK_DIR}/api-spec-epic-XX.md`
