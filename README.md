# ecommerce-data-warehouse-etl
# 🛒 Système d'Aide à la Décision E-Commerce avec Data Warehouse

> Projet académique de Business Intelligence - Analyse des ventes en ligne avec PostgreSQL, Pentaho ETL et Power BI

[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-blue)](https://www.postgresql.org/)
[![Pentaho](https://img.shields.io/badge/Pentaho-9.4-orange)](https://www.hitachivantara.com/en-us/products/pentaho-platform.html)
[![Power BI](https://img.shields.io/badge/Power_BI-Desktop-yellow)](https://powerbi.microsoft.com/)

## 📊 Vue d'ensemble

Système décisionnel complet pour l'analyse des achats en ligne, incluant :
- **Data Warehouse** avec schéma en étoile (PostgreSQL)
- **Pipelines ETL** automatisés (Pentaho Data Integration)
- **Tableaux de bord interactifs** (Power BI)

**Données :** 50 commandes, 25 produits, 20 clients

## 🏗️ Architecture

![Architecture](docs/images/architecture.png)

### Schéma en étoile
- **Table de faits :** Faits_Commandes (50 lignes)
- **Dimensions :**
  - Dim_Clients (20 clients)
  - Dim_Produits (25 produits)
  - Dim_Temps (730 dates)

## 🔄 Processus ETL

### Transformation 1 : Chargement des produits
CSV → Pentaho → PostgreSQL (25 produits)

### Transformation 2 : Chargement des clients
PostgreSQL Staging → Calculs (année/mois) → Dimension Clients

### Transformation 3 : Chargement des commandes
JSON → Calculs (PrixUnitaire, ChiffreAffaires, DateID) → Table de faits

## 📈 Tableaux de bord Power BI

- **Vue d'ensemble :** KPIs, tendances mensuelles
- **Analyse produits :** Top 10, ventes par catégorie
- **Analyse clients :** Carte géographique, top clients

## 🚀 Installation

### Prérequis
- PostgreSQL 16
- Pentaho Data Integration 9.4
- Power BI Desktop

### Étapes
1. Créer la base de données :
```sql
   psql -U postgres -f 01-database/schema.sql
```

2. Exécuter les transformations Pentaho dans l'ordre :
   - Load_Dim_Produits.ktr
   - Load_Dim_Clients.ktr
   - Load_Faits_Commandes.ktr

3. Ouvrir dashboard.pbix dans Power BI

## 📁 Structure du projet
```
├── 01-database/       # Scripts SQL
├── 02-data-sources/   # Données sources (CSV, JSON, logs)
├── 03-pentaho-etl/    # Transformations Pentaho
├── 04-powerbi/        # Tableaux de bord
└── 05-documentation/  # Rapports et présentation
```

## 🎓 Contexte académique

**Projet :** Mini-projet Système d'Aide à la Décision  
**École :** ISGA Marrakech - 3IABD  
**Professeur :** M. SNINEH Sidi Mohamed  
**Année :** 2024-2025

## 📸 Captures d'écran

### Pentaho ETL
![ETL Flow](docs/images/etl-flow.png)

### Power BI Dashboard
![Dashboard](docs/images/dashboard-preview.png)

## 🛠️ Technologies utilisées

- **Base de données :** PostgreSQL 16
- **ETL :** Pentaho Data Integration 9.4
- **BI :** Power BI Desktop
- **Formats de données :** JSON, CSV, Log files




---

⭐ Si ce projet vous aide, n'hésitez pas à mettre une étoile !
```


