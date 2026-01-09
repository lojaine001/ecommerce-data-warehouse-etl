-- Base de données MySQL - Informations sur les clients
-- Script de création et d'insertion pour la table clients

-- Créer la base de données si elle n'existe pas
CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

-- Supprimer la table si elle existe déjà (pour réinitialiser)
DROP TABLE IF EXISTS clients;

-- Créer la table clients
CREATE TABLE clients (
    ClientID INT PRIMARY KEY,
    NomClient VARCHAR(255) NOT NULL,
    Pays VARCHAR(50) NOT NULL,
    DateInscription DATE NOT NULL,
    Email VARCHAR(255),
    Ville VARCHAR(100)
);

-- Insérer les données des clients
INSERT INTO clients (ClientID, NomClient, Pays, DateInscription, Email, Ville) VALUES
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

-- Vérifier l'insertion
SELECT * FROM clients ORDER BY ClientID;

-- Statistiques sur les clients par pays
SELECT Pays, COUNT(*) as NombreClients
FROM clients
GROUP BY Pays
ORDER BY NombreClients DESC;
