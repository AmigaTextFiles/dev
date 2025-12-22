%{

#undef yywrap

#include <stdio.h>
#include <assert.h>

//#ifndef INCLUDED_COBPP_H
#include "cobpp.h"
//#endif
 

int i;
unsigned long columnLen;
unsigned long columnCount = 1;
unsigned long lineCount = 1;
char lineout[80];

void lineExpand(void) ;
void tabExpand(void) ;
void lexError( char * msg ) ;

%}

eol	[\n]
tab	[\t]
blank   [ ]
Quote	['"]
ws	[ \n]

%x INITAL FREE FIXED FIXED_7 FIXED_A FIXED_LC COMMENT 

%%
		if ( globalEnvPtr->format == 0 ) {
		  /* free == 0, fixed == 1 */
                        printf("%06d", lineCount*10);
			BEGIN( FREE ) ;}
		else if ( globalEnvPtr->format == 1)
			BEGIN( FIXED ) ;
		else {
			assert(1);
		}
<*>{tab}	{ tabExpand();  }

<FREE>{eol}	{ lineCount++;columnCount=0; printf("\n%06d", lineCount*10); }
<FREE>{Quote}{ws}+"&"{ws}+{Quote}  { /*remove for concatination */; }
<FREE>^"*".*$		{ ECHO; /* remove line */ ; }

<FREE>^[^ ]		{ columnCount++;
			  fprintf(stderr,
			    	    "%s:%lu: Invaild character (%c) in"
				    "column 7.\n"
				    ,globalEnvPtr->filename
				    ,lineCount
				    ,yytext[0]
				);
				/* remove line */  }
<FREE>^"/".*$		{ /* remove line */ ; }
<FREE>^"D".*$		{ 	if ( globalEnvPtr->debug == 1 ) {
					yytext[0]=' ';
					 ECHO;
			   	} /* else remove line */
			}
<FREE>^"$".*$		{ 	fprintf(stderr,
					"%s:%lu: Warning: Directive ignored.\n"
					,globalEnvPtr->filename
					,lineCount); 
				 globalEnvPtr->errFlag++;
			}	
<FREE>.*		{
                         columnLen = strlen(yytext);
			 if ( columnLen > 66 ) {
                            lineExpand();
                         }
                         else {
                            columnCount = columnLen;  
                            ECHO; 
                         }
                        }




<FIXED,FIXED_A>{eol}	{ lineCount++;columnCount=0;ECHO; BEGIN(FIXED); }
<COMMENT>{eol}		{ BEGIN(FIXED); lineCount++;columnCount=0; ECHO; }
<FIXED_LC>{eol}		{ ECHO; BEGIN(FIXED); lineCount++;columnCount=0; }

<COMMENT>.		{ ECHO; /* eat comments */ /*printf("*")*/ ; }
<FIXED_LC>.	{ /* eat comments */ /*printf("*")*/ ; }

<FIXED>^.{6}		{ columnCount+=6 ; BEGIN(FIXED_7); 
				/*  remove sequence number */ }
<FIXED_7>"*"	|
<FIXED_7>"/" 	|
<FIXED_7>"$" 		{ ECHO; BEGIN(COMMENT); /* comment line remove */ }
	
<FIXED_7>"D" 		{ columnCount++;
			   if ( globalEnvPtr->debug == 1 ) 
				BEGIN(FIXED_A);
			   else 
				BEGIN(COMMENT);
			   
			}

<FIXED_7>[\n]		{ BEGIN(FIXED); lineCount++;columnCount=0;ECHO; }
<FIXED_7>[ ]		{ columnCount++;BEGIN(FIXED_A);ECHO; }
<FIXED_7>[^ \n]		{ globalEnvPtr->errFlag++;
			  fprintf(stderr,
			    	    "%s:%lu: Invaild character (%c) in"
				    "column 7.\n"
				    ,globalEnvPtr->filename
				    ,lineCount
				    ,yytext[0]
				);
			  BEGIN(COMMENT);
			}
	
<FIXED_A>{eol}.{6}"-"{blank}{4}{Quote}	 { /* Continuation line remove */ 
					lineCount++;columnCount=0; BEGIN(FIXED_A); }

<FIXED_A>{Quote}{eol}.{6}"-"{blank}{4}{Quote} { lineCount++;columnCount=0; BEGIN(FIXED_A);
				 /* Continuation line remove */  }
					
<FIXED,FIXED_A>.	{ /* any other line */
			 	columnCount++;
				/* don't echo */
				if ( columnCount > 72 ) {
					BEGIN(FIXED_LC);
				}
				/* }else if ( columnCount > 80 ){ 
				 * lexError( "Record Exceeded 80 cols!"); } 
				 */
				else {
					ECHO;
				}
			}	




%%
/*
 * print error on tab.
 */
void lineExpand(void) {
  int nlines, j;
  char *s = yytext, delm = '0';
  
  for(j=0; j<columnLen; j++) {
     if( (yytext[j] == '\'') || (yytext[j] == '"') ) {
        delm = yytext[j];
        j = columnLen + 3;
     }
  }
  if(delm == '0') {
    fprintf(stderr, "Error: quote/double expected in litteral, not found");
    return;
  }
  strncpy(lineout, s, 66);
  lineout[66] = '\0';
  printf("%s", lineout);
  columnCount = 66;
  s = yytext + 66;
  nlines = ((columnLen - 66) / 60) + 1;

  for(j=1; j<nlines; j++) {
     sprintf(lineout, "-    %c", delm);
     strncat(lineout, s, 60);
     lineout[66] = '\0';
     s = s + 60;
     columnCount =  columnCount + 66;
     lineCount++;
     printf("\n%06d%s", lineCount*10, lineout); 
  }

  if( (j = strlen(s)) > 0) {
    sprintf(lineout, "-    %c", delm);
    strncat(lineout, s, j);
    lineout[6 + j] = '\0';
    lineCount++;
    printf("\n%06d%s", lineCount*10, lineout); 
  }
  		    
/*
    fprintf(stderr,
           "%s: Character (%c) in column %d, line %lu.\n",
	    globalEnvPtr->filename,
	    yytext[0],
            columnCount,
            lineCount);
*/
}

void tabExpand(void) {
 
        /*
         * Check the warning level settings 
         * output the appropriate message.
         *
         */
/*
        if ( globalEnvPtr->tab2space == 0 ) {
*/
/* now is a tab always an error?? yes? */
	(void)fprintf(stderr,
		"%s:%lu: Error tab in column %lu\n"
		,globalEnvPtr->filename
		, lineCount, columnCount
	);
       globalEnvPtr->errFlag++;
	return;
/*
        }
 */
 
 
}

void lexError( char * msg ) {

	(void)fprintf(stderr,
		"%s:%lu: %s\n"
		,globalEnvPtr->filename
		,lineCount
		,msg
	);
	globalEnvPtr->errFlag++;
	return;
}
 
int yywrap(void) {
 
/* yywrap will be called to open files from the List of Files in the
 * Global Env struct.
 */
	return 1;
}

