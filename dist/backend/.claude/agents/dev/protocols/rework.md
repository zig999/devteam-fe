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
