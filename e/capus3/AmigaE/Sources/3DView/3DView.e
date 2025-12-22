->> EDEVHEADER
/*= © NasGûl ==========================
 ESOURCE 3DView.e
 EDIR    Workbench:AmigaE/Sources/3DView/3DLib
 ECOPT   ERRLINE
 EXENAME 3DView
 MAKE    BUILD
 AUTHOR  NasGûl
 TYPE    EXEDOS
=====================================*/
-><
->> HISTORY
/*= History ===========================
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
 - v0.81 Localisation.
 - v0.91 Perte de la localisation essentiellement par flème que autre chose, mais...
        - Interface MUI (multi-fenêtrage).
        - Les coordonnées des objets sont flottants.
        - Sauvegarde au format POV 1.0 et POV 2.0
        - Beaucoup de routines Externes (la plupart des fonctions de gestion et de
          dessin sont des modules E).
        - Création de primitives calculées (Ruban de Moebius,Sphère..)
        - Utilisation directe de la vector.library ou du module FilledVector.m.
 - v0.92    - Les routines externes sont dans une librarie (ddd.library).

=====================================*/
-><
->> ©/DISTRIBUTION/UTILISATION
/*=====================================

 - TOUTE UTILISATION COMMERCIALE DES CES SOURCES EST
   INTERDITE SANS MON AUTORISATION.

 - TOUTE DISTRIBUTION DOIT ETRE FAITES EN TOTALITE (EXECUTABLES/MODULES E/SOURCES E).

 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 !! TOUTE INCLUSION SUR UN CD-ROM EST INTERDITE SANS MON AUTORISATION.!!
 !! SEULES LES DISTRIBUTIONS DE FRED FISH ET AMINET CDROM SONT AUTO-  !!
 !! RISES A DISTRIBUER CES PROGRAMMES/SOURCES.                        !!
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

=====================================*/
-><
OPT LARGE
OPT PREPROCESS
->> MODULES

MODULE 'muimaster','libraries/mui'
MODULE 'tools/boopsi','utility/tagitem','utility/hooks'
MODULE 'exec/ports','exec/nodes','exec/lists','other/plist'
MODULE 'intuition/intuition','intuition/screens'
MODULE 'graphics/view','graphics/modeid'
MODULE 'reqtools','libraries/reqtools'
MODULE 'mathffp','mathtrans','tools/installhook'
MODULE 'mathieeesingbas','mathieeesingtrans'
MODULE 'rexxsyslib','rexx/storage'
MODULE 'workbench/workbench','workbench/startup'

MODULE 'ddd','libraries/dddobject'
MODULE '*3DViewMUI'
-><
->> DEFINITIONS GLOBALES

ENUM ER_NONE,ER_LIBMUIMASTER,ER_LIBREQTOOLS,ER_LIBDDD,ER_LIBICON,ER_LIBUTILITY,ER_LIBMATH,ER_NOSCREEN,ER_NOWINDOW,ER_NOBASE3D,
     ER_MUIOPENMAIN,ER_OPENDRAWINGWINDOW,ER_3DVIEWRUN,ER_BADARGS

CONST FILLEDVECTOR_SIZE_FACE=16

DEF myapp=NIL:PTR TO app_obj
DEF mywindow=NIL:PTR TO window
DEF mybase=NIL:PTR TO base3d
DEF dx,dy,dw,dh,autoactive=FALSE
DEF myarexx:PTR TO app_arexx
DEF arexxhook:hook
DEF curdir[256]:STRING

-><
->> initArexxCommand()

PROC initArexxCommand()
    DEF arexxcom:PTR TO mui_command,n
    installhook(arexxhook,{lookArexxMessage})
    installhook(myarexx.error,{lookArexxError})
    myarexx.commands := NEW arexxcom[ 24 ]
    n:=0;myarexx.commands[n].mc_name:='LOADNEWOBJECT';myarexx.commands[n].mc_template:=MC_TEMPLATE_ID
            myarexx.commands[n].mc_parameters := ID_LOADNEWOBJ;myarexx.commands[n].mc_hook:=NIL
    n:=1;myarexx.commands[n].mc_name:='ADDNEWOBJECT' ;myarexx.commands[n].mc_template:=MC_TEMPLATE_ID
            myarexx.commands[n].mc_parameters := ID_ADDNEWOBJ ;myarexx.commands[n].mc_hook:=NIL
    n:=2;myarexx.commands[n].mc_name:='SAVEWHAT'     ;myarexx.commands[n].mc_template:='WHAT/N,GET/S'
            myarexx.commands[n].mc_parameters := 2        ;myarexx.commands[n].mc_hook:=arexxhook
    n:=3;myarexx.commands[n].mc_name:='SAVEFORMAT'   ;myarexx.commands[n].mc_template:='FORMAT/N,GET/S'
            myarexx.commands[n].mc_parameters := 2        ;myarexx.commands[n].mc_hook:=arexxhook
    n:=4;myarexx.commands[n].mc_name:='SAVE'         ;myarexx.commands[n].mc_template:=MC_TEMPLATE_ID
            myarexx.commands[n].mc_parameters := ID_SAVE      ;myarexx.commands[n].mc_hook:=NIL
    n:=5;myarexx.commands[n].mc_name:='SAVEBASE'     ;myarexx.commands[n].mc_template:='DIR'
            myarexx.commands[n].mc_parameters := 1        ;myarexx.commands[n].mc_hook:=arexxhook
    n:=6;myarexx.commands[n].mc_name:='FCTIMAGINE'   ;myarexx.commands[n].mc_template:='SET/K,GET/S'
            myarexx.commands[n].mc_parameters := 2        ;myarexx.commands[n].mc_hook:=arexxhook
    n:=7;myarexx.commands[n].mc_name:='FCTSCULPT'    ;myarexx.commands[n].mc_template:='SET/K,GET/S'
            myarexx.commands[n].mc_parameters := 2        ;myarexx.commands[n].mc_hook:=arexxhook
    n:=8;myarexx.commands[n].mc_name:='FCT3DPRO'     ;myarexx.commands[n].mc_template:='SET/K,GET/S'
            myarexx.commands[n].mc_parameters := 2        ;myarexx.commands[n].mc_hook:=arexxhook
    n:=9;myarexx.commands[n].mc_name:='FCTVERTEX'     ;myarexx.commands[n].mc_template:='SET/K,GET/S'
            myarexx.commands[n].mc_parameters := 2        ;myarexx.commands[n].mc_hook:=arexxhook
    n:=10;myarexx.commands[n].mc_name:='BASE3DINFO'   ;myarexx.commands[n].mc_template:=NIL
            myarexx.commands[n].mc_parameters := 0        ;myarexx.commands[n].mc_hook:=arexxhook
    n:=11;myarexx.commands[n].mc_name:='OBJECT3DINFO' ;myarexx.commands[n].mc_template:='NUM/N'
            myarexx.commands[n].mc_parameters := 1        ;myarexx.commands[n].mc_hook:=arexxhook
    n:=12;myarexx.commands[n].mc_name:='WINFILE'      ;myarexx.commands[n].mc_template:=NIL
            myarexx.commands[n].mc_parameters := 0        ;myarexx.commands[n].mc_hook:=arexxhook
    n:=13;myarexx.commands[n].mc_name:='WINVUE'       ;myarexx.commands[n].mc_template:=NIL
            myarexx.commands[n].mc_parameters := 0        ;myarexx.commands[n].mc_hook:=arexxhook
    n:=14;myarexx.commands[n].mc_name:='WINOBJ'       ;myarexx.commands[n].mc_template:=NIL
            myarexx.commands[n].mc_parameters := 0        ;myarexx.commands[n].mc_hook:=arexxhook
    n:=15;myarexx.commands[n].mc_name:='WINROT'       ;myarexx.commands[n].mc_template:=NIL
            myarexx.commands[n].mc_parameters := 0        ;myarexx.commands[n].mc_hook:=arexxhook
    n:=16;myarexx.commands[n].mc_name:='WINPREFS'     ;myarexx.commands[n].mc_template:=NIL
            myarexx.commands[n].mc_parameters := 0        ;myarexx.commands[n].mc_hook:=arexxhook
    n:=17;myarexx.commands[n].mc_name:='OBJPTSDATA'   ;myarexx.commands[n].mc_template:='NUMOBJ/A/N,NUMPTS/A/N'
            myarexx.commands[n].mc_parameters := 2        ;myarexx.commands[n].mc_hook:=arexxhook
    n:=18;myarexx.commands[n].mc_name:='OBJFCSDATA'   ;myarexx.commands[n].mc_template:='NUMOBJ/A/N,NUMFCS/A/N'
            myarexx.commands[n].mc_parameters := 2        ;myarexx.commands[n].mc_hook:=arexxhook
    n:=19;myarexx.commands[n].mc_name:='LOCKGUI'      ;myarexx.commands[n].mc_template:=NIL
            myarexx.commands[n].mc_parameters := 0        ;myarexx.commands[n].mc_hook:=arexxhook
    n:=20;myarexx.commands[n].mc_name:='UNLOCKGUI'    ;myarexx.commands[n].mc_template:=NIL
            myarexx.commands[n].mc_parameters := 0        ;myarexx.commands[n].mc_hook:=arexxhook
    n:=21;myarexx.commands[n].mc_name:='TOTALMEM'     ;myarexx.commands[n].mc_template:=NIL
            myarexx.commands[n].mc_parameters := 0        ;myarexx.commands[n].mc_hook:=arexxhook
    n:=22;myarexx.commands[n].mc_name:='LOADBASE'     ;myarexx.commands[n].mc_template:='FICHIER/A'
            myarexx.commands[n].mc_parameters := 1        ;myarexx.commands[n].mc_hook:=arexxhook
    n:=23;myarexx.commands[n].mc_name:=NIL        ;myarexx.commands[n].mc_template:=NIL
            myarexx.commands[n].mc_parameters := 0        ;myarexx.commands[n].mc_hook:=NIL
