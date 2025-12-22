MODULE 'iff','libraries/iff','intuition/intuition','intuition/screens',
       'exec/memory'

ENUM ER_NONE,ER_IFFLIB,ER_OPENIFF,ER_NOBMHD,ER_SCREEN,ER_WINDOW,ER_DECODE

DEF iff=NIL,s=NIL,ct[256]:ARRAY OF INT,bmhd,w=NIL:PTR TO window,
    quit=FALSE,msg:PTR TO intuimessage,sprite=NIL

PROC main() HANDLE
  /* Ouvre la biblihotèque en premier */
  IF (iffbase:=OpenLibrary('iff.library',22))=NIL THEN Raise(ER_IFFLIB)

  /* arg = filename of IFF file */
  IF (iff:=IfFL_OpenIFF(arg,IFFL_MODE_READ))=NIL THEN Raise(ER_OPENIFF)

  /* BMHD = BitMap HeaDer (contient les dimensions de l'image) */
  IF (bmhd:=IfFL_GetBMHD(iff))=NIL THEN Raise(ER_NOBMHD)

  /* Ouvre l'écran avec les dimensions correctes */
  IF (s:=OpenScreenTagList(NIL,
    [SA_WIDTH,Int(bmhd),SA_HEIGHT,Int(bmhd+2),SA_DEPTH,Char(bmhd+8),
     SA_DISPLAYID,IfFL_GetViewModes(iff),
     0,0]))=NIL THEN Raise(ER_SCREEN)

  /* Ouvre une grande fenêtre inutile */
  IF (w:=OpenWindowTagList(NIL,
    [WA_LEFT,0,WA_TOP,0,WA_WIDTH,Int(bmhd),WA_HEIGHT,Int(bmhd+2),
     WA_FLAGS,WFLG_SIMPLE_REFRESH OR WFLG_NOCAREREFRESH OR
              WFLG_BORDERLESS OR WFLG_ACTIVATE,
     WA_IDCMP,IDCMP_MOUSEBUTTONS OR IDCMP_RAWKEY,
     WA_CUSTOMSCREEN,s,
     NIL,NIL]))=NIL THEN Raise(ER_WINDOW)

  /* Efface le pinteur de la souris */
  IF sprite:=AllocMem(20,MEMF_CHIP OR MEMF_CLEAR)
    SetPointer(w,sprite,1,16,0,0)
  ENDIF

  /* Fixe la palette de l'écran */
  LoadRGB4(s+44,ct,IfFL_GetColorTab(iff,ct))

  /* Essaie de charger l'image */
  IF (IfFL_DecodePic(iff,s+184))=FALSE THEN Raise(ER_DECODE)

  /* Attend que l'utilisateur appuie sur le bouton de la souris */
  REPEAT
    IF msg:=GetMsg(w.userport)
      quit:=(msg.class AND (IDCMP_MOUSEBUTTONS OR IDCMP_RAWKEY))
    ELSE
      quit:=(Wait(-1) AND Shl(1,12))
    ENDIF
  UNTIL quit

  Raise(ER_NONE)
EXCEPT
  /* Nettoie */
  IF w THEN CloseWindow(w)
  IF sprite THEN FreeMem(sprite,20)
  IF s THEN CloseScreen(s)
  IF iff THEN IfFL_CloseIFF(iff)
  IF iffbase THEN CloseLibrary(iffbase)

  /* Affiche les messages d'erreurs possible */
  IF exception>0
    WriteF('Error: \s.\n',
      ListItem(['Pas de IFF.library','Ne peut ouvrir le fichier IFF',
                'Le fichier IFF n'a pa de bitmap header','Ne peut ouvrir l\aécran',
                'Ne peut ouvrir la fenêtre','Ne peut décoder l\aimage'],
                exception-1))
  ENDIF
ENDPROC
