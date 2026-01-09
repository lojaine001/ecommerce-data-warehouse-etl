# Fichiers de Données - Projet SAD E-Commerce

## 📦 Contenu des Fichiers

### 1. **commandes.json** (50 commandes)
- Fichier JSON contenant 50 commandes du 15/01/2024 au 10/05/2024
- Champs: CommandeID, ClientID, ProduitID, Quantite, MontantTotal, DateCommande, Statut
- Statuts variés: Validée, Annulée, En attente
- Montants de 15.99€ à 3196.00€

### 2. **produits.csv** (25 produits)
- Fichier CSV avec 25 produits dans 4 catégories
- Catégories: Électronique, Meubles, Éducation, Accessoires
- Champs: ProduitID, NomProduit, Categorie, Prix
- Prix de 14.99€ à 899.99€

### 3. **paiements.log** (50 logs de paiement)
- Fichier LOG avec statuts des paiements
- Format: [Date Heure] CommandeID | ClientID | Statut Paiement | Montant
- Statuts: Réussi, Échoué, En attente
- Correspond aux 50 commandes du fichier JSON

### 4. **clients_mysql.sql** (20 clients)
- Script SQL pour créer et remplir la table clients dans MySQL
- 20 clients de 11 pays différents (France, Maroc, Espagne, etc.)
- Champs: ClientID, NomClient, Pays, DateInscription, Email, Ville
- Prêt à exécuter dans MySQL Workbench ou ligne de commande

## 📊 Statistiques des Données

- **50 commandes** sur 5 mois (janvier à mai 2024)
- **25 produits** dans 4 catégories
- **20 clients** de 11 pays différents
- **Montant total des ventes**: ~25,000€
- **Taux de validation**: ~70% (commandes validées)
- **Taux d'annulation**: ~16%
- **En attente**: ~14%

## 🚀 Utilisation avec votre Projet

### Étape 1: Importer dans MySQL
```bash
mysql -u root -p < clients_mysql.sql
```

### Étape 2: Placer les fichiers
- **commandes.json** → Dossier de sources Talend
- **produits.csv** → Dossier de sources Talend
- **paiements.log** → Dossier de sources Talend
- **clients_mysql.sql** → Exécuter dans MySQL

### Étape 3: Configurer Talend
- Job 1: Extraction JSON (commandes)
- Job 2: Extraction CSV (produits)
- Job 3: Extraction MySQL (clients)
- Job 4: Parsing LOG (paiements)

### Étape 4: Charger dans PostgreSQL/BigQuery
- Table de faits: Faits_Commandes
- Dimensions: Dim_Clients, Dim_Produits, Dim_Temps

## 📝 Notes Importantes

1. Les ClientID vont de 2001 à 2020
2. Les ProduitID vont de 3001 à 3025
3. Les CommandeID vont de 1001 à 1050
4. Toutes les clés étrangères sont cohérentes
5. Les dates vont de janvier à mai 2024

## 🎯 Compatibilité

- ✅ PostgreSQL (local)
- ✅ Google BigQuery (cloud)
- ✅ Azure SQL Database (cloud)
- ✅ Amazon RDS (cloud)
- ✅ Talend Open Studio
- ✅ Power BI

## 📧 Structure Recommandée du Schéma

### Table de Faits: Faits_Commandes
- CommandeID (PK)
- ClientID (FK)
- ProduitID (FK)
- DateID (FK)
- Quantite
- MontantTotal
- StatutCommande
- StatutPaiement

### Dimension: Dim_Clients
- ClientID (PK)
- NomClient
- Pays
- Ville
- DateInscription
- Email

### Dimension: Dim_Produits
- ProduitID (PK)
- NomProduit
- Categorie
- Prix

### Dimension: Dim_Temps
- DateID (PK)
- Date
- Jour
- Mois
- Annee
- Trimestre

---

**Créé pour le Mini-Projet 3IABD - ISGA Marrakech**
**Cours de M. SNINEH Sidi Mohamed**
