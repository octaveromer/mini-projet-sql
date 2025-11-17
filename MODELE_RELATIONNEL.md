# Modèle Relationnel - Clinique Dentaire Dentissimo

## 1. FRANCHISE
Gestion des différentes franchises de la clinique.

```
FRANCHISE(
    id_franchise: NUMBER [PK],
    nom: VARCHAR2(100) [NOT NULL],
    adresse: VARCHAR2(200) [NOT NULL],
    ville: VARCHAR2(100) [NOT NULL],
    code_postal: VARCHAR2(10) [NOT NULL],
    telephone: VARCHAR2(15),
    email: VARCHAR2(100),
    date_ouverture: DATE
)
```

**Contraintes:**
- PK: `id_franchise`
- UNIQUE: `email`

---

## 2. PATIENT
Informations personnelles des patients.

```
PATIENT(
    id_patient: NUMBER [PK],
    nom: VARCHAR2(100) [NOT NULL],
    prenom: VARCHAR2(100) [NOT NULL],
    date_naissance: DATE [NOT NULL],
    sexe: CHAR(1) [CHECK sexe IN ('M', 'F')],
    adresse: VARCHAR2(200),
    ville: VARCHAR2(100),
    code_postal: VARCHAR2(10),
    telephone: VARCHAR2(15),
    email: VARCHAR2(100),
    numero_securite_sociale: VARCHAR2(15) [UNIQUE],
    date_inscription: DATE DEFAULT SYSDATE,
    id_franchise: NUMBER [FK -> FRANCHISE]
)
```

**Contraintes:**
- PK: `id_patient`
- FK: `id_franchise` REFERENCES `FRANCHISE(id_franchise)`
- UNIQUE: `numero_securite_sociale`
- CHECK: `sexe IN ('M', 'F')`

---

## 3. PERSONNEL
Informations sur le personnel interne et les praticiens externes.

```
PERSONNEL(
    id_personnel: NUMBER [PK],
    nom: VARCHAR2(100) [NOT NULL],
    prenom: VARCHAR2(100) [NOT NULL],
    type_personnel: VARCHAR2(50) [NOT NULL] [CHECK type_personnel IN ('Dentiste', 'Assistant', 'Hygieniste', 'Praticien_Externe')],
    specialite: VARCHAR2(100),
    telephone: VARCHAR2(15),
    email: VARCHAR2(100) [UNIQUE],
    date_embauche: DATE,
    salaire: NUMBER(10,2),
    est_externe: CHAR(1) DEFAULT 'N' [CHECK est_externe IN ('O', 'N')],
    id_franchise: NUMBER [FK -> FRANCHISE]
)
```

**Contraintes:**
- PK: `id_personnel`
- FK: `id_franchise` REFERENCES `FRANCHISE(id_franchise)`
- UNIQUE: `email`
- CHECK: `type_personnel IN ('Dentiste', 'Assistant', 'Hygieniste', 'Praticien_Externe')`
- CHECK: `est_externe IN ('O', 'N')`

---

## 4. DOSSIER_PATIENT
Dossier médical associé à un patient.

```
DOSSIER_PATIENT(
    id_dossier: NUMBER [PK],
    id_patient: NUMBER [FK -> PATIENT] [NOT NULL],
    date_creation: DATE DEFAULT SYSDATE [NOT NULL],
    date_derniere_modification: DATE,
    statut: VARCHAR2(20) DEFAULT 'Ouvert' [CHECK statut IN ('Ouvert', 'Ferme')],
    motif_consultation: VARCHAR2(500),
    notes_generales: CLOB,
    allergies: VARCHAR2(500),
    antecedents_medicaux: CLOB
)
```

**Contraintes:**
- PK: `id_dossier`
- FK: `id_patient` REFERENCES `PATIENT(id_patient)`
- CHECK: `statut IN ('Ouvert', 'Ferme')`

---

## 5. TRAITEMENT
Historique des traitements effectués pour chaque dossier patient.

