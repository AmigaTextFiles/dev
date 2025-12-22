#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <string.h>
#include <ctype.h>

#include "global.h"
#include "dbstree.h"
#include "stack.h"

bool include_values = true;

static dbsTree			symtree, strtree;
static earray<cfile_i>		Filez;
static stack<int>		stsym;
static stack<signed char>	TsInt8;
static stack<signed short int>	TsInt16;
static stack<signed long int>	TsInt32;
static stack<unsigned long int>	TuInt32;
static stack<double>		TFloat;
static int			nreserved, indx;

class symboltmp : public dbsNodeStr
{
   public:
	symboltmp (int I) : dbsNodeStr (&symtree), ID (I) { }
	unsigned int ID;
};

class stringtmp : public dbsNodeStr
{
   public:
	stringtmp (int I) : dbsNodeStr (&strtree), ID (I) { }
	unsigned int ID;
};

static void symtoarray (dbsNode *d)
{
	symboltmp *s = (symboltmp*) d;
	if (s->ID >= SYMBASE)
		C_Syms [s->ID - SYMBASE] = s->Name;
	else delete [] s->Name;
	delete s;
}

static void strtoarray (dbsNode *d)
{
	stringtmp *s = (stringtmp*) d;
	C_Strings [s->ID - BASE] = s->Name;
	delete s;
}

static char *string;
static int enter_string ()
{
static	unsigned int SID = BASE;
	//DBS_STRQUERY = true_string (string);
	DBS_STRQUERY = string;
	stringtmp *S = (stringtmp*) strtree.dbsFind ();
	if (S) delete [] DBS_STRQUERY;
	else S = new stringtmp (SID++);
	return S->ID;
}

static int c_symbol (char *s, int len)
{
static	unsigned int SID = SYMBASE;
	DBS_STRQUERY = (char*) alloca (len + 1);
	strncpy (DBS_STRQUERY, s, len);
	DBS_STRQUERY [len] = 0;
	symboltmp *S = (symboltmp*) symtree.dbsFind ();
	if (S) return S->ID;
	S = new symboltmp (SID++);
	return S->ID;
}

static int enter_float ()
{
	int i;
	TFloat [i = TFloat.alloc ()] = strtod (CTok.p, NULL);
	return FLOATBASE + i;
}

static int character_constant ();
static int enter_integer ()
{
	long int is, iu;
	if (CTok.type == CCONSTANT)
		is = character_constant ();
	else is = strtol (CTok.p, NULL, 0);

	if (is == 0) return INT8BASE;
	if (is < 128 && is >= -128) {
		TsInt8 [iu = TsInt8.alloc ()] = is;
		return INT8BASE + iu;
	}
	if (is < 32768 && is >= -32768) {
		TsInt16 [iu = TsInt16.alloc ()] = is;
		return INT16BASE + iu;
	}
	if (is != LONG_MAX) {
		TsInt32 [iu = TsInt32.alloc ()] = is;
		return INT32BASE + iu;
	}
	TuInt32 [iu = TuInt32.alloc ()] = strtoul (CTok.p, NULL, 0);
	return UINT32BASE + iu;
}

static void string_constant (char *s, int l)
{
	char *ns;
	int si;

	if (!include_values) {
		string = "";
		return;
	}

	if (string) {
		ns = new char [(si = strlen (string) + l) + 1];
		strncat (strcpy (ns, string), s, l);
		ns [si] = 0;
		delete [] string;
		string = ns;
	} else {
		string = new char [l + 1];
		strncpy (string, s, l);
		string [l] = 0;
	}
}

static inline void _enter_token (int i)
{
	if (i == RESERVED_auto || i == RESERVED_volatile || i == RESERVED_inline) return;

	if (i == RESERVED_double) i = RESERVED_float;

	stsym [indx = stsym.alloc ()] = i;
}

void enter_token ()
{
	int i;

	if (CTok.type == IDENT_DUMMY)
		i = c_symbol (CTok.p, CTok.len);
	else if (CTok.type == STRING) {
		string_constant (CTok.p, CTok.len);
		return;
	} else if (CTok.type == CONSTANT || CTok.type == CCONSTANT)
		i = (include_values) ? enter_integer () : INT8BASE;
	else if (CTok.type == FCONSTANT)
		i = (include_values) ? enter_float () : FLOATBASE;
	else i = CTok.type;

	if (string) {
		_enter_token ((include_values) ? enter_string () : BASE);
		string = NULL;
	}

	_enter_token (i);
}

void enter_file_indicator (char *f)
{
	int last;

	if (!f [0]) return;

	if (Filez.nr) {
		last = Filez.nr - 1;
		if (!strcmp (f, Filez.x [last].file)) return;
		if (Filez.x [last].indx == indx) {
			delete [] Filez.x [last].file;
			Filez.x [last].file = StrDup (f);
			return;
		}
	}

	Filez.x [last = Filez.alloc ()].indx = indx;
	Filez.x [last].file = StrDup (f);
}

#define LOOKBUILTIN(x) \
	DBS_STRQUERY = #x;\
	S = (symboltmp*) symtree.dbsFind ();\
	ccbuiltins.bt ## x = (S) ? (int) S->ID : -1;

