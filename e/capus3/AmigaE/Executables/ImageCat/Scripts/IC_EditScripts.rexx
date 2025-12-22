/*================================
 $VER: IC_EditScripts 1.0 © NasGûl
 =================================
 Ce script ouvre un sélécteur de fichiers 
 pour l'édition d'un des scripts avec GoldED
 Vous êtes obligez de créer un fichier de prefs pour 
 que GoldED s'ouvre sur l'écran de ImageCat.
 ========================================*/

/*=== prefs de GoldED ===*/
prefsgolded='Env:GoldED/GoldED_ImageCat.Prefs'

/*=== On regarde si GoldED tourne ===*/
x=ShowList('P','GOLDED.1')

/*=== Il ne tourne pas,on le lance ===*/
IF x=0 Then Call runGoldED()

/*=== on recolte les fichiers du sélécteurs de fichiers ===*/
result=GetFile(0,0,'ImageCat:Scripts','','Fichier a éditer','ImageCatScreen','PATGAD|MULTISELECT',fichier,80,200,'#?.rexx')

/*=== si il y a quelque chose a faire ===*/
IF result~=="" Then
    Do
        /*=== on se souvient du nombres de fichiers séléctionnés ===*/
        numfiles=result

        /*=== On vas lui causer ===*/
        Address 'GOLDED.1'
        
        /*=== on bloque la fenêtre courante ===*/
        'LOCK CURRENT'

        /*=== On regarde sur quel écran est GoldED en ce moment ===*/
        'QUERY SCREEN VAR 'scr

        /*=== Si il n'est pas sur l'écran de ImageCat on le met dessus===*/
        IF scr~=='ImageCatScreen' Then
            'PREFS LOAD FILE 'prefsgolded
        Else
            Nop

        /*===
            Lors d'un changement d'écran avec GoldED,si il n'y a pas de
            fenêtre ouverte,GoldED ouvre un fenêtre sans nom,nous sommes
            donc obliger de verifier si le texte courant contient du texte
            ou non,si il contient du texte c'est que GoldED avait déjà une
            fenêtre ouverte lors changement d'écran,il ne faut donc pas
            ecraser ce texte.
        ===*/

        /*=== il y a t-il du texte ? ===*/
        'QUERY ANYTEXT VAR 't

        /*=== on parcoure la liste des fichiers revoyer par le sélécteur ===*/
        Do i=1 To numfiles
            /*=== y'en a pas,on ecrase,sinon on ouvre une nouvelle fenêtre ===*/
            IF t='FALSE' Then
                Do
                    'OPEN NAME 'fichier.i' QUIET'
                    t='TRUE'
                End
            Else
                'OPEN NEW NAME 'fichier.i' QUIET'
        End

        /*=== On débloque la fenêtre courante ===*/
        'UNLOCK'
    End
Else
    Nop

Exit 0

runGoldED:
    /*=== si il y a GoldED dans le system ===*/
    x=Exists('GOLDED:GOLDED')

    /*=== y'a pas,on s'en vas...===*/
    IF x=0 Then Exit 5

    /*=== on lance tous le binz ===*/
    Address Command 'Run GoldED:GoldED Config 'prefsgolded
    
    /*=== on attend que le port soit ok ===*/
    Do For 50 While ~Show('Ports','GOLDED.1')
        Call Delay 10
    End

    /*=== si il n'y a toujours personne,on quitte ===*/
    x=ShowList('P','GOLDED.1')
    IF x=0 Then Exit 5

Return 0




