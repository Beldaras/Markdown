# MSCYBER#15- Gestion de multiples domaines et sécurisation des droits avancées sur les données

Ce brief vise à développer vos compétences techniques autour de Microsoft AD DS de façon plus poussée, tout en révisant vos fondamentaux. De plus, il tend à mettre en jeu vos compétences collaboratives et organisationnelles.

Sur le plan technique, la maîtrise des composants de AD DS en local, la répartition des rôles FSMO et la délégation des droits et leur bonne gestion selon la méthode AGDLP sont les clés d'un tel projet.

Chaque instance de serveur est mis en place sur un réseau local propre et sur un serveur physique dédié

- DSI group 192.168.1.110-119
- LDE 120-129
- BEF 130-139
- lma-breizh.local 140-149 ⇒ serveur 192.168.1.140
- GDM 150-159

Les serveurs sont sous MS Windows 2019 sans interface graphique et en utilisant MS Windows Admin Center pour l'administration à distance ou PowerShell.

## Préparer son ADDS de filiale “Les Marins de l’Armor” (MDA)

Chaque DSI doit préparer sont contrôleur de domaine et des objets pour des groupes et comptes utilisateurs, **en suivant la méthode AGDLP**

1. **Chaque entité doit disposer des unités d’organisation suivantes :**

   - Direction de filiale
   - Administratif & Finances,
   - Service RH,
   - Bureau d'Etudes,
   - Fabrication,
   - Services Informatique.

2. **Pour chaque UO, un dossier partagé**

   - accessible uniquement par les utilisateur de l’UO
   - en lecture par la Direction
   - accès de gestion aux droits par le Service Info

3. **Création des groupes selon l’AGDLP**

   - _Groupes globaux_

     - Direction de filiale,
     - Administratif & Finances,
     - Service RH,
     - Bureau d'Etudes,
     - Fabrication,
     - Services Informatique

   - _Groupe de portée locale_

     - GDL_partage_RW
     - GDL_partage_RO

   - Les utilisateurs sont rattachés aux groupe de portée globale eux-mêmes rattachés aux groupe de portée locale

## Niveau groupe

1. le DSI groupe “Breizh Startup Nation” dispose des droits du service info
2. la direction groupe dispose des droits des directions de filiales

## Réinitialisation de canal sécurisé

1. vous devez réinitialiser le canal sécurisé pour un compte d'ordinateur qui a perdu la connectivité au domaine dans la filiale
2. Le contrôle de l'opération est ensuite délégué au service RH afin de permettre la connectivité au domaine par leur service également et délester l'équipe informatique.

## Questions

- Quels sont les rôles FSMO dans AD DS ? Que permet d'assurer chaque rôle ?  
   FSMO signifie _"Flexible Single Master Operation"_. Les rôles FSMO permettent de limiter la modification de certaines données internes à l’annuaire Active Directory et ainsi limiter les risque de conflits.  
   Par défaut, le premier contrôleur de domaine du domaine détient les cinq rôles FSMO. Cependant, il est possible de transférer les rôles si vous souhaitez les répartir entre plusieurs contrôleurs de domaine Ils sont au nombre de 5 :

  - **_Maître d’opération des noms de domaine_** : Le détenteur du rôle FSMO Maître d’opérations des noms de domaine est le contrôleur de domaine chargé d’apporter les modifications à l’espace de noms de domaine à l’échelle de la forêt de l’annuaire, c’est-à-dire le contexte d’appellation des partitions\configuration ou LDAP://CN=Partitions, CN=Configuration, DC="domain". Ce contrôleur de domaine est le seul qui peut ajouter ou supprimer un domaine de l’annuaire.
  - **_Contrôleur de schéma_** : Le détenteur du rôle FSMO Contrôleur de schéma est le contrôleur de domaine chargé d’exécuter les mises à jour du schéma d’annuaire. Une fois la mise à jour du schéma terminée, il est répliqué du contrôleur de schéma vers tous les autres contrôleurs de domaine de l’annuaire.
  - **_Maître RID_** : Le détenteur du rôle FSMO Maître RID est le contrôleur de domaine unique chargé de traiter les demandes du pool RID provenant de tous les contrôleurs de domaine d’un domaine donné. Il est également chargé de supprimer un objet de son domaine et de le placer dans un autre domaine lors d’un déplacement d’objet. Le RID est un identifiant relatif qui est unique au sein de chaque SID, de façon à ce que chaque contrôleur de domaine aura un bloc (pool) de RID unique qu’il pourra attribuer aux futurs objets créés dans l’annuaire.
  - **_Maître d’infrastructure_** : chargé de mettre à jour le SID et le nom unique d’un objet dans une référence d’objet inter-domaines. Le rôle Maître d’infrastructure (IM) doit être détenu par un contrôleur de domaine qui n’est pas un serveur de catalogue global (GC).
  - **_Émulateur PDC_** : nécessaire pour synchroniser l’heure dans une entreprise, l’émulateur PDC d’un domaine fait autorité pour le domaine. L’émulateur PDC à la racine de la forêt fait autorité pour l’entreprise et doit être configuré pour collecter l’heure à partir d’une source externe.

- Comment sont configurés les rôle FSMO dans votre succursale seule et lorsque vous devez l'intégrer avec le reste de l'entreprise ?  
  Dans une succursale seule, le controleur de domaine possède les 5 rôles FSME. Dans un contexte d'entreprise avec plusieurs domaines, les rôles peuvent être distribués aux différents contrôleurs de domaines.

