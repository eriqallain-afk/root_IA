import sqlite3
import os
import sys
import json
from datetime import datetime

# ============================================================
# insert_entry.py — MSP-Assistant v1.1
# Modes :
#   1. import + save_intervention(dict)
#   2. CLI : python insert_entry.py intervention.json
# ============================================================

BASE_PATH = r"C:\Intranet_EA\EA4AI\GPT-Enterprise\root_IA\MSP-Assistant"
DB_PATH   = os.path.join(BASE_PATH, "DB", "msp_assistant.db")

FIELDS = [
    "client", "ticket", "technicien", "debut", "fin",
    "resume", "note_interne", "discussion", "courriel_client",
    "teams", "scripts_suggeres", "diagnostic", "chronologie"
]

def save_intervention(data: dict) -> int:
    """
    Insere une intervention dans la DB.
    data = dict avec les cles de FIELDS (les manquants = "")
    Retourne l'id insere.
    """
    conn   = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    cursor.execute("""
        INSERT INTO interventions (
            client, ticket, technicien, debut, fin, resume,
            note_interne, discussion, courriel_client, teams,
            scripts_suggeres, diagnostic, chronologie, date_enregistrement
        ) VALUES (
            :client, :ticket, :technicien, :debut, :fin, :resume,
            :note_interne, :discussion, :courriel_client, :teams,
            :scripts_suggeres, :diagnostic, :chronologie, :date_enregistrement
        )
    """, {
        **{k: data.get(k, "") for k in FIELDS},
        "date_enregistrement": datetime.now().strftime("%Y-%m-%d %H:%M")
    })

    new_id = cursor.lastrowid
    conn.commit()
    conn.close()
    print(f"Intervention #{new_id} sauvegardee — ticket : {data.get('ticket','?')}")
    return new_id


if __name__ == "__main__":
    # Mode CLI : python insert_entry.py <fichier.json>
    if len(sys.argv) == 2 and sys.argv[1].endswith(".json"):
        json_path = sys.argv[1]
        if not os.path.exists(json_path):
            print(f"Erreur : fichier JSON introuvable : {json_path}")
            sys.exit(1)
        with open(json_path, "r", encoding="utf-8") as f:
            data = json.load(f)
        save_intervention(data)

    else:
        # Mode demo
        save_intervention({
            "client":          "Client Demo",
            "ticket":          "CW-TEST-001",
            "technicien":      "Tech Demo",
            "debut":           datetime.now().strftime("%Y-%m-%d %H:%M"),
            "fin":             datetime.now().strftime("%Y-%m-%d %H:%M"),
            "resume":          "Test insertion CLI",
            "note_interne":    "Note interne test",
            "discussion":      "Discussion CW test",
            "courriel_client": "Courriel test",
            "teams":           "Teams test",
            "scripts_suggeres": "",
            "diagnostic":      "Diagnostic test",
            "chronologie":     "Chronologie test"
        })
