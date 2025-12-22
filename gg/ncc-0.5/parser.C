/*******************************************************************************

	C parser

*******************************************************************************/
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <assert.h>

#include "global.h"
#include "stack.h"

exprtree CExpr;

//***************************************************************************
//		Forward
//***************************************************************************
static NormPtr constant_int_expression (NormPtr, int&);
static NormPtr parse_structure (NormPtr);
//***************************************************************************
//		Declarations I
//***************************************************************************
static NormPtr skip_parens (NormPtr);
static NormPtr skip_braces (NormPtr);
static int initializer_nsize (NormPtr, int);
static NormPtr get_enum_consts (NormPtr);

class declarator
{
	NormPtr p;
	int dp;
	void dcl ();
	void dirdcl ();
	void bitfield ();
	void arglist_to_specs ();
	NormPtr parse (NormPtr);

#ifdef GNU_VIOLATIONS
	NormPtr bt_typeof (NormPtr);
#endif
	NormPtr builtin (NormPtr);
	NormPtr bt_enum (NormPtr);
	NormPtr bt_typedef (NormPtr);
	NormPtr bt_struct (NormPtr);

	void complete_size ();
	void argument_conversions ();
	void semantics ();
	bool do_argument_conversions;
	ObjPtr basetype;
   public:
	bool have_extern, have_static, have_typedef, have_const,
	     have_init, have_code;

	declarator (bool b = false) { do_argument_conversions = b; }
	NormPtr parse_base (NormPtr);
	NormPtr parse_dcl (NormPtr);

	typeID gentype;
	NormPtr args;
	int symbol;
	int spec [MSPEC];
};
//***********************************************************************
//		definitions : declarator
//***********************************************************************

NormPtr declarator::parse (NormPtr i)
{
	p = i; dp = 0; args = symbol = -1; have_init = have_code = false;

	if (CODE [p] == ':' || (ISSYMBOL (CODE [p]) && CODE [p + 1] == ':'))
		bitfield ();
	else dcl ();

	spec [dp] = -1;
	have_init = CODE [p] == '=';
	have_code = CODE [p] == '{';

	return p;
}

void declarator::bitfield ()
{
	if (CODE [p] != ':') symbol = CODE [p++];
	spec [0] = ':';
	p = constant_int_expression (++p, spec [1]);
	dp = 2;
}

void declarator::dcl ()
{
	int ns = 0;

	for (;; p++)
		if (CODE [p] == '*') ++ns;
		else if (CODE [p] != RESERVED_const
			&& CODE [p] != RESERVED_volatile) break;
	dirdcl ();
	while (ns--) spec [dp++] = '*';
}

void declarator::dirdcl ()
{
	if (CODE [p] == '(') {
		++p;
		dcl ();
		if (CODE [p++] != ')') syntax_error (p, "Missing parenthesis");
	} else if (ISSYMBOL (CODE [p]))
		symbol = CODE [p++];

	for (;;) {
		switch (CODE [p]) {
		case '(':
			if (args == -1) args = p;
			spec [dp++] = '(';
			arglist_to_specs ();
			continue;
		case '[':
			if (CODE [++p] == ']') {
				spec [dp++] = '[';
				spec [dp++] = 0;
				p++; continue;
			}
			spec [dp++] = '[';
			p = constant_int_expression (p, spec [dp++]);
			if (CODE [p++] != ']')
				syntax_error (p, "No :]");
			continue;
		}
		break;
	}
}

void declarator::complete_size ()
{
	int t = CODE [p + 1];
	if (ISSTRING (t)) spec [1] = strlen (C_Strings [t - BASE]) + 1;
	else if (t == '{') {
		int i, a = esizeof_objptr (basetype);
		for (i = 2; spec [i] == '['; i += 2)
			a *= spec [i + 1];
		spec [1] = initializer_nsize (p + 1, a);
	} else syntax_error (p, "incomplete array initializer single");
}

void declarator::semantics ()
{
	int i = 0, v;

	if (spec [0] == '(') {
		if (have_init) syntax_error (p, "Function != Variable");
	} else if (have_code) syntax_error (p, "Variable != Function");

	if (spec [0] == ':') {
		if (spec [1] < 0 || spec [1] > BITFIELD_Q)
			syntax_error (p, "absurd");
		return;
	}

	while (i < dp)
		if (spec [i] == '[') {
			i += 2;
			if (spec [i] == '(')
				syntax_error (p, "array of functions");
		} else if (spec [i] == '(') {
			i += 2;
			v = spec [i];
			if (v == '(' || v == '[')
				syntax_error (p, "Function returning invalid");
		} else i++;
}

