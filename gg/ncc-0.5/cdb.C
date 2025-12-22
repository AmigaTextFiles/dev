/*****************************************************************************

	data collected from the parser

*****************************************************************************/
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <assert.h>

#include "dbstree.h"
#include "inttree.h"
#include "global.h"
#include "stack.h"

/*****************************************************************************
#
#	the most complex part in a C compiler is the data structures
#	storing what is introduced from the declarations.
#
#	the base to understanding how the program works, is understanding
#	the way data is stored and retrieved from this cdb.
#
#	what this file provides is described in global.h at
#	`CDB interface' 
#
#	this is where all the monay went...
*****************************************************************************/

/*****************************************************************************
#
#	In many parts of the program, there is multiplexing of
#	different kind of pointers in integers.
#	Thats a thing we can do in 32-bit architectures
#	==> A register can have values up to 4 billion
#	    and thus, when used as an index of arrays, it
#	    can actually store much more.
#
#	For example. Suppose a program is using foo[]s and
#	zoo[]s and at some point we have something that may
#	be either a foo or a zoo. That can be multiplexed
#	into an integer 'x', where:
#		if it is a foo, x = index in foo []
#		if it is a zoo, x = 10000000 + index in zoo []
#
#	This situation is common in many programs and 32-bit
#	architectures are not only about "4Gb of memory"
#
#	Here are basic indexes used:
#
# typeID:	integer describing index in the types [] table of
#		basetype+pointers/arrays/arguments
# ObjPtr:	integer which multiplexes possible base-types into one
#		Bitfield:   if < -32
#		Builtin:    <BASETYPE> if < _BTLIMIT
#		Structure:  <RegionPtr> if < TYPEDEF_BASE && positive
#		Typedef:    <typeID> if > TYPEDEF_BASE
#			in the latter case typeID = ObjPtr - TYPEDEF_BASE
# RegionPtr:	integer describing index in regions [] table
# NormPtr:	integer describing index in the CODE[] normalized C source
# ArglPtr:	integer describing index in arglists[] table
# Symbol:	integer describing value of CODE[]
#
*****************************************************************************/
bool INGLOBAL, INSTRUCT;
typeID VoidType, SIntType;
ArglPtr NoArgSpec;

/*****************************************************************************
#	type pool	(typeID)
#
#	here we allocate types. Types of X are:
#		int X
#		int **X
#		int * X [32][64][]
#		struct foo *X
#		int X (int, char*, struct bar**)
#		struct foo **(*X[3]) (int, char)
#
#	abstract declarations for the above are described with a
#	'struct type' object, which includes basetype (ObjPtr)
#	and specifications (pointer, array-size, function-ArglistPtr).
#	For example, the latter foo has specifications:
#		'[', 3, '*', '(', <ArglPtr>, '*', '*', -1
#	which sais: array 3 of pointer to function with arguments
#		    at <ArglPtr> returning pointer to pointer to basetype
#
#	the types[] table, does not include typedef basetypes.
#	typedefs are expanded before things are inserted into types[]
#	with use of the gettype(type&) function.
*****************************************************************************/
static earray<type> types;
static dbsTree typetree;
struct utype : public dbsNode
{
static	type Query;
	utype ();
	typeID ID;
	int compare (dbsNode*);
	int compare ();
};

utype::utype () : dbsNode (&typetree)
{
	types.x [ID = types.alloc ()].base = Query.base;
	types.x [ID].spec = intdup (Query.spec);
}

type utype::Query;
int utype::compare (dbsNode *d)
{
	utype *u = (utype*) d;
	RegionPtr p = types.x [ID].base;
	RegionPtr p2 = types.x [u->ID].base;
	if (p == p2) return intcmp (types.x [ID].spec, types.x [u->ID].spec);
	return p < p2 ? -1 : 1;
}

int utype::compare ()
{
	RegionPtr p = types.x [ID].base;
	RegionPtr p2 = Query.base;
	if (p == p2) return intcmp (types.x [ID].spec, Query.spec);
	return p < p2 ? -1 : 1;
}

typeID newtype (type &t)
{
	utype::Query.base = t.base;
	utype::Query.spec = t.spec;
	utype *u = (utype*) typetree.dbsFind ();
	if (!u) u = new utype;
	return u->ID;
}

