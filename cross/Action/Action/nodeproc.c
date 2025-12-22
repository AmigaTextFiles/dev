/*************************************************************************
**                                                                      **
** These are the node processor routines                                **
**                                                                      **
** Copyright (c) 1994 by Jim Patchell                                   **
**                                                                      **
** This code was orignially started back in 1994 or so....now in 2003 I **
** pick it back up  ...and again in 2010 :-)                                                    **
*************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "nodeid.h"
#include "symtab.h"
#include "nodeman.h"
#include "value.h"
#include "codegen.h"
#include "gen.h"
#include "nodeproc.h"
#include "temp.h"
#include "misc.h"

/* Misc Global variables */
static int	do_binary_const(value **v1p,int op, value **v2p );
extern const char *nnames[];
STACK *ExitStack;
STACK *DoLoopStack;
STACK *IfStack;
FILE *OutFile;

extern value *(*node_proc[])(NODE *n);
static int ConstantExpression = 0;
static int Debug;
/*
** node processor routines
*/

static char *assop_strings[] = {
	"equals",
	"add",
	"sub",
	"mul",
	"div",
	"mod",
	"or",
	"and",
	"xor",
	"shl",
	"shr",
	NULL

};


enum bin_ops {BINOP_ADD,BINOP_SUB,BINOP_MUL,BINOP_DIV,BINOP_MOD,
			BINOP_OR,BINOP_AND,BINOP_XOR,BINOP_SHL,BINOP_SHR,
			BINOP_OROR,BINOP_ANDAND,BINOP_NE,BINOP_EQ,BINOP_LT,BINOP_GT,
			BINOP_LE,BINOP_GE};

static char *binop_strings[] = {
	"add",
	"sub",
	"mul",
	"div",
	"mod",
	"or",
	"and",
	"xor",
	"shl",
	"shr",
	"||",
	"&&",
	"ne",
	"eq",
	"lt",
	"gt",
	"lte",
	"gte",
	NULL
};

static int binop_ops[] = {'+','-','*','/','%','|','&','^','<','>'};

static int NotRelOp(int op)
{
	int rv = 0;
	switch(op)
	{
	case BINOP_ADD:
	case BINOP_SUB:
	case BINOP_MUL:
	case BINOP_DIV:
	case BINOP_MOD:
	case BINOP_OR:
	case BINOP_AND:
	case BINOP_XOR:
	case BINOP_SHL:
	case BINOP_SHR:
	case BINOP_OROR:
	case BINOP_ANDAND:
		rv = 1;
		break;
	case BINOP_NE:
	case BINOP_EQ:
	case BINOP_LT:
	case BINOP_GT:
	case BINOP_LE:
	case BINOP_GE:
		rv = 0;
		break;
	}
	return rv;
}

/*-----------------------------------------------------------------------
**
** Assignment operators
**
**---------------------------------------------------------------------*/


static value *assop(NODE *n,int op)
{
	NODE *n1,*n2;		/*	child nodes	*/
	value *v1,*v2;      /*	values returned from processor nodes	*/
	value *rV;

	n1 = n->down;
	n2 = n1->next;
	if(Debug)   printf("ASSIGNOP = %s:n=%d  n1=%d  n2=%d\n",assop_strings[op],n->numb,n1->numb,n2->numb);
	v1 = (node_proc[n1->id])(n1);		/*	process nodes	*/
	n2->aux = v1;		//let binary processing nodes know
						//where the lvalue is going
	v2 = (node_proc[n2->id])(n2);
	if(v1 !=  v2)
		rV = DoAssign(OutFile,v1,v2,op,1,1);
	else
		rV = v2;
	return rV;
}

static value *np_EQUALS(NODE *n)
{
	return assop(n,ASSOP_EQUALS);
}

static value *np_MULEQ(NODE *n)
{
	return assop(n,ASSOP_MUL);
}

static value *np_DIVEQ(NODE *n)
{
	return assop(n,ASSOP_DIV);
}

static value *np_MODEQ(NODE *n)
{
	return assop(n,ASSOP_MOD);
}

static value *np_ADDEQ(NODE *n)
{
	return assop(n,ASSOP_ADD);
}

static value *np_SUBEQ(NODE *n)
{
	return assop(n,ASSOP_SUB);
}

static value *np_LSHEQ(NODE *n)
{
	return assop(n,ASSOP_SHL);
}

static value *np_RSHEQ(NODE *n)
{
	return assop(n,ASSOP_SHR);
}

static value *np_ANDEQ(NODE *n)
{
	return assop(n,ASSOP_AND);
}

static value *np_OREQ(NODE *n)
{
	return assop(n,ASSOP_OR);
}

static value *np_XOREQ(NODE *n)
{
	return assop(n,ASSOP_XOR);
}

/*-------------------------------------------------------------------------
**
** Binary operators
**
**------------------------------------------------------------------------*/

static value *binary(NODE *n,int op)
{
	NODE *n1,*n2;		/*	child nodes	*/
	value *v1,*v2;      /*	values returned from processor nodes	*/
	value *rV = NULL;
	value *Lv;		//left value
	
	if(Debug) printf("BINOP=%s\n",binop_strings[op]);
	n1 = n->down;
	n2 = n1->next;
	Lv = (value *)n->aux;
	if(Lv) fprintf(stderr,"Levft Value is %s\n",Lv->name);
	v1 = (node_proc[n1->id])(n1);		/*	process nodes	*/
	v2 = (node_proc[n2->id])(n2);
	if(v1 && v2)	//good values?
	{
//printf("VALUE1 %s  VALUE2 %s\n",v1->name,v2->name);
		if(do_binary_const(&v1,binop_ops[op],&v2) )		/*	was this a const	*/
		{
			release_value(v2);
			if(Debug) printf("VALUE=%d\n",v1->type->V_INT);
			rV = v1;
		}
		else
		{
			if( (SizeOfRef(v1->type) != SizeOfRef(v2->type)) && (!IS_CONSTANT(v1->type) && !IS_CONSTANT(v2->type) ) )
			{
				//----------------------------
				//OK, these guys are not the
				//smae size and they need to
				// be in order to combine them
				//----------------------------
				if(SizeOfRef(v1->type) > SizeOfRef(v2->type))
				{
					v2 = ConvertTypeUp(OutFile,v2,v1->type);
					//---------------------------
					// this operation leaves the
					// in registers if v2 is not
					// a long. so we need to save
					// v2 to a temp otherwise
					//--------------------------
				}
				else if (SizeOfRef(v2->type) > SizeOfRef(v1->type))
				{
					v1 = ConvertTypeUp(OutFile,v1,v2->type);
				}
			}
			if(ValInMem(v1) && !ValInMem(v2))
			{
				if(NotRelOp(op))	//we can swap operands
				{
					value *t;
					t = v1;
					v1 = v2;
					v2 = t;		//swap around the args
				}
				else
				{
					v2 = SaveToTemp(OutFile,v2);	//put in temp
				}
			}
			else if (!ValInMem(v1) && !ValInMem(v2))
			{
				v2 = SaveToTemp(OutFile,v2);	//put V2 in a temp
			}
			rV = DoBinary(OutFile,v1,op,v2,1,1,NULL,NULL,Lv);
//			release_value(v2);
		}
	}
	return rV;
}

