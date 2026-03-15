---
name: skill-context
description: Interactive skill that collects project context through guided single-choice questions and generates a context.md file ready for the UX and Dev teams. Invoked via the /context command.
user-invocable: true
---

# SKILL: Context Builder

## Propósito
Conduzir o humano por uma entrevista estruturada para capturar o contexto mínimo necessário antes de ativar o Time UX (`/ux`) ou o Time Dev (`/dev`). O resultado é um `context.md` bem formado, sem ambiguidades que bloqueiem os agentes.

---

## Regras de comportamento

- Faça **uma pergunta por vez** — nunca agrupe perguntas
- Prefira perguntas de **escolha única numerada** — o humano responde com o número
- Use perguntas abertas apenas quando opções pré-definidas não cobrirem bem o espaço de respostas
- Antes de iniciar, verifique se `{WORK_DIR}/context.md` já existe:
  - Se existir: pergunte se quer **atualizar** o existente ou **criar do zero**
  - Se não existir: inicie o fluxo normalmente
- Ao final de cada bloco temático, exiba um **resumo do que foi coletado** e pergunte se está correto antes de avançar
- Se o humano responder "não sei" ou "não tenho certeza", registre como `⚠️ A definir:` no arquivo gerado — não bloqueie o fluxo

---

## Fluxo de perguntas

### BLOCO 1 — Tipo de trabalho

**P1.1 — Tipo de projeto**
```
Sobre o que vamos trabalhar?

1. Nova feature em sistema existente
2. Novo produto / greenfield (sem codebase existente)
3. Melhoria ou otimização em feature existente
4. Correção de comportamento (não é bug técnico — é mudança intencional)
5. Refactoring ou dívida técnica (sem mudança de comportamento visível)
```

**P1.2 — Tem interface visual (UI)?**
```
Esta tarefa envolve telas, componentes ou fluxos visuais?

1. Sim — afeta diretamente o que o usuário vê e interage
2. Parcialmente — tem alguma mudança visual, mas o foco é lógica/dados
3. Não — é puramente back-end, infra, scripts ou lógica sem UI
```

**P1.3 — Escopo estimado** *(perguntar apenas se P1.1 = 1, 2 ou 3)*
```
Qual a complexidade percebida desta tarefa?

1. Pequena — um componente ou ajuste isolado (< 4h)
2. Média — alguns componentes ou um fluxo de tela (4–12h)
3. Grande — múltiplas telas ou áreas do sistema (> 12h)
4. Não sei ainda
```

---

### BLOCO 2 — Contexto do sistema

**P2.1 — O sistema existente** *(pular se P1.1 = 2)*
```
Qual área ou módulo do sistema será afetado?

[resposta aberta — ex: "módulo de relatórios", "tela de checkout", "autenticação"]
```

**P2.2 — Stack e tecnologias** *(pular se o CLAUDE.md do projeto já define isso)*
```
Qual a stack principal do projeto?

1. React + TypeScript
2. Vue + TypeScript
3. Angular + TypeScript
4. React Native (mobile)
5. Outro — vou descrever
```

**P2.3 — Há um CLAUDE.md do projeto disponível?**
```
O projeto de destino tem um CLAUDE.md com arquitetura e convenções?

1. Sim — vou informar o caminho
2. Não — vou descrever o essencial agora
3. Não sei
```
- Se **1**: solicite o caminho e leia o arquivo antes de continuar
- Se **2**: faça perguntas adicionais sobre estrutura de pastas e convenções
- Se **3**: registre como `⚠️ A definir:` e continue

---

### BLOCO 3 — O que precisa ser feito

**P3.1 — Descrição da tarefa**
```
Descreva em 1 a 3 frases o que precisa ser feito.
(O que deve existir depois que a tarefa estiver concluída, que não existe hoje?)

[resposta aberta]
```

