-- Requêtes de vérification/analytique pour la base Dentissimo (Oracle)

-- A. Patients nouveaux vs récurrents sur 12 derniers mois
WITH visites AS (
    SELECT patient_id,
           MIN(date_creation) AS premiere_visite,
           COUNT(*) AS nb_visites
    FROM dossier_patient
    WHERE date_creation >= ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -12)
    GROUP BY patient_id
)
SELECT CASE WHEN nb_visites = 1 THEN 'NOUVEAU' ELSE 'RECURRENT' END AS type_patient,
       COUNT(*) AS total_patients
FROM visites
GROUP BY CASE WHEN nb_visites = 1 THEN 'NOUVEAU' ELSE 'RECURRENT' END;

-- Profil patientèle : distribution par tranche d'âge et sexe
SELECT CASE
           WHEN MONTHS_BETWEEN(SYSDATE, date_naissance)/12 < 18 THEN '-18'
           WHEN MONTHS_BETWEEN(SYSDATE, date_naissance)/12 < 35 THEN '18-34'
           WHEN MONTHS_BETWEEN(SYSDATE, date_naissance)/12 < 50 THEN '35-49'
           ELSE '50+'
       END AS tranche_age,
       sexe,
       COUNT(*) AS nb_patients
FROM patient
GROUP BY sexe,
         CASE
           WHEN MONTHS_BETWEEN(SYSDATE, date_naissance)/12 < 18 THEN '-18'
           WHEN MONTHS_BETWEEN(SYSDATE, date_naissance)/12 < 35 THEN '18-34'
           WHEN MONTHS_BETWEEN(SYSDATE, date_naissance)/12 < 50 THEN '35-49'
           ELSE '50+'
         END;

-- Fidélité : top patients par nombre de dossiers
SELECT p.nom, p.prenom, COUNT(d.dossier_id) AS nb_dossiers
FROM patient p
JOIN dossier_patient d ON d.patient_id = p.patient_id
GROUP BY p.nom, p.prenom
ORDER BY nb_dossiers DESC
FETCH FIRST 10 ROWS ONLY;

-- B. Dossiers ouverts vs fermés par franchise
SELECT f.nom AS franchise,
       SUM(CASE WHEN d.statut = 'OUVERT' THEN 1 ELSE 0 END) AS dossiers_ouverts,
       SUM(CASE WHEN d.statut = 'FERME'  THEN 1 ELSE 0 END) AS dossiers_fermes
FROM franchise f
LEFT JOIN dossier_patient d ON d.franchise_id = f.franchise_id
GROUP BY f.nom;

-- Statistiques actes médicaux : volume et montant moyen par type
SELECT type_acte,
       COUNT(*) AS nb_actes,
       AVG(montant) AS montant_moyen
FROM acte_medical
GROUP BY type_acte
ORDER BY nb_actes DESC;

-- Temps moyen de traitement (jours)
SELECT AVG(date_fin - date_debut) AS duree_moy_jours
FROM traitement
WHERE date_fin IS NOT NULL;

-- C. Revenus par type de soin (type d'acte payé)
SELECT am.type_acte,
       SUM(p.montant) AS revenu_total
FROM paiement p
JOIN acte_medical am ON p.acte_id = am.acte_id
GROUP BY am.type_acte
ORDER BY revenu_total DESC;

-- Paiements en retard
SELECT p.paiement_id, p.date_paiement, p.montant, p.mode_paiement,
       NVL(am.type_acte, 'Traitement global') AS cible
FROM paiement p
LEFT JOIN acte_medical am ON p.acte_id = am.acte_id
WHERE p.statut = 'EN_RETARD';

-- Revenu mensuel (12 derniers mois)
SELECT TO_CHAR(TRUNC(date_paiement, 'MM'), 'YYYY-MM') AS mois,
       SUM(montant) AS revenu_mensuel
FROM paiement
WHERE date_paiement >= ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -12)
GROUP BY TRUNC(date_paiement, 'MM')
ORDER BY mois;

-- D. Consultations par praticien
SELECT pr.nom || ' ' || pr.prenom AS praticien,
       COUNT(am.acte_id) AS nb_actes,
       SUM(am.montant) AS chiffre_affaires
FROM personnel pr
LEFT JOIN acte_medical am ON am.personnel_id = pr.personnel_id
GROUP BY pr.nom, pr.prenom
ORDER BY nb_actes DESC;

-- Efficacité praticien : montant moyen par acte
SELECT pr.nom || ' ' || pr.prenom AS praticien,
       AVG(am.montant) AS montant_moyen_acte
FROM personnel pr
JOIN acte_medical am ON am.personnel_id = pr.personnel_id
GROUP BY pr.nom, pr.prenom;

