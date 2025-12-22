/*
 * picasm -- token.c
 *
 * Include handling, macro expansion, lexical analysis
 *
 * Timo Rossi <trossi@iki.fi>
 * 
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

#include "picasm.h"

/*
 * keyword table for tokenizer
 *
 * this must be in sync with the token definitions in picasm.h
 */
static char Keyword_Table[] = {
  "include\0"
  "macro\0"
  "endm\0"
  "exitm\0"
  "if\0"
  "else\0"
  "endif\0"
  "equ\0"
  "set\0"
  "end\0"
  "org\0"
  "ds\0"
  "edata\0"
  "config\0"
  "picid\0"
  "device\0"
  "defined\0"
  "streq\0"
  "isstr\0"
  "chrval\0"
  "opt\0"
  "local\0"
  "endlocal\0"
  "error\0"
	    
/* 12/14-bit PIC instruction mnemonics */
  "addlw\0"
  "addwf\0"
  "andlw\0"
  "andwf\0"
  "bcf\0"
  "bsf\0"
  "btfsc\0"
  "btfss\0"
  "call\0"
  "clrf\0"
  "clrw\0"
  "clrwdt\0"
  "comf\0"
  "decf\0"
  "decfsz\0"
  "goto\0"
  "incf\0"
  "incfsz\0"
  "iorlw\0"
  "iorwf\0"
  "movlw\0"
  "movf\0"
  "movwf\0"
  "nop\0"
  "option\0"
  "retfie\0"
  "retlw\0"
  "return\0"
  "rlf\0"
  "rrf\0"
  "sleep\0"
  "sublw\0"
  "subwf\0"
  "swapf\0"
  "tris\0"
  "xorlw\0"
  "xorwf\0"

  "\0"
};

/* tokenizer definitions & variables */
int tok_char;

int token_type, line_buf_off;
char token_string[TOKSIZE];
long token_int_val;

int ifskip_mode; /* TRUE when skipping code inside if..endif */

/*
 * include file handling
 */
void
begin_include(char *fname)
{
  struct inc_file *p;

  p = mem_alloc(sizeof(struct inc_file));
  p->type = INC_FILE;
  p->v.f.fname = mem_alloc(strlen(fname)+1);
  strcpy(p->v.f.fname, fname);
  p->linenum = 0;
  p->cond_nest_count = cond_nest_count;

  if((p->v.f.fp = fopen(p->v.f.fname, "r")) == NULL) {
    if(current_file == NULL) {
      fatal_error("Can't open '%s'", p->v.f.fname);
    } else {
      error(0, "Can't open include file '%s'", p->v.f.fname);
      free(p->v.f.fname);
      free(p);
      line_buf_ptr = NULL;
      tok_char = ' ';
      return;
    }
  }

  p->next = current_file;
  current_file = p;
  line_buf_ptr = NULL;
  tok_char = ' ';
}

/*
 * Move to previous level of include/macro
 */
void
end_include(void)
{
  struct inc_file *p;
  struct macro_arg *arg1, *arg2;

  if(current_file != NULL) {
    if(cond_nest_count != current_file->cond_nest_count) {
      error(0, "conditional assembly not terminated by ENDIF");
      cond_nest_count = current_file->cond_nest_count;
    }

    p = current_file->next;
    if(current_file->type == INC_FILE) {
      fclose(current_file->v.f.fp);
      free(current_file->v.f.fname);
    } else { /* free macro arguments */
      arg1 = current_file->v.m.args;
      while(arg1 != NULL) {
	arg2 = arg1->next;
	free(arg1);
	arg1 = arg2;
      }
    }
    free(current_file);
    current_file = p;
  }
}

/*
 * Expand a macro
 */
void
expand_macro(struct symbol *sym)
{
  struct inc_file *minc;
  struct macro_arg *arg;
  char *cp;
  int narg;
  int parcnt, d_char;

  write_listing_line(0); /* list the macro call line */

  minc = mem_alloc(sizeof(struct inc_file));
  minc->type = INC_MACRO;
  minc->v.m.sym = sym;
  minc->v.m.ml = sym->v.text;
  minc->linenum = 0;
  minc->cond_nest_count = cond_nest_count;
  minc->v.m.args = NULL;
  minc->v.m.uniq_id = unique_id_count++;
  arg = NULL;

  for(narg = 1;;narg++) {
    while(tok_char != '\n' && isspace(tok_char)) /* skip whitespace */
      read_src_char();

    if(tok_char == '\n' || tok_char == '\0' ||
       tok_char == ';' || tok_char == EOF)
      break;

    cp = line_buf_ptr-1;

    /*
     * Macro parameters are separated by commas. However, strings and
     * character constants (using double and single quotes)
     * can be used even if they contain commas. Also commas
     * inside parenthesis (such as function parameter delimiters)
     * don't count as macro parameter separators.
     *
     */

    parcnt = 0; /* parenthesis nesting count */

    while(!isspace(tok_char) &&
	  tok_char != '\n' && tok_char != '\0' &&
	  tok_char != ';' && tok_char != EOF) {
      if(parcnt == 0 && tok_char == ',')
	break;

      if(tok_char == '(') {
	parcnt++;
      } else if(tok_char == ')') {
	parcnt--;
      } else if(tok_char == '"' || tok_char == '\'') {
	/* quoted string or character constant */
	d_char = tok_char;

	do {
	  read_src_char();
	}
	while(tok_char != d_char && tok_char != '\n' &&
	      tok_char != '\0' && tok_char != EOF);

	if(tok_char != d_char)
	  break;
      }

      read_src_char();
    }

    if(narg >= 10)
      warning("Too many macro arguments (max. 9)");

    if(arg == NULL) {
      arg = mem_alloc(sizeof(struct macro_arg)
		      +(line_buf_ptr-cp-1));
      minc->v.m.args = arg;
    } else {
      arg->next = mem_alloc(sizeof(struct macro_arg)
			    +(line_buf_ptr-cp-1));
      arg = arg->next;
    }
    strncpy(arg->text, cp, line_buf_ptr-cp-1);
    arg->text[line_buf_ptr-cp-1] = '\0';
    arg->next = NULL;

    /* skip whitespace */
    while(tok_char != '\n' && isspace(tok_char))
      read_src_char();
    if(tok_char != ',')
      break;

    read_src_char();
  }

  if(tok_char != ';' && tok_char != '\n' &&
     tok_char != '\0' && tok_char != EOF)
    error(0, "Extraneous characters after a valid source line");

  minc->next = current_file;
  current_file = minc;

  line_buf_ptr = NULL;
  tok_char = ' ';
  get_token();
}

/*
 * Read a character from source file.
 * Handles includes and macros.
 */
void
read_src_char(void)
{
  char *scp, *pcp, *dcp;
  int parm;
  struct macro_arg *arg;
  static char tmpbuf[12];

  if(line_buf_ptr == NULL || *line_buf_ptr == '\0') {
    if(current_file == NULL) {
      tok_char = EOF;
      return;
    }

getc1:
    if(current_file->type == INC_MACRO)	{
      if(current_file->v.m.ml == NULL) {
	end_include();
	goto getc1;
      }

      scp = current_file->v.m.ml->text;
      dcp = line_buffer;
      while(*scp != '\0' && dcp < &line_buffer[sizeof(line_buffer)]) {
	if(*scp == '\\') {
	  scp++;
	  if(*scp >= '1' && *scp <= '9') { /* macro arg */
	    parm = *scp - '1'; /* macro arg #, starting from 0 */
	    for(arg = current_file->v.m.args;
		arg != NULL && parm > 0; arg = arg->next, parm--);
	    if(arg != NULL) {
	      for(pcp = arg->text; *pcp != '\0' &&
		  dcp < &line_buffer[sizeof(line_buffer)];)
		*dcp++ = *pcp++;
	    }
	    scp++;
	  } else if(*scp == '0' || *scp == '@') {
	    sprintf(tmpbuf, "%03d", current_file->v.m.uniq_id);

	    for(pcp = tmpbuf; *pcp != '\0' &&
		dcp < &line_buffer[sizeof(line_buffer)];)
	      *dcp++ = *pcp++;

	    scp++;
	  } else if(*scp == '#') { /* number of arguments */
	    for(parm = 0, arg = current_file->v.m.args;
		arg != NULL; arg = arg->next, parm++);

	    sprintf(tmpbuf, "%d", parm);

	    for(pcp = tmpbuf; *pcp != '\0' &&
		dcp < &line_buffer[sizeof(line_buffer)];)
	      *dcp++ = *pcp++;

	    scp++;
	  } else
	    *dcp++ = *scp;
	} else
	  *dcp++ = *scp++;
      }
      if(dcp == &line_buffer[sizeof(line_buffer)]) {
	error(0, "Line buffer overflow");
	dcp--;
      }

      *dcp = '\0'; /* NUL-terminate the line */
      current_file->v.m.ml = current_file->v.m.ml->next;
    } else {
      if(fgets(line_buffer, sizeof(line_buffer)-1,
	       current_file->v.f.fp) == NULL) {
	if(current_file->next != NULL) {
	  end_include();
	  goto getc1;
	}
	tok_char = EOF;
	return;
      }
    }
    current_file->linenum++;
    line_buf_ptr = line_buffer;
  }
  tok_char = ((unsigned char)(*line_buf_ptr++));
}

