@database TransCat
@author "zIgUS"
@node "Main" "TransCat_Slovensko.guide"
@$ver: TransCat documentation 1.20 [02.08.99]
@remark Translated by Bostjan Cargo <chargo@rocketmail.com>

                              @{b}TransCat@{ub} v1.20
                              **************
                               [02.08.1999]


             @{"   Avtorstvo    " link "Copyright"}  Pravne informacije o TransCat.
             @{"   Namestitev   " link "Installation"}  Kako namestiti TransCat.
             @{"      Uvod      " link "Introduction"}  Uvod v program TransCat.
             @{"    Uporaba     " link "Use"}  Kako uporabljati TransCat.
             @{"   Prihodnost   " link "The Future"}  Prihodnost programa TransCat.
             @{"   Zgodovina    " link "History"}  Zgodovina, vedno ta zgodovina...
             @{"     Prevod     " link "Translation"}  Prevod kataloga.

             @{"     Avtor      " link "Contact"}  Moj naslov.
@EndNode


@Node "Copyright" "Pravne informacije o TransCat."

 Pomembno :
 ==========

 TransCat je (c) 1998-1999 zIgUS. Vse pravice pridr¾ane.

 TransCat je program vrste shareware. Lahko ga registrirate s plaèilom 50 FRF,
 15 USD ali 25 DEM (@{"registracija" link "Registration"}). Prejeli boste polno razlièico.

 Predstavitveno razlièico smete prosto razpo¹iljati.
 Registrirani uporabniki si polne razlièice ne smejo deliti oz. je ne smejo
 razpo¹iljati.

 TransCat se dobavlja tak kot je : brez kakr¹nekoli garancije - niti
 vsebovane, niti izrecne. V nobenem primeru ne more biti avtor neposredno,
 niti ne posredno odgovoren za stalno ali obèasno ¹kodo oz. izgubo podatkov
 povzroèeno z rabo ali uporabo te programske opreme. 
 Vsa tveganja pri rabi tega programa nosi uporabnik sam.

 Nobena od pridru¾enih datotek, vkljuèenih v ta arhiv, ne sme biti zamenjana
 ali na kakr¹enkoli naèin spremenjena. O vsaki spremembi me morate predhodno 
 obvestiti.

 Odsvetujem vam uporabo tak¹nih razlièic. Sicer lahko raèunate na nekaj
 neprijetnih preseneèenj; obenem to vpliva tudi na prihodnji razvoj programa
 TransCat.
@EndNode


@Node "Registration" "Registriranje TransCat."

 TransCat je vrste Shareware. Prièujoèa predstavitvena razlièica ima
 naslednje omejitve:

  · Ne dovoljuje shranjevanja prevodov katalogov (.ct).
  · Avtor ne more vpisati svojega imena v datoteko .catalog

 Polno razlièico prejmete po opravljeni registraciji, tj. ko plaèate
 registracijsko pristojbino v vi¹ini 50 FRF, 15 USD ali 25 DEM.

 Ta znesek je veljaven le v primeru, ko (kot avtor) dejansko prejmem 50 FRF.
 Èe dobim manj, vas ne bom registriral vse dokler ne bom prejel toènega
 zneska.

 Èe imate tiskalnik, lahko na tem mestu uporabite obrazec za registracijo
 programa TransCat.


 Po¹ljite prosim obrazec za registracijo z va¹im naslovom na naslov:

      K L A X
      P.O Box 14
      21601 Longvic CEDEX
      France


 Registracijo bom opravil èimprej bo mogoèe.

 Takrat se vam bom tudi zahvalil za podporo mojemu delu.
 Pomnite : Le programi, ki jih kupujete, so programi, ki bodo razvijani tudi v
           bodoèe !
@EndNode

@Node "Installation" "Kako namestiti TransCat..."

 @{b}Namestitev@{ub}

 Niè la¾jega!

 Prekopirajte predal s TransCat kamorkoli na trdi disk in knji¾nico fgl.library
 v predal LIBS:.

@EndNode

@Node "Introduction" "Vizitka TransCat..."

  Programiranje je opravil zIgUS  (c) 1998-1999
  TransCat teèe le na A1200 ali bolj¹em raèunalniku.


  TransCat uporablja dve knji¾nici :

      - fgl.library
      - asl.library

  Potrebuje tudi @{"MUI" link "mui"} 3.6 ali vi¹je razlièice.

  TransCat je bil programiran v optimiranem 100% zbirniku.
  Èe najdete kak¹nega hro¹èa ali imate predlog za dodatne mo¾nosti,
  stopite v @{"stik z mano" link "Contact"}.

