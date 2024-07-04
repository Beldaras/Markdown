# MSCYBER#31 - Améliorer la disponibilité d'une application critique

## Auteurs

Roblot Jean-Philippe - <jroblot.simplon@proton.me>  
Drula Kevin - <kdrula.simplon@proton.me>  
Fontaine Mathieu

## Version

01/07/2024 - V1R0

## Stack technique

![Static Badge](https://img.shields.io/badge/Ubuntu%20Server-22.04-orange)
![Static Badge](https://img.shields.io/badge/Galera%20Cluster%204-26.4.18-orange)
![Static Badge](https://img.shields.io/badge/MariaDB-10.6.18-brown)
![Static Badge](https://img.shields.io/badge/Nginx-1.27.0-green)

Powered by <https://shields.io>

## Contexte

Votre entreprise, la société BIG (Breizh IT Geek) se voit confier la mission de faire évoluer une architecture d'application d'un de ses clients. L'objectif est mettre en place un modèle de déploiement actif/actif pour assurer la haute disponibilité de ladite application en respectant les contraintes de PCI/PRI du client pour la continuité, la sauvegarde et la restauration du service.
IMPORTANT - Ce travail s'inscrit dans une série de plusieurs travaux en cascade.

En tant que administrateur infrastructures sécurisées, les gestes professionnels associés à cette situation sont :

- Identifier les composants de l'architecture à redonder
- Définir les solutions techniques de redondances selon le modèle actif/actif
- Travailler sur un environnement de développement et effectuer les mises en production de façon maitrisée
- Planifier, Concevoir, Déployer et Tester les composants unitaires et le système global
- Assurer la disponibilité de l'environnement selon les exigences client

## Objectifs

**Objectif n°1** - Réalisation du déploiement sur l'environnement IaaS imposé par le client (voir annexe)

- **Objectif n°2** - Déployer un site WordPress sur au moins trois VM en mode actif/actif avec un pare-feu local par instance

- **Objectif n°3** - Déployer le SGBDR du site sur des VM différentes de celles pour le frontal web avec un pare-feu local par instance

- **Objectif n°4** - Déployer le SGBDR du site sur au moins trois VM dans un cluster en mode actif/actif

- **Objectif n°5** - Respecter la contrainte client d'utiliser le SGBDR de la solution MariaDB

- **Objectif n°6** - Identifier et déployer une solution uniforme de reverse proxy/répartiteur de charge pour le frontal web et le cluster de SGBDR avec un pare-feu local par instance

- **Objectif n°7** - Respecter les contraintes du fournisseur de cloud pour la passerelle Internet (SNAT et FQDN) à voir avec le formateur

- **Objectif n°8** - Séparer les environnements de développement et de production et maitriser les mises en production (MEP) pour garantir la stabilité de la production

- **Objectif n°9** - Respecter les contraintes de sécurité pour l'accès au cloud (Bastion d'accès)

- **Objectif n°10** - Automatiser et planifier une sauvegarde de chaque composant de l'architecture client pour permettre une restauration en moins d'une heure de l'environnement complet en cas de déclenchement du PRI du client (Utiliser le NAS de Backup externe mis à disposition par le client)

- **_Objectif transverse_** - Gérer le travail d'équipe à travers la méthode KANBAN selon les phases A faire / En développement / En test / En production

## DAT

![alt text](image-130.png)

## Données techniques

[Notes de l'hébergeur](https://simplonline-v3-prod.s3.eu-west-3.amazonaws.com/media/file/pdf/readme-ha-web-v0r1-667c1c682d26d255784513.pdf)

## KANBAN

[Jira - Infra Web - Simplon](https://jphilipperoblot.atlassian.net/jira/core/projects/IWS/board)

## SGBDR et cluster Galera

### Pré-requis

- 3 serveurs Linux Ubuntu LTS 22.04
  - SRV-MariaDB-1 @ip 192.168.1.70
  - SRV-MariaDB-2 @ip 192.168.1.74
  - SRV-MariaDB-3 @ip 192.168.1.73
- Une SGBDR MariaDB
- moteur de stockage InnoDB ou XtraDB
  ![alt text](image-131.png)
- Toutes les tables de la base de données répliquée doivent avoir une clé primaire
- Le pare-feu des serveurs doit autoriser les ports 3306, 4444, 4567 et 4568

### Installation de Galera

```bash
  sudo apt install galera-4

  # Vérifier la présence du fichier de configuration après installation
  ls /etc/mysql/mariadb.conf.d/
  50-client.cnf  50-mysql-clients.cnf  50-mysqld_safe.cnf  50-server.cnf  60-galera.cnf
```

### Configuration

1. Ouvrir le fichier `sudo nano /etc/mysql/mariadb.conf.d/60-galera.cnf` 
2. Décommenter les lignes nécessaires
3. Spécifier l'emplacement de la librairie `wsrep`
4. Renseigner les IP des serveurs de base de données
![alt text](image-134.png)

### Démarrer le cluster Galera

1. Stopper MariaDB avant d'initialiser le cluster
2. Initialiser Galera
3. Effectuer une requête dans MariaDB pour vérifier le nombre de noeuds dans notre cluster (à ce stade, un seul serveur est configuré, la valeur sera `1`)
![alt text](image-133.png)

### Ajouter des noeuds au cluster Galera

1. Copier/coller le fichier de configuration de Galera sur vos deux autres serveurs
2. Redémarrer l'instance MariaDB sur les serveurs respectifs
3. Sur le serveur 1, effectuer une requête dans MariaDB pour vérifier le nombre de noeuds dans notre cluster  
![alt text](image-135.png)

### Vérifier l'état des noeuds Galera

![alt text](image-136.png)  
La seconde requête permet de voir si le nœud local est capable de traiter suffisamment rapidement les opérations de réplication qu'il reçoit. Sa valeur doit être zéro quand tout fonctionne normalement.
