# 🔐 INFORMATIONS DE CONNEXION - PROJET SAD E-COMMERCE

## 📊 PostgreSQL (Base de données locale)

### Informations générales
- **Type** : PostgreSQL 16
- **Host** : localhost (ou 127.0.0.1)
- **Port** : 5432
- **Database** : EntrepotCommandes
- **Schema** : public
- **Username** : postgres
- **Password** : [VOTRE_MOT_DE_PASSE_ICI]

⚠️ **IMPORTANT** : Notez votre mot de passe PostgreSQL ici : ___________________________

---

## 🔧 PENTAHO DATA INTEGRATION (PDI) - Configuration des connexions

### Connexion PostgreSQL (Entrepôt de données)

**Dans Spoon : View → Database Connections → New**

```
Connection Name : PostgreSQL_EntrepotCommandes
Connection Type : PostgreSQL
Access : Native (JDBC)
Host Name : localhost
Database Name : EntrepotCommandes
Port Number : 5432
User Name : postgres
Password : [votre_mot_de_passe]
```

**Steps Pentaho à utiliser :**

**Input (Lecture) :**
- `CSV file input` - Lire produits.csv
- `JSON input` - Lire commandes.json
- `Text file input` - Lire paiements.log
- `Table input` - Lire depuis PostgreSQL

**Transform (Transformation) :**
- `Select values` - Sélectionner colonnes
- `Filter rows` - Filtrer données
- `Calculator` - Calculs
- `String operations` - Manipuler texte

**Output (Écriture) :**
- `Table output` - Écrire dans PostgreSQL
- `Insert / Update` - Insérer ou mettre à jour

### Lecture fichiers CSV (Produits)

**Step : CSV file input**

```
Filename : C:\ProjetSAD\Donnees\produits.csv
Delimiter : ,
Enclosure : "
Header : Yes (first line contains headers)
Format : mixed
Encoding : UTF-8
```

### Lecture fichiers JSON (Commandes)

**Step : JSON input**

```
File or directory : C:\ProjetSAD\Donnees\commandes.json
Fields to extract :
- CommandeID (Integer)
- ClientID (Integer)
- ProduitID (Integer)
- Quantite (Integer)
- MontantTotal (Number)
- DateCommande (Date, format: yyyy-MM-dd)
- Statut (String)
```

### Lecture fichiers LOG (Paiements)

**Step : Text file input**

```
File : C:\ProjetSAD\Donnees\paiements.log
Content Type : Text
Format : Unix
Encoding : UTF-8
Fields : Parse using regex or fixed width
```

---

## 📊 POWER BI DESKTOP - Configuration de connexion

### Méthode 1 : Connexion PostgreSQL native

**Get Data → Database → PostgreSQL database**

```
Server : localhost:5432
Database : EntrepotCommandes
Data Connectivity mode : Import (recommandé)
```

**Authentication :**
- Type : Database
- User name : postgres
- Password : [votre_mot_de_passe]

### Méthode 2 : Si la méthode 1 ne marche pas

**Get Data → More → ODBC**

Vous devrez installer le driver PostgreSQL ODBC :
- Télécharger : https://www.postgresql.org/ftp/odbc/versions/msi/
- Choisir : psqlodbc_x64.msi (version 64-bit)

---

## 🌐 GOOGLE BIGQUERY (À utiliser à la fin)

### Informations (à remplir quand vous créerez le projet)

```
Project ID : [sera généré par Google Cloud]
Dataset : entrepot_commandes
Location : europe-west1 (ou EU)
```

### Pour Pentaho → BigQuery

