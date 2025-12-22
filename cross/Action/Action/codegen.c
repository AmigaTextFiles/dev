/*********************************************
** Code generator for the ACTION! compiler for 
** the Atari computer.
** Created by Jim Patchell
** in March of 2010
*********************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "symtab.h"
#include "value.h"
#include "codegen.h"
#include "gen.h"
#include "temp.h"
#include "nodeproc.h"

static symbol *CurProc;
REGS *Regs;
static value *DoArrayRefLong(FILE *out,value *v1,value *v2);
static value *DoArrayRefCard(FILE *out,value *v1,value *v2);
static value *DoArrayRefByte(FILE *out,value *v1,value *v2);

enum bin_ops {BINOP_ADD,BINOP_SUB,BINOP_MUL,BINOP_DIV,BINOP_MOD,
			BINOP_OR,BINOP_AND,BINOP_XOR,BINOP_SHL,BINOP_SHR,
			BINOP_OROR,BINOP_ANDAND,BINOP_NE,BINOP_EQ,BINOP_LT,BINOP_GT,
			BINOP_LE,BINOP_GE};

void SetCurrentProc(symbol *pS)
{
	CurProc = pS;	//set the current proceedure being generated
}

symbol *GetCurrentProc(void)
{
	return CurProc;
}

void OutputInternalStuff(FILE *out)
{
	fprintf(out,"\t.SECTION\t\"%s\",$%02x\n","temps",0x080);
	GenTempStuff(out);
	fprintf(out,"\t.SECTION\t\"%s\",$%02x\n","args",0x0A0);
	fprintf(out,"%s:\t.DS\t16\n","__ARGS");
	fprintf(out,"\t.SECTION\t\"%s\",$%02x\n","code",0x2000);
}

void OutputData(FILE *out,symbol *pSym)
{
	int ObjSize,v;

	while(pSym)
	{
		switch(pSym->init)
		{
			case SYMTAB_INIT_NONE:	/* initval has no meaning	*/
				if(!pSym->type->tdef)
					fprintf(out,"%s:\t.DS %d\n",pSym->rname,SizeOfType(pSym->type));
				break;
			case SYMTAB_INIT_VALUE:	/* symbol is initialized to value	*/
				ObjSize = SizeOfType(pSym->type);	//get size of object
				if(ObjSize == 1)
				{
					fprintf(out,"%s:\t.DB %d\n",pSym->rname,pSym->iv.initval);
				}
				else if (ObjSize == 2)
				{
					v = pSym->iv.initval;
					fprintf(out,"%s:\t.DB %d,%d\n",pSym->rname,LOW(v),LOWMID(v));
				}
				else if (ObjSize == 4)
				{
					v = pSym->iv.initval;
					fprintf(out,"%s:\t.DB %d,%d,%d,%d\n",pSym->rname,LOW(v),LOWMID(v),HIGHMID(v),HIGH(v));
				}
				break;
			case SYMTAB_INIT_ADDRESS:	/* Address is defined by user for symbol	*/
				v = pSym->iv.initval;
				fprintf(out,"%s:\tEQU %d\n",pSym->rname,v);
				break;
			case SYMTAB_INIT_ARRAY:	/* array is initialized to table of constants	*/
				ObjSize = SizeOfType(pSym->type);	//get size of object
				if(pSym->type->next->select.d.string_flag)
				{
					fprintf(out,"%s:\t.DB %s\n",pSym->rname,GetStringData(pSym));
				}
				else
				{
					fprintf(out,"%s:\t.DB %s\n",pSym->rname,GetDataData(pSym));
				}
				break;
		}	//end of switch statement
		pSym = pSym->next;
	}	//end of while(pSym)
}

int SizeOfRef(link *l)
{
	/************************************************
	** This function is like SizeOfType(link *l)
	** but give the size of value refered to by
	** the type.
	**
	** For example, both functions will return 1 for
	** type BYTE, But this one will also return
	** 1 for BYTE POINTER where SizeOfType will return
	** 2 (since a pointer is a two byte object).
	** This function will return size of 4 for LONG
	** POINTER, rather than 2 that SizeOfType would
	** return.
	*************************************************/

	int retval=0;
	link *ld;

	if(IS_SPECIFIER(l))	//is the a specifier?
	{
		switch(l->select.s.noun)	//basic type?
		{
			case SYMTAB_INT:	/* specifier.noun. INT has the value 0 so   */
				if(l->select.s._long)	//long value
					retval = 4;
				else
					retval = 2;	//just a regular card or int type
				break;
			case SYMTAB_CHAR:	/* that an uninitialized structure defaults */
				retval = 1;
				break;
			case SYMTAB_VOID:	/* to int, same goes for EXTERN, below.	    */
				fprintf(stderr,"Hey, this is ACTION!...there are no void types\n");
				break;
			case SYMTAB_STRUCTURE:
				ld = l->next;
				if(ld)	//is there a declarator?
				{
					if(IS_DECLARATOR(ld))
					{
						if(IS_POINTER(ld))
						{
							retval = 2;
						}
						else
						{
							fprintf(stderr,"STRUCT:ERROR:bad declarator\n");
						}
					}
				}
				else
					retval = l->select.s.const_val.v_struct->size;
				break;
			case SYMTAB_LABEL:
				fprintf(stderr,"Hey, this is ACTION!...there are no Lables\n");
				break;
		}
	}
	else
		retval = -1;
	return retval;
}

int SizeOfType(link *l)
{
	int retval=0;
	link *ld;

	if(IS_SPECIFIER(l))	//is the a specifier?
	{
		switch(l->select.s.noun)	//basic type?
		{
			case SYMTAB_INT:	/* specifier.noun. INT has the value 0 so   */
				if(l->next)	//is there a declarator?
				{
					if(IS_DECLARATOR(l->next))
					{
						if(IS_ARRAY(l->next))
						{
							if(l->select.s._long)	//long value
								retval = 4;
							else
								retval = 2;	//just a regular card or int type
							retval *= l->next->select.d.num_ele;
						}
						else if(IS_POINTER(l->next))
						{
							retval = 2;
						}
						else if(IS_FUNCT(l->next))
							retval = 2;
					}
				}
				else
				{
					if(l->select.s._long)	//long value
						retval = 4;
					else
						retval = 2;	//just a regular card or int type
				}
				break;
			case SYMTAB_CHAR:	/* that an uninitialized structure defaults */
				ld = l->next;
				if(ld)	//is there a declarator?
				{
					if(IS_DECLARATOR(ld))
					{
						if(IS_ARRAY(ld))
						{
							retval = l->next->select.d.num_ele;
						}
						else if(IS_POINTER(ld))
						{
							retval = 2;
						}
						else if(IS_FUNCT(ld))
							retval = 1;
						else
						{
							fprintf(stderr,"CHAR:ERROR:bad declarator\n");
						}
					}
					else
						fprintf(stderr,"CHAR:ERROR:Odd specifier wher decl should be\n");
				}
				else
					retval = 1;
				break;
			case SYMTAB_VOID:	/* to int, same goes for EXTERN, below.	    */
				fprintf(stderr,"Hey, this is ACTION!...there are no void types\n");
				break;
			case SYMTAB_STRUCTURE:
				ld = l->next;
				if(ld)	//is there a declarator?
				{
					if(IS_DECLARATOR(ld))
					{
						if(IS_POINTER(ld))
						{
							retval = 2;
						}
						else
						{
							fprintf(stderr,"CHAR:ERROR:bad declarator\n");
						}
					}
				}
				else
					retval = l->select.s.const_val.v_struct->size;
				break;
			case SYMTAB_LABEL:
				fprintf(stderr,"Hey, this is ACTION!...there are no Lables\n");
				break;
		}
	}
	else
		retval = -1;
	return retval;
}

int ArraySize(symbol *pS)
{
	//-----------------------------
	// returns number of elements
	// in an array
	//----------------------------
	int SizeByDecl,SizeByInit;
	int retval;
	link *l;

	if(pS->init == SYMTAB_INIT_ARRAY)
	{
		SizeByInit = pS->initSize;
	}
	l = pS->type;
	SizeByDecl=l->next->select.d.num_ele;
	if(SizeByDecl>SizeByInit) retval = SizeByDecl;
	else retval = SizeByInit;
	return retval;
}

char *GetStringData(symbol *pSym)
{
	int len,i;
	int l = 0;
	static char buf[2048];

	len = pSym->initSize;
	l+=sprintf(&buf[l],"%d,",len);
	for(i=0;i<len;++i)
		l+=sprintf(&buf[l],"%d%c",pSym->iv.arrinit[i] & 0x0ff,(i==(len-1))?0:',');
	return buf;
}

char *GetDataData(symbol *pSym)
{
	int len,i;
	int l = 0;
	static char buf[2048];

	len = pSym->initSize;
	for(i=0;i<len;++i)
		l+=sprintf(&buf[l],"%d%c",pSym->iv.arrinit[i] & 0x0ff,(i==(len-1))?0:',');
	return buf;
}

int SizeOfArgList(symbol *args)
{
	int retval=0;

	while(args)
	{
		retval += SizeOfType(args->type);	//size of first object
		args = args->next;	//pointer to next object
	}
	return retval;
}

void OutputGetArgs(FILE *out,char *FirstArg,int size,char *proc)
{
	char *Loop;
	int count;

	OutputLable(out,proc);
	fprintf(out,"\tSTA\t%s\n",FirstArg);
	--size;
	if(size-- > 0) fprintf(out,"\tSTX\t%s+1\n",FirstArg);
	if(size-- > 0) fprintf(out,"\tSTY\t%s+2\n",FirstArg);
	if(size > 3)
	{
		Loop = GenLabel(proc);
		fprintf(out,"\tLDX\t#0\n");
		fprintf(out,"%s:\tLDA\t$A3,X\n",Loop);
		fprintf(out,"\tSTA\t%s+3,X\n",FirstArg);
		fprintf(out,"\tINX\n");
		fprintf(out,"\tCPX\t#%d\n",size);
		fprintf(out,"\tBNE\t%s\n",Loop);
	}
	else if (size > 0)
	{
		count = 3;
		while(size--)
		{
			fprintf(out,"\tLDA\t$A0+%d\n",count);
			fprintf(out,"\tSTA\t%s+%d\n",FirstArg,count);
			++count;
		}

	}

}

