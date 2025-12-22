/* PubScreenNames.e
 * Affiche le nom et quelques atres attributs d'écrans public ouverts
 * Teste aussi la présence d'écran particulier.
 *
 * Domaine Public par Diego Caravana.
 * ( Source traduit par Olivier ANH (BUGSS) )
 *
 * Merci à Wouter van Oortmerssen pour son TRES BON travail, en espérant
 * qu'il continuera a programmer en E !
 *
 * Hé, apprenez le E !!!
 *
 */

/* TAB=4 */

OPT OSVERSION=37

/* Ici les OBJECTs qu'on utilise pour copier les données inhérentes aux écrans
 * public. Copier les données est nécessaire car le vérroulliage (lock) de la
 * liste (PubScreen List) doit être le plus court possible (voir les autodocs
 * de Commodore). C'est due au fait que la liste ne peut être modifiée (i.e.
 * aucune fnêtre ne peut s'ouvrir ou se fermer) tant qu'elle est verrouillée
 * par un tache.
 */

OBJECT mypubscreen
        name, flags:INT, visitorcnt:INT, screen, task, next
ENDOBJECT

MODULE 'intuition/screens', 'exec/lists', 'exec/nodes'

CONST ARGS_NUM=2
ENUM  ARG_FULL, ARG_EXISTS

ENUM ERR_NONE=0, ERR_PUBLOCK, ERR_MEM, ERR_WRONGARGS, OK_FOUND, OK_NOTFOUND

DEF     localpslist:mypubscreen, strflags[25]:STRING, args[ARGS_NUM]:ARRAY OF LONG

RAISE ERR_MEM           IF String()=NIL,
          ERR_PUBLOCK   IF LockPubScreenList()=NIL,
          ERR_WRONGARGS IF ReadArgs()=NIL,
          ERR_MEM               IF New()=NIL

PROC main() HANDLE
DEF pslist:PTR TO lh, psnode:PTR TO ln, i=0, localpsnode:PTR TO mypubscreen,
        pubscreen:PTR TO pubscreennode, publock=NIL, rdargs=NIL

        VOID '$VER: PubScreenNames 1.1 (13.02.93) par Diego Caravana'

        rdargs := ReadArgs('FULL/S,EXISTS/K', args, 0)

        /* Prend la liste des écran public ;
         * Elle ne sera pas modifiée pendant la lecture
         */
        publock := LockPubScreenList()

        /* première boucle : copie toutes les données nécessaires le plus vite possible
         */
        pslist := publock
        psnode := pslist.head
        localpsnode := localpslist

        WHILE psnode.succ <> NIL

                /* teste si un écran EXISTS avec un nom spécifié
                 */
                IF StrCmp(psnode.name, args[ARG_EXISTS], ALL) THEN Raise(OK_FOUND)

                /* alloue une chaine dynamique pour reduire la mémoire utilisée
                 * car les STRINGs ne sont pas permises (bientôt, j'espère :)
                 * dans les OBJECTs
                 */
                localpsnode.name:=String(StrLen(psnode.name)+2)
                StrCopy(localpsnode.name, psnode.name, ALL)
                IF args[ARG_FULL]=-1    /* copy only if needed */
                        pubscreen:=psnode
                        localpsnode.flags:=pubscreen.flags
                        localpsnode.visitorcnt:=pubscreen.visitorcount
                        localpsnode.task:=pubscreen.sigtask
                        localpsnode.screen:=pubscreen.screen
                ENDIF

                /* alloue un OBJECT pour contenir les informations du
                 * prochain écran
                 */
                localpsnode.next:=New(SIZEOF mypubscreen)

                /* change les pointeurs pour éxaminer la chaine
                 */
                localpsnode:=localpsnode.next
                psnode:=psnode.succ
        ENDWHILE

        UnlockPubScreenList()
        publock:=NIL    /* pour mémoire que l'on a déverrouillé (release the lock)*/

        /* à ce point, si un nom d'écran est spécifié avec EXIST, il n'a pas
         * été trouvé comme Ecran Public (Public Screen) dans la boucle
         * précédente, on peut alors sortir avec une code de retour null
         */
        IF StrLen(args[ARG_EXISTS]) <> 0 THEN Raise(OK_NOTFOUND)

        /* imprime l'entête avec la description des champs
     */
        IF args[ARG_FULL]=-1    /* imprime le bon ! */
                WriteF('\n N. Nom               Visiteurs Ecran      Tache      Flags\n')
                WriteF(  ' ---------------------------------------------------------------------------\n')
        ELSE
                WriteF('\n N. Nom\n')
                WriteF(  ' ----------------------\n')
        ENDIF

        /* Seconde boucle : imprime toutes les données
         */
        localpsnode:=localpslist
        WHILE localpsnode.next <> NIL
                i++

                IF args[ARG_FULL]=-1    /* choisir les infos à imprimer */

                        /* not-so-simple code: the two flags are independent by one another
                         * and also we want a "|" (OR in C) put between them; then, there
                         * is a default string which is used when no flag is set
                         */
                        StrCopy(strflags,'<No Flags Set>',ALL)
                        IF localpsnode.flags AND SHANGHAI
                                StrCopy(strflags,'SHANGHAI',ALL)
                                IF localpsnode.flags AND POPPUBSCREEN
                                        StrAdd(strflags,'|POPPUBSCREEN',ALL)
                                ENDIF
                        ELSE
                                IF localpsnode.flags AND POPPUBSCREEN
                                        StrCopy(strflags,'POPPUBSCREEN',ALL)
                                ENDIF
                        ENDIF

                        WriteF(' \l\d[2] \l\s[18]    \l\d[3]   $\z\h[8]  $\z\h[8]  \l\s\n',
                                i, localpsnode.name, localpsnode.visitorcnt,
                                localpsnode.screen, localpsnode.task, strflags )
                ELSE
                        WriteF(' \l\d[2] \l\s[18]\n', i, localpsnode.name)
                ENDIF

                localpsnode:=localpsnode.next
        ENDWHILE
        WriteF('\n Trouvé \d Public Screen(s)\n\n', i)

        Raise(ERR_NONE)

EXCEPT
        IF publock THEN UnlockPubScreenList()
    IF rdargs THEN FreeArgs(rdargs)

        SELECT exception
                CASE ERR_NONE;
                CASE OK_FOUND;          CleanUp(5)              /* Si WARN, ce sera vrai (true) */
                CASE OK_NOTFOUND;       CleanUp(0)
                CASE ERR_PUBLOCK;       WriteF('*** Ne peut obtenir les infos sur PubScreen !\n')
                CASE ERR_MEM;           WriteF('*** Pas de  mémoire !\n')
                DEFAULT;                        PrintFault(IoErr(), '*** Erreur')
        ENDSELECT

        IF exception THEN CleanUp(10)
        CleanUp(0)

ENDPROC
