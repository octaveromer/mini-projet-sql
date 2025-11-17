# Diagramme du Modèle Conceptuel de Données (MCD)

## 🎨 Comment visualiser le MCD

### Option 1 : Utiliser Mermaid (recommandé pour GitHub)
Le diagramme Mermaid ci-dessous s'affiche automatiquement sur GitHub.

### Option 2 : Utiliser Draw.io
1. Allez sur https://app.diagrams.net/
2. Importez le fichier `MCD_drawio.xml` (ci-dessous)
3. Éditez et exportez en PNG/PDF

### Option 3 : Utiliser Looping (logiciel français spécialisé MCD)
1. Téléchargez Looping : http://www.looping-mcd.fr/
2. Créez le MCD avec l'interface graphique
3. Générez automatiquement le MLD

### Option 4 : Utiliser ERDPlus
1. Allez sur https://erdplus.com/
2. Créez un nouveau diagramme ER
3. Utilisez les spécifications ci-dessous

---

## 📊 Diagramme MCD en Mermaid

```mermaid
erDiagram
    FRANCHISE ||--o{ PATIENT : "fréquente"
    FRANCHISE ||--o{ DOSSIER_PATIENT : "gère"
    FRANCHISE ||--o{ COMMANDE : "passe"
    FRANCHISE ||--o{ EQUIPEMENT : "possède"
    FRANCHISE }o--o{ PERSONNEL : "travaille_dans"

    PATIENT ||--o{ DOSSIER_PATIENT : "a_pour_dossier"
    PATIENT ||--o{ DENT : "possède"

    DOSSIER_PATIENT ||--o{ TRAITEMENT : "contient"

    TRAITEMENT ||--o{ ACTE_MEDICAL : "réalise"
    TRAITEMENT ||--o{ PAIEMENT : "paye"

    PERSONNEL ||--o{ ACTE_MEDICAL : "effectue"

    ACTE_MEDICAL ||--o{ PAIEMENT : "paye"
    ACTE_MEDICAL ||--o{ ETAT_DENT : "lie_à"
    ACTE_MEDICAL }o--o{ PRODUIT_DENTAIRE : "consomme"
    ACTE_MEDICAL }o--o{ EQUIPEMENT : "utilise"

    DENT ||--o{ ETAT_DENT : "a_pour_état"

    ETAT_DENT }o--o{ ANOMALIE : "détecte"
    ETAT_DENT ||--o{ RESTAURATION : "restaure"

    FOURNISSEUR ||--o{ COMMANDE : "fournit"

    COMMANDE }o--o{ PRODUIT_DENTAIRE : "compose"

    FRANCHISE {
        NUMBER franchise_id PK
        VARCHAR2 nom
        VARCHAR2 adresse
        VARCHAR2 ville
        VARCHAR2 code_postal
        VARCHAR2 telephone
    }

    PERSONNEL {
        NUMBER personnel_id PK
        VARCHAR2 nom
        VARCHAR2 prenom
        VARCHAR2 role_metier
        VARCHAR2 specialite
        VARCHAR2 type_contrat
        VARCHAR2 telephone
        VARCHAR2 email
    }

    PATIENT {
        NUMBER patient_id PK
        VARCHAR2 nom
        VARCHAR2 prenom
        DATE date_naissance
        CHAR sexe
        VARCHAR2 telephone
        VARCHAR2 email
        VARCHAR2 adresse
        VARCHAR2 ville
        VARCHAR2 code_postal
    }

    DOSSIER_PATIENT {
        NUMBER dossier_id PK
        DATE date_creation
        VARCHAR2 statut
        VARCHAR2 motif_consultation
        VARCHAR2 notes_generales
    }

    TRAITEMENT {
        NUMBER traitement_id PK
        DATE date_debut
        DATE date_fin
        VARCHAR2 description
        NUMBER cout_estime
        VARCHAR2 statut
    }

    ACTE_MEDICAL {
        NUMBER acte_id PK
        VARCHAR2 type_acte
        VARCHAR2 description
        DATE date_acte
        NUMBER montant
        VARCHAR2 radiographie_ref
        VARCHAR2 prescription_text
    }

    PAIEMENT {
        NUMBER paiement_id PK
        DATE date_paiement
        NUMBER montant
        VARCHAR2 mode_paiement
        VARCHAR2 statut
    }

    PRODUIT_DENTAIRE {
        NUMBER produit_id PK
        VARCHAR2 nom
        VARCHAR2 type_produit
        NUMBER stock_quantite
        VARCHAR2 unite
        NUMBER seuil_alerte
        NUMBER prix_unitaire
    }

    FOURNISSEUR {
        NUMBER fournisseur_id PK
        VARCHAR2 nom
        VARCHAR2 contact
        VARCHAR2 telephone
        VARCHAR2 email
    }

    COMMANDE {
        NUMBER commande_id PK
        DATE date_commande
        VARCHAR2 statut
        DATE date_livraison
    }

    EQUIPEMENT {
        NUMBER equipement_id PK
        VARCHAR2 nom
        VARCHAR2 categorie
        DATE date_acquisition
        NUMBER cout_acquisition
        VARCHAR2 statut
    }

    DENT {
        NUMBER dent_id PK
        VARCHAR2 code_fdi
        VARCHAR2 commentaire
    }

    ETAT_DENT {
        NUMBER etat_dent_id PK
        DATE date_observation
        VARCHAR2 description
    }

    ANOMALIE {
        NUMBER anomalie_id PK
        VARCHAR2 libelle
        VARCHAR2 description
        VARCHAR2 severite
    }

    RESTAURATION {
        NUMBER restauration_id PK
        VARCHAR2 type_restauration
        VARCHAR2 materiau
        DATE date_pose
        NUMBER duree_vie_estimee
    }
```

