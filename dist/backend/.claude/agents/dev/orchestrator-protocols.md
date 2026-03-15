---
name: orchestrator-dev-protocols
description: Index of protocol files. Each protocol is a separate file loaded on demand by orchestrator-core.
user-invocable: false
---

# Orchestrator-Dev — Protocolos (Backend)

> **Não carregue este arquivo inteiro.** Cada protocolo é um arquivo separado. Carregue apenas o protocolo necessário para a decisão atual.

## Índice de protocolos

| Protocolo | Arquivo | Quando carregar |
|-----------|---------|----------------|
| Montagem de contexto + extração + short mode | `.claude/agents/dev/protocols/context-mounting.md` | Ao ativar qualquer sub-agente |
| Integração de Epic | `.claude/agents/dev/protocols/epic-integration.md` | Quando todas as Stories de um Epic atingirem `Concluído` |
| Retrabalho (feedback loop) | `.claude/agents/dev/protocols/rework.md` | Quando QA reprova uma Story |
| Tech-debt | `.claude/agents/dev/protocols/tech-debt.md` | Quando `us-XX-entrega.md` contém "Dívidas técnicas geradas" |
| Push e merge | `.claude/agents/dev/protocols/push-merge.md` | Após QA aprovar uma Story |
| Cleanup `_temp/` | `.claude/agents/dev/protocols/cleanup.md` | Após Planner, Story ou Epic concluídos |