//----------------------------------------------
// Do a binary operation.  Assume that both
// values are of the same "size"...right now
// we don't care about the same type
//----------------------------------------------
const int AddSubPre[7] = {STATUS_CLC,STATUS_SEC,-1,-1,-1,-1,-1,};

value *BinOpOp(FILE *out, value *v1, value *v2,int op,short rFlagV1,short rFlagV2,value *lv)
{
	link *t1 = v1->type;
	link *t2 = v2->type;
	value * rv = lv;
	int size;

	//***********************************
	// CHECK value v1 for being a constant
	// A constant is always 4 bytes so it
	// makes no sense to determine the
	// code generation on this.
	// Because the compiler combines
	// constants, if v1 is a constant,
	// these is supposed to be no way
	// v2 could be a constant, so use
	// its size to determine code 
	// generation
	//**********************************
	if(v1->ValLoc == VALUE_IS_CONSTANT)
		size = SizeOfRef(v2->type);
	else
		size = SizeOfRef(v1->type);

	switch(size)
	{
		case 1:		//1 byte operations
			if(rv == NULL)
			{
				rv = new_value();
				rv->type = clone_type(t1,&rv->etype);
				rv->ValLoc = VALUE_IN_A;	//leave result in accum
			}
			switch(v1->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location
				case VALUE_IS_CONSTANT:	//the value is a constant, should never have two that are
				case VALUE_POINT_TO:
					GenAccOps(out,ACCOP_LDA,0,v1);
				case VALUE_IN_A	:	//value is located in the accumulator
					if(AddSubPre[op] >= 0) GenSetClr(out,AddSubPre[op]);
					GenAccOps(out,op,0,v2);
					if(rv->ValLoc != VALUE_IN_A)
					{
						GenAccOps(out,ACCOP_STA,0,rv);
					}
					break;
			}
			break;
		case 2:		//2 byte operations
			if(rv == NULL) rv = CreateTemp(t1,2);
			switch(v1->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location
				case VALUE_IS_CONSTANT:	//the value is a constant
				case VALUE_POINT_TO:
					GenAccOps(out,ACCOP_LDA,0,v1);
					if(AddSubPre[op] >= 0) GenSetClr(out,AddSubPre[op]);
					GenAccOps(out,op,0,v2);
					GenAccOps(out,ACCOP_STA,0,rv);
					GenAccOps(out,ACCOP_LDA,1,v1);
					GenAccOps(out,op,1,v2);
					GenAccOps(out,ACCOP_STA,1,rv);
					break;
				case VALUE_IN_A	:	//value is located in the accumulator
					break;
			}
			break;	
		case 4:		//4 byte operations
			if(rv == NULL)
			{
				rv = new_value();
				rv->type = clone_type(t1,&rv->etype);
				rv->ValLoc = VALUE_IN_TMP;	//leave result in accum
			}
			switch(v1->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IS_CONSTANT:	//the value is a constant
				case VALUE_IN_TMP:	//value is located in a temporary location
				case VALUE_POINT_TO:
					GenAccOps(out,ACCOP_LDA,0,v1);
					if(AddSubPre[op] >= 0) GenSetClr(out,AddSubPre[op]);
					GenAccOps(out,op,0,v2);
					GenAccOps(out,ACCOP_STA,0,rv);
					GenAccOps(out,ACCOP_LDA,1,v1);
					GenAccOps(out,op,1,v2);
					GenAccOps(out,ACCOP_STA,1,rv);
					GenAccOps(out,ACCOP_LDA,2,v1);
					GenAccOps(out,op,2,v2);
					GenAccOps(out,ACCOP_STA,2,rv);
					GenAccOps(out,ACCOP_LDA,3,v1);
					GenAccOps(out,op,3,v2);
					GenAccOps(out,ACCOP_STA,3,rv);
					break;
				case VALUE_IN_A	:	//value is located in the accumulator
					break;
			}
			break;
	}
	if(rFlagV1) discard_value(v1);
	if(rFlagV2) discard_value(v2);
	return rv;
}

value *ShiftOp(FILE *out,value *v1,value *v2,int op,short rFlagV1,short rFlagV2)
{
	link *t1 = v1->type;
	link *t2 = v2->type;
	value * rv = 0;
	int ShiftDir,ShiftInc;
	int ASRflag = 0;

	char *Lable = GenLabel(CurProc->name);
	int Shift,Rotate;

	if(op == BINOP_SHL)
	{
		Shift = SHIFT_ASL;
		Rotate = SHIFT_ROL;
		ShiftDir = 0;
		ShiftInc = 1;
	}
	else
	{
		if(IS_UNSIGNED(t1))
			Shift = SHIFT_LSR;
		else
		{
			Shift = SHIFT_ROR;
			ASRflag = 1;
		}
		Rotate = SHIFT_ROR;
		ShiftDir = SizeOfRef(v1->type)-1;
		ShiftInc = -1;
	}
	switch(SizeOfRef(v1->type))
	{
		case 1:		//1 byte operations
			rv = new_value();
			rv->type = clone_type(t1,&rv->etype);
			rv->ValLoc = VALUE_IN_A;	//leave result in accum
			switch(v1->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location
					GenLoadReg(out,REGS_X,0,v2);
					OutputLable(out,Lable);
					if(ASRflag)
					{
						GenLoadRegWithConst(out,REGS_Y,0x80);
						GenIndexOp(out,INDEX_CPY,0,v1);
					}
					GenShift(out,Shift,0,v1);
					GenIncReg(out,REGS_X,REG_DEC);
					GenBranch(out,BRANCH_BNE,Lable);
					break;
				case VALUE_IN_A	:	//value is located in the accumulator					
				case VALUE_IS_CONSTANT:	//the value is a constant, should never have two that are
					GenLoadReg(out,REGS_X,0,v2);
					GenLoadReg(out,REGS_A,0,v1);
					OutputLable(out,Lable);
					if(ASRflag)
						GenAccOpsConst(out,ACCOP_CMP,0,0x80);
					GenShift(out,Shift,0,v1);
					GenIncReg(out,REGS_X,REG_DEC);
					GenBranch(out,BRANCH_BNE,Lable);
					break;
			}
			break;
		case 2:		//2 byte operations
			switch(v1->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IS_CONSTANT:	//the value is a constant
					rv = CreateTemp(v1->type,2);
					GenAccOps(out,ACCOP_LDA,0,v1);
					GenAccOps(out,ACCOP_STA,0,rv);
					GenAccOps(out,ACCOP_LDA,1,v1);
					GenAccOps(out,ACCOP_STA,1,rv);
					GenLoadReg(out,REGS_X,0,v2);
					OutputLable(out,Lable);
					if(ASRflag)
					{
						GenLoadRegWithConst(out,REGS_Y,0x80);
						GenIndexOp(out,INDEX_CPY,1,v1);
					}
					GenShift(out,Shift,ShiftDir,rv);
					GenShift(out,Rotate,ShiftDir+ShiftInc,rv);
					GenIncReg(out,REGS_X,REG_DEC);
					GenBranch(out,BRANCH_BNE,Lable);
					break;
				case VALUE_IN_TMP:	//value is located in a temporary location
					rv = v1;
					GenLoadReg(out,REGS_X,0,v2);
					OutputLable(out,Lable);
					if(ASRflag)
					{
						GenLoadRegWithConst(out,REGS_Y,0x80);
						GenIndexOp(out,INDEX_CPY,1,v1);
					}
					GenShift(out,Shift,ShiftDir,rv);
					GenShift(out,Rotate,ShiftDir+ShiftInc,rv);
					GenIncReg(out,REGS_X,REG_DEC);
					GenBranch(out,BRANCH_BNE,Lable);
					break;
				case VALUE_IN_A	:	//value is located in the accumulator
					break;
			}
			break;	
		case 4:		//4 byte operations
			switch(v1->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IS_CONSTANT:	//the value is a constant
					rv = CreateTemp(v1->type,4);
					GenAccOps(out,ACCOP_LDA,0,v1);
					GenAccOps(out,ACCOP_STA,0,rv);
					GenAccOps(out,ACCOP_LDA,1,v1);
					GenAccOps(out,ACCOP_STA,1,rv);
					GenAccOps(out,ACCOP_LDA,2,v1);
					GenAccOps(out,ACCOP_STA,2,rv);
					GenAccOps(out,ACCOP_LDA,3,v1);
					GenAccOps(out,ACCOP_STA,3,rv);
					GenLoadReg(out,REGS_X,0,v2);
					OutputLable(out,Lable);
					if(ASRflag)
					{
						GenLoadRegWithConst(out,REGS_Y,0x80);
						GenIndexOp(out,INDEX_CPY,3,v1);

					}
					GenShift(out,Shift,ShiftDir,rv);
					GenShift(out,Rotate,ShiftDir+ShiftInc,rv);
					GenShift(out,Rotate,ShiftDir + ShiftInc * 2,rv);
					GenShift(out,Rotate,ShiftDir + ShiftInc * 3,rv);
					GenIncReg(out,REGS_X,REG_DEC);
					GenBranch(out,BRANCH_BNE,Lable);
					break;
				case VALUE_IN_TMP:	//value is located in a temporary location
					GenLoadReg(out,REGS_X,0,v2);
					fprintf(out,"%s:\n",Lable);
					if(ASRflag)
					{
						GenLoadRegWithConst(out,REGS_Y,0x80);
						GenIndexOp(out,INDEX_CPY,3,v1);
					}
					GenShift(out,Shift,ShiftDir,v1);
					GenShift(out,Rotate,ShiftDir + ShiftInc,v1);
					GenShift(out,Rotate,ShiftDir + ShiftInc * 2,v1);
					GenShift(out,Rotate,ShiftDir + ShiftInc * 3,v1);
					GenIncReg(out,REGS_X,REG_DEC);
					GenBranch(out,BRANCH_BNE,Lable);
					rv = v1;
					break;
				case VALUE_IN_A	:	//value is located in the accumulator
					break;
			}
			break;
	}
	if(rFlagV1) discard_value(v1);
	if(rFlagV2) discard_value(v2);
	return rv;
}

