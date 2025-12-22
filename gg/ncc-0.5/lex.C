/******************************************************************************

	C/C++ lexcial analyser on preprocessed source

******************************************************************************/

#include <string.h>
#include <stdio.h>
#include <ctype.h>

#include "global.h"

token CTok;
int line;

static char *Cpp;
static int Ci, Clen;

/******************************************************************************
		Unwindable lex exceptional error conditions
******************************************************************************/

class EOFC {
public:
	EOFC(char*);
};

EOFC::EOFC (char *c)
{
	fprintf (stderr, "Unterminated %s near token %i\n", c, Ci);
}

/***************************************************************************
		Start of Token Parser Routines
***************************************************************************/

static void skip_line ()
{
	for (;;) {
		while (Cpp [Ci] != '\n')
			if (++Ci >= Clen) return;
		if (Cpp [Ci - 1] == '\\') {
			//++line;
			++Ci;
			continue;
		}
		break;
	}
}

static void skip_comment ()
{
	Ci += 2;

	for (;;) {
		while (Cpp [Ci] != '*') {
			//if (Cpp [Ci] == '\n') line++;
			if (++Ci >= Clen) throw EOFC ("// comment");
		}
		++Ci;
		if (Cpp [Ci] != '/') continue;
		break;
	}

	++Ci;
}

static inline void skip_ws ()
{
	for (;;) {
		for (;;) {
			if (Cpp [Ci] == ' ' || Cpp [Ci] == '\t') {
				if (++Ci >= Clen) return;
				continue;
			}
			if (Cpp [Ci] == '\n') {
				//++line;
				if (++Ci >= Clen) return;
				continue;
			}
			break;
		}
		if (Cpp [Ci] == '/') {
			if (Cpp [Ci + 1] == '*')
				skip_comment ();
			else if (Cpp [Ci + 1] == '/')
				skip_line ();
			else return;
			continue;
		}
		if (Cpp [Ci] == '\\' && Cpp [Ci + 1] == '\n') {
			Ci += 2;
			//++line;
			continue;
		}
		break;
	}
}

static inline void get_ident ()
{
	CTok.type = IDENT_DUMMY;
	CTok.p = &Cpp [Ci];

	while (isalnum (Cpp [Ci]) || Cpp [Ci] == '_')
		if (++Ci >= Clen) break;

	CTok.len = &Cpp [Ci] - CTok.p;
}

static char EOFstring [] = " string literal";

static void get_string ()
{
	CTok.type = STRING;
	CTok.p = &Cpp [++Ci];

	for (;;) {
		while (Cpp [Ci] != '\\' && Cpp [Ci] != '"')
			if (++Ci >= Clen) throw EOFC (EOFstring);
		if (Cpp [Ci] == '\\') {
			Ci += 2;
			if (Ci >= Clen) throw EOFC (EOFstring);
			continue;
		}
		break;
	}

	CTok.len = &Cpp [Ci] - CTok.p;
	++Ci;
}

static inline void get_exponent ()
{
	++Ci;
	if (Cpp [Ci] == '-' || Cpp [Ci] == '+') Ci++;
	while (isdigit (Cpp [Ci]))
		if (++Ci >= Clen) break;
}

static inline void get_float_frac ()
{
	// The token pointer and length are already set to
	// the decimal part, or this[char] && 0 if no decimal part

	++Ci;

	while (isdigit (Cpp [Ci]))
		if (++Ci >= Clen) break;
}

static char EOFchar [] = "character constant";

static void get_char_const ()
{
	++Ci;
	CTok.type = CCONSTANT;
	CTok.p = &Cpp [Ci];

	for (;;) {
		while (Cpp [Ci] != '\\' && Cpp [Ci] != '\'')
			if (++Ci >= Clen) throw EOFC (EOFchar);
		if (Cpp [Ci] == '\\') {
			Ci += 2;
			if (Ci >= Clen) throw EOFC (EOFchar);
			continue;
		}
		break;
	}

	CTok.len = &Cpp [Ci] - CTok.p;
	if (CTok.len > 10) throw (EOFchar);
	++Ci;
}

