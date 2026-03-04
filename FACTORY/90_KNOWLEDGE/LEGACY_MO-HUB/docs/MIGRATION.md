# MIGRATION — EA4IA Clean

Date : 2025-12-27

Ce document liste les mouvements/archivages effectués pour produire ce repo clean.

## Déplacements & archivages (top-level)

- **MOVE** `registry.yaml` → `core/registry.yaml`
- **ARCHIVE** `registry_updated_with_IT.yaml` → `archive/root/registry_updated_with_IT.yaml`
- **ARCHIVE** `registry.yaml-02` → `archive/root/registry.yaml-02`
- **ARCHIVE** ` (2).gitattributes` → `archive/root/(2).gitattributes`
- **ARCHIVE** ` (3).gitattributes` → `archive/root/(3).gitattributes`
- **ARCHIVE** `changelog (1).md` → `archive/root/changelog (1).md`
- **ARCHIVE** `Copie de Hub_META_FactoryGPT.docx` → `archive/root/Copie de Hub_META_FactoryGPT.docx`
- **MOVE** `.gitattributes` → `.gitattributes`
- **MOVE** `docs/` → `docs/repo/`
- **MOVE** `prompts/` → `prompts/`
- **MOVE** `contracts/` → `contracts/`
- **MOVE** `09-Documents/` → `assets/branding/`
- **MOVE** `Pictures/` → `assets/images/`
- **MOVE** `Template/` → `assets/templates/`
- **ARCHIVE** `FIlesDOwnl/` → `archive/downloads/`
- **MOVE** `Hub_META_FactoryGPT.docx` → `docs/legacy/Hub_META_FactoryGPT.docx`
- **MOVE** `tests/` → `teams/it/tests/`
- **MOVE** `@DAM/` → `teams/dam/`
- **MOVE** `@Media-Radio/` → `teams/radio/`
- **MOVE** `@Psy-Relations/` → `teams/iasm/`
- **MOVE** `@NEA/` → `teams/nea/`
- **MOVE** `@NEA_Redaction_TEST/` → `teams/nea/redaction_test/`
- **MOVE** `@Finance-Crypto/` → `teams/trad/finance-crypto/`
- **MOVE** `@Master/` → `teams/hub/master/`
## Extraction de docs utiles depuis les téléchargements

- **MOVE** `archive/downloads/NAMING__IDS.md` → `docs/governance/NAMING__IDS.md`
- **MOVE** `archive/downloads/decision_log.md` → `docs/governance/decision_log.md`
- **MOVE** `archive/downloads/policy__approvals.md` → `docs/governance/policy__approvals.md`
- **MOVE** `archive/downloads/changelog.md` → `docs/governance/CHANGELOG_legacy.md`
- **MOVE** `archive/downloads/RUNBOOK__add_agent.md` → `docs/runbooks/RUNBOOK__add_agent.md`
- **MOVE** `archive/downloads/PLAYBOOK__MO.md` → `docs/playbooks/PLAYBOOK__MO.md`
- **MOVE** `archive/downloads/capability_map.yaml` → `core/extensions/capability_map.yaml`
- **ARCHIVE** `archive/downloads/capability_map (1).yaml` → `archive/downloads/variants/capability_map (1).yaml`
- **MOVE** `archive/downloads/teams_index.yaml` → `core/extensions/teams_index.yaml`
- **ARCHIVE** `archive/downloads/teams_index (1).yaml` → `archive/downloads/variants/teams_index (1).yaml`
- **ARCHIVE** `archive/downloads/teams_index (2).yaml` → `archive/downloads/variants/teams_index (2).yaml`
- **MOVE** `archive/downloads/TEAM__meta.yaml` → `docs/reference/teams/TEAM__meta.yaml`
- **ARCHIVE** `archive/downloads/TEAM__meta (1).yaml` → `archive/downloads/variants/TEAM__meta (1).yaml`
- **MOVE** `archive/downloads/TEAM__iahq.yaml` → `docs/reference/teams/TEAM__iahq.yaml`
- **MOVE** `archive/downloads/registry_it_comms_renamed.yaml` → `docs/reference/registries/registry_it_comms_renamed.yaml`
- **ARCHIVE** `archive/downloads/registry_it_comms_renamed (1).yaml` → `archive/downloads/variants/registry_it_comms_renamed (1).yaml`
- **MOVE** `archive/downloads/registry_it_comms_renamed_with_alias.yaml` → `docs/reference/registries/registry_it_comms_renamed_with_alias.yaml`
- **ARCHIVE** `archive/downloads/registry_it_comms_renamed_with_alias (1).yaml` → `archive/downloads/variants/registry_it_comms_renamed_with_alias (1).yaml`
- **ARCHIVE** `archive/downloads/policy__approvals (1).md` → `archive/downloads/variants/policy__approvals (1).md`
## Doublons exacts déplacés vers archive/duplicates

