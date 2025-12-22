/* This file has been separated from lc.c just to show how
   GCT works with separate files and updated files. */

#include "lc.h"
#include <stdio.h>


/*
  NAME:
  get_token

  FUNCTION:
  Gets and identifies a start-of-comment, end-of-comment, white space,
  end-of-line, or text.

  ALGORITHM:
  get a character.
  identify the character as part of a token, getting another character
  if necessary and pushing that character back if necessary.
  if text or comment has been found, we can skip much of this line.

  PARAMETERS:
  fp:             pointer to a file.
  eoln_char:      what character signalled end-of-line.

  RETURNS:
  type of token.

  GLOBALS:
  none.

  CALLS:
  get_character:  get a character from a particular file.
  PUSH_BACK:      put the character back.
  skip_token:     skip to next possible different token.

  CALLED BY:
  tally_line:     which interprets the tokens.

  HISTORY:
  Initial coding Jun 5, 1981 by Brian Marick of DTI.
  Aug 16, 1983    Brian Marick of Compion         Handle brackets.
  Jul 12, 2004    Ray Rizzuto                     Added C++ comments parsing
*/

TOKEN
get_token (fp, eoln_char)

    FILE * fp;
    int    *eoln_char;

{

    register int    c;                                  /* Any character. */
    register    TOKEN token;                            /* The token, when identified. */


    c = get_character (fp);
    switch (c)
    {
    case ST_COMM1: 
        c = get_character (fp);
        if (c == ST_COMM2)
            token = T_START_COMMENT;
        else if (c == ST_COMM1)
			token = T_START_CPP_COMMENT;
		else		
        {
            token = T_TEXT;
            PUSH_BACK (c, fp);
        }
        break;
    case EN_COMM1: 
        c = get_character (fp);
        if (c == EN_COMM2)
            token = T_END_COMMENT;
        else
        {
            token = T_TEXT;
            PUSH_BACK (c, fp);
        }
        break;
    case TAB: 
    case BLANK: 
        token = T_WHITE;
        break;
    case LCURL:
    case RCURL:
        token = (white_bracket ? T_WHITE : T_TEXT);
        break;
    case NEWLINE: 
    case FORM_FEED: 
    case EOF: 
        token = T_END_LINE;
        break;
    default: 
        token = T_TEXT;
        break;
    }

    *eoln_char = c;                                     /* return character that ended the line. */
    if (token == T_TEXT)                                /* can skip much text */
        skip_token (fp);
    return (token);
}

/*
  NAME:
  skip_token

  FUNCTION:
  When the T_TEXT token is discovered, much
  of the rest of the line may be profitably skipped.
  Note that T_TEXT may be found whether or not we are in a comment.

  ALGORITHM:
  Keep getting characters until the gotten character is EOF, newline,
  form feed, ST_COMM1 or EN_COMM1.
  Push the last character gotten back on the input stream.

  PARAMETERS:
  fp:             file pointer.

  RETURNS:
  nothing.

  GLOBALS:
  none.

  CALLS:
  get_character:  get a character from the input stream.
  PUSH_BACK:      put it back.

  CALLED BY:
  get_token:      which gets tokens from input and returns their type.

  HISTORY:
  First coded on June 8, 1981 by Brian Marick of DTI.

*/


skip_token (fp)

    FILE * fp;

{
    register int    ch;                                 /* character to be read. */


    /*
     * Delete the comments around the following statement, then reinstrument.
     * Feel free to change line numbering.
     *
     * if (in_comment) ch = ch+1; 
     */
    
    while (((ch = get_character (fp)) != ST_COMM1)
           && (ch != EN_COMM1)
           && (ch != FORM_FEED)
           && (ch != NEWLINE)
           && (ch != EOF))
        ;
    PUSH_BACK (ch, fp);
}

/*
  NAME:
  get_character

  FUNCTION:
  Return a character.
  If a single or double quote is escaped by backslash, return the
  backslash.
  If we are not in a comment and a single quote is found, skip the
  character in single quotes and return a single quote.
  if we are not in a comment and a double quote is found, skip the
  string and return a double quote.

  ALGORITHM: 
  Use PULL_OFF to get a character. (PULL_OFF will handle backslash.)
  if not in a comment
  if the character is a double quote
  keep getting characters until a matching quote character is 
  found or an end of file marker is found.
  if an end of file marker was found, complain.
  else if the character is a single quote
  search for the matching quote.
  if the matching quote is never found
  print an error message.
  return the character.

  PARAMETERS:
  fp:             pointer to this file.

  RETURNS:
  ch:             the character gotten.

  GLOBALS:
  in_comment:     TRUE if we are currently in a comment.

  CALLS:
  PULL_OFF:       a macro that gets characters but returns \ for
  escaped characters.

  CALLED BY:
  get_token:      gets a token from the input stream
  skip_token:     skips text when text has already been found.

  HISTORY:
  Initial coding June 8, 1981 by Brian Marick of DTI.

*/


get_character (fp)

    FILE * fp;


{
    register int    ch;                                 /* the character. */


    PULL_OFF (ch, fp);
    if (!in_comment && !in_cpp_comment)
    {
        if (ch == STRING)
        {
            do
            {                                           /* braces are necessary. */
                PULL_OFF (ch, fp);
            }
            while ((ch != STRING) && (ch != EOF));
            if (ch != STRING)                           /* no matching double quotes. */
            {
                fprintf (stderr, "lc: Unclosed string.\n");
                ch = STRING;                            /* return string. */
                                                        /* note that it is unnecessary to PUSH_BACK EOF. */
            }
        }
        else
            if (ch == QUOTE)
            {
                register int    c;                      /* check for matching quote. */
                do
                {
                    PULL_OFF(c, fp);
                    if (EOF == c || NEWLINE == c)
                    {
                        PUSH_BACK(c, fp);
                        fprintf (stderr, "lc:  unterminated character constant.\n");
                        break;
                    }
                }
                while (c != QUOTE);
            }
    }
    return (ch);
}
