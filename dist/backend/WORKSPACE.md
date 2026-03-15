# WORKSPACE

> Preencha o campo `WORK_DIR` antes de ativar qualquer agente.
> **Todos** os arquivos do processo — contexto, debate, UX, backlog, entregas e logs — serão salvos diretamente nessa pasta, sem subpastas.

---

## Configuração obrigatória

```
WORK_DIR: \docs\feature01
```

**Exemplos válidos:**
```
WORK_DIR: \docs\feature01
WORK_DIR: C:\projetos\telecom\sprint-03
WORK_DIR: /home/zig/projetos/dashboard/feature-auth
```

---

## Arquivos gerados dentro de {WORK_DIR}

Todos os arquivos ficam na raiz da pasta indicada:

```
{WORK_DIR}/
├── contexto.md              ← você cria antes de iniciar
├── CLAUDE.md                ← você cria antes de iniciar (ou copia do projeto)
├── ux-debate.md             ← gerado por UX-A e UX-B
├── ux.md                    ← gerado por UX-Synthesis
├── api-spec-epic-XX.md      ← gerado por API Design Agent (um por Epic)
├── backlog.md               ← gerado por Planner Agent
├── us-XX-entrega.md         ← gerado por Developer Agent
├── us-XX-qa.md              ← gerado por QA & Docs Agent
├── us-XX-infra-pendencias.md ← gerado por Developer Agent (quando há pendências)
├── tech-debt.md             ← gerado por Orchestrator-Dev
├── log-orchestrator-root.md ← gerado por Orchestrator-Root
├── log-orchestrator-ux.md   ← gerado por Orchestrator-UX
└── log-orchestrator-dev.md  ← gerado por Orchestrator-Dev
```

---

## Arquivos que VOCÊ cria antes de iniciar

| Arquivo | Conteúdo mínimo |
|---------|----------------|
| `{WORK_DIR}/contexto.md` | Descrição da feature, requisitos, restrições |
| `{WORK_DIR}/CLAUDE.md` | Stack, arquitetura e convenções do projeto |

Todos os outros arquivos são gerados automaticamente pelos agentes.

---

## Regra de ouro

> Nenhum agente cria arquivos fora de `{WORK_DIR}`.
> Se `WORK_DIR` não estiver preenchido, nenhum agente é ativado.
