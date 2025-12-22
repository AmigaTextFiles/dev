/*=========================================================================================*/
/* Source code generate by Gui2E v0.1 © 1994 NasGûl                                        */
/*=========================================================================================*/
/*"Peps Header"*/
/*======<<< Peps Header >>>======
 PRGVERSION '0'
 ================================
 PRGREVISION '81'
 ================================
 AUTHOR      'NasGûl'
 ===============================*/
/*======<<<   History   >>>======
 - v0.1 Imagine/Cyber v2.0/Sculpt (rotation/zoom). (04/02/94)
 - v0.2 Vertex v1.62a et v1.73.1f/start_cli et start_wb. (07/02/94)
 - v0.3 3Dpro v1.10 Final. (12/02/94)
 - v0.4 Cyber v1.0. (modification de 3Dview.m <ID_3D3D> <TYPE_OLDCYBER> <TYPE_NEWCYBER>)
        Ajout palette (Fond gris/trait noir ou Fond noir/trait blanc (15/02/94).
 - v0.5 Ajout des commandes L (load) A (ajouter objet) M (multi-load) (16/02/94).
 - v0.6 Ajout de la fonction F10 (informations sur les objets).
        l'interface a été faite avec GadToolBox et convertit avec Gui2E.
        (modification de 3Dview.m Ajout de object3d.bounded (true ou false))
        La routine readimaginefile() ne charge plus que les objets ayant des points (17/02/94).
 - v0.7 Les commandes sont en menus.
        l'écran est du type SUPER_HIRESLACE (non paramètrable).
        Récritures des routines p_StartWB() et p_StartCLI() (multi-arguments possible).
        Les couleurs (font gris/trait noir ou fond noir trait blianc) ont disparus,
        a la place on peut choisir la couleurs des points,faces,des objects selectionnés et
        de la boite d'encadrement (bounding).
 - v0.8 Sauve en binaire (pour l'utilisation de la vector.library).
        Charge les objets au format Vertex 2.0 (nouveau format) (07-10-94).
        Ajout d'un Port Arexx.
 - v0.9 Localisation.
 ===============================*/
/**/
OPT OSVERSION=37,LARGE
/*"Modules"*/
MODULE 'intuition/intuition','gadtools','libraries/gadtools','intuition/gadgetclass','intuition/screens',
       'graphics/text','exec/lists','exec/nodes','exec/ports','eropenlib','utility/tagitem'
MODULE 'graphics/displayinfo'
MODULE 'diskfont'
MODULE '3dviewnew'
MODULE 'reqtools','libraries/reqtools'
MODULE 'mathtrans'
MODULE 'intuition/intuitionbase'
MODULE 'workbench/startup'
MODULE 'rexxsyslib','rexx/storage'
MODULE 'mheader'
/**/
/*"Globals définitions"*/
ENUM ER_NONE,ER_SCREENSIG,ER_SCREEN,ER_LOCKSCREEN,ER_VISUAL,ER_CONTEXT,ER_MENUS,ER_GADGET,ER_WINDOW,
     ER_MEM,ER_BADARGS,ER_INITBASE,ER_NOFICHIER,ER_OPEN,ER_INCONNU,OK_FICHIER,ER_FONT,
     ER_PORT,ER_PORTEXIST,ER_CREATEPORT


RAISE ER_MEM IF New()=NIL,
      ER_MEM IF String()=NIL

CONST DEBUG=FALSE

CONST OBJ_SELECT=0,
      OBJ_DESELECT=1,
      OBJ_COUNTPTSFCS=2,
      SAVE_BIN=3,
      TYPE_VERTEX2=8,
      ID_3DDD=$33444444

DEF screen:PTR TO screen,
    visual=NIL,
    tattr:PTR TO textattr,
    myfont,
    reelquit=FALSE,
    offy,offx,
    titlescreen[256]:STRING
/*"view Definitions"*/
/*=== menus constants ===*/
ENUM MENU_LOADNEW,MENU_LOADADD,
     MENU_SAVE_OBJSELECT,MENU_SAVE_OBJDESELECT,MENU_SAVE_OBJALL,
     MENU_SAVE_DXF,MENU_SAVE_GEO,MENU_SAVE_RAY,MENU_SAVE_BIN,MENU_SAVEBASE,
     MENU_CONFIGURATION,
     MENU_QUITTER,
     MENU_MODE_PTS,MENU_MODE_FCS,MENU_MODE_PTSFCS,
     MENU_VUE_XOY,MENU_VUE_XOZ,MENU_VUE_YOZ,
     MENU_COORD_INVX,MENU_COORD_INVY,MENU_COORD_INVZ,
     MENU_ZOOM_P_PLUS,MENU_ZOOM_P_MOINS,MENU_ZOOM_G_PLUS,MENU_ZOOM_G_MOINS,
     MENU_ROT_UP,MENU_ROT_DOWN,MENU_ROT_LEFT,MENU_ROT_RIGHT,MENU_OBJCENTRE,MENU_INFORMATION,
     MENU_SELECTALL,MENU_DESELECTALL,MENU_OBJSELECTION,
     MENU_COUL_PTS,MENU_COUL_FCS,MENU_COUL_OBJSELECT,MENU_COUL_BOUNDING

DEF view_window=NIL:PTR TO window
DEF view_glist=NIL
DEF view_menu=NIL
/**/
/*"config Definitions"*/
DEF config_window=NIL:PTR TO window
DEF config_glist=NIL
/*==================*/
/*     Gadgets      */
/*==================*/
CONST GA_G_FCT3DPRO=0
CONST GA_G_FCTSCULPT=1
CONST GA_G_FCTIMAGINE=2
CONST GA_G_FCTVERTEX=3
CONST GA_G_CONFIGOK=4
CONST GA_G_CONFIGCANCEL=5
/*=============================
 = Gadgets labels of config
 =============================*/
