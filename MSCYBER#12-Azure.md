# Provisionnement de machines virtuelles dans le cloud Azure

En tant qu'Administrateur Infrastructure et Sécurité, vous devez évaluez les coûts, provisionner, déployer et décommissionner un groupe de ressources dans le cloud Azure pour l'hébergement de différents services applicatifs. Afin d'évaluer pleinement la solution, le travail doit être réalisé par l'intermédiaire de l'interface web du Portail Azure et également par le biais de l'interface CLI Azure Shell.

## Authors

Roblot Jean-Philippe - <jroblot.simplon@proton.me>  
Moreau Ronan - <rmoreau.simplon@proton.me>

## Version

31/01/2024 - V1R0

## Releases

![Static Badge](https://img.shields.io/badge/PowerShell-5.1-blue)
![Static Badge](https://img.shields.io/badge/Azure%20CLI-2.56-blue)
![Static Badge](https://img.shields.io/badge/Ubuntu%20Server-LTS%2020.04-orange)

</br>Powered by <https://shields.io>

## Prérequis

Définir et caractériser les différents types d'offres cloud que sont : IaaS, PaaS et SaaS

# 1. Azure Portal

- Accéder au portail Azure en utilisant votre compte Simplon et l'authentification multifacteur "Microsoft Authenticator"
  ![alt text](image-28.png)

- Vérifier que votre compte est bien rattaché à la souscription GDO SIMPLON RENNES
  ![alt text](image-29.png)

- Utiliser la "Calculatrice de prix" de Microsoft pour définir le coût mensuel d'un VM Linux ayant les caractéristiques suivantes : Linux Ubuntu 20.04 LTS Gen2, Dimensionnement Standard D2s_v3, SSD Standard, Sans redondance et localisé dans l'Est des U.S. et un réseau virtuel avec groupe de sécurité de base.
  ![alt text](Calculatrice-azure.png)
  ![alt text](image-30.png)

- Utiliser l'Assistant de Provisionnement pour créer une VM selon les contraintes précédentes. De plus, la VM doit être accessible via SSH sur le port TCP/22 et une clé SSH-RSA
  ![alt text](image-37.png)
  ![alt text](image-32.png)
  ![alt text](image-33.png)
  ![alt text](image-34.png)

- Indiquer dans le compte-rendu l'explication des paramètres suivants : Options de disponibilité, Région, Type de Sécurité, Type de disques, Réseau virtuel.

- Identifier l'adresse publique d'accès à la VM et valider l'accès via SSH à la VM depuis votre poste de travail

  ```bash
    ssh Jean-Philippe@104.41.156.121 -i id_rsa
  ```

  ![alt text](image-38.png)

- Exporter le modèle de votre VM pour permettre un redéploiement à l'identique d'une autre VM

  ![alt text](image-39.png)
  _Ici nous avons le choix entre télécharger en local le template au format json, ou l'ajouter à la bibliothèque Azure_

- Faire la démonstration avec le formateur

- Décommissionner toutes les ressources ainsi créées pour vous assurer de ne pas laisser des coûts cacher se facturer après le travail
  ![alt text](image-40.png)
  ![alt text](image-41.png)

# 2. Azure CLI

Commencer par paramétrer PowerShell afin de prendre en charge Azure CLI

```powershell
  $ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri https://aka.ms/installazurecliwindowsx64 -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; Remove-Item .\AzureCLI.msi
```

- Utiliser l'interface en ligne de commande pour vous connecter à votre compte MS Azure

  ```powershell
    az login
  ```

- Afficher la liste des régions de disponibilité du cloud AZURE

  ```powershell
    az account list-locations -o table
  ```

- Pour identifier l'image Linux Ubuntu 20.04 LTS Gen2 que vous devez installer, lister les éditeurs disponible dans la région retenue pour votre déploiement en recherchant "Canonical" qui est l'éditeur Ubuntu. Lister les offres de Canonical, pous le SKU associé à la version Ubuntu de l'image souhaité

  ```powershell
     az vm image list --location eastus --publisher Canonical --offer Ubuntu-server --sku 20_04-lts-gen2  --all -o table
  ```

- Afficher la taille de la VM qui sera créée à partir de cette image

  ```powershell
    az vm image show --urn Canonical:0001-com-ubuntu-server-focal:20_04-lts-gen2:20.04.202401291

    {
      "architecture": "x64",
      "automaticOsUpgradeProperties": {
        "automaticOsUpgradeSupported": false
      },
      "dataDiskImages": [],
      "disallowed": {
        "vmDiskType": "Unmanaged"
      },
      "extendedLocation": null,
      "features": [
        {
          "name": "SecurityType",
          "value": "TrustedLaunchSupported"
        },
        {
          "name": "IsAcceleratedNetworkSupported",
          "value": "True"
        },
        {
          "name": "DiskControllerTypes",
          "value": "SCSI, NVMe"
        },
        {
          "name": "IsHibernateSupported",
          "value": "True"
        }
      ],
      "hyperVGeneration": "V2",
      "id": "/Subscriptions/f6734ccd-d4fd-44d4-92af-7c5ab651a764/Providers/Microsoft.Compute/Locations/westus/Publishers/Canonical/ArtifactTypes/VMImage/Offers/0001-com-ubuntu-server-focal/Skus/20_04-lts-gen2/Versions/20.04.202401291",
      "imageDeprecationStatus": {
        "alternativeOption": null,
        "imageState": "Active",
        "scheduledDeprecationTime": null
      },
      "location": "westus",
      "name": "20.04.202401291",
      "osDiskImage": {
        "operatingSystem": "Linux",
        "sizeInGb": 30
      },
      "plan": null,
      "tags": null
    }
  ```

- Créer un groupe de ressources pour héberger votre VM

  ```powershell
    az group create --name jp-group --location eastus
  ```

- Créer la VM en vous assurant qu'elle soit accessible via SSH sur le port TCP/22 et avec votre clé SSH-RSA

  ```powershell
    az vm create --resource-group jp-group --name vm-jp --image Canonical:0001-com-ubuntu-server-focal:20_04-lts-gen2:20.04.202401291 --size Standard_D2s_v3 --location eastus --admin-username azureadmin --authentication-type ssh --ssh-key-value ~/.ssh/id_rsa.pub --storage-sku Standard_LRS --os-disk-size-gb 30 --os-disk-caching ReadWrite --data-disk-caching None
  ```

- Tester votre accès SSH sur la VM
  ![alt text](image-43.png)

- Exporter le modèle de votre VM pour permettre un redéploiement à l'identique d'une autre VM

  ```powershell
    # Trouver le déploiement dans l'historique
    az deployment group list --resource-group jp-group

    # Exporter le déploiement vers notre dossier utilisateur
    az deployment group export --resource-group jp-group --name vm_deploy_azcfs5tHfdgV1vfq10dwT4NtuLqshnGw > ~/vmJPDeployment.json
  ```

  [Consulter l'historique ](https://learn.microsoft.com/fr-fr/azure/azure-resource-manager/templates/deployment-history?tabs=azure-cli)  
   [Les deux options d'export](https://learn.microsoft.com/fr-fr/azure/azure-resource-manager/templates/export-template-cli)

- BONUS - Installer un serveur LAMP sur votre VM et ouvrir l'accès au port TCP/80 (NSG Network Security Group) pour tester votre installation

  ```powershell
    # Ouvrir le port 80 de la VM Azure via Azure CLI
    az vm open-port -n vm-jp -g jp-group --port 80
  ```

  ```bash
      # Mettre à jour notre serveur
    sudo apt update && sudo apt upgrade
      # Installer la stack LAMP
    sudo apt install apache2 php libapache2-mod-php mysql-server php-mysql

      # Installer les plugin PHP
    sudo apt install php-curl php-gd php-intl php-json php-mbstring php-xml php-zip
  ```

  ![alt text](image-44.png)

- Faire la démonstrateur avec le formateur et Décommissionner toutes les ressources ainsi créées

  ```powershell
    # Arrêter la VM
    az vm stop --resource-group jp-group --name vm-jp
    # Supprimer les ressources
    az group delete --name jp-group --no-wait # Le paramètre --no-wait empêche le blocage de l’interface CLI lors de la suppression
    # ou
    az group wait --name jp-group --deleted #  pour attendre la fin de la suppression ou regarder sa progression
  ```

- Deployer depuis le template stocké en local
  ```powershell
    # Après avoir créé un groupe de ressources "jp-group"
    az deployment group create --resource-group jp-group --template-file C:\Users\Utilisateur\vmJPDeployment.json
  ```
  ![alt text](image-45.png)

# Questions

- Quel outil de déploiement devez-vous choisir pour des déploiements sur plusieurs clouds incluant Azure et Amazon Web Services (AWS) ?  
  =>Terraform, outil open source d'_Infratsructure as Code_ permettant d'utiliser un langage de configuration de haut niveau.

- Quel outil de déploiement devez-vous choisir pour les déploiements déclaratifs sur Azure si vous voulez optimiser les fonctionnalités d’intégration de la plateforme ?  
  => Bicep (et son extension VSCode), langage spécifique à un domaine (DSL) qui utilise la syntaxe déclarative pour déployer des ressources Azure.

- Quel outil pouvez-vous utiliser pour exécuter des commandes Azure CLI sans devoir ajouter ou installer des logiciels sur votre ordinateur ?  
  => On peut utiliser Azure Cloud Shell depuis le navigateur

- Quel paramètre de la commande Azure CLI az vm image devez-vous utiliser pour lister toutes les images du même fournisseur ?  
  `az vm image list --publisher`

- Quelle ressource Azure est un prérequis lors du déploiement d’une machine virtuelle Azure, quelle que soit la méthode de provisionnement ?  
  => Il faut au préalable avoir créé un groupe de ressources pour pouvoir déployer une VM.

- Quel est l’avantage de l’utilisation de modèles Bicep par rapport aux modèles Azure Resource Manager ?
  - Meilleur support pour la modularité et la réutilisation du code : Bicep fournit une syntaxe concise, une cohérence des types fiable et une prise en charge de la réutilisation du code.
  - Réduction des opérations de déploiement manuel: Bicep permet de faire évoluer vos solutions plus facilement et avec une qualité et une cohérence accrues.