**P3.2 — Por que agora?** *(contexto de negócio)*
```
Qual o motivador desta tarefa?

1. Pedido de usuário / feedback recebido
2. Requisito de negócio / novo cliente ou contrato
3. Decisão técnica interna (dívida, performance, segurança)
4. Regulatório ou compliance
5. Outro — vou descrever
```

**P3.3 — Há requisitos ou restrições conhecidos?**
```
Existe algo que NÃO pode mudar ou deve ser respeitado?

1. Sim — vou descrever
2. Não — sem restrições conhecidas
3. Não sei ainda
```
- Se **1**: solicite a descrição em texto livre

---

### BLOCO 4 — Usuário e impacto *(pular se P1.2 = 3)*

**P4.1 — Quem usa esta parte do sistema?**
```
Qual o perfil principal de quem será impactado?

1. Usuário final (cliente, consumidor)
2. Operador interno (analista, atendente, backoffice)
3. Administrador do sistema
4. Desenvolvedor / integrador (API, SDK)
5. Múltiplos perfis — vou descrever
```

**P4.2 — Qual a dor ou necessidade do usuário?**
```
Complete a frase: "Hoje o usuário precisa ___, mas ___."

[resposta aberta — ex: "aprovar relatórios, mas precisa abrir 3 sistemas diferentes"]
```

---

### BLOCO 5 — Confirmação e geração

Ao final, exiba o resumo completo antes de gerar o arquivo:

```
## Resumo do contexto coletado

**Tipo:** [nova feature / melhoria / greenfield / etc.]
**Tem UI:** [sim / parcialmente / não]
**Área afetada:** [módulo ou tela]
**Stack:** [tecnologias]
**O que fazer:** [descrição]
**Motivador:** [por que agora]
**Restrições:** [lista ou "nenhuma"]
**Usuário afetado:** [perfil]
**Dor do usuário:** [frase completada]
**Dúvidas em aberto:** [lista de ⚠️ ou "nenhuma"]

Posso gerar o context.md com estas informações?

1. Sim — gerar agora
2. Quero corrigir algo — [indicar o que]
```

---

## Template do context.md gerado

```markdown
# Contexto

_Gerado em: YYYY-MM-DD_
_Via: skill-context (entrevista guiada)_

---

## Tipo de trabalho

- **Categoria:** [Nova feature | Melhoria | Greenfield | Refactoring | Correção de comportamento]
- **Envolve UI:** [Sim | Parcialmente | Não]
- **Complexidade estimada:** [P | M | G | A definir]

---

## O que precisa ser feito

[Descrição em 1–3 frases do que deve existir ao final]

---

## Motivador

[Por que esta tarefa existe agora — contexto de negócio ou técnico]

---

## Sistema existente

- **Área afetada:** [módulo, tela ou componente — ou "greenfield"]
- **Stack:** [tecnologias principais]
- **CLAUDE.md do projeto:** [caminho | não disponível | ⚠️ A definir]

---

## Usuário afetado

- **Perfil:** [descrição do perfil principal]
- **Dor atual:** "Hoje o usuário precisa ___, mas ___."

---

## Restrições

[Lista de restrições conhecidas, ou "Nenhuma restrição conhecida"]

---

## Dúvidas em aberto

[Lista de ⚠️ A definir: itens não respondidos, ou "Nenhuma"]

---

## Próximos passos sugeridos

[Gerado automaticamente com base nas respostas:]

- Se tem UI → executar `/ux {WORK_DIR}` para definir personas e jornadas
- Se não tem UI → executar `/dev {WORK_DIR}` diretamente (ativar Developer Agent)
- Se tem dúvidas em aberto → resolver antes de ativar qualquer agente
```

---

## Regras de geração do arquivo

- Salvar em `{WORK_DIR}/context.md`
- Se o arquivo já existia e o humano escolheu **atualizar**: manter o histórico ao final com bloco `## Histórico de atualizações`
- Nunca sobrescrever sem confirmar
- Após gerar, informar o próximo comando a executar com base nas respostas coletadas
