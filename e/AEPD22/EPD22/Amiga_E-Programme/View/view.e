/*************************************************************************

:Programm.      VIEW
:Version.       1.01
:Beschreibung.  Anzeigeprogramm für beliebige Dateien mit Suchfunktion
:Autor.         Peter Palm
:EC-Version.    EC3.1a
:OS.            > 2.04 (unter OS3.0 auf A1200 programmiert und getestet)
:PRG-Version.   0.9a -> erste (halbwegs fehlerfreie) Version
                        - ohne SEARCH, HEX, NOCASE, Kommentarzeile
                1.0  -> mit o.g. Optionen
                1.01 -> * einen kleinen Fehler in der checkByte-Routine
                          (mit großer Wirkung) beseitigt (siehe Hex-Dump
                          unter V1.0!!!).
                1.02 -> * Länge des Programms verkürzt;
                        * die Optionen BOTH (jetzt default) und
                          GER (fließt jetzt bei CONTEXT mit ein)
                          entfernt;
                        * einige Routinen optimiert bzw. entfernt
                          (unnötiger Ballast);
                        * konnte Ausführungsgeschwindigkeit
                          (nach "AProf") beschleunigen.

:letzte
 Änderung.      05.02.1995
:Status.        Freeware

*************************************************************************/

OPT OSVERSION=37   /* hoffentlich, ansonsten OSVERSION=39 */

MODULE 'dos/dos'

OBJECT argument            /* aus der Argumentenzeile abgeleitete Parameter                */
  size:LONG,               /* -- Länge der gelesenen Daten                                 */
  wordlen:INT,             /* -- Die minimale Wortlänge (Option WLEN/N, [s. DOC])          */
  linemaxlen:LONG,         /* -- maximale Länge einer Ausgabezeile (V0.90a nur 40 Zeichen) */
  linecount:LONG,          /* -- aktuelle Länge der Ausgabezeile                           */
  options:CHAR,            /* -- Optionen (die ####/S-Optionen der Argumentenzeile)        */
  rows:CHAR,               /* -- Anzahl der Reihen bei Hex-Dump                            */
  searchmode:LONG,         /* -- Suchmodus Ein/Aus  (Flags s.u.)                           */
  searchstr:PTR TO CHAR    /* -- der Suchstring                                            */
ENDOBJECT

OBJECT wordinfo            /* Informationen zum aktuellen Wort                             */
  wordcount:LONG,          /* -- Wortzähler                                                */
  memcount:LONG,           /* -- zeigt auf nächste zu bearbeitende Speicheradresse         */
  cur_word:PTR TO CHAR,    /* -- aktuelles Wort                                            */
  cur_len:LONG,            /* -- Länge des aktuellen Wortes                                */
  flags:CHAR,              /* -- Returnflags (s.u.)                                        */
  position:LONG,           /* -- Position des aktuellen Wortes im File (relativ)           */
  realcount:LONG,          /* -- aktuelle Zahl der bearbeiteten Bytes                      */
  searchcount:LONG         /* -- Anzahl der gefundenen Wörter                              */
ENDOBJECT

ENUM ARG_NAME   = 0,    /* Die einzelnen Argumente der Liste */
     ARG_WLEN,
     ARG_UPPER,
     ARG_LOWER,
     ARG_NUM,
     ARG_CONTEXT,
     ARG_ADDR,
     ARG_ONLY,
     ARG_ALL,
     ARG_HEX,
     ARG_SEARCH,
     ARG_NOCASE

ENUM FLW_NONE   = 0,    /* Returnflags zu "OBJECT wordinfo" */
     FLW_RUN,
     FLW_EOF,
     FLW_BREAK

ENUM FLHD_RUN   = 0,    /* interne Flags für die Hex-Dump-Routine */
     FLHD_EOF,
     FLHD_BREAK 