static int initializer_nsize (NormPtr p, int na)
{
	int ec = 1;
	NormPtr e = skip_braces (p++);

	while (p < e)
		if (CODE [p] == ',') ec++, p++;
		else if (CODE [p] == '{') {
			ec += na;
			p = skip_braces (p);
		} else p++;

	return na ? ec / na : ec;
}

static NormPtr skip_parens (NormPtr p)
{
	int ns = 0;

	for (; p < C_Ntok; p++)
		if (CODE [p] == '(') ++ns;
		else if (CODE [p] == ')')
			if (--ns == 0) return p + 1;
	return syntax_error (p, "Unclosed parenthesis:)");
}

static NormPtr skip_braces (NormPtr p)
{
	int ns = 0;

	for (; p < C_Ntok; p++)
		if (CODE [p] == '{') ++ns;
		else if (CODE [p] == '}')
			if (--ns == 0) return p + 1;
	return syntax_error (p, "Unclosed braces:}");
}

//***********************************************************************
//		definitions : declarator
//***********************************************************************

void declarator::argument_conversions ()
{
	int tspec [MSPEC], *tp = tspec, *vp = spec;

	if (basetype >= TYPEDEF_BASE && *vp == -1) {
		type t;
		opentype (basetype - TYPEDEF_BASE, t);
		if (t.spec [0] == '(') *tp++ = '*';
	}

	if (*vp == '(') *tp++ = '*';
	for (;;vp++) {
		switch (*vp) {
		case '*': *tp++ = '*'; continue;
		case '[': *tp++ = '*'; vp++; continue;
		case '(': *tp++ = '('; *tp++ = *++vp; continue;
		}
		*tp = -1;
		break;
	}
	intcpy (spec, tspec);
}

NormPtr declarator::parse_dcl (NormPtr p)
{
	type t;

	p = parse (p);
	if (have_init && spec [0] == '[' && spec [1] == 0) complete_size ();
	semantics ();

	if (do_argument_conversions) argument_conversions ();
	t.base = basetype;
	t.spec = spec;
	gentype = gettype (t);
	return p;
}

NormPtr declarator::parse_base (NormPtr p)
{
	have_extern = have_static = have_typedef = have_const = false;

	for (;ISDCLFLAG (CODE [p]); p++) switch (CODE [p]) {
		case RESERVED_extern:  have_extern  = true; break;
		case RESERVED_static:  have_static  = true; break;
		case RESERVED_typedef: have_typedef = true; break;
		case RESERVED_const:   have_const   = true; break;
	}

	if ((have_extern && have_static) || (have_extern && have_typedef)
	|| (have_static && have_typedef)) syntax_error (p, "Decide");

	if (ISBASETYPE (CODE [p]) || ISHBASETYPE (CODE [p]))
		return builtin (p);
	if (CODE [p] == RESERVED_struct || CODE [p] == RESERVED_union)
		return bt_struct (p);
	if (ISSYMBOL (CODE [p]))
		return bt_typedef (p);
	if (CODE [p] == RESERVED_enum)
		return bt_enum (p + 1);
#ifdef GNU_VIOLATIONS
	if (CODE [p] == RESERVED___typeof__)
		return bt_typeof (p + 1);
	if (CODE [p] == RESERVED___label__) {
		while (CODE [p] != ';') p++;
		return p;
	}
#endif
	basetype = S_INT;
	return p;
}

NormPtr declarator::builtin (NormPtr p)
{
	int bt, sh, lo, si, us;

	bt = sh = lo = si = us = 0;
	for (;ISBASETYPE (CODE [p]) || ISHBASETYPE (CODE [p])
	 || CODE [p] == RESERVED_const; p++)
		switch (CODE [p]) {
		case RESERVED_long:     lo++; break;
		case RESERVED_short:    sh++; break;
		case RESERVED_signed:   si++; break;
		case RESERVED_unsigned: us++; break;
		case RESERVED_const:	continue;
		default: if (bt) syntax_error (p, "Please specify");
			bt = CODE [p];
	}

	if (bt == 0) bt = RESERVED_int;
	if ((lo && sh) || (si && us)) syntax_error (p, "AMBIGUOUS specifiers");
	switch (bt) {
	case RESERVED_float: basetype = FLOAT; break;
	case RESERVED_double: basetype = DOUBLE; break;
	case RESERVED_void: basetype = VOID; break;
	case RESERVED_char: basetype = (us) ? U_CHAR : S_CHAR; break;
	case RESERVED_int:
		if (sh) basetype = (us) ? U_SINT : S_SINT;
		else if (lo == 1) basetype = (us) ? U_LINT : S_LINT;
		else if (lo > 1) basetype = (us) ? U_LONG : S_LONG;
		else basetype = (us) ? U_INT : S_INT;
	}

	return p;
}

