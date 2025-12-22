/*
** this file is used to tokenize an action
** file for parsing
**
** This file was  created Jan 15, 2010 by
** Jim Patchell.
**
** This file is yyin the public domain and
** may be used freely.
**
** All I ask is that this notice be left
** yyin the file.
*/

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include "tokens.h"
#include "symtab.h"
#include "hash.h"

char inbuf[2048];	//a big buffer to store things yyin
yyCol = 0;
yyLine = 1;

typedef struct {
		int token;
		char *kw;
} KEYWORD;
FILE *yyin;

typedef struct {
	char *b;
	int index;
	int size;
}UNGETBUF;

UNGETBUF ungetbuf;

static int debugmode = 0;


KEYWORD ktab[] = {
	{	AND,"AND"			},	//AMD
	{	OR,	"OR"			},	// OR
	{	ARRAY,"ARRAY"		},
	{	POINTER,"POINTER"	},
	{	BYTE,"BYTE"			},
	{	CARD,"CARD"			},
	{	INT,"INT"			},
	{	TYPE,"TYPE"			},
	{	DO,"DO"				},
	{	OD,"OD"				},
	{	IF,"IF"				},
	{	ELSEIF,"ELSEIF"		},
	{	ELSE,"ELSE"			},
	{	FI,"FI"				},
	{	FOR,"FOR"			},
	{	TO,"TO"				},
	{	STEP,"STEP"			},
	{	WHILE,"WHILE"		},
	{	UNTIL,"UNTIL"		},
	{	EXIT,"EXIT"			},
	{	PROC,"PROC"			},
	{	FUNC,"FUNC"			},
	{	RETURN,"RETURN"		},
	{	BEGIN,"BEGIN"		},
	{	END,"END"			},
	{	MODULE,"MODULE"		},
	{	LSH,"LSH"			},
	{	RSH,"RSH"			},
	{	MOD,"MOD"			},
	{	THEN,"THEN"			},
	{	CHAR,"CHAR"			},
	{	DEFINE,"DEFINE"		},
	{	XOR,"XOR"			},
	{	LONG,"LONG"			},
	{	INCLUDE,"INCLUDE"	},
	{	-1,(char *)NULL		}
};

/***********************************************
** FILE_STACK object
** the FILE_STACK is used to keep track include
** files.
**********************************************/

typedef struct {
	FILE **Stack;	//array of FILE pointers
	int index;		// current file pointer
	int size;		//maximum number of FILE * to stack
}FILE_STACK;

FILE_STACK *FileStack;

FILE_STACK *newFileStack(int size)
{
	FILE_STACK *pFS = malloc(sizeof(FILE_STACK) + size * sizeof(FILE *));
	memset(pFS,sizeof(FILE_STACK) + size * sizeof(FILE *),0);
	pFS->size = size;
	pFS->index = 0;
	pFS->Stack = (FILE **)&pFS[1];	//start address of stack
	return pFS;
}

FILE *popFileStack(FILE_STACK *pFS)
{
	FILE *rv = NULL;

	if(pFS->index)
	{
		rv = pFS->Stack[--pFS->index];
	}
	return rv;
}

void pushFileStack(FILE_STACK *pFS,FILE *pF)
{
	if(pFS->index < pFS->size)
	{
		pFS->Stack[pFS->index] = pF;
		++pFS->index;
	}
	else
	{
		fprintf(stderr,"File Include Overflow\n");
		exit(1);
	}
}

int statusFileStack(FILE_STACK *pFS)
{
	return pFS->index;
}

//-------------------------------------------
// LexDebugMode
//
//	Put the lexer into debug mode
//
// parameter:
//	mode.......If ture, DEBUG is ON, FALSE is off
//------------------------------------------

void LexDebugMode(int mode)
{
	debugmode = mode;	//change debug mode
	if(debugmode)
		fprintf(stderr,"Debug Mode Is ON\n");
	else
		fprintf(stderr,"Debug Mode is OFF\n");
}

//-----------------------------------------
// initialize Lexer Objects
//-----------------------------------------

