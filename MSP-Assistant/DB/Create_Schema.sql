-- MSP-Assistant Schema SQLite v1.1
-- Chemin cible : C:\Intranet_EA\EA4AI\GPT-Enterprise\root_IA\MSP-Assistant\DB\
-- Corrige 2026-03-16 : suppression du texte Python REPL (>>>)

CREATE TABLE IF NOT EXISTS interventions (
    id                   INTEGER PRIMARY KEY AUTOINCREMENT,
    client               TEXT    NOT NULL,
    ticket               TEXT    NOT NULL,
    technicien           TEXT,
    debut                TEXT,
    fin                  TEXT,
    resume               TEXT,
    note_interne         TEXT,
    discussion           TEXT,
    courriel_client      TEXT,
    teams                TEXT,
    scripts_suggeres     TEXT,
    diagnostic           TEXT,
    chronologie          TEXT,
    date_enregistrement  TEXT DEFAULT (strftime('%Y-%m-%d %H:%M', 'now', 'localtime'))
);

CREATE INDEX IF NOT EXISTS idx_ticket ON interventions(ticket);
CREATE INDEX IF NOT EXISTS idx_client ON interventions(client);
CREATE INDEX IF NOT EXISTS idx_date   ON interventions(date_enregistrement);
