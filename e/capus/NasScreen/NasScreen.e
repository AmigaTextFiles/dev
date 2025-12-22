/********************************************************************************
 * << AUTO HEADER XDME >>
 ********************************************************************************
 ED      "EDG"
 EC      "EC"
 PREPRO      "EPP"
 SOURCE      "NasScreen.e"
 EPPDEST     "NasScreen_EPP.e"
 EXEC        "NasScreen"
 ISOURCE     " "
 HSOURCE     " "
 ERROREC     " "
 ERROREPP    " "
 VERSION     "0"
 REVISION    "12"
 NAMEPRG     "NasScreen"
 NAMEAUTHOR  "NasGûl"
 ********************************************************************************
 * HISTORY :
 * V0.1    - Initial version (# MENU ITEM SUBI COMM STACK KEY).
 * V0.11   - Ajout de SCREENMODE PALETTE FONT.
 * v0.12   - Ajout du menu Build.
 *******************************************************************************/
 OPT OSVERSION=37
ENUM ER_NONE,ER_OPENLIB,ER_WB,ER_VISUAL,ER_CONTEXT,ER_GADGET,ER_WINDOW,ER_MENUS,
     ER_MEM,ER_BA,ER_SCREEN,ER_SIG
MODULE 'intuition/intuition', 'gadtools', 'libraries/gadtools',
       'intuition/gadgetclass', 'exec/nodes', 'intuition/screens',
       'exec/lists','graphics/displayinfo' ,'graphics/text','gadtoolsbox/forms'
MODULE 'utility','utility/tagitem','wb','workbench/startup','dos/dosextens'
MODULE 'asl','libraries/asl','dos/dostags','dos/dosextens','diskfont'
RAISE ER_MEM IF New()=NIL
RAISE ER_MEM IF String()=NIL
DEF new_screen=NIL:PTR TO screen,
    visual=NIL,
    wnd=NIL:PTR TO window,type,menu
DEF sig=-1
DEF tattr:PTR TO textattr      /* Texte Attibuts */
DEF save_list[500]:LIST        /* Buffer contenant la description des menus (LONG) */
                   /* ATTENTION une LIST stocke sur des LONG ou INT ou CHAR mais pas sur les 3  */
                   /* la copie dans des structures newmenu se feras plus tard (PROC readfile()) */
DEF com_list[500]:LIST         /* Liste Contenant les commandes associées aux menus */
DEF stack_list[500]:LIST       /* Liste contenant les stacks associées aux commandes */
DEF save_list_chip,total_chip      /* Emplacement réel des menus,total mémoire de réservé */
DEF fichier_source[256]:STRING     /* string contenant le fichier de déscription des menus */
DEF scr_type=HIRES_KEY         /* Type d'écran par défault */
DEF scr_depth=2            /* Profondeur par défault   */
DEF palette[4]:ARRAY OF INT    /* Palette de l'écran       */
DEF dp=1,bp=2              /* detailpen et blockpen    */
DEF all_pens
PROC main() HANDLE /*"main()"*/
/********************************************************************************
 * Para     : NONE
 * Return   : NONE
 * Descritption : Main Procédure
 *******************************************************************************/
    DEF test_main
    VOID {prg_banner}
    tattr:=['topaz.font',9,0,0]:textattr
    palette[0]:=$787
    palette[1]:=$111
    palette[2]:=$ABB
    palette[3]:=$068
    all_pens:=[0,1,1,2,1,3,1,0,2,1,2,1]:INT
    /*************************************/
    /* Initialisation des menus internes */
    /*************************************/
    ListCopy(save_list,[1,0,'NasGûl Menus',0,0,0,0,
            2,0,'  Infos...  ',0,0,0,0,
            2,0,'  NewShell  ',0,0,0,0,
            2,0,'  Rebuild   ',0,0,0,0,
            2,0,'  Quitter   ',0,0,0,0],35)
    ListCopy(com_list,[0,0,0,0,0],5)
    ListCopy(stack_list,[0,0,0,0,0],5)
    StrCopy(fichier_source,arg,ALL)
    /**********************************************************************/
    /* readfile() renvoit FALSE si:                                       */
    /* - le fichier est trop gros.                    */
    /* - le fichier ne peut être ouvert.                  */
    /* - une ligne du fichier ne contient aucun des mots suivants:    */
    /*       - # en premier caractère (commentaires)                      */
    /*       - MENU                           */
    /*       - ITEM                           */
    /*       - SUBI                           */
    /*       - SCREENMODE                         */
    /*       - PALETTE                            */
    /**********************************************************************/
    /* remakelist() reinitialise les menus internes                       */
    /**********************************************************************/
    IF (test_main:=readfile())=FALSE THEN remakelist()
    IF (test_main:=openinterface())<>ER_NONE THEN Raise(test_main)
    REPEAT
    IF (test_main:=wait4message())<>ER_NONE THEN Raise(test_main)
    UNTIL type=IDCMP_CLOSEWINDOW
    Raise(ER_NONE)