DEF g_fct3dpro
DEF g_fctsculpt
DEF g_fctimagine
DEF g_fctvertex
DEF g_configok
DEF g_configcancel
/**/
/*"info Definitions"*/
DEF info_window=NIL:PTR TO window
DEF info_glist=NIL
/*==================*/
/*     Gadgets      */
/*==================*/
CONST GA_G_INFOTOTALPTS=0
CONST GA_G_INFOTOTALFCS=1
CONST GA_G_INFOTOTALOBJ=2
CONST GA_G_INFODELOBJ=3
CONST GA_G_OBJMODE=4
CONST GA_G_INFONBRSPTS=5
CONST GA_G_INFONBRSFCS=6
CONST GA_G_INFOMINX=7
CONST GA_G_INFOMAXX=8
CONST GA_G_INFOMINY=9
CONST GA_G_INFOMAXY=10
CONST GA_G_INFOMINZ=11
CONST GA_G_INFOMAXZ=12
CONST GA_G_INFOCENX=13
CONST GA_G_INFOCENY=14
CONST GA_G_INFOCENZ=15
CONST GA_G_INFOTYPE=16
CONST GA_G_INFOOK=17
CONST GA_G_INFOLIST=18
/*=============================
 = Gadgets labels of info
 =============================*/
DEF g_infototalpts
DEF g_infototalfcs
DEF g_infototalobj
DEF g_infodelobj
DEF g_objmode
DEF g_infonbrspts
DEF g_infonbrsfcs
DEF g_infominx
DEF g_infomaxx
DEF g_infominy
DEF g_infomaxy
DEF g_infominz
DEF g_infomaxz
DEF g_infocenx
DEF g_infoceny
DEF g_infocenz
DEF g_infotype
DEF g_infook
DEF g_infolist
/**/
/*"Applications Définitions"*/
DEF screensig=-1                  /*==== Signal for pubscreen  ====*/
DEF mybase:PTR TO database3d      /*==== pointer to database3d ====*/
DEF data_objtype[20]:LIST         /*==== List content string types ====*/
DEF data_boundedbox[36]:LIST      /*==== just a 3D cube ====*/
DEF defaultreqdir[256]:STRING     /*==== dir by default for FileRequester ====*/
DEF curobjnode=-1                 /*==== Current node selected ====*/
DEF stringvue:PTR TO LONG         /*==== for titlescreen ====*/
DEF arglist[100]:LIST             /*==== E list with arg ====*/
/**/
/**/
/*"Pmodules Lists"*/
PMODULE '3DViewerLoadObject'
PMODULE '3DViewerSaveObject'
PMODULE '3DViewerList'
PMODULE '3DWindows'
PMODULE '3DFonctions'
PMODULE '3DArexx'
PMODULE '3DView_Cat'
PMODULE 'PModules:dWriteF'
PMODULE 'PModules:PMheader'
PMODULE 'PModules:pListView'
/**/
/*"Message Proc"*/
/*"p_LookAllMessage() :Attend les messages sur les ports IDCMP de toutes fenêtres."*/
PROC p_LookAllMessage() 
    DEF sigreturn
    DEF viewport:PTR TO mp
    DEF configport:PTR TO mp
    DEF infoport:PTR TO mp
    IF view_window THEN viewport:=view_window.userport ELSE viewport:=NIL
    IF config_window THEN configport:=config_window.userport ELSE configport:=NIL
    IF info_window THEN infoport:=info_window.userport ELSE infoport:=NIL
    sigreturn:=Wait(Shl(1,viewport.sigbit) OR
                    Shl(1,configport.sigbit) OR
                    Shl(1,infoport.sigbit) OR
                    Shl(1,arexxport.sigbit) OR
                    $F000)
    IF (sigreturn AND Shl(1,viewport.sigbit))
        p_LookviewMessage()
    ENDIF
    IF (sigreturn AND Shl(1,configport.sigbit))
        IF (p_LookconfigMessage())=TRUE
            p_RemconfigWindow()
        ENDIF
    ENDIF
    IF (sigreturn AND Shl(1,infoport.sigbit))
        IF (p_LookinfoMessage())=TRUE
            p_ReminfoWindow()
            p_DrawBase()
        ENDIF
    ENDIF
    IF (sigreturn AND Shl(1,arexxport.sigbit))
        p_LookArexxMessage()
    ENDIF
    IF (sigreturn AND $F000)
        reelquit:=TRUE
    ENDIF
ENDPROC
/**/
/*"p_LookviewMessage() :Examine les messages sur le port IDCMP de view_window."*/
PROC p_LookviewMessage() 
    DEF mes:PTR TO intuimessage
    DEF g:PTR TO gadget
    DEF type=0,infos=NIL
    WHILE mes:=Gt_GetIMsg(view_window.userport)
        type:=mes.class
        dWriteF(['Type $\h\n'],[type])
        SELECT type
            CASE IDCMP_MENUVERIFY
                infos:=mes.code
                dWriteF(['MENUVERIFY Info $\h\n'],[infos])
            CASE IDCMP_MENUPICK
                infos:=mes.code
                dWriteF(['Info $\h\n'],[infos])
                p_LookMenusAction(infos)
            CASE (IDCMP_GADGETDOWN OR IDCMP_GADGETUP)
                g:=mes.iaddress
                infos:=g.gadgetid
                SELECT infos
                ENDSELECT
        ENDSELECT
        Gt_ReplyIMsg(mes)
    ENDWHILE
