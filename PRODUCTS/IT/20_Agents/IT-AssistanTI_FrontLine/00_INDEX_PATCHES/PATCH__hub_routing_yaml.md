# PATCH — hub_routing.yaml
# Ajouter route FRONTLINE dans la table de routage
# Position recommandee : AVANT la route support N3 existante

```yaml
  # 7b. FRONTLINE — APPELS DIRECTS + MSPBOT N2
  - match_any_intents:
      - frontline
      - appel_direct
      - ticket_mspbot
      - frontline_support
    default_actor_id: IT-AssistanTI_FrontLine
    default_playbook_id: IT_FRONTLINE_CALL_TO_CLOSE
```
