-- ============================================================================
-- SCHÉMA EN ÉTOILE POUR L'ENTREPÔT DE DONNÉES E-COMMERCE
-- Base de données: EntrepotCommandes (PostgreSQL)
-- Projet: Système d'Aide à la Décision - ISGA Marrakech
-- ============================================================================

-- Se connecter à la base de données
\c EntrepotCommandes;

-- ============================================================================
-- PARTIE 1: TABLES SOURCES (STAGING)
-- Ces tables reçoivent les données brutes avant transformation
-- ============================================================================

-- Table staging pour les clients (source)
DROP TABLE IF EXISTS staging_clients CASCADE;
CREATE TABLE staging_clients (
    ClientID INT PRIMARY KEY,
    NomClient VARCHAR(255) NOT NULL,
    Pays VARCHAR(50) NOT NULL,
    DateInscription DATE NOT NULL,
    Email VARCHAR(255),
    Ville VARCHAR(100)
);

-- Insérer les données clients (20 clients)
INSERT INTO staging_clients (ClientID, NomClient, Pays, DateInscription, Email, Ville) VALUES
(2001, 'Jean Dupont', 'France', '2023-01-15', 'jean.dupont@email.fr', 'Paris'),
(2002, 'Sarah Williams', 'États-Unis', '2023-02-20', 'sarah.w@email.com', 'New York'),
(2003, 'Carlos García', 'Espagne', '2023-03-10', 'carlos.g@email.es', 'Madrid'),
(2004, 'Mohammed Alami', 'Maroc', '2023-04-05', 'm.alami@email.ma', 'Casablanca'),
(2005, 'Emma Schmidt', 'Allemagne', '2023-04-18', 'emma.s@email.de', 'Berlin'),
(2006, 'Li Wei', 'Chine', '2023-05-22', 'li.wei@email.cn', 'Shanghai'),
(2007, 'Marco Rossi', 'Italie', '2023-06-12', 'marco.r@email.it', 'Rome'),
(2008, 'Fatima Zahra', 'Maroc', '2023-06-25', 'f.zahra@email.ma', 'Marrakech'),
(2009, 'John Smith', 'Royaume-Uni', '2023-07-08', 'john.s@email.uk', 'Londres'),
(2010, 'Sophie Martin', 'France', '2023-07-20', 'sophie.m@email.fr', 'Lyon'),
(2011, 'Ahmed Hassan', 'Égypte', '2023-08-14', 'ahmed.h@email.eg', 'Le Caire'),
(2012, 'Maria Silva', 'Portugal', '2023-08-28', 'maria.s@email.pt', 'Lisbonne'),
(2013, 'Yuki Tanaka', 'Japon', '2023-09-10', 'yuki.t@email.jp', 'Tokyo'),
(2014, 'Pierre Dubois', 'Belgique', '2023-09-22', 'pierre.d@email.be', 'Bruxelles'),
(2015, 'Anna Kowalski', 'Pologne', '2023-10-05', 'anna.k@email.pl', 'Varsovie'),
(2016, 'Omar Benjelloun', 'Maroc', '2023-10-18', 'o.benjelloun@email.ma', 'Rabat'),
(2017, 'Isabella Romano', 'Italie', '2023-11-02', 'isabella.r@email.it', 'Milan'),
(2018, 'Henrik Larsson', 'Suède', '2023-11-15', 'henrik.l@email.se', 'Stockholm'),
(2019, 'Lucas Fernandez', 'Espagne', '2023-12-01', 'lucas.f@email.es', 'Barcelone'),
(2020, 'Amina Idrissi', 'Maroc', '2023-12-20', 'amina.i@email.ma', 'Fès');

COMMENT ON TABLE staging_clients IS 'Table source pour les données clients (avant transformation)';

-- ============================================================================
-- PARTIE 2: TABLES DE DIMENSIONS
-- ============================================================================