static inline void get_nconst ()
{
	CTok.type = CONSTANT;
	CTok.p = &Cpp [Ci];

	while (isalnum (Cpp [Ci]))
		if (++Ci >= Clen) break;

	if (Cpp [Ci] == '.') {
		get_float_frac ();
		CTok.type = FCONSTANT;
	}
	if (Cpp [Ci] == 'e' || Cpp [Ci] == 'E') {
		get_exponent ();
		CTok.type = FCONSTANT;
	}

	if (isalpha (Cpp [Ci]))
	while (Cpp [Ci] == 'U' || Cpp [Ci] == 'u' || Cpp [Ci] == 'F'
	   ||  Cpp [Ci] == 'f' || Cpp [Ci] == 'L' || Cpp [Ci] == 'l')
		if (++Ci >= Clen) break;

	CTok.len = &Cpp [Ci] - CTok.p;
}

/***************************************************************************
		Little utils
***************************************************************************/

static void grle_morph ()
{
	char gl = Cpp [Ci];

	CTok.p = &Cpp [Ci];
	++Ci;

	if (Cpp [Ci] == gl) {
		++Ci;
		if (Cpp [Ci] == '=') {
			++Ci;
			CTok.type = (gl == '>') ? ASSIGNRS : ASSIGNLS;
		} else CTok.type = (gl == '>') ? RSH : LSH;
	} else if (Cpp [Ci] == '=' || Cpp [Ci] == '?') {
		++Ci;
		CTok.type = (gl == '>') ? GEQCMP : LEQCMP;
	} else CTok.type = gl;
}

static void anor_morph ()
{
	char ao = Cpp [Ci];

	++Ci;

	if (Cpp [Ci] == ao) {
		++Ci;
		CTok.type = (ao == '&') ? ANDAND : OROR;
	} else if (Cpp [Ci] == '=') {
		++Ci;
		CTok.type = (ao == '&') ? ASSIGNBA : ASSIGNBO;
	} else CTok.type = ao;
}

/***************************************************************************
***************************************************************************/

/******************************************************************************
		Interface entry functions
******************************************************************************/

