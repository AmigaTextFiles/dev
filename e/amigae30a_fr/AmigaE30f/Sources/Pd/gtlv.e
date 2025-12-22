/*------------------------------------------------------------------------------------------*
  Source E génératé par SRCGEN v0.1

  Démo montrant la création, le gestion , le nettoyage d'un listview de la gadtools.library.
  Inclu des gadgets bouton et chaine pour la fonctionnalité.
  AUTEUR:  B. Wills + SRCGEN :-)
 *------------------------------------------------------------------------------------------*/
OPT OSVERSION=37

MODULE 'gadtools', 'libraries/gadtools', 'intuition/intuition',
       'intuition/screens', 'graphics/text',
       'exec/lists', 'exec/nodes', 'utility/tagitem'

/*-- Function return values. --*/
ENUM NONE, NOCONTEXT, NOGADGET, NOWB, NOVISUAL, OPENGT, NOWINDOW, NOMENUS, MEM

/*-- Gadget IDs. --*/
ENUM ADDBUTTON_ID, DELETEBUTTON_ID, STRING_ID, LISTVIEW_ID

RAISE "MEM" IF New()=NIL,
      "MEM" IF String()=NIL

/*-- Variables Standards de SrcGen. --*/
DEF win=NIL:PTR TO window,
    scr=NIL:PTR TO screen,
    glist=NIL,
    visual=NIL,
    infos:PTR TO gadget,
    messageClass,
    offx, offy, tattr

/*-- Listview et gadgets associés. --*/
DEF list=NIL:PTR TO mlh,            /* liste Exec prend les entrées listview    */
    listView=NIL:PTR TO gadget,     /* gadget listview                          */
    addButton=NIL:PTR TO gadget,    /* gadget bouton pour ajouter une entrée    */
    deleteButton=NIL:PTR TO gadget, /* gadget bouton pour effacer une entrée    */
    stringGadget=NIL:PTR TO gadget, /* gadget chaine, valeur ajoutée au listiew */
    stringGadgetValue:PTR TO CHAR   /* Pointeur sur le le gadget de chaine      */

PROC initList(l:PTR TO mlh)
/*-- Initialise une liste exec. --*/
  l.head:=l+4
  l.tail:=NIL
  l.tailpred:=l
ENDPROC

PROC setupScreen()
/*-- Ouvre bibliothèques et prend les infos écran. --*/
  IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN RETURN OPENGT
  IF (scr:=LockPubScreen('Workbench'))=NIL THEN RETURN NOWB
  IF (visual:=GetVisualInfoA(scr,NIL))=NIL THEN RETURN NOVISUAL
  offy:=scr.wbortop+Int(scr.rastport+58)-10
  tattr:=['topaz.font',8,0,0]:textattr
ENDPROC  NONE

PROC closeScreen()
/*-- Libère resources, ferme écran et bibliothèques. --*/
  IF glist THEN FreeGadgets(glist)
  IF visual THEN FreeVisualInfo(visual)
  IF scr THEN UnlockPubScreen(NIL,scr)
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
ENDPROC

PROC createGadgets()
/*-- Initialise structures gadget et les créés. --*/
  DEF g, stringInfo:PTR TO stringinfo
  /*-- Init list Exec pour prendre les entrées listview. Commence à vide. --*/
  list:=New(SIZEOF mlh)
  initList(list)
  IF (g:=CreateContext({glist}))=NIL THEN RETURN NOCONTEXT
  IF (g:=listView:=CreateGadgetA(LISTVIEW_KIND, g,
    [offx+7, offy+13, 243, 100,
     'Ma liste', tattr, LISTVIEW_ID, 0, visual, 0]:newgadget,
    [GTLV_LABELS,       list,
     GTLV_SHOWSELECTED, NIL, TAG_DONE]))=NIL THEN RETURN NOGADGET
  IF (g:=stringGadget:=CreateGadgetA(STRING_KIND,g,
    [offx+7, offy+111, 243, 12,
     '', tattr, STRING_ID, 0, visual, 0]:newgadget,
    [GTST_MAXCHARS,25, TAG_DONE]))=NIL THEN RETURN NOGADGET
/*-- C'est là que le tempo gadget est caché ! --*/
  stringInfo:=stringGadget.specialinfo
  stringGadgetValue:=stringInfo.buffer
/*-------------------------------------------------------*/
  IF (g:=addButton:=CreateGadgetA(BUTTON_KIND, g,
    [offx+58, offy+111+15, 65, 17,
     'Ajouter', tattr, ADDBUTTON_ID, 16, visual, 0]:newgadget,
    [TAG_DONE]))=NIL THEN RETURN NOGADGET
  IF (g:=deleteButton:=CreateGadgetA(BUTTON_KIND, g,
    [offx+129, offy+111+15, 65, 17,
     'Effacer', tattr, DELETEBUTTON_ID, 16, visual, 0]:newgadget,
    [TAG_DONE]))=NIL THEN RETURN NOGADGET
ENDPROC  NONE

