
/* EC 2 PPMS converter */

/* we get called <ourname> "< redirection file" <eggs.x>      */
/*                                never see      in arg       */
/* output must be #filename# ( optional column ) line message */

MODULE  'tools/ctype'         /* c emulating macros       */

CONST BUFF = 500,             /* the input stream buffer size and extra input is ignored  */
      WB = 256,               /* word buffer for breaking the read stream down into words */
      NB = 10,                /* number buffer for placing error line numbers in as ascii */
      MB = 256,               /* message buffer even too big at this size only needs 60   */
      WORD = 1,               /* value returned by getbit() when a word is found          */
      NUM = 2,                /* value returned by getbit() when a number is found        */
      EOF = -1,               /* end of file                                              */
      EXIT_FAILURE = 10       /* no mem                                                   */

/* word, line, msg pointers to dynamically allocated buffs  */
/* size = read stream size, end = end of buffer ram         */
/* p is always the pointer to current buffpos               */

DEF word, line, msg, end, size, p

PROC main() HANDLE
DEF t, type = NIL

  NEW word[ WB ], line[ NB ], msg[ MB ]   /* allocate space          */
  WriteF( '' )                            /* input channel wakeup   */
  p, size := read()                       /* fill buffer with input */
  end := p + size

  WriteF( '\s', p )                       /* this would cause the entire output to be sent */

/* set defaults incase they are not available while parsing the message */

  AstrCopy( line, '0' )
  AstrCopy( msg, 'unknown !#@$ no help available' )

/* until all done */

  WHILE ( t := getbit() ) <> EOF
  IF t = WORD

/* 9 lines that handle the bits that others don't !@#$ */

    IF StrCmp( word, 'ec' ) /* a general EC init error follows.. */
      eat( ":" )
      getline( msg, MB )
      type := "E"

    ELSEIF  StrCmp( word, 'UNREFERENCED' )
      eat( ":" )
      AstrCopy( msg, 'unreferenced: ' )
      getline( msg + 14, MB )
      type := "W"

/* handles ERROR and possible line number */

    ELSEIF StrCmp( word, 'ERROR' ) OR StrCmp( word, 'WARNING' )
      type := word[]
      eat( ":" )                                  /* burp...  ': or spaces'   */
      getline( msg, MB )
      getbit()
      IF  StrCmp( word, 'LINE' )                  /* line number?           */
	getbit()                                  /* grab number/ maybe     */
	AstrCopy( line, word, NB )                /* copy the line          */
      ENDIF
    ENDIF
    IF type                                       /* anything happen above  */
      outerr( type )                              /* spit the error strings */
    type := NIL                                   /* done with this error   */
    ENDIF
  ENDIF
  ENDWHILE

EXCEPT
  SELECT exception
    CASE  "MEM"; WriteF( 'NO MEM!!!\n' )
		 CleanUp( EXIT_FAILURE )
  ENDSELECT
ENDPROC

/* generates the error output */

PROC outerr( type )                               /* type is char W or E    */
  WriteF( '#\s# ', arg )                          /* out the file name      */
  WriteF( '\s ', line )                           /* the line as text       */
  WriteF( '\c ', type )                           /* W or E ?               */
  WriteF( '\s\n', msg )                           /* the nasty bit          */
ENDPROC

/* buffers the entire input stream for processing */

PROC read()                                       /* fills buff with input no need to hack */
DEF m, l = NIL, c

  NEW m[ BUFF + 2 ]
  m[ NIL ] := "\n"
  m[ BUFF - 2 ] := "\n"
  m[ BUFF - 1 ] := "\n"
  m++

  WHILE ( ( c := Inp( stdin ) ) <> -1 ) AND ( l < ( BUFF ) ) DO m[ l++ ] := c
ENDPROC m, l

/* returns a word or ascii number, ignoring rubbish */

PROC  getbit()
DEF c, pos = NIL

  LOOP
    SELECT 128 OF c := p[]  /* create offsets for jumping to for first 128 values */

      CASE "a" TO "z", "A" TO "Z"
	WHILE isalpha( p[] ) AND ( pos < WB - 1 )   /* while could be a lexical identifier */
	  word[ pos ] := p[]++
	  pos++
	ENDWHILE
	word[ pos ] := NIL
	RETURN WORD

      CASE "0" TO "9"
	WHILE isdigit( p[] ) AND ( pos < WB - 1 )   /* while ascii digits   */
	  word[ pos ] := p[]++
	  pos++
	  ENDWHILE
	word[ pos ] := NIL
	RETURN NUM

      CASE  "\n"                                    /* new line check eob   */
	IF p >= end THEN RETURN EOF                 /* alway a '\n' there   */

    ENDSELECT
  p++                                               /* rubbish skip it      */
  ENDLOOP
ENDPROC

/* feed me left overs, yum, yum */

PROC  eat( what1 = "\t", what2 = " " )              /* default white space  */
  WHILE ( p[] = what1 ) OR ( p[] = what2 ) AND ( p < end ) DO p[]++
ENDPROC

/* grabs a line while not eob and no CR LF */

PROC  getline( to, len )                            /* buffer to, and size  */
  WHILE ( p[] <> "\n" ) AND ( p[] <> "\b" ) AND ( p < end )
  to[] := p[]
  to++; p++
  len--
  ENDWHILE
  to[] := NIL
ENDPROC


