# 🎨 Comment Visualiser le Modèle Conceptuel (MCD)

Ce document vous guide pour créer et visualiser le **Modèle Conceptuel de Données (MCD)** de la clinique dentaire Dentissimo.

---

## 📁 Fichiers Disponibles

| Fichier                      | Format      | Utilisation                                    |
|------------------------------|-------------|------------------------------------------------|
| `MODELE_CONCEPTUEL.md`       | Markdown    | Documentation textuelle complète du MCD        |
| `MCD_DIAGRAMME.md`           | Mermaid     | Diagramme qui s'affiche sur GitHub             |
| `mcd_plantuml.puml`          | PlantUML    | Code pour générer un diagramme UML             |

---

## 🚀 Méthode 1 : Visualisation sur GitHub (Mermaid) - LE PLUS SIMPLE

### Étapes :
1. Poussez vos fichiers sur GitHub
2. Ouvrez `MCD_DIAGRAMME.md` sur GitHub
3. Le diagramme Mermaid s'affiche automatiquement ! ✨

**Avantages :**
- ✅ Aucune installation nécessaire
- ✅ Affichage direct sur GitHub
- ✅ Parfait pour la documentation

**Inconvénients :**
- ❌ Moins personnalisable visuellement
- ❌ Pas idéal pour un rendu PDF professionnel

---

## 🎯 Méthode 2 : PlantUML - POUR GÉNÉRER DES IMAGES

### Option A : En ligne (rapide)

1. Ouvrez le fichier `mcd_plantuml.puml`
2. Copiez tout le contenu
3. Allez sur https://www.plantuml.com/plantuml/uml/
4. Collez le code dans l'éditeur
5. Cliquez sur "Submit"
6. Téléchargez le diagramme en PNG ou SVG

### Option B : Avec VSCode (recommandé)

1. Installez VSCode : https://code.visualstudio.com/
2. Installez l'extension "PlantUML" dans VSCode
3. Installez Graphviz : https://graphviz.org/download/
4. Ouvrez `mcd_plantuml.puml` dans VSCode
5. Appuyez sur `Alt + D` pour prévisualiser
6. Clic droit > Export pour sauvegarder en PNG/SVG

**Avantages :**
- ✅ Haute qualité d'image
- ✅ Export en PNG, SVG, PDF
- ✅ Code versionnable (Git)

**Inconvénients :**
- ❌ Nécessite installation
- ❌ Courbe d'apprentissage

---

## 🎓 Méthode 3 : Looping - LOGICIEL SPÉCIALISÉ MCD (RECOMMANDÉ POUR BUT SD)

### Installation

1. **Télécharger Looping** : http://www.looping-mcd.fr/
2. Installer le logiciel (Windows uniquement, ou via Wine sur Linux/Mac)

### Création du MCD dans Looping

#### Étape 1 : Créer les Entités

Cliquez sur "Nouvelle Entité" et créez les 15 entités suivantes :

1. **FRANCHISE**
   - franchise_id (Identifiant)
   - nom
   - adresse
   - ville
   - code_postal
   - telephone

2. **PERSONNEL**
   - personnel_id (Identifiant)
   - nom
   - prenom
   - role_metier
   - specialite
   - type_contrat
   - telephone
   - email

3. **PATIENT**
   - patient_id (Identifiant)
   - nom
   - prenom
   - date_naissance
   - sexe
   - telephone
   - email
   - adresse
   - ville
   - code_postal

4. **DOSSIER_PATIENT**
   - dossier_id (Identifiant)
   - date_creation
   - statut
   - motif_consultation
   - notes_generales

5. **TRAITEMENT**
   - traitement_id (Identifiant)
   - date_debut
   - date_fin
   - description
   - cout_estime
   - statut

6. **ACTE_MEDICAL**
   - acte_id (Identifiant)
   - type_acte
   - description
   - date_acte
   - montant
   - radiographie_ref
   - prescription_text

7. **PAIEMENT**
   - paiement_id (Identifiant)
   - date_paiement
   - montant
   - mode_paiement
   - statut

8. **PRODUIT_DENTAIRE**
   - produit_id (Identifiant)
   - nom
   - type_produit
   - stock_quantite
   - unite
   - seuil_alerte
   - prix_unitaire

9. **FOURNISSEUR**
   - fournisseur_id (Identifiant)
   - nom
   - contact
   - telephone
   - email

10. **COMMANDE**
    - commande_id (Identifiant)
    - date_commande
    - statut
    - date_livraison

