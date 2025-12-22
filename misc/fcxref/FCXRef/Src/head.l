%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

extern int AddFunc(char *file, char *func,int linenum);
extern int opt_struct;

char *actfile;
int lineno;
char struname[1024];
int struline;

%}

%x      xdefine
%x		xstruct
%x		ins

%%

[" "\t]*"#define"[" "\t]+	{ BEGIN(xdefine); }
[" "\t]*"struct"[" "\t]+	{
							if(opt_struct!=0) BEGIN(xstruct);
							}

<xdefine>[a-zA-Z0-9_]+	{
						int l;
						l=strlen(yytext)-1;
						if(yytext[l]!='H'&&yytext[l-1]!='_') {
							AddFunc(actfile,yytext,lineno);
							}
						BEGIN(INITIAL);
						}
<xstruct>[a-zA-Z0-9_]+	{
						struline=lineno;
						if(strlen(yytext)<1024) strcpy(struname,yytext);
						else struname[0]='\0';
						BEGIN(ins);
						}
<ins>[^" "\t\n{]		{
						BEGIN(INITIAL);
						}
<ins>[" "\t]*
<ins>\n					{ lineno++; }
<ins>"{"				{
						if(struname[0]!='\0') {
							AddFunc(actfile,struname,struline);
						}
						BEGIN(INITIAL);
						}
<xstruct>"\n"			{ ++lineno; BEGIN(INITIAL); }
<xstruct>.				{ BEGIN(INITIAL); }

"\n"					{ ++lineno; }
.

%%

void scanhead(char *file) {
	FILE *f;

	actfile=file;
	lineno=1;
	if(NULL==(yyin=f=fopen(file,"rb"))) return;
	yylex();
	fclose(f);
}