---

## 📝 Légende des Cardinalités

| Notation Mermaid | Signification        | Description                    |
|------------------|----------------------|--------------------------------|
| `||--o{`         | 1 vers plusieurs (0,n)| Un à plusieurs (optionnel)    |
| `||--|{`         | 1 vers plusieurs (1,n)| Un à plusieurs (obligatoire)  |
| `}o--o{`         | Plusieurs à plusieurs| Relation N:M                   |
| `||--||`         | 1 vers 1             | Relation 1:1                   |

---

## 🎯 Cardinalités Détaillées

### Relations 1:N

| Association           | Entité Source | Card. | Entité Cible       | Card. |
|-----------------------|---------------|-------|--------------------|-------|
| FREQUENTER            | PATIENT       | 0,1   | FRANCHISE          | 0,n   |
| AVOIR_DOSSIER         | PATIENT       | 1,1   | DOSSIER_PATIENT    | 0,n   |
| OUVRIR_DANS           | DOSSIER_PATIENT| 0,n  | FRANCHISE          | 1,1   |
| CONTENIR              | DOSSIER_PATIENT| 1,1  | TRAITEMENT         | 0,n   |
| REALISER              | TRAITEMENT    | 1,1   | ACTE_MEDICAL       | 0,n   |
| EFFECTUER             | PERSONNEL     | 1,1   | ACTE_MEDICAL       | 0,n   |
| PAYER_ACTE            | ACTE_MEDICAL  | 0,1   | PAIEMENT           | 0,n   |
| PAYER_TRAITEMENT      | TRAITEMENT    | 0,1   | PAIEMENT           | 0,n   |
| FOURNIR               | FOURNISSEUR   | 1,1   | COMMANDE           | 0,n   |
| COMMANDER_POUR        | FRANCHISE     | 1,1   | COMMANDE           | 0,n   |
| POSSEDER_EQUIPEMENT   | FRANCHISE     | 0,1   | EQUIPEMENT         | 0,n   |
| APPARTENIR_A          | PATIENT       | 1,1   | DENT               | 0,n   |
| OBSERVER              | DENT          | 1,1   | ETAT_DENT          | 0,n   |
| LIER_A_ACTE           | ACTE_MEDICAL  | 0,1   | ETAT_DENT          | 0,n   |
| RESTAURER             | ETAT_DENT     | 1,1   | RESTAURATION       | 0,n   |

### Relations N:M

| Association           | Entité 1      | Card. | Entité 2           | Card. | Attributs             |
|-----------------------|---------------|-------|--------------------|-------|-----------------------|
| TRAVAILLER_DANS       | PERSONNEL     | 0,n   | FRANCHISE          | 0,n   | date_debut, date_fin  |
| COMPOSER              | COMMANDE      | 0,n   | PRODUIT_DENTAIRE   | 0,n   | quantite, prix_unitaire|
| DETECTER              | ETAT_DENT     | 0,n   | ANOMALIE           | 0,n   | -                     |
| CONSOMMER             | ACTE_MEDICAL  | 0,n   | PRODUIT_DENTAIRE   | 0,n   | quantite_utilisee     |
| UTILISER_EQUIPEMENT   | ACTE_MEDICAL  | 0,n   | EQUIPEMENT         | 0,n   | duree_minutes         |

