/*---------------------------------------------------------------------*\
!                                                                       !
!  fc.c  Compiler for FOOGOL IV -- version 4.2  Last change:1985-12-02  !
!        Translates FOOGOL IV into VAX/UNIX assembler                   !
!                                                                       !
!    Written by Per Lindberg, QZ, Box 27322, 10254 Stockholm, Sweden.   !
!                                                                       !
!    This software is in the public domain. The Hacker Ethic applies.   !
!    (A postcard from anyone who ports it would be appreciated.)        !
!                                                                       !
\*---------------------------------the-mad-programmer-strikes-again----*/

#define UNIX

#ifdef SARG10            /* Sargasso C (under TOPS10/20) peculiarities */
  #strings low
  #define _UNIXCON
#endif

#include <stdio.h>

#define isupper(c) ((c) >= 'A' && (c) <= 'Z')
#define tolower(c) ((c) - 'A' + 'a')

#define MAXTAB     25           /* Tweak these to your own liking  */
#define MAXTOKEN   80

#define WHITESPACE  0           /* These could be turned into enum */
#define NUMBER      1
#define LETTER      2
#define QUOTE       3
#define SEMICOLON   4
#define RANDOM      5

FILE *inf, *outf;

int labelcount = 0,
    linecount  = 0,
    debug      = 0;

char token[MAXTOKEN],
     pending[MAXTOKEN],
     keytab[MAXTAB][MAXTOKEN],
     symtab[MAXTAB][MAXTOKEN],
     *usage =
#ifdef SARG10
     "usage: '.run fc- [-debug] infile [outfile]'";
#endif
#ifdef UNIX
     "usage: 'fc [-debug] infile [outfile]'";
#endif

main(argc,argv) int argc; char *argv[]; {
  if (argc < 2) error(usage);
  if (*argv[1] == '-') { debug = 1; --argc; ++argv; }
  if (argc < 2) error(usage);
  openinfile(argv[1]);
  openoutfile(argv[argc == 2 ? 1 : 2]);
  init();
  if (!PROGRAM()) error("Syntax error");
  fclose(inf);
  fclose(outf);
}

char *defaultext(fname,ext,force) char *fname, *ext; int force; {
  static char result[255];
  char c, *point, *s = result;
  strcpy(result,fname);
  while (*s) ++s;
  point = s;
  while (c = *s, s > result && c != '.') --s;
  if (c == '.') {                                /* some extention exists */
    point = s;
    if (!force) return result;            /* don't worry about what it is */
  }
  strcpy(point,ext);                 /* put default extention after point */
  return result;
}

openinfile(fname) char *fname; {
  char *defaultext();
  d("openinfile",defaultext(fname,".foo",0),"");
  if ((inf = fopen(defaultext(fname,".foo",0),"r")) == NULL)
    error2("Can't open infile", defaultext(fname,".foo",0));
}

openoutfile(fname) char *fname; {
  char *defaultext();
  d("openoutfile",defaultext(fname,".s",1),"");
  if ((outf = fopen(defaultext(fname,".s",1),"w")) == NULL)
    error2("Can't open outfile", defaultext(fname,".s",1));
}

init() {
  int i;
  d("init","","");
  get2();
  gettoken();
  for (i = 0; i < MAXTAB; i++) keytab[i][0] = '\0';
}

error(msg) char *msg; {
  printf("\n\nFoo: %s", msg);
  if (linecount) printf(" at line %d",linecount + 1);
  printf("\n");
  exit(1);
}

error2(s1,s2) char *s1,*s2; {
  static char msg[80];
  sprintf(msg,"%s\"%s\"",s1,s2);
  error(msg);
}

lowcase(s) char *s; {
  char c;
  for (c = *s; c = *s; ++s) if (isupper(c)) *s = tolower(c);
}

/* Basic I/O functions */

