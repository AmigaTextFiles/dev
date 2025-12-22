/********************************************************************************
 * << AUTO HEADER XDME >>
 ********************************************************************************
 ED           "EDG"
 EC           "EC"
 PREPRO       "EPP"
 SOURCE       "TM_AutoDock.e"
 EPPDEST      "TM_AutoDock_EPP.e"
 EXEC         "TM_AutoDock"
 ISOURCE      "ToolManager.i"
 HSOURCE      " "
 ERROREC      " "
 ERROREPP     " "
 VERSION      "0"
 REVISION     "0"
 NAMEPRG      "TM_AutoDock"
 NAMEAUTHOR   "NasGûl"
 ********************************************************************************
 * HISTORY :
 *******************************************************************************/
 OPT OSVERSION=37
/* Object personnel pour le gestion du Dock */
OBJECT toolmini
    obj_dock_exec:LONG
    obj_dock_image:LONG
    obj_dock_sound:LONG
ENDOBJECT
/* tags de la whatis */
CONST WI_FIB=$800000CA,WI_DEEP=$800000CB,WI_BUFFER=$800000CC,WI_BUFLEN=$800000CD
CONST WI_DLX=$800000CE,WI_DLT=$800000CF,WBF_UPDATEFILETYPE=$01

MODULE 'toolmanager','whatis','utility/tagitem','utility/hooks','dos/dos',
       'dos/dosasl','utility','graphics/text','intuition/intuition',
       'commodities','libraries/commodities','exec/ports','icon',
       'asl','libraries/asl','gadtools','libraries/gadtools',
       'libraries/toolmanager','tmhandle','exec/nodes','exec/lists'

ENUM ARG_DIR,ARG_COL,ARG_HOTKEY,ARG_ICON,ARG_POPUP,ARG_ARG,NUMARGS

ENUM ER_NONE,ER_BADARGS,ER_WHATISLIB,ER_TMHANDLE,ER_TMLIB,ER_ALLOCHANDLE,ER_MEM,ER_OBJEXEC,
     ER_CREATEDOCK,ER_DIRONLY,ER_NOEXEC,ER_OBJIMAGE,ER_CXLIB,ER_CREATEPORT,ER_BROKER,
     ER_CXFOBJ,ER_CXSOBJ,ER_CXTOBJ,ER_CXERROR,ER_ICONLIB,ER_INTUILIB,ER_GADTOOLSLIB

RAISE ER_MEM IF New()=NIL,
      ER_MEM IF String()=NIL

