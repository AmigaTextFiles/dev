@database TransCat
@author "zIgUS"
@node "Main" "TransCat_Magyar.guide"
@$ver: TransCat documentation 1.20 [08.09.99]
@remark Translated by Garami Ferenc (GFS) <gfs22@freemail.c3.hu>

                              @{b}TransCat@{ub} v1.20
                              **************
                               [08.09.1999]


             @{"     Szerzõi jog     " link "Copyright"}  Jogi információk a TransCat-ról.
             @{"     Installálás     " link "Installation"}  Hogyan installáld a TransCat-ot.
             @{"      Bemutatás      " link "Introduction"}  TransCat bemutatása.
             @{"      Használat      " link "Use"}  Hogyan használd a TransCat-ot.
             @{"       A jövõ        " link "The Future"}  A TransCat jövõje.
             @{"      Története      " link "History"}  A fejlõdés.
             @{"      Nyelvezet      " link "Translation"}  Milyen nyelvekre lett lefordítva.

             @{" A program készítõje " link "Contact"}  Az én címem.
@EndNode


@Node "Copyright" "Jogi információk a TransCat-ról."

 Fontos :
 ========

 TransCat © 1998-1999 készítõje : zIgUS. Minden jog fentartva.

 A TransCat Shareware program. A @{"regisztráció" link "Registration"}s díj 50 FF, 15 US$ vagy 25 DM
 ellenében megkapod a teljes regisztrált verziót.

 A demo verzió szabadon másolható terjeszthetõ.
 A regisztrált felhasználók nem terjeszthetik, nem adhatják tovább a teljes (regisztrált) verziót.

 A program készítõje nem vállal felelõsséget a TransCat használata során
 közvetlenül vagy közvetve keletkezõ váratlan adatsérülésére vagy elvesztésére. 
 A felelõsség a program felhasználóját terheli.
 
 A programhoz tartozó összes file-t tartalmazza ez az arhív állomány.
 Nem szabad a szerzõ engedélye nélkül bármilyen változtatást eszközölni
 a programban.       

 Aki nem az eredeti változatot használja, azt esetleg kellemetlen meglepetések
 érhetik a program mûködése során. Valamint árt a TransCat jövõjének, fejlesztésének.
@EndNode


@Node "Registration" "TransCat regisztrációja."

 A TransCat Shareware program. A demó verzióban a következõket nem lehet használni :

  · Katalógus translation (.ct) állomány mentése.
  · A készítõ neve nem kerül bele a .catalog állományba.

 Elküldöm neked a teljes regisztrált verzióta regisztrációs díj 
 50 Francia Franknak megfelelõ, USA Dollár vagy Német Márka ellenében.

 Ez az összeg most 50 FF, 15 US$ vagy 25 DM.   
 
 Ha van neked nyomtatód, használd a TransCat regisztrációs formátumát
 a regisztráció menüben.



 A kitöltött regisztrációs lapot és díjjat a következõ címre küld el :

      K L A X
      P.O Box 14
      21601 Longvic CEDEX
      France


 Elõre is köszönöm neked, hogy segítesz a munkámban. 
 
 Ha megvásárolod a programot, ezzel támogatod a további fejlesztéseket. 
@EndNode

@Node "Installation" "Hogyan installáld..."

 @{b}Installás@{ub}

 Nagyon egyszerû!

 Az fgl.library-t másold be abba könyvtárba,
 ami LIBS: meghajtónak van assign-olva. 
 
@EndNode

@Node "Introduction" "TransCat bemutatása..."

  A programot készítette : zIgUS  © 1998-1999
  A TransCat A1200 vagy nagyobb gépen futtatható.


  TransCat a következõ library-ket használja :

      - fgl.library
      - asl.library

  valamint @{"MUI" link "mui"} 3.6 vagy nagyobbat.

  A TransCat 100%-ig assembler kódban íródott. Ha valamilyen hibát találsz,
  vagy van valami új ötleted, írjál a @{"címem" link "Contact"}re.

@EndNode