ENDPROC

-><
->> main() HANDLE

PROC main() HANDLE
    DEF t
    GetCurrentDirName(curdir,256)
    IF FindPort('3DVIEW') THEN Raise(ER_3DVIEWRUN)
    IF (t:=openLibraries())<>ER_NONE THEN Raise(t)
    IF (t:=initAPP())<>ER_NONE THEN Raise(t)
    IF wbmessage
    startWB()
    ELSE
    startCLI()
    ENDIF
    initArexxCommand()
    IF NEW myapp.create(NIL,myarexx,NIL)
    myapp.init_notifications()
    t:=lookMUIMessage()
    SELECT t
        CASE ER_NONE; NOP
        CASE ER_MUIOPENMAIN; WriteF('Mui ne peut pas ouvrir sa fenêtre.\n')
        CASE ER_OPENDRAWINGWINDOW; WriteF('Impossible d''ouvrir la fenêtre de dessin.\n')
    ENDSELECT
    myapp.dispose()
    ELSE
    Raise(ER_MUIOPENMAIN)
    ENDIF
    Raise(ER_NONE)
EXCEPT
    SELECT exception
    CASE ER_3DVIEWRUN
        WriteF('3DView est déjà lancé\n')
        CleanUp(20)
    CASE ER_LIBDDD
        WriteF('ddd.library ?\n')
    CASE ER_LIBMUIMASTER
        WriteF('muimaster.library ?\n')
    CASE ER_LIBREQTOOLS
        WriteF('reqtools.librrary ?\n')
    CASE ER_LIBICON
        WriteF('icn.library ?\n')
    CASE ER_LIBUTILITY
        WriteF('utility.library ?\n')
    CASE ER_LIBMATH
        WriteF('mathlib ?\n')
    CASE ER_NOSCREEN
        WriteF('Pas d''écran !\n')
    CASE ER_NOWINDOW
        WriteF('Pas de fenêtre !\n')
    CASE ER_NOBASE3D
        WriteF('Init base3D impossible !\n')
    CASE ER_BADARGS
        WriteF('mauvais argumets !\n')
    ENDSELECT
    remAPP()
    closeLibraries()
ENDPROC

-><
->> genCodeE(b:PTR TO base3d,vo,vsup,vsens,vtime,vrx,vry,vrz,center)

PROC genCodeE(b:PTR TO base3d,vo,vsup,vsens,vtime,vrx,vry,vrz,center)
    DEF convok,adrpts,adrfcs,longdatapts,longdatafcs
    DEF h,oldstdout,pivstr[256]:STRING,bo:PTR TO object3d,basename[256]:STRING,npts,nfcs
    SELECT vsup
    CASE VECTOR_LIB
        adrpts,adrfcs:=Conv3DObj2VectLib(b,vo,vsens,16,center)
        IF adrpts<>NIL
        bo:=getInfoNode(b.objlist,vo,GETWITH_NUM,RETURN_ADR)
        longdatapts:=(bo.nbrspts*8)+2
        IF vsens=FV_DOUBLE THEN longdatafcs:=(bo.nbrsfcs*44)+2 ELSE longdatafcs:=(bo.nbrsfcs*22)+2
        basename:=getInfoNode(b.objlist,vo,GETWITH_NUM,RETURN_NAME)
        StringF(pivstr,'Ram:\s.e',basename)
        IF h:=Open(pivstr,1006)
            oldstdout:=stdout
            stdout:=h
            WriteF('-><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n')
            WriteF('-> Source Code generate by 3View © NasGûl\n')
            WriteF('-><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n')
            WriteF('\n')
            WriteF('MODULE \avector\a,\alibraries/vector\a\n')
            WriteF('MODULE \agraphics/modeid\a\n')
            WriteF('\n')
            WriteF('DEF myvscreen:PTR TO newvscreen\n')
            WriteF('DEF mycolor:PTR TO INT\n')
            WriteF('DEF myview,vobj:PTR TO object\n')
            WriteF('DEF myworld:PTR TO world\n')
            WriteF('PROC main()\n')
            WriteF('    myvscreen:=[0,0,640,512,4,0,0,HIRESLACE_KEY,NIL,\avector.library  ©1991 by A.Lippert\a,0,0,0,640,512,4]:newvscreen\n')
            WriteF('    mycolor:=[0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,6,6,6,6,7,7,7,7,8,8,8,8,9,9,9,9,10,10,10,10,11,11,11,11,12,12,12,12,13,13,13,13,14,14,14,14,15,15,15,15,-1]:INT\n')
            WriteF('    vobj:=[{binpts},{binfcs},\n')
            WriteF('           [\d,0,0,0,\d,\d,\d,END_1]:INT,\n',vtime,vrx,vry,vrz)
            WriteF('           0,0,0,-1000,0,0,0]:object\n')
            WriteF('    myworld:=[0,1,vobj]:world\n')
            WriteF('    IF vecbase:=OpenLibrary(\avector.library\a,1)\n')
            WriteF('        IF myview:=OpenVScreen(myvscreen)\n')
            WriteF('            SetColors(myview,mycolor)\n')
            WriteF('            AutoScaleOn(myvscreen.viewmodes)\n')
            WriteF('            DoAnim(myworld)\n')
            WriteF('            IF myview THEN CloseVScreen()\n')
            WriteF('        ENDIF\n')
            WriteF('        CloseLibrary(vecbase)\n')
            WriteF('    ENDIF\n')
            WriteF('ENDPROC\n')
            WriteF('\n\n')
            WriteF('binpts: INCBIN \a\sPts.bin\a\n',basename)
            WriteF('binfcs: INCBIN \a\sFcs.bin\a\n',basename)
            Close(h)
            stdout:=oldstdout
        ENDIF
        StringF(pivstr,'Ram:\sPts.bin',basename)
        IF h:=Open(pivstr,1006)
            Write(h,adrpts,longdatapts)
            Close(h)
        ENDIF
        StringF(pivstr,'Ram:\sFcs.bin',basename)
        IF h:=Open(pivstr,1006)
            Write(h,adrfcs,longdatafcs)
            Close(h)
        ENDIF
        IF adrpts<>NIL THEN Dispose(adrpts)
        IF adrfcs<>NIL THEN Dispose(adrfcs)
        ELSE
        IF adrpts<>NIL THEN Dispose(adrpts)
        IF adrfcs<>NIL THEN Dispose(adrfcs)
        ENDIF
    ENDSELECT
ENDPROC

-><
->> lookMUIMessage()

PROC lookMUIMessage()
    DEF running = TRUE,result,signal,active,t,tempo,sel
    DEF viewport:PTR TO mp,ret
    /*=== primitives data ====*/
    DEF primname[80]:STRING,primx,primy,primfct,primfcs=0
    DEF buffer[256]:STRING,delbase=FALSE
    DEF pivobj:PTR TO object3d
    DEF resizemsg:PTR TO intuimessage
    DEF class,noprefs=TRUE

    DEF vect_sens=0,vect_support=0,vect_time=500,vect_rx=1,vect_ry=1,vect_rz=1,vect_numobj,curnbrsfcs,doit
    DEF curobjvinfo[256]:STRING

    /*== on regarde si la fenêtre est la===*/
    get(myapp.wi_3dmain,MUIA_Window_Window,{tempo})
    IF tempo=NIL THEN RETURN ER_MUIOPENMAIN

    /*== on transfert la base 3D dans les gadgets mui ===*/
    noprefs:=readPrefsFile()
    base3DinMui(mybase)

    IF Not(emptyList(mybase.objlist)) THEN updateMuiList(mybase.objlist,myapp.lv_objlist)

    get(myapp.wi_3dmain,MUIA_Window_Screen,{tempo})
    mywindow:=openDrawingWindow(tempo)
    IF mywindow=NIL THEN RETURN ER_OPENDRAWINGWINDOW

    FormatBase3DWithWindow(mybase,mywindow)
    viewport:=mywindow.userport
    IF noprefs THEN infoTextThanks(mywindow)

    WHILE running
    result:=domethod(myapp.app,[MUIM_Application_Input,{signal}])
