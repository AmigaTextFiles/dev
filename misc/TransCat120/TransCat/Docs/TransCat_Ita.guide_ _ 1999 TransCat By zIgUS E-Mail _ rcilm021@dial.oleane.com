@database TransCat
@author "zIgUS"
@node "Main" "TransCat.guide"
@$ver: Documentazione TransCat 1.13 [20.10.98]


                              @{b}TransCat@{ub} v1.13
                              **************
                               [20.10.1998]


             @{"   Copyright     " link "Copyright"}  Informazioni legali per TransCat.
             @{"  Installazione  " link "Installation"}  Come installare TransCat.
             @{"  Introduzione   " link "Introduction"}  Introduzione a TransCat.
             @{"      Uso        " link "Use"}  Come usare TransCat.
             @{"   Il futuro     " link "The Future"}  Il futuro di TransCat.
             @{"   La storia     " link "History"}  La storia di TransCat...
             @{"   Traduzioni    " link "Traduzione"}  Chi ha tradotto i cataloghi.

             @{"     Autore      " link "Contact"}  Il mio indirizzo.
@EndNode


@Node "Copyright" "Informazioni legali per TransCat."

 Importante :
 ===========

 TransCat is © 1998 di zIgUS. Tutti i diritti riservati.

 TrabsCat è Shareware. Ti puoi registrare pagando 50 Franchi Francesi, 15 Dollari
 o 25 Marchi @{"registrazione" link "Registration"}. In questo modo riceverai la
 versione completa.

 La versione Demo può essere distribuita liberamente.
 Gli utenti della versione registrata non possono condividere con altri o
 distribuire la loro copia completa.

 TransCat viene dato così com'è: Senza garanzia di alcun tipo, nè implicita.
 nè esplicita. In ogni caso non può essera data all'autore alcuna responsabilità
 nè diretta nè indiretta per danni eventualmente causati, perdita di dati o altro,
 o danneggiamenti di qualsiasi tipo dovuti all'uso di questo software.
 Tutti i rischi che possono derivare dall'uso di questo software vengono presi
 dall'utente.

 Tutti i file inclusi in questo archivio non possono essere cambiati od alterati
 in qualsiasi modo. Ogni modifica deve essere riportata.

 Vi prego di non usare queste versioni "modificate". Altrimenti potreste avere
 alcune spiacevoli sorprese e fermereste gli sviluppi futuri di TransCat.
@EndNode


@Node "Registration" "Registrazione a TransCat."

 TransCat è Shareware. Questa versione demo ha le seguenti restrizioni :

  . Non permette di salvare i catalogs translation (.ct).
  . L'autore non può mettere il suo nome nel file .catalog.

 Puoi ricevere la versione completa registrandoti, pagando una quota di
 50 Franchi francesi, 15 Dollari o 25 Marchi.

 Questo tipo di registrazione è l'unico consentito, se l'ammontare è inferiore
 non verrai registrato!!

 Se hai una stampante, usa il registration form che si trova all'interno di
 TransCat.

 Per favore, spedisci la registrazione con il tuo indirizzo a:

      K L A X
      P.O Box 14
      21601 Longvic CEDEX
      France


 La tua registrazione verrà disbrigata al più presto possibile.

 Ti ringrazio anticipatamente per il supporto che mi dai.
 Ricorda : @{b}Compra il software se vuoi che lo sviluppo dello stesso continui !!!@{ub}
@EndNode

@Node "Installation" "Come si installa..."

 @{b}Installazione@{ub}

 Niente di più facile!

 Copia il cassetto che contiene questo archivio dove desideri e copia la
 fgl.library nel cassetto LIBS:

@EndNode

@Node "Introduction" "Informazioni su TransCat..."

  Codificato da zIgUS  © 1998
  TransCat funziona solo su a A1200 o superiore.


  TransCat usa le librerie seguenti :

      - fgl.library
      - asl.library

  E naturalmente @{"MUI" link "mui"} 3.6 o superiore.

  TransCat è stato creato in assembler ottimizzato al 100%. Se trovi qualche
  bug o hai dei suggerimenti per altre opzioni, @{"contattami" link "Contact"}.

@EndNode

@Node "MUI" "Informazioni su MUI..."

                         @{b}MUI - MagicUserInterface@{ub}


                   (c) Copyright 1993/99 di Stefan Stuntz


 MUI è un sistema per creare e mantenere interfacce grafiche, tramite l'aiuto di
un programma per le preferenze, l'utente ha la possibilità di modificare l'aspetto
di ogni programma che usa MUI secondo il suo gusto personale.

 MUI viene distribuito come Shareware. Per ottenere il pacchetto completo, contenente
molti esempi ed altre informazioni,leggi il file 'muiXXusr.lha'
(XX è il numero di versione) che si può trovare su Aminet o sui dischi di pubblico
dominio.

 Se vuoi registrarti direttamente, manda pure 30 Marchi o 20 Dollari in banconote a

                  @{b}      Stefan Stuntz
                   Eduard-Spranger-Straße 7
                        80935 München
                           GERMANIA    @{ub}

                        


@EndNode