```
TRAITEMENT(
    id_traitement: NUMBER [PK],
    id_dossier: NUMBER [FK -> DOSSIER_PATIENT] [NOT NULL],
    date_debut: DATE [NOT NULL],
    date_fin: DATE,
    description: VARCHAR2(500),
    cout_total: NUMBER(10,2) DEFAULT 0,
    statut: VARCHAR2(20) DEFAULT 'En cours' [CHECK statut IN ('En cours', 'Termine', 'Annule')],
    notes: CLOB
)
```

**Contraintes:**
- PK: `id_traitement`
- FK: `id_dossier` REFERENCES `DOSSIER_PATIENT(id_dossier)`
- CHECK: `statut IN ('En cours', 'Termine', 'Annule')`
- CHECK: `date_fin >= date_debut` (si date_fin NOT NULL)

---

## 6. ACTE_MEDICAL
Détails des actes médicaux réalisés lors des traitements.

```
ACTE_MEDICAL(
    id_acte: NUMBER [PK],
    id_traitement: NUMBER [FK -> TRAITEMENT] [NOT NULL],
    id_personnel: NUMBER [FK -> PERSONNEL] [NOT NULL],
    date_acte: DATE DEFAULT SYSDATE [NOT NULL],
    type_acte: VARCHAR2(100) [NOT NULL],
    description: VARCHAR2(500),
    montant: NUMBER(10,2) [NOT NULL],
    duree_minutes: NUMBER(5),
    notes: VARCHAR2(500)
)
```

**Contraintes:**
- PK: `id_acte`
- FK: `id_traitement` REFERENCES `TRAITEMENT(id_traitement)`
- FK: `id_personnel` REFERENCES `PERSONNEL(id_personnel)`
- CHECK: `montant >= 0`
- CHECK: `duree_minutes > 0`

---

## 7. RADIOGRAPHIE
Radiographies associées aux actes médicaux.

```
RADIOGRAPHIE(
    id_radiographie: NUMBER [PK],
    id_acte: NUMBER [FK -> ACTE_MEDICAL] [NOT NULL],
    type_radio: VARCHAR2(50) [NOT NULL] [CHECK type_radio IN ('Panoramique', 'Retroalveolaire', 'Cone Beam')],
    date_radio: DATE DEFAULT SYSDATE,
    fichier_image: VARCHAR2(500),
    observations: VARCHAR2(500)
)
```

**Contraintes:**
- PK: `id_radiographie`
- FK: `id_acte` REFERENCES `ACTE_MEDICAL(id_acte)`
- CHECK: `type_radio IN ('Panoramique', 'Retroalveolaire', 'Cone Beam')`

---

## 8. PRESCRIPTION
Prescriptions médicales associées aux actes.

```
PRESCRIPTION(
    id_prescription: NUMBER [PK],
    id_acte: NUMBER [FK -> ACTE_MEDICAL] [NOT NULL],
    date_prescription: DATE DEFAULT SYSDATE,
    medicament: VARCHAR2(200) [NOT NULL],
    dosage: VARCHAR2(100),
    duree_traitement: VARCHAR2(100),
    instructions: VARCHAR2(500)
)
```

**Contraintes:**
- PK: `id_prescription`
- FK: `id_acte` REFERENCES `ACTE_MEDICAL(id_acte)`

---

## 9. DENT
Représentation de chaque dent d'un patient (système FDI).

```
DENT(
    id_dent: NUMBER [PK],
    id_patient: NUMBER [FK -> PATIENT] [NOT NULL],
    code_fdi: NUMBER(2) [NOT NULL] [CHECK code_fdi BETWEEN 11 AND 85],
    type_dent: VARCHAR2(20) [CHECK type_dent IN ('Incisive', 'Canine', 'Premolaire', 'Molaire')],
    position: VARCHAR2(50),
    date_enregistrement: DATE DEFAULT SYSDATE
)
```

**Contraintes:**
- PK: `id_dent`
- FK: `id_patient` REFERENCES `PATIENT(id_patient)`
- UNIQUE: `(id_patient, code_fdi)`
- CHECK: `code_fdi BETWEEN 11 AND 85`
- CHECK: `type_dent IN ('Incisive', 'Canine', 'Premolaire', 'Molaire')`

