/*---------------------------------------------
**
** Header file for node processor functions
**
** Copyright (c) 1994 by Jim Patchell
**
**-------------------------------------------*/

#ifndef NODEPROC__H
#define NODEPROC__H

#ifdef __cplusplus
extern "C" {
#endif

extern FILE *OutFile;

	enum ass_ops {ASSOP_EQUALS,ASSOP_ADD,ASSOP_SUB,ASSOP_MUL,ASSOP_DIV,
			ASSOP_MOD,ASSOP_OR,ASSOP_AND,ASSOP_XOR,ASSOP_SHL,ASSOP_SHR};

extern value *(*node_proc[])(NODE *n);
extern value *process_tree(NODE *n);
extern int EvalConstExp(NODE *n);
extern void NodeSetDebug(int v);

#ifdef __cplusplus
}
#endif

#endif
