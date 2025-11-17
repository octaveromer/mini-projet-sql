-- Jeu de données de test pour la clinique Dentissimo
-- L'ordre des insertions respecte les contraintes de clés étrangères.

-- Franchises
INSERT INTO franchise (nom, adresse, ville, code_postal, telephone) VALUES
('Dentissimo Centre', '12 rue des Lilas', 'Lyon', '69003', '04 78 00 00 01');
INSERT INTO franchise (nom, adresse, ville, code_postal, telephone) VALUES
('Dentissimo Rive-Gauche', '5 avenue du Rhône', 'Lyon', '69007', '04 78 00 00 02');

-- Personnel
INSERT INTO personnel (nom, prenom, role_metier, specialite, type_contrat, telephone, email) VALUES
('Martin', 'Alice', 'Dentiste', 'Implantologie', 'INTERNE', '060000001', 'alice.martin@dentissimo.fr');
INSERT INTO personnel (nom, prenom, role_metier, specialite, type_contrat, telephone, email) VALUES
('Durand', 'Paul', 'Hygiéniste', NULL, 'INTERNE', '060000002', 'paul.durand@dentissimo.fr');
INSERT INTO personnel (nom, prenom, role_metier, specialite, type_contrat, telephone, email) VALUES
('Bernard', 'Luc', 'Dentiste', 'Endodontie', 'EXTERNE', '060000003', 'luc.bernard@cabinet-lb.fr');

-- Affectations
INSERT INTO franchise_personnel (franchise_id, personnel_id, date_debut) VALUES (1, 1, DATE '2024-01-01');
INSERT INTO franchise_personnel (franchise_id, personnel_id, date_debut) VALUES (1, 2, DATE '2024-01-01');
INSERT INTO franchise_personnel (franchise_id, personnel_id, date_debut) VALUES (2, 3, DATE '2024-03-01');

-- Patients
INSERT INTO patient (nom, prenom, date_naissance, sexe, telephone, email, adresse, ville, code_postal, franchise_ref_id) VALUES
('Dupont', 'Emma', DATE '1990-04-12', 'F', '061000001', 'emma.dupont@mail.com', '3 rue du Parc', 'Lyon', '69001', 1);
INSERT INTO patient (nom, prenom, date_naissance, sexe, telephone, email, adresse, ville, code_postal, franchise_ref_id) VALUES
('Lopez', 'Carlos', DATE '1985-09-30', 'M', '062000002', 'carlos.lopez@mail.com', '22 quai Victor', 'Lyon', '69002', 1);
INSERT INTO patient (nom, prenom, date_naissance, sexe, telephone, email, adresse, ville, code_postal, franchise_ref_id) VALUES
('Nguyen', 'Mai', DATE '2000-01-05', 'F', '063000003', 'mai.nguyen@mail.com', '15 rue des Acacias', 'Villeurbanne', '69100', 2);

-- Dossiers
INSERT INTO dossier_patient (patient_id, franchise_id, date_creation, statut, motif_consultation, notes_generales) VALUES
(1, 1, DATE '2025-01-10', 'OUVERT', 'Contrôle annuel', 'RAS en 2024');
INSERT INTO dossier_patient (patient_id, franchise_id, date_creation, statut, motif_consultation, notes_generales) VALUES
(2, 1, DATE '2025-02-02', 'OUVERT', 'Douleur molaire', 'Antécédent de carie en 2023');
INSERT INTO dossier_patient (patient_id, franchise_id, date_creation, statut, motif_consultation, notes_generales) VALUES
(3, 2, DATE '2025-03-18', 'OUVERT', 'Blanchiment', 'Première visite');

-- Traitements
INSERT INTO traitement (dossier_id, date_debut, date_fin, description, cout_estime, statut) VALUES
(1, DATE '2025-01-10', NULL, 'Contrôle et détartrage', 120, 'EN_COURS');
INSERT INTO traitement (dossier_id, date_debut, date_fin, description, cout_estime, statut) VALUES
(2, DATE '2025-02-03', DATE '2025-02-15', 'Traitement carie molaire bas droite', 350, 'TERMINE');
INSERT INTO traitement (dossier_id, date_debut, date_fin, description, cout_estime, statut) VALUES
(3, DATE '2025-03-20', NULL, 'Plan blanchiment', 500, 'PLANIFIE');

