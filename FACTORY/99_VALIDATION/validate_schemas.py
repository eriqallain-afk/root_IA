#!/usr/bin/env python3
"""
validate_schemas.py -- Validation schema-lite des fichiers YAML critiques.

CORRECTION v2 (2026-03) :
  - ROOT recalcule depuis ce script (root_IA/99_VALIDATION/) -> parents[1] = root_IA/
  - Tous les chemins critiques prefixes par FACTORY/ (layout split)
  - Cle 'router_actor_id' remplacee par 'router' (schema hub_routing v2.0)
  - Cle 'fallback' accepte string OU dict
  - 20_AGENTS/ cherche d'abord dans FACTORY/ puis a la racine (compat. future)
"""
from pathlib import Path
import sys
import yaml

# Ce script est dans root_IA/99_VALIDATION/
# parents[1] = root_IA/
ROOT    = Path(__file__).resolve().parents[1]
FACTORY = ROOT / "FACTORY"


def fail(msg: str) -> None:
    print("FAIL:", msg)
    sys.exit(1)


def ok(msg: str) -> None:
    print("OK:  ", msg)


# ------------------------------------------------------------------
# 1. Fichiers critiques (chemins absolus)
# ------------------------------------------------------------------
core = {
    "ROUTING":      FACTORY / "80_MACHINES/hub_routing.yaml",
    "PLAYBOOKS":    FACTORY / "40_RUNBOOKS/playbooks.yaml",
    "MEMORY_INDEX": FACTORY / "90_MEMORY/memory.yaml",
}

for key, path in core.items():
    if not path.exists():
        fail(f"Fichier manquant [{key}] : {path}")
    ok(f"{key} trouvé : {path.relative_to(ROOT)}")


# ------------------------------------------------------------------
# 2. hub_routing.yaml -- cles obligatoires
# ------------------------------------------------------------------
routing = yaml.safe_load(core["ROUTING"].read_text(encoding="utf-8"))

# Cles requises -- CORRECTION : 'router' et non 'router_actor_id'
required_routing_keys = ["schema_version", "router", "routing_table", "fallback"]
for req in required_routing_keys:
    if req not in routing:
        fail(f"hub_routing.yaml : cle manquante '{req}' "
             f"(cles presentes : {list(routing.keys())})")
ok(f"hub_routing.yaml : toutes les cles presentes {required_routing_keys}")

# Verifier que routing_table est une liste non vide
if not isinstance(routing.get("routing_table"), list) or len(routing["routing_table"]) == 0:
    fail("hub_routing.yaml : 'routing_table' doit etre une liste non vide")
ok(f"hub_routing.yaml : routing_table = {len(routing['routing_table'])} routes")


# ------------------------------------------------------------------
# 3. playbooks.yaml
# ------------------------------------------------------------------
pbs = yaml.safe_load(core["PLAYBOOKS"].read_text(encoding="utf-8"))
if "playbooks" not in pbs or not isinstance(pbs["playbooks"], dict):
    fail("playbooks.yaml invalide : cle 'playbooks' manquante ou pas un dictionnaire")
ok(f"playbooks.yaml : {len(pbs['playbooks'])} playbooks")


# ------------------------------------------------------------------
# 4. memory.yaml
# ------------------------------------------------------------------
mem = yaml.safe_load(core["MEMORY_INDEX"].read_text(encoding="utf-8"))
if "memory_objects" not in mem:
    fail("memory.yaml invalide : cle 'memory_objects' manquante")
ok(f"memory.yaml : {len(mem['memory_objects'])} memory objects")


# ------------------------------------------------------------------
# 5. Agents -- 20_AGENTS/ dans FACTORY/ (ou racine si absent)
# ------------------------------------------------------------------
agents_root = FACTORY / "20_AGENTS"
if not agents_root.exists():
    # Compat legacy -- chercher a la racine
    agents_root = ROOT / "20_AGENTS"
if not agents_root.exists():
    fail(f"Dossier 20_AGENTS introuvable (cherche dans FACTORY/ et a la racine)")

missing_files = []
for agent_yaml in sorted(agents_root.rglob("agent.yaml")):
    base = agent_yaml.parent
    for req in ["contract.yaml", "prompt.md"]:
        if not (base / req).exists():
            missing_files.append(f"{base.relative_to(ROOT)}/{req}")

if missing_files:
    fail(f"Fichiers manquants dans 20_AGENTS ({len(missing_files)}) :\n  " +
         "\n  ".join(missing_files[:10]) +
         ("\n  ..." if len(missing_files) > 10 else ""))

agent_count = len(list(agents_root.rglob("agent.yaml")))
ok(f"20_AGENTS : {agent_count} agents valides (contract.yaml + prompt.md presents)")


# ------------------------------------------------------------------
# 6. CTL agents (00_CONTROL/) -- verification supplementaire
# ------------------------------------------------------------------
ctl_root = FACTORY / "00_CONTROL/agents"
if ctl_root.exists():
    ctl_agents = [d for d in ctl_root.iterdir() if d.is_dir()]
    ctl_ok = 0
    for d in ctl_agents:
        all_present = all((d / f).exists() for f in ["agent.yaml", "contract.yaml", "prompt.md"])
        if all_present:
            ctl_ok += 1
        else:
            missing = [f for f in ["agent.yaml", "contract.yaml", "prompt.md"] if not (d / f).exists()]
            print(f"WARN : CTL/{d.name} -- manquant : {missing}")
    ok(f"CTL agents : {ctl_ok}/{len(ctl_agents)} complets")


# ------------------------------------------------------------------
# Resultat final
# ------------------------------------------------------------------
print("\nOK: schema-lite validation passed")
