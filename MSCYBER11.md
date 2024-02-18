# MSCYBER#11

# Installation et configuration d’un serveur avec Proxmox

Le 29 janvier 2024, à Rennes
Auteurs 

    Jean-Philippe Roblot 
    Rafael Mendes

Dernière mise à jour le 29 janvier 2024 à 15h


## Objectifs :

Créez un serveur de virtualisation depuis une machine physique et avec l’utilisation Promox, expliquez les étapes d’installation et répondez au questionnaire sur la virtualisation et l’hyperviseur. 


## Décrire les étapes d'installation de l'hyperviseur.
1. récupérer l’ISO de Proxmox dans le site de l’éditeur ;
2. créer une clé USB bootable depuis l’ISO proxmox ;
3. démarrer la machine physique avec un boot sur la clé USB ;
4. choisir l’interface graphique pour l’installation ;
5. avancer les étapes d’installation (les paramètres par défaut sont suffisants, sauf l’adresse IP qui doit appartenir à la même plage d’IP du réseau local) ;
![première étape de l’assistant d’installation Proxmox](https://cdn.discordapp.com/attachments/1201468488884162593/1201469530174652456/IMG_2558.jpg)

![choix de localisation](https://cdn.discordapp.com/attachments/1201468488884162593/1201469529067376731/IMG_2559.jpg)

![paramétrage du réseau](https://cdn.discordapp.com/attachments/1201468488884162593/1201469527771320461/IMG_2560.jpg)

![résumé de la configuration](https://cdn.discordapp.com/attachments/1201468488884162593/1201469527012147200/IMG_2561.jpg)



6. câbler la machine physique à une machine client ;
7. connecter sur le navigateur de la machine client et taper l’adresse IP du serveur Proxmox sur la barre URL avec le port `:8006` (la bonne adresse est indiquée dans la bannière d’ouverture du système Proxmox sur la machine physique du serveur) ;
8. utiliser les identifiants login : root et le mot de passe créé pendant l’installation. 


## Quels sont les types de machines virtuelles et quelles sont leurs différences ?

Il y en a deux types de machines virtuelles : la machine virtuelle système et la machine virtuelle de processus. 

1. La machine virtuelle système est une machine qui réplique un ordinateur dans son intégralité et elle font donc fonctionner un système d’exploitation complet et peut faire fonctionner plusieurs applications ;
2. La machine virtuelle de processus permet un seul processus de s’exécuter en tant qu’application.



## Questionnaire : 
1.  Qu’est-ce qu’un Datacentre (dans Proxmox) ?
    - Un datacenter dans proxmox server est un point unique de gestion des ressources virtuelles. Il permet de créer, gérer et monitorer des machines virtuelles (VM) et des containers Linux (LXC) sur plusieurs serveurs physiques
2.  De combien de coeurs dispose le Datacentre ?
    - Cela dépends du total de la configuration des machines qui composent le centre de données.  
3. Qu’est-ce qu’un node (dans Proxmox) ? 
    - Un node est un serveur. 
4. De combien de coeurs dispose le Node ?
    1. Cela dépends de la configuration de la machine qui sert comme serveur. 
5. Quel est le CPU de la machine que vous utilisez comme serveur pour la réalisation du brief ? 
    - La machine a un coeur i5 de 4 coeurs. 
![résumé de la configuration matériel du noeud](https://cdn.discordapp.com/attachments/1186298174785208323/1201487598938509382/image.png)

![résume de la configuration matérieul du noeud 2](https://cdn.discordapp.com/attachments/1186298174785208323/1201487623907192862/image.png)

6. De combien de RAM dispose votre Node ? 
    - Notre node dispose actuellement de 8gb. 
7. Quel est le type de réseau de votre Node (Bridge/NAT/Segment isolé) ? 
    - C’est un réseau de type bridge. 
8. De combien d’espace disque dispose votre Node : 
    1. pour le stockage des VMs ? 
        - Le Node en question a 148gb d’espace disque pour les VMs;
    2. pour le stockage des isos d’installation ? 
        - Le Node en question a 72gb pour le stockage des ISOs d’installation.
9. Sous quel OS Proxmox tourne-t-il ? 
    - Proxmox tourne sur Linux Debian. 
10. Quel est l’hyperviseur sous-jacent utilisé par Proxmox ? 
    - Proxmox utilise l’hyperviseur KVM (Kernel-based Virtual Machine).


## Création et gestion des Machines Virtuelles : 
1.  Comment je choisis le type d’OS que je compte déployer ? (Screenshot) 
![il est possible de choisir le type d’OS à installer lors de la création d’une machine virtuelle](https://cdn.discordapp.com/attachments/1201468488884162593/1201506033454035094/image.png?ex=65ca10b1&is=65b79bb1&hm=fd72da7b231bdce815671afeca9d7d4e91f542b0826efb69387b57a9bc79b7b9&)

2. Comment je choisis l’iso (CD d’installation) que je vais utiliser ?
![il est possible d’ajouter un ISO avec l’option téléverser](https://cdn.discordapp.com/attachments/1201468488884162593/1201504202447401020/screen-OS.png?ex=65ca0efc&is=65b799fc&hm=b38f10e46839fa53d468ee35c860a8cd7adf850534ff8582605786b2133e2edf&)

3. Comment je choisis le type de BIOS (BIOS/UEFI) que je vais utiliser ?
![il est possible de choisir le type de BIOS dans les étapes de la création d’une machine virtuelle](https://cdn.discordapp.com/attachments/1201468488884162593/1201505865094664192/image.png?ex=65ca1089&is=65b79b89&hm=afa4978e5d8a2afff17064e4de84052624b1c315896dcce0c69fe4615af96bfe&)

4. Comment je choisis le volume de stockage sur lequel je vais stocker le disque de ma machine ? Ainsi que sa taille ? (Screenshot) 
![il est possible de choisir le volume de stockage dans les étapes de la création d’une machine virtuelle](https://cdn.discordapp.com/attachments/1201468488884162593/1201506308663300106/image.png?ex=65ca10f2&is=65b79bf2&hm=04d864b35c6dfacf7ab64a286641989fd5a09de8f2957a5e0178c3fcaccb8722&)

5. Dans le choix du CPU, quelle est la différence entre « Sockets » et « Cores » ? 
    - Un socket est un connecteur qui permet d’insérer un processeur dans une carte mère. Un core est une unité de calcul indépendante qui se trouve à l’intérieur du processeur.
6. Si je souhaite faire de la virtualisation imbriquée sur ma future machine, quel est le type de processeur que je dois utiliser ?
    - Pour utiliser cette fonctionnalité, il faut avoir un processeur qui supporte les extensions de virtualisation matérielle, comme Intel VT-x ou AMD-V


## Installation d’un conteneur Debian 12 :
1. télécharger Debian 12 sur Proxmox ;
![](https://cdn.discordapp.com/attachments/1201468488884162593/1201526491624771685/image.png)

2. créer un conteneur en utilisant le modèle Debian 12 ;
![](https://cdn.discordapp.com/attachments/1201468488884162593/1201525918653497374/image.png)

3. paramétrer le stockage, le processeur et la mémoire selon les recommandation de Debian ; 
4. configurer l’interface réseau du conteneur en lui attribuant une IP sur le réseau et en utilisant l’interface pont de Proxmox ;  
![](https://cdn.discordapp.com/attachments/1201468488884162593/1201527912319422584/image.png)



## Vérification bon fonctionnement du réseau virtuel

Nous avons pu vérifier que les machines virtuelles créées avec le serveur Promox sont en bon fonctionnement et ont une connexion dans le réseau à travers l’utilisation de la commande `ping`, comme il est possible d’attester dans l’image suivante : 

![](https://cdn.discordapp.com/attachments/1201468488884162593/1201529328714924165/image.png)



# [Bonus] Création d’un cluster Proxmox et connexion entre groupe
1. dans le datacenter de l’interface graphique de Proxmox, naviguer vers l’option Cluster et opter pour Créer un cluster ; 
![](https://cdn.discordapp.com/attachments/1196747353667936307/1201822498031665153/cluster.jpg?ex=65cb376c&is=65b8c26c&hm=80c9c77736c93f2b16e2d1bad353da47541c4103f1830b5e00c68b28ad7d5f81&)

2. ouvrir l’option Cluster Join Information ;
![](https://paper-attachments.dropboxusercontent.com/s_84774823E65B92858A27AA817D84A77A89B880018D67F0EBB6222AC98CDD7FDE_1706607586503_image.png)

3. connecter sur le deuxième serveur, naviguer également vers l’option Cluster et opter pour Join Cluster ;
4. remplir avec les information du cluster créé précédemment et lancer la connexion.


# Comment quitter un cluster
1. utiliser la commande `pvecm nodes` pour lister les nodes connectés ;
2. utiliser la commande `pvecm delnode <nom du node>` pour déconnecter les nodes. 
3. ensuite, pour supprimer les paramètres du master, ajouter les commandes :
    systemctl stop pve-cluster corosync
    pmxcfs -l
    rm /etc/corosync/*
    rm /etc/pve/corosync.conf
    killall pmxcfs
    systemctl start pve-cluster
4. supprimer les fichiers restants des anciens nodes : 
    cd /etc/pve/nodes
    rm -r [nom du node]
    systemctl restart pveproxy pvedaemon pve-cluster


# Informations sur cluster composé de l’ensemble de la classe
1. Quelle est la quantité RAM du cluster ? 70GiB.
2. Quelle est la quantité de CPU du cluster ? 20 processeurs.
3. Quelle est la capacité totale de stockage du cluster ? 2,33TiB.
![capture d’écran avec les information du cluster](https://cdn.discordapp.com/attachments/1201468488884162593/1201847818428629002/image.png)