---

## 10. ANOMALIE
Types d'anomalies dentaires.

```
ANOMALIE(
    id_anomalie: NUMBER [PK],
    type_anomalie: VARCHAR2(100) [NOT NULL],
    description: VARCHAR2(500),
    gravite: VARCHAR2(20) [CHECK gravite IN ('Legere', 'Moderee', 'Severe', 'Critique')]
)
```

**Contraintes:**
- PK: `id_anomalie`
- UNIQUE: `type_anomalie`
- CHECK: `gravite IN ('Legere', 'Moderee', 'Severe', 'Critique')`

---

## 11. RESTAURATION
Types de restaurations dentaires.

```
RESTAURATION(
    id_restauration: NUMBER [PK],
    type_restauration: VARCHAR2(100) [NOT NULL],
    materiau: VARCHAR2(100),
    duree_vie_estimee_mois: NUMBER(5),
    description: VARCHAR2(500)
)
```

**Contraintes:**
- PK: `id_restauration`
- UNIQUE: `type_restauration`
- CHECK: `duree_vie_estimee_mois > 0`

---

## 12. ETAT_DENT
Historique de l'état de chaque dent à un moment précis.

```
ETAT_DENT(
    id_etat_dent: NUMBER [PK],
    id_dent: NUMBER [FK -> DENT] [NOT NULL],
    id_acte: NUMBER [FK -> ACTE_MEDICAL],
    date_observation: DATE DEFAULT SYSDATE [NOT NULL],
    etat_general: VARCHAR2(20) [CHECK etat_general IN ('Saine', 'Atteinte', 'Traitee', 'Extraite')],
    notes: VARCHAR2(500)
)
```

**Contraintes:**
- PK: `id_etat_dent`
- FK: `id_dent` REFERENCES `DENT(id_dent)`
- FK: `id_acte` REFERENCES `ACTE_MEDICAL(id_acte)` (nullable)
- CHECK: `etat_general IN ('Saine', 'Atteinte', 'Traitee', 'Extraite')`

---

## 13. ETAT_DENT_ANOMALIE
Association entre un état de dent et les anomalies détectées (relation N:M).

```
ETAT_DENT_ANOMALIE(
    id_etat_dent: NUMBER [FK -> ETAT_DENT],
    id_anomalie: NUMBER [FK -> ANOMALIE],
    date_detection: DATE DEFAULT SYSDATE,
    stade: VARCHAR2(50),
    observations: VARCHAR2(500)
)
```

**Contraintes:**
- PK: `(id_etat_dent, id_anomalie)`
- FK: `id_etat_dent` REFERENCES `ETAT_DENT(id_etat_dent)`
- FK: `id_anomalie` REFERENCES `ANOMALIE(id_anomalie)`

---

## 14. ETAT_DENT_RESTAURATION
Association entre un état de dent et les restaurations effectuées (relation N:M).

```
ETAT_DENT_RESTAURATION(
    id_etat_dent: NUMBER [FK -> ETAT_DENT],
    id_restauration: NUMBER [FK -> RESTAURATION],
    date_restauration: DATE DEFAULT SYSDATE,
    materiau_utilise: VARCHAR2(100),
    cout: NUMBER(10,2),
    observations: VARCHAR2(500)
)
```

**Contraintes:**
- PK: `(id_etat_dent, id_restauration)`
- FK: `id_etat_dent` REFERENCES `ETAT_DENT(id_etat_dent)`
- FK: `id_restauration` REFERENCES `RESTAURATION(id_restauration)`
- CHECK: `cout >= 0`

---

## 15. PAIEMENT
Suivi des paiements pour les actes et traitements.