/*
 * Lexical analyzer
 * Returns the next token from the source file
 */
void
get_token(void)
{
  int tp, base;
  char *cp;

  for(;;) {
    /*
     * skip spaces
     */
    while(tok_char != '\n' && isspace(tok_char))
      read_src_char();

    if(tok_char == EOF)	{
      token_type = TOK_EOF;
      token_string[0] = '\0';
      return;
    }

    if(tok_char != ';')
      break;

    /* comment */
    line_buf_ptr = NULL;
    tok_char = '\n';

  } /* for(;;) */

/*
 * character constant (integer)
 * (does not currently handle the quote character)
 */
  if(tok_char == '\'') {
    read_src_char();
    token_string[0] = tok_char;
    read_src_char();
    if(tok_char != '\'')
      goto invalid_token;
    read_src_char();
    token_string[1] = '\0';
    token_int_val = (long)((unsigned char)token_string[0]);
    token_type = TOK_INTCONST;
    return;
  }

  if(tok_char == '"') { /* string constant (include filename) */
    read_src_char();
    tp = 0;
    while(tp < TOKSIZE-1 && tok_char != '"' && tok_char != EOF)	{
      token_string[tp++] = tok_char;
      read_src_char();
    }
    if(tok_char != '\"' && !ifskip_mode)
      error(0, "String not terminated");
    token_string[tp] = '\0';
    read_src_char();
    token_type = TOK_STRCONST;
    return;
  }

/*
 * integer number
 */
  if(isdigit(tok_char)) {
    token_type = TOK_INTCONST;
    token_string[0] = tok_char;
    tp = 1;
    read_src_char();
    if(token_string[0] == '0') {
      if(tok_char == 'x' || tok_char == 'X') { /* hex number */
	token_string[tp++] = tok_char;
	read_src_char();
	while(tp < TOKSIZE-1 && isxdigit(tok_char)) {
	  token_string[tp++] = tok_char;
	  read_src_char();
	}
	token_string[tp] = '\0';
	token_int_val = strtoul(&token_string[2], NULL, 16);
	/* should put range check here */
	return;
      }
    }

    while(tp < TOKSIZE-2 && isxdigit(tok_char))	{
      token_string[tp++] = tok_char;
      read_src_char();
    }

    base = 10;
    switch(tok_char) {
      case 'H': /* hex */
      case 'h':
        base = 16; /* hex */
	token_string[tp++] = tok_char;
	read_src_char();
	break;

      case 'O': /* octal */
      case 'o':
	base = 8; /* octal */
	token_string[tp++] = tok_char;
	read_src_char();
	break;

      default:
	if(token_string[0] == '0' &&
	   (token_string[1] == 'b' || token_string[1] == 'B')) {
	  token_string[tp] = '\0';
	  token_int_val = strtoul(&token_string[2], &cp, 2);
	  if(cp != &token_string[tp] && !ifskip_mode)
	    error(0, "Invalid digit in a number");
	  /* should put range check here */
	  return;
	} else if(token_string[tp-1] == 'B' || token_string[tp-1] == 'b') {
	  base = 2;
	} else {
	  if(token_string[tp-1] != 'D' && token_string[tp-1] != 'd')
	    token_string[tp++] = '\0';
	}
	break;
    }

    token_string[tp] = '\0';
    token_int_val = strtoul(token_string, &cp, base);
    if(cp != &token_string[tp-1] && !ifskip_mode)
      error(0, "Invalid digit in a number");
    /* should put range check here */
    return;
  }

/*
 * Handle B'10010100' binary etc.
 */
  if((tok_char == 'b' || tok_char == 'B' ||
      tok_char == 'd' || tok_char == 'D' ||
      tok_char == 'h' || tok_char == 'H' ||
      tok_char == 'o' || tok_char == 'O') &&
     line_buf_ptr != NULL && *line_buf_ptr == '\'') {
    token_string[0] = tok_char;
    read_src_char();
    token_string[1] = tok_char;
    read_src_char();
    tp = 2;
    while(tp < TOKSIZE-1 && isxdigit(tok_char))	{
      token_string[tp++] = tok_char;
      read_src_char();
    }
    if(tok_char != '\'')
      goto invalid_token;
    token_string[tp++] = tok_char;
    read_src_char();
    token_string[tp] = '\0';

    switch(token_string[0]) {
      case 'b':
      case 'B':
        base = 2;
	break;

      case 'o':
      case 'O':
	base = 8;
	break;

      case 'h':
      case 'H':
	base = 16;
	break;

      case 'd':
      case 'D':
      default:
	base = 10;
	break;
    }

    token_int_val = strtoul(&token_string[2], &cp, base);
    if(cp != &token_string[tp-1] && !ifskip_mode)
      error(0, "Invalid digit in a number");
    /* should put range check here */
    token_type = TOK_INTCONST;
    return;
  }

/*
 * keyword or identifier
 */
  if(tok_char == '_' || tok_char == '.' || isalpha(tok_char)) {
    line_buf_off = (line_buf_ptr - &line_buffer[1]);

    token_string[0] = tok_char;
    tp = 1;
    read_src_char();

    if(token_string[0] == '.' &&
       tok_char != '_' && !isalnum(tok_char)) {
      token_string[1] = '\0';
      token_type = TOK_PERIOD;
      return;
    }

    while(tp < TOKSIZE-1 &&
	  (tok_char == '_' || tok_char == '.' || isalnum(tok_char))) {
      token_string[tp++] = tok_char;
      read_src_char();
    }
    token_string[tp] = '\0';

    token_type = FIRST_KW;
    cp = Keyword_Table;
    while(*cp) {
      if(strcasecmp(token_string, cp) == 0)
	return;
      while(*cp++)
	;
      token_type++;
    }
    token_type = TOK_IDENTIFIER;
    return;
  }

/*
 * non-numeric & non-alpha tokens
 */
  switch(tok_char) {
    case '\n':
    case '\0':
      token_type = TOK_NEWLINE;
      strcpy(token_string, "\\n");
      skip_eol();
      return;

    case '<':
      token_string[0] = tok_char;
      read_src_char();
      if(tok_char == '<') {
	token_string[1] = tok_char;
	token_string[2] = '\0';
	token_type = TOK_LSHIFT;
	read_src_char();
	return;
      }

      if(tok_char == '=') {
	token_string[1] = tok_char;
	token_string[2] = '\0';
	token_type = TOK_LESS_EQ;
	read_src_char();
	return;
      }

      if(tok_char == '>') {
	token_string[1] = tok_char;
	token_string[2] = '\0';
	token_type = TOK_NOT_EQ;
	read_src_char();
	return;
      }

      token_type = TOK_LESS;
      token_string[1] = '\0';
      return;

    case '>':
      token_string[0] = tok_char;
      read_src_char();
      if(tok_char == '>') {
	token_string[1] = tok_char;
	token_string[2] = '\0';
	token_type = TOK_RSHIFT;
	read_src_char();
	return;
      }

      if(tok_char == '=') {
	token_string[1] = tok_char;
	token_string[2] = '\0';
	token_type = TOK_GT_EQ;
	read_src_char();
	return;
      }

      token_string[1] = '\0';
      token_type = TOK_GREATER;
      return;

    case '!':
      token_string[0] = tok_char;
      read_src_char();
      if(tok_char != '=')
	goto invalid_token;
      token_string[1] = tok_char;
      token_string[2] = '\0';
      read_src_char();
      token_type = TOK_NOT_EQ;
      return;

    case '=':
      token_string[0] = tok_char;
      read_src_char();
      if(tok_char == '=') {
	token_string[1] = tok_char;
	read_src_char();
	token_string[2] = '\0';
	token_type = TOK_EQ;
	return;
      }

      if(tok_char == '<') {
	token_string[1] = tok_char;
	read_src_char();
	token_string[2] = '\0';
	token_type = TOK_LESS_EQ;
	return;
      }

      if(tok_char == '>') {
	token_string[1] = tok_char;
	read_src_char();
	token_string[2] = '\0';
	token_type = TOK_GT_EQ;
	return;
      }

      if(tok_char == '_' || tok_char == '.' ||
	 isalpha(tok_char)) { /* local symbol */
	line_buf_off = (line_buf_ptr - &line_buffer[2]);

	token_string[0] = tok_char;
	tp = 1;
	read_src_char();

	while(tp < TOKSIZE-1 &&
	      (tok_char == '_' || tok_char == '.' || isalnum(tok_char))) {
	  token_string[tp++] = tok_char;
	  read_src_char();
	}
	token_string[tp] = '\0';

	token_type = TOK_LOCAL_ID;
	return;
      }

      token_string[1] = '\0';
      token_type = TOK_EQUAL;
      return;

    case '$':
      read_src_char();
      if(!isxdigit(tok_char))
	{
	  token_string[0] = '$';
	  token_string[1] = '\0';
	  token_type = TOK_DOLLAR;
	  return;
	}

      tp = 0;
      do
	{
	  token_string[tp++] = tok_char;
	  read_src_char();
	} while(tp < TOKSIZE-1 && isxdigit(tok_char));

      token_string[tp] = '\0';
      token_int_val = strtoul(&token_string[1], NULL, 16);
      token_type = TOK_INTCONST;
      /* should put range check here */
      return;

    case '\\':
      token_type = TOK_BACKSLASH;
      break;

    case ',':
      token_type = TOK_COMMA;
      break;

    case '(':
      token_type = TOK_LEFTPAR;
      break;

    case ')':
      token_type = TOK_RIGHTPAR;
      break;

    case '+':
      token_type = TOK_PLUS;
      break;

    case '-':
      token_type = TOK_MINUS;
      break;

    case '&':
      token_type = TOK_BITAND;
      break;

    case '|':
      token_type = TOK_BITOR;
      break;

    case '^':
      token_type = TOK_BITXOR;
      break;

    case '~':
      token_type = TOK_BITNOT;
      break;

    case '*':
      token_type = TOK_ASTERISK;
      break;

    case '/':
      token_type = TOK_SLASH;
      break;

    case '%':
      token_type = TOK_PERCENT;
      break;

    case ':':
      token_type = TOK_COLON;
      break;

    case '[':
      token_type = TOK_LEFTBRAK;
      break;

    case ']':
      token_type = TOK_RIGHTBRAK;
      break;

    default:
      goto invalid_token;
  }

  token_string[0] = tok_char;
  token_string[1] = '\0';
  read_src_char();
  return;

invalid_token:
  if(!ifskip_mode)
    error(0, "Invalid token");
  token_string[0] = '\0';
  token_type = TOK_INVALID;
}

/* skip to the next line */
void
skip_eol(void)
{
  line_buf_ptr = NULL;
  tok_char = ' ';
}
