/*=========================================
 $VER: IC_EditTools 1.0 (17.11.95) © NasGûl
 ==========================================
 Ce script lance GoldED sur l'écran de ImageCat
 pour l'édition du fichier ImageCat.Tools
 Vous êtes obligez de créer un fichier de prefs pour 
 que GoldED s'ouvre sur l'écran de ImageCat.
 ========================================*/

/*=== prefs de GoldED ===*/
prefsgolded='Env:GoldED/GoldED_ImageCat.Prefs'

/*=== On regarde si GoldED tourne ===*/
x=ShowList('P','GOLDED.1')

/*=== Il ne tourne pas,on le lance ===*/
IF x=0 Then Call runGoldED()

/*=== On lui cause ===*/
Address 'GOLDED.1'

/*=== On Lock la fenêtre courante ===*/
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

/*=== y'en a pas,on ecrase,sinon on ouvre une nouvelle fenêtre ===*/
IF t='FALSE' Then
    'OPEN NAME ImageCat:ImageCat.Tools QUIET'
Else
    'OPEN NEW NAME ImageCat:ImageCat.Tools QUIET'

/*=== On débloque la fenêtre courante ===*/
'UNLOCK'

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