```
PAIEMENT(
    id_paiement: NUMBER [PK],
    id_traitement: NUMBER [FK -> TRAITEMENT] [NOT NULL],
    date_paiement: DATE DEFAULT SYSDATE [NOT NULL],
    montant: NUMBER(10,2) [NOT NULL],
    mode_paiement: VARCHAR2(50) [CHECK mode_paiement IN ('Especes', 'Carte', 'Cheque', 'Virement', 'Mutuelle')],
    statut: VARCHAR2(20) DEFAULT 'Effectue' [CHECK statut IN ('Effectue', 'En attente', 'Annule', 'Rembourse')],
    reference: VARCHAR2(100),
    notes: VARCHAR2(500)
)
```

**Contraintes:**
- PK: `id_paiement`
- FK: `id_traitement` REFERENCES `TRAITEMENT(id_traitement)`
- CHECK: `montant > 0`
- CHECK: `mode_paiement IN ('Especes', 'Carte', 'Cheque', 'Virement', 'Mutuelle')`
- CHECK: `statut IN ('Effectue', 'En attente', 'Annule', 'Rembourse')`

---

## 16. FOURNISSEUR
Informations sur les fournisseurs de produits dentaires.

```
FOURNISSEUR(
    id_fournisseur: NUMBER [PK],
    nom: VARCHAR2(100) [NOT NULL],
    adresse: VARCHAR2(200),
    ville: VARCHAR2(100),
    code_postal: VARCHAR2(10),
    telephone: VARCHAR2(15),
    email: VARCHAR2(100) [UNIQUE],
    contact_principal: VARCHAR2(100),
    notes: VARCHAR2(500)
)
```

**Contraintes:**
- PK: `id_fournisseur`
- UNIQUE: `email`

---

## 17. PRODUIT_DENTAIRE
Catalogue des produits dentaires et consommables.

```
PRODUIT_DENTAIRE(
    id_produit: NUMBER [PK],
    nom: VARCHAR2(200) [NOT NULL],
    type_produit: VARCHAR2(50) [NOT NULL],
    description: VARCHAR2(500),
    unite_mesure: VARCHAR2(20),
    stock_actuel: NUMBER(10,2) DEFAULT 0,
    stock_minimum: NUMBER(10,2) DEFAULT 0,
    prix_unitaire: NUMBER(10,2),
    id_fournisseur: NUMBER [FK -> FOURNISSEUR]
)
```

**Contraintes:**
- PK: `id_produit`
- FK: `id_fournisseur` REFERENCES `FOURNISSEUR(id_fournisseur)`
- CHECK: `stock_actuel >= 0`
- CHECK: `stock_minimum >= 0`
- CHECK: `prix_unitaire >= 0`

---

## 18. COMMANDE
Suivi des commandes passées aux fournisseurs.

```
COMMANDE(
    id_commande: NUMBER [PK],
    id_fournisseur: NUMBER [FK -> FOURNISSEUR] [NOT NULL],
    id_franchise: NUMBER [FK -> FRANCHISE] [NOT NULL],
    date_commande: DATE DEFAULT SYSDATE [NOT NULL],
    date_livraison_prevue: DATE,
    date_livraison_reelle: DATE,
    statut: VARCHAR2(20) DEFAULT 'En cours' [CHECK statut IN ('En cours', 'Livree', 'Annulee', 'Partielle')],
    montant_total: NUMBER(10,2) DEFAULT 0,
    notes: VARCHAR2(500)
)
```

**Contraintes:**
- PK: `id_commande`
- FK: `id_fournisseur` REFERENCES `FOURNISSEUR(id_fournisseur)`
- FK: `id_franchise` REFERENCES `FRANCHISE(id_franchise)`
- CHECK: `statut IN ('En cours', 'Livree', 'Annulee', 'Partielle')`
- CHECK: `montant_total >= 0`
- CHECK: `date_livraison_prevue >= date_commande`

---

## 19. LIGNE_COMMANDE
Détails des produits dans une commande (relation N:M).

```
LIGNE_COMMANDE(
    id_commande: NUMBER [FK -> COMMANDE],
    id_produit: NUMBER [FK -> PRODUIT_DENTAIRE],
    quantite: NUMBER(10,2) [NOT NULL],
    prix_unitaire: NUMBER(10,2) [NOT NULL],
    montant_ligne: NUMBER(10,2) [NOT NULL]
)
```

