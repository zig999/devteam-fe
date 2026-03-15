---
description: Inicia o Time Dev para a feature indicada. Aceita ux.md (feature completa), improve##.md (melhorias incrementais) ou ambos. Uso: /dev docs/features/[nome-da-feature]
---

WORK_DIR = $ARGUMENTS

## Detecção de modo

Verifique quais arquivos existem em $ARGUMENTS:
- `ux.md` → presente?
- `improve*.md` → presente(s)?
- `backlog.md` → presente? (retomada de sessão)

### Modo de operação:

| ux.md | improve##.md | Modo |
|-------|-------------|------|
| ✅ | ❌ | **Feature** — fluxo padrão via ux.md |
| ✅ | ✅ | **Feature + Improve** — ux.md como base, melhorias como input adicional ao Planner |
| ❌ | ✅ | **Improve** — Planner gera backlog diretamente das melhorias, sem ux.md |
| ❌ | ❌ | **Erro** — nenhuma entrada disponível, orientar o humano a executar `/context`, `/ux` ou `/improve` |

> Se `backlog.md` já existir, é retomada de sessão — ignore a detecção acima e retome normalmente.

## Arquivos a ler

1. $ARGUMENTS/CLAUDE.md
2. .claude/agents/dev/orchestrator-core.md
3. $ARGUMENTS/backlog.md (se existir — retomada de sessão)
4. $ARGUMENTS/log-orchestrator-dev.md (se existir — retomada de sessão)

### Conforme o modo:
- **Feature / Feature + Improve:** ler também $ARGUMENTS/ux.md e $ARGUMENTS/context.md (se backlog não existir)
- **Improve:** ler todos os $ARGUMENTS/improve*.md e $ARGUMENTS/context.md (se existir, opcional)
- **Feature + Improve:** ler também todos os $ARGUMENTS/improve*.md

Use as instruções do Orchestrator-Dev Core para coordenar o ciclo de desenvolvimento.
Carregue protocolos individuais de `.claude/agents/dev/protocols/` conforme necessário (ver índice em `orchestrator-protocols.md`).
O Time Dev lê ux.md em modo somente leitura. Não modifica arquivos UX.
