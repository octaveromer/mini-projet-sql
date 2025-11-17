# Modèle Conceptuel de Données (MCD) - Clinique Dentaire Dentissimo

## 1. Liste des Entités

### 1.1 FRANCHISE
Représente les différentes agences de la clinique dentaire.

**Attributs :**
- `franchise_id` : Identifiant unique (clé primaire)
- `nom` : Nom de la franchise
- `adresse` : Adresse complète
- `ville` : Ville
- `code_postal` : Code postal
- `telephone` : Numéro de téléphone

---

### 1.2 PERSONNEL
Personnel interne (employés) et praticiens externes.

**Attributs :**
- `personnel_id` : Identifiant unique (clé primaire)
- `nom` : Nom du personnel
- `prenom` : Prénom
- `role_metier` : Rôle (dentiste, assistant, hygiéniste, etc.)
- `specialite` : Spécialité médicale
- `type_contrat` : Type de contrat (INTERNE / EXTERNE)
- `telephone` : Téléphone
- `email` : Email

---

### 1.3 PATIENT
Patients de la clinique.

**Attributs :**
- `patient_id` : Identifiant unique (clé primaire)
- `nom` : Nom du patient
- `prenom` : Prénom
- `date_naissance` : Date de naissance
- `sexe` : Sexe (M/F)
- `telephone` : Téléphone
- `email` : Email
- `adresse` : Adresse
- `ville` : Ville
- `code_postal` : Code postal

---

### 1.4 DOSSIER_PATIENT
Dossier médical d'un patient dans une franchise.

**Attributs :**
- `dossier_id` : Identifiant unique (clé primaire)
- `date_creation` : Date de création du dossier
- `statut` : Statut du dossier (OUVERT / FERME)
- `motif_consultation` : Motif de la consultation
- `notes_generales` : Notes générales du dossier

---

### 1.5 TRAITEMENT
Traitement médical associé à un dossier patient.

**Attributs :**
- `traitement_id` : Identifiant unique (clé primaire)
- `date_debut` : Date de début du traitement
- `date_fin` : Date de fin du traitement
- `description` : Description du traitement
- `cout_estime` : Coût estimé
- `statut` : Statut (PLANIFIE / EN_COURS / TERMINE)

---

### 1.6 ACTE_MEDICAL
Acte médical réalisé lors d'un traitement.

**Attributs :**
- `acte_id` : Identifiant unique (clé primaire)
- `type_acte` : Type d'acte (détartrage, extraction, implant, etc.)
- `description` : Description de l'acte
- `date_acte` : Date de réalisation
- `montant` : Montant de l'acte
- `radiographie_ref` : Référence vers fichier radiographie
- `prescription_text` : Texte de prescription médicale

---

### 1.7 PAIEMENT
Paiement effectué pour un acte ou un traitement.

**Attributs :**
- `paiement_id` : Identifiant unique (clé primaire)
- `date_paiement` : Date du paiement
- `montant` : Montant payé
- `mode_paiement` : Mode (CB / ESPECES / VIREMENT / CHEQUE)
- `statut` : Statut (PAYE / EN_RETARD / PARTIEL)

---

### 1.8 PRODUIT_DENTAIRE
Produits et consommables dentaires.

**Attributs :**
- `produit_id` : Identifiant unique (clé primaire)
- `nom` : Nom du produit
- `type_produit` : Type (anesthésiant, composite, consommable, etc.)
- `stock_quantite` : Quantité en stock
- `unite` : Unité de mesure (ml, g, unités)
- `seuil_alerte` : Seuil d'alerte de stock
- `prix_unitaire` : Prix unitaire

---

### 1.9 FOURNISSEUR
Fournisseurs de produits dentaires.

**Attributs :**
- `fournisseur_id` : Identifiant unique (clé primaire)
- `nom` : Nom du fournisseur
- `contact` : Personne de contact
- `telephone` : Téléphone
- `email` : Email

---

### 1.10 COMMANDE
Commande de produits auprès d'un fournisseur.

