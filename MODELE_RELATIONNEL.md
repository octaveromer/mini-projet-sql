# Modèle Relationnel (MLD) - Clinique Dentaire Dentissimo

## Transformation du Modèle Conceptuel en Modèle Relationnel

---

## 1. Règles de Transformation MCD → MLD

### Règle 1 : Transformation des entités
Chaque entité devient une table avec :
- La clé primaire de l'entité devient la clé primaire de la table
- Tous les attributs simples deviennent des colonnes

### Règle 2 : Transformation des associations

#### Association 1:N (One-to-Many)
- La clé primaire du côté "1" devient clé étrangère du côté "N"
- Les attributs de l'association (s'il y en a) sont ajoutés au côté "N"

#### Association N:M (Many-to-Many)
- Création d'une table d'association
- Clé primaire composée des deux clés étrangères
- Les attributs de l'association deviennent des colonnes

#### Association 1:1 (One-to-One)
- Une des deux clés devient clé étrangère dans l'autre table
- Généralement, on choisit le côté optionnel pour recevoir la clé étrangère

---

## 2. Tables Résultantes de la Transformation

### 2.1 Transformation des Entités Simples

#### FRANCHISE
Entité → Table directe

```sql
FRANCHISE (
    franchise_id       NUMBER [PK],
    nom                VARCHAR2(120) [NOT NULL],
    adresse            VARCHAR2(240),
    ville              VARCHAR2(80),
    code_postal        VARCHAR2(15),
    telephone          VARCHAR2(30)
)
```

**Origine :** Entité FRANCHISE du MCD

---

#### PERSONNEL
Entité → Table directe

```sql
PERSONNEL (
    personnel_id       NUMBER [PK],
    nom                VARCHAR2(80) [NOT NULL],
    prenom             VARCHAR2(80) [NOT NULL],
    role_metier        VARCHAR2(40) [NOT NULL],
    specialite         VARCHAR2(80),
    type_contrat       VARCHAR2(20) [CHECK (type_contrat IN ('INTERNE','EXTERNE'))],
    telephone          VARCHAR2(30),
    email              VARCHAR2(120)
)
```

**Origine :** Entité PERSONNEL du MCD

---

#### PATIENT
Entité → Table directe + Association FREQUENTER (0,1)

```sql
PATIENT (
    patient_id         NUMBER [PK],
    nom                VARCHAR2(80) [NOT NULL],
    prenom             VARCHAR2(80) [NOT NULL],
    date_naissance     DATE,
    sexe               CHAR(1) [CHECK (sexe IN ('M','F'))],
    telephone          VARCHAR2(30),
    email              VARCHAR2(120),
    adresse            VARCHAR2(240),
    ville              VARCHAR2(80),
    code_postal        VARCHAR2(15),
    franchise_ref_id   NUMBER [FK → FRANCHISE]
)
```

**Origine :**
- Entité PATIENT du MCD
- Association FREQUENTER (0,1) : ajout de `franchise_ref_id` (optionnel car cardinalité 0,1)

---

#### PRODUIT_DENTAIRE
Entité → Table directe

```sql
PRODUIT_DENTAIRE (
    produit_id         NUMBER [PK],
    nom                VARCHAR2(120) [NOT NULL],
    type_produit       VARCHAR2(80) [NOT NULL],
    stock_quantite     NUMBER(10,2),
    unite              VARCHAR2(20),
    seuil_alerte       NUMBER(10,2),
    prix_unitaire      NUMBER(10,2)
)
```

**Origine :** Entité PRODUIT_DENTAIRE du MCD

---

#### FOURNISSEUR
Entité → Table directe

```sql
FOURNISSEUR (
    fournisseur_id     NUMBER [PK],
    nom                VARCHAR2(120) [NOT NULL],
    contact            VARCHAR2(120),
    telephone          VARCHAR2(30),
    email              VARCHAR2(120)
)
```

