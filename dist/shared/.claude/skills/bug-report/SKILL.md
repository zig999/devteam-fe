---
name: skill-bug-report
description: Interactive skill that collects one or more bug reports through a guided questionnaire with multiple-choice options and generates a context.md file with all bugs listed. Invoked via the /bug-report command.
user-invocable: true
---

# SKILL: Bug Report

## Propósito
Conduzir o humano por um questionário estruturado para capturar bugs de forma completa e padronizada. Suporta múltiplos bugs por sessão. Cada bug é salvo em um arquivo individual `bug##.md` no `{WORK_DIR}`, pronto para o time de dev corrigir via `/dev`.

---

## Regras de comportamento

- **Sempre pergunte ao humano qual o `{WORK_DIR}` desejado antes de qualquer outra ação** — nunca assuma, deduza ou escolha um diretório por conta própria. Essa deve ser a **primeira pergunta** do fluxo.
- **Após definir o `{WORK_DIR}`, pergunte se deseja criar uma branch para o desenvolvimento:**
  ```
  Deseja criar uma branch para este desenvolvimento?

  1. Sim — criar branch
  2. Não — continuar na branch atual
  ```
  - Se **Sim**: pergunte o nome da branch (sugira um nome baseado no contexto, ex: `bugfix/descricao-curta`) e crie a branch com `git checkout -b {nome}`
  - Se **Não**: siga o fluxo normalmente na branch atual
- Faça **uma pergunta por vez** — nunca agrupe perguntas
- Prefira perguntas de **escolha única numerada** — o humano responde com o número
- Use perguntas abertas apenas quando opções pré-definidas não cobrirem o espaço de respostas
- Antes de iniciar, verifique se já existem arquivos `bug*.md` no `{WORK_DIR}`:
  - Se existirem: identifique o maior número existente (ex: `bug03.md` → próximo será `bug04.md`) e pergunte se quer **adicionar novos bugs** a partir do próximo número ou **recriar do zero** (apagando os existentes com confirmação)
  - Se não existirem: inicie o fluxo normalmente a partir de `bug01.md`
- Ao final de cada bug, exiba o **resumo do bug coletado** e pergunte se está correto antes de avançar
- Se o humano responder "não sei" ou "não lembro", registre como `⚠️ A confirmar:` — não bloqueie o fluxo
- Após cada bug confirmado, pergunte se há mais bugs a registrar antes de gerar o arquivo

---

## Fluxo de perguntas — por bug

### BLOCO 1 — Identificação

**P1.1 — Título do bug**
```
Descreva o bug em uma frase curta.
(Ex: "Botão de salvar não responde no formulário de endereço")

[resposta aberta]
```

**P1.2 — Onde ocorre?**
```
Em qual área do sistema o bug aparece?

[resposta aberta — identifique a tela, componente ou fluxo específico]
```

---

### BLOCO 2 — Reprodução

**P2.1 — Como reproduzir?**
```
Descreva os passos para reproduzir o bug.
(Ex: "1. Acessar /checkout  2. Preencher endereço  3. Clicar em Salvar")

[resposta aberta — liste os passos numerados]
```

### BLOCO 3 — Comportamento

**P3.1 — O que era esperado?**
```
Descreva o comportamento correto esperado.
(Ex: "O formulário deve salvar e redirecionar para a tela de confirmação")

[resposta aberta]
```

**P3.2 — O que acontece de fato?**
```
Descreva o comportamento atual incorreto.
(Ex: "Nada acontece ao clicar — sem feedback, sem redirecionamento")

[resposta aberta]
```

**P3.3 — Mensagem de erro**
```
Apareceu alguma mensagem de erro? Se sim, cole aqui (tela ou console).
Se não apareceu, diga "não".

[resposta aberta]
```

### BLOCO 5 — Confirmação do bug

Ao final de cada bug, exiba o resumo antes de registrar:

```
## Bug #N — Resumo

**Título:** [título]
**Onde:** [tela/componente]
**Passos:** [lista numerada]
**Esperado:** [comportamento correto]
**Atual:** [comportamento incorreto]
**Erro:** [mensagem ou "nenhuma"]

Este bug está correto?

1. Sim — registrar e continuar
2. Quero corrigir algo — [indicar o que]
```

---

### BLOCO 6 — Mais bugs?

Após confirmar cada bug:

```
Há mais bugs a registrar?

1. Sim — próximo bug
2. Não — salvar os arquivos agora
```

---

## Template do bug##.md gerado

Cada bug é salvo em um arquivo individual no `{WORK_DIR}` com o nome `bug##.md` (ex: `bug01.md`, `bug02.md`, etc.).

```markdown
# Bug #NN — [Título]

_Gerado em: YYYY-MM-DD_
_Via: skill-bug-report (questionário guiado)_

---

**Onde:** [tela ou componente]

## Como reproduzir
1. [passo 1]
2. [passo 2]
3. [passo 3]

## Comportamento esperado
[descrição]

## Comportamento atual
[descrição]

## Mensagem de erro
[texto da mensagem, trecho de log, ou "Nenhuma"]

## Dúvidas em aberto
[Lista de ⚠️ A confirmar: itens não respondidos, ou "Nenhuma"]
```

---

## Regras de geração dos arquivos

- Salvar cada bug em `{WORK_DIR}/bug##.md` (numeração com dois dígitos: `bug01.md`, `bug02.md`, etc.)
- A numeração é sequencial e contínua — se já existem `bug01.md` e `bug02.md`, o próximo será `bug03.md`
- Nunca sobrescrever arquivos existentes sem confirmar com o humano
- Após salvar todos os bugs, exibir um resumo consolidado:
  - Total de bugs registrados na sessão
  - Lista dos arquivos criados
- Após o resumo, exibir o próximo comando a executar: `/dev {WORK_DIR}`