-- Actes médicaux
INSERT INTO acte_medical (traitement_id, personnel_id, type_acte, description, date_acte, montant, radiographie_ref, prescription_text) VALUES
(1, 1, 'Détartrage', 'Nettoyage complet', DATE '2025-01-10', 80, NULL, 'Bicarbonate hydratation');
INSERT INTO acte_medical (traitement_id, personnel_id, type_acte, description, date_acte, montant, radiographie_ref, prescription_text) VALUES
(2, 1, 'Radio', 'Radio molaire bas droite', DATE '2025-02-03', 50, 'radio_carlos_20250203.png', NULL);
INSERT INTO acte_medical (traitement_id, personnel_id, type_acte, description, date_acte, montant, radiographie_ref, prescription_text) VALUES
(2, 3, 'Obturation', 'Obturation composite', DATE '2025-02-10', 300, NULL, 'Antibiotique 5 jours');
INSERT INTO acte_medical (traitement_id, personnel_id, type_acte, description, date_acte, montant, radiographie_ref, prescription_text) VALUES
(3, 1, 'Consultation', 'Plan de blanchiment', DATE '2025-03-20', 70, NULL, NULL);

-- Paiements (acte ou traitement)
INSERT INTO paiement (acte_id, traitement_id, date_paiement, montant, mode_paiement, statut) VALUES
(1, NULL, DATE '2025-01-10', 80, 'CB', 'PAYE');
INSERT INTO paiement (acte_id, traitement_id, date_paiement, montant, mode_paiement, statut) VALUES
(2, NULL, DATE '2025-02-04', 50, 'CB', 'PAYE');
INSERT INTO paiement (acte_id, traitement_id, date_paiement, montant, mode_paiement, statut) VALUES
(3, NULL, DATE '2025-02-15', 300, 'CB', 'PAYE');
INSERT INTO paiement (acte_id, traitement_id, date_paiement, montant, mode_paiement, statut) VALUES
(NULL, 3, DATE '2025-03-22', 200, 'VIREMENT', 'PARTIEL');

-- Produits dentaires
INSERT INTO produit_dentaire (nom, type_produit, stock_quantite, unite, seuil_alerte, prix_unitaire) VALUES
('Composite A2', 'Composite', 40, 'unite', 10, 25);
INSERT INTO produit_dentaire (nom, type_produit, stock_quantite, unite, seuil_alerte, prix_unitaire) VALUES
('Anesthésiant xylocaine', 'Anesthésiant', 200, 'ml', 50, 0.5);
INSERT INTO produit_dentaire (nom, type_produit, stock_quantite, unite, seuil_alerte, prix_unitaire) VALUES
('Gant nitrile', 'Consommable', 500, 'paire', 100, 0.2);
INSERT INTO produit_dentaire (nom, type_produit, stock_quantite, unite, seuil_alerte, prix_unitaire) VALUES
('Fil dentaire', 'Consommable', 300, 'unite', 50, 0.15);

-- Fournisseurs
INSERT INTO fournisseur (nom, contact, telephone, email) VALUES
('DentalSupplies', 'Jean Fournier', '045600001', 'contact@dentalsupplies.fr');
INSERT INTO fournisseur (nom, contact, telephone, email) VALUES
('MedicalPlus', 'Sophie Martin', '045600002', 'sophie@medicalplus.fr');

-- Commandes
INSERT INTO commande (fournisseur_id, franchise_id, date_commande, statut, date_livraison) VALUES
(1, 1, DATE '2025-01-05', 'LIVREE', DATE '2025-01-12');
INSERT INTO commande (fournisseur_id, franchise_id, date_commande, statut, date_livraison) VALUES
(2, 2, DATE '2025-03-01', 'PARTIELLE', DATE '2025-03-10');

