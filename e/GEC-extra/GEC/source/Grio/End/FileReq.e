


ENUM OK,ER_KICK,ER_RT,ER_ARGS,ER_ALLOC,ER_VAR

MODULE 'reqtools','libraries/reqtools','dos/var','utility/tagitem'

ENUM FILE,TIT,OKT,VOL,MLTI,SAVE,NOF,PAT,VAR,GLOB,COM,PUB,NUMARGS


RAISE ER_KICK IF KickVersion()=NIL,
      ER_RT IF OpenLibrary()=NIL,
      ER_ARGS IF ReadArgs()=NIL,
      ER_ALLOC IF RtAllocRequestA()=NIL,
      ER_VAR IF SetVar()=NIL,
      OK IF RtFileRequestA()=NIL

CONST STRSIZE=256


DEF args[NUMARGS]:ARRAY OF LONG,readargs=NIL,x,
    freq:PTR TO rtfilerequester,
    flist:PTR TO rtfilelist,dir[90]:STRING,
    name[34]:STRING,str[STRSIZE]:STRING,
    flstore,tags,stag,buf[110]:STRING,
    patt:PTR TO CHAR , tmp:PTR TO CHAR


PROC main() HANDLE


   VOID '$VER: FileReq 1.22 (03.01.97) by Grio'


   FOR x:=0 TO NUMARGS-1 DO args[x]:=NIL

   KickVersion(36)

   reqtoolsbase:=OpenLibrary('reqtools.library',38)

   tmp:='File,Title,OkTxt/K,Volume/S,Multi/S,Save/S,NoFiles/S,'+
        'Pattern/K,Var/K,Global/S,Comma/S,PubScreen/K'

   readargs:=ReadArgs(tmp,args,NIL)

   freq:=RtAllocRequestA(RT_FILEREQ,NIL)


   IF args[TIT]=NIL THEN args[TIT]:='Select something'

   IF args[VAR]=NIL THEN args[VAR]:='FileReqResult'

   IF args[GLOB] THEN
      args[GLOB]:=GVF_GLOBAL_ONLY ELSE args[GLOB]:=GVF_LOCAL_ONLY

   tags:=NIL

   IF args[VOL]
      stag:=RTFI_VOLUMEREQUEST
   ELSE
      stag:=RTFI_FLAGS
      IF args[FILE]
         x:=FilePart(args[FILE])
         StrCopy(dir,args[FILE],x-args[FILE])
         StrCopy(name,x,ALL)
      ENDIF
      IF args[PAT] THEN patt:=args[PAT] ELSE patt:='#?'
      RtChangeReqAttrA(freq,[RTFI_MATCHPAT,patt,RTFI_DIR,dir,TAG_DONE])
      IF args[MLTI] THEN tags:=FREQF_MULTISELECT
      IF args[PAT]  THEN tags:=tags+FREQF_PATGAD
      IF args[NOF]  THEN tags:=tags+FREQF_NOFILES
      IF args[SAVE] THEN tags:=tags+FREQF_SAVE
   ENDIF

   flist:=RtFileRequestA(freq,name,args[TIT],[
   RT_PUBSCRNAME,args[PUB],RT_REQPOS,REQPOS_POINTER,
   RT_UNDERSCORE,"_",RTFI_OKTEXT,args[OKT],
   stag,tags,TAG_DONE])

   StrCopy(dir,freq.dir,ALL)

   AddPart(dir,'',90)


   flstore:=flist

   IF args[COM] THEN tmp:='"\s\s"' ELSE tmp:='\s\s'

   IF args[MLTI]
      StrCopy(str,'')
      REPEAT
        StringF(buf,tmp,dir,flist.name)
        IF EstrLen(str)+EstrLen(buf) > STRSIZE THEN JUMP setstr
        StrAdd(str,buf,ALL)
        StrAdd(str,' ',1)
        flist:=flist.next
      UNTIL flist=NIL
   ELSE
      StringF(str,tmp,dir,name)
      flstore:=0
   ENDIF

setstr:

   SetVar(args[VAR],str,StrLen(str),args[GLOB])

EXCEPT DO
   IF readargs THEN FreeArgs(readargs)
   IF flstore THEN RtFreeFileList(flstore)
   IF freq THEN RtFreeRequest(freq)
   IF reqtoolsbase THEN CloseLibrary(reqtoolsbase)
   IF exception
      SELECT exception
         CASE ER_KICK
              Write(stdout,'os 2.0+ required\n',17)
         CASE ER_RT
              PrintF('could not open reqtools.library v38\n')
         CASE ER_ARGS
              PrintFault(IoErr(),NIL)
         CASE ER_ALLOC
              PrintF('can\at allocate requester\n')
         CASE ER_VAR
              PrintF('unable to set variable\n')
      ENDSELECT
   ENDIF
   CleanUp(0)
ENDPROC

