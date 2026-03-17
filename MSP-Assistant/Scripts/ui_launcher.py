import sqlite3
import os
import tkinter as tk
from tkinter import ttk, messagebox

# ============================================================
# ui_launcher.py — MSP-Assistant v1.1
# Dashboard Tkinter pour visualiser les interventions
# ============================================================

BASE_PATH = r"C:\Intranet_EA\EA4AI\GPT-Enterprise\root_IA\MSP-Assistant"
DB_PATH   = os.path.join(BASE_PATH, "DB", "msp_assistant.db")

LABELS = [
    "ID", "Client", "Ticket", "Technicien", "Debut", "Fin",
    "Resume", "Note Interne", "Discussion", "Courriel Client",
    "Teams", "Scripts", "Diagnostic", "Chronologie", "Date enregistrement"
]

def load_data():
    if not os.path.exists(DB_PATH):
        messagebox.showerror("Erreur", f"DB introuvable :\n{DB_PATH}")
        return []
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute("SELECT id, client, ticket, technicien, debut, fin FROM interventions ORDER BY id DESC")
    rows = cursor.fetchall()
    conn.close()
    return rows

def open_row(event):
    item = tree.focus()
    if not item:
        return
    row_id = tree.item(item)["values"][0]
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM interventions WHERE id=?", (row_id,))
    row = cursor.fetchone()
    conn.close()
    if not row:
        return
    text.config(state=tk.NORMAL)
    text.delete("1.0", tk.END)
    for lbl, val in zip(LABELS, row):
        text.insert(tk.END, f"{'='*40}\n{lbl}\n{'='*40}\n{val or '(vide)'}\n\n")
    text.config(state=tk.DISABLED)

# ── UI ────────────────────────────────────────────────────────
root = tk.Tk()
root.title("MSP-Assistant — Dashboard")
root.geometry("1100x700")

# Frame haut : liste
frame_top = tk.Frame(root)
frame_top.pack(fill="both", expand=False, padx=10, pady=5)

tree = ttk.Treeview(
    frame_top,
    columns=("id", "client", "ticket", "tech", "debut", "fin"),
    show="headings", height=12
)
for col, name, w in [
    ("id","#",60), ("client","Client",180), ("ticket","Ticket",120),
    ("tech","Technicien",120), ("debut","Debut",130), ("fin","Fin",130)
]:
    tree.heading(col, text=name)
    tree.column(col, width=w)

scrollbar = ttk.Scrollbar(frame_top, orient="vertical", command=tree.yview)
tree.configure(yscrollcommand=scrollbar.set)
tree.pack(side="left", fill="both", expand=True)
scrollbar.pack(side="right", fill="y")

for row in load_data():
    tree.insert("", tk.END, values=row)

tree.bind("<Double-1>", open_row)

# Frame bas : detail
frame_bot = tk.Frame(root)
frame_bot.pack(fill="both", expand=True, padx=10, pady=5)

tk.Label(frame_bot, text="Detail de l'intervention (double-clic sur une ligne) :").pack(anchor="w")

text = tk.Text(frame_bot, wrap="word", state=tk.DISABLED)
sb2  = ttk.Scrollbar(frame_bot, orient="vertical", command=text.yview)
text.configure(yscrollcommand=sb2.set)
sb2.pack(side="right", fill="y")
text.pack(fill="both", expand=True)

root.mainloop()
