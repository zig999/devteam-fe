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
