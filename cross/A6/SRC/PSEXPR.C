/* ------------------------------------------------------------------
    PSEXPR.C -- expression parser for the A6 cross assembler
     This is free software, please see the file
     "COPYING" for copyright and licence details
   ------------------------------------------------------------------ */

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>

#include "error.h"
#include "global.h"
#include "label.h"
#include "outf.h"
#include "pstext.h"

#define RETURNLO (1)
#define RETURNHI (2)

#define MODE_WAITDEFINE (1)
#define MODE_WAITOPERATOR (2)
#define MODE_LABEL (100)
#define MODE_DENARY (200)
#define MODE_HEX (300)
#define MODE_EXISTS (700)

unsigned int parseexpr(char *expr)
{
	int mode=MODE_WAITDEFINE, skipws=1, returnmode=0, i;
	unsigned int accum=0,next=0;
	char sign='+', operator='+';
	static char buffer[256];
	int pos=0, negate=0;

	/* To ensure that all modes expire at EOL */
	static char buffer2[256];

	char *e=(char*)buffer2;
	strcpy(e,expr);
	i=strlen(e);
	e[i++]=' '; e[i]=0;

	/* Check for returning only high or low byte */
	if(*e=='<') {
		returnmode=RETURNLO; e++;
	} else if(*e=='>') {
		returnmode=RETURNHI; e++;
	}

	while(*e && mode) {
		#ifdef DEBUG
	  	printf("parseexpr: %c sign=%c operator=%c mode=%u skipws=%u accum=%u next=%u\n",*e,sign,operator,mode,skipws,accum,next);
		fflush(stdout);
	   	#endif

		/* Skip whitespace */
		if(skipws)
			if(isspace(*e))
				e++;
			else
				skipws=0;

		else switch(mode) {
			/* Waiting for number/label */
			case MODE_WAITDEFINE:
				pos=0;

				if(isalpha(*e) || *e=='_') {	/* label */
					mode=MODE_LABEL; skipws=0; break; }

				if(isdigit(*e)) {		/* denary */
					mode=MODE_DENARY; skipws=1; break; }

				switch(*e) {
					case '-':		/* -ve number */
						e++; sign='-'; break;
					case '~':		/* negate */
						e++; negate=1; break;
					case '\'': case '\"':	/* character */
						mode=600; skipws=1; break;
					case '*':		/* PC Counter */
						e++; next=outf_getpc(); mode=3; break;
					case '$':		/* hex */
						e++; mode=MODE_HEX; skipws=1; break;
					case '%':		/* binary */
						e++; mode=400; skipws=1; break;
					case '@':		/* octal */
						e++; mode=500; skipws=1; break;
					case '[':		/* label exists */
						e++; mode=MODE_EXISTS; skipws=0; break;
					default:
						mode=(int)*e;
						e=malloc((256+strlen(e))*sizeof(char));
						sprintf(e,"illegal character `%c' to begin label in `%s'",mode,expr);
						error(e,ERR_PASS2);
					return(-1);
				}

				break;

			/* Waiting for operator */
			case MODE_WAITOPERATOR:
				if(isspace(*e)) {
					e++; break;
				} else {
					switch(*e) {
						case '^': case '?': case '&': case '|':
							operator=*e++;
							if(operator==*e) {
								operator=-operator;
								e++;
							}
							mode=MODE_WAITDEFINE; skipws=1;
							break;

						case '+': case '*': case '/': case'-':
							operator=*e++;
							mode=MODE_WAITDEFINE; skipws=1;
							break;

						default:
							e[1]=0;
							errors("illegal character `%s' in expression",e,ERR_PASS2);
							return(-1);
					}
				}

				break;

			/* Value of label */
			case MODE_LABEL:
				if(isalnum(*e) || (*e=='_') || (*e=='.') || (*e=='$'))
					buffer[pos++]=*e++;
				else {
					buffer[pos]=0; pos=0;
					next=lbl_getval((char *)buffer);
					if(next==-1) {
						errors("undefined label `%s'",buffer,ERR_PASS2);
						return(0xffff);
					}
					mode=3;
				}
				break;

			/* Is label defined? */
			case MODE_EXISTS:
				if(isalnum(*e) || (*e=='_') || (*e=='.') || (*e=='$'))
					buffer[pos++]=*e++;
				else {
					if(*e==']')
						e++;
					else {
						error("unterminated square brackets",ERR_PASS2);
						return(-1);
					}

					buffer[pos]=0; pos=0;
					if(mode==MODE_LABEL) {
						next=lbl_getval((char *)buffer);
						if(next==-1) {
							errors("undefined label `%s'",buffer,ERR_PASS2);
							return(0xffff);
						}
					} else {
						next=(lbl_getptr((char *)buffer,lbl_getlocale()))?1:0;
					}
					mode=3;
				}
				break;

			/* Denary */
			case MODE_DENARY:
				if(isdigit(*e))
					next=(next*10) + ((*e++)&0x0f);
				else
					mode=3;
				break;

			/* Hex */
			case MODE_HEX:
				if(isdigit(*e))
					next=(next<<4) + ((*e++)&0x0f);
				else if(*e <= 'f' && *e >= 'a')
					next=(next<<4) + ((*e++)-'a')+10;
				else if(*e <= 'F' && *e >= 'A')
					next=(next<<4) + ((*e++)-'A')+10;
				else mode=3;
				break;

			/* Binary */
			case 400:
				if(*e == '0' || *e=='1')
					next=(next<<1) + (*e++ & 1);
				else
					mode=3;
				break;

			/* Octal */
			case 500:
				if(*e >= '0' && *e<='8')
					next=(next<<3) + (*e++ & 7);
				else
					mode=3;
				break;

			/* Ascii */
			case 600:
				if(e[0] != e[2]) {
					error("incorrectly quoted character in expression",0);
					return(-1);
				}

				next=pstext_convchar(e[1]);
				e+=3;
				mode=3;
				break;
		} /* switch(mode) */

		/* Do operator */
		if(*e==0 || mode==3) {
			if(sign=='-') next=-next;

			switch(operator) {
				case '+':
					accum+=next; break;

				case '-':
					accum-=next; break;

				case '*':
					accum*=next; break;

				case '/':
					if(next==0) {
						error("division by zero",ERR_PASS2);
						return(0xffff);
					} else
						accum/=next; break;

				case '^': case '|':
					accum|=next; break;

				case -('^'): case -('|'):
					accum=accum||next; break;

				case '?':
					accum^=next; break;

				case -('?'):
					accum=accum^next?1:0; break;

				case '&':
					accum&=next; break;

				case -('&'):
					accum=accum&&next; break;
			}

			next=0; operator='+'; sign='+';

			if(*e)
				mode=MODE_WAITOPERATOR;
			else
				mode=0;
		} /* End of operator */
	} /* while */

	#ifdef DEBUG
	printf("parseexpr returns %u\n",accum);
	fflush(stdout);
	#endif

	if(accum<0) accum=accum+0x10000;

	if(accum>0xffff)
		error("expression overflow -- truncated to 16 bits",ERR_WARNING);

	switch(returnmode) {
		case RETURNLO:
			return(accum & 0xff);
		case RETURNHI:
			return(accum>>8);
		default:
			return(accum & 0xffff);
	}
}