**Origine :** Entité FOURNISSEUR du MCD

---

#### EQUIPEMENT
Entité → Table directe + Association POSSEDER_EQUIPEMENT (0,1)

```sql
EQUIPEMENT (
    equipement_id      NUMBER [PK],
    nom                VARCHAR2(120) [NOT NULL],
    categorie          VARCHAR2(80),
    date_acquisition   DATE,
    cout_acquisition   NUMBER(12,2),
    statut             VARCHAR2(20) [CHECK (statut IN ('ACTIF','HORS_SERVICE','MAINTENANCE'))],
    franchise_id       NUMBER [FK → FRANCHISE]
)
```

**Origine :**
- Entité EQUIPEMENT du MCD
- Association POSSEDER_EQUIPEMENT (0,1) : ajout de `franchise_id` (optionnel)

---

#### ANOMALIE
Entité → Table directe (table de référence)

```sql
ANOMALIE (
    anomalie_id        NUMBER [PK],
    libelle            VARCHAR2(120) [NOT NULL],
    description        VARCHAR2(400),
    severite           VARCHAR2(20) [CHECK (severite IN ('LEGER','MODERE','SEVERE'))]
)
```

**Origine :** Entité ANOMALIE du MCD (catalogue de référence)

---

### 2.2 Transformation des Entités avec Associations 1:N

#### DOSSIER_PATIENT
Entité → Table + Associations AVOIR_DOSSIER (1,1) et OUVRIR_DANS (1,1)

```sql
DOSSIER_PATIENT (
    dossier_id         NUMBER [PK],
    patient_id         NUMBER [NOT NULL] [FK → PATIENT],
    franchise_id       NUMBER [NOT NULL] [FK → FRANCHISE],
    date_creation      DATE [NOT NULL],
    statut             VARCHAR2(20) [CHECK (statut IN ('OUVERT','FERME'))],
    motif_consultation VARCHAR2(200),
    notes_generales    VARCHAR2(4000)
)
```

**Origine :**
- Entité DOSSIER_PATIENT du MCD
- Association AVOIR_DOSSIER (côté N) : ajout de `patient_id` obligatoire
- Association OUVRIR_DANS (côté N) : ajout de `franchise_id` obligatoire

---

#### TRAITEMENT
Entité → Table + Association CONTENIR (1,1)

```sql
TRAITEMENT (
    traitement_id      NUMBER [PK],
    dossier_id         NUMBER [NOT NULL] [FK → DOSSIER_PATIENT],
    date_debut         DATE [NOT NULL],
    date_fin           DATE,
    description        VARCHAR2(400),
    cout_estime        NUMBER(10,2),
    statut             VARCHAR2(20) [CHECK (statut IN ('PLANIFIE','EN_COURS','TERMINE'))],
    CONSTRAINT ck_tr_dates CHECK (date_fin IS NULL OR date_fin >= date_debut)
)
```

**Origine :**
- Entité TRAITEMENT du MCD
- Association CONTENIR (côté N) : ajout de `dossier_id` obligatoire

---

#### ACTE_MEDICAL
Entité → Table + Associations REALISER (1,1) et EFFECTUER (1,1)

```sql
ACTE_MEDICAL (
    acte_id            NUMBER [PK],
    traitement_id      NUMBER [NOT NULL] [FK → TRAITEMENT],
    personnel_id       NUMBER [NOT NULL] [FK → PERSONNEL],
    type_acte          VARCHAR2(80) [NOT NULL],
    description        VARCHAR2(400),
    date_acte          DATE [NOT NULL],
    montant            NUMBER(10,2),
    radiographie_ref   VARCHAR2(200),
    prescription_text  VARCHAR2(1000)
)
```

**Origine :**
- Entité ACTE_MEDICAL du MCD
- Association REALISER (côté N) : ajout de `traitement_id` obligatoire
- Association EFFECTUER (côté N) : ajout de `personnel_id` obligatoire