NormPtr declarator::bt_enum (NormPtr p)
{
	basetype = S_INT;
	if (!ISSYMBOL (CODE [p]) && CODE [p] != '{')
		syntax_error (p, "DEAD rats after enum");

	if (CODE [p] != '{' && CODE [p + 1] != '{') {
		if (!valid_enumtag (CODE [p]) &&
		    !introduce_enumtag (CODE [p]))
			syntax_error (p, "enum tag REDEFINED");
		return p + 1;
	}

	if (CODE [p] != '{')
		if (!introduce_enumtag (CODE [p++]))
			syntax_error (p, "enum tag REDEFINED");

	return get_enum_consts (p);
}

NormPtr declarator::bt_typedef (NormPtr p)
{
	if ((basetype = lookup_typedef (CODE [p])) == -1) {
		basetype = S_INT;
		return p;
	}
	return p + 1;
}

NormPtr declarator::bt_struct (NormPtr p)
{
	bool isst = CODE [p++] == RESERVED_struct;

	if (!ISSYMBOL (CODE [p]) && CODE [p] != '{')
		syntax_error (p, "DEAD RATS after struct");

	if (CODE [p] != '{' && CODE [p + 1] != '{') {
		basetype = (CODE [p + 1] == ';')
		 	? fwd_struct_tag (CODE [p], isst)
			: use_struct_tag (CODE [p], isst);
		return p + 1;
	}

	int s = ANONYMOUS;
	if (CODE [p] != '{') s = CODE [p++];
	if ((basetype = introduce_struct_dcl (s, isst)) == -1)
		syntax_error (p, "Redefined structure tag");

	return parse_structure (p + 1);
}

static NormPtr get_enum_consts (NormPtr p)
{
	int counter = 0, s;
	NormPtr e = skip_braces (p++) - 1;

	for (;;) {
		s = CODE [p++];
		if (s == '}') break;
		if (!ISSYMBOL (s))
			syntax_error (p, "Random NOISE INSIDE ENUM");
		if (CODE [p] == '=')
			p = constant_int_expression (++p, counter);
		if (!introduce_enumconst (s, counter++))
			syntax_error (p, "Enumeration constant exists");
		if (p >= e) break;
		if (CODE [p++] != ',')
			syntax_error (p, "RANDOM noise inside enum");
	}

	return e + 1;
}

//***************************************************************************
//		Forward
//***************************************************************************
static NormPtr initializer (Symbol, NormPtr);
static NormPtr parse_function (Symbol, NormPtr, NormPtr);
static bool is_dcl_start (int);
//***************************************************************************
//		Declarations II
//
//	Four places of declarators:
//	1) Declarator in code or global
//	2) Declarator inside structure block
//	3) Function argument list
//	4) (type cast)
//***************************************************************************
class cast_type
{
   public:
	typeID gentype;
	NormPtr parse (NormPtr);
};

class arglist
{
	NormPtr argument (NormPtr);
	NormPtr parse_newstyle (NormPtr);
	bool old_declaration (NormPtr);
	NormPtr parse_oldstyle (NormPtr, bool = false);
   public:
	bool nolist;
	typeID types [100];
	int names [100], ii;
	void parse_declare (NormPtr);
	NormPtr parse (NormPtr);
};

class declaration
{
   protected:
virtual	void semantics (NormPtr);
   public:
	declarator D;
	declaration (bool b = false) : D (b) { }
	NormPtr parse (NormPtr);
};

class declaration_instruct : public declaration
{
	void semantics (NormPtr);
};
//***********************************************************************
//		definitions:	cast, arglist
//***********************************************************************

NormPtr cast_type::parse (NormPtr p)
{
	declarator B;
	p = B.parse_dcl (B.parse_base (p));

	if (B.have_typedef || B.have_extern || B.have_static
	|| B.have_code || B.have_init || B.symbol != -1
	|| B.spec [0] == ':') syntax_error (p, "Improper cast");

	gentype = B.gentype;

	return p;
}

NormPtr arglist::argument (NormPtr p)
{
	declarator B (true);
	p = B.parse_dcl (B.parse_base (p));

	if (B.have_typedef || B.have_extern || B.have_static
	|| B.have_code || B.have_init || B.spec [0] == ':')
		syntax_error (p, "Crap argument");

	names [ii] = B.symbol;
	types [ii++] = B.gentype;

	return p;
}

bool arglist::old_declaration (NormPtr p)
{
	return ISSYMBOL (CODE [p])
	       && (CODE [p + 1] == ',' || CODE [p + 1] == ')')
	       && lookup_typedef (CODE [p]) == -1;
}

NormPtr arglist::parse_newstyle (NormPtr p)
{
	ii = 0;

	if (CODE [p] == ')') {
		nolist = true;
		return p + 1;
	}

	if (CODE [p] == RESERVED_void && CODE [p + 1] == ')')
		return p + 2;

	while (CODE [p] != ')')
		if (CODE [p] == ELLIPSIS) {
			types [ii++] = SPECIAL_ELLIPSIS;
			if (CODE [p + 1] != ')')
				syntax_error (p, "'...' must be last");
			return p + 2;
		} else if (CODE [p = argument (p)] == ',') p++;

	return p + 1;
}

