---
name: skill-ux
description: Quality standards, canonical templates, and evaluation criteria for UX proposals and the final ux.md deliverable. Defines complete persona format, journey criteria, UX principle testability, proposal size limits, and the handoff quality checklist. Loaded by orchestrator-ux when activating any UX agent.
user-invocable: false
---

# SKILL: UX

## Propósito
Esta skill define os padrões, templates canônicos e critérios de qualidade para o Time de UX produzir propostas e o `ux.md` final com consistência e rastreabilidade.

---

## Template canônico — Persona completa

```markdown
### [Nome fictício]

**Perfil:** [quem é — cargo, contexto de vida, familiaridade com tecnologia]
**Objetivo principal:** [o que ela precisa conseguir com este produto]
**Frustrações atuais:** [o que a impede hoje — máximo 3 itens]
**Comportamentos relevantes:** [como ela age hoje para resolver o problema sem o produto]
**Critério de sucesso:** [como ela sabe que o produto funcionou — verificável, não genérico]
**Estado emocional de chegada:** [como ela chega ao produto — apressada, desconfiante, curiosa]
```

**Uma persona está completa quando:**
- [ ] Tem nome fictício (facilita referência nos critérios de aceite do Planner)
- [ ] Objetivo é uma ação, não um sentimento ("conseguir aprovar relatório" vs "se sentir segura")
- [ ] Frustrações são concretas — não "processo complicado" mas "precisa abrir 3 sistemas diferentes para fechar um único pedido"
- [ ] Critério de sucesso é verificável por um observador externo

---

## Template canônico — Jornada completa

```markdown
| Etapa | Ação do usuário | Resposta do sistema | Emoção | Ponto de atrito |
|-------|----------------|---------------------|--------|-----------------|
| [nome] | [o que faz] | [o que o produto faz] | [emoção específica] | [o que pode dar errado] |
```

**Uma jornada está completa quando:**
- [ ] Tem início claro (de onde o usuário parte — antes do produto)
- [ ] Tem fim claro (como o usuário sabe que terminou — inclusive estados de erro)
- [ ] Inclui pelo menos 1 caminho de erro com a resposta do sistema
- [ ] Emoções são específicas: não "frustrado" mas "sente que está perdendo tempo" ou "com medo de clicar errado e perder o rascunho"
- [ ] Pontos de atrito são identificados — não apenas o happy path

---

## O que torna um Princípio de UX testável

Um princípio de UX é testável quando tem:

1. **Nome evocativo** — 2 a 4 palavras que resumem a intenção ("Ação visível antes de comprometer", "O sistema confirma, não o usuário")
2. **Descrição** — o que significa na prática para este produto específico
3. **Exemplo de aplicação** — comportamento concreto que segue este princípio
4. **Exemplo de violação** — comportamento concreto que quebraria este princípio

❌ Princípio não testável: "Ser simples e intuitivo"
✅ Princípio testável: **"Confirmar antes de destruir"** — qualquer ação irreversível exige confirmação explícita antes de executar. _Aplicação:_ deletar um relatório abre modal com contagem regressiva de 5s. _Violação:_ botão "excluir" executa imediatamente sem confirmação.

---

## Graus de inovação — critérios

| Grau | Símbolo | Critério |
|------|---------|----------|
| Radical | 🔴 | Questiona a premissa central do produto; exige validação com usuário antes de construir |
| Arrojada | 🟠 | Inverte uma convenção estabelecida; implementável mas com risco de adoção |
| Progressiva | 🟡 | Melhoria significativa sobre o padrão de mercado; risco de adoção baixo |

Cada `ux-proposals.md` deve ter **ao menos uma direção 🔴 ou 🟠**. Três direções 🟡 indicam que a síntese suavizou demais.

---

## Limite de tamanho por proposta

Cada agente folha deve produzir uma proposta de **400 a 800 palavras**.

- Abaixo de 400 palavras: proposta superficial, provavelmente com seções incompletas
- Acima de 800 palavras: especificação excessiva para esta fase; o agente provavelmente está descendo para UI em vez de permanecer em experiência