typeID gettype (type &t)
{
	if (t.base < TYPEDEF_BASE) return newtype (t);

	type nt;
	typeID td = t.base - TYPEDEF_BASE;
	int newspec [MSPEC];

	// check incomplete typedef
	intcpycat (newspec, t.spec, types.x [td].spec);
	nt.base = types.x [td].base;
	nt.spec = newspec;
	return newtype (nt);
}

void opentype (typeID ti, type &t)
{
	t.base = types.x [ti].base;
	t.spec = types.x [ti].spec;
}
/*****************************************************************************
#	argument lists.
#
#	Array of typeIDs terminated at -1.
#	also stored in a dbstree for log(N) insert
*****************************************************************************/
static earray<typeID*>	arglists;
static dbsTree		argTree;

class argNode : public dbsNode
{
   public:
static	Vspec Query;
	argNode ();
	int compare (dbsNode*);
	int compare ();
	ArglPtr ID;
};

Vspec argNode::Query;

int argNode::compare (dbsNode *d)
{
	return intcmp (arglists.x [ID], arglists.x [((argNode*)d)->ID]);
}

int argNode::compare ()
{
	return intcmp (arglists.x [ID], Query);
}

argNode::argNode () : dbsNode (&argTree)
{
	arglists.x [ID = arglists.alloc ()] = intdup (Query);
}

ArglPtr make_arglist (typeID *t)
{
	argNode::Query = t;
	argNode *a = (argNode*) argTree.dbsFind ();
	if (!a) a = new argNode;
	return a->ID;
}

typeID *ret_arglist (ArglPtr n)
{
	return arglists.x [n];
}
/*****************************************************************************
#	identifier lookup
#
#	for each identifier, there is a list including:
#		what this identifier is, and
#		which region (scope) this applies to
#	there is also an array of regions, each with the
#	index of its parent region.
#
#	with these, here we deal with lookups.
#	Introducing new names in regions is done later.
#
#	RECORD uses info.rp which shows which region it is about
#	ENUMCONST uses info.eval for the value
#	ENUMTAG is only useful for its existance
*****************************************************************************/
static RegionPtr current_region;

enum ITYPE {
	RECORD, ENUMTAG, TYPEDEF, OBJECT, EOBJECT,
	ENUMCONST, EFUNCTION, IFUNCTION
};
#define ISTAG(x) (x <= ENUMTAG)

static struct lookup_t {
	lookup_t *next;
	RegionPtr cp;
	lookup_t (Symbol, ITYPE, RegionPtr);
	union {
		RegionPtr rp;
		typeID tdf;
		int eval;
	} info;
	int placement;
	char kind, incomplete, defspec;
} **lookup_table;

lookup_t::lookup_t (Symbol s, ITYPE i, RegionPtr r)
{
	next = lookup_table [s - SYMBASE];
	lookup_table [s - SYMBASE] = this;
	kind = i;
	cp = r;
}

enum REGION {
	GLOBAL, CCODE, FUNCTIONAL, RECORD_S, RECORD_U
};

struct region {
	RegionPtr parent;
	REGION kind;
	int aligned_top, nn;
	char bits, incomplete;
	int add_object (typeID);
	int add_field (typeID, typeID&);
};
#define ISRECORD(x) (x >= RECORD_S)

int region::add_object (typeID t)
{
	if (usage_only) return 0;
	if (kind == RECORD_U) {
		int i = sizeof_typeID (t);
		if (i > aligned_top) aligned_top = i;
		return 0;
	}
	int r = aligned_top;
	int i = sizeof_typeID (t);
	nn++;
	if (i == 0) ;
	else if (i == 1) aligned_top++;
	else if (i == 2) aligned_top += aligned_top % 2 ? 3 : 2;
	else {
		int a = aligned_top % 4;
		if (a == 0) aligned_top += i;
		else aligned_top += 4 - a + i;
	}
	return r;
}

