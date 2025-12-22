@database TransCat
@author "zIgUS"
@node "Main" "TransCat_English.guide"
@$ver: TransCat documentation 1.20 [08.09.99]
@remark Translated by Pascal Rullier <rullier@bugss.org>

                              @{b}TransCat@{ub} v1.20
                              **************
                               [08.09.1999]


             @{"   Copyright    " link "Copyright"}  Legal Information on TransCat.
             @{"  Installation  " link "Installation"}  How to install TransCat.
             @{"  Introduction  " link "Introduction"}  Introduction of TransCat.
             @{"      Use       " link "Use"}  How to use TransCat.
             @{"   The Future   " link "The Future"}  The future of TransCat.
             @{"    History     " link "History"}  The history, always the history...
             @{"  Translation   " link "Translation"}  Catalog translation.

             @{"     Author     " link "Contact"}  My address.
@EndNode


@Node "Copyright" "Legal Information on TransCat."

 Important :
 ===========

 TransCat is © 1998-1999 by zIgUS. All right reserved.

 TransCat is Shareware. You can register by paying 50 FF, 15 US$ or 25 DM
 @{"registration" link "Registration"}. You will receive a full version.

 The demo version can be distributed freely.
 Registered users may not share or distribute their full version.

 TransCat is supplied as is : Without guarantee of any kind, neither implicit,
 neither explicit. In any case, you can't hold the Author Will for responsible,
 directly or indirectly of damages consistent or incident, loss of data caused
 by the usage or the application of this software.
 All riscs of using this software is assumed by the user.

 All the associed files, included in this archive, may not be changed or
 altered in any way. Any modified version must be reported.

 I advice you against use of such versions. Otherwise you can have some
 unpleasant surprises and it harms the future development of TransCat.
@EndNode


@Node "Registration" "Registration to TransCat."

 TransCat is Shareware. This demo version has the following restrictions :

  · It don't permit to save catalogs translation (.ct).
  · The author can not put it's name in the .catalog

 You can receive the full version by registering. You have to pay the
 registration fee of 50 FF, 15 US$ or 25 DM

 This amount is only valid if, the author obtains actually 50 FF.
 If less, you will not be registered till I obtain the correct amount.

 If you have any printer, use the registration form at this point in
 TransCat to register.


 Send me please, the registration form with your address to :

      K L A X
      P.O Box 14
      21601 Longvic CEDEX
      France


 The registration will be handled usually as quick as possible.

 I will then thank you for supporting my work.
 Remember : Buying software is software what will continue to be developed !
@EndNode

@Node "Installation" "How install it..."

 @{b}Installation@{ub}

 Nothing hard!

 Just copy the drawer where you want it and copy the fgl.library in the
 LIBS: Drawer.

@EndNode

@Node "Introduction" "About TransCat..."

  Code by zIgUS  © 1998-1999
  TransCat only runs on A1200 or better.


  TransCat uses the following libraries :

      - fgl.library
      - asl.library

  As well as @{"MUI" link "mui"} 3.6 or higher.

  TransCat has been coded in 100% optimized assembler. If you find any
  bugs or have some suggestions for other options, @{"Contact me" link "Contact"}.

@EndNode

@Node "MUI" "About of MUI..."


                          @{b}MUI - MagicUserInterface@{ub}

                   (c) Copyright 1993/97 de Stefan Stuntz


 MUI is a system to configure any Graphics User Interfaces.
 With the help of software controlled preferences, the user have the
 possibility of personalizing the interface as his taste.

 MUI is distributed in shareware form. To obtain the complete archive,
 containing a lot of examples and more informations on the registration,
 consult the archive named "muiXXusr.lha" (XX for the version number)
 on your BBS, Public Domain or Aminet.

      If you desire to register MUI, you can send


                            DM 30.- or US$ 20.-

                                     to

                                Stefan Stuntz
                          Eduard-Spranger-Straße 7
                                80935 München
                                   GERMANY
@EndNode

