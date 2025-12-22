/************************************************/
/* Tokens definitions file.			*/
/* This file must be processed with:		*/
/*	lex proto.l				*/
/* to generate the file lex.yy.c		*/
/*						*/
/* This file is part of genproto v1.2		*/
/* Copyright November 1996 by Nicolas Pomarede.	*/
/************************************************/


%{

# include <stdio.h>
# include "proto.h"


/*--------------------------------------*/
/*	Variables C gérées par LEX	*/
/*--------------------------------------*/

int		lineno=1;		/* on compte à partir de 1 */

char		ParamBuf[ PARAMLEN ];	/* pour stocker les paramètres d'une fonction */
int		ParamBufLen;


%}

%x comment

ID	[~a-zA-Z_][a-zA-Z0-9_]*
SPACE	[ \t]+

%%


"/*"			BEGIN(comment);
<comment>[^*\n]*
<comment>"*"+[^*/\n]*
<comment>\n		lineno++;
<comment>"*"+"/"	BEGIN(INITIAL);


"//"			{ /* ignore commentaire C++ */
			  while ( input() != '\n' )
			      ;			/* ignore le commentaire */

			  unput ( '\n' );	/* remet le \n pour que LEX puisse le compter */
			}

"#"			{ /* ignore préprocesseur */
			  while ( input() != '\n' )
			      ;			/* ignore la ligne */

			  unput ( '\n' );	/* remet le \n pour que LEX puisse le compter */
			}


auto		|
break		|
case		|
continue	|
default		|
do		|
else		|
for		|
goto		|
if		|
register	|
return		|
sizeof		|
switch		|
typedef		|
while		|
include		|
define		|
ifdef		|
ifndef		|
elif		|
catch		|
delete		|
new		|
private		|
protected	|
public		|
this		|
throw		|
try			return RESET;


char		|
const		|
double		|
enum		|
extern		|
float		|
int		|
long		|
short		|
signed		|
static		|
struct		|
union		|
unsigned	|
void		|
volatile	|
class		|
friend		|
inline		|
virtual		|
"&"		|
"*"			return KEYWORD;


"("			{
			  register int OpenPar = 1;
			  register int c;
			  register int index = 0;

			  ParamBuf[ index++ ] = '(';
			  for ( ; ; )
			    {
			      while ( ( c = input() ) != ')' )
			        {
			          if ( c == '\n' )
			            lineno++;
				  else if ( c == '(' )
				    OpenPar++;
			          ParamBuf[ index++ ] = c;

				  if ( index >= PARAMLEN-1 )	/* ligne trop longue ? */
				    index = PARAMLEN-2;		/* bloque index */
			        }

			      ParamBuf[ index++ ] = ')';
			      if ( OpenPar == 1 )
			        break;
			      else
				OpenPar--;
			    }


			  ParamBufLen = index;
			  ParamBuf[ index ] = '\0';
			  return PARAMS;
			}


"{"			{
			  register int OpenPar = 1;
			  register int c;

			  for ( ; ; )
			    {
			      while ( ( c = input() ) != '}' )
			        {
			          if ( c == '\n' )
			            lineno++;
				  else if ( c == '{' )
				    OpenPar++;
			        }

			      if ( OpenPar == 1 )
			        break;
			      else
				OpenPar--;
			    }
			  return BLOC;
			}


":"			return ':';

"::"			return DEUX_POINTS;

{ID}			return ID;

{SPACE}			/* ignore espaces */

\n			lineno++;

.			return RESET;	/* ';' , '=' , etc... */


%%

int	yywrap ( void )
{
  return 1;
}


/************************************************/
/*		FIN DE proto.l			*/
/************************************************/