@Node "Use" "How to use TransCat..."
                        _          ._______  ___       .--.__ 
                       ¡¬\         |      / ¡  ¬\_____ |  ¦ ¬|
                       | _\  /\    ¦  ___/  |    \   / |  |  |
                       ¦  \\// \   | __)_   |  \  \ /  |  |  |
                       `---\/   \  |    ¬\  |  ¦\  /   |  ¯  |
                            l____\ l______\ `--' \/    l_____¦

                       ---------------------------------------
                       @{"Progetto" link "project"}  @{"Azioni" link "actions"}  @{"Importa" link "import"}  @{"Esporta" link "export"}

 @{b}Filtro@{ub}    :    Permette di cercare un nome in un catalogo, puoi usare anche
                la wildcard tramite il tasto "*". Abbreviazione: "f".

 @{b}Trandotti@{ub} :    Riporta la percentuale degli elementi tradotti.

 @{b}Numero@{ub}    :    Mostra il numero della stringa selezionata.

 @{b}Mostra@{ub}    :    Permette di mostrare tutti, o  solo gli elementi non tradotti
                del catalogo (in questo modo, la voce tradotta scompare
                quando viene tradotta). Abbreviazione: "a".

 @{b}Elementi@{ub}  :    Mostra il numero degli elementi presenti nel catalogo.

 @{b}Abbr. "e"@{ub} :    Permette di editare la stringa selezionata.

 @{b}Abbr. "c"@{ub} :    Permette di copiare la stringa selezionata.
@EndNode


@Node "Project" "Menu Progetto"

 @{b}Leggi catalogo@{ub} :  Permette di leggere ogni tipo di catalogo.

 @{b}Scrivi catalogo@{ub} : Permette di salvare il catalogo modificato.

 @{b}Informazioni sul catalogo@{ub} : Riporta alcune informazioni sul catalgog :
                           - Nome dell'autore (solo con la versine registrata).
                           - Nome del catalogo.
                           - Lingua del catalogo (solo con la versione registrata).
                           - Versione del catalogo.
                           - Revisione del catalogo.

 @{b}Informazioni@{ub} : Informazioni su TransCat e sull'utente registrato.


 @{b}Esci@{ub}  : Permette di uscire da TransCat.
@EndNode

@Node "Actions" "Menu azioni"

 @{b}Riempi stringhe vuote@{ub} : Permette di riempire le stringhe vuote presenti
                      nel catalogo.

 @{b}Cerca numero@{ub} : Permette di cercare un numero nel catalogo.
@EndNode

@Node "Import" "Menu Importa"

 @{b}Descrizione del catalogo@{ub} : Legge la descrizione di un catalogo (.cd), di solito
                            fornito dall'autore del software.

 @{b}Traduzione del catalogo@{ub} : Legge  la traduzione di un catalogo (.ct), fatto da tè !!!
@EndNode

@Node "Export" "Menu Esporta"

 @{b}Descrizione catalogo@{ub} : Permette di salvare la descrizione del catalogo (.cd).

 @{b}traduzione catalogo@{ub} : Permette di salvare il catalogo tradotto (.ct)
                       (Solo per gli utenti registrati)

 @{b}Costanti ASM@{ub} :    Crea un file di costanti per l'Assembler.

 @{b}Costanti C@{ub} :      Crea un file di costanti per il linguaggio C.

 @{b}Costanti E@{ub} :      Crea un file di costanti per il linguaggio E.

 @{b}Costanti Blitz@{ub} :  Crea un file di costanti per BlitzBasic.

@EndNode

@Node "The Future" "Il ritorno al futuro...."

  - Aspetto i tuoi suggerimenti !!!!!!!!

  - Implementare un modo di "cattura" del catalogo durante il caricamento
    di un programma eseguibile.
@EndNode

@Node "History" "La storia di TransCat"

 @{U}Versione 1.13@{uU} :

  - Correzione di un bug che si verifica se il catalogo è superiore
    a 5 kb.

 @{U}Versione 1.12@{uU} :

  - Creato il modo cerca/rimpiazza (automatico!).
  - Correzione di un bug che si verifica durante la lettura di
    alcuni cataloghi.

 @{U}Versione 1.01@{uU} :

  - Corretto un bug nella creazione del file di descrizione.

 @{U}Versione 1.00@{uU} :

  - Prima distribuzione su Aminet.

@EndNode

@Node "Traduzione" "Chi ha tradotto i cataloghi."

 TransCat è disponibile nelle seguenti lingue :

  - In Francese : Traduzione catalogo       : L'autore
                  Traduzione documentazione : L'autore

  - In Inglese : Traduzione catalogo       : Pascal Rullier
                 Traduzione documentazione : Millot Lionel
                 Traduzione documentazione : Schaaij Willem

  - In Tedesco : Traduzione catalogo       : Dirk Neubauer
                 Traduzione documentazione : Dirk Neubauer

  - In Italiano : Traduzione catalogo       : Virginio Savani
                  Traduzione documentazione : Virginio Savani

 Se desideri tradurre il catalogo di Transcat nella tua lingua, ti posso
 spedire il file di descrizione del catalogo (.cd).
@EndNode

@Node "Contact" "Il mio indirizzo..."

  Puoi contattarmi al seguente indirizzo :

      @{b}K L A X@{ub}
      P.O Box 14
      21601 Longvic CEDEX
      @{b}Francia@{ub}

   Email  : rcilm021@dial.oleane.com
  IrcName : zIgUS ( su #artbas )
@EndNode

