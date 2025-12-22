OPT OSVERSION=37

MODULE 'tools/async',
       'tools/ctype',
       'tools/easygui',
       'amigalib/lists',
       'dos/dos',
       'exec/lists',
       'exec/nodes',
       'intuition/intuition',
       'libraries/asl',
       'asl'

ENUM ERR_NONE, ERR_ADOS, ERR_ASL, ERR_EXAM, ERR_EXNEXT, ERR_GUI,
     ERR_LIB, ERR_LOCK, ERR_OPEN, ERR_PATT, ERR_QUIT, ERR_STOP,
     ERR_STR, NUM_ERRS

RAISE ERR_ADOS  IF AllocDosObject()=NIL,
      ERR_ASL   IF AllocAslRequest()=NIL,
      ERR_EXAM  IF Examine()=FALSE,
      ERR_LIB   IF OpenLibrary()=NIL,
      ERR_LOCK  IF Lock()=NIL,
      ERR_PATT  IF ParsePattern()=-1,
      ERR_PATT  IF ParsePatternNoCase()=-1,
      ERR_STR   IF String()=NIL

CONST MAXSTR=100, BUFFERSIZE=1000

CONST MAXPATT=MAXSTR*2+2

-> String gadgets
DEF xfindstr[MAXSTR]:STRING, xdirstr[MAXSTR]:STRING,
    findstr[MAXSTR]:STRING, dirstr[MAXSTR]:STRING,
    findgad, dirgad,
    xfpattstr[MAXSTR]:STRING, fpattstr[MAXSTR]:STRING, fpattgad,
    fpattbuff[MAXPATT]:STRING

-> Other gadgets
DEF reslist=NIL:PTR TO lh, resgad, gogad,
    xrec=TRUE, xcase=TRUE, xword=FALSE, xbrief=FALSE,
    rec, case, word, brief,
    xpatt=FALSE, patt, pattbuff[MAXPATT]:STRING

-> Other globals
DEF ready=TRUE, gh=NIL:PTR TO guihandle, path[MAXSTR]:STRING,
    findfunc=NIL, freq=NIL:PTR TO filerequester

PROC main() HANDLE
  StrCopy(xfpattstr, '#?')
  newList(NEW reslist)
  easyguiA({prog},
           [EQROWS,
              findgad:=[STR,{s_ignore},'_Find:',xfindstr,MAXSTR,10,0,0,"f"],
              [COLS,
                 [SPACEH],
                 [CHECK,{c_patt},'P_attern?',xpatt,TRUE,0,"a"],
                 [CHECK,{c_case},'_Case sensitive?',xcase,TRUE,0,"c"],
                 [CHECK,{c_word},'_Whole word?',xword,TRUE,0,"w"]
              ],
              [BAR],
              [COLS,
                 dirgad:=[STR,{s_ignore},'_Directory:',xdirstr,MAXSTR,10,0,0,"d"],
                 [BUTTON,{b_pick},'Pic_k...',0,"k"]
              ],
              [COLS,
                 fpattgad:=[STR,{s_ignore},'File _Pattern:',xfpattstr,MAXSTR,5,0,0,"p"],
                 [CHECK,{c_rec},'_Recursive?',xrec,TRUE,0,"r"],
                 [CHECK,{c_brief},'_Brief output?',xbrief,TRUE,0,"b"]
              ],
              [BAR],
              [TEXT,'Results:',NIL,FALSE,5],
              resgad:=[LISTV,{l_ignore},'',25,10,reslist,FALSE,0,0],
              [BAR],
              [COLS,
                 [SPACEH],
                 gogad:=[BUTTON,{b_go},'_GO!',0,"g",0,FALSE],
                 [SPACEH],
                 [BUTTON,{b_stop},'_Stop',0,"s"],
                 [SPACEH],
                 [BUTTON,{b_quit},'_Quit',0,"q"],
                 [SPACEH]
              ]
           ],
           [EG_GHVAR,{gh}, NIL])
EXCEPT DO
  IF reslist
    freeNodes(reslist)
    END reslist
  ENDIF
  IF freq THEN FreeAslRequest(freq)
  IF aslbase THEN CloseLibrary(aslbase)
ENDPROC

PROC s_ignore(info, str) IS 0
PROC l_ignore(info, x) IS 0

-> Action functions for option gadgets
PROC c_case(info,bool) IS xcase:=bool
PROC c_word(info,bool) IS xword:=bool
PROC c_rec(info,bool) IS xrec:=bool
PROC c_brief(info,bool) IS xbrief:=bool
PROC c_patt(info,bool) IS xpatt:=bool