11. **EQUIPEMENT**
    - equipement_id (Identifiant)
    - nom
    - categorie
    - date_acquisition
    - cout_acquisition
    - statut

12. **DENT**
    - dent_id (Identifiant)
    - code_fdi
    - commentaire

13. **ETAT_DENT**
    - etat_dent_id (Identifiant)
    - date_observation
    - description

14. **ANOMALIE**
    - anomalie_id (Identifiant)
    - libelle
    - description
    - severite

15. **RESTAURATION**
    - restauration_id (Identifiant)
    - type_restauration
    - materiau
    - date_pose
    - duree_vie_estimee

#### Étape 2 : Créer les Associations

Cliquez sur "Nouvelle Association" et créez les relations suivantes :

##### Relations 1:N (15 associations)

| Association           | Entité 1          | Card. | Entité 2        | Card. |
|-----------------------|-------------------|-------|-----------------|-------|
| FREQUENTER            | PATIENT           | 0,1   | FRANCHISE       | 0,n   |
| AVOIR_DOSSIER         | PATIENT           | 1,1   | DOSSIER_PATIENT | 0,n   |
| OUVRIR_DANS           | FRANCHISE         | 1,1   | DOSSIER_PATIENT | 0,n   |
| CONTENIR              | DOSSIER_PATIENT   | 1,1   | TRAITEMENT      | 0,n   |
| REALISER              | TRAITEMENT        | 1,1   | ACTE_MEDICAL    | 0,n   |
| EFFECTUER             | PERSONNEL         | 1,1   | ACTE_MEDICAL    | 0,n   |
| PAYER_ACTE            | ACTE_MEDICAL      | 0,1   | PAIEMENT        | 0,n   |
| PAYER_TRAITEMENT      | TRAITEMENT        | 0,1   | PAIEMENT        | 0,n   |
| FOURNIR               | FOURNISSEUR       | 1,1   | COMMANDE        | 0,n   |
| COMMANDER_POUR        | FRANCHISE         | 1,1   | COMMANDE        | 0,n   |
| POSSEDER_EQUIPEMENT   | FRANCHISE         | 0,1   | EQUIPEMENT      | 0,n   |
| APPARTENIR_A          | PATIENT           | 1,1   | DENT            | 0,n   |
| OBSERVER              | DENT              | 1,1   | ETAT_DENT       | 0,n   |
| LIER_A_ACTE           | ACTE_MEDICAL      | 0,1   | ETAT_DENT       | 0,n   |
| RESTAURER             | ETAT_DENT         | 1,1   | RESTAURATION    | 0,n   |

##### Relations N:M (5 associations)

| Association           | Entité 1          | Card. | Entité 2         | Card. | Attributs                    |
|-----------------------|-------------------|-------|------------------|-------|------------------------------|
| TRAVAILLER_DANS       | PERSONNEL         | 0,n   | FRANCHISE        | 0,n   | date_debut, date_fin         |
| COMPOSER              | COMMANDE          | 0,n   | PRODUIT_DENTAIRE | 0,n   | quantite, prix_unitaire      |
| DETECTER              | ETAT_DENT         | 0,n   | ANOMALIE         | 0,n   | -                            |
| CONSOMMER             | ACTE_MEDICAL      | 0,n   | PRODUIT_DENTAIRE | 0,n   | quantite_utilisee            |
| UTILISER_EQUIPEMENT   | ACTE_MEDICAL      | 0,n   | EQUIPEMENT       | 0,n   | duree_minutes                |

#### Étape 3 : Générer le MLD automatiquement

1. Dans Looping, cliquez sur "Générer le MLD"
2. Looping transforme automatiquement votre MCD en MLD
3. Vérifiez que les 20 tables sont générées correctement

#### Étape 4 : Générer le SQL

1. Dans Looping, allez dans "Générer le SQL"
2. Choisissez "Oracle" comme SGBD
3. Exportez le script SQL
4. Comparez avec `schema.sql`

#### Étape 5 : Exporter le diagramme

1. Fichier > Exporter > Image
2. Choisissez PNG ou PDF
3. Utilisez cette image dans votre rapport

**Avantages de Looping :**
- ✅ Logiciel français, adapté à la méthode Merise
- ✅ Génération automatique du MLD depuis le MCD
- ✅ Export SQL direct pour Oracle
- ✅ Interface intuitive
- ✅ Gratuit
- ✅ Parfait pour les projets BUT SD

