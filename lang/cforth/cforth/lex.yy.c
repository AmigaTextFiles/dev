# include "stdio.h"
# define U(x) x
# define NLSTATE yyprevious=YYNEWLINE
# define BEGIN yybgin = yysvec + 1 +
# define INITIAL 0
# define YYLERR yysvec
# define YYSTATE (yyestate-yysvec-1)
# define YYOPTIM 1
# define YYLMAX 200
# define output(c) putc(c,yyout)
# define input() (((yytchar=yysptr>yysbuf?U(*--yysptr):getc(yyin))==10?(yylineno++,yytchar):yytchar)==EOF?0:yytchar)
# define unput(c) {yytchar= (c);if(yytchar=='\n')yylineno--;*yysptr++=yytchar;}
# define yymore() (yymorfg=1)
# define ECHO fprintf(yyout, "%s",yytext)
# define REJECT { nstr = yyreject(); goto yyfussy;}
int yyleng; extern char yytext[];
int yymorfg;
extern char *yysptr, yysbuf[];
int yytchar;
FILE *yyin = {stdin}, *yyout = {stdout};
extern int yylineno;
struct yysvf { 
	struct yywork *yystoff;
	struct yysvf *yyother;
	int *yystops;};
struct yysvf *yyestate;
extern struct yysvf yysvec[], *yybgin;
/* LEX input for FORTH input file scanner */
/* 
	Specifications are as follows:
	This file must be run through "sed" to change 
		yylex () {
	to
		TOKEN *yylex () {
	where the sed script is
		sed "s/yylex () {/TOKEN *yylex () {/" lex.yy.c

	Note that spaces have been included above so these lines won't be
	mangled by sed; in actuality, the two blanks surrounding () are
	removed.

	The function "yylex()" always returns a pointer to a structure:

	    struct tokenrec {
		int type;
		char *text;
	    }
	    #define TOKEN struct tokenrec

	where the type is a hint as to the word's type:
		DECIMAL for decimal literal		d+
		OCTAL for octal literal		0d*
		HEX for hex literal		0xd+ or 0Xd+
		C_BS for a literal Backspace	'\b'
		C_FF for a literal Form Feed	'\f'
		C_NL for a literal Newline	'\n'
		C_CR for a literal Carriage Return '\r'
		C_TAB for a literal Tab '\t'
		C_BSLASH for a literal backslash '\\'
		C_IT for an other character literal 'x' where x is possibly '
		STRING_LIT for a string literal (possibly containing \")
		COMMENT for a left-parenthesis (possibly beginning a comment)
		PRIM for "PRIM"
		CONST for "CONST"
		VAR for "VAR"
		USER for "USER"
		LABEL for "LABEL"
		COLON for ":"
		SEMICOLON for ";"
		SEMISTAR for ";*" (used to make words IMMEDIATE)
		NUL for the token {NUL}, which gets compiled as a null byte;
			this special interpretation takes place in the COLON
			code.
		LIT for the word "LIT" (treated like OTHER, except that
			no warning is generated when a literal follows this)
		OTHER for an other word not recognized above

	Note that this is just a hint: the meaning of any string of characters
	depends on the context.

*/
#include "forth.lex.h"
TOKEN token;
# define YYNEWLINE 10
TOKEN *yylex(){
int nstr; extern int yyprevious;
while((nstr = yylook()) >= 0)
yyfussy: switch(nstr){
case 0:
if(yywrap()) return(0); break;
case 1:
/* whitespace -- keep looping */ ;
break;
case 2:
	{ token.type = DECIMAL; token.text = yytext;
					return &token; }
break;
case 3:
	{ token.type = OCTAL; token.text = yytext;
					return &token; }
break;
case 4:
	{ token.type = HEX; token.text = yytext;
					return &token; }
break;
case 5:
{ token.type = C_BS; token.text = yytext; return &token; }
break;
case 6:
{ token.type = C_FF; token.text = yytext; return &token; }
break;
case 7:
{ token.type = C_NL; token.text = yytext; return &token; }
break;
case 8:
{ token.type = C_CR; token.text = yytext; return &token; }
break;
case 9:
{ token.type = C_TAB; token.text = yytext; return &token; }
break;
case 10:
{ token.type = C_BSLASH; token.text = yytext; return &token; }
break;
case 11:
{ token.type = C_LIT; token.text = yytext; return &token; }
break;
case 12:
{ token.type = STRING_LIT; token.text = yytext; 
				return &token; }
break;
case 13:
	{ token.type = COMMENT; token.text = yytext;
				return &token; }
break;
case 14:
	{ token.type = PRIM; token.text = yytext;
				return &token; }
break;
case 15:
	{ token.type = CONST; token.text = yytext;
				return &token; }
break;
case 16:
	{ token.type = VAR; token.text = yytext;
				return &token; }
break;
case 17:
	{ token.type = USER; token.text = yytext;
				return &token; }
break;
case 18:
	{ token.type = LABEL; token.text = yytext;
				return &token; }
break;
case 19:
	{ token.type = COLON; token.text = yytext;
				return &token; }
break;
case 20:
	{ token.type = SEMICOLON; token.text = yytext;
				return &token; }
break;
case 21:
	{ token.type = SEMISTAR; token.text = yytext;
				return &token; }
break;
case 22:
	{ token.type = NUL; token.text = yytext;
				return &token; }
break;
case 23:
	{ token.type = LIT; token.text = yytext;
				return &token; }
break;
case 24:
{ token.type = OTHER; token.text = yytext;
				return &token; }
break;
case -1:
break;
default:
fprintf(yyout,"bad switch yylook %d",nstr);
} return(0); }
/* end of yylex */
int yyvstop[] = {
0,

1,
0,

1,
0,

-24,
0,

1,
0,

-24,
0,

-24,
0,

-13,
-24,
0,

-24,
0,

-3,
-24,
0,

-2,
-24,
0,

-19,
-24,
0,

-20,
-24,
0,

-24,
0,

-24,
0,

-24,
0,

-24,
0,

-24,
0,

-24,
0,

24,
0,

24,
0,

-12,
-24,
0,

-24,
0,

-24,
0,

24,
0,

-24,
0,

13,
24,
0,

3,
24,
0,

-3,
-24,
0,

-24,
0,

2,
24,
0,

19,
24,
0,

20,
24,
0,

-21,
-24,
0,

-24,
0,

-24,
0,

-24,
0,

-24,
0,

-24,
0,

-24,
0,

-24,
0,

-12,
0,

12,
24,
0,

-12,
-24,
0,

-11,
-24,
0,

-11,
0,

-24,
0,

-24,
0,

-24,
0,

-24,
0,

-24,
0,

-24,
0,

-4,
-24,
0,

21,
24,
0,

-24,
0,

-24,
0,

-23,
-24,
0,

-24,
0,

-24,
0,

-16,
-24,
0,

-24,
0,

12,
0,

-12,
0,

12,
24,
0,

11,
24,
0,

11,
0,

-10,
-24,
0,

-5,
-24,
0,

-6,
-24,
0,

-7,
-24,
0,

-8,
-24,
0,

-9,
-24,
0,

4,
24,
0,

-24,
0,

-24,
0,

23,
24,
0,

-14,
-24,
0,

-17,
-24,
0,

16,
24,
0,

-24,
0,

12,
0,

10,
24,
0,

5,
24,
0,

6,
24,
0,

7,
24,
0,

8,
24,
0,

9,
24,
0,

-15,
-24,
0,

-18,
-24,
0,

14,
24,
0,

17,
24,
0,

-22,
-24,
0,

15,
24,
0,

18,
24,
0,

22,
24,
0,
0};
# define YYTYPE char
struct yywork { YYTYPE verify, advance; } yycrank[] = {
0,0,	0,0,	1,3,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	1,4,	1,4,	
0,0,	4,4,	4,4,	0,0,	
4,4,	4,4,	7,26,	7,26,	
11,31,	11,31,	21,44,	21,44,	
0,0,	12,32,	12,32,	33,55,	
33,55,	0,0,	42,63,	42,63,	
0,0,	42,63,	42,63,	1,5,	
4,4,	46,66,	46,66,	0,0,	
1,6,	1,7,	22,45,	3,3,	
23,46,	24,47,	1,8,	48,68,	
49,69,	1,9,	1,10,	3,19,	
3,19,	42,63,	50,70,	2,6,	
2,7,	1,10,	12,33,	1,11,	
1,12,	2,8,	5,5,	51,71,	
6,23,	52,72,	1,3,	43,64,	
1,13,	35,57,	5,20,	5,20,	
6,24,	6,19,	2,11,	2,12,	
3,3,	1,14,	37,59,	38,60,	
18,40,	1,15,	13,34,	2,13,	
15,37,	16,38,	1,16,	1,17,	
34,56,	1,3,	3,3,	3,3,	
2,14,	9,27,	9,27,	5,21,	
2,15,	6,23,	3,3,	36,58,	
22,22,	2,16,	2,17,	10,30,	
10,30,	8,9,	8,10,	3,3,	
39,61,	5,5,	5,5,	6,23,	
6,23,	8,10,	14,3,	40,62,	
41,43,	5,5,	53,73,	6,23,	
28,27,	28,27,	14,19,	14,19,	
1,18,	43,43,	5,5,	56,75,	
6,23,	57,76,	3,3,	59,78,	
9,28,	9,28,	45,65,	45,65,	
58,77,	58,77,	60,79,	2,18,	
29,54,	29,54,	10,10,	10,10,	
62,81,	25,46,	65,43,	14,3,	
29,54,	5,5,	10,10,	6,23,	
75,89,	5,22,	76,90,	6,25,	
81,93,	29,54,	82,43,	28,28,	
28,28,	14,3,	14,3,	0,0,	
47,67,	47,67,	0,0,	47,67,	
47,67,	14,3,	61,80,	61,80,	
9,29,	64,82,	64,82,	0,0,	
17,3,	0,0,	14,35,	14,3,	
14,3,	14,3,	14,3,	14,3,	
17,19,	17,19,	14,36,	47,67,	
68,83,	68,83,	69,84,	69,84,	
70,85,	70,85,	71,86,	71,86,	
72,87,	72,87,	25,48,	73,88,	
73,88,	14,3,	78,91,	78,91,	
25,49,	79,92,	79,92,	0,0,	
25,50,	17,3,	14,3,	14,3,	
14,3,	14,3,	14,3,	14,3,	
25,51,	45,22,	89,94,	89,94,	
25,52,	0,0,	25,53,	17,3,	
17,3,	90,95,	90,95,	93,96,	
93,96,	0,0,	0,0,	17,3,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	20,41,	0,0,	
17,39,	17,3,	17,3,	17,3,	
17,3,	17,3,	20,41,	20,41,	
54,74,	54,74,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
64,43,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	17,3,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	20,42,	
17,3,	17,3,	17,3,	17,3,	
17,3,	17,3,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	20,41,	20,41,	54,54,	
54,54,	0,0,	0,0,	0,0,	
0,0,	20,41,	0,0,	54,54,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	20,41,	0,0,	
54,54,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	0,0,	0,0,	0,0,	
0,0,	20,41,	0,0,	0,0,	
0,0,	20,43,	0,0,	0,0,	
0,0};
struct yysvf yysvec[] = {
0,	0,	0,
yycrank+-1,	0,		yyvstop+1,
yycrank+-16,	yysvec+1,	yyvstop+3,
yycrank+-42,	0,		yyvstop+5,
yycrank+4,	0,		yyvstop+7,
yycrank+-61,	0,		yyvstop+9,
yycrank+-63,	0,		yyvstop+11,
yycrank+-9,	yysvec+3,	yyvstop+13,
yycrank+-57,	yysvec+3,	yyvstop+16,
yycrank+-84,	yysvec+3,	yyvstop+18,
yycrank+-94,	yysvec+3,	yyvstop+21,
yycrank+-11,	yysvec+3,	yyvstop+24,
yycrank+-16,	yysvec+3,	yyvstop+27,
yycrank+-3,	yysvec+3,	yyvstop+30,
yycrank+-113,	0,		yyvstop+32,
yycrank+-2,	yysvec+3,	yyvstop+34,
yycrank+-2,	yysvec+3,	yyvstop+36,
yycrank+-175,	0,		yyvstop+38,
yycrank+-2,	yysvec+3,	yyvstop+40,
yycrank+0,	0,		yyvstop+42,
yycrank+-237,	0,		yyvstop+44,
yycrank+-13,	yysvec+3,	yyvstop+46,
yycrank+-8,	yysvec+5,	yyvstop+49,
yycrank+-5,	yysvec+3,	yyvstop+51,
yycrank+6,	0,		yyvstop+53,
yycrank+-106,	yysvec+3,	yyvstop+55,
yycrank+0,	0,		yyvstop+57,
yycrank+0,	0,		yyvstop+60,
yycrank+-111,	yysvec+3,	yyvstop+63,
yycrank+-92,	yysvec+3,	yyvstop+66,
yycrank+0,	0,		yyvstop+68,
yycrank+0,	0,		yyvstop+71,
yycrank+0,	0,		yyvstop+74,
yycrank+-18,	yysvec+3,	yyvstop+77,
yycrank+-10,	yysvec+3,	yyvstop+80,
yycrank+-3,	yysvec+3,	yyvstop+82,
yycrank+-15,	yysvec+3,	yyvstop+84,
yycrank+-5,	yysvec+3,	yyvstop+86,
yycrank+-10,	yysvec+3,	yyvstop+88,
yycrank+-26,	yysvec+3,	yyvstop+90,
yycrank+-30,	yysvec+3,	yyvstop+92,
yycrank+-24,	yysvec+20,	0,	
yycrank+21,	0,		yyvstop+94,
yycrank+-33,	yysvec+20,	0,	
yycrank+0,	0,		yyvstop+96,
yycrank+-125,	yysvec+5,	yyvstop+99,
yycrank+-28,	yysvec+3,	yyvstop+102,
yycrank+155,	0,		yyvstop+105,
yycrank+-8,	yysvec+3,	yyvstop+107,
yycrank+-9,	yysvec+3,	yyvstop+109,
yycrank+-15,	yysvec+3,	yyvstop+111,
yycrank+-24,	yysvec+3,	yyvstop+113,
yycrank+-26,	yysvec+3,	yyvstop+115,
yycrank+-79,	yysvec+3,	yyvstop+117,
yycrank+-239,	yysvec+3,	yyvstop+119,
yycrank+0,	0,		yyvstop+122,
yycrank+-44,	yysvec+3,	yyvstop+125,
yycrank+-60,	yysvec+3,	yyvstop+127,
yycrank+-127,	yysvec+3,	yyvstop+129,
yycrank+-54,	yysvec+3,	yyvstop+132,
yycrank+-56,	yysvec+3,	yyvstop+134,
yycrank+-161,	yysvec+3,	yyvstop+136,
yycrank+-68,	yysvec+3,	yyvstop+139,
yycrank+0,	0,		yyvstop+141,
yycrank+-164,	yysvec+20,	yyvstop+143,
yycrank+-54,	yysvec+20,	yyvstop+145,
yycrank+0,	0,		yyvstop+148,
yycrank+0,	0,		yyvstop+151,
yycrank+-179,	yysvec+3,	yyvstop+153,
yycrank+-181,	yysvec+3,	yyvstop+156,
yycrank+-183,	yysvec+3,	yyvstop+159,
yycrank+-185,	yysvec+3,	yyvstop+162,
yycrank+-187,	yysvec+3,	yyvstop+165,
yycrank+-190,	yysvec+3,	yyvstop+168,
yycrank+0,	0,		yyvstop+171,
yycrank+-68,	yysvec+3,	yyvstop+174,
yycrank+-78,	yysvec+3,	yyvstop+176,
yycrank+0,	0,		yyvstop+178,
yycrank+-193,	yysvec+3,	yyvstop+181,
yycrank+-196,	yysvec+3,	yyvstop+184,
yycrank+0,	0,		yyvstop+187,
yycrank+-31,	yysvec+3,	yyvstop+190,
yycrank+-66,	yysvec+20,	yyvstop+192,
yycrank+0,	0,		yyvstop+194,
yycrank+0,	0,		yyvstop+197,
yycrank+0,	0,		yyvstop+200,
yycrank+0,	0,		yyvstop+203,
yycrank+0,	0,		yyvstop+206,
yycrank+0,	0,		yyvstop+209,
yycrank+-209,	yysvec+3,	yyvstop+212,
yycrank+-216,	yysvec+3,	yyvstop+215,
yycrank+0,	0,		yyvstop+218,
yycrank+0,	0,		yyvstop+221,
yycrank+-218,	yysvec+3,	yyvstop+224,
yycrank+0,	0,		yyvstop+227,
yycrank+0,	0,		yyvstop+230,
yycrank+0,	0,		yyvstop+233,
0,	0,	0};
struct yywork *yytop = yycrank+329;
struct yysvf *yybgin = yysvec+1;
char yymatch[] = {
00  ,01  ,01  ,01  ,01  ,01  ,01  ,01  ,
01  ,011 ,012 ,01  ,011 ,011 ,01  ,01  ,
01  ,01  ,01  ,01  ,01  ,01  ,01  ,01  ,
01  ,01  ,01  ,01  ,01  ,01  ,01  ,01  ,
011 ,01  ,'"' ,01  ,01  ,01  ,01  ,01  ,
01  ,01  ,01  ,01  ,01  ,01  ,01  ,01  ,
'0' ,'1' ,'1' ,'1' ,'1' ,'1' ,'1' ,'1' ,
'8' ,'8' ,01  ,01  ,01  ,01  ,01  ,01  ,
01  ,'A' ,'A' ,'A' ,'A' ,'A' ,'A' ,01  ,
01  ,01  ,01  ,01  ,01  ,01  ,01  ,01  ,
01  ,01  ,01  ,01  ,01  ,01  ,01  ,01  ,
'X' ,01  ,01  ,01  ,01  ,01  ,01  ,01  ,
01  ,'A' ,'A' ,'A' ,'A' ,'A' ,'A' ,01  ,
01  ,01  ,01  ,01  ,01  ,01  ,01  ,01  ,
01  ,01  ,01  ,01  ,01  ,01  ,01  ,01  ,
'X' ,01  ,01  ,01  ,01  ,01  ,01  ,01  ,
0};
char yyextra[] = {
0,0,1,1,1,1,1,1,
1,1,1,1,1,1,1,1,
1,1,1,1,1,1,1,1,
1,0,0,0,0,0,0,0,
0};
/*	@(#)ncform	1.2	*/
int yylineno =1;
# define YYU(x) x
# define NLSTATE yyprevious=YYNEWLINE
char yytext[YYLMAX];
struct yysvf *yylstate [YYLMAX], **yylsp, **yyolsp;
char yysbuf[YYLMAX];
char *yysptr = yysbuf;
int *yyfnd;
extern struct yysvf *yyestate;
int yyprevious = YYNEWLINE;
yylook(){
	register struct yysvf *yystate, **lsp;
	register struct yywork *yyt;
	struct yysvf *yyz;
	int yych, yyfirst;
	struct yywork *yyr;
# ifdef LEXDEBUG
	int debug;
# endif
	char *yylastch;
	/* start off machines */
# ifdef LEXDEBUG
	debug = 0;
# endif
	yyfirst=1;
	if (!yymorfg)
		yylastch = yytext;
	else {
		yymorfg=0;
		yylastch = yytext+yyleng;
		}
	for(;;){
		lsp = yylstate;
		yyestate = yystate = yybgin;
		if (yyprevious==YYNEWLINE) yystate++;
		for (;;){
# ifdef LEXDEBUG
			if(debug)fprintf(yyout,"state %d\n",yystate-yysvec-1);
# endif
			yyt = yystate->yystoff;
			if(yyt == yycrank && !yyfirst){  /* may not be any transitions */
				yyz = yystate->yyother;
				if(yyz == 0)break;
				if(yyz->yystoff == yycrank)break;
				}
			*yylastch++ = yych = input();
			yyfirst=0;
		tryagain:
# ifdef LEXDEBUG
			if(debug){
				fprintf(yyout,"char ");
				allprint(yych);
				putchar('\n');
				}
# endif
			yyr = yyt;
			if ( (int)yyt > (int)yycrank){
				yyt = yyr + yych;
				if (yyt <= yytop && yyt->verify+yysvec == yystate){
					if(yyt->advance+yysvec == YYLERR)	/* error transitions */
						{unput(*--yylastch);break;}
					*lsp++ = yystate = yyt->advance+yysvec;
					goto contin;
					}
				}
# ifdef YYOPTIM
			else if((int)yyt < (int)yycrank) {		/* r < yycrank */
				yyt = yyr = yycrank+(yycrank-yyt);
# ifdef LEXDEBUG
				if(debug)fprintf(yyout,"compressed state\n");
# endif
				yyt = yyt + yych;
				if(yyt <= yytop && yyt->verify+yysvec == yystate){
					if(yyt->advance+yysvec == YYLERR)	/* error transitions */
						{unput(*--yylastch);break;}
					*lsp++ = yystate = yyt->advance+yysvec;
					goto contin;
					}
				yyt = yyr + YYU(yymatch[yych]);
# ifdef LEXDEBUG
				if(debug){
					fprintf(yyout,"try fall back character ");
					allprint(YYU(yymatch[yych]));
					putchar('\n');
					}
# endif
				if(yyt <= yytop && yyt->verify+yysvec == yystate){
					if(yyt->advance+yysvec == YYLERR)	/* error transition */
						{unput(*--yylastch);break;}
					*lsp++ = yystate = yyt->advance+yysvec;
					goto contin;
					}
				}
			if ((yystate = yystate->yyother) && (yyt= yystate->yystoff) != yycrank){
# ifdef LEXDEBUG
				if(debug)fprintf(yyout,"fall back to state %d\n",yystate-yysvec-1);
# endif
				goto tryagain;
				}
# endif
			else
				{unput(*--yylastch);break;}
		contin:
# ifdef LEXDEBUG
			if(debug){
				fprintf(yyout,"state %d char ",yystate-yysvec-1);
				allprint(yych);
				putchar('\n');
				}
# endif
			;
			}
# ifdef LEXDEBUG
		if(debug){
			fprintf(yyout,"stopped at %d with ",*(lsp-1)-yysvec-1);
			allprint(yych);
			putchar('\n');
			}
# endif
		while (lsp-- > yylstate){
			*yylastch-- = 0;
			if (*lsp != 0 && (yyfnd= (*lsp)->yystops) && *yyfnd > 0){
				yyolsp = lsp;
				if(yyextra[*yyfnd]){		/* must backup */
					while(yyback((*lsp)->yystops,-*yyfnd) != 1 && lsp > yylstate){
						lsp--;
						unput(*yylastch--);
						}
					}
				yyprevious = YYU(*yylastch);
				yylsp = lsp;
				yyleng = yylastch-yytext+1;
				yytext[yyleng] = 0;
# ifdef LEXDEBUG
				if(debug){
					fprintf(yyout,"\nmatch ");
					sprint(yytext);
					fprintf(yyout," action %d\n",*yyfnd);
					}
# endif
				return(*yyfnd++);
				}
			unput(*yylastch);
			}
		if (yytext[0] == 0  /* && feof(yyin) */)
			{
			yysptr=yysbuf;
			return(0);
			}
		yyprevious = yytext[0] = input();
		if (yyprevious>0)
			output(yyprevious);
		yylastch=yytext;
# ifdef LEXDEBUG
		if(debug)putchar('\n');
# endif
		}
	}
yyback(p, m)
	int *p;
{
if (p==0) return(0);
while (*p)
	{
	if (*p++ == m)
		return(1);
	}
return(0);
}
	/* the following are only used in the lex library */
yyinput(){
	return(input());
	}
yyoutput(c)
  int c; {
	output(c);
	}
yyunput(c)
   int c; {
	unput(c);
	}