---

#### PAIEMENT
Entité → Table + Associations PAYER_ACTE et PAYER_TRAITEMENT (exclusives)

```sql
PAIEMENT (
    paiement_id        NUMBER [PK],
    acte_id            NUMBER [FK → ACTE_MEDICAL],
    traitement_id      NUMBER [FK → TRAITEMENT],
    date_paiement      DATE [NOT NULL],
    montant            NUMBER(10,2) [NOT NULL],
    mode_paiement      VARCHAR2(20) [CHECK (mode_paiement IN ('CB','ESPECES','VIREMENT','CHEQUE'))],
    statut             VARCHAR2(20) [CHECK (statut IN ('PAYE','EN_RETARD','PARTIEL'))],
    CONSTRAINT ck_pai_cible CHECK (
        (acte_id IS NOT NULL AND traitement_id IS NULL) OR
        (acte_id IS NULL AND traitement_id IS NOT NULL)
    )
)
```

**Origine :**
- Entité PAIEMENT du MCD
- Associations PAYER_ACTE et PAYER_TRAITEMENT : clés étrangères optionnelles mais exclusives
- **Contrainte d'exclusivité** : un paiement concerne SOIT un acte SOIT un traitement

---

#### COMMANDE
Entité → Table + Associations FOURNIR (1,1) et COMMANDER_POUR (1,1)

```sql
COMMANDE (
    commande_id        NUMBER [PK],
    fournisseur_id     NUMBER [NOT NULL] [FK → FOURNISSEUR],
    franchise_id       NUMBER [NOT NULL] [FK → FRANCHISE],
    date_commande      DATE [NOT NULL],
    statut             VARCHAR2(20) [CHECK (statut IN ('EN_ATTENTE','LIVREE','ANNULEE','PARTIELLE'))],
    date_livraison     DATE,
    CONSTRAINT ck_cmd_dates CHECK (date_livraison IS NULL OR date_livraison >= date_commande)
)
```

**Origine :**
- Entité COMMANDE du MCD
- Association FOURNIR (côté N) : ajout de `fournisseur_id` obligatoire
- Association COMMANDER_POUR (côté N) : ajout de `franchise_id` obligatoire

---

#### DENT
Entité → Table + Association APPARTENIR_A (1,1)

```sql
DENT (
    dent_id            NUMBER [PK],
    patient_id         NUMBER [NOT NULL] [FK → PATIENT],
    code_fdi           VARCHAR2(3) [NOT NULL],
    commentaire        VARCHAR2(200),
    CONSTRAINT uc_dent_patient UNIQUE (patient_id, code_fdi)
)
```

**Origine :**
- Entité DENT du MCD
- Association APPARTENIR_A (côté N) : ajout de `patient_id` obligatoire
- **Contrainte d'unicité** : un patient ne peut avoir qu'une seule dent avec un code FDI donné

---

#### ETAT_DENT
Entité → Table + Associations OBSERVER (1,1) et LIER_A_ACTE (0,1)

```sql
ETAT_DENT (
    etat_dent_id       NUMBER [PK],
    dent_id            NUMBER [NOT NULL] [FK → DENT],
    date_observation   DATE [NOT NULL],
    description        VARCHAR2(400),
    acte_id            NUMBER [FK → ACTE_MEDICAL]
)
```

**Origine :**
- Entité ETAT_DENT du MCD
- Association OBSERVER (côté N) : ajout de `dent_id` obligatoire
- Association LIER_A_ACTE (côté N) : ajout de `acte_id` optionnel

---

#### RESTAURATION
Entité → Table + Association RESTAURER (1,1)

```sql
RESTAURATION (
    restauration_id    NUMBER [PK],
    etat_dent_id       NUMBER [NOT NULL] [FK → ETAT_DENT],
    type_restauration  VARCHAR2(80) [NOT NULL],
    materiau           VARCHAR2(80),
    date_pose          DATE [NOT NULL],
    duree_vie_estimee  NUMBER(5,1)
)
```

