/*
** Node manager for ANAGRAM parsers
** copyright (c) 1994 Jim Patchell
**
** This is a library of routines for generating Abstract SYNTAX trees
*/

#include <stdio.h>
#include <stdlib.h>
//#include <mem.h>
#include <string.h>
#include "symtab.h"
#include "nodeman.h"

static POOL *nodechunks = NULL;		/*	pointer to list of node chunks	*/
static NODE *nodelist = NULL;			/*	list of nodes in pool			*/
static int n_nodes = 0;         /*	number of nodes allocated		*/
static int nodenumber = 0;

const char *nnames[] = {
	"EQUALS",		//0
	"MULEQ",       //1
	"DIVEQ",		//2
	"MODEQ",		//3
	"ADDEQ",		//4
	"SUBEQ",       //5
	"ANDEQ",		//6
	"OREQ",		//7
	"XOREQ",		//8
	"LSHEQ",		//9
	"RSHEQ",		//10
	"OR",			//11
	"AND",			//13
	"BITOR",		//13
	"BITXOR",		//14
	"BITAND",		//15
	"EQ",			//16
	"NE",			//17
	"LT",			//18
	"GT",			//19
	"LTE",			//20
	"GTE",			//21
	"LSH",			//22
	"RSH",			//23
	"ADD",			//24
	"SUB",			//25
	"MUL",			//26
	"DIV",			//27
	"MOD",			//28
	"COMPLEMENT",	//29
	"ADDRESSOF",	//30
	"CONTENTSOF",	//31
	"NEGATIVE",	//32
	"CODEBLOCK",		//33
	"MEMBER",		//34
	"FUNCCALL",	//35
	"ARGUMENTS",	//36
	"CONSTANT",	//37
	"IDENT",		//38
	"STRING",		//39
	"FOR",			//40
	"DOLOOP",		//41
	"WHILE",		//42
	"IF",			//43
	"ELSEIF",		//44
	"ELSE",		//45
	"RETURN",		//46
	"UNTIL",		//47
	"EXIT",		//48
	"STEP",		//49
	"PROC",		//50
	"FUNC",		//51
	"IFSTMT",		//52
	"FORSTART",	//53
	"FORTO",		//54
	"ARRAYREF	",	//55
	"PROCCALL",	//56
	"PROCIDENT",	//57
	"PROCLOCALS",	//58
	"FORDOLOOP",	//59
	"WHILEDOLOOP",	//60	
	NULL
};

NODE *NewNode(void)
{
	//----------------------------------------------------------------
	// returns a pointer to a node element
	//----------------------------------------------------------------

	NODE *t;
	POOL *p;
	int i;

	if(nodelist == NULL)	/*	anything in list?	*/
	{
		/*	allocate a bunch of nodes	*/
		if( (p= (POOL *)calloc(1,sizeof(POOL)) ) == NULL)
			return NULL;		//could not allocate pool element
		if((t = (NODE *)calloc(NODECHUNK,sizeof(NODE)) ) == NULL)
			return NULL;		//could not allocate NODE chunk
		p->next = nodechunks;
		nodechunks = p;
		p->mem = t;		/*	record block of allocated node chunks	*/
		for(i=0;i<NODECHUNK;++i)
		{
			t->next = nodelist;
			nodelist = t;
			++t;
		}
	}
	t = nodelist;
	nodelist = t->next;	/*	strip out element	*/
	++n_nodes;		/*	increment allocated node list	*/
	memset(t,0,sizeof(NODE));
	return(t);
}

void DiscardNode(NODE *n)
{
	//----------------------------------------------------
	// this function puts a node back into the node list
	//----------------------------------------------------
	n->next = nodelist;
	nodelist = n;
	--n_nodes;	//decrement number of nodes allocated
}

void DiscardTree(NODE *n)
{
	/*	this function discards an entire syntax tree	*/
	if(n == NULL)
		return;
	if(n->down != NULL)
		DiscardTree(n->down);
	if(n->next != NULL)
		DiscardTree(n->next);
	DiscardNode(n);
}