static value *np_BITOR(NODE *n)
{
	return binary(n,BINOP_OR);
}

static value *np_BITXOR(NODE *n)
{
	return binary(n,BINOP_XOR);
}

static value *np_BITAND(NODE *n)
{
	return binary(n,BINOP_AND);
}

static value *np_LSH(NODE *n)
{
	return binary(n,BINOP_SHL);
}

static value *np_RSH(NODE *n)
{
	return binary(n,BINOP_SHR);
}

static value *np_ADD(NODE *n)
{
	return binary(n,BINOP_ADD);;
}

static value *np_SUB(NODE *n)
{
	return binary(n,BINOP_SUB);
}

static value *np_MUL(NODE *n)
{
	return binary(n,BINOP_MUL);
}

static value *np_DIV(NODE *n)
{
	return binary(n,BINOP_DIV);
}

static value *np_MOD(NODE *n)
{
	return binary(n,BINOP_MOD);
}

/*-------------------------------------------------------------------------
**
** Logical operators
**
**-----------------------------------------------------------------------*/

static value *np_OR(NODE *n)
{
	//-----------------------------------------
	// Now, the rubber needs to hit the road
	//
	// +OR
	// | +<TreeOne>
	// | +<TreeTwo>
	//
	// This function is used in IF and WHILE and
	// UNTIL statements.
	//
	// parameter:
	//	n....pointer to the node to be processed
	//
	// special params:
	//	n->aux points to a RELOP_D structure
	// This structure will contain info from
	// up stream nodes that will allow this
	// node to do the proper branching and
	// what not.
	//
	// The two nodes will branch TRUE to the
	// same spot.  But a Branch FALSE to the
	// doing the test for the second node.
	// Or, in other words, branch to TRUE code
	// when you hit the first condition that is
	// TRUE
	//------------------------------------------
	NODE *n1,*n2;		/*	child nodes	*/
	value *v1,*v2;      /*	values returned from processor nodes	*/
	RELOP_D *pRelData,*pRD;

	pRD = (RELOP_D *)n->aux;
	n1 = n->down;
	n2 = n1->next;
	pRelData = malloc(sizeof(RELOP_D));
	pRelData->LabFalse = GenLabel(GetCurrentProc()->name);
	pRelData->LabTrue = pRD->LabTrue;
	n1->aux = (void *)pRelData;
	v1 = (node_proc[n1->id])(n1);		/*	process nodes	*/
	if(v1 != NULL)				//this was not a rel operation
	{
		BranchOnValue(OutFile,v1,pRelData->LabFalse,pRelData->LabTrue);
	}
	OutputLable(OutFile,pRelData->LabFalse);
	free(pRelData->LabFalse);
	pRelData->LabFalse = pRD->LabFalse;
	n2->aux = (void  *)pRelData;
	v2 = (node_proc[n2->id])(n2);		/*	process nodes	*/
	if(v2 != NULL)
	{
		BranchOnValue(OutFile,v2,pRelData->LabFalse,pRelData->LabTrue);
	}
	return NULL;
}

static value *np_AND(NODE *n)
{
	//-----------------------------------------------
	// +-AND
	// |  +-<TreeOne>
	// |  +-<TreeTwo>
	// |
	//
	//
	// This function is used in IF and WHILE and
	// UNTIL statements.
	//
	// parameter:
	//	n....pointer to the node to be processed
	//
	// special params:
	//	n->aux points to a RELOP_D structure
	// This structure will contain info from
	// up stream nodes that will allow this
	// node to do the proper branching and
	// what not.
	//
	// This function will generate code that will
	// branch TRUE if both threes evaluate true
	// This function will branch FALSE when the
	// first tree evaluates FALSE
	//-------------------------------------------

	NODE *n1,*n2;		/*	child nodes	*/
	value *v1,*v2;      /*	values returned from processor nodes	*/
	RELOP_D *pRelData,*pRD;

	pRD = (RELOP_D *)n->aux;
	n1 = n->down;
	n2 = n1->next;
	pRelData = malloc(sizeof(RELOP_D));
	pRelData->LabFalse = pRD->LabFalse;
	pRelData->LabTrue = GenLabel(GetCurrentProc()->name);
	n1->aux = (void *)pRelData;
	v1 = (node_proc[n1->id])(n1);		/*	process nodes	*/
	if(v1 != NULL)				//this was not a rel operation
	{
		BranchOnValue(OutFile,v1,pRelData->LabFalse,pRelData->LabTrue);
	}
	OutputLable(OutFile,pRelData->LabTrue);
	free(pRelData->LabTrue);
	pRelData->LabTrue = pRD->LabTrue;
	n2->aux = (void *)pRelData;
	v2 = (node_proc[n2->id])(n2);
	if(v2 != NULL)
	{
		BranchOnValue(OutFile,v2,pRelData->LabFalse,pRelData->LabTrue);
	}
	return NULL;
}

static value *relop(NODE *n,int op)
{
	NODE *n1,*n2;		/*	child nodes	*/
	value *v1,*v2;      /*	values returned from processor nodes	*/
	value *rV = NULL;
	RELOP_D *pRD;
	
	if(Debug) printf("RELOP=%s\n",binop_strings[op]);
	n1 = n->down;
	n2 = n1->next;
	pRD = (RELOP_D *)n->aux;
	v1 = (node_proc[n1->id])(n1);		/*	process nodes	*/
	v2 = (node_proc[n2->id])(n2);
	DoBinary(OutFile,v1,op,v2,1,1,pRD->LabTrue,pRD->LabFalse,NULL);

	return NULL;
}

static value *np_EQ(NODE *n)
{
	return relop(n,BINOP_EQ);
}

static value *np_NE(NODE *n)
{
	return relop(n,BINOP_NE);
}

static value *np_LT(NODE *n)
{
	return relop(n,BINOP_LT);
}

static value *np_GT(NODE *n)
{
	return relop(n,BINOP_GT);
}

static value *np_LTE(NODE *n)
{
	return relop(n,BINOP_LE);
}