---

## 🖼️ Méthode 4 : Draw.io - POUR UNE PERSONNALISATION MAXIMALE

### Étapes :

1. Allez sur https://app.diagrams.net/
2. Créez un nouveau diagramme
3. Sélectionnez "Entity Relation" dans les formes
4. Créez manuellement :
   - 15 rectangles pour les entités
   - 20 losanges pour les associations
   - Reliez-les avec les cardinalités
5. Exportez en PNG, SVG ou PDF

### Template de base :

1. Utilisez des **rectangles** pour les entités
2. Listez les attributs à l'intérieur
3. Soulignez la clé primaire
4. Utilisez des **losanges** pour les associations
5. Ajoutez les cardinalités sur les traits de liaison

**Avantages :**
- ✅ Totalement gratuit
- ✅ Très personnalisable
- ✅ Export en haute qualité
- ✅ Fonctionne en ligne, aucune installation

**Inconvénients :**
- ❌ Création manuelle (pas de génération automatique)
- ❌ Plus long à réaliser

---

## 🏆 Quelle Méthode Choisir ?

| Situation                          | Méthode Recommandée  | Raison                                          |
|------------------------------------|----------------------|-------------------------------------------------|
| Projet BUT SD / École              | **Looping**          | Standard français, génère MLD + SQL             |
| Documentation GitHub               | **Mermaid**          | Affichage direct, versionnable                  |
| Rendu visuel professionnel         | **PlantUML**         | Haute qualité, automatisé                       |
| Personnalisation maximale          | **Draw.io**          | Contrôle total sur l'apparence                  |
| Présentation PowerPoint            | **Draw.io** ou **PlantUML** | Export PNG/SVG de qualité            |

---

## 📝 Pour Votre Rendu de Projet

### Documents à inclure :

1. **MCD visuel** (PDF/PNG) généré avec Looping ou Draw.io
2. **MODELE_CONCEPTUEL.md** (documentation textuelle)
3. **MLD visuel** généré automatiquement par Looping
4. **MODELE_RELATIONNEL.md** (documentation textuelle)
5. **VALIDATION_MODELES.md** (preuve de cohérence)
6. **schema.sql** (implémentation SQL)

### Structure du dossier de rendu :

```
mini-projet-sql/
├── docs/
│   ├── MCD_diagramme.png          ← Généré avec Looping
│   ├── MLD_diagramme.png          ← Généré avec Looping
│   ├── MODELE_CONCEPTUEL.md
│   ├── MODELE_RELATIONNEL.md
│   └── VALIDATION_MODELES.md
├── sql/
│   ├── schema.sql
│   ├── seed.sql
│   └── queries.sql
└── README.md
```

---

## ⚡ Guide Rapide : Créer le MCD en 15 minutes avec Looping

1. **Télécharger et installer Looping** (2 min)
2. **Créer les 15 entités** avec leurs attributs (5 min)
3. **Créer les 20 associations** avec cardinalités (5 min)
4. **Générer le MLD automatiquement** (1 min)
5. **Exporter en image** (1 min)
6. **Générer le SQL Oracle** (1 min)

**Total : ~15 minutes pour un MCD/MLD complet !** ⚡

---

## 🆘 Besoin d'Aide ?

### Ressources :

- **Looping** : http://www.looping-mcd.fr/
  - Tutoriel vidéo : https://www.youtube.com/results?search_query=looping+mcd+tutoriel

- **PlantUML** : https://plantuml.com/
  - Documentation : https://plantuml.com/er-diagram

- **Draw.io** : https://app.diagrams.net/
  - Tutoriel ER : https://www.youtube.com/results?search_query=draw.io+entity+relationship

- **Méthode Merise** :
  - https://fr.wikipedia.org/wiki/Merise_(informatique)

---

## ✅ Checklist Finale

Avant de rendre votre projet, vérifiez :

- [ ] Le MCD contient bien 15 entités
- [ ] Le MCD contient bien 20 associations
- [ ] Toutes les cardinalités sont indiquées
- [ ] Les clés primaires sont identifiées
- [ ] Les attributs des associations N:M sont présents
- [ ] Le MLD contient 20 tables
- [ ] Le MLD est cohérent avec le MCD
- [ ] Le schema.sql correspond au MLD
- [ ] Les diagrammes sont exportés en haute qualité (PNG/PDF)
- [ ] La documentation est complète et claire

---

**Bonne chance pour votre projet ! 🚀**
