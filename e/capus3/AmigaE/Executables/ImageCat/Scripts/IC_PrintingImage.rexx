/*==================================
 $VER: IC_PrintingImage 1.1 © NasGûl
 ===================================
 Ce script imprime toutes les images séléctionnées
 dans la liste avec Studio.Si Studio ne tourne pas
 il est lancé est fermé a la fin du traitement des images.
 =================================*/
Options Results

Options Failat 21
/*=== fichier passé en argument. ===*/
Parse arg fichier

/*=== chemin de Studio ===*/
studpath=GetEnv('StudioPath')

/*=== nombres d'images séléctionnées ===*/
numfile=GetEnv('IC_NUMSEL')

/*=== si Studio est sur le system ===*/
IF studpath~=="" Then
    Do
        /*=== Studio tourne-t-il ? ===*/
        x=ShowList('P','PRTSTUDIO.1')

        /*=== si non on le lance ===*/
        IF x=0 THEN Call runStudio()
        
        /*=== on va lui parler ===*/
        Address 'PRTSTUDIO.1'
        'SETFILE 'fichier
        'PANEL'
        IF PRTSTUDIO_RESULT='Ok' Then 
            'PRINT'
        ELSE
            NOP
        /*===
            on décrémente le variable IC_NUMSEL
            ce qui nous permet de savoir le dernier
            fichier a traiter.
        ===*/
        SetEnv('IC_NUMSEL',numfile-1)
    End
Else
    Nop

/*=== on regarge si on a lancer Studio ===*/
studrun=GetEnv('IC_ICRUNSTUDIO')

/*=== si oui, ===*/
IF studrun=1 Then
    Do
        /*=== traite-t-on le dernier fichier ===*/
        n=GetEnv('IC_NUMSEL')

        /*=== 
            si oui on quitte Studio puisqu'on la lancé
            est qu'on a fini alors...
        ===*/
        IF n=0 Then
            Do
                Address 'PRTSTUDIO.1' 'QUIT'
        
                /*=== on efface le résidu radioactif ===*/
                Address Command 'Delete >NIl: Env:IC_ICRUNSTUDIO'
            End
    End
Exit

runStudio:
    /*=== on lance Studio ===*/
    Address Command
    'Run >Nil: <Nil: 'studpath' nofilereq PubScreen ImageCatScreen Rexx'
    
    /*=== on attend que tout soit cool...===*/
    Do For 50 While ~Show('Ports','PRTSTUDIO.1')
        Call Delay 10
    End

    /*=== on regarde si la bête est partie ===*/
    x=ShowList('P','PRTSTUDIO.1')

    /*=== si elle est pas partie c'est qu'elle est pas la ===*/
    IF x=0 Then Exit

    /*=== on dit a tous le monde que c'est nous qu'il l'a fait :) ===*/
    SetEnv('IC_ICRUNSTUDIO',1)
Return 0

Exit



