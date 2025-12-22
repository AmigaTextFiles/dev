/*
 * structure for lvalue's - (cclvalue.h)
 *
 * $Id: lvalue.h 1.2 1999/03/18 01:14:26 djm8 Exp $
 */

struct lvalue {
        SYMBOL *symbol ;                /* symbol table address, or 0 for constant */
        int indirect ;                  /* type of indirect object, 0 for static object */
        int ptr_type ;                  /* type of pointer or array, 0 for other idents */
        int is_const ;                  /* true if constant expression */
        long const_val ;                        /* value of constant expression (& other uses) */
        TAG_SYMBOL *tagsym ;    /* tag symbol address, 0 if not struct */
        int (*binop)() ;                /* function address of highest/last binary operator */
        char *stage_add ;               /* stage addess of "oper 0" code, else 0 */
        int val_type ;                  /* type of value calculated */
        char flags ;                    /* As per symbol */
        int type;                       /* type (from symbol table) */
	int ident;			/* ident (from symbol table) */
} ;

#define LVALUE struct lvalue