static value *np_GTE(NODE *n)
{
	return relop(n,BINOP_GE);
}

/*-------------------------------------------------------------------------
**
** Urnary operators
**
**------------------------------------------------------------------------*/

static value *np_ADDRESSOF(NODE *n)
{
	NODE *n1;		/*	child nodes	*/
	value *v1;      /*	values returned from processor nodes	*/
	value *rV;
	link *s,*d,*t;

	n1 = n->down;
	if(Debug) printf("%s:n=%d\n",nnames[n->id],n->numb);
	v1 = (node_proc[n1->id])(n1);		/*	process nodes	*/
	t = v1->type;
	s = new_link();
	d = new_link();
	s->tclass = SYMTAB_SPECIFIER;
	s->SYMTAB_NOUN = t->SYMTAB_NOUN;
	d->SYMTAB_DCL_TYPE = SYMTAB_POINTER;
	s->next = d;
	rV = new_value();
	rV->ValLoc = VALUE_IN_TMP;	//leave result in accum
	rV->is_tmp = GetTemp(2,&rV->offset);
	MakeTempName(rV->name,rV->offset);
	rV->type = s;
	rV->etype = d;
	fprintf(OutFile,"\tLDA\t#<%s\n",v1->name);
	GenAccOps(OutFile,ACCOP_STA,0,rV);
	fprintf(OutFile,"\tLDA\t#>%s\n",v1->name);
	GenAccOps(OutFile,ACCOP_STA,1,rV);
	return rV;
}

static value *np_CONTENTSOF(NODE *n)
{
	NODE *n1;		/*	child nodes	*/
	value *v1;      /*	values returned from processor nodes	*/
	value *rv;

	n1 = n->down;
	if(Debug) printf("%s:n=%d\n",nnames[n->id],n->numb);
	v1 = (node_proc[n1->id])(n1);		/*	process nodes	*/
	/* We need to dereference a pointer	*/
	rv = CreateTemp(v1->type,0);
	rv->ValLoc = VALUE_IN_TMP;
	GenAccOps(OutFile,ACCOP_LDA,0,v1);
	GenAccOps(OutFile,ACCOP_STA,0,rv);
	GenAccOps(OutFile,ACCOP_LDA,1,v1);
	GenAccOps(OutFile,ACCOP_STA,1,rv);
	rv = DeReferencePointer(rv);
	rv->ValLoc = VALUE_POINT_TO;
	return rv;
}

static value *np_NEGATIVE(NODE *n)
{
	NODE *n1;		/*	child nodes	*/
	value *v1;		/*	child value	*/
	link *l;
	value *rv;

	n1 = n->down;
	v1 = (node_proc[n1->id])(n1);	/*	process nodes	*/
	l = v1->type;
	if(IS_CONSTANT(l))
	{
		if(IS_INT(l))
			l->V_INT = -l->V_INT;
		else if (IS_LONG(l))
			l->V_LONG = -l->V_LONG;
		rv = v1;
	}
	else
		rv = DoNegative(OutFile,v1);
	return rv;
}

static value *np_CODEBLOCK(NODE *n)
{
	DATABLOCK *pD;
	int i;

	if(Debug) printf("%s:n=%d\n",nnames[n->id],n->numb);
	pD = (DATABLOCK *)n->aux;
	fprintf(OutFile,"\t.DB\t");
	for(i=0;i<pD->size;++i)
	{
		fprintf(OutFile,"$%02x%c",pD->data[i] & 0x0ff,(i == (pD->size - 1))?'\n':',');
	}
	return NULL;
}

static value *np_MEMBER(NODE *n)
{
	NODE *n1,*n2;		/*	child nodes	*/
	value *v1;      /*	values returned from processor nodes	*/
	symbol *pStruct,*pM;
	structdef *pMember;
	char *MembrName;
	int loop;

	n1 = n->down;
	n2 = n1->next;

	//********************************************
	// n1 is the node that will determine the
	// name of the structure, and n2 will
	// determine the name of the member
	//********************************************
	pStruct = n1->symb;
	MembrName = (char *)n2->symb;	//get name of member
	pMember = pStruct->type->select.s.const_val.v_struct;
	pM = pMember->fields;
	loop = 1;
	while(loop>0)
	{
		if(strcmp(pM->name,MembrName) == 0)
			loop = 0;
		else
		{
			pM = pM->next;
			if(pM == NULL)
				loop = -1;
		}
	}
	if(pM == NULL) fprintf(stderr,"%s is not a member of %s\n",MembrName,pStruct->name);
	else
	{
		printf("Offset = %d FOR %s\n",pM->level,pM->name);
	}
	if(Debug) printf("%s:n=%d\n",nnames[n->id],n->numb);
	v1 = new_value();
	v1->type = clone_type(pM->type,&v1->etype);
	v1->ValLoc = VALUE_IN_MEM;
	sprintf(v1->name,"%s+%d",pStruct->name,pM->level);
	return v1;
}

static value *np_ARRAYREF(NODE *n)
{
	NODE *n1,*n2;		/*	child nodes	*/
	value *v1,*v2;      /*	values returned from processor nodes	*/
	value *rV;

	n1 = n->down;
	n2 = n1->next;
	if(Debug) printf("%s:n=%d\n",nnames[n->id],n->numb);
	//------------------------------
	//This is where the Array is
	//-----------------------------
	v1 = (node_proc[n1->id])(n1);		/*	process nodes	*/
	//-----------------------------
	// this value is the index
	//----------------------------
	v2 = (node_proc[n2->id])(n2);
	//----------------------------
	// Accessing the Array is
	// probably done best by
	// creating a pointer
	//---------------------------
	rV = DoArrayRef(OutFile,v1,v2);
	return rV;
}

static value *np_FUNCCALL(NODE *n)
{
	NODE *procname,*args;		/*	child nodes	*/
	link *t,*l,*d;
	PARAMS params;
	int size,i;
	value *rv;

	procname = n->down;
	args = procname->next;
	if(Debug) printf("%s:n=%d\n",nnames[n->id],n->numb);
	//we are not going to process the node for name
	// of the function
	// first calculate the number of bytes to be passed
	//
	t = procname->symb->type;
	if(t->next->select.d.args)
	{
		symbol *pSym = t->next->select.d.args;
		params.NBytes = 0;
		params.Nparams = 0;
		i=0;
		while(pSym)
		{
			size = SizeOfType(pSym->type);
			params.NBytes += size;
			params.Psize[i++] = size;
			params.Nparams += 1;
			pSym = pSym->next;
		}
	}
	else
		params.NBytes = params.Nparams = 0;	//ther are no parameters to pass
	if( params.Nparams)
	{
		args->aux = (void *)&params;	//pass the number of byte to next function
		(node_proc[args->id])(args);		/*	process nodes	*/
	}
	GenJumpSub(OutFile,procname->symb);
	rv = new_value();
	rv->type = clone_type(t,&rv->etype);
	l = rv->type;	//first declarator
	while(l)	//is there a declarator?
	{
		if(l->next)
		{
			if(IS_FUNCT(l->next))
			{
				d = l->next;
				l->next = l->next->next;
				discard_link(d);
			}
			else
				l = l->next;
		}
		else
			l = l->next;
	}
	switch(SizeOfRef(procname->symb->type))
	{
		case 1:
			rv->ValLoc = VALUE_IN_A;
			break;
		case 2:
			rv->ValLoc = VALUE_IN_MEM;
			strcpy(rv->name,"__ARGS");
			break;
		case 4:
			rv->ValLoc = VALUE_IN_MEM;
			strcpy(rv->name,"__ARGS");
			break;
	}
	return rv;
}