int region::add_field (typeID ti, typeID &ret)
{
	type t = types.x [ti];
	type nt;
	int spec [3] = { -1, 0, -1 }, r = aligned_top;

	if (t.spec [1] == 0) {
		bits = 0;
		nt.base = S_INT;
		spec [0] = '[';
		nt.spec = spec;
		ret = gettype (nt);
		if (kind != RECORD_U) aligned_top += 4;
		return r;
	}
	if ((bits += t.spec [1]) > BITFIELD_Q) {
		bits = 0;
		if (kind != RECORD_U) aligned_top += 4;
	}
	nt.base = -(bits + 32 * t.spec [1]);
	nt.spec = spec;
	ret = gettype (nt);
	return r;
}

static stack<region> regions;

static struct {
	RegionPtr cc [32];
	int cci;
} p_region;

RegionPtr open_region (RegionPtr r)
{
	p_region.cc [p_region.cci++] = current_region;

	current_region = r;
	INGLOBAL = false;
	INSTRUCT = ISRECORD (regions [r].kind);
	return r;
}

RegionPtr new_region (REGION kind, RegionPtr r)
{
	RegionPtr n;
	regions [n = regions.alloc ()].parent = r;
	regions [n].kind = kind;
	regions [n].nn = regions [n].aligned_top = regions [n].bits = 0;
	regions [n].incomplete = 1;
	return n;
}

RegionPtr open_region (REGION kind, RegionPtr r)
{
	return open_region (new_region (kind, r));
}

void close_region ()
{
	regions [current_region].incomplete = 0;
	current_region = p_region.cc [--p_region.cci];
	INGLOBAL = current_region == 0;
	INSTRUCT = !INGLOBAL && ISRECORD (regions [current_region].kind);
}

lookup_t *Lookup (Symbol s, bool tagged, RegionPtr r)
{
	lookup_t *t = lookup_table [s - SYMBASE];
	for (; t; t = t->next)
		if (t->cp == r)
		if ((tagged && ISTAG(t->kind)) || (!tagged && !ISTAG(t->kind)))
			return t;
	return NULL;
}

lookup_t *Lookup_foruse (Symbol s, bool tagged, RegionPtr r)
{
	lookup_t *t;
	for (;;) {
		if ((t = Lookup (s, tagged, r))) return t;
		if (r == 0) break;
		r = regions [r].parent;
	}
	return NULL;
}
/*****************************************************************************
#	small utility : comparison of types
#
#	Normally, comparison one by one would be plentyly enough, but a
#	function declaration w/o arguments is a wildcard that should
#	match with any other argument list
#	Moreover, incomplete arrays match with complete arrays
*****************************************************************************/
static Ok speccmp (Vspec s1, Vspec s2)
{
	while (*s1 != -1) {
		if (*s1 != *s2) return false;
		if (*s1 == '(') {
			++s1, ++s2;
			if (*s1 != *s2 && *s1 != NoArgSpec && *s2 != NoArgSpec)
				return false;
		} else if (*s1 == '[') {
			++s1, ++s2;
			if (*s1 != *s2 && *s1 != 0 && *s2 != 0)
				return false;
		}
		++s1, ++s2;
	}
	return *s1 == *s2;
}

static Ok typecmp (typeID ti1, typeID ti2)
{
	type t1 = types.x [ti1];
	type t2 = types.x [ti2];

	return t1.base == t2.base && speccmp (t1.spec, t2.spec);
}
/******************************************************************************
#	functions
#
#	functions are compiled after global has been parsed
#	so that in expressions we know which variables are external.
#
#	At each function definition, we store the location to the
#	function body and the function arguments in CODE[].
#
#	after the entire translation unit, function_no()
#	will be called for each function, which will return the
#	pointers to argument list, function body and open a
#	region ready to receive the argument objects.
******************************************************************************/
struct cfunc {
	Symbol name;
	NormPtr args, body;
};

static earray<cfunc> functions;

Ok function_definition (Symbol name, NormPtr args, NormPtr body)
{
	int i;
	lookup_t *L = Lookup (name, false, 0);

	if (L->kind != EFUNCTION) return false;
	L->kind = IFUNCTION;

	functions.x [i = functions.alloc ()].name = name;
	functions.x [i].args = args;
	functions.x [i].body = body;
	L->placement = i;
	return true;
}

Ok function_no (int i, NormPtr *ra, NormPtr *rb)
{
	if (i >= functions.nr) return false;
	*ra = functions.x [i].args;
	*rb = functions.x [i].body;
	open_region (FUNCTIONAL, 0);
	ncc->new_function (functions.x [i].name);
	return true;
}