NormPtr arglist::parse_oldstyle (NormPtr p, bool dcl)
{
	// few syntax/semantics tests. We suppose old program, which
	// is syntactically correct for the last 10 years 
	int i = 0, j;
	ii = 1;
	types [0] = ARGLIST_OPEN;
	types [1] = -1;

	if (CODE [p] != ')')
		do names [i++] = CODE [p++]; while (CODE [p++] == ',');

	if (dcl) {
		declaration D (true);
		while (CODE [p] != '{') {
			p = D.parse (p);
			for (j = 0; j < i; j++)
				if (names [j] == D.D.symbol) {
					names [j] = -1;
					break;
				}
		}
		for (j = 0; j < i; j++) if (names [j] != -1)
			introduce_obj (names [j], SIntType, DEFAULT);
	} else {
		if (!is_dcl_start (CODE [p])) return p;
		while (CODE [p] != '{') p++;
	}
	return p;
}

void arglist::parse_declare (NormPtr p)
{
	if (old_declaration (p)) {
		parse_oldstyle (p, true);
		return; 
	}

	int i;
	parse_newstyle (p);

	for (i = 0; i < ii; i++)
		if (types [i] != SPECIAL_ELLIPSIS) {
			if (names [i] == -1)
				syntax_error (p, "Abstract argument");
			introduce_obj (names [i], types [i], DEFAULT);
		}
}

NormPtr arglist::parse (NormPtr p)
{
	nolist = false;
	return old_declaration (p) ? parse_oldstyle (p) : parse_newstyle (p);
}

void declarator::arglist_to_specs ()
{
	arglist A;
	p = A.parse (p + 1);
	if (A.nolist) A.types [A.ii++] = ARGLIST_OPEN;
	A.types [A.ii] = -1;
	spec [dp++] = make_arglist (A.types);
}

//***********************************************************************
//		definitions:	declaration, instructure
//***********************************************************************

NormPtr declaration::parse (NormPtr p)
{
	VARSPC vs;
	bool ok;
	typeID t;

	p = D.parse_base (p);
	while (CODE [p] != ';') {
		p = D.parse_dcl (p);

		semantics (p);
		t = D.gentype;

		vs = (D.have_extern)?EXTERN:(D.have_static)?STATIC:DEFAULT;

		if (D.have_typedef) ok = introduce_tdef (D.symbol, t);
		else ok = introduce_obj (D.symbol, t, vs);
		if (!ok) syntax_error (p, "redefined: ", expand (D.symbol));

		if (D.have_init) p = initializer (D.symbol, p + 1);
		if (D.have_code) return parse_function (D.symbol, D.args, p);

		if (CODE [p] == ';') break;
		if (CODE [p] != ',')
			syntax_error(p, "unaccaptable declaration, separator;",
					 expand (CODE [p]));
		p++;
	}

	return p + 1;
}

void declaration::semantics (NormPtr p)
{
	if (D.spec [0] == ':'
	|| (D.have_typedef && (D.have_init || D.have_code)))
		syntax_error (p, "Not the \"right thing\"");
	if (D.symbol == -1) syntax_error (p, "ABSENT symbol");
	if (D.have_code && !INGLOBAL)
		syntax_error (p, "Do you like nested functions?");
}

void declaration_instruct::semantics (NormPtr p)
{
	if (D.have_static || D.have_extern || D.have_typedef
	|| D.spec [0] == '(' || D.have_init || D.have_code
	|| (D.symbol == -1 && D.spec [0] != ':'))
		syntax_error (p, "Not good dcl in struct");
}

static bool is_typename (int token)
{
	return token == RESERVED_struct || token == RESERVED_union
		|| ISBASETYPE(token) || ISHBASETYPE (token) 
		|| token == RESERVED_enum
		|| (ISSYMBOL (token) && lookup_typedef (token) != -1);
}

static bool is_dcl_start (int token)
{
	return ISDCLFLAG (token) || is_typename (token)
#ifdef GNU_VIOLATIONS
		|| token == RESERVED___label__
		|| token == RESERVED___typeof__
#endif
				;
}

//**************************************************************************
//		Part II
//
//	By now we are ok with the declarations (introducing new names
//	to the program). Whenever we see a declaration, invoke a declarator.
//	We can at any time lookup what's an identifier, with lookup().
//
//	Missing:
//		parsing expressions in initializers
//
//	But this is ok, because this is exactly what we are going to
//	do now.
//**************************************************************************
//			C expressions
//**************************************************************************
NormPtr ExpressionPtr;

