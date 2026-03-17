import sqlite3
import os
from datetime import datetime

# ============================================================
# export_reports.py — MSP-Assistant v1.1
# Exporte toutes les interventions en fichiers .txt
# ============================================================

BASE_PATH     = r"C:\Intranet_EA\EA4AI\GPT-Enterprise\root_IA\MSP-Assistant"
DB_PATH       = os.path.join(BASE_PATH, "DB", "msp_assistant.db")
OUTPUT_FOLDER = os.path.join(BASE_PATH, "Reports")

os.makedirs(OUTPUT_FOLDER, exist_ok=True)

conn = sqlite3.connect(DB_PATH)
conn.row_factory = sqlite3.Row
cursor = conn.cursor()
cursor.execute("SELECT * FROM interventions ORDER BY id DESC")
rows = cursor.fetchall()
conn.close()

print(f"{len(rows)} intervention(s) a exporter...")

for row in rows:
    # Nom de fichier safe (retirer les / et \ du ticket)
    ticket_safe = str(row['ticket']).replace("/", "-").replace("\\", "-")
    fname = os.path.join(OUTPUT_FOLDER, f"Intervention_{row['id']}_{ticket_safe}.txt")

    with open(fname, "w", encoding="utf-8") as f:
        f.write(f"INTERVENTION #{row['id']}\n")
        f.write(f"{'='*50}\n")
        f.write(f"Client     : {row['client']}\n")
        f.write(f"Ticket     : {row['ticket']}\n")
        f.write(f"Technicien : {row['technicien']}\n")
        f.write(f"Debut      : {row['debut']}\n")
        f.write(f"Fin        : {row['fin']}\n")
        f.write(f"Enregistre : {row['date_enregistrement']}\n\n")

        sections = [
            ("Discussion ConnectWise", "discussion"),
            ("Note Interne CW",        "note_interne"),
            ("Courriel Client",        "courriel_client"),
            ("Message Teams",          "teams"),
            ("Scripts Suggeres",       "scripts_suggeres"),
            ("Diagnostic",             "diagnostic"),
            ("Chronologie",            "chronologie"),
            ("Resume",                 "resume"),
        ]
        for titre, key in sections:
            contenu = row[key] or "(vide)"
            f.write(f"=== {titre} ===\n{contenu}\n\n")

    print(f"Exporte : {fname}")

print("Export termine.")