static value *np_PROCCALL(NODE *n)
{
	NODE *procname,*args;		/*	child nodes	*/
	link *t;
	PARAMS params;
	int size,i;

	procname = n->down;
	args = procname->next;
	if(Debug) printf("%s:n=%d\n",nnames[n->id],n->numb);
	//we are not going to process the node for name
	// of the function
	// first calculate the number of bytes to be passed
	//
	t = procname->symb->type;
	if(t->next->select.d.args)
	{
		symbol *pSym = t->next->select.d.args;
		params.NBytes = 0;
		params.Nparams = 0;
		i=0;
		while(pSym)
		{
			size = SizeOfType(pSym->type);
			params.NBytes += size;
			params.Psize[i++] = size;
			params.Nparams += 1;
			pSym = pSym->next;
		}
	}
	else
		params.NBytes = params.Nparams = 0;	//ther are no parameters to pass
	if( params.Nparams)
	{
		args->aux = (void *)&params;	//pass the number of byte to next function
		(node_proc[args->id])(args);		/*	process nodes	*/
	}
	GenJumpSub(OutFile,procname->symb);
	return NULL;
}

static value *np_PROCIDENT(NODE *n)
{
	NODE *n1;		/*	child nodes	*/
	value *v1;      /*	values returned from processor nodes	*/

	n1 = n->down;
	if(Debug) printf("%s:n=%d  %s\n",nnames[n->id],n->numb,n->symb);
	if(n1)
		v1 = (node_proc[n1->id])(n1);		/*	process nodes	*/

	return NULL;
}


static value *np_ARGUMENTS(NODE *n)
{
	/****************************************
	** Oh!..this is not going to be fun.
	** The paramter list is made with the
	** First paramter First in the list, but
	** the first paramter is stored in the
	** accumulator...so, we really need to know
	** what the last parameter is first
	** I will make use of the fact that we will
	** know ahead of time what the parameters
	** are supposed to look like
	** The number of bytes to pass will be
	** in the aux member of the node passed
	** to this function
	****************************************/

	NODE *n1;		/*	child nodes	*/
	value *v1;      /*	values returned from processor nodes	*/
	PARAMS *pP;
	int i;

	pP = (PARAMS *)n->aux;
	n1 = n->down;
	if(Debug)  printf("%s:n=%d\n",nnames[n->id],n->numb);
	for(i=0;i<pP->Nparams;++i)
	{
		if(n1)
		{
			v1 = (node_proc[n1->id])(n1);		/*	process nodes	*/
			Passparameter(OutFile,v1,pP,pP->Nparams -(i+1));
			n1 = n1->next;
		}
		else
		{
			fprintf(stderr,"Incorrect Number of params\n");
		}
	}

	return NULL;
}

static value *np_COMPLEMENT(NODE *n)
{
	//***************************************
	// Currently, this is NOT used....
	//***************************************
	NODE *n1;		/*	child nodes	*/
	value *v1;      /*	values returned from processor nodes	*/

	n1 = n->down;
	if(Debug) printf("%s:n=%d\n",nnames[n->id],n->numb);
	v1 = (node_proc[n1->id])(n1);		/*	process nodes	*/
	return NULL;
}

/*----------------------------------------------------------------------
**
** basic elements that make up the code
**
**--------------------------------------------------------------------*/

static value *np_CONSTANT(NODE *n)
{
	value *v;

	if(Debug) printf("%s:n=%d  %s\n",nnames[n->id],n->numb,n->symb);
	v = make_icon((char *)n->symb,n->symb->type->V_INT);
	return v;
}

/*********************************************
** np_IDENT
** this is a fundemental element, so this node
** will go no farther.  It is up to this node
** to generate a value that can be opperated on
** by node processing routines futher up the
** line
*********************************************/

static value *np_IDENT(NODE *n)
{
	value *v;

	if(Debug) printf("%s:n=%d  %s\n",nnames[n->id],n->numb,n->symb);
	v = new_value();	//create a new value
	strcpy(v->name,n->symb->rname);	//copy over symbol rname
	v->type = clone_type(n->symb->type,&v->etype);
	return v;
}

