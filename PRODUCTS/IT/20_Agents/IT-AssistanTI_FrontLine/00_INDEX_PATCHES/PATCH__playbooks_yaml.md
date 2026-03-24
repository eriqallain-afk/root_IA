# PATCH — playbooks.yaml
# Ajouter le nouveau playbook IT_FRONTLINE_CALL_TO_CLOSE

```yaml
  IT_FRONTLINE_CALL_TO_CLOSE:
    description: >
      Flux premiere ligne (FrontLine) : reception billet MSPBOT ou appel direct ->
      triage -> resolution N2 -> cloture CW (Note Interne + Discussion STAR) -> KB si P1/P2.
    steps:
    - step: receive
      actor_id: IT-AssistanTI_FrontLine
      description: Reception billet MSPBOT ou appel direct - identification client
    - step: triage_and_resolve
      actor_id: IT-AssistanTI_FrontLine
      description: Categorisation, arbre de decision, resolution N2 ou transfert structure
    - step: closeout
      actor_id: IT-AssistanTI_FrontLine
      description: Cloture CW - Note Interne + Discussion STAR
    - step: kb_if_needed
      actor_id: IT-KnowledgeKeeper
      description: Creation article KB si P1/P2 ou nouveau type de probleme
      condition: P1 ou P2 ou nouveau_type
    - step: archive
      actor_id: OPS-DossierIA
      description: Archivage du dossier
```
