# Exemples I/O — @EDU-Extractor_CCQ

## Exemple 1 — mono-élève
Entrée : PDF 1 élève (2 pages)
Sortie : extraction_batch.students[0].text = transcription complète, pages=[0,1]

## Exemple 2 — multi-élèves > 7
Entrée : PDF 12 élèves
Sortie : returned_students_count=7, continuation_required=true, next_start_index=8