void open_compound ()
{
	open_region (CCODE, current_region);
}

void functions_of_file ()
{
	printf ("%s\n", sourcefile);
	for (int i = 0; i < functions.nr; i++)
		printf ("\t%s\n", expand (functions.x [i].name));
}
/*****************************************************************************
#	declaration of new names to the program
#
#	which are: objects (variables and functions), typedefs
#	enumeration tags, enumeration constants and structure tags.
#
#	structure tag can be declared at declaration or at forward
#	declaration (use). Check for recursion (incomplete base type), is
#	done at the sizeof calculation elsewhere.
#
#	the items are semantically correct, and the only error that
#	can happen here is if something is already declared
#	in the same region
*****************************************************************************/

static Ok function_declaration (Symbol s, typeID t, VARSPC v)
{
	lookup_t *L;

	if ((L = Lookup (s, false, 0))) {
		if (L->kind < EFUNCTION) return false;
		typeID tt = L->info.tdf;
		if (!typecmp (t, tt)) return false;
		if (L->kind == EFUNCTION && types.x [tt].spec [1] == NoArgSpec)
			L->info.tdf = t;
		return true;
	}

	L = new lookup_t (s, EFUNCTION, 0);
	L->info.tdf = t;
	L->defspec = v;
	return true;
}

static Ok field_member (Symbol s, typeID t)
{
	typeID nt;
	int p;

	if (s != -1 && Lookup (s, false, current_region))
		return false;
	p = regions [current_region].add_field (t, nt);
	if (s != -1) {
		lookup_t *L = new lookup_t (s, OBJECT, current_region);
		L->info.tdf = nt;
		L->placement = p;
	}
	return true;
}

Ok introduce_obj (Symbol s, typeID t, VARSPC v)
{
	if (ISFUNCTION (types.x [t]))
		return function_declaration (s, t, v);
	if (types.x [t].spec [0] == ':')
		return field_member (s, t);

	if (t == VoidType)
		syntax_error (expand (s), "is just void");

	lookup_t *L;
	if ((L = Lookup (s, false, current_region))) {
		if (L->kind != EOBJECT && L->kind != OBJECT) return false;
		typeID et = L->info.tdf;
		if (!typecmp (t, et)) return false;
		if (current_region == 0) return true;
		if (types.x[et].spec[0] == '[' && types.x[et].spec[1] == 0) {
			if (L->kind == OBJECT || v == EXTERN) {
				L->info.tdf = t;
				return true;
			}
			L->kind = OBJECT;
			L->placement = regions
			 [current_region].add_object (t);
			return true;
		}
		if (L->kind == OBJECT) return v == EXTERN;
		if (v != EXTERN) {
			// instantiation
			L->kind = OBJECT;
			L->info.tdf = t;
			L->placement = regions
			 [current_region].add_object (t);
		}
		return true;
	}

	if (v == EXTERN) {
		L = new lookup_t (s, EOBJECT, current_region);
		L->info.tdf = t;
	} else {
		L = new lookup_t (s, OBJECT, current_region);
		L->info.tdf = t;
		L->placement = regions
			[current_region].add_object (t);
	}

	return true;
}

Ok introduce_tdef (Symbol s, typeID t)
{
	lookup_t *L = Lookup (s, false, current_region);
	if (L) return L->kind == TYPEDEF && typecmp (t, L->info.tdf);
	L = new lookup_t (s, TYPEDEF, current_region);
	L->info.tdf = t;
	return true;
}

ObjPtr lookup_typedef (Symbol s)
{
	lookup_t *t = Lookup_foruse (s, false, current_region);
	if ((t) && t->kind == TYPEDEF)
		return TYPEDEF_BASE + t->info.tdf;
	return -1;
}

Ok introduce_enumconst (Symbol s, int value)
{
	RegionPtr r = current_region;
	while (ISRECORD (regions [r].kind)) r = regions [r].parent;
	if (Lookup (s, false, r)) return false;
	lookup_t *L = new lookup_t (s, ENUMCONST, r);
	L->info.eval = value;
	return true;
}

Ok introduce_enumtag (Symbol s)
{
	if (Lookup (s, true, current_region)) return false;
	new lookup_t (s, ENUMTAG, current_region);
	return true;
}