value *BoolOp(FILE *out,value *v1,value *v2,int op,short rFlagV1,short rFlagV2)
{
	//-------------------------------
	// this function is relatively
	// simple in that it really
	// only deals with two 8 bit
	// operaands.  It will take any
	// type, however, and convert it
	// to a BOOL
	//------------------------------
	value *rv;
	value *o1,*o2;
	int opr;

	if(op == BINOP_ANDAND) opr = ACCOP_AND;
	else opr = ACCOP_ORA;;

	if(v1->type->SYMTAB_NOUN != SYMTAB_BOOL)
	{
		//-----------------------------
		// convert v1 to BOOL
		//------------------------------
		o1 = ConvertToBOOL(out,v1);
			o1 = SaveToTemp(out,o1);
	}
	else if(v1->ValLoc == VALUE_IN_A)
		o1 = SaveToTemp(out,v1);
	else
		o1 = v1;
	if(v2->type->SYMTAB_NOUN != SYMTAB_BOOL)
	{
		//-----------------------------
		// convert v2 to BOOL
		//-----------------------------
		o2 = ConvertToBOOL(out,v2);
	}
	else
		o2 = v2;
	switch(o2->ValLoc)
	{
		case VALUE_IN_MEM:	//value is located in a variable location
		case VALUE_IN_TMP:	//value is located in a temporary location
		case VALUE_IS_CONSTANT:	//the value is a constant
		case VALUE_POINT_TO:
			GenAccOps(out,ACCOP_LDA,0,o2);
		case VALUE_IN_A	:	//value is located in the accumulator
			GenAccOps(out,opr,0,o1);
			break;
	}
	if(rFlagV1) discard_value(o1);
	if(rFlagV2) discard_value(o2);
	rv = BOOLInAccumulator();
	return rv;
}

value *CmpEquOp(FILE *out,value *v1,value *v2,int op,short rFlgV1, short rFlgV2,char *LabTrue, char *LabFalse)
{
	value *rv = NULL;
	int OpSize;

	OpSize = SizeOfRef(v1->type);

	switch(OpSize)
	{
		case 1:
			switch(v1->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location
				case VALUE_IS_CONSTANT:	//the value is a constant
				case VALUE_POINT_TO:	//a value in a temp points to the value
					GenAccOps(out,ACCOP_LDA,0,v1);
				case VALUE_IN_A	:	//value is located in the accumulator
					GenAccOps(out,ACCOP_CMP,0,v2);
					break;
			}
			if(op == BINOP_EQ)
				GenBranch(out,BRANCH_BEQ,LabTrue);
			else
				GenBranch(out,BRANCH_BNE,LabTrue);
			GenJump(out,LabFalse);
			break;
		case 2:
			//---------------------------------
			// Lda oprA
			// Eor OprB
			// Bne False
			// Ora OprA+1
			// Eor OprB+1
			// Bne False:
			//True:
			//     *
			//     *
			// False
			//--------------------------------
			switch(v1->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location
				case VALUE_IS_CONSTANT:	//the value is a constant
				case VALUE_POINT_TO:	//a value in a temp points to the value
					GenAccOps(out,ACCOP_LDA,0,v1);
					GenAccOps(out,ACCOP_EOR,0,v2);
					if(op == BINOP_EQ)
						GenBranch(out,BRANCH_BNE,LabFalse);
					else
						GenBranch(out,BRANCH_BNE,LabTrue);
					GenAccOps(out,ACCOP_ORA,1,v1);
					GenAccOps(out,ACCOP_EOR,1,v2);
					break;
				case VALUE_IN_A	:	//value is located in the accumulator
					break;
			}
			if(op == BINOP_EQ)
				GenBranch(out,BRANCH_BEQ,LabTrue);
			else
				GenBranch(out,BRANCH_BNE,LabTrue);
			GenJump(out,LabFalse);
			break;
		case 4:
			switch(v1->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location
				case VALUE_IS_CONSTANT:	//the value is a constant
				case VALUE_POINT_TO:	//a value in a temp points to the value
					GenAccOps(out,ACCOP_LDA,0,v1);
					GenAccOps(out,ACCOP_EOR,0,v2);
					if(op == BINOP_EQ)
						GenBranch(out,BRANCH_BNE,LabFalse);
					else
						GenBranch(out,BRANCH_BNE,LabTrue);
					GenAccOps(out,ACCOP_ORA,1,v1);
					GenAccOps(out,ACCOP_EOR,1,v2);
					if(op == BINOP_EQ)
						GenBranch(out,BRANCH_BNE,LabFalse);
					else
						GenBranch(out,BRANCH_BNE,LabTrue);
					GenAccOps(out,ACCOP_ORA,2,v1);
					GenAccOps(out,ACCOP_EOR,2,v2);
					if(op == BINOP_EQ)
						GenBranch(out,BRANCH_BNE,LabFalse);
					else
						GenBranch(out,BRANCH_BNE,LabTrue);
					GenAccOps(out,ACCOP_ORA,3,v1);
					GenAccOps(out,ACCOP_EOR,3,v2);
					break;
				case VALUE_IN_A	:	//value is located in the accumulator
					break;
			}
			if(op == BINOP_EQ)
				GenBranch(out,BRANCH_BEQ,LabTrue);
			else
				GenBranch(out,BRANCH_BNE,LabTrue);
			GenJump(out,LabFalse);
			break;
	}
	return rv;
}

value *RelOp(FILE *out,value *v1,value *v2,int op,short rFlagV1,short rFlagV2,char *LabTrue,char *LabFalse)
{
	//-----------------------------
	// the value returned by this
	// code generator is always a
	// BOOL
	//-----------------------------
	value *rv;
	int branchop;
	int opSize;


	switch(op)
	{
		case BINOP_LT:	//v1 < v2
			branchop = BRANCH_BCC;
			break;
		case BINOP_GT:	//v2 < v1
			//---------------------------
			// need to swap V1 and V2
			//---------------------------
			rv = v1;	//swap values
			v1 = v2;
			v2 = rv;
			branchop = BRANCH_BCC;
			break;
		case BINOP_LE:	//v2 >= v1
			//---------------------------
			// need to swap V1 and V2
			//---------------------------
			rv = v1;
			v1 = v2;
			v2 = rv;
			branchop = BRANCH_BCS;
			break;
		case BINOP_GE:	//v1 >= v2
			branchop = BRANCH_BCS;
			break;
	}
	if(v2->ValLoc == VALUE_IN_A) 
	{
		v2 = SaveToTemp(out,v2);
	}
	rv = NULL;

	if(IS_CONSTANT(v1->type))
		opSize = SizeOfRef(v2->type);
	else
		opSize = SizeOfRef(v1->type);

	switch(opSize)
	{
		case 1:	//Byte size
			switch(v1->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location
				case VALUE_IS_CONSTANT:	//the value is a constant
					GenAccOps(out,ACCOP_LDA,0,v1);
				case VALUE_IN_A	:	//value is located in the accumulator
					GenAccOps(out,ACCOP_CMP,0,v2);
					GenBranch(out,branchop,LabTrue);
					GenJump(out,LabFalse);
					break;
			}
			break;
		case 2:	//word size
			switch(v1->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location
				case VALUE_IS_CONSTANT:	//the value is a constant
					//-----------------------------
					// operate on first byte
					//-----------------------------
					GenAccOps(out,ACCOP_LDA,0,v1);
					GenAccOps(out,ACCOP_CMP,0,v2);
					//----------------------------------------
					// operate on second byte
					//----------------------------------------
					GenAccOps(out,ACCOP_LDA,1,v1);
					GenAccOps(out,ACCOP_SBC,1,v2);
					GenBranch(out,branchop,LabTrue);
					GenJump(out,LabFalse);
					break;
				case VALUE_IN_A	:	//value is located in the accumulator
					fprintf(stderr,"ERROR:RelOp:Invalid value location\n");
					break;
			}
			break;
		case 4:	//extra long size
			switch(v1->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location
				case VALUE_IS_CONSTANT:	//the value is a constant
					//-----------------------------
					// operate on first byte
					//-----------------------------
					GenAccOps(out,ACCOP_LDA,0,v1);
					GenAccOps(out,ACCOP_SBC,0,v2);
					//----------------------------------------
					// operate on second byte
					//----------------------------------------
					GenAccOps(out,ACCOP_LDA,1,v1);
					GenAccOps(out,ACCOP_SBC,1,v2);

					//----------------------------------------
					// operate on third byte
					//----------------------------------------
					GenAccOps(out,ACCOP_LDA,2,v1);
					GenAccOps(out,ACCOP_SBC,2,v2);
					//----------------------------------------
					// operate on forth byte
					//----------------------------------------
					GenAccOps(out,ACCOP_LDA,3,v1);
					GenAccOps(out,ACCOP_SBC,3,v2);
					
					GenBranch(out,branchop,LabTrue);
					GenJump(out,LabFalse);
					break;
				case VALUE_IN_A	:	//value is located in the accumulator
					fprintf(stderr,"ERROR:RelOp:Invalid value location\n");
					break;
			}
			break;
	}
	if(rFlagV1) discard_value(v1);
	if(rFlagV2) discard_value(v2);
	return rv;
}

