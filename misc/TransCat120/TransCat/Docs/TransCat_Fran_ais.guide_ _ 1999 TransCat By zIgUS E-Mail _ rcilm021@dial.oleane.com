@database TransCat
@author "zIgUS"
@node "Main" "TransCat.guide"
@$ver: TransCat documentation 1.20 [08.09.99]


                              @{b}TransCat@{ub} v1.20
                              **************
                               [08.09.1999]


             @{"   Copyright    " link "Copyright"}  Informations juridiques sur TransCat.
             @{"  Installation  " link "Installation"}  Comment installer TransCat.
             @{"  Introduction  " link "Introduction"}  Introduction à TransCat.
             @{"  Utilisation   " link "Utilisation"}  Comment utiliser TransCat.
             @{"     Futur      " link "Futur"}  Le futur de TransCat.
             @{"  Historique    " link "Historique"}  Encore l'histoire, toujours l'histoire...
             @{"  Traduction    " link "Traduction"}  Traduction des catalogues.

             @{" Contactez  moi " link "Contact"}  Mon adresse.
@EndNode


@Node "Copyright" "Informations juridiques sur TransCat."

 Important :
 ===========

 TransCat est © 1999 par zIgUS. Tous droits réservés.

 TransCat est Shareware. En payant 50 FF, 15 US$ ou 25 DM vous pouvez
 vous @{"enregistrer" link "Enregistrement"} et recevoir une version complète.

 La version de démonstration peut être librement distribuée.
 Les utilisateurs enregistrés ne doivent pas redistribuer leur version.

 TransCat est fourni tel-quel, sans aucune garantie de quelque sorte,
 ni explicite, ni implicite. En aucun cas, l'auteur ne pourra être tenu
 pour responsable, direct ou indirect, des dommages conséquents ou incidents,
 des pertes de données occasionnées par l'utilisation ou l'application de ce
 logiciel. Tous les risques, quant à l'utilisation de ce logiciel, doivent
 être assumés par l'utilisateur.

 Tous les fichiers associés, inclus dans cette archive, doivent rester
 inchangés et inaltérés.
 Aucune version modifiée ne devrait être redistribuée.

 Je vous déconseille d'utiliser de telles versions, vous pourriez avoir
 de désagréables surprises et cela nuirait aux futurs développements
 de TransCat.
@EndNode


@Node "Enregistrement" "Enregistrement à TransCat."

 TransCat est Shareware, la version de démonstration à les restrictions suivantes :

  · Elle ne permet pas de sauver les catalogues traduction (.ct).
  · L'auteur ne pourra pas mettre son nom dans le .catalog.

 Vous pouvez recevoir la version complète en vous enregistrant et en payant
 les frais d'enregistrement.

 Qui sont de :  50 FF 15US$ 25 DM

 Ces sommes sont seulement valables si, après le change, j'obtiens
 effectivement 50 FF. Si j'obtenais moins, il vous faudrait faire
 l'appoint.

 Si vous avez une imprimante, veuillez utiliser l'enregistrement prévu
 à cet effet dans TransCat pour votre enregistrement.


 Envoyez, S.V.P., le formulaire d'enregistrement avec votre réglement à :

      K L A X
      Boite Postale 14
      21601 Longvic CEDEX
      France


 Les enregistrements sont souvent traités le jour même et repartent le
 lendemain.

 Je voudrais encore vous remercier de supporter mon travail.
 Rappelez-vous : Un programme acheté est un programme qui continue d'être developpé !
@EndNode

@Node "Installation" "Comment l'installer..."

 @{b}Installation@{ub}

 Rien de très compliqué !

 Juste copier le tiroir à l'endroit qui vous convient le mieux et
 la fgl.library dans le tiroir LIBS:
@EndNode