Ok valid_enumtag (Symbol s)
{
	lookup_t *t = Lookup_foruse (s, true, current_region);
	return (t) && t->kind == ENUMTAG;
}

/******************************************************************************
#	records (struct, union)
#
#	Normally, structure by name is not needed. But in the
#	case of usage report the user wants to know which
#	structure is structure #234
#	Thus the inttree.
******************************************************************************/
static intTree struct_names;
class sname : public intNode
{
   public:
	int symbol;
	sname (int s) : intNode (&struct_names) { symbol = s; }
};

const char *struct_by_name (RegionPtr p)
{
	sname *s = (sname*) struct_names.intFind (p);
	if (!s) return "internal BUG";
	return s->symbol == -1 ? "{anonymous}" : C_Syms [s->symbol - SYMBASE];
}

static inline void name_struct (RegionPtr p, Symbol s)
{
	if (usage_only) if (!struct_names.intFind (p)) new sname (s);
}

RegionPtr introduce_struct_dcl (Symbol s, bool isst)
{
	RegionPtr r;
	lookup_t *L;
	for (r = current_region; ISRECORD (regions [r].kind);
		r = regions [r].parent);

	if (s != ANONYMOUS) {
		L = Lookup_foruse (s, true, r);
		if (L) {
			if (L->kind == ENUMTAG) return -1;
			name_struct (L->info.rp, s);
			return open_region (L->info.rp);
		}
		L = new lookup_t (s, RECORD, r);
		L->incomplete = 0;
		L->info.rp = open_region (isst ? RECORD_S:RECORD_U, r);
		name_struct (L->info.rp, s);
		return L->info.rp;
	}
	r = open_region (new_region (isst ? RECORD_S : RECORD_U, r));
	name_struct (r, -1);
	return r;
}

RegionPtr use_struct_tag (Symbol s, bool isst)
{
	RegionPtr r;
	lookup_t *L;
	for (r = current_region; ISRECORD (regions [r].kind);
		r = regions [r].parent);
	L = Lookup_foruse (s, true, r);
	if (L) return (L->kind == ENUMTAG) ? -1 : L->info.rp;
	L = new lookup_t (s, RECORD, r);
	L->incomplete = 1;
	return L->info.rp = new_region (isst ? RECORD_S : RECORD_U, r);
}

RegionPtr fwd_struct_tag (Symbol s, bool isst)
{
	RegionPtr r;
	lookup_t *L;
	for (r = current_region; ISRECORD (regions [r].kind);
		r = regions [r].parent);
	L = Lookup (s, true, r);
	if (L) return (L->kind == ENUMTAG) ? -1 : L->info.rp;
	L = new lookup_t (s, RECORD, r);
	L->incomplete = 1;
	return L->info.rp = new_region (isst ? RECORD_S : RECORD_U, r);
}

/*****************************************************************************
#	lookup_object
#
#	this is the kind of lookup needed in expressions.
#	expressions do not need: structure tags, typedefs, etc
#	but only objects or enumeration constants
#
#	for functions there is the additional rule that if a
#	declaration does not exist, it is implictly declared as
#	extern int f ();
#
#	for structure members it is the same but the lookup is
#	restricted only inside the scope and it does not do it's best
#	to find a matching declaration
*****************************************************************************/
lookup_object::lookup_object (Symbol s)
{
	lookup_t *L;

	if (!(L = Lookup_foruse (s, false, current_region)))
		half_error ("Undefined object", expand (s));

	if ((enumconst = L->kind == ENUMCONST)) {
		ec = L->info.eval;
		return;
	}

	typeID t = L->info.tdf;
	base = types.x [t].base;
	if (L->kind == OBJECT) {
		FRAME = L->cp;
		displacement = L->placement;
		intcpy (spec, types.x [t].spec);
	} else if (L->kind == EOBJECT) {
		FRAME = -1;
		displacement = 0;
		intcpy (spec, types.x [t].spec);
	} else if (L->kind == IFUNCTION || L->kind == EFUNCTION) {
		FRAME = -1;
		displacement = L->placement;
		spec [0] = '*';
		intcpy (spec + 1, types.x [t].spec);
	} else half_error ("Undefined object", expand (s));
}