ENDPROC
/**/
/*"p_LookMenusAction(inf) :Traite l'informations des menus."*/
PROC p_LookMenusAction(inf)
    DEF para_r,plan,win
    DEF it_adr:PTR TO menuitem,sel
    WHILE it_adr:=ItemAddress(view_window.menustrip,inf)
        sel:=Long(it_adr+34)
        SELECT sel
            /*==== MENU FICHIER ====*/
            CASE MENU_LOADNEW /*==== Charger Nouveau  ====*/
                IF p_MakeRequest(get_3DView_string(REQ_DELOBJ),get_3DView_string(REQ_DELOBJ_GAD),NIL)
                    mybase.objlist:=p_CleanList(mybase.objlist,TRUE,[DISP,22,DISP,26,DISE],LIST_CLEAN)
                    mybase.totalpts:=0;mybase.totalfcs:=0
                    IF p_FileRequester(get_3DView_string(REQFILE_NEW))
                        IF info_window<>NIL THEN p_RenderinfoWindow()
                        p_AllObjects(OBJ_COUNTPTSFCS)
                        p_RebuildMinMax()
                        p_DrawBase()
                    ENDIF
                ENDIF
            CASE MENU_LOADADD /*==== Charger Ajouter ====*/
                IF p_FileRequester(get_3DView_string(REQFILE_AJOUTER))
                    IF info_window<>NIL THEN p_RenderinfoWindow()
                    p_AllObjects(OBJ_COUNTPTSFCS)
                    p_RebuildMinMax()
                    p_DrawBase()
                ENDIF
            /*=======================================*/
            /*==== Menu Sauver (séléction). ====*/
            CASE MENU_SAVE_OBJSELECT    /*==== Sauver (selected obj) ====*/
                mybase.savewhat:=MENU_SAVE_OBJSELECT
            CASE MENU_SAVE_OBJDESELECT  /*==== Sauver (no-selected obj ====*/
                mybase.savewhat:=MENU_SAVE_OBJDESELECT
            CASE MENU_SAVE_OBJALL       /*==== Tous les obj ====*/
                mybase.savewhat:=MENU_SAVE_OBJALL
            /*=======================================*/
            /*==== Menu Sauver (Format). ====*/
            CASE MENU_SAVE_DXF   /*==== Format DXF ====*/
                mybase.saveformat:=SAVE_DXF
            CASE MENU_SAVE_GEO  /*==== Format Geo ====*/
                mybase.saveformat:=SAVE_GEO
            CASE MENU_SAVE_RAY /*==== Format Ray ====*/
                mybase.saveformat:=SAVE_RAY
            CASE MENU_SAVE_BIN
                mybase.saveformat:=SAVE_BIN
            CASE MENU_SAVEBASE
                para_r:=mybase.saveformat
                SELECT para_r
                    CASE SAVE_DXF
                        p_SaveDxfFile(mybase.savewhat)
                    CASE SAVE_GEO
                        p_SaveGeoFile(mybase.savewhat)
                    CASE SAVE_RAY
                        p_SaveRayFile(mybase.savewhat)
                    CASE SAVE_BIN
                        p_SaveBinFile(mybase.savewhat)
                ENDSELECT
            /*=======================================*/
            CASE MENU_CONFIGURATION /*==== Configuration ====*/
                IF config_window=NIL
                    IF (win:=p_OpenTheConfigWindow())<>ER_NONE
                        p_MakeRequest(get_3DView_string(REQ_NO_INFOWINDOW),get_3DView_string(REQ_NO_INFOWINDOW_GAD),0)
                    ENDIF
                ENDIF
            /*=======================================*/
            CASE MENU_QUITTER /*==== Quitter ====*/
                reelquit:=TRUE
            /*==== MENU VUES ====*/
            /*==== Menu Modes ====*/
            CASE MENU_MODE_PTS    /*==== Mode Points ====*/
                mybase.drawmode:=DRAW_PTS
                p_DrawBase()
            CASE MENU_MODE_FCS    /*==== Mode Faces ====*/
                mybase.drawmode:=DRAW_FCS
                p_DrawBase()
            CASE MENU_MODE_PTSFCS /*==== Mode Pts+Fcs ====*/
                mybase.drawmode:=DRAW_PTSFCS
                p_DrawBase()
            /*=======================================*/
            /*==== Menu Vue en ====*/
            CASE MENU_VUE_XOY   /*==== Vue en XOY ====*/
                mybase.plan:=PLAN_XOY
                p_RefreshScreenTitle()
                p_DrawBase()
            CASE MENU_VUE_XOZ  /*==== Vue en XOZ ====*/
                mybase.plan:=PLAN_XOZ
                p_RefreshScreenTitle()
                p_DrawBase()
            CASE MENU_VUE_YOZ /*==== Vue en YOZ ====*/
                mybase.plan:=PLAN_YOZ
                p_RefreshScreenTitle()
                p_DrawBase()
            /*=======================================*/
            /*==== Menu coordonnées ====*/
            CASE MENU_COORD_INVX   /*==== Inverse Coord. en x ====*/
                IF mybase.signex=1 THEN mybase.signex:=-1 ELSE mybase.signex:=1
                p_RefreshScreenTitle()
                p_DrawBase()
            CASE MENU_COORD_INVY  /*====    "      "     " y ====*/
                IF mybase.signey=1 THEN mybase.signey:=-1 ELSE mybase.signey:=1
                p_RefreshScreenTitle()
                p_DrawBase()
            CASE MENU_COORD_INVZ /*====    "      "     " z ====*/
                IF mybase.signez=1 THEN mybase.signez:=-1 ELSE mybase.signez:=1
                p_RefreshScreenTitle()
                p_DrawBase()
            /*=======================================*/
            /*==== Menu Zoom ====*/
            CASE MENU_ZOOM_P_PLUS   /*==== Petit Zoom + ====*/
                mybase.echelle:=SpAdd(mybase.echelle,0.01)
                p_RefreshScreenTitle()
                p_DrawBase()
            CASE MENU_ZOOM_P_MOINS  /*==== Petit Zoom - ====*/
                mybase.echelle:=SpSub(0.01,mybase.echelle)
                p_RefreshScreenTitle()
                p_DrawBase()
            CASE MENU_ZOOM_G_PLUS /*==== Grand Zoom + ====*/
                mybase.echelle:=SpMul(mybase.echelle,2.0)
                p_RefreshScreenTitle()
                p_DrawBase()
            CASE MENU_ZOOM_G_MOINS /*==== Grand Zoom - ====*/
                mybase.echelle:=SpMul(mybase.echelle,0.5)
                p_RefreshScreenTitle()
                p_DrawBase()
            /*=======================================*/
            /*==== Menu Rotation ====*/
            CASE MENU_ROT_UP  /*==== En Haut ====*/
                para_r:=SpDiv(180.0,SpMul(mybase.anglerotation,3.14159))
                plan:=mybase.plan
                SELECT plan
                    CASE PLAN_XOY
                        dWriteF(['Axe :\d ','Angle \d\n'],[AXE_X,para_r])
                        p_RotationBase(AXE_X,para_r)
                    CASE PLAN_YOZ
                        p_RotationBase(AXE_Y,para_r)
                    CASE PLAN_XOZ
                        p_RotationBase(AXE_X,para_r)
                    DEFAULT; NOP
                ENDSELECT
                p_RebuildMinMax()
                p_DrawBase()
            CASE MENU_ROT_DOWN  /*==== En Bas  ====*/
                para_r:=SpDiv(180.0,SpMul(SpNeg(mybase.anglerotation),3.14159))
                plan:=mybase.plan
                SELECT plan
                    CASE PLAN_XOY
                        p_RotationBase(AXE_X,para_r)
                    CASE PLAN_YOZ
                        p_RotationBase(AXE_Y,para_r)
                    CASE PLAN_XOZ
                        p_RotationBase(AXE_X,para_r)
                    DEFAULT; NOP
                ENDSELECT
                p_RebuildMinMax()
                p_DrawBase()
            CASE MENU_ROT_LEFT /*==== a gauche ====*/
                para_r:=SpDiv(180.0,SpMul(mybase.anglerotation,3.14159))
                plan:=mybase.plan
                SELECT plan
                    CASE PLAN_XOY
                        p_RotationBase(AXE_Y,para_r)
                    CASE PLAN_YOZ
                        p_RotationBase(AXE_Z,para_r)
                    CASE PLAN_XOZ
                        p_RotationBase(AXE_Z,para_r)
                    DEFAULT; NOP
                ENDSELECT
                p_RebuildMinMax()
                p_DrawBase()
            CASE MENU_ROT_RIGHT /*==== a droite ====*/
                para_r:=SpDiv(180.0,SpMul(SpNeg(mybase.anglerotation),3.14159))
                plan:=mybase.plan
                SELECT plan
                    CASE PLAN_XOY
                        p_RotationBase(AXE_Y,para_r)
                    CASE PLAN_YOZ
                        p_RotationBase(AXE_Z,para_r)
                    CASE PLAN_XOZ
                        p_RotationBase(AXE_Z,para_r)
                    DEFAULT; NOP
                ENDSELECT
                p_RebuildMinMax()
                p_DrawBase()
            CASE MENU_OBJCENTRE /*==== centre les objs ====*/
                p_CentreObjs()
                p_DrawBase()
                p_RebuildMinMax()
            /*==== MENU OBJETS ====*/
            CASE MENU_SELECTALL /*==== Select tous les objs ====*/
                p_AllObjects(OBJ_SELECT)
                p_DrawBase()
            CASE MENU_DESELECTALL /*==== Deselect tous les objs ====*/
                p_AllObjects(OBJ_DESELECT)
                p_DrawBase()
            CASE MENU_OBJSELECTION /*==== Selection ====*/
                IF info_window=NIL 
                    IF (win:=p_OpenTheInfoWindow())<>ER_NONE
                        p_MakeRequest(get_3DView_string(REQ_NO_INFOWINDOW),get_3DView_string(REQ_NO_INFOWINDOW_GAD),0)
                    ENDIF
                ENDIF
            /*=======================================*/
            /*==== Menu Couleurs ====*/
            CASE MENU_COUL_PTS   /*==== Couleur points ====*/
                para_r:=p_MakePaletteRequest(get_3DView_string(REQ_COLOR_POINTS),mybase.rgbpts)
                IF para_r<>-1 THEN mybase.rgbpts:=para_r
                p_DrawBase()
            CASE MENU_COUL_FCS  /*==== Couleur faces ====*/
                para_r:=p_MakePaletteRequest(get_3DView_string(REQ_COLOR_FACES),mybase.rgbnormal)
                IF para_r<>-1 
                    mybase.rgbnormal:=para_r
                    p_DrawBase()
                ENDIF
            CASE MENU_COUL_OBJSELECT /*==== Couleur obj select. ====*/
                para_r:=p_MakePaletteRequest(get_3DView_string(REQ_COLOR_SELECTEDOBJ),mybase.rgbselect)
                IF para_r<>-1 
                    mybase.rgbselect:=para_r
                    p_DrawBase()
                ENDIF
            CASE MENU_COUL_BOUNDING /*==== Couleur encadrement. ====*/
                para_r:=p_MakePaletteRequest(get_3DView_string(REQ_COLOR_BOUNDING),mybase.rgbbounding)
                IF para_r<>-1 
                    mybase.rgbbounding:=para_r
                    p_DrawBase()
                ENDIF
        ENDSELECT
        inf:=it_adr.nextselect
    ENDWHILE