@EndNode

@Node "MUI" "Vizitka MUI..."


                         MUI - MagicUserInterface

                 (c) Avtorsko delo 1993-97 Stefana Stuntza


 MUI je sistem za gradnjo in vzdr¾evanje grafiènih uporabni¹kih vmesnikov.
 S  pomoèjo  nastavitvenega  programa  lahko  uporabnik  izgled doloèenega
 uporabnega programa prilagodi svojemu okusu.

 MUI  se  razpo¹ilja  kot shareware.  Èe  ¾elite  prejeti  celoten  paket,
 vkljuèno  z  veliko primeri in veè informacijami o registraciji, poi¹èite
 prosim  datoteko  "muiXXusr.lha"  (XX pomeni  oznako zadnje razlièice) na
 lokalnih BBSih ali na disketah s programi v javni lasti.


           Èe ¾elite program registrirati neposredno, po¹ljite


                         DEM 30.-  ali  USD 20.-

                                na naslov

                              Stefan Stuntz
                         Eduard-Spranger-Straße 7
                              80935 München
                               DEUTSCHLAND
@EndNode

@Node "Use" "Kako uporabljati TransCat..."
                        _          ._______  ___       .--.__ 
                       ¡¬\         |      / ¡  ¬\_____ |  ¦ ¬|
                       | _\  /\    ¦  ___/  |    \   / |  |  |
                       ¦  \\// \   | __)_   |  \  \ /  |  |  |
                       `---\/   \  |    ¬\  |  ¦\  /   |  ¯  |
                            l____\ l______\ `--' \/    l_____¦

                       ---------------------------------------
                       @{"Projekt" link "project"}  @{"Ukrepi" link "actions"}  @{"Uva¾anje" link "import"}  @{"Izva¾anje" link "export"}

 @{b}Filter@{ub} :             Omogoèa iskanje imena v katalogu. Uporabite lahko
                      nadomestni vzorec s tipko "*".
                      Bli¾njièna tipka: "f".

 @{b}Prevedeno@{ub}  :         Podaja dele¾ prevedenih elementov.

 @{b}Niz ¹t.@{ub} :            Prikazuje ¹tevilko izbranega niza.

 @{b}Prika¾i@{ub}  :           Omogoèa prikaz vseh ali samo prevedenih elementov
                      kataloga (v drugem primeru bo preveden stavek takoj po
                      vnosu prevoda izginil).
                      Bli¾njièna tipka: "p".

 @{b}©t. vseh elementov@{ub} : Prikazuje ¹tevilo elementov kataloga.

 @{b}Bli¾njica "I"@{ub} :      Omogoèa prikaz izvirnika izbranega niza.

 @{b}Bli¾njica "K"@{ub} :      Omogoèa kopiranje izvirnika v prevod izbranega niz.

 @{b}Bli¾njica "U"@{ub} :      Omogoèa dostop do urejevalnika besedil.

 @{b}Bli¾njica "N"@{ub} :      Omogoèa prikaz izbranega niza.

 @{b}Informacije o oznakah@{ub} :

  - @{fg shine}\el@{fg text} levo poravnano besedilo
  - @{fg shine}\ec@{fg text} sredinsko poravnano besedilo
  - @{fg shine}\er@{fg text} desno poravnano besedilo
  - @{fg shine}\eb@{fg text} krepko
  - @{fg shine}\eu@{fg text} podèrtano
  - @{fg shine}\ei@{fg text} po¹evno
  - @{fg shine}\e1@{fg text} bela pisava
  - @{fg shine}\e0@{fg text} èrna pisava
  - @{fg shine}\en@{fg text} obièajen naèin
  - @{fg shine}\n@{fg text}  nova vrsta
  - @{fg shine}\t@{fg text}  tabulator

@EndNode


@Node "Project" "Meni Projekt"

 @{b}Odpri katalog@{ub} : Omogoèa odpiranje vseh vrst katalogov.

 @{b}Shrani katalog@{ub} : Omogoèa shranjevanje spremenjenih katalogov.

 @{b}Informacije o katalogu@{ub} : Podaja nekaj informacij o katalogu :
                          - Avtorjevo ime (samo v registriranih izvodih).
                          - Ime kataloga.
                          - Jezik kataloga (samo v registriranih izvodih;
                            materini jeziki registriranih uporabnikov imajo
                            prednost).
                          - Razlièica kataloga.
                          - Podrazlièica kataloga.

 @{b}Vizitka@{ub} : Informacije o programu TransCat in registraciji uporabnika.


 @{b}Konèaj@{ub} : Omogoèa izhod iz programa TransCat.
