# IT-Technicien — Exemples d’usage (5)

> Les exemples utilisent des placeholders (CLIENT_X, SERVER01, user@domaine.tld) et ne contiennent aucun secret.

---

## Scénario 1 — NOC : serveur en alerte (disque plein)

**Entrée (ticket)**
- « CLIENT_X — Alerte RMM : espace disque faible sur SERVER01. Impact : applications lentes. »

**Sortie (attendue)**
- **Catégorie** : NOC (alerte capacité / stockage)
- **Diagnostic probable**
  - Volume système proche du seuil → dégradation performance / services
  - Fichiers temporaires / logs qui gonflent
- **Checklist SUGGESTION**
  1) Vérifier RMM : volumes, seuils, croissance récente
  2) Vérifier journaux/erreurs disque et services impactés
  3) Identifier top consommateurs (dossiers) et confirmer politique de nettoyage
  4) Nettoyage contrôlé (temp/log) ou extension volume (si approuvé)
  5) Valider santé services + retour monitoring
- **Validations**
  - Espace libre au-dessus du seuil
  - Services/app OK, alertes RMM revenues à normal
- **POUR COPILOT**
  - /obs RMM : volume C: sous seuil (détails à confirmer)
  - /fait [À CONFIRMER] Analyse top consommateurs effectuée
  - /test Vérification alertes RMM revenues à normal [À CONFIRMER]
  - items_a_confirmer: ["Quel volume exact et seuil ?", "Action autorisée : nettoyage vs extension ?"]

---

## Scénario 2 — NOC : sauvegarde en échec

**Entrée (ticket)**
- « CLIENT_X — Job de sauvegarde en échec depuis 2 jours. »

**Sortie (attendue)**
- **Catégorie** : NOC (sauvegardes)
- **Diagnostic probable**
  - Espace repository insuffisant
  - Erreur réseau/timeout
  - Agent/service de sauvegarde en erreur
- **Checklist SUGGESTION**
  1) Vérifier dernier succès + code erreur (sans logs bruts)
  2) Vérifier capacité repository et rétention
  3) Vérifier connectivité/état proxy/agent
  4) Corriger cause (espace/service) puis relancer job si autorisé
  5) Valider succès et plan de rattrapage
- **Validations**
  - Job terminé “Success”
  - Point de restauration présent et cohérent
- **POUR COPILOT**
  - /obs Job en échec depuis 2 jours (outil à préciser)
  - /fait [À CONFIRMER] Vérification code erreur effectuée
  - /test Job relancé et succès [À CONFIRMER]
  - items_a_confirmer: ["Quel outil de backup ?", "Erreur exacte ?", "Repository espace OK ?"]

---

## Scénario 3 — SOC : détection antivirus

**Entrée (ticket)**
- « CLIENT_X — Alerte AV : malware détecté sur un poste utilisateur. »

**Sortie (attendue)**
- **Catégorie** : SOC (alerte sécurité)
- **Diagnostic probable**
  - Détection vraie positive ou PUA
  - Téléchargement/extension navigateur
- **Checklist SUGGESTION**
  1) Confirmer alerte (nom détection, chemin) — sans copier logs bruts
  2) Selon politique : isoler poste (si outil le permet)
  3) Lancer scan complet / remédiation
  4) Vérifier récurrence et périmètre (autres endpoints)
  5) Recommandations prévention (updates, sensibilisation)
- **Validations**
  - Endpoint “Clean” / aucune alerte active
  - Scan complet OK
- **Risques / précautions**
  - Si signes de propagation/exfiltration → **[ESCALADE REQUISE]**
- **POUR COPILOT**
  - /obs Alerte AV reçue (détails détection à confirmer)
  - /fait [À CONFIRMER] Remédiation AV lancée
  - /test Scan complet terminé sans menace [À CONFIRMER]
  - items_a_confirmer: ["Nom de la détection ?", "Isoler endpoint requis (politique) ?"]

---

## Scénario 4 — SOC : connexion bloquée au firewall

**Entrée (ticket)**
- « CLIENT_X — L’accès à un service externe est bloqué. Demande de déblocage au firewall. »

**Sortie (attendue)**
- **Catégorie** : SOC (firewall / filtrage)
- **Diagnostic probable**
  - Règle de filtrage sortante
  - Catégorie WebFilter
  - DNS/URL bloquée
- **Checklist SUGGESTION**
  1) Obtenir info minimale : source, destination, port, protocole, durée (temporaire ?)
  2) Vérifier logs firewall sur la fenêtre concernée
  3) Appliquer exception/règle la plus restrictive possible (si approuvé)
  4) Tester l’accès, documenter résultat
  5) Revoir et retirer règle temporaire si applicable
- **Validations**
  - Test d’accès OK
  - Logs montrent trafic autorisé
- **POUR COPILOT**
  - /obs Demande déblocage firewall (service externe)
  - /fait [À CONFIRMER] Analyse logs firewall effectuée
  - /test Accès au service validé [À CONFIRMER]
  - items_a_confirmer: ["Source ?", "Destination/URL/IP ?", "Port/protocole ?", "Règle temporaire (oui/non) ?"]

---

## Scénario 5 — SUPPORT : ajout utilisateur Microsoft 365

**Entrée (ticket)**
- « CLIENT_X — Créer un nouvel utilisateur M365 pour arrivée lundi. Licence Business Standard. »

**Sortie (attendue)**
- **Catégorie** : SUPPORT (M365 / comptes)
- **Checklist SUGGESTION**
  1) Créer compte utilisateur et attribuer licence demandée
  2) Ajouter groupes et accès selon rôle (minimum requis)
  3) Configurer MFA selon standards
  4) Vérifier boîte aux lettres/Exchange si applicable
  5) Envoyer instructions de première connexion (client-safe)
- **Validations**
  - Connexion réussie
  - Licence appliquée
- **POUR COPILOT**
  - /obs Demande création utilisateur M365 (licence Business Standard)
  - /fait [À CONFIRMER] Compte créé + licence appliquée
  - /test Connexion utilisateur validée [À CONFIRMER]
  - items_a_confirmer: ["Nom/UPN ?", "Groupes/rôle ?", "MFA requis (politique) ?"]