CONST OPT_BOTH       = %00000011,    /* die einzelnen Optionen (siehe DOC) */
      OPT_LOWER      = %00000001,
      OPT_UPPER      = %00000010,
      OPT_NUM        = %00001000,
      OPT_CONTEXT_C  = %00010000,
      OPT_CONTEXT    = %00010011,
      OPT_ADDR       = %00100000,
      OPT_ONLY       = %01000000,
      OPT_ALL        = %00011011,
      OPT_HEX        = %10000000

/* Die Suchmodus-Flags für die Tabelle */
CONST NO = 0,                 /* Zeichen nicht darstellbar */
      CL = %00000001,         /* Großbuchstabe             */
      CU = %00000010,         /* Kleinbuchstabe            */
      CN = %00001000,         /* Ziffer                    */
      CT = %00010000,         /* sonstiges Zeichen         */
      NY = %10000000          /* noch nicht "darstellbar"  */

ENUM ERR_NONE   = 0,   /* die Fehlercodes */
     ERR_READ,
     ERR_NOMEM,
     ERR_OPEN,
     ERR_NOFILE,
     ERR_NOINFO,
     ERR_BADARGS

CONST SEARCHMODE_ON  = 1,     /* die Suchmodus-Flags ( argument.searchmode ) */
      SEARCHMODE_OFF = 0,
      SEARCHMODE_NOCASE=2

CONST OFL_FIRST=0,  /* Ausgabesteuerungsflags für OPT_SEARCH in output() */
      OFL_ANY=-1

CONST CMNT_RUN = 0,       /* Flags für getCommentArgs() */
      CMNT_FOUND = 1,
      CMNT_NOTFOUND = 2


DEF chars[256]:LIST           /* Komplementäre Angaben zu jedem Zeichen, ob es
                                 in der gewählten Option darstellbar ist */

PROC initOptions( ar:PTR TO LONG )
/*  initialisiert und füllt das Argumentenfeld  */

  DEF options:REG,
      aptr:PTR TO argument

  aptr := New( SIZEOF argument ) 

  IF ar[ARG_WLEN]
    aptr.wordlen := Long( ar[ARG_WLEN] )
    IF aptr.wordlen = 0 THEN aptr.wordlen := 1
  ELSE
    aptr.wordlen := 1
  ENDIF

  options := aptr.options

  IF ar[ARG_UPPER] THEN ORI.L #OPT_UPPER,options
  IF ar[ARG_LOWER] THEN ORI.L #OPT_LOWER,options
  IF ( options AND OPT_BOTH ) = 0 THEN ORI.L #OPT_BOTH,options

  IF ar[ARG_NUM] THEN ORI.L #OPT_NUM,options

  IF ar[ARG_CONTEXT] THEN ORI.L #OPT_CONTEXT,options

  IF ar[ARG_ADDR] THEN ORI.L #OPT_ADDR,options

  IF ar[ARG_ONLY] THEN ORI.L #OPT_ONLY,options

  IF ar[ARG_ALL] THEN ORI.L #OPT_ALL,options

  IF ar[ARG_HEX] THEN ORI.L #OPT_HEX,options

  aptr.searchstr := ar[ARG_SEARCH]
  IF StrLen( aptr.searchstr )
    IF ar[ARG_NOCASE]
      aptr.searchmode := SEARCHMODE_NOCASE
      UpperStr( aptr.searchstr )
    ELSE
      aptr.searchmode := SEARCHMODE_ON
    ENDIF
    aptr.options := aptr.options AND %01011111
  ELSE
    aptr.searchmode := SEARCHMODE_OFF
  ENDIF
  aptr.options := options
ENDPROC aptr

