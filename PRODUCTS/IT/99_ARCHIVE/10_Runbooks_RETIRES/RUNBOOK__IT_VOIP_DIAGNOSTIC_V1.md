# RUNBOOK — Diagnostic Téléphonie IP & VoIP MSP
**ID :** RUNBOOK__IT_VOIP_DIAGNOSTIC_V1  
**Version :** 1.0 | **Agent :** IT-VoIPMaster  
**Applicable :** Tout incident VoIP/UC (3CX, Teams Phone, SIP trunk, qualité audio)

---

## DÉCLENCHEURS
- Plainte qualité audio (écho, coupures, one-way audio)
- Téléphones ne s'enregistrent plus (registration failure)
- Trunk SIP en échec / pas de tonalité externe
- Teams Phone : appels entrants/sortants impossibles
- Dégradation MOS signalée par utilisateurs

---

## ÉTAPE 1 — QUALIFICATION INITIALE (5 min)

Répondre aux questions :
1. Quel système VoIP ? (3CX / Teams Phone / Cisco CUCM / Mitel / RingCentral / autre)
2. Symptôme précis ? (pas de son / son unidirectionnel / écho / coupures / registration fail)
3. Affecté : 1 poste / un site complet / tous les sites ?
4. Depuis quand ? Changement récent ? (mise à jour, changement réseau, nouveau fournisseur SIP)
5. Appels internes affectés ? Externes ? Les deux ?

**Diagnostic préliminaire :**
- Interne seulement → problème PBX/VLAN/config locale
- Externe seulement → problème trunk SIP / fournisseur
- Interne + externe → problème réseau/QoS ou PBX global

---

## ÉTAPE 2 — TESTS RÉSEAU (10-15 min)

### 2.1 Test latence et jitter vers trunk SIP
```powershell
# Test ping vers IP du trunk SIP (remplacer X.X.X.X)
# ⚠️ Info : lecture seule, aucun impact
Test-NetConnection -ComputerName "sip.provider.com" -Port 5060

# Ping continu pour mesurer jitter
ping -t sip.provider.com | Measure-Object
```

**Seuils :**
- Latence OK : < 80ms | Warning : 80-150ms | Critique : > 150ms
- Packet loss OK : 0% | Warning : 0.5-1% | Critique : > 1%

### 2.2 Vérifier VLAN Voice
```powershell
# Vérifier configuration réseau sur poste VoIP
ipconfig /all | Select-String "IPv4|VLAN"
# Confirmer VLAN Voice séparé du data (bonne pratique)
```

### 2.3 Vérifier QoS
- Confirmer DSCP EF (46) taggé pour flux RTP
- Confirmer politique QoS active sur switch/routeur
- Sur switch Cisco : `show mls qos interface` ou `show policy-map interface`

---

## ÉTAPE 3 — DIAGNOSTIC PAR SYMPTÔME

### Symptôme A : Registration SIP échoue
```
Causes probables :
1. Credentials SIP incorrects (username/password/domain)
2. Firewall bloque UDP 5060 ou TCP 5061
3. NAT traversal mal configuré (STUN/TURN)
4. Serveur SIP inaccessible (résolution DNS)

Tests :
- Depuis PBX : nslookup sip.provider.com
- Wireshark sur port 5060 : capture 401 Unauthorized vs timeout
- Tester depuis hors NAT (connexion directe) pour isoler NAT
```

### Symptôme B : Audio unidirectionnel (one-way audio)
```
Cause quasi-certaine : problème NAT / RTP ports bloqués

Tests :
- Vérifier port range RTP ouvert (typique : UDP 10000-20000)
- Vérifier STUN server configuré dans PBX
- Tester avec softphone sur réseau différent
- Wireshark : flux RTP reçu d'un seul côté
```

### Symptôme C : Écho ou délai
```
Causes probables :
1. Latence WAN > 150ms → écho perceptible
2. AEC (Acoustic Echo Cancellation) désactivé sur téléphone
3. Haut-parleur trop fort côté distant

Tests :
- Mesurer latence vers trunk SIP (voir 2.1)
- Vérifier paramètres AEC dans config téléphone/PBX
- Tester avec casque vs haut-parleur
```

### Symptôme D : Teams Phone ne fonctionne pas
```
Checklist spécifique :
- Licence Phone System attribuée à l'utilisateur ? (Azure AD Admin Center)
- Direct Routing : SBC certifié et certificat valide ?
- Dial plan configuré ? (normalization rules)
- Voice routing policy assignée à l'utilisateur ?

Commandes PowerShell Teams :
# Vérifier licence
Get-MsolUser -UserPrincipalName user@domain.com | Select-Object Licenses
# Vérifier politique voix
Get-CsOnlineUser user@domain.com | Select-Object TeamsUpgradeMode, VoiceRoutingPolicy
```

---

## ÉTAPE 4 — VÉRIFICATIONS 3CX SPÉCIFIQUES

```
Dashboard 3CX :
- Status → Trunks : vérifier statut trunk (Registered/Unregistered)
- Status → Phones : vérifier registrations
- Logs → SIP trace : activer 5 min pour capturer erreurs

Ports à vérifier ouverts vers 3CX :
- TCP 5090 (Tunnel)
- UDP 9000-10999 (RTP media)
- TCP/UDP 5060-5061 (SIP)
- TCP 443, 5000-5001 (Web/Apps)
```

---

## ÉTAPE 5 — RÉSOLUTION ET DOCUMENTATION

### Après résolution :
- [ ] Test appel entrant + sortant validé
- [ ] Test qualité audio (MOS > 3.5 minimum, > 4.0 idéal)
- [ ] Documentation dans CW via IT-TicketScribe
- [ ] KB créé si problème non documenté

### Si non résolu :
- Escalader vers IT-NetworkMaster (problème réseau/QoS confirmé)
- Escalader vers IT-CloudMaster (Teams Phone/M365)
- Contacter fournisseur SIP trunk (si trunk side)