void InitLexer(int ungetbuffSIZE)
{
//	LexDebugMode(1);
	ungetbuf.b = malloc(ungetbuffSIZE);
	ungetbuf.index = 0;
	ungetbuf.size = ungetbuffSIZE;
	FileStack = newFileStack(20);
}

//----------------------------------------------
// GetLexBuff
//
//	Get a pointer to the input buffer for the
// lexical analyzer. The lex buffer will contain
// the characters that caused it to generate the
// current token
//---------------------------------------------

char *GetLexBuff(void)
{
	return inbuf;
}

//------------------------------------------------
// lookuptoken
//	finds the keyword that is associated with a
//	token value
//
// used for debugging
//
// parameter:
//	t..........token to find the keyword for
//
//	reutrns char * to keyword
//------------------------------------------------
char *lookuptoken(int t)
{
	char *retval = 0;
	int i;

	for(i=0;ktab[i].kw;++i)
	{
		if(t == ktab[i].token)
		{
			retval = ktab[i].kw;
			break;
		}
	}
	return retval;
}

//-----------------------------------------
// symbolchar
//
// this function detrmines if a character is
// in the set of characters allowed in a 
// symbol
//
// parameter:
//	c.....character to tesst
//
// returns true is character can be in a symbol
// returns false if it cannot be in a symbol
//-------------------------------------------

int symbolchar(int c)
{
	int rv;

	if((c >= 'a') && (c <= 'z')) rv = 1;
	else if ((c >= 'A') && (c <= 'Z')) rv = 1;
	else if ((c >= '0') && (c <= '9')) rv = 1;
	else if (c == '_') rv = 1;
	else rv = 0;
	return rv;
}

//-------------------------------------------
// notwhitespace
//
//	this function is used to determine if a
// a character is a member of the set of
// white space characters
//
// parameter:
//	c.......cheacter to test
//
//	returns true is c is not a white space character
//	returns false if c is whitespace
//----------------------------------------------

int notwhitespace(int c)
{
	int rv;

	switch(c)
	{
		case '\t': case '\n': case '\r': case ' ':
			rv = 0;
			break;
		default:
			rv = 1;
			break;

	}	//end of switch c
	return rv;
}

/**************************************************
** lookupkeyword
**	This function is used to determine if a
** string of characters is a keyword or not.
** If it isn't a keyword, it is ether a Identifier
** or a Macro.
**
** parameter:
**	s......pointer to string to test
**
***************************************************/

int lookupkeyword(char *s)
{
	int rval = -1;
	int i;
	static char t[80];

	//copy potential keyword to temp
	//and convert to upper case
	for(i=0;s[i];++i)
	{
		t[i] = toupper(s[i]);
	}
	t[i] = 0;
//	fprintf(stderr,"Enter KW Lookup\n");
	for(i=0;ktab[i].kw;++i)
	{
		if(strcmp(ktab[i].kw,t) == 0)
		{
			if(debugmode)fprintf(stderr,"Keyword:%s\n",s);
			rval = ktab[i].token;
			break;
		}
	}
//	fprintf(stderr,"Exit KW Lookup\n");
	return rval;
}

void yyunget(int c)
{
	/************************************
	** This function implents an unget
	** buffer.  The last character put
	** into here is the first one to
	** be fetched by yyGet()
	*************************************/
	if(ungetbuf.index < ungetbuf.size)
	{
		ungetbuf.b[ungetbuf.index++] = c;
	}
	else
	{
		fprintf(stderr,"Ungetbuf overflow\n");
		exit(1);
	}
}

//----------------------------------------
// yyGet
//
// Get a character from the current input
// stream.  If there are any characters in
// the unget buffer, those will be pulled out
// first.
//
//	returns next character in input stream
//-----------------------------------------
int yyGet()
{
	int c;

	if(ungetbuf.index)
		c = ungetbuf.b[--ungetbuf.index];
	else
		c = fgetc(yyin);	//get character from input stream
//	putchar(c);
	if(c == '\n')
	{
		yyLine ++;
		yyCol = 0;
	}
	else
		yyCol++;
	return c;
}

