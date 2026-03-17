MSP-Assistant v1.1 — corrige 2026-03-16
========================================

CHEMIN CIBLE
------------
C:\Intranet_EA\EA4AI\GPT-Enterprise\root_IA\MSP-Assistant\

STRUCTURE
---------
DB\
  Create_Schema.sql       Schema SQL propre (corrige — sans texte Python REPL)
  msp_assistant.db        Base SQLite (copiee depuis lancien emplacement)

Scripts\
  create_db.py            Creer / reinitialiser la base
  insert_entry.py         Inserer une intervention (dict Python ou fichier JSON)
  insert_from_prompt.ps1  Appel complet depuis PowerShell (13 params via JSON temp)
  export_reports.py       Exporter toutes les interventions en .txt
  ui_launcher.py          Dashboard Tkinter (visualisation)

Reports\                  Rapports exportes (cree automatiquement)
Move-MSPAssistant.ps1     Script de demenagement depuis C:\MSP-Assistant

DEMARRAGE RAPIDE
----------------
Etape 1 — Deplacer les fichiers :
  PowerShell : .\Move-MSPAssistant.ps1

Etape 2 — Creer / verifier la base :
  python Scripts\create_db.py

Etape 3 — Tester une insertion :
  python Scripts\insert_entry.py

Etape 4 — Visualiser les entrees :
  python Scripts\ui_launcher.py

Etape 5 — Exporter :
  python Scripts\export_reports.py

INTEGRATION IT-AssistanceTechnique (/close)
--------------------------------------------
Apres la commande /close, l'agent genere les livrables CW et appelle :

  .\insert_from_prompt.ps1 `
    -Client      "NomClient" `
    -Ticket      "CW-1683171" `
    -Technicien  "Jean L." `
    -Debut       "2026-03-16 09:00" `
    -Fin         "2026-03-16 09:25" `
    -Resume      "Lenteur serveur Fidelio - CPU 100%" `
    -NoteInterne "[note interne CW]" `
    -Discussion  "[discussion CW STAR]" `
    -CourrielClient "[email client]" `
    -Teams       "[annonce Teams]" `
    -Scripts     "[scripts PS utilises]" `
    -Diagnostic  "[diagnostic complet]" `
    -Chronologie "[chronologie intervention]"

Le script cree un JSON temporaire -> appelle insert_entry.py -> nettoie le JSON.

CORRECTIONS v1.0 -> v1.1
--------------------------
[CRITIQUE] Create_Schema.sql : supprime le texte Python REPL (>>>) present par erreur
[CRITIQUE] Tous les chemins : C:\MSP-Assistant -> dossier IA EA4AI
[MAJEUR]   insert_from_prompt.ps1 : completement recrit, 13 params passes via JSON
[MAJEUR]   insert_entry.py : supporte appel Python ET appel CLI avec JSON
[MINEUR]   export_reports.py : chemin corrige + gestion valeurs nulles
[MINEUR]   ui_launcher.py : chemin corrige + UI amelioree
