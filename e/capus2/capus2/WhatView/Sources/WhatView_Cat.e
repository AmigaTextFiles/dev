/****************************************************************
   This file was created automatically by `FlexCat V1.1'
   Do not edit by hand!
****************************************************************/
/*"DEF"*/
    /* External modules */
MODULE 'locale', 'libraries/locale'
MODULE 'utility/tagitem'
    /* Object definitions */
OBJECT fc_type
    id  :LONG
    str :LONG
ENDOBJECT
    /* Global variables */
DEF catalog_WhatView:PTR TO catalog
DEF array_WhatView[78]:ARRAY OF fc_type
    /* Constant definitions */
CONST MSG_GAD_WHATVIEW = 0
CONST MSG_GAD_INFO = 1
CONST MSG_GAD_ADDICON = 2
CONST MSG_GAD_EXECUTE = 3
CONST MSGWHATVIEW_COMASS = 4
CONST MSGWHATVIEW_COMASS_GAD = 5
CONST MSGWHATVIEW_NOCOM = 6
CONST MSGWHATVIEW_NOCOM_GAD = 7
CONST MSGWHATVIEW_EXECCOM = 8
CONST MSGWHATVIEW_EXECCOM_GAD = 9
CONST MSGWHATVIEW_FLUSHLIB_BAD = 10
CONST MSGWHATVIEW_FLUSHLIB_GOOD = 11
CONST MSGWHATVIEW_ADDICON = 12
CONST MSGWHATVIEW_WBRUN_FAILED = 13
CONST MSGERWHATVIEW_INFOWINDOW = 14
CONST MSGERWHATVIEW_ER_LOCKSCREEN = 15
CONST MSGERWHATVIEW_ER_VISUAL = 16
CONST MSGERWHATVIEW_ER_CONTEXT = 17
CONST MSGERWHATVIEW_ER_MENUS = 18
CONST MSGERWHATVIEW_ER_GADGET = 19
CONST MSGERWHATVIEW_ER_WINDOW = 20
CONST MSGERWHATVIEW_ER_NOICON = 21
CONST MSGERWHATVIEW_ER_BADARGS = 22
CONST MSGERWHATVIEW_ER_NOPREFS = 23
CONST MSGERWHATVIEW_ER_APPWIN = 24
CONST MSGERWHATVIEW_ER_APPITEM = 25
CONST MSGERWHATVIEW_ER_PORT = 26
CONST MSGERWHATVIEW_ER_PORTEXIST = 27
CONST MSGERWHATVIEW_ER_SIG = 28
CONST MSGERWHATVIEW_ER_CX = 29
CONST MSGERWHATVIEW_ER_INTUITIONLIB = 30
CONST MSGERWHATVIEW_ER_GADTOOLSLIB = 31
CONST MSGERWHATVIEW_ER_GRAPHICSLIB = 32
CONST MSGERWHATVIEW_ER_WHATISLIB = 33
CONST MSGERWHATVIEW_ER_REQTOOLSLIB = 34
CONST MSGERWHATVIEW_ER_EXECLIB = 35
CONST MSGERWHATVIEW_ER_WORKBENCHLIB = 36
CONST MSGERWHATVIEW_ER_UTILITYLIB = 37
CONST MSGERWHATVIEW_ER_DOSLIB = 38
CONST MSGERWHATVIEW_ER_ICONLIB = 39
CONST MSGERWHATVIEW_ER_REXXSYSLIBLIB = 40
CONST MSGERWHATVIEW_ER_COMMODITIESLIB = 41
CONST MSGWVPREFS_MENU_DEFACT = 42
CONST MSGWVPREFS_MENU_OPENWIN = 43
CONST MSGWVPREFS_MENU_WHATVIEW = 44
CONST MSGWVPREFS_MENU_INFO = 45
CONST MSGWVPREFS_MENU_ADDICON = 46
CONST MSGWVPREFS_MENU_EXECUTE = 47
CONST MSGWVPREFS_MENU_QUIT = 48
CONST MSGWVPREFS_MENU_UTILS = 49
CONST MSGWVPREFS_MENU_EDITICON = 50
CONST MSGWVPREFS_GAD_COMMANDE = 51
CONST MSGWVPREFS_GAD_EXECTYPE = 52
CONST MSGWVPREFS_GAD_STACK = 53
CONST MSGWVPREFS_GAD_PRI = 54
CONST MSGWVPREFS_GAD_LOAD = 55
CONST MSGWVPREFS_GAD_SAVE = 56
CONST MSGWVPREFS_GAD_SAVEAS = 57
CONST MSGWVPREFS_GAD_ADD = 58
CONST MSGWVPREFS_GAD_REM = 59
CONST MSGWVPREFS_GAD_ID = 60
CONST MSGWVPREFS_GAD_ACTION = 61
CONST MSGWVPREFS_GAD_PARENTTYPE = 62
CONST MSGWVPREFS_GAD_USEPT = 63
CONST MSGWVPREFS_REQ_EXECNOICON = 64
CONST MSGWVPREFS_REQ_NOICON = 65
CONST MSGWVPREFS_REQ_NODEFICON = 66
CONST MSGWVPREFS_REQ_TYPEEXIST = 67
CONST MSGWHATISPREFS_LOAD = 68
CONST MSGWHATISPREFS_SAVE = 69
CONST MSGWHATISPREFS_SAVEAS = 70
CONST MSGWHATISPREFS_QUIT = 71
CONST MSGWHATISPREFS_NEWNODE = 72
CONST MSGWHATISPREFS_REQ_HAILLOAD = 73
CONST MSGWHATISPREFS_REQ_HAILSAVE = 74
CONST MSGWHATISPREFS_REQ_CANCEL = 75
CONST MSGWHATIS_ER_NOPORT = 76
CONST MSGWHATIS_ER_ARG = 77
/**/
/*"open_WhatView_catalog(loc:PTR TO locale:language:PTR TO CHAR)"*/
PROC open_WhatView_catalog(loc:PTR TO locale, language:PTR TO CHAR)
    DEF tag, tagarg, dummy_var = 0

    array_WhatView[dummy_var].id := MSG_GAD_WHATVIEW; array_WhatView[dummy_var++].str := '_WhatView'
    array_WhatView[dummy_var].id := MSG_GAD_INFO; array_WhatView[dummy_var++].str := 'In_fo'
    array_WhatView[dummy_var].id := MSG_GAD_ADDICON; array_WhatView[dummy_var++].str := 'A_ddIcon'
    array_WhatView[dummy_var].id := MSG_GAD_EXECUTE; array_WhatView[dummy_var++].str := '_Execute'
    array_WhatView[dummy_var].id := MSGWHATVIEW_COMASS; array_WhatView[dummy_var++].str := 'La commande associée a \s est renvoyée au subtype \s\n' +
    'qui n''est pas dans la liste.'
    array_WhatView[dummy_var].id := MSGWHATVIEW_COMASS_GAD; array_WhatView[dummy_var++].str := 'Merci'
    array_WhatView[dummy_var].id := MSGWHATVIEW_NOCOM; array_WhatView[dummy_var++].str := 'Pas de commande pour:\n' +
    'Fichier :\s\n' +
    'Type    :\s\n' +
    'Taille  :\d\n' +
    'Date    :\s'
    array_WhatView[dummy_var].id := MSGWHATVIEW_NOCOM_GAD; array_WhatView[dummy_var++].str := '_Suivant|S_ortie'
    array_WhatView[dummy_var].id := MSGWHATVIEW_EXECCOM; array_WhatView[dummy_var++].str := 'Execution d''une commande pour:\n' +
    'Fichier :\s\n' +
    'Type    :\s\n' +
    'Taille  :\d\n'
    array_WhatView[dummy_var].id := MSGWHATVIEW_EXECCOM_GAD; array_WhatView[dummy_var++].str := '_Execute|_Annuler'
    array_WhatView[dummy_var].id := MSGWHATVIEW_FLUSHLIB_BAD; array_WhatView[dummy_var++].str := 'Flush impossible \d programme(s)\n' +
    'utilise(nt) la whatis.linbrary.'
    array_WhatView[dummy_var].id := MSGWHATVIEW_FLUSHLIB_GOOD; array_WhatView[dummy_var++].str := 'Flush de la Whatis.library'
    array_WhatView[dummy_var].id := MSGWHATVIEW_ADDICON; array_WhatView[dummy_var++].str := 'Pas d''icônes par défaut pour:\n' +
    'Fichier :\s\n' +
    'Type    :\s\n' +
    'Taille  :\d'
    array_WhatView[dummy_var].id := MSGWHATVIEW_WBRUN_FAILED; array_WhatView[dummy_var++].str := 'Erreur lors du lancement WB.'
    array_WhatView[dummy_var].id := MSGERWHATVIEW_INFOWINDOW; array_WhatView[dummy_var++].str := 'Impossible d''ouvrir la fenêtre d''informations.'
    array_WhatView[dummy_var].id := MSGERWHATVIEW_ER_LOCKSCREEN; array_WhatView[dummy_var++].str := 'Erreur : Ecran.\n'
    array_WhatView[dummy_var].id := MSGERWHATVIEW_ER_VISUAL; array_WhatView[dummy_var++].str := 'Erreur : Visual.\n'
    array_WhatView[dummy_var].id := MSGERWHATVIEW_ER_CONTEXT; array_WhatView[dummy_var++].str := 'Erreur : Context.\n'
    array_WhatView[dummy_var].id := MSGERWHATVIEW_ER_MENUS; array_WhatView[dummy_var++].str := 'Erreur : Menus.\n'
    array_WhatView[dummy_var].id := MSGERWHATVIEW_ER_GADGET; array_WhatView[dummy_var++].str := 'Erreur : Gadget.\n'
    array_WhatView[dummy_var].id := MSGERWHATVIEW_ER_WINDOW; array_WhatView[dummy_var++].str := 'Erreur : Fenêtre.\n'
    array_WhatView[dummy_var].id := MSGERWHATVIEW_ER_NOICON; array_WhatView[dummy_var++].str := 'Erreur : Pas d''icône.\n'
    array_WhatView[dummy_var].id := MSGERWHATVIEW_ER_BADARGS; array_WhatView[dummy_var++].str := 'Erreur : Mauvais arguments.\n'
    array_WhatView[dummy_var].id := MSGERWHATVIEW_ER_NOPREFS; array_WhatView[dummy_var++].str := 'Erreur : Pas de fichier Env:WhatView.Prefs.\n'
    array_WhatView[dummy_var].id := MSGERWHATVIEW_ER_APPWIN; array_WhatView[dummy_var++].str := 'Erreur : Création de la fenêtre d''application.\n'
    array_WhatView[dummy_var].id := MSGERWHATVIEW_ER_APPITEM; array_WhatView[dummy_var++].str := 'Erreur : Création de l''entrée menu du Workbench.\n'
    array_WhatView[dummy_var].id := MSGERWHATVIEW_ER_PORT; array_WhatView[dummy_var++].str := 'Erreur : Création du port de messages.\n'
    array_WhatView[dummy_var].id := MSGERWHATVIEW_ER_PORTEXIST; array_WhatView[dummy_var++].str := 'Erreur : WhatViewPort existe déjà.\n'
    array_WhatView[dummy_var].id := MSGERWHATVIEW_ER_SIG; array_WhatView[dummy_var++].str := 'Erreur : Allocation du signal impossible.\n'
    array_WhatView[dummy_var].id := MSGERWHATVIEW_ER_CX; array_WhatView[dummy_var++].str := 'Erreur : Création de la commoditée.\n'
    array_WhatView[dummy_var].id := MSGERWHATVIEW_ER_INTUITIONLIB; array_WhatView[dummy_var++].str := 'Erreur : Ouverture de l''intuition.library v37 impossible.\n'
    array_WhatView[dummy_var].id := MSGERWHATVIEW_ER_GADTOOLSLIB; array_WhatView[dummy_var++].str := 'Erreur : Ouverture de la gadtools.library v37 impossible.\n'
    array_WhatView[dummy_var].id := MSGERWHATVIEW_ER_GRAPHICSLIB; array_WhatView[dummy_var++].str := 'Erreur : Ouverture de la graphics.library v37 impossible.\n'
    array_WhatView[dummy_var].id := MSGERWHATVIEW_ER_WHATISLIB; array_WhatView[dummy_var++].str := 'Erreur : Ouverture de la whatis.library v4 impossible.\n'
    array_WhatView[dummy_var].id := MSGERWHATVIEW_ER_REQTOOLSLIB; array_WhatView[dummy_var++].str := 'Erreur : Ouverture de la reqtools.library v37 impossible.\n'
    array_WhatView[dummy_var].id := MSGERWHATVIEW_ER_EXECLIB; array_WhatView[dummy_var++].str := 'Erreur : Ouverture de l''exec.library v37 impossible.\n'
    array_WhatView[dummy_var].id := MSGERWHATVIEW_ER_WORKBENCHLIB; array_WhatView[dummy_var++].str := 'Erreur : Ouverture de la workbench.librayr v37 impossible.\n'
    array_WhatView[dummy_var].id := MSGERWHATVIEW_ER_UTILITYLIB; array_WhatView[dummy_var++].str := 'Erreur : Ouverture de l''utility.library v37 impossible.\n'
    array_WhatView[dummy_var].id := MSGERWHATVIEW_ER_DOSLIB; array_WhatView[dummy_var++].str := 'Erreur : Ouverture de la dos.library v37 impossible.\n'
    array_WhatView[dummy_var].id := MSGERWHATVIEW_ER_ICONLIB; array_WhatView[dummy_var++].str := 'Erreur : Ouverture de l''icon.library v37 impossible.\n'
    array_WhatView[dummy_var].id := MSGERWHATVIEW_ER_REXXSYSLIBLIB; array_WhatView[dummy_var++].str := 'Erreur : Ouverture de la rexxsyslib.library v36 impossible.\n'
    array_WhatView[dummy_var].id := MSGERWHATVIEW_ER_COMMODITIESLIB; array_WhatView[dummy_var++].str := 'Erreur : Ouverture de la commodities.library v37 impossible.\n'
    array_WhatView[dummy_var].id := MSGWVPREFS_MENU_DEFACT; array_WhatView[dummy_var++].str := 'Action par défaut'
    array_WhatView[dummy_var].id := MSGWVPREFS_MENU_OPENWIN; array_WhatView[dummy_var++].str := 'Ouvre la fenêtre'
    array_WhatView[dummy_var].id := MSGWVPREFS_MENU_WHATVIEW; array_WhatView[dummy_var++].str := 'WhatView'
    array_WhatView[dummy_var].id := MSGWVPREFS_MENU_INFO; array_WhatView[dummy_var++].str := 'Info'
    array_WhatView[dummy_var].id := MSGWVPREFS_MENU_ADDICON; array_WhatView[dummy_var++].str := 'AddIcon'
    array_WhatView[dummy_var].id := MSGWVPREFS_MENU_EXECUTE; array_WhatView[dummy_var++].str := 'Execute'
    array_WhatView[dummy_var].id := MSGWVPREFS_MENU_QUIT; array_WhatView[dummy_var++].str := 'Quitter'
    array_WhatView[dummy_var].id := MSGWVPREFS_MENU_UTILS; array_WhatView[dummy_var++].str := 'Utilitaires'
    array_WhatView[dummy_var].id := MSGWVPREFS_MENU_EDITICON; array_WhatView[dummy_var++].str := 'Editer Icone'
    array_WhatView[dummy_var].id := MSGWVPREFS_GAD_COMMANDE; array_WhatView[dummy_var++].str := 'Commande'
    array_WhatView[dummy_var].id := MSGWVPREFS_GAD_EXECTYPE; array_WhatView[dummy_var++].str := 'ExecType'
    array_WhatView[dummy_var].id := MSGWVPREFS_GAD_STACK; array_WhatView[dummy_var++].str := 'Pile'
    array_WhatView[dummy_var].id := MSGWVPREFS_GAD_PRI; array_WhatView[dummy_var++].str := 'Priorité'
    array_WhatView[dummy_var].id := MSGWVPREFS_GAD_LOAD; array_WhatView[dummy_var++].str := 'Charger'
    array_WhatView[dummy_var].id := MSGWVPREFS_GAD_SAVE; array_WhatView[dummy_var++].str := 'Sauver'
    array_WhatView[dummy_var].id := MSGWVPREFS_GAD_SAVEAS; array_WhatView[dummy_var++].str := 'Sauver S.'
    array_WhatView[dummy_var].id := MSGWVPREFS_GAD_ADD; array_WhatView[dummy_var++].str := 'Add'
    array_WhatView[dummy_var].id := MSGWVPREFS_GAD_REM; array_WhatView[dummy_var++].str := 'Rem'
    array_WhatView[dummy_var].id := MSGWVPREFS_GAD_ID; array_WhatView[dummy_var++].str := 'ID'
    array_WhatView[dummy_var].id := MSGWVPREFS_GAD_ACTION; array_WhatView[dummy_var++].str := 'Action'
    array_WhatView[dummy_var].id := MSGWVPREFS_GAD_PARENTTYPE; array_WhatView[dummy_var++].str := 'Parent Type'
    array_WhatView[dummy_var].id := MSGWVPREFS_GAD_USEPT; array_WhatView[dummy_var++].str := 'Utilise Parent Type'
    array_WhatView[dummy_var].id := MSGWVPREFS_REQ_EXECNOICON; array_WhatView[dummy_var++].str := 'Attention !! la commande "\s" n''a pas d''icône\n' +
    '(peut-être une commande cli..).'
    array_WhatView[dummy_var].id := MSGWVPREFS_REQ_NOICON; array_WhatView[dummy_var++].str := 'Icône inexistante.'
    array_WhatView[dummy_var].id := MSGWVPREFS_REQ_NODEFICON; array_WhatView[dummy_var++].str := 'Pas d''icône par défaut.'
    array_WhatView[dummy_var].id := MSGWVPREFS_REQ_TYPEEXIST; array_WhatView[dummy_var++].str := 'Le type "\s" existe déjà.'
    array_WhatView[dummy_var].id := MSGWHATISPREFS_LOAD; array_WhatView[dummy_var++].str := 'Charger'
    array_WhatView[dummy_var].id := MSGWHATISPREFS_SAVE; array_WhatView[dummy_var++].str := 'Sauver'
    array_WhatView[dummy_var].id := MSGWHATISPREFS_SAVEAS; array_WhatView[dummy_var++].str := 'SauverS.'
    array_WhatView[dummy_var].id := MSGWHATISPREFS_QUIT; array_WhatView[dummy_var++].str := 'Quitter'
    array_WhatView[dummy_var].id := MSGWHATISPREFS_NEWNODE; array_WhatView[dummy_var++].str := '(Nouveau)'
    array_WhatView[dummy_var].id := MSGWHATISPREFS_REQ_HAILLOAD; array_WhatView[dummy_var++].str := 'WhatIsPrefs Charger'
    array_WhatView[dummy_var].id := MSGWHATISPREFS_REQ_HAILSAVE; array_WhatView[dummy_var++].str := 'WhatIsPrefs Sauver'
    array_WhatView[dummy_var].id := MSGWHATISPREFS_REQ_CANCEL; array_WhatView[dummy_var++].str := 'Annuler'
    array_WhatView[dummy_var].id := MSGWHATIS_ER_NOPORT; array_WhatView[dummy_var++].str := 'Port WhatViewPort inexistant.\n'
    array_WhatView[dummy_var].id := MSGWHATIS_ER_ARG; array_WhatView[dummy_var++].str := '1 argument manquant (Dossier ou fichier ou filtre).\n'

    IF (localebase AND (catalog_WhatView = NIL))
        IF language
            tag := OC_LANGUAGE
            tagarg := language
        ELSE
            tag:= TAG_IGNORE
        ENDIF

        catalog_WhatView := OpenCatalogA(loc, 'WhatView.catalog',
                                    [   OC_BUILTINLANGUAGE, 'français',
                                        tag, tagarg,
                                        OC_VERSION, 0,
                                        TAG_DONE    ])
    ENDIF
ENDPROC
/**/
/*"close_WhatView_catalog()"*/
PROC close_WhatView_catalog()

    IF localebase THEN CloseCatalog(catalog_WhatView)
    catalog_WhatView := NIL
ENDPROC
/**/
/*"get_WhatView_string(strnum)"*/
PROC get_WhatView_string(strnum)
    DEF defaultstr:PTR TO CHAR, i = 0

    WHILE ((i < 78) AND (array_WhatView[i].id <> strnum)) DO INC i
    defaultstr := IF (i < 78) THEN array_WhatView[i].str ELSE NIL

ENDPROC IF catalog_WhatView THEN GetCatalogStr(catalog_WhatView, strnum, defaultstr) ELSE defaultstr
/**/
/****************************************************************
   End of the automatically created part!
****************************************************************/

