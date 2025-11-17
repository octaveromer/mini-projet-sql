# Mini-projet : base Oracle pour clinique dentaire Dentissimo

Livrables fournis (dans ce dossier) :
- `schema.sql` : création du schéma Oracle (tables, contraintes, index).
- `seed.sql` : jeu de données de test réaliste (INSERT + COMMIT).
- `queries.sql` : requêtes pour vérifier et analyser les besoins métier.

## Exécution rapide
```sql
-- Depuis SQL*Plus ou SQLcl
@schema.sql
@seed.sql
@queries.sql -- facultatif pour exécuter les requêtes de vérification
```

## Modèle conceptuel (entités principales)
- `Franchise` gère agences locales.
- `Personnel` (interne/externe) avec affectations historisées `FranchisePersonnel`.
- `Patient` et son `DossierPatient` (statut ouvert/fermé, motif, notes).
- `Traitement` rattaché à un dossier ; composé d'`ActeMedical` (type, date, praticien, radiographie, prescription).
- `Paiement` lié à un acte ou à un traitement complet.
- `ProduitDentaire`, `Fournisseur`, `Commande` + `CommandeLigne` pour la chaîne d’approvisionnement.
- `Equipement` et son usage lors d’un acte (`ActeEquipement`).
- Suivi buccal et dentaire : `Dent` (code FDI), `EtatDent` (daté, éventuellement associé à un acte), `Anomalie` + `EtatDentAnomalie`, `Restauration`.
- Consommation de produits lors des actes : `ActeProduit`.

## Modèle relationnel (tables et clés)
- Clés primaires : `..._id` (IDENTITY).
- Clés étrangères majeures :
  - `dossier_patient.patient_id -> patient`
  - `dossier_patient.franchise_id -> franchise`
  - `traitement.dossier_id -> dossier_patient`
  - `acte_medical.traitement_id -> traitement`
  - `acte_medical.personnel_id -> personnel`
  - `paiement.acte_id -> acte_medical` et/ou `paiement.traitement_id -> traitement` (exactement l’un des deux, contrainte `ck_pai_cible`)
  - `dent.patient_id -> patient`, `etat_dent.dent_id -> dent`, `etat_dent.acte_id -> acte_medical`
  - `etat_dent_anomalie.etat_dent_id -> etat_dent`, `...anomalie_id -> anomalie`
  - `restauration.etat_dent_id -> etat_dent`
  - `acte_produit.acte_id -> acte_medical`, `...produit_id -> produit_dentaire`
  - `acte_equipement.acte_id -> acte_medical`, `...equipement_id -> equipement`
  - `commande.fournisseur_id -> fournisseur`, `commande.franchise_id -> franchise`
  - `commande_ligne.commande_id -> commande`, `...produit_id -> produit_dentaire`
  - `franchise_personnel` relie personnel/franchise avec dates d’affectation.
- Contraintes notables :
  - `ck_tr_dates`, `ck_pai_cible`, `ck_cmd_dates`, `ck_fp_dates` pour les règles métiers.
  - Unicité d’une dent par patient/code FDI : `uc_dent_patient`.

## Jeu de données de test
- 2 franchises, 3 personnels, 3 patients.
- Dossiers/traitements/actes couvrant contrôle, radio, obturation, consultation.
- Paiements payés et partiel pour tester statuts.
- Stock produits et commandes multi-fournisseurs.
- Equipements utilisés par actes, anomalies et restaurations sur dents.

## Requêtes de vérification (queries.sql)
Couverture des besoins A–H du sujet : nouveaux vs récurrents, profil et fidélité, dossiers ouverts/fermés, stats actes et temps de traitement, revenus/paiements, performance praticiens, suivi produits/commandes/équipements, fréquence des anomalies/restaurations, répartition franchise et rentabilité estimée des traitements.

## Points d’attention / extensions possibles
- Gestion fine du stock (décrémentation automatique) à implémenter via triggers/procédures si nécessaire.
- Ajout d’un référentiel de codes FDI ou de surfaces dentaires pour plus de granularité.
- Historisation des statuts d’équipement (maintenance) et des statuts de commande de manière détaillée.
- Éventuels index supplémentaires selon volumétries réelles et plans d’exécution.