INSERT INTO commande_ligne (commande_id, produit_id, quantite, prix_unitaire) VALUES
(1, 1, 30, 22);
INSERT INTO commande_ligne (commande_id, produit_id, quantite, prix_unitaire) VALUES
(1, 3, 300, 0.18);
INSERT INTO commande_ligne (commande_id, produit_id, quantite, prix_unitaire) VALUES
(2, 2, 150, 0.45);
INSERT INTO commande_ligne (commande_id, produit_id, quantite, prix_unitaire) VALUES
(2, 4, 150, 0.12);

-- Equipements
INSERT INTO equipement (franchise_id, nom, categorie, date_acquisition, cout_acquisition, statut) VALUES
(1, 'Fauteuil Planmeca', 'Fauteuil', DATE '2023-01-05', 12000, 'ACTIF');
INSERT INTO equipement (franchise_id, nom, categorie, date_acquisition, cout_acquisition, statut) VALUES
(1, 'Radio pano Carestream', 'Radiologie', DATE '2022-06-15', 20000, 'ACTIF');
INSERT INTO equipement (franchise_id, nom, categorie, date_acquisition, cout_acquisition, statut) VALUES
(2, 'Fauteuil Sirona', 'Fauteuil', DATE '2024-02-01', 15000, 'ACTIF');

-- Dents (codes FDI)
INSERT INTO dent (patient_id, code_fdi, commentaire) VALUES
(1, '11', 'Incisive sup. droite');
INSERT INTO dent (patient_id, code_fdi, commentaire) VALUES
(1, '26', 'Molaire sup. gauche');
INSERT INTO dent (patient_id, code_fdi, commentaire) VALUES
(2, '46', 'Molaire inf. droite douloureuse');
INSERT INTO dent (patient_id, code_fdi, commentaire) VALUES
(3, '21', 'Incisive sup. gauche');

-- Etats de dents
INSERT INTO etat_dent (dent_id, date_observation, description, acte_id) VALUES
(1, DATE '2025-01-10', 'Contrôle OK', 1);
INSERT INTO etat_dent (dent_id, date_observation, description, acte_id) VALUES
(2, DATE '2025-01-10', 'Légère tartre', 1);
INSERT INTO etat_dent (dent_id, date_observation, description, acte_id) VALUES
(3, DATE '2025-02-03', 'Caries détectée', 2);
INSERT INTO etat_dent (dent_id, date_observation, description, acte_id) VALUES
(3, DATE '2025-02-10', 'Après obturation', 3);
INSERT INTO etat_dent (dent_id, date_observation, description, acte_id) VALUES
(4, DATE '2025-03-20', 'Teinte naturelle A2', 4);

-- Anomalies catalogue
INSERT INTO anomalie (libelle, description, severite) VALUES
('Caries', 'Lésion carieuse', 'MODERE');
INSERT INTO anomalie (libelle, description, severite) VALUES
('Fracture', 'Fissure couronne', 'SEVERE');
INSERT INTO anomalie (libelle, description, severite) VALUES
('Inflammation', 'Gencive inflammée', 'LEGER');

-- Anomalies constatées
INSERT INTO etat_dent_anomalie (etat_dent_id, anomalie_id) VALUES
(3, 1);

-- Restaurations
INSERT INTO restauration (etat_dent_id, type_restauration, materiau, date_pose, duree_vie_estimee) VALUES
(4, 'Obturation', 'Composite A2', DATE '2025-02-10', 8);

-- Produits utilisés par acte
INSERT INTO acte_produit (acte_id, produit_id, quantite_utilisee) VALUES
(3, 1, 1); -- composite
INSERT INTO acte_produit (acte_id, produit_id, quantite_utilisee) VALUES
(3, 2, 2); -- anesthésiant
INSERT INTO acte_produit (acte_id, produit_id, quantite_utilisee) VALUES
(1, 3, 2); -- gants

-- Equipements utilisés
INSERT INTO acte_equipement (acte_id, equipement_id, duree_minutes) VALUES
(1, 1, 30);
INSERT INTO acte_equipement (acte_id, equipement_id, duree_minutes) VALUES
(2, 2, 15);
INSERT INTO acte_equipement (acte_id, equipement_id, duree_minutes) VALUES
(3, 1, 45);

COMMIT;