DEF debug=FALSE                             /* variable pour le debugprint */
DEF dossier[256]:STRING,col                 /* dossier,nbrs de colonnes  passé en arg */
DEF hotkey[20]:STRING                       /* hotkey passé en arg */
DEF flag_icon=FALSE                         /* icône passé en arg */
DEF flag_popup=FALSE                        /* popup passé en arg */
DEF flag_arg=FALSE                          /* argument pour les object Exec */
DEF list_tagic[1000]:LIST                   /* list des tags du dock */
DEF handle:PTR TO tmhandle                  /* handle toolmanager */
DEF num_icon[1000]:ARRAY OF LONG            /* stockage du nom des objects Icon et Exec pour TM */
DEF num_exec[1000]:ARRAY OF LONG            /* stockage de la commade exec de l'object Exec */
DEF cxmybroker:PTR TO newbroker             /* CxObject de la commoditie */
DEF cxmsgport:PTR TO mp                     /* Port de message */
DEF cxfilterobj       /*:PTR TO newbroker*/
DEF cxsenderobj       /*:PTR TO newbroker*/  /** LOOK THE HORRIBLE open_libraries() proc. **/
DEF cxtranslateobj    /*:PTR TO newbroker*/
DEF mynewbroker:PTR TO newbroker
PROC main() HANDLE /*"main()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : NONE
 * Description  : Main Proc.
 *******************************************************************************/
    DEF args[NUMARGS]:LIST,templ,x,rdargs=NIL   /* Lecture Argument cli */
    DEF test_main                               /* Variable de test     */
    DEF id,res,reel_quit=FALSE,active=TRUE
    VOID {prg_banner}
    /* On ouvre les libraries */
    IF (test_main:=open_libraries())<>ER_NONE THEN Raise(test_main)
    /* Lecture des arguments CLI */
    FOR x:=0 TO NUMARGS-1 DO args[x]:=0
    templ:='DOSSIER,COL/K/N,HK=HOTKEY/K,ICON/S,POPUP/S,ARG/S'
    rdargs:=ReadArgs(templ,args,NIL)
    IF rdargs=NIL THEN Raise(ER_BADARGS)                       /* Erreur Argument */
    /* Initialisation des variables d'arguments */
    IF args[ARG_DIR] THEN StrCopy(dossier,args[ARG_DIR],ALL)
    IF args[ARG_HOTKEY] THEN StrCopy(hotkey,args[ARG_HOTKEY],ALL) ELSE hotkey:=NIL
    IF args[ARG_COL] THEN col:=Long(args[ARG_COL]) ELSE col:=1
    IF args[ARG_ICON] THEN flag_icon:=TRUE ELSE flag_icon:=FALSE
    IF args[ARG_POPUP] THEN flag_popup:=TRUE ELSE flag_popup:=FALSE
    IF args[ARG_ARG] THEN flag_arg:=TRUE ELSE flag_arg:=FALSE
    IF debug THEN WriteF('\s \d \s \d \d\n',dossier,col,hotkey,flag_icon,flag_popup)
    /* On reserve un handle de TM */
    IF (handle:=AllocTMHandle())=NIL THEN Raise(ER_ALLOCHANDLE)
    /* On initilise l'objet Dock de TM (stocké dans une liste) */
    ListCopy(list_tagic,[TMOP_ACTIVATED,TRUE,
                         TMOP_CENTERED,TRUE,
                         TMOP_FRONTMOST,TRUE,
                         TMOP_VERTICAL,FALSE,
                         TMOP_COLUMNS,col,
                         TMOP_TEXT,Not(flag_icon),
                         TMOP_HOTKEY,hotkey,
                         TMOP_MENU,FALSE,
                         TMOP_POPUP,flag_popup,
                         TMOP_TOFRONT,active,
                         TMOP_FONT,['topaz.font',8,0,0]:textattr,
                         TMOP_TITLE,dossier],ALL)
    /* On regarde dans le dossier et on construit le Dock */
    IF (test_main:=read_dossier())<>ER_NONE THEN Raise(test_main)
    /* On crée le Dock */
    IF (test_main:=CreateTMObjectTagList(handle,'b',TMOBJTYPE_DOCK,list_tagic))=NIL THEN Raise(ER_CREATEDOCK)
    p_WriteFList(handle.lobjexec)
    REPEAT
        IF res:=GetMsg(cxmsgport)
            id:=CxMsgID(res)
            SELECT id
                CASE $13
                    EasyRequestArgs(0,[20,0,0,'  <<<< TM-AutoDock v0.0 © 1994 NasGûl >>>>  \n'+
                                              '                                            \n'+
                                              'ToolManager.library © Stefan Becker.        \n'+
                                              'WhatIs.library      © S. Rougier/P. Carette.\n'+
                                              'Amiga_E             © W.V Oortmerssen.','Merci'],0,NIL)

                CASE $17; reel_quit:=TRUE
                DEFAULT; NOP
            ENDSELECT
            ReplyMsg(res)
        ELSE
            WaitPort(cxmsgport)
        ENDIF
    UNTIL reel_quit=TRUE
    Raise(ER_NONE)