static void do_yylex ()
{
Again:
	if (Ci >= Clen) {
		CTok.type = THE_END;
		return;
	}

	skip_ws ();
	if (Ci >= Clen) {
		CTok.type = THE_END;
		return;
	}

	CTok.p = &Cpp [Ci];
	CTok.len = 0;

	if (isdigit (Cpp [Ci]))
		get_nconst ();
	else if (isalpha (Cpp [Ci]) || Cpp [Ci] == '_')
		get_ident ();
	else switch (Cpp [Ci]) {
		case '(':
		case ')':
		case ';':
		case ',':
			CTok.type = Cpp [Ci];
			CTok.p = &Cpp [Ci];
			++Ci;
			break;
		case '*':
			CTok.type = Cpp [Ci];
			++Ci;
			if (Cpp [Ci] == '=') {
				CTok.type = ASSIGNM;
				++Ci;
				break;
			}
			break;
		case '"':
			get_string ();
			return;
		case '\'':
			get_char_const ();
			return;
		case '/':
			++Ci;
			if (Cpp [Ci] == '=') {
				CTok.type = ASSIGND;
				++Ci;
				break;
			}
			CTok.type = '/';
			break;
		case '.':
			if (isdigit (Cpp [Ci + 1])) {
				get_nconst ();
				break;
			}
			++Ci;
			if (Cpp [Ci] == '.' && Cpp [Ci + 1] == '.') {
				CTok.type = ELLIPSIS;
				Ci += 2;
				break;
			}
			if (Cpp [Ci] == '*') {
				CTok.type = DOTSTAR;
				++Ci;
				break;
			}
			CTok.type = '.';
			break;
		case '-':
			++Ci;
			if (Cpp [Ci] == '>') {
				++Ci;
				if (Cpp [Ci] == '*') {
					CTok.type = POINTSAT_STAR;
					++Ci;
				} else CTok.type = POINTSAT;
				break;
			}
			if (Cpp [Ci] == '-') {
				CTok.type = MINUSMINUS;
				++Ci;
				break;
			}
			if (Cpp [Ci] == '=') {
				CTok.type = ASSIGNS;
				++Ci;
				break;
			}
			CTok.type = '-';
			break;
		case '+':
			++Ci;
			if (Cpp [Ci] == '+') {
				CTok.type = PLUSPLUS;
				++Ci;
				break;
			}
			if (Cpp [Ci] == '=') {
				CTok.type = ASSIGNA;
				++Ci;
				break;
			}
			CTok.type = '+';
			break;
		case '!':
		case '%':
		case '^':
			CTok.type = Cpp [Ci];
			++Ci;
			if (Cpp [Ci] == '=') {
				CTok.type = (CTok.type == '!') ? NEQCMP :
					(CTok.type == '%') ? ASSIGNR : ASSIGNBX;
				++Ci;
				break;
			}
			break;
		case '&':
		case '|':
			anor_morph ();
			break;
		case ':':
			++Ci;
			if (Cpp [Ci] == ':') {
				CTok.type = SCOPE;
				++Ci;
				break;
			}
			CTok.type = ':';
			break;
		case '=':
			++Ci;
			if (Cpp [Ci] == '=') {
				CTok.type = EQCMP;
				++Ci;
				break;
			}
			CTok.type = '=';
			break;
		case '>':
		case '<':
			grle_morph ();
			break;
		case '#':
			CTok.type = '#';
			if (Ci == 0 || Cpp [Ci - 1] == '\n'
			|| Cpp [Ci - 1] == '\r')
				CTok.type = CPP_DIRECTIVE;
			++Ci;
			if (Ci < Clen && Cpp [Ci] == '#') {
				CTok.type = CPP_CONCAT;
				++Ci;
			}
			break;
		case '[':
		case ']':
		case '~':
			CTok.type = Cpp [Ci];
			CTok.p = &Cpp [Ci];
			++Ci;
			break;
		case '\r':
		case '\f':
			++Ci;
			goto Again;
		default:
			// $
			CTok.type = Cpp [Ci];
			CTok.p = &Cpp [Ci];
			++Ci;
	}

	CTok.len = &Cpp [Ci] - CTok.p;
}

static void skip_pp_line ()
{
	// Skip a line but respect that newlines inside:
	// strings, comments, character consts
	// and escaped ones don't count.
	//
	// For preprocessed source, the only directive is:
	// # <line> "file"
	// send the file to enter_file_indicator ()
	//
	char tmp [512];
	tmp [0] = 0;

	for (;;) {
		if (Ci >= Clen) {
			CTok.type = THE_END;
			return;
		}

		switch (Cpp [Ci]) {
		case '/':
			++Ci;
			if (Cpp [Ci] == '*') skip_comment ();
			else if (Cpp [Ci] == '/') skip_line ();
			break;
		case '\\':
			++Ci;
			if (Cpp [Ci] == '\n')
				++Ci;
			break;
		case '\n':
			goto outer;
		case '"':
			get_string ();
			strncpy (tmp, CTok.p, CTok.len);
			tmp [CTok.len] = 0;
			break;
		case '\'':
			get_char_const ();
			break;
		default:
			++Ci;
		}
	}
outer:
	enter_file_indicator (tmp);
}

/******************************************************************************
		Main
******************************************************************************/

void yynorm (char *c, int l)
{
	Cpp = c;
	Clen = l;
	line = 0;
	Ci = 0;

	try {
		for (;;) {
			do_yylex ();

			if (CTok.type == THE_END) break;
			if (CTok.type == CPP_DIRECTIVE)
				skip_pp_line (); else

			enter_token ();
		}
	} catch (EOFC) {
	}
}