-- DIMENSION: Clients
DROP TABLE IF EXISTS Dim_Clients CASCADE;
CREATE TABLE Dim_Clients (
    ClientID INT PRIMARY KEY,
    NomClient VARCHAR(255) NOT NULL,
    Pays VARCHAR(50) NOT NULL,
    Ville VARCHAR(100),
    Email VARCHAR(255),
    DateInscription DATE NOT NULL,
    AnneeInscription INT,
    MoisInscription INT,
    -- Métadonnées ETL
    DateChargement TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    SourceSysteme VARCHAR(50) DEFAULT 'PostgreSQL'
);

COMMENT ON TABLE Dim_Clients IS 'Dimension Clients - Informations sur les clients';

-- Index pour améliorer les performances
CREATE INDEX idx_dim_clients_pays ON Dim_Clients(Pays);
CREATE INDEX idx_dim_clients_ville ON Dim_Clients(Ville);

-- DIMENSION: Produits
DROP TABLE IF EXISTS Dim_Produits CASCADE;
CREATE TABLE Dim_Produits (
    ProduitID INT PRIMARY KEY,
    NomProduit VARCHAR(255) NOT NULL,
    Categorie VARCHAR(100) NOT NULL,
    Prix DECIMAL(10, 2) NOT NULL,
    -- Attributs calculés
    Gammeprix VARCHAR(20),
    -- Métadonnées ETL
    DateChargement TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    SourceSysteme VARCHAR(50) DEFAULT 'CSV'
);

COMMENT ON TABLE Dim_Produits IS 'Dimension Produits - Catalogue des produits';

-- Index pour améliorer les performances
CREATE INDEX idx_dim_produits_categorie ON Dim_Produits(Categorie);
CREATE INDEX idx_dim_produits_gamme ON Dim_Produits(Gammeprix);

