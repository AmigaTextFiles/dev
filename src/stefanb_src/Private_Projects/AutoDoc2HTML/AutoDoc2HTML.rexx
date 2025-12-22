/*
 * AutoDoc2HTML.rexx  V0.0.02
 *
 * Convert AutoDoc file to HTML
 *
 * (c) 1996 Stefan Becker
 */
OPTIONS RESULTS

/* Load support libraries */
IF SHOW(L, 'rexxdosssupport.library') == 0 THEN
 CALL ADDLIB('rexxdossupport.library', 0, -30, 0)

/* Default command line values */
template      = 'AUTODOC/A,LIBRARY/K,INITFILE/K,TOPNODE/K'
returncode    = 20
args.LIBRARY  = ''
args.INITFILE = ''
args.TOPNODE  = ''

/* Define program "constants" */
CONST_Contents = 'Contents'

/* Default variable settings. These can be changed in the INITFILE */
comment = ''
header  = ''
footer  = ''
top     = 'Leave AutoDoc'
toc     = 'Contents'

/* Analyze command lines */
PARSE SOURCE . . programname .
PARSE ARG arguments

/* Help requested? */
IF STRIP(arguments) = '?' THEN DO
 CALL WRITECH(STDOUT, Template || ': ')
 arguments = READLN(STDIN)
END