static value *np_STRING(NODE *n)
{
	/*******************************************************
	** This function is for the strings that are sprinkled
	** throughout the code in a program.  We need to create
	** a CHAR ARRAY value for these and generate a lable
	*******************************************************/
	value *v;      /*	values returned from processor nodes	*/
	link *s,*d;
	char *label;
	char *b;

	b = malloc(256);
	if(Debug) printf("%s:n=%d  %s\n",nnames[n->id],n->numb,n->symb);
	v = new_value();
	s = new_link();
	d = new_link();
	sprintf(b,"%s_STR_",GetCurrentProc()->name);
	label = GenLabel(b);
	strcpy(v->name,label);
	s->tclass = SYMTAB_SPECIFIER;
	d->tclass = SYMTAB_DECLARATOR;
	s->SYMTAB_NOUN = SYMTAB_CHAR;
	s->next = d;
	d->SYMTAB_DCL_TYPE = SYMTAB_ARRAY;
	d->SYMTAB_NUM_ELE = strlen((char *)n->symb)+1;
	free(label);
	label = GenLabel(GetCurrentProc()->name);
	GenJump(OutFile,label);
	fprintf(OutFile,"%s:\t.DB\t%d,\"%s\"\n",v->name,strlen((char *)n->symb),n->symb);
	OutputLable(OutFile,label);
	free(label);
	v->type = s;
	v->etype = d;
	free(b);
	return v;
}
/*----------------------------------------------------------------------
**
** Miscilaneous Node functions
**
**--------------------------------------------------------------------*/
static value *np_PROC(NODE *n)
{
	NODE *n1,*n2=NULL;		/*	child nodes	*/
	value *v1,*v2;      /*	values returned from processor nodes	*/
	symbol *args;
	char *prefix;
	int arglistsize;
	int procdeclared;

	prefix = malloc(128);
	sprintf(prefix,"%s_ARG_",n->symb->name);	//generate argument prefix
	args = n->symb->type->next->SYMTAB_ARGS;	//get pointer to argument chain
	procdeclared = n->symb->type->V_ULONG;	//address of proc (if any)
	GenSymbolRname(args,prefix);	//generate output names
	if(procdeclared == 0)
	{
		OutputData(OutFile,args);	//output allocation for arguments
	}
	free(prefix);
	arglistsize = SizeOfArgList(args);
	SetCurrentProc(n->symb);
	if(arglistsize) OutputGetArgs(OutFile,args->rname,arglistsize,n->symb->name);
	else if (procdeclared != 0) fprintf(OutFile,"%s\tEQU$%04x\n",n->symb->name,procdeclared);
	else fprintf(OutFile,"%s:\n",n->symb->name);
	n1 = n->down;
	if(n1) n2 = n1->next;
	if(Debug) printf("%s:n=%d\n",nnames[n->id],n->numb);
	if(n1)
	{
		if(n1->id == NODEID_RETURN)
			n1->aux = n->symb;
		v1 = (node_proc[n1->id])(n1);		/*	process nodes	*/
	}
	while(n2)
	{
		if(n2->id == NODEID_RETURN)
			n2->aux = n->symb;
		v2 = (node_proc[n2->id])(n2);
		n2 = n2->next;
	}
	return NULL;
}

static value *np_FUNC(NODE *n)
{
	NODE *n1,*n2;		/*	child nodes	*/
	value *v1,*v2;      /*	values returned from processor nodes	*/
	symbol *args;
	char *prefix;
	int arglistsize;

	prefix = malloc(128);
	sprintf(prefix,"%s_ARG_",n->symb->name);	//generate argument prefix
	args = n->symb->type->next->SYMTAB_ARGS;	//get pointer to argument chain
	GenSymbolRname(args,prefix);	//generate output names
	OutputData(OutFile,args);	//output allocation for arguments
	free(prefix);
	arglistsize = SizeOfArgList(args);
	SetCurrentProc(n->symb);
	if(arglistsize) OutputGetArgs(OutFile,args->rname,arglistsize,n->symb->name);
	else fprintf(OutFile,"%s:\n",n->symb->name);
	n1 = n->down;
	n2 = n1->next;
	if(Debug) printf("%s:n=%d\n",nnames[n->id],n->numb);
	if(n1)
	{
		v1 = (node_proc[n1->id])(n1);		/*	process nodes	*/
	}
	while(n2)
	{
		v2 = (node_proc[n2->id])(n2);
		n2 = n2->next;
	}
	return NULL;
}

static value *np_PROCLOCALS(NODE *n)
{
	char *Lable;
	symbol *proc;
	if(Debug) printf("%s:n=%d  %s\n",nnames[n->id],n->numb,n->symb);
	proc = (symbol *)n->aux;
	GenSymbolRname(n->symb,proc->name);
	Lable = GenLabel(proc->name);
	GenJump(OutFile,Lable);
	OutputData(OutFile,n->symb);
	OutputLable(OutFile,Lable);
	free(Lable);
	return NULL;
}

/*----------------------------------------------------------------------
**
** looping node functions
**
**--------------------------------------------------------------------*/

static value *np_DOLOOP(NODE *n)
{
	NODE *n1;		/*	child nodes	*/
	value *v1;      /*	values returned from processor nodes	*/
	char *Lable1,*Lable2,*tStr;

	tStr = malloc(128);
	sprintf(tStr,"%s_OD_",GetCurrentProc()->name);
	Lable1 = GenLabel(tStr);
	sprintf(tStr,"%s_DO_",GetCurrentProc()->name);
	Lable2 = GenLabel(tStr);
	StackPush(ExitStack,Lable1);
	StackPush(DoLoopStack,Lable2);
	OutputLable(OutFile,Lable2);
	n1 = n->down;
	if(Debug) printf("%s:n=%d\n",nnames[n->id],n->numb);
	while(n1)
	{
		v1 = (node_proc[n1->id])(n1);		/*	process nodes	*/
		n1 = n1->next;
		if(v1) release_value(v1);
	}
	GenJump(OutFile,Lable2);
	OutputLable(OutFile,Lable1);
	StackPop(ExitStack);
	StackPop(DoLoopStack);
	return NULL;
}

static value *np_WHILEDOLOOP(NODE *n)
{
	NODE *n1;		/*	child nodes	*/
	value *v1;      /*	values returned from processor nodes	*/

	n1 = n->down;
	if(Debug) printf("%s:n=%d\n",nnames[n->id],n->numb);
	while(n1)
	{
		v1 = (node_proc[n1->id])(n1);		/*	process nodes	*/
		n1 = n1->next;
		if(v1) release_value(v1);
	}
	return NULL;
}

static value *np_FORDOLOOP(NODE *n)
{
	NODE *n1;		/*	child nodes	*/
	value *v1;      /*	values returned from processor nodes	*/
	char *Lable1,*Lable2;

	Lable1 = GenLabel(GetCurrentProc()->name);
	Lable2 = GenLabel(GetCurrentProc()->name);

	n1 = n->down;
	if(Debug) printf("%s:n=%d\n",nnames[n->id],n->numb);
	while(n1)
	{
		v1 = (node_proc[n1->id])(n1);		/*	process nodes	*/
		n1 = n1->next;
	}
	return NULL;
}