EXCEPT
    IF rdargs THEN FreeArgs(rdargs)
    IF cxmybroker THEN DeleteCxObjAll(cxmybroker)
    IF cxmsgport
        WHILE res:=GetMsg(cxmsgport) DO ReplyMsg(res)
        DeleteMsgPort(cxmsgport)
    ENDIF
    IF whatisbase THEN CloseLibrary(whatisbase)
    IF toolmanagerbase THEN CloseLibrary(toolmanagerbase)
    IF cxbase THEN CloseLibrary(cxbase)
    IF iconbase THEN CloseLibrary(iconbase)
    IF intuitionbase THEN CloseLibrary(intuitionbase)
    IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
    IF handle THEN FreeTMHandle(handle)
    SELECT exception
        CASE ER_BADARGS;     WriteF('Mauvais Argument.\n>TM_AutoDock <dossier>\n')
        CASE ER_WHATISLIB;   WriteF('Whatis.library v3 ??\n')
        CASE ER_TMHANDLE;    WriteF('ToolManager no actif.\n')
        CASE ER_TMLIB;       WriteF('ToolManager.library v3 ??n')
        CASE ER_GADTOOLSLIB; WriteF('gadtools.library v3 ??n')
        CASE ER_ALLOCHANDLE; WriteF('Impossible d\aouvir le handle.\n')
        CASE ER_MEM;         WriteF('Erreur de memoire.\n')
        CASE ER_OBJEXEC;     WriteF('Erreur de création d\aun objet Exec.\n')
        CASE ER_CREATEDOCK;  WriteF('Impossible d\aouvir le dock.\n')
        CASE ER_DIRONLY;     WriteF('Mauvais Argument.\n>TM_AutoDock <dossier>\n')
        CASE ER_NOEXEC;      WriteF('Aucun Exec.\n')
        CASE ER_OBJIMAGE;    WriteF('Erreur de création d\aun objet Image.\n')
        CASE ER_CXLIB;       WriteF('commodities.library ???\n')
        CASE ER_CREATEPORT;  WriteF('Impossible de créer le port de message.\n')
        CASE ER_BROKER;      WriteF('Impossible de créer le Broker.\n')
        CASE ER_CXFOBJ;      WriteF('Impossible d crée le Broker filter.\n')
        CASE ER_CXSOBJ;      WriteF('Impossible de créer le Broker Sender.\n')
        CASE ER_CXTOBJ;      WriteF('Impossible de créer le Broker Translate.\n')
        CASE ER_CXERROR;     WriteF('Erreur de création de la commoditie..\n')
        CASE ER_ICONLIB;     WriteF('icon.library ???\n')
        CASE ER_INTUILIB;    WriteF('intuition.library ???\n')
        DEFAULT;         NOP
    ENDSELECT
ENDPROC
PROC read_dossier() /*"read_dossier()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : ER_NONE if ok,else the error.
 * Description  : Build All Docks for toolmanager.
 *******************************************************************************/
    DEF lock,fib:fileinfoblock            /* Pour faire le 'dir' */
    DEF id_type                           /* id_type pour la whatis.library */
    DEF id_str[9]:STRING                  /* stockage du nom du filetype de la whatis.library */
    DEF fichier[80]:STRING                /* stockage pour le chemin complet du fichier courant */
    DEF test_in_dock                      /* variable de test pour connaitre si le fichier et un executable */
    DEF count=0                           /* compteur */
    DEF piv_stock:PTR TO toolmini         /* pointeur sur ma ministructure */
    DEF t_exists                          /* variable de test pour voir l'existence d'une icône associée à l'executable */
    DEF type_exec                         /* variable pour la définition du flag TMOP_EXECTYPE de l'objet Exec courant (WB/cli)*/
    DEF nom_ic[80]:STRING                 /* Stockage pour le nom des objects Icon et Exec */
    DEF out[100]:STRING                   /* Stockage de la déscription de la fenêtre con: si l'executable n'as pas d'icône */
    IF lock:=Lock(dossier,-2)
        IF Examine(lock,fib)
            IF fib.entrytype<0            /* Un nom de fichier a été passé en arg ERROR */
                UnLock(lock)
                RETURN ER_DIRONLY
            ENDIF
            WHILE ExNext(lock,fib)
                NameFromLock(lock,fichier,256)                 /* stocke dans fichier le nom racine du fichier courant */
                AddPart(fichier,'',256)                        /* ajoute le / si besoin */
                StringF(fichier,'\s\s',fichier,fib.filename)   /* reconstruit le chemin+nom du fichier */
                id_type:=WhatIs(fichier,[WI_DEEP,1])           /* interogatoire de la Whatis.library */
                id_str:=GetIDString(id_type)                   /* ça continue .. */
                test_in_dock:=in_doc(id_str)                   /* On regarde si c'est un executable */
                IF test_in_dock                                /* si oui on y vas */
                    StrCopy(nom_ic,fib.filename,ALL)           /* stock le nom du programme dans nom_ic */
                    num_icon[count]:=String(EstrLen(nom_ic))   /* réserve la mémoire pour nom_ic */
                    StrCopy(num_icon[count],nom_ic,ALL)        /* copie le nom dans la place réservé plus haut */
                    num_exec[count]:=String(EstrLen(fichier))  /* réserve la mémoire pour le nom de l'executable (nom complet chemin/fichier) */
                    StrCopy(num_exec[count],fichier,ALL)       /* copie le nom de l'executable dans la place réservé plus haut */
                    StringF(nom_ic,'\s.info',fichier)          /* reconstruit le nom reel du fichier icône associé a l'executable */
                    IF (t_exists:=exist_fichier(nom_ic))>-1    /* si il y a une icône */
                        type_exec:=TMET_WB                     /* on lancera l'object Exec du workbench */
                        out:=''                                /* sans ouvrir de fenêtre de sortie */
                    ELSE                                       /* sinon */
                        type_exec:=TMET_CLI                    /* on lance en cli */
                        out:='con:0/0/640/56/TM_AutoDock OutPut/CLOSE/WAIT'  /* avec cette fenêtre de sortie */
                    ENDIF
                    /* On crée un object Exec du nom de l'executable */
                    IF (CreateTMObjectTagList(handle,num_icon[count],TMOBJTYPE_EXEC,                 /* Type d'objet Exec */
                                                                     [TMOP_ARGUMENTS,flag_arg,       /* Avec ou sans argument  */
                                                                      TMOP_COMMAND,num_exec[count],  /* commande associé  */
                                                                      TMOP_EXECTYPE,type_exec,       /* WB ou Cli */
                                                                      TMOP_CURRENTDIR,dossier,       /* CD automatique */
                                                                      TMOP_OUTPUT,out,                /* Sortie standart */
                                                                      TAG_DONE]))=NIL THEN RETURN ER_OBJEXEC
                    /* Si le flag icon est mis */
                    IF flag_icon=TRUE
                        /* On construit un objet Image */
                        IF (CreateTMObjectTagList(handle,num_icon[count],TMOBJTYPE_IMAGE,[TMOP_FILE,fichier,TAG_DONE]))=NIL THEN RETURN ER_OBJIMAGE
                    ENDIF
                    /* On initilise ma ministructure */
                    piv_stock:=New(SIZEOF toolmini)
                    /* On associe les deux objets (Exec et Image) ensemble */
                    piv_stock.obj_dock_exec:=num_icon[count]
                    piv_stock.obj_dock_image:=num_icon[count]
                    piv_stock.obj_dock_sound:=NIL                 /* Pas de son...*/
                    ListAdd(list_tagic,[TMOP_TOOL,piv_stock],2)   /* On ajoute tout ça a l'objet Dock */
                    IF debug THEN WriteF('Fichier \s \s \d\n',num_icon[count],num_exec[count],type_exec)
                    count:=count+1                                /* on continue..*/
                ENDIF
            ENDWHILE
        ENDIF
        UnLock(lock)
    ELSE
        WriteF('Lock Ipossible.\n')
    ENDIF
    /* si il n'y a pas d'executable c'est pas la peine de continuer */
    IF count=0 THEN RETURN ER_NOEXEC ELSE RETURN ER_NONE
ENDPROC
PROC in_doc(id_str) /*"in_doc(id_str)"*/
/********************************************************************************
 * Para         : Id String (STRING) whatis.library.
 * Return       : TRUE if file in dock ,else FALSE
 * Description  : Choose all Exe.
 *******************************************************************************/
    /* ID de la WhatIs.library pris en compte */
    IF StrCmp(id_str,'Exe',3) THEN RETURN TRUE
    IF StrCmp(id_str,'Pure Exe',7) THEN RETURN TRUE
    IF StrCmp(id_str,'PP40 Exe',8) THEN RETURN TRUE
    IF StrCmp(id_str,'PP30 Exe',8) THEN RETURN TRUE
    IF StrCmp(id_str,'PP Exe',5) THEN RETURN TRUE
    IF StrCmp(id_str,'Script',6) THEN RETURN TRUE
    RETURN FALSE
