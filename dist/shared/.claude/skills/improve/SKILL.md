---
name: skill-improve
description: Interactive skill that collects small improvement requests through a quick 3-question flow and generates improve##.md files in the WORK_DIR. Invoked via the /improve command.
user-invocable: true
---

# SKILL: Improve

## Propósito
Capturar pequenas melhorias de forma rápida e objetiva. Suporta múltiplas melhorias por sessão. Cada melhoria é salva em um arquivo individual `improve##.md` no `{WORK_DIR}`, pronto para o time de dev implementar via `/dev`.

---

## Regras de comportamento

- **Sempre pergunte ao humano qual o `{WORK_DIR}` desejado antes de qualquer outra ação** — nunca assuma, deduza ou escolha um diretório por conta própria. Essa deve ser a **primeira pergunta** do fluxo.
- **Após definir o `{WORK_DIR}`, pergunte se deseja criar uma branch para o desenvolvimento:**
  ```
  Deseja criar uma branch para este desenvolvimento?

  1. Sim — criar branch
  2. Não — continuar na branch atual
  ```
  - Se **Sim**: pergunte o nome da branch (sugira um nome baseado no contexto, ex: `improve/descricao-curta`) e crie a branch com `git checkout -b {nome}`
  - Se **Não**: siga o fluxo normalmente na branch atual
- Faça **uma pergunta por vez** — nunca agrupe perguntas
- Antes de iniciar, verifique se já existem arquivos `improve*.md` no `{WORK_DIR}`:
  - Se existirem: identifique o maior número existente (ex: `improve03.md` → próximo será `improve04.md`) e pergunte se quer **adicionar novas melhorias** a partir do próximo número ou **recriar do zero** (apagando os existentes com confirmação)
  - Se não existirem: inicie o fluxo normalmente a partir de `improve01.md`
- Ao final de cada melhoria, exiba o **resumo** e pergunte se está correto antes de avançar
- Se o humano responder "não sei", registre como `⚠️ A confirmar:` — não bloqueie o fluxo
- Após cada melhoria confirmada, pergunte se há mais melhorias a registrar

---

## Fluxo de perguntas — por melhoria

**P1 — O que melhorar?**
```
Descreva a melhoria em uma frase curta.
(Ex: "Adicionar tooltip no botão de exportar")

[resposta aberta]
```

**P2 — Onde?**
```
Em qual tela, componente ou área do sistema?

[resposta aberta]
```

**P3 — Como deveria ficar?**
```
Descreva o comportamento desejado após a melhoria.
(Ex: "Ao passar o mouse no botão, exibir 'Exportar relatório em PDF'")

[resposta aberta]
```

### Confirmação

Ao final de cada melhoria, exiba o resumo antes de registrar:

```
## Improve #N — Resumo

**O quê:** [descrição]
**Onde:** [tela/componente]
**Como deveria ficar:** [comportamento desejado]

Esta melhoria está correta?

1. Sim — registrar e continuar
2. Quero corrigir algo — [indicar o que]
```

---

### Mais melhorias?

Após confirmar cada melhoria:

```
Há mais melhorias a registrar?

1. Sim — próxima melhoria
2. Não — salvar os arquivos agora
```

---

## Template do improve##.md gerado

Cada melhoria é salva em um arquivo individual no `{WORK_DIR}` com o nome `improve##.md` (ex: `improve01.md`, `improve02.md`, etc.).

```markdown
# Improve #NN — [Descrição curta]

_Gerado em: YYYY-MM-DD_
_Via: skill-improve (questionário guiado)_

---

**Onde:** [tela ou componente]

## Comportamento desejado
[descrição de como deveria ficar após a melhoria]

## Dúvidas em aberto
[Lista de ⚠️ A confirmar: itens não respondidos, ou "Nenhuma"]
```

---

## Regras de geração dos arquivos

- Salvar cada melhoria em `{WORK_DIR}/improve##.md` (numeração com dois dígitos: `improve01.md`, `improve02.md`, etc.)
- A numeração é sequencial e contínua — se já existem `improve01.md` e `improve02.md`, o próximo será `improve03.md`
- Nunca sobrescrever arquivos existentes sem confirmar com o humano
- Após salvar todas as melhorias, exibir um resumo consolidado:
  - Total de melhorias registradas na sessão
  - Lista dos arquivos criados
- Após o resumo, exibir o próximo comando a executar: `/dev {WORK_DIR}`
