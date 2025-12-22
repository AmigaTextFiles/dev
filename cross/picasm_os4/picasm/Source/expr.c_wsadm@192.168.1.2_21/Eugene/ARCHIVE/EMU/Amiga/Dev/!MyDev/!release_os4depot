/*
 * picasm -- expr.c
 *
 * expression parser
 *
 * Timo Rossi <trossi@iki.fi>
 * 
 */

#include <stdio.h>
#include <string.h>

#include "picasm.h"

int expr_error; /* expression error flag */

/*
 * expression parser, bottom level
 */
static long
expr_element(void)
{
  long val, tval;
  struct symbol *sym;
  static unsigned char strbuf[256];
  int symtype;

  if(expr_error)
    return 0;
	
  switch(token_type) {
    case TOK_LEFTBRAK:
      get_token();
      tval = 0;
      while(!expr_error && token_type != TOK_RIGHTBRAK) {
	val = get_expression();
	if(val < 0 || val >= EXPR_NBITS) {
	  error(1, "bit number out of range");
	  expr_error = 1;
	}
	tval |= (1 << val);
      }
      if(!expr_error)
	get_token();
      return tval;

    case TOK_LEFTPAR:
      get_token();
      val = get_expression();
      if(!expr_error && token_type != TOK_RIGHTPAR) {
	error(1, "')' expected");
	expr_error = 1;
      }
      if(!expr_error)
	get_token();
      return val;

    case KW_DEFINED:
      get_token();
      if(token_type != TOK_LEFTPAR) {
	error(1, "'(' expected");
	expr_error = 1;
	return EXPR_FALSE;
      }

      get_token();
      if(token_type != TOK_IDENTIFIER && token_type != TOK_LOCAL_ID) {
	error(1, "Symbol expected");
	expr_error = 1;
	return EXPR_FALSE;
      }

      symtype =
	(token_type == TOK_IDENTIFIER ? SYMTAB_GLOBAL : SYMTAB_LOCAL);

      if((sym = lookup_symbol(token_string, symtype)) == NULL)
	val = EXPR_FALSE;
      else if(sym->type == SYM_DEFINED || sym->type == SYM_SET)
	val = EXPR_TRUE;
      else
	val = EXPR_FALSE;

      get_token();
      if(token_type != TOK_RIGHTPAR) {
	error(1, "')' expected");
	expr_error = 1;
	return val;
      }
      get_token();
      return val;

    case KW_STREQ:
      /* streq(arg1, arg2), return TRUE if strings are identical */
      get_token();
      if(token_type != TOK_LEFTPAR) {
	error(1, "'(' expected");
	expr_error = 1;
	return EXPR_FALSE;
      }

      get_token();
      if(token_type != TOK_STRCONST) {
	error(1, "Quoted string expected");
	expr_error = 1;
	return EXPR_FALSE;
      }
      strcpy(strbuf, token_string);

      get_token();
      if(token_type != TOK_COMMA) {
	error(1, "',' expected");
	expr_error = 1;
	return EXPR_FALSE;
      }

      get_token();
      if(token_type != TOK_STRCONST) {
	error(1, "Quoted string expected");
	expr_error = 1;
	return EXPR_FALSE;
      }

      val = (strcmp(token_string, strbuf) == 0 ? EXPR_TRUE : EXPR_FALSE);

      get_token();
      if(token_type != TOK_RIGHTPAR) {
	error(1, "')' expected");
	expr_error = 1;
	return val;
      }
      get_token();
      return val;

    case KW_ISSTR:
      /* isstr(arg), return TRUE if argument is a quoted string */
      get_token();
      if(token_type != TOK_LEFTPAR) {
	error(1, "'(' expected");
	expr_error = 1;
	return EXPR_FALSE;
      }

      get_token();
      if(token_type == TOK_STRCONST) {
	val = EXPR_TRUE;
	get_token();
      }	else if(token_type == TOK_RIGHTPAR) {
	get_token(); /* empty parameter list */
	return EXPR_FALSE;
      } else {
	val = EXPR_FALSE;
	do {
	  get_token();
	} while(token_type != TOK_EOF && token_type != TOK_NEWLINE &&
		token_type != TOK_COMMA && token_type != TOK_RIGHTPAR);
      }
      if(token_type != TOK_RIGHTPAR) {
	error(1, "')' expected");
	expr_error = 1;
	return val;
      }
      get_token();
      return val;

    case KW_CHRVAL:
      /* chrval(string, pos), return ascii code of character in string */
      get_token();
      if(token_type != TOK_LEFTPAR) {
	error(1, "'(' expected");
	expr_error = 1;
	return -1;
      }

      get_token();
      if(token_type != TOK_STRCONST) {
	error(1, "Quoted string expected");
	expr_error = 1;
	return -1;
      }
      strcpy(strbuf, token_string);

      get_token();
      if(token_type != TOK_COMMA) {
	error(1, "',' expected");
	expr_error = 1;
	return -1;
      }

      get_token();
      val = get_expression();
      if(val < 0 || val >= (long)strlen(strbuf))
	val = -1;
      else
	val = strbuf[val];

      if(token_type != TOK_RIGHTPAR) {
	error(1, "')' expected");
	expr_error = 1;
	return val;
      }
      get_token();
      return val;

    case TOK_DOLLAR: /* current location */
    case TOK_PERIOD:
      switch(O_Mode) {
        case O_PROGRAM:
	  val = prog_location;
	  break;

	case O_REGFILE:
	  val = reg_location;
	  break;

	case O_EDATA:
	  val = edata_location;
	  break;

	case O_NONE:
	default:
	  val = org_val;
	  break;
      }
      if(val < 0) {
	error(1, "ORG value not set");
	expr_error = 1;
      }
      get_token();
      return val;

    case TOK_INTCONST:
      val = token_int_val;
      get_token();
      return val;

    case TOK_IDENTIFIER:
    case TOK_LOCAL_ID:
      symtype =
	(token_type == TOK_IDENTIFIER ? SYMTAB_GLOBAL : SYMTAB_LOCAL);

      if(symtype == SYMTAB_LOCAL && local_level == 0) {
	error(1, "Local symbol outside a LOCAL block");
	expr_error = 1;
	return 0;
      }

      if((sym = lookup_symbol(token_string, symtype)) == NULL) {
	error(1, "Undefined symbol '%s%s'",
	      (symtype == SYMTAB_LOCAL ? "=" : ""),
	      token_string);
	expr_error = 1;
      }	else {
	if(sym->type == SYM_MACRO) {
	  error(1, "Invalid usage of macro name '%s'", token_string);
	  expr_error = 1;
	} else if(sym->type != SYM_DEFINED && sym->type != SYM_SET) {
	  error(1, "Undefined symbol '%s%s'",
		(symtype == SYMTAB_LOCAL ? "=" : ""),
		token_string);
	  expr_error = 1;
	}

	get_token();
	return sym->v.value;
      }
      break;

    default:
      expr_error = 1;
      error(1, "Expression syntax error");
      break;
  }

  return 0;
}