//***************************************************************
//
// DoBinary
// Thhis function generates code for a binary operation
//
// parameters:
//	out.......pointer to file stream to output generated code to
//	v1........Value on left of operator
//	op........Operation
//	v2.......Value on right of operator
//	rFlgV1...If true, OK to release v1
//	rFlgV2...If true, OK to release v2
//	LabTure..pointer to lable for branching to TRUE code
//	LabFalse.pointer to lable for branching to FALSE code
//	lv.......pointer to left value when doing an assign
//
// Returns relultant value after operation
//**************************************************************

value *DoBinary(FILE *out,value *v1,int op, value *v2,short rFlagV1, short rFlagV2,char *LabTrue,char *LaFalse,value *lv )
{
	value * rv = 0;

	switch(op)
	{
		case BINOP_ADD:
			rv = BinOpOp(out,v1,v2,ACCOP_ADC,rFlagV1,rFlagV2,lv);
			break;
		case BINOP_SUB:
			rv = BinOpOp(out,v1,v2,ACCOP_SBC,rFlagV1,rFlagV2,lv);
			break;
		case BINOP_MUL:
			break;
		case BINOP_DIV:
			break;
		case BINOP_MOD:
			break;
		case BINOP_OR:
			rv = BinOpOp(out,v1,v2,ACCOP_ORA,rFlagV1,rFlagV2,lv);
			break;
		case BINOP_AND:
			rv = BinOpOp(out,v1,v2,ACCOP_AND,rFlagV1,rFlagV2,lv);
			break;
		case BINOP_XOR:
			rv = BinOpOp(out,v1,v2,ACCOP_EOR,rFlagV1,rFlagV2,lv);
			break;
		case BINOP_SHL:
		case BINOP_SHR:
			rv = ShiftOp(out,v1,v2,op,rFlagV1,rFlagV2);
			break;
		case BINOP_OROR:
			rv = BoolOp(out,v1,v2,BINOP_OROR,rFlagV1,rFlagV2);
			break;
		case BINOP_ANDAND:
			rv = BoolOp(out,v1,v2,BINOP_ANDAND,rFlagV1,rFlagV2);
			break;
		case BINOP_NE:
		case BINOP_EQ:
			CmpEquOp(out,v1,v2,op,rFlagV1,rFlagV2,LabTrue,LaFalse);
			break;
		case BINOP_LT:
		case BINOP_GT:
		case BINOP_LE:
		case BINOP_GE:
			rv = RelOp(out,v1,v2,op,rFlagV1,rFlagV2,LabTrue,LaFalse);
			break;
	}
	return rv;
}

value *ConvertTypeUp(FILE *out,value *v1,link *t2)
{
	//-----------------------------
	// convert v1 to the same type
	// as the link chain t2
	//-----------------------------
	value *rV;
	int Handle,Index;
	char *Lable1,*Lable2;

	rV = new_value();
	rV->sym = v1->sym;
	rV->type = clone_type(t2,&rV->etype);
	switch(SizeOfRef(rV->type))
	{
		case 1:	//we should never have this case
			fprintf(stderr,"ERROR:ConvertUP,\'%s\' Already a Byte\n",v1->name);
			rV = v1;
			break;
		case 2:	//we can only onvert up from BYTE
			Handle = GetTemp(SizeOfRef(rV->type),&Index);
			MakeTempName(rV->name,Index);
			rV->offset = Index;
			rV->is_tmp = Handle;
			switch(v1->ValLoc)	//where is it located
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IS_CONSTANT:	//the value is a constant
				case VALUE_IN_TMP:	//value is located in a temporary location
					GenAccOps(out,ACCOP_LDA,0,v1);
				case VALUE_IN_A	:	//value is located in the accumulator
					GenAccOps(out,ACCOP_STA,0,rV);
					GenAccOpsConst(out,ACCOP_LDA,0,0);
					GenAccOps(out,ACCOP_STA,1,rV);
					break;
			}
			break;
		case 4:	//convert byte or word to long
			//--------------------------
			// first thing we need to do
			// is allocate a temp to put
			// the long into
			//-------------------------
			Handle = GetTemp(SizeOfRef(rV->type),&Index);
			MakeTempName(rV->name,Index);
			rV->offset = Index;
			rV->is_tmp = Handle;
			switch(v1->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location
					if(IS_CHAR(v1->type))
					{
						GenAccOps(out,ACCOP_LDA,0,v1);
						GenAccOps(out,ACCOP_STA,0,rV);
						GenAccOpsConst(out,ACCOP_LDA,0,0);
						GenAccOps(out,ACCOP_STA,1,rV);
						GenAccOps(out,ACCOP_STA,2,rV);
						GenAccOps(out,ACCOP_STA,3,rV);
					}
					else	//it is a WORD
					{
						GenAccOps(out,ACCOP_LDA,0,v1);
						GenAccOps(out,ACCOP_STA,0,rV);
						GenAccOps(out,ACCOP_LDA,2,v1);
						GenAccOps(out,ACCOP_STA,2,rV);
						if(IS_UINT(v1->type))
						{
							GenAccOpsConst(out,ACCOP_LDA,0,0);
							GenAccOps(out,ACCOP_STA,2,rV);
							GenAccOps(out,ACCOP_STA,3,rV);
						}
						else	//integer type, do sign extend
						{
							Lable1 = GenLabel(GetCurrentProc()->name);
							Lable2 = GenLabel(GetCurrentProc()->name);
							GenBranch(out,BRANCH_BMI,Lable1);
							GenAccOpsConst(out,ACCOP_LDA,0,0);
							GenBranch(out,BRANCH_BEQ,Lable2);
							OutputLable(out,Lable1);
							GenAccOpsConst(out,ACCOP_LDA,0,0xff);
							OutputLable(out,Lable2);
							GenAccOps(out,ACCOP_STA,2,rV);
							GenAccOps(out,ACCOP_STA,3,rV);
						}
					}
					break;
				case VALUE_IN_A	:	//value is located in the accumulator
					if(IS_CHAR(v1->type))
					{
						GenAccOps(out,ACCOP_STA,0,rV);
						GenAccOpsConst(out,ACCOP_LDA,0,0);
						GenAccOps(out,ACCOP_STA,1,rV);
						GenAccOps(out,ACCOP_STA,2,rV);
						GenAccOps(out,ACCOP_STA,3,rV);
					}
					else	//it is a WORD
					{
						fprintf(stderr,"Cannot have a word in the Accum\n");
					}
					break;
				case VALUE_IS_CONSTANT:	//the value is a constant
					GenAccOps(out,ACCOP_LDA,0,v1);
					GenAccOps(out,ACCOP_STA,0,rV);
					GenAccOps(out,ACCOP_LDA,1,v1);
					GenAccOps(out,ACCOP_STA,1,rV);
					GenAccOps(out,ACCOP_LDA,2,v1);
					GenAccOps(out,ACCOP_STA,2,rV);
					GenAccOps(out,ACCOP_LDA,3,v1);
					GenAccOps(out,ACCOP_STA,3,rV);
					break;
			}
			break;
	}
	return rV;
}

/**********************************************
** DoAssign - Generates the code for the various
** assignment statements
** parameters:
**	v1....value that is being assigned to
**	v2...value being assigned
**	op.....assignment operation
**
** returns value of assigned value
***********************************************/

void AssignOp(FILE *out, value *v1, value *v2)
{
	//----------------------------------
	// this is the fuction for doing just
	// a regular straight assign
	//
	// v1 must be in memory somehwere
	//---------------------------------
	link *t1 = v1->type;
	link *t2 = v2->type;

	switch(SizeOfRef(v1->type))
	{
		case 1:		//1 byte operations
			switch(v2->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location
				case VALUE_IS_CONSTANT:	//the value is a constant, should never have two that are
					GenAccOps(out,ACCOP_LDA,0,v2);
				case VALUE_IN_A	:	//value is located in the accumulator
					GenAccOps(out,ACCOP_STA,0,v1);
					break;
				case VALUE_POINT_TO:
					GenLoadRegWithConst(out,REGS_Y,0);
					GenAccOps(out,ACCOP_LDA,0,v2);
					GenAccOps(out,ACCOP_STA,0,v1);
					break;
			}
			break;
		case 2:		//2 byte operations
			switch(v2->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location
				case VALUE_IS_CONSTANT:	//the value is a constant
				case VALUE_POINT_TO:
					GenAccOps(out,ACCOP_LDA,0,v2);
					GenAccOps(out,ACCOP_STA,0,v1);
					GenAccOps(out,ACCOP_LDA,1,v2);
					GenAccOps(out,ACCOP_STA,1,v1);
					break;
				case VALUE_IN_A	:	//value is located in the accumulator
					break;
			}
			break;	
		case 4:		//4 byte operations
			switch(v2->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location
				case VALUE_IS_CONSTANT:	//the value is a constant
				case VALUE_POINT_TO:
					GenAccOps(out,ACCOP_LDA,0,v2);
					GenAccOps(out,ACCOP_STA,0,v1);
					GenAccOps(out,ACCOP_LDA,1,v2);
					GenAccOps(out,ACCOP_STA,1,v1);
					GenAccOps(out,ACCOP_LDA,2,v2);
					GenAccOps(out,ACCOP_STA,2,v1);
					GenAccOps(out,ACCOP_LDA,3,v2);
					GenAccOps(out,ACCOP_STA,3,v1);
					break;
				case VALUE_IN_A	:	//value is located in the accumulator
					break;
			}
			break;
	}
}

