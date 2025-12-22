MODULE	'exec/nodes'

/* the structure in the pr_LocalVars list */
/* Do NOT allocate yourself, use SetVar()!!! This structure may grow in */
/* future releases!  The list should be left in alphabetical order, and */
/* may have multiple entries with the same name but different types.	*/

OBJECT LocalVar
	Node:LN,
	Flags:UWORD,
	Value:PTR TO UBYTE,
	Len:ULONG

/*
 * The lv_Flags bits are available to the application.	The unused
 * lv_Node.ln_Pri bits are reserved for system use.
 */

/* bit definitions for lv_Node.ln_Type: */
#define LV_VAR			0	/* an variable */
#define LV_ALIAS		1	/* an alias */
/* to be or'ed into type: */
#define LVB_IGNORE		7	/* ignore this entry on GetVar, etc */
#define LVF_IGNORE		$80

/* definitions of flags passed to GetVar()/SetVar()/DeleteVar() */
/* bit defs to be OR'ed with the type: */
/* item will be treated as a single line of text unless BINARY_VAR is used */
#define GVB_GLOBAL_ONLY		8
#define GVF_GLOBAL_ONLY		$100
#define GVB_LOCAL_ONLY		9
#define GVF_LOCAL_ONLY		$200
#define GVB_BINARY_VAR		10		/* treat variable as binary */
#define GVF_BINARY_VAR		$400
#define GVB_DONT_NULL_TERM	11	/* only with GVF_BINARY_VAR */
#define GVF_DONT_NULL_TERM	$800

/* this is only supported in >= V39 dos.  V37 dos ignores this. */
/* this causes SetVar to affect ENVARC: as well as ENV:.	*/
#define GVB_SAVE_VAR		12	/* only with GVF_GLOBAL_VAR */
#define GVF_SAVE_VAR		$1000
