# PATCH hub_routing.yaml — Ajouter après la section NOC TRIAGE
# Insérer ce bloc dans 80_MACHINES/hub_routing.yaml
# Position recommandée : après le bloc "NOC TRIAGE", avant "TECH / RCA"

  # ── INFRA / CLOUD INCIDENT ───────────────────────────────
  - match_any_intents:
      - it_commandare_infra
      - infra_incident
      - infra_alert
      - server_down
      - vm_incident
      - dc_incident
      - cloud_incident
      - azure_incident
      - m365_incident
      - storage_incident
      - dr_incident
      - backup_critical
      - network_infra
      - capacity_critical
      - resource_exhaustion
    default_actor_id: IT-Commandare-Infra
    default_playbook_id: IT_COMMANDARE_INFRA

# ────────────────────────────────────────────────────────────
# NOTE SUR L'ORDRE DE ROUTAGE POUR LES INCIDENTS INFRA
# ────────────────────────────────────────────────────────────
# Flux recommandé pour un incident infra entrant :
#
#   noc_dispatch / alert_triage
#       → IT-Commandare-NOC (corrélation, paging, coordination NOC)
#       → IT-Commandare-Infra (lead technique infra/cloud) ← NOUVEAU
#       → IT-Commandare-TECH (si RCA général requis)
#       → IT-Commandare-OPR (fermeture, DoD)
#
# Les intents "infrastructure" / "servers" / "network" génériques
# continuent à router vers InfrastructureMaster / NetworkMaster
# pour les demandes non-incident (questions, configs, designs).
# IT-Commandare-Infra est pour les INCIDENTS actifs uniquement.
# ────────────────────────────────────────────────────────────