static int bopid;

static int priority (int op)
{
	if (op > 256) switch (op) {
		case LSH:	bopid = SHL;	return 11;
		case RSH:	bopid = SHR;	return 11;
		case GEQCMP:	bopid = CGRE;	return 10;
		case LEQCMP:	bopid = CLEE;	return 10;
		case EQCMP:	bopid = BEQ;	return 9;
		case NEQCMP:	bopid = BNEQ;	return 9;
		case ANDAND:	bopid = IAND;	return 5;
		case OROR:	bopid = IOR;	return 4;
		default:			return 0;
	}
	switch (op) {
		case '*':	bopid = MUL;	return 13;
		case '/':	bopid = DIV;	return 13;
		case '%':	bopid = REM;	return 13;
		case '+':	bopid = ADD;	return 12;
		case '-':	bopid = SUB;	return 12;
		case '>':	bopid = CGR;	return 10;
		case '<':	bopid = CLE;	return 10;
		case '&':	bopid = BAND;	return 8;
	}
	if (op == '^') {
		bopid = BXOR;
		return 6;
	}
	if (op != '|') return 0;
	bopid = BOR;
	return 7;
}

static int xlate_uop (int op)
{
	switch (op) {
		case '!':	return LNEG;
		case '*':	return PTRIND;
		case '+':	return UPLUS;
		case '-':	return UMINUS;
		case '&':	return ADDROF;
	}
	switch (op) {
		case PLUSPLUS:		return PPPRE;
		case MINUSMINUS:	return MMPRE;
		default:		return OCPL;
	}
}

subexpr *&ee = CExpr.ee;

class expression_parser
{
inline	void reloc ();
	void value_to_expression (exprID, Symbol);
#ifdef GNU_VIOLATIONS
	exprID gnu_st_expr ();
	exprID gnu_ctor_expr (typeID);
#endif
#ifdef LABEL_VALUES
	exprID gnu_label_value ();
#endif
	exprID sizeof_typename ();
	exprID postfix_expression ();
	exprID unary_expression ();
	exprID argument_expression_list ();
	exprID primary_expression ();
	exprID prefix_expression ();
	exprID binary_expression (exprID, int);
	exprID logicalOR_expression ();

	int nee, extra;
    public:
	expression_parser (NormPtr, subexpr*);

	exprID assignment_expression ();
	exprID conditional_expression ();
	exprID expression ();

	NormPtr EP;
	subexpr *ee;
	int iee;
	~expression_parser ();
};

//***********************************************************************
//		definitions
//***********************************************************************

exprID expression_parser::sizeof_typename ()
{
	cast_type T;
	EP = T.parse (EP + 2);
	if (CODE [EP++] != ')') syntax_error (EP, "erroneous sizeof");
	ee [iee].action = VALUE;
	ee [iee].voici.value = sizeof_typeID (T.gentype);
	return iee++;
}

#define ISUNARY(x) \
	((x<'~') ? (x=='!'||x=='*'||x=='&'||x=='-'||x=='+')\
	: (x==PLUSPLUS || x==MINUSMINUS || x=='~'))

exprID expression_parser::unary_expression ()
{
	int prefix [40];
	typeID casts [40];
	int ipr = 0, t;
	exprID e = -1;

	for (t = CODE [EP]; t < BASE; t = CODE [++EP])
		if (ISUNARY (t)) prefix [ipr++] = xlate_uop (t);
		else if (t == '(')
			if (is_dcl_start (CODE [EP + 1])) {
				cast_type C;
				EP = C.parse (EP + 1);
				casts [ipr] = C.gentype;
				prefix [ipr++] = CAST;
#ifdef GNU_VIOLATIONS
				if (CODE [EP + 1] == '{') {
					e = gnu_ctor_expr (C.gentype);
					goto have_unary;
				}
#endif
			} else break;
		else if (t == RESERVED_sizeof)
			if (CODE [EP+1] == '(' && is_dcl_start (CODE [EP+2])) {
				e = sizeof_typename ();
				goto have_unary;
			} else prefix [ipr++] = SIZEOF;
#ifdef LABEL_VALUES
		else if (t == ANDAND) {
			e = gnu_label_value ();
			goto have_unary;
		}
#endif
		else break;
		
	if ((e = postfix_expression ()) == -1 && ipr > 0)
		syntax_error (EP, "prefix operator w/o operand");

have_unary:
	reloc (); /* * */
	while (ipr--) {
		ee [iee].voici.e = e;
		if ((ee [iee].action = prefix [ipr]) == CAST)
			ee [iee].voila.cast = casts [ipr];
		e = iee++;
	}

	return e;
}

