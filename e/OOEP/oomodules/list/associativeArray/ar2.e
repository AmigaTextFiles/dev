/*
 * ar2.e - yer very basic dumb program that reads a text file and counts the
 * number of times each unique word occurs.  Words are used as the array index
 * (key) in an associative array.  This is not -really- an E parser, so it's
 * easier to follow if you use it on plain text, else you'll see some weird
 * "words" and have to THINK to figure out where they're coming from. :)
 *
 * December 24 1995 Gregor Goldbach
 *   This is the original test program by Barry. I just removed the initial size
 *   value from the call to new().
 *   I ran it over my guided dos autodoc (nearly 205Kb). It swallow nearly
 *   800Kb :)
 */

MODULE 'exec/strings'
MODULE 'oomodules/list/associativeArray'

RAISE "OPEN" IF Open()=NIL,
      "MEM" IF String()=NIL,
      "^C" IF CtrlC()=TRUE

CONST SPACE=" ",
      TAB=9

/*
 * Derived class.
 */

OBJECT myAsAr OF associativeArray
  /* key will store pointers to strings */
  /* val will store a count of the string's occurence */
ENDOBJECT
  /* myAsAr */

PROC disposeKey(key) OF myAsAr IS DisposeLink(key)
PROC testKey(string1, string2) OF myAsAr IS OstrCmp(string1, string2)

/*---------------------------------------------------------------------------*/

/*
 * TEST FUNCTIONS.
 */

PROC isWhite(c)
  SELECT c
    CASE SPACE; RETURN TRUE
    CASE TAB;   RETURN TRUE
    CASE LF;    RETURN TRUE
  ENDSELECT
ENDPROC FALSE
  /* isWhite */

PROC isPunct(c) IS (-1<>InStr('.,;:()/?-''"!@#$%^&*=+\\|[]{}<>`~', [c,0]:CHAR))
  /* note: left out "_" for my test since identifiers can have them */

PROC skipSeparator(s)
  DEF c
  WHILE (isWhite(c:=s[]) OR isPunct(c)) DO INC s
ENDPROC s
  /* skipSeparator */

/*---------------------------------------------------------------------------*/

/*
 * Add word to array and tally.
 */
PROC tallyWord(ar:PTR TO myAsAr, key) HANDLE
  DEF val=0
  val:=ar.get(key)
EXCEPT DO
  val:=val+1
  ar.set(key, val)
ENDPROC
  /* tallyWord */

/*
 * Make key from word.
 */
PROC makeKey(w)
  DEF key
  key:=String(EstrLen(w))
  StrCopy(key, w)
ENDPROC key
  /* makeKey */

/*
 * Pickup a word.
 */
PROC getWord(ar, s, w)
  DEF key
  SetStr(w, 0)
  WHILE (isWhite(s[]) OR isPunct(s[])=FALSE) AND (s[]<>EOS)
    StrAdd(w, s, 1)
    INC s
  ENDWHILE
  IF EstrLen(w)
    key:=makeKey(w)
    tallyWord(ar, key)
  ENDIF
ENDPROC s
  /* getWord */

/*
 * Pickup all words in a line.
 */
PROC getWords(ar:PTR TO myAsAr, s, w)
  LOOP
    s:=skipSeparator(s)
    IF s[]=EOS THEN RETURN
    s:=getWord(ar, s, w)
  ENDLOOP
ENDPROC
  /* getWords */

/*---------------------------------------------------------------------------*/

/*
 * Print entire contents of array.
 */
PROC printEmAll(ar:PTR TO myAsAr)
  DEF i, last, key:PTR TO LONG, val:PTR TO LONG
  key:=ar.key
  val:=ar.val
  last:=ar.tail-1
  FOR i:=0 TO last DO WriteF(' \s  ==  \d\n', key[i], val[i])
ENDPROC
  /* printEmAll */

/*---------------------------------------------------------------------------*/

/*
 * MAIN.
 */
PROC main() HANDLE
  DEF ar=NIL:PTR TO myAsAr
  DEF fh=NIL, s=NIL, w=NIL
  IF arg[]=EOS THEN Raise("ARGS")
  fh:=Open(arg, OLDFILE)
  s:=String(100)
  w:=String(100)
  NEW ar.new()
  /* process the whole file, tallying word occurences into ar */
  WHILE Fgets(fh, s, 100) DO getWords(ar, s, w)
  /* print out the entire array */
  printEmAll(ar)
EXCEPT DO
  IF fh THEN Close(fh)
  SELECT exception
    CASE ASAR_EXCEPTION
      SELECT exceptioninfo
        CASE ASAR_KEYNOTFOUND;   WriteF('bad key request\n')
        CASE ASAR_STACKOVERFLOW; WriteF('stack overflow\n')
      ENDSELECT
    CASE "MEM";  WriteF('out of mem\n')
    CASE "ARGS"; WriteF('examine which file?\n')
    CASE "OPEN"; WriteF('can''t open file\n')
    CASE "^C";   WriteF('interrupted\n')
    CASE 0;
    DEFAULT; WriteF('unknow exception \d/\d\n', exception, exceptioninfo)
  ENDSELECT
  CleanUp()
ENDPROC
  /* main */