@Node "Introduction" "A propos de TransCat..."

  Programmé par zIgUS  © 1999
  TransCat fonctionne uniquement sur A1200 ou plus.


  TransCat utilise les librairies suivantes :

      - fgl.library
      - asl.library

  ainsi que @{"MUI" link "mui"} 3.6 ou plus.

  TransCat a été programmé 100 % en assembleur optimisé, si vous trouvez
  un bugg, ou si vous avez des suggestions pour d'autres options,
  @{"Contactez moi" link "Contact"}.
@EndNode

@Node "MUI" "A propos de MUI..."


                          @{b}MUI - MagicUserInterface@{ub}

                   (c) Copyright 1993/97 de Stefan Stuntz


 MUI est un système pour configurer des interfaces graphiques utilisateur.
 A l'aide d'un programme de réglage de préférences, l'utilisateur d'une
 application a la possibilité de personnaliser l'interface selon ses goûts.

 MUI est distribué sous forme shareware. Pour obtenir une archive complète,
 contenant de nombreux exemples et plus d'informations sur l'enregistrement,
 consulter l'archive nommée "muiXXusr.lha" (XX pour le n° de la dernière
 version) sur votre BBS, les disquettes domaine public ou Aminet.

      Si vous désirez vous enregistrer directement, vous pouvez envoyer


                            DM 30.-  ou  US$ 20.-

                                      à

                                Stefan Stuntz
                          Eduard-Spranger-Straße 7
                                80935 München
                                   GERMANY
@EndNode

@Node "Utilisation" "Comment utiliser TransCat..."
                        _          ._______  ___       .--.__ 
                       ¡¬\         |      / ¡  ¬\_____ |  ¦ ¬|
                       | _\  /\    ¦  ___/  |    \   / |  |  |
                       ¦  \\// \   | __)_   |  \  \ /  |  |  |
                       `---\/   \  |    ¬\  |  ¦\  /   |  ¯  |
                            l____\ l______\ `--' \/    l_____¦

                       ---------------------------------------
                       @{"Projet" link "projet"}  @{"Actions" link "actions"}  @{"Importer" link "importer"}  @{"Exporter" link "exporter"}

 @{b}Filtre@{ub}   : Permet de rechercher un nom dans le catalogue, vous pouvez aussi
            utiliser les "jocker" avec la touche "*".
            Raccourci clavier : "f".

 @{b}Traduit@{ub}  : Donne le pourcentage d'éléments traduits dans le catalogue.

 @{b}Numéro@{ub}   : Affiche le numéro de la chaîne sélectionnée.

 @{b}Afficher@{ub} : Permet de tout afficher, ou seulement d'afficher ce qui n'est pas
            traduit dans le catalogue (dans ce mode, les phrases traduites au
            fur et à mesure disparaîtront).
            Raccourci clavier : "a".

 @{b}Eléménts@{ub} : Affiche le nombre d'éléments que contient le catalogue.

 @{b}Raccourci clavier "e"@{ub} : Permet d'éditer la chaîne sélectionnée.

 @{b}Raccourci clavier "c"@{ub} : Permet de copier la chaîne sélectionnée.

 @{b}Raccourci clavier "T"@{ub} : Permet d'accéder à l'éditeur de texte.

 @{b}Information sur@{ub} :

  - @{fg shine}\el@{fg text} texte à gauche
  - @{fg shine}\ec@{fg text} texte au centre
  - @{fg shine}\er@{fg text} texte à droite
  - @{fg shine}\eb@{fg text} gras
  - @{fg shine}\eu@{fg text} souligne
  - @{fg shine}\ei@{fg text} italic
  - @{fg shine}\e1@{fg text} écriture en blanc
  - @{fg shine}\e0@{fg text} écriture en noir
  - @{fg shine}\en@{fg text} mode normal
  - @{fg shine}\n@{fg text}  saut de ligne
  - @{fg shine}\t@{fg text}  tabulation
@EndNode