void AssignOpOp(FILE *out, value *v1, value *v2,int op)
{
	//------------------------------------------------
	// Very similar to a regular binary operation
	// but, v1 will always be a memory location
	// and that is where the final value will end up
	//------------------------------------------------
	link *t1 = v1->type;
	link *t2 = v2->type;
	char *Lable;

	switch(SizeOfRef(v1->type))
	{
		case 1:		//1 byte operations
			switch(v2->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location
					GenAccOps(out,ACCOP_LDA,0,v2);
				case VALUE_IN_A	:	//value is located in the accumulator
					if(AddSubPre[op] >= 0) GenSetClr(out,AddSubPre[op]);
					GenAccOps(out,op,0,v1);
					GenAccOps(out,ACCOP_STA,0,v1);
					break;
				case VALUE_IS_CONSTANT:	//the value is a constant, should never have two that are
					if((v2->type->V_ULONG == 1) && (op == ACCOP_ADC))	//incrment/decrement by 1?
					{
						GenInc(out,REG_INC,0,v1);
					}
					else if ((v2->type->V_ULONG == 1) && (op == ACCOP_SBC))
					{
						GenInc(out,REG_DEC,0,v1);
					}
					else
					{
						GenAccOps(out,ACCOP_LDA,0,v2);
						if(AddSubPre[op] >= 0) GenSetClr(out,AddSubPre[op]);
						GenAccOps(out,op,0,v1);
						GenAccOps(out,ACCOP_STA,0,v1);
					}
					break;
			}
			break;
		case 2:		//2 byte operations
			switch(v2->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location
					GenAccOps(out,ACCOP_LDA,0,v2);
					if(AddSubPre[op] >= 0) GenSetClr(out,AddSubPre[op]);
					GenAccOps(out,op,0,v1);
					GenAccOps(out,ACCOP_STA,0,v1);
					GenAccOps(out,ACCOP_LDA,1,v2);
					GenAccOps(out,op,1,v1);
					GenAccOps(out,ACCOP_STA,1,v1);
					break;
				case VALUE_IN_A	:	//value is located in the accumulator
					break;
				case VALUE_IS_CONSTANT:	//the value is a constant
					if((v2->type->V_ULONG == 1) && (op == ACCOP_ADC))	//incrment/decrement by 1?
					{
						Lable = GenLabel(GetCurrentProc()->name);
						GenInc(out,REG_INC,0,v1);
						GenBranch(out,BRANCH_BCC,Lable);
						GenInc(out,REG_INC,1,v1);
						OutputLable(out,Lable);
						free(Lable);
					}
					else if ((v2->type->V_ULONG == 1) && (op == ACCOP_SBC))
					{
						Lable = GenLabel(GetCurrentProc()->name);
						GenInc(out,REG_DEC,0,v1);
						GenBranch(out,BRANCH_BCC,Lable);
						GenInc(out,REG_DEC,1,v1);
						OutputLable(out,Lable);
						free(Lable);
					}
					else
					{
						GenAccOps(out,ACCOP_LDA,0,v2);
						if(AddSubPre[op] >= 0) GenSetClr(out,AddSubPre[op]);
						GenAccOps(out,op,0,v1);
						GenAccOps(out,ACCOP_STA,0,v1);
						GenAccOps(out,ACCOP_LDA,1,v2);
						GenAccOps(out,op,1,v1);
						GenAccOps(out,ACCOP_STA,1,v1);
					}
					break;
			}
			break;	
		case 4:		//4 byte operations
			switch(v2->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location
					GenAccOps(out,ACCOP_LDA,0,v2);
					if(AddSubPre[op] >= 0) GenSetClr(out,AddSubPre[op]);
					GenAccOps(out,op,0,v1);
					GenAccOps(out,ACCOP_STA,0,v1);
					GenAccOps(out,ACCOP_LDA,1,v2);
					GenAccOps(out,op,1,v1);
					GenAccOps(out,ACCOP_STA,1,v1);
					GenAccOps(out,ACCOP_LDA,2,v2);
					GenAccOps(out,op,2,v1);
					GenAccOps(out,ACCOP_STA,2,v1);
					GenAccOps(out,ACCOP_LDA,3,v2);
					GenAccOps(out,op,3,v1);
					GenAccOps(out,ACCOP_STA,3,v1);
					break;
				case VALUE_IN_A	:	//value is located in the accumulator
					break;
				case VALUE_IS_CONSTANT:	//the value is a constant
					if((v2->type->V_ULONG == 1) && (op == ACCOP_ADC))	//incrment/decrement by 1?
					{
						Lable = GenLabel(GetCurrentProc()->name);
						GenInc(out,REG_INC,0,v1);
						GenBranch(out,BRANCH_BCC,Lable);
						GenInc(out,REG_INC,1,v1);
						GenBranch(out,BRANCH_BCC,Lable);
						GenInc(out,REG_INC,2,v1);
						GenBranch(out,BRANCH_BCC,Lable);
						GenInc(out,REG_INC,3,v1);
						OutputLable(out,Lable);
						free(Lable);
					}
					else if ((v2->type->V_ULONG == 1) && (op == ACCOP_SBC))
					{
						Lable = GenLabel(GetCurrentProc()->name);
						GenInc(out,REG_DEC,0,v1);
						GenBranch(out,BRANCH_BCC,Lable);
						GenInc(out,REG_DEC,1,v1);
						GenBranch(out,BRANCH_BCC,Lable);
						GenInc(out,REG_DEC,2,v1);
						GenBranch(out,BRANCH_BCC,Lable);
						GenInc(out,REG_DEC,3,v1);
						OutputLable(out,Lable);
						free(Lable);
					}
					else
					{
						GenAccOps(out,ACCOP_LDA,0,v2);
						if(AddSubPre[op] >= 0) GenSetClr(out,AddSubPre[op]);
						GenAccOps(out,op,0,v1);
						GenAccOps(out,ACCOP_STA,0,v1);
						GenAccOps(out,ACCOP_LDA,1,v2);
						GenAccOps(out,op,1,v1);
						GenAccOps(out,ACCOP_STA,1,v1);
						GenAccOps(out,ACCOP_LDA,2,v2);
						GenAccOps(out,op,2,v1);
						GenAccOps(out,ACCOP_STA,2,v1);
						GenAccOps(out,ACCOP_LDA,3,v2);
						GenAccOps(out,op,3,v1);
						GenAccOps(out,ACCOP_STA,3,v1);
					}
					break;
			}
			break;
	}
}

void ShiftAssign(FILE *out,value *v1,value *v2,int op)
{
	//---------------------------------
	// V1 is the value to be shifted
	// V2 is the amount to shift by
	// V1 is where the value will end up
	// V1 must be a memory location!
	//--------------------------------
	link *t1 = v1->type;
	link *t2 = v2->type;

	char *Lable = GenLabel(CurProc->name);
	int ShiftDir,ShiftInc;
	int ASRflag = 0;
	int Shift,Rotate;

	printf("Shift Assign Op = %d\n",op);
	if(op == ASSOP_SHL)
	{
		Shift = SHIFT_ASL;
		Rotate = SHIFT_ROL;
		ShiftDir = 0;
		ShiftInc = 1;
	}
	else
	{
		if(IS_UNSIGNED(t1))
			Shift = SHIFT_LSR;
		else
		{
			Shift = SHIFT_ROR;
			ASRflag = 1;
		}
		Rotate = SHIFT_ROR;
		ShiftDir = SizeOfRef(v1->type)-1;
		ShiftInc = -1;
	}
	switch(SizeOfRef(v1->type))
	{
		case 1:		//1 byte operations
			switch(v2->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location
				case VALUE_IS_CONSTANT:	//the value is a constant, should never have two that are
					GenLoadReg(out,REGS_X,0,v2);
					break;
				case VALUE_IN_A	:	//value is located in the accumulator	
					GenTransfer(out,XFER_TAX);
					break;
			}
			OutputLable(out,Lable);
			GenShift(out,Shift,0,v1);
			GenIncReg(out,REGS_X,REG_DEC);
			GenBranch(out,BRANCH_BNE,Lable);
			break;
		case 2:		//2 byte operations
			switch(v2->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location
				case VALUE_IS_CONSTANT:	//the value is a constant, should never have two that are
					GenLoadReg(out,REGS_X,0,v2);
					break;
				case VALUE_IN_A	:	//value is located in the accumulator	
					fprintf(stderr,"ERROR:BinOpOp:Invalid Value Location\n");
					break;
			}
			OutputLable(out,Lable);
			if(op == ASSOP_SHL)
			{
				GenShift(out,Shift,0,v1);
				GenShift(out,Rotate,1,v1);
			}
			else
			{
				if(ASRflag)
				{
					GenLoadRegWithConst(out,REGS_Y,0x80);
					GenIndexOp(out,INDEX_CPY,1,v1);
				}
				GenShift(out,Shift,1,v1);
				GenShift(out,Rotate,0,v1);
			}
			GenIncReg(out,REGS_X,REG_DEC);
			GenBranch(out,BRANCH_BNE,Lable);
			break;	
		case 4:		//4 byte operations
			switch(v2->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location
				case VALUE_IS_CONSTANT:	//the value is a constant, should never have two that are
					GenLoadReg(out,REGS_X,0,v2);
					break;
				case VALUE_IN_A	:	//value is located in the accumulator	
					fprintf(stderr,"ERROR:BinOpOp:Invalid Value Location\n");
					break;
			}
			OutputLable(out,Lable);
			if(op == ASSOP_SHL)
			{
				GenShift(out,Shift,0,v1);
				GenShift(out,SHIFT_ROL,1,v1);
				GenShift(out,SHIFT_ROL,2,v1);
				GenShift(out,SHIFT_ROL,3,v1);
			}
			else
			{
				if(ASRflag)
				{
					GenLoadRegWithConst(out,REGS_Y,0x80);
					GenIndexOp(out,INDEX_CPY,3,v1);
				}
				GenShift(out,Shift,3,v1);
				GenShift(out,SHIFT_ROR,2,v1);
				GenShift(out,SHIFT_ROR,1,v1);
				GenShift(out,SHIFT_ROR,0,v1);

			}
			GenIncReg(out,REGS_X,REG_DEC);
			GenBranch(out,BRANCH_BNE,Lable);
			break;
	}
}

