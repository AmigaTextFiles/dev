


ENUM OK,ER_RT,ER_PIP,ER_ALLOC,ER_SET

MODULE 'reqtools','libraries/reqtools','dos/var','utility/tagitem'

ENUM STR,TIT,FILL,GAD,TEXT,LIGHT,SVAR,CVAR,GLOB,PUB,NUMARGS

CONST STRSIZE=256

RAISE ER_RT IF OpenLibrary()=NIL,
      ER_ALLOC IF RtAllocRequestA()=NIL,
      OK IF RtGetStringA()=NIL,
      ER_PIP IF StrCmp()=TRUE,
      ER_SET IF SetVar()=NIL


DEF args[NUMARGS]:ARRAY OF LONG,readargs=NIL,temp,x,gs,
    strbuf[256]:STRING,req,pip,endgad[4]:STRING



PROC main() HANDLE

    IF KickVersion(37)=FALSE
       Write(stdout,'os 2.04+ required\n',18)
       Raise(OK)
    ENDIF


    VOID '$VER: GetString 1.23 (17.01.97) by Grio'


    reqtoolsbase:=OpenLibrary('reqtools.library',38)

    FOR x:=0 TO NUMARGS-1 DO args[x]:=NIL


    temp:= 'String,Title,NoFill/S,Gads/K,Text/K,LightText/S,SV=StringVar/K,'+
           'CV=ChoiceVar/K,Global/S,PubScreen/K'

    IF (readargs:=ReadArgs(temp,args,NIL))=NIL
       PrintFault(IoErr(),NIL)
       Raise(OK)
    ENDIF

    IF args[STR] THEN StrCopy(strbuf,args[STR],STRSIZE)

    IF args[GAD]
        pip:='|'
        StrCmp(args[GAD],pip,1)
        MidStr(endgad,args[GAD],StrLen(args[GAD])-1,1)
        StrCmp(endgad,pip,1)
        IF InStr(args[GAD],pip,1)=-1 THEN Raise(ER_PIP)
        IF InStr(args[GAD],'||',1)>0 THEN Raise(ER_PIP)
    ENDIF


    req:=RtAllocRequestA(RT_REQINFO,NIL)
    gs:=RtGetStringA(strbuf,STRSIZE,args[TIT],req,
                    [RTGS_BACKFILL,
                     IF args[FILL] THEN FALSE ELSE TRUE,
                     RT_PUBSCRNAME,args[PUB],
                     RT_REQPOS,REQPOS_POINTER,
                     RTGS_FLAGS,
                     IF args[LIGHT] AND args[TEXT]
                     THEN GSREQF_HIGHLIGHTTEXT OR GSREQF_CENTERTEXT
                     ELSE GSREQF_CENTERTEXT,
                     RTGS_TEXTFMT,args[TEXT],
                     IF args[GAD] THEN RTGS_GADFMT ELSE NIL,
                     args[GAD],
                     RT_UNDERSCORE,"_",
                     TAG_DONE])

    IF args[GLOB] THEN
       args[GLOB]:=GVF_GLOBAL_ONLY ELSE args[GLOB]:=GVF_LOCAL_ONLY

    SetVar(IF args[SVAR] THEN args[SVAR] ELSE 'GetStringResult',
              strbuf,StrLen(strbuf), args[GLOB] )


    IF args[CVAR]
       StringF(endgad,'\d',gs)
       gs:=NIL
       SetVar(args[CVAR],endgad,StrLen(endgad),args[GLOB])
    ENDIF



EXCEPT DO

  IF readargs THEN FreeArgs(readargs)
  IF req THEN RtFreeRequest(req)
  IF reqtoolsbase THEN CloseLibrary(reqtoolsbase)

  IF exception
     SELECT exception
         CASE ER_RT
              temp:='could not open reqtools.library v38\n'
         CASE ER_PIP
              temp:='bad entering "|" sign\n'
         CASE ER_ALLOC
              temp:='unable to allocate requester\n'
         CASE ER_SET
              temp:='can\at set variable\n'
     ENDSELECT
     PrintF(temp)
  ENDIF

ENDPROC gs