ENDPROC
/**/
/*"p_LookconfigMessage() :Examine les messages sur le port IDCMP de config_window."*/
PROC p_LookconfigMessage() 
   DEF mes:PTR TO intuimessage
   DEF g:PTR TO gadget
   DEF gstr:PTR TO stringinfo
   DEF type=0,infos=NIL
   DEF ret=FALSE
   DEF f_3dpro,f_sculpt,f_imagine,f_vertex,change=FALSE
   f_3dpro:=mybase.fct3dpro
   f_sculpt:=mybase.fctsculpt
   f_imagine:=mybase.fctimagine
   f_vertex:=mybase.fctvertex
   WHILE mes:=Gt_GetIMsg(config_window.userport)
       type:=mes.class
       SELECT type
           CASE IDCMP_MENUPICK
              infos:=mes.code
              p_LookMenusAction(infos)
           CASE IDCMP_GADGETUP
              g:=mes.iaddress
              infos:=g.gadgetid
              gstr:=g.specialinfo
              dWriteF(['Config Window Gadget Info $\h\n'],[infos])
              SELECT infos
                  CASE GA_G_FCT3DPRO
                      mybase.fct3dpro:=p_StringToFloat(gstr.buffer)
                  CASE GA_G_FCTSCULPT
                      mybase.fctsculpt:=p_StringToFloat(gstr.buffer)
                  CASE GA_G_FCTIMAGINE
                      mybase.fctimagine:=p_StringToFloat(gstr.buffer)
                  CASE GA_G_FCTVERTEX
                      mybase.fctvertex:=p_StringToFloat(gstr.buffer)
                  CASE GA_G_CONFIGOK
                      ret:=TRUE
                      change:=TRUE
                  CASE GA_G_CONFIGCANCEL
                      ret:=TRUE
              ENDSELECT
           CASE IDCMP_CLOSEWINDOW
               ret:=TRUE
       ENDSELECT
       Gt_ReplyIMsg(mes)
   ENDWHILE
   IF change=TRUE
       mybase.fct3dpro:=f_3dpro
       mybase.fctsculpt:=f_sculpt
       mybase.fctimagine:=f_imagine
       mybase.fctvertex:=f_vertex
    ENDIF
   RETURN ret
