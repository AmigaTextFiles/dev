/****** args.m/--overview-- *******************************************
* 
*   PURPOSE
*       To provide ReadArgs() parsing for both CLI and WB.
* 
*   OVERVIEW
*       AmigaDOS 2.0 has a very powerful argument parser known as
*       ReadArgs(). It allows you to specify a simple template,
*       which describes how arguments will be parsed and will fill
*       an array of LONGs.
*
*       This module provides a readargs() call, which uses the
*       Workbench startup message to go through a list of selected icons'
*       tooltypes, and matches those tooltypes like arguments on the
*       command line.
*
*       Used in ShellScr by Kyzer/CSG
*
****************************************************************************
*
*
*/

->example:
->  IF rdargs := readargs('CX_PRIORITY/N, CX_POPKEY, CX_POPUP/S',
->                       args:=NEW [0,0,0], wbmessage)
->
->    cx_pri := IF args[0] THEN Long(args[0]) ELSE 0
->    hotkey := IF args[1] THEN args[1] ELSE 'ctrl alt del'
->    popup  := args[2]
->    [....]
->    FreeArgs(rdargs)
->  ENDIF

-> FIXES:
-> - (06.04.98) Gags when directories are selected. Fixed.
-> - (04.05.98) Fixed memory-trashing bug.
-> - (02.09.98) Stops quoting already-quoted strings

-> TODO:
-> - support =YES and =NO tooltypes in switches
-> - special case (list of icon names) to /M switched variables

OPT MODULE,OSVERSION=36

MODULE 'icon', 'dos/rdargs', 'workbench/startup', 'workbench/workbench'
DEF iconbase

-> Basically, we run through all the selected icons' tooltypes from
-> first (our own icon) to last. if the left part of a tooltype
-> (in 'BLA=FISH', the left part is 'BLA') is judged by DOS to be
-> a keyword from the template (this includes parsing aliases for
-> keywords) then we insert it and its right part (if there is one)
-> into a list in the appropriate place, which can overwrite tooltypes
-> already there (eg, selected icons override default settings in our
-> own icon). Once we have this list of keywords and values, we can make
-> a single string with all these keywords and values, and give it to
-> ReadArgs.

-> The code that splits a tooltype into left and right parts is clever
-> enough to ignore 'disabled' tooltypes which begin with '(', and also
-> ignores tooltypes beginning IM1= or IM2= for performance reasons (NewIcons
-> contain a lot of these tooltypes for their icon data)

EXPORT PROC readargs(template:PTR TO CHAR, args, wbmsg:PTR TO wbstartup) HANDLE
  DEF rdargs=NIL, tooltype, name, val, m, n, arg, dir, len,
      arglst=NIL:PTR TO LONG,     -> a list to all our args and their values
      dobj=NIL:PTR TO diskobject, -> diskobject of 'current icon'
      tooltypes:PTR TO LONG       -> tooltypes of 'current icon'

  -> If we were run from shell, then just parse as normal
  IF wbmsg = NIL THEN RETURN ReadArgs(template, args, NIL)

  -> make sure icon.library is available
  IF (iconbase := OpenLibrary('icon.library', 36))=NIL THEN Raise("LIB")

  -> make a big enough list to hold all name/value pairs for template
  IF (arglst := List(len :=getlistlen(template)))=NIL THEN Raise("MEM")
  DEC len

  -> Go through all tooltypes in all selected icons
  FOR m := 0 TO wbmsg.numargs - 1
    dir := CurrentDir(wbmsg.arglist[m].lock)
    dobj := GetDiskObject(wbmsg.arglist[m].name)
    CurrentDir(dir)

    IF dobj
      IF tooltypes := dobj.tooltypes
        WHILE tooltype := tooltypes[]++
          -> split up tooltype
          name, val := ttsplit(tooltype)
          IF name
            -> if in template, place into appropriate list entry
            IF (arg := FindArg(template, name)) <> -1
              n := Shl(arg, 1)
              IF arg := arglst[ n ] THEN DisposeLink(arg)
              IF arg := arglst[n+1] THEN DisposeLink(arg)
              arglst[ n ] := name
              arglst[n+1] := val
            ELSE
              IF name THEN DisposeLink(name)
              IF val  THEN DisposeLink(val)
            ENDIF
          ENDIF
        ENDWHILE
      ENDIF
      FreeDiskObject(dobj); dobj := NIL
    ENDIF
  ENDFOR

  -> calculate length of final 'arg string' to be parsed by ReadArgs()
  m := 0
  FOR n := 0 TO len DO IF arg := arglst[n] THEN m := m + 3 + EstrLen(arg)

  IF (m := String(m))=NIL THEN Raise("MEM")
  StrCopy(m, '')

  -> concatenate final arg settings into one big string
  FOR n:=0 TO len
    IF arg := arglst[n]
      -> append either 'arg ' or '"arg" ' if arg has spaces in it
      IF (InStr(arg, ' ') = -1) AND (arg[] <> "\q")
        StrAdd(m, arg)
        StrAdd(m, ' ')
      ELSE        
        StrAdd(m, '"')
        StrAdd(m, arg)
        StrAdd(m, '" ')
      ENDIF
    ENDIF
  ENDFOR

  -> perform the ReadArgs call on our constructed string
  rdargs := ReadArgs(template, args,
    [m, EstrLen(m), 0, NIL, NIL, 0, NIL, RDAF_NOPROMPT]
  )

  -> throw away big string
  DisposeLink(m)

EXCEPT DO
  IF arglst
    FOR n := 0 TO len
      IF arg := arglst[n] THEN DisposeLink(arg)
    ENDFOR
    DisposeLink(arglst)
  ENDIF

  IF dobj     THEN FreeDiskObject(dobj)
  IF iconbase THEN CloseLibrary(iconbase); iconbase := NIL

  ReThrow()
ENDPROC rdargs



PROC ttsplit(s:PTR TO CHAR)
  -> of something 'blah=foo', returns 'blah', 'foo'
  -> of something 'blah', returns 'blah', NIL
  -> of something beginning '(', 'IM1=' or 'IM2=', returns NIL, NIL

  DEF div, len, l, r

  -> ignore disabled tooltypes, newicon tooltypes, and blank ones
  IF s = NIL THEN RETURN NIL, NIL
  IF (s[]="(") OR (s[]="\0") OR
     StrCmp(s, 'IM1=', 4) OR StrCmp(s, 'IM2=', 4) THEN
    RETURN NIL, NIL

  len := StrLen(s)
  div := InStr(s, '=') -> find '=' divisor

  IF div = -1
    -> no '=' present in string - return copy of left half
    IF l := String(len) THEN StrCopy(l, s)
    RETURN l, NIL
  ENDIF

  -> allocate left and right strings
  l := String(div + 1)
  r := String(len - div)

  -> if either string allocation failed, free either and return NIL
  IF (l AND r)=NIL
    IF l THEN DisposeLink(l)
    IF r THEN DisposeLink(r)
    RETURN NIL, NIL
  ENDIF

  MidStr(l, s, 0, div) -> copy left of '=' to l
  MidStr(r, s, div+1) -> copy right of '=' to r
ENDPROC l, r

PROC getlistlen(template)
	MOVEQ	#1, D0
	MOVE.L	template, A0
__cnt:	MOVE.B	(A0)+, D1
	BEQ.S	__end
	CMP.B	#",", D1
	BNE.S	__cnt
	ADDQ	#1, D0
	BRA.S	__cnt
__end:	ASL.W	#1, D0
ENDPROC D0
