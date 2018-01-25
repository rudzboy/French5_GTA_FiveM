<img src="http://forum.french5.fr/styles/forumus-transparent-version/theme/images/logo/logo.png">

# Serveurs GTA5 Roleplay via le client FiveM

## Accès

Se connecter sur le serveur dédié via ssh/ftp :

Adresse: localhost <br/>
Port: 30120 <br/>
Username: yourusername <br/>
Password: yourgoddamnpwd <br/>

ssh -> Passer super-utilisateur (pour les actions sur les serveurs FiveM)
```
su root
```
Mot de passe: yourfriciknrootpwd <br/>

## Base de données

Mot de passe "root" : yourfricikndatabasepwd <br/>

### Ajouter un accès phpmyadmin

Editer le fichier /etc/httpd/conf.d/phpMyAdmin.conf et ajoutez votre IP à l'image de celles-ci dessous
"Require ip 127.0.0.1"
"Allow from 127.0.0.1"

Redémarrer le service apache2
```
/sbin/service httpd restart
```
Il est de bonne convention de se créer un utilisateur dans la BDD avec nom/motdepasse, toutes permissions sauf perms GRANT <br/>
et de l'utiliser pour se connecter au phpmyadmin/client sql ensuite


## Icecon

### Accès

Lien vers [Client](https://github.com/icedream/icecon/releases)<br/>
Adresse: localhost:port <br/>
Password: iceconpassword (cf . Fichiers citmp-server.yml)<br/>

### Commandes

status = Permet d'obtenir les informations du serveur (ID des joueurs et noms/L'IP des joueurs et le ping).<br/>
clientkick [ID] [raisondukick] = Permet de kick un joueur par ID et d'y ajouter une raison.<br/>
tempbanclient [ID] [raisonduban] = Permet de ban un joueur par ID et d'y ajouter une raison.<br/>
say [message] = Parler dans le chat de votre serveur à tous les joueurs.<br/>
tell [ID] [message] = Parler dans le chat à un joueur.<br/>
start [resource] = Permet de démarrer une ressource.<br/>
stop [resource] = Permet de stopper une ressource.<br/>
restart [resource] = Permet de redémarrer une ressource.<br/>
refresh [resource] = Permet d'actualisé une ressource.<br/>

## Installation Serveurs / Maintenance

Se connecter en ssh sur le dédie et en "root" XD

### Démarrer un serveur :

```
screen -S nom_du_serveur

cd /home/fivem/repertoire_serveur
./run.sh
```

### Se détâcher du "screen" (mais le serveur tourne toujours dans le "screen") :

Appuyer sur Ctrl+A puis d

### Lister les "screen" actifs :

```
screen -ls
```
Affichera la liste des screens actifs avec leur identifiant (SCREEN_ID)

### Redémarrer un serveur :

```
screen -r SCREEN_ID
```
Appuyer sur Ctrl+C (arrête le serveur), supprimer le répertoire de cache puis redémarrer

```
rm -rf cache/
./run.sh
```


### Arrêter un serveur :

```
screen -X -S SCREEN_ID quit
```

### Redémarrage des serveurs (Crontab) :

Restarts programmés tous les jours à 0h00, 3h00, 8h00, 13h00 et 19h00
Sauvegarde MySQL à chaque.
Messages d'informations en jeu à 30min, 15min, 5min et 1min avant le restart

```
#CRONTAB FIVEM FRENCH5 SERVERS AUTORESTART

00 2,8,14,20 * * * /home/fivem/restart_servers.sh >> /home/fivem/restart_cron.log
30,45,55,58,59 1,7,13,19 * * * /home/fivem/restart_warning.sh >> /home/fivem/restart_cron.log
```
Pour éditer la crontab :
[Guide](http://www.desmoulins.fr/index.php?pg=informatique!unix!crontab)

```
crontab -e
```

### Liens utiles

Documentation de la commande [screen](https://doc.ubuntu-fr.org/screen) <br/>
Client de jeu [FiveM](https://fivem.net/)
