## Protocolo de cleanup — `_temp/`

Arquivos intermediários que já foram consumidos devem ser movidos para `{WORK_DIR}/_temp/`. Crie a pasta se não existir. **Nunca delete — apenas mova.**

**Trigger:** o Orchestrator-Dev executa o cleanup **imediatamente após cada evento listado abaixo**, antes de prosseguir para a próxima decisão.

### Após Planner concluir (`backlog.md` gerado)
Mover para `_temp/`:
- `{WORK_DIR}/context.md` (se existir)
- `{WORK_DIR}/improve*.md` (se existirem — já foram consumidos pelo Planner e incorporados ao backlog)

### Após Story concluída (QA aprovado, status `Concluído`)
Mover para `_temp/`:
- `{WORK_DIR}/us-XX-entrega.md`
- `{WORK_DIR}/us-XX-qa.md`
- `{WORK_DIR}/us-XX-backend-pendencias.md` (se existir)
- Quaisquer `{WORK_DIR}/bug##.md` ou `{WORK_DIR}/improve##.md` que foram endereçados pela Story concluída

### Após Epic concluído (integração aprovada)
Mover para `_temp/`:
- `{WORK_DIR}/ui-epic-XX.md`