EXCEPT
    closeinterface()
    IF new_screen.firstwindow<>0
    Wait(Shl(1,sig))            /* wait until all windows closed */
    ENDIF
    IF sig THEN FreeSignal(sig)
    IF save_list_chip THEN FreeMem(save_list_chip,total_chip)
    IF com_list THEN Dispose(com_list)
    IF stack_list THEN Dispose(stack_list)
    IF tattr THEN Dispose(tattr)
    IF new_screen THEN CloseS(new_screen)
    SetDefaultPubScreen(NIL)    /* workbench is default again */
    SELECT exception
    CASE ER_NONE;   NOP
    CASE ER_OPENLIB; WriteF('Impossible d\aouvir les libraries gadtools.library et/ou asl.libraries\n')
    CASE ER_SCREEN;  WriteF('Ouverture de l\aécran impossible.\n')
    CASE ER_VISUAL;  WriteF('Impossible de "locker" l\aécran.\n')
    CASE ER_MENUS;   WriteF('Impossible de créer les menus.\n')
    CASE ER_WINDOW;  WriteF('Impossible d\aouvrir la fenêtre.\n')
    CASE ER_MEM;     WriteF('Mémoire insuufisante.\n')
    CASE ER_BA;  WriteF('Bad Args !.\n')
    DEFAULT;     NOP
    ENDSELECT
ENDPROC
PROC openinterface() /*"openinterface()"*/
/********************************************************************************
 * Para     : NONE
 * Return   : ER_NONE si tout c'est bien passé,sinon l'erreur produite.
 * Description  : Ouvre les libraries,Initialise l'écran et la fenêtre.
 *******************************************************************************/
  IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN RETURN ER_OPENLIB
  IF (aslbase:=OpenLibrary('asl.library',37))=NIL THEN RETURN ER_OPENLIB
  IF (new_screen:=OpenScreenTagList(NIL,          /* get ourselves a public screen */
     [SA_TOP,0,
      /*SA_WIDTH,1820,*/              /* la taille de l'écran ne se fait qu'avec */
      /*SA_HEIGHT,512,*/              /*                         */
      SA_DEPTH,scr_depth,             /*                         */
      SA_FONT,tattr,              /*                         */
      SA_DISPLAYID,scr_type,          /* le champ SA_DISPLAYID           */
      SA_PUBNAME,'NGLSCREEN',
      SA_TITLE,'NasGûl Screen © 1994 NasGûl',
      SA_PUBSIG,IF (sig:=AllocSignal(-1))=NIL THEN Raise(ER_SIG) ELSE sig,
      SA_AUTOSCROLL,TRUE,
      SA_TYPE,CUSTOMSCREEN+PUBLICSCREEN,
      SA_OVERSCAN,OSCAN_TEXT,
      /*SA_PENS,[0,1,1,2,1,3,1,0,2,1,2,1]:INT,    /* Répartition de couleurs WB 2.0 */*/
      SA_PENS,all_pens,
      SA_DETAILPEN,dp,            /* Detailpen */
      SA_BLOCKPEN,bp,             /* BlockPen  */
      0,0]))=NIL THEN RETURN ER_SCREEN
  PubScreenStatus(new_screen,0)                 /* make it available */
  SetDefaultPubScreen('NGLSCREEN')
  SetPubScreenModes(SHANGHAI)
  IF (visual:=GetVisualInfoA(new_screen,NIL))=NIL THEN RETURN ER_VISUAL
  IF (menu:=CreateMenusA(save_list_chip,NIL))=NIL THEN RETURN ER_MENUS
  IF LayoutMenusA(menu,visual,NIL)=FALSE THEN RETURN ER_MENUS
  IF (wnd:=OpenW(0,0,new_screen.width,new_screen.height,$700,$900,'NGLWINDOW',new_screen,15,NIL))=NIL THEN RETURN ER_WINDOW
  LoadRGB4(ViewPortAddress(wnd),palette,4)
  IF SetMenuStrip(wnd,menu)=FALSE THEN RETURN ER_MENUS
  Gt_RefreshWindow(wnd,NIL)
  RETURN ER_NONE