@Node "Use" "How to use TransCat..."
                        _          ._______  ___       .--.__ 
                       ¡¬\         |      / ¡  ¬\_____ |  ¦ ¬|
                       | _\  /\    ¦  ___/  |    \   / |  |  |
                       ¦  \\// \   | __)_   |  \  \ /  |  |  |
                       `---\/   \  |    ¬\  |  ¦\  /   |  ¯  |
                            l____\ l______\ `--' \/    l_____¦

                       ---------------------------------------
                       @{"Project" link "project"}  @{"Actions" link "actions"}  @{"import" link "import"}  @{"export" link "export"}

 @{b}Filter@{ub} :       Permits searching a name in a catalog, You can make use
                of a wildcard with the "*" key.
                Shortcut: "f".

 @{b}Translated@{ub} :   Give you the percentage of translated elements.

 @{b}Number@{ub} :       Shows the number of the selected string.

 @{b}Display@{ub} :      Permits to show all, or only the untranslated elements
                in the catalog (in this mode, the translated sentence will
                disappear when translated).
                Shortcut : "a".

 @{b}Elements@{ub} :     Shows the number of elements, present in the catalog.

 @{b}Shortcut "e"@{ub} : Permits to edit the selected string.

 @{b}Shortcut "c"@{ub} : Permits to copy the selected string.

 @{b}Shortcut "T"@{ub} : Permits to access to texteditor.

 @{b}Information on@{ub} :

  - @{fg shine}\el@{fg text} left aligned text
  - @{fg shine}\ec@{fg text} center aligned text
  - @{fg shine}\er@{fg text} right aligned text
  - @{fg shine}\eb@{fg text} bold
  - @{fg shine}\eu@{fg text} underlined
  - @{fg shine}\ei@{fg text} italic
  - @{fg shine}\e1@{fg text} white writing
  - @{fg shine}\e0@{fg text} black writing
  - @{fg shine}\en@{fg text} normal mode
  - @{fg shine}\n@{fg text}  linefeed
  - @{fg shine}\t@{fg text}  tabulation

@EndNode


@Node "Project" "Project Menu"

 @{b}Open catalog@{ub} : Permits to open all sorts of catalogs.

 @{b}Save catalog@{ub} : Permits to save the catalog with modifications.

 @{b}Catalog information@{ub} : Gives some information about the catalog :
                           - Author's name  (registered version only).
                           - Catalog's name.
                           - Language of catalog (registered users only,
                             their native language is put in priority).
                           - Version of the catalog.
                           - Revision of the catalog.

 @{b}About@{ub} : Information about TransCat and the users registration.


 @{b}Quit@{ub} : Permits to quit TransCat.
@EndNode

@Node "Actions" "Actions Menu"

 @{b}Fill empty strings@{ub} : Permits to fill all empty strings in the
                      catalog.

 @{b}Search a number@{ub} : Permits to search a number in the catalog.
@EndNode

@Node "Import" "Import Menu"

 @{b}Catalog Description@{ub} : Load a catalog description (.cd), generally
                       supplied by the author of the software.

 @{b}Catalog Translation@{ub} : Load a translation catalog (.ct), made by
                       yourself !!!
@EndNode

@Node "Export" "Export Menu"

 @{b}Catalog Description@{ub} : Permits to save a catalog description.

 @{b}Catalog Translation@{ub} : Permits to save your translation file.
                       (Registered users only)

 @{b}Constants ASM@{ub} :       Make a file with constants for Assembler.

 @{b}Constants C@{ub} :         Make a file with constants for C.

 @{b}Constants E@{ub} :         Make a file with constants for E.

 @{b}Constants Blitz@{ub} :     Make a file with constants for Blitz.

@EndNode

@Node "The Future" "The return of the future..."

  - I wait for your suggestions !!!!!!!!

@EndNode

@Node "History" "The Story of TransCat"

 @{U}Version 1.20@{uU} :

  - Text editor making (very useful for complex sentences)

 @{U}Version 1.14@{uU} :

  - Snoop catalog implementation during loading a software.

 @{U}Version 1.13@{uU} :

  - Bug corrected when the size of catalog was over 5 Ko.

 @{U}Version 1.12@{uU} :

  - Create the mode search/replace (made in automatic).
  - Bug corrected in reading some catalogs.

 @{U}Version 1.01@{uU} :

  - Bug corrected to create a description file.

 @{U}Version 1.00@{uU} :

  - The first distribution on Aminet.

@EndNode

@Node "Translation" "Locale translation catalogs."

 TransCat is available in the next languages :

  - In French : Translation catalog   : The author
                Translation document  : The author

  - In English : Translation catalog  : Pascal Rullier
                 Translation document : Millot Lionel
                 Translation document : Schaaij Willem

  - In Deutsch : Translation catalog  : Dirk Neubauer
                 Translation document : Dirk Neubauer

  - In Spanish : Translation catalog  : Fermín Venegas
                 Translation document : Fermín Venegas

  - In Italian : Translation catalog  : Virginio Savani
                 Translation document : Virginio Savani

  - In Magyar  : Translation catalog  : Garami Ferenc


 If you want to translate the TransCat's catalog in your language,
 ask me to send you the catalog description file (.cd).
@EndNode

@Node "Contact" "My address..."

  You can contact me on the following address :

      @{b}K L A X@{ub}
      P.O Box 14
      21601 Longvic CEDEX
      France

   Email  : rcilm021@dial.oleane.com
  IrcName : zIgUS ( on #artbas )
@EndNode