PROC main( )
/*  koordiniert die einzelnen Funktionsaufrufe  */

  DEF rdargs:REG,
      args[20]:LIST,
      a:PTR TO argument,
      lockA:REG,
      lockB:REG,
      fib:fileinfoblock,
      handle,
      mem:REG,
      w:PTR TO wordinfo


  chars := [ NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO,   -> die
             NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO,   -> Ver-
             NO, CT, CT, CT, CT, CT, CT, CT, CT, CT, CT, CT, CT, CT, CT, CT,   -> gleichs-
             CN, CN, CN, CN, CN, CN, CN, CN, CN, CN, CT, CT, CT, CT, CT, CT,   -> tabel-
             CT, CU, CU, CU, CU, CU, CU, CU, CU, CU, CU, CU, CU, CU, CU, CU,   -> le
             CU, CU, CU, CU, CU, CU, CU, CU, CU, CU, CU, CT, CT, CT, CT, CT,
             CT, CL, CL, CL, CL, CL, CL, CL, CL, CL, CL, CL, CL, CL, CL, CL,
             CL, CL, CL, CL, CL, CL, CL, CL, CL, CL, CL, CT, CT, CT, CT, NO,
             NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO,
             NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO, NO,
             NO, CT, CT, CT, CT, CT, CT, CT, CT, CT, CT, CT, CT, CT, CT, CT,
             CT, CT, CT, CT, CT, CT, CT, CT, CT, CT, CT, CT, CT, CT, CT, CT,
             NY, NY, NY, NY, CT, NY, NY, NY, NY, NY, NY, NY, NY, NY, NY, NY,
             NY, NY, NY, NY, NY, NY, CT, NO, NY, NY, NY, NY, CT, NY, NY, CT,
             NY, NY, NY, NY, CT, NY, NY, NY, NY, NY, NY, NY, NY, NY, NY, NY,
             NY, NY, NY, NY, NY, NY, CT, NO, NY, NY, NY, NY, CT, NY, NY, NY ]

  w := New( SIZEOF wordinfo )

  JUMP next

  CHAR '$VER:VIEW Version 1.02 (c) by Peter Palm, 18.01.-05.02.1995',0

next:

  IF rdargs := ReadArgs( 'FILE/A,' +
                         'WLEN/N,' +
                         'U=UPPER/S,' +
                         'L=LOWER/S,' +
                         'N=NUM/S,' +
                         'C=CONTEXT/S,' +
                         'A=ADDR/S,' +
                         'O=ONLY/S,' +
                         'A=ALL/S,' +
                         'H=HEX/S,' +
                         'S=SEARCH/K,' +
                         'NC=NOCASE/S', args, NIL )
    a := initOptions( args )
    a := getCommentArgs( a )
    IF lockA := Lock( args[ARG_NAME], -2 )
      lockB := DupLock( lockA )
      IF Examine( lockA, fib )
        IF fib.direntrytype < 0
          a.size := fib.size
          IF handle := OpenFromLock( lockB )
            IF mem := New( a.size )
              IF Read( handle, mem, a.size )
                w.cur_word := String( 80 )
                IF a.options AND OPT_HEX
                  outputHexDump( mem, a.size, a.rows )
                ELSE
                  REPEAT
                    w := getCurWord( a, w, mem )
                    a := output( a, w )
                  UNTIL w.flags > FLW_RUN
                  underline( a, w, args[ARG_NAME] )
                ENDIF
              ELSE
                errorMessage( ERR_READ )
              ENDIF
            ELSE
              errorMessage( ERR_NOMEM )
            ENDIF
            Close( handle )
          ELSE
            errorMessage( ERR_OPEN )
          ENDIF
        ELSE
          errorMessage( ERR_NOFILE )
        ENDIF
      ENDIF
      UnLock( lockA )
      UnLock( lockB )
    ELSE
      errorMessage( ERR_NOINFO )
    ENDIF
    FreeArgs( rdargs )
  ELSE
    errorMessage( ERR_BADARGS )
  ENDIF
ENDPROC