->    WriteF('result \d\n',result)
    SELECT result
        CASE MUIV_Application_ReturnID_Quit
        running := FALSE
        CASE ID_VECTOPENWIN
        get(myapp.lv_objlist,MUIA_List_Active,{active})
        IF active<>-1
            pivobj:=getInfoNode(mybase.objlist,active,GETWITH_NUM,RETURN_ADR)
            IF pivobj<>-1
                vect_numobj:=active
                IF (pivobj.nbrsfcs>=4096) THEN request('L\aobjet a plus de 4096 faces\n(risques de guru avec la vector.library)','Ok',0,myapp.wi_objets)
                curnbrsfcs:=pivobj.nbrsfcs
                StringF(curobjvinfo,'\s \d \d',pivobj.obj_node.name,pivobj.nbrspts,pivobj.nbrsfcs)
                set(myapp.tx_vobjinfo,MUIA_Text_Contents,curobjvinfo)
                set(myapp.wi_vector,MUIA_Window_Open,MUI_TRUE)
            ENDIF
        ENDIF
        CASE ID_VECTSENS
        get(myapp.cy_vsens,MUIA_Cycle_Active,{active})
        SELECT active
            CASE 0; vect_sens:=FV_INDIRECT
            CASE 1; vect_sens:=FV_DIRECT
            CASE 2; vect_sens:=FV_DOUBLE
        ENDSELECT
        CASE ID_VECTSUPPORT
        get(myapp.cy_vsupport,MUIA_Cycle_Active,{active})
        vect_support:=active
        SELECT vect_support
            CASE VECTOR_LIB
            set(myapp.st_vduree,MUIA_Disabled,FALSE)
            set(myapp.bt_genecode,MUIA_Disabled,FALSE)
            CASE VECTOR_MOD
            set(myapp.st_vduree,MUIA_Disabled,MUI_TRUE)
            set(myapp.bt_genecode,MUIA_Disabled,MUI_TRUE)
            ENDSELECT
        CASE ID_VECTFACTOR
        get(myapp.st_vfactor,MUIA_String_Contents,{buffer})
        mybase.vectorfactor:=string2Float(buffer)
        CASE ID_VECTTIME
        get(myapp.st_vduree,MUIA_String_Contents,{buffer})
        vect_time:=Val(buffer,NIL)
        CASE ID_VECTROTX
        get(myapp.st_vrotx,MUIA_String_Contents,{buffer})
        vect_rx:=Val(buffer,NIL)
        CASE ID_VECTROTY
        get(myapp.st_vroty,MUIA_String_Contents,{buffer})
        vect_ry:=Val(buffer,NIL)
        CASE ID_VECTROTZ
        get(myapp.st_vrotz,MUIA_String_Contents,{buffer})
        vect_rz:=Val(buffer,NIL)
        CASE ID_VECTRENDER
        IF ((curnbrsfcs>=2048) AND (vect_sens=FV_DOUBLE) AND (vect_support=VECTOR_LIB))
            doit:=request('L\aobjet a plus de 2048 faces et elles sont doublées\n(risques de guru avec la vector.library)','On Essaye|Pas question',0,myapp.wi_vector)
        ELSE
            doit:=TRUE
        ENDIF
        IF doit
            sleepAll(myapp,MUI_TRUE)
            RenderVectorObject(mybase,vect_numobj,vect_support,vect_sens,vect_time,vect_rx,vect_ry,vect_rz,TRUE)
            sleepAll(myapp,FALSE)
        ENDIF
        CASE ID_VECTGENCODEE
        sleepAll(myapp,MUI_TRUE)
        genCodeE(mybase,vect_numobj,vect_support,vect_sens,vect_time,vect_rx,vect_ry,vect_rz,TRUE)
        sleepAll(myapp,FALSE)
        CASE ID_AUTOACTIVE
        IF autoactive
            tempo:=0
        ELSE
            tempo:=MUI_TRUE
        ENDIF
        autoactive:=tempo
        CASE ID_NEWANGLE
        get(myapp.sl_angle,MUIA_Slider_Level,{tempo})
        mybase.anglerotation:=tempo!
        CASE ID_MAINWINCLOSE
        IF mywindow<>NIL THEN mywindow:=closeDrawingWindow(mywindow)
        viewport:=NIL
        CASE ID_MAINWINOPEN
        IF mywindow=NIL
            get(myapp.wi_3dmain,MUIA_Window_Screen,{tempo})
            mywindow:=openDrawingWindow(tempo)
            viewport:=mywindow.userport
            IF autoactive THEN ActivateWindow(mywindow)
            sleepAll(myapp,MUI_TRUE)
            t:=DrawBase3D(mybase,mywindow)
            sleepAll(myapp,FALSE)
        ENDIF
        CASE ID_SAVEPREFS
        savePrefsFile()
        CASE ID_COLOROBJ
        get(myapp.cy_colorobjs,MUIA_Cycle_Active,{active})
        SELECT active
            CASE 0
            IF Not(tempo:=paletteRequest('Couleur des points',mybase.rgbpts))
                mybase.rgbpts:=tempo
            ENDIF
            CASE 1
            IF Not(tempo:=paletteRequest('Couleur des faces',mybase.rgbnormal))
                mybase.rgbnormal:=tempo
            ENDIF
            CASE 2
            IF Not(tempo:=paletteRequest('Couleur des objets séléctionnés',mybase.rgbselect))
                mybase.rgbselect:=tempo
            ENDIF
            CASE 3
            IF Not(tempo:=paletteRequest('Couleur de l''encadrement',mybase.rgbbounding))
                mybase.rgbbounding:=tempo
            ENDIF
        ENDSELECT
        CASE ID_CENTERBASE
        IF autoactive THEN ActivateWindow(mywindow)
        sleepAll(myapp,MUI_TRUE)
        CentreBase3D(mybase)
        t:=DrawBase3D(mybase,mywindow)
        sleepAll(myapp,FALSE)
        CASE ID_LOADNEWOBJ
        sleepAll(myapp,MUI_TRUE)
        IF request('Les objets présent seront effacer','Ok|Cancel',0,myapp.wi_3dfichier)
            mybase.objlist:=cleanList(mybase.objlist,TRUE,mybase.freedata,LIST_CLEAN)
            mybase.totalpts:=0;mybase.totalfcs:=0
            IF fileRequester('Charger objet(s)',myapp.wi_3dfichier)
            updateMuiList(mybase.objlist,myapp.lv_objlist)
            updateObjInfo()
            IF autoactive THEN ActivateWindow(mywindow)
            t:=DrawBase3D(mybase,mywindow)
            ENDIF
        ENDIF
        sleepAll(myapp,FALSE)
        CASE ID_ADDNEWOBJ
        sleepAll(myapp,MUI_TRUE)
        IF fileRequester('Charger objet(s)',myapp.wi_3dfichier)
            updateMuiList(mybase.objlist,myapp.lv_objlist)
            updateObjInfo()
            IF autoactive THEN ActivateWindow(mywindow)
            t:=DrawBase3D(mybase,mywindow)
        ENDIF
        sleepAll(myapp,FALSE)
        CASE ID_LOADNEWPRIM
        delbase:=TRUE
        CASE ID_ADDNEWPRIM
        delbase:=FALSE
        CASE ID_SAVEWHAT
        get(myapp.cy_savewhat,MUIA_Cycle_Active,{active})
        SELECT active
            CASE 0; mybase.savewhat:=SAVEOBJ_ALL
            CASE 1; mybase.savewhat:=SAVEOBJ_SEL
            CASE 2; mybase.savewhat:=SAVEOBJ_DES
        ENDSELECT
        CASE ID_SAVEFORMAT
        get(myapp.cy_saveformat,MUIA_Cycle_Active,{active})
        SELECT active
            CASE 0; mybase.saveformat:=SAVE_DXF
            CASE 1; mybase.saveformat:=SAVE_GEO
            CASE 2; mybase.saveformat:=SAVE_RAY
            CASE 3; mybase.saveformat:=SAVE_BIN
            CASE 4; mybase.saveformat:=SAVE_POV1
            CASE 5; mybase.saveformat:=SAVE_POV2
        ENDSELECT
        CASE ID_SAVE
        sleepAll(myapp,MUI_TRUE)
        IF fileSaveRequester('Sauver les objet(s)',myapp.wi_3dfichier)
        ENDIF
        sleepAll(myapp,FALSE)
        CASE ID_FCTIMAGINE
        get(myapp.st_fimagine,MUIA_String_Contents,{buffer})
        mybase.fctimagine:=string2Float(buffer)
        CASE ID_FCTSCULPT
        get(myapp.st_fsculpt,MUIA_String_Contents,{buffer})
        mybase.fctsculpt:=string2Float(buffer)
        CASE ID_FCT3DPRO
        get(myapp.st_f3dpro,MUIA_String_Contents,{buffer})
        mybase.fct3dpro:=string2Float(buffer)
        CASE ID_FCTVERTEX
        get(myapp.st_fvertex,MUIA_String_Contents,{buffer})
        mybase.fctvertex:=string2Float(buffer)
        CASE ID_MODEVUE
        get(myapp.cy_modevue,MUIA_Cycle_Active,{active})
        SELECT active
            CASE 0; mybase.drawmode:=DRAW_PTS
            CASE 1; mybase.drawmode:=DRAW_FCS
            CASE 2; mybase.drawmode:=DRAW_PTSFCS
        ENDSELECT
        IF autoactive THEN ActivateWindow(mywindow)
        sleepAll(myapp,MUI_TRUE)
        t:=DrawBase3D(mybase,mywindow)
        sleepAll(myapp,FALSE)
        CASE ID_PLANVUE
        get(myapp.cy_planvue,MUIA_Cycle_Active,{active})
        SELECT active
            CASE 0; mybase.plan:=PLAN_XOY
            CASE 1; mybase.plan:=PLAN_XOZ
            CASE 2; mybase.plan:=PLAN_YOZ
        ENDSELECT
        IF autoactive THEN ActivateWindow(mywindow)
        sleepAll(myapp,MUI_TRUE)
        t:=DrawBase3D(mybase,mywindow)
        sleepAll(myapp,FALSE)
        CASE ID_INVCOORD
        get(myapp.cy_invcoord,MUIA_Cycle_Active,{active})
        SELECT active
            CASE 1
            tempo:=mybase.signex
            mybase.signex:=IeeeSPNeg(tempo)
            CASE 2
            tempo:=mybase.signey
            mybase.signey:=IeeeSPNeg(tempo)
            CASE 3
            tempo:=mybase.signez
            mybase.signez:=IeeeSPNeg(tempo)
        ENDSELECT
        set(myapp.cy_invcoord,MUIA_Cycle_Active,0)
        IF active<>0
            IF autoactive THEN ActivateWindow(mywindow)
            sleepAll(myapp,MUI_TRUE)
            t:=DrawBase3D(mybase,mywindow)
            sleepAll(myapp,FALSE)
        ENDIF
        CASE ID_GLOUPEMOINS
            mybase.echelle:=IeeeSPMul(mybase.echelle,0.5)
            IF autoactive THEN ActivateWindow(mywindow)
            sleepAll(myapp,MUI_TRUE)
            t:=DrawBase3D(mybase,mywindow)
            sleepAll(myapp,FALSE)
        CASE ID_GLOUPEPLUS
            mybase.echelle:=IeeeSPMul(mybase.echelle,2.0)
            IF autoactive THEN ActivateWindow(mywindow)
            sleepAll(myapp,MUI_TRUE)
            t:=DrawBase3D(mybase,mywindow)
            sleepAll(myapp,FALSE)
        CASE ID_PLOUPEMOINS
            mybase.echelle:=IeeeSPMul(mybase.echelle,0.800)
            IF autoactive THEN ActivateWindow(mywindow)
            sleepAll(myapp,MUI_TRUE)
            t:=DrawBase3D(mybase,mywindow)
            sleepAll(myapp,FALSE)
        CASE ID_PLOUPEPLUS
            mybase.echelle:=IeeeSPMul(mybase.echelle,1.250)
            IF autoactive THEN ActivateWindow(mywindow)
            sleepAll(myapp,MUI_TRUE)
            t:=DrawBase3D(mybase,mywindow)
            sleepAll(myapp,FALSE)
        CASE ID_ROTUP
        RotateBase3D(mybase,CURSORUP)
        IF autoactive THEN ActivateWindow(mywindow)
        sleepAll(myapp,MUI_TRUE)
        t:=DrawBase3D(mybase,mywindow)
        sleepAll(myapp,FALSE)
        CASE ID_ROTLEFT
        RotateBase3D(mybase,CURSORLEFT)
        IF autoactive THEN ActivateWindow(mywindow)
        sleepAll(myapp,MUI_TRUE)
        t:=DrawBase3D(mybase,mywindow)
        sleepAll(myapp,FALSE)
        CASE ID_ROTRIGHT
        RotateBase3D(mybase,CURSORRIGHT)
        IF autoactive THEN ActivateWindow(mywindow)
        sleepAll(myapp,MUI_TRUE)
        t:=DrawBase3D(mybase,mywindow)
        sleepAll(myapp,FALSE)
        CASE ID_ROTDOWN
        RotateBase3D(mybase,CURSORDOWN)
        IF autoactive THEN ActivateWindow(mywindow)
        sleepAll(myapp,MUI_TRUE)
        t:=DrawBase3D(mybase,mywindow)
        sleepAll(myapp,FALSE)
        CASE ID_DRAWING
        FormatBase3DWithWindow(mybase,mywindow)
        IF autoactive THEN ActivateWindow(mywindow)
        sleepAll(myapp,MUI_TRUE)
        t:=DrawBase3D(mybase,mywindow)
        sleepAll(myapp,FALSE)
        CASE ID_OBJLISTACTIVE
        CASE ID_LISTOBJDBC
        updateObjInfo()
        CASE ID_DELOBJ
        get(myapp.lv_objlist,MUIA_List_Active,{active})
        IF active<>-1
            pivobj:=getInfoNode(mybase.objlist,active,GETWITH_NUM,RETURN_ADR)
            IF pivobj<>-1
            remNode(mybase.objlist,active,TRUE,mybase.freedata)
            mybase.nbrsobjs:=mybase.nbrsobjs-1
            mybase.totalpts:=mybase.totalpts-pivobj.nbrspts
            mybase.totalfcs:=mybase.totalfcs-pivobj.nbrsfcs
            updateMuiList(mybase.objlist,myapp.lv_objlist)
            get(myapp.wi_vector,MUIA_Window_Open,{tempo})
            IF tempo<>NIL THEN set(myapp.wi_vector,MUIA_Window_Open,FALSE)
            IF autoactive THEN ActivateWindow(mywindow)
            sleepAll(myapp,MUI_TRUE)
            t:=DrawBase3D(mybase,mywindow)
            sleepAll(myapp,FALSE)
            ENDIF
        ENDIF
        CASE ID_OBJACTMODIF
        get(myapp.lv_objlist,MUIA_List_Entries,{tempo})
        get(myapp.ra_objetact,MUIA_Radio_Active,{active})
        FOR ret:=0 TO tempo-1
            domethod(myapp.lv_objlist,[MUIM_List_Select,ret,MUIV_List_Select_Ask,{sel}])
            get(myapp.lv_objlist,MUIA_List_Active,{t})
            IF ((sel=1) OR (t=ret))
            get(myapp.ra_objetact,MUIA_Radio_Active,{active})
            pivobj:=getInfoNode(mybase.objlist,ret,GETWITH_NUM,RETURN_ADR)
            SELECT active
                CASE 0
                pivobj.bounded:=FALSE
                pivobj.selected:=FALSE
                CASE 1
                pivobj.bounded:=FALSE
                pivobj.selected:=TRUE
                CASE 2
                pivobj.bounded:=TRUE
                pivobj.selected:=FALSE
            ENDSELECT
            sleepAll(myapp,MUI_TRUE)
            t:=DrawObject3D(mybase,pivobj,mywindow)
            sleepAll(myapp,FALSE)
            ENDIF
        ENDFOR
        CASE ID_PRIMX
        CASE ID_PRIMY
        CASE ID_PRIMOK
        IF delbase=TRUE
            IF request('Les objets présent seront effacer','Ok|Cancel',0,myapp.wi_3dfichier)
            mybase.objlist:=cleanList(mybase.objlist,TRUE,mybase.freedata,LIST_CLEAN)
            mybase.totalpts:=0;mybase.totalfcs:=0
            ENDIF
        ENDIF
        /*=== get the active prim ===*/
        get(myapp.lv_primitives,MUIA_List_Active,{active})
        /*=== get séparation en x ===*/
        get(myapp.st_primx,MUIA_String_Contents,{buffer})
        primx:=Val(buffer,NIL)
        /*=== séparation en y ===*/
        get(myapp.st_primy,MUIA_String_Contents,{buffer})
        primy:=Val(buffer,NIL)
        /*=== facteur 3d ===*/
        get(myapp.st_fct3d,MUIA_String_Contents,{buffer})
        primfct:=string2Float(buffer)
        /*=== nom de l'objet ===*/
        get(myapp.st_nomobj,MUIA_String_Contents,{buffer})
        StrCopy(primname,buffer,ALL)
        IF active<>-1
            SELECT active
            CASE 0 /*=== torus ===*/
                 MakeObject(mybase,PRIM_TORUS,primname,primx,primy,primfct,primfcs)
                 IF autoactive THEN ActivateWindow(mywindow)
                 sleepAll(myapp,MUI_TRUE)
                 t:=DrawBase3D(mybase,mywindow)
                 sleepAll(myapp,FALSE)
            CASE 1 /*=== Moebius ===*/
                 MakeObject(mybase,PRIM_MOEBIUS,primname,primx,primy,primfct,primfcs)
                 IF autoactive THEN ActivateWindow(mywindow)
                 sleepAll(myapp,MUI_TRUE)
                 t:=DrawBase3D(mybase,mywindow)
                 sleepAll(myapp,FALSE)
            CASE 2 /*=== Plan ===*/
                 MakeObject(mybase,PRIM_PLAN,primname,primx,primy,primfct,primfcs)
                 IF autoactive THEN ActivateWindow(mywindow)
                 sleepAll(myapp,MUI_TRUE)
                 t:=DrawBase3D(mybase,mywindow)
                 sleepAll(myapp,FALSE)
            CASE 3 /*=== Trbl ===*/
                 MakeObject(mybase,PRIM_TRBL,primname,primx,primy,primfct,primfcs)
                 IF autoactive THEN ActivateWindow(mywindow)
                 sleepAll(myapp,MUI_TRUE)
                 t:=DrawBase3D(mybase,mywindow)
                 sleepAll(myapp,FALSE)
            CASE 4 /*=== Sphere ===*/
                 MakeObject(mybase,PRIM_SPHERE,primname,primx,primy,primfct,primfcs)
                 IF autoactive THEN ActivateWindow(mywindow)
                 sleepAll(myapp,MUI_TRUE)
                 t:=DrawBase3D(mybase,mywindow)
                 sleepAll(myapp,FALSE)
            CASE 5 /*=== Spirale ===*/
                 MakeObject(mybase,PRIM_SPIRALE,primname,primx,primy,primfct,primfcs)
                 IF autoactive THEN ActivateWindow(mywindow)
                 sleepAll(myapp,MUI_TRUE)
                 t:=DrawBase3D(mybase,mywindow)
                 sleepAll(myapp,FALSE)
            CASE 6 /*=== Vagues ===*/
                 MakeObject(mybase,PRIM_VAGUES,primname,primx,primy,primfct,primfcs)
                 IF autoactive THEN ActivateWindow(mywindow)
                 sleepAll(myapp,MUI_TRUE)
                 t:=DrawBase3D(mybase,mywindow)
                 sleepAll(myapp,FALSE)
            CASE 7 /*=== Cylindre ===*/
                 MakeObject(mybase,PRIM_CYLINDRE,primname,primx,primy,primfct,primfcs)
                 IF autoactive THEN ActivateWindow(mywindow)
                 sleepAll(myapp,MUI_TRUE)
                 t:=DrawBase3D(mybase,mywindow)
                 sleepAll(myapp,FALSE)
            CASE 8 /*=== ConeD ===*/
                 MakeObject(mybase,PRIM_CONED,primname,primx,primy,primfct,primfcs)
                 IF autoactive THEN ActivateWindow(mywindow)
                 sleepAll(myapp,MUI_TRUE)
                 t:=DrawBase3D(mybase,mywindow)
                 sleepAll(myapp,FALSE)
            CASE 9 /*=== Dome ===*/
                 MakeObject(mybase,PRIM_DOME,primname,primx,primy,primfct,primfcs)
                 IF autoactive THEN ActivateWindow(mywindow)
                 sleepAll(myapp,MUI_TRUE)
                 t:=DrawBase3D(mybase,mywindow)
                 sleepAll(myapp,FALSE)
            CASE 10 /*=== cube ===*/
                 PrimCube(mybase,primname,PRIMD_CUBE)
                 IF autoactive THEN ActivateWindow(mywindow)
                 sleepAll(myapp,MUI_TRUE)
                 t:=DrawBase3D(mybase,mywindow)
                 sleepAll(myapp,FALSE)
            CASE 11 /*=== tetra ===*/
                 PrimCube(mybase,primname,PRIMD_TETRA)
                 IF autoactive THEN ActivateWindow(mywindow)
                 sleepAll(myapp,MUI_TRUE)
                 t:=DrawBase3D(mybase,mywindow)
                 sleepAll(myapp,FALSE)
            CASE 12 /*=== octa ===*/
                 PrimCube(mybase,primname,PRIMD_OCTA)
                 IF autoactive THEN ActivateWindow(mywindow)
                 sleepAll(myapp,MUI_TRUE)
                 t:=DrawBase3D(mybase,mywindow)
                 sleepAll(myapp,FALSE)
            CASE 13 /*=== Dodeca ===*/
                 PrimCube(mybase,primname,PRIMD_DODECA)
                 IF autoactive THEN ActivateWindow(mywindow)
                 sleepAll(myapp,MUI_TRUE)
                 t:=DrawBase3D(mybase,mywindow)
                 sleepAll(myapp,FALSE)
            CASE 14 /*=== Icosa ===*/
                 PrimCube(mybase,primname,PRIMD_ICOSA)
                 IF autoactive THEN ActivateWindow(mywindow)
                 sleepAll(myapp,MUI_TRUE)
                 t:=DrawBase3D(mybase,mywindow)
                 sleepAll(myapp,FALSE)
            CASE 15 /*=== Octatronqué ===*/
                 PrimCube(mybase,primname,PRIMD_OCTATRONQUE)
                 IF autoactive THEN ActivateWindow(mywindow)
                 sleepAll(myapp,MUI_TRUE)
                 t:=DrawBase3D(mybase,mywindow)
                 sleepAll(myapp,FALSE)
            CASE 16 /*=== Cuboctaère ===*/
                 PrimCube(mybase,primname,PRIMD_CUBO)
                 IF autoactive THEN ActivateWindow(mywindow)
                 sleepAll(myapp,MUI_TRUE)
                 t:=DrawBase3D(mybase,mywindow)
                 sleepAll(myapp,FALSE)
            ENDSELECT
            updateMuiList(mybase.objlist,myapp.lv_objlist)
            updateObjInfo()
        ELSE
            request('Vous devez séléctionné une primitive','Ok',0,myapp.wi_3dfichier)
        ENDIF
        CASE ID_PRIMCANCEL
        CASE ID_PRIMNAME
        CASE ID_PRIMFACES
        get(myapp.cy_primfaces,MUIA_Cycle_Active,{active})
        primfcs:=active
        CASE ID_PRIMFCT3D
    ENDSELECT
    IF (signal AND running) THEN ret:=Wait(signal OR Shl(1,viewport.sigbit) OR $F000)
    IF ret=$1000
