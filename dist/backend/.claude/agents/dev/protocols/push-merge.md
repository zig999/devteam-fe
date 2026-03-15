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