ENDPROC
/**/
/*"p_LookinfoMessage() :Examine les messages sur le port IDCMP de info_window."*/
PROC p_LookinfoMessage() 
   DEF mes:PTR TO intuimessage
   DEF g:PTR TO gadget
   DEF type=0,infos=NIL,ret=FALSE
   DEF iobj:PTR TO object3d
   WHILE mes:=Gt_GetIMsg(info_window.userport)
       type:=mes.class
       SELECT type
           CASE IDCMP_MENUPICK
              infos:=mes.code
              p_LookMenusAction(infos)
           CASE IDCMP_CLOSEWINDOW
               ret:=TRUE
           CASE IDCMP_GADGETDOWN 
              g:=mes.iaddress
              infos:=g.gadgetid
              SELECT infos
                  CASE GA_G_OBJMODE
                      infos:=mes.code
                      iobj:=p_GetAdrNode(mybase.objlist,curobjnode)
                      SELECT infos
                          CASE 0
                            iobj.selected:=FALSE
                            iobj.bounded:=FALSE
                          CASE 1
                            iobj.selected:=TRUE
                            iobj.bounded:=FALSE
                          CASE 2
                            iobj.selected:=FALSE
                            iobj.bounded:=TRUE
                          DEFAULT; NOP
                      ENDSELECT
                  ENDSELECT
           CASE IDCMP_GADGETUP
              g:=mes.iaddress
              infos:=g.gadgetid
              SELECT infos
                  CASE GA_G_INFOTOTALPTS
                  CASE GA_G_INFOTOTALFCS
                  CASE GA_G_INFOTOTALOBJ
                  CASE GA_G_INFODELOBJ
                      p_LockListView(g_infolist,info_window)
                      curobjnode:=p_EnleveNode(mybase.objlist,curobjnode,TRUE,[DISP,22,DISP,26,DISE])
                      p_UnLockListView(g_infolist,info_window,mybase.objlist)
                      p_AllObjects(OBJ_COUNTPTSFCS)
                      p_RenderinfoWindow()
                  CASE GA_G_INFONBRSPTS
                  CASE GA_G_INFONBRSFCS
                  CASE GA_G_INFOMINX
                  CASE GA_G_INFOMAXX
                  CASE GA_G_INFOMINY
                  CASE GA_G_INFOMAXY
                  CASE GA_G_INFOMINZ
                  CASE GA_G_INFOMAXZ
                  CASE GA_G_INFOCENX
                  CASE GA_G_INFOCENY
                  CASE GA_G_INFOCENZ
                  CASE GA_G_INFOTYPE
                  CASE GA_G_INFOOK
                      ret:=TRUE
                  CASE GA_G_INFOLIST
                      curobjnode:=mes.code
                      p_RenderinfoWindow()
              ENDSELECT
       ENDSELECT
       Gt_ReplyIMsg(mes)
   ENDWHILE
   RETURN ret