PROC getCommentArgs( aptr:PTR TO argument )
/* Holt die beiden Argumente aus der Kommentarzeile der Programmdatei */

  DEF fib:fileinfoblock,
      lock:REG,
      program_name[80]:STRING,
      flag=CMNT_RUN:REG,
      comment[80]:STRING,
      work[10]:STRING,
      spos:REG,
      val:REG

  IF GetProgramName( program_name, 80 )
    IF lock := GetProgramDir( )
      Examine( lock, fib )
      REPEAT 
        IF ExNext( lock, fib )
          IF StrCmp( fib.filename, program_name, ALL )
            flag := CMNT_FOUND
            comment := fib.comment
          ENDIF
        ELSE
          IF flag = CMNT_RUN THEN flag := CMNT_NOTFOUND
        ENDIF
      UNTIL flag
    ENDIF
  ENDIF
  aptr.linemaxlen := 40
  aptr.rows := 16
  IF flag = CMNT_FOUND
    IF ( spos := InStr( comment, 'CPL=', 0 ) ) <> -1
      MidStr( work, comment, (spos+4), 2 )
      IF ( ( val := Val( work, 0 ) ) < 10 ) OR ( val > 80 ) THEN val := 40
      aptr.linemaxlen := val
    ENDIF
    IF ( spos := InStr( comment, 'BPL=', 0 ) ) <> -1
      MidStr( work, comment, (spos+4), 2 )
      IF ( ( val := Val( work, 0 ) ) < 2 ) OR ( val > 16 ) THEN val := 16 
      aptr.rows := val
    ENDIF
  ENDIF
ENDPROC aptr

PROC outputHexDump( mem, size, row )
/*  Hex-Dump-Ausgaberoutine (gesamte Datei)  */

  DEF byte:REG,
      m:REG,
      bytestr[80]:STRING,
      ascstr[80]:STRING,
      bcnt=0,
      cnt=0:REG,
      ocnt=0:REG,
      flag=FLHD_RUN:REG,
      empty[40]:STRING

  DEC row

  StrCopy( empty, '          ' +
                  '          ' +
                  '          ' +
                  '          ', ALL )
  REPEAT
    m := mem + cnt
    MOVE.L m,A0
    MOVE.B (A0),D0
    AND.L #$FF,D0
    MOVE.L D0,byte
    StringF( bytestr, '\s\z\h[2] ', bytestr, byte )
    IF chars[byte] AND $7F
      StringF( ascstr, '\s\c', ascstr, byte )
    ELSE
      StrAdd( ascstr, '.', 1 )
    ENDIF
    INC bcnt
    IF bcnt > row
      WriteF( '\z\h[8]: \s \s\n', ocnt, bytestr, ascstr )
      bcnt := 0
      StrCopy( bytestr, '', ALL )
      StrCopy( ascstr, '', ALL )
      ocnt := ocnt + row + 1
    ENDIF
    INC m
    INC cnt
    IF ( cnt >= size ) THEN flag := FLHD_EOF
    IF CtrlC( ) THEN flag := FLHD_BREAK
  UNTIL flag
  StrAdd( bytestr, empty, ((3*(row+1))-StrLen(bytestr)) )
  IF bcnt > 0 THEN WriteF( '\z\h[8]: \s \s\n', ocnt, bytestr, ascstr )
  IF flag = FLHD_BREAK THEN WriteF( '*** Abbruch\n' )
ENDPROC

PROC getCurWord( aptr:PTR TO argument, word:PTR TO wordinfo, mem )
/*  holt das nächste Wort ab der Adresse wordinfo.memcount  */

  DEF byte:REG,
      wo:PTR TO CHAR,
      m:REG,
      fl=FLW_NONE:REG,
      bcnt=0:REG,
      cnt:REG

  cnt := word.memcount
  word.position := cnt
  wo := cnt + mem
  REPEAT
    m := cnt + mem
    MOVE.L m,A0
    MOVE.B (A0),D0
    AND.L #$FF,D0
    MOVE.L D0,byte
    IF chars[byte] AND aptr.options
      INC bcnt
    ELSE
      StrCopy( word.cur_word, '', ALL )
      word.cur_len := 0
      IF bcnt
        IF ( bcnt = aptr.wordlen ) OR
           ( ( ( aptr.options AND OPT_ONLY ) = 0 ) AND ( bcnt > aptr.wordlen ) )
          word.wordcount := word.wordcount + 1
          StrCopy( word.cur_word, wo, bcnt )
          word.cur_len := bcnt
        ENDIF
      ENDIF
      fl := FLW_RUN
    ENDIF
    INC cnt
    IF cnt > aptr.size THEN fl := FLW_EOF
    IF CtrlC( ) THEN fl := FLW_BREAK
    word.realcount := word.realcount + 1
  UNTIL fl <> FLW_NONE
  word.flags := fl
  word.memcount := cnt
