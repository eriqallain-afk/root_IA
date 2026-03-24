# PATCH — gpt_catalog.yaml
# Ajouter APRÈS IT-AssistanTI_N3

```yaml
  IT-AssistanTI_FrontLine:
    display_name: '@IT-AssistanTI_FrontLine'
    team_id: TEAM__IT
    status: active
    intents:
    - frontline
    - appel_direct
    - ticket_mspbot
    - triage
    - helpdesk
    - n1
    - n2
    - password
    - acces
    - outlook
    - imprimante
    - lecteur_reseau
    - vpn
    - application
    - it
    paths:
      agent: 20_Agents/IT-AssistanTI_FrontLine/agent.yaml
      contract: 20_Agents/IT-AssistanTI_FrontLine/contract.yaml
      prompt: 20_Agents/IT-AssistanTI_FrontLine/prompt.md
```