@EndNode

@Node "Actions" "Meni Ukrepi"

 @{b}Zapolni prazne nize@{ub} : Omogoèa zapolnitev vseh praznih nizov v
                       katalogu.

 @{b}I¹èi ¹tevilko niza@{ub} : Omogoèa iskanje o¹tevilènih spremenljivk
                      v katalogu.
@EndNode

@Node "Import" "Meni Uva¾anje"

 @{b}Opis kataloga (.cd)@{ub} : Nalo¾i opis kataloga (.cd), ki ga ponavadi
                       priskrbijo avtorji programske opreme.

 @{b}Prevod kataloga (.ct)@{ub} : Nalo¾i prevod kataloga (.ct), ki ste ga
                         naredili sami !!!
@EndNode

@Node "Export" "Meni Izva¾anje"

 @{b}Opis kataloga (.cd)@{ub} :      Omogoèa shranjevanje opisa kataloga.

 @{b}Prevod kataloga (.ct)@{ub} :    Omogoèa shranjevanje datoteke s prevodom.
                            (samo v registriranih izvodih)

 @{b}Konstante za ASM@{ub} :         Ustvari datoteko s konstantami za zbirnik.

 @{b}Konstante za C@{ub} :           Ustvari datoteko s konstantami za jezik C.

 @{b}Konstante za E@{ub} :           Ustvari datoteko s konstantami za jezik E.

 @{b}Konstante za BlitzBasic@{ub} :  Ustvari datoteko s konstantami za jezik BlitzBasic.

@EndNode

@Node "The Future" "Povratek prihodnosti..."

  - Èakam na va¹e predloge !!!!!!!!

@EndNode

@Node "History" "Zgodba o TransCat"

 @{U}Razlièica 1.20@{uU} :

  - Dodan urejevalnik besedil (zelo uporaben pri zapletenih stavkih)

 @{U}Razlièica 1.14@{uU} :

  - Vgrajeno prestrezanje katalogov med zaganjanjem programov.

 @{U}Razlièica 1.13@{uU} :

  - Odpravljen hro¹è, ki se je pojavljal pri katalogih velikosti preko 5 KB.

 @{U}Razlièica 1.12@{uU} :

  - Ustvarjeno iskanje/zamenjevanje (deluje samodejno).
  - Odpravljen hro¹è pri branju nekaterih katalogov.

 @{U}Razlièica 1.01@{uU} :

  - Odpravljen hro¹è pri ustvarjanju datoteke z opisom kataloga.

 @{U}Razlièica 1.00@{uU} :

  - Prvo razpo¹iljanje na Aminetu.

@EndNode

@Node "Translation" "Lokalizacijski prevodi katalogov."

 TransCat je na voljo v naslednjih jezikih:

  - V franco¹èini   : prevod kataloga      : avtor
                      prevod dokumentacije : avtor

  - V angle¹èini    : prevod kataloga      : Pascal Rullier
                      prevod dokumentacije : Millot Lionel
                      prevod dokumentacije : Schaaij Willem

  - V nem¹èini      : prevod kataloga      : Dirk Neubauer
                      prevod dokumentacije : Dirk Neubauer

  - V ¹pan¹èini     : prevod kataloga      : Fermín Venegas
                      prevod dokumentacije : Fermín Venegas

  - V italijan¹èini : prevod kataloga      : Virginio Savani
                      prevod dokumentacije : Virginio Savani

  - V mad¾ar¹èini   : prevod kataloga      : Garami Ferenc

  - V sloven¹èini   : prevod kataloga      : Bo¹tjan Èargo
                      prevod dokumentacije : Bo¹tjan Èargo


 Èe ¾elite prevesti katalog za TransCat v va¹ jezik, mi to
 sporoèite, in poslal vam bom datoteko z opisom kataloga (.cd).
@EndNode

@Node "Contact" "Moj naslov..."

  Najdete me na tem naslovu :

      @{b}K L A X@{ub}
      P.O Box 14
      21601 Longvic CEDEX
      France

  E-po¹tni naslov : rcilm021@dial.oleane.com
   Nadimek na IRC : zIgUS ( na kanalu #artbas )
@EndNode