- **ARCHIVE** `teams/dam/Copie de Procédure verification  complete.docx` → `archive/duplicates/teams/dam/Copie de Procédure verification  complete.docx`
- **ARCHIVE** `teams/dam/Description précise v2- reformater (pdf).docx` → `archive/duplicates/teams/dam/Description précise v2- reformater (pdf).docx`
- **ARCHIVE** `teams/dam/Description précise v2- reformater (pdf).docx` → `archive/duplicates/teams/dam/Description précise v2- reformater (pdf).docx`
- **ARCHIVE** `teams/dam/Equipe_Claude/Copie de reformater (pdf).docx` → `archive/duplicates/teams/dam/Equipe_Claude/Copie de reformater (pdf).docx`
- **ARCHIVE** `teams/dam/Equipe_Claude/Document initial (1).pdf` → `archive/duplicates/teams/dam/Equipe_Claude/Document initial (1).pdf`
- **ARCHIVE** `teams/dam/Equipe_Claude/Procedure complete (2).pdf` → `archive/duplicates/teams/dam/Equipe_Claude/Procedure complete (2).pdf`
- **ARCHIVE** `teams/iasm/00-Overview/Description-equipe-IT/CréationDeLequipe.txt` → `archive/duplicates/teams/iasm/00-Overview/Description-equipe-IT/CréationDeLequipe.txt`
- **ARCHIVE** `assets/images/DALL·E 2025-12-02 16.43.35 - A professional, modern, and elegant digital icon representing the identity of an AI chatbot named 'IT-SecurityMaster'. The image should visually conve.webp` → `archive/duplicates/assets/images/DALL·E 2025-12-02 16.43.35 - A professional, modern, and elegant digital icon representing the identity of an AI chatbot named 'IT-SecurityMaster'. The image should visually conve.webp`
- **ARCHIVE** `assets/images/DALL·E 2025-12-02 16.53.19 - A professional, modern, and elegant digital icon representing the identity of an AI chatbot named 'GPT ScriptMaster'. The image should visually convey.webp` → `archive/duplicates/assets/images/DALL·E 2025-12-02 16.53.19 - A professional, modern, and elegant digital icon representing the identity of an AI chatbot named 'GPT ScriptMaster'. The image should visually convey.webp`
- **ARCHIVE** `assets/images/DALL·E 2025-12-02 16.53.27 - A professional, modern, and elegant digital icon representing the identity of an AI chatbot named 'IT-CloudMaster'. The image should visually convey c.webp` → `archive/duplicates/assets/images/DALL·E 2025-12-02 16.53.27 - A professional, modern, and elegant digital icon representing the identity of an AI chatbot named 'IT-CloudMaster'. The image should visually convey c.webp`
- **ARCHIVE** `assets/images/DALL·E 2025-12-02 16.53.37 - A professional, modern, and elegant digital icon representing the identity of an AI chatbot named 'IT-NetworkMaster'. The image should visually convey.webp` → `archive/duplicates/assets/images/DALL·E 2025-12-02 16.53.37 - A professional, modern, and elegant digital icon representing the identity of an AI chatbot named 'IT-NetworkMaster'. The image should visually convey.webp`
- **ARCHIVE** `assets/images/DALL·E 2025-12-02 16.53.54 - A professional, modern, and elegant digital icon representing the identity of an AI chatbot named 'IT-SupportMaster'. The image should visually convey.webp` → `archive/duplicates/assets/images/DALL·E 2025-12-02 16.53.54 - A professional, modern, and elegant digital icon representing the identity of an AI chatbot named 'IT-SupportMaster'. The image should visually convey.webp`
- **ARCHIVE** `assets/images/DALL·E 2025-12-02 17.09.33 - A professional and sleek digital icon representing an AI assistant named 'PromptInterne'. The icon should reflect the concept of internal prompt engin.webp` → `archive/duplicates/assets/images/DALL·E 2025-12-02 17.09.33 - A professional and sleek digital icon representing an AI assistant named 'PromptInterne'. The icon should reflect the concept of internal prompt engin.webp`
- **ARCHIVE** `assets/images/DALL·E 2025-12-02 17.11.26 - A powerful, professional digital icon representing an AI assistant named 'IT-DirecteurTechnic'. The image should evoke leadership, control, and high-l.webp` → `archive/duplicates/assets/images/DALL·E 2025-12-02 17.11.26 - A powerful, professional digital icon representing an AI assistant named 'IT-DirecteurTechnic'. The image should evoke leadership, control, and high-l.webp`
- **ARCHIVE** `assets/images/DALL·E 2025-12-02 17.10.16 - A powerful, professional digital icon representing an AI assistant named 'IT-DirecteurTechnic'. The image should evoke leadership, control, and high-l.webp` → `archive/duplicates/assets/images/DALL·E 2025-12-02 17.10.16 - A powerful, professional digital icon representing an AI assistant named 'IT-DirecteurTechnic'. The image should evoke leadership, control, and high-l.webp`
- **ARCHIVE** `assets/images/DALL·E 2025-12-02 17.10.19 - A powerful, professional digital icon representing an AI assistant named 'IT-DirecteurTechnic'. The image should evoke leadership, control, and high-l.webp` → `archive/duplicates/assets/images/DALL·E 2025-12-02 17.10.19 - A powerful, professional digital icon representing an AI assistant named 'IT-DirecteurTechnic'. The image should evoke leadership, control, and high-l.webp`
## Copies nommées déplacées vers archive/copies

- **ARCHIVE** `teams/dam/Copie de Procédure verification  complete.docx` → `archive/copies/teams/dam/Copie de Procédure verification  complete.docx`