static value *np_FOR(NODE *n)
{
	//----------------------------------------
	// processing this node is going to be a little
	// messy.
	// The tree should look like this:
	//  +-FOR
	//  | +-FORSTART
	//  | | +<stuff>
	//  | +-FORTO
	//  | | +-<stuff>
	//  | +-STEP (this node is "optional"
	//  | | +-<stuff>
	//  | +-FORDOLOOP
	//  |   +-<stuff>
	//
	//	statagy is to locate the four nodes that
	// make up a for loop and then process them
	// in an a-prior mode
	//-----------------------------------------
	NODE *start,*forto,*step,*doloop;		/*	child nodes	*/
	value *v1,*v2,*v3,*v4;      /*	values returned from processor nodes	*/
	char *Lable1,*Lable2,*Lable3;
	char *tStr = malloc(128);

	sprintf(tStr,"%s_FOR_%c",GetCurrentProc()->name,'A'+ ExitStack->Index);
	Lable1 = GenLabel(tStr);
	sprintf(tStr,"%s_Fr_code_%c",GetCurrentProc()->name,'A'+ ExitStack->Index);
	Lable2 = GenLabel(tStr);
	sprintf(tStr,"%s_FOR_xit_%c",GetCurrentProc()->name,'A'+ ExitStack->Index);
	Lable3 = GenLabel(tStr);
	start = n->down;
	forto = start->next;
	if(forto->next->id == NODEID_STEP)
	{
		step = forto->next;
		doloop = step->next;
	}
	else
	{
		step = NULL;
		doloop = forto->next;
	}
	StackPush(ExitStack,Lable1);
	StackPush(DoLoopStack,Lable2);
	if(Debug) printf("%s:n=%d\n",nnames[n->id],n->numb);
	//--------------------------
	// v1 should be a memory
	// location, and will be the
	// loop itterator
	//-------------------------
	v1 = (node_proc[start->id])(start);		/*	process nodes	*/
	OutputLable(OutFile,Lable1);
	//-----------------------------
	// compare the itterator to the
	// maximum value
	//----------------------------
	v2 = (node_proc[forto->id])(forto);
	v4 = DoBinary(OutFile,v1,BINOP_EQ,v2,0,0,Lable3,Lable2,NULL);
	OutputLable(OutFile,Lable2);
	(node_proc[doloop->id])(doloop);
	if(step)	//is there an optional step?
	{
		v3 = (node_proc[step->id])(step);
		DoAssign(OutFile,v1,v3,ASSOP_ADD,1,1);
		//v1 gets released here
	}
	else
	{
		v3 = MakeConstant(v1->type,1);
		DoAssign(OutFile,v1,v3,ASSOP_ADD,1,1);
		//V1  gets released here
	}
	GenJump(OutFile,Lable1);
	OutputLable(OutFile,Lable3);
	StackPop(ExitStack);
	StackPop(DoLoopStack);
	free(Lable3);
	free(Lable2);
	free(Lable1);
	return NULL;
}

static value *np_FORTO(NODE *n)
{
	NODE *n1;		/*	child nodes	*/
	value *v1;      /*	values returned from processor nodes	*/

	n1 = n->down;
	if(Debug) printf("%s:n=%d\n",nnames[n->id],n->numb);
	if(n1)
	{
		v1 = (node_proc[n1->id])(n1);		/*	process nodes	*/
	}
	return v1;
}

static value *np_FORSTART(NODE *n)
{
	NODE *n1,*n2;		/*	child nodes	*/
	value *v1,*v2;      /*	values returned from processor nodes	*/

	n1 = n->down;
	n2 = n1->next;
	if(Debug) printf("%s:n=%d\n",nnames[n->id],n->numb);
	v1 = (node_proc[n1->id])(n1);		/*	process nodes	*/
	v2 = (node_proc[n2->id])(n2);
	DoAssign(OutFile,v1,v2,ASSOP_EQUALS,0,1);	//reelase v2
	return v1;
}

static value *np_STEP(NODE *n)
{
	NODE *n1;		/*	child nodes	*/
	value *v1 = NULL;      /*	values returned from processor nodes	*/

	n1 = n->down;
	if(Debug) printf("%s:n=%d\n",nnames[n->id],n->numb);
	if(n1)v1 = (node_proc[n1->id])(n1);		/*	process nodes	*/
	return v1;
}

static value *np_WHILE(NODE *n)
{
	NODE *n1,*n2;		/*	child nodes	*/
	value *v1,*v2;      /*	values returned from processor nodes	*/
	char *Lable1,*Lable2,*Lable3,*tStr;
	RELOP_D *pRD;

	tStr = malloc(128);
	pRD = (RELOP_D *)malloc(sizeof(RELOP_D));
	sprintf(tStr,"%s_WHILE",GetCurrentProc()->name);
	Lable1 = GenLabel(tStr);
	sprintf(tStr,"%s_ELIHW",GetCurrentProc()->name);
	Lable2 = GenLabel(tStr);
	sprintf(tStr,"%s_WCODE",GetCurrentProc()->name);
	Lable3 = GenLabel(tStr);
	StackPush(ExitStack,Lable2);
	StackPush(DoLoopStack,Lable1);
	pRD->LabFalse=Lable2;
	pRD->LabTrue=Lable3;
	n1 = n->down;
	n2 = n1->next;
	n1->aux = (void *)pRD;
	if(Debug) printf("%s:n=%d\n",nnames[n->id],n->numb);
	OutputLable(OutFile,Lable1);
	v1 = (node_proc[n1->id])(n1);	/*	process nodes	*/
	if(v1 != NULL)
		BranchOnValue(OutFile,v1,pRD->LabFalse,pRD->LabTrue);
	OutputLable(OutFile,Lable3);
	v2 = (node_proc[n2->id])(n2);
	GenJump(OutFile,Lable1);
	OutputLable(OutFile,Lable2);
	StackPop(ExitStack);
	StackPop(DoLoopStack);
	return NULL;
}

/*----------------------------------------------------------------------
**
** If statement functions
**
**--------------------------------------------------------------------*/

static value *np_IFSTMT(NODE *n)
{
	NODE *n1,*n2;		/*	child nodes	*/
	value *v1,*v2;     /*	values returned from processor nodes	*/
	char *label,*pre;

	pre = malloc(128);
	sprintf(pre,"%s_exit_",GetCurrentProc()->name);
	label = GenLabel(pre);
	free (pre);
	StackPush(IfStack,label);
	n1 = n->down;
	n2 = n1->next;

	if(Debug) printf("***%s:n=%d\n",nnames[n->id],n->numb);
	if(n1)	//process the IF statement
	{
		v1 = (node_proc[n1->id])(n1);		/*	process nodes	*/
	}
	while(n2)
	{
		v2 = (node_proc[n2->id])(n2);	//process next node
//		if(v2) fprintf(OutFile,"%s:\n",v1->name);
		n2 = n2->next;
	}
	fprintf(OutFile,"%s:\n",label);
	StackPop(IfStack);
	free(label);
	if(Debug) printf("-----EXIT If Stmt-------\n");
	return NULL;
}

