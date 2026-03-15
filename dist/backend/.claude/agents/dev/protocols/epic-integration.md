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
