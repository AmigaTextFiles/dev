/* Regarde un fichier par notification

Affiche une requête qund un fichier est modifié.
USAGE: watch <file>
EXEMPLE: run >NIL: watch >NIL: s:startup-sequence

A besoin de la v37

"regarde" simplement un fichier, en utilisant le nouveau système
de notification du kick 2.0.
Note : il ne vous prévient pas que le fichier va être modifié, il
vous le dit juste.
Utile, par exemple, si vous installez un nouveau programme, et vous
voulez savoir ce que fait l'Installer fait quelque chose à votre
startup-sequence ou votre user-startup.

Notez que la seule façon d'arrêter Watch est de modifier le fichier
(ou de rebooter :-)

*/

OPT OSVERSION=37

MODULE 'dos/notify'

PROC main()                       /* s'assure que le fichier est là:  */
  DEF nreq:PTR TO notifyrequest,sig,task    /* sinon on n'aura jamais */
  IF (FileLength(arg)=-1) OR (arg[0]=0)     /* de notification        */
    WriteF('file "\s" does not exist\n',arg)
    CleanUp(10)
  ENDIF
  nreq:=New(SIZEOF notifyrequest)     /* mémoire vidée */
  IF nreq=NIL THEN RETURN 20
  sig:=AllocSignal(-1)                /* on veux être prévenu */
  IF sig=-1 THEN RETURN 10
  task:=FindTask(0)
  nreq.name:=arg                      /* rempli dans la structure */
  nreq.flags:=NRF_SEND_SIGNAL
  nreq.port:=task                     /* union port/task */
  nreq.signalnum:=sig
  IF StartNotify(nreq)
    WriteF('Now watching: "\s"\n',arg)
    Wait(Shl(1,sig))
    EasyRequestArgs(0,[20,0,0,'Le fichier "\s" a été modifié!','Zut!'],0,[arg])
    EndNotify(nreq)
  ELSE
    WriteF('Ne peut pas regarder "\s".\n',arg)
  ENDIF
  FreeSignal(sig)
ENDPROC
