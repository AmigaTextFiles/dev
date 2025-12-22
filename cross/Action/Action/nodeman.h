/*
** Header file for node manager
**
** Copyright (c) 1994 Jim Patchell
**
*/

#ifndef NODEMAN__H
#define NODEMAN__H

#ifdef __cplusplus
extern "C" {
#endif

#define NODECHUNK	10		/*	number of nodes allocated at a time	*/

typedef struct node {
	int numb;			//for debug purposes, can see who's next
	int id;
	void *aux;
	struct symbol *symb;
	struct node *next;
	struct node *down;
} NODE;

typedef struct {
	char *LabFalse;
	char *LabTrue;
}RELOP_D;

typedef struct pool {
	NODE *mem;
	struct pool *next;
}POOL;

//-------------------------------------------------------------------------
// function prototypes
//-------------------------------------------------------------------------

extern NODE *NewNode(void);		//create a new AST node
extern void DiscardNode(NODE *n);	//discard an AST node
extern void DiscardTree(NODE *n);	//discard an entire tree
extern int FreeNodes(void);		//free all nodes in pool
extern NODE *MakeNode(int id,NODE *n1,NODE *n2);
extern NODE *MakeLeaf(int id,void *n1,void *n2);
extern NODE *MakeList(NODE *n,NODE *n1);
extern void print_tree(NODE *n);

#ifdef __cplusplus
}
#endif

#endif //NODEMAN__H