->        WriteF('break C \h\n',ret)
        running:=FALSE
    ENDIF
    IF (ret AND Shl(1,viewport.sigbit))
        WHILE resizemsg:=GetMsg(mywindow.userport)
        class:=resizemsg.class
        dx:=mywindow.leftedge
        dy:=mywindow.topedge
        dw:=mywindow.width
        dh:=mywindow.height
        IF class=IDCMP_NEWSIZE
            updateDrawingInfo()
            FormatBase3DWithWindow(mybase,mywindow)
            ClearDrawingArea(mywindow,0)
            t:=DrawBase3D(mybase,mywindow)
        ENDIF
        ReplyMsg(resizemsg)
        ENDWHILE
    ENDIF
    ENDWHILE
ENDPROC ER_NONE

-><>
->> lookArexxMessage(hk,obj,muimsg)

PROC lookArexxMessage(hk,obj,muimsg)
    DEF commande:PTR TO LONG
    DEF rexxmsg:PTR TO rexxmsg
    DEF arg1=0,arg2=0,o:PTR TO object3d,t,buffer[256]:STRING,fbuf[256]:STRING,ret=0
    DEF x1,y1,z1
    get(obj,MUIA_Application_RexxMsg,{rexxmsg})
    commande:=rexxmsg.args
    IF StrCmp(commande[0],'SAVEWHAT',8)
    arg1:=Long(Long(muimsg))
    arg2:=Long(muimsg+4)
    IF arg2
        StringF(buffer,'\d',mybase.savewhat)
    ELSE
        IF (arg1>=0) AND (arg1<=2)
        StringF(buffer,'\d',mybase.savewhat)
        mybase.savewhat:=arg1
        base3DinMui(mybase)
        ELSE
        StrCopy(buffer,'',ALL)
        ret:=20
        ENDIF
    ENDIF
    ELSEIF StrCmp(commande[0],'SAVEFORMAT',10)
    arg1:=Long(Long(muimsg))
    arg2:=Long(muimsg+4)
    IF arg2
        StringF(buffer,'\d',mybase.saveformat)
    ELSE
        IF (arg1>=0) AND (arg1<=5)
        StringF(buffer,'\d',mybase.saveformat)
        mybase.saveformat:=arg1
        base3DinMui(mybase)
        ELSE
        StrCopy(buffer,'',ALL)
        ret:=20
        ENDIF
    ENDIF
    ELSEIF StrCmp(commande[0],'SAVEBASE',8)
    arg1:=Long(muimsg)
    arg2:=mybase.saveformat
    SELECT arg2
        CASE SAVE_DXF
        t:=SaveDxfFile(mybase,arg1)
        CASE SAVE_GEO
        t:=SaveGeoFile(mybase,arg1)
        CASE SAVE_RAY
        t:=SaveRayFile(mybase,arg1)
        CASE SAVE_BIN
        t:=SaveBinFile(mybase,arg1,mybase.vectorfactor)
        CASE SAVE_POV1
        t:=SavePovFile(mybase,arg1)
        CASE SAVE_POV2
        t:=SavePovFile(mybase,arg1)
    ENDSELECT
    IF t=FALSE THEN ret:=20
    ELSEIF StrCmp(commande[0],'FCTIMAGINE',10)
    arg1:=Long(muimsg)
    arg2:=Long(muimsg+4)
    StrCopy(buffer,float2String(mybase.fctimagine),ALL)
    IF arg1
        StrCopy(fbuf,arg1,ALL);t:=string2Float(fbuf);mybase.fctimagine:=t
        set(myapp.st_fimagine,MUIA_String_Contents,arg1)
    ENDIF
    ELSEIF StrCmp(commande[0],'FCTSCULPT',7)
    arg1:=Long(muimsg)
    arg2:=Long(muimsg+4)
    StrCopy(buffer,float2String(mybase.fctsculpt),ALL)
    IF arg1
        StrCopy(fbuf,arg1,ALL);t:=string2Float(fbuf);mybase.fctsculpt:=t
        set(myapp.st_fsculpt,MUIA_String_Contents,arg1)
    ENDIF
    ELSEIF StrCmp(commande[0],'FCT3DPRO',7)
    arg1:=Long(muimsg)
    arg2:=Long(muimsg+4)
    StrCopy(buffer,float2String(mybase.fct3dpro),ALL)
    IF arg1
        StrCopy(fbuf,arg1,ALL);t:=string2Float(fbuf);mybase.fct3dpro:=t
        set(myapp.st_f3dpro,MUIA_String_Contents,arg1)
    ENDIF
    ELSEIF StrCmp(commande[0],'FCTVERTEX',7)
    arg1:=Long(muimsg)
    arg2:=Long(muimsg+4)
    StrCopy(buffer,float2String(mybase.fctvertex),ALL)
    IF arg1
        StrCopy(fbuf,arg1,ALL);t:=string2Float(fbuf);mybase.fctvertex:=t
        set(myapp.st_fvertex,MUIA_String_Contents,arg1)
    ENDIF
    ELSEIF StrCmp(commande[0],'BASE3DINFO',10)
    StringF(buffer,'\d \d \d',mybase.nbrsobjs,mybase.totalpts,mybase.totalfcs)
    ELSEIF StrCmp(commande[0],'OBJECT3DINFO',12)
    arg1:=Long(Long(muimsg))
    o:=getInfoNode(mybase.objlist,arg1,GETWITH_NUM,RETURN_ADR)
    IF o<>-1
        arg2:=mybase.formatname
        StringF(buffer,'\d \d \d \d \d \d \d \d \d \d \d \d \d \s \s',o.nbrspts,o.nbrsfcs,o.datapts,o.datafcs,o.objminx,o.objmaxx,o.objminy,o.objmaxy,o.objminz,o.objmaxz,o.objcx,o.objcy,o.objcz,o.obj_node.name,mybase.formatname[o.typeobj])
    ELSE
        StringF(buffer,'','')
        ret:=20
    ENDIF
    ELSEIF StrCmp(commande[0],'WINFILE',7)
    set(myapp.wi_3dfichier,MUIA_Window_Open,MUI_TRUE)
    ELSEIF StrCmp(commande[0],'WINVUE',6)
    set(myapp.wi_vues,MUIA_Window_Open,MUI_TRUE)
    ELSEIF StrCmp(commande[0],'WINOBJ',6)
    set(myapp.wi_objets,MUIA_Window_Open,MUI_TRUE)
    ELSEIF StrCmp(commande[0],'WINROT',6)
    set(myapp.wi_rotation,MUIA_Window_Open,MUI_TRUE)
    ELSEIF StrCmp(commande[0],'WINPREFS',6)
    set(myapp.wi_prefs,MUIA_Window_Open,MUI_TRUE)
    ELSEIF StrCmp(commande[0],'OBJPTSDATA',10)
    arg1:=Long(Long(muimsg))
    arg2:=Long(Long(muimsg+4))
    o:=getInfoNode(mybase.objlist,arg1,GETWITH_NUM,RETURN_ADR)
    IF o<>-1
        IF (arg2<=(o.nbrspts-1))
        x1:=Long(o.datapts+(arg2*12))
        y1:=Long(o.datapts+(arg2*12)+4)
        z1:=Long(o.datapts+(arg2*12)+8)
        StrCopy(fbuf,float2String(x1),ALL)
        StrAdd(buffer,fbuf,ALL);StrAdd(buffer,' ',1)
        StrCopy(fbuf,float2String(y1),ALL)
        StrAdd(buffer,fbuf,ALL);StrAdd(buffer,' ',1)
        StrCopy(fbuf,float2String(z1),ALL)
        StrAdd(buffer,fbuf,ALL);StrAdd(buffer,' ',1)
        ELSE
        StrCopy(buffer,'',ALL)
        ret:=20
        ENDIF
    ELSE
        StrCopy(buffer,'',ALL)
        ret:=20
    ENDIF
    ELSEIF StrCmp(commande[0],'OBJFCSDATA',10)
    arg1:=Long(Long(muimsg))
    arg2:=Long(Long(muimsg+4))
    o:=getInfoNode(mybase.objlist,arg1,GETWITH_NUM,RETURN_ADR)
    IF o<>-1
        IF (arg2<=(o.nbrsfcs-1))
        x1:=Long(o.datafcs+(arg2*12))
        y1:=Long(o.datafcs+(arg2*12)+4)
        z1:=Long(o.datafcs+(arg2*12)+8)
        StringF(fbuf,'\d \d \d',x1,y1,z1)
        StrCopy(buffer,fbuf,ALL)
        ELSE
        StrCopy(buffer,'',ALL)
        ret:=20
        ENDIF
    ELSE
        StrCopy(buffer,'',ALL)
        ret:=20
    ENDIF
    ELSEIF StrCmp(commande[0],'LOCKGUI',7)
    sleepAll(myapp,MUI_TRUE)
    ELSEIF StrCmp(commande[0],'UNLOCKGUI',9)
    sleepAll(myapp,FALSE)
    ELSEIF StrCmp(commande[0],'TOTALMEM',8)
    arg1:=totalMemBase3D(mybase)
    StringF(buffer,'\d',arg1)
    ELSEIF StrCmp(commande[0],'LOADBASE',7)
    arg1:=Long(muimsg)
    x1,y1:=ReadFile3D(mybase,arg1)
    SELECT x1
        CASE ERR3D_UNKNOWNFILE
        StringF(buffer,'\s non valide',arg1)
        ret:=20
        CASE ERR3D_NOFILE
        StringF(buffer,'\s inexistant',arg1)
        ret:=20
        DEFAULT
        updateMuiList(mybase.objlist,myapp.lv_objlist)
    ENDSELECT
    ELSEIF StrCmp(commande[0],'DELBASE',7)
    mybase.objlist:=cleanList(mybase.objlist,TRUE,mybase.freedata,LIST_CLEAN)
    mybase.totalpts:=0;mybase.totalfcs:=0
    updateMuiList(mybase.objlist,myapp.lv_objlist)
    ENDIF
    set(myapp.app,MUIA_Application_RexxString,buffer)
