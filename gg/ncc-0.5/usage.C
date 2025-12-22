/*****************************************************************************
$	C-flow and data usage analysis.
$
$	Stripped-down version of ccexpr. expressions are compiled but
$	without producing bytecode assembly. just inform about
$	function calls, use of global variables and use of members
$	of structures
*****************************************************************************/
#include <stdio.h>
#include <assert.h>

#include "global.h"
#include "inttree.h"

static intTree printed;

void report (Symbol s, int frame)
{
	if (tdmap_fmt) return;
	if (!unique_vars) {
		if (frame == -1 )
		printf ("\tUsing extern object %s\n", C_Syms [SYMBOLID (s)]);
		else if (frame == 0)
		printf ("\tUsing global object %s\n", C_Syms [SYMBOLID (s)]);
		else printf ("\tUsing member %s of structure %s\n",
			C_Syms [SYMBOLID (s)], struct_by_name (frame));
	} else if (!printed.intFind (frame * 100000 + s)) {
		new intNode (&printed);
		if (frame == -1 )
		printf ("\tUsing extern object %s\n", C_Syms [SYMBOLID (s)]);
		else if (frame == 0)
		printf ("\tUsing global object %s\n", C_Syms [SYMBOLID (s)]);
		else printf ("\tUsing member %s of structure %s\n",
			C_Syms [SYMBOLID (s)], struct_by_name (frame));
	}
}

void newfunction (Symbol s)
{
	if (tdmap_fmt) printf ("%s\n", C_Syms [SYMBOLID (s)]);
	else printf ("\n# # # # #Function %s\n", C_Syms [SYMBOLID (s)]);
	if (printed.root) {
		delete printed.root;
		printed.root = NULL;
	}
}


struct ccsub_small
{
inline	void fconv ();
inline	void iconv ();
inline	void settype (int);
inline	void lvaluate ();
inline	void copytype (ccsub_small&);
inline	void degrade (ccsub_small&);
inline	void arithmetic_convert (ccsub_small&, ccsub_small&);
inline	bool arithmetic ();
inline	bool structure ();
inline	void assign_convert (ccsub_small&);
	bool op1return;
static	ccsub_small op1;
inline	void cc_binwconv (ccsub_small&, ccsub_small&);
inline	void cc_addptr (ccsub_small&, ccsub_small&);
	int  base, spec [MSPEC];
	bool lv;
	void cc_fcall (exprID);
	void cc_prepostfix (exprID);
inline	void cc_terminal (exprID);
inline	void cc_dot (exprID);
inline	void cc_array (exprID);
inline	void cc_star (exprID);
inline	void cc_addrof (exprID);
	void cc_ecast (exprID);
	void cc_usign (exprID);
inline	void cc_nbool (exprID);
inline	void cc_compl (exprID);
inline	void cc_add (exprID);
	void cc_sub (exprID);
	void cc_muldiv (exprID);
	void cc_bintg (exprID);
inline	void cc_cmp (exprID);
	void cc_bool (exprID);
	void cc_conditional (exprID);
	void cc_assign (exprID);
	void cc_oassign (exprID);
	ccsub_small (exprID);
	ccsub_small () {}
	ccsub_small (typeID, bool);
};

ccsub_small ccsub_small::op1;

void ccsub_small::cc_terminal (exprID ei)
{
	subexpr e = ee [ei];
	lookup_object ll (e.voici.symbol);
	if (ll.enumconst) {
		settype (S_INT);
		return;
	}
	base = ll.base;
	intcpy (spec, ll.spec);
	if (ll.FRAME <= 0)
	report (e.voici.symbol, ll.FRAME);
	lvaluate ();
}

void ccsub_small::cc_addrof (exprID ei)
{
	ccsub_small o (ee [ei].voici.e);

	base = o.base;
	if (o.lv || o.structure ()) {
		spec [0] = '*';
		intcpy (&spec [1], o.spec);
	} else if (o.spec [0] != -1)
		intcpy (spec, o.spec);
	else half_error ("&address_of not addressable");
}

void ccsub_small::cc_star (exprID e)
{
	ccsub_small o (ee [e].voici.e);
	degrade (o);
	lvaluate ();
}

void ccsub_small::cc_array (exprID ei)
{
	ccsub_small o1 (ee [ei].voici.e), o2 (ee [ei].e);
	cc_addptr (o1, o2);
	degrade (*this);
	lvaluate ();
}

void ccsub_small::cc_dot (exprID ei)
{
	subexpr e = ee [ei];
	ccsub_small o (e.voici.e);
	lookup_member lm (e.voila.member, o.base);
	base = lm.base;
	intcpy (spec, lm.spec);
	report (e.voila.member, o.base);
	lvaluate ();
}

void ccsub_small::cc_ecast (exprID ei)
{
	subexpr e = ee [ei];
	ccsub_small o (e.voici.e), pseudo (e.voila.cast, true);
	o.assign_convert (pseudo);
	copytype (o);
	*this = o;
}

