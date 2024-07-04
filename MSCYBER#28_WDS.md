# Déploiement automatisé MS Windows (WDS + MDT)

En tant que administrateur Infrastructure Sécurisée, malgré l'introduction de InTune par Microsoft, nombres d'entreprises encore les solutions WDS et MDT pour le déploiement de postes de travail sous MS Windows 10 et 11. En tant qu'administrateur, vous devez maitriser cette opération d'automatisation et de personnalisation d'un modèle ou "master" du système d'exploitation. Et assurer la sécurité des masters.

## Auteurs

Roblot Jean-Philippe - <jroblot.simplon@proton.me>  
Drula Kevin - <kdrula.roblot@proton.me>

## Version

15/05/2024 - V1R0

## Stack technique

![Static Badge](https://img.shields.io/badge/Microsoft-WDS-blue)
![Static Badge](https://img.shields.io/badge/Windows-2019-blue)
![Static Badge](https://img.shields.io/badge/Windows-10-blue)
![Static Badge](https://img.shields.io/badge/Windows-11-blue)

Powered by <https://shields.io>

## Contexte

Sur la base d'un environnement de virtualisation de type VirtualBox ou VMware Workstation, vous devez mettre en oeuvre un environnement de déploiement de postes d'entreprise.

Votre environnement doit répondre au cahier des charges suivants :

L'environnement de déploiement est isolé du réseau d'entreprise

Le déploiement doit permettre l'installation de poste Windows 10 Pro intégré dans un domaine AD DS

L'environnement doit disposer d'un serveur Windows Server 2019 ou 2022 avec les rôles WDS et ADDS (DNS+DHCP)

La personnalisation des postes doit offrir les éléments suivants :

REQ01 = Système d'exploitation = MS Windows 10 Professionnel Build 1903 ou supérieur
REQ02 = Partitionnement des disques = C:\ (SYSTEM) de 30 Go et D:\ (DATA) de 10 Go
REQ03 = Intégration des postes dans le domaine d'entreprise (AD-DS)
REQ04 = Installer VS Code
REQ05 = Installer CCleaner
SEC01 = Interdire l'installation de logiciel aux utilisateurs du domaine
SEC02 = Désactiver/Interdire la connexion de supports de stockage externes
SEC03 = Afficher un message à la connexion d'un utilisateur du domaine (Personnaliser votre message d'entreprise)

SEC04 = Interdire l'accès au "Panneau de Configuration" aux utilisateurs du domaine

L'intégration de LAPS est obligatoire pour la gestion des comptes administrateurs locaux

## Pré-requis

Un serveur Windows 2019 avec les rôles ADDS et DHCP
Le rôle Service de déploiement Windows (WDS)
Les outils ADK (Windows Assessment and Deployment Kit), MDT (Microsoft Deployment Toolkit) et Windows PE (Preinstallation Environment).
Accès administrateur au serveur.

## DHCP
Ajouter le rôle DHCP et paramétrer une plage d'étendue
![alt text](image-62.png)
Paramétrer l'étendue pour WDS :  
`Options d'étendue > Configurer les options`

![alt text](image-63.png)

![alt text](image-64.png)  
*cocher les options 66 et 67*

![alt text](image-65.png)

## Ajout du rôle WDS

Sur votre serveur ADDS, ajouter le rôle `Service de déploiement Windows` et suivre les indication de l'assistant d'installation
![alt text](image-57.png)

Paramétrer WDS :  

`Outils > Services de déploiement Windows`

![alt text](Config-WDS.png)
![alt text](image-58.png)
![alt text](image-59.png)  

Spécifier le volume de stockage que vous souhaitez dédier à WDS

![alt text](image-60.png)
![alt text](image-66.png)
![alt text](image-67.png)

Vous constatez suite à la configuration de WDS que l'option 60 s'est automatiquement ajoutée au DHCP
![alt text](image-68.png)

Pour tester le fonctionnement de notre WDS, lancer une machine cliente sans système d'exploitation, configurée pour démarrer sur le réseau. Si tout va bien, vous obtenez ceci :  
![alt text](image-69.png)

Maintenant que nous nous sommes assuré du bon fonctionnement, nous allons ajouter les images que nous voulons sur WDS  
`Images de démarrage > Ajouter une image de démarrage > Parcourir`

![alt text](image-70.png)
![alt text](image-71.png)  
*Récupérer boot.wim depuis le cd d'installation de Win10 chargée dans le lecteur du serveur*

De la même manière, charger `install.wim` dans le dossier `Images d'installation`

![alt text](image-72.png)

Notre poste client à maintenant une installation Windows  Pro standard. Cependant, cette solution ne permet pas de personaliser l'installation. Pour cela, il va falloir passer par d'autres outils : Windows ADK et MDT.

## Paramétrer le DHCP pour prise en charge de l'UEFI

## Installer Windows ADK

* Télécharger ADK
  ![alt text](image-73.png)

* Lancer l'assistant d'installation  
  ![alt text](image-74.png)
  ![alt text](image-75.png)

* Installer l'add-on Windows PE
  ![alt text](image-76.png)
  ![alt text](image-77.png)
  ![alt text](image-78.png)

## Installer MDT

* Télécharger MDT et lancer l'assistant
  ![alt text](image-79.png)
  ![alt text](image-80.png)
  ![alt text](image-81.png)
  ![alt text](image-82.png)

* Créer le deployment share via le Deployment Workbench
  ![alt text](image-83.png)
  ![alt text](image-84.png)
  ![alt text](image-85.png)
  ![alt text](image-86.png)
  ![alt text](image-87.png)

  Une fois le partage configuré, vous obtenez ceci, côté Workbench et Explorateur de fichiers
  ![alt text](image-88.png)

* Script PS de création d'utilisateur local dédié à MDT
  il est nécessaire, lors du démarage de la machine qui se connecte au partage, qu'elle puisse utiliser un compte utilisateur avec lres droit de lecture et d'exécution

  ```PowerShell
    # Spécifier le nom et le mot de passe du compte de service
    $ServiceAccountName = "Service_MDT"
    $ServiceAccountPassword = ConvertTo-SecureString "V0treMDP!" -AsPlainText -Force

    # Créer le compte local
    New-LocalUser $ServiceAccountName -Password $ServiceAccountPassword -FullName "MDT" -Description "Compte de service pour MDT"

    # Ajouter les droits en lecture sur le partage
    Grant-SmbShareAccess -Name "DeploymentShare$" -AccountName "Service_MDT" -AccessRight Read -Force

    # Attribuer au compte de service les permissions nécessaires pour accéder aux fichiers de déploiement MDT
    $MDTSharePath = "\\$env:COMPUTERNAME\DeploymentShare$"
    $Acl = Get-Acl $MDTSharePath
    $Rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Service_MDT","ReadAndExecute", "ContainerInherit, ObjectInherit", "None", "Allow")
    $Acl.SetAccessRule($Rule)
    Set-Acl $MDTSharePath $Acl
  ```

  ![alt text](image-89.png)
  ![alt text](image-90.png)

* Importer une image Windows 11  
  ![alt text](image-91.png)  
  Importer l'image montée dans le lecteur, autrement, dans source, sélectionné votre lecteur optique
  ![alt text](image-92.png)
  ![alt text](image-93.png)
  ![alt text](image-94.png)
  Le script
  ```PowerShell
    Import-Module "C:\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
    New-PSDrive -Name "DS001" -PSProvider MDTProvider -Root "W:\DeploymentShare"
    import-mdtoperatingsystem -path "DS001:\Operating Systems" -SourcePath "E:\" -DestinationFolder "Windows 11 Pro x64" -Verbose
  ```
  Dans 'Operating System', nous avons récupéré toutes les versions de l'OS présentent dans boot.wim. Nous allons supprimer les versions dont nous n'avons pas l'utilité
  ![alt text](image-95.png)

* Ajouter une séquence de tâches  
  ![alt text](image-96.png)
  Suivez les étapes du wizard
  ![alt text](image-102.png)
  ![alt text](image-103.png)

* Editer la séquence
  ![alt text](image-104.png)

* Update Deployment Share  
  `MDT Deplyment Share > clicl droit > Update`
  ![alt text](image-113.png)

* Importer l'image Lite Touch
  Dans l'outil WDS
  ![alt text](image-114.png)
  ![alt text](image-115.png)

* Test de déploiement sur une machine vierge
  ![alt text](image-116.png)
  ![alt text](image-117.png)

* Ajouter des programmes à l'installation (Exemple de VSCode)
  ![alt text](image-105.png)
  ![alt text](image-106.png)
  ![alt text](image-107.png)
  ![alt text](image-108.png)
  *La commande d'installation dépend du logiciel, à trouver sur le site éditeur*
  ![alt text](image-109.png)
  
* Partionner le disque
  ![alt text](image1.png)