value *DoAssign(FILE *out,value *v1,value *v2,int op,short rFlagV1,short rFlagV2)
{
	value *rV = NULL;

	switch (op)
	{
		case ASSOP_EQUALS:
			AssignOp(out,v1,v2);
			break;
		case ASSOP_ADD:
			AssignOpOp(out,v1,v2,ACCOP_ADC);
			break;
		case ASSOP_SUB:
			AssignOpOp(out,v1,v2,ACCOP_SBC);
			break;
		case ASSOP_MUL:
		case ASSOP_DIV:
		case ASSOP_MOD:
			fprintf(stderr,"Not Impleneted yet\n");
			break;
		case ASSOP_OR:
			AssignOpOp(out,v1,v2,ACCOP_ORA);
			break;
		case ASSOP_AND:
			AssignOpOp(out,v1,v2,ACCOP_AND);
			break;
		case ASSOP_XOR:
			AssignOpOp(out,v1,v2,ACCOP_EOR);
			break;
		case ASSOP_SHL:
			ShiftAssign(out,v1,v2,ASSOP_SHL);
			break;
		case ASSOP_SHR:
			ShiftAssign(out,v1,v2,ASSOP_SHR);
			break;
	}
	if(rFlagV1) discard_value(v1);
	if(rFlagV2) discard_value(v2);
	return rV;
}

void BranchOnValue(FILE *out,value *v,char *False,char *True)
{
	switch(SizeOfRef(v->type))
	{
		case 1:
			switch(v->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location
				case VALUE_IS_CONSTANT:	//the value is a constant
				case VALUE_POINT_TO:	//a value in a temp points to the value
					GenAccOps(out,ACCOP_LDA,0,v);
				case VALUE_IN_A	:	//value is located in the accumulator
					GenBranch(out,BRANCH_BNE,True);
					GenJump(out,False);
					break;
			}
			break;
		case 2:
			switch(v->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location
				case VALUE_IS_CONSTANT:	//the value is a constant
				case VALUE_POINT_TO:	//a value in a temp points to the value
					GenAccOps(out,ACCOP_LDA,0,v);
					GenAccOps(out,ACCOP_ORA,1,v);
					GenBranch(out,BRANCH_BNE,True);
					GenJump(out,False);
					break;
				case VALUE_IN_A	:	//value is located in the accumulator
					break;
			}
			break;
		case 4:
			switch(v->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location
				case VALUE_IS_CONSTANT:	//the value is a constant
				case VALUE_POINT_TO:	//a value in a temp points to the value
					GenAccOps(out,ACCOP_LDA,0,v);
					GenAccOps(out,ACCOP_ORA,1,v);
					GenAccOps(out,ACCOP_ORA,2,v);
					GenAccOps(out,ACCOP_ORA,3,v);
					GenBranch(out,BRANCH_BNE,True);
					GenJump(out,False);
					break;
				case VALUE_IN_A	:	//value is located in the accumulator
					break;
			}
			break;
	}

}

/*******************************************
** Stack Functions
******************************************/

STACK *newStack(int size)
{
	STACK *pS = malloc(sizeof(STACK) + sizeof(char *) * size);
	pS->Size = size;
	pS->Index = 0;
	pS->Stack = (char **)&pS[1];
	return pS;
}

char *StackGetTop(STACK *pS)
{
	char *rV;

	if(pS->Index > 0) rV = pS->Stack[pS->Index - 1];
	else rV = NULL;
	return rV;
}

char *StackPop(STACK *pS)
{
	char *rV;

	if(pS->Index > 0)
	{
		--pS->Index;
		rV = pS->Stack[pS->Index];
	}
	else rV = NULL;
	return rV;
}

void StackPush(STACK *pS,char *s)
{
	pS->Stack[pS->Index] = s;
	++pS->Index;
}

//----------------------------------------
// register allocation manager
//----------------------------------------

REGS *newREGS(void)
{
	REGS *rV = malloc(sizeof(REGS));
	rV->A = 0;
	rV->X = 0;
	rV->Y = 0;
	rV->pA = NULL;
	rV->pX = NULL;
	rV->pY = NULL;
	rV->Aval = -1;
	rV->Xval = -1;
	rV->Yval = -1;
	return rV;
}

/**********************************
** Aquire a register
**
** this funciton checks to see if
** the desired register is avialiable
** If it is, it will mark the reg as
** used and return true.  If it is
** in use, we return FALSE
**
** parameter
**
**	pR.....pointer to register use descriptor
**	reg....register that is desired
**********************************/

int REGSget(REGS *pR,int reg)
{
	int rv;
	switch(reg)
	{
		case REGS_A:
			if(pR->A) rv = 0;
			else
			{
				pR->A = 1;
				rv = 1;
			}
			break;
		case REGS_X:
			if(pR->X) rv = 0;
			else
			{
				pR->X = 1;
				rv = 1;
			}
			break;
		case REGS_Y:
			if(pR->Y) rv = 0;
			else
			{
				pR->Y = 1;
				rv = 1;
			}
			break;
	}
	return rv;
}

/******************************************
** Release a register
**
** When we are done using a register, we
** release to make it availiable for
** future use
**
** paramters:
**	pR.....pointer to register use descriptor
**	reg....register to be released
******************************************/

int REGSrel(REGS *pR,int reg)
{
	int rv= 1;
	switch(reg)
	{
		case REGS_A:
			pR->A = 0;
			pR->pA = NULL;
			pR->Aval = -1;
			break;
		case REGS_X:
			pR->X = 0;
			pR->pX = NULL;
			pR->Xval = -1;
			break;
		case REGS_Y:
			pR->Y = 0;
			pR->pY = NULL;
			pR->Yval = -1;
			break;
	}
	return rv;
}

/****************************************
** Check allocation status of the regs
** returns true if the reg is allocated
** returns false if it is not
****************************************/

int REGSchk(REGS *pR,int reg)
{
	int rv;
	switch(reg)
	{
		case REGS_A:
			rv = pR->A;
			break;
		case REGS_X:
			rv = pR->X;
			break;
		case REGS_Y:
			rv = pR->Y;
			break;
	}
	return rv;
}

/****************************************
**
** Set the value attatched to a register
**
** parameter:
**	pR.....pointer to the register data base
**	reg....register to attach a value to
**	pV.....pointer to the value structure to attach
*******************************************/

 int REGsetValue(REGS *pR,int reg,struct value *pV)
 {
	 int rv = 0;
 	switch(reg)
	{
		case REGS_A:
			if((pR->A) && (pR->Aval < 0))
			{
				pR->pA = pV;
				rv = 1;
			}
			break;
		case REGS_X:
			if((pR->X) && (pR->Xval < 0))
			{
				pR->pX = pV;
				rv = 1;
			}
			break;
		case REGS_Y:
			if((pR->Y) && (pR->Yval < 0))
			{
				pR->pY = pV;
				rv = 1;
			}
			break;
	}
	return rv;
}

 /****************************************
 ** Get the value attached to a register
 **
 ** parameters:
 **	pR.......pointer to the register data structure
 **	reg......register to get the attached value of
 **
 ** returns: pointer to attached value.
 **	returns NULL if there is no value or
 ** the register is not being used
 ***************************************/

 struct value *REGgetValue(REGS *pR,int reg)
 {
	 value *pV;

  	switch(reg)
	{
		case REGS_A:
			pV = pR->pA;
			break;
		case REGS_X:
			pV = pR->pX;
			break;
		case REGS_Y:
			pV = pR->pY;
			break;
	}
	return pV;
}

 /********************************************
 ** Set the constant value of a register.
 ** The register must be in use and there
 ** cannot be a value in the register.
 **
 ** parameters:
 **	pR......pointer to the register data base
 **	reg.....register to set the constant value to
 **	v......,constant value to set register to
 **
 ** returns: true if successful, false otherwise
 ********************************************/

int REGSsetConst(REGS *pR,int reg,int v)
{
	int rv = 0;
 	switch(reg)
	{
		case REGS_A:
			if((pR->A) && (!pR->pA))
			{
				pR->Aval = v;
				rv = 1;
			}

			break;
		case REGS_X:
			if((pR->X) && (!pR->pX))
			{
				pR->Xval = v;
				rv = 1;
			}
			break;
		case REGS_Y:
			if((pR->Y) && (!pR->pY))
			{
				pR->Yval = v;
				rv = 1;
			}
			break;
	}
	return rv;
}

int REGSgetConst(REGS *pR,int reg)
{
	int rv = 0;

 	switch(reg)
	{
		case REGS_A:
			rv = pR->Aval;
			break;
		case REGS_X:
			rv = pR->Xval;
			break;
		case REGS_Y:
			rv = pR->Yval;
			break;
	}
	return rv;
}

/****************************************
**  REGSisAnyRegSetTo returns any register
** that just so happens to have the desired
** value in it.
**
** parameters:
**	pR......pointer to registers structure
**	v.......value we are looking for
**
** returns:
** negative on no match, register number on 
** success
**
******************************************/

int REGSisAnyRegSetTo(REGS *pR, int v)
{
	int i;
	int rv = -1;

	for(i=0;i<3;++i)	//check all regs
	{
		if(REGSgetConst(pR,i) == v)
		{
			rv = i;
			i = 1000;	//break out of loop
		}
	}
	return rv;
}

/*********************************************
** Generate code to negate a number
********************************************/

