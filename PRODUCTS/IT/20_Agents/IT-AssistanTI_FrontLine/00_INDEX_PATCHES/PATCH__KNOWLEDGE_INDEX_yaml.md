# PATCH — KNOWLEDGE_INDEX.yaml
# 1. Ajouter IT-AssistanTI_FrontLine dans les consumers shared

```yaml
# shared.templates_cw.consumers — ajouter :
      - IT-AssistanTI_FrontLine

# shared.runbooks.consumers — ajouter :
      - IT-AssistanTI_FrontLine

# shared.checklists.consumers — ajouter :
      - IT-AssistanTI_FrontLine

# shared.powershell_library.consumers — ajouter :
      - IT-AssistanTI_FrontLine

# shared.reference.consumers — ajouter :
      - IT-AssistanTI_FrontLine
```

# 2. Ajouter section agent dans la partie agents

```yaml
  IT-AssistanTI_FrontLine:
    path: 20_Agents/IT-AssistanTI_FrontLine/
    knowledge:
      - 20_Agents/IT-AssistanTI_FrontLine/knowledge/REFERENCE__SLA_FrontLine.md
      - 20_Agents/IT-AssistanTI_FrontLine/knowledge/REFERENCE__Scripts_FrontLine.md
      - 20_Agents/IT-AssistanTI_FrontLine/02_TEMPLATES/TEMPLATE__CW_NOTE_INTERNE_FrontLine.md
      - 20_Agents/IT-AssistanTI_FrontLine/02_TEMPLATES/TEMPLATE__CW_DISCUSSION_STAR_FrontLine.md
      - 20_Agents/IT-AssistanTI_FrontLine/02_TEMPLATES/TEMPLATE__CW_NOTE_TRIAGE.md
```