/* Parse command line with template */
IF ReadArgs(arguments, Template, "args.") THEN DO

 /* Read initialization file */
 IF initfile ~= '' THEN INTERPRET ReadFile(args.INITFILE)

 /* Open autodoc file */
 IF OPEN(autodoc, args.AUTODOC, 'R') THEN DO

  /* Get Library name */
  IF GetLibraryName(args.AUTODOC, args.LIBRARY) THEN DO

   /* We're starting now... */
   SAY 'Analyzing AutoDoc ''' || args.AUTODOC || ''' for library ''' || library || ''''

   /* Parse TOC */
   entries = ReadTOC()
   IF entries ~= 0 THEN DO

    /* Write TOC */
    IF WriteTOC(entries) THEN DO

     /* Parse each node */
     DO i = 1 TO entries

      /* Parse next node */
      IF ReadNode(nodes.i) THEN DO

       /* Write HTML document */
       IF ~WriteNode(nodes.i) THEN DO
        SAY 'Couldn''t create HTML document for' nodes.i
        LEAVE
       END
      END
      ELSE DO
       SAY 'Couldn''t read entry for' nodes.i
       LEAVE
      END
     END

     /* All OK? */
     IF i = entries + 1 THEN DO

      /* Tell the user! */
      SAY 'AutoDoc converted!'

      /* Set return code */
      returncode = 0
     END
    END
    ELSE SAY 'Couldn''t create table of contents document!'
   END
   ELSE SAY 'Error in TABLE OF CONTENTS!'
  END
  ELSE SAY 'No library name?!?'
 END
 ELSE SAY 'Couldn''t open AutoDoc ''' || args.AUTODOC || '''!'
END
     /* Command line parsing failed */
ELSE SAY Fault(RC, programname)

EXIT returncode

/*---------------------------------------------------------------------------*/
/* Analyze AutoDoc TOC  */
ReadTOC: PROCEDURE EXPOSE autodoc library nodes.

/* Set default return code */
returncode = 0

/* Tell the user */
WRITECH(STDOUT, 'Analyzing table of contents')

/* Read first line and check contents */
IF UPPER(STRIP(READLN(autodoc))) == 'TABLE OF CONTENTS' THEN DO

 /* Contents line introducer */
 introducer = library || '/'
 namestart  = LENGTH(introducer) + 1

 /* Generate node list */
 DO FOREVER

  /* Read first character from autodoc */
  line = READCH(autodoc, 1)

  /* Which type of line? */
  SELECT
   WHEN line == '0C'X THEN LEAVE   /* End of TOC */

   WHEN line == '0A'X THEN ITERATE /* Empty line */

   WHEN EOF(autodoc)  THEN DO      /* End of file? */
    SAY ' Unexpected EOF!'
    returncode = 0
    LEAVE
   END

   OTHERWISE DO                    /* Non-empty line */

    /* Read rest of line */
    line = STRIP(line || READLN(autodoc))

    /* Line with spaces? */
    IF line == '' THEN ITERATE

    /* Increment counter */
    returncode = returncode + 1

    /* Progress report */
    WRITECH(STDOUT, '.')

    /* Check format of contents line */
    IF INDEX(line, introducer) == 1 THEN

     /* Strip introducer and get node name */
     nodes.returncode = WORD(SUBSTR(line, namestart), 1)

    ELSE DO
     SAY ' Erroneous contents line:' line
     returncode = 0
     LEAVE
    END
   END
  END
 END

 /* Contents OK? */
 IF returncode ~= 0 THEN SAY ' ' || returncode || ' entries found'
END

/* Return result */
RETURN returncode

/*---------------------------------------------------------------------------*/
/* Write TOC HTML */
WriteTOC: PROCEDURE EXPOSE CONST_Contents nodes. library args. comment header top footer

/* Parse procedure arguments */
PARSE ARG entries

/* Set default return code */
returncode = 0

/* Read first line and check contents */
IF OpenHTMLFile(CONST_Contents) THEN DO

 /* Write header */
 WRITELN(html, '<H2>AutoDoc for ' || library || '</H2><UL>')

 /* Create list of links */
 DO i = 1 TO entries
  WRITELN(html, '<LI><A HREF="' || nodes.i || '.html">' || nodes.i || '</A>')
 END

 /* End list */
 WRITELN(html, '</UL>')

 /* Close contents document */
 CloseHTMLFile(CONST_Contents)

 /* All OK */
 returncode = 1
END

/* Return result */
RETURN returncode

/*---------------------------------------------------------------------------*/
/* Known keyword? */
KnownKeyword: PROCEDURE

/* Parse procedure arguments */
PARSE ARG w

IF w == 'NAME' | w == 'SYNOPSIS' | w == 'FUNCTION' | w == 'INPUTS' | w == 'BUGS' | w == 'SEE ALSO' THEN RETURN w

/* Synonyms for RESULTS */
IF w == 'RESULTS' | w == 'RESULT' THEN RETURN 'RESULTS'

/* Synonyms for NOTE */
IF w == 'NOTE' | w == 'NOTES' | w == 'SPECIAL NOTES' | w == 'WARNING' THEN RETURN 'NOTES'

/* Synonyms for EXAMPLE */
IF w == 'EXAMPLE' | w == 'EXAMPLES' THEN RETURN 'EXAMPLE'

/* Unknown keyword */
RETURN ''

/*---------------------------------------------------------------------------*/
/* Parse NAME entry */
ParseNAME: PROCEDURE EXPOSE autodoc

/* Parse procedure arguments */
PARSE ARG nodename

/* Set default return code */
string = ''
inname = 0

/* Scan autodoc */
DO FOREVER

 /* Read first character from autodoc */
 line = READCH(autodoc, 1)

 /* Which type of line? */
 SELECT
  WHEN line == '0C'X | EOF(autodoc) THEN DO /* End of node or end of file? */
   string = ''
   LEAVE
  END

  WHEN line == '0A'X THEN IF inname THEN LEAVE /* Empty line */

  OTHERWISE DO                                 /* Non-empty line */

   /* Read rest of line */
   line = STRIP(TRANSLATE(line || READLN(autodoc), ' ', '09'X))

   /* In name? */
   IF ~inname THEN DO

    /* Check line */
    IF (WORD(line, 1) == nodename) & (LEFT(WORD(line, 2), 1) == '-') THEN DO

     /* Initialize string */
     string = '<TABLE><TR><TD><CODE>' || nodename || '</CODE><TD>-<TD>' || SUBSTR(line, WORDINDEX(line, 3))

     /* Parsing name */
     inname = 1

    END
    ELSE DO
     SAY 'Incorrect NAME entry:' line
     string = ''
     LEAVE
    END
   END
   ELSE DO

    /* Line with spaces? */
    IF line == '' THEN LEAVE

    /* Add line to string */
    string = string || ' ' || line
   END
  END
 END
END

/* Entry parsed? */
IF string ~= '' THEN string = string || '</TABLE>'

/* Return NAME HTML contents */
return string

/*---------------------------------------------------------------------------*/
/* Parse pre-formatted entry */
ParsePreFormatted: PROCEDURE EXPOSE autodoc line dontread

/* Initialize string */
string = ''

/* Scan autodoc */
DO FOREVER

 /* Read first character from autodoc */
 line = READCH(autodoc, 1)

 /* Which type of line? */
 SELECT
  WHEN line == '0C'X | EOF(autodoc) THEN DO /* End of node or end of file? */
   string = ''
   LEAVE
  END

  WHEN line == '0A'X                THEN string = string || '0A'X

  OTHERWISE DO                              /* Non-empty line */

   /* Read rest of line */
   line = line || READLN(autodoc)

   /* Next entry reached? */
   IF KnownKeyword(STRIP(line)) ~= '' THEN DO
    dontread = 1
    LEAVE
   END

   /* Add line to string */
   string = string || line || '0A'X
  END
 END
END

/* Entry parsed? */
IF string ~= '' THEN DO

 /* Remove leading & trailing empty lines */
 string = STRIP(string, 'B', '0A'X)

 /* Complete string */
 string = '<PRE>' || string || '</PRE>'
END

/* Return pre-formatted HTML contents */
return string

/*---------------------------------------------------------------------------*/
/* Parse several paragraphs */
ParseParagraphs: PROCEDURE EXPOSE autodoc line dontread

/* Initialize string */
string      = ''
inparagraph = 0

/* Scan autodoc */
DO FOREVER

 /* Read first character from autodoc */
 line = READCH(autodoc, 1)

 /* Which type of line? */
 SELECT
  WHEN line == '0C'X | EOF(autodoc) THEN DO /* End of node or end of file? */
   string   = ''
   dontread = 1
   LEAVE
  END

  WHEN line == '0A'X                THEN DO /* Empty line */

   /* In paragraph? */
   IF inparagraph THEN DO

    /* Yes, terminate it */
    string      = string || '</P>'
    inparagraph = 0
   END
  END

  OTHERWISE DO                              /* Non-empty line */

   /* Read rest of line */
   line = STRIP(TRANSLATE(line || READLN(autodoc), ' ', '09'X))

   /* Next entry reached? */
   IF KnownKeyword(line) ~= '' THEN DO
    dontread = 1
    LEAVE
   END

   /* New paragraph? */
   IF ~inparagraph THEN DO

    /* Yes, start it */
    string      = string || '<P>' || line
    inparagraph = 1
   END
   ELSE
    /* No, just add line to string */
    string = string || ' ' || line

  END
 END
END

/* Entry parsed and still in paragraph? */
IF (string ~= '') & inparagraph THEN string = string || '</P>'

/* Return paragraph contents */
return string

/*---------------------------------------------------------------------------*/
/* Parse variables */
ParseVariables: PROCEDURE EXPOSE autodoc line dontread

/* Initialize string */
string     = '<TABLE>'
invariable = 0

/* Scan autodoc */
DO FOREVER

 /* Read first character from autodoc */
 line = READCH(autodoc, 1)

 /* Which type of line? */
 SELECT
  WHEN line == '0C'X | EOF(autodoc) THEN DO /* End of node or end of file? */
   string   = ''
   dontread = 1
   LEAVE
  END

  WHEN line == '0A'X THEN invariable = 0    /* Empty line */

  OTHERWISE DO                              /* Non-empty line */

   /* Read rest of line */
   line = STRIP(TRANSLATE(line || READLN(autodoc), ' ', '09'X))

   /* Next entry reached? */
   IF KnownKeyword(line) ~= '' THEN DO
    dontread = 1
    LEAVE
   END

   /* New variable? */
   IF ~invariable THEN DO

    /* Check line */
    seperator = INDEX(line, '-')
    IF seperator = 0 THEN DO
     string   = ''
     dontread = 1
     LEAVE
    END

    /* Yes, start it */
    invariable = 1

    /* Initialize string */
    string = string || '<TR><TD VALIGN=TOP><VAR>' || STRIP(SUBSTR(line, 1, seperator - 1)) || '</VAR><TD VALIGN=TOP>-<TD> ' || SUBSTR(line, WORDINDEX(line, 3))

   END
   ELSE
    /* No, just add line to string */
    string = string || ' ' || line

  END
 END
END

/* Entry parsed and still in paragraph? */
IF string ~= '' THEN string = string || '</TABLE>'

/* Return variables contents */
return string

/*---------------------------------------------------------------------------*/
/* Parse SEE ALSO entry */
ParseSEEALSO: PROCEDURE EXPOSE autodoc

/* Initialize string */
string = ''

/* Scan autodoc */
DO FOREVER

 /* Read first character from autodoc */
 line = READCH(autodoc, 1)

 /* Which type of line? */
 SELECT
  WHEN line == '0C'X | EOF(autodoc) THEN DO /* End of node or end of file? */
   string   = ''
   LEAVE
  END

  WHEN line == '0A'X THEN LEAVE             /* Empty line: Stop parsing */

  OTHERWISE string = string || STRIP(TRANSLATE(line || READLN(autodoc), ' ', '09X')) || ' '
 END
END

/* Entry parsed? */
IF string ~= '' THEN DO

 /* Initialize strings */
 functions = STRIP(string)
 string    = '<TABLE>'

 /* Parse reference list */
 DO UNTIL functions == ''

  /* Add next reference */
  string = string || '<TR><TD>' STRIP(WORD(functions, 1), 'T', ',')

  /* Cut out reference */
  functions = DELWORD(functions, 1, 1)
 END

 /* Complete string */
 string = string || '</TABLE>'
END

/* Return SEE ALSO contents */
return string

/*---------------------------------------------------------------------------*/
/* Read node from AutoDoc */
ReadNode: PROCEDURE EXPOSE autodoc library contents.

/* Parse procedure arguments */
PARSE ARG nodename

/* Set default return code */
returncode = 0

/* Get first line */
line = READLN(autodoc)

/* Node header */
nodeheader   = library || '/' || nodename
headerlength = LENGTH(nodeheader)

/* Check node header: "library/node<n spaces>library/node" */
IF INDEX(line, nodeheader) = 1  & SUBSTR(line, LENGTH(line) + 1 - headerlength) == nodeheader THEN DO

 /* Special case for tag functions: They may have several headers! */
 DO FOREVER

  /* Read next line */
  line = READLN(autodoc)

  /* Does it contain the library name in the first column? */
  IF INDEX(line, library) ~= 1 THEN LEAVE
 END

 /* Don't read next line */
 dontread = 1

 /* Initialize contents stem */
 contents.NAME     = ''
 contents.SYNOPSIS = ''
 contents.FUNCTION = ''
 contents.INPUTS   = ''
 contents.RESULTS  = ''
 contents.NOTES    = ''
 contents.EXAMPLE  = ''
 contents.BUGS     = ''
 contents.SEEALSO  = ''

 /* Scan autodoc */
 DO FOREVER

  /* Read first character from autodoc */
  IF ~dontread THEN line = READCH(autodoc, 1)

  /* Which type of line? */
  SELECT
   WHEN line == '0C'X THEN DO      /* End of node */
    returncode = 1
    LEAVE
   END

   WHEN line == '0A'X THEN ITERATE /* Empty line */

   WHEN EOF(autodoc)  THEN DO      /* End of file? */
    SAY ' Unexpected EOF!'
    LEAVE
   END

   OTHERWISE DO                    /* Non-empty line */

    /* Read rest of line */
    IF dontread THEN dontread = 0
                ELSE line = line || READLN(autodoc)
    line = STRIP(TRANSLATE(line, ' ', '09'X))

    /* Line with spaces? */
    IF line == '' THEN ITERATE

    /* Check keyword */
    keyword = KnownKeyword(line)
    IF keyword ~= '' THEN DO

     /* Keyword-sensitive parsing */
     SELECT
      WHEN keyword == 'NAME'     THEN contents.NAME       = ParseNAME(nodename)
      WHEN keyword == 'SYNOPSIS' THEN contents.SYNOPSIS   = ParsePreFormatted()
      WHEN keyword == 'FUNCTION' THEN contents.FUNCTION   = ParseParagraphs()
      WHEN keyword == 'INPUTS'   THEN contents.INPUTS     = ParseVariables()
      WHEN keyword == 'RESULTS'  THEN contents.RESULTS    = ParseVariables()
      WHEN keyword == 'NOTES'    THEN contents.NOTES      = ParseParagraphs()
      WHEN keyword == 'EXAMPLE'  THEN contents.EXAMPLE    = ParsePreFormatted()
      WHEN keyword == 'BUGS'     THEN contents.BUGS       = ParseParagraphs()
      WHEN keyword == 'SEE ALSO' THEN contents.SEEALSO    = ParseSEEALSO()
     END
    END
    ELSE DO
     SAY 'Unknown keyword' line
     LEAVE
    END
   END
  END
 END
END
ELSE SAY 'Errorneous header in node ' || nodename || ': ' line

/* Return result */
RETURN returncode

/*---------------------------------------------------------------------------*/
/* Write one entry to HTML document (with link translation) */
WriteEntry: PROCEDURE EXPOSE html contents. nodes. entries

/* Parse procedure arguments */
PARSE ARG entry, name

/* Entry valid? */
string = contents.entry
IF string ~= '' THEN DO

 /* Name specified? */
 IF name == '' THEN name = entry

 /* Replace function names with links */
 start = 1
 DO UNTIL start = 0

  /* Scan for () in string */
  start = INDEX(string, '()', start)
  IF start ~= 0 THEN DO

   /* Scan for beginning of function name */
   funcstart = LASTPOS(' ', string, start) + 1
   length    = start - funcstart

   /* Cut out */
   function = SUBSTR(string, funcstart, length)
   string   = DELSTR(string, funcstart, length + 2)

   /* Build new default string */
   newfunction = '<CODE>' || function || '()</CODE>'

   /* Scan node list */
   DO i = 1 to entries

    /* Local function? */
    IF nodes.i == function THEN DO

     /* If local function then generate link */
     newfunction = '<A HREF="' || function || '.html">' || newfunction || '</A>'
     LEAVE
    END
   END

   /* Insert new string */
   string = insert(newfunction, string, funcstart - 1)

   /* Skip entry */
   start = funcstart + LENGTH(newfunction)
  END
 END

 /* Write entry */
 WRITELN(html, '<H2>' || name || '</H2><BLOCKQUOTE>' || string || '</BLOCKQUOTE>')
END

/* All OK */
RETURN 0

/*---------------------------------------------------------------------------*/
/* Write node HTML document */
WriteNode: PROCEDURE EXPOSE CONST_Contents library contents. args. comment header top toc footer nodes. entries

/* Parse procedure arguments */
PARSE ARG nodename

/* Set default return code */
returncode = 0

/* Check mandatory fields */
IF (contents.NAME ~= '') & (contents.SYNOPSIS ~= '') & (contents.FUNCTION ~= '') THEN DO
 /* Read first line and check contents */
 IF OpenHTMLFile(nodename) THEN DO

  /* Write mandatory entries */
  WRITELN(html, '<H2>NAME</H2><BLOCKQUOTE>'     || contents.NAME     || '</BLOCKQUOTE>')
  WRITELN(html, '<H2>SYNOPSIS</H2>'             || contents.SYNOPSIS || '</BLOCKQUOTE>')
  WriteEntry(FUNCTION)

  /* Write non mandatory entries */
  WriteEntry(INPUTS)
  WriteEntry(RESULTS)
  WriteEntry(NOTES)
  WriteEntry(EXAMPLE)
  WriteEntry(BUGS)
  WriteEntry(SEEALSO, 'SEE ALSO')

  /* Close contents document */
  CloseHTMLFile(nodename)

  /* All OK */
  returncode = 1
 END
END
ELSE SAY 'NAME, SYNOPSIS or FUNCTION part missing in ' || nodename || '!'

/* Return result */
RETURN returncode

/*---------------------------------------------------------------------------*/
/* Read a file into a string */
ReadFile: PROCEDURE

/* Parse procedure arguments */
PARSE ARG filename

/* Set default return value */
string = ''

/* Open file */
IF OPEN(file, filename) THEN
DO
 /* Scan file and append lines */
 DO UNTIL EOF(file)
  string = string || READLN(file)
 END

 /* Close file */
 CLOSE(file)
END

/* Return result */
RETURN string

/*---------------------------------------------------------------------------*/
/* Get library name */
GetLibraryName: PROCEDURE EXPOSE library

/* Parse procedure arguments */
PARSE ARG filename library

/* Library name specified? */
IF library == '' THEN
DO

 /* No, extract library base name from file name */
 IF UPPER(RIGHT(filename, 4)) == '.DOC' THEN DO

  /* Strip ending */
  filename = SUBSTR(filename, 1, LENGTH(filename) - 4)

  /* Get file name, strip path */
  index = LASTPOS('/', filename)
  IF index ~= 0 THEN filename = SUBSTR(filename, index + 1)
  index = LASTPOS(':', filename)
  IF index ~= 0 THEN filename = SUBSTR(filename, index + 1)

  /* Library name extracted */
  library    = filename || '.library'
  returncode = 1
 END
END
ELSE returncode = 1

/* Return result */
RETURN returncode

/*---------------------------------------------------------------------------*/
/* Open HTML file */
OpenHTMLFile: PROCEDURE EXPOSE html comment header library

/* Parse procedure arguments */
PARSE ARG nodename

/* Set default return code */
returncode = 0

/* Tell the user about it */
WRITECH(STDOUT, 'HTML File: ' || nodename || '... ')

/* Open file */
IF OPEN(html, nodename || '.html', W) THEN DO

 /* Write header */
 WRITELN(html, '<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">')
 WRITELN(html, '<!-- Converted with AutoDoc2HTML (c) 1996 Stefan Becker <stefanb@yello.ping.de> on ' || translate(date(),'-',' ') || ' -->')
 IF comment ~= '' THEN WRITELN(html, '<!-- ' || comment || ' -->')
 WRITELN(html, '<HTML><HEAD><TITLE>AutoDoc: ' || library || '/' || nodename || '</TITLE></HEAD><BODY>')
 IF header ~= '' THEN WRITELN(html, header)

 /* All OK */
 returncode = 1
END

/* Return result */
RETURN returncode

/*---------------------------------------------------------------------------*/
/* Close HTML file */
CloseHTMLFile: PROCEDURE EXPOSE html args. top CONST_Contents toc footer

/* Parse procedure arguments */
PARSE ARG nodename

WRITELN(html, '<HR><TABLE WIDTH=100%><TR>')
IF args.TOPNODE ~= ''             THEN WRITELN(html, '<TD><A HREF="' || args.TOPNODE || '">' || top || '</A>')
IF nodename     ~= CONST_Contents THEN WRITELN(html, '<TD ALIGN=RIGHT><A HREF="' || CONST_Contents || '.html">' || toc || '</A>')
WRITELN(html, '</TABLE>')
WRITELN(html, footer)
WRITELN(html, '</BODY></HTML>')

/* Close file */
CLOSE(html)

/* Tell the user about it */
SAY 'DONE'

/* Return no result */
RETURN 0
