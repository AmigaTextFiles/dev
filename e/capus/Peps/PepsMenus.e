DEF save_list[500]:LIST        /* Buffer contenant la description des menus (LONG) */
                               /* ATTENTION une LIST stocke sur des LONG ou INT ou CHAR mais pas sur les 3  */
                               /* la copie dans des structures newmenu se feras plus tard (PROC readfile()) */
DEF com_list[500]:LIST         /* Liste Contenant les commandes associées aux menus */
DEF stack_list[500]:LIST       /* Liste contenant les stacks associées aux commandes */
DEF save_list_chip=NIL,total_chip      /* Emplacement réel des menus,total mémoire de réservé */
PROC p_ReadMenuFile(mfile) /*"p_ReadMenuFile(mfile)"*/
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
  IF (flen:=FileLength(mfile))=-1 THEN RETURN FALSE
  IF (buf:=New(flen+1))=NIL THEN RETURN FALSE
  IF (handle:=Open(mfile,1005))=NIL THEN RETURN FALSE
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
        IF (test_parsing:=p_ParseLineMenu(ff))=FALSE  /* parsing de ff */
            Dispose(buf)
            dWriteF(['Error Read Menu File :\s\n'],[ff])
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
PROC p_ParseLineMenu(ff) /*"p_ParseLineMenu(ff)"*/
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
        IF StrCmp('MENU',parse_str,4)=TRUE                           /* Entrée Menu */
            IF (ret_str:=found_para('MENU',parse_str,'"'))<>FALSE        /* Trouve le titre */
                str_para:=String(EstrLen(ret_str))
                StrCopy(str_para,ret_str,ALL)
                ListAdd(save_list,[1,0,str_para,0,0,0,0],7)          /* stockage dans la liste */
                ListAdd(com_list,[''],1)                             /* mise a jour des autres listes */
                ListAdd(stack_list,[''],1)
                Dispose(str_para)                                    /* libère mem */
            ENDIF
            RETURN TRUE                          /* LIGNE OK */
        ELSEIF StrCmp('BARL',parse_str,4)=TRUE
            ListAdd(save_list,[2,NM_BARLABEL,0,0,0,0,0],7)
            RETURN TRUE
        ELSEIF StrCmp('ITEM',parse_str,4)=TRUE                       /* Entrée Item */
            IF (ret_str:=found_para('ITEM',parse_str,'"'))<>FALSE        /* Trouve le nom */
                str_para:=String(EstrLen(ret_str))
                StrCopy(str_para,ret_str,ALL)
                ListAdd(save_list,[2,0,str_para],3)                  /* stockage dans la liste */
                Dispose(str_para)
                IF (ret_str:=found_para('KEY',parse_str,'"'))<>FALSE     /* Trouve le raccourci clavier */
                    str_para:=String(EstrLen(ret_str))
                    StrCopy(str_para,ret_str,ALL)
                    ListAdd(save_list,[str_para,0,0,0],4)            /* stockage dans la liste */
                    Dispose(str_para)                                /* libère la mémoire */
                ELSE
                    ListAdd(save_list,[0,0,0,0],4)                   /* pas de raccourci clavier */
                ENDIF
                IF (ret_str:=found_para('COMM',parse_str,'"'))<>FALSE    /* trouve la commande associée */
                    str_para:=String(EstrLen(ret_str))
                    StrCopy(str_para,ret_str,ALL)
                    ListAdd(com_list,[str_para],1)                   /* stockage dans la liste */
                    Dispose(str_para)
                ELSE
                    ListAdd(com_list,[''],1)                         /* item sans commande,donc c'est un item */
                ENDIF                            /* avec subitem                  */
                IF (ret_str:=found_para('TYPE',parse_str,'"'))<>FALSE   /* trouve la stack */
                    str_para:=String(EstrLen(ret_str))
                    StrCopy(str_para,ret_str,ALL)
                    ListAdd(stack_list,[str_para],1)                 /* stockage dans la liste */
                    Dispose(str_para)
                ELSE
                    ListAdd(stack_list,['REXX'],1)                   /* stack par défault a 4000 */
                ENDIF
            ENDIF
            RETURN TRUE                          /* LIGNE OK */
        ELSEIF StrCmp('SUBI',parse_str,4)=TRUE                       /* Entrée SubItem */
            IF (ret_str:=found_para('SUBI',parse_str,'"'))<>FALSE        /* Trouve le nom */
                str_para:=String(EstrLen(ret_str))
                StrCopy(str_para,ret_str,ALL)
                ListAdd(save_list,[3,0,str_para],3)                  /* Stockage */
                Dispose(str_para)                                    /* FreeMem  */
                IF (ret_str:=found_para('KEY',parse_str,'"'))<>FALSE     /* Raccourci clavier */
                    str_para:=String(EstrLen(ret_str))
                    StrCopy(str_para,ret_str,ALL)
                    ListAdd(save_list,[str_para,0,0,0],4)            /* stockage */
                    Dispose(str_para)
                ELSE
                    ListAdd(save_list,[0,0,0,0],4)                   /* pas de raccourci clavier */
                ENDIF
                IF (ret_str:=found_para('COMM',parse_str,'"'))<>FALSE    /* Trouve commande associée */
                    str_para:=String(EstrLen(ret_str))
                    StrCopy(str_para,ret_str,ALL)
                    ListAdd(com_list,[str_para],1)                   /* stockage */
                    Dispose(str_para)
                ELSE
                    ListAdd(com_list,[''],1)                         /* pas de commande */
                ENDIF
                IF (ret_str:=found_para('TYPE',parse_str,'"'))<>FALSE   /* Trouve la stack */
                    str_para:=String(EstrLen(ret_str))
                    StrCopy(str_para,ret_str,ALL)
                    ListAdd(stack_list,[str_para],1)                 /* Stockage */
                    Dispose(str_para)
                ELSE
                    ListAdd(stack_list,['REXX'],1)                   /* Stack par défault de 4000 */
                ENDIF
            ENDIF
            RETURN TRUE                          /* LIGNE OK */
        ENDIF
    ELSE
        RETURN TRUE                          /* LIGNE COMMENTAIRE OK */
    ENDIF
    RETURN FALSE                             /* PROBLEME AUCUN #,MENU,ITEM,SUBI DANS CETTE LIGNE */