**Contraintes:**
- PK: `(id_commande, id_produit)`
- FK: `id_commande` REFERENCES `COMMANDE(id_commande)`
- FK: `id_produit` REFERENCES `PRODUIT_DENTAIRE(id_produit)`
- CHECK: `quantite > 0`
- CHECK: `prix_unitaire >= 0`
- CHECK: `montant_ligne = quantite * prix_unitaire`

---

## 20. EQUIPEMENT
Inventaire des équipements médicaux de la clinique.

```
EQUIPEMENT(
    id_equipement: NUMBER [PK],
    nom: VARCHAR2(200) [NOT NULL],
    type_equipement: VARCHAR2(100),
    numero_serie: VARCHAR2(100) [UNIQUE],
    date_acquisition: DATE,
    prix_acquisition: NUMBER(10,2),
    etat: VARCHAR2(20) DEFAULT 'Fonctionnel' [CHECK etat IN ('Fonctionnel', 'En maintenance', 'Hors service', 'En reparation')],
    date_derniere_maintenance: DATE,
    id_franchise: NUMBER [FK -> FRANCHISE]
)
```

**Contraintes:**
- PK: `id_equipement`
- FK: `id_franchise` REFERENCES `FRANCHISE(id_franchise)`
- UNIQUE: `numero_serie`
- CHECK: `etat IN ('Fonctionnel', 'En maintenance', 'Hors service', 'En reparation')`
- CHECK: `prix_acquisition >= 0`

---

## 21. UTILISATION_PRODUIT
Suivi de l'utilisation des produits lors des actes médicaux (relation N:M).

```
UTILISATION_PRODUIT(
    id_acte: NUMBER [FK -> ACTE_MEDICAL],
    id_produit: NUMBER [FK -> PRODUIT_DENTAIRE],
    quantite_utilisee: NUMBER(10,2) [NOT NULL],
    date_utilisation: DATE DEFAULT SYSDATE
)
```

**Contraintes:**
- PK: `(id_acte, id_produit)`
- FK: `id_acte` REFERENCES `ACTE_MEDICAL(id_acte)`
- FK: `id_produit` REFERENCES `PRODUIT_DENTAIRE(id_produit)`
- CHECK: `quantite_utilisee > 0`

---

## 22. UTILISATION_EQUIPEMENT
Suivi de l'utilisation des équipements lors des actes médicaux (relation N:M).

```
UTILISATION_EQUIPEMENT(
    id_acte: NUMBER [FK -> ACTE_MEDICAL],
    id_equipement: NUMBER [FK -> EQUIPEMENT],
    date_utilisation: DATE DEFAULT SYSDATE,
    duree_utilisation_minutes: NUMBER(5),
    notes: VARCHAR2(500)
)
```

**Contraintes:**
- PK: `(id_acte, id_equipement)`
- FK: `id_acte` REFERENCES `ACTE_MEDICAL(id_acte)`
- FK: `id_equipement` REFERENCES `EQUIPEMENT(id_equipement)`
- CHECK: `duree_utilisation_minutes > 0`

---

## Résumé des Relations