static void FreeChunks(POOL *p)
{
	if(p->next != NULL)
		FreeChunks(p->next);
	free(p->mem);	/*	free NODE chunk	*/
	free(p);		/*	free POOL node	*/
}

int FreeNodes(void)
{
	//----------------------------------------------------
	// frees all memory allocated by NewNode
	// If there are any outstanding nodes, function returns
	// non zero number, zero if memory is freed
	//----------------------------------------------------

	if(n_nodes)
		return n_nodes;		//memory still in use error
	FreeChunks(nodechunks);
    return 0;
}

NODE *MakeNode(int id, NODE *n1, NODE *n2)
{
	/****************************************************************
	**
	** MakeNode
	**
	** Paramerters:
	**	id.......Node type, i.e. NODE_ADD, NODE_FOR...etc
	**	n1.......pointer to down node
	**	n2.......pointer to next node
	** Returns:
	**	pointer to new node
	**
	****************************************************************/

	NODE *n;
	NODE *t;

	if((n = NewNode()) == NULL)
	{
		fprintf(stderr,"ERROR:Could Not Create New AST node\n");
		exit(1);
	}
	n->down = n1;	//set down node
	t = n1;
	if(t)
	{
		while(t->next != NULL)
			t = t->next;	//look for end of NODE list
		t->next = n2;		//put the next node at the end of the list
	}
	else
			n->next = NULL;
	n->id = id;			//set the ID
	n->numb = ++nodenumber;	//node number (for DEBUG)
	return(n);
}

NODE *MakeLeaf(int id, void *n1, void *n2)
{
	NODE *n;

	if((n = NewNode()) == NULL)
	{
		fprintf(stderr,"ERROR:Could Not Create New AST node\n");
		exit(1);
	}
	n->next = NULL;
	n->down = NULL;
	if(n1 != NULL)
		n->symb = (symbol *)n1;
	n->aux = n2;
	n->id = id;
	n->numb = ++nodenumber;
	return(n);
}

NODE *MakeList(NODE *n, NODE *n1)
{
	/*
	** This function makes a list of nodes, starting with node n
	** Node n1 is attached to end of list
	*/
	NODE *t;

	t = n;
	while(t->next != NULL)
	{
		t = t->next;
	}
	t->next = n1;
	return(n);
}

//----------------------------------------------------------------------
// routines for printing out abstract SYNTAX tree's
//----------------------------------------------------------------------

static void PrintNode(char *d, NODE *n)
{
	int down,next;

	if(n->down == NULL)
		down = -1;
	else
		down = n->down->numb;
	if(n->next == NULL)
		next = -1;
	else
		next = n->next->numb;
	printf(";\t %4d %4d %4d %s%s %s\n",n->numb,down,next,d,nnames[n->id],n->symb?n->symb->name:"");
}

static void Trav(char *d,NODE *n)
{
	while(n->next != NULL)	/*	while next pointer points to valid node	*/
	{
		strcat(d,"+-");
		PrintNode(d,n);
		d[strlen(d)-2] = '\0';
		if(n->down != NULL)	/*	Does Down pointer point to Something?	*/
		{
			strcat(d,"| ");
			Trav(d,n->down);	/*	Traverse the Down Node	*/
			d[strlen(d)-2] = '\0';
		}
		n = n->next;
	}
	strcat(d,"+-");
	PrintNode(d,n);
	d[strlen(d)-2] = '\0';
	if(n->down != NULL)
	{
		strcat(d,"  ");
		Trav(d,n->down);
		d[strlen(d)-2] = '\0';
	}
}

void print_tree(NODE *n)
{
	/*	prints out a syntax tree	*/
	char *d;

	if(n != NULL)
	{
		d = malloc(512);
		memset(d,0,512);
		printf("\t NUMB DOWN NEXT\n");
		Trav(d,n);
		free(d);
	}
}