**Driver BigQuery JDBC pour Pentaho :**
1. Télécharger SimbaJDBCDriverforGoogleBigQuery depuis Google Cloud
2. Copier tous les JARs dans `C:\Pentaho\data-integration\lib\`
3. Redémarrer Spoon

**Configuration de connexion dans Pentaho :**

**View → Database Connections → New**

```
Connection Name : BigQuery_EntrepotCommandes
Connection Type : Google BigQuery
Access : Native (JDBC)
Project ID : [votre_project_id]
Dataset : entrepot_commandes
OAuthServiceAcctEmail : [votre_service_account_email]
OAuthPvtKeyPath : [chemin vers votre fichier JSON de credentials]
```

**Steps Pentaho pour BigQuery :**
- `Table input` avec connexion BigQuery
- `Table output` avec connexion BigQuery
- Identiques à PostgreSQL, juste changer la connexion !

**📝 Note importante :** Les transformations Pentaho restent **identiques** !
Vous changerez juste la connexion de base de données de PostgreSQL → BigQuery.

### Pour Power BI → BigQuery

**Get Data → More → Google BigQuery**

```
Billing Project ID : [votre_project_id]
Use Storage API : Yes (pour meilleures performances)
Authentication : OAuth 2.0 ou Service Account
```

---

## 📂 STRUCTURE DES FICHIERS RECOMMANDÉE

Créez cette structure sur votre ordinateur :

```
C:\ProjetSAD\
├── Donnees\
│   ├── commandes.json
│   ├── produits.csv
│   ├── paiements.log
│   └── clients_mysql.sql
├── Scripts\
│   └── schema_entrepot_commandes.sql
├── Pentaho\
│   ├── Transformations\
│   │   ├── Load_Dim_Produits.ktr
│   │   ├── Load_Dim_Clients.ktr
│   │   ├── Load_Faits_Commandes.ktr
│   │   └── Enrich_Paiements.ktr
│   └── Jobs\
│       └── Master_ETL_Job.kjb
├── PowerBI\
│   └── [vos fichiers .pbix]
└── Documentation\
    ├── README.md
    ├── GUIDE_INSTALLATION_PENTAHO.md
    └── INFORMATIONS_CONNEXION.md
```

---

## 🔍 VÉRIFICATION DES CONNEXIONS

### Test connexion PostgreSQL depuis ligne de commande

Ouvrez CMD ou PowerShell et tapez :

```bash
psql -h localhost -p 5432 -U postgres -d EntrepotCommandes
```

Si ça fonctionne, vous verrez : `EntrepotCommandes=#`

### Test connexion dans pgAdmin 4

1. Ouvrir pgAdmin 4
2. Servers → PostgreSQL 16 → Databases → EntrepotCommandes
3. Si vous voyez les tables, la connexion fonctionne !

---

## 🎯 TABLES CRÉÉES DANS PostgreSQL

### Tables Sources (Staging)
- staging_clients (20 lignes)

### Dimensions
- Dim_Clients (vide, sera remplie par Talend)
- Dim_Produits (vide, sera remplie par Talend)
- Dim_Temps (730 lignes, déjà remplie)

### Table de Faits
- Faits_Commandes (vide, sera remplie par Talend)

### Vues Analytiques
- Vue_Ventes_Par_Produit
- Vue_Ventes_Par_Client
- Vue_Ventes_Par_Mois
- Vue_Statuts_Commandes

---

## 🚀 ORDRE D'EXÉCUTION

1. ✅ **PostgreSQL installé et configuré**
2. ⏳ **Exécuter schema_entrepot_commandes.sql dans pgAdmin**
3. ⏳ **Configurer connexions dans Talend**
4. ⏳ **Créer jobs ETL dans Talend**
5. ⏳ **Exécuter jobs Talend pour charger données**
6. ⏳ **Connecter Power BI à PostgreSQL**
7. ⏳ **Créer tableaux de bord Power BI**
8. ⏳ **Migrer vers BigQuery (dernière étape)**

---

## 📞 AIDE EN CAS DE PROBLÈME

### Erreur : "Password authentication failed"
→ Vérifiez votre mot de passe PostgreSQL

### Erreur : "Connection refused"
→ Vérifiez que PostgreSQL est démarré (services Windows)

### Erreur : "Database does not exist"
→ Vérifiez que vous avez créé la base "EntrepotCommandes"

### Power BI ne trouve pas PostgreSQL
→ Installez le driver PostgreSQL ODBC

---

## ✅ CHECKLIST AVANT DE CONTINUER

- [ ] PostgreSQL installé et mot de passe noté
- [ ] Base "EntrepotCommandes" créée dans pgAdmin 4
- [ ] Tous les fichiers de données téléchargés
- [ ] Script SQL téléchargé
- [ ] Structure de dossiers créée
- [ ] Ce fichier imprimé ou sauvegardé

---

**Date de création** : Décembre 2024
**Projet** : Système d'Aide à la Décision - ISGA Marrakech
**Étudiant** : Lojaine EDDAHIR