@Node "Projet" "Menu Projet"

 @{b}Ouvrir catalogue@{ub}      : Permet d'ouvrir tous types de catalogue.

 @{b}Sauvegarde catalogue@{ub}  : Permet de sauver le catalogue avec les modifications.

 @{b}Information catalogue@{ub} : Donne des informations sur le catalogue en cours :
                          - Nom de l'auteur (version enregistrée seulement).
                          - Nom du catalogue.
                          - Langue du catalogue (pour les personnes enregistrées,
                            leur langue natale est mise d'office).
                          - Version du catalogue.
                          - Révision du catalogue.

 @{b}A propos@{ub} : Information sur TransCat, on y trouve aussi, l'enregistrement
            de celui-ci.

 @{b}Quitter@{ub}  : Permet de quitter TransCat.
@EndNode

@Node "Actions" "Menu Actions"

 @{b}Remplir les chaînes vides@{ub} : Permet de remplir toutes les chaînes vides du
                             catalogue.

 @{b}Chercher numéro@{ub} : Permet de rechercher un numéro dans tout le catalogue.
@EndNode

@Node "Importer" "Menu Importer"

 @{b}Description de catalogue@{ub} : Charge un catalogue description (.cd), généralement
                            fourni par l'auteur du programme.

 @{b}Traduction de catalogue@{ub} : Charge un catalogue traduction (.ct), fait par vous !!!
@EndNode

@Node "Exporter" "Menu Exporter"

 @{b}Description de catalogue@{ub} : Permet de sauver un catalogue description.

 @{b}Traduction de catalogue@{ub}  : Permet seulement pour les personnes enregistrées de
                            sauvegarder leur traduction.

 @{b}Constantes ASM@{ub}   : Crée un fichier avec les constantes assembleur du catalogue.

 @{b}Constantes C@{ub}     : Crée un fichier avec les constantes C du catalogue.

 @{b}Constantes E@{ub}     : Crée un fichier avec les constantes E du catalogue.

 @{b}Constantes Blitz@{ub} : Crée un fichier avec les constantes Blitz du catalogue.
@EndNode

@Node "Futur" "Le retour du futur..."

  - J'attends vos suggestions !!!!!!!!
@EndNode

@Node "Historique" "L'histoire de TransCat"

 @{U}Version 1.20@{uU} :

  - Création d'un éditeur de texte (très utile pour des phrases complexes).

 @{U}Version 1.14@{uU} :

  - Implémentation de la capture d'un catalogue au chargement d'un
    programme exécutable.

 @{U}Version 1.13@{uU} :

  - Bug corrigé lors des chargements de catalogues dépassant les 5 Ko.

 @{U}Version 1.12@{uU} :

  - Implémentation du mode recherche/remplace (fait en automatique).
  - Bug corrigé lors de la lecture de certains catalogues.

 @{U}Version 1.01@{uU} :

  - Bug corrigé lors de la sauvegarde d'un fichier description.

 @{U}Version 1.00@{uU} :

  - Première distribution sur Aminet.
@EndNode

@Node "Traduction" "Traduction des catalogues."

 TransCat est disponible dans les langues suivantes :

  - Français : Traduction catalogue : L'auteur
               Traduction document  : L'auteur

  - Anglais  : Traduction catalogue : Pascal Rullier
               Traduction document  : Millot Lionel
               Traduction document  : Schaaij Willem

  - Allemand : Traduction catalogue : Dirk Neubauer
               Traduction document  : Dirk Neubauer

  - Espagnol : Traduction catalogue : Fermín Venegas
               Traduction document  : Fermín Venegas

  - Italien  : Traduction catalogue : Virginio Savani
               Traduction document  : Virginio Savani

  - Magyar   : Traduction catalogue : Garami Ferenc


 Si vous êtes prêts à traduire dans votre langue le catalogue de TransCat,
 demandez moi de vous envoyer le catalogue description (.cd).
@EndNode

@Node "Contact" "Mon adresse ..."

  Vous pouvez me joindre à l'adresse suivante :

      @{b}K L A X@{ub}
      Boite Postale 14
      21601 Longvic CEDEX
      France

   Email  : rcilm021@dial.oleane.com
  IrcName : zIgUS ( on #artbas )
@EndNode