@Node "MUI" "About of MUI..."


                          @{b}MUI - MagicUserInterface@{ub}

                   (c) Copyright 1993/97  Stefan Stuntz


 MUI a Grafikus Felhasználói Felületnek a konfigurálható rendszere.
 A felhasználó a beállító program segítségévél lehetõséget kap a beállítások
 azonnali leellenõrzésére, tesztelésére.
 
 MUI szabadon terjeszthetõ szoftver, melynek a regisztrálásáért a szerzõ
 tiszteletdíjat kér. A teljes arhív állomány tartalmaz nagy mennyiségû példát.

 Az arhívot, benne az információt a regisztráláshoz, megtalálod "muiXXusr.lha"
 (XX a verzió száma) néven a BBS-n, Public Domain-on vagy az Aminet-en.

      Ha regisztráltatni akarod a MUI-t, akkor a készítõjének küldjél


                           30.- DM vagy 20.- US$ 

                             a következõ címre :        

                                Stefan Stuntz
                          Eduard-Spranger-Straße 7
                                80935 München
                                   GERMANY
@EndNode

@Node "Use" "Hogyan használd a TransCat-ot..."
                        _          ._______  ___       .--.__ 
                       ¡¬\         |      / ¡  ¬\_____ |  ¦ ¬|
                       | _\  /\    ¦  ___/  |    \   / |  |  |
                       ¦  \\// \   | __)_   |  \  \ /  |  |  |
                       `---\/   \  |    ¬\  |  ¦\  /   |  ¯  |
                            l____\ l______\ `--' \/    l_____¦

                       ---------------------------------------
                       @{"Feladat" link "project"}  @{"Tevékenység" link "actions"}  @{"Import" link "import"}  @{"Export" link "export"} @{"Különleges" link "extras"}

 @{b}Szûrõ@{ub}          :  A szövegben keresést megkönyítõ funkció. Használható "*" a behelyettesítésre.
                Billenyûzetrõl: "f".

 @{b}Fordítás@{ub}       :   Kijelzi, hogy mennyi százalékban készült el a fordítás.

 @{b}Sor@{ub}            :   A kiválasztott szöveg sorszáma.

 @{b}Kijelzés@{ub}       :   Teljes           (az összes szöveg látható).
                    Nincs lefordítva (a le nem fordított szöveg látható csak). 
                Billenyûzetrõl: "a".

 @{b}Össz adat@{ub}            :   Kijelzi a katalógusban lévõ összes szöveg darabszámát.

 @{b}Billenyûzetrõl "e"@{ub}   :   A kiválasztott szöveg szerkesztése.

 @{b}Billenyûzetrõl "c"@{ub}   :   A kiválasztott szöveg másolása.

 @{b}Billenyûzetrõl "T"@{ub}   :   Belsõ szövegszerkesztõ hívása.

 @{b}szövegbeli információk@{ub} :

  - @{fg shine}\el@{fg text} balra igazított szöveg
  - @{fg shine}\ec@{fg text} középre igazított szöveg
  - @{fg shine}\er@{fg text} jobbra igazított szöveg
  - @{fg shine}\eb@{fg text} vastag
  - @{fg shine}\eu@{fg text} aláhúzott
  - @{fg shine}\ei@{fg text} döntött
  - @{fg shine}\e1@{fg text} fehér betû
  - @{fg shine}\e0@{fg text} fekete betû
  - @{fg shine}\en@{fg text} normál mód
  - @{fg shine}\n@{fg text}  soremelés
  - @{fg shine}\t@{fg text}  tabulálás

@EndNode


@Node "Project" "Fealadat Menû"

 @{b}Katalógus megnyitása@{ub} : Egy katalógus file betöltése.

 @{b}Katalógus mentése@{ub}    : A módosított katalógus kimentése.

 @{b}Katalógus információ@{ub} : Néhány információt ad a katalógus file-ról:
                           - A készítõ neve (Csak regisztrált felhasználóknak).
                           - A katalógus neve.
                           - A katalógus nyelvezete (A regisztrált felhasználóknak a
                             nyelvezetét veszi figyelembe elõször).
                           - Katalógus file verziója
                                            kiadása
                                            mérete
                                            dátuma
                                            össz adata.  

 @{b}Névjegy@{ub} : Információ a TransCat-ról és regisztrált felhasználóról.

 @{b}Kilépés@{ub} : Kilépés a TransCat-ból.
