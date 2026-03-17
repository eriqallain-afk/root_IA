import sqlite3
import os

# ============================================================
# create_db.py — MSP-Assistant v1.1
# Chemin cible corrige (ex C:\MSP-Assistant)
# ============================================================

BASE_PATH = r"C:\Intranet_EA\EA4AI\GPT-Enterprise\root_IA\MSP-Assistant"
DB_FILE   = os.path.join(BASE_PATH, "DB", "msp_assistant.db")
SQL_FILE  = os.path.join(BASE_PATH, "DB", "Create_Schema.sql")

os.makedirs(os.path.dirname(DB_FILE), exist_ok=True)

conn   = sqlite3.connect(DB_FILE)
cursor = conn.cursor()

with open(SQL_FILE, "r", encoding="utf-8") as f:
    # Filtrer les lignes de commentaires pour executescript
    sql = "\n".join(
        line for line in f.read().splitlines()
        if not line.strip().startswith("--")
    )
    cursor.executescript(sql)

conn.commit()
conn.close()
print("Base creee :", DB_FILE)