value *DoNegative(FILE *out,value *v)
{
	value *rv;
	value *tmp;
	switch(SizeOfRef(v->type))
	{
		case 1:
			rv = ValueInAccumulator(v->type);
			switch(v->ValLoc)
			{
				case VALUE_IN_A	:	//value is located in the accumulator
					tmp = ValueInTemp(v->type);
					GenAccOps(out,ACCOP_STA,0,tmp);
					release_value(v);
					v = tmp;
				case VALUE_POINT_TO:	//a value in a temp points to the value				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location
					GenLoadRegWithConst(out,REGS_A,0);
					GenSetClr(out,STATUS_SEC);
					GenAccOps(out,ACCOP_SBC,0,v);
					break;
				case VALUE_IS_CONSTANT:	//the value is a constant
					v->type->V_LONG = -v->type->V_LONG;
					rv = v;
					break;
			}
			break;
		case 2:
			switch(v->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location	
				case VALUE_POINT_TO:	//a value in a temp points to the value
					if((v->ValLoc == VALUE_IN_MEM) || (VALUE_POINT_TO == v->ValLoc))
						rv = ValueInTemp(v->type);
					else
						rv = v;
					GenLoadRegWithConst(out,REGS_A,0);
					GenSetClr(out,STATUS_SEC);
					GenAccOps(out,ACCOP_SBC,0,v);
					GenAccOps(out,ACCOP_STA,0,rv);
					GenLoadRegWithConst(out,REGS_A,0);
					GenAccOps(out,ACCOP_SBC,1,v);
					GenAccOps(out,ACCOP_STA,1,rv);
					break;
				case VALUE_IN_A	:	//value is located in the accumulator
					break;
				case VALUE_IS_CONSTANT:	//the value is a constant
					v->type->V_LONG = -v->type->V_LONG;
					rv = v;
					break;
			}
			break;
		case 4:
			switch(v->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location
				case VALUE_POINT_TO:	//a value in a temp points to the value
					if((v->ValLoc == VALUE_IN_MEM) || (VALUE_POINT_TO == v->ValLoc))
						rv = ValueInTemp(v->type);
					else
						rv = v;
					GenLoadRegWithConst(out,REGS_A,0);
					GenSetClr(out,STATUS_SEC);
					GenAccOps(out,ACCOP_SBC,0,v);
					GenAccOps(out,ACCOP_STA,0,rv);
					GenLoadRegWithConst(out,REGS_A,0);
					GenAccOps(out,ACCOP_SBC,1,v);
					GenAccOps(out,ACCOP_STA,1,rv);
					GenLoadRegWithConst(out,REGS_A,0);
					GenAccOps(out,ACCOP_SBC,2,v);
					GenAccOps(out,ACCOP_STA,2,rv);
					GenLoadRegWithConst(out,REGS_A,0);
					GenAccOps(out,ACCOP_SBC,3,v);
					GenAccOps(out,ACCOP_STA,3,rv);
					break;
				case VALUE_IN_A	:	//value is located in the accumulator
					break;
				case VALUE_IS_CONSTANT:	//the value is a constant
					v->type->V_LONG = -v->type->V_LONG;
					rv = v;
					break;
			}
			break;
	}
	return rv;
}

static void StoreParam(FILE *out,int index)
{
	/*****************************************
	** assume that the value to be stored is
	** in the accumulator
	****************************************/
	switch(index)
	{
		case 0:	//save param into A reg
			// do nothing...
			break;
		case 1:	//save param into X reg
			fprintf(out,"\tTAX\n");
			break;
		case 2:	//save param into Y reg
			fprintf(out,"\tTAY\n");
			break;
		default:	//save into page zero memory
			fprintf(out,"\tSTA\t$%02x\n",0xa0+index);
			break;
	}
}

/***********************************************************
** Generate code for passing parameters
**
** out.....pointer to file stream to output data to
** v.......value to pass to called function
** pP.....pointer to descriptor that describes number of params
** param..parameter position in list of pased params
**
** if there are a total of of n parameters (vvalue in
** pP->Nparams), the value of param will range from
** 0 to n-1.  Where 0 is the first parameter in the
** function call... ( afunc(first,second,third...) )
** The first byte of a function call is stored in
** reg A, the second in reg X, the third in reg Y.
** After this, params are stored in pgae 0 mem locations
** starting at $A3.  Traditionally, ACTION! limits
** the number of passed parameters to 16 bytes.
**********************************************************/

void Passparameter(FILE *out,value *v,PARAMS *pP, int param)
{
	//--------------------------------
	// calculate index of where param
	// is going to be stored.
	//-------------------------------
	int Index;
	int i;

	for(i=0,Index = 0;i<param;++i)
	{
		Index += pP->Psize[i];
	}
//	printf("Index of param %s is %d\n",v->name,Index);
	switch(SizeOfRef(v->type))
	{
		case 1:	//one byte value
			switch(v->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location
				case VALUE_IS_CONSTANT:	//the value is a constant
				case VALUE_POINT_TO:	//a value in a temp points to the value
					GenAccOps(out,ACCOP_LDA,0,v);
				case VALUE_IN_A	:	//value is located in the accumulator
					break;
			}
			StoreParam(out,Index);
			break;
		case 2:	//two byte value
				//It should be noted that we will start at index + 1
				// this is so that the LSB will end up in the accumulator
				//if the index is 0
			switch(v->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location
				case VALUE_IS_CONSTANT:	//the value is a constant
				case VALUE_POINT_TO:	//a value in a temp points to the value
					GenAccOps(out,ACCOP_LDA,1,v);
					StoreParam(out,Index+1);
					GenAccOps(out,ACCOP_LDA,0,v);
					StoreParam(out,Index);
					break;
				case VALUE_IN_A	:	//value is located in the accumulator
					break;
			}
			break;
		case 4:	//four byte value
			switch(v->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location
				case VALUE_IS_CONSTANT:	//the value is a constant
				case VALUE_POINT_TO:	//a value in a temp points to the value
					GenAccOps(out,ACCOP_LDA,3,v);
					StoreParam(out,Index+3);
					GenAccOps(out,ACCOP_LDA,2,v);
					StoreParam(out,Index+2);
					GenAccOps(out,ACCOP_LDA,1,v);
					StoreParam(out,Index+1);
					GenAccOps(out,ACCOP_LDA,0,v);
					StoreParam(out,Index);
					break;
				case VALUE_IN_A	:	//value is located in the accumulator
					break;
			}
			break;
	}
}

value *DoReturn(FILE *out,value *v,int Nret)
{
	value *rv;
	if(Nret != SizeOfType(v->type))
	{
		fprintf(stderr,"WARNING:Type Mismatch in Fucntion Return\n");
	}
	switch(SizeOfRef(v->type))
	{
		case 1:	//leave return value in accumulator
			switch(v->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location
				case VALUE_IS_CONSTANT:	//the value is a constant
				case VALUE_POINT_TO:	//a value in a temp points to the value
					GenAccOps(out,ACCOP_LDA,0,v);
					break;
				case VALUE_IN_A	:	//value is located in the accumulator
					break;
			}
			rv = v;
			break;
		case 2:	//return value save in __ARGS
			rv = new_value();
			rv->type = clone_type(v->type,&rv->etype);
			rv->ValLoc = VALUE_IN_MEM;
			strcpy(rv->name,"__ARGS");
			switch(v->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location
				case VALUE_IS_CONSTANT:	//the value is a constant
				case VALUE_POINT_TO:	//a value in a temp points to the value
					GenAccOps(out,ACCOP_LDA,0,v);
					GenAccOps(out,ACCOP_STA,0,rv);
					GenAccOps(out,ACCOP_LDA,1,v);
					GenAccOps(out,ACCOP_STA,1,rv);
					break;
				case VALUE_IN_A	:	//value is located in the accumulator
					break;
			}
			break;
		case 4:
			rv = new_value();
			rv->type = clone_type(v->type,&rv->etype);
			rv->ValLoc = VALUE_IN_MEM;
			strcpy(rv->name,"__ARGS");
			switch(v->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location
				case VALUE_IS_CONSTANT:	//the value is a constant
				case VALUE_POINT_TO:	//a value in a temp points to the value
					GenAccOps(out,ACCOP_LDA,0,v);
					GenAccOps(out,ACCOP_STA,0,rv);
					GenAccOps(out,ACCOP_LDA,1,v);
					GenAccOps(out,ACCOP_STA,1,rv);
					GenAccOps(out,ACCOP_LDA,2,v);
					GenAccOps(out,ACCOP_STA,2,rv);
					GenAccOps(out,ACCOP_LDA,3,v);
					GenAccOps(out,ACCOP_STA,3,rv);
					break;
				case VALUE_IN_A	:	//value is located in the accumulator
					break;
			}
			break;
	}
	return rv;
}

value *DoArrayRef(FILE *out,value *v1,value *v2)
{
	value *rv;

	switch(SizeOfRef(v1->type))
	{
		case 1:	//byte array
			rv = DoArrayRefByte(out,v1,v2);
			break;
		case 2:	//card array
			rv = DoArrayRefCard(out,v1,v2);
			break;	
		case 4:	//long array
			rv = DoArrayRefLong(out,v1,v2);
			break;
	}
	return rv;
}

