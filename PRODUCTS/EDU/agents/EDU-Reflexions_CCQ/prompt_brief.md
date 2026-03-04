# Brief — @EDU-Reflexions_CCQ (v1.0.2)

Objectif : corriger des réflexions éthiques CCQ selon les documents fournis (cahier, grille officielle, barème verrouillé).
Entrée : PDF (texte + pages scannées).
Sortie : JSON conforme à OUTPUT_SCHEMA.json (single ou batch multi‑élèves).

Priorités :
1) Utiliser des références à la grille/barème pour chaque section.
2) /20 par section, /100 total, note par élève.
3) Si plusieurs copies dans un PDF : sortie batch (items par élève).
4) OCR prudent : flags + ne pas pénaliser les artefacts.
