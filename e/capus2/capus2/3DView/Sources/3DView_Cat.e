/****************************************************************
   This file was created automatically by `FlexCat V1.1'
   Do not edit by hand!
****************************************************************/


    /* External modules */
MODULE 'locale', 'libraries/locale'
MODULE 'utility/tagitem'

    /* Object definitions */
OBJECT fc_type
    id  :LONG
    str :LONG
ENDOBJECT

    /* Global variables */
DEF catalog_3DView:PTR TO catalog
DEF array_3DView[112]:ARRAY OF fc_type

    /* Constant definitions */
CONST REQ_DELOBJ = 0
CONST REQ_DELOBJ_GAD = 1
CONST REQFILE_NEW = 2
CONST REQFILE_AJOUTER = 3
CONST REQ_NO_INFOWINDOW = 4
CONST REQ_NO_INFOWINDOW_GAD = 5
CONST REQ_COLOR_POINTS = 6
CONST REQ_COLOR_FACES = 7
CONST REQ_COLOR_SELECTEDOBJ = 8
CONST REQ_COLOR_BOUNDING = 9
CONST TEXT_SCALE = 10
CONST DER_SCREENSIG = 11
CONST DER_SCREEN = 12
CONST DER_LOCKSCREEN = 13
CONST DER_VISUAL = 14
CONST DER_CONTEXT = 15
CONST DER_MENUS = 16
CONST DER_GADGET = 17
CONST DER_WINDOW = 18
CONST DER_INTUITIONLIB = 19
CONST DER_GADTOOLSLIB = 20
CONST DER_GRAPHICSLIB = 21
CONST DER_DISKFONTLIB = 22
CONST DER_REQTOOLSLIB = 23
CONST DER_MATHTRANSLIB = 24
CONST DER_REXXSYSLIBLIB = 25
CONST DER_FONT = 26
CONST DER_PORT = 27
CONST DER_PORTEXIST = 28
CONST DER_CREATEPORT = 29
CONST DMENU_FILE = 30
CONST DMENU_LOADNEW = 31
CONST DMENU_LOADADD = 32
CONST DMENU_SAVE_S = 33
CONST DMENU_SAVE_OBJSELECT = 34
CONST DMENU_SAVE_OBJDESELECT = 35
CONST DMENU_SAVE_ALLOBJ = 36
CONST DMENU_SAVE_F = 37
CONST DMENU_SAVE_DXF = 38
CONST DMENU_SAVE_GEO = 39
CONST DMENU_SAVE_RAY = 40
CONST DMENU_SAVE_BIN = 41
CONST DMENU_SAVEBASE = 42
CONST DMENU_CONFIGURATION = 43
CONST DMENU_QUITTER = 44
CONST DMENU_VUES = 45
CONST DMENU_MODE = 46
CONST DMENU_MODE_PTS = 47
CONST DMENU_MODE_FCS = 48
CONST DMENU_MODE_PTSFCS = 49
CONST DMENU_VUEEN = 50
CONST DMENU_VUE_XOY = 51
CONST DMENU_VUE_XOZ = 52
CONST DMENU_VUE_YOZ = 53
CONST DMENU_COORD = 54
CONST DMENU_COORD_INVX = 55
CONST DMENU_COORD_INVY = 56
CONST DMENU_COORD_INVZ = 57
CONST DMENU_ZOOM = 58
CONST DMENU_ZOOM_P_PLUS = 59
CONST DMENU_ZOOM_P_MOINS = 60
CONST DMENU_ZOOM_G_PLUS = 61
CONST DMENU_ZOOM_G_MOINS = 62
CONST DMENU_ROT = 63
CONST DMENU_ROT_UP = 64
CONST DMENU_ROT_DOWN = 65
CONST DMENU_ROT_LEFT = 66
CONST DMENU_ROT_RIGHT = 67
CONST DMENU_OBJCENTRE = 68
CONST DMENU_OBJ = 69
CONST DMENU_SELECTALL = 70
CONST DMENU_DESELECTALL = 71
CONST DMENU_OBJSECTION = 72
CONST DMENU_COLOR = 73
CONST DMENU_COLORPTS = 74
CONST DMENU_COLORFCS = 75
CONST DMENU_COLOROBJSELECT = 76
CONST DMENU_COLORBOUNDING = 77
CONST GAD_DELOBJ = 78
CONST GAD_TYPE = 79
CONST GAD_MX_NORMAL = 80
CONST GAD_MX_SELECT = 81
CONST GAD_MX_BOUNDED = 82
CONST GAD_MX_HIDE = 83
CONST GAD_NBRSPTS = 84
CONST GAD_NBRSFCS = 85
CONST GAD_MINX = 86
CONST GAD_MAXX = 87
CONST GAD_MINY = 88
CONST GAD_MAXY = 89
CONST GAD_MINZ = 90
CONST GAD_MAXZ = 91
CONST GAD_TOTALPTS = 92
CONST GAD_TOTALFCS = 93
CONST GAD_TOTALOBJ = 94
CONST GAD_CENTREX = 95
CONST GAD_CENTREY = 96
CONST GAD_CENTREZ = 97
CONST GAD_OUI = 98
CONST WREQ_3D2 = 99
CONST WREQ_3D = 100
CONST WREQ_VERTEX = 101
CONST WREQ_3DPRO = 102
CONST WREQ_IMAGINE = 103
CONST WREQ_SCULPT = 104
CONST WREQ_VERTEX2 = 105
CONST REQ_INCONNU = 106
CONST GAD_SAVEGEO = 107
CONST GAD_SAVEDXF = 108
CONST GAD_SAVERAY = 109
CONST GAD_SAVEBIN = 110
CONST GAD_FCT3DSAVEBIN = 111


    /* Opening catalog procedure */