@EndNode

@Node "Actions" "Tevékenység Menû"

 @{b}Ûres szöveg feltöltése@{ub} : Feltölti a le nem fordított szöveget az eredeti szöveggel.

 @{b}X-ik sorra ugrás@{ub}       : Sorszám szerinti keresés.
@EndNode

@Node "Import" "Import Menû"

 @{b}Katalógus Description@{ub}       : Betölt egy katalógus description (.cd) file-t. 
                               (Amit a software  készítõi mellékelni szoktak a programjaikhoz.) 

 @{b}Katalógus Translation@{ub}       : Betölt egy katalógus translation (.ct) file-t.
                               (Amit magadnak készítesz el.)
@EndNode

@Node "Export" "Export Menû"

 @{b}Katalógus Description@{ub}       : Kimentés katalógus description file-ként.

 @{b}Katalógus Translation@{ub}       : Kimentés katalógus translation file-ként.
                               (Csak regisztrált felhasználóknak)

 @{b}ASM   formátumban (.consts)@{ub} : Készít egy file-t Assembler-ben való felhasználásra.

 @{b}C     formátumban (.consts)@{ub} : Készít egy file-t C-ben való felhasználásra.

 @{b}E     formátumban (.consts)@{ub} : Készít egy file-t E-ben való felhasználásra.

 @{b}Blitz formátumban (.consts)@{ub} : Készít egy file-t Blitz-ben való felhasználásra.

@EndNode

@Node "Extras" "Különleges Menû"

 @{b}Katalógus fürkész@{ub} : A menüpont elindítása után a betöltött programból kiszedi a katalógust,
                     a program kilépése után szerkeszthetõ, kimenthetõ.
                     A beolvasás közben is megszakítható a Mégsem gombbal.
@EndNode

@Node "The Future" "A jövõ ..."

  - Várom az ötleteket, javaslatokat !!!!!!!!

@EndNode

@Node "History" "A TransCat Története."

 @{U}Version 1.20@{uU} :

  - Belsõ szövegszerkesztõ készítése (nagyon hasznos az összetett mondatok készítésénél).

 @{U}Version 1.14@{uU} :

  - Katalógus kilopó beépítése.

 @{U}Version 1.13@{uU} :

  - 5Kbyte-nál nagyobb katalaógus hibás méretkijelzés. Hiba kijavítva.

 @{U}Version 1.12@{uU} :

  - Automatikus keresés/helyettesítés elkészítése (Ha létezik több egyforma szöveg,
                                                   az összeset behelyettesíti).
  - Néhány katalógus hibás beolvasása. Hiba kijavítva.

 @{U}Version 1.01@{uU} :

  - Hibás Description file készítés. Hiba kijavítva.

 @{U}Version 1.00@{uU} :

  - Az elsõ verzió ami felkerült az Aminet-re.

@EndNode

@Node "Translation" "Nyelvezetek..."

 TransCat a következõ nyelvekre lettek lefordítva :

  - Francia :  Katalógus    : A készítõ
               Dokumentum   : A készítõ

  - Angol   :  Katalógus    : Pascal Rullier
               Dokumentum   : Millot Lionel
               Dokumentum   : Schaaij Willem

  - Német   :  Katalógus    : Dirk Neubauer
               Dokumentum   : Dirk Neubauer

  - Spanyol :  Katalógus    : Fermín Venegas
               Dokumentum   : Fermín Venegas

  - Olasz   :  Katalógus    : Virginio Savani
               Dokumentum   : Virginio Savani

  - Magyar  :  Katalógus    : Garami Ferenc  (GFS)
               Dokumentum   : Garami Ferenc  (GFS)


 Ha a TransCat katalógust le akarod fordítani más nyelvre,
 akkor elküldöm neked a katalógus description file-t (.cd).
@EndNode

@Node "Contact" "A címem ..."

  A kapcsolatot a következõ címen veheted fel velem :

      @{b}K L A X@{ub}
      P.O Box 14
      21601 Longvic CEDEX
      France

   Email  : rcilm021@dial.oleane.com
  IrcName : zIgUS ( on #artbas server irc.insat.com)
@EndNode

