/* FOLD info
        ~~~~ */

/* ARexxPort.e 1.0 - par Leon Woestenberg (leon@stack.urc.tue.nl) */
/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
/*

   Je présente ici quelques fonctions de base pour rendre vos
   programmes E capable de communiquer avec d'autres programmes
   multitaches via AREXX. Avec ces fonctions vos programmes
   pourront:

   · Recevoir et réagir aux commandes ARexx qui ont été envoyé.
   · Appeler Rexx Master pour lancer des commandes que votre programme
     ne comprend pas. Ce peut être des script AREXX (dans REXX:) aussi.
   · Envoyer des commandes AREXX à d'autres programmes ou à Rxx Master.

   Ce source est du domaine public alors utilisez le :)

   Le source est abondamment commeté et s'explqie quasiment par lui-même.
   La chse la plus dur est : Quand un message AREXX arrivant contient
   une commande qui n'est pas supporté par votre programme, ce message
   n'est pas renvoyé DE SUITE. D'abord, un nouveau message est créé et
   envoyé à Rexx Master. On peut enlever  le premier message de la mémoire
   (en utilisant le pointeur). De cette façon, les scripts AREXX peuvent
   être utilisé avec des commandes AREXX. Notez que l'extension par défaut
   de ces scripts peut être adapté à votre programme dans la procédure
   sendRexxMsg.

   ARexx ajoute une grande possibilité à votre Amiga multitache, comme
   des taches qui interagissent en temps réel entre eux, comme ça il peuvent
   utiliser les caractèristique des autres. Pensez au possibilité offerte à
   vos programmes étendus avec une interface ARexx.

   Si vous avez des questions, suggestions, ou report d'erreurs, joignez moi
   via Internet. Les questions/discussions générale sur ce source sont
   aussi les bienvenues sur l'Amiga E mailing list.

                              Leon Woestenberg (leon@stack.urc.tue.nl)

*/
/* FEND */
/* FOLD "modules" */

MODULE 'exec/ports','exec/nodes'
MODULE 'rexxsyslib','rexx/rexxio','rexx/rxslib','rexx/errors','rexx/storage'
MODULE 'dos/dos'

/* FEND */
/* FOLD "definitions" */

DEF hostport=NIL:PTR TO mp
DEF runflag=TRUE
DEF unconfirmed=0

/* FEND */

/* FOLD "main" */
PROC main() HANDLE

  /* open rexx library */
  IF (rexxsysbase:=OpenLibrary('rexxsyslib.library',0))

    /* créé un port hôte pour arexx */
    IF (hostport:=createPort('HoteExemple',0))

    /* exemples de votre proramme envoyant des cxommandes arexx à d'autres
       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    /*

    /* Dit à GoldED de déplacer le curseur d'une ligne vers le haut */
    sendRexxMsg('GOLDED.1','UP',NIL,0)

    /* dit au shell d'éxécuter la commande list */
    sendRexxMsg('REXX','"ADDRESS COMMAND list"',NIL,0)

    /* lance un script depuis REXX: (mettez l'extension par défaut dans sendRexxMsg) */
    sendRexxMsg('REXX','scriptname',NIL,0)

    /* envoie une commande 'QUIT' à nous même :o) */
    sendRexxMsg('HoteExemple','QUIT',NIL,0)

    */

    /* informe l'utilisateur que ça marche */
    WriteF('Attend des évènements. Envoyez moi une commande arexx QUIT en tapant:\nrx "ADDRESS \aHoteExemple\a; QUIT" depuis un shell. Ou pressez CTRL-C pour m\aarrêter.\n')

    /* attend */
    wait()

    deletePort(hostport)
    ELSE
      WriteF('Désolé bonhomme, je crois que je tourne déja une fois.\n')
    ENDIF
    CloseLibrary(rexxsysbase)
  ELSE
    WriteF('Ne peut pas ouvrir la rexxsyslib.library. J\aen ai vraiment besoin!\n')
  ENDIF
