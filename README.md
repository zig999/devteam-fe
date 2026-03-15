# Dev Team Agents

Sistema de agentes autônomos para [Claude Code](https://docs.anthropic.com/en/docs/claude-code) que coordenam o ciclo completo de desenvolvimento de features — da pesquisa de UX até a entrega com QA.

> Este repositório **não é um produto**. É a infraestrutura de agentes que é instalada em projetos destino.

---

## Como funciona

O sistema é composto por dois times de agentes que trabalham em sequência:

```
/context → /ux → /dev
```

### Time UX

Cinco agentes com perspectivas radicalmente diferentes analisam o briefing de forma isolada, gerando propostas independentes. Um sexto agente (UX-SYNTHESIS-X) sintetiza as propostas em 3 direções de produto. O humano escolhe uma, e o agente a expande no `ux.md` final.

| Agente | Lente |
|--------|-------|
| UX-DESTRUCTOR | Inversão de premissas |
| UX-ALIEN | Zero convenções de UI |
| UX-TEMPO | Três horizontes temporais |
| UX-CONTRARIAN | Lógica contrária |
| UX-SISTEMA | Ecossistema e escala |
| UX-SYNTHESIS-X | Síntese por colisão |

### Time Dev

Recebe o `ux.md` e executa o ciclo de desenvolvimento:

| Agente | Papel |
|--------|-------|
| Planner | Gera backlog com Epics e User Stories |
| UI Agent* | Especificação visual detalhada por Epic |
| API Designer** | Design de endpoints e contratos |
| Developer | Implementa cada User Story |
| QA & Docs | Valida a entrega e documenta |

\* Apenas no domínio **frontend**
\** Apenas no domínio **backend**

---

## Instalação

### Pré-requisitos

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) instalado e configurado

### Instalar agentes em um projeto

```bash
# Frontend
./dist/install.sh frontend C:\caminho\do\projeto

# Backend
./dist/install.sh backend C:\caminho\do\projeto
```

O script copia para o projeto destino:
- Agentes compartilhados (Time UX)
- Agentes específicos do domínio (Time Dev frontend ou backend)
- Templates `CLAUDE.md` e `WORKSPACE.md` (sem sobrescrever se já existirem)

---

## Uso

### 1. Configurar o projeto destino

Preencha os dois arquivos no projeto onde os agentes foram instalados:

- **`CLAUDE.md`** — Stack, arquitetura e convenções do projeto
- **`WORKSPACE.md`** — Defina o `WORK_DIR` (pasta onde os artefatos serão gerados)

### 2. Gerar o contexto da feature

```
/context docs/features/nome-da-feature
```

Entrevista guiada que coleta requisitos e gera o `context.md`.

### 3. Executar o Time UX

```
/ux docs/features/nome-da-feature
```

Gera propostas de UX, apresenta 3 direções e, após escolha humana, produz o `ux.md`.

### 4. Executar o Time Dev

```
/dev docs/features/nome-da-feature
```

Lê o `ux.md`, gera o backlog e executa o ciclo de desenvolvimento completo.

---

## Estrutura do repositório

```
dev-team/
├── CLAUDE.md                  # Instruções para os agentes neste repo
├── WORKSPACE.md               # Template de configuração de workspace
├── claudemd_example.md        # Template de CLAUDE.md para projetos destino
└── dist/                      # Pacote de distribuição
    ├── install.sh             # Script de instalação
    ├── shared/                # Agentes e skills compartilhados
    │   └── .claude/
    │       ├── agents/ux/     # Time UX (6 agentes)
    │       ├── commands/      # Slash commands (/context, /ux, /dev)
    │       └── skills/        # Skills compartilhadas
    ├── frontend/              # Domínio frontend
    │   └── .claude/
    │       ├── agents/dev/    # Time Dev (Planner, UI, Developer, QA)
    │       └── skills/        # Skills: development, ui, qa-docs, standards
    └── backend/               # Domínio backend
        └── .claude/
            ├── agents/dev/    # Time Dev (Planner, API Designer, Developer, QA)
            └── skills/        # Skills: development, api-design, qa-docs, standards
```

---

## Artefatos gerados por feature

Todos os arquivos são salvos no `WORK_DIR` configurado:

```
{WORK_DIR}/
├── context.md                 # Briefing da feature (você cria via /context)
├── ux.md                      # Entregável do Time UX → entrada do Time Dev
├── ux-proposals.md            # 3 direções de produto apresentadas
├── ux-debate.md               # Registro de decisões de design
├── backlog.md                 # Epics e User Stories
├── ui-[epic].md               # Especificação visual (frontend)
├── us-XX-entrega.md           # Entrega por User Story
├── us-XX-qa.md                # QA por User Story
├── log-orchestrator-*.md      # Logs de execução dos orchestrators
```

---

## Retomada de sessão

Todos os comandos suportam retomada. Se a sessão for interrompida, execute o mesmo comando novamente — o orchestrator lê o log de execução e retoma de onde parou, sem reexecutar etapas já concluídas.

---

## Skills disponíveis

| Skill | Comando | Descrição |
|-------|---------|-----------|
| context | `/context` | Entrevista guiada para gerar o briefing |
| bug-report | `/bug-report` | Coleta bugs via questionário guiado |
| improve | `/improve` | Coleta melhorias incrementais |
| planning | — | Templates de backlog (uso interno do Planner) |
| ux-quality | — | Critérios de qualidade UX (uso interno do Time UX) |
| development | — | Padrões de implementação (uso interno do Developer) |
| standards | — | Regras de qualidade de código (uso interno) |
| qa-docs | — | Padrões de QA e documentação (uso interno) |
| ui | — | Padrões de especificação visual (frontend, uso interno) |
| api-design | — | Padrões de design de API (backend, uso interno) |

---

## Licença

Uso interno.