ENDPROC
PROC closeinterface() /*"closeinterface()"*/
/********************************************************************************
 * Para     : NONE
 * Return   : NONE
 * Descritption : Ferme l'écran la fenêtre et les libraries.
 *******************************************************************************/
  IF wnd THEN ClearMenuStrip(wnd)
  IF menu THEN FreeMenus(menu)
  IF visual THEN FreeVisualInfo(visual)
  IF wnd THEN CloseWindow(wnd)
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
  IF aslbase THEN CloseLibrary(aslbase)
ENDPROC
PROC wait4message() HANDLE /*"wait4message()"*/
/********************************************************************************
 * Para     : NONE
 * Return   : ER_NONE ou l'erreur apparue lors d'un Rebuild (menus).
 * Descritption : Surveille la fenêtre.
 *******************************************************************************/
  DEF mes:PTR TO intuimessage,ms
  DEF ret=NIL,adr_menu:PTR TO menu,number
  DEF fwin:PTR TO window
  ms:=wnd.menustrip
  REPEAT
    type:=0
    IF mes:=Gt_GetIMsg(wnd.userport)
      type:=mes.class
      IF type=IDCMP_MENUPICK
      ret:=mes.code
      IF ret<>$FFFF
          adr_menu:=ItemAddress(ms,ret)
          SELECT ret
          CASE $F800 /*Infos*/
              EasyRequestArgs(0,[20,0,0,'NasGûl Screen v0.0a','Ok'],0,NIL)
          CASE $F820 /*newshell*/
              Execute('Newshell',0,stdout)
             all_pens:=[1,2,1,2,0,1,3,1,2,1,1,0]:INT
          CASE $F840 /*rebuild*/
              /*Raise(rebuildmenu(fichier_source))*/
              Raise(rebuildmenu())
          CASE $F860 /*quitter*/
              fwin:=new_screen.firstwindow
              IF fwin.nextwindow=0
              IF EasyRequestArgs(0,[20,0,0,'Voulez-vous quitter ?','Oui|Non'],0,NIL) THEN type:=IDCMP_CLOSEWINDOW
              ELSE
              IF EasyRequestArgs(0,[20,0,0,'Attention plusieurs fenêtres sur l\aécran.\n Voulez-vous quitter ?','Oui|Non'],0,NIL) THEN type:=IDCMP_CLOSEWINDOW
              ENDIF
          DEFAULT
              number:=executemenu(ms,adr_menu)
          ENDSELECT
      ENDIF
      ELSEIF type=IDCMP_REFRESHWINDOW
    Gt_BeginRefresh(wnd)
    Gt_EndRefresh(wnd,TRUE)
    type:=0
      ELSEIF type<>IDCMP_CLOSEWINDOW
    type:=0
      ENDIF
      Gt_ReplyIMsg(mes)
    ELSE
      Wait(-1)
    ENDIF
  UNTIL type
  Raise(ER_NONE)
