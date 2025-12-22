/*------------------------------------------------------------------------*

  cookRawkeyTest.e - test et monstre l'usage du module cookRawkey.m

 *------------------------------------------------------------------------*/

MODULE 'intuition/intuition',
       'intuition/screens',
       'graphics/rastport',
       'tools/cookRawkey'

CONST ESCAPE_KEY=27

PROC main() HANDLE
  DEF win=NIL:PTR TO window,
      idcmpMessage:PTR TO intuimessage, idcmpCode, idcmpQualifier, iAddress,
      error, errorMessage, asciiChar
  /*------------------------------*
    Initialise le module de conversion rawkey.
   *------------------------------*/
  IF error:=warmupRawkeyCooker() THEN Raise(error)
  /*-- Converti les rawkeys jusqu'à ce que la touche ESC est pressée. --*/
  IF win:=OpenW(20, 20, 500, 150,
                IDCMP_RAWKEY, WFLG_ACTIVATE,
                'Pressez Escape pour Quitter', NIL, WBENCHSCREEN, NIL)
    REPEAT
      /*-- Attend un rawkey. --*/
      WHILE (idcmpMessage:=GetMsg(win.userport))=NIL DO WaitPort(win.userport)
      /*-- Copie l'info intuimessage, et répond. --*/
      idcmpCode:=idcmpMessage.code
      idcmpQualifier:=idcmpMessage.qualifier
      iAddress:=idcmpMessage.iaddress
      ReplyMsg(idcmpMessage)
      /*------------------------*
        Converti rawkey en ascii.
       *------------------------*/
      IF (asciiChar:=cookRawkey(idcmpCode, idcmpQualifier, iAddress)) <> ESCAPE_KEY
        TextF(20, 40, 'Key=\c', asciiChar)
      ENDIF
    UNTIL asciiChar=ESCAPE_KEY
    CloseW(win)
  ELSE
    WriteF('Ne peut ouvrir la fenêtre\n')
  ENDIF
  /*---------------------------------*
    Nettoie le module de conversion rawkey.
   *---------------------------------*/
  shutdownRawkeyCooker()
EXCEPT
  errorMessage:='figger it out'
  /*--------------------------------------*
    Gère les exceptions levées par conversion
   *--------------------------------------*/
  SELECT exception
    CASE "MEM";          errorMessage:='avoir de la mémoire'
    CASE ER_CREATEPORT;  errorMessage:='créé un port message'
    CASE ER_CREATEIO;    errorMessage:='créé une requête IO'
    CASE ER_OPENDEVICE;  errorMessage:='oouvrir le console.device'
    CASE ER_ASKKEYMAP;   errorMessage:='demander le keymap'
  ENDSELECT
  WriteF('Ne peut pas \s!\n', errorMessage)
  /*---------------------------------*
    Nettoie le module de conversion rawkey.
   *---------------------------------*/
  shutdownRawkeyCooker()
ENDPROC