static void used_builtins ()
{
	symboltmp *S;
	LOOKBUILTIN (__FUNCTION__);
	LOOKBUILTIN (__PRETTY_FUNCTION__);
	LOOKBUILTIN (__builtin_return_address);
}

void make_norm ()
{
	if (string) _enter_token (enter_string ());

	used_builtins ();
	C_Ntok = stsym.nr ();
	CODE = new int [C_Ntok + 3];
	stsym.copy (&CODE);
	CODE  [C_Ntok] = FORCEERROR;
	CODE  [C_Ntok + 1] = ';';
	CODE  [C_Ntok + 2] = FORCEERROR;
	stsym.destroy ();
	C_Syms = new char* [C_Nsyms = symtree.nnodes - nreserved];
	symtree.deltree (symtoarray);
	Filez.freeze ();
	C_Files = Filez.x;
	C_Nfiles = Filez.nr;
	C_Strings = new char* [C_Nstrings = strtree.nnodes];
	strtree.deltree (strtoarray);
	TFloat.copy (&C_Floats);
	TFloat.destroy ();
	TsInt8.copy (&C_Chars);
	TsInt8.destroy ();
	TsInt16.copy (&C_Shortints);
	TsInt16.destroy ();
	TsInt32.copy (&C_Ints);
	TsInt32.destroy ();
	TuInt32.copy (&C_Unsigned);
	TuInt32.destroy ();
}

#define RESERVED(x) \
	DBS_STRQUERY = #x;\
	symtree.dbsFind ();\
	new symboltmp (RESERVED_ ## x); \
	++nreserved;

static void reserved_c ()
{
	RESERVED(inline);
	RESERVED(do);
	RESERVED(struct);
	RESERVED(case);
	RESERVED(for);
	RESERVED(short);
	RESERVED(union);
	RESERVED(sizeof);
	RESERVED(register);
	RESERVED(break);
	RESERVED(auto);
	RESERVED(continue);
	RESERVED(const);
	RESERVED(default);
	RESERVED(enum);
	RESERVED(else);
	RESERVED(extern);
	RESERVED(goto);
	RESERVED(if);
	RESERVED(long);
	RESERVED(return);
	RESERVED(signed);
	RESERVED(static);
	RESERVED(switch);
	RESERVED(typedef);
	RESERVED(unsigned);
	RESERVED(volatile);
	RESERVED(while);
	RESERVED(__asm__);
#ifdef GNU_VIOLATIONS
	RESERVED(__typeof__);
	RESERVED(__label__);
#endif

	RESERVED(void);
	RESERVED(int);
	RESERVED(char);
	RESERVED(float);
	RESERVED(double);
}

void prepare ()
{
	reserved_c ();
	symtree.dbsBalance ();
	indx = 0;
	string = "";
	enter_string ();
	string = NULL;
	TFloat [TFloat.alloc ()] = 0.0;
	// often have division by zero if all values zeroed
	TsInt8 [TsInt8.alloc ()] = include_values ? 0 : 1;
}

//******************************************************
//	small utility
//	evaluate number which is integer
//******************************************************
int getint (int token)
{
	if (token < INT16BASE) return C_Chars [token - INT8BASE];
	if (token < INT32BASE) return C_Shortints [token - INT16BASE];
	if (token < UINT32BASE) return C_Ints [token - INT32BASE];
	return syntax_error ("Expected integer and got something else", "else");
}

//******************************************************
//	small utility
//	evaluate character constants
//		a terrible deja-vu...
//******************************************************

const static char escc [] = "ntvbrfae";
const static char esct [] = "\n\t\v\b\r\f\a\e";

static char escape (char **s)
{
	char i;
	(*s)++;
	if (**s >= '0' && **s < '8') {
		i = **s - '0';
		(*s)++;
		if (**s >= '0' && **s < '8') {
			i <<= 3;
			i = **s - '0';
			(*s)++;
			if (**s >= '0' && **s < '8') {
				i <<= 3;
				i += **s - '0';
			}
		}
		return i;
	}
	if (**s == 'x') {
		(*s)++;
		if (!isxdigit (**s)) warning ("bad hex character escape");
		i = (**s - '0') << 4;
		(*s)++;
		if (!isxdigit (**s)) warning ("bad hex character escape");
		return i + (**s - '0');
	}
	for (i = 0; i < (int) sizeof (escc) - 1; i++)
		if (**s == escc [i]) return esct [i];
	return **s;
}

static int character_constant ()
{
	char *s = CTok.p;
	for (;;) {
		if (*s == '\'') {
			warning ("Empty character constant");
			return 0;
		}
		return (*s == '\\') ? escape (&s) : s [1];
	}
}

#if 0
static char *true_string (char *s)
{
	char *e = s;
	char *d;
	char *tmp = d = (char*) alloca (strlen (s) + 5); // heuristic

	for (;*s; s++) *d++ = *s == '\\' ? escape (&s) : *s;
	*d = 0;
	delete [] e;
	return StrDup (tmp);
}
#endif