static value *DoArrayRefByte(FILE *out,value *v1,value *v2)
{
	/******************************************
	** Generate code for doing a reference to
	** an array elelment
	**
	** parameter:
	**	out.......FILE pointer to utupt stream
	**	v1........Array Variable...should pretty
	**			much always point directly or
	**			almost directly to a variable name
	**	v2......Index of array
	**
	** returns a pointer to a value that is of
	** POINTER_TO_MEM
	**
	** The code generated needs to calculate
	** a runtime address.  So we start with
	** the address of the array and add to
	** that the approriate index.
	** For a byte, the index is used as
	** is, for a CARD or INT, we need to
	** to shift the index one bit Left (*2),
	** and for a LONG we need to shift
	** the index 2 bits left (mult by 4)
	**
	** If the array is 256 bytes or less, we
	** can use absolute indexed indexing/
	** If the array size is greater than 256
	** bytes, then we must use indirect 
	** addressing.
	******************************************/
	value *rv;	//where the return value is placed
	link *s;
	int dim;

//	printf("Enter Do Array Ref %s[%s]\n",v1->name,v2->name);
//	printf("Size of Array  %s[%s] = %d\n",v1->name,v2->name,SizeOfRef(v1->type));
	//----------------------------------------
	// v1 should always be located in memory
	//----------------------------------------
	dim = v1->type->next->select.d.num_ele;
	printf("Size of Array is %d\n",dim);
	s = new_link();
	s->tclass = SYMTAB_SPECIFIER;
	s->SYMTAB_NOUN = SYMTAB_INT;
	s->SYMTAB_UNSIGNED = 1;
	rv = CreateTemp(s,2);

	//--------------------------------
	// we need to create a poiinter
	// to the memory location in the
	// array, so v1 will have a size
	// of "2" for all we care.
	// Before we exit though, we need
	// to make sure upstream generators
	// know the size of the object that
	// was being pointed to.
	//---------------------------------
	switch(SizeOfRef(v2->type))	//size of index
	{
		case 1:	//BYTE and CHAR indexes
			switch(v1->ValLoc)	//where is the base?
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location
					switch(v2->ValLoc)	//where is the index?
					{
						case VALUE_IN_MEM:	//value is located in a variable location
						case VALUE_IN_TMP:	//value is located in a temporary location
						case VALUE_IS_CONSTANT:	//the value is a constant
							GenLoadRegWithVal(out,REGS_A,0,v1);
							GenSetClr(out,STATUS_CLC);
							GenAccOps(out,ACCOP_ADC,0,v2);
							GenAccOps(out,ACCOP_STA,0,rv);
							GenLoadRegWithVal(out,REGS_A,1,v1);
							GenAccOps(out,ACCOP_ADC,1,v2);
							GenAccOps(out,ACCOP_STA,1,rv);
							break;
						case VALUE_POINT_TO:	//a value in a temp points to the value
							GenLoadRegWithConst(out,REGS_Y,0);	//load Y with 0
							GenAccOps(out,ACCOP_LDA,0,v2);
							GenSetClr(out,STATUS_CLC);
							GenAccOps(out,ACCOP_ADC,0,v1);
							GenAccOps(out,ACCOP_STA,0,rv);
							GenIncReg(out,REGS_Y,REG_INC);
							GenAccOps(out,ACCOP_LDA,1,v2);
							GenAccOps(out,ACCOP_ADC,1,v1);
							GenAccOps(out,ACCOP_STA,1,rv);
							break;
					}
					break;
				case VALUE_IS_CONSTANT:	//the value is a constant
				case VALUE_POINT_TO:	//a value in a temp points to the value
					break;
			}
			break;
		case 2:	//INT and CARD indexes
			switch(v1->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location
					switch(v2->ValLoc)
					{
						case VALUE_IN_MEM:	//value is located in a variable location
						case VALUE_IN_TMP:	//value is located in a temporary location
						case VALUE_IS_CONSTANT:	//the value is a constant
							GenLoadRegWithVal(out,REGS_A,0,v1);
							GenSetClr(out,STATUS_CLC);
							GenAccOps(out,ACCOP_ADC,0,v2);
							GenAccOps(out,ACCOP_STA,0,rv);
							GenLoadRegWithVal(out,REGS_A,1,v1);
							GenAccOps(out,ACCOP_ADC,1,v2);
							GenAccOps(out,ACCOP_STA,1,rv);
							break;
						case VALUE_IN_A	:	//value is located in the accumulator
							break;
						case VALUE_POINT_TO:	//a value in a temp points to the value
							GenLoadRegWithConst(out,REGS_Y,0);	//load Y with 0
							GenAccOps(out,ACCOP_LDA,0,v2);
							GenSetClr(out,STATUS_CLC);
							GenAccOps(out,ACCOP_ADC,0,v1);
							GenAccOps(out,ACCOP_STA,0,rv);
							GenIncReg(out,REGS_Y,REG_INC);
							GenAccOps(out,ACCOP_LDA,1,v2);
							GenAccOps(out,ACCOP_ADC,1,v1);
							GenAccOps(out,ACCOP_STA,1,rv);
							break;
					}
					break;
				case VALUE_IN_A	:	//value is located in the accumulator
				case VALUE_IS_CONSTANT:	//the value is a constant
				case VALUE_POINT_TO:	//a value in a temp points to the value
					break;
			}
			break;
		case 4:	//LONG indexes
			switch(v1->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location
					switch(v2->ValLoc)
					{
						case VALUE_IN_MEM:	//value is located in a variable location
						case VALUE_IN_TMP:	//value is located in a temporary location
						case VALUE_IS_CONSTANT:	//the value is a constant
							GenLoadRegWithVal(out,REGS_A,0,v1);
							GenSetClr(out,STATUS_CLC);
							GenAccOps(out,ACCOP_ADC,0,v2);
							GenAccOps(out,ACCOP_STA,0,rv);
							GenLoadRegWithVal(out,REGS_A,1,v1);
							GenAccOps(out,ACCOP_ADC,1,v2);
							GenAccOps(out,ACCOP_STA,1,rv);
							break;
						case VALUE_IN_A	:	//value is located in the accumulator
							break;
						case VALUE_POINT_TO:	//a value in a temp points to the value
							break;
					}
					break;
				case VALUE_IN_A	:	//value is located in the accumulator
				case VALUE_IS_CONSTANT:	//the value is a constant
				case VALUE_POINT_TO:	//a value in a temp points to the value
					break;
			}
			break;
	}
	rv->type->SYMTAB_NOUN = v1->type->SYMTAB_NOUN;
	rv->type->SYMTAB_UNSIGNED = v1->type->SYMTAB_UNSIGNED;
	rv->type->SYMTAB_LONG = v1->type->SYMTAB_LONG;
	rv->ValLoc = VALUE_POINT_TO;
	return rv;
}

static value *DoArrayRefCard(FILE *out,value *v1,value *v2)
{
	value *rv;	//where the return value is placed
	link *s;
	int dim;
	value *pAcc;	//dummy value for accumulator
	link *bs;
	int RefSize;

	bs = new_link();
	bs->tclass = SYMTAB_SPECIFIER;
	bs->SYMTAB_NOUN = SYMTAB_CHAR;
	bs->SYMTAB_UNSIGNED = 0;
	pAcc = ValueInAccumulator(bs);
	dim = v1->type->next->select.d.num_ele;
	printf("Sizeof Array is %d\n",dim);
	s = new_link();
	s->tclass = SYMTAB_SPECIFIER;
	s->SYMTAB_NOUN = SYMTAB_INT;
	s->SYMTAB_UNSIGNED = 1;
	rv = CreateTemp(s,2);
	RefSize = SizeOfRef(v2->type);
	switch(RefSize)	//size of index
	{
		case 1:	//BYTE and CHAR indexes
		case 2:	//card and int indexes
		case 4:
			GenAccOps(out,ACCOP_LDA,0,v2);
			GenShift(out,SHIFT_ASL,0,pAcc);
			GenStackOper(out,STACK_PHP);
			GenSetClr(out,STATUS_CLC);
			GenAccOps(out,ACCOP_ADC,0,v1);
			GenAccOps(out,ACCOP_STA,0,rv);
			if(RefSize == 1)
			{
				GenLoadRegWithConst(out,REGS_A,0);
			}
			else
			{
				GenAccOps(out,ACCOP_LDA,1,v2);
			}
			GenShift(out,SHIFT_ROL,0,pAcc);
			GenStackOper(out,STACK_PLP);
			GenAccOps(out,ACCOP_ADC,1,v1);
			GenAccOps(out,ACCOP_STA,1,rv);
			break;
	}	//end of switch(SizeOfRef)
	rv->type->SYMTAB_NOUN = v1->type->SYMTAB_NOUN;
	rv->type->SYMTAB_UNSIGNED = v1->type->SYMTAB_UNSIGNED;
	rv->type->SYMTAB_LONG = v1->type->SYMTAB_LONG;
	rv->ValLoc = VALUE_POINT_TO;
	return rv;
}

static value *DoArrayRefLong(FILE *out,value *v1,value *v2)
{
	value *rv;	//where the return value is placed
	link *s;
	int dim;
	char *Lable,*tS;
	int RefSize;

	tS = malloc(128);
	sprintf(tS,"%s_LIND",GetCurrentProc()->name);
	Lable = GenLabel(tS);
	free(tS);
	dim = v1->type->next->select.d.num_ele;
	printf("Sizeof Array is %d\n",dim);
	s = new_link();
	s->tclass = SYMTAB_SPECIFIER;
	s->SYMTAB_NOUN = SYMTAB_INT;
	s->SYMTAB_UNSIGNED = 1;
	rv = CreateTemp(s,2);

	RefSize = SizeOfRef(v2->type);
	switch(RefSize)	//size of index
	{
		case 1:	//BYTE and CHAR indexes
		case 2:
		case 4:
			GenAccOps(out,ACCOP_LDA,0,v2);
			GenAccOps(out,ACCOP_STA,0,rv);
			if(RefSize == 1)
			{
				GenLoadRegWithConst(out,REGS_Y,0);
				GenIndexOp(out,INDEX_STY,1,rv);
			}
			else
			{
				GenAccOps(out,ACCOP_LDA,1,v2);
				GenAccOps(out,ACCOP_STA,1,rv);
			}
			GenLoadRegWithConst(out,REGS_Y,2);
			OutputLable(out,Lable);
			GenShift(out,SHIFT_ASL,0,rv);
			GenShift(out,SHIFT_ROL,1,rv);
			GenIncReg(out,REGS_Y,REG_DEC);
			GenBranch(out,BRANCH_BNE,Lable);
			REGSsetConst(Regs,REGS_Y,0);	//	Reg Y will be zero here
			GenAccOps(out,ACCOP_LDA,0,v1);
			GenSetClr(out,STATUS_CLC);
			GenAccOps(out,ACCOP_ADC,0,rv);
			GenAccOps(out,ACCOP_STA,0,rv);
			GenAccOps(out,ACCOP_LDA,1,v1);
			GenAccOps(out,ACCOP_ADC,1,rv);
			GenAccOps(out,ACCOP_STA,1,rv);
			break;
	}	//end of switch(SizeOfRef)
	rv->type->SYMTAB_NOUN = v1->type->SYMTAB_NOUN;
	rv->type->SYMTAB_UNSIGNED = v1->type->SYMTAB_UNSIGNED;
	rv->type->SYMTAB_LONG = v1->type->SYMTAB_LONG;
	rv->ValLoc = VALUE_POINT_TO;
	return rv;
}
