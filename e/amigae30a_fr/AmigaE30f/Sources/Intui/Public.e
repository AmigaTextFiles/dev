/* Ouvre notre écran publique avec un shell dedans ...
   Note : cette exemple ne prend pas compte 2 écrans avec le même nom,
   ou d'autres bizarreries...
   WB 2.0
   Traduction : Olivier ANH (BUGSS)                                    */

OPT OSVERSION=37

MODULE 'intuition/screens'

ENUM OKAY,NOSCREEN,NOSIG

PROC main() HANDLE
  DEF s=NIL,sig=-1,name
  IF (s:=OpenScreenTagList(0,          /* ouvre notre écran publique */
         [SA_DEPTH,2,
          SA_DISPLAYID,$8000,
          SA_PUBNAME,name:='PublicShell',
          SA_TITLE,name,
          SA_PUBSIG,IF (sig:=AllocSignal(-1))=NIL THEN Raise(NOSIG) ELSE sig,
          SA_PUBTASK,NIL,
          0,0]))=NIL THEN Raise(NOSCREEN)
  PubScreenStatus(s,0)                 /* le rend accessible */
  SetDefaultPubScreen(name)
  SetPubScreenModes(SHANGHAI)
  Execute('NewShell WINDOW CON:0/0/640/256/bla/NOBORDER/BACKDROP',NIL,NIL)
    /* d'autre applications peuvent utiliser notre écran aussi
       si on veut juste notre shell, on le rend privée de nouveau */
  Wait(Shl(1,sig))            /* attend que toutes les fenêtre soient fermées */
  SetDefaultPubScreen(NIL)    /* le workbench est de nouveau par défaut */
  Raise(OKAY)
EXCEPT
  IF s THEN CloseS(s)
  IF sig>=0 THEN FreeSignal(sig)
  IF exception=NOSCREEN
    WriteF('Ne peut ouvrir l''écran !\n')
  ELSEIF exception=NOSIG
    WriteF('Pas de signal possible !\n')
  ENDIF
ENDPROC
