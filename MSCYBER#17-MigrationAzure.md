# Migration du site Intranet

Dans le cadre de l'évolution d'infrastructure il est nécessaire de procéder à la migration du site Interne chez un nouveau prestataire Cloud qui est Microsoft Azure.

## Authors

Roblot Jean-Philippe - <jroblot.simplon@proton.me>  
Moreau Ronan - <rmoreau.simplon@proton.me>
Adsuar Guillaume
Pantalouf Dany

## Version

16/02/2024 - V1R0

## Releases

![Static Badge](https://img.shields.io/badge/Microsoft-Azure-blue)
![Static Badge](https://img.shields.io/badge/Debian-11-red)
![Static Badge](https://img.shields.io/badge/WordPress-blue)

Powered by <https://shields.io>

## Contexte

En tant qu'administrateur systémes, il vous est demandé de mettre en place le site interne de votre filiale chez un nouveau prestataire cloud, Azure.  
Il vous sera pour ce faire nécessaire de procéder, a l'aide de scripts, à la sauvegarde de votre site.  
Ensuite vous devrez mettre en place votre nouveau serveur en utilisant le portail Azure.  
Enfin il vous faudra deploier votre site interne sur cette nouvelle infrastructure.

## Déploiement d'une marchine virtuel Azure

cf documentation [MSCYBER#12](https://github.com/Beldaras/Markdown/blob/main/MSCYBER%2312-Azure.pdf)  
Nous choisirons ici une distribution Linux Debian 12, et un accès distant SSH via mot de passse.

## Installation de la pile LAMP et de WordPress

cf documentation [MSCYBER#16](https://github.com/Beldaras/Markdown/blob/main/MSCYBER%2316-LAMP-WP.pdf)

## Script de sauvegarde du site web et déploiement

Il nous faut un script capable de récupérer :

- notre site web
- les différents vHOSTS
- notre base de données

```bash
  #!/bin/bash

  # Définir les variables
  SITE_DIR="/var/www/html/"
  VHOST_Dom_DIR="/etc/apache2/sites-available/lma-breizh.local.conf"
  VHOST_Pub_DIR="/etc/apache2/sites-available/public.conf"
  BACKUP_DIR="/root/BackUp-WP"
  DB_USER="root"
  DB_PASS="Jesaispasmoi@"
  DB_NAME="wp_mscyber_ron_jp"

  # Créer un répertoire de sauvegarde s'il n'existe pas
  mkdir -p $BACKUP_DIR

  # Sauvegarder les fichiers du site
  cp $SITE_DIR $VHOST_Dom_DIR $VHOST_Pub_DIR /root/BackUp-WP

  # Sauvegarder la base de données du site
  mysqldump -u $DB_USER -p$DB_PASS $DB_NAME > $BACKUP_DIR/db_backup_$(date +%Y%m%d).sql
```

Envoie du répertoire de sauvegarde

```bash
  scp -r BackUp-WP Administrateur@172.212.83.207:/home/Administrateur
```

Pour déployer, il suffit de placer chaque fichier dans ses emplacements respectifs sur la machine Azure.
Il faudra également créé un utilisateur pour la nouvelle DB.

## Questions

1 - Quelles sont les étapes nécessaires pour migrer un site WordPress d'un prestataire à un autre ?
- Déployer la machine virtuelle chez le nouveau prestataire
- Configurer les nouveau serveur web
- Effectuer la sauvegarde du site via script ou plugin WP
- Exporter la database avec un dump
- Envoyer le fichier de backup vers la nouvelle VM hôte
- Dans MySQL, importer la DB du site via le dump .sql
- Créer un utilisateur pour la nouvelle DB et lui donner les droits sur la DB du site

    ```SQL
      CREATE USER 'tr4'@'localhost' IDENTIFIED BY 'test';
      GRANT ALL PRIVILEGES ON wp_mscyber_ron_jp.* TO 'tr4'@'localhost' IDENTIFIED BY 'test';
      FLUSH PRIVILEGES;
    ```

- Modifier le fichier de config WP afin de l'adapter au nouvel utilisateur  
    `sudo nano /var/www/html.wp-config.php`
- Placer les différents fichiers de backup à leurs emplacement respaectifs.
  
2 - Quelles sont les informations et les accès essentiels dont vous aurez besoin pour effectuer la migration ?

- Accès à la machine hôte actuelle
- Acccès à l'administration du wordpress
- Accès à la DB
- Accès à la machine hôte cible

Chaque accès nécessite de connaitre les identifiants associés.

3 - Comment assurer une sauvegarde complète et sécurisée du site WordPress avant la migration ?

- On peut utiliser un script
- utiliser un plugin WordPress
- Stocker plusieurs suavegarde sur des emplacement différents

4 - Quels sont les éléments spécifiques à prendre en compte lors de la migration d'une base de données WordPress d'un serveur à un autre ?


5 - Comment s'assurer que tous les fichiers, thèmes et plugins sont correctement transférés lors de la migration ?

6 - Quels sont les éventuels risques ou problèmes techniques que l'on peut rencontrer lors d'une migration de site web et comment les anticiper ?
