#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
validate_product.py — Validateur interactif pour les PRODUCTS EA4AI
====================================================================

Lance depuis n'importe quel dossier — le script trouve automatiquement
la racine du repo (root_IA/) et lit products_registry.yaml.

Emplacement : root_IA/99_VALIDATION/validate_product.py
Companion   : root_IA/99_VALIDATION/products_registry.yaml

Utilisation :
  python validate_product.py             # menu interactif
  python validate_product.py --all       # valider TOUS les products
  python validate_product.py --id EDU    # valider un product direct
  python validate_product.py --id EDU IASM PLR  # plusieurs

Exit codes :
  0 = tout valide
  1 = erreur fatale (fichier manquant, YAML invalide)
  2 = erreurs de validation détectées
"""

from __future__ import annotations

import argparse
import os
import sys
import glob
from pathlib import Path
from typing import Dict, List, Optional, Set, Tuple, Any

try:
    import yaml
except ImportError:
    print("FATAL: PyYAML requis.  Installe avec :  pip install pyyaml")
    sys.exit(1)

# ─── Chemins ────────────────────────────────────────────────────────────────
# Ce script est dans root_IA/99_VALIDATION/
# parents[0] = root_IA/99_VALIDATION/
# parents[1] = root_IA/
HERE     = Path(__file__).resolve().parent
ROOT     = HERE.parent
PRODUCTS = ROOT / "PRODUCTS"
REGISTRY = HERE / "products_registry.yaml"

# ─── Couleurs terminal (Windows CMD / PowerShell les supportent depuis Win10) ─
USE_COLOR = sys.stdout.isatty()

def _c(text: str, code: str) -> str:
    if not USE_COLOR:
        return text
    return f"\033[{code}m{text}\033[0m"

def GREEN(t):  return _c(t, "32")
def RED(t):    return _c(t, "31")
def YELLOW(t): return _c(t, "33")
def CYAN(t):   return _c(t, "36")
def BOLD(t):   return _c(t, "1")
def DIM(t):    return _c(t, "2")


# ─── Modèles de données ────────────────────────────────────────────────────
class Finding:
    def __init__(self):
        self.errors:   List[str] = []
        self.warnings: List[str] = []
        self.infos:    List[str] = []

    def err(self, msg: str):  self.errors.append(msg)
    def warn(self, msg: str): self.warnings.append(msg)
    def info(self, msg: str): self.infos.append(msg)

    @property
    def ok(self) -> bool:
        return len(self.errors) == 0

    def summary(self) -> str:
        return (f"ERREURS:{len(self.errors)}  "
                f"WARNINGS:{len(self.warnings)}")


# ─── Utilitaires YAML ─────────────────────────────────────────────────────
def load_yaml(path: Path) -> Any:
    with open(path, encoding="utf-8", errors="replace") as f:
        return yaml.safe_load(f)

def _first_key(d: dict, *keys) -> Any:
    for k in keys:
        if k in d:
            return d[k]
    return None


# ─── Lecture du registre ──────────────────────────────────────────────────
def load_registry() -> List[dict]:
    if not REGISTRY.exists():
        print(RED(f"FATAL: products_registry.yaml introuvable : {REGISTRY}"))
        print(f"       Ce fichier doit être dans : {HERE}")
        sys.exit(1)
    data = load_yaml(REGISTRY)
    return data.get("products", [])


# ─── Menu interactif ──────────────────────────────────────────────────────
def interactive_menu(products: List[dict]) -> List[dict]:
    print()
    print(BOLD(CYAN("=" * 62)))
    print(BOLD(CYAN("        EA4AI — validate_product.py — Sélection")))
    print(BOLD(CYAN("=" * 62)))
    print()
    print(f"  Repo   : {ROOT}")
    print(f"  Registre : {len(products)} PRODUCTS disponibles")
    print()

    # Afficher la liste numérotée
    for i, p in enumerate(products, 1):
        status_icon = GREEN("●") if p.get("status") == "active" else YELLOW("◐")
        notes = f"  {DIM(p['notes'])}" if p.get("notes") else ""
        print(f"  {BOLD(str(i).rjust(2))}.  {status_icon}  "
              f"{BOLD(p['id']):<22}  {DIM(p['display_name'])}{notes}")

    print()
    print(f"  {BOLD('0')}.  {CYAN('ALL')}  — Valider TOUS les products")
    print()
    print("─" * 62)
    print("  Saisir le(s) numéro(s) séparés par espace ou virgule.")
    print(f"  Exemples :  {DIM('1')}  |  {DIM('1 3 5')}  |  {DIM('2,4')}  |  {DIM('0')}")
    print("─" * 62)

    while True:
        try:
            raw = input(f"\n  {BOLD('Ton choix')} : ").strip()
        except (KeyboardInterrupt, EOFError):
            print(f"\n  {YELLOW('Annulé.')}")
            sys.exit(0)

        if not raw:
            print(f"  {YELLOW('Entre au moins un numéro.')}")
            continue

        # Normaliser : accepter espace, virgule, point-virgule
        parts = raw.replace(",", " ").replace(";", " ").split()

        try:
            nums = [int(p) for p in parts]
        except ValueError:
            print(f"  {RED('Valeur invalide — utilise uniquement des chiffres.')}")
            continue

        if any(n < 0 or n > len(products) for n in nums):
            print(f"  {RED(f'Numéros valides : 0 à {len(products)}')}")
            continue

        if 0 in nums:
            return list(products)   # TOUS

        # Dédoublonner tout en préservant l'ordre
        seen: Set[int] = set()
        selected = []
        for n in nums:
            if n not in seen:
                seen.add(n)
                selected.append(products[n - 1])

        return selected


# ─── VALIDATION D'UN PRODUCT ──────────────────────────────────────────────

def _agents_dir(product_root: Path, agents_dir_name: str) -> Optional[Path]:
    """Retourne le dossier agents (gère les variantes de nommage)."""
    for name in [agents_dir_name, "agents", "20_Agents", "AGENTS"]:
        p = product_root / name
        if p.exists() and p.is_dir():
            return p
    return None


def validate_product(p_meta: dict) -> Tuple[Finding, Dict[str, Any]]:
    pid   = p_meta["id"]
    proot = PRODUCTS / pid
    f     = Finding()
    stats: Dict[str, Any] = {"id": pid, "display_name": p_meta.get("display_name", pid)}

    if not proot.exists():
        f.err(f"Dossier PRODUCT introuvable : {proot}")
        return f, stats

    # ── 1. Fichiers critiques ──────────────────────────────────────────────
    catalog_path  = proot / "00_INDEX" / "gpt_catalog.yaml"
    index_path    = proot / "00_INDEX" / "agents_index.yaml"
    routing_path  = proot / "80_MACHINES" / "hub_routing.yaml"
    playbooks_path = proot / "playbooks" / "playbooks.yaml"

    for label, path in [
        ("gpt_catalog.yaml",    catalog_path),
        ("agents_index.yaml",   index_path),
        ("hub_routing.yaml",    routing_path),
        ("playbooks.yaml",      playbooks_path),
    ]:
        if not path.exists():
            f.err(f"Fichier critique manquant : {path.relative_to(PRODUCTS)}")
        else:
            f.info(f"{label} trouvé")

    # Si un fichier critique manque, arrêter ici
    if not f.ok:
        return f, stats

    # ── 2. Charger les fichiers ────────────────────────────────────────────
    try:
        cat_data  = load_yaml(catalog_path)
        idx_data  = load_yaml(index_path)
        rt_data   = load_yaml(routing_path)
        pbs_data  = load_yaml(playbooks_path)
    except Exception as e:
        f.err(f"Erreur de parsing YAML : {e}")
        return f, stats

    # ── 3. Catalog — agents ────────────────────────────────────────────────
    catalog_raw = cat_data.get("catalog") if isinstance(cat_data, dict) else None
    if isinstance(catalog_raw, dict):
        catalog_ids: Set[str] = set(catalog_raw.keys())
    elif isinstance(catalog_raw, list):
        catalog_ids = {a.get("id") or a.get("actor_id") for a in catalog_raw if isinstance(a, dict)}
        catalog_ids.discard(None)
    else:
        catalog_ids = set()
        f.err("gpt_catalog.yaml : clé 'catalog' absente ou format inattendu")

    stats["catalog_count"] = len(catalog_ids)
    if len(catalog_ids) == 0:
        f.err("gpt_catalog.yaml : aucun agent détecté")

    # ── 4. agents_index ────────────────────────────────────────────────────
    idx_raw = idx_data.get("agents") if isinstance(idx_data, dict) else None
    if isinstance(idx_raw, dict):
        index_ids: Set[str] = set(idx_raw.keys())
    elif isinstance(idx_raw, list):
        index_ids = {a.get("id") or a.get("actor_id") for a in idx_raw if isinstance(a, dict)}
        index_ids.discard(None)
    else:
        index_ids = set()
        f.err("agents_index.yaml : clé 'agents' absente ou format inattendu")

    stats["index_count"] = len(index_ids)

    # Sync catalog ↔ index
    only_cat = sorted(catalog_ids - index_ids)
    only_idx = sorted(index_ids - catalog_ids)
    if only_cat:
        f.warn(f"Dans catalog mais pas dans index : {only_cat}")
    if only_idx:
        f.warn(f"Dans index mais pas dans catalog : {only_idx}")
    if not only_cat and not only_idx and catalog_ids:
        f.info(f"catalog ↔ index synchronisés ({len(catalog_ids)} agents)")

    # ── 5. hub_routing ────────────────────────────────────────────────────
    routing_table = []
    if isinstance(rt_data, dict):
        routing_table = rt_data.get("routing_table", [])
        # Clé router : PRODUCTS utilisent 'router_actor_id'
        router_key = _first_key(rt_data, "router_actor_id", "router")
        if not router_key:
            f.warn("hub_routing.yaml : clé 'router_actor_id' absente")
        else:
            if router_key not in catalog_ids and router_key not in index_ids:
                f.warn(f"hub_routing.yaml : router '{router_key}' absent du catalog")
            else:
                f.info(f"router_actor_id = {router_key} (présent dans catalog)")
    else:
        f.err("hub_routing.yaml : format inattendu (attendu : dict)")

    stats["routes_count"] = len(routing_table)

    # Vérifier actors référencés dans routing
    routing_actor_refs: Set[str] = set()
    routing_pb_refs:    Set[str] = set()
    for route in routing_table:
        if not isinstance(route, dict):
            continue
        actor = _first_key(route, "default_actor_id", "actor_id")
        pb    = _first_key(route, "default_playbook_id", "playbook_id")
        if actor:
            routing_actor_refs.add(str(actor))
        if pb:
            routing_pb_refs.add(str(pb))

    missing_routing_actors = sorted(
        a for a in routing_actor_refs
        if a not in catalog_ids and a not in index_ids
    )
    if missing_routing_actors:
        f.err(f"Routing → actors inconnus : {missing_routing_actors}")
    elif routing_actor_refs:
        f.info(f"Routing : {len(routing_actor_refs)} actor_id tous connus")

    # ── 6. Playbooks ──────────────────────────────────────────────────────
    pbs_map: Dict[str, Any] = {}
    if isinstance(pbs_data, dict):
        pbs_map = pbs_data.get("playbooks", {})
    if not isinstance(pbs_map, dict):
        f.err("playbooks.yaml : clé 'playbooks' absente ou pas un dict")
    stats["playbooks_count"] = len(pbs_map)

    # Vérifier que les playbooks référencés dans routing existent
    missing_pbs = sorted(p for p in routing_pb_refs if p not in pbs_map)
    if missing_pbs:
        f.err(f"Routing → playbooks inconnus : {missing_pbs}")
    elif routing_pb_refs:
        f.info(f"Routing → {len(routing_pb_refs)} playbooks tous présents")

    # Vérifier actors dans les steps des playbooks
    pb_actor_refs: Set[str] = set()
    for pb_id, pb_def in pbs_map.items():
        for step in (pb_def.get("steps", []) if isinstance(pb_def, dict) else []):
            if not isinstance(step, dict):
                continue
            actor = _first_key(step, "actor_id", "actor", "agent_id")
            if actor:
                pb_actor_refs.add(str(actor))

    missing_pb_actors = sorted(
        a for a in pb_actor_refs
        if a not in catalog_ids and a not in index_ids
    )
    if missing_pb_actors:
        f.err(f"Playbooks steps → actors inconnus : {missing_pb_actors}")
    elif pb_actor_refs:
        f.info(f"Playbooks steps : {len(pb_actor_refs)} actor_id tous connus")

    # ── 7. Agents physiques ────────────────────────────────────────────────
    agents_root = _agents_dir(proot, p_meta.get("agents_dir", "agents"))
    if agents_root is None:
        f.warn("Dossier agents introuvable (agents/ ou 20_Agents/)")
    else:
        physical_agents = [
            d for d in agents_root.iterdir() if d.is_dir()
        ]
        stats["physical_count"] = len(physical_agents)

        # Vérifier fichiers obligatoires pour chaque agent
        incomplete: List[str] = []
        for ag_dir in physical_agents:
            missing_files = [
                fn for fn in ["agent.yaml", "contract.yaml", "prompt.md"]
                if not (ag_dir / fn).exists()
            ]
            if missing_files:
                incomplete.append(f"{ag_dir.name} manque {missing_files}")

        if incomplete:
            for inc in incomplete:
                f.warn(f"Agent incomplet : {inc}")
        else:
            f.info(f"Agents physiques : {len(physical_agents)} / "
                   f"tous ont agent.yaml + contract.yaml + prompt.md")

        # Sync physique ↔ catalog
        phys_ids = {d.name for d in physical_agents}
        not_in_catalog = sorted(phys_ids - catalog_ids)
        not_physical   = sorted(catalog_ids - phys_ids)
        if not_in_catalog:
            f.warn(f"Agents physiques non référencés dans catalog : {not_in_catalog}")
        if not_physical:
            f.warn(f"Agents dans catalog sans dossier physique : {not_physical}")
        if not not_in_catalog and not not_physical:
            f.info(f"Sync physique ↔ catalog : {len(phys_ids)} agents alignés")

    # ── 8. manifest.yaml (optionnel) ──────────────────────────────────────
    manifest = proot / "manifest.yaml"
    if p_meta.get("has_manifest") and not manifest.exists():
        f.warn("manifest.yaml attendu mais absent")
    elif manifest.exists():
        try:
            m = load_yaml(manifest)
            if isinstance(m, dict):
                f.info(f"manifest.yaml : version={m.get('version','?')} nom={m.get('name','?')}")
        except Exception:
            f.warn("manifest.yaml : erreur de parsing")

    return f, stats


# ─── AFFICHAGE DES RÉSULTATS ──────────────────────────────────────────────

def print_product_result(f: Finding, stats: Dict[str, Any]) -> None:
    pid   = stats["id"]
    name  = stats.get("display_name", pid)
    nb_ok = len(f.infos)
    nb_w  = len(f.warnings)
    nb_e  = len(f.errors)

    print()
    if f.ok:
        banner = GREEN(f"  ✔  {pid}  —  {name}")
    else:
        banner = RED(f"  ✖  {pid}  —  {name}")
    print(BOLD(banner))

    # Statistiques
    parts = []
    if "catalog_count"   in stats: parts.append(f"catalog:{stats['catalog_count']}")
    if "index_count"     in stats: parts.append(f"index:{stats['index_count']}")
    if "physical_count"  in stats: parts.append(f"physiques:{stats['physical_count']}")
    if "routes_count"    in stats: parts.append(f"routes:{stats['routes_count']}")
    if "playbooks_count" in stats: parts.append(f"playbooks:{stats['playbooks_count']}")
    if parts:
        print(f"     {DIM('  |  '.join(parts))}")

    # Erreurs
    for e in f.errors:
        print(f"     {RED('❌')} {e}")

    # Warnings
    for w in f.warnings:
        print(f"     {YELLOW('⚠')}  {w}")

    # Infos (uniquement si pas d'erreur pour éviter le bruit)
    if f.ok and nb_w == 0:
        for i in f.infos:
            print(f"     {GREEN('✓')}  {DIM(i)}")
    elif f.ok:
        print(f"     {GREEN('✓')}  {nb_ok} vérifications OK")

    print(f"     {DIM('─' * 52)}")
    result = GREEN("OK") if f.ok and nb_w == 0 else \
             YELLOW("OK (warnings)") if f.ok else RED("FAIL")
    print(f"     {BOLD('Résultat')} : {result}  |  "
          f"ERR:{RED(str(nb_e))}  WARN:{YELLOW(str(nb_w))}  OK:{GREEN(str(nb_ok))}")


def print_final_report(results: List[Tuple[Finding, Dict]]) -> None:
    total   = len(results)
    passed  = sum(1 for f, _ in results if f.ok)
    warned  = sum(1 for f, _ in results if f.ok and f.warnings)
    failed  = sum(1 for f, _ in results if not f.ok)

    print()
    print(BOLD(CYAN("=" * 62)))
    print(BOLD(CYAN("                 RAPPORT FINAL")))
    print(BOLD(CYAN("=" * 62)))
    print()
    print(f"  Products validés : {total}")
    print(f"  {GREEN(f'  OK complet   : {passed - warned}')}")
    print(f"  {YELLOW(f'  OK + warnings: {warned}')}")
    print(f"  {RED(f'  FAIL         : {failed}')}")
    print()

    for f, stats in results:
        pid = stats["id"]
        if not f.ok:
            icon = RED("  [FAIL]")
        elif f.warnings:
            icon = YELLOW("  [WARN]")
        else:
            icon = GREEN("  [OK]  ")
        print(f"  {icon}  {pid:<22}  "
              f"ERR:{len(f.errors)}  WARN:{len(f.warnings)}")

    print()
    print(BOLD(CYAN("=" * 62)))
    if failed == 0 and warned == 0:
        print(BOLD(GREEN("  RÉSULTAT : TOUS LES PRODUCTS SONT 100% CONFORMES")))
    elif failed == 0:
        print(BOLD(YELLOW(f"  RÉSULTAT : {warned} product(s) avec warnings — voir détails")))
    else:
        print(BOLD(RED(f"  RÉSULTAT : {failed} product(s) en ÉCHEC — corriger puis relancer")))
    print(BOLD(CYAN("=" * 62)))
    print()


# ─── POINT D'ENTRÉE ───────────────────────────────────────────────────────

def main() -> int:
    parser = argparse.ArgumentParser(
        description="Validateur interactif PRODUCTS EA4AI",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Exemples :
  python validate_product.py              # menu interactif
  python validate_product.py --all        # tous les products
  python validate_product.py --id EDU     # un seul
  python validate_product.py --id EDU PLR IASM  # plusieurs
  python validate_product.py --list       # lister les products disponibles
        """
    )
    parser.add_argument("--all",  action="store_true", help="Valider TOUS les products")
    parser.add_argument("--id",   nargs="+",           help="ID(s) du product à valider")
    parser.add_argument("--list", action="store_true", help="Lister les products disponibles et quitter")
    args = parser.parse_args()

    # Vérifications préliminaires
    if not PRODUCTS.exists():
        print(RED(f"FATAL: Dossier PRODUCTS introuvable : {PRODUCTS}"))
        print(f"       ROOT détecté : {ROOT}")
        return 1

    products = load_registry()
    if not products:
        print(RED("FATAL: Aucun product dans products_registry.yaml"))
        return 1

    # Index par ID
    registry_map = {p["id"]: p for p in products}

    # --list
    if args.list:
        print(f"\n  {len(products)} PRODUCTS dans le registre :\n")
        for p in products:
            status = GREEN("active") if p.get("status") == "active" else YELLOW(p.get("status","?"))
            print(f"  {p['id']:<25}  {status:<12}  {p.get('display_name','')}")
        print()
        return 0

    # Sélection des products à valider
    if args.all:
        selected = products
    elif args.id:
        selected = []
        for pid in args.id:
            if pid in registry_map:
                selected.append(registry_map[pid])
            else:
                print(RED(f"ERREUR: Product '{pid}' inconnu dans le registre."))
                print(f"  IDs valides : {', '.join(registry_map.keys())}")
                return 1
    else:
        selected = interactive_menu(products)

    if not selected:
        print(YELLOW("  Aucun product sélectionné. Au revoir."))
        return 0

    # Confirmation
    print()
    print(BOLD(f"  {len(selected)} product(s) à valider :"))
    for p in selected:
        print(f"    → {p['id']}")
    print()

    # Validation
    results: List[Tuple[Finding, Dict]] = []
    for p_meta in selected:
        print(CYAN(f"\n  Validation : {p_meta['id']} ..."))
        finding, stats = validate_product(p_meta)
        print_product_result(finding, stats)
        results.append((finding, stats))

    # Rapport final (si plusieurs)
    if len(results) > 1:
        print_final_report(results)

    # Code retour global
    any_error = any(not f.ok for f, _ in results)
    return 2 if any_error else 0


if __name__ == "__main__":
    sys.exit(main())