-- DIMENSION: Temps
DROP TABLE IF EXISTS Dim_Temps CASCADE;
CREATE TABLE Dim_Temps (
    DateID INT PRIMARY KEY,
    DateComplete DATE NOT NULL UNIQUE,
    Jour INT NOT NULL,
    Mois INT NOT NULL,
    Annee INT NOT NULL,
    Trimestre INT NOT NULL,
    Semaine INT NOT NULL,
    NomMois VARCHAR(20),
    NomJour VARCHAR(20),
    EstWeekend BOOLEAN,
    -- Métadonnées
    DateChargement TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE Dim_Temps IS 'Dimension Temps - Dates pour analyse temporelle';

-- Index pour améliorer les performances
CREATE INDEX idx_dim_temps_date ON Dim_Temps(DateComplete);
CREATE INDEX idx_dim_temps_annee_mois ON Dim_Temps(Annee, Mois);
CREATE INDEX idx_dim_temps_trimestre ON Dim_Temps(Annee, Trimestre);

-- ============================================================================
-- PARTIE 3: TABLE DE FAITS
-- ============================================================================

-- TABLE DE FAITS: Commandes
DROP TABLE IF EXISTS Faits_Commandes CASCADE;
CREATE TABLE Faits_Commandes (
    -- Clés
    CommandeID INT PRIMARY KEY,
    ClientID INT NOT NULL,
    ProduitID INT NOT NULL,
    DateID INT NOT NULL,
    
    -- Mesures
    Quantite INT NOT NULL,
    MontantTotal DECIMAL(10, 2) NOT NULL,
    PrixUnitaire DECIMAL(10, 2),
    
    -- Attributs descriptifs
    StatutCommande VARCHAR(20) NOT NULL,
    StatutPaiement VARCHAR(20),
    
    -- Mesures calculées
    ChiffreAffaires DECIMAL(10, 2),
    
    -- Métadonnées ETL
    DateChargement TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    SourceSysteme VARCHAR(50) DEFAULT 'JSON',
    
    -- Clés étrangères
    CONSTRAINT fk_faits_client FOREIGN KEY (ClientID) 
        REFERENCES Dim_Clients(ClientID),
    CONSTRAINT fk_faits_produit FOREIGN KEY (ProduitID) 
        REFERENCES Dim_Produits(ProduitID),
    CONSTRAINT fk_faits_temps FOREIGN KEY (DateID) 
        REFERENCES Dim_Temps(DateID)
);

COMMENT ON TABLE Faits_Commandes IS 'Table de faits - Transactions de commandes';

-- Index pour améliorer les performances des requêtes analytiques
CREATE INDEX idx_faits_client ON Faits_Commandes(ClientID);
CREATE INDEX idx_faits_produit ON Faits_Commandes(ProduitID);
CREATE INDEX idx_faits_date ON Faits_Commandes(DateID);
CREATE INDEX idx_faits_statut ON Faits_Commandes(StatutCommande);
CREATE INDEX idx_faits_montant ON Faits_Commandes(MontantTotal);

-- ============================================================================
-- PARTIE 4: FONCTIONS UTILITAIRES
-- ============================================================================

-- Fonction pour générer la dimension temps automatiquement
CREATE OR REPLACE FUNCTION generer_dimension_temps(
    date_debut DATE,
    date_fin DATE
) RETURNS VOID AS $$
DECLARE
    current_date DATE;
    date_id INT;
BEGIN
    current_date := date_debut;
    
    WHILE current_date <= date_fin LOOP
        -- Générer DateID au format YYYYMMDD
        date_id := TO_CHAR(current_date, 'YYYYMMDD')::INT;
        
        -- Insérer la date si elle n'existe pas déjà
        INSERT INTO Dim_Temps (
            DateID, DateComplete, Jour, Mois, Annee, Trimestre, Semaine,
            NomMois, NomJour, EstWeekend
        ) VALUES (
            date_id,
            current_date,
            EXTRACT(DAY FROM current_date)::INT,
            EXTRACT(MONTH FROM current_date)::INT,
            EXTRACT(YEAR FROM current_date)::INT,
            EXTRACT(QUARTER FROM current_date)::INT,
            EXTRACT(WEEK FROM current_date)::INT,
            TO_CHAR(current_date, 'Month'),
            TO_CHAR(current_date, 'Day'),
            CASE WHEN EXTRACT(DOW FROM current_date) IN (0, 6) THEN TRUE ELSE FALSE END
        ) ON CONFLICT (DateComplete) DO NOTHING;
        
        current_date := current_date + INTERVAL '1 day';
    END LOOP;
    
    RAISE NOTICE 'Dimension Temps générée de % à %', date_debut, date_fin;
END;
$$ LANGUAGE plpgsql;

-- Générer la dimension temps pour 2023-2024
SELECT generer_dimension_temps('2023-01-01'::DATE, '2024-12-31'::DATE);

-- ============================================================================
-- PARTIE 5: VUES ANALYTIQUES
-- ============================================================================

-- Vue: Ventes par produit et catégorie
CREATE OR REPLACE VIEW Vue_Ventes_Par_Produit AS
SELECT 
    p.ProduitID,
    p.NomProduit,
    p.Categorie,
    p.Prix,
    COUNT(f.CommandeID) AS NombreCommandes,
    SUM(f.Quantite) AS QuantiteTotale,
    SUM(f.MontantTotal) AS ChiffreAffairesTotal,
    AVG(f.MontantTotal) AS MontantMoyen,
    MAX(f.DateChargement) AS DerniereVente
FROM Dim_Produits p
LEFT JOIN Faits_Commandes f ON p.ProduitID = f.ProduitID
GROUP BY p.ProduitID, p.NomProduit, p.Categorie, p.Prix
ORDER BY ChiffreAffairesTotal DESC NULLS LAST;

-- Vue: Ventes par client et pays
CREATE OR REPLACE VIEW Vue_Ventes_Par_Client AS
SELECT 
    c.ClientID,
    c.NomClient,
    c.Pays,
    c.Ville,
    COUNT(f.CommandeID) AS NombreCommandes,
    SUM(f.Quantite) AS QuantiteTotale,
    SUM(f.MontantTotal) AS ChiffreAffairesTotal,
    AVG(f.MontantTotal) AS PanierMoyen,
    MAX(t.DateComplete) AS DerniereCommande
FROM Dim_Clients c
LEFT JOIN Faits_Commandes f ON c.ClientID = f.ClientID
LEFT JOIN Dim_Temps t ON f.DateID = t.DateID
GROUP BY c.ClientID, c.NomClient, c.Pays, c.Ville
ORDER BY ChiffreAffairesTotal DESC NULLS LAST;

-- Vue: Ventes par période (mois)
CREATE OR REPLACE VIEW Vue_Ventes_Par_Mois AS
SELECT 
    t.Annee,
    t.Mois,
    t.NomMois,
    t.Trimestre,
    COUNT(f.CommandeID) AS NombreCommandes,
    SUM(f.Quantite) AS QuantiteTotale,
    SUM(f.MontantTotal) AS ChiffreAffairesTotal,
    AVG(f.MontantTotal) AS PanierMoyen,
    COUNT(DISTINCT f.ClientID) AS NombreClientsActifs
FROM Dim_Temps t
LEFT JOIN Faits_Commandes f ON t.DateID = f.DateID
GROUP BY t.Annee, t.Mois, t.NomMois, t.Trimestre
ORDER BY t.Annee, t.Mois;

-- Vue: Performance par statut de commande
CREATE OR REPLACE VIEW Vue_Statuts_Commandes AS
SELECT 
    f.StatutCommande,
    COUNT(f.CommandeID) AS NombreCommandes,
    SUM(f.MontantTotal) AS ChiffreAffaires,
    AVG(f.MontantTotal) AS MontantMoyen,
    ROUND(COUNT(f.CommandeID) * 100.0 / SUM(COUNT(f.CommandeID)) OVER (), 2) AS Pourcentage
FROM Faits_Commandes f
GROUP BY f.StatutCommande
ORDER BY NombreCommandes DESC;

-- ============================================================================
-- PARTIE 6: STATISTIQUES ET VÉRIFICATIONS
-- ============================================================================

-- Afficher les statistiques des tables
DO $$
BEGIN
    RAISE NOTICE '============================================================';
    RAISE NOTICE 'STATISTIQUES DE L''ENTREPÔT DE DONNÉES';
    RAISE NOTICE '============================================================';
    RAISE NOTICE 'Tables sources:';
    RAISE NOTICE '  - staging_clients: % lignes', (SELECT COUNT(*) FROM staging_clients);
    RAISE NOTICE '';
    RAISE NOTICE 'Dimensions:';
    RAISE NOTICE '  - Dim_Clients: % lignes', (SELECT COUNT(*) FROM Dim_Clients);
    RAISE NOTICE '  - Dim_Produits: % lignes', (SELECT COUNT(*) FROM Dim_Produits);
    RAISE NOTICE '  - Dim_Temps: % lignes', (SELECT COUNT(*) FROM Dim_Temps);
    RAISE NOTICE '';
    RAISE NOTICE 'Table de faits:';
    RAISE NOTICE '  - Faits_Commandes: % lignes', (SELECT COUNT(*) FROM Faits_Commandes);
    RAISE NOTICE '';
    RAISE NOTICE 'Vues analytiques créées: 4';
    RAISE NOTICE '============================================================';
END $$;

-- ============================================================================
-- FIN DU SCRIPT
-- ============================================================================

-- Messages de confirmation
\echo '✅ Schéma en étoile créé avec succès !'
\echo '✅ Tables de dimensions créées: Dim_Clients, Dim_Produits, Dim_Temps'
\echo '✅ Table de faits créée: Faits_Commandes'
\echo '✅ Vues analytiques créées'
\echo ''
\echo '📊 Prochaines étapes:'
\echo '   1. Charger les données avec Talend ETL'
\echo '   2. Connecter Power BI pour les rapports'
\echo '   3. Migrer vers BigQuery à la fin'
