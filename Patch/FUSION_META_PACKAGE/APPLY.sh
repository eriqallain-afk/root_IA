#!/bin/bash
# Script d'application — Fusion META (10 → 8 agents)
# Date: 2026-02-01

set -e  # Exit on error

echo "=== FUSION META — Application du package ==="
echo ""
echo "Ce script va :"
echo "  1. Créer 2 nouveaux agents (META-PromptMaster, META-GouvernanceQA)"
echo "  2. Marquer 4 agents comme deprecated"
echo "  3. Patcher agents_index.yaml et playbooks.yaml"
echo ""

# Vérifier qu'on est dans root_IA
if [ ! -f "VERSION" ] || [ ! -d "20_AGENTS/META" ]; then
    echo "ERREUR: Ce script doit être exécuté depuis la racine de root_IA"
    exit 1
fi

# Backup
echo "[1/5] Création backup..."
BACKUP_DIR="BACKUP_FUSION_META_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
cp -r 20_AGENTS/META "$BACKUP_DIR/"
cp 00_INDEX/agents_index.yaml "$BACKUP_DIR/"
cp 40_RUNBOOKS/playbooks.yaml "$BACKUP_DIR/"
echo "✓ Backup créé: $BACKUP_DIR"

# Copier nouveaux agents
echo "[2/5] Copie des nouveaux agents..."
cp -r FUSION_META_PACKAGE/20_AGENTS_META_NEW/META-PromptMaster 20_AGENTS/META/
cp -r FUSION_META_PACKAGE/20_AGENTS_META_NEW/META-GouvernanceQA 20_AGENTS/META/
echo "✓ META-PromptMaster créé"
echo "✓ META-GouvernanceQA créé"

# Marquer anciens agents comme deprecated
echo "[3/5] Dépréciation des anciens agents..."
for agent in META-Opromptimizer META-PromptArchitectEquipes META-SuperviseurInvisible META-GouvernanceEtRisques; do
    if ! grep -q "status: deprecated" "20_AGENTS/META/$agent/agent.yaml"; then
        echo "status: deprecated" >> "20_AGENTS/META/$agent/agent.yaml"
        echo "deprecated_date: '2026-02-01'" >> "20_AGENTS/META/$agent/agent.yaml"
        case $agent in
            META-Opromptimizer|META-PromptArchitectEquipes)
                echo "replaced_by: META-PromptMaster" >> "20_AGENTS/META/$agent/agent.yaml"
                ;;
            META-SuperviseurInvisible|META-GouvernanceEtRisques)
                echo "replaced_by: META-GouvernanceQA" >> "20_AGENTS/META/$agent/agent.yaml"
                ;;
        esac
        echo "✓ $agent deprecated"
    else
        echo "⚠ $agent déjà deprecated (skip)"
    fi
done

# Appliquer patches
echo "[4/5] Application des patches..."
cp FUSION_META_PACKAGE/PATCHES/agents_index.yaml 00_INDEX/agents_index.yaml
cp FUSION_META_PACKAGE/PATCHES/playbooks.yaml 40_RUNBOOKS/playbooks.yaml
echo "✓ agents_index.yaml patché"
echo "✓ playbooks.yaml patché"

# Validation (si scripts disponibles)
echo "[5/5] Validation..."
if [ -f "scripts/validate_schemas.py" ]; then
    echo "Running validate_schemas.py..."
    python scripts/validate_schemas.py || echo "⚠ Validation schemas failed (non-blocking)"
fi
if [ -f "validate_root_IA.sh" ]; then
    echo "Running validate_root_IA.sh..."
    bash validate_root_IA.sh || echo "⚠ Validation root_IA failed (non-blocking)"
fi

echo ""
echo "=== FUSION META APPLIQUÉE AVEC SUCCÈS ==="
echo ""
echo "Changements effectués :"
echo "  + META-PromptMaster (20_AGENTS/META/)"
echo "  + META-GouvernanceQA (20_AGENTS/META/)"
echo "  ~ 4 agents marqués deprecated"
echo "  ~ agents_index.yaml mis à jour"
echo "  ~ playbooks.yaml mis à jour (BUILD_ARMY_FACTORY)"
echo ""
echo "Backup : $BACKUP_DIR"
echo ""
echo "Prochaines étapes :"
echo "  1. Tester BUILD_ARMY_FACTORY avec nouveaux agents"
echo "  2. Commit changes: git add . && git commit -m 'FUSION: META 10→8 agents'"
echo "  3. Monitor 1 semaine"
echo ""
echo "Rollback (si nécessaire) :"
echo "  cp -r $BACKUP_DIR/META 20_AGENTS/"
echo "  cp $BACKUP_DIR/agents_index.yaml 00_INDEX/"
echo "  cp $BACKUP_DIR/playbooks.yaml 40_RUNBOOKS/"
echo ""