- Expliquer le principe de la méthode AGDLP pour la configuration des droits sur les dossiers et partages.  
   La méthode AGDLP utilise l'imbrication des groupes de sécurité pour gérer les permissions NTFS sur les ressources. Les utilisateurs (**A**ccount) sont intégrés dans des groupes globaux (**G**lobal), eux-même ajoutés dans des groupes de domaine local (**D**omain **L**ocal) auxquels seront attribuées des permissions NTFS sur les ressources (**P**ermissions),

- Comment vérifiez-vous les droits effectifs sur les dossiers partagés par les groupes ?  
  Clic droit sur le dossier > Propriétés > Avancés > Autorisations effectives

- En cas de conflits dans les autorisations de groupes, quelles sont les règles appliquées par Windows Server pour déterminer les droits effectifs ?

  - Autorisations explicites : les autorisations qui sont attribuées directement à un utilisateur ou à un groupe ont la priorité sur toutes les autres autorisations.
  - Autorisations héritées : prioritaires sur les autorisations par défaut, mais sont subordonnées aux autorisations explicites.
  - Autorisation de refus : si une autorisation de refus est définie, elle a la priorité sur toutes les autres autorisations.
  - Combinaison d'autorisations : si un utilisateur est membre de plusieurs groupes, l’utilisateur a tous les droits qui sont accordés à ces groupes.

- Quels sont les groupes par défaut et les risques de sécurité liés aux groupes par défauts qui fournissent des privilèges administratifs ?  
  Administrateurs : Ce groupe a des droits administratifs complets sur le domaine.
  Admins de domaine : Les membres de ce groupe ont des droits administratifs complets sur tous les domaines de la forêt.
  Administrateurs de l’entreprise : Les membres de ce groupe sont administrateurs de l’ensemble des domaines de la forêt.
  Opérateurs de sauvegarde : Un utilisateur ajouté à ce groupe dans Active Directory peut sauvegarder et restaurer des fichiers et des répertoires situés sur chaque contrôleur de domaine du domaine.  
  Les groupes par défaut qui fournissent des privilèges administratifs peuvent être exploités par des attaquants.

- Qu'est-ce que la délégation de contrôle administratif sous Windows Server AD DS ?  
  La délégation de contrôle administratif sous Windows Server Active Directory Domain Services (AD DS) est une fonctionnalité qui permet de donner l’autorisation de réaliser des tâches d’administration à des utilisateurs ou des groupes. Cela est particulièrement utile pour déléguer des permissions sans donner des privilèges administratifs complets.

- Quelles types de tâche standard ou personnalisée peut assurer une délégation de contrôle administratif ?  
  On peut par exemple attribuer à un groupe le contrôle total de tous les objets d’une unité d’organisation, attribuer à un autre groupe uniquement des droits de création, suppression et gestion des comptes d’utilisateur dans l’unité d’organisation, puis attribuer à un troisième groupe uniquement le droit de réinitialiser les mots de passe de compte d’utilisateur.

- Quelles sont les options qui permettent de modifier les attributs des utilisateurs, nouveaux ou existants ?
  - Via l’interface graphique : clic droit sur l’utilisateur et cliquez sur “Propriétés”. Vous pouvez alors modifier divers attributs dans les différents onglets
  - Via PowerShell avec la cmdlet
    ```PowerShell
      Set-ADUser
      # Exemple
      Set-ADUser -Identity "jdoe" -telephoneNumber "1234567890"
    ```
  - Via l'attribut UserAccountControl  
    ![alt text](image-1.png)
    ```PowerShell
      Get-ADUser florian -Properties UserAccountControl | Select Name,UserAccountControl
    ```
    ![alt text](image.png)
- Quels sont les types d'objets qui peuvent être membres des groupes globaux ?  
  Selon l'AGDLP, les comptes utilisateurs.

- Quels sont les types d'objets qui peuvent être membres des groupes locaux de domaine ?  
  Les groupes globaux.

- Quelles sont les deux informations d'identification nécessaires pour qu'un ordinateur puisse joindre un domaine ?
  - Le nom du domaine à joindre
  - Le nom dʼutilisateur et le mot de passe dʼun compte avec des droits
    dʼadministration sur le domaine

### Installation et administration du serveur Windows Serveur 2019 Core

- Accéder à l’assistant config sur server sans UI ⇒ `sconfig`

  ![alt text](IMG_2581.jpeg)

- Attribuer une IP statique

  ![alt text](IMG_2582.jpeg)

- Administration à distance via Admin Center

      * Se connecter au serveur

      * Dans rôle et fonctionnalités, activer le rôle ADDS

      * Pour administrer Active Directory en graphique dans Admin center

              Paramètres > Extensions

          ![alt text](<Untitled 1.png>)

      * Via PowerShell

  ![alt text](<Untitled 2.png>)
  ![alt text](<Untitled 3.png>)

          [Installation de services de domaine Active Directory et promotion du serveur en contrôleur de domaine](https://www.dell.com/support/kbdoc/fr-fr/000121955/installation-de-services-de-domaine-active-directory-et-promotion-du-serveur-en-contrôleur-de-domaine)

          Vérification `Get-ADDomain`

      * Créer les UO

          ```powershell
          New-ADOrganizationalUnit -Name "Direction de filiale" -Path "CD=lma-breizh, CD=local"
          ```
          ![alt text](<Untitled 4.png>)


      * Rejoindre la fôret globale en établissant une relation d’approbation via le DNS

          ```powershell
          Set-DnsServerForwarder 192.168.1.110 #ip du server de la DSI
          ```
          ![alt text](<Untitled 5.png>)
