---
name: skill-standards
description: Shared quality standards used by both Developer and QA agents. Defines mandatory tests per Story type, universal edge-case checklist, and test quality criteria. Single source of truth to avoid divergence between implementation and verification.
user-invocable: false
---

# SKILL: Standards (compartilhada)

## Propósito
Esta skill é a **fonte única** dos padrões de qualidade que o Developer deve seguir ao implementar e que o QA deve usar ao verificar. Ambos os agentes recebem este arquivo no contexto — qualquer mudança aqui se propaga automaticamente para os dois lados.

---

## Testes obrigatórios por tipo de Story

| Tipo de Story | O que o Developer deve entregar | O que o QA deve verificar |
|---|---|---|
| **Nova funcionalidade** | Unitário para utils/hooks + Componente para cada componente novo + Integração para fluxos com API | Todos os critérios + bordas. Documentação obrigatória para novos artefatos |
| **Melhoria** | Testes dos comportamentos modificados (unitário ou componente) + atualização dos testes existentes afetados | Critérios modificados + bordas do escopo. Regressão obrigatória. Doc se novos artefatos |
| **Refactoring** | Testes dos comportamentos preservados devem continuar passando; não adicione nova lógica sem teste | Comportamentos preservados. Regressão obrigatória. Doc somente se interface mudou |
| **Ajuste visual** | Snapshot ou teste de renderização confirmando que o componente ainda renderiza corretamente | Comportamento visual + acessibilidade. Regressão visual obrigatória |
| **Bugfix** | Teste de regressão obrigatório: reproduz o bug antes da correção e confirma que passa após | Apenas o caso reportado + regressão imediata |

---

## Critérios de qualidade de teste

Estes critérios se aplicam tanto à escrita (Developer) quanto à validação (QA).

| Critério | Aprovado | Reprovado (BUG de qualidade) |
|---|---|---|
| Cobertura de critérios | Todo critério de aceite tem ao menos 1 teste | Critério sem teste — BUG Alta |
| Cobertura de bordas | Bordas obrigatórias do tipo de Story têm teste | Borda sem teste — BUG Média |
| Teste o comportamento | `expect(screen.getByText(...))` | `expect(component.state...)` — BUG Média |
| Integração cobre erro de API | Há mock de 4xx/5xx + verificação de feedback visual | Só testa sucesso — BUG Média |
| Regressão em bugfix | Reproduz o bug e confirma correção | Ausente — BUG Alta |
| Testes passam | Todos os testes passam na execução | Falha — BUG Alta |

**Regras adicionais:**
- Teste o **comportamento**, não a implementação: prefira `expect(screen.getByText("Salvo!")).toBeVisible()` a `expect(component.state.saved).toBe(true)`
- Cada critério de aceite da Story deve ter ao menos um teste mapeado
- Casos de borda tratados no código de produção devem ter teste correspondente
- Testes de integração com API devem cobrir resposta de sucesso **e** resposta de erro
- Evite testes que sempre passam (`expect(true).toBe(true)`) — o QA vai reprovar

---

## Casos de borda — checklist universal

Para toda Story, verificar obrigatoriamente:

**Dados de entrada:**
- [ ] Input nulo ou undefined
- [ ] String vazia `""`
- [ ] Número zero ou negativo
- [ ] Lista vazia `[]`
- [ ] Valores no limite (ex: máximo de caracteres, valor mínimo/máximo de um range)
- [ ] Caracteres especiais e unicode em campos de texto

**Estado do sistema:**
- [ ] Comportamento quando o recurso buscado não existe (404 vs erro 500)
- [ ] Comportamento com usuário sem permissão
- [ ] Comportamento com sessão expirada

**Chamadas de API (front consome como caixa-preta):**
- [ ] Comportamento quando a API retorna erro (4xx / 5xx) — mensagem de erro exibida ao usuário?
- [ ] Comportamento com timeout de rede — loading state interrompido corretamente?
- [ ] Comportamento com payload malformado ou campo ausente — crash ou fallback gracioso?

**Interação e acessibilidade:**
- [ ] Elementos interativos funcionam com teclado (Tab, Enter, Esc)
- [ ] Imagens têm alt text; formulários têm labels associados
- [ ] Foco visual está visível em elementos focáveis

> **Developer:** trate os cenários aplicáveis à sua Story e documente no arquivo de entrega.
> **QA:** verifique se os cenários aplicáveis foram tratados e têm teste correspondente.

---

## Classificação de severidade de bugs

| Severidade | Critério | Impacto na Story |
|---|---|---|
| **Crítica** | Sistema trava, dados corrompidos, falha de segurança | Reprovar + bloquear outros testes |
| **Alta** | Critério de aceite não atendido, fluxo principal quebrado | Reprovar a Story |
| **Média** | Caso de borda não tratado, comportamento inconsistente | Aprovar com ressalva obrigatória |
| **Baixa** | Problema cosmético, mensagem de erro pouco clara | Registrar, não bloqueia aprovação |
