#ifndef RECOGNIZED_H
#define RECOGNIZED_H

/**
 * We don't consider constants and variables. Only single-operand operators and
 * double-operands operators.
 * To us constants and variables are handled a different way: we shall priorize 
 * variables definitions.
 * We shall assign eventual constant values to those variables that miss a value 
 * assignement (those that are not explicitly defined as variables, while are 
 * defined as constant). This behavior allows constant definitions  override by 
 * variables definitions.
 */

#include "btree.h"
#include "list.h"

typedef int op_id;

struct operation {
	op_id  id;
	char 	*op;
	btree *(* expand_fptr)(struct operation *me, btree **btnodesarray, list *tk_indexes);
};

/**
 *	Priority in OP_ID is fundamental and is based on the logical priority 
 *	in operations calculus, that states for instance that
 * the SUM op_id comes before the SUB or the others.
 */

//			NAME			OP_ID (and priority)
#define	SUM			0
#define	SUB			1
#define EXP         2
#define	MULT		3
#define	DIV			4
#define	MOD			5
#define	COS			6
#define	SIN			7
#define	ATAN		8
#define	TAN			9
#define	NEP			10
#define	LOGN		11
#define	LOG2		12
#define	LOG10		13
//This confines the number of operators
#define	NOTOP		14

//			NAME			OP (string)
#define	SUM_OP 		"+"
#define	SUB_OP 		"-"
#define EXP_OP		"^"
#define	MULT_OP 	"*"
#define	DIV_OP 		"/"
#define	MOD_OP		"%"
#define	COS_OP 		"cos"
#define	SIN_OP 		"sin"
#define	ATAN_OP	 	"atan"
#define TAN_OP 		"tan"
#define	NEP_OP 	 	"exp"
#define	LOGN_OP	 	"logn"
#define	LOG2_OP	 	"log2"
#define	LOG10_OP	"log10"

static struct operation operation[NOTOP];

#endif
