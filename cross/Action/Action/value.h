/*-> (C) 1990 Allen I. Holub                                                */
/* VALUE.H:	Various definitions for (l|r)values. "symtab.h" must be
 *		#included before #including this file.
 */
#ifndef VALUE__H
#define VALUE__H

#define BYTE_WIDTH	1	/* Widths of the basic types.	      */
#define WORD_WIDTH	2
#define LWORD_WIDTH	4
#define PTR_WIDTH	2
#define ALIGN_WORST	1
#define SWIDTH	1

#define VALNAME_MAX (NAME_MAX * 2)     /* Max. length of string in value.name */

typedef struct value
{
    char     name[ VALNAME_MAX ]; /* Operand that accesses the value.	    */
    link     *type;		  /* Variable's type (start of chain).	    */
    link     *etype;		  /* Variable's type (end of chain).	    */
    symbol   *sym;		  /* Original symbol.			    */
    unsigned lvalue   :1;	  /* 1 = lvalue, 0 = rvalue.		    */
    unsigned is_tmp   :4;	  /* 1 if a temporary variable.		    */
	unsigned ValLoc:3;		// where the value is located
    unsigned offset;	  /* Absolute value of offset from base of  */
				  /* temporary region on stack to variable. */
} value;


#define VALUE_IN_MEM		0	//value is located in a variable location
#define VALUE_IN_TMP		1	//value is located in a temporary location
#define VALUE_IN_A			2	//value is located in accumulator (byte and bool)
#define VALUE_IS_CONSTANT	3	//indicates that the value is a constant
#define VALUE_POINT_TO		4	//A temp points to the value
#define VALUE_IN_MEM_INDX	5	//used to access arrays
#define VALUE_IN_TMP_INDX	6	//used to access arrays

#define LEFT  1		     /* Second argument to shift_name() in value.c, */
#define RIGHT 0		     /* 			   discussed below. */

#define CONST_STR(p) tconst_str((p)->type)   /* Simplify tconst_str() calls */
					     /* with value arguments by     */
					     /* extracting the type field.  */
/**********************************************************************
**                                                                   **
** function prototypes                                               **
**                                                                   **
**********************************************************************/
#ifdef __cplusplus
extern "C" {
#endif

extern value	*new_value(void);
extern void discard_value(value *p );
extern char *shift_name(value *val,int left );
extern char *rvalue(value *val );
extern char *rvalue_name(value *val );
extern value *tmp_create(link *type,int add_pointer );
extern char *get_prefix(link *type );
extern value *tmp_gen(link *tmp_type,value *src );
extern char *convert_type(link *targ_type,value *src );
extern int	get_size(link *type );
extern char *get_suffix(link *type );
extern void	release_value(value *val );
extern value  *make_icon(char *yytext,int numeric_val );
extern value *make_int(void);
extern value *make_scon(void);

#ifdef __cplusplus
}
#endif

#endif