ENDPROC ret

-><>
->> totalMemBase3D(base:PTR TO base3d)

PROC totalMemBase3D(base:PTR TO base3d)
    DEF tm=0
    DEF o:PTR TO object3d,list:PTR TO lh
    tm:=SIZEOF base3d
    list:=base.objlist
    o:=list.head
    WHILE o
    IF o.obj_node.succ<>0
        tm:=tm+(SIZEOF object3d)+(o.nbrspts*12)+(o.nbrsfcs*12)
    ENDIF
    o:=o.obj_node.succ
    ENDWHILE
ENDPROC tm

-><>
->> lookArexxError(hk=NIL,obj=NIL,rexxmsg=NIL:PTR TO rexxmsg)

PROC lookArexxError(hk=NIL,obj=NIL,rexxmsg=NIL:PTR TO rexxmsg)
    DEF commande:PTR TO LONG
    commande:=rexxmsg.args
    request('Commande \s Inconnu','Ok',[commande[0]],NIL)
->    set(myapp.app,MUIA_Application_RexxString,'qwerty')
ENDPROC

-><
->> infoTextThanks(w:PTR TO window)

PROC infoTextThanks(w:PTR TO window)
    DEF oldrast
    SetTopaz(9)
    ClearDrawingArea(mywindow,1)
    SetAPen(w.rport,2)
    SetBPen(w.rport,1)
    oldrast:=SetStdRast(w.rport)
    tapText(w.rport,20,20, '»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»')
    tapText(w.rport,20,30, '» MUIMaster.library © Stefan Stuntz          »')
    tapText(w.rport,20,40, '» MUIBuilder        © Eric Totel             »')
    tapText(w.rport,20,50, '» GenCodeE          © Lionel Vintenat        »')
    tapText(w.rport,20,60, '» AmigaE            © Wouter van Oortmerssen »')
    tapText(w.rport,20,70, '» vector.library    © A. Lippert             »')
    tapText(w.rport,20,80, '» FilledVector.m    © Frank Zucchi           »')
    tapText(w.rport,20,90, '»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»')
    tapText(w.rport,20,100,'» 3DView            © NasGûl                 »')
    tapText(w.rport,20,110,'»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»')
    tapText(w.rport,20,130,'(Ce message disparaitra lors de la copie des prefs)')
    Delay(50)
    SetStdRast(oldrast)
    Execute('3DView.message',0,stdout)
