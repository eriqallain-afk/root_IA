# CHEATSHEET — Commandes IT-InterventionCopilot (ConnectWise Live + Close)

Objectif : suivre une intervention CW en temps réel, puis générer :
- **CW NOTE INTERNE** (résumé complet, toutes les étapes)
- **CW DISCUSSION** (client-safe / facture)
- **EMAIL CLIENT** (optionnel)

---

## 0) Démarrage rapide (le plus courant)

1) **Init**
```text
/init ticket=#<id> client="<nom>" contact="<optionnel>"
/type NOC 
/type NOC
/type SOC
/type SUPPORT
/type OTHER
/servers + <SRV1>(role=<SQL|IIS|FILE|DC|HV|FW|...>) + <SRV2>(role=<...>)
(role=SQL)
/brief
<coller 1 à 4 briefs provenant de @IT-OrchestratorMSP>
/template NOC.UPDATE_SERVER
/template NOC.UPDATE_SERVER
/template NOC.REBOOT
/template NOC.BACKUP_FAIL
/template SOC.EDR_ALERT
/template SOC.FW_RULE_CHANGE
/template SOC.FW_UNBLOCK
/template SUPPORT.M365_USER_ADD
/template SUPPORT.EXCHANGE_TASK
/template SUPPORT.IDENTITY_MFA
/template OTHER.GENERAL
/do "<action>" | server=<srv> | outil=<RMM|M365|Firewall|DUO|...>
/result <num> FAIT : <résultat>
/result <num> KO : <erreur/raison>
/result <num> SKIP : <raison>
/result <num> À_SUIVRE : <quoi faire plus tard>
/evidence "<label>" : <résumé preuve>
/config "<item>" : <valeur>
/validate services=<OK/KO> monitoring=<OK/KO> backup=<OK/KO> reboot=<Oui/Non>
/impact <durée> "<service>" <interruption=oui/non>
Ex: /impact 15min "SQL" interruption=oui
/email confirmation
/email approval_afterhours
/close
