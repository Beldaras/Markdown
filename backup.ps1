# Créer une nouvelle policy
$policy = New-WBPolicy

# Sélectionner les volumes à sauvegarder
$volumes = Get-WBVolume -AllVolumes | where mountpath -eq "c:,d:"
Add-WBVolume -Policy $policy -Volume $volumes

# ajoute bare metal recovery, réduit les temps d'arrêt en cas de panne
Add-WBBareMetalRecovery $Policy

# Définir le disque de backup
$disks = Get-WBDisk
$backupLocation = New-WBBackupTarget -Disk $disks[1]
Add-WBBackupTarget -Policy $policy -Target $backupLocation

# Réaliser un état du système
Add-WBSystemState -Policy $policy

# Planification de l'heure pour effectuer des sauvegardes quotidiennes
Set-WBSchedule -Policy $policy 22:00

# Activer la policy
Set-WBPolicy -Policy $policy