int out(line) char *line; {
  char c, symb[MAXTOKEN], *subst(), *s = symb;
  int printmode = 1, chmode = 1;
  while(c = *line++) {
    if (c == ' ') { if (chmode) putc('\t',outf);
                    chmode = 0;
    } else {
      chmode = 1;
      if (c != 39) { if (printmode) putc(c,outf);
                     else           *s++ = c;
      } else if (!printmode) {
             *s = '\0';
             if (*symb) fprintf(outf,"%s",subst(symb));
             printmode = 1;
           } else {
             printmode = 0;
             s = symb;
           }
    }
  }
  putc('\n',outf);
  return 1;
}

gettoken() {
  strcpy(token,pending); get2();
  if (!strcmp("/",token) && !strcmp("*",pending)) {
    d("comment:",token,pending);
    while (strcmp("*",token) || strcmp("/",pending)) {
      strcpy(token,pending); get2();
      d("        ",token,"");
    }
    strcpy(token,pending); get2();
    strcpy(token,pending); get2();
  }
d("gettoken returning",token,pending);
}

get2() {
  int c0, c, typ, count = 1;
  char *p = pending;
  while((typ=type(c0=getc(inf))) == WHITESPACE) if (c0 == '\n') ++linecount;
  if (c0 != EOF) *p++ = c0;
  if (typ == QUOTE) {
    while ((c = getc(inf)) != EOF && type(c) != QUOTE) {
      if (++count == MAXTOKEN) error("String too long");
      *p++ = c;
    }
    *p++ = '"';
  }
  else {
    while ((type(c=getc(inf)) == typ
            || typ == LETTER && type(c) == NUMBER)
	    && typ != RANDOM
            && c != EOF) {
      *p++ = c;
      typ = type(c);
      if (++count == MAXTOKEN) error("Too long input token");
    }
    ungetc(c,inf);
  }
  *p = '\0';  
}

int type(c) int c; {
  if (c == EOF) return -1;
  if (c >= '0' && c <= '9') return(NUMBER);
  if (c >= 'A' && c <= 'Z' || c >= 'a' && c <= 'z') return(LETTER);
  if (c == ' ' || c == '\t' || c == '\n') return(WHITESPACE); /*  */
  if (c == '"') return (QUOTE);
  if (c == ';') return (SEMICOLON);
  return(RANDOM);
}

/* Basic input matching functions */

int match(s) char *s; {
d("match",token,s);
  lowcase(token);
  if (strcmp(s,token)) return 0;
  gettoken();          return 1;
}

int id(name) char *name; {
  int t;
  char c, *p = token;
  d("id",token,name);
  if (type(*p++) != LETTER) return 0;
  while (c = *p++) {
    t = type(c);
    if (t != NUMBER && t != LETTER) return(0);
  }
  lowcase(token);
  enter(name,token);
  gettoken();
  return(1);
}

int number(name) char *name; {
  char c, *p = token;
  d("number",token,name);
  while (c = *p++) if (type(c) != NUMBER) return(0);
  enter(name,token);
  gettoken();
  return(1);
}

int string(name) char *name; {
  d("string",token,name);
  if (*token != '"') return 0;
  enter(name,token);
  gettoken();
  return 1;
}

label(name) char *name; {
  char result[6];
  d("label ",name,"");
  sprintf(result,"L%d",labelcount++);
  enter(name,result);
}

/* Internal symbol table */

enter(key,val) char *key, *val; {
  int i;
  d("enter ",val,key);
  for (i = 0; i < MAXTAB; i++) {
    if (keytab[i][0] == '\0') {
      strcpy(keytab[i],key);
      strcpy(symtab[i],val);
      return;
    }
  }
  error2("INTERNAL SYMTAB ENTER ERROR, can't enter ", val);
}

int lookup(key) char *key; {
  int i;
  for (i = MAXTAB-1; i >= 0 ; i--) {
    if (!strcmp(key,keytab[i])) {
      d("lookup ",symtab[i],key);
      return i;
    }
  }
  error2("INTERNAL SYMTAB LOOKUP ERROR, can't find ", key);
}

char *subst(key) char *key; {
  return symtab[lookup(key)];
}

remove(key) char *key; {
  keytab[lookup(key)][0] = '\0';
}

