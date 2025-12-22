/********************************************************/
/* ChangeDefPubScreen v0.0a  © 1993 NasGûl              */
/********************************************************/
OPT OSVERSION=37                       /* OS 2.XX */
MODULE 'intuition/screens'             /* FOR SCREEN */
ENUM ARG_NAMESCR,ARG_INFO,NUMARGS      /* ARGUMENT CLI */
ENUM ER_NONE,ER_LOCKPUBSCR,ER_BADARGS  /* ERROR        */
DEF rdargs=NIL                         /* FOR ReadArgs() */
PROC main() HANDLE /*"main()"*/
    DEF args[NUMARGS]:LIST,templ,x                /* FOR ARGUMENT */
    DEF version[256]:STRING,pubname[256]:STRING   /* STRING VERSION,NAME OF THE DEFAULT PUBSCREEN */
    DEF scr                                       /* POINTER TO SCREEN */
    StrCopy(version,'$VER:ChangeDefPubScr v0.0a ® NasGûl (08-12-93)',50)
    FOR x:=0 TO NUMARGS-1 DO args[x]:=0
    templ:='NAME,INFO/S'
    rdargs:=ReadArgs(templ,args,NIL)
    IF rdargs=NIL THEN Raise(ER_BADARGS)
    IF args[ARG_INFO]
        GetDefaultPubScreen(pubname)
        Raise(ER_NONE)
    ENDIF
    IF args[ARG_NAMESCR] THEN StrCopy(pubname,args[ARG_NAMESCR],ALL) ELSE StrCopy(pubname,'Workbench',ALL)
    IF scr:=LockPubScreen(pubname)
        SetDefaultPubScreen(pubname)
        SetPubScreenModes(SHANGHAI)
        UnlockPubScreen(NIL,scr)
    ELSE
        Raise(ER_LOCKPUBSCR)
    ENDIF
    Raise(ER_NONE)
EXCEPT
    SELECT exception
        CASE ER_BADARGS;    WriteF('Mauvais paramètre(s) !\n')
        CASE ER_LOCKPUBSCR; WriteF('L\aécran public spécifié n\aexiste pas !\n')
        CASE ER_NONE;       WriteF('Nouveau PublicScreen par défaut :\s.\n',pubname)
    ENDSELECT
ENDPROC