PROC open_3DView_catalog(loc:PTR TO locale, language:PTR TO CHAR)
    DEF tag, tagarg, dummy_var = 0

    array_3DView[dummy_var].id := REQ_DELOBJ; array_3DView[dummy_var++].str := 'Tous les objets de la base vont être éffacés!!.'
    array_3DView[dummy_var].id := REQ_DELOBJ_GAD; array_3DView[dummy_var++].str := '_Oui|_Non'
    array_3DView[dummy_var].id := REQFILE_NEW; array_3DView[dummy_var++].str := 'Nouveau'
    array_3DView[dummy_var].id := REQFILE_AJOUTER; array_3DView[dummy_var++].str := 'Ajouter'
    array_3DView[dummy_var].id := REQ_NO_INFOWINDOW; array_3DView[dummy_var++].str := 'Impossible d''ouvir la fenêtre d''informations.'
    array_3DView[dummy_var].id := REQ_NO_INFOWINDOW_GAD; array_3DView[dummy_var++].str := '_Oui'
    array_3DView[dummy_var].id := REQ_COLOR_POINTS; array_3DView[dummy_var++].str := 'Couleur des points.'
    array_3DView[dummy_var].id := REQ_COLOR_FACES; array_3DView[dummy_var++].str := 'Couleur des faces.'
    array_3DView[dummy_var].id := REQ_COLOR_SELECTEDOBJ; array_3DView[dummy_var++].str := 'Couleur des objets selectionnés.'
    array_3DView[dummy_var].id := REQ_COLOR_BOUNDING; array_3DView[dummy_var++].str := 'Couleur d''encadrement.'
    array_3DView[dummy_var].id := TEXT_SCALE; array_3DView[dummy_var++].str := 'Echelle'
    array_3DView[dummy_var].id := DER_SCREENSIG; array_3DView[dummy_var++].str := 'AllocSignal() impossible pour l''écran.\n'
    array_3DView[dummy_var].id := DER_SCREEN; array_3DView[dummy_var++].str := 'Impossible d''ouvrir l''écran.\n'
    array_3DView[dummy_var].id := DER_LOCKSCREEN; array_3DView[dummy_var++].str := 'Impossible de ''locker'' l''écran.\n'
    array_3DView[dummy_var].id := DER_VISUAL; array_3DView[dummy_var++].str := 'Erreur : Visual.\n'
    array_3DView[dummy_var].id := DER_CONTEXT; array_3DView[dummy_var++].str := 'Erreur : Context.\n'
    array_3DView[dummy_var].id := DER_MENUS; array_3DView[dummy_var++].str := 'Erreur : Menus.\n'
    array_3DView[dummy_var].id := DER_GADGET; array_3DView[dummy_var++].str := 'Erreur : Gadget.\n'
    array_3DView[dummy_var].id := DER_WINDOW; array_3DView[dummy_var++].str := 'Erreur : Fenêtre.\n'
    array_3DView[dummy_var].id := DER_INTUITIONLIB; array_3DView[dummy_var++].str := 'Ouverture de l''intuition.library v37 impossible.\n'
    array_3DView[dummy_var].id := DER_GADTOOLSLIB; array_3DView[dummy_var++].str := 'Ouverture de la gadtools.library v37 impossible.\n'
    array_3DView[dummy_var].id := DER_GRAPHICSLIB; array_3DView[dummy_var++].str := 'Ouverture de la graphics.library v37 impossible.\n'
    array_3DView[dummy_var].id := DER_DISKFONTLIB; array_3DView[dummy_var++].str := 'Ouverture de la diskfont.library v37 impossible.n'
    array_3DView[dummy_var].id := DER_REQTOOLSLIB; array_3DView[dummy_var++].str := 'Ouverture de la reqtools.library v37 impossible.\n'
    array_3DView[dummy_var].id := DER_MATHTRANSLIB; array_3DView[dummy_var++].str := 'Ouverture de la mathtrans.library v37 impossible.\n'
    array_3DView[dummy_var].id := DER_REXXSYSLIBLIB; array_3DView[dummy_var++].str := 'Ouverture de la rexxsyslib.library v36 impossible.\n'
    array_3DView[dummy_var].id := DER_FONT; array_3DView[dummy_var++].str := 'Ouverture de la fonte Ruby.font taille 15 impossible.\n'
    array_3DView[dummy_var].id := DER_PORT; array_3DView[dummy_var++].str := 'Erreur : Port.\n'
    array_3DView[dummy_var].id := DER_PORTEXIST; array_3DView[dummy_var++].str := 'Le port Arexx est déjà présent.\n'
    array_3DView[dummy_var].id := DER_CREATEPORT; array_3DView[dummy_var++].str := 'Erreur durant la création du port de message.\n'
    array_3DView[dummy_var].id := DMENU_FILE; array_3DView[dummy_var++].str := 'Fichier'
    array_3DView[dummy_var].id := DMENU_LOADNEW; array_3DView[dummy_var++].str := 'Charger (Nouveau.)'
    array_3DView[dummy_var].id := DMENU_LOADADD; array_3DView[dummy_var++].str := 'Charger (Ajouter.)'
    array_3DView[dummy_var].id := DMENU_SAVE_S; array_3DView[dummy_var++].str := 'Sauver (Séléction.)'
    array_3DView[dummy_var].id := DMENU_SAVE_OBJSELECT; array_3DView[dummy_var++].str := 'Objets Séléctionnés.'
    array_3DView[dummy_var].id := DMENU_SAVE_OBJDESELECT; array_3DView[dummy_var++].str := 'Objets non-séléctionnés.'
    array_3DView[dummy_var].id := DMENU_SAVE_ALLOBJ; array_3DView[dummy_var++].str := 'Tous les objets.'
    array_3DView[dummy_var].id := DMENU_SAVE_F; array_3DView[dummy_var++].str := 'Sauver (Format.)'
    array_3DView[dummy_var].id := DMENU_SAVE_DXF; array_3DView[dummy_var++].str := 'Format DXF.'
    array_3DView[dummy_var].id := DMENU_SAVE_GEO; array_3DView[dummy_var++].str := 'Foramt GEO.'
    array_3DView[dummy_var].id := DMENU_SAVE_RAY; array_3DView[dummy_var++].str := 'Format RAY.'
    array_3DView[dummy_var].id := DMENU_SAVE_BIN; array_3DView[dummy_var++].str := 'Format BIN.'
    array_3DView[dummy_var].id := DMENU_SAVEBASE; array_3DView[dummy_var++].str := 'Sauver'
    array_3DView[dummy_var].id := DMENU_CONFIGURATION; array_3DView[dummy_var++].str := 'Configuration.'
    array_3DView[dummy_var].id := DMENU_QUITTER; array_3DView[dummy_var++].str := 'Quitter'
    array_3DView[dummy_var].id := DMENU_VUES; array_3DView[dummy_var++].str := 'Vues'
    array_3DView[dummy_var].id := DMENU_MODE; array_3DView[dummy_var++].str := 'Mode'
    array_3DView[dummy_var].id := DMENU_MODE_PTS; array_3DView[dummy_var++].str := 'Points.'
    array_3DView[dummy_var].id := DMENU_MODE_FCS; array_3DView[dummy_var++].str := 'Faces.'
    array_3DView[dummy_var].id := DMENU_MODE_PTSFCS; array_3DView[dummy_var++].str := 'Points+Faces.'
    array_3DView[dummy_var].id := DMENU_VUEEN; array_3DView[dummy_var++].str := 'Vue en'
    array_3DView[dummy_var].id := DMENU_VUE_XOY; array_3DView[dummy_var++].str := 'Vue en XOY.'
    array_3DView[dummy_var].id := DMENU_VUE_XOZ; array_3DView[dummy_var++].str := 'Vue en XOZ.'
    array_3DView[dummy_var].id := DMENU_VUE_YOZ; array_3DView[dummy_var++].str := 'Vue en YOZ.'
    array_3DView[dummy_var].id := DMENU_COORD; array_3DView[dummy_var++].str := 'Coordonnées'
    array_3DView[dummy_var].id := DMENU_COORD_INVX; array_3DView[dummy_var++].str := 'Inverse les coordonnées en X.'
    array_3DView[dummy_var].id := DMENU_COORD_INVY; array_3DView[dummy_var++].str := 'Inverse les coordonnées en Y.'
    array_3DView[dummy_var].id := DMENU_COORD_INVZ; array_3DView[dummy_var++].str := 'Inverse les coordonnées en Z.'
    array_3DView[dummy_var].id := DMENU_ZOOM; array_3DView[dummy_var++].str := 'Loupe'
    array_3DView[dummy_var].id := DMENU_ZOOM_P_PLUS; array_3DView[dummy_var++].str := 'Petite loupe +.'
    array_3DView[dummy_var].id := DMENU_ZOOM_P_MOINS; array_3DView[dummy_var++].str := 'Petite loupe -.'
    array_3DView[dummy_var].id := DMENU_ZOOM_G_PLUS; array_3DView[dummy_var++].str := 'Grande loupe +.'
    array_3DView[dummy_var].id := DMENU_ZOOM_G_MOINS; array_3DView[dummy_var++].str := 'Grande loupe -.'
    array_3DView[dummy_var].id := DMENU_ROT; array_3DView[dummy_var++].str := 'Rotation'
    array_3DView[dummy_var].id := DMENU_ROT_UP; array_3DView[dummy_var++].str := 'En Haut.'
    array_3DView[dummy_var].id := DMENU_ROT_DOWN; array_3DView[dummy_var++].str := 'En Bas.'
    array_3DView[dummy_var].id := DMENU_ROT_LEFT; array_3DView[dummy_var++].str := 'A Gauche.'
    array_3DView[dummy_var].id := DMENU_ROT_RIGHT; array_3DView[dummy_var++].str := 'A Droite.'
    array_3DView[dummy_var].id := DMENU_OBJCENTRE; array_3DView[dummy_var++].str := 'Centre les objets.'
    array_3DView[dummy_var].id := DMENU_OBJ; array_3DView[dummy_var++].str := 'Objets'
    array_3DView[dummy_var].id := DMENU_SELECTALL; array_3DView[dummy_var++].str := 'Sélectionner tous les objets.'
    array_3DView[dummy_var].id := DMENU_DESELECTALL; array_3DView[dummy_var++].str := 'Désélectionner tous les objets.'
    array_3DView[dummy_var].id := DMENU_OBJSECTION; array_3DView[dummy_var++].str := 'Séléction.'
    array_3DView[dummy_var].id := DMENU_COLOR; array_3DView[dummy_var++].str := 'Couleur.'
    array_3DView[dummy_var].id := DMENU_COLORPTS; array_3DView[dummy_var++].str := 'Points.'
    array_3DView[dummy_var].id := DMENU_COLORFCS; array_3DView[dummy_var++].str := 'Faces.'
    array_3DView[dummy_var].id := DMENU_COLOROBJSELECT; array_3DView[dummy_var++].str := 'Objets sélectionnés.'
    array_3DView[dummy_var].id := DMENU_COLORBOUNDING; array_3DView[dummy_var++].str := 'Encadrement.'
    array_3DView[dummy_var].id := GAD_DELOBJ; array_3DView[dummy_var++].str := 'Efface Objet.'
    array_3DView[dummy_var].id := GAD_TYPE; array_3DView[dummy_var++].str := 'Type'
    array_3DView[dummy_var].id := GAD_MX_NORMAL; array_3DView[dummy_var++].str := 'Normal.'
    array_3DView[dummy_var].id := GAD_MX_SELECT; array_3DView[dummy_var++].str := 'Séléctionné.'
    array_3DView[dummy_var].id := GAD_MX_BOUNDED; array_3DView[dummy_var++].str := 'Encadré.'
    array_3DView[dummy_var].id := GAD_MX_HIDE; array_3DView[dummy_var++].str := 'Caché.'
    array_3DView[dummy_var].id := GAD_NBRSPTS; array_3DView[dummy_var++].str := 'NbrsPts'
    array_3DView[dummy_var].id := GAD_NBRSFCS; array_3DView[dummy_var++].str := 'NbrsFcs'
    array_3DView[dummy_var].id := GAD_MINX; array_3DView[dummy_var++].str := 'MinX'
    array_3DView[dummy_var].id := GAD_MAXX; array_3DView[dummy_var++].str := 'MaxX'
    array_3DView[dummy_var].id := GAD_MINY; array_3DView[dummy_var++].str := 'MinY'
    array_3DView[dummy_var].id := GAD_MAXY; array_3DView[dummy_var++].str := 'MaxY'
    array_3DView[dummy_var].id := GAD_MINZ; array_3DView[dummy_var++].str := 'MinZ'
    array_3DView[dummy_var].id := GAD_MAXZ; array_3DView[dummy_var++].str := 'MaxZ'
    array_3DView[dummy_var].id := GAD_TOTALPTS; array_3DView[dummy_var++].str := 'TotalPts'
    array_3DView[dummy_var].id := GAD_TOTALFCS; array_3DView[dummy_var++].str := 'TotalFcs'
    array_3DView[dummy_var].id := GAD_TOTALOBJ; array_3DView[dummy_var++].str := 'TotalObj'
    array_3DView[dummy_var].id := GAD_CENTREX; array_3DView[dummy_var++].str := 'CentreX'
    array_3DView[dummy_var].id := GAD_CENTREY; array_3DView[dummy_var++].str := 'CentreY'
    array_3DView[dummy_var].id := GAD_CENTREZ; array_3DView[dummy_var++].str := 'CentreZ'
    array_3DView[dummy_var].id := GAD_OUI; array_3DView[dummy_var++].str := 'Oui'
    array_3DView[dummy_var].id := WREQ_3D2; array_3DView[dummy_var++].str := 'Charge(nt) objet(s) 3D2 .'
    array_3DView[dummy_var].id := WREQ_3D; array_3DView[dummy_var++].str := 'Charge(nt) objet(s) 3D .'
    array_3DView[dummy_var].id := WREQ_VERTEX; array_3DView[dummy_var++].str := 'Charge(nt) objet(s) Vertex .'
    array_3DView[dummy_var].id := WREQ_3DPRO; array_3DView[dummy_var++].str := 'Charge(nt) objet(s) 3DPro .'
    array_3DView[dummy_var].id := WREQ_IMAGINE; array_3DView[dummy_var++].str := 'Charge(nt) objet(s) Imagine .'
    array_3DView[dummy_var].id := WREQ_SCULPT; array_3DView[dummy_var++].str := 'Charge(nt) objet(s) Sculpt .'
    array_3DView[dummy_var].id := WREQ_VERTEX2; array_3DView[dummy_var++].str := 'Charge(nt) objet(s) Vertex2.0 .'
    array_3DView[dummy_var].id := REQ_INCONNU; array_3DView[dummy_var++].str := 'Type de fichier inconnu:\n' +
	'      Imagine 2.0\n' +
	'      Sculpt  2.04\n' +
	'      Cyber   1.0\n' +
	'      Cyber   2.0\n' +
	'      Vertex  1.62a\n' +
	'      Vertex  1.73.1f\n' +
	'      Vertex  2.0\n' +
	'      3DPro   1.10'
    array_3DView[dummy_var].id := GAD_SAVEGEO; array_3DView[dummy_var++].str := 'Sauver Geo'
    array_3DView[dummy_var].id := GAD_SAVEDXF; array_3DView[dummy_var++].str := 'Sauver DXF'
    array_3DView[dummy_var].id := GAD_SAVERAY; array_3DView[dummy_var++].str := 'Sauver Ray'
    array_3DView[dummy_var].id := GAD_SAVEBIN; array_3DView[dummy_var++].str := 'Sauver Bin'
    array_3DView[dummy_var].id := GAD_FCT3DSAVEBIN; array_3DView[dummy_var++].str := 'Facteur 3D'

    IF (localebase AND (catalog_3DView = NIL))
        IF language
            tag := OC_LANGUAGE
            tagarg := language
        ELSE
            tag:= TAG_IGNORE
        ENDIF

        catalog_3DView := OpenCatalogA(loc, '3DView.catalog',
                                    [   OC_BUILTINLANGUAGE, 'français',
                                        tag, tagarg,
                                        OC_VERSION, 0,
                                        TAG_DONE    ])
    ENDIF
ENDPROC
    
    /* Closing catalog procedure */
PROC close_3DView_catalog()

    IF localebase THEN CloseCatalog(catalog_3DView)
    catalog_3DView := NIL
ENDPROC

    /* Procedure which returns the correct string according to the catalog */
PROC get_3DView_string(strnum)
    DEF defaultstr:PTR TO CHAR, i = 0

    WHILE ((i < 112) AND (array_3DView[i].id <> strnum)) DO INC i
    defaultstr := IF (i < 112) THEN array_3DView[i].str ELSE NIL

ENDPROC IF catalog_3DView THEN GetCatalogStr(catalog_3DView, strnum, defaultstr) ELSE defaultstr
/****************************************************************
   End of the automatically created part!
****************************************************************/