/* Syntax definition. This is the neat part! */

int PROGRAM() { d("PROGRAM",token,pending);
  if (!match("begin"))	return 0;	out("      .text # # begin");
					out("      .align 1");
					out("      .globl  _main");
					out("_main:");
					out("      .word 0");
  if (!OPT_DECLARATION()) return 0;
  if (!STATEMENT())	return 0;
  while (match(";"))
    if (!STATEMENT())	return 0;
  if (!match("end"))	return 0;	out("      ret   # # end");
  return 1;
}

int OPT_DECLARATION() { d("OPT_DECLARATION",token,pending);
  if (DECLARATION()
  && !match(";")) return 0;
  return 1;
}

int DECLARATION() { d("DECLARATION",token,pending);
  if (!match("integer")) return 0;	out("     .data  1 # integer");
  if (!ID_SEQUENCE())	 return 0;	out("     .text");
  return 1;
}

int ID_SEQUENCE() { d("ID_SEQUENCE",token,pending);
  if (!IDENTIFIER())	return 0;
  while (match(","))
    if (!IDENTIFIER())	return 0;
  return 1;
}

int IDENTIFIER() { d("IDENTIFIER",token,pending);
  if (!id("X"))	return 0;		out("'X':  .long   0");
					remove("X");
  return 1;
}

int STATEMENT() { d("STATEMENT",token,pending);
  return
  IO_STATEMENT()
  ||
  WHILE_STATEMENT()
  ||
  COND_STATEMENT()
  ||
  BLOCK()
  ||                     /* the order is important here */
  ASSIGN_STATEMENT();
}

int BLOCK() { d("BLOCK",token,pending);
  if (!match("begin"))	return 0;	out(" # # # begin");
  if (DECL_OR_ST())
    while(match(";"))
     if (!STATEMENT())	return 0;
  if (!match("end"))	return 0;	out(" # # # end");
  return 1;
}

int DECL_OR_ST() { d("DECL_OR_ST",token,pending);
  return
  DECLARATION()
  ||
  STATEMENT();
}

int IO_STATEMENT() { d("IO_STATEMENT",token,pending);
  return
  PRINTS_STATEMENT()
  ||
  PRINTN_STATEMENT()
  ||
  PRINT_STATEMENT();
}

int PRINTS_STATEMENT() { d("PRINTS_STATEMENT",token,pending);
  if (!match("prints")) return 0;
  if (!match("("))	return 0;
  if (!string("S"))	return 0;	label("Ls");
					out("      .data 1 # prints");
					out("'Ls': .asciz  'S'");
					out("      .text");
					out("      pushal   'Ls'");
					out("      calls   $1,_PRS");
					remove("S"); remove("Ls");
  if (!match(")"))	return 0;
  return 1;
}

int PRINTN_STATEMENT() { d("PRINTN_STATEMENT",token,pending);
  if (!match("printn")) return 0;
  if (!match("("))	return 0;
  if (!EXPRESSION())	return 0;	out("      pushl  r0 # printn");
					out("      calls   $1,_PRN");
  if (!match(")"))	return 0;
  return 1;
}

int PRINT_STATEMENT() { d("PRINT_STATEMENT",token,pending);
  if (!match("print"))	return 0;	out("      calls   $0,_PR # print");
  return 1;
}

int COND_STATEMENT() { d("COND_STATEMENT",token,pending);
  if (!match("if"))	return 0;	label("Lt"); label("Le"); label("Lq");
  if (!EXPRESSION())	return 0;	out("      tstl  r0 # if");
  if (!match("then"))	return 0;	out("      bneq  'Lq' # then");
					out("      jmp   'Le'");
					out("'Lq':");
  if (!STATEMENT())	return 0;	out("      jmp   'Lt'");
					out("'Le': #     # # else");
  if (match("else"))
    if (!STATEMENT())	return 0;	out("'Lt': #     # # endif");
					remove("Lt");remove("Le");remove("Lq");
  return 1;
}