---

## 📥 Fichier Draw.io (XML)

Créez un fichier `MCD_dentissimo.drawio` et collez ce contenu :

```xml
<?xml version="1.0" encoding="UTF-8"?>
<mxfile host="app.diagrams.net">
  <diagram name="MCD Clinique Dentissimo">
    <mxGraphModel dx="1422" dy="794" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="827" pageHeight="1169">
      <root>
        <mxCell id="0" />
        <mxCell id="1" parent="0" />

        <!-- Instructions:
        1. Copiez ce XML
        2. Allez sur https://app.diagrams.net/
        3. Fichier > Importer > Depuis le texte
        4. Collez et importez
        5. Le diagramme de base sera créé, vous pouvez l'améliorer visuellement
        -->

        <mxCell id="note1" value="Pour créer le MCD complet dans Draw.io:&#xa;&#xa;1. Utilisez la palette 'Entity Relation'&#xa;2. Ajoutez les 15 entités (rectangles)&#xa;3. Ajoutez les 20 associations (losanges)&#xa;4. Reliez-les avec les cardinalités&#xa;5. Référez-vous au fichier MODELE_CONCEPTUEL.md"
                style="text;html=1;strokeColor=#d6b656;fillColor=#fff2cc;align=left;verticalAlign=top;whiteSpace=wrap;rounded=1;"
                vertex="1" parent="1">
          <mxGeometry x="40" y="40" width="400" height="160" as="geometry" />
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

---

## 🔧 Instructions pour Draw.io (Méthode Manuelle)

### Étape 1 : Créer les Entités (15 rectangles)

1. Allez sur https://app.diagrams.net/
2. Nouveau diagramme vierge
3. Utilisez la bibliothèque "Entity Relation" (à gauche)
4. Ajoutez 15 rectangles pour les entités :
   - FRANCHISE
   - PERSONNEL
   - PATIENT
   - DOSSIER_PATIENT
   - TRAITEMENT
   - ACTE_MEDICAL
   - PAIEMENT
   - PRODUIT_DENTAIRE
   - FOURNISSEUR
   - COMMANDE
   - EQUIPEMENT
   - DENT
   - ETAT_DENT
   - ANOMALIE
   - RESTAURATION

### Étape 2 : Ajouter les Associations (20 losanges)

Ajoutez 20 losanges pour les associations entre les entités (voir liste dans MODELE_CONCEPTUEL.md)

### Étape 3 : Relier avec les Cardinalités

Utilisez les connecteurs et ajoutez les cardinalités :
- `0,1` = optionnel, un seul
- `1,1` = obligatoire, un seul
- `0,n` = optionnel, plusieurs
- `1,n` = obligatoire, plusieurs

### Étape 4 : Ajouter les Attributs

Dans chaque rectangle d'entité, listez les attributs (soulignez la clé primaire).

---

## 🖥️ Alternative : Utiliser PlantUML

Créez un fichier `mcd.puml` :

```plantuml
@startuml MCD_Clinique_Dentissimo

' Configuration
skinparam linetype ortho
skinparam nodesep 80
skinparam ranksep 80

entity "FRANCHISE" as franchise {
  * franchise_id : NUMBER <<PK>>
  --
  nom : VARCHAR2(120)
  adresse : VARCHAR2(240)
  ville : VARCHAR2(80)
  code_postal : VARCHAR2(15)
  telephone : VARCHAR2(30)
}

entity "PERSONNEL" as personnel {
  * personnel_id : NUMBER <<PK>>
  --
  nom : VARCHAR2(80)
  prenom : VARCHAR2(80)
  role_metier : VARCHAR2(40)
  specialite : VARCHAR2(80)
  type_contrat : VARCHAR2(20)
  telephone : VARCHAR2(30)
  email : VARCHAR2(120)
}

entity "PATIENT" as patient {
  * patient_id : NUMBER <<PK>>
  --
  nom : VARCHAR2(80)
  prenom : VARCHAR2(80)
  date_naissance : DATE
  sexe : CHAR(1)
  telephone : VARCHAR2(30)
  email : VARCHAR2(120)
  adresse : VARCHAR2(240)
  ville : VARCHAR2(80)
  code_postal : VARCHAR2(15)
}