lookup_function::lookup_function (Symbol s)
{
	lookup_t *L;

	if (!(L = Lookup_foruse (s, false, current_region))) {
		type t;
		spec [0] = '(', spec [1] = NoArgSpec, spec [2] = -1;
		base = t.base = S_INT;
		t.spec = spec;
		introduce_obj (s, gettype (t), EXTERN);
		FRAME = -1;
		displacement = 0;
	} else if (L->kind == EFUNCTION) {
		FRAME = -1;
		displacement = 0;
		typeID t = L->info.tdf;
		base = types.x [t].base;
		intcpy (spec, types.x [t].spec);
	} else if (L->kind == IFUNCTION) {
		FRAME = -1;
		displacement = L->placement;
		typeID t = L->info.tdf;
		base = types.x [t].base;
		intcpy (spec, types.x [t].spec);
	} else if (L->kind == EOBJECT || L->kind == OBJECT) {
		typeID t = L->info.tdf;
		if (types.x [t].spec [0] != '*'
		&&  types.x [t].spec [1] != '(')
			half_error ("Not a pointer to function", expand (s));
		base = types.x [t].base;
		intcpy (spec, types.x [t].spec + 1);
		FRAME = L->cp;
		displacement = L->placement;
	} else half_error ("Not a function", expand (s));
}

lookup_member::lookup_member (Symbol s, RegionPtr r)
{
	lookup_t *L = Lookup (s, false, r);

	if (!(L = Lookup (s, false, r)))
		half_error ("Undefined member", expand (s));

	displacement = L->placement;
	typeID t = L->info.tdf;
	base = types.x [t].base;
	intcpy (spec, types.x [t].spec);
}
/*****************************************************************************
#	sizeof
#
#	- esizeof_objptr (), is used for the case the sizeof the
#	base declarator is needed to compute the size of an incomplete
#	type from initializer. For example:
#
#		typedef struct { int x, y } foo;
#		foo bar [] = { 1, 2, 3, 4, 5, 6 };
#	were bar is array [3] of struct foo.
#
#	- sizeof_typeID (), is used by sizeof (typename)
#
#	- the function ptr_incremenet () take as an argument a type
#	which MUST be a pointer to something, and return how
#	much will the ++ operator on the pointer increase it.
******************************************************************************/
static bool just_count;

static const int sizez [] = {
	sizeof (char), sizeof (char), sizeof (short int), sizeof (short int),
	sizeof (int), sizeof (int), sizeof (long int), sizeof (long int),
	sizeof (long long), sizeof (long long), sizeof (float),
	sizeof (double), 0
};

static inline int sizeof_btype (BASETYPE b)
{
	return (just_count) ? 1 : sizez [b - S_CHAR];
}

static inline int sizeof_ptr ()
{
	return (just_count) ? 1 : sizeof (void*);
}

static int sizeof_struct (RegionPtr p)
{
	if (regions [p].incomplete)
		syntax_error (ExpressionPtr, "incomplete structure");
	return (just_count) ? regions [p].nn : regions [p].aligned_top;
}

static int sizeof_type (type &t)
{
	int i, na = 1, st, *spec = t.spec;

	if (spec [0] == '(') return 0;

	for (i = 0; spec [i] == '['; i += 2)
		na *= spec [i + 1];

	//if (!na) half_error ("sizeof Incomplete type attempted");

	st = (spec [i] == '*') ? sizeof_ptr ()
		: (T_BASETYPE (t)) ? sizeof_btype ((BASETYPE) t.base)
		: sizeof_struct (t.base);

	return na * st;
}

int sizeof_typeID (typeID ti)
{
	type t = types.x [ti];
	return sizeof_type (t);
}
// *************************************************

int esizeof_objptr (ObjPtr o)
{
	if (o < _BTLIMIT) return 1;

	just_count = true;
	int r = (o < TYPEDEF_BASE) ? sizeof_struct (o) :
		sizeof_typeID (o - TYPEDEF_BASE);
	just_count = false;
	return r;
}

int sizeof_type (int base, Vspec spec)
{
	type t;
	t.base = base;
	t.spec = spec;
	return sizeof_type (t);
}

