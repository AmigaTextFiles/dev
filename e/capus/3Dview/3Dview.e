/********************************************************************************
 * << AUTO HEADER XDME >>
 ********************************************************************************
 ED             "EDG"
 EC             "EC -e"
 PREPRO         "EPP -t"
 SOURCE         "3Dview.e"
 EPPDEST        "3Dview_EPP.e"
 EXEC           "3DView"
 ISOURCE        "3Dview.i"
 HSOURCE        " "
 ERROREC        " "
 ERROREPP       " "
 VERSION        "0"
 REVISION       "6"
 NAMEPRG        "3DView"
 NAMEAUTHOR     "NasGûl"
 ********************************************************************************
 * HISTORY :
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
 *******************************************************************************/
OPT LARGE
ENUM ER_NONE,ER_INCONNU,ER_NOFICHIER,ER_NOMEM,ER_OPEN,OK_FICHIER,
     ER_INTUITIONLIB,ER_GADTOOLSLIB,ER_GFXLIB,ER_REQTOOLSLIB,
     ER_SIG,ER_WINDOW,ER_SCREEN,ER_LOCKSCREEN,ER_VISUAL,ER_CONTEXT,ER_GADGET,
     ER_BADARGS,ER_ICONLIB,ER_MATHTRANSLIB
RAISE ER_NOMEM IF New()=NIL
MODULE 'intuition/intuition'
MODULE 'gadtools','libraries/gadtools'
MODULE 'reqtools','libraries/reqtools'
MODULE 'icon','workbench/workbench'
MODULE 'mathtrans'
MODULE 'intuition/gadgetclass','intuition/screens','graphics/text','graphics/displayinfo'
MODULE 'exec/lists','exec/nodes','utility/tagitem','dos/dosextens','workbench/startup','exec/ports'
MODULE '3Dview','MHeader'
/* DEFINITION GENERALES (fenêtre de vue)*/
DEF view_screen:PTR TO screen,
    view_window:PTR TO window,
    view_type,view_infos,
    sig=-1,type_scr
/* DEFINITIONS GENERALES (fenêtre info) */
    DEF wininfo_visual=NIL,
        wininfo_window:PTR TO window,
        wininfo_glist=NIL,
        wininfo_type,wininfo_infos
    /** GADGETLABELS **/
    DEF g_num,g_nbrspts,g_nbrsfaces,g_datafaces,g_datapts,g_objcx,g_objcy,g_objcz,g_objminx,g_objmaxx,g_objminy,g_objmaxy,g_objminz,g_objmaxz,g_listobj,g_objselected,g_objtype,g_objbounded
    DEF texte,g
    DEF data_objtype[20]:LIST
    /***************************/
    DEF wininfo_mes:PTR TO intuimessage
    DEF wininfo_g:PTR TO gadget
    /**************************/
    DEF wintattr
DEF fichier_source[256]:STRING
DEF my_database:PTR TO database3d,list_obj[500]:LIST
DEF minx=NIL,maxx=NIL,miny=NIL,maxy=NIL,minz=NIL,maxz=NIL,echelle=0.1,plan=PLAN_XOY
DEF base_cx=NIL,base_cy=NIL,base_cz=NIL,signe_x=1,signe_y=1,signe_z=1,angle_rotation=10.0
DEF format=NIL,centre_x=NIL,centre_y=NIL
DEF tattr
DEF base_lock,task
DEF palette[4]:ARRAY OF INT
DEF default_dir[256]:STRING
DEF new_liste:PTR TO lh
DEF data_boundedbox[36]:LIST
DEF viewwindow_sig
PMODULE '3D_InitRemApp'
PMODULE '3D_AllRequester'
PMODULE '3D_InfoWindow'
PMODULE '3D_InOutObj'
PMODULE '3D_ActionBase'
PMODULE '3D_ViewWindow'
PMODULE 'Pmodules:Plist'
PROC main() HANDLE /*"main()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : NONE
 * Description  : Main Proc.
 *******************************************************************************/
    DEF test_main
    tattr:=['topaz.font',9,0,0]:textattr
    wintattr:=['topaz.font',8,0,0]:textattr
    data_objtype:=['Imagine','Cyber v1.0','Cyber v2.0','Sculpt',
                   'Vertex < v 1.62a','Vertex > v 1.73.f','3Dpro','LightWave']
    data_boundedbox:=[0,2,1,0,3,2,3,6,2,3,7,6,7,5,6,7,4,5,4,0,1,4,1,5,1,2,6,1,6,5,4,7,3,4,3,0]
    do_ReadHeader({prg_banner})
    StrCopy(fichier_source,arg,ALL)
    new_liste:=New(SIZEOF lh)
    new_liste.tail:=0
    new_liste.head:=new_liste.tail
    new_liste.tailpred:=new_liste.head
    new_liste.type:=0
    new_liste.pad:=0
    my_database:=New(SIZEOF database3d)
    my_database.nbrsobjs:=0
    my_database.totalpts:=0
    my_database.totalfaces:=0
    my_database.firstobj:=list_obj[0]
    task:=FindTask(0)
    IF (test_main:=open_lib())<>ER_NONE THEN Raise(test_main)
    IF wbmessage<>NIL
        IF (test_main:=start_from_wb())<>ER_NONE THEN Raise(test_main)
    ELSE
        IF (test_main:=start_from_cli())<>ER_NONE THEN Raise(test_main)
    ENDIF
    IF (test_main:=readfile())<>OK_FICHIER THEN Raise(test_main)
    IF (test_main:=open_interface())<>ER_NONE THEN Raise(test_main)
    rebuildminmax()
    draw_base()
    REPEAT
        wait4message()
    UNTIL view_type=IDCMP_CLOSEWINDOW
    Raise(ER_NONE)
EXCEPT
    CurrentDir(base_lock)
    cleanupbase()
    IF new_liste THEN Dispose(new_liste)
    IF tattr THEN Dispose(tattr)
    IF wintattr THEN Dispose(wintattr)
    IF data_objtype THEN Dispose(data_objtype)
    IF data_boundedbox THEN Dispose(data_boundedbox)
    close_interface()
    close_lib()
    SELECT exception
        CASE ER_INCONNU;   WriteF('type de fichier inconnu.\n')
        CASE ER_NOFICHIER; WriteF('le fichier \s est introuvable.\n')
        CASE ER_NOMEM;     WriteF('Pas assez de mémoire.\n')
        CASE ER_OPEN;      WriteF('Impossible d\aouvrir le fichier.\n')
        CASE ER_INTUITIONLIB; WriteF('Intuition.library ?\n')
        CASE ER_GADTOOLSLIB;  WriteF('GadTools.library ?\n')
        CASE ER_ICONLIB;      WriteF('Icon.library ?\n')
        CASE ER_GFXLIB;       WriteF('Graphics.library ?\n')
        CASE ER_REQTOOLSLIB;  WriteF('ReqTools.library ?\n')
        CASE ER_MATHTRANSLIB; WriteF('MathTrans.library ?\n')
        CASE ER_SIG;          WriteF('Erreur Signal.\n')
        CASE ER_SCREEN;       WriteF('Erreur Screen.\n')
        CASE ER_WINDOW;       WriteF('Erreur Window.\n')
        CASE ER_BADARGS;      WriteF('Mauvais Arguments.\n')
        DEFAULT;              NOP
    ENDSELECT
ENDPROC
prg_banner:
INCBIN '3Dview.header'