**Attributs :**
- `commande_id` : Identifiant unique (clé primaire)
- `date_commande` : Date de la commande
- `statut` : Statut (EN_ATTENTE / LIVREE / ANNULEE / PARTIELLE)
- `date_livraison` : Date de livraison

---

### 1.11 EQUIPEMENT
Équipements médicaux de la clinique.

**Attributs :**
- `equipement_id` : Identifiant unique (clé primaire)
- `nom` : Nom de l'équipement
- `categorie` : Catégorie (fauteuil, radio, stérilisation, etc.)
- `date_acquisition` : Date d'acquisition
- `cout_acquisition` : Coût d'acquisition
- `statut` : Statut (ACTIF / HORS_SERVICE / MAINTENANCE)

---

### 1.12 DENT
Dent d'un patient identifiée par le code FDI.

**Attributs :**
- `dent_id` : Identifiant unique (clé primaire)
- `code_fdi` : Code FDI de la dent (11 à 48 pour adultes, 51 à 85 pour enfants)
- `commentaire` : Commentaire général sur la dent

---

### 1.13 ETAT_DENT
État d'une dent à une date donnée (historique).

**Attributs :**
- `etat_dent_id` : Identifiant unique (clé primaire)
- `date_observation` : Date d'observation de l'état
- `description` : Description de l'état

---

### 1.14 ANOMALIE
Catalogue des anomalies dentaires possibles.

**Attributs :**
- `anomalie_id` : Identifiant unique (clé primaire)
- `libelle` : Libellé de l'anomalie (carie, fracture, infection, etc.)
- `description` : Description détaillée
- `severite` : Sévérité (LEGER / MODERE / SEVERE)

---

### 1.15 RESTAURATION
Restauration dentaire effectuée sur une dent.

**Attributs :**
- `restauration_id` : Identifiant unique (clé primaire)
- `type_restauration` : Type (obturation, couronne, implant, bridge, etc.)
- `materiau` : Matériau utilisé (composite, céramique, métal, etc.)
- `date_pose` : Date de pose
- `duree_vie_estimee` : Durée de vie estimée en années

---

## 2. Liste des Associations

### 2.1 TRAVAILLER_DANS
Association entre PERSONNEL et FRANCHISE (avec historisation).

**Cardinalités :** `PERSONNEL (0,n) ---- (0,n) FRANCHISE`

**Attributs de l'association :**
- `date_debut` : Date de début d'affectation
- `date_fin` : Date de fin d'affectation (NULL si toujours affecté)

**Signification :** Un personnel peut travailler dans plusieurs franchises au fil du temps, et une franchise peut avoir plusieurs membres du personnel.

---

### 2.2 FREQUENTER
Association entre PATIENT et FRANCHISE (franchise principale).

**Cardinalités :** `PATIENT (0,1) ---- (0,n) FRANCHISE`

**Signification :** Un patient fréquente principalement une franchise (optionnel), et une franchise peut avoir plusieurs patients.

---

### 2.3 AVOIR_DOSSIER
Association entre PATIENT et DOSSIER_PATIENT.

**Cardinalités :** `PATIENT (1,1) ---- (0,n) DOSSIER_PATIENT`

**Signification :** Un dossier appartient à un patient unique, et un patient peut avoir plusieurs dossiers.

---

### 2.4 OUVRIR_DANS
Association entre DOSSIER_PATIENT et FRANCHISE.

**Cardinalités :** `DOSSIER_PATIENT (0,n) ---- (1,1) FRANCHISE`

**Signification :** Un dossier est ouvert dans une franchise spécifique, et une franchise peut gérer plusieurs dossiers.

---

### 2.5 CONTENIR
Association entre DOSSIER_PATIENT et TRAITEMENT.

**Cardinalités :** `DOSSIER_PATIENT (1,1) ---- (0,n) TRAITEMENT`

**Signification :** Un traitement est rattaché à un dossier unique, et un dossier peut contenir plusieurs traitements.