int ptr_increment (int b, Vspec spec)
{
	type t;
	int tspec [50];

	if (spec [0] == -1)
		half_error ("invalid pointer arithmetic");

	t.base = b;
	intcpy (tspec, spec [0] == '*' ? spec + 1: spec + 2);
	t.spec = tspec;

	return sizeof_type (t);
}

/*****************************************************************************
#
#	initialization of various things
#
*****************************************************************************/
void init_cdb ()
{
	lookup_table = new lookup_t* [C_Nsyms];
	for (int i = 0; i < C_Nsyms; i++)
		lookup_table [i] = NULL;

	// global, region 0, parent of self, etc
	open_region (GLOBAL, 0);
	INGLOBAL = true;

	// Void type
	int x [1];
	x [0] = -1;
	type t = { VOID, &x[0] };
	VoidType = newtype (t);
	t.base = S_INT;
	SIntType = newtype (t);

	// argument list with no arguments --old style
	typeID ta [2];
	ta [0] = ARGLIST_OPEN; ta [1] = -1;
	NoArgSpec = make_arglist (ta);

#define DEFBUILTIN(B, S1, S2, S3, S4, T) \
	if (ccbuiltins.bt ## B!= -1) {\
		int s [] = { S1, S2, S3, S4 }; type t;\
		t.base = T; t.spec = s;\
		introduce_obj (ccbuiltins.bt ## B, gettype (t), STATIC);\
	}

	DEFBUILTIN(__FUNCTION__, '*', -1, -1, -1, S_CHAR)
	DEFBUILTIN(__PRETTY_FUNCTION__, '*', -1, -1, -1, S_CHAR)
	DEFBUILTIN(__builtin_return_address, '(', NoArgSpec, '*', -1, VOID)
}

//
// this routine here, shows what is included in the lookup table ---
// useful for debugging cdb
//

void show_lookups ()
{
	lookup_t *L;
	int i;

	for (i = 0; i < C_Nsyms; i++) {
		printf ("* * * * * Symbol [%s]\n", C_Syms [i]);
		for (L = lookup_table [i]; L; L = L->next) {
		printf ("- Inside %i: ", L->cp);
		switch (L->kind) {
		case RECORD:
			printf ("Record no %i\n", L->info.rp);
			break;
		case ENUMTAG:
			printf ("Enumeration tag\n");
			break;
		case TYPEDEF:
			printf ("typedef\n");
			printtype (L->info.tdf);
			break;
		case OBJECT:
		case EOBJECT:
			printf ("variable %i\n", L->placement);
			printtype (L->info.tdf);
			break;
		case ENUMCONST:
			printf ("enumeration constant %i\n", L->info.eval);
			break;
		case EFUNCTION:
		case IFUNCTION:
			printf ("function %i\n", L->placement);
			printtype (L->info.tdf);
			break;
		default:;
		} }
	}
}

/*****************************************************************************

*****************************************************************************/

void showdb ()
{
//show_lookups ();
printf ("#%i types\n", types.nr);
printf ("#%i arglists\n", arglists.nr);
printf ("#%i regions\n", regions.nr ());
printf ("#%i function definitions\n", functions.nr);

}

//****************************************************************************
//	debugging routine, print a type
//****************************************************************************

#define U "unsigned "
#define S "short "
#define L "long "
#define I "int"
#define C "char"

static const char *btn [] = {
	C, U C, S I, U S I, I, U I, L I,
	U L I, L L, U L L, "float", "double", "void"
};

void printtype (int base, int *spec)
{
#define STDE stdout
	int i;
	if (base < _BTLIMIT) fprintf (STDE, "%s ", btn [base - S_CHAR]);
	else fprintf (STDE, "record #%i ", base);
	for (i = 0; spec [i] != -1; i++)
		if (spec [i] == '*') fprintf (STDE, "*");
		else if (spec [i] == '[')
			fprintf (STDE, "[%i]", spec [++i]);
		else if (spec [i] == '(')
			fprintf (STDE, "(%i)", spec [++i]);
		else if (spec [i] == ':')
			fprintf (STDE, ":%i", spec [++i]);
		else { printf ("fuck %i", spec [i]); break; }
	fprintf (STDE, "\n");
}

void printtype (typeID ti)
{
	type t = types.x [ti];
	printtype (t.base, t.spec);
}