void ccsub_small::cc_usign (exprID ei)
{
	subexpr e = ee [ei];
	ccsub_small o (e.voici.e);
	copytype (o);
}

void ccsub_small::cc_nbool (exprID ei)
{
	ccsub_small o (ee [ei].voici.e);
	(void) o;
	settype (S_INT);
}

void ccsub_small::cc_compl (exprID ei)
{
	ccsub_small o (ee [ei].voici.e);
	(void) o;
	settype (S_INT);
}

void ccsub_small::cc_bintg (exprID ei)
{
	subexpr e = ee [ei];
	ccsub_small o1 (e.voici.e), o2 (e.e);
	(void) o2;
	if (op1return) op1 = o1;
	settype (S_INT);
}

void ccsub_small::cc_muldiv (exprID ei)
{
	subexpr e = ee [ei];
	ccsub_small o1 (e.voici.e), o2 (e.e);
	if (op1return) op1 = o1;
	cc_binwconv (o1, o2);
}

void ccsub_small::cc_prepostfix (exprID ei)
{
	subexpr e = ee [ei];
	ccsub_small o (e.voici.e);
	copytype (o);
}

void ccsub_small::cc_add (exprID ei)
{
	subexpr e = ee [ei];
	ccsub_small o1 (e.voici.e), o2 (e.e);

	if (op1return) op1 = o1;
	if (o1.arithmetic () && o2.arithmetic ())
		cc_binwconv (o1, o2);
	else    cc_addptr (o1, o2);
}

void ccsub_small::cc_sub (exprID ei)
{
	subexpr e = ee [ei];
	ccsub_small o1 (e.voici.e), o2 (e.e);

	if (op1return) op1 = o1;

	if (o1.arithmetic () && o2.arithmetic ()) {
		cc_binwconv (o1, o2);
		return;
	}

	if (!o1.arithmetic () && !o2.arithmetic ()) settype (S_INT);
	else copytype (o1);
}

void ccsub_small::cc_cmp (exprID ei)
{
	subexpr e = ee [ei];
	ccsub_small o1 (e.voici.e), o2 (e.e);

	if (o1.arithmetic () && o1.arithmetic ())
		arithmetic_convert (o1, o2);
	settype (S_INT);
}

void ccsub_small::cc_bool (exprID ei)
{
	subexpr e = ee [ei];
	ccsub_small o1 (e.voici.e);
	ccsub_small o2 (e.e);
	(void) o1;
	(void) o2;
	settype (S_INT);
}

void ccsub_small::cc_conditional (exprID ei)
{
	subexpr e = ee [ei];
	ccsub_small o (e.voici.e);
	ccsub_small o1 (e.e);
	ccsub_small o2 (e.voila.eelse);
	(void) o1;
	(void) o2;
	(void) o;
	copytype (o2);
}

void ccsub_small::cc_assign (exprID ei)
{
	subexpr e = ee [ei];
	ccsub_small o1 (e.voici.e), o2 (e.e);
	(void) o2;
	copytype (o1);
}

void ccsub_small::cc_oassign (exprID ei)
{
	op1return = true;
	switch (ee [ei].action) {
		case ASSIGNA:	cc_add (ei); break;
		case ASSIGNS:	cc_sub (ei); break;
		case ASSIGNM:
		case ASSIGND:	cc_muldiv (ei); break;
		case ASSIGNBA: case ASSIGNBX: case ASSIGNBO:
		case ASSIGNRS: case ASSIGNLS:
		case ASSIGNR:	cc_bintg (ei); break;
	}
	copytype (op1);
}

void ccsub_small::cc_fcall (exprID ei)
{
	int i;
	subexpr e = ee [ei];

	if (ee [e.voici.e].action == SYMBOL) {
		lookup_function lf (ee [e.voici.e].voici.symbol);
		printf ((tdmap_fmt) ? "\t%s\n" : "Calls function %s\n",
			 expand (ee [e.voici.e].voici.symbol));
		base = lf.base;
		intcpy (spec, lf.spec + 2);
	} else {
		ccsub_small fn (ee [ei].voici.e);
		i = 2;
		if (fn.spec [0] != '(') {
			if (fn.spec [0] == '*' && fn.spec [1] == '(')
				i = 3;
			else half_error ("not a function");
		}
		base = fn.base;
		intcpy (spec, fn.spec + i);
	}

	if ((ei = ee [ei].e) != -1) {
		for (; ee [ei].action == ARGCOMMA; ei = ee [ei].e) {
			ccsub_small o (ee [ei].voici.e);
			o.lv = o.lv;
		}
		ccsub_small o (ei);
		o.lv = o.lv;
	}
}

////////////////////////////////////////////////////////////////////////////

void ccsub_small::cc_binwconv (ccsub_small &o1, ccsub_small &o2)
{
	arithmetic_convert (o1, o2);
	settype (o1.base);
}

void ccsub_small::cc_addptr (ccsub_small &o1, ccsub_small &o2)
{
	bool b2 = o2.arithmetic ();
	if (b2) {
		o2.lv = false;
		copytype (o1);
	} else {
		o1.lv = false;
		copytype (o2);
	}
}

void ccsub_small::copytype (ccsub_small &o)
{
	base = o.base;
	intcpy (spec, o.spec);
}

void ccsub_small::degrade (ccsub_small &o)
{
	base = o.base;
	if (o.spec [0] == -1) half_error ("Not a pointer");
	intcpy (spec, o.spec + (o.spec [0] == '*' ? 1 : 2));
}

bool ccsub_small::structure ()
{
	return spec [0] == -1 && base >= 0;
}

bool ccsub_small::arithmetic ()
{
	return spec [0] == -1 && base < VOID || spec [0] == ':';
}

void ccsub_small::lvaluate ()
{
	lv = !(spec [0] =='[' || spec [0] ==-1 && base >=0 || spec [0] =='(');
}

void ccsub_small::settype (int b)
{
	base = b;
	spec [0] = -1;
}

void ccsub_small::assign_convert (ccsub_small &o)
{
	if (o.arithmetic ())
		if (o.base != FLOAT) iconv ();
		else fconv ();
	base = o.base;
	intcpy (spec, o.spec);
}

void ccsub_small::arithmetic_convert (ccsub_small &o1, ccsub_small &o2)
{
	if (o1.base == FLOAT || o2.base == FLOAT) {
		if (o1.base != o2.base)
			if (o1.base == FLOAT) o2.fconv ();
			else o1.fconv ();
	}
}

void ccsub_small::fconv ()
{
	settype (FLOAT);
}

void ccsub_small::iconv ()
{
	settype (S_INT);
}

//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

ccsub_small::ccsub_small (exprID ei)
{
	if (ei == -1) return;
advance:
	subexpr e = ee [ei];

	lv = false;
	op1return = false;
	switch (e.action) {
		case VALUE: case COMPOUND_RESULT:
		case UVALUE:	settype (S_INT);	break;
		case FVALUE:	settype (FLOAT);	break;
		case SVALUE:	base = S_CHAR; spec [0] = '*'; spec [1] = -1;
				break;
		case AVALUE:	base = VOID; spec [0] = '*'; spec [1] = -1;
				break;
		case SYMBOL:	cc_terminal (ei);	break;
		case FCALL:	cc_fcall (ei);		break;
		case MEMB:	cc_dot (ei);		break;
		case ARRAY:	cc_array (ei);		break;
		case ADDROF:	cc_addrof (ei);		break;
		case PTRIND:	cc_star (ei);		break;
		case MMPOST: case PPPOST:
		case PPPRE:
		case MMPRE:	cc_prepostfix (ei);	break;
		case CAST:	cc_ecast (ei);		break;
		case LNEG:	cc_nbool (ei);		break;
		case OCPL:	cc_compl (ei);		break;
		case UPLUS:
		case UMINUS:	cc_usign (ei);		break;
		case SIZEOF:	settype (S_INT);	break;
		case MUL:
		case DIV:	cc_muldiv (ei);		break;
		case ADD:	cc_add (ei);		break;
		case SUB:	cc_sub (ei);		break;
		case SHR: case SHL: case BOR: case BAND: case BXOR:
		case REM:	cc_bintg (ei);	break;
		case IAND:
		case IOR:	cc_bool (ei);		break;
		case BNEQ: case CGR: case CGRE: case CLE: case CLEE:
		case BEQ:	cc_cmp (ei);	break;
		case COND:	cc_conditional (ei);	break;
		case COMMA: {
			ccsub_small o (e.voici.e);
			ei = e.e;
			(void) o;
			goto advance;
		}
		default:
			if (e.action == '=') cc_assign (ei);
			else cc_oassign (ei);
	}
}


ccsub_small::ccsub_small (typeID ti, bool)
{
	type t;
	opentype (ti, t);
	base = t.base;
	intcpy (spec, t.spec);
}

//
//
//
//

class ncci_usage : public ncci
{
	public:
	void cc_expression ();
	int  cc_int_expression ();
	void new_function (Symbol);
	void inline_assembly (NormPtr, int);
};

void ncci_usage::cc_expression ()
{
	try {
		if (CExpr.first != -1)  {
			ccsub_small CC (CExpr.first);
			CC.lv = CC.lv;
		}
	} catch (EXPR_ERROR) { }
	last_result++;
}

int ncci_usage::cc_int_expression ()
{
	return 112;
}

void ncci_usage::new_function (Symbol s)
{
	newfunction (s);
}

void ncci_usage::inline_assembly (NormPtr p, int n)
{
// hoping that inline assembly won't use global variables,
// nor call functions, it is ignored (for now at least)
}

void set_usage_report ()
{
	ncc = new ncci_usage;
}
