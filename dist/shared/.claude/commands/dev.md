---
description: Inicia o Time Dev para a feature indicada. Requer ux.md já gerado pelo Time UX. Uso: /dev docs/features/[nome-da-feature]
---

Leia os seguintes arquivos:
1. $ARGUMENTS/CLAUDE.md
2. $ARGUMENTS/context.md (somente se $ARGUMENTS/backlog.md não existir — pular em retomada de sessão)
3. $ARGUMENTS/ux.md
4. .claude/agents/dev/orchestrator-core.md
5. $ARGUMENTS/backlog.md (se existir — retomada de sessão)
6. $ARGUMENTS/log-orchestrator-dev.md (se existir — retomada de sessão)

WORK_DIR = $ARGUMENTS

Use as instruções do Orchestrator-Dev Core para coordenar o ciclo de desenvolvimento.
Carregue `.claude/agents/dev/orchestrator-protocols.md` apenas quando precisar montar o prompt de um sub-agente.
O Time Dev lê ux.md em modo somente leitura. Não modifica arquivos UX.