PROC b_pick(info)
  IF aslbase=NIL
    aslbase:=OpenLibrary('asl.library', 37)
    -> Only initialise once so position, path, etc. remembered.
    freq:=AllocAslRequest(ASL_FILEREQUEST,
                         [ASLFR_WINDOW,      gh.wnd,
                          ASLFR_TITLETEXT,   'Pick a Directory',
                          ASLFR_DRAWERSONLY, TRUE,
                          NIL])
  ENDIF
  IF RequestFile(freq) THEN setstr(gh, dirgad, freq.drawer)
ENDPROC

PROC b_go(info)
  -> Only go if not already going!
  IF ready
    ready:=FALSE
    go()
    ready:=TRUE
  ENDIF
ENDPROC

PROC b_stop(info)
  -> Interrupt if going
  IF ready=FALSE THEN Raise(ERR_STOP)
ENDPROC

PROC b_quit(info) IS Raise(ERR_QUIT)

-> Copy current gadget values.
PROC copygadgets()
  -> Extract the current strings from the text gadgets.
  getstr(gh,findgad); getstr(gh,dirgad)
  StrCopy(findstr, xfindstr); StrCopy(dirstr, xdirstr)
  rec:=xrec; case:=xcase; word:=xword; brief:=xbrief
  getstr(gh,fpattgad)
  StrCopy(fpattstr, xfpattstr)
  patt:=xpatt
ENDPROC

-> Just scan the selected directory.
PROC go() HANDLE
  DEF tmp[MAXSTR]:STRING, p
  setdisabled(gh,gogad)
  -> Get a copy of current gadget values.
  copygadgets()
  -> Not much to do if the string is empty...
  IF EstrLen(findstr)=0 THEN Raise()
  -> Empty the list and redisplay it.
  setlistvlabels(gh, resgad, -1)
  freeNodes(reslist)
  setlistvlabels(gh, resgad, reslist)
  IF patt
    p:=IF word THEN '((#?[~A-Za-z0-9])|%)' ELSE '#?'
    StrCopy(tmp, p); StrAdd(tmp, findstr); StrAdd(tmp, p)
    IF case
      ParsePattern(tmp, pattbuff, MAXPATT)
      findfunc:={find_patt_case}
    ELSE
      ParsePatternNoCase(tmp, pattbuff, MAXPATT)
      findfunc:={find_patt_nocase}
    ENDIF
  ELSEIF case
    findfunc:=IF word THEN {find_word_case} ELSE {find_case}
  ELSE
    -> Make the findstr lowercase if ignoring case differences.
    LowerStr(findstr)
    findfunc:=IF word THEN {find_word_nocase} ELSE {find_nocase}
  ENDIF
  -> Set up pattern buffer.
  ParsePatternNoCase(fpattstr, fpattbuff, MAXPATT)
  scandir(dirstr)
EXCEPT DO
  -> Re-enable the 'Go!' gadget.
  setdisabled(gh,gogad,FALSE)
  IF exception=ERR_QUIT THEN ReThrow()
ENDPROC

-> The start of the real work.
PROC scandir(s) HANDLE
  DEF lock=NIL, fib=NIL:PTR TO fileinfoblock, oldlock, len
  len:=EstrLen(path)
  lock:=Lock(s, ACCESS_READ)
  oldlock:=CurrentDir(lock)
  fib:=AllocDosObject(DOS_FIB, NIL)
  -> Examine the file.
  Examine(lock, fib)
  IF fib.direntrytype>=0
    -> It's a directory, so examine all the files it contains.
    WHILE ExNext(lock, fib)
      checkgui(gh)
      IF fib.direntrytype<0
        IF MatchPatternNoCase(fpattbuff, fib.filename)
          scanfile(fib.filename)
        ENDIF
      ELSEIF rec
        -> If directory then call recursively.
        StrAdd(path, fib.filename); StrAdd(path, '/')
        scandir(fib.filename)
        SetStr(path, len)
      ENDIF
    ENDWHILE
    IF IoErr()<>ERROR_NO_MORE_ENTRIES THEN Raise(ERR_EXNEXT)
  ENDIF
EXCEPT DO
  SetStr(path, len)
  IF fib THEN FreeDosObject(DOS_FIB, fib)
  IF lock
    CurrentDir(oldlock)
    UnLock(lock)
  ENDIF
  SELECT NUM_ERRS OF exception
  CASE ERR_ADOS, ERR_EXAM, ERR_EXNEXT, ERR_LOCK
  DEFAULT
    ReThrow()
  ENDSELECT
