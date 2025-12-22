/* very similar to RawDoFmt() or StringF() but you can define your
** own format commands.
**
** An command looks like
**     keychar[flags][width[.limit]]type
**
** The commands in [] are optional.
**   'keychar' - key character specified by you (usually "%")
**   'flags'   - set to '-' for left justification
**   'width'   - fieldwidth
**   'limit'   - maximum width of an string (works only with PARG_Type_String)
**   'type'    - an valid format command specified by you (letters and "_" only!!)
**
** to print an 'keychar'-character just write 2 of them.
*/

OPT MODULE
OPT REG=5

MODULE 'sven/support/string',
       'sven/support/newrealf',
       'sven/memset',
       'sven/patternArgs'

EXPORT CONST CPD_EXCEPTION="cpde"
EXPORT ENUM CPD_Error_UnknownArgType=1,
            CPD_Error_UnknownKeyString


EXPORT OBJECT pattern_argdescr
  used                    -> TRUE if argument is used
  type                    -> type of argument (PARGS_Type_XXX)
  data                    -> datas of this argument
  dummystr:PTR TO CHAR    -> dummy string for converting the argument or NIL
ENDOBJECT


EXPORT OBJECT pattern_data
  newformatstr:PTR TO CHAR         -> the formatstring used with RawDoFmt

  argdescrcount                    -> number of arguments
  argdescr:PTR TO pattern_argdescr -> array of argument descriptions

  argscount                        -> number of entries in 'argsconvert' and 'args'
  argsconvert:PTR TO LONG          -> contains for every 'argscount' the position of the related 'argdescr'-structure
  args:PTR TO LONG                 -> dummy array to store arguments for RawDoFmt
ENDOBJECT


/* creates an pattern_data structure useable with patternStringF()
**
** Parameter:
**   formatstr - the formatstring
**   keychar   - the character preceding an format command (normally "%")
**   args      - array of patter_arg structures describing the possible
**               format commands. Last entry must have set his type field
**               to PARGS_Type_END!
**               The 'keystr' field may only contain letters and "_"!!
**               If the types-field contains PARGS_Type_Float you must set
**               the data-field of pattern_arg to precision
**               (number of accurat positions after "."))
**
**
** The function creates all necessary data structures.
** It scans the format string for any occurance of 'keychar'. if it
** is found it tries to find the matching pattern_arg.
** to insert an 'keychar' character, just write it twice.
** Using an format command twice or more is possible.
**
** returns the patter_data structure which should be freed with
** freePatternData().
** May raise exceptions
**
** Example:
**  pd:=createPatternData('patternStringF(): %TIME %YEAR (%6PERCENT%%)',"%",
**                        [PARGS_Type_String,  'TIME',    0,
**                         PARGS_Type_Decimal, 'YEAR',    0,
**                         PARGS_Type_Float,   'PERCENT', 2,
**                         PARGS_Type_END]:pattern_arg)
**  WriteF('"\s"\n',patternStringF(hstri,pd,['15.06 Uhr',15.26,1997]))
**
**  Results in "PatternStringF(): 15.06 Uhr 1997 ( 15.26%)"
**
*/
EXPORT PROC createPatternData(formatstr:PTR TO CHAR,keychar,
                              args:PTR TO pattern_arg) HANDLE