ENDPROC

-><
->> tapText(rast,x,y,text)

PROC tapText(rast,x,y,text)
    DEF len,b,pas=0,str[10]:STRING
    len:=StrLen(text)
    FOR b:=0 TO len-1
    StringF(str,'\c',text[b])
    Move(rast,x+pas,y)
    Text(rast,str,1)
    pas:=pas+9
    Delay(2)
    ENDFOR
ENDPROC

-><
->> base3DinMui(b:PTR TO base3d)

PROC base3DinMui(b:PTR TO base3d)
    DEF buffer[80]:STRING

    StrCopy(buffer,float2String(b.vectorfactor),ALL)
    set(myapp.st_vfactor,MUIA_String_Contents,buffer)

    set(myapp.cy_planvue,MUIA_Cycle_Active,b.plan)
    set(myapp.cy_modevue,MUIA_Cycle_Active,b.drawmode)
    set(myapp.cy_savewhat,MUIA_Cycle_Active,b.savewhat)
    set(myapp.cy_saveformat,MUIA_Cycle_Active,b.saveformat)

    IF autoactive
    SetAttrsA(myapp.ch_autoactive,[MUIA_NoNotify,TRUE,MUIA_Selected,autoactive,TAG_DONE])
    SetAttrsA(myapp.ch_autoactive,[MUIA_NoNotify,FALSE,TAG_DONE])
    ENDIF
->  set(myapp.ch_autoactive,MUIA_Selected,autoactive)
ENDPROC

-><
->> updateDrawingInfo()

PROC updateDrawingInfo()
    DEF buffer[80]:STRING
    StringF(buffer,'\d',dx)
    set(myapp.st_drawingwinx,MUIA_String_Contents,buffer)
    StringF(buffer,'\d',dy)
    set(myapp.st_drawingwiny,MUIA_String_Contents,buffer)
    StringF(buffer,'\d',dw)
    set(myapp.st_drawingwinw,MUIA_String_Contents,buffer)
    StringF(buffer,'\d',dh)
    set(myapp.st_drawingwinh,MUIA_String_Contents,buffer)
ENDPROC

-><
->> updateObjInfo()