ENDPROC
/**/
/**/
/*"Application procédures."*/
/*"p_Init3DBase() :Initialise la base de données."*/
PROC p_Init3DBase() HANDLE 
    /*==== Allocate mem for structure ====*/
    DEF e[20]:STRING
    DEF rp
    mybase:=New(SIZEOF database3d)      
    mybase.nbrsobjs:=0
    mybase.totalpts:=0
    mybase.totalfcs:=0
    mybase.objlist:=p_InitList()
    /*mybase.fct3dpro:=0.1*/
    mybase.fct3dpro:=0.1
    mybase.fctsculpt:=0.001
    mybase.fctimagine:=1.0
    mybase.fctvertex:=0.0001
    mybase.minx:=0
    mybase.maxx:=0
    mybase.miny:=0
    mybase.maxy:=0
    mybase.minz:=0
    mybase.maxz:=0
    mybase.echelle:=0.1
    mybase.plan:=PLAN_XOY
    mybase.basecx:=0
    mybase.basecy:=0
    mybase.basecz:=0
    mybase.signex:=1
    mybase.signey:=1
    mybase.signez:=1
    mybase.anglerotation:=10.0
    mybase.rgbpts:=7
    mybase.rgbnormal:=1
    mybase.rgbselect:=6
    mybase.rgbbounding:=3
    mybase.drawmode:=DRAW_PTSFCS
    mybase.saveformat:=SAVE_DXF
    mybase.savewhat:=MENU_SAVE_OBJALL
    mybase.palette:=[$689,$002,$DDD,$458,$B6C,$FB1,$F48,$CFA]:INT
    /*==== All objects types ====*/
    data_objtype:=['Imagine','Cyber v1.0','Cyber v2.0','Sculpt',
                   'Vertex<v1.62a','Vertex>v1.73.f','3Dpro','LightWave','Vertex v2.0']
    /*==== Data for bound object ====*/
    data_boundedbox:=[0,2,1,0,3,2,3,6,2,3,7,6,7,5,6,7,4,5,4,0,1,4,1,5,1,2,6,1,6,5,4,7,3,4,3,0]
    /*==== String for info plan ====*/
    stringvue:=['Plan XOY','Plan YOZ','Plan XOZ']
    /*==== Default Dir for FileRequester ====*/
    StrCopy(defaultreqdir,'Ram:',ALL)
    StrCopy(e,p_FloatToString(mybase.echelle),ALL)
    StringF(titlescreen,'\l\s[32]       \s:\s Sx:\d[2] Sy:\d[2] Sz:\d[2] \s:\s',title_req,get_3DView_string(DMENU_VUES),stringvue[mybase.plan],mybase.signex,mybase.signey,mybase.signez,get_3DView_string(TEXT_SCALE),e)
    IF (rp:=p_CreateArexxPort('3DViewPort',0))<>ER_NONE THEN Raise(rp)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_Rem3DBase() :libère la mémoire allouée pour les objets."*/
PROC p_Rem3DBase() 
    IF arexxport THEN p_DeleteArexxPort(arexxport)
    IF mybase
        p_CleanList(mybase.objlist,TRUE,[DISP,22,DISP,26,DISE],LIST_REMOVE)
    ENDIF
ENDPROC
/**/
/*"p_InitReq(titre) :Initialise un mini requester (window),<titre>=Titre."*/
PROC p_InitReq(titre)
/********************************************************************************
 * Para         : Title (STRING).
 * Return       : address of the window.
 * Description  : Open a little Window (center on 3DviewScreen).
 *******************************************************************************/
    DEF w,wx,wy,p_itext:PTR TO intuitext,long
    p_itext:=New(SIZEOF intuitext)
    p_itext.itextfont:=tattr
    p_itext.itext:=String(EstrLen(titre))
    StrCopy(p_itext.itext,titre,ALL)
    p_itext.nexttext:=NIL
    long:=IntuiTextLength(p_itext)
    wx:=Div(screen.width,2)-Div(long,2)
    wy:=Div(screen.height,2)-5
    w:=OpenW(wx,wy,long,18,$100,$0,titre,IF screen THEN screen ELSE 0,IF screen THEN 15 ELSE 1,NIL)
    Dispose(p_itext)
    RETURN w
ENDPROC
/**/
/*"p_FileRequester(a) :PopUp a multifile requester (Reqtools.library),<a>=texte du gadget ok."*/
PROC p_FileRequester(a)
/*===============================================================================
 = Para         : Text of ok gadget.
 = Return       : False if cancel selected.
 = Description  : PopUp a MultiFileRequester,build the whatview arguments.
 ==============================================================================*/
    DEF reqfile:PTR TO rtfilerequester
    DEF liste:PTR TO rtfilelist
    DEF buffer[120]:STRING
    DEF add_liste=0
    DEF ret=FALSE
    DEF the_reelname[256]:STRING
    DEF thefile[256]:STRING
    reqfile:=NIL
    dWriteF(['p_WVFileRequester()\n'],[0])
    IF reqfile:=RtAllocRequestA(RT_FILEREQ,NIL)
        buffer[0]:=0
        RtChangeReqAttrA(reqfile,[RTFI_DIR,defaultreqdir,TAG_DONE])
        add_liste:=RtFileRequestA(reqfile,buffer,title_req,
                                  [RTFI_FLAGS,FREQF_MULTISELECT,RTFI_OKTEXT,a,RTFI_HEIGHT,200,
                                   RT_WINDOW,view_window,RT_LOCKWINDOW,TRUE,RT_UNDERSCORE,"_",TAG_DONE])
        StrCopy(defaultreqdir,reqfile.dir,ALL)
        StrCopy(thefile,reqfile.dir,ALL)
        IF reqfile THEN RtFreeRequest(reqfile)
        IF add_liste THEN ret:=TRUE
    ELSE
        dWriteF(['p_WVFileRequester() Bad\n'],[0])
        ret:=FALSE
    ENDIF
    IF ret=TRUE
        liste:=add_liste
        IF add_liste
            AddPart(thefile,'',256)
            WHILE liste
                StringF(the_reelname,'\s\s',thefile,liste.name)
                dWriteF(['Fichier :\s\n'],[the_reelname])
                p_ReadFile(the_reelname)
                liste:=liste.next
            ENDWHILE
            IF add_liste THEN RtFreeFileList(add_liste)
        ENDIF
    ELSE
        ret:=FALSE
    ENDIF
    RETURN ret