int WHILE_STATEMENT() { d("WHILE_STATEMENT",token,pending);
  if (!match("while"))	return 0;	label("Lw"); label("Lx"); label("Lv");
					out("'Lw': #     # # while");
  if (!EXPRESSION())	return 0;	out("      tstl  r0");
  if (!match("do"))	return 0;	out("      bneq  'Lv'");
                                        out("      jmp   'Lx'");
                                        out("'Lv': #     # # do");
  if(!STATEMENT())	return 0;	out("      jmp   'Lw'");
					out("'Lx': #     # # endwhile");
					remove("Lw");remove("Lx");remove("Lv");
  return 1;
}

int ASSIGN_STATEMENT() { d("ASSIGN_STATEMENT",token,pending);
  if (!id("Var"))	return 0;
  if (!match(":"))	return 0;
  if (!match("="))	return 0;
  if (!EXPRESSION())	return 0;	out("    movl  r0,'Var' # 'Var':=");
					remove("Var");
  return 1;
}

int EXPRESSION() { d("EXPRESSION",token,pending);
  if (!EXPR1())		return 0;
  if (!OPT_RHS())	return 0;
  return 1;
}

int OPT_RHS() { d("OPT_RHS",token,pending);
  return
  RHS_EQ()
  ||
  RHS_NEQ()
  ||
  1;
}

int RHS_EQ() { d("RHS_EQ",token,pending);
  if (!match("="))	return 0;	label("L="); label("Ly");
					out("      pushl  r0 # =");
  if (!EXPR1())		return 0;	out("      cmpl   (sp)+,r0");
					out("      beql   'L='");
					out("      movl   $0,r0");
					out("      jmp    'Ly'");
					out("'L=': movl   $1,r0");
					out("'Ly':");
					remove("L="); remove("Ly");
  return 1;
}

int RHS_NEQ() { d("RHS_NEQ",token,pending);
  if (!match("#"))	return 0;	label("L#"); label("Lz");
					out("      pushl  r0 # <>");
  if (!EXPR1())		return 0;	out("      cmpl   (sp)+,r0");
					out("      beql   'L#'");
					out("      movl   $1,r0");
					out("      jmp    'Lz'");
					out("'L#': movl   $0,r0");
					out("'Lz':");
					remove("L#"); remove("Lz");
  return 1;
}

int SIGNED_TERM() { d("SIGNED_TERM",token,pending);
  return
  PLUS_TERM()
  ||
  MINUS_TERM();
}

int PLUS_TERM() { d("PLUS_TERM",token,pending);
  if (!match("+"))	return 0;	out("      pushl  r0   # +term");
  if (!TERM())		return 0;	out("      addl2  (sp)+,r0");
  return 1;
}

int MINUS_TERM() { d("MINUS_TERM",token,pending);
  if (!match("-"))	return 0;	out("      pushl  r0   # -term");
  if (!TERM())		return 0;	out("      subl3  r0,(sp)+,r0");
  return 1;
}

int TERM() { d("TERM",token,pending);
  if (!PRIMARY())	return 0;
  while (match("*")) {			out("      pushl  r0    # *");
    if (!PRIMARY())	return 0;	out("      mull2  (sp)+,r0");
  }
  return 1;
}

int PRIMARY() { d("PRIMARY",token,pending);
  if (id("Z")) {			out("       movl 'Z',r0");
					remove("Z");
    return 1;
  }
  if (number("Z")) {			out("       movl $'Z',r0");
					remove("Z");
    return 1;
  }
  if (match("(")) {
    if (!EXPRESSION())	return 0;
    if (!match(")"))	return 0;
    return 1;
  }
  return 0;
}

int EXPR1() { d("EXPR1",token,pending);
  if (!TERM())		return 0;
  while(SIGNED_TERM());
  return 1;
}

/* And finally, the debug function... */

int d(s1,s2,s3) char *s1,*s2,*s3; {
  if (debug) {
    printf("%s",s1);
    if (*s2) printf(" \"%s\"",s2);
    if (*s3) printf(" \"%s\"",s3);
    putchar('\n');
  }
  return 1;
}