**Origine :**
- Entité RESTAURATION du MCD
- Association RESTAURER (côté N) : ajout de `etat_dent_id` obligatoire

---

### 2.3 Transformation des Associations N:M en Tables d'Association

#### FRANCHISE_PERSONNEL
Association TRAVAILLER_DANS (N:M avec attributs : date_debut, date_fin)

```sql
FRANCHISE_PERSONNEL (
    franchise_personnel_id NUMBER [PK],
    franchise_id           NUMBER [NOT NULL] [FK → FRANCHISE],
    personnel_id           NUMBER [NOT NULL] [FK → PERSONNEL],
    date_debut             DATE [NOT NULL],
    date_fin               DATE,
    CONSTRAINT ck_fp_dates CHECK (date_fin IS NULL OR date_fin >= date_debut)
)
```

**Origine :** Association TRAVAILLER_DANS du MCD (N:M)

**Explication :**
- Association N:M → Table intermédiaire
- Clé primaire : `franchise_personnel_id` (identifiant technique)
- Clés étrangères : `franchise_id` et `personnel_id`
- Attributs de l'association : `date_debut`, `date_fin`

---

#### COMMANDE_LIGNE
Association COMPOSER (N:M avec attributs : quantite, prix_unitaire)

```sql
COMMANDE_LIGNE (
    commande_ligne_id  NUMBER [PK],
    commande_id        NUMBER [NOT NULL] [FK → COMMANDE],
    produit_id         NUMBER [NOT NULL] [FK → PRODUIT_DENTAIRE],
    quantite           NUMBER(10,2) [NOT NULL],
    prix_unitaire      NUMBER(10,2) [NOT NULL]
)
```

**Origine :** Association COMPOSER du MCD (N:M)

**Explication :**
- Association N:M entre COMMANDE et PRODUIT_DENTAIRE → Table intermédiaire
- Clé primaire : `commande_ligne_id`
- Clés étrangères : `commande_id` et `produit_id`
- Attributs de l'association : `quantite`, `prix_unitaire`

---

#### ETAT_DENT_ANOMALIE
Association DETECTER (N:M)

```sql
ETAT_DENT_ANOMALIE (
    etat_dent_anomalie_id NUMBER [PK],
    etat_dent_id          NUMBER [NOT NULL] [FK → ETAT_DENT],
    anomalie_id           NUMBER [NOT NULL] [FK → ANOMALIE]
)
```

**Origine :** Association DETECTER du MCD (N:M)

**Explication :**
- Association N:M entre ETAT_DENT et ANOMALIE → Table intermédiaire
- Un état de dent peut avoir plusieurs anomalies détectées
- Une anomalie peut apparaître sur plusieurs dents

---

#### ACTE_PRODUIT
Association CONSOMMER (N:M avec attribut : quantite_utilisee)

```sql
ACTE_PRODUIT (
    acte_produit_id    NUMBER [PK],
    acte_id            NUMBER [NOT NULL] [FK → ACTE_MEDICAL],
    produit_id         NUMBER [NOT NULL] [FK → PRODUIT_DENTAIRE],
    quantite_utilisee  NUMBER(10,2) [NOT NULL]
)
```

**Origine :** Association CONSOMMER du MCD (N:M)

**Explication :**
- Association N:M entre ACTE_MEDICAL et PRODUIT_DENTAIRE → Table intermédiaire
- Attribut de l'association : `quantite_utilisee`
- Permet de tracer les produits consommés lors de chaque acte

---

#### ACTE_EQUIPEMENT
Association UTILISER_EQUIPEMENT (N:M avec attribut : duree_minutes)

```sql
ACTE_EQUIPEMENT (
    acte_equipement_id NUMBER [PK],
    acte_id            NUMBER [NOT NULL] [FK → ACTE_MEDICAL],
    equipement_id      NUMBER [NOT NULL] [FK → EQUIPEMENT],
    duree_minutes      NUMBER(5,0)
)
```

**Origine :** Association UTILISER_EQUIPEMENT du MCD (N:M)

**Explication :**
- Association N:M entre ACTE_MEDICAL et EQUIPEMENT → Table intermédiaire
- Attribut de l'association : `duree_minutes`
- Permet de suivre l'utilisation des équipements

---

## 3. Schéma Relationnel Complet

### Vue d'ensemble des tables et relations

```
FRANCHISE
    ├── franchise_id [PK]
    └── est référencée par :
        ├── PATIENT.franchise_ref_id [FK] (0,1)
        ├── DOSSIER_PATIENT.franchise_id [FK] (1,1)
        ├── COMMANDE.franchise_id [FK] (1,1)
        ├── EQUIPEMENT.franchise_id [FK] (0,1)
        └── FRANCHISE_PERSONNEL.franchise_id [FK] (N:M)

PERSONNEL
    ├── personnel_id [PK]
    └── est référencé par :
        ├── ACTE_MEDICAL.personnel_id [FK] (1,1)
        └── FRANCHISE_PERSONNEL.personnel_id [FK] (N:M)

PATIENT
    ├── patient_id [PK]
    ├── franchise_ref_id [FK → FRANCHISE] (0,1)
    └── est référencé par :
        ├── DOSSIER_PATIENT.patient_id [FK] (1,1)
        └── DENT.patient_id [FK] (1,1)

DOSSIER_PATIENT
    ├── dossier_id [PK]
    ├── patient_id [FK → PATIENT] (1,1)
    ├── franchise_id [FK → FRANCHISE] (1,1)
    └── est référencé par :
        └── TRAITEMENT.dossier_id [FK] (1,1)

TRAITEMENT
    ├── traitement_id [PK]
    ├── dossier_id [FK → DOSSIER_PATIENT] (1,1)
    └── est référencé par :
        ├── ACTE_MEDICAL.traitement_id [FK] (1,1)
        └── PAIEMENT.traitement_id [FK] (0,1 exclusif)

ACTE_MEDICAL
    ├── acte_id [PK]
    ├── traitement_id [FK → TRAITEMENT] (1,1)
    ├── personnel_id [FK → PERSONNEL] (1,1)
    └── est référencé par :
        ├── PAIEMENT.acte_id [FK] (0,1 exclusif)
        ├── ETAT_DENT.acte_id [FK] (0,1)
        ├── ACTE_PRODUIT.acte_id [FK] (N:M)
        └── ACTE_EQUIPEMENT.acte_id [FK] (N:M)

PAIEMENT
    ├── paiement_id [PK]
    ├── acte_id [FK → ACTE_MEDICAL] (0,1 exclusif)
    └── traitement_id [FK → TRAITEMENT] (0,1 exclusif)

PRODUIT_DENTAIRE
    ├── produit_id [PK]
    └── est référencé par :
        ├── COMMANDE_LIGNE.produit_id [FK] (N:M)
        └── ACTE_PRODUIT.produit_id [FK] (N:M)

FOURNISSEUR
    ├── fournisseur_id [PK]
    └── est référencé par :
        └── COMMANDE.fournisseur_id [FK] (1,1)

COMMANDE
    ├── commande_id [PK]
    ├── fournisseur_id [FK → FOURNISSEUR] (1,1)
    ├── franchise_id [FK → FRANCHISE] (1,1)
    └── est référencé par :
        └── COMMANDE_LIGNE.commande_id [FK] (N:M)

EQUIPEMENT
    ├── equipement_id [PK]
    ├── franchise_id [FK → FRANCHISE] (0,1)
    └── est référencé par :
        └── ACTE_EQUIPEMENT.equipement_id [FK] (N:M)

DENT
    ├── dent_id [PK]
    ├── patient_id [FK → PATIENT] (1,1)
    ├── UNIQUE (patient_id, code_fdi)
    └── est référencée par :
        └── ETAT_DENT.dent_id [FK] (1,1)

ETAT_DENT
    ├── etat_dent_id [PK]
    ├── dent_id [FK → DENT] (1,1)
    ├── acte_id [FK → ACTE_MEDICAL] (0,1)
    └── est référencé par :
        ├── RESTAURATION.etat_dent_id [FK] (1,1)
        └── ETAT_DENT_ANOMALIE.etat_dent_id [FK] (N:M)

ANOMALIE
    ├── anomalie_id [PK]
    └── est référencée par :
        └── ETAT_DENT_ANOMALIE.anomalie_id [FK] (N:M)

RESTAURATION
    ├── restauration_id [PK]
    └── etat_dent_id [FK → ETAT_DENT] (1,1)
```

---

## 4. Tables d'Association N:M

| Table d'Association      | Entité 1          | Entité 2          | Attributs Supplémentaires            |
|--------------------------|-------------------|-------------------|--------------------------------------|
| FRANCHISE_PERSONNEL      | FRANCHISE         | PERSONNEL         | date_debut, date_fin                 |
| COMMANDE_LIGNE           | COMMANDE          | PRODUIT_DENTAIRE  | quantite, prix_unitaire              |
| ETAT_DENT_ANOMALIE       | ETAT_DENT         | ANOMALIE          | -                                    |
| ACTE_PRODUIT             | ACTE_MEDICAL      | PRODUIT_DENTAIRE  | quantite_utilisee                    |
| ACTE_EQUIPEMENT          | ACTE_MEDICAL      | EQUIPEMENT        | duree_minutes                        |

---

## 5. Récapitulatif des Contraintes d'Intégrité

### Contraintes de clé primaire (PK)
Toutes les tables ont une clé primaire identifiant unique (généralement un `NUMBER GENERATED BY DEFAULT AS IDENTITY`).

### Contraintes de clé étrangère (FK)

| Table              | Colonne FK         | Référence              | Cardinalité |
|--------------------|--------------------|-----------------------|-------------|
| PATIENT            | franchise_ref_id   | FRANCHISE(franchise_id)| 0,1         |
| DOSSIER_PATIENT    | patient_id         | PATIENT(patient_id)   | 1,1         |
| DOSSIER_PATIENT    | franchise_id       | FRANCHISE(franchise_id)| 1,1         |
| TRAITEMENT         | dossier_id         | DOSSIER_PATIENT(dossier_id)| 1,1    |
| ACTE_MEDICAL       | traitement_id      | TRAITEMENT(traitement_id)| 1,1       |
| ACTE_MEDICAL       | personnel_id       | PERSONNEL(personnel_id)| 1,1         |
| PAIEMENT           | acte_id            | ACTE_MEDICAL(acte_id) | 0,1 (exclusif)|
| PAIEMENT           | traitement_id      | TRAITEMENT(traitement_id)| 0,1 (exclusif)|
| COMMANDE           | fournisseur_id     | FOURNISSEUR(fournisseur_id)| 1,1     |
| COMMANDE           | franchise_id       | FRANCHISE(franchise_id)| 1,1         |
| EQUIPEMENT         | franchise_id       | FRANCHISE(franchise_id)| 0,1         |
| DENT               | patient_id         | PATIENT(patient_id)   | 1,1         |
| ETAT_DENT          | dent_id            | DENT(dent_id)         | 1,1         |
| ETAT_DENT          | acte_id            | ACTE_MEDICAL(acte_id) | 0,1         |
| RESTAURATION       | etat_dent_id       | ETAT_DENT(etat_dent_id)| 1,1        |

### Contraintes CHECK

| Table              | Colonne            | Contrainte                                                    |
|--------------------|--------------------|---------------------------------------------------------------|
| PERSONNEL          | type_contrat       | IN ('INTERNE','EXTERNE')                                      |
| PATIENT            | sexe               | IN ('M','F')                                                  |
| DOSSIER_PATIENT    | statut             | IN ('OUVERT','FERME')                                         |
| TRAITEMENT         | statut             | IN ('PLANIFIE','EN_COURS','TERMINE')                          |
| TRAITEMENT         | dates              | date_fin IS NULL OR date_fin >= date_debut                    |
| PAIEMENT           | mode_paiement      | IN ('CB','ESPECES','VIREMENT','CHEQUE')                       |
| PAIEMENT           | statut             | IN ('PAYE','EN_RETARD','PARTIEL')                             |
| PAIEMENT           | cible              | (acte_id IS NOT NULL XOR traitement_id IS NOT NULL)           |
| COMMANDE           | statut             | IN ('EN_ATTENTE','LIVREE','ANNULEE','PARTIELLE')              |
| COMMANDE           | dates              | date_livraison IS NULL OR date_livraison >= date_commande     |
| EQUIPEMENT         | statut             | IN ('ACTIF','HORS_SERVICE','MAINTENANCE')                     |
| ANOMALIE           | severite           | IN ('LEGER','MODERE','SEVERE')                                |
| FRANCHISE_PERSONNEL| dates              | date_fin IS NULL OR date_fin >= date_debut                    |

### Contraintes UNIQUE

| Table              | Colonnes           | Raison                                                        |
|--------------------|--------------------|---------------------------------------------------------------|
| DENT               | (patient_id, code_fdi) | Un patient ne peut avoir qu'une dent avec un code FDI donné |

---

## 6. Index pour Optimisation des Requêtes

```sql
-- Index sur les clés étrangères (améliore les jointures)
CREATE INDEX idx_dp_patient ON dossier_patient(patient_id);
CREATE INDEX idx_tr_dossier ON traitement(dossier_id);
CREATE INDEX idx_am_traitement ON acte_medical(traitement_id);
CREATE INDEX idx_dent_patient ON dent(patient_id);
CREATE INDEX idx_ed_dent ON etat_dent(dent_id);
CREATE INDEX idx_ap_produit ON acte_produit(produit_id);
CREATE INDEX idx_cmd_franchise ON commande(franchise_id);

-- Index sur les statuts (améliore les requêtes de filtrage)
CREATE INDEX idx_pai_statut ON paiement(statut);
```

---

## 7. Normalisation

### Forme Normale 1 (1NF) ✅
- Toutes les valeurs sont atomiques (pas de listes, pas de groupes répétitifs)
- Chaque table a une clé primaire unique

### Forme Normale 2 (2NF) ✅
- Respecte 1NF
- Tous les attributs non-clés dépendent de la totalité de la clé primaire
- Aucune dépendance partielle

### Forme Normale 3 (3NF) ✅
- Respecte 2NF
- Aucune dépendance transitive (attributs non-clés ne dépendent pas d'autres attributs non-clés)
- Exemple : Les informations du fournisseur ne sont pas répétées dans COMMANDE, elles sont dans FOURNISSEUR

### Forme Normale Boyce-Codd (BCNF) ✅
- Respecte 3NF
- Toute dépendance fonctionnelle a pour déterminant une clé candidate

---

## 8. Correspondance MCD → MLD : Tableau Récapitulatif

| Élément MCD                  | Type              | Transformation MLD                                    |
|------------------------------|-------------------|-------------------------------------------------------|
| Entité FRANCHISE             | Entité            | Table FRANCHISE                                       |
| Entité PERSONNEL             | Entité            | Table PERSONNEL                                       |
| Entité PATIENT               | Entité            | Table PATIENT (+ FK franchise_ref_id)                 |
| Entité DOSSIER_PATIENT       | Entité            | Table DOSSIER_PATIENT (+ FK patient_id, franchise_id) |
| Entité TRAITEMENT            | Entité            | Table TRAITEMENT (+ FK dossier_id)                    |
| Entité ACTE_MEDICAL          | Entité            | Table ACTE_MEDICAL (+ FK traitement_id, personnel_id) |
| Entité PAIEMENT              | Entité            | Table PAIEMENT (+ FK acte_id OU traitement_id)        |
| Entité PRODUIT_DENTAIRE      | Entité            | Table PRODUIT_DENTAIRE                                |
| Entité FOURNISSEUR           | Entité            | Table FOURNISSEUR                                     |
| Entité COMMANDE              | Entité            | Table COMMANDE (+ FK fournisseur_id, franchise_id)    |
| Entité EQUIPEMENT            | Entité            | Table EQUIPEMENT (+ FK franchise_id)                  |
| Entité DENT                  | Entité            | Table DENT (+ FK patient_id)                          |
| Entité ETAT_DENT             | Entité            | Table ETAT_DENT (+ FK dent_id, acte_id)               |
| Entité ANOMALIE              | Entité            | Table ANOMALIE (catalogue)                            |
| Entité RESTAURATION          | Entité            | Table RESTAURATION (+ FK etat_dent_id)                |
| Association TRAVAILLER_DANS  | N:M avec attributs| Table FRANCHISE_PERSONNEL                             |
| Association FREQUENTER       | 0,1 → N           | FK franchise_ref_id dans PATIENT                      |
| Association AVOIR_DOSSIER    | 1,1 → N           | FK patient_id dans DOSSIER_PATIENT                    |
| Association OUVRIR_DANS      | N → 1,1           | FK franchise_id dans DOSSIER_PATIENT                  |
| Association CONTENIR         | 1,1 → N           | FK dossier_id dans TRAITEMENT                         |
| Association REALISER         | 1,1 → N           | FK traitement_id dans ACTE_MEDICAL                    |
| Association EFFECTUER        | 1,1 → N           | FK personnel_id dans ACTE_MEDICAL                     |
| Association PAYER_ACTE       | N → 0,1           | FK acte_id dans PAIEMENT (exclusif)                   |
| Association PAYER_TRAITEMENT | N → 0,1           | FK traitement_id dans PAIEMENT (exclusif)             |
| Association FOURNIR          | N → 1,1           | FK fournisseur_id dans COMMANDE                       |
| Association COMMANDER_POUR   | N → 1,1           | FK franchise_id dans COMMANDE                         |
| Association COMPOSER         | N:M avec attributs| Table COMMANDE_LIGNE                                  |
| Association POSSEDER_EQUIPEMENT | N → 0,1        | FK franchise_id dans EQUIPEMENT                       |
| Association APPARTENIR_A     | N → 1,1           | FK patient_id dans DENT                               |
| Association OBSERVER         | N → 1,1           | FK dent_id dans ETAT_DENT                             |
| Association LIER_A_ACTE      | N → 0,1           | FK acte_id dans ETAT_DENT                             |
| Association DETECTER         | N:M               | Table ETAT_DENT_ANOMALIE                              |
| Association RESTAURER        | N → 1,1           | FK etat_dent_id dans RESTAURATION                     |
| Association CONSOMMER        | N:M avec attributs| Table ACTE_PRODUIT                                    |
| Association UTILISER_EQUIPEMENT | N:M avec attributs | Table ACTE_EQUIPEMENT                             |

---

## 9. Conclusion

Ce modèle relationnel respecte les règles de transformation du modèle conceptuel et assure :
- **Intégrité référentielle** : Toutes les relations sont maintenues par des clés étrangères
- **Normalisation** : Le modèle est en 3NF/BCNF
- **Performance** : Index sur les colonnes fréquemment utilisées en jointures et filtres
- **Évolutivité** : Facile d'ajouter de nouvelles entités ou relations
- **Traçabilité** : Historisation des affectations du personnel et des états dentaires

Le modèle permet de répondre à tous les besoins analytiques spécifiés dans le cahier des charges du projet.