exprID expression_parser::primary_expression ()
{
	int t = CODE [EP++];

	if (ISSYMBOL (t)) {
		ee [iee].action = SYMBOL;
		ee [iee].voici.symbol = t;
		return iee++;
	}

	if (ISNUMBER (t) || ISSTRING (t)) {
		value_to_expression (iee, t);
		return iee++;
	}

	if (t != '(') {
		EP--;
		return -1;
	}

	exprID e;
#ifdef GNU_VIOLATIONS
	if (CODE [EP] == '{') e = gnu_st_expr (); else
#endif
	e = expression ();
	if (CODE [EP++] != ')')
		syntax_error (EP, "parse error");
	return e;
}

exprID expression_parser::postfix_expression ()
{
	exprID e = primary_expression ();
	if (e == -1) return -1;

	int t;
	for (t = CODE [EP];; t = CODE [++EP]) {
		ee [iee].voici.e = e;

		switch (t) {
		case PLUSPLUS:
			ee [e = iee++].action = PPPOST; break;
		case MINUSMINUS:
			ee [e = iee++].action = MMPOST; break;
		case '[':
			EP++;
			ee [e = iee++].action = ARRAY;
			ee [e].e = expression ();
			if (CODE [EP] != ']')
				syntax_error (EP, "parse error222");
			break;
		case '(':
			EP++;
			ee [e = iee++].action = FCALL;
			ee [e].e = argument_expression_list ();
			if (CODE [EP] != ')')
				syntax_error (EP, "missing ')'");
			break;
		case POINTSAT:
			ee [e = iee++].action = PTRIND;
			ee [iee].voici.e = e;
		case '.':
			ee [e = iee++].action = MEMB;
			ee [e].voila.member = CODE [++EP];
			if (!ISSYMBOL (ee [e].voila.member))
				syntax_error (EP, "->members only");
			break;
		default:
			return e;
		}
	}
}

exprID expression_parser::binary_expression (exprID lop, int pri)
{
static	int p2;
	int coperator = bopid;
	exprID e;
	EP++;
	if ((e = unary_expression ()) == -1)
		syntax_error (EP, "two operands expected");

	p2 = priority (CODE [EP]);
	while (p2 > pri)
		e = binary_expression (e, p2);

	ee [iee].voici.e = lop;
	ee [iee].action = coperator;
	ee [iee].e = e;
	e = iee++;

	return (p2 < pri) ? e : binary_expression (e, pri);
}

exprID expression_parser::logicalOR_expression ()
{
	int p;
	exprID e = unary_expression ();
	if (e == -1) return -1;

	while ((p = priority (CODE [EP])))
		e = binary_expression (e, p);

	return e;
}

exprID expression_parser::conditional_expression ()
{
	exprID e = logicalOR_expression ();
	if (e == -1) return -1;

	if (CODE [EP] == '?') {
		ee [iee].voici.e = e;
		ee [e = iee++].action = COND;
		EP++;
		ee [e].e = expression ();
		if (CODE [EP++] != ':')
			syntax_error (EP, "(what) ? is ':' missing");
		if ((ee [e].voila.eelse = conditional_expression ()) == -1)
			syntax_error (EP, "(what) ? is : missing");
	}

	return e;
}

exprID expression_parser::assignment_expression ()
{
	exprID e = conditional_expression ();
	if (e == -1) return -1;

	if (!ISASSIGNMENT (CODE [EP])) return e;

	ee [iee].voici.e = e;
	ee [e = iee++].action = CODE [EP++];
	if ((ee [e].e = assignment_expression ()) == -1)
		syntax_error (EP, " = (missing operand)");

	return e;
}

exprID expression_parser::expression ()
{
	exprID e = assignment_expression ();
	if (e == -1) return -1;

	if (CODE [EP] == ',') {
		++EP;
		ee [iee].voici.e = e;
		ee [e = iee++].action = COMMA;
		ee [e].e = expression ();
	}

	return e;
}

exprID expression_parser::argument_expression_list ()
{
	exprID e = assignment_expression ();
	if (e == -1) return -1;

	if (CODE [EP] == ',') {
		++EP;
		ee [iee].voici.e = e;
		ee [e = iee++].action = ARGCOMMA;
		ee [e].e = argument_expression_list ();
	}

	return e;
}

expression_parser::expression_parser (NormPtr p, subexpr *tee)
{
#define STDNEE 38
	ExpressionPtr = EP = p;
	nee = STDNEE;
	extra = false;
	ee = tee;
	iee = 0;
}

void expression_parser::reloc ()
{
#define RELOCAT 10
	if (nee - iee < RELOCAT) {
		subexpr *bigger = new subexpr [nee += 32];
		memcpy (bigger, ee, iee * sizeof ee [0]);
		if (extra) delete [] ee;
		ee = bigger;
		extra = true;
	}
}

