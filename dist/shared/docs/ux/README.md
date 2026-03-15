# Time UX — Documentação

O Time UX é responsável por produzir o `ux.md` — o entregável de experiência do usuário que alimenta o Time Dev. Ele opera de forma **completamente isolada** do Time Dev: não lê backlog, stories nem arquivos de entrega.

---

## Índice

- [Como funciona](#como-funciona)
- [Estrutura de arquivos](#estrutura-de-arquivos)
- [Modos de operação](#modos-de-operação)
- [Os agentes](#os-agentes)
- [Fluxo detalhado](#fluxo-detalhado)
- [Entradas necessárias](#entradas-necessárias)
- [Saídas produzidas](#saídas-produzidas)
- [Como iniciar](#como-iniciar)
- [Retomada de sessão](#retomada-de-sessão)

---

## Como funciona

O Time UX opera em duas etapas principais:

**Etapa 1 — Propostas paralelas isoladas**
Cinco agentes com lentes radicalmente diferentes analisam o mesmo briefing de forma sequencial e isolada. Cada um produz uma proposta sem conhecer o que os outros estão gerando. O isolamento é garantido por restrição de input — não por instrução ao agente.

**Etapa 2 — Síntese por colisão**
O UX-SYNTHESIS-X lê todas as cinco propostas e produz 3 direções de produto. Essas direções não são médias das propostas — são ideias que emergem da tensão entre elas. O humano escolhe uma direção, e o SYNTHESIS-X a expande no `ux.md` final.

```
/ux docs/features/minha-feature
         │
         ▼
  orchestrator-ux
         │
    ┌────┴────┐
    │  sequencial  │
    │  + isolado   │
    └────┬────┘
         │
    ┌────▼────────────────────────────────┐
    │  1. UX-DESTRUCTOR                   │
    │  2. UX-ALIEN                        │
    │  3. UX-TEMPO                        │
    │  4. UX-CONTRARIAN                   │
    │  5. UX-SISTEMA                      │
    └────┬────────────────────────────────┘
         │  (5 propostas validadas)
         ▼
    UX-SYNTHESIS-X  ──► ux-proposals.md (3 direções)
         │
         │  ◄── humano escolhe uma direção
         ▼
      ux.md  ──► Time Dev
```

---

## Estrutura de arquivos

### Instalação no projeto

```
.claude/
├── agents/
│   └── ux/
│       ├── orchestrator-ux.md     # Coordenador do time
│       ├── ux-destructor.md       # Agente: inversão de premissas
│       ├── ux-alien.md            # Agente: zero convenções de UI
│       ├── ux-tempo.md            # Agente: três horizontes temporais
│       ├── ux-contrarian.md       # Agente: lógica contrária
│       ├── ux-sistema.md          # Agente: ecossistema e escala
│       └── ux-synthesis-x.md     # Agente: síntese por colisão
├── commands/
│   └── ux.md                      # Slash command /ux
└── skills/
    └── skill-ux.md                # Templates e checklists canônicos
```

### Gerado por feature (em `{WORK_DIR}`)

```
docs/features/minha-feature/
├── CLAUDE.md                      # Contexto de domínio do produto (obrigatório)
├── context.md                    # Briefing da feature (obrigatório)
├── log-orchestrator-ux.md         # Log de execução (gerado automaticamente)
├── ux-destructor.md               # Proposta: inversão de premissas (intermediário)
├── ux-alien.md                    # Proposta: zero convenções (intermediário)
├── ux-tempo.md                    # Proposta: horizontes temporais (intermediário)
├── ux-contrarian.md               # Proposta: lógica contrária (intermediário)
├── ux-sistema.md                  # Proposta: ecossistema (intermediário)
├── ux-proposals.md                # 3 direções para escolha humana (permanente)
├── ux-debate.md                   # Registro de decisões de design (permanente)
└── ux.md                          # Entregável final para o Time Dev (permanente)
```

---

## Modos de operação

### Modo COMPLETO
Usado quando a feature é nova e não existe `ux.md` anterior.

- Os 5 agentes propõem livremente sem referência a design existente
- UX-SYNTHESIS-X gera 3 direções do zero
- Output: `ux.md` criado do zero

### Modo INCREMENTAL
Usado quando a feature é uma melhoria em algo existente (já há `ux.md`).

- O `context.md` deve deixar explícito o escopo da melhoria — o orchestrator valida isso antes de iniciar
- Os 5 agentes continuam isolados (não recebem o `ux.md` existente)
- UX-SYNTHESIS-X recebe o `ux.md` existente e opera em modo extensão
- Personas e princípios aprovados não podem ser contraditos
- Output: `ux.md` atualizado (não um arquivo novo)

---

## Os agentes

### Orchestrator-UX
**Arquivo:** `.claude/agents/ux/orchestrator-ux.md`
**Ativado por:** Slash command `/ux {WORK_DIR}`
**Papel:** Coordena o processo completo. Ativa os agentes em sequência, valida cada proposta antes de avançar, gerencia checkpoints, apresenta as 3 direções ao humano e produz o `ux-debate.md` ao final.

---

### UX-DESTRUCTOR
**Arquivo:** `.claude/agents/ux/ux-destructor.md`
**Lente:** Inversão de premissas
**Pergunta central:** "O produto deveria existir da forma que foi concebido?"

Identifica todas as premissas implícitas no briefing e propõe suas inversões. Seleciona as 2-3 inversões mais férteis e constrói uma proposta de experiência completa a partir delas. Uma proposta que não assusta levemente o leitor não é destrutiva o suficiente.

**Seções obrigatórias (7):** Premissas destruídas · A inversão central · Como o produto funcionaria · Por que parece errado (e por que pode ser certo) · Persona que se beneficia desta inversão · Jornada invertida · Princípios desta proposta

---

### UX-ALIEN
**Arquivo:** `.claude/agents/ux/ux-alien.md`
**Lente:** Zero herança de convenções de UI
**Pergunta central:** "Como resolver este problema sem herdar nenhum padrão de interface?"

Age como se nunca tivesse visto um computador. Não conhece menus, botões, modais ou onboarding. Foca no problema humano puro e propõe a experiência a partir de metáforas do mundo real. Proibido usar jargão de UI na proposta.

**Seções obrigatórias (8):** O problema humano puro · Metáfora do mundo real adotada · Como a experiência funciona · Convenções que esta proposta elimina · Por que cada remoção faz sentido · Persona · Jornada · Princípios desta proposta

---

### UX-TEMPO
**Arquivo:** `.claude/agents/ux/ux-tempo.md`
**Lente:** Três horizontes temporais simultâneos
**Pergunta central:** "Como o mesmo usuário experimenta o produto nos primeiros 5 minutos, em 30 dias e em 2 anos?"

Detecta armadilhas temporais: o que encanta no onboarding mas frustra o usuário experiente, o que cria dívida cognitiva, o que o produto não conseguirá dar em 2 anos. Parte da premissa que todo produto é projetado para um usuário que não existe.

**Seções obrigatórias (6):** Usuário T0/T30/T2A · Armadilhas temporais (tabela) · Princípio central desta proposta · Como a experiência evolui (T0, T30, T2A) · Jornada temporal · Princípios desta proposta

---

### UX-CONTRARIAN
**Arquivo:** `.claude/agents/ux/ux-contrarian.md`
**Lente:** Oposto de cada premissa óbvia
**Pergunta central:** "Por que não o contrário?" para cada decisão que o briefing trata como dada

Defende sistematicamente o oposto de cada premissa que parece óbvia. Não por provocação — escolhe as inversões mais defensáveis, não as mais dramáticas. É honesto sobre o que a proposta contrária sacrifica.

**Seções obrigatórias (8):** Premissas contestadas (tabela) · A lógica contrária central · Como o produto funcionaria · O que esta proposta sacrifica conscientemente · O que ganha em troca · Persona que se beneficia desta inversão · Jornada contrária · Princípios desta proposta

---

### UX-SISTEMA
**Arquivo:** `.claude/agents/ux/ux-sistema.md`
**Lente:** Ecossistema e comportamentos em escala
**Pergunta central:** "O que emerge quando 10.000 pessoas usam este produto?"

Não enxerga usuários individuais — enxerga o ecossistema. Detecta efeitos de rede, loops de feedback involuntários e comportamentos emergentes em escala. Projeta os efeitos sistêmicos intencionalmente em vez de deixá-los emergir por acaso.

**Seções obrigatórias (8):** Atores do ecossistema (tabela) · Efeitos emergentes em escala (tabela) · A oportunidade sistêmica · Loops de feedback intencionais · Como o produto escala · Persona sistêmica · Jornada coletiva · Princípios desta proposta

---

### UX-SYNTHESIS-X
**Arquivo:** `.claude/agents/ux/ux-synthesis-x.md`
**Ativado por:** Orchestrator-UX após validar as 5 propostas
**Papel:** Síntese por colisão — não busca consenso, busca ideias que só existem na interseção das cinco propostas

Opera em três fases distintas:

| Fase | Quando | Input | Output |
|------|--------|-------|--------|
| Fase 1 | Após as 5 propostas | 5 arquivos + context.md + CLAUDE.md | `ux-proposals.md` com 3 direções |
| Fase 2 | Após escolha humana | ux-proposals.md + todos os arquivos | `ux.md` expandido |
| Fase 3 | Pós-reprovação de Story | ux.md atual + 1 proposta + descrição do aspecto que falhou | `ux.md` com seção revisada |

**Regra fundamental:** cada direção deve conter um "elemento emergente" — uma ideia que nenhum agente propôs sozinho. Se não há elemento emergente, foi curadoria, não síntese.

---

## Fluxo detalhado

```
1. Humano executa: /ux docs/features/minha-feature

2. Orchestrator-UX avalia o estado:
   ├─ Nenhum arquivo existe?         → inicia do zero
   ├─ Processo parcialmente feito?   → retoma do ponto de parada (via log)
   └─ ux.md existe e é válido?       → notifica o humano (concluído)

3. Para cada agente (sequencial):
   a. Prepara contexto: apenas context.md + CLAUDE.md + arquivo do agente
   b. Ativa o agente
   c. Valida o arquivo gerado (tamanho + seções obrigatórias)
   d. Se inválido: reexecuta do zero
   e. Registra no log
   f. Avança para o próximo

4. UX-SYNTHESIS-X Fase 1:
   a. Lê as 5 propostas
   b. Mapeia interseções e contradições férteis
   c. Constrói 3 direções (cada uma com elementos de ≥2 agentes diferentes)
   d. Salva ux-proposals.md
   e. Apresenta tabela resumo ao humano

5. Humano escolhe uma direção (ou solicita Direção 4)

6. UX-SYNTHESIS-X Fase 2:
   a. Expande a direção escolhida
   b. Gera ux.md completo com personas, jornadas, princípios e fluxos

7. Orchestrator-UX executa checklist de qualidade no ux.md:
   ├─ Passou? → gera ux-debate.md → oferece limpeza dos intermediários
   └─ Falhou? → retorna ao SYNTHESIS-X para completar

8. Orchestrator-UX notifica o humano: ux.md disponível — execute `/dev {WORK_DIR}` para iniciar o Time Dev
```

---

## Entradas necessárias

Para executar `/ux [caminho]`, o diretório da feature precisa conter:

### `CLAUDE.md` (obrigatório)
Contexto de domínio do produto. Deve incluir:
- Domínio de negócio e terminologia específica
- Perfis de usuário já conhecidos (se existirem)
- Restrições de acessibilidade (se houver)
- Sistema de design declarado (se houver)
- O que NÃO muda (fundamental para modo INCREMENTAL)

> ⚠️ Este arquivo é diferente do `CLAUDE.md` da raiz do projeto — contém contexto de produto, não infraestrutura de agentes.

### `context.md` (obrigatório)
Briefing da feature. Para o modo INCREMENTAL, deve responder explicitamente:
- Qual feature existente está sendo melhorada?
- O que já existe hoje que não muda?
- Qual é o escopo específico da melhoria?

Se o `context.md` for vago em modo INCREMENTAL, o orchestrator para e solicita reescrita antes de ativar qualquer agente.

---

## Saídas produzidas

| Arquivo | Tipo | Para quem |
|---------|------|-----------|
| `ux.md` | Permanente | Time Dev — entregável principal |
| `ux-proposals.md` | Permanente | Referência das 3 direções apresentadas |
| `ux-debate.md` | Permanente | Registro de decisões de design para consulta futura |
| `log-orchestrator-ux.md` | Permanente | Rastreabilidade do processo |
| `ux-destructor.md` | Intermediário | Pode ser removido após ux.md aprovado |
| `ux-alien.md` | Intermediário | Pode ser removido após ux.md aprovado |
| `ux-tempo.md` | Intermediário | Pode ser removido após ux.md aprovado |
| `ux-contrarian.md` | Intermediário | Pode ser removido após ux.md aprovado |
| `ux-sistema.md` | Intermediário | Pode ser removido após ux.md aprovado |

---

## Como iniciar

```bash
# Nova feature
/ux docs/features/nome-da-feature

# Melhoria em feature existente (ux.md já existe no diretório)
/ux docs/features/nome-da-feature
# O orchestrator detecta o modo INCREMENTAL automaticamente pela presença do ux.md
```

---

## Retomada de sessão

Se a sessão for interrompida, execute o mesmo comando novamente:

```bash
/ux docs/features/nome-da-feature
```

O Orchestrator-UX lê o `log-orchestrator-ux.md` e retoma exatamente de onde parou. Não reexecuta agentes com status ✅ confirmado no log.

Estados possíveis no log e comportamento de retomada:

| Estado no log | Comportamento |
|---------------|---------------|
| Em andamento (1–4 propostas) | Retoma a partir do próximo agente pendente |
| Pronto para síntese | Ativa UX-SYNTHESIS-X Fase 1 diretamente |
| Aguardando escolha humana | Reapresenta a tabela das 3 direções |
| Direção 4 solicitada | Verifica se Direção 4 já existe; se não, gera |
| Expansão pendente | Ativa UX-SYNTHESIS-X Fase 2 com a direção registrada |

---

## Fronteira com o Time Dev

O Time UX **não lê nem escreve**:
- `backlog.md`
- `us-XX-entrega.md`
- `us-XX-qa.md`
- Qualquer arquivo gerado pelo Time Dev

O único arquivo compartilhado é `ux.md` — produzido pelo Time UX e consumido pelo Time Dev.