O Orchestrator-UX usa 200 palavras como mínimo de validação técnica (truncagem). O intervalo 400–800 é o alvo para síntese de qualidade.

---

## Checklist de qualidade do ux.md

Usado pelo Orchestrator-UX antes do handoff para o Time Dev:

### Personas
- [ ] Pelo menos 1 persona com todos os 6 campos do template canônico preenchidos
- [ ] Critério de sucesso é verificável (não genérico)
- [ ] As personas são distintas entre si — não variações da mesma pessoa

### Jornadas
- [ ] Pelo menos 1 jornada completa por persona principal
- [ ] Inclui pelo menos 1 caminho de erro com resposta do sistema
- [ ] Etapas são específicas o suficiente para gerar critérios de aceite Given/When/Then

### Princípios de UX
- [ ] Mínimo 3 princípios
- [ ] Cada princípio tem nome, descrição, exemplo de aplicação e exemplo de violação
- [ ] Os princípios são verificáveis (não aspiracionais genéricos)

### Fluxos de interação
- [ ] Pelo menos 1 fluxo com happy path e pelo menos 1 caminho de erro
- [ ] Estados intermediários identificados (loading, vazio, erro, sucesso)

### Momentos de impacto
- [ ] Pelo menos 1 momento com localização específica na jornada
- [ ] O momento descreve o que diferencia este produto do padrão de mercado

### Geral
- [ ] Nenhum `⚠️` de dúvida em aberto sem resposta
- [ ] Todas as personas referenciadas na jornada estão definidas na seção Personas
- [ ] Nenhuma referência a componentes de UI específicos (botões, modais, grids) — isso é escopo do UI Agent

---

## Checklist de qualidade por proposta individual

Usado pelo Orchestrator-UX na validação de cada arquivo `ux-[agente].md`:

| Agente | Seções obrigatórias |
|--------|---------------------|
| UX-DESTRUCTOR | "Premissas destruídas" (tabela) · "A inversão central" · "Como o produto funcionaria" · "Por que parece errado (e por que pode ser certo)" · "Persona que se beneficia desta inversão" · "Jornada invertida" · "Princípios desta proposta" |
| UX-ALIEN | "O problema humano puro" · "Metáfora do mundo real adotada" · "Como a experiência funciona" · "Convenções que esta proposta elimina" · "Por que cada remoção faz sentido" · "Persona" · "Jornada" · "Princípios desta proposta" |
| UX-TEMPO | "Usuário T0 / T30 / T2A" · "Armadilhas temporais" (tabela) · "Princípio central desta proposta" · "Como a experiência evolui" (fases T0, T30 e T2A) · "Jornada temporal" · "Princípios desta proposta" |
| UX-CONTRARIAN | "Premissas contestadas" (tabela) · "A lógica contrária central" · "Como o produto funcionaria" · "O que esta proposta sacrifica conscientemente" · "O que ganha em troca" · "Persona que se beneficia desta inversão" · "Jornada contrária" · "Princípios desta proposta" |
| UX-SISTEMA | "Atores do ecossistema" (tabela) · "Efeitos emergentes em escala" (tabela) · "A oportunidade sistêmica" · "Loops de feedback intencionais" · "Como o produto escala" · "Persona sistêmica" · "Jornada coletiva" · "Princípios desta proposta" |

---

## Customização via CLAUDE.md

Ao ler o `CLAUDE.md` do projeto, extraia:

| O que procurar | Para usar em |
|----------------|--------------|
| Personas ou perfis já definidos | Verificar se as personas do ux.md as estendem corretamente (modo INCREMENTAL) |
| Domínio de negócio e terminologia | Linguagem das jornadas e princípios — use os termos do negócio |
| Restrições de acessibilidade | Adicionar como restrição em "Restrições e dúvidas em aberto" do ux.md |
| Sistema de design declarado | Informar o UI Agent (não alterar o ux.md — UX não especifica componentes) |