static value *np_IF(NODE *n)
{
	NODE *n1,*n2;		/*	child nodes	*/
	value *v1,*v2;      /*	values returned from processor nodes	*/
	char *LableFalse,*LableTrue,*LableExit,*pre;
	RELOP_D *pRD;

	n1 = n->down;
	n2 = n1->next;
	pre = malloc(128);
	sprintf(pre,"%s_false_",GetCurrentProc()->name);
	LableFalse = GenLabel(pre);
	sprintf(pre,"%s_true_",GetCurrentProc()->name);
	LableTrue = GenLabel(pre);
	free(pre);
	LableExit = StackGetTop(IfStack);
	pRD = (RELOP_D *)malloc(sizeof(RELOP_D));
	pRD->LabFalse = LableFalse;
	pRD->LabTrue = LableTrue;
	n1->aux = (void *)pRD;
	fprintf(OutFile,"\t\t;If Statement\n");
	if(Debug) printf("%s:n=%d\n",nnames[n->id],n->numb);
	v1 = (node_proc[n1->id])(n1);	/*	process compare nodes	*/
	if(v1 != NULL)
	{
		BranchOnValue(OutFile,v1,LableFalse,LableTrue);
	}
	OutputLable(OutFile,LableTrue);
	while(n2)	//process nodes that execute when true
	{
		if(Debug) printf("<>IF Loop  Next Node %s\n",nnames[n2->id]);
		v2 = (node_proc[n2->id])(n2);
		n2 = n2->next;
	}
	GenJump(OutFile,LableExit);
	OutputLable(OutFile,LableFalse);
	return v2;
}

static value *np_ELSEIF(NODE *n)
{
	NODE *n1,*n2;		/*	child nodes	*/
	value *v1,*v2;      /*	values returned from processor nodes	*/
	char *LableFalse,*LableTrue,*LableExit,*pre;
	RELOP_D *pRD;

	n1 = n->down;
	n2 = n1->next;
	pre = malloc(128);
	sprintf(pre,"%s_false_",GetCurrentProc()->name);
	LableFalse = GenLabel(pre);
	sprintf(pre,"%s_true_",GetCurrentProc()->name);
	LableTrue = GenLabel(pre);
	free(pre);
	LableExit = StackGetTop(IfStack);
	pRD = (RELOP_D *)malloc(sizeof(RELOP_D));
	pRD->LabFalse = LableFalse;
	pRD->LabTrue = LableTrue;
	n1->aux = (void *)pRD;
	fprintf(OutFile,"\t\t;If Statement\n");
	if(Debug) printf("%s:n=%d\n",nnames[n->id],n->numb);
	v1 = (node_proc[n1->id])(n1);	/*	process compare nodes	*/
	if(v1 != NULL)
	{
		BranchOnValue(OutFile,v1,LableFalse,LableTrue);
	}
	OutputLable(OutFile,LableTrue);
	while(n2)	//process nodes that execute when true
	{
		if(Debug) printf("<>IF Loop  Next Node %s\n",nnames[n2->id]);
		v2 = (node_proc[n2->id])(n2);
		n2 = n2->next;
	}
	GenJump(OutFile,LableExit);
	OutputLable(OutFile,LableFalse);
	return v2;
}

static value *np_ELSE(NODE *n)
{
	NODE *n1;		/*	child nodes	*/
	value *v1;      /*	values returned from processor nodes	*/

	n1 = n->down;
	if(Debug) printf("%s:n=%d\n",nnames[n->id],n->numb);
	while(n1)
	{
		v1 = (node_proc[n1->id])(n1);		/*	process nodes	*/
		n1 = n1->next;
	}
	return NULL;
}

/*---------------------------------------------------------------------
**
** Goto statements
**
**-------------------------------------------------------------------*/

static value *np_RETURN(NODE *n)
{
	NODE *n1;
	symbol *pFunc = NULL;
	value *v1;
	value *rv = NULL;
	int Nret;	//number of bytes to return
	//------------------------------------------------
	// if this is a return from a function, then
	// n->aux will contain a pointer to the symbol
	// for the function
	//------------------------------------------------
	if(n->aux) pFunc = (symbol *)n->aux;
	if(Debug) printf("%s:n=%d\n",nnames[n->id],n->numb);
	n1 = n->down;
	if(n1 != NULL)	/*	process the nodes in the tree	*/
	{
		//---------------------------------------
		// if there is a return value, this is
		// where it gets processed.
		// BYTE functions: Returns value in A
		// INT, CARD, POINTER functions return value in $A0,$A1
		// LONG functions return value in $A0->$A3
		//----------------------------------------
		v1 = (node_proc[n1->id])(n1);		/*	process nodes	*/
		if(pFunc) Nret = SizeOfType(pFunc->type);
		if(pFunc) printf("Function %s Returns %d Bytes\n",pFunc->name,Nret);
		rv = DoReturn(OutFile,v1,Nret);
	}
	fprintf(OutFile,"\tRTS\n");
	return rv;
}

static value *np_EXIT(NODE *n)
{
	char *Lable;

	if(Debug) printf("%s:n=%d\n",nnames[n->id],n->numb);
	Lable = StackGetTop(ExitStack);
	if(Lable) GenJump(OutFile,Lable);
	else fprintf(stderr,"Error: Exit not inside of Loop\n");
	return NULL;
}

static value *np_UNTIL(NODE *n)
{
	NODE *n1;
	value *v1;
	RELOP_D *pRD;

	pRD = (RELOP_D *)malloc(sizeof(RELOP_D));
	pRD->LabTrue = StackGetTop(ExitStack);
	pRD->LabFalse = StackGetTop(DoLoopStack);

	if(Debug) printf("%s:n=%d\n",nnames[n->id],n->numb);
	n1 = n->down;
	n1 ->aux = (void *)pRD;
	v1 = (node_proc[n1->id])(n1);		/*	process nodes	*/
	//V! must be a BOOL
	if(v1 != NULL)
	{
		BranchOnValue(OutFile,v1,pRD->LabFalse,pRD->LabTrue);
	}

	return NULL;
}

/*
** this is the table of node processor routines
*/

value *(*node_proc[])(NODE *n) = {
	np_EQUALS,			//0
	np_MULEQ,			//1
	np_DIVEQ,			//2
	np_MODEQ,			//3
	np_ADDEQ,			//4
	np_SUBEQ,			//5
	np_ANDEQ,			//6
	np_OREQ,			//7
	np_XOREQ,			//8
	np_LSHEQ,			//9
	np_RSHEQ,			//10
	np_OR,				//11
	np_AND,				//12
	np_BITOR,			//13
	np_BITXOR,			//14
	np_BITAND,			//15
	np_EQ,				//16
	np_NE,				//17
	np_LT,				//18
	np_GT,				//19
	np_LTE,				//20
	np_GTE,				//21
	np_LSH,				//22
	np_RSH,				//23
	np_ADD,				//24
	np_SUB,				//25
	np_MUL,				//26
	np_DIV,				//27
	np_MOD,				//28
	np_COMPLEMENT,		//29
	np_ADDRESSOF,		//30
	np_CONTENTSOF,		//31
	np_NEGATIVE,		//32
	np_CODEBLOCK,		//33	ooopps. not used
	np_MEMBER,			//34
	np_FUNCCALL,		//35
	np_ARGUMENTS,		//36
	np_CONSTANT,		//37
	np_IDENT,			//38
	np_STRING,			//39
	np_FOR,				//40
	np_DOLOOP,			//41
	np_WHILE,			//42
	np_IF,				//43
	np_ELSEIF,			//44
	np_ELSE,			//45
	np_RETURN,			//46
	np_UNTIL,			//47
	np_EXIT,			//48
	np_STEP,			//49
	np_PROC,			//50
	np_FUNC,			//51
	np_IFSTMT,			//52
	np_FORSTART,		//53
	np_FORTO,			//54
	np_ARRAYREF	,		//55
	np_PROCCALL,		//56
	np_PROCIDENT,		//57
	np_PROCLOCALS,		//58
	np_FORDOLOOP,		//59
	np_WHILEDOLOOP		//60
};


