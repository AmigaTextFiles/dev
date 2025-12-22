/** 
* @author Riccardo Manfrin [namesurname at gmail dot com]
* @brief  Parser methods definition
*/
 
#ifndef __LIB_PARSE_H__
#define __LIB_PARSE_H__
#include "btree.h"
#include "list.h"

#define expr2val atof
#define parser_val_t float

typedef struct{
	list  *vars;
	list  *lfunctions;
	btree *pstruct;
	void  *data;
} parser;

 /**
  * Here we define new functions to be used within the 
  * expression to parse.
  * Each new function must be in the form
  * 
  * 	"my_new_function(myvar1,var2,3)"
  *
  * while the explaination must be 
  * 
  * 	"myvar1+myvar2/3"
  *
  * Functions explaination can contain other functions 
  * as long as these are already defined.
  *
  * The function returns 0 upon successful completition
  * or -1 in case of errors
  */
int parser_func(parser *p, char *function, char *replacement_expr);

 /**
  * Here we define the variables that will be used within
  * the mathematical expression to solve.
  * Calling the function multiple times on the same 
  * variable will just update its value.
  *
  * The function returns 0 upon successful completition
  * or -1 in case of errors
  */
int parser_var(parser *p, char *var, parser_val_t value);


/**
 * This function is used to generate a new parser based on
 * the mathematical expression provided as argument.
 */
parser * parser_new();

 /**
  * This function must be called on the root and
  * processes the tree until it is complete;
  * The way it works is to expand the root and proceed
  * with the leaf nodes as long as the algorithm find
  * leaf nodes to expand.
  * This function makes use of the btree dispatcher and
  * of recursion to work things out.
  */
void parser_expand(parser *p, char *expr);

 /**
  * Calculate the result of the expression
  */
parser_val_t parser_calc(parser *p, char *expr);

 /**
  * Destroyer to invoke when done with parsing
  */
void parser_destroy(parser *p);

#endif