ENDPROC
/**/
/*"p_MakeRequest(bodytext,gadgettext,the_arg) :Juste un requester (reqtools.library)."*/
PROC p_MakeRequest(bodytext,gadgettext,the_arg)
/*===============================================================================
 = Para         : texte (STRING),gadgets (STRING),the_arg.
 = Return       : FALSE if cancel selected,else TRUE.
 = Description  : PopUp a requester (reqtools.library).
 ==============================================================================*/
    DEF ret
    dWriteF(['p_MakeWVRequest()\n'],[0])
    ret:=RtEZRequestA(bodytext,gadgettext,0,the_arg,[RT_WINDOW,view_window,RT_LOCKWINDOW,TRUE,RTEZ_REQTITLE,title_req,RT_UNDERSCORE,"_",0])
    RETURN ret
ENDPROC
/**/
/*"p_MakePaletteRequest(titre,couleur) :PopUp the reqtools palette requester."*/
PROC p_MakePaletteRequest(titre,couleur)
    DEF i:PTR TO intuitionbase,win:PTR TO window,ret
    i:=intuitionbase
    win:=i.activewindow
    ret:=RtPaletteRequestA(titre,NIL,[RT_WINDOW,win,RT_LOCKWINDOW,TRUE,RTPA_COLOR,couleur,0])
    RETURN ret
ENDPROC
/**/
/*"p_RefreshScreenTitle()"*/
PROC p_RefreshScreenTitle()
    DEF e[20]:STRING
    StrCopy(e,p_FloatToString(mybase.echelle),ALL)
    StringF(titlescreen,'\l\s[32]       \s:\s Sx:\d[2] Sy:\d[2] Sz:\d[2] \s:\s',title_req,get_3DView_string(DMENU_VUES),stringvue[mybase.plan],mybase.signex,mybase.signey,mybase.signez,get_3DView_string(TEXT_SCALE),e)
    SetWindowTitles(view_window,'',titlescreen)
    IF info_window
        SetWindowTitles(info_window,'3DView Informations.',titlescreen)
    ENDIF
    IF config_window
        SetWindowTitles(config_window,'3DView Configuration.',titlescreen)
    ENDIF
ENDPROC
/**/
/*"p_AllObjects(action) :Effectue une action sur tous les objets."*/
PROC p_AllObjects(action)
    DEF mylist:PTR TO lh,mynode:PTR TO ln,ob:PTR TO object3d
    DEF bpts=0,bfcs=0
    mylist:=mybase.objlist
    mynode:=mylist.head
    WHILE mynode
        IF mynode.succ<>0
            ob:=mynode
            SELECT action
                CASE OBJ_SELECT
                    ob.selected:=TRUE
                CASE OBJ_DESELECT
                    ob.selected:=FALSE
                CASE OBJ_COUNTPTSFCS
                    bpts:=bpts+ob.nbrspts
                    bfcs:=bfcs+ob.nbrsfcs
                DEFAULT
                    NOP
            ENDSELECT
        ENDIF
        mynode:=mynode.succ
    ENDWHILE
    mybase.totalpts:=bpts
    mybase.totalfcs:=bfcs
    mybase.nbrsobjs:=p_CountNodes(mybase.objlist)
ENDPROC
/**/
/*"p_StringTOFloat(string)"*/
PROC p_StringToFloat(string)
    DEF entier[256]:STRING
    DEF decimal[256]:STRING
    DEF pos
    DEF ei,di,ef,df,vir,p,res=0
    pos:=InStr(string,'.',0)
    IF pos<>-1
        MidStr(entier,string,0,pos)
        MidStr(decimal,string,pos+1,ALL)
        vir:=SpFlt(EstrLen(decimal))
        ei:=Val(entier,NIL)
        di:=Val(decimal,NIL)
        ef:=SpFlt(ei)
        p:=10
        FOR pos:=1 TO SpFix(vir)-1
            p:=Mul(p,10)
        ENDFOR
        df:=SpDiv(SpFlt(p),SpFlt(di))
        res:=SpAdd(ef,df)
        RETURN res
    ENDIF
ENDPROC
/**/
/*"p_FloatToString(float)"*/
PROC p_FloatToString(float)
    DEF r[80]:STRING
    StringF(r,'\d.\z\d[7]',SpFix(float),
            SpFix( SpMul( SpSub( SpFlt(SpFix(float)),float ),10000000.0 ) ))
    RETURN r
ENDPROC
/**/
/*"writefloat(float)"*/
PROC writefloat(float)
    WriteF('\d.\z\d[7]\n',SpFix(float),
            SpFix( SpMul( SpSub( SpFlt(SpFix(float)),float ),10000000.0 ) ))