PROC updateObjInfo()
    DEF active
    DEF buffer[256]:STRING
    DEF obj:PTR TO object3d,name:PTR TO LONG
    get(myapp.lv_objlist,MUIA_List_Active,{active})
    name:=mybase.formatname
    IF active<>-1
    obj:=getInfoNode(mybase.objlist,active,GETWITH_NUM,RETURN_ADR)
    IF obj<>-1
        /*=== type ob obj ===*/
        StringF(buffer,'\s',name[obj.typeobj])
        set(myapp.tx_typeobj,MUIA_Text_Contents,buffer)
        /*=== nbrs de pts ===*/
        StringF(buffer,'\d',obj.nbrspts)
        set(myapp.tx_nbrspts,MUIA_Text_Contents,buffer)
        /*=== nbrs fcs===*/
        StringF(buffer,'\d',obj.nbrsfcs)
        set(myapp.tx_nbrsfcs,MUIA_Text_Contents,buffer)
        /*=== obj minx ===*/
        StrCopy(buffer,float2String(obj.objminx),ALL)
        set(myapp.tx_minx,MUIA_Text_Contents,buffer)
        /*=== obj maxx ===*/
        StrCopy(buffer,float2String(obj.objmaxx),ALL)
        set(myapp.tx_maxx,MUIA_Text_Contents,buffer)
        /*=== obj miny ===*/
        StrCopy(buffer,float2String(obj.objminy),ALL)
        set(myapp.tx_miny,MUIA_Text_Contents,buffer)
        /*=== obj maxy ===*/
        StrCopy(buffer,float2String(obj.objmaxy),ALL)
        set(myapp.tx_maxy,MUIA_Text_Contents,buffer)
        /*=== obj minz ===*/
        StrCopy(buffer,float2String(obj.objminz),ALL)
        set(myapp.tx_minz,MUIA_Text_Contents,buffer)
        /*=== obj maxz ===*/
        StrCopy(buffer,float2String(obj.objmaxz),ALL)
        set(myapp.tx_maxz,MUIA_Text_Contents,buffer)
        /*===obj centre x ===*/
        StrCopy(buffer,float2String(obj.objcx),ALL)
        set(myapp.tx_centrex,MUIA_Text_Contents,buffer)
        /*=== obj centre y ===*/
        StrCopy(buffer,float2String(obj.objcy),ALL)
        set(myapp.tx_centrey,MUIA_Text_Contents,buffer)
        /*=== obj centre z ===*/
        StrCopy(buffer,float2String(obj.objcz),ALL)
        set(myapp.tx_centrez,MUIA_Text_Contents,buffer)
        IF obj.selected=TRUE THEN set(myapp.ra_objetact,MUIA_Radio_Active,1)
        IF obj.bounded=TRUE THEN set(myapp.ra_objetact,MUIA_Radio_Active,2)
        IF (obj.selected=FALSE) AND (obj.bounded=FALSE) THEN set(myapp.ra_objetact,MUIA_Radio_Active,0)
    ENDIF
    ELSE
    /*=== type ob obj ===*/
    set(myapp.tx_typeobj,MUIA_Text_Contents,'Aucun')
    /*=== nbrs de pts ===*/
    set(myapp.tx_nbrspts,MUIA_Text_Contents,'0000')
    /*=== nbrs fcs===*/
    set(myapp.tx_nbrsfcs,MUIA_Text_Contents,'0000')
    /*=== obj minx ===*/
    set(myapp.tx_minx,MUIA_Text_Contents,'0000.0000')
    /*=== obj maxx ===*/
    set(myapp.tx_maxx,MUIA_Text_Contents,'0000.0000')
    /*=== obj miny ===*/
    set(myapp.tx_miny,MUIA_Text_Contents,'0000.0000')
    /*=== obj maxy ===*/
    set(myapp.tx_maxy,MUIA_Text_Contents,'0000.0000')
    /*=== obj minz ===*/
    set(myapp.tx_minz,MUIA_Text_Contents,'0000.0000')
    /*=== obj maxz ===*/
    set(myapp.tx_maxz,MUIA_Text_Contents,'0000.0000')
    /*===obj centre x ===*/
    set(myapp.tx_centrex,MUIA_Text_Contents,'0000.0000')
    /*=== obj centre y ===*/
    set(myapp.tx_centrey,MUIA_Text_Contents,'0000.0000')
    /*=== obj centre z ===*/
    set(myapp.tx_centrez,MUIA_Text_Contents,'0000.0000')
    ENDIF
    StringF(buffer,'\d',mybase.totalpts)
    set(myapp.tx_totalpts,MUIA_Text_Contents,buffer)
    StringF(buffer,'\d',mybase.totalfcs)
    set(myapp.tx_totalfcs,MUIA_Text_Contents,buffer)
    StringF(buffer,'\d',mybase.nbrsobjs)
    set(myapp.tx_totalobj,MUIA_Text_Contents,buffer)
ENDPROC

-><
->> updateMuiList(execlist:PTR TO lh,muilist)

PROC updateMuiList(execlist:PTR TO lh,muilist)
    DEF n:PTR TO ln,nom
    n:=execlist.head
    domethod(muilist,[MUIM_List_Clear])
    set(muilist,MUIA_List_Quiet,MUI_TRUE)
    WHILE n
    IF n.succ<>0
        nom:=n.name
        domethod(muilist,[MUIM_List_Insert,{nom},1,MUIV_List_Insert_Bottom])
    ENDIF
    n:=n.succ
    ENDWHILE
    set(muilist,MUIA_List_Quiet,FALSE)
ENDPROC

-><
->> openLibraries() HANDLE

PROC openLibraries() HANDLE
    IF (muimasterbase:=OpenLibrary('muimaster.library',9))=NIL THEN Raise(ER_LIBMUIMASTER)
->    IF xpkbase:=OpenLibrary('xpkmaster.library',1) ELSE xpkbase:=NIL
->    IF (workbenchbase:=OpenLibrary('workbench.library',0))=NIL THEN Raise(ER_LIBWORKBENCH)
->    IF (iffbase:=OpenLibrary('iff.library',0))=NIL THEN Raise(ER_LIBIFF)
    IF (reqtoolsbase:=OpenLibrary('reqtools.library',0))=NIL THEN Raise(ER_LIBREQTOOLS)
->    IF (rexxsysbase:=OpenLibrary('rexxsyslib.library',0))=NIL THEN Raise(ER_LIBREXXSYSLIB)
    IF (mathbase:=OpenLibrary('mathffp.library',34))=NIL THEN Raise(ER_LIBMATH)
    IF (mathtransbase:=OpenLibrary('mathtrans.library',34))=NIL THEN Raise(ER_LIBMATH)
    IF (mathieeesingbasbase:=OpenLibrary('mathieeesingbas.library',34))=NIL THEN Raise(ER_LIBMATH)
    IF (mathieeesingtransbase:=OpenLibrary('mathieeesingtrans.library',34))=NIL THEN Raise(ER_LIBMATH)
    IF (utilitybase:=OpenLibrary('utility.library',37))=NIL THEN Raise(ER_LIBUTILITY)
    IF (dddbase:=OpenLibrary('ddd.library',0))=NIL THEN Raise(ER_LIBDDD)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC

-><
->> closeLibraries()

PROC closeLibraries()
    IF dddbase THEN CloseLibrary(dddbase)
    IF utilitybase THEN CloseLibrary(utilitybase)
    IF mathieeesingtransbase THEN CloseLibrary(mathieeesingtransbase)
    IF mathieeesingbasbase THEN CloseLibrary(mathieeesingbasbase)
    IF mathtransbase THEN CloseLibrary(mathtransbase)
    IF mathbase THEN CloseLibrary(mathbase)
->    IF rexxsysbase THEN CloseLibrary(rexxsysbase)
    IF reqtoolsbase THEN CloseLibrary(reqtoolsbase)
->    IF iffbase THEN CloseLibrary(iffbase)
->    IF workbenchbase THEN CloseLibrary(workbenchbase)
->    IF iconbase THEN CloseLibrary(iconbase)
->    IF xpkbase THEN CloseLibrary(xpkbase)
    IF muimasterbase THEN CloseLibrary(muimasterbase)
ENDPROC

-><
->> initAPP() HANDLE

PROC initAPP() HANDLE
    DEF n:PTR TO ln
    mybase:=Init3DBase()
    IF mybase=NIL THEN Raise(ER_NOBASE3D)
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC

-><
->> openDrawingWindow(screen)

PROC openDrawingWindow(screen)
    DEF w:PTR TO window
   w:=OpenWindowTagList(NIL,[ WA_TOP,       dy,
                    WA_LEFT,        dx,
                    WA_INNERWIDTH,  dw,
                    WA_INNERHEIGHT, dh,
                    WA_CLOSEGADGET, TRUE,
                    WA_DRAGBAR,     TRUE,
                    WA_DEPTHGADGET, TRUE,
                    WA_SIZEBBOTTOM, TRUE, /* toggle this */
                    WA_SIZEGADGET,  TRUE,
                    WA_MINHEIGHT,   100,
                    WA_MINWIDTH,    50,
                    WA_MAXHEIGHT,   -1,
                    WA_MAXWIDTH,    -1,
                    WA_CUSTOMSCREEN,screen,
                    WA_IDCMP,       IDCMP_CLOSEWINDOW OR
                            IDCMP_CHANGEWINDOW OR IDCMP_RAWKEY OR
                            IDCMP_NEWSIZE,
                    WA_TITLE,       '3DView (Représentation)',
                    0,0]) /* NB: no checking here either :<*/
ENDPROC w

-><
->> closeDrawingWindow(win)

PROC closeDrawingWindow(win)
    IF win<>NIL THEN CloseWindow(win)
    win:=NIL
ENDPROC win

-><
->> remAPP()

PROC remAPP()
    IF mywindow<>NIL THEN closeDrawingWindow(mywindow)
    IF mybase<>NIL THEN Rem3DBase(mybase)
ENDPROC

-><
->> fileRequester(titre:PTR TO CHAR,muiwindow)

