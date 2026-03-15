# CLAUDE.md

## 🎯 Propósito do Projeto

Este projeto é um **laboratório de desenvolvimento de agentes Claude Code**.  
Seu único objetivo é projetar, construir e refinar a estrutura de agentes e skills que serão **reutilizados em outros projetos**. Nenhuma lógica de negócio de produto final deve residir aqui.

> ⚠️ **Importante:** Este repositório não é um produto. É a infraestrutura de agentes que alimenta outros projetos.

---

## 🤖 Papel dos Agentes

Os agentes desenvolvidos aqui devem ser:

- **Autônomos** — capazes de executar tarefas completas com mínima intervenção humana
- **Modulares** — cada skill deve ser independente e reutilizável
- **Portáteis** — facilmente importáveis em outros projetos Claude Code
- **Testáveis** — todo comportamento deve ser validável de forma isolada

---

## 🛠️ Configurações do Claude Code

### Modelo
Sempre utilizar `claude-sonnet-4` salvo instrução explícita em contrário.

## Regras de busca
  - Para qualquer exploração de código, usar primeiro `mcp__cocoindex-code__search` antes de Glob/Grep

### Comportamento padrão
- Responder sempre em **português (BR)** salvo quando o contexto exigir outro idioma
- Preferir respostas objetivas e diretas
- Não repetir o enunciado da tarefa antes de executá-la
- Ao criar arquivos, sempre verificar se já existem antes de sobrescrever

### Permissões
```yaml
# Permitido sem confirmação
allow:
  - read any file
  - write inside ./agents, ./skills, ./prompts, ./tools, ./tests
  - run test scripts

# Requer confirmação explícita
confirm:
  - delete files
  - install new dependencies
  - modify CLAUDE.md
```

### Uso de ferramentas
- Priorizar ferramentas nativas do Claude Code antes de criar scripts customizados
- Ao criar uma nova tool, documentá-la imediatamente em `docs/tools.md`
- Ferramentas devem ter tratamento de erro explícito

---

## 📦 Desenvolvimento de Skills

Cada skill deve seguir o padrão:

### Checklist antes de publicar uma skill
- [ ] Documentação em `README.md` está completa
- [ ] Ao menos 3 casos de teste cobertos
- [ ] Comportamento em edge cases validado
- [ ] Dependências de outras skills explicitamente declaradas

---

## 🔄 Fluxo de Trabalho

1. **Desenvolver** — criar/iterar agente ou skill neste repositório
2. **Testar** — validar comportamento isoladamente em `tests/`
3. **Documentar** — atualizar `docs/` antes de considerar pronto
4. **Exportar** — disponibilizar para consumo nos projetos destino

---

## ❌ O que NÃO fazer aqui

- Não implementar lógica de negócio de projetos externos
- Não conectar a APIs de produção de outros sistemas
- Não armazenar credenciais ou dados sensíveis
- Não criar dependências circulares entre skills

## Ambiente
- todos os projetos desenvolvidos são executados em sistema operacional Windows