ENDPROC
PROC p_RemakeMenuList() /*"p_RemakeMenuList()"*/
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
PROC p_RebuildMenu() /*"p_RebuidMenu()"*/
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
    IF pp_window THEN ClearMenuStrip(pp_window)
    IF menu THEN FreeMenus(menu)
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
    IF (test_cleanup:=p_ReadMenuFile(menufile))=FALSE THEN p_RemakeMenuList()
    IF (menu:=CreateMenusA(save_list_chip,NIL))=NIL THEN RETURN ER_MENUS
    IF LayoutMenusA(menu,visual,NIL)=FALSE THEN RETURN ER_MENUS
    IF pp_window<>NIL
        IF SetMenuStrip(pp_window,menu)=FALSE THEN RETURN ER_MENUS
    ENDIF
    Gt_RefreshWindow(pp_window,NIL)
    RETURN ER_NONE
ENDPROC
PROC p_ExecuteMenu(ms,adr_menu) /*"p_ExecuteMenu(ms,adr_menu)"*/
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
    DEF exe_str[256]:STRING,type_exe[256]:STRING
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
    StrCopy(type_exe,stack_list[count],ALL)
    IF StrCmp(type_exe,'CLI',4)
        p_Execute(exe_str)
    ELSEIF StrCmp(type_exe,'REXX',4)
        p_SendRexxCommand(exe_str,'REXX',RXCOMM+RXFF_RESULT)
    ELSEIF StrCmp(type_exe,'EDPORT',6)
        p_SendRexxCommand(exe_str,edarexxportname,RXCOMM+RXFF_RESULT)
    ENDIF
ENDPROC