/*-----------------------------------------------------------------------**
**                                                                       **
** process_tree                                                          **
**                                                                       **
** this function is used to go through all the branches in a tree to     **
** process the parse tree that was generated.                            **
**                                                                       **
** returns a value pointer.                                              **
** Takes a pointer to a head node to a parse tree.                       **
**                                                                       **
**-----------------------------------------------------------------------*/

value *process_tree(NODE *n)
{
	value *v=NULL;

	while(n != NULL)
	{
		printf("Processing Nodes %d:%s\n",n->numb,nnames[n->id]);
		v = (node_proc[n->id])(n);
		n = n->next;
	}
	return(v);
}


/*----------------------------------------------------------------------*/
/*do_binary_const() is -> (C) 1990 Allen I. Holub                       */
/*----------------------------------------------------------------------*/

static int	do_binary_const(value **v1p,int op, value **v2p )
{
    /* If both operands are constants, do the arithmetic. On exit, *v1p
     * is modified to point at the longer of the two incoming types
     * and the result will be in the last link of *v1p's type chain.
     */

    long  x;
    link  *t1 = (*v1p)->type ;
    link  *t2 = (*v2p)->type ;
    value *tmp;

    /* Note that this code assumes that all fields in the union start at the
     * same address.
     */

    if( IS_CONSTANT(t1) && IS_CONSTANT(t2) )
    {
	if( IS_INT(t1) && IS_INT(t2) )
	{
	    switch( op )
	    {
	    case '+':	t1->V_INT +=  t2->V_INT;	break;
	    case '-':	t1->V_INT -=  t2->V_INT;	break;
	    case '*':	t1->V_INT *=  t2->V_INT;	break;
	    case '&':	t1->V_INT &=  t2->V_INT;	break;
	    case '|':	t1->V_INT |=  t2->V_INT;	break;
	    case '^':	t1->V_INT ^=  t2->V_INT;	break;
	    case '/':	t1->V_INT /=  t2->V_INT;	break;
	    case '%':	t1->V_INT %=  t2->V_INT;	break;
	    case '<':	t1->V_INT <<= t2->V_INT;	break;

	    case '>':	if( IS_UNSIGNED(t1) ) t1->V_UINT >>= t2->V_INT;

			else		      t1->V_INT  >>= t2->V_INT;

			break;
	    }
	    return 1;
	}
	else if( IS_LONG(t1) && IS_LONG(t2) )
	{
	    switch( op )
	    {
	    case '+':	t1->V_LONG +=  t2->V_LONG;	break;
	    case '-':	t1->V_LONG -=  t2->V_LONG;	break;
	    case '*':	t1->V_LONG *=  t2->V_LONG;	break;
	    case '&':	t1->V_LONG &=  t2->V_LONG;	break;
	    case '|':	t1->V_LONG |=  t2->V_LONG;	break;
	    case '^':	t1->V_LONG ^=  t2->V_LONG;	break;
	    case '/':	t1->V_LONG /=  t2->V_LONG;	break;
	    case '%':	t1->V_LONG %=  t2->V_LONG;	break;
	    case '<':	t1->V_LONG <<= t2->V_LONG;	break;

	    case '>':	if( IS_UNSIGNED(t1) ) t1->V_ULONG >>= t2->V_LONG;
			else		      t1->V_LONG  >>= t2->V_LONG;
			break;
	    }
	    return 1;
	}
	else if( IS_LONG(t1) && IS_INT(t2) )
	{
	    switch( op )
	    {
	    case '+':	t1->V_LONG +=  t2->V_INT;	break;
	    case '-':	t1->V_LONG -=  t2->V_INT;	break;
	    case '*':	t1->V_LONG *=  t2->V_INT;	break;
	    case '&':	t1->V_LONG &=  t2->V_INT;	break;
	    case '|':	t1->V_LONG |=  t2->V_INT;	break;
	    case '^':	t1->V_LONG ^=  t2->V_INT;	break;
	    case '/':	t1->V_LONG /=  t2->V_INT;	break;
	    case '%':	t1->V_LONG %=  t2->V_INT;	break;
	    case '<':	t1->V_LONG <<= t2->V_INT;	break;

	    case '>':	if( IS_UNSIGNED(t1) ) t1->V_ULONG >>= t2->V_INT;
			else		      t1->V_LONG  >>= t2->V_INT;
			break;
	    }
	    return 1;
	}
	else if( IS_INT(t1) && IS_LONG(t2) )
	{
	    /* Avoid commutativity problems by doing the arithmetic first,
	     * then swapping the operand values.
	     */

	    switch( op )
	    {

	    case '+':	x = t1->V_INT +  t2->V_LONG;

	    case '-':	x = t1->V_INT -  t2->V_LONG;

	    case '*':	x = t1->V_INT *  t2->V_LONG;

	    case '&':	x = t1->V_INT &  t2->V_LONG;

	    case '|':	x = t1->V_INT |  t2->V_LONG;

	    case '^':	x = t1->V_INT ^  t2->V_LONG;

	    case '/':	x = t1->V_INT /  t2->V_LONG;

	    case '%':	x = t1->V_INT %  t2->V_LONG;

	    case '<':	x = t1->V_INT << t2->V_LONG;

	    case '>':	if( IS_UINT(t1) ) x = t1->V_UINT >> t2->V_LONG;

			else              x = t1->V_INT  >> t2->V_LONG;
			break;
	    }

	    t2->V_LONG = x;	/* Modify v1 to point at the larger   */
	    tmp  = *v1p ;	/* operand by swapping *v1p and *v2p. */
	    *v1p = *v2p ;
	    *v2p = tmp  ;
	    return 1;
	}
    }
    return 0;
}

void NodeSetDebug(int v)
{
	Debug = v;		//activate debug output
}