---

### 2.6 REALISER
Association entre TRAITEMENT et ACTE_MEDICAL.

**Cardinalités :** `TRAITEMENT (1,1) ---- (0,n) ACTE_MEDICAL`

**Signification :** Un acte médical appartient à un traitement unique, et un traitement peut contenir plusieurs actes.

---

### 2.7 EFFECTUER
Association entre PERSONNEL et ACTE_MEDICAL.

**Cardinalités :** `PERSONNEL (1,1) ---- (0,n) ACTE_MEDICAL`

**Signification :** Un acte est effectué par un praticien unique, et un praticien peut réaliser plusieurs actes.

---

### 2.8 PAYER_ACTE
Association entre PAIEMENT et ACTE_MEDICAL.

**Cardinalités :** `PAIEMENT (0,n) ---- (0,1) ACTE_MEDICAL`

**Signification :** Un paiement peut être associé à un acte (ou à un traitement), et un acte peut avoir plusieurs paiements.

---

### 2.9 PAYER_TRAITEMENT
Association entre PAIEMENT et TRAITEMENT.

**Cardinalités :** `PAIEMENT (0,n) ---- (0,1) TRAITEMENT`

**Signification :** Un paiement peut être associé à un traitement complet (ou à un acte), et un traitement peut avoir plusieurs paiements.

**Note :** Un paiement est lié SOIT à un acte SOIT à un traitement (contrainte d'exclusivité).

---

### 2.10 FOURNIR
Association entre FOURNISSEUR et COMMANDE.

**Cardinalités :** `FOURNISSEUR (1,1) ---- (0,n) COMMANDE`

**Signification :** Une commande est passée auprès d'un fournisseur unique, et un fournisseur peut recevoir plusieurs commandes.

---

### 2.11 COMMANDER_POUR
Association entre FRANCHISE et COMMANDE.

**Cardinalités :** `FRANCHISE (1,1) ---- (0,n) COMMANDE`

**Signification :** Une commande est passée pour une franchise spécifique, et une franchise peut passer plusieurs commandes.

---

### 2.12 COMPOSER
Association entre COMMANDE et PRODUIT_DENTAIRE (lignes de commande).

**Cardinalités :** `COMMANDE (1,1) ---- (0,n) PRODUIT_DENTAIRE (0,n)`

**Attributs de l'association :**
- `quantite` : Quantité commandée
- `prix_unitaire` : Prix unitaire au moment de la commande

**Signification :** Une commande peut contenir plusieurs produits, et un produit peut apparaître dans plusieurs commandes.

---

### 2.13 POSSEDER_EQUIPEMENT
Association entre FRANCHISE et EQUIPEMENT.

**Cardinalités :** `FRANCHISE (0,1) ---- (0,n) EQUIPEMENT`

**Signification :** Un équipement appartient à une franchise (optionnel), et une franchise peut posséder plusieurs équipements.

---

### 2.14 APPARTENIR_A
Association entre DENT et PATIENT.

**Cardinalités :** `DENT (0,n) ---- (1,1) PATIENT`

**Signification :** Une dent appartient à un patient unique, et un patient peut avoir plusieurs dents enregistrées.

---

### 2.15 OBSERVER
Association entre ETAT_DENT et DENT.

**Cardinalités :** `ETAT_DENT (0,n) ---- (1,1) DENT`

**Signification :** Un état de dent concerne une dent unique, et une dent peut avoir plusieurs états dans l'historique.

---

### 2.16 LIER_A_ACTE
Association entre ETAT_DENT et ACTE_MEDICAL.

**Cardinalités :** `ETAT_DENT (0,n) ---- (0,1) ACTE_MEDICAL`

**Signification :** Un état de dent peut être lié à un acte médical (optionnel), et un acte peut concerner plusieurs états de dents.

---

### 2.17 DETECTER
Association entre ETAT_DENT et ANOMALIE (anomalies détectées).

**Cardinalités :** `ETAT_DENT (0,n) ---- (0,n) ANOMALIE`

**Signification :** Lors d'une observation, plusieurs anomalies peuvent être détectées sur une dent, et une anomalie peut être constatée sur plusieurs dents.

---

### 2.18 RESTAURER
Association entre RESTAURATION et ETAT_DENT.

**Cardinalités :** `RESTAURATION (0,n) ---- (1,1) ETAT_DENT`

**Signification :** Une restauration est effectuée suite à un état de dent spécifique, et un état peut nécessiter plusieurs restaurations.

---

### 2.19 CONSOMMER
Association entre ACTE_MEDICAL et PRODUIT_DENTAIRE (produits consommés).

**Cardinalités :** `ACTE_MEDICAL (0,n) ---- (0,n) PRODUIT_DENTAIRE`

**Attributs de l'association :**
- `quantite_utilisee` : Quantité utilisée lors de l'acte

**Signification :** Un acte peut consommer plusieurs produits, et un produit peut être utilisé dans plusieurs actes.

---

### 2.20 UTILISER_EQUIPEMENT
Association entre ACTE_MEDICAL et EQUIPEMENT.

**Cardinalités :** `ACTE_MEDICAL (0,n) ---- (0,n) EQUIPEMENT`

**Attributs de l'association :**
- `duree_minutes` : Durée d'utilisation en minutes

**Signification :** Un acte peut utiliser plusieurs équipements, et un équipement peut être utilisé pour plusieurs actes.

---

## 3. Diagramme Entité-Association (Représentation Textuelle)

```
                                    CLINIQUE DENTAIRE DENTISSIMO

┌─────────────────────────────────────────────────────────────────────────────────┐
│                          GESTION DES FRANCHISES ET PERSONNEL                      │
└─────────────────────────────────────────────────────────────────────────────────┘

    PERSONNEL (0,n) ────── TRAVAILLER_DANS ────── (0,n) FRANCHISE
         │                 [date_debut, date_fin]              │
         │                                                      │
         │(1,1)                                          (0,1)  │
         │                                                      │
    EFFECTUER                                          POSSEDER_EQUIPEMENT
         │                                                      │
         │(0,n)                                          (0,n)  │
         │                                                      │
    ACTE_MEDICAL                                          EQUIPEMENT
         │
         │(1,1)
         │
    REALISER
         │
         │(0,n)
         │
    TRAITEMENT ────── PAYER_TRAITEMENT ────── (0,1) PAIEMENT (0,1) ────── PAYER_ACTE
         │                                                                      │
         │(1,1)                                                          (0,n)  │
         │                                                                      │
    CONTENIR                                                         retour à ACTE_MEDICAL
         │
         │(0,n)
         │
    DOSSIER_PATIENT
         │       │
         │(1,1)  │(1,1)
         │       │
   AVOIR_DOSSIER OUVRIR_DANS
         │       │
    (0,n)│  (0,n)│
         │       │
    PATIENT ──── FREQUENTER ────── (0,1) FRANCHISE
         │
         │(1,1)
         │
    APPARTENIR_A
         │
         │(0,n)
         │
       DENT
         │
         │(1,1)
         │
    OBSERVER
         │
         │(0,n)
         │
    ETAT_DENT ────── LIER_A_ACTE ────── (0,1) ACTE_MEDICAL
         │       │
         │       │
         │       └─── RESTAURER ────── (0,n) RESTAURATION
         │
         │
         └────── DETECTER ────── (0,n) ANOMALIE


┌─────────────────────────────────────────────────────────────────────────────────┐
│                    GESTION DES PRODUITS ET COMMANDES                              │
└─────────────────────────────────────────────────────────────────────────────────┘

    FOURNISSEUR (1,1) ────── FOURNIR ────── (0,n) COMMANDE (1,1) ────── COMMANDER_POUR ────── (0,n) FRANCHISE
                                                      │
                                                      │(1,1)
                                                      │
                                                   COMPOSER
                                                      │
                                                (0,n) │ (0,n)
                                                      │
                                              PRODUIT_DENTAIRE
                                                      │
                                                      │
                                                (0,n) │ (0,n)
                                                      │
                                                   CONSOMMER
                                                      │
                                                      └─────── retour à ACTE_MEDICAL


┌─────────────────────────────────────────────────────────────────────────────────┐
│                       UTILISATION DES ÉQUIPEMENTS                                 │
└─────────────────────────────────────────────────────────────────────────────────┘

    ACTE_MEDICAL (0,n) ────── UTILISER_EQUIPEMENT ────── (0,n) EQUIPEMENT
                              [duree_minutes]
```

---

## 4. Règles de Gestion

1. **RG1** : Un dossier patient est toujours rattaché à un patient unique et à une franchise unique.

2. **RG2** : Un traitement appartient obligatoirement à un dossier patient.

3. **RG3** : Chaque acte médical est réalisé par un seul praticien et fait partie d'un seul traitement.

4. **RG4** : Un paiement concerne SOIT un acte médical SOIT un traitement complet (exclusivité).

5. **RG5** : Une dent est identifiée de manière unique par le couple (patient, code_fdi).

6. **RG6** : L'historique de l'état d'une dent est conservé avec possibilité de lier chaque observation à un acte médical.

7. **RG7** : Plusieurs anomalies peuvent être détectées lors d'une observation de dent.

8. **RG8** : Une restauration est toujours liée à un état de dent spécifique (observation ayant nécessité cette restauration).

9. **RG9** : Un membre du personnel peut être affecté à plusieurs franchises au fil du temps (historisation avec dates).

10. **RG10** : Une commande est passée par une franchise auprès d'un fournisseur et peut contenir plusieurs produits.

11. **RG11** : Le stock des produits doit être suivi et mis à jour lors de leur utilisation dans les actes.

12. **RG12** : Les équipements appartiennent à une franchise et peuvent être utilisés dans plusieurs actes.

---

## 5. Contraintes d'Intégrité

### Contraintes de domaine :
- `sexe` ∈ {M, F}
- `type_contrat` ∈ {INTERNE, EXTERNE}
- `statut` (dossier) ∈ {OUVERT, FERME}
- `statut` (traitement) ∈ {PLANIFIE, EN_COURS, TERMINE}
- `mode_paiement` ∈ {CB, ESPECES, VIREMENT, CHEQUE}
- `statut` (paiement) ∈ {PAYE, EN_RETARD, PARTIEL}
- `statut` (commande) ∈ {EN_ATTENTE, LIVREE, ANNULEE, PARTIELLE}
- `statut` (equipement) ∈ {ACTIF, HORS_SERVICE, MAINTENANCE}
- `severite` ∈ {LEGER, MODERE, SEVERE}

### Contraintes temporelles :
- `date_fin` ≥ `date_debut` (pour traitement et affectation personnel)
- `date_livraison` ≥ `date_commande`

### Contraintes d'unicité :
- Un patient ne peut avoir qu'une seule dent avec un code FDI donné
- Un paiement est lié SOIT à un acte SOIT à un traitement (pas aux deux)

---

## 6. Notes Complémentaires

### Code FDI :
Le système FDI (Fédération Dentaire Internationale) utilise une numérotation à deux chiffres :
- **Adultes** : 11-18 (quadrant 1), 21-28 (quadrant 2), 31-38 (quadrant 3), 41-48 (quadrant 4)
- **Enfants** : 51-55 (quadrant 5), 61-65 (quadrant 6), 71-75 (quadrant 7), 81-85 (quadrant 8)

### Historisation :
Le modèle permet l'historisation de :
- L'affectation du personnel aux franchises
- L'état des dents au fil du temps
- Les anomalies et restaurations dentaires

### Évolutivité :
Le modèle permet d'ajouter facilement :
- De nouvelles franchises
- De nouveaux types d'actes médicaux
- De nouvelles anomalies et restaurations
- De nouveaux produits et équipements
