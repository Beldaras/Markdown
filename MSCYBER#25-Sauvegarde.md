# Sécurité des données - Sauvegardes de données

## Questions

1. Lister et donner les caractéristiques (taille maximale, performance, etc.) d'au moins trois types de support de sauvegarde
   - Disques durs :
     - avantages : rapide, fiable, bon rapport capacité/prix, espace de plusieurs To (la capacité de stockage double tous les deux ans), possibilité de RAID, durée de vie d'une dizaine d'années
     - inconvénients : sensible aux chocs
   - Bandes magnétiques :
     - anvantages : durée de vie (30 ans), très fiable, faible coût, intéressantes pour de la sauvegarde de données froides ou tièdes
     - inconvénients : temps d'accès long, une seule tâche d'écriture à la fois
   - NAS : Famille des HDD mais autonome, possède son propre OS. Souvent composé de plusieurs éléments, utilisation en réseau (local et internet) et pour la sauvegarde de grandes données. Disposant d’une forte disponibilité, il fait partie des solutions très appréciées par les entreprises pour la sauvegarde de fichiers stratégiques.
2. Au regard de ces éléments, expliquer la REGLE n°2 de sauvegarde "3-2-1" suivante
: il faut disposer d'au moins 3 copies des données (les données primaires et deux sauvegardes), sur 2
supports de données différents, dont 1 copie de sauvegarde est sur un site externe.
    - On effectue les sauvegardes sur deux supports de stockage différents afin de limiter les risques pour nos données. supports distincts. Dans le cas contraire, en cas d’incident, la perte de données pourrait concerner à la fois l’original et la copie si les deux fichiers sont stockés sur le même appareil.
3. Pour les trois types de sauvegarde (complète, différentielle et incrémentielle)
comparer les caractéristiques de temps de sauvegarde, de volume de données sauvegardées et de
temps de restauration.  
    - Sauvegarde complète :
      - Complexité réduite : La création et la restauration de sauvegardes complètes sont relativement simples et peuvent être effectuées sans logiciel spécifique.
      - Volume de données : Le volume de la sauvegarde complète correspond au stock de données complet.
      - Temps de sauvegarde : Prend du temps, car il faut copier l’ensemble des données.
      - Fiabilité : Très fiable, car toutes les données sont sauvegardées.
    - Sauvegarde différentielle :
      - Complexité : Moins complexe que la sauvegarde complète, mais plus complexe que la sauvegarde incrémentielle.
      - Volume de données : Le volume de la sauvegarde différentielle croît au fil du temps, en fonction des modifications depuis la dernière sauvegarde complète.
      - Temps de sauvegarde : Rapide pour sauvegarder, car seules les données modifiées sont copiées.
      - Fiabilité : Fiable, mais moins que la sauvegarde complète.
    - Sauvegarde incrémentielle :
      - Complexité : Plus complexe que la sauvegarde différentielle, mais plus simple que la sauvegarde complète.
      - Volume de données : Le volume de la sauvegarde incrémentielle croît également au fil du temps, mais uniquement pour les modifications depuis la dernière sauvegarde (qu’elle soit complète ou incrémentielle).
      - Temps de sauvegarde : Plus rapide que la sauvegarde complète, car seules les données modifiées depuis la dernière sauvegarde sont copiées.
      - Fiabilité : Fiable, mais nécessite une chaîne d’incrémentations pour restaurer les données jusqu’à la dernière sauvegarde complète.  

    En résumé, la sauvegarde complète est la plus fiable, mais elle nécessite plus de temps et d’espace de stockage. La sauvegarde différentielle est un compromis entre fiabilité et rapidité, tandis que la sauvegarde incrémentielle est rapide mais nécessite une chaîne d’incrémentations pour la restauration complète des données
4. Identifier un fournisseur de sauvegarde de données dans le cloud et présenter les caractéristiques de son offre en quelques lignes ?  

    Acronis Cyber Protect :  
    - Description : Acronis est remarquable pour avoir évolué ses capacités de sauvegarde dans le cloud en une suite de sécurité complète incluant une protection contre les rançongiciels.
    - Fonctionnalités :
      - Protection contre les rançongiciels.
      - Sauvegarde et restauration des données.
      - Gestion intégrée de la protection.
      - Analyse des données dans les clouds publics tiers pour détecter les logiciels malveillants.

## Etude de cas

![alt text](image-56.png)

### A voir

RTO & RPO
