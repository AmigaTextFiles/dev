/****************************************
** Lexer file for the ACTION! language
** Created Feb 6, 2010
** this is just the first version to mostly
** test weather or not I have any
** understanding of just how FLEX works...
** As of the first version, I am pretty
** sure I am parsing out most of the
** tokens required for ACTION!
**
** This file is in the pubglic domain.
** Author: Jim Patchell
** 
***************************************/

%option noyywrap

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "yystype.h"
#include "yygrammar.h"
#include "symtab.h"
%}

DIGIT     [0-9]
ID        [_A-Za-z][_0-9A-Za-z]*
HEXDIGIT	[0-9A-Fa-f]


%%

{DIGIT}+    {yylval.name = NewString(yytext);return CONSTANT;}
MODULE		return MODULE;
DO			return DO;;
OD			return OD;
IF			return IF;
THEN		return THEN;
ELSE		return ELSE;
ELSEIF		return ELSEIF;
FI			return FI;
FOR			return FOR;
TO			return TO;
STEP		return STEP;
WHILE		return WHILE;
UNTIL		return UNTIL;
TYPE		return TYPE;
BYTE		return BYTE;
CHAR		return CHAR;
CARD		return CARD;
INT			return INT;
AND			return AND;
OR			return OR;
MOD			return MOD;
LSH			return LSH;
RSH			return RSH;
DEFINE		return DEFINE;
PROC		return PROC;
FUNC		return FUNC;
RETURN		return RETURN;
POINTER		return POINTER;
ARRAY		return ARRAY;
{ID}		{
              {
			    symbol *pSym;
                printf("%s\n",yytext);
				yylval.name = NewString(yytext);
				pSym = findsym( Symbol_tab, yylval.name );
				if(pSym == NULL) return IDENTIFIER;	/* symbol not defined yet	*/
				else if (pSym->Token) return pSym->Token;
				else return IDENTIFIER;
			  }
			}
"$"{HEXDIGIT}+	{yylval.name = NewString(&yytext[1]); return HEX_CONSTANT;}	
[ \t\n\r]*	/* eat white space	*/
";".+     printf("**Comment**\n");
\"(\\.|[^\"])*\"   {int l; yylval.name = NewString(&yytext[1]);l = strlen(yylval.name); yylval.name[l-1] = 0;  return STRING;}
"==+"		return ASS_ADD;
"==-"		return ASS_SUB;
"==*"		return ASS_MUL;
"==/"		return ASS_DIV;
"==|"		return ASS_OR;
"==&"		return ASS_AND;
"==#"		return ASS_XOR;
"=="MOD		return ASS_MOD;
"=="LSH		return ASS_LSH;
"=="RSH		return ASS_RSH;
"<>"		return NEQ;
"#"			return NEQ;
">="		return GTE;
"<="		return LTE;
"'".		{yylval.name = NewString(&yytext[1]); return LITERAL;}
[\+\-\*/^\@\(\)=\,><\[\]]	return yytext[0];

%%

typedef struct {
	char *name;
	int token;
}TOKEN_TABLE;

TOKEN_TABLE tt[] = {
 {"LITERAL",LITERAL},
 {"STRING", STRING},
 {"HEX_CONSTANT" , HEX_CONSTANT} ,
 {"CONSTANT" , CONSTANT },
 {"RSH" , RSH },
 {"LSH" , LSH },
 {"MOD" , MOD} ,
 {"IDENTIFIER" , IDENTIFIER },
 {"ASS_XOR", ASS_XOR} ,
 {"ASS_AND" , ASS_AND} ,
 {"ASS_OR" , ASS_OR} ,
 {"ASS_MOD" , ASS_MOD} ,
 {"ASS_DIV" , ASS_DIV} ,
 {"ASS_MUL" , ASS_MUL} ,
 {"ASS_SUB" , ASS_SUB} ,
 {"ASS_ADD" , ASS_ADD} ,
 {"FUNC" , FUNC} ,
 {"PROC" , PROC} ,
 {"<EOF>" , ACTION_EOF} ,
 {"RETURN" , RETURN} ,
 {"MODULE" , MODULE} ,
 {"TYPE" , TYPE },
 {"POINTER" , POINTER },
 {"ARRAY" , ARRAY} ,
 {"CARD" , CARD} ,
 {"INT" , INT} ,
 {"CHAR" , CHAR} ,
 {"BYTE" , BYTE} ,
 {"EXIT" , EXIT} ,
 {"UNTIL" , UNTIL} ,
 {"WHILE" , WHILE} ,
 {"FI" , FI} ,
 {"ELSEIF" , ELSEIF} ,
 {"ELSE" , ELSE },
 {"THEN" , THEN} ,
 {"IF" , IF} ,
 {"OD" , OD} ,
 {"DO" , DO} ,
 {"STEP" , STEP} ,
 {"TO" , TO} ,
 {"FOR" , FOR },
 {"OR" , OR} ,
 {"AND" , AND} ,
 {"LTE" , LTE} ,
 {"GTE" , GTE },
 {"EQU" , EQU },
 {"NEQ" , NEQ} ,
 {"DEFINE",DEFINE},
 {NULL,0}
};

char *TokenLookup(int token)
{
	static char S[128];
	int i;
	char *p;

	if(token < 256)	//sincle character tokens
	{
		S[0] = (char)token;
		S[1] = 0;
	}
	else
	{
		for(i=0;tt[i].token;++i)
		{
			if(token == tt[i].token)
			{
				strcpy(S,tt[i].name);
				switch(token) {
					case STRING:
					case LITERAL:
					case CONSTANT:
					case HEX_CONSTANT:
					case IDENTIFIER:
						p = &S[strlen(S)];
						sprintf(p,":=:%s",yytext);
						break;
				}
				break;
			}
		}
	}
	return S;
}