EXCEPT
    RETURN exception
ENDPROC
PROC readfile() /*"readfile()"*/
/********************************************************************************
 * Para     : NONE
 * Return   : TRUE si tout c'est bien passé,sion FALSE
 * Descritption : Ouvre le fichier de config et le traite ligne par ligne.
 *******************************************************************************/
  DEF len,a,adr,buf,handle,flen=TRUE,long,pas
  DEF my_string[256]:STRING,p=0,ff[256]:STRING
  DEF my_menu:PTR TO newmenu,test_parsing=NIL
  /*****************************************/
  /* Stockage du fichier source dans buf   */
  /*****************************************/
  IF (flen:=FileLength(fichier_source))=-1 THEN RETURN FALSE
  IF (buf:=New(flen+1))=NIL THEN RETURN FALSE
  IF (handle:=Open(fichier_source,1005))=NIL THEN RETURN FALSE
  len:=Read(handle,buf,flen)
  Close(handle)
  IF len<1 THEN RETURN FALSE
  adr:=buf
  /***********/
  /* Lecture */
  /***********/
  FOR a:=0 TO len-1
    test_parsing:=NIL
    IF buf[a]=10                /* Retour chariot (on traite le fichier par ligne) */
    IF a-p<>0               /* si la ligne n'est pas vide ..*/
        StringF(my_string,'\s',adr)     /* stockage de la ligne dans ff */
        ff:=String(EstrLen(my_string))
        StrCopy(ff,my_string,a-p)
        IF (test_parsing:=parse(ff))=FALSE  /* parsing de ff */
        Dispose(buf)
        RETURN FALSE
        ENDIF
    ENDIF
    p:=a+1
    adr:=buf+a+1
    ENDIF
  ENDFOR
  Dispose(buf)                            /* libére la mémoire buffer du fichier_source */
  ListAdd(save_list,[0,0,0,0,0,0,0],7)    /* ajoute le END_MENU (0)  a la liste des menus */
  long:=ListLen(save_list)                /* longueur de la  liste qui sert a calculer */
  total_chip:=(long/7)*20                 /* la place que prennent les structures newmenu */
  save_list_chip:=AllocMem(total_chip,2)  /* on alloue la place néssessaire */
  pas:=save_list_chip
  FOR buf:=0 TO long-1 STEP 7
    my_menu:=New(SIZEOF newmenu)             /* création */
    my_menu.type:=save_list[buf]         /* stockage */
    my_menu.pad:=save_list[buf+1]        /*    "     */
    my_menu.label:=save_list[buf+2]      /*    "     */
    my_menu.commkey:=save_list[buf+3]    /*    "     */
    my_menu.flags:=save_list[buf+4]      /*    "     */
    my_menu.mutualexclude:=save_list[buf+5]  /*    "     */
    my_menu.userdata:=save_list[buf+6]   /*    "     */
    CopyMem(my_menu,pas,20)                  /* Copie en mémoire */
    pas:=pas+20              /* incrémentation par pas de 20 */
    Dispose(my_menu)                         /* libération du buffer my_menu */
  ENDFOR
  /*******************/
  /* FIN DE LA COPIE */
  /*******************/
  Dispose(save_list)   /* libération de buffer */
  RETURN TRUE