expression_parser::~expression_parser ()
{
	if (extra) delete [] ee;
}
//***********************************************************************
//		definitions
//***********************************************************************

void expression_parser::value_to_expression (exprID i, Symbol s)
{
	if (ISSTRING (s)) {
		ee [i].action = SVALUE;
		ee [i].voici.value = s - BASE;
		return;
	}

	if (s >= FLOATBASE) {
		ee [i].action = FVALUE;
		ee [i].voici.fvalue = C_Floats [s - FLOATBASE];
		return;
	}

	if (s >= UINT32BASE) {
		ee [i].action = UVALUE;
		ee [i].voici.uvalue = C_Unsigned [s - UINT32BASE];
		return;
	}

	ee [i].action = VALUE;
	ee [i].voici.value = getint (s);
}

NormPtr parse_expression (NormPtr p)
{
	subexpr tee [STDNEE];
	expression_parser PP (p, tee);

	CExpr.first = PP.expression ();
	CExpr.ee = PP.ee;
	CExpr.ne = PP.iee;
	if (!usage_only) prcode (p, PP.EP - p);
	ncc->cc_expression ();
	return PP.EP;
}

static NormPtr constant_int_expression (NormPtr p, int &r)
{
	if (ISNUMBER (CODE [p]) && CODE [p] < UINT32BASE
	&& !priority (CODE [p + 1])) {
		r = getint (CODE [p]);
		return p + 1;
	}

	subexpr tee [STDNEE];
	expression_parser PP (p, tee);

	CExpr.first = PP.conditional_expression ();
	CExpr.ee = PP.ee;
	CExpr.ne = PP.iee;
	r = ncc->cc_int_expression ();
	return PP.EP;
}

//**************************************************************************
//	just did some testing. many programs are polluted with gnu
//	`statements in expressions' and `constructor expressions'.
//	there goes my beautiful program....
//	seriously, this is hairy. <Optimization> is the root of all
//	evil, and statements in expressions which need typeof to
//	act as templates, __label__ to declare local labels, are
//	evil. The judgement day is coming....
//**************************************************************************
#ifdef GNU_VIOLATIONS
static NormPtr compound_statement (NormPtr p);
exprID expression_parser::gnu_st_expr ()
{
	EP = compound_statement (EP + 1);
	ee [iee].action = COMPOUND_RESULT;
	ee [iee].voici.using_result = last_result;
	return iee++;
}
exprID expression_parser::gnu_ctor_expr (typeID c)
{
	EP = skip_braces (EP + 1);
	ee [iee].action = VALUE;
	return iee++;
}
NormPtr declarator::bt_typeof (NormPtr p)
{
	if (CODE [p++] != '(') syntax_error (p, "typeof '('");
	subexpr tee [STDNEE];
	expression_parser PP (p, tee);
CExpr.first = PP.expression ();
CExpr.ee = PP.ee;
CExpr.ne = PP.iee;
	basetype = typeof_expression ();
	p = PP.EP;
	if (CODE [p] != ')') syntax_error (p, "typeof ')'");
	return p + 1;
}
#endif
#ifdef LABEL_VALUES
exprID expression_parser::gnu_label_value ()
{
	int s = CODE [++EP];
	if (!ISSYMBOL (s)) syntax_error (EP, "&&identifier only, for labels");
	ee [iee].action = AVALUE;
	ee [iee].voici.symbol = s;
	EP++;
	return iee++;
}
#endif
//**************************************************************************
//		Part III
//
//	statements, this is really easy
//**************************************************************************

static NormPtr while_statement (NormPtr p);
static NormPtr for_statement (NormPtr p);
static NormPtr do_statement (NormPtr p);
static NormPtr switch_statement (NormPtr p);
static NormPtr if_statement (NormPtr p);
static NormPtr compound_statement (NormPtr p);
static NormPtr __asm___statement (NormPtr p);

static NormPtr statement (NormPtr p)
{
	int t = CODE [p++];

	if (ISSYMBOL (t) && CODE [p] == ':')
		return p + 1;

	switch (t) {
	case RESERVED_default:
		if (CODE [p] != ':') syntax_error (p, "default:");
		return p + 1;
	case RESERVED_case:
		int tmp;
		p = constant_int_expression (p, tmp);
		if (CODE [p] != ':') syntax_error (p, "case ERROR:");
		return p + 1;
	case RESERVED_continue:
	case RESERVED_break:
		if (CODE [p] != ';') syntax_error (p, "break | continue ';'");
		return p + 1;
	case RESERVED_goto:
		if (!ISSYMBOL (CODE [p]) || CODE [p + 1] != ';')
			syntax_error (p, "goto error;");
		return p + 2;
	case RESERVED_return:
		p = parse_expression (p);
		if (CODE [p] != ';') syntax_error (p, "return ... ';'");
		return p + 1;
	case RESERVED_while:	return while_statement (p);
	case RESERVED_for:	return for_statement (p);
	case RESERVED_do:	return do_statement (p);
	case RESERVED_switch:	return switch_statement (p);
	case RESERVED_if:	return if_statement (p);
	case RESERVED___asm__:	return __asm___statement (p);
	case '{':		return compound_statement (p);
	default:
		p = parse_expression (p - 1);
		if (CODE [p++] != ';')
			syntax_error (p, "expression + ';' = statement");
	case ';':
		return p;
	}
}