ENDPROC word

PROC output( aptr:PTR TO argument, word:PTR TO wordinfo )
/*  gibt das aktuelle Wort (und wenn gewünscht zusätzliche Infos) aus  */

  DEF pos=0:REG,
      oldpos=0:REG,
      flag=OFL_FIRST:REG,
      w[80]:STRING

  StrCopy( w, word.cur_word, ALL )
  IF aptr.searchmode
    IF ( aptr.searchmode = SEARCHMODE_NOCASE ) THEN UpperStr( w )
   IF StrLen( w ) = StrLen( aptr.searchstr )
      IF StrCmp( w, aptr.searchstr, ALL )
        WriteF( '\n\z\h[6] : \s', word.position, word.cur_word )
        word.searchcount := word.searchcount + 1
      ENDIF
    ELSE
      WHILE ( pos := InStr( w, aptr.searchstr ) ) <> -1
        IF flag = OFL_FIRST
          WriteF( '\n\z\h[6] : \s \d', word.position,
                                           word.cur_word,
                                           pos )
          flag := OFL_ANY
          oldpos := pos
        ELSE
          oldpos := oldpos + pos + 1
          WriteF( ',\d', oldpos )
        ENDIF
        word.searchcount := word.searchcount + 1
        RightStr( w, w, (StrLen(w)-StrLen(aptr.searchstr)-pos) )
      ENDWHILE
    ENDIF
  ELSE
    IF ( aptr.options AND OPT_ADDR ) = 0
      IF word.cur_len
        IF ( aptr.linecount + word.cur_len ) > aptr.linemaxlen
          WriteF( '\n' )
          aptr.linecount := word.cur_len + 1
        ELSE
          aptr.linecount := aptr.linecount + word.cur_len + 1
        ENDIF
        WriteF( '\s ', word.cur_word )
      ENDIF
    ELSEIF word.cur_len
      WriteF( '\z\h[6]  \s\n', word.position, word.cur_word )
    ENDIF
  ENDIF
ENDPROC aptr

PROC underline( aptr:PTR TO argument, word:PTR TO wordinfo, filename:PTR TO CHAR )
/*  zeigt die Unterzeile an  */

  WriteF( '\n\nFile: \s, Länge: \d Bytes.\n', filename, aptr.size )
  IF word.flags = FLW_BREAK THEN WriteF( '*** Abbruch. Bearbeitete Bytes: \d\n\n', word.realcount )
  IF aptr.searchmode <> SEARCHMODE_OFF
    WriteF( 'Wort "\s" \dmal vorhanden.\n', aptr.searchstr, word.searchcount )
  ELSE
    WriteF( 'Wörter gefunden: \d\n', word.wordcount )
  ENDIF
ENDPROC

PROC errorMessage( error ) IS WriteF( '\s\n',   /*  Ausgabe der Fehlermeldungen  */
                                      ListItem( ['',
                                                 'Fehler beim lesen des Files',
                                                 'Kein freier Speicher verfügbar',
                                                 'Kann File nicht öffnen',
                                                 'Verzeichnisse nicht erlaubt',
                                                 'File nicht gefunden',
                                                 'Gefordertes Argument fehlt'],
                                                 error ) )

/*
   Wenn irgendwelche Fehler im Code gefunden werden sollten, oder irgendjemandem
   Optimierungen vorschweben, dann teilt es mir doch bitte mit!

                                              Peter Palm
                                              Leipziger Straße 4
                                              03130 Spremberg N/L
*/