ENDPROC
PROC parse(ff) /*"parse(ff)"*/
/********************************************************************************
 * Para     : Chaine de caractères.
 * Return   : TRUE si tout c'set bien passé,sion FALSE
 * Description  : Stock la ligne dans save_list.
 *******************************************************************************/
    DEF ret_str[256]:STRING
    DEF trim_str[256]:STRING
    DEF parse_str[256]:STRING
    DEF str_para[256]:STRING
    trim_str:=TrimStr(ff)
    IF StrCmp('#',ff,1)<>TRUE                                        /* si ce n'est pas un commentaire.. */
    StrCopy(parse_str,trim_str,ALL)
    IF StrCmp('SCREENMODE',parse_str,10)
        initscreen(parse_str)
        RETURN TRUE
    ENDIF
    IF StrCmp('PALETTE',parse_str,7)
        initpalette(parse_str)
        RETURN TRUE
    ENDIF
    IF StrCmp('MENU',parse_str,4)=TRUE                           /* Entrée Menu */
        IF (ret_str:=found_para('MENU',parse_str))<>FALSE        /* Trouve le titre */
        str_para:=String(EstrLen(ret_str))
        StrCopy(str_para,ret_str,ALL)
        ListAdd(save_list,[1,0,str_para,0,0,0,0],7)          /* stockage dans la liste */
        ListAdd(com_list,[''],1)                             /* mise a jour des autres listes */
        ListAdd(stack_list,[''],1)
        Dispose(str_para)                                    /* libère mem */
        ENDIF
        RETURN TRUE                          /* LIGNE OK */
    ELSEIF StrCmp('ITEM',parse_str,4)=TRUE                       /* Entrée Item */
        IF (ret_str:=found_para('ITEM',parse_str))<>FALSE        /* Trouve le nom */
        str_para:=String(EstrLen(ret_str))
        StrCopy(str_para,ret_str,ALL)
        ListAdd(save_list,[2,0,str_para],3)                  /* stockage dans la liste */
        Dispose(str_para)
        IF (ret_str:=found_para('KEY',parse_str))<>FALSE     /* Trouve le raccourci clavier */
            str_para:=String(EstrLen(ret_str))
            StrCopy(str_para,ret_str,ALL)
            ListAdd(save_list,[str_para,0,0,0],4)            /* stockage dans la liste */
            Dispose(str_para)                                /* libère la mémoire */
        ELSE
            ListAdd(save_list,[0,0,0,0],4)                   /* pas de raccourci clavier */
        ENDIF
        IF (ret_str:=found_para('COMM',parse_str))<>FALSE    /* trouve la commande associée */
            str_para:=String(EstrLen(ret_str))
            StrCopy(str_para,ret_str,ALL)
            ListAdd(com_list,[str_para],1)                   /* stockage dans la liste */
            Dispose(str_para)
        ELSE
            ListAdd(com_list,[''],1)                         /* item sans commande,donc c'est un item */
        ENDIF                            /* avec subitem                  */
        IF (ret_str:=found_para('STACK',parse_str))<>FALSE   /* trouve la stack */
            str_para:=String(EstrLen(ret_str))
            StrCopy(str_para,ret_str,ALL)
            ListAdd(stack_list,[str_para],1)                 /* stockage dans la liste */
            Dispose(str_para)
        ELSE
            ListAdd(stack_list,['4000'],1)                   /* stack par défault a 4000 */
        ENDIF
        ENDIF
        RETURN TRUE                          /* LIGNE OK */
    ELSEIF StrCmp('SUBI',parse_str,4)=TRUE                       /* Entrée SubItem */
        IF (ret_str:=found_para('SUBI',parse_str))<>FALSE        /* Trouve le nom */
        str_para:=String(EstrLen(ret_str))
        StrCopy(str_para,ret_str,ALL)
        ListAdd(save_list,[3,0,str_para],3)                  /* Stockage */
        Dispose(str_para)                                    /* FreeMem  */
        IF (ret_str:=found_para('KEY',parse_str))<>FALSE     /* Raccourci clavier */
            str_para:=String(EstrLen(ret_str))
            StrCopy(str_para,ret_str,ALL)
            ListAdd(save_list,[str_para,0,0,0],4)            /* stockage */
            Dispose(str_para)
        ELSE
            ListAdd(save_list,[0,0,0,0],4)                   /* pas de raccourci clavier */
        ENDIF
        IF (ret_str:=found_para('COMM',parse_str))<>FALSE    /* Trouve commande associée */
            str_para:=String(EstrLen(ret_str))
            StrCopy(str_para,ret_str,ALL)
            ListAdd(com_list,[str_para],1)                   /* stockage */
            Dispose(str_para)
        ELSE
            ListAdd(com_list,[''],1)                         /* pas de commande */
        ENDIF
        IF (ret_str:=found_para('STACK',parse_str))<>FALSE   /* Trouve la stack */
            str_para:=String(EstrLen(ret_str))
            StrCopy(str_para,ret_str,ALL)
            ListAdd(stack_list,[str_para],1)                 /* Stockage */
            Dispose(str_para)
        ELSE
            ListAdd(stack_list,['4000'],1)                   /* Stack par défault de 4000 */
        ENDIF
        ENDIF
        RETURN TRUE                          /* LIGNE OK */
    ENDIF
    ELSE
    RETURN TRUE                          /* LIGNE COMMENTAIRE OK */
    ENDIF
    RETURN FALSE                             /* PROBLEME AUCUN #,MENU,ITEM,SUBI DANS CETTE LIGNE */