PROC fileRequester(titre:PTR TO CHAR,muiwindow)
/*===============================================================================
 = Para     : NONE
 = Return   : False if cancel selected.
 = Description  : PopUp a MultiFileRequester,build the whatview arguments.
 ==============================================================================*/
    DEF reqfile:PTR TO rtfilerequester
    DEF liste:PTR TO rtfilelist
    DEF buffer[120]:STRING,w:PTR TO window
    DEF add_liste=0
    DEF ret=FALSE
    DEF the_reelname[256]:STRING
    DEF defaultdir[256]:STRING
    DEF valide,format
    get(muiwindow,MUIA_Window_Window,{w})
    reqfile:=NIL
    IF reqfile:=RtAllocRequestA(RT_FILEREQ,NIL)
    buffer[0]:=0
    add_liste:=RtFileRequestA(reqfile,buffer,titre,
                  [RT_WINDOW,w,RTFI_FLAGS,FREQF_MULTISELECT+FREQF_PATGAD,RTFI_HEIGHT,200,
                   RT_UNDERSCORE,"_",TAG_DONE])
    StrCopy(defaultdir,reqfile.dir,ALL)
    AddPart(defaultdir,'',256)
    IF reqfile THEN RtFreeRequest(reqfile)
    IF add_liste THEN ret:=TRUE
    ELSE
    ret:=FALSE
    ENDIF
    IF ret=TRUE
    liste:=add_liste
    IF add_liste
        WHILE liste
        StringF(the_reelname,'\s\s',defaultdir,liste.name)
        valide,format:=ReadFile3D(mybase,the_reelname)
        IF valide=ERR3D_UNKNOWNFILE
            request('Fichier \s inconnu','Ok',[the_reelname],muiwindow)
        ENDIF
        liste:=liste.next
        ENDWHILE
        IF add_liste THEN RtFreeFileList(add_liste)
    ENDIF
    ELSE
    ret:=FALSE
    ENDIF
    RETURN ret
ENDPROC

-><
->> fileSaveRequester(titre:PTR TO CHAR,muiwindow)

PROC fileSaveRequester(titre:PTR TO CHAR,muiwindow)
/*===============================================================================
 = Para     : NONE
 = Return   : False if cancel selected.
 = Description  : PopUp a MultiFileRequester,build the whatview arguments.
 ==============================================================================*/
    DEF reqfile:PTR TO rtfilerequester
    DEF buffer[120]:STRING,w:PTR TO window
    DEF add_liste=0
    DEF ret=FALSE
    DEF defaultdir[256]:STRING
    DEF format
    get(muiwindow,MUIA_Window_Window,{w})
    reqfile:=NIL
    IF reqfile:=RtAllocRequestA(RT_FILEREQ,NIL)
    buffer[0]:=0
    add_liste:=RtFileRequestA(reqfile,buffer,titre,
                  [RT_WINDOW,w,RTFI_FLAGS,FREQF_NOFILES+FREQF_SAVE,RTFI_HEIGHT,200,
                   RT_UNDERSCORE,"_",TAG_DONE])
    StrCopy(defaultdir,reqfile.dir,ALL)
    AddPart(defaultdir,'',256)
    IF reqfile THEN RtFreeRequest(reqfile)
    IF add_liste THEN ret:=TRUE
    ELSE
    ret:=FALSE
    ENDIF
    IF ret=TRUE
    format:=mybase.saveformat
    SELECT format
        CASE SAVE_DXF;  SaveDxfFile(mybase,defaultdir)
        CASE SAVE_GEO;  SaveGeoFile(mybase,defaultdir)
        CASE SAVE_RAY;  SaveRayFile(mybase,defaultdir)
        CASE SAVE_BIN;  SaveBinFile(mybase,defaultdir,mybase.vectorfactor)
        CASE SAVE_POV1; SavePovFile(mybase,defaultdir)
        CASE SAVE_POV2; SavePovFile(mybase,defaultdir)
    ENDSELECT
    ELSE
    ret:=FALSE
    ENDIF
    RETURN ret
ENDPROC

-><
->> request(bodytext,gadgettext,the_arg,muiwindow)

PROC request(bodytext,gadgettext,the_arg,muiwindow)
    DEF ret
    DEF w:PTR TO window
    get(muiwindow,MUIA_Window_Window,{w})
    IF muiwindow<>NIL
    IF w
        ret:=RtEZRequestA(bodytext,gadgettext,0,the_arg,[RT_WINDOW,w,TAG_DONE])
    ENDIF
    ELSE
    ret:=RtEZRequestA(bodytext,gadgettext,0,the_arg,[TAG_DONE])
    ENDIF
    RETURN ret
ENDPROC

-><
->> float2String(float)

PROC float2String(float)
    DEF r[80]:STRING
    StringF(r,'\d.\z\d[4] ',IeeeSPFix(float),IeeeSPFix(IeeeSPAbs(IeeeSPMul(IeeeSPSub(IeeeSPFlt(IeeeSPFix(float)),float ),10000.0))))
    RETURN r
ENDPROC

-><
->> string2Float(string)

PROC string2Float(string)
    DEF entier[256]:STRING
    DEF decimal[256]:STRING
    DEF pos
    DEF ei,di,ef,df,vir,p,res=0,ret
    #ifdef DBP
    WriteF('stringToFloat()\n')
    #endif
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
    ret:=SpTieee(res)
    RETURN ret
    ENDIF
ENDPROC

-><
->> readPrefsFile()

PROC readPrefsFile()
    DEF h,buffer,t,ret=FALSE
    IF h:=Open('Env:3DView.Prefs',1005)
    IF buffer:=New(36)
        t:=Read(h,buffer,36)
        dx:=Long(buffer)
        dy:=Long(buffer+4)
        dw:=Long(buffer+8)
        dh:=Long(buffer+12)
        mybase.rgbpts:=Int(buffer+18)
        mybase.rgbnormal:=Int(buffer+22)
        mybase.rgbselect:=Int(buffer+26)
        mybase.rgbbounding:=Int(buffer+30)
        autoactive:=Long(buffer+32)
        updateDrawingInfo()
        Dispose(buffer)
    ENDIF
    Close(h)
    ELSE
    dx:=0
    dy:=0
    dw:=640
    dh:=128
    ret:=TRUE
    ENDIF
ENDPROC ret

-><
->> savePrefsFile()

PROC savePrefsFile()
    DEF h,t
    IF h:=Open('Env:3DView.Prefs',1006)
    t:=Write(h,[dx,dy,dw,dh,mybase.rgbpts,mybase.rgbnormal,mybase.rgbselect,mybase.rgbbounding,autoactive]:LONG,36)
    IF t<>36
        WriteF('Erreur\n')
    ENDIF
    Close(h)
    ENDIF
ENDPROC

-><
->> paletteRequest(titre,couleur)

PROC paletteRequest(titre,couleur)
    DEF win:PTR TO window,ret
    get(myapp.wi_prefs,MUIA_Window_Window,{win})
    sleepAll(myapp,MUI_TRUE)
    ret:=RtPaletteRequestA(titre,NIL,[RT_WINDOW,win,RT_LOCKWINDOW,TRUE,RTPA_COLOR,couleur,0])
    sleepAll(myapp,FALSE)
    RETURN ret
ENDPROC

-><
->> sleepAll(theapp:PTR TO app_obj,v)

PROC sleepAll(theapp:PTR TO app_obj,v)
    set(theapp.wi_3dmain,MUIA_Window_Sleep,v)
    set(theapp.wi_3dfichier,MUIA_Window_Sleep,v)
    set(theapp.wi_config,MUIA_Window_Sleep,v)
    set(theapp.wi_vues,MUIA_Window_Sleep,v)
    set(theapp.wi_rotation,MUIA_Window_Sleep,v)
    set(theapp.wi_objets,MUIA_Window_Sleep,v)
    set(theapp.wi_primcal,MUIA_Window_Sleep,v)
    set(theapp.wi_prefs,MUIA_Window_Sleep,v)
    set(theapp.wi_vector,MUIA_Window_Sleep,v)
ENDPROC

-><
->> wF(float)
PROC wF(float)
    WriteF('\d.\z\d[4] ',IeeeSPFix(float),IeeeSPFix(IeeeSPAbs(IeeeSPMul(IeeeSPSub(IeeeSPFlt(IeeeSPFix(float)),float ),10000.0))))
ENDPROC

-><
->> startWB() HANDLE

PROC startWB() HANDLE
    DEF wb:PTR TO wbstartup
    DEF args:PTR TO wbarg
    DEF b
    DEF mes:PTR TO mn,n:PTR TO ln
    DEF source[256]:STRING
    DEF fichier[256]:STRING
    DEF valide,format
    wb:=wbmessage
    mes:=wb.message
    n:=mes.ln
    args:=wb.arglist
    CurrentDir(args[0].lock)
    WHILE n
    IF n.succ<>0
        wb:=n
        FOR b:=1 TO wb.numargs-1
        NameFromLock(args[b].lock,source,256)
        AddPart(source,'',256)
        StringF(fichier,'\s\s',source,args[b].name)
        valide,format:=ReadFile3D(mybase,fichier)
        IF Not(valide)
            request('Fichier \s inconnu','Ok',[fichier],NIL)
        ENDIF
        ENDFOR
    ENDIF
    n:=n.succ
    ENDWHILE
    Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC

-><
->> startCLI() HANDLE

PROC startCLI() HANDLE
    DEF myargs:PTR TO LONG,rdargs=NIL
    DEF marg:PTR TO LONG,b=20
    DEF n[256]:STRING,valide,format
    myargs:=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    IF rdargs:=ReadArgs('FILES/M',myargs,NIL)
    marg:=myargs[]
    IF myargs[0]
        FOR b:=0 TO 19
        IF marg[b]<>0
            IF b=0 THEN StrCopy(n,Long(myargs[0]),ALL) ELSE StrCopy(n,marg[b],ALL)
             IF ((FileLength(n)<>-1) AND (EstrLen(n)<>0))
            valide,format:=ReadFile3D(mybase,n)
            IF Not(valide) THEN WriteF('Fichier \s inconnu\n',n)
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

-><