ENDPROC
/**/
/*"p_StartWB()"*/
PROC p_StartWB() HANDLE
    DEF wb:PTR TO wbstartup
    DEF args:PTR TO wbarg
    DEF b
    DEF mes:PTR TO mn,n:PTR TO ln
    DEF source[256]:STRING
    DEF fichier[256]:STRING
    wb:=wbmessage
    mes:=wb.message
    n:=mes.ln
    WHILE n
        IF n.succ<>0
            wb:=n
            dWriteF(['NumArgs :\d\n'],[wb.numargs])
            args:=wb.arglist
            FOR b:=1 TO wb.numargs-1
                NameFromLock(args[b].lock,source,256)
                AddPart(source,'',256)
                StringF(fichier,'\s\s',source,args[b].name)
                dWriteF(['WB fichier :\s\n'],[fichier])
                arglist:=Link(fichier,arglist)
                p_ReadFile(fichier)
            ENDFOR
        ENDIF
        n:=n.succ
    ENDWHILE
    /*
    args:=wb.arglist
    dWriteF(['NumArgs :\d\n'],[wb.numargs])
    FOR b:=1 TO wb.numargs-1
        NameFromLock(args[b].lock,source,256)
        AddPart(source,'',256)
        StringF(fichier,'\s\s',source,args[b].name)
        dWriteF(['WB fichier :\s\n'],[fichier])
        p_ReadFile(fichier)
    ENDFOR
    */
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
/**/
/*"p_StartCli()"*/
PROC p_StartCli() HANDLE 
    DEF myargs:PTR TO LONG,rdargs=NIL
    DEF marg:PTR TO LONG,b=20
    DEF n[256]:STRING
    myargs:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    IF rdargs:=ReadArgs('FILES/M',myargs,NIL)
        marg:=myargs[]
        IF myargs[0]
            FOR b:=0 TO 19
                IF marg[b]<>0
                    IF b=0 THEN StrCopy(n,Long(myargs[0]),ALL) ELSE StrCopy(n,marg[b],ALL)
                     IF ((FileLength(n)<>-1) AND (EstrLen(n)<>0))
                        dWriteF(['Argcli \s ',' \s\n'],[n,EstrLen(myargs[b])])
                        p_ReadFile(n)
                    ENDIF
                ENDIF
            ENDFOR
        ENDIF
    ELSE
        Raise(ER_BADARGS)
    ENDIF
    Raise(ER_NONE)
EXCEPT
    IF rdargs THEN FreeArgs(rdargs)
    RETURN exception
ENDPROC
/**/
/**/
/*"main() :Main procédure."*/
PROC main() HANDLE 
    DEF testmain
    p_DoReadHeader({banner})
    localebase:=OpenLibrary('locale.library',0)
    open_3DView_catalog(NIL,NIL)
    IF (testmain:=p_OpenLibraries())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_Init3DBase())<>ER_NONE THEN Raise(testmain)
    IF wbmessage<>NIL
        IF (testmain:=p_StartWB())<>ER_NONE THEN Raise(testmain)
    ELSE
        IF (testmain:=p_StartCli())<>ER_NONE THEN Raise(testmain)
    ENDIF
    IF (testmain:=p_SetUpScreen())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_InitviewWindow())<>ER_NONE THEN Raise(testmain)
    /*=============================================================
    IF (testmain:=p_InitconfigWindow())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_InitinfoWindow())<>ER_NONE THEN Raise(testmain)
    ===============================================================*/
    IF (testmain:=p_OpenviewWindow())<>ER_NONE THEN Raise(testmain)
    ActivateWindow(view_window)
    /*===============================================================
    IF (testmain:=p_OpeninfoWindow())<>ER_NONE THEN Raise(testmain)
    IF (testmain:=p_OpenconfigWindow())<>ER_NONE THEN Raise(testmain)
    =================================================================*/
    IF p_EmptyList(mybase.objlist)<>-1 
        p_AllObjects(OBJ_COUNTPTSFCS)
        p_RebuildMinMax()
        p_DrawBase()
    ENDIF
    REPEAT
        p_LookAllMessage()
    UNTIL reelquit=TRUE
    Raise(ER_NONE)
EXCEPT
    IF view_window THEN p_RemviewWindow()
    IF config_window THEN p_RemconfigWindow()
    IF info_window THEN p_ReminfoWindow()
    IF mybase THEN p_Rem3DBase()
    IF screen THEN p_SetDownScreen()
    p_CloseLibraries()
    SELECT exception
        CASE ER_SCREENSIG;  WriteF(get_3DView_string(DER_SCREENSIG))
        CASE ER_SCREEN;     WriteF(get_3DView_string(DER_SCREEN))
        CASE ER_LOCKSCREEN; WriteF(get_3DView_string(DER_LOCKSCREEN))
        CASE ER_VISUAL;     WriteF(get_3DView_string(DER_VISUAL))
        CASE ER_CONTEXT;    WriteF(get_3DView_string(DER_CONTEXT))
        CASE ER_MENUS;      WriteF(get_3DView_string(DER_MENUS))
        CASE ER_GADGET;     WriteF(get_3DView_string(DER_GADGET))
        CASE ER_WINDOW;     WriteF(get_3DView_string(DER_WINDOW))
        CASE ER_INTUITIONLIB; WriteF(get_3DView_string(DER_INTUITIONLIB))
        CASE ER_GADTOOLSLIB;  WriteF(get_3DView_string(DER_GADTOOLSLIB))
        CASE ER_GRAPHICSLIB;  WriteF(get_3DView_string(DER_GRAPHICSLIB))
        CASE ER_DISKFONTLIB;  WriteF(get_3DView_string(DER_DISKFONTLIB))
        CASE ER_REQTOOLSLIB;  WriteF(get_3DView_string(DER_REQTOOLSLIB))
        CASE ER_MATHTRANSLIB; WriteF(get_3DView_string(DER_MATHTRANSLIB))
        CASE ER_REXXSYSLIBLIB; WriteF(get_3DView_string(DER_REXXSYSLIBLIB))
        CASE ER_FONT;         WriteF(get_3DView_string(DER_FONT))
        CASE ER_PORT;         WriteF(get_3DView_string(DER_PORT))
        CASE ER_PORTEXIST;    WriteF(get_3DView_string(DER_PORTEXIST))
        CASE ER_CREATEPORT;   WriteF(get_3DView_string(DER_CREATEPORT))
    ENDSELECT
    close_3DView_catalog()
    IF localebase THEN CloseLibrary(localebase)
ENDPROC
/**/