ENDPROC
PROC found_para(str_para,parse_str) /*"found_para(str_para,parse_str)"*/
/********************************************************************************
 * Para     : Mot clé,ligne
 * Return   : la chaine résultante ou FALSE.
 * Description  : Retourne le paramètre d'un Mot Clé.
 *        Ex
 *        found_para('MACHIN','BIDULE "je suis un bidule" TRUC "je suis un truc" MACHIN "je suis un machin"')
 *        Auras en retour je suis un machin
 *******************************************************************************/
    DEF p[256]:STRING,pos_dep,pos_fin
    pos_dep:=InStr(parse_str,str_para,0)
    IF pos_dep<>-1
    pos_dep:=InStr(parse_str,'"',pos_dep)
    pos_fin:=InStr(parse_str,'"',pos_dep+1)
    MidStr(p,parse_str,pos_dep+1,(pos_fin-pos_dep)-1)
    RETURN p
    ELSE
    RETURN FALSE
    ENDIF
ENDPROC
PROC executemenu(ms,adr_menu) /*"executemenu(ms,adr_menu)"*/
/********************************************************************************
 * Para     : adr menustrip,adr item
 * Return   : NONE
 * Description  : Compte les menus et execute la commande associée
 *******************************************************************************/
    DEF look_menu:PTR TO menu
    DEF look_item:PTR TO menuitem
    DEF look_subitem:PTR TO menuitem
    DEF look_itext:PTR TO intuitext
    DEF adr
    DEF count=0
    DEF exe_str[256]:STRING,exe_stack
    look_menu:=ms
    adr:=adr_menu
    WHILE look_menu
    IF look_menu.firstitem<>0
        look_item:=look_menu.firstitem
        count:=count+1
        WHILE look_item
        IF look_item=adr
            JUMP found_exec
        ENDIF
        count:=count+1
        look_itext:=look_item.itemfill         /* Structure Intuitext (texte du menu) */
        IF look_item.subitem<>0
            look_subitem:=look_item.subitem
            WHILE look_subitem
            IF look_subitem=adr
                JUMP found_exec
            ENDIF
            count:=count+1
            look_itext:=look_subitem.itemfill
            look_subitem:=look_subitem.nextitem
            ENDWHILE
        ENDIF
        look_item:=look_item.nextitem
        ENDWHILE
    ENDIF
    look_menu:=look_menu.nextmenu
    ENDWHILE
    found_exec:
    StrCopy(exe_str,com_list[count],ALL)
    exe_stack:=Val(stack_list[count],NIL)
    SystemTagList(exe_str,[SYS_OUTPUT,NIL,
                      SYS_INPUT,NIL,
                      SYS_ASYNCH,TRUE,
                      SYS_USERSHELL,TRUE,
                      NP_STACKSIZE,exe_stack,
                      NP_PRIORITY,0,
                      NP_PATH,NIL,
                      NP_CONSOLETASK,NIL,
                      TAG_DONE])
