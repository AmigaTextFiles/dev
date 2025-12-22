/*
 * picasm -- pic12bit.c
 *
 * Timo Rossi <trossi@iki.fi>
 * 
 */

#include <stdio.h>

#include "picasm.h"

/*
 * Assemble 12-bit PIC code
 *
 */
int
assemble_12bit_mnemonic(int op)
{
  long val;
  struct symbol *sym;
  char *cp;
  int t, symtype;

  switch(op) {
    case KW_ANDLW:
    case KW_IORLW:
    case KW_XORLW:
      val = get_expression();
      if(expr_error)
	return FAIL;
      if(val < -0x80 || val > 0xff)
	error(1, "8-bit literal out of range");
      val &= 0xff; /* this assumes 2-complement negative numbers */
      switch(op) {
        case KW_ANDLW: gen_code(0xe00 | val); break;
	case KW_IORLW: gen_code(0xd00 | val); break;
	case KW_XORLW: gen_code(0xf00 | val); break;
      }
      break;

    case KW_MOVLW:
      if(gen_byte_c(0xc00) != OK)
	return FAIL;
      break;

    case KW_ADDWF:
    case KW_SUBWF:
    case KW_ANDWF:
    case KW_IORWF:
    case KW_XORWF:
    case KW_COMF:
    case KW_DECF:
    case KW_INCF:
    case KW_MOVF:
    case KW_DECFSZ:
    case KW_INCFSZ:
    case KW_RLF:
    case KW_RRF:
    case KW_SWAPF:
      val = get_expression();
      if(expr_error)
	return FAIL;
      if(val < 0 || val > 0x1f)
	error(0, "Register file address out of range");
      t = 1;
      if(token_type == TOK_COMMA) {
	get_token();
	t = get_expression();
	if(expr_error)
	  return FAIL;
      }	else {
	if(warnlevel > 0)
	  warning("Destination speficier omitted");
      }
      val = (val & 0x1f) | (t != 0 ? 0x20 : 0);
      switch(op) {
        case KW_ADDWF:  gen_code(0x1c0 | val); break;
	case KW_SUBWF:  gen_code(0x080 | val); break;
	case KW_ANDWF:  gen_code(0x140 | val); break;
	case KW_IORWF:  gen_code(0x100 | val); break;
	case KW_XORWF:  gen_code(0x180 | val); break;
	case KW_COMF:   gen_code(0x240 | val); break;
	case KW_DECF:   gen_code(0x0c0 | val); break;
	case KW_INCF:   gen_code(0x280 | val); break;
	case KW_MOVF:   gen_code(0x200 | val); break;
	case KW_DECFSZ: gen_code(0x2c0 | val); break;
	case KW_INCFSZ: gen_code(0x3c0 | val); break;
	case KW_RLF:    gen_code(0x340 | val); break;
	case KW_RRF:    gen_code(0x300 | val); break;
	case KW_SWAPF:  gen_code(0x380 | val); break;
      }
      break;

    case KW_CLRF:
    case KW_MOVWF:
      val = get_expression();
      if(expr_error)
	return FAIL;
      if(val < 0 || val > 0x1f)
	error(0, "Register file address out of range");
      switch(op) {
        case KW_CLRF:  gen_code(0x060 | val); break;
	case KW_MOVWF: gen_code(0x020 | val); break;
      }
      break;

    case KW_BCF:
    case KW_BSF:
    case KW_BTFSC:
    case KW_BTFSS:
      val = get_expression();
      if(expr_error)
	return FAIL;
      if(val < 0 || val > 0x1f)
	error(0, "Register file address out of range");
      if(token_type != TOK_COMMA) {
	error(1, "',' expected");
	return FAIL;
      }
      get_token();
      t = get_expression();
      if(expr_error)
	return FAIL;
      if(t < 0 || t > 7) {
	error(0, "Bit number out of range");
      }
      val |= (t << 5);
      switch(op) {
        case KW_BCF:   gen_code(0x400 | val); break;
	case KW_BSF:   gen_code(0x500 | val); break;
	case KW_BTFSC: gen_code(0x600 | val); break;
	case KW_BTFSS: gen_code(0x700 | val); break;
      }
      break;

    case KW_CALL:
    case KW_GOTO:
      t = 0;
      if(token_type == TOK_IDENTIFIER || token_type == TOK_LOCAL_ID) {
	symtype =
	  (token_type == TOK_IDENTIFIER ? SYMTAB_GLOBAL : SYMTAB_LOCAL);

	if(symtype == SYMTAB_LOCAL && local_level == 0) {
	  error(1, "Local symbol outside a LOCAL block");
	  return FAIL;
	}

	sym = lookup_symbol(token_string, symtype);
	if(sym == NULL || sym->type == SYM_FORWARD) {
	  if(sym == NULL) {
	    sym = add_symbol(token_string, symtype);
	    sym->type = SYM_FORWARD;
	  }

	  val = 0;
	  add_patch(symtype, sym,
		    (op == KW_CALL ? PATCH8 : PATCH9));
	  t = 1;
	  get_token();
	  goto gen_goto_call;
	}
      }

      val = get_expression();
      if(expr_error)
	return FAIL;

      if(val < 0 || val >= prog_mem_size)
	error(0, "GOTO/CALL address out of range");

      if(op == KW_CALL && (val & 0x100) != 0)
	error(0, "CALL address in upper half of a page");

gen_goto_call:
      switch(op) {
        case KW_CALL: gen_code(0x900 | (val & 0xff)); break;
	case KW_GOTO: gen_code(0xa00 | (val & 0x1ff)); break;
      }
      if(t)
	list_flags |= LIST_FORWARD;
      break;

    case KW_TRIS:
      t = get_expression();
      if(expr_error)
	return FAIL;
      if(t != 5 && t != 6 && t != 7)
	error(0, "Invalid register address for TRIS");
      gen_code(0x000 | t);
      break;

/*
 * RETLW allows multiple parameters/strings, for generating lookup tables
 */
    case KW_RETLW:
      for(;;) {
	if(token_type == TOK_STRCONST) {
	  for(cp = token_string; *cp != '\0'; cp++)
	    gen_code(0x800 | (int)((unsigned char)(*cp)));
	  get_token();
	} else {
	  if(gen_byte_c(0x800) != OK)
	    return FAIL;
	}

	if(token_type != TOK_COMMA)
	  break;

	get_token();
      }
      break;

    case KW_NOP:
      gen_code(0x000);
      break;

    case KW_CLRW:
      gen_code(0x040);
      break;

    case KW_OPTION:
      gen_code(0x002);
      break;

    case KW_SLEEP:
      gen_code(0x003);
      break;

    case KW_CLRWDT:
      gen_code(0x004);
      break;

    case KW_RETURN:
    case KW_RETFIE:
    case KW_ADDLW:
    case KW_SUBLW:
      error(1, "Unimplemented instruction for PIC%s", pic_type->name);
      return FAIL;

    default:
      error(1, "Syntax error");
      return FAIL;
  }

  return OK;
}

