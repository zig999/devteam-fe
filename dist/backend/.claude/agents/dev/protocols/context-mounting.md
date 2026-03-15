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

**Conforme o modo de operação:**

**Modos Feature / Feature + Improve** (ux.md presente) — copie no prompt:
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

**Modo Improve** (sem ux.md) — copie no prompt:
```
## Epic e Stories alvo (extraído do backlog.md)
[bloco EPIC-XX com objetivo e suas Stories]

## Melhorias de referência (extraído dos improve##.md originais)
[descrição, local e comportamento desejado de cada melhoria vinculada ao Epic]

> Não há ux.md nesta sessão. Use as descrições das melhorias como
> referência para o design de API. Priorize consistência com os
> contratos e endpoints já existentes no projeto.
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

**Conforme o modo de operação:**

- **Modo Feature** (sessão inicial, backlog ausente): `ux.md` **completo**
- **Modo Improve** (sem ux.md): todos os `improve##.md` concatenados no prompt, na ordem numérica
- **Modo Feature + Improve**: `ux.md` completo + todos os `improve##.md` como seção adicional:
  ```
  ## Melhorias incrementais solicitadas
  [conteúdo de cada improve##.md, separados por ---]
  ```
- **Retomada** (qualquer modo): apenas seções de Epics ainda não presentes no backlog + personas (se ux.md existir)

> **Modo Improve — instrução adicional ao Planner:** "Não há ux.md nesta sessão. Gere o backlog a partir das melhorias listadas abaixo. Cada melhoria pode gerar uma ou mais User Stories. Agrupe em Epics quando fizer sentido temático. Mantenha o escopo enxuto — são melhorias incrementais, não features completas."

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