ENDPROC
PROC remakelist() /*"remakelist()"*/
/********************************************************************************
 * Para     : NONE
 * Return   : NONE
 * Description  : Erreur dans le fichier de config,on ne reconstruit que les
 *        menus par défaut.
 *******************************************************************************/
    DEF my_menu:PTR TO newmenu
    DEF pas,long,buf
    EasyRequestArgs(0,[20,0,0,'Error Found in config. file','Ok'],0,NIL)
    /******************/
    /* On efface tout */
    /******************/
    IF save_list THEN Dispose(save_list)
    IF com_list THEN Dispose(com_list)
    IF stack_list THEN Dispose(stack_list)
    /*******************************************/
    /* Et on initialise que les menus internes */
    /*******************************************/
    ListCopy(save_list,[1,0,'NasGûl Menus',0,0,0,0,
              2,0,'  Infos...  ',0,0,0,0,
              2,0,'  NewShell  ',0,0,0,0,
              2,0,'  Rebuild   ',0,0,0,0,
              2,0,'  Quitter   ',0,0,0,0],35)
    ListCopy(com_list,[0,0,0,0,0],5)
    ListCopy(stack_list,[0,0,0,0,0],5)
    ListAdd(save_list,[0,0,0,0,0,0,0],7)
    long:=ListLen(save_list)
    total_chip:=(long/7)*20
    save_list_chip:=AllocMem(total_chip,2)
    pas:=save_list_chip
    FOR buf:=0 TO long-1 STEP 7
      my_menu:=New(SIZEOF newmenu)
      my_menu.type:=save_list[buf]
      my_menu.pad:=save_list[buf+1]
      my_menu.label:=save_list[buf+2]
      my_menu.commkey:=save_list[buf+3]
      my_menu.flags:=save_list[buf+4]
      my_menu.mutualexclude:=save_list[buf+5]
      my_menu.userdata:=save_list[buf+6]
      CopyMem(my_menu,pas,20)
      pas:=pas+20
      Dispose(my_menu)
    ENDFOR
    Dispose(save_list)
ENDPROC
PROC initscreen(parse_str) /*"initscreen(parse_str)"*/
/********************************************************************************
 * Para     : Chaine de caractères
 * Return   : NONE
 * Description  : Lecture de la ligne SCREENMODE du fichier de config.
 *******************************************************************************/
    DEF valeur[256]:STRING
    DEF font_name[80]:STRING,font_size[2]:STRING,pos_f=NIL
    DEF new_tattr:PTR TO textattr
    IF (valeur:=found_para('MODE',parse_str))<>FALSE
    IF StrCmp('SHRE',valeur,4)
        scr_type:=SUPERLACE_KEY
        JUMP ok
    ENDIF
    IF StrCmp('SHR',valeur,3)
        scr_type:=SUPER_KEY
        JUMP ok
    ENDIF
    IF StrCmp('HRE',valeur,3)
        scr_type:=HIRESLACE_KEY
        JUMP ok
    ENDIF
    IF StrCmp('BRE',valeur,3)
        scr_type:=LORESLACE_KEY
        JUMP ok
    ENDIF
    IF StrCmp('BR',valeur,2)
        scr_type:=LORES_KEY
        JUMP ok
    ENDIF
    IF StrCmp('HR',valeur,2)
        scr_type:=HIRES_KEY
        JUMP ok
    ENDIF
    ENDIF
    ok:
    IF (valeur:=found_para('TYPE',parse_str))<>FALSE
    IF StrCmp('PAL',valeur,3)
        scr_type:=scr_type+PAL_MONITOR_ID
        JUMP ok1
    ENDIF
    IF StrCmp('NTSC',valeur,4)
        scr_type:=scr_type+NTSC_MONITOR_ID
        JUMP ok1
    ENDIF
    ENDIF
    ok1:
    IF (valeur:=found_para('DEPTH',parse_str))<>FALSE
    scr_depth:=Val(valeur,NIL)
    ENDIF
    IF (valeur:=found_para('DP',parse_str))<>FALSE
    dp:=Val(valeur,NIL)
    ENDIF
    IF (valeur:=found_para('BP',parse_str))<>FALSE
    bp:=Val(valeur,NIL)
    ENDIF
    IF (valeur:=found_para('FONT',parse_str))<>FALSE
    pos_f:=InStr(valeur,'/',0)
    MidStr(font_name,valeur,0,pos_f)
    MidStr(font_size,valeur,pos_f+1,ALL)
    IF tattr THEN Dispose(tattr)
    new_tattr:=New(SIZEOF textattr)
    new_tattr.name:=String(EstrLen(font_name))
    StrCopy(new_tattr.name,font_name,ALL)
    new_tattr.ysize:=Val(font_size,NIL)
    new_tattr.style:=0
    new_tattr.flags:=0
    tattr:=new_tattr
    ENDIF