### Relations 1:N (One-to-Many)
1. **FRANCHISE** → **PATIENT** (Une franchise a plusieurs patients)
2. **FRANCHISE** → **PERSONNEL** (Une franchise emploie plusieurs membres du personnel)
3. **FRANCHISE** → **EQUIPEMENT** (Une franchise possède plusieurs équipements)
4. **FRANCHISE** → **COMMANDE** (Une franchise passe plusieurs commandes)
5. **PATIENT** → **DOSSIER_PATIENT** (Un patient peut avoir plusieurs dossiers)
6. **PATIENT** → **DENT** (Un patient a plusieurs dents)
7. **DOSSIER_PATIENT** → **TRAITEMENT** (Un dossier contient plusieurs traitements)
8. **TRAITEMENT** → **ACTE_MEDICAL** (Un traitement comprend plusieurs actes)
9. **TRAITEMENT** → **PAIEMENT** (Un traitement peut avoir plusieurs paiements)
10. **PERSONNEL** → **ACTE_MEDICAL** (Un praticien réalise plusieurs actes)
11. **ACTE_MEDICAL** → **RADIOGRAPHIE** (Un acte peut avoir plusieurs radiographies)
12. **ACTE_MEDICAL** → **PRESCRIPTION** (Un acte peut générer plusieurs prescriptions)
13. **ACTE_MEDICAL** → **ETAT_DENT** (Un acte peut concerner plusieurs états de dents)
14. **DENT** → **ETAT_DENT** (Une dent a plusieurs états historiques)
15. **FOURNISSEUR** → **PRODUIT_DENTAIRE** (Un fournisseur fournit plusieurs produits)
16. **FOURNISSEUR** → **COMMANDE** (Un fournisseur reçoit plusieurs commandes)

### Relations N:M (Many-to-Many)
1. **ETAT_DENT** ↔ **ANOMALIE** (via ETAT_DENT_ANOMALIE)
2. **ETAT_DENT** ↔ **RESTAURATION** (via ETAT_DENT_RESTAURATION)
3. **COMMANDE** ↔ **PRODUIT_DENTAIRE** (via LIGNE_COMMANDE)
4. **ACTE_MEDICAL** ↔ **PRODUIT_DENTAIRE** (via UTILISATION_PRODUIT)
5. **ACTE_MEDICAL** ↔ **EQUIPEMENT** (via UTILISATION_EQUIPEMENT)

---

## Normalisation

Le modèle respecte la **3ème Forme Normale (3NF)** :
- ✅ **1NF** : Toutes les valeurs sont atomiques, pas de groupes répétitifs
- ✅ **2NF** : Tous les attributs non-clés dépendent de la totalité de la clé primaire
- ✅ **3NF** : Aucune dépendance transitive (pas d'attribut non-clé dépendant d'un autre attribut non-clé)

---

## Index Recommandés

Pour optimiser les performances des requêtes :

```sql
-- Index sur les clés étrangères
CREATE INDEX idx_patient_franchise ON PATIENT(id_franchise);
CREATE INDEX idx_dossier_patient ON DOSSIER_PATIENT(id_patient);
CREATE INDEX idx_traitement_dossier ON TRAITEMENT(id_dossier);
CREATE INDEX idx_acte_traitement ON ACTE_MEDICAL(id_traitement);
CREATE INDEX idx_acte_personnel ON ACTE_MEDICAL(id_personnel);
CREATE INDEX idx_dent_patient ON DENT(id_patient);
CREATE INDEX idx_etat_dent ON ETAT_DENT(id_dent);
CREATE INDEX idx_paiement_traitement ON PAIEMENT(id_traitement);
CREATE INDEX idx_commande_fournisseur ON COMMANDE(id_fournisseur);

-- Index sur les dates fréquemment utilisées
CREATE INDEX idx_patient_date_inscription ON PATIENT(date_inscription);
CREATE INDEX idx_acte_date ON ACTE_MEDICAL(date_acte);
CREATE INDEX idx_paiement_date ON PAIEMENT(date_paiement);

-- Index composites
CREATE INDEX idx_dent_patient_code ON DENT(id_patient, code_fdi);
CREATE INDEX idx_traitement_dates ON TRAITEMENT(date_debut, date_fin);
```

---

## Notes Importantes

1. **Système FDI** : Le code FDI (Fédération Dentaire Internationale) utilise une numérotation de 11 à 85 pour identifier chaque dent.

2. **Gestion des stocks** : Le stock des produits doit être mis à jour automatiquement lors de l'utilisation (triggers recommandés).

3. **Calculs automatiques** : Les montants totaux (traitement, commande) peuvent être calculés via des triggers ou des vues.

4. **Historique** : Le modèle permet de tracer l'historique complet de l'état dentaire de chaque patient.

5. **Extensibilité** : Le modèle peut facilement être étendu pour ajouter de nouvelles fonctionnalités.
