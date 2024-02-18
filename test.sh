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