/* expression parser, unary minus and bit-not */
static long
expr_unary1(void)
{
  int op;
  long val;

  if(!expr_error &&
     (token_type == TOK_MINUS || token_type == TOK_BITNOT)) {
    op = token_type;
    get_token();
    val = expr_element();
    if(op == TOK_MINUS)
      return -val;
    else
      return ~val;
  } else
    return expr_element();
}

/* expression, multiplication, division, bit-and */
static long
expr_mul_div(void)
{
  int op;
  long val1, val2;

  val1 = expr_unary1();
  while(!expr_error &&
	((op = token_type) == TOK_ASTERISK || op == TOK_SLASH ||
	 op == TOK_PERCENT || op == TOK_BITAND)) {
    get_token();
    val2 = expr_unary1();
    switch(op) {
      case TOK_ASTERISK:
        val1 *= val2;
	break;

      case TOK_SLASH:
      case TOK_PERCENT:
	if(val2 == 0) {
	  error(1, "Division by zero");
	  expr_error = 1;
	} else {
	  if(op == TOK_SLASH)
	    val1 /= val2;
	  else
	    val1 %= val2;
	}
	break;

      case TOK_BITAND:
	val1 &= val2;
	break;
    }
  }
  return val1;
}

/* expression. add, subtract, bit-or */
static long
expr_add_sub(void)
{
  int op;
  long val1, val2;

  val1 = expr_mul_div();
  while(!expr_error && ((op = token_type) == TOK_PLUS || op == TOK_MINUS ||
		       op == TOK_BITOR || op == TOK_BITXOR ||
		       op == TOK_LSHIFT || op == TOK_RSHIFT)) {
    get_token();
    val2 = expr_mul_div();
    switch(op) {
      case TOK_PLUS:
        val1 += val2;
	break;

      case TOK_MINUS:
	val1 -= val2;
	break;

      case TOK_BITOR:
	val1 |= val2;
	break;

      case TOK_BITXOR:
	val1 ^= val2;
	break;

      case TOK_LSHIFT:
	val1 <<= val2;
	break;

      case TOK_RSHIFT:
	val1 >>= val2;
	break;
      }
  }
  return val1;
}

/*
 * the main expression parser entry point
 *
 * handles only compare operators directly
 * (note: '=' (TOK_EQUAL) cannot be used as a comparison operator
 * as it would be confused with local labels. '==' (TOK_EQ)
 * must be used instead)
 */
long
get_expression(void)
{
  int op;
  long val1, val2;

  expr_error = 0;

  val1 = expr_add_sub();
  while(!expr_error && ((op = token_type) == TOK_EQ ||
		       op == TOK_NOT_EQ ||
		       op == TOK_LESS || op == TOK_GREATER ||
		       op == TOK_LESS_EQ || op == TOK_GT_EQ)) {
    get_token();
    val2 = expr_add_sub();
    switch(op) {
      case TOK_EQ:
        val1 = -(val1 == val2);
	break;

      case TOK_NOT_EQ:
	val1 = -(val1 != val2);
	break;

      case TOK_LESS:
	val1 = -(val1 < val2);
	break;

      case TOK_LESS_EQ:
	val1 = -(val1 <= val2);
	break;

      case TOK_GREATER:
	val1 = -(val1 > val2);
	break;

      case TOK_GT_EQ:
	val1 = -(val1 >= val2);
	break;
    }
  }
  return val1;
}
