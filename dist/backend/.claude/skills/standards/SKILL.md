---
name: skill-standards
description: Shared quality standards used by both Developer and QA agents (backend). Defines mandatory tests per Story type, universal edge-case checklist, and test quality criteria. Single source of truth to avoid divergence between implementation and verification.
user-invocable: false
---

# SKILL: Standards — Backend (compartilhada)

## Propósito
Esta skill é a **fonte única** dos padrões de qualidade que o Developer deve seguir ao implementar e que o QA deve usar ao verificar. Ambos os agentes recebem este arquivo no contexto — qualquer mudança aqui se propaga automaticamente para os dois lados.

---

## Testes obrigatórios por tipo de Story

| Tipo de Story | O que o Developer deve entregar | O que o QA deve verificar |
|---|---|---|
| **Nova funcionalidade** | Unitário para services/utils + Integração para rotas (request → response) + Teste de validação de input | Todos os critérios + bordas. Documentação obrigatória para novos artefatos |
| **Melhoria** | Testes dos comportamentos modificados (unitário ou integração) + atualização dos testes existentes afetados | Critérios modificados + bordas do escopo. Regressão obrigatória. Doc se novos artefatos |
| **Refactoring** | Testes dos comportamentos preservados devem continuar passando; não adicione nova lógica sem teste | Comportamentos preservados. Regressão obrigatória. Doc somente se interface mudou |
| **Bugfix** | Teste de regressão obrigatório: reproduz o bug antes da correção e confirma que passa após | Apenas o caso reportado + regressão imediata |

---

## Critérios de qualidade de teste

Estes critérios se aplicam tanto à escrita (Developer) quanto à validação (QA).

| Critério | Aprovado | Reprovado (BUG de qualidade) |
|---|---|---|
| Cobertura de critérios | Todo critério de aceite tem ao menos 1 teste | Critério sem teste — BUG Alta |
| Cobertura de bordas | Bordas obrigatórias do tipo de Story têm teste | Borda sem teste — BUG Média |
| Teste o comportamento | `expect(response.status).toBe(201)` | `expect(service.internalState)` — BUG Média |
| Integração cobre erro | Há teste de 4xx/5xx + verificação de corpo de resposta | Só testa sucesso — BUG Média |
| Regressão em bugfix | Reproduz o bug e confirma correção | Ausente — BUG Alta |
| Testes passam | Todos os testes passam na execução | Falha — BUG Alta |
| Isolamento de testes | Cada teste limpa seu estado (truncate, rollback, mocks resetados) | Testes interdependentes — BUG Média |

**Regras adicionais:**
- Teste o **comportamento**, não a implementação: prefira `expect(response.body.data.name).toBe("João")` a `expect(repository.findById).toHaveBeenCalled()`
- Cada critério de aceite da Story deve ter ao menos um teste mapeado
- Casos de borda tratados no código de produção devem ter teste correspondente
- Testes de integração devem cobrir resposta de sucesso **e** resposta de erro
- Testes devem ser isolados — não depender de ordem de execução ou estado de outro teste
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
- [ ] Payload excedendo tamanho máximo permitido

**Segurança e autenticação:**
- [ ] Request sem token de autenticação → 401
- [ ] Request com token expirado → 401
- [ ] Request com token válido mas sem permissão → 403
- [ ] Tentativa de SQL injection em campos de texto
- [ ] Tentativa de acessar recurso de outro usuário → 403 ou 404
- [ ] Headers obrigatórios ausentes

**Estado do sistema:**
- [ ] Recurso não encontrado → 404 (não 500)
- [ ] Recurso duplicado (unique constraint) → 409
- [ ] Recurso em estado inválido para a operação (ex: tentar publicar o que já está publicado) → 422
- [ ] Concorrência: duas requests simultâneas ao mesmo recurso

**Integração e infraestrutura:**
- [ ] Banco de dados indisponível → erro tratado, não crash
- [ ] Serviço externo retorna erro ou timeout → fallback ou erro claro
- [ ] Resposta de serviço externo com formato inesperado → erro tratado
- [ ] Migration rollback funciona corretamente

> **Developer:** trate os cenários aplicáveis à sua Story e documente no arquivo de entrega.
> **QA:** verifique se os cenários aplicáveis foram tratados e têm teste correspondente.

---

## Classificação de severidade de bugs

| Severidade | Critério | Impacto na Story |
|---|---|---|
| **Crítica** | Sistema trava, dados corrompidos, falha de segurança, SQL injection possível | Reprovar + bloquear outros testes |
| **Alta** | Critério de aceite não atendido, fluxo principal quebrado, endpoint retorna 500 em caso esperado | Reprovar a Story |
| **Média** | Caso de borda não tratado, mensagem de erro pouco informativa, campo de resposta incorreto | Aprovar com ressalva obrigatória |
| **Baixa** | Inconsistência de nomenclatura, log desnecessário, documentação incompleta | Registrar, não bloqueia aprovação |
