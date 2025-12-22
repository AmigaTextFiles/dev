#include "config.h"
#include "norm.h"
#include "stack.h"
#define MSPEC 20
#define BITFIELD_Q 32

//
// the types we'll be using
//
typedef int NormPtr;
typedef int RegionPtr, ObjPtr, typeID, ArglPtr, Symbol, *Vspec;
typedef int exprID;


//
// preprocessing
//
extern void preproc (int, char**);


//
// program options
//
extern bool usage_only, include_values, unique_vars, tdmap_fmt;
extern char *sourcefile;


//
// inform
//
extern FILE *output;
extern char* StrDup (char*);
extern void debug (char*, NormPtr, int);
extern void prcode (NormPtr, int);
extern void printtype (int, int*);
extern void printtype (typeID);
extern int syntax_error (NormPtr, char* = NULL);
extern int syntax_error (char*, char*);
extern int syntax_error (NormPtr, char*, char*);
extern void half_error (char*, char* = NULL);
extern void warning (char*, char = 0);
extern char *expand (int);
class EXPR_ERROR {public: EXPR_ERROR () {}};


//
// lex & normalized C source
//
struct token
{
	unsigned int type;
	char *p;
	int len;
};
extern token CTok;

struct cfile_i
{
	int	indx;
	char	*file;
};

extern int*		CODE;
extern int		C_Ntok;
extern char**		C_Syms;
extern int		C_Nsyms;
extern char**		C_Strings;
extern int		C_Nstrings;
extern cfile_i*		C_Files;
extern int		C_Nfiles;

extern double*		C_Floats;
extern signed char*	C_Chars;
extern short int*	C_Shortints;
extern long int*	C_Ints;
extern unsigned long*	C_Unsigned;

extern struct __builtins__ {
	int bt__builtin_return_address;
	int bt__FUNCTION__;
	int bt__PRETTY_FUNCTION__;
} ccbuiltins;

extern void enter_token ();
extern void enter_file_indicator (char*);
extern void prepare ();
extern void make_norm ();
extern int getint (int);
extern void yynorm (char*, int);


//
// utilities
//
extern void	intcpycat (int*, int*, int*);
extern int*	intdup (int*);
extern int	intcmp (int*, int*);
extern void	intncpy (int*, int*, int);
extern inline	void intcpy (int *d, int *s) { while ((*d++ = *s++) != -1); }
extern inline int intlen (int *i) { int l=0; while (*i++ != -1) l++; return l; }


//
// the compilation
//
extern void parse_C ();


//
// CDB interface
//
enum VARSPC {
	EXTERN, STATIC, DEFAULT
};

typedef bool Ok;

extern typeID VoidType, SIntType;

enum BASETYPE {
	S_CHAR = -20, U_CHAR, S_SINT, U_SINT, S_INT, U_INT,
	S_LINT, U_LINT, S_LONG, U_LONG, FLOAT, DOUBLE, VOID,
	_BTLIMIT
};
#define INTEGRAL(x) (x >= S_CHAR && x <= U_LONG)
#define TYPEDEF_BASE 50000

struct type {
	int base;
	Vspec spec;
};
#define ISFUNCTION(t) ((t).spec [0] == '(')
#define T_BASETYPE(t) ((t).base < _BTLIMIT)
#define T_BASETYPEDEF(t) ((t).base >= TYPEDEF_BASE)
#define T_BASESTRUCT(t) (t > 0 && t < TYPEDEF_BASE)

#define ARGLIST_OPEN -2
#define SPECIAL_ELLIPSIS -3

#define INCODE (!INGLOBAL && !INSTRUCT)
extern bool INGLOBAL, INSTRUCT;
extern ArglPtr NoArgSpec;
extern void init_cdb ();
extern typeID		gettype (type&);
extern ArglPtr		make_arglist (typeID*);
extern typeID*		ret_arglist (ArglPtr);
extern void		opentype (typeID, type&);
extern int		esizeof_objptr (ObjPtr);
extern int		sizeof_typeID (typeID);
extern int		sizeof_type (int, Vspec);
extern int		ptr_increment (int, Vspec);
extern Ok		introduce_obj (Symbol, typeID, VARSPC);
extern Ok		introduce_tdef (Symbol, typeID);
extern ObjPtr		lookup_typedef (Symbol);
extern Ok		introduce_enumconst (Symbol, int);
extern Ok		introduce_enumtag (Symbol);
extern Ok		valid_enumtag (Symbol);
extern RegionPtr	introduce_struct_dcl (Symbol, bool);
extern RegionPtr	use_struct_tag (Symbol, bool);
extern RegionPtr	fwd_struct_tag (Symbol, bool);
extern Ok		function_definition (Symbol, NormPtr, NormPtr);
extern Ok		function_no (int, NormPtr*, NormPtr*);
extern void		open_compound ();
extern void		close_region ();
extern const char*	struct_by_name (RegionPtr);
extern void		functions_of_file ();

//
// CDB lookups
//
struct lookup_object {
	bool enumconst;
	int ec;
	ObjPtr base;
	RegionPtr FRAME;
	int displacement;
	int spec [50];
	lookup_object (Symbol);
};

struct lookup_function {
	ObjPtr base;
	RegionPtr FRAME;
	int displacement;
	int spec [50];
	lookup_function (Symbol);
};

struct lookup_member {
	ObjPtr base;
	int spec [50];
	int displacement;
	lookup_member (Symbol, RegionPtr);
};


//
// cc-expressions
//
enum COPS {
	VALUE, FVALUE, SVALUE, UVALUE, AVALUE,
	SYMBOL,
	FCALL, ARRAY, MEMB,
	PPPOST, MMPOST,
	PPPRE, MMPRE, LNEG, OCPL, PTRIND, ADDROF, UPLUS, UMINUS, CAST, SIZEOF,
	MUL, DIV, REM, ADD, SUB, SHL, SHR,
	BEQ, BNEQ, CGR, CGRE, CLE, CLEE,
	BAND, BOR, BXOR,
	IAND, IOR,
	COND, // assignments taken from norm.h defines
	COMMA, ARGCOMMA,
	COMPOUND_RESULT
};

struct subexpr
{
	int action;
	union {
		int using_result;
		long int value;
		unsigned long int uvalue;
		double fvalue;
		Symbol symbol;
		exprID e;
	} voici;
	exprID e;
	union {
		typeID cast;
		Symbol member;
		exprID eelse;
	} voila;
};

struct exprtree
{
	subexpr *ee;
	int ne;
	exprID first;
};

extern exprtree	CExpr;
extern int	last_result;
extern subexpr	*&ee;
extern NormPtr	ExpressionPtr;
extern typeID	typeof_expression ();


//
// different behaviour of the compiler
//
extern class ncci
{
	public:
	virtual void cc_expression () = 0;
	virtual int  cc_int_expression () = 0;
	virtual void new_function (Symbol) = 0;
	virtual void inline_assembly (NormPtr, int) = 0;
} *ncc;

extern void set_compilation ();
extern void set_usage_report ();