PROC openWindow()
  IF createGadgets()<>NONE THEN RETURN NOGADGET
  /*-- Note WA_IDCMP pour prendre des messages du gadget listview: --*/
  IF (win:=OpenWindowTagList(NIL,
    [WA_LEFT,         38,
     WA_TOP,          14,
     WA_WIDTH,        offx+257,
     WA_HEIGHT,       offy+150,
     WA_IDCMP,        (IDCMP_REFRESHWINDOW OR IDCMP_CLOSEWINDOW OR IDCMP_GADGETUP OR
                       IDCMP_MOUSEMOVE OR LISTVIEWIDCMP OR SCROLLERIDCMP),
     WA_FLAGS,        (WFLG_DRAGBAR OR WFLG_DEPTHGADGET OR WFLG_CLOSEGADGET OR
                       WFLG_SMART_REFRESH OR WFLG_ACTIVATE),
     WA_TITLE,NIL,
     WA_CUSTOMSCREEN, scr,
     WA_MINWIDTH,     67,
     WA_MINHEIGHT,    21,
     WA_MAXWIDTH,     $2C0,
     WA_MAXHEIGHT,    277,
     WA_AUTOADJUST,   1,
     WA_GADGETS,      glist,
     TAG_DONE]))=NIL THEN RETURN NOWINDOW
  Gt_RefreshWindow(win, NIL)
ENDPROC NONE

PROC closeWindow()
  IF win THEN CloseWindow(win)
ENDPROC

PROC wait4message(win:PTR TO window)
  DEF mes:PTR TO intuimessage, type
  REPEAT
    type:=0
    IF mes:=Gt_GetIMsg(win.userport)
      type:=mes.class
      SELECT type
        CASE IDCMP_GADGETUP
          /*-- Tout les vieux gadget vont le faire. L'adresse est faite --*/
          /*-- pour identifier qui à envoyé le message.                 --*/
          infos:=mes.iaddress
          infos.gadgetid:=mes.code
        CASE IDCMP_REFRESHWINDOW
          Gt_BeginRefresh(win)
          Gt_EndRefresh(win,TRUE)
          type:=0
      ENDSELECT
      Gt_ReplyIMsg(mes)
    ELSE
      WaitPort(win.userport)
    ENDIF
  UNTIL type
ENDPROC type

PROC addToList()
  DEF newNode=NIL:PTR TO ln, node:PTR TO ln,
      len, done=FALSE, itemPosition=0
  /*-- N'ajoute pas si il n'y a rien dans le gadget de chaine. --*/
  IF (len:=StrLen(stringGadgetValue))=0 THEN RETURN
  /*-- Crée un noeud et une chaine pour ajouter au listview. --*/
  newNode:=New(SIZEOF ln)
  newNode.name:=String(len)
  StrCopy(newNode.name, stringGadgetValue, ALL)
  /*-- Détache la list Exec du gadget listview. --*/
  Gt_SetGadgetAttrsA (listView, win, NIL, [GTLV_LABELS, -1, TAG_DONE])
  /*-- Décide où insérer la nouvelle entrée. Tri sur le premier caractère. --*/
  node:=list.head
  IF list.tailpred=list
    AddHead(list, newNode)
  ELSEIF Char(node.name)>stringGadgetValue[]
    AddHead(list, newNode)
  ELSEIF node=list.tailpred
    AddTail(list, newNode)
  ELSE
    WHILE done=FALSE
      node:=node.succ
      INC itemPosition
      IF Char(node.name)>stringGadgetValue[]
        done:=TRUE
      ELSEIF node.succ=NIL
        done:=TRUE
      ENDIF
    ENDWHILE
    Insert(list, newNode, node.pred)
  ENDIF
  /*-- Reattach the exec list to the listview gadget. --*/
  Gt_SetGadgetAttrsA (listView, win, NIL,
                      [GTLV_LABELS, list,
                       GTLV_TOP,    itemPosition,
                       TAG_DONE])
ENDPROC

PROC deleteFromList(itemPosition)
  DEF node:PTR TO ln, i
  /*-- N'efface pas si aucune entrée n'est sélectionnée. --*/
  IF (itemPosition=-1) OR (list.tailpred=list) THEN RETURN
  /*-- Détache la liste Exec du gadget listview. --*/
  Gt_SetGadgetAttrsA (listView, win, NIL, [GTLV_LABELS, -1, TAG_DONE])
  /*-- Cherche le noeud qui correspond à itemPosition dans la liste Exec. --*/
  node:=list.head
  FOR i:=1 TO itemPosition DO node:=node.succ
  /*-- Enlève et désalloue les données du noeuds. --*/
  Remove(node)
  Dispose(node.name)
  Dispose(node)
  /*-- Reattache la liste exec au gadget listview. --*/
  Gt_SetGadgetAttrsA (listView, win, NIL,
                      [GTLV_LABELS, list, TAG_DONE])
ENDPROC

PROC main() HANDLE
  DEF listItemPosition=-1 /* valeur sentinelle, indique aucune sélection */
  IF setupScreen()=NONE
    IF openWindow()=NONE
      REPEAT
        messageClass:=wait4message(win)
        SELECT messageClass
          CASE IDCMP_GADGETUP
            SELECT infos  /* pointeur sur gadget */
              CASE addButton
                addToList()  /* demande une valeur dans le gadget chaine */
              CASE deleteButton
                deleteFromList(listItemPosition) /* demande une sélection */
                listItemPosition:=-1             /* valeur sentinelle=pas de sélection */
              CASE listView
                listItemPosition:=infos.gadgetid /* notez l'utilistion de ce champ ! */
            ENDSELECT
          CASE IDCMP_INTUITICKS
            NOP /* Ceci est envoyé pour quelques raisons (que la raison ignore) }:-( */
        ENDSELECT
      UNTIL messageClass=IDCMP_CLOSEWINDOW
      closeWindow()
    ENDIF
  ENDIF
  closeScreen()
  CleanUp(0)
EXCEPT
  WriteF('Exception: "\s"\n', [exception, 0])
  closeWindow()
  closeScreen()
  CleanUp(0)
ENDPROC