ENDPROC

-> The real work.  Search the file for the findstr.
PROC scanfile(file) HANDLE
  DEF fh=NIL, buffer[BUFFERSIZE]:STRING, line=1
  fh:=myopen(file, OLDFILE)
  WHILE myreadstr(fh, buffer)
    checkgui(gh)
    IF findfunc(buffer)
      report(file, buffer, line)
      -> Stop here if being brief.
      IF brief THEN Raise()
    ENDIF
    INC line
  ENDWHILE
EXCEPT DO
  IF fh THEN myclose(fh)
  IF exception<>ERR_OPEN THEN ReThrow()
ENDPROC

-> Use as_Open from tools/async
PROC myopen(file, mode)
  DEF fh
  IF fh:=as_Open(file, mode, 3, 5000)
    RETURN fh
  ELSE
    Raise(ERR_OPEN)
  ENDIF
ENDPROC

-> Close the file opened with myopen().
PROC myclose(fh) IS as_Close(fh)

-> Return FALSE (or NIL) if failed to read string.
PROC myreadstr(fh, s)
  DEF res
  IF res:=as_FGetS(fh, s, StrMax(s)) THEN SetStr(s, StrLen(s))
ENDPROC res

-> Try to find findstr in s (case sensitive)
PROC find_case(s) IS InStr(s, findstr)<>-1

-> Try to find the word findstr in s (case sensitive)
PROC find_word_case(s)
  DEF i=0, len
  len:=EstrLen(s)
  WHILE i<len
    IF -1=(i:=InStr(s, findstr, i))
      RETURN FALSE
    ELSEIF isword(s, i, EstrLen(findstr))
      RETURN TRUE
    ELSE
      INC i
    ENDIF
  ENDWHILE
ENDPROC FALSE

-> Try to find findstr in s (not case sensitive)
PROC find_nocase(s) IS lower_find(s, {find_case})

-> Try to find the word findstr in s (not case sensitive)
PROC find_word_nocase(s) IS lower_find(s, {find_word_case})

PROC find_patt_case(s) IS MatchPattern(pattbuff, s)
PROC find_patt_nocase(s) IS MatchPatternNoCase(pattbuff, s)

-> Try to find after lowercasing a copy of s.
PROC lower_find(s, real_find)
  DEF tmp[MAXSTR]:STRING
  StrCopy(tmp, s)
  LowerStr(tmp)
ENDPROC real_find(tmp)

-> Is the bit between i and i+len a complete word in s?
PROC isword(s, i, len)
  IF i>0 THEN IF isalnum(s[i-1]) THEN RETURN FALSE
  RETURN isalnum(s[i+len])=FALSE
ENDPROC

-> Report the find and update list.
PROC report(f, s, n)
  setlistvlabels(gh, resgad, -1)
  addNode(reslist, f, s, n)
  setlistvlabels(gh, resgad, reslist)
ENDPROC

-> Add a new node to the list.
PROC addNode(list, f, s, n) HANDLE
  DEF node=NIL:PTR TO ln, len
  NEW node
  len:=EstrLen(path)+StrLen(f)+10
  IF brief
    node.name:=String(len)
    StringF(node.name, '\s\s (\d)', path, f, n)
  ELSE
    filter(s)
    node.name:=String(len+EstrLen(s)+4)
    StringF(node.name, '\s\s (\d) -> \s', path, f, n, s)
  ENDIF
  AddTail(list, node)
EXCEPT
  IF node
    IF node.name THEN DisposeLink(node.name)
    END node
  ENDIF
  ReThrow()
ENDPROC

-> Free a list of nodes and empty it.
PROC freeNodes(list:PTR TO lh)
  DEF worknode:PTR TO ln, nextnode
  worknode:=list.head  -> First node.
  WHILE nextnode:=worknode.succ
    IF worknode.name THEN DisposeLink(worknode.name)
    END worknode
    worknode:=nextnode
  ENDWHILE
  newList(list)
ENDPROC

-> Convert non-printing chars to " " or ".".
PROC filter(s)
  WHILE s[]
    IF 0=(s[] AND $60)
      SELECT $E OF s[]
      CASE $0
        -> Leave this alone!
      CASE $8, $A, $D
        -> TAB, linefeed, carriage return.
        s[]:=" "
      DEFAULT
        s[]:="."
      ENDSELECT
    ENDIF
    s++
  ENDWHILE
ENDPROC

  CHAR 0, '$VER:'
prog:
 CHAR ' FindString 1.3', 0, 0
