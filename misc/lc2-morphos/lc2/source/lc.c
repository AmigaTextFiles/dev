
char    id_lc[] = "@(#)lc.c     1.20";
/*
  @(#) -- module lc.c, version 1.20.  Last changed 8/17/83 18:20:28.
*/

#include        "lc.h"
#include        <stdio.h>


/*
  NAME:
  lc.c

  FUNCTION:
  Counts lines with comments, lines with code, and blank lines in
  the files given it. See the documentation.

  ALGORITHM:
  Get the arguments.
  If there is a flag argument, it is the new size of a page.
  for each file given (stdin if none are given)
  count the lines, keeping note of what each line is.
  return the totals.
  print the grand total.

  PARAMETERS:
  argc, argv

  RETURNS:
  exit status 0 if it was successful.
  exit status 1 if any file was not found.
  exit status 2 if a bad pagesize flag was given.
  exit status 3 if a program error was found.

  GLOBALS:
  stdio.h:                the standard i/o library.

  KNOWN BUGS:
  Text of the form 
  printf("garbage \
  more garbage");
  will be incorrectly counted as one line. 

  HISTORY:
  Initial coding finished June 10, 1981 by Brian Marick of DTI.
  Aug 16, 1983    Brian Marick of Compion         Counts '}', '{' as
  white space.
  Aug 17, 1992    Brian Marick, self-employed     Improve for GCT demo                                    
  Jul 12, 2004    Ray Rizzuto                     Added C++ comments parsing
  
  NOTE:
  The quoting and escaping rules are not exactly as they are in C.
  A backslash will remove any special significance from a following
  single or double quote. Otherwise, the backslash will be ignored.
  Note that this includes the newlines in multi-line macros.
  A string need not be terminated on the same line it started on.
  This has the potential of causing lc to gobble up the whole file
  looking for a string.
*/


int     page_size = 56;                                 /* Global size of a page. */
BOOLEAN in_comment = FALSE;                             /* TRUE if we are in a comment. */
BOOLEAN in_cpp_comment = FALSE;							/* TRUE if we are in a C++ comment */
BOOLEAN white_bracket = FALSE;                          /* TRUE -- brackets count as white space. */






/*
  NAME:
  main

  FUNCTION:
  strip pagesize and bracket switches and then process each file in turn.

  ALGORITHM:
  while there are arguments beginning with '-'
  if the argument is either '}' or '{'
  set white_bracket to TRUE
  else 
  read them as the new size of page
  if the arguments were incorrect
  print error message and exit.
  if reading from standard input
  tally that file
  show the tally.
  else if reading from named files
  tally each file.
  show the tally.
  show the total tally.
  PARAMETERS:
  argc: standard argument count
  argv: standard pointer to arguments

  RETURNS:
  Status 0 if all goes well.
  Status 1 if there was a file not found.
  Status 2 if there was a bad pagesize argument. (abortive exit)
  Status 3 if there was a program error. (abortive exit)

  GLOBALS:
  page_size:      number of lines per page.
  stdin, stderr:  standard input and error. 

  CALLS:
  sscanf:         scan a line in core.
  fprintf:        print to a file.
  show_header:    print this program's column headers.
  tally_file:     get counts for a single file.
  show_tally:     show counts for a single file.
  fclose:         close a file.
  panic:          die if something unexpected happens.
  make_total:     add counts for this file to total counts.

  CALLED BY:

  HISTORY:
  Initial coding June 5, 1981 by Brian Marick of DTI.
  Aug 16, 1983    Brian marick of Compion         Allow -} and -{ arguments.

*/

main (argc, argv)

    int     argc;
    char   *argv[];

{
    register int    index;                              /* loop index. */
    FILE * fp;                                          /* pointer to a file. */
    struct tally    total_tally;                        /* total tallies for all files. */
    struct tally    file_tally;                         /* tally for a particular file. */
    int     status = OK;                                /* exit status. */

    while (--argc > 0 && (**++argv == '-'))
    {
        if (  (*argv)[1] == LCURL || (*argv)[1] == RCURL)
        {
            white_bracket = TRUE;
        }
        else if (sscanf (*argv + 1, "%d", &page_size) == FALSE)
        {
            fprintf (stderr, "lc: Bad page size argument: %s\n", *argv);
            exit (BAD_FLAG);
        }
    }

/* argc now contains number of files. Argv points to the first file. */

    total_tally.pure_code = total_tally.pure_comment = total_tally.both = total_tally.blank = total_tally.pages = 0;
    if (argc == 0)
    {
        tally_file (stdin, &file_tally);
        show_header ();
        show_tally ("", &file_tally);
    }
    else
    {
        show_header ();
        for (index = 1; index <= argc; index++)
        {
            if ((fp = fopen (*argv, "r")) == NULL)
            {
                status = FILE_NOT_FOUND;
                fprintf (stderr, "lc: can't open %s\n", *argv);
            }
            else
            {
                tally_file (fp, &file_tally);
                if (fclose (fp) == EOF)
                    panic (PANIC, "Fclose error.");
                show_tally (*argv, &file_tally);
                if (argc > 1)
                    make_total (&total_tally, &file_tally);
            }
            argv++;
        }
        if (argc > 1)
        {
            printf ("\n");
            show_tally ("ALL:", &total_tally);
        }
    }
    exit (status);
}



/*
  NAME:
  show_header
  FUNCTION:
  Print column headers.

  ALGORITHM:
  Print column headers.

  PARAMETERS:
  none.

  RETURNS:
  nothing

  GLOBALS:
  none.

  CALLS:
  printf:         format and print output.

  CALLED BY:
  main

  HISTORY:
  Initial coding finished June 5, 1981 by Brian Marick of DTI.
*/

show_header ()

{
    printf ("\t\tPure\tPure\tBoth\t\tTotal\tTotal\tTotal\n");
    printf ("\t\tCode\tComment\tCod&Com\tBlank\tCode\tComment\tLines\tPages\n");
    printf ("\n");
}



/*
  NAME:
  tally_file

  FUNCTION:
  Find the line counts for a particular file.

  ALGORITHM:
  Initialize.
  Repeat below until the end of file is reached:
  get information about a line
  if the line is real (not 0 chars followed by EOF or LINE_FEED)
  increment the line count.
  if lines have overflowed the page or line ended with FORM_FEED
  zero line count.
  increment page count.
  if the line is real 
  increment number of comments, etc., depending on what
  information about the line was counted.
  Make sure the final page is counted.

  PARAMETERS:
  fp:             pointer to a FILE.
  file_tally:     counts for this file.

  RETURNS:
  nothing.

  GLOBALS:
  page_size:      the number of lines per page.

  CALLS:
  tally_line:     Determines what's on a line.
  panic:          'Handles' program errors.

  CALLED BY:
  main

  HISTORY:
  Initial coding finished June 5, 1981 by Brian Marick of DTI.
*/

tally_file (fp, file_tally)

    FILE * fp;
    struct tally   *file_tally;


{
    register int    end_char;                           /* character which ended line just processed. May contain EOF 
                                                         */
    struct line line_info;                              /* information about the line last processed. */
    register int    line_count = 0;                     /* lines on current page. */


    file_tally->pure_code = file_tally->pure_comment = file_tally->both = file_tally->blank = file_tally->pages = 0;
    do
    {
        end_char = tally_line (fp, &line_info);
        if (!line_info.null_line)
            line_count++;
        if ((line_count >= page_size) || (end_char == FORM_FEED))

        {
            line_count = 0;
            (file_tally->pages)++;
        }
        if (!line_info.null_line)
        {
            if (line_info.code && line_info.comment)
                (file_tally->both)++;
            else
                if (line_info.code)
                    (file_tally->pure_code)++;
                else
                    if (line_info.comment)
                        (file_tally->pure_comment)++;
                    else
                        (file_tally->blank)++;
        }
    }
    while (end_char != EOF);
    if (line_count > 0)
        (file_tally->pages)++;                          /* count the last page. */
}



/*
  NAME:
  show_tally

  FUNCTION:
  prints counts in proper columns.

  ALGORITHM:
  Print name of file.
  If name of file is shorter than one tab
  Put in a tab.
  Print values in appropriate columns.

  PARAMETERS:
  name:           name of file.
  name_tally:     counts associated with that file.

  RETURNS:
  nothing

  GLOBALS:
        

  CALLS:
  printf:         format output to standard output.
  strlen:         returns length of a string.

  CALLED BY:
  main

  HISTORY:
  Initial Coding finished on June 5, 1981 by Brian Marick of DTI
*/

show_tally (name, name_tally)

    char   *name;
    struct tally   *name_tally;

{
    printf ("%s", name);
    if (strlen (name) < TABSIZE)
        printf ("\t");
    printf ("\t%d", name_tally->pure_code);
    printf ("\t%d", name_tally->pure_comment);
    printf ("\t%d", name_tally->both);
    printf ("\t%d", name_tally->blank);
    printf ("\t%d", name_tally->pure_code + name_tally->both);
    printf ("\t%d", name_tally->pure_comment + name_tally->both);
    printf ("\t%d", name_tally->pure_code + name_tally->pure_comment +
            name_tally->both + name_tally->blank);
    printf ("\t%d", name_tally->pages);
    printf ("\n");
}



/*
  NAME:
  make_total

  FUNCTION:
  adds counts for one file to total counts.

  ALGORITHM:
  adds counts for one file to total counts.

  PARAMETERS:
  total_tally:    counts for all files so far.
  file_tally:     counts for one particular file.

  RETURNS:
  nothing.

  GLOBALS:
  none.

  CALLS:
  nothing.

  CALLED BY:
  main

  HISTORY:
  Initial Coding finished on June 5, 1981 by Brian Marick of DTI.
*/

make_total (total_tally, file_tally)

    struct tally   *total_tally;
    struct tally   *file_tally;

{
    total_tally->pure_code += file_tally->pure_code;
    total_tally->pure_comment += file_tally->pure_comment;
    total_tally->both += file_tally->both;
    total_tally->blank += file_tally->blank;
    total_tally->pages += file_tally->pages;
}



/*
  NAME:
  tally_line

  FUNCTION:
  Determine if line is blank, has code or comment.

  ALGORITHM:
  Set default cases.
  while the gotten token doesn't mark end of line
  mark that the line is real (has something in it)
  depending on the value of token and whether we are in a comment or not
  store information about line.
  if the end of line mark is newline
  make sure that the line has been marked real.

  PARAMETERS:
  fp:             pointer to a file.
  line_info:      will contain the information about the line.

  RETURNS:
  the character that ended this line.

  GLOBALS:
  in_comment:     TRUE if we are in a comment now.

  CALLS:
  get_token:      gets the next 'thing' on the current line.
  fprintf:        print to file.

  CALLED BY:
  tally_file:     which accumulates the information for each line
  processed by this function.

  HISTORY:
  Initial Coding finished June 5, 1981 by Brian Marick of DTI.
*/

tally_line (fp, line_info)

    FILE * fp;
    struct line *line_info;

{
    int     eoln_char;                                  /* Character which ended this line. */
    register    TOKEN token;                            /* Current token from get_token. */


    line_info->null_line = TRUE;
    line_info->blank = !in_comment;                     /* default blank line if not in comment */
    line_info->comment = in_comment;                    /* but if in comment, not that. */
    line_info->code = FALSE;
    while ((token = get_token (fp, &eoln_char)) != T_END_LINE)
    {
        line_info->null_line = FALSE;
        switch (token)
        {
        case T_START_COMMENT: 
            in_comment = TRUE;                      /* no matter if we are already in a comment. */
            line_info->comment = TRUE;
            line_info->blank = FALSE;
            break;
		case T_START_CPP_COMMENT:
			if (!in_comment)
			{
				in_cpp_comment = TRUE;
				line_info->comment = TRUE;
				line_info->blank = FALSE;
			}
            break;
        case T_END_COMMENT:
			if (!in_cpp_comment)
			{
				if (!in_comment)
					fprintf (stderr, "lc: Missing /*\n");
				in_comment = FALSE;
				line_info->comment = TRUE;
				line_info->blank = FALSE;
			}
            break;
        case T_TEXT: 
            if (!in_comment && !in_cpp_comment)
            {
                line_info->code = TRUE;
                line_info->blank = FALSE;
            }
            break;
        }
    }
    if (eoln_char == '\n')                              /* take care of bare newlines. */
        line_info->null_line = FALSE;
    else
        if (eoln_char == EOF)
            in_comment = FALSE;                         /* EOF delimits a comment. */
	in_cpp_comment = FALSE;								/* C++ comment ends at end of line */
	return (eoln_char);
}



/*
  NAME:
  panic.c


  FUNCTION:
  Print error message and quickly exit.

  ALGORITHM:
  Print error message and quickly exit.

  PARAMETERS:
  status:         exit status that should be returned.
  reason:         what should be typed to standard error.

  RETURNS:
  exit status.

  GLOBALS:
  none.

  CALLS:
  fprint:         print to a selected file.
  exit:           leave.

  CALLED BY:
  almost anyone.

  HISTORY:
  Initial coding June 9, 1981 by Brian Marick of DTI.
*/


panic(status, reason)

    int     status;
    char    *reason;

{
    fprintf(stderr, "panic: %s\n", reason);
    exit(status);
}

