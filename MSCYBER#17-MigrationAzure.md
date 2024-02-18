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

## Script de sauvegarde du site web

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

## Déploiement d'une marchine virtuel Azure