ENDPROC
PROC open_libraries() /*"open_librarie()"*/
/********************************************************************************
 * Para         : NONE
 * Return       : ER_NONE if ok,else the error.
 * Description  : Open Libraries (exit if no ToolManager Handler).
 *                Build the commodities (newbroker).
 *******************************************************************************/
    DEF test_toolhandle
    mynewbroker:=[NB_VERSION,0,'TM_AutoDock',
                   'TM_AutoDock © 1994 NasGûl',
                   'Dock Automatique pour ToolManager',
                   NBU_UNIQUE OR NBU_NOTIFY,
                   COF_SHOW_HIDE,                /* COF_SHOW_HIDE */
                   0,0,NIL,0]:newbroker
    IF (whatisbase:=OpenLibrary('whatis.library',3))=NIL THEN RETURN ER_WHATISLIB
    /* si ToolManager n'est pas actif toute tentative d'ouvrir la librarie lance TM */
    /* avant.                                                                       */
    IF (test_toolhandle:=FindTask('ToolManager Handler'))=NIL THEN RETURN ER_TMHANDLE
    IF (toolmanagerbase:=OpenLibrary('toolmanager.library',3))=NIL THEN RETURN ER_TMLIB
    IF (cxbase:=OpenLibrary('commodities.library',37))=NIL THEN RETURN ER_CXLIB
    IF (iconbase:=OpenLibrary('icon.library',37))=NIL THEN RETURN ER_ICONLIB
    IF (intuitionbase:=OpenLibrary('intuition.library',37))=NIL THEN RETURN ER_INTUILIB
    IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN RETURN ER_GADTOOLSLIB
    /* On crée le port de message */
    IF (cxmsgport:=CreateMsgPort())=NIL THEN RETURN ER_CREATEPORT
    /* On attache notre structure newbroker a ce port */
    mynewbroker.port:=cxmsgport
    IF (cxmybroker:=CxBroker(mynewbroker,NIL))=NIL THEN RETURN ER_BROKER
    /***** ?????? AU HASARD ?????? *****/
    IF (cxfilterobj:=CreateCxObj(cxmybroker,CX_FILTER,'alt c'))=NIL THEN RETURN ER_CXFOBJ
    AttachCxObj(cxmybroker,cxfilterobj)
    IF (cxsenderobj:=CreateCxObj(cxmybroker,CX_SEND,cxmsgport))=NIL THEN RETURN ER_CXSOBJ
    AttachCxObj(cxfilterobj,cxsenderobj)
    IF (cxtranslateobj:=CreateCxObj(cxmybroker,CX_TRANSLATE,NIL))=NIL THEN RETURN ER_CXTOBJ
    AttachCxObj(cxfilterobj,cxtranslateobj)
    IF CxObjError(cxfilterobj) THEN RETURN ER_CXERROR
    ActivateCxObj(cxmybroker,TRUE)
    RETURN ER_NONE
ENDPROC
PROC exist_fichier(nom) /*"exist_fichier(nom)"*/
/********************************************************************************
 * Para         : file (STRING).
 * Return       : the len of file or -1.
 * Description  : Exists() fonction remplacement.
 *******************************************************************************/
    DEF len
    len:=FileLength(nom)
    RETURN len
ENDPROC
PROC p_WriteFList(ptr_list) /*"p_WriteFList(ptr_list)"*/
/********************************************************************************
 * Para         : address of list
 * Return       : NONE
 * Description  : Write the list and node in stdout.
 *******************************************************************************/
    DEF w_list:PTR TO lh
    DEF w_node:PTR TO ln
    w_list:=ptr_list
    w_node:=w_list.head
    WriteF('Adr List:\h[8] Head:\h[8] TailPred:\h[8]\n',w_list,w_list.head,w_list.tailpred)
    WHILE w_node
        /*IF w_node.succ<>0*/
            WriteF('Adr:\h[8] Succ:\h[8] Pred:\h[8] Name:\s\n',w_node,w_node.succ,w_node.pred,w_node.name)
        /*ENDIF*/
        w_node:=w_node.succ
    ENDWHILE
ENDPROC
prg_banner:
INCBIN 'TM_AutoDock.header'