static NormPtr parenth_expression (NormPtr p)
{
	if (CODE [p++] != '(')
		syntax_error (p, "'(' expression");
	p = parse_expression (p);
	if (CODE [p++] != ')')
		syntax_error (p, "expression ')'");
	return p;
}

static NormPtr while_statement (NormPtr p)
{
	return statement (parenth_expression (p));
}

static NormPtr do_statement (NormPtr p)
{
	p = statement (p);
	if (CODE [p++] != RESERVED_while)
		syntax_error (p, "do w/o while");
	p = parenth_expression (p);
	if (CODE [p++] != ';')
		syntax_error (p, "This is special, but you need a ';'");
	return p;
}

static NormPtr for_statement (NormPtr p)
{
	if (CODE [p++] != '(')
		syntax_error (p, "for '('...");
	p = parse_expression (p);
	if (CODE [p++] != ';')
		syntax_error (p, "for (expression ';' ...");
	p = parse_expression (p);
	if (CODE [p++] != ';')
		syntax_error (p, "for (expression; expression ';' ...");
	p = parse_expression (p);
	if (CODE [p++] != ')')
		syntax_error (p, "for (;; ')'");
	return statement (p);
}

static NormPtr switch_statement (NormPtr p)
{
	p = parenth_expression (p);
	if (CODE [p++] != '{')
		syntax_error (p, "switch () '{'");
	return compound_statement (p);
}

static NormPtr if_statement (NormPtr p)
{
	p = statement (parenth_expression (p));
	// oh my god! this must be the horrible if-else ambiguity!
	return CODE [p] == RESERVED_else ? statement (p + 1) : p;
}

static NormPtr compound_statement (NormPtr p)
{
	open_compound ();

	while (CODE [p] != '}')
		if (is_dcl_start (CODE [p])) {
			declaration D;
			p = D.parse (p);
		} else break;

	while (CODE [p] != '}')
		p = statement (p);

	close_region ();
	return p + 1;
}

static NormPtr __asm___statement (NormPtr p)
{
	NormPtr ast = p + 1;
	if (CODE [p] != '(') syntax_error (p, "__asm__ '('");
	p = skip_parens (p);
	if (CODE [p++] != ';') syntax_error (p, "asm() ';'");
	ncc->inline_assembly (ast, p - ast - 1);
	return p;
}

//***********************************************************************
//
//		Part IV - the rest
//
//***********************************************************************
static NormPtr initializer (Symbol s, NormPtr p)
{
	if (CODE [p] == '{') return skip_braces (p);
	if (ISSTRING (CODE [p])) {
		return p + 1;
	}

	subexpr tee [STDNEE];
	tee [0].action = '=';
	tee [0].voici.e = 1;
	tee [1].action = SYMBOL;
	tee [1].voici.symbol = s;
	expression_parser EEP (p, tee);
	EEP.iee = 2;
	exprID e;

	if ((e = EEP.assignment_expression ()) == -1)
		syntax_error (p, "erroneous initialization");
	EEP.ee [0].e = e;

	CExpr.first = 0;
	CExpr.ee = EEP.ee;
	CExpr.ne = EEP.iee;
	if (!usage_only) prcode (p, EEP.EP - p);
	ncc->cc_expression ();
	return EEP.EP;
}

static NormPtr parse_structure (NormPtr p)
{
	declaration_instruct D;
	while (CODE [p] != '}' && p < C_Ntok)
		p = D.parse (p);
	close_region ();
	return p + 1;
}

static NormPtr parse_function (Symbol s, NormPtr a, NormPtr p)
{
	if (!function_definition (s, a, p))
	syntax_error (p, "Function definition already defined", expand (s));
	return skip_braces (p);
}

void do_functions ()
{
	int i;
	NormPtr args, body;

	for (i = 0; function_no (i, &args, &body); i++) {
		arglist A;
		A.parse_declare (args + 1);
		compound_statement (body + 1);
		close_region ();
	}
}

//
// Well, that's it.
//
void parse_translation_unit ()
{
	NormPtr p = 0;
	declaration D;

	while (p < C_Ntok)
		if (CODE [p] == ';') p++;
		else p = D.parse (p);

	do_functions ();
}

void parse_C ()
{
	parse_translation_unit ();
}