EXCEPT
  WriteF('Quleque chose comme \d n'a pas marché, tu vois?\n')
  deletePort(hostport)
  hostport:=NIL
  IF rexxsysbase
    CloseLibrary(rexxsysbase)
    rexxsysbase:=NIL
  ENDIF
ENDPROC
/* FEND */
/* FOLD "wait" */
PROC wait()

  DEF signalmask=0
  DEF hostmask=0

  /* masque signal pour notre port hôte */
  hostmask:=Shl(1,hostport.sigbit)

  /* continue à tourner ou messages non confirmés? */
  WHILE runflag OR unconfirmed

    /* attend les signaux d'évènements */
    signalmask:=Wait(hostmask OR SIGBREAKF_CTRL_C)

    /* et gère les évènements qui arrive */
    IF signalmask AND hostmask THEN handleRexxMsg()
    IF signalmask AND SIGBREAKF_CTRL_C THEN runflag:=FALSE

  ENDWHILE
ENDPROC
/* FEND */

/* FOLD "handleRexxMsg" */
PROC handleRexxMsg()

  /* pointeur sur le message à gérer */
  DEF rexxmsg:PTR TO rexxmsg
  /* pointeur sur messagenode */
  DEF msgnode:PTR TO mn
  /* pointeur sur la liste de noeuds du message */
  DEF listnode:PTR TO ln

  /* liste de 16 pointers sur les chaines de commande */
  DEF rexxargs:PTR TO LONG

  /* pointe sur le premier caractère de la commande */
  DEF command:PTR TO CHAR

  /* (un autre) message à la queue? */
  WHILE rexxmsg:=GetMsg(hostport)

    /* met le pointeur sur messagenode */
    msgnode:=rexxmsg.mn

    /* met le pointeur sur la liste de noeuds */
    listnode:=msgnode.ln

    /* met le pointeur sur les commands */
    rexxargs:=rexxmsg.args

    /* réponse de confirmation d'un message envoyé par nous? */
    IF listnode.type=NT_REPLYMSG

      /* original message pointer present? */
      IF rexxargs[15]
        /* répond au message original */
        ReplyMsg(rexxargs[15])
      ENDIF

      /* efface ce message de confirmation */
      DeleteArgstring(rexxargs[0])
      DeleteRexxMsg(rexxmsg)

      /* diminue le compteur non-confirmé */
      DEC unconfirmed

    /* un tout nouveau message */
    ELSE

      /* pointe sur la commande après avoir sautés les espaces etc. */
      command:=TrimStr(rexxargs[0])
      WriteF('We received an ARexx command: \s\n',command)

      /* initialise les codes sortants */
      rexxmsg.result1:=0
      rexxmsg.result2:=NIL

      /* exemple de gestion d'une commande que quequ'un nous a envoyé
         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

      /* command known? */
      IF StrCmp('QUIT',command,ALL)
        WriteF('So let\as quit here.\n')
        runflag:=FALSE
        ReplyMsg(rexxmsg)

      /* commande inconnue */
      ELSE
        WriteF('Hmmm. Commance inconnue. On l'envoie à Rexx Master...\n')

        /* on fait suivre cette commande à rexx master (peut-être c'est un script?) */
        /* le message original n'est pas répondu pour le moment */
        /* tant qu'on n'a pas eu confirmation de rexx master. */
        /* Pour cela, on garde ce message dans un pointeur de message rexxargs[15] */
        /* in rexxargs[15] de la commande envoyée à Rexx Master */

        /* message ne peut pas être envoyé à rexx? */
        IF sendRexxMsg('REXX',rexxargs[0],rexxmsg,0)=NIL

          /* met le code de retour : erreur fatale */
          xReplyRexxCmd(rexxmsg,RC_FATAL,NIL)

          /* répond au message */
          ReplyMsg(rexxmsg)

        ENDIF
      ENDIF
    ENDIF
  ENDWHILE
ENDPROC
/* FEND */
/* FOLD "sendRexxMsg(hostname,command,unknownmsg,flags)" */
PROC sendRexxMsg(hostname,command,unknownmsg,flags)

  DEF arexxport=NIL:PTR TO mp
  DEF rexxmsg=NIL:PTR TO rexxmsg
  DEF rexxargs:PTR TO LONG
  DEF listnode=NIL:PTR TO ln
  DEF temp=NIL

  /* retourne si le port hôte n'est pas présent */
  IF hostport=NIL THEN RETURN NIL

  listnode:=hostport.ln

  /* retourne si on ne pas faire un message rexx */
  IF (rexxmsg:=CreateRexxMsg(hostport,'rexx',listnode.name))=NIL THEN RETURN NIL

  /* pointeur vers les commandes */
  rexxargs:=rexxmsg.args

  /* peut-on créer un argstring? */
  IF temp:=CreateArgstring(command,StrLen(command))

    /* met le premier argstring */
    rexxargs[0]:=temp

    /* met les flags */
    rexxmsg.action:=RXCOMM OR flags

    /* met le pointeur message original dans un pointeur chaine de 16 */
    rexxargs[15]:=unknownmsg

    /* interdit le multitache */
    Forbid()

    /* envoie notre message vers un port déja existant */
    IF (arexxport:=FindPort(hostname)) THEN PutMsg(arexxport,rexxmsg)

    /* permet le multitache */
    Permit()

    /* sended? */
    IF arexxport

      /* augmente le compteur de non-confirmé */
      INC unconfirmed

      /* messages envoyés avec succès */
      RETURN rexxmsg
    ENDIF
  ENDIF

  IF temp
    DeleteArgstring(temp)
  ENDIF
  IF rexxmsg
    DeleteRexxMsg(rexxmsg)
  ENDIF
  RETURN NIL
ENDPROC
/* FEND */
/* FOLD "replyRexxMsg(rexxmsg,rc,returnstring)" */
PROC xReplyRexxCmd(rexxmsg:PTR TO rexxmsg,rc,returnstring)

  /* met le code de retour */
  rexxmsg.result1:=rc

  /* et un pointeur sur la chaine sortante */
  rexxmsg.result2:=IF (rexxmsg.action AND RXFF_RESULT) AND (returnstring<>NIL) THEN CreateArgstring(returnstring,StrLen(returnstring)) ELSE NIL

ENDPROC
/* FEND */
/* FOLD "createPort(portname,priority)" */
PROC createPort(portname,priority)

  DEF port=NIL:PTR TO mp
  DEF node=NIL:PTR TO ln

  /* met le port public? */
  IF portname

    /* personne ne fait le même port SVP */
    Forbid()

    /* notre port va-t-il être unique ? */
    IF FindPort(portname)=0

      /* peut-on faire un port? */
      IF port:=CreateMsgPort()

        node:=port.ln

        /* rempli le nom */
        node.name:=portname

        /* priorité du port public */
        node.pri:=priority

        /* et fat ce port public */
        AddPort(port)
      ENDIF
    ENDIF

    /* multitache */
    Permit()

  /* fait juste un port privé */
  ELSE

    /* essaie de faire un port */
    port:=CreateMsgPort()

  ENDIF
/* retourne le pointeur au port, ou NIL si le port ne peut être fait (unique) */
ENDPROC port
/* FEND */
/* FOLD "deletePort(port)" */
PROC deletePort(port:PTR TO mp)

  DEF node=NIL:PTR TO ln
  DEF msg=NIL:PTR TO mn

  /* pointeur donné ? */
  IF port

    node:=port.ln

    /* si public alors enlêve de la liste public du port */
    IF node.name THEN RemPort(port)

    /* plus de message SVP */
    Forbid()

    /* enlêve tous les messages à la queue */
    WHILE msg:=GetMsg(port) DO ReplyMsg(msg)

    /* efface le port */
    DeleteMsgPort(port)

    /* multitache */
    Permit()
  ENDIF
ENDPROC
/* FEND */

