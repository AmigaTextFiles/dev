/*
This file is licensed to you under the license specified in the included file
`LICENSE'. Look there for further details.
*/


/*
  Called by yyparse on error.
 */
#include <stdio.h>

extern int gengetopt_count_line; 

void
yyerror (char *s)
{
  fprintf (stderr, "gengetopt: %d: %s\n", gengetopt_count_line, s);
}

