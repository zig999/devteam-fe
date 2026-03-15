---
name: skill-ui
description: Templates, naming conventions, and quality rules for UI specifications. Covers screen maps, component tables, state tables, interaction descriptions, and design system tokens. Loaded by orchestrator-dev when activating the UI Agent.
user-invocable: false
---

# SKILL: UI Specification

## Propósito
Esta skill define os templates, convenções de nome e checklist de qualidade para o UI Agent produzir especificações visuais consistentes, completas e prontas para o Developer Agent.

---

## Convenção de nome dos arquivos

```
{WORK_DIR}/ui-epic-XX.md
```

Onde `XX` é o número do Epic em minúsculas com zero à esquerda:
- EPIC-01 → `ui-epic-01.md`
- EPIC-02 → `ui-epic-02.md`

> Use sempre o identificador numérico do Epic, não o nome descritivo, para garantir referência estável.

---

## Customização via CLAUDE.md

Antes de produzir qualquer especificação, extraia do `{WORK_DIR}/CLAUDE.md`:

| O que procurar | Para usar em |
|---|---|
| Biblioteca de componentes (shadcn, MUI, Tremor, Ant Design...) | Referenciar componentes pelo nome da biblioteca |
| Sistema de design ou tokens já definidos | Paleta, tipografia, espaçamento |
| Framework de frontend (React, Vue, Next.js...) | Convenções de estrutura de tela |
| Terminologia de domínio | Textos e labels sugeridos — nunca usar placeholder genérico |

---

## Template canônico de tela

```markdown
### Tela: [Nome]

**Story(ies):** US-XX
**Persona:** [Nome da persona conforme {WORK_DIR}/ux.md]
**Objetivo do usuário nesta tela:** [O que ele precisa conseguir aqui — em linguagem do domínio]

---

#### Estrutura de layout

[Descreva as regiões em ASCII ou texto estruturado]

+----------------------------------+
| HEADER: [logo] [navegação] [user]|
+----------------------------------+
| SIDEBAR        | CONTEÚDO        |
| - item 1       | [título]        |
| - item 2       | [área principal]|
+----------------------------------+
| FOOTER: [info secundária]        |
+----------------------------------+

---

#### Componentes

| Componente | Tipo | Conteúdo | Estado padrão |
|------------|------|----------|---------------|
| [Nome] | Botão / Input / Card / Tabela / Modal / ... | [o que exibe] | Ativo / Desabilitado / Loading |

> Se o projeto usa biblioteca de componentes, referencie o nome exato (ex: `<Button variant="primary">`, `<DataTable>`, `<Sheet>`).

---

#### Hierarquia visual

1. **Elemento de maior destaque:** [qual e por quê — geralmente a ação primária]
2. **Elemento secundário:** [qual]
3. **Elementos de suporte:** [quais]

---

#### Estados obrigatórios da tela

| Estado | Gatilho | O que muda visualmente |
|--------|---------|----------------------|
| Padrão | Tela carregada com dados | [descrição] |
| Loading | Requisição em andamento | [skeleton / spinner — especifique qual] |
| Vazio | Sem dados para exibir | [empty state — mensagem + ação sugerida] |
| Erro | Falha na requisição | [mensagem de erro + ação de recuperação] |
| Sucesso | Ação concluída | [feedback visual — toast / banner / redirect] |

> Tela sem estado de erro e estado vazio está **incompleta** — o Developer não pode iniciar sem eles.

---

#### Mensagens e textos

| Elemento | Texto sugerido |
|----------|---------------|
| Título da tela | "[texto — use terminologia do domínio]" |
| Ação primária | "[label do botão]" |
| Estado vazio | "[mensagem]" |
| Erro genérico | "[mensagem]" |
| Confirmação de sucesso | "[mensagem]" |

---

#### Comportamentos de interação

- [Ação do usuário → resposta do sistema: hover, click, drag, submit, etc.]
- [Comportamentos responsivos se relevante para o Epic]
- [Acessibilidade: foco de teclado esperado, aria-labels relevantes]

---

#### Referência aos princípios de UX

- [Princípio do {WORK_DIR}/ux.md]: como se aplica nesta tela
```

---

## Template de mapa de telas (obrigatório no início do documento)

```markdown
## Mapa de telas

| Tela | Story(ies) | Persona principal | Tipo |
|------|-----------|-------------------|------|
| [Nome] | US-XX, US-YY | [Persona] | Nova / Existente modificada |
```

---

## Template de diretrizes visuais (por Epic)

Se o projeto já tem `{WORK_DIR}/ui-system.md`, referencie os tokens existentes. Se não tem, defina o mínimo necessário:

```markdown
## Diretrizes visuais — EPIC-XX

**Paleta de cores:**
- Primária: [cor / variável CSS]
- Secundária: [cor]
- Feedback positivo: [cor]
- Feedback negativo: [cor]
- Texto principal: [cor]
- Background: [cor]

**Tipografia:**
- Título de tela: [fonte, tamanho, peso]
- Corpo de texto: [fonte, tamanho, peso]
- Label de campo: [fonte, tamanho, peso]

**Espaçamento:** [unidade base — ex: múltiplos de 8px]

**Componentes reutilizáveis definidos neste Epic:**
- [Nome]: [descrição e quando usar]
```

---

## Estrutura final do `ui-epic-XX.md`

```markdown
# UI Spec — EPIC-XX: [Nome do Epic]

_Criado em: YYYY-MM-DD_
_Referência UX: {WORK_DIR}/ux.md_
_Stories cobertas: US-XX, US-YY, US-ZZ_

---

## Mapa de telas
[tabela de telas x stories]

---

## Especificações de tela
[uma seção por tela com template canônico]

---

## Diretrizes visuais
[paleta, tipografia, espaçamento, componentes]

---

## Dúvidas em aberto
[itens marcados com ⚠️ que precisam de resposta antes do Developer]
```

---

## Checklist de qualidade antes de entregar

- [ ] Todas as telas do Epic estão mapeadas (nenhuma Story liberada sem sua tela especificada)
- [ ] Cada tela tem os 5 estados obrigatórios: Padrão, Loading, Vazio, Erro, Sucesso
- [ ] Textos e labels usam terminologia do domínio (sem placeholder genérico)
- [ ] Componentes da biblioteca do projeto foram referenciados pelo nome exato
- [ ] Hierarquia visual está definida para cada tela
- [ ] Comportamentos de teclado e aria-labels foram considerados
- [ ] Princípios de UX do `{WORK_DIR}/ux.md` estão referenciados em pelo menos uma tela
- [ ] Dúvidas em aberto estão marcadas com `⚠️`
- [ ] Nome do arquivo segue a convenção: `{WORK_DIR}/ui-epic-XX.md`

---

## Regras de qualidade

| Regra | Ação se violada |
|---|---|
| Tela sem estado de erro | Marcar como `⚠️` e não liberar para Developer |
| Tela sem estado vazio | Marcar como `⚠️` e não liberar para Developer |
| Texto com "Lorem ipsum" ou "Clique aqui" | Substituir com terminologia do domínio |
| Componente da biblioteca não referenciado pelo nome | Corrigir antes de entregar |
| Epic grande (5+ Stories) — entrega parcial | Especificar quais Stories podem avançar; nunca liberar Story com tela parcialmente especificada |
