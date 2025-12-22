/*                                                                              */
/*   (C) COPYRIGHT International Business Machines Corp. 1993                   */
/*   All Rights Reserved                                                        */
/*   Licensed Materials - Property of IBM                                       */
/*   US Government Users Restricted Rights - Use, duplication or                */
/*   disclosure restricted by GSA ADP Schedule Contract with IBM Corp.          */

/* definitions */
digit    [0-9]
char     [a-zA-Z_.]
alphanum [0-9a-zA-Z_.\-\*]
%{  /* code to be included */
#ifdef WIN32
#include <windows.h>
#endif
#include "Suite.h"
#include "TestList.h"
#include "AttrList.h"
#include "PropList.h"
#include "General.h"
#include "Print.h"
#include "TestName.h"
#include "PropName.h"
#include "NameList.h"
#include "Global.h"
#include "AttrName.h"
#include "Table.h"
#include <GL/gl.h>
#include <GL/glu.h>
#ifdef WIN32
#include <gl\glaux.h>
#endif
#include "AttrTab.h"
#include "PropTab.h"
#include "TestTab.h"
#if defined(__OS2__)
#include "y_tab.h"
#elif defined(WIN32)
#include "ytab.h"
#else
#include "y.tab.h"
#endif
#include <stdlib.h>
#include <malloc.h>

TablePtr attributes;
TablePtr properties;
TablePtr tests;
int printMode = 0;
#if defined(DEC)
int yylineno = 1;
#elif defined(WIN32)
int visualID = -1;
static int yylineno = 1;
#endif

%}
/* end of definitions */
%%
\{	return(openCurly);
\}	return(closeCurly);
\[	return(openBracket);
\]	return(closeBracket);
\(	return(openParen);
\)	return(closeParen);
"%"	return(Percent);
","	return(comma);

\/\*			{
			    A:
				switch (input()) {
				  case '*': goto B;
				  case 0: printf("GLperf: EOF found before comment ended\n"); exit(1);
#if defined(WIN32) || defined(DEC)
				  case '\n': yylineno++;
#endif
				  default:  goto A;
				}
			    B:
				switch (input()) {
				  case '*': goto B;
				  case '/': break;
				  case 0: printf("GLperf: EOF found before comment ended\n"); exit(1);
#if defined(WIN32) || defined(DEC)
				  case '\n': yylineno++;
#endif
				  default:  goto A;
				}
			}

\"			{
			    int i;
			    int n = 32;
			    char* buffer = (char*)malloc(n);
			    for (i=0; (buffer[i] = input()) != '"'; i++) {
#if defined(WIN32) || defined(DEC)
				if (buffer[i] == '\n') yylineno++;
#endif
				buffer = (i == n-2) ? (char*)realloc(buffer, n+=32) : buffer;
			    }
			    buffer[i] = (char)0;
			    yylval.attr = new_Attribute_String(buffer);
			    Attribute__SetLineNum(yylval.attr, yylineno);
			    free(buffer);
			    return(attrName);
			}

\/\/			{
			    char ch;
			    while ((ch = input()) != '\n');
#if defined(WIN32) || defined(DEC)
			    if (ch == '\n') yylineno++;
#endif
			}

\*			{
			    yylval.attr = new_Attribute_Int((int)WildCard);
			    Attribute__SetLineNum(yylval.attr, yylineno);
			    return(wildcard);
			}

[Aa][Ll][Ll]		{
			    yylval.attr = new_Attribute_Int((int)WildCard);
			    Attribute__SetLineNum(yylval.attr, yylineno);
			    return(wildcard);
			}

[Ff][Rr][Oo][Mm]	return(From);
[Tt][Oo]		return(To);
[Ss][Tt][Ee][Pp]	return(step);
[Pp][Rr][Ii][Nn][Tt][Ff]	return(Printf);

0x[0-9A-Fa-f]+		{
			    yylval.attr = new_Attribute_Int((int)strtol((const char*)yytext, NULL, 16));
			    Attribute__SetLineNum(yylval.attr, yylineno);
			    return(attrName);
			}

[+-]?{digit}+ 		{
			    yylval.attr = new_Attribute_Int((int)atoi((char*)yytext));
			    Attribute__SetLineNum(yylval.attr, yylineno);
			    return(attrName);
			}

[+-]?[0-9]*"."[0-9]*([eE][+-][0-9]+)?	{
			    yylval.attr = new_Attribute_Float((float)atof((char*)yytext));
			    Attribute__SetLineNum(yylval.attr, yylineno);
			    return(attrName);
			}

{alphanum}*	{
			    int i;
			    FILE* fp;

			    if (Table__Lookup(tests, (char*)yytext, &i)) {
				yylval.ival = i;
				return(testName);
			    } else if (Table__Lookup(properties, (char*)yytext, &i)) {
				yylval.attr = new_Attribute_Int((int)i);
			        Attribute__SetLineNum(yylval.attr, yylineno);
				return(PropName);
			    } else if (Table__Lookup(attributes, (char*)yytext, &i)) {
				yylval.attr = new_Attribute_Int((int)i);
			        Attribute__SetLineNum(yylval.attr, yylineno);
				return(attrName);
                            } else {
                                /* No error checking done here anymore */
				printf("GLperf: Line %d, Unidentifiable symbol \"%s\"\n",yylineno, (char*)yytext);
                                yylval.attr = new_Attribute_String((char*)yytext);
			        Attribute__SetLineNum(yylval.attr, yylineno);
                                return(errorName);
                            }
			}

\r*\n           {
#if defined(WIN32) || defined(DEC)
		    yylineno++;
#endif
		}
[ \t]+		{}
%%
void yyinit(int argc, char** argv)
{
    int i;

    for (i=1; i<argc; i++) {
        if (strcmp(argv[i],"-d")==0) {
	    printMode |= Delta;
        } else if (strcmp(argv[i],"-s")==0) {
	    printMode |= StateDelta;
        } else if (strcmp(argv[i],"-p")==0) {
	    printMode |= Pixels;
        } else if (strcmp(argv[i],"-u")==0) {
	    printMode |= MicroSec;
        } else {
            yyin = fopen(argv[i], "r");
            if (!yyin) {
                printf("GLperf: Cannot open input file: %s\n", argv[i]);
                exit(1);
            }
        }
    }

    attributes = new_Table();
    properties = new_Table();
    tests      = new_Table();
    Table__Load(attributes, Attributes, NumAttributes);
    Table__Load(properties, Properties, NumProperties);
    Table__Load(tests, Tests, NumTests);
}

int
yyclose(void)
{
    delete_Table(attributes);
    delete_Table(properties);
    delete_Table(tests);
    auxCloseWindow();
    return(0);
}

#ifndef yywrap
int yywrap(void)
{
  return(1);
}
#endif