->// "createPatternData()"
DEF pd=NIL:PTR TO pattern_data,
    hstri=NIL:PTR TO CHAR,
    len,
    argscount=0,
    curarg:PTR TO pattern_arg,
    i,c,
    spos,epos,
    argsconvert=NIL:PTR TO LONG,
    argsconvertcount=0

  ->IF keychar=0 THEN keychar:='%'

  /* allocate dummy string
  */
  len:=StrLen(formatstr)
  hstri:=allocString(len*2)

  NEW pd,
      argsconvert[len/2]     -> dummy argsconvert

  /* count arguments
  */
  IF args
    WHILE args[argscount].type<>PARGS_Type_END DO INC argscount
  ENDIF

  /* create argdescription and arg array
  */
  IF argscount
    pd.argdescrcount:=argscount
    NEW pd.argdescr[argscount]
  ENDIF

  spos:=0  -> position after last keystring
  epos:=0  -> current position
  WHILE c:=formatstr[epos++]

    IF c=keychar

      /* copy previous (none formatstring) characters
      */
      IF epos-spos>1
        StrAdd(hstri,formatstr+spos,epos-spos-1)
      ENDIF

      IF formatstr[epos]=keychar
        /* a double 'keychar' results in an single one
        ** (eq. '&&' IS '&')
        */
        IF keychar="%"
          /* "%" is used as format code by RawDoFmt. Therefore we must
          ** add '%%' TO display one '%'
          */
          StrAdd(hstri,'%%')
        ELSE
          StrAdd(hstri,[keychar,0]:CHAR)
        ENDIF
        INC epos

      ELSE

        /* start the format command
        */
        StrAdd(hstri,'%')

        spos:=epos

        /* skip RawDoFmt() codes line width and justify statements
        */
        WHILE c:=formatstr[epos]
          EXIT ((c>="a") AND (c<="z")) OR
               ((c>="A") AND (c<="Z")) OR
               (c="_")
          INC epos
        ENDWHILE
        IF epos-spos>=1
          StrAdd(hstri,formatstr+spos,epos-spos)
        ENDIF

        /* find matching pattern argument
        */
        FOR i:=0 TO argscount-1
          curarg:=args[i]
          EXIT (StrCmp(formatstr+epos,curarg.keystr,StrLen(curarg.keystr)) AND
                (curarg.type<>PARGS_Type_Ignore))
        ENDFOR

        IF i<argscount
          /* process found argument
          **  'curarg'=current pattern_arg
          **  'i'=position of current argument
          */
          c:=curarg.type

          /* initialized argdescription
          */
          pd.argdescr[i].type:=c
          pd.argdescr[i].used:=TRUE
          pd.argdescr[i].data:=curarg.data
          SELECT c
            CASE PARGS_Type_Decimal
              StrAdd(hstri,'ld')

            CASE PARGS_Type_String
              StrAdd(hstri,'s')

            CASE PARGS_Type_Char
              StrAdd(hstri,'lc')

            CASE PARGS_Type_Hex
              StrAdd(hstri,'lx')

            CASE PARGS_Type_Float
              StrAdd(hstri,'s')
              IF pd.argdescr[i].dummystr=NIL
                pd.argdescr[i].dummystr:=allocString(12) -> necessary for converting float to string
              ENDIF

            DEFAULT
              Throw(CPD_EXCEPTION,CPD_Error_UnknownArgType)
          ENDSELECT

          /* store the position OF the argument description struture
          */
          argsconvert[argsconvertcount++]:=i

          /* skip key string
          */
          epos:=epos+StrLen(curarg.keystr)

        ELSE
          Throw(CPD_EXCEPTION,CPD_Error_UnknownKeyString)
        ENDIF

      ENDIF

      spos:=epos

    ENDIF

  ENDWHILE

  /* copy last (none formatstring) characters
  */
  IF epos-spos>1
    StrAdd(hstri,formatstr+spos,epos-spos-1)
  ENDIF

  /* copy the new format string
  */
  pd.newformatstr:=strCreateCopy(hstri)

  /* copy argsconvert-structure
  */
  pd.argscount:=argsconvertcount
  NEW pd.argsconvert[argsconvertcount],
      pd.args[argsconvertcount]
  FOR i:=0 TO argsconvertcount-1 DO pd.argsconvert[i]:=argsconvert[i]

EXCEPT DO

  /* cleaning up
  */
  END argsconvert[len/2]
  disposeString(hstri)
  IF exception
    freePatternData(pd)
    ReThrow()
  ENDIF

ENDPROC pd
->\\


/* frees an pattern_data-struture
*/
EXPORT PROC freePatternData(pd:PTR TO pattern_data)
->// "freePatternData()"
DEF i

  IF pd
    disposeString(pd.newformatstr)

    /* free argdescription array and all related strings
    */
    IF pd.argdescr
      FOR i:=0 TO pd.argdescrcount-1 DO disposeString(pd.argdescr[i].dummystr)
      END pd.argdescr[pd.argdescrcount]
    ENDIF
    END pd.args[pd.argscount],
        pd.argsconvert[pd.argscount]

    END pd
  ENDIF

ENDPROC NIL
->\\


/* Converts datas from 'args' to 'deststr' using the format description from 'pd'.
**
** Parameters:
**   deststr - the destination estring(!!)
**   pd      - an pattern_data structure returned from createPatternData()
**   args    - the argument array (must contain an value for every entry of the
**              'args'parameter you passed to createPatternData())
**
** Returns the estring ('deststr').
*/
EXPORT PROC patternStringF(deststr:PTR TO CHAR,pd:PTR TO pattern_data,args:PTR TO LONG)
->// "patternStringF()"
DEF i,
    dummy

  FOR i:=0 TO pd.argscount-1
    dummy:=pd.argsconvert[i]

    IF pd.argdescr[dummy].type=PARGS_Type_Float
      pd.args[i]:=newRealF(pd.argdescr[dummy].dummystr,  -> dummy string
                           args[dummy],                  -> the float number
                           pd.argdescr[dummy].data)      -> accuraty
    ELSE
      pd.args[i]:=args[dummy]
    ENDIF

  ENDFOR

  /* a little nasty trick.
  ** Fill string with 1. Last item is a zero byte.
  ** Helps to not write more characters than 'StrMax()'.
  **
  ** If someone know how to make it without this trick, let
  ** me know how!
  */
  memset(deststr,1,i:=StrMax(deststr))
  deststr[i]:=0

  RawDoFmt(pd.newformatstr,pd.args,{putproc},deststr)

  SetStr(deststr,StrLen(deststr))

ENDPROC deststr

putproc:
       TST.B  (A3)         -> string end reached?
       BEQ.S  putproc_skip
       MOVE.B D0,(A3)+
putproc_skip:
       RTS
->\\