ENDPROC
PROC initpalette(parse_str) /*"initpalette()"*/
/********************************************************************************
 * Para     : Chaine de caractères.
 * Return   : NONE
 * Description  : Lecture de la ligne PALETTE de fichier de config.
 *******************************************************************************/
    DEF rgb[4]:STRING,r_g_b
    IF (rgb:=found_para('COL0',parse_str))<>FALSE
    r_g_b:=Val(rgb,NIL)
    palette[0]:=r_g_b
    ENDIF
    IF (rgb:=found_para('COL1',parse_str))<>FALSE
    r_g_b:=Val(rgb,NIL)
    palette[1]:=r_g_b
    ENDIF
    IF (rgb:=found_para('COL2',parse_str))<>FALSE
    r_g_b:=Val(rgb,NIL)
    palette[2]:=r_g_b
    ENDIF
    IF (rgb:=found_para('COL3',parse_str))<>FALSE
    r_g_b:=Val(rgb,NIL)
    palette[3]:=r_g_b
    ENDIF
ENDPROC
PROC rebuildmenu() /*"rebuildmenu()"*/
/********************************************************************************
 * Para     : NONE.
 * Return   : ER_NONE si Ok,sinon l'erreur.
 * Description  : Libère la mémoire des menus,ferme la fenêtre,et reload le
 *        fichier de config.
 *******************************************************************************/
    DEF test_cleanup
    /* <<<< CLEANUP >>>> */
    IF save_list_chip THEN FreeMem(save_list_chip,total_chip)
    IF com_list THEN Dispose(com_list)
    IF stack_list THEN Dispose(stack_list)
    IF wnd THEN ClearMenuStrip(wnd)
    IF menu THEN FreeMenus(menu)
    IF wnd THEN CloseWindow(wnd)
    /* Palette par défault */
    palette[0]:=$787
    palette[1]:=$111
    palette[2]:=$ABB
    palette[3]:=$068
    /*************************************/
    /* Initialisation des menus internes */
    /*************************************/
    ListCopy(save_list,[1,0,'NasGûl Menus',0,0,0,0,
            2,0,'  Infos...  ',0,0,0,0,
            2,0,'  NewShell  ',0,0,0,0,
            2,0,'  Rebuild   ',0,0,0,0,
            2,0,'  Quitter   ',0,0,0,0],35)
    ListCopy(com_list,[0,0,0,0,0],5)
    ListCopy(stack_list,[0,0,0,0,0],5)
    /* On charge le fichier */
    IF (test_cleanup:=readfile())=FALSE THEN remakelist()
    IF (menu:=CreateMenusA(save_list_chip,NIL))=NIL THEN RETURN ER_MENUS
    IF LayoutMenusA(menu,visual,NIL)=FALSE THEN RETURN ER_MENUS
    IF (wnd:=OpenW(0,0,new_screen.width,new_screen.height,$700,$190E,'NGLWINDOW',new_screen,15,NIL))=NIL THEN RETURN ER_WINDOW
    LoadRGB4(ViewPortAddress(wnd),palette,4)
    IF SetMenuStrip(wnd,menu)=FALSE THEN RETURN ER_MENUS
    new_screen.font:=tattr
    Gt_RefreshWindow(wnd,NIL)
    RETURN ER_NONE
ENDPROC
prg_banner:
INCBIN 'NasScreen.header'