//------------------------------------------------
// yylex
//
// returns the next token in the input stream
// this is the function that is called by the
// parser.
//------------------------------------------------

int yylex()
{
	int c,c1;
	int index = 0;	//inbuf index
	int token;
	char *pT;

	if(debugmode) fprintf(stderr,"Enter Lex\n");
	while (1)
	{
		c = yyGet();
		switch(c)
		{
			case EOF:
				if(statusFileStack(FileStack))	//we have old files to parse
					yyin = popFileStack(FileStack);
				else
					return 0;		//end of file
				break;
			case '/':	//divide or start of comment
				c = yyGet();
				if(c == '/')	//process comment
				{
					do {
						c = yyGet();
						if(c == EOF)
						{
							fprintf(stderr,"Unexpected end of file\n");
							exit(1);
						}
					}while (c != '\n');	//get very thing to end of line
					if(debugmode)fprintf(stderr,"Comment\n");
				}
				else
				{
					yyunget(c);
					return '/';
				}
				break;
			case ';':	//start of comment
				do {
					c = yyGet();
					if(c == EOF)
					{
						fprintf(stderr,"Unexpected end of file\n");
						exit(1);
					}
				}while (c != '\n');	//get very thing to end of line
				if(debugmode)fprintf(stderr,"Comment\n");
				break;
			case '+':
			case '-':
			case '*':
			case '^':
			case '[':
			case ']':
			case '(':
			case ')':
			case '%':
			case '&':
			case '|':
			case ',':
			case '@':
			case '.':
				if(debugmode)fprintf(stderr,"Found Token:%c\n",c);
				return c;
				break;
			case '>':
			case '<':
				c1 = yyGet();	//get next character
				if(c1 == '=')
				{
					if(c == '>') return GTE;
					else if (c == '<') return LTE;
				}
				else if((c == '<') && (c1 == '>'))
					return NEQ;
				else
				{
					yyunget(c1);	//push second caracter back
					return c;	//return token
				}
				break;
			case '=':	//this one is a little more tricky
						//we need to look at the next char
						//and see if it makes up one of the
						//assignment operators
				c = yyGet();	//get the next character
				if(c == '=')
				{
					c = yyGet();	//get next character
					switch(c)
					{
						case '%':
							if(debugmode)fprintf(stderr,"Found Token:=%c\n",c);
							return XORassign;
							break;
						case '&':
							if(debugmode)fprintf(stderr,"Found Token:=%c\n",c);
							return ANDassign;
							break;
						case '*':
							if(debugmode)fprintf(stderr,"Found Token:=%c\n",c);
							return MULassign;
							break;
						case '-':
							if(debugmode)fprintf(stderr,"Found Token:=%c\n",c);
							return SUBassign;
							break;
						case '+':
							if(debugmode)fprintf(stderr,"Found Token:=%c\n",c);
							return ADDassign;
							break;
						case '/':
							if(debugmode)fprintf(stderr,"Found Token:=%c\n",c);
							return DIVassign;
							break;
						case '|':
							if(debugmode)fprintf(stderr,"Found Token:=%c\n",c);
							return ORassign;
							break;
						default:	//check for RSH,LSH and MOD
							pT = malloc(256);	//a temp buffer
							//Get the next three characters
							pT[0] = c;
							pT[1] = yyGet();
							pT[2] = yyGet();
							pT[3] = 0;
							token = lookupkeyword(pT);
							switch(token)
							{
								case RSH:
									free(pT);
									return RSHassign;
									break;
								case LSH:
									free(pT);
									return LSHassign;
									break;
								case MOD:
									free(pT);
									return MODassign;
									break;
								default:
									yyunget(pT[2]);
									yyunget(pT[1]);
									yyunget(pT[0]);
									free(pT);
									break;
							}
							if(debugmode)fprintf(stderr,"Found Token:=\n");
							return '=';
							break;
					}	//end of switch for = combinations
				}
				else
				{
						yyunget(c);
						return '=';
				}
				break;
			case '"':	//start of a string constant
					while(1) {
						c = yyGet();
						if(c != '"')
							inbuf[index++] = c;
						else
						{
							inbuf[index] = 0;	//terminate string
							if(debugmode) fprintf(stderr,"STRING %s\n",inbuf);
							break;
						}
					}
					return STRING;
					break;
				case '0': case '1': case '2':
				case '3': case '4': case '5':
				case '6': case '7': case '8': case '9':
					//decimal value:
					inbuf[index++] = c;
					while(1) {
						c = yyGet();	//get next character
						if(isdigit(c))
							inbuf[index++] = c;	//add character to buffer
						else
						{
							yyunget(c);	//push char back into stream
							inbuf[index++] = 0;
							if(debugmode) fprintf(stderr,"CONSTANT %s\n",inbuf);
							return CONSTANT;
						}
					}
					break;
				case '$':	//hex value
					while(1)
					{
						c = yyGet();	//get next character
						if(isxdigit(c))
							inbuf[index++] = c;
						else
						{
							yyunget(c);
							inbuf[index] = 0;
							if(debugmode) fprintf(stderr,"CONSTANT %s\n",inbuf);
							return HEX_CONSTANT;
						}
					}
					break;
				case ' ': case '\t': case '\n': case '\r':	//whitespace
					break;
				case '\'':
					c = yyGet();
					inbuf[0] = c;
					return CHAR_CONSTANT;
					break;
			default:	//this is where we look for keywords and identifiers
				//----------------------
				// create a string
				//----------------------
				inbuf[index++] = c;	//first char of word
				while(1){
					c= yyGet();	//get another character
					if(symbolchar(c))
						inbuf[index++] = c;
					else
						break;
				}
				yyunget(c);
				inbuf[index] = 0;	//terminate string
				//------------------
				// OK, got a string
				// check to see if it
				// is a keyword
				//------------------
//				printf("inbuf = \"%s\"\n",inbuf);
				token = lookupkeyword(inbuf);
				if(token < 0)
				{
					/*********************************
					** OK, we have an identifier.
					** We need to check to see if
					** this is already in the symbol
					** table, and if it is, we need
					** to check to see if the tokenval
					** has been set to something else.
					** This is used for defining TYPES,
					** FUNCs, and PROCs
					*********************************/
					symbol *pSym;

					pSym = findsym( Symbol_tab,inbuf );
					if(pSym)	//an already defined symbol
					{
						if(debugmode) fprintf(stderr,"Found %s\n",pSym->name);
						if(pSym->Token)
						{
							return pSym->Token;
						}
						else if (pSym->type)	//has symbol been deifned?
						{
							if (pSym->type->SYMTAB_NOUN == SYMTAB_MACRO)
							{
								//------------------------------------
								// ok this could get messy.
								// we have a replacement for input text
								// what we are going to do is put this
								// stirng into the ungetbuf
								//-------------------------------------
								char *s = pSym->type->V_STRING;
								int l = strlen(s);
								int i;
								if(debugmode) fprintf(stderr,"Unget Macro %s\n",s);
								for(i=l-1;i >= 0;--i)
									yyunget(s[i]);
								index = 0;	//reset input buffer
								continue;
							}
						}
					}
					if(debugmode)fprintf(stderr,"SYNBOL:%s\n",inbuf);
					return IDENTIFIER;
				}
				else if (token == INCLUDE)
				{
					token = yylex();
					if(token == STRING)	//is the next token a string?
					{
						printf("%s\n",inbuf);
						pushFileStack(FileStack,yyin);
						if((yyin = fopen(inbuf,"r")) == NULL)
						{
							fprintf(stderr,"Could not open Include File %s\n",inbuf);
							exit(1);
						}
						index = 0;	//reset inbuf index
					}
					else
					{
						fprintf(stderr,"BAD INCLUDE\n");
						exit(1);
					}
				}
				else if (token == RETURN)
				{
					extern int IfLevel;
					if(IfLevel)
						return PRETURN;
					else
						return token;
				}
				else
				{
					if(debugmode)fprintf(stderr,"TOKEN:%s\n",inbuf);
					return token;
				}
				break;
		}	//end of switch c
	}	//end of while loop
	return -1;	//should never get here.
}	//end of LEX function

