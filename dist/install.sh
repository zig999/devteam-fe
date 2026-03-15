#!/bin/bash
# ============================================================================
# install.sh — Instala os agentes de desenvolvimento em um projeto destino
#
# Uso:
#   ./install.sh <frontend|backend> <caminho-do-projeto>
#
# Exemplos:
#   ./install.sh frontend C:\projetos\meu-app-react
#   ./install.sh backend /home/user/projetos/minha-api
#   ./install.sh frontend .   (instala no diretório atual)
#
# O que faz:
#   1. Copia os arquivos compartilhados (shared/) para o projeto
#   2. Copia os arquivos específicos do domínio (frontend/ ou backend/)
#   3. Copia o template CLAUDE.md e WORKSPACE.md para o projeto
#
# Não sobrescreve CLAUDE.md ou WORKSPACE.md se já existirem.
# ============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOMAIN="$1"
TARGET="$2"

# --- Validação ---

if [[ -z "$DOMAIN" || -z "$TARGET" ]]; then
  echo "Uso: ./install.sh <frontend|backend> <caminho-do-projeto>"
  echo ""
  echo "Exemplos:"
  echo "  ./install.sh frontend C:\\projetos\\meu-app"
  echo "  ./install.sh backend /home/user/projetos/api"
  exit 1
fi

if [[ "$DOMAIN" != "frontend" && "$DOMAIN" != "backend" ]]; then
  echo "Erro: domínio deve ser 'frontend' ou 'backend'"
  exit 1
fi

if [[ ! -d "$TARGET" ]]; then
  echo "Erro: diretório '$TARGET' não encontrado"
  exit 1
fi

SHARED_DIR="$SCRIPT_DIR/shared"
DOMAIN_DIR="$SCRIPT_DIR/$DOMAIN"

if [[ ! -d "$SHARED_DIR" ]]; then
  echo "Erro: diretório shared/ não encontrado em $SCRIPT_DIR"
  exit 1
fi

if [[ ! -d "$DOMAIN_DIR" ]]; then
  echo "Erro: diretório $DOMAIN/ não encontrado em $SCRIPT_DIR"
  exit 1
fi

# --- Instalação ---

echo "Instalando agentes ($DOMAIN) em: $TARGET"
echo ""

# 1. Copiar shared (agentes UX, commands, skills compartilhadas)
echo "[1/3] Copiando arquivos compartilhados..."
cp -r "$SHARED_DIR/.claude/"* "$TARGET/.claude/" 2>/dev/null || mkdir -p "$TARGET/.claude" && cp -r "$SHARED_DIR/.claude/"* "$TARGET/.claude/"

# 2. Copiar domínio específico (agentes dev, skills específicas)
echo "[2/3] Copiando arquivos $DOMAIN..."
cp -r "$DOMAIN_DIR/.claude/"* "$TARGET/.claude/"

# 3. Copiar templates (sem sobrescrever)
echo "[3/3] Copiando templates..."

if [[ -f "$TARGET/CLAUDE.md" ]]; then
  echo "  CLAUDE.md já existe — não sobrescrito"
  echo "  Template disponível em: $DOMAIN_DIR/claudemd_example.md"
else
  cp "$DOMAIN_DIR/claudemd_example.md" "$TARGET/CLAUDE.md"
  echo "  CLAUDE.md criado — preencha antes de ativar os agentes"
fi

if [[ -f "$TARGET/WORKSPACE.md" ]]; then
  echo "  WORKSPACE.md já existe — não sobrescrito"
else
  cp "$DOMAIN_DIR/WORKSPACE.md" "$TARGET/WORKSPACE.md"
  echo "  WORKSPACE.md criado — preencha o WORK_DIR antes de iniciar"
fi

echo ""
echo "Instalação concluída!"
echo ""
echo "Próximos passos:"
echo "  1. Preencha o CLAUDE.md com a stack e arquitetura do projeto"
echo "  2. Preencha o WORKSPACE.md com o WORK_DIR"
echo "  3. Execute /context para gerar o contexto da feature"
echo "  4. Execute /ux {WORK_DIR} para gerar o UX"
echo "  5. Execute /dev {WORK_DIR} para iniciar o desenvolvimento"
