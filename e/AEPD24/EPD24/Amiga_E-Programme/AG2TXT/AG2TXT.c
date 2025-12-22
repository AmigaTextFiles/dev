/* AmigaGuide to Text converter (v2). Copyright (c) 1994, Jason R. Hulance */
/* C version. Restricted use of ANSI codes, so they work on Xterms etc.    */
/* Should compile easily (using gcc, say):                                 */
/*    gcc -O2 -o ag2txt ag2txt.c                                           */

#include<stdio.h>
#include<ctype.h>

typedef enum { N_INIT, N_OUT, N_IN, NODE_STATES } NODE;
typedef enum { L_INIT, L_QUOTED, L_SPACED, LINE_STATES } LINE;
typedef enum { A_INIT, A_AT, A_BRAC, A_IGNORE, A_END, AT_STATES } AT;

#define MAX_LINE_LEN (1024)
#define MAX_WIDTH    (120)
#define CMP_EQUAL    (0)
#define CMP_UNEQUAL  (1)

#define TRUE  (0==0)
#define FALSE (1==0)

char in[MAX_LINE_LEN];
FILE *outh=NULL;

typedef enum {BOLD, ITALIC, F_LINK, TITLE, HIGHLIGHT, OTHER} FONT;

void write_ansi(FONT type, int on)
{
  /*    BOLD      ITALIC       F_LINK     TITLE    HIGHLIGHT    OTHER */
  if(on) {
    static char *ansi[] = {
      "\033[1m", "\033[1m",  "\033[1m", "\033[7m", "\033[1m", "\033[1m" };
    fputs(ansi[type], outh);
  }
  else {
    static char *ansi[] = {
      "\033[0m", "\033[0m", "\033[0m", "\033[0m", "\033[0m", "\033[0m" };
    fputs(ansi[type], outh);
  }
}

int Stricmp(char *s, char *t)
{
  while(*s && *t) {
    if(toupper(*s) != *t)
      return CMP_UNEQUAL;
    s++, t++;
  }
  return (*s || *t) ? CMP_UNEQUAL : CMP_EQUAL;
}

int Strnicmp(char *s, char *t)
{
  while(*s && *t) {
    if(toupper(*s) != *t)
      return CMP_UNEQUAL;
    s++, t++;
  }
  return (*t) ? CMP_UNEQUAL : CMP_EQUAL;
}

void error(char *msg, int err)
{
  fputs(msg, stderr);
  exit(err);
}

char *get_word(char **line, int *chkbrac)
{
  LINE status=L_INIT;
  char *t=NULL, *to;
  int noword=TRUE, special=FALSE;

  if(line==NULL || *line==NULL)
    return NULL;
  to=*line;
  while(**line && noword) {
    if(to != *line) *to = **line;
    switch(**line) {
    case '"':
      if(special)
	to++;
      else {
	switch(status) {
	case L_INIT:
	  status=L_QUOTED;
	  t=(*line)+1;
	  to++;
	  break;
	case L_QUOTED:
	  *to='\0';
	  noword=FALSE;
	  break;
	default:
	  to++;
	  break;
	}
      }
      break;
    case '\n': case '\t': case ' ':
      if(status==L_SPACED) {
        *to='\0';
        noword=FALSE;
      }
      else
	to++;
      break;
    default:
      if(chkbrac && **line=='}') {
        *to='\0';
        noword=FALSE;
        *chkbrac=TRUE;
      }
      else {
	if(status==L_INIT) {
          t=*line;
          status=L_SPACED;
	}
	to++;
      }
      break;
    }
    if(special)
      special=FALSE;
    else if(**line=='\\') {
      special=TRUE;
      to--;
    }
    (*line)++;
  }
  return t;
}

int parse_at_line(char **line)
{
  char *first, *second, *third;
  int gotbrac=FALSE, i=0, on=TRUE;
  char c;

  first=get_word(line, &gotbrac);
  if(first && *first) {
    i=1;
    if(gotbrac==FALSE) {
      second=get_word(line, &gotbrac);
      if(second && *second) {
        i=2;
        if(gotbrac==FALSE) {
          third=get_word(line, &gotbrac);
          if(third && *third)
	    i=3;
	}
      }
    }
  }
  switch(i) {
  case 1:
    if(toupper(*first)=='U') {
      on=FALSE;
      first++;
    }
    c=toupper(*first);
    switch(c) {
    case 'B':
      write_ansi(BOLD, on);
      break;
    case 'I':
      write_ansi(ITALIC, on);
      break;
    }
    break;
  case 2:
    if(Stricmp(first, "FG")==CMP_EQUAL) {
      if(Stricmp(second, "HIGHLIGHT")==CMP_EQUAL)
        write_ansi(HIGHLIGHT, TRUE);
      else if(Stricmp(second, "TEXT")==CMP_EQUAL)
        write_ansi(HIGHLIGHT, FALSE);
    }
    else if(Stricmp(second, "CLOSE")==CMP_EQUAL ||
	    Stricmp(second, "QUIT")==CMP_EQUAL) {
      write_ansi(OTHER, TRUE);
      fputs(first, outh);
      write_ansi(OTHER, FALSE);
    }
    break;
  case 3:
    if(Stricmp(second, "LINK")==CMP_EQUAL ||
       Stricmp(second, "ALINK")==CMP_EQUAL) {
      write_ansi(F_LINK, TRUE);
      fputs(first, outh);
      write_ansi(F_LINK, FALSE);
    }
    else {
      write_ansi(OTHER, TRUE);
      fputs(first, outh);
      write_ansi(OTHER, FALSE);
    }
    break;
  }
  return gotbrac;
}

