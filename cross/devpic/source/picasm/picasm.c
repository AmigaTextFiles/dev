/*
 * picasm.c
 *
 * Freely distributable for non-commercial use (basically,
 * don't sell this program without my permission. You can
 * use it for developing commercial PIC applications, but
 * of course I am not responsible for any damages caused by
 * this assembler generating bad code or anything like that)
 *
 * Copyright 1995-1998 by Timo Rossi
 * See the file picasm.doc for more information
 * 
 *   email: trossi@iki.fi
 *   www: http://www.iki.fi/trossi/pic/
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <ctype.h>
#include <time.h>

#include "picasm.h"

int warnlevel;

static int total_line_count;
static int errors, warnings; /* error & warning counts */

unsigned short list_flags;

/* imported from devices.c */
extern struct pic_type pic_types[];

static FILE *list_fp;
static int listing_on;
static int list_loc;
static pic_instr_t *list_ptr;
static long list_val, list_len;

int cond_nest_count;
int unique_id_count;

/* the current source file/macro */
struct inc_file *current_file;

/* Line buffer & pointer to it */
char *line_buf_ptr;
char line_buffer[256];

static struct patch *global_patch_list;
struct patch **local_patch_list_ptr;

struct pic_type *pic_type;

int prog_mem_size;

static int reg_file_limit;

short code_generated;

static pic_instr_t prog_mem[PROGMEM_MAX];
static pic_instr_t data_eeprom[EEPROM_MAX];
static pic_instr_t pic_id[4];
pic_instr_t config_fuses;

org_mode_t O_Mode;

int prog_location;         /* current address for program code */
int reg_location;   /* current address for register file */
int edata_location; /* current address for data EEPROM */
int org_val;

int local_level;

/* Error handling */
/*
 * Show line number/line with error message
 */
static void
err_line_ref(void)
{
  struct inc_file *inc;

  if(current_file != NULL) {
    inc = current_file;
    if(inc->type != INC_FILE) {
      fprintf(stderr, "(Macro %s line %d) ",
	      inc->v.m.sym->name, inc->linenum);
      while(inc != NULL && inc->type != INC_FILE)
	inc = inc->next;
    }
    fprintf(stderr, "File '%s' at line %d:\n",
	    inc->v.f.fname, inc->linenum);
    fputs(line_buffer, stderr);
    if(line_buffer[0] != '\0' && line_buffer[strlen(line_buffer)-1] != '\n')
      fputc('\n', stderr);
  }
}

/*
 * Warning message
 */
void
warning(char *fmt, ...)
{
  va_list args;

  err_line_ref();
  fputs("Warning: ", stderr);
  va_start(args, fmt);
  vfprintf(stderr, fmt, args);
  if(list_fp != NULL) {
    fputs("Warning: ", list_fp);
    vfprintf(list_fp, fmt, args);
    fputc('\n', list_fp);
  }
  fputc('\n', stderr);
  va_end(args);
  warnings++;
}

/*
 * skip the end of line, in case of an error
 */
static void
error_lineskip(void)
{
  write_listing_line(0);
  skip_eol();
  get_token();
}

/*
 * Error message
 * call error_lineskip() if lskip is non-zero
 *
 */
void
error(int lskip, char *fmt, ...)
{
  va_list args;

  err_line_ref();
  fputs("Error: ", stderr);
  va_start(args, fmt);
  vfprintf(stderr, fmt, args);
  if(list_fp != NULL) {
    fputs("Error: ", list_fp);
    vfprintf(list_fp, fmt, args);
    fputc('\n', list_fp);
  }
  fputc('\n', stderr);
  va_end(args);
  if(++errors >= MAX_ERRORS)
    fatal_error("too many errors, aborting");
	
  if(lskip)
    error_lineskip();
}

/*
 * Fatal error message
 */
void
fatal_error(char *fmt, ...)
{
  va_list args;

  err_line_ref();
  fputs("Fatal error: ", stderr);
  va_start(args, fmt);
  vfprintf(stderr, fmt, args);
  fputc('\n', stderr);
  va_end(args);
  exit(EXIT_FAILURE);
}

/* memory allocation */
void *
mem_alloc(int size)
{
  void *p;

  if((p = malloc(size)) == NULL)
    fatal_error("Out of memory");

  return p;
}

/*
 * initialize the assembler
 */
static void
init_assembler(void)
{
  pic_instr_t *cp;
  int n;

  init_symtab(); /* initialize symbol table */

  /* initialize program memory to invalid values */
  for(n = PROGMEM_MAX, cp = prog_mem; n-- > 0; *cp++ = INVALID_INSTR);

  /* initialize data memory to invalid values */
  for(n = EEPROM_MAX, cp = data_eeprom; n-- > 0; *cp++ = INVALID_DATA);

  /* initialize jump  patch list */
  global_patch_list = NULL;

  prog_location = -1;
  reg_location = -1;
  edata_location = -1;

  org_val = -1;

  current_file = NULL;

  config_fuses = INVALID_CONFIG;
  pic_id[0] = INVALID_ID;

  errors = warnings = 0;

  list_flags = 0;
  list_len = 0;
  listing_on = 1;

  cond_nest_count = 0;
  unique_id_count = 1;
  total_line_count = 0;
  code_generated = 0;

  local_level = 0;

  ifskip_mode = 0;
}

/*
 * generate program code
 */
void gen_code(int val)
{
  if(pic_type == NULL)
    fatal_error("PIC device type not set");

  if(O_Mode == O_NONE) {
    O_Mode = O_PROGRAM;

    if(org_val < 0) {
      error(0, "ORG value not set");
      prog_location = 0;
      return;
    }

    prog_location = org_val;
  } else if(O_Mode != O_PROGRAM) {
    error(0, "ORG mode conflict");
    O_Mode = O_PROGRAM;
    return;
  }

  if(prog_location >= prog_mem_size)
    fatal_error("Code address out of range");

  if(prog_mem[prog_location] != INVALID_INSTR)
    warning("Overlapping code at 0x%x\n", prog_location);

  if((list_flags & LIST_PROG) == 0) {
    list_loc = prog_location;
    list_flags = LIST_LOC | LIST_PROG;
  }
  list_len++;

  prog_mem[prog_location++] = val;

  code_generated = 1;
}

/*
 * Generate data for data EEPROM
 */
void
gen_edata(int val)
{
  if(O_Mode == O_NONE) {
    O_Mode = O_EDATA;

    if(org_val < 0) {
      error(0, "ORG value not set");
      edata_location = 0;
      return;
    }

    edata_location = org_val;
  } else if(O_Mode != O_EDATA) {
    error(0, "ORG mode conflict");
    O_Mode = O_EDATA;
    return;
  }

  if(edata_location >= pic_type->eeprom_size)
    fatal_error("Data EEPROM address out of range");

  if(data_eeprom[edata_location] < 0x100)
    warning("Overlapping EEPROM data at 0x%x\n", edata_location);

  if((list_flags & LIST_LOC) == 0) {
    list_loc = edata_location;
    list_flags = LIST_LOC | LIST_EDATA;
  }
  list_len++;

  data_eeprom[edata_location++] = val;

  code_generated = 1;
}

/*
 * Write one line of Intel-hex file
 */
static void
write_hex_record(FILE *fp,
			   int reclen, /* length (in words) */
			   int loc, /* address */
			   pic_instr_t *data, /* pointer to word data */
			   int format) /* IHX8M or IHX16 */
{
  int check = 0;

  switch(format) {
    case IHX8M:
      fprintf(fp, ":%02X%04X00", 2*reclen, 2*loc);
      check += ((2*loc) & 0xff) + (((2*loc) >> 8) & 0xff) + 2*reclen;
      break;

    case IHX16:
      fprintf(fp, ":%02X%04X00", reclen, loc);
      check += (loc & 0xff) + ((loc >> 8) & 0xff) + reclen;
      break;
  }

  while(reclen--) {
    switch(format) {
      case IHX8M:
        fprintf(fp, "%02X%02X",
		(int)(*data & 0xff), (int)((*data >> 8) & 0xff));
	break;

      case IHX16:
	fprintf(fp, "%02X%02X",
		(int)((*data >> 8) & 0xff), (int)(*data & 0xff));
	break;
    }
    check += (*data & 0xff) + ((*data >> 8) & 0xff);
    data++;
  }

  /* write checksum, assumes 2-complement */
  fprintf(fp, "%02X" HEX_EOL, (-check) & 0xff);
}

/*
 * Write output file in ihx8m or ihx16-format
 *
 */
static void
write_output(char *fname, int format)
{
  int loc, reclen;
  FILE *fp;

  if((fp = fopen(fname, "w")) == NULL)
    fatal_error("Can't create file '%s'", fname);

  /* program */
  for(loc = 0;;) {
    while(loc < prog_mem_size && prog_mem[loc] == INVALID_INSTR)
      loc++;

    if(loc >= prog_mem_size)
      break;
      
    reclen = 0;
    while(reclen < 8 && loc < prog_mem_size
	  && prog_mem[loc] != INVALID_INSTR) {
      loc++;
      reclen++;
    }
    write_hex_record(fp, reclen, loc-reclen, &prog_mem[loc-reclen], format);
  }

  /* PIC ID */
  if(pic_id[0] != INVALID_ID) {
    switch(pic_type->instr_set) {
      case PIC12BIT:
        write_hex_record(fp, 4, prog_mem_size, pic_id, format);
	break;

      case PIC14BIT:
	write_hex_record(fp, 4, 0x2000, pic_id, format);
	break;
    }
  }

  /* config fuses */
  if(config_fuses != INVALID_CONFIG) {
    write_hex_record(fp, 1, pic_type->fuse_addr, &config_fuses, format);
  }

  if(pic_type->eeprom_size > 0) { /* data EEPROM */
    for(loc = 0;;) {
      while(loc < pic_type->eeprom_size && data_eeprom[loc] >= 0x100)
	loc++;
        
      if(loc >= pic_type->eeprom_size)
	break;
        
      reclen = 0;
      while(reclen < 8 && loc < pic_type->eeprom_size
	    && data_eeprom[loc] < 0x100) {
	loc++;
	reclen++;
      }
      write_hex_record(fp, reclen, 0x2100+loc-reclen,
		       &data_eeprom[loc-reclen], format);
    }
  }

  fputs(":00000001FF" HEX_EOL , fp); /* end record */
  fclose(fp);
}

/*
 * Write one line to listing file (if listing is enabled)
 */
void
write_listing_line(int cond_flag)
{
  int i;

  if(list_fp != NULL && listing_on) {
    fprintf(list_fp, "%04d%c%c",
	    ++total_line_count,
	    (current_file != NULL && current_file->type == INC_MACRO ?
	     '+' : ' '),
	    (cond_flag ? '!' : ' '));

    if(line_buffer[0] != '\0') {
      if(list_flags & LIST_VAL)	{
	fprintf(list_fp, "%08lX  ", list_val);
      } else {
	if(list_flags & LIST_LOC)
	  fprintf(list_fp, "%04X", list_loc);
	else
	  fputs("    ", list_fp);

	if((list_flags & (LIST_PROG|LIST_EDATA|LIST_PTR)) != 0) {
	  fputc(((list_flags & LIST_FORWARD) ? '?' : ' '), list_fp);
	  if(list_flags & LIST_PROG) {
	    fprintf(list_fp, "%04X ", prog_mem[list_loc]);
	  } else if(list_flags & LIST_EDATA) {
	    fprintf(list_fp, "%04X ", data_eeprom[list_loc]);
	  } else if(list_flags & LIST_PTR) {
	    fprintf(list_fp, "%04X ", *list_ptr++);
	  }
	} else {
	  fputs("      ", list_fp);
	}
      }

      fputs(line_buffer, list_fp);
      if(line_buffer[0] != '\0'
	 && line_buffer[strlen(line_buffer)-1] != '\n')
	fputc('\n', list_fp);

      list_len--;
      for(i = 0; i < list_len; i++) {
	list_loc++;
	fprintf(list_fp, "%04d%c ",
		total_line_count,
		(current_file != NULL
		 && current_file->type == INC_MACRO ?
		 '+' : ' '));

	if(list_flags & LIST_LOC)
	  fprintf(list_fp, "%04X", list_loc);
	else
	  fputs("    ", list_fp);

	if(list_flags & LIST_PROG) {
	  fprintf(list_fp, " %04X\n", prog_mem[list_loc]);
	} else if(list_flags & LIST_EDATA) {
	  fprintf(list_fp, " %04X\n", data_eeprom[list_loc]);
	} else if(list_flags & LIST_PTR) {
	  fprintf(list_fp, " %04X\n", *list_ptr++);
	}
      }
    }

    if(listing_on < 0)
      listing_on = 0;
  }
  list_flags = 0;
  list_len = 0;
}

/*
 * parse and handle OPT-directive
 * (this is special as it must be done as macro definition time
 *  if inside a macro)
 */
static int
handle_opt(void)
{
  if(token_type != TOK_IDENTIFIER) {
    error(1, "OPT syntax error");
    return FAIL;
  }
  /*
   * Note: when listing is turned off, 'listing_on' is set to -1
   * here and the listing routine sets it to zero after listing
   * the line containing the 'opt nol'.
   */
  if(strcasecmp(token_string, "nol") == 0
     || strcasecmp(token_string, "nolist") == 0) {
    listing_on = -1;
  } else if(strcasecmp(token_string, "l") == 0
	  || strcasecmp(token_string, "list") == 0) {
    listing_on = 1;
  } else {
    error(1, "OPT syntax error");
    return FAIL;
  }

  get_token();
  return OK;
}

/*
 * Define a macro
 */
static void
define_macro(char *name)
{
  struct symbol *sym;
  struct macro_line *ml;
  int t;

  if(token_type != TOK_NEWLINE && token_type != TOK_EOF)
    error(0, "Extraneous characters after a valid source line");
  skip_eol();

  write_listing_line(0);

  sym = add_symbol(name, SYMTAB_GLOBAL);
  sym->type = SYM_MACRO;
  sym->v.text = NULL;
  ml = NULL;

  for(;;) {
    get_token(); /* read first token on next line */
    t = 0;
    if(token_type == TOK_IDENTIFIER) {
      t = 1;
      get_token();
      if(token_type == TOK_COLON)
	get_token();
    }
    if(token_type == TOK_EOF || token_type == KW_END)
      fatal_error("Macro definition not terminated");

    if(token_type == KW_MACRO)
      fatal_error("Nested macro definitions not allowed");

    if(token_type == KW_ENDM) /* end macro definition */
      break;

/* OPT must be handled inside macros at definition time */
    if(token_type == KW_OPT) {
      get_token();
      handle_opt();
    } else {
      if(ml == NULL) {
	ml = mem_alloc(sizeof(struct macro_line)
		       +strlen(line_buffer));
	sym->v.text = ml;
      } else {
	ml->next = mem_alloc(sizeof(struct macro_line)
			     +strlen(line_buffer));
	ml = ml->next;
      }
      strcpy(ml->text, line_buffer);
      ml->next = NULL;
    }

    write_listing_line(0);

    line_buf_ptr = NULL;
    tok_char = ' ';
  }
  if(t)
    error(0, "Label not allowed with ENDM");
  get_token();
}

/*
 * Skip subroutine used by the conditional assembly directives
 * return: -1=premature EOF, 0=ok, 1=label (not allowed)
 */
static int
if_else_skip(void)
{
  int t, ccount;

  ccount = 0;
  ifskip_mode++;
  do {
    skip_eol();
    get_token();
    write_listing_line(1);

    t = 0;
    if(token_type == TOK_IDENTIFIER) {
      t = 1;
      get_token();
      if(token_type == TOK_COLON)
	get_token();
    }
    if(token_type == KW_IF) {
      ccount++;
    } else if(token_type == KW_ENDIF) {
      if(ccount <= 0)
	break;
      ccount--;
    } else if(token_type == KW_ELSE && ccount <= 0) {
      break;
    }
  } while(token_type != TOK_EOF && token_type != KW_END);

  ifskip_mode--;
  return (token_type == TOK_EOF || token_type == KW_END) ? -1 : t;
}

/*
 * Add a patch pointing to the current location
 */
void
add_patch(int tab, struct symbol *sym, patchtype_t type)
{
  struct patch **patch_list_ptr, *ptch;

  patch_list_ptr =
    (tab == SYMTAB_GLOBAL ? &global_patch_list : local_patch_list_ptr);

  if(O_Mode == O_NONE) {
    O_Mode = O_PROGRAM;
    if(org_val < 0) {
      error(0, "ORG value not set");
      prog_location = 0;
      return;
    }
    prog_location = org_val;
  }

  ptch = mem_alloc(sizeof(struct patch));
  ptch->label = sym;
  ptch->type = type;
  ptch->location = prog_location;

  /* add a new patch to patch_list */
  ptch->next = *patch_list_ptr;
  *patch_list_ptr = ptch;
}  

/*
 * Apply the store patches and also free the patch list
 */
static void
apply_patches(struct patch *patch_list)
{
  struct patch *ptch, *p2;

  /*
   * fix forward jumps/calls
   */
  for(ptch = patch_list; ptch != NULL; ptch = p2) {
    p2 = ptch->next;

    if(ptch->label->type == SYM_FORWARD)
      error(0, "Undefined label '%s%s'",
	    (patch_list == global_patch_list ? "" : "="),
	    ptch->label->name);
    else
      switch(ptch->type) {
        case PATCH8:
	  if(pic_type->instr_set == PIC12BIT && (ptch->label->v.value & 0x100) != 0
	     && (prog_mem[ptch->location] & 0xff00) == 0x900)
	    error(0, "CALL address in upper half of a page (label '%s%s')",
		  (patch_list == global_patch_list ? "" : "="),
		  ptch->label->name);

	  prog_mem[ptch->location] =
	    (prog_mem[ptch->location] & 0xff00)
	      | (ptch->label->v.value & 0xff);
	  break;

	case PATCH9:
	  prog_mem[ptch->location] =
	    (prog_mem[ptch->location] & 0xfe00)
	      | (ptch->label->v.value & 0x1ff);
	  break;

	case PATCH11:
	  prog_mem[ptch->location] =
	    (prog_mem[ptch->location] & 0xf800)
	      | (ptch->label->v.value & 0x7ff);
	  break;
      }
    mem_free(ptch);
  }
}

/*
 * Generate code for an instruction with 8-bit literal data
 * allows forward references
 */
int
gen_byte_c(int instr_code)
{
  int t, symtype;
  long val;
  struct symbol *sym;

  t = 0;
  if(token_type == TOK_IDENTIFIER || token_type == TOK_LOCAL_ID) {
    symtype =
      (token_type == TOK_IDENTIFIER ? SYMTAB_GLOBAL : SYMTAB_LOCAL);

    if(symtype == SYMTAB_LOCAL && local_level == 0) {
      error(1, "Local symbol outside a LOCAL block");
      return FAIL;
    }

    sym = lookup_symbol(token_string, symtype);
    if(sym == NULL || sym->type == SYM_FORWARD)	{
      if(sym == NULL) {
	sym = add_symbol(token_string, symtype);
	sym->type = SYM_FORWARD;
      }

      add_patch(symtype, sym, PATCH8);
      get_token();
      gen_code(instr_code);
      list_flags |= LIST_FORWARD;
      return OK;
    }
  }

  val = get_expression();
  if(expr_error)
    return FAIL;

  if(val < -0x80 || val > 0xff) {
    error(0, "8-bit literal out of range");
    return FAIL;
  }

  gen_code(instr_code | (val & 0xff));
  return OK;
}

/*
 * check if the current token is a valid ORG mode specifier
 * and return the mode (or O_NONE if not valid mode specifier)
 */
static int
org_mode(void)
{
  if(token_type == KW_EDATA)
    return O_EDATA;

  if(token_type == TOK_IDENTIFIER) {
    if(strcasecmp(token_string, "code") == 0)
      return O_PROGRAM;

    if(strcasecmp(token_string, "reg") == 0)
      return O_REGFILE;
  }

  return O_NONE;
}

/*
 * The assembler itself
 */
static void
assembler(char *fname)
{
  static char symname[256];
  struct symbol *sym;
  int op, t, symtype;
  long val;
  char *cp;
  struct pic_type *pic;

  if(pic_type != NULL) {
    sprintf(symname, "__%s", pic_type->name);
    sym = add_symbol(symname, SYMTAB_GLOBAL);
    sym->type = SYM_DEFINED;
    sym->v.value = 1;
  }

  begin_include(fname);
  get_token();

  while(token_type != TOK_EOF) {
    sym = NULL;
    if(token_type == TOK_IDENTIFIER || token_type == TOK_LOCAL_ID) {
      symtype =
	(token_type == TOK_IDENTIFIER ? SYMTAB_GLOBAL : SYMTAB_LOCAL);

      if(symtype == SYMTAB_LOCAL && local_level == 0) {
	error(1, "Local symbol outside a LOCAL block");
	continue;
      }

      t = (line_buf_off == 0);

      strcpy(symname, token_string);
      sym = lookup_symbol(symname, symtype);
      if(sym != NULL && sym->type == SYM_MACRO) {
	/* skip whitespace */
	while(tok_char != '\n' && isspace(tok_char))
	  read_src_char();

	if(line_buf_ptr != NULL &&
	   strncasecmp(line_buf_ptr-1, "macro", 5) == 0 &&
	   line_buf_ptr[4] != '.' && line_buf_ptr[4] != '_' &&
	   !isalnum((unsigned char)line_buf_ptr[4])) {
	  error(1, "Multiple definition of macro '%s'", symname);
	  continue;
	}

	expand_macro(sym);
	continue;
      }

      get_token();
      switch(token_type) {
        case KW_MACRO:
	  get_token();
	  if(sym != NULL) {
	    error(1, "Multiply defined symbol '%s%s'",
		  (symtype == SYMTAB_LOCAL ? "=" : ""),
		  sym->name);
	    continue;
	  }
	  define_macro(symname);
	  goto line_end;

	case KW_EQU:
	  if(sym != NULL) {
	    if(sym->type != SYM_FORWARD)
	      error(0, "Multiply defined symbol '%s%s'",
		    (symtype == SYMTAB_LOCAL ? "=" : ""),
		    sym->name);
	  } else
	    sym = add_symbol(symname, symtype);
	  get_token();
	  sym->type = SYM_DEFINED;
	  sym->v.value = get_expression();
	  if(expr_error)
	    continue; /* error_lineskip() done in expr.c */

	  list_val = sym->v.value;
	  list_flags = LIST_VAL;
	  goto line_end;

	case KW_SET:
	  if(sym != NULL && sym->type != SYM_SET)
	    error(0, "Multiply defined symbol '%s%s'",
		  (symtype == SYMTAB_LOCAL ? "=" : ""),
		  sym->name);
	  else if(sym == NULL)
	    sym = add_symbol(symname, symtype);
	  get_token();
	  sym->type = SYM_SET;
	  sym->v.value = get_expression();
	  if(expr_error)
	    continue;

	  list_val = sym->v.value;
	  list_flags = LIST_VAL;
	  goto line_end;

	case TOK_COLON:
	  get_token();
	  goto do_label;

	default:
	  if(t == 0)
	    warning("Label not in the beginning of a line");

do_label:
	  switch(O_Mode) {
	    case O_PROGRAM:
	      t = prog_location;
	      break;

	    case O_REGFILE:
	      t = reg_location;
	      break;

	    case O_EDATA:
	      t = edata_location;
	      break;

	    case O_NONE:
	      t = org_val;
	      break;
	  }

	  if(t < 0) {
	    error(0, "ORG value not set");
	  } else {
	    if(sym != NULL && sym->type != SYM_FORWARD)
	      error(0, "Multiply defined symbol '%s%s'",
		    (symtype == SYMTAB_LOCAL ? "=" : ""),
		    sym->name);
	    if(sym == NULL)
	      sym = add_symbol(symname, symtype);
	    sym->type = SYM_DEFINED;
	    sym->v.value = t;
	    list_loc = t;
	    list_flags = LIST_LOC;
	  }
	  break;
      }
    }

    /* if this line has a label, 'sym' points to it */

    if(token_type == TOK_NEWLINE) {
      write_listing_line(0);
      get_token();
      continue;
    }

    if(token_type == TOK_IDENTIFIER &&
       (sym = lookup_symbol(token_string, SYMTAB_GLOBAL))
       != NULL && sym->type == SYM_MACRO) {
      expand_macro(sym);
      continue;
    }

    if(token_type == KW_END)
      break;

    if(token_type == KW_ERROR) {
      while(isspace((unsigned char)(*line_buf_ptr)))
	 line_buf_ptr++;
      error(1, "%s", line_buf_ptr);
      continue;
    }
	  
    op = token_type;
    get_token();

    switch(op) {
      case KW_INCLUDE:
      if(token_type != TOK_STRCONST) {
	error(1, "Missing file name after INCLUDE");
	continue;
      }

      strcpy(symname, token_string);
      get_token();
      if(token_type != TOK_NEWLINE && token_type != TOK_EOF)
	error(0, "Extraneous characters after a valid source line");

      begin_include(symname);

      write_listing_line(0);
      get_token();
      continue;

    case KW_SET:
    case KW_EQU:
      if(sym == NULL)
	error(1, "SET/EQU without a label");
      else
	error(1, "SET/EQU syntax error");
      continue;

    case KW_MACRO:
      error(1, "MACRO without a macro name");
      continue;

    case KW_ENDM:
      error(1, "ENDM not allowed outside a macro");
      continue;

    case KW_EXITM:
      /*
       * EXITM works now (version 0.97). Strange that
       * nobody noticed that it wasn't implemented
       * at all in previous versions.
       */
      if(current_file == NULL || current_file->type != INC_MACRO) {
	error(1, "EXITM not allowed outside a macro");
	continue;
      }
      cond_nest_count = current_file->cond_nest_count;
      end_include();
      break;

    case KW_OPT:
      if(handle_opt() != OK) {
	error_lineskip();
	continue;
      }
      break;

    case KW_LOCAL:
      add_local_symtab();
      break;

    case KW_ENDLOCAL:
      if(local_level == 0) {
	error(1, "ENDLOCAL without LOCAL");
	continue;
      }

      apply_patches(*local_patch_list_ptr);
      remove_local_symtab();
      break;
	    
    case KW_IF:
      if(sym != NULL)
	error(0, "Label not allowed with IF");

      val = get_expression();

      if(token_type != TOK_NEWLINE && token_type != TOK_EOF)
	error(0, "Extraneous characters after a valid source line");

      if(val == 0) {
	write_listing_line(0);
	t=if_else_skip();
	if(t == -1)
	  fatal_error("Conditional not terminated");
	else if(t == 1)
	  error(0, "Label not allowed with %s",
		(token_type == KW_ELSE ? "ELSE" : "ENDIF"));

	if(token_type == KW_ELSE)
	  cond_nest_count++;
	get_token();
	goto line_end2;
      } else
	cond_nest_count++;
      break;

    case KW_ELSE:
      if(sym != NULL)
	error(0, "Label not allowed with %s", "ELSE");

      if(current_file == NULL
	 || cond_nest_count <= current_file->cond_nest_count)
	error(0, "ELSE without IF");

      write_listing_line(0);
      t = if_else_skip();
      if(t == -1)
	fatal_error("Conditional not terminated");
      else if(t == 1)
	error(0, "Label not allowed with %s",
	      (token_type == KW_ELSE ? "ELSE" : "ENDIF"));

      if(token_type == KW_ELSE)
	error(0, "Multiple ELSE statements with one IF");

      cond_nest_count--;

      get_token();
      goto line_end2;

    case KW_ENDIF:
      if(sym != NULL)
	error(0, "Label not allowed with %s", "ENDIF");

      if(current_file == NULL
	 || cond_nest_count <= current_file->cond_nest_count)
	error(0, "ENDIF without IF");

      cond_nest_count--;
      break;

    case KW_ORG:
      if(pic_type == NULL)
	fatal_error("PIC device type not set");

      org_val = -1;
      if((t = org_mode()) != O_NONE) {
	get_token();
	O_Mode = (org_mode_t)t;
	switch(O_Mode) {
	  case O_PROGRAM:
	  case O_NONE: /* shut up GCC warning, cannot really happen here */
	    org_val = prog_location;
	    break;

	  case O_REGFILE:
	    org_val = reg_location;
	    break;

	  case O_EDATA:
	    org_val = edata_location;
	    break;
	}
	if(org_val < 0) {
	  error(0, "ORG value not set");
	  O_Mode = O_NONE;
	}
	break;
      }

      val = get_expression();
      if(expr_error)
	continue;

      if(val < 0 || val >= prog_mem_size) {
	error(1, "ORG value out of range");
	continue;
      }

      org_val = val;
      O_Mode = O_NONE;

      if(token_type == TOK_COMMA) {
	get_token();
	if((t = org_mode()) == O_NONE) {
	  error(0, "Invalid ORG mode");
	} else {
	  O_Mode = (org_mode_t)t;
	  switch(O_Mode)
	  {
	    case O_PROGRAM:
	    case O_NONE: /* shut up GCC warning, cannot really happen here */
	      prog_location = org_val;
	      break;
		  
	    case O_REGFILE:
	      reg_location = org_val;
	      break;
		  
	    case O_EDATA:
	      edata_location = org_val;
	      break;
	  }
	}
	      
	get_token();
      }
	    
      list_loc = org_val;
      list_flags = LIST_LOC;
      break;

    case KW_DS:
      val = get_expression();
      if(expr_error)
	continue;

      if(O_Mode == O_NONE) {
	O_Mode = O_REGFILE;
	if(org_val < 0) {
	  error(0, "ORG value not set");
	  reg_location = 0;
	} else
	  reg_location = org_val;
      }

      if(O_Mode != O_REGFILE)
	error(0, "ORG mode conflict");
      else {
	if(reg_location >= reg_file_limit)
	  fatal_error("Register file address out of range");
	list_loc = reg_location;
	list_flags = LIST_LOC;
	reg_location += val;
      }
      break;

    case KW_EDATA:
      if(pic_type == NULL)
	fatal_error("PIC device type not set");

      if(pic_type->eeprom_size == 0) {
	error(1, "PIC%s does not have data EEPROM", pic_type->name);
	continue;
      }

      for(;;) {
	if(token_type == TOK_STRCONST) {
	  for(cp = token_string; *cp != '\0'; cp++)
	    gen_edata((int)((unsigned char)(*cp)));
	  get_token();
	} else {
	  val = get_expression();
	  if(expr_error)
	    break;

	  if(val < 0 || val > 0xff) {
	    error(0, "Data EEPROM byte out of range");
	  } else
	    gen_edata(val);
	}
	if(token_type != TOK_COMMA)
	  break;

	get_token();
      }
      break;

    case KW_CONFIG:
      if(pic_type == NULL)
	fatal_error("PIC device type not set");

      if(config_fuses != INVALID_CONFIG) {
	error(1, "Multiple CONFIG definitions");
	continue;
      }

      parse_config();

      list_flags = LIST_PTR;
      list_ptr = &config_fuses;
      list_len = 1;
      break;

      /* Device type */
    case KW_DEVICE:
      if(token_type != TOK_IDENTIFIER && token_type != TOK_STRCONST) {
	error(1, "DEVICE requires a device type");
	continue;
      }

      cp = token_string;
      if(strncasecmp(token_string, "PIC", 3) == 0)
	cp += 3;

      for(pic = pic_types; pic->name != NULL; pic++) {
	if(strcasecmp(pic->name, cp) == 0)
	  break;
      }
      if(pic->name == NULL)
	fatal_error("Invalid PIC device type");

      get_token();
      if(pic_type == pic)
	break;

      if(pic_type != NULL) {
	error(1, "Duplicate DEVICE setting");
	continue;
      }
      pic_type = pic;
      prog_mem_size = pic_type->progmem_size;
      reg_file_limit = pic_type->regfile_limit;

      sprintf(symname, "__%s", pic_type->name);
      sym = add_symbol(symname, SYMTAB_GLOBAL);
      sym->type = SYM_DEFINED;
      sym->v.value = 1;
      break;

      /* PIC ID */
    case KW_PICID:
      if(pic_type == NULL)
	fatal_error("PIC device type not set");

      if(pic_id[0] != INVALID_ID) {
	error(1, "Multiple ID definitions");
	continue;
      }

      /*
       * should check if ID is really allowed for all PIC types.
       * Microchip 1994 databook specfically says that ID is not
       * implemented on PIC16C6x/74... but 1995/96 databook
       * has different information about that...
       */

      for(t = 0;;) {
	val = get_expression();
	if(expr_error)
	  continue;

	if(val < 0 || val > 0x3fff)
	  error(0, "PIC ID value out of range");
	else {
	  if(t >= 4) {
	    error(1, "PIC ID too long (max 4 bytes)");
	    continue;
	  }
	  pic_id[t] = (pic_instr_t)val;
	}

	t++;

	if(token_type != TOK_COMMA)
	  break;

	get_token();
      }

      if(t > 0) {
	list_flags = LIST_PTR;
	list_len = t;
	list_ptr = pic_id;

	while(t < 4)
	  pic_id[t++] = 0x3fff;
      }
      break;

      /* mnemonics */

    default:
      switch(pic_type->instr_set) {
        case PIC12BIT:
	  t = assemble_12bit_mnemonic(op);
	  break;

	case PIC14BIT:
	default:
	  t = assemble_14bit_mnemonic(op);
	  break;
	}
      if(t != OK)
	continue;
      break;
    }

line_end:
    write_listing_line(0);

line_end2:
    if(token_type == TOK_EOF)
      continue;

    if(token_type != TOK_NEWLINE) {
      error(0, "Extraneous characters after a valid source line");
      skip_eol();
    }
    get_token();
  } /* while(token_type != TOK_EOF) */

  /*
   * Close all open source files
   * (only really necessary if END has been used)
   */
  while(current_file != NULL)
    end_include();

  if(local_level > 0)
    error(0, "LOCAL not terminated with ENDLOCAL");

  apply_patches(global_patch_list);
}

/*
 * main program
 */
int
main(int argc, char *argv[])
{
  static char in_filename[256], out_filename[256], list_filename[256];
  static int out_format = IHX8M;
  static int listing = 0, symdump = 0;
  char *p;
  time_t ti;
  struct tm *tm;

  pic_type = NULL;
  out_filename[0] = '\0';
  list_filename[0] = '\0';
  warnlevel = 0;

  while(argc > 1 && argv[1][0] == '-') {
    switch(argv[1][1]) {
      case 'o': /* output file name */
        if(argv[1][2] != '\0')
	  strcpy(out_filename, &argv[1][2]);
	else {
	  if(argc < 3) {
	    fputs("-o option requires a file name\n", stderr);
	    exit(EXIT_FAILURE);
	  }
	  strcpy(out_filename, argv[2]);
	  argc--;
	  argv++;
	}
	break;

      case 'i': case 'I': /* output hex format (ihx8m/ihx16) */
	if(strcasecmp(&argv[1][1], "ihx8m") == 0)
	  out_format = IHX8M;
	else if(strcasecmp(&argv[1][1], "ihx16") == 0)
	  out_format = IHX16;
	else
	  goto usage;
	break;

      case 'p': case 'P': /* PIC type */
	if(!((argv[1][2] == 'i' || argv[1][2] == 'I') &&
	     (argv[1][3] == 'c' || argv[1][3] == 'C')))
	  goto usage;

	for(pic_type = pic_types; pic_type->name != NULL; pic_type++) {
	  if(strcasecmp(pic_type->name, &argv[1][4]) == 0)
	    break;
	}

	if(pic_type->name == NULL) {
	  fprintf(stderr, "Invalid device type '%s'\n", &argv[1][1]);
	  exit(EXIT_FAILURE);
	}

	prog_mem_size = pic_type->progmem_size;
	reg_file_limit = pic_type->regfile_limit;
	break;

      case 'l': /* listing/list filename */
	listing = 1;
	if(argv[1][2] != '\0')
	  strcpy(list_filename, &argv[1][2]);
	break;

      case 's':
        symdump = 1;
        break;

      case 'w': /* warning mode (gives some more warnings) */
	if(argv[1][2] != '\0') {
	  warnlevel = atoi(&argv[1][2]);
	} else {
	  warnlevel = 1;
	}
	break;

      case 'v': /* version info */
	fprintf(stderr,
		"12/14-bit PIC assembler " VERSION
		" -- Copyright 1995-1998 by Timo Rossi\n"
    "AmigaOS version beta2 by RDC <rdc@cch.pmc.ru>\n");
	break;
	
      case '-': /* end of option list */
      case '\0':
	argc--;
	argv++;
	goto opt_done;

      default:
	goto usage;
    }
    argc--;
    argv++;
  }

opt_done:
  if(argc != 2) {
usage:
    fputs("Usage: picasm [-o<objname>] [-l<listfile>] [-s] [-ihx8m/ihx16]\n"
	  "              [-pic<device>] [-w[n]] [-version] <filename>\n", stderr);
    exit(EXIT_FAILURE);
  }

  strncpy(in_filename, argv[1], sizeof(in_filename)-1);
  if(strchr(in_filename, '.') == NULL)
    strcat(in_filename, ".asm");

  if(out_filename[0] == '\0') {
    strcpy(out_filename, in_filename);
    if((p = strrchr(out_filename, '.')) != NULL)
      *p = '\0';
  }
  if(strchr(out_filename, '.') == NULL)
    strcat(out_filename, ".hex");

  init_assembler();

  list_fp = NULL;
  if(listing) {
    if(list_filename[0] == '\0') {
      strcpy(list_filename, in_filename);
      if((p = strrchr(list_filename, '.')) != NULL)
	*p = '\0';
      strcat(list_filename, ".lst");
    }

    if((list_fp = fopen(list_filename, "w")) == NULL)
      fatal_error("Can't create listing file '%s'", list_filename);

    ti = time(NULL);
    tm = localtime(&ti);

    fprintf(list_fp, "** 12/14-bit PIC assembler " VERSION "\n");
    fprintf(list_fp, "** %s assembled %s\n",
	    in_filename, asctime(tm));
  }

  assembler(in_filename);
  if(errors == 0) {
    if(code_generated)
      write_output(out_filename, out_format);
    else
      fputs("No code generated\n", stderr);
  }
  else
    fprintf(stderr, "%d error%s found\n", errors, errors == 1 ? "" : "s");

  if(warnings != 0)
    fprintf(stderr, "%d warning%s\n", warnings, warnings == 1 ? "" : "s");

  if(list_fp)
    {
      if(symdump)
        dump_symtab(list_fp);
      fclose(list_fp);
    }
  return EXIT_SUCCESS;
}