-- E. Suivi des produits consommés et reste en stock
SELECT pd.nom,
       pd.type_produit,
       pd.stock_quantite,
       NVL(consomme.qte_utilisee, 0) AS qte_utilisee,
       (pd.stock_quantite - NVL(consomme.qte_utilisee,0)) AS stock_theorique
FROM produit_dentaire pd
LEFT JOIN (
    SELECT produit_id, SUM(quantite_utilisee) AS qte_utilisee
    FROM acte_produit
    GROUP BY produit_id
) consomme ON consomme.produit_id = pd.produit_id;

-- Historique des commandes et valeur
SELECT c.commande_id, f.nom AS fournisseur, fr.nom AS franchise,
       c.date_commande, c.statut,
       SUM(cl.quantite * cl.prix_unitaire) AS montant_total
FROM commande c
JOIN fournisseur f ON f.fournisseur_id = c.fournisseur_id
JOIN franchise fr ON fr.franchise_id = c.franchise_id
JOIN commande_ligne cl ON cl.commande_id = c.commande_id
GROUP BY c.commande_id, f.nom, fr.nom, c.date_commande, c.statut
ORDER BY c.date_commande DESC;

-- Coût d'utilisation des équipements par acte (durée * coût amorti fictif)
SELECT am.acte_id,
       am.type_acte,
       SUM(ae.duree_minutes) AS duree_totale_min,
       COUNT(DISTINCT ae.equipement_id) AS nb_equipements
FROM acte_medical am
JOIN acte_equipement ae ON ae.acte_id = am.acte_id
GROUP BY am.acte_id, am.type_acte;

-- F. Anomalies les plus fréquentes par dent
SELECT d.patient_id, d.code_fdi, a.libelle, COUNT(*) AS nb_occurrences
FROM etat_dent_anomalie eda
JOIN etat_dent ed ON ed.etat_dent_id = eda.etat_dent_id
JOIN dent d ON d.dent_id = ed.dent_id
JOIN anomalie a ON a.anomalie_id = eda.anomalie_id
GROUP BY d.patient_id, d.code_fdi, a.libelle
ORDER BY nb_occurrences DESC;

-- Durabilité des restaurations (âge moyen en années)
SELECT type_restauration,
       AVG(MONTHS_BETWEEN(SYSDATE, date_pose)/12) AS age_moyen_ans
FROM restauration
GROUP BY type_restauration;

-- G. Répartition des patients par franchise (selon dossiers)
SELECT fr.nom AS franchise, COUNT(DISTINCT dp.patient_id) AS nb_patients
FROM franchise fr
LEFT JOIN dossier_patient dp ON dp.franchise_id = fr.franchise_id
GROUP BY fr.nom;

-- Activité par franchise et praticien (nombre d'actes)
SELECT fr.nom AS franchise,
       pr.nom || ' ' || pr.prenom AS praticien,
       COUNT(am.acte_id) AS nb_actes
FROM acte_medical am
JOIN traitement t ON t.traitement_id = am.traitement_id
JOIN dossier_patient dp ON dp.dossier_id = t.dossier_id
JOIN franchise fr ON fr.franchise_id = dp.franchise_id
JOIN personnel pr ON pr.personnel_id = am.personnel_id
GROUP BY fr.nom, pr.nom, pr.prenom
ORDER BY fr.nom, nb_actes DESC;

-- H. Dépenses par type de produit (consommables)
SELECT type_produit,
       SUM(quantite * prix_unitaire) AS montant_commande
FROM commande_ligne cl
JOIN produit_dentaire pd ON pd.produit_id = cl.produit_id
GROUP BY type_produit;

-- Rentabilité des traitements (revenus - coûts consommables utilisés)
WITH revenus AS (
    SELECT COALESCE(p.traitement_id, am.traitement_id) AS traitement_id,
           SUM(p.montant) AS revenu
    FROM paiement p
    LEFT JOIN acte_medical am ON am.acte_id = p.acte_id
    GROUP BY COALESCE(p.traitement_id, am.traitement_id)
), couts AS (
    SELECT am.traitement_id, SUM(ap.quantite_utilisee * pd.prix_unitaire) AS cout_consommable
    FROM acte_medical am
    JOIN acte_produit ap ON ap.acte_id = am.acte_id
    JOIN produit_dentaire pd ON pd.produit_id = ap.produit_id
    GROUP BY am.traitement_id
)
SELECT t.traitement_id,
       NVL(revenus.revenu, 0) AS revenu,
       NVL(couts.cout_consommable, 0) AS cout_consommable,
       NVL(revenus.revenu, 0) - NVL(couts.cout_consommable, 0) AS marge_estimee
FROM traitement t
LEFT JOIN revenus ON revenus.traitement_id = t.traitement_id
LEFT JOIN couts ON couts.traitement_id = t.traitement_id
ORDER BY t.traitement_id;