void parse_node_line(char *line, char *title)
{
  char *first, *second;
  first=get_word(&line, NULL);
  second=get_word(&line, NULL);
  if(first && *first) {
    if(second && *second)
      strcpy(title, second);
    else
      strcpy(title, first);
  }
}

void parse_title_line(char *line, char *title)
{
  char *first;
  first=get_word(&line, NULL);
  if(first && *first)
    strcpy(title, first);
}

void statecopy(AT state)
{
  switch(state) {
  case A_IGNORE:
    fputc('\\', outh);
    break;
  case A_AT:
    fputc('@', outh);
    break;
  case A_BRAC:
    fputs("@{", outh);
    break;
  }
}

void output(char *line)
{
  AT status=A_INIT;
  int gotbrac;
  char c;

  if(line[0]=='@' && line[1]!='{')
    return;
  while(c=*line) {
    switch(c) {
    case '\\':
      if(status==A_INIT)
        status=A_IGNORE;
      else {
        statecopy(status);
        fputc(c, outh);
        status=A_INIT;
      }
      line++;
      break;
    case '@':
      if(status==A_INIT)
        status=A_AT;
      else {
        if(status!=A_IGNORE) statecopy(status);
        fputc(c, outh);
        status=A_INIT;
      }
      line++;
      break;
    case '{':
      if(status==A_AT)
        status=A_BRAC;
      else {
        statecopy(status);
        fputc(c, outh);
        status=A_INIT;
      }
      line++;
      break;
    case '}':
      switch(status) {
      case A_BRAC: case A_END:
	break;
      default:
        statecopy(status);
        fputc(c, outh);
	break;
      }
      status=A_INIT;
      line++;
      break;
    default:
      switch(status) {
      case A_BRAC:
        gotbrac=parse_at_line(&line);
        status=(gotbrac ? A_INIT : A_END);
	break;
      case A_END:
        line++;
	break;
      default:
        statecopy(status);
        fputc(c, outh);
        status=A_INIT;
        line++;
      }
    }
  }
}

void main(int argc, char *argv[])
{
  FILE *fh;
  NODE status=N_INIT;
  char *s, title[MAX_WIDTH];
  int empty=TRUE;
  char *top="\n--------------------------------------" \
            "--------------------------------------\n";
  char *bot="======================================" \
            "======================================\n";
  if(argc<2)
    error("Usage:  ag2txt <infile> [<outfile>]\n", 1);
  if((fh=fopen(argv[1], "r"))==NULL) {
    fprintf(stderr, "\"%s\" ", argv[1]);
    error("could not be opened\n", 2);
  }
  if(argc>2)
    outh=fopen(argv[2], "w");
  if(outh==NULL)
    outh=stdout;
  while(fgets(in, MAX_LINE_LEN, fh)) {
    switch(status) {
    case N_INIT:
      if(Strnicmp(in, "@DATABASE")!=CMP_EQUAL)
        error("Bad AmigaGuide input file\n", 3);
      else
        status=N_OUT;
      break;
    case N_OUT:
      if(Strnicmp(in, "@NODE ")==CMP_EQUAL) {
        status=N_IN;
	parse_node_line(in+6, title);
        empty=TRUE;
      }
      break;
    case N_IN:
      if(empty && Strnicmp(in, "@TITLE")==CMP_EQUAL)
	parse_title_line(in+6, title);
      else if(Strnicmp(in, "@ENDNODE")==CMP_EQUAL) {
        fputs(bot, outh);
	status=N_OUT;
      }
      else {
        s=in;
	while(*s == ' ' || *s == '\t' || *s == '\n') s++;
        if(!(empty && *s=='\0')) {
          if(empty) {
            write_ansi(TITLE, TRUE);
            fputs(title, outh);
            write_ansi(TITLE, FALSE);
            fputs(top, outh);
            empty=FALSE;
	  }
          output(in);
	}
      }
      break;
    }
  }
}