entity "DOSSIER_PATIENT" as dossier {
  * dossier_id : NUMBER <<PK>>
  --
  date_creation : DATE
  statut : VARCHAR2(20)
  motif_consultation : VARCHAR2(200)
  notes_generales : VARCHAR2(4000)
}

entity "TRAITEMENT" as traitement {
  * traitement_id : NUMBER <<PK>>
  --
  date_debut : DATE
  date_fin : DATE
  description : VARCHAR2(400)
  cout_estime : NUMBER(10,2)
  statut : VARCHAR2(20)
}

entity "ACTE_MEDICAL" as acte {
  * acte_id : NUMBER <<PK>>
  --
  type_acte : VARCHAR2(80)
  description : VARCHAR2(400)
  date_acte : DATE
  montant : NUMBER(10,2)
  radiographie_ref : VARCHAR2(200)
  prescription_text : VARCHAR2(1000)
}

entity "DENT" as dent {
  * dent_id : NUMBER <<PK>>
  --
  code_fdi : VARCHAR2(3)
  commentaire : VARCHAR2(200)
}

entity "ETAT_DENT" as etat_dent {
  * etat_dent_id : NUMBER <<PK>>
  --
  date_observation : DATE
  description : VARCHAR2(400)
}

entity "ANOMALIE" as anomalie {
  * anomalie_id : NUMBER <<PK>>
  --
  libelle : VARCHAR2(120)
  description : VARCHAR2(400)
  severite : VARCHAR2(20)
}

entity "RESTAURATION" as restauration {
  * restauration_id : NUMBER <<PK>>
  --
  type_restauration : VARCHAR2(80)
  materiau : VARCHAR2(80)
  date_pose : DATE
  duree_vie_estimee : NUMBER(5,1)
}

' Relations principales
franchise ||--o{ patient : "fréquente (0,1)-(0,n)"
franchise ||--o{ dossier : "gère (1,1)-(0,n)"
patient ||--o{ dossier : "a_pour_dossier (1,1)-(0,n)"
patient ||--o{ dent : "possède (1,1)-(0,n)"
dossier ||--o{ traitement : "contient (1,1)-(0,n)"
traitement ||--o{ acte : "réalise (1,1)-(0,n)"
personnel ||--o{ acte : "effectue (1,1)-(0,n)"
dent ||--o{ etat_dent : "observe (1,1)-(0,n)"
etat_dent ||--o{ restauration : "restaure (1,1)-(0,n)"

' Relations N:M (simplifiées)
personnel }o--o{ franchise : "travaille_dans"
etat_dent }o--o{ anomalie : "détecte"
acte }o--o{ etat_dent : "lie_à (0,1)"

@enduml
```

Visualisez sur : https://www.plantuml.com/plantuml/uml/

---

## 🎓 Logiciel Recommandé : Looping

**Looping** est un logiciel français gratuit spécialisé dans les MCD/MLD :

1. **Télécharger** : http://www.looping-mcd.fr/
2. **Avantages** :
   - Interface spécialement conçue pour les MCD français
   - Génération automatique du MLD depuis le MCD
   - Export SQL direct
   - Gestion des cardinalités à la française (0,1 - 1,1 - 0,n - 1,n)
   - Génération de scripts SQL pour Oracle, MySQL, PostgreSQL

3. **Utilisation** :
   - Créez les entités avec leurs attributs
   - Créez les associations avec les cardinalités
   - Looping génère automatiquement le MLD
   - Exportez en SQL pour Oracle

---

## 📋 Checklist pour créer votre MCD visuel

- [ ] Choisir l'outil (Draw.io, Looping, ERDPlus)
- [ ] Créer les 15 entités rectangulaires
- [ ] Ajouter les attributs dans chaque entité
- [ ] Souligner les clés primaires
- [ ] Créer les 20 associations (losanges)
- [ ] Relier les entités aux associations
- [ ] Ajouter les cardinalités sur chaque liaison
- [ ] Ajouter les attributs des associations N:M
- [ ] Vérifier la cohérence avec MODELE_CONCEPTUEL.md
- [ ] Exporter en PNG/PDF pour le rapport

---

## 💡 Conseil

Pour votre projet BUT SD, je recommande **Looping** car :
- C'est l'outil utilisé en France pour l'enseignement des MCD
- Il respecte la notation française Merise
- Il génère automatiquement le MLD et le SQL
- C'est gratuit et facile à utiliser

Le diagramme Mermaid ci-dessus est parfait pour GitHub, mais pour votre rendu final, créez un vrai diagramme visuel avec Looping ou Draw.io !
