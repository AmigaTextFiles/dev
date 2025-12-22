/*********************************************
** This is a collection of rotines for generating
** short sections of code
**
** Created March 8, 2010
** By Jim Patchell
***********************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "symtab.h"
#include "value.h"
#include "codegen.h"
#include "gen.h"
#include "temp.h"


value *SkelGen(FILE *out,value *v)
{
	value *rv = NULL;
	switch(SizeOfRef(v->type))
	{
		case 1:
			switch(v->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
					break;
				case VALUE_IN_TMP:	//value is located in a temporary location
					break;
				case VALUE_IN_A	:	//value is located in the accumulator
					break;
				case VALUE_IS_CONSTANT:	//the value is a constant
					break;
				case VALUE_POINT_TO:	//a value in a temp points to the value
					break;
			}
			break;
		case 2:
			switch(v->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
					break;
				case VALUE_IN_TMP:	//value is located in a temporary location
					break;
				case VALUE_IN_A	:	//value is located in the accumulator
					break;
				case VALUE_IS_CONSTANT:	//the value is a constant
					break;
				case VALUE_POINT_TO:	//a value in a temp points to the value
					break;
			}
			break;
		case 4:
			switch(v->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
					break;
				case VALUE_IN_TMP:	//value is located in a temporary location
					break;
				case VALUE_IN_A	:	//value is located in the accumulator
					break;
				case VALUE_IS_CONSTANT:	//the value is a constant
					break;
				case VALUE_POINT_TO:	//a value in a temp points to the value
					break;
			}
			break;
	}
	return rv;
}

value *SaveToTemp(FILE *out,value *v)
{
	value *rV;
	int Handle,Index;

	if(v->ValLoc != VALUE_IN_TMP)
	{
		rV = new_value();
		Handle = GetTemp(SizeOfRef(v->type),&Index);
		MakeTempName(rV->name,Index);
		rV->type = clone_type(v->type,&rV->etype);
		rV->ValLoc = VALUE_IN_TMP;
		rV->offset = Index;
		rV->is_tmp = Handle;
	}
	switch(SizeOfRef(v->type))
	{
		case 1:	//BYTE
			switch(v->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
					fprintf(out,"\tLDA\t%s\n",v->name);
					fprintf(out,"\tSTA\t%s\n",rV->name);
					break;
				case VALUE_IN_TMP:	//value is located in a temporary location
					rV = v;
					break;
				case VALUE_IN_A	:	//value is located in the accumulator
					fprintf(out,"\tSTA\t%s\n",rV->name);
					break;
				case VALUE_IS_CONSTANT:	//the value is a constant
					fprintf(out,"\tLDA\t#%d\n",LOW(v->type->V_ULONG));
					fprintf(out,"\tSTA\t%s\n",rV->name);
					break;
			}
			break;
		case 2:	//INT,CARD,POINTER
			switch(v->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
					fprintf(out,"\tLDA\t%s\n",v->name);
					fprintf(out,"\tSTA\t%s\n",rV->name);
					fprintf(out,"\tLDA\t%s+1\n",v->name);
					fprintf(out,"\tSTA\t%s+1\n",rV->name);
					break;
				case VALUE_IN_TMP:	//value is located in a temporary location
					rV = v;	//do nothing
					break;
				case VALUE_IN_A	:	//value is located in the accumulator
					fprintf(stderr,"ERROR:SaveToTemp:Invalid Value Location\n");
					break;
				case VALUE_IS_CONSTANT:	//the value is a constant
					fprintf(out,"\tLDA\t#%d\n",LOW(v->type->V_ULONG));
					fprintf(out,"\tSTA\t%s\n",rV->name);
					fprintf(out,"\tLDA\t#%d\n",LOWMID(v->type->V_ULONG));
					fprintf(out,"\tSTA\t%s+1\n",rV->name);
					break;
			}
			break;
		case 4:	//LONG
			switch(v->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
					fprintf(out,"\tLDA\t%s\n",v->name);
					fprintf(out,"\tSTA\t%s\n",rV->name);
					fprintf(out,"\tLDA\t%s+1\n",v->name);
					fprintf(out,"\tSTA\t%s+1\n",rV->name);
					fprintf(out,"\tLDA\t%s+2\n",v->name);
					fprintf(out,"\tSTA\t%s+2\n",rV->name);
					fprintf(out,"\tLDA\t%s+3\n",v->name);
					fprintf(out,"\tSTA\t%s+3\n",rV->name);
					break;
				case VALUE_IN_TMP:	//value is located in a temporary location
					rV = v;
					break;
				case VALUE_IN_A	:	//value is located in the accumulator
					fprintf(stderr,"ERROR:SaveToTemp:Invalid Value Location\n");
					break;
				case VALUE_IS_CONSTANT:	//the value is a constant
					fprintf(out,"\tLDA\t#%d\n",LOW(v->type->V_ULONG));
					fprintf(out,"\tSTA\t%s\n",rV->name);
					fprintf(out,"\tLDA\t#%d\n",LOWMID(v->type->V_ULONG));
					fprintf(out,"\tSTA\t%s+1\n",rV->name);
					fprintf(out,"\tLDA\t#%d\n",HIGHMID(v->type->V_ULONG));
					fprintf(out,"\tSTA\t%s+2\n",rV->name);
					fprintf(out,"\tLDA\t#%d\n",HIGH(v->type->V_ULONG));
					fprintf(out,"\tSTA\t%s+3\n",rV->name);
					break;
			}
			break;
	}
	return rV;
}

int ValInMem(value *v)
{
	int rV = 0;

	switch(v->ValLoc)
	{
		case VALUE_IN_MEM:	//value is located in a variable location
		case VALUE_IN_TMP:	//value is located in a temporary location
		case VALUE_IS_CONSTANT:	//the value is a constant
			rV = 1;
			break;
		case VALUE_IN_A	:	//value is located in the accumulator
			rV = 0;
			break;
	}
	return rV;
}


const char * const AccOps[] = {
	"ADC",//	0
	"SBC",//	1
	"CMP",//	2
	"AND",	//	3
	"ORA",//	4
	"EOR",//	5
	"LDA",	//6
	"STA",	//7
	"ADC",//	0 X index register
	"SBC",//	1
	"CMP",//	2
	"AND",	//	3
	"ORA",//	4
	"EOR",//	5
	"LDA",	//6
	"STA",	//7
	"ADC",//	0	Y Index Register
	"SBC",//	1
	"CMP",//	2
	"AND",	//	3
	"ORA",//	4
	"EOR",//	5
	"LDA",	//6
	"STA"	//7
};

void GenAccOpsConst(FILE *out,int Op,int OpWord,int v)
{
	int c,flag;

	switch(OpWord)
	{
		case 0:
			c = LOW(v);
			break;
		case 1:
			c = LOWMID(v);
			break;
		case 2:
			c = HIGHMID(v);
			break;
		case 3:
			c = HIGH(v);
			break;
	}
	flag = REGSget(Regs,REGS_A);
	switch(Op)
	{
		case ACCOP_ADC:
			if(flag >= 0) Regs->Aval += c;
			break;
		case ACCOP_SBC:
			if(flag >= 0) Regs->Aval -= c;
			break;
		case ACCOP_CMP:
			break;
		case ACCOP_AND:
			if(flag >= 0) Regs->Aval &= c;
			break;
		case ACCOP_ORA:
			if(flag >= 0) Regs->Aval |= c;
			break;
		case ACCOP_EOR:
			if(flag >= 0) Regs->Aval ^= c;
			break;
		case ACCOP_LDA:
			if(flag >= 0) Regs->Aval = c;
			break;
	}
	fprintf(out,"\t%s\t#%d\n",AccOps[Op],c);
}


/***************************************************************
** Generate an instruction that operates on the accumulator
**
** parameters:
**	out.....pointer to the output file stream
**	Op.....Thyp of accumulator operation to be done (Instruction)
**	OpWord..In multi byte operaands, which byte3 is it?
**	pV.....pointer to the value being operated on
***************************************************************/

void GenAccOps(FILE *out,int Op,int OpWord,value *pV)
{
	int v;
	int regv;
	int i,c;
	int GenFlag = 1;

	switch(pV->ValLoc)
	{
		case VALUE_IN_TMP:
		case VALUE_IN_MEM:
			if(!(ACCOP_CMP == Op || ACCOP_STA == Op))
			{
				Regs->Aval = -1;
				Regs->pA = NULL;	//value in register indetermniate
			}
			fprintf(out,"\t%s\t%s+%d\n",AccOps[Op],pV->name,OpWord);
			break;
		case VALUE_IS_CONSTANT:
			switch(OpWord)
			{
				case 0:
					v = LOW(pV->type->V_ULONG);
					break;
				case 1:
					v = LOWMID(pV->type->V_ULONG);
					break;
				case 2:
					v = HIGHMID(pV->type->V_ULONG);
					break;
				case 3:
					v = HIGH(pV->type->V_ULONG);
					break;
			}
			if(Op == ACCOP_LDA)
			{
				if(v != Regs->Aval)
					Regs->Aval = v;
				else
					GenFlag = 0;	//don't generate another line of code
			}
			else if(!(ACCOP_CMP == Op || ACCOP_STA == Op))
			{
				Regs->Aval = -1;
				Regs->pA = NULL;	//value in register indetermniate
			}
			if(GenFlag)fprintf(out,"\t%s\t#%d\n",AccOps[Op],v);
			break;
		case VALUE_POINT_TO:
			if(REGSchk(Regs,REGS_Y))	//is y reg allocated?
			{
				if( (regv = REGSgetConst(Regs,REGS_Y)) >= 0)	//and is set to constant
				{
					if(regv > OpWord)
					{
						if((regv - OpWord) > 2)
						{
							GenLoadRegWithConst(out,REGS_Y,OpWord);
						}
						else
						{
							for(i=0;i<(regv - OpWord);++i)
								GenIncReg(out,REGS_Y,REG_DEC);
						}
					}
					else if (OpWord > regv)
					{
						if((OpWord - regv) > 2)
						{
							GenLoadRegWithConst(out,REGS_Y,OpWord);
						}
						else
						{
							for(i=0;i<(OpWord - regv);++i)
								GenIncReg(out,REGS_Y,REG_INC);
						}
					}
				}
				else
				{
					GenLoadRegWithConst(out,REGS_Y,OpWord);
				}
			}
			else
			{
				GenLoadRegWithConst(out,REGS_Y,OpWord);
			}
			fprintf(out,"\t%s\t(%s),Y\n",AccOps[Op],pV->name);
			if(!(ACCOP_CMP == Op || ACCOP_STA == Op))
			{
				Regs->Aval = -1;
				Regs->pA = NULL;	//value in register indetermniate
			}
			break;
		case VALUE_IN_MEM_INDX:	//access objects in memory
		case VALUE_IN_TMP_INDX: //but indexed with X reg
			if(OpWord >= 0)
			{
				regv = REGSgetConst(Regs,REGS_X);
				if(regv > 0)
				{
					if(OpWord > Regs->Xval)
					{
						if((OpWord - Regs->Xval) > 2)
						{
							GenLoadRegWithConst(out,REGS_X,OpWord);
						}
						else
						{
							c = OpWord - Regs->Xval;
							for(i=0;i < c;++i)
								GenIncReg(out,REGS_X,REG_INC);
						}
					}
					else if (Regs->Xval > OpWord)
					{
						if((Regs->Xval - OpWord) > 2)
						{
							GenLoadRegWithConst(out,REGS_X,OpWord);
						}
						else
						{
							c = Regs->Xval - OpWord;
							for(i=0;i < c;++i)
								GenIncReg(out,REGS_X,REG_DEC);
						}
					}
				}
			}
			else
			{
				Regs->pX = NULL;
				Regs->Xval = -1;
			}
			if(!(ACCOP_CMP == Op || ACCOP_STA == Op))
			{
				Regs->Aval = -1;
				Regs->pA = NULL;	//value in register indetermniate
			}
			fprintf(out,"\t%s\t%s,X\n",AccOps[Op],pV->name);
			break;
	}
}

static void GenAccOps_Y(FILE *out,int Op,int OpWord,value *pV)
{
	int c;
	int regv;
	int i;

	if(OpWord >= 0)
	{
		regv = REGSgetConst(Regs,REGS_Y);
		if(regv > 0)
		{
			if(OpWord > Regs->Xval)
			{
				if((OpWord - regv) > 2)
				{
					GenLoadRegWithConst(out,REGS_X,OpWord);
				}
				else
				{
					c = OpWord - regv;
					for(i=0;i < c;++i)
						GenIncReg(out,REGS_X,REG_INC);
				}
			}
			else if (regv > OpWord)
			{
				if((regv - OpWord) > 2)
				{
					GenLoadRegWithConst(out,REGS_X,OpWord);
				}
				else
				{
					c = regv - OpWord;
					for(i=0;i < c;++i)
						GenIncReg(out,REGS_X,REG_DEC);
				}
			}
		}
	}
	else
	{
		Regs->pY = NULL;
		Regs->Yval = -1;
	}
	switch(pV->ValLoc)
	{
		case VALUE_IN_TMP:
		case VALUE_IN_MEM:
			if(!(ACCOP_CMP == Op || ACCOP_STA == Op))
			{
				Regs->Aval = -1;
				Regs->pA = NULL;	//value in register indetermniate
			}
			fprintf(out,"\t%s\t%s,Y\n",AccOps[Op],pV->name);
			break;
	}
}

static const char * const IncInst[3] = {
	"INC",
	"INX",
	"INY"
};

static const char * const DecInst[3] = {
	"DEC",
	"DEX",
	"DEY"
};

//*************************************
// Generate increment and decrement reg
// Instructions
//
//	parameters:
//	out.....FILE pointer to output stream
//	reg....Register to increment or dec
//	dir... 0 -> DECrement, 1 ->INCrement
//**************************************

static const char Rs[4] = {"AXY"};

void GenInc(FILE *out,int dir, int word, value *pV)
{
	char *inst;
	int CarryOp;
	value *cV;	//place to store a temp constant

	if(dir == REG_INC)
	{
		switch(pV->ValLoc)
		{
			case VALUE_IN_MEM:			//value is located in a variable location
			case VALUE_IN_TMP:			//value is located in a temporary location
			case VALUE_IN_MEM_INDX:		//used to access arrays
			case VALUE_IN_TMP_INDX:		//used to access arrays
				inst =(char *) IncInst[REGS_A];
				break;
			case VALUE_IN_A	:			//value is located in accumulator (byte and bool)
			case VALUE_POINT_TO	:		//A temp points to the value
				inst = "ADC";
				CarryOp = STATUS_CLC;
				break;
			case VALUE_IS_CONSTANT:		//indicates that the value is a constant
				fprintf(stderr,"Error::Cannot Increment a constant value\n");
				break;
		}
	}
	else
	{
		switch(pV->ValLoc)
		{
			case VALUE_IN_MEM:			//value is located in a variable location
			case VALUE_IN_TMP:			//value is located in a temporary location
			case VALUE_IN_MEM_INDX:		//used to access arrays
			case VALUE_IN_TMP_INDX:		//used to access arrays
				inst = (char *) DecInst[REGS_A];
				break;
			case VALUE_IN_A	:			//value is located in accumulator (byte and bool)
			case VALUE_POINT_TO	:		//A temp points to the value
				inst = "SBC";
				CarryOp = STATUS_SEC;
				break;
			case VALUE_IS_CONSTANT:		//indicates that the value is a constant
				fprintf(stderr,"Error::Cannot Decrement a constant value\n");
				break;
		}
	}
	switch(pV->ValLoc)
	{
		case VALUE_IN_MEM:			//value is located in a variable location
		case VALUE_IN_TMP:			//value is located in a temporary location
			fprintf(out,"\t%s\t%s+%d\n",inst,pV->name,word);
			break;
		case VALUE_IN_A	:			//value is located in accumulator (byte and bool)
			GenSetClr(out,CarryOp);
			fprintf(out,"\t%s\t#$01\n",inst);
			break;
		case VALUE_IS_CONSTANT:		//indicates that the value is a constant
			break;
		case VALUE_POINT_TO	:		//A temp points to the value
			if(word == 0)
			{
				cV = MakeConstant(pV->type,0);
				GenLoadReg(out,REGS_Y,0,cV);
				GenSetClr(out,CarryOp);
				GenAccOps(out,ACCOP_LDA,0,pV);
				fprintf(out,"\t%s\t#$01\n",inst);
				GenAccOps(out,ACCOP_STA,0,pV);
			}
			else
			{
				GenIncReg(out,REGS_Y,REG_INC);
				GenAccOps(out,ACCOP_LDA,word,pV);
				fprintf(out,"\t%s\t#$01\n",inst);
				GenAccOps(out,ACCOP_STA,word,pV);
			}
			break;
		case VALUE_IN_MEM_INDX:		//used to access arrays
		case VALUE_IN_TMP_INDX:		//used to access arrays
			fprintf(out,"\t%s\t%s+d,X\n",inst,pV->name,word);
			break;
	}
}

void GenIncReg(FILE *out,int reg,int dir)
{
	char *inst;
	int v;
	if(dir == REG_INC) inst =(char *) IncInst[reg];
	else inst = (char *) DecInst[reg];

	if(REGSchk(Regs,reg))	//is the register allocated?
	{
		fprintf(out,"\t%s\n",inst);
		if((v = REGSgetConst(Regs,reg)) < 0)
			fprintf(stderr,"Register %c Not Allocated\n",Rs[reg]);
		else
		{
			if(dir) v++;
			else v--;
			REGSsetConst(Regs,reg,v);
		}
	}
}

static const char * const LdReg[3] = {
	"LDA",
	"LDX",	
	"LDY"
};

/************************************************************
** This function is more for loading an index regster, although
** it can be used to laod the accumulator as well
**
** parameters:
**	out.......File stream to write code out to
**	reg.......register to load
**	word.....which word of value to load (0->3)
**	v.........value to load
*************************************************************/

void GenLoadReg(FILE *out,int reg, int word, value *v)
{
	int val;

	REGSget(Regs,reg);	//allocate register
	switch(v->ValLoc)
	{
		case VALUE_IN_MEM:	//value is located in a variable location
		case VALUE_IN_TMP:	//value is located in a temporary location
			fprintf(out,"\t%s\t%s+%d\n",LdReg[reg],v->name,word);
			REGSsetConst(Regs,reg,-1);
			REGsetValue(Regs,reg,NULL);
			break;
		case VALUE_IS_CONSTANT:	//the value is a constant
			switch(word)
			{
				case 0:
					val = LOW(v->type->V_ULONG);
					break;
				case 1:
					val = LOWMID(v->type->V_ULONG);
					break;
				case 2:
					val = HIGHMID(v->type->V_ULONG);
					break;
				case 3:
					val = HIGH(v->type->V_ULONG);
					break;
			}
			fprintf(out,"\t%s\t#%d\n",LdReg[reg],val);
			REGSsetConst(Regs,reg,val);
			REGsetValue(Regs,reg,NULL);
			break;
		case VALUE_POINT_TO:	//a value in a temp points to the value
			GenAccOps(out,ACCOP_LDA,word,v);
		case VALUE_IN_A	:	//value is located in the accumulator
			if(REGS_A != reg)
			{
				if(reg == REGS_Y)
					GenTransfer(out,XFER_TAY);
				else
					GenTransfer(out,XFER_TAX);
			}
			REGSsetConst(Regs,reg,-1);
			REGsetValue(Regs,reg,NULL);
			break;
		case VALUE_IN_MEM_INDX:		//used to access arrays
		case VALUE_IN_TMP_INDX:		//used to access arrays
			if( REGS_X == reg)	//trying to load the X reg?
			{
				GenAccOps(out,ACCOP_LDA,word,v);
				GenTransfer(out,XFER_TAY);
			}
			else
			{
				fprintf(out,"\t%s\t%s+%d,X\n",LdReg[reg],v->name);
			}
			break;
	}
}

/******************************************************
** GenLoadRegWithVal is used to load an address of a
** label into a register.  It can be either thte upper
** or lower word of that address
**
** parameters:
**	out.......pointer to output stream to write code
**	reg......register to load data into
**	word......0 is LSB and 1 is MSB
**	v........value that referes to some memory location
******************************************************/

void GenLoadRegWithVal(FILE *out,int reg,int word,value *v)
{
	switch(reg)	//value is indeterminate, so unallocate
	{
		case REGS_A:
			Regs->Aval = -1;
			Regs->pA = NULL;
			break;
		case REGS_X:
			Regs->Xval = -1;
			Regs->pX = NULL;
			break;
		case REGS_Y:
			Regs->Yval = -1;
			Regs->pY = NULL;
			break;
	}
	fprintf(out,"\t%s\t#%c%s\n",LdReg[reg],word?'<':'>',v->name);
}

void GenLoadRegWithConst(FILE *out,int reg,int v)
{
	int r;

	if(REGSchk(Regs,reg))
	{
//		fprintf(stderr,"Reg %c Already Allocated\n",Rs[reg]);
//		REGSrel(Regs,reg);	//Not good, but just release reg for now
	}
	if((r = REGSisAnyRegSetTo(Regs,v)) < 0)
		fprintf(out,"\t%s\t#%d\n",LdReg[reg],v);
	else
	{
		switch(r)
		{
			case REGS_A:
				switch(reg)
				{
					case REGS_A:
						break;
					case REGS_X	:
						GenTransfer(out,XFER_TAX);
						break;
					case REGS_Y:
						GenTransfer(out,XFER_TAY);
						break;
				}
				break;
			case REGS_X	:
				switch(reg)
				{
					case REGS_A:
						GenTransfer(out,XFER_TXA);
						break;
					case REGS_X	:
						break;
					case REGS_Y:
						GenStackOper(out,STACK_PHA);
						GenTransfer(out,XFER_TXA);
						GenTransfer(out,XFER_TAY);
						GenStackOper(out,STACK_PLA);
						break;
				}
				break;
			case REGS_Y:
				switch(reg)
				{
					case REGS_A:
						GenTransfer(out,XFER_TYA);
						break;
					case REGS_X	:
						GenStackOper(out,STACK_PHA);
						GenTransfer(out,XFER_TYA);
						GenTransfer(out,XFER_TAX);
						GenStackOper(out,STACK_PLA);
						break;
					case REGS_Y:
						break;
				}
				break;
		}
	}
	REGSget(Regs,reg);	//aquire register
	REGSsetConst(Regs,reg,v);
}

static const char * const XfreOps[] = {
	"TAY",
	"TAX",
	"TYA",
	"TXA",
	"TXS",
	"TSX"
};

void GenTransfer(FILE *out,int op)
{
	switch(op)
	{
		case XFER_TAY:
			Regs->Y = Regs->A;
			Regs->Yval = Regs->Aval;
			Regs->pY = Regs->pA;
			break;
		case XFER_TAX:
			Regs->X = Regs->A;
			Regs->Xval = Regs->Aval;
			Regs->pX= Regs->pA;
			break;
		case XFER_TYA:
			Regs->A = Regs->Y ;
			Regs->Aval = Regs->Yval;
			Regs->pA = Regs->pY;
			break;
		case XFER_TXA:
			Regs->A = Regs->X ;
			Regs->Aval = Regs->Xval;
			Regs->pA = Regs->pX;
			break;
		case XFER_TXS:
			break;
		case XFER_TSX:
			Regs->X = 0;
			Regs->Xval = -1;
			Regs->pX= NULL;
			break;
	}
	fprintf(out,"\t%s\n",XfreOps[op]);
}

static const char * const StackOps[] = {
	"PLA",
	"PHA",
	"PLP",
	"PHP"
};

void GenStackOper(FILE *out,int op)
{
	if(STACK_PLA == op)
	{
		REGSsetConst(Regs,REGS_A,-1);	//if A set to const, release
		REGsetValue(Regs,REGS_A,NULL);		//set to current value in A
	}
	fprintf(out,"\t%s\n",StackOps[op]);
}

value *ConvertToBOOL(FILE *out,value *v)
{
	value *rV;
	char *Lable = GenLabel(GetCurrentProc()->name);

	rV = BOOLInAccumulator();

	switch(SizeOfRef(v->type))
	{
		case 1:
			switch(v->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location
					fprintf(out,"\tLDA\t%s\n",v->name);
					fprintf(out,"\tBEQ\t%s\n",Lable);
					fprintf(out,"\tLDA\t#1\n");
					fprintf(out,"%s:\n",Lable);
					break;
				case VALUE_IN_A	:	//value is located in the accumulator
					fprintf(out,"\tCMP\t#0\n");
					fprintf(out,"\tBEQ\t%s\n",Lable);
					fprintf(out,"\tLDA\t#1\n");
					fprintf(out,"%s:\n",Lable);
					break;
				case VALUE_IS_CONSTANT:	//the value is a constant
					if(v->type->V_ULONG)
						fprintf(out,"\tLDA\t#1\n");
					else
						fprintf(out,"\tLDA\t#0\n");
					fprintf(out,"%s:\n",Lable);
					break;
			}
			break;
		case 2:
			switch(v->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location
					fprintf(out,"\tLDA\t#0\n");
					fprintf(out,"\tCMP\t%s\n",v->name);
					fprintf(out,"\tSBC\t%s+1\n",v->name);
					fprintf(out,"\tBEQ\t%s\n",Lable);
					fprintf(out,"\tLDA\t#1\n");
					fprintf(out,"%s:\n",Lable);
					break;
				case VALUE_IN_A	:	//value is located in the accumulator
					break;
				case VALUE_IS_CONSTANT:	//the value is a constant
					if(v->type->V_ULONG)
						fprintf(out,"\tLDA\t#1\n");
					else
						fprintf(out,"\tLDA\t#0\n");
					break;
			}
			break;
		case 4:
			switch(v->ValLoc)
			{
				case VALUE_IN_MEM:	//value is located in a variable location
				case VALUE_IN_TMP:	//value is located in a temporary location
					fprintf(out,"\tLDA\t#0\n");
					fprintf(out,"\tCMP\t%s\n",v->name);
					fprintf(out,"\tSBC\t%s+1\n",v->name);
					fprintf(out,"\tSBC\t%s+2\n",v->name);
					fprintf(out,"\tSBC\t%s+3\n",v->name);
					fprintf(out,"\tBEQ\t%s\n",Lable);
					fprintf(out,"\tLDA\t#1\n");
					fprintf(out,"%s:\n",Lable);
					break;
				case VALUE_IN_A	:	//value is located in the accumulator
					break;
				case VALUE_IS_CONSTANT:	//the value is a constant
					if(v->type->V_ULONG)
						fprintf(out,"\tLDA\t#1\n");
					else
						fprintf(out,"\tLDA\t#0\n");
					break;
			}
			break;
	}
	discard_value(v);
	return rV;
}

value *SaveByteToTemp(FILE *out,value *v)
{
	link *t = v->type;
	value *rV;

	switch(v->ValLoc)
	{
		case VALUE_IN_MEM:	//value is located in a variable location
			rV = v;	//do nothing
			break;
		case VALUE_IN_TMP:	//value is located in a temporary location
			//do nothing
			rV = v;
			break;
		case VALUE_IN_A	:	//value is located in the accumulator
			rV = ValueInTemp(t);
			fprintf(out,"\tSTA\t%s\n",rV->name);
			break;
		case VALUE_IS_CONSTANT:	//the value is a constant
			fprintf(out,"\tLDA\t#%d\n",LOW(v->type->V_ULONG));
			rV = ValueInTemp(t);
			fprintf(out,"\tSTA\t%s\n",rV->name);
			break;
	}

	return rV;
}

value *ValueInTemp(link *t)
{
	value *rV;
	link *pL;

	rV = new_value();
	rV->ValLoc = VALUE_IN_TMP;
	rV->is_tmp = GetTemp(1,&rV->offset);
	GenTempName(rV);
	pL = new_link();
	pL->tclass = SYMTAB_SPECIFIER;
	pL->SYMTAB_NOUN = t->SYMTAB_NOUN;
	rV->type = rV->etype = pL;
	return rV;
}

value *ValueInAccumulator(link *t)
{
	value *rV;
	link *pL;

	rV = new_value();
	rV->ValLoc = VALUE_IN_A;
	pL = new_link();
	pL->tclass = SYMTAB_SPECIFIER;
	pL->SYMTAB_NOUN = t->SYMTAB_NOUN;
	rV->type = rV->etype = pL;
	return rV;
}

value *BOOLInAccumulator(void)
{
	value *rV;
	link *pL;

	rV = new_value();
	rV->ValLoc = VALUE_IN_A;
	pL = new_link();
	pL->tclass = SYMTAB_SPECIFIER;
	pL->SYMTAB_NOUN = SYMTAB_BOOL;
	rV->type = rV->etype = pL;
	return rV;
}

value *GenLDA(FILE *out,value *v1)
{
	value *rV = v1;
	v1->ValLoc = VALUE_IN_A;
	switch(v1->ValLoc)
	{
		case VALUE_IN_MEM:	//value is located in a variable location
		case VALUE_IN_TMP:	//value is located in a temporary location
			fprintf(out,"\tLDA\t%s\n",v1->name);
			break;
		case VALUE_IN_A	:	//value is located in the accumulator
			break;
		case VALUE_IS_CONSTANT:	//the value is a constant
			fprintf(out,"\tLDA\t#%d\n",LOW(v1->type->V_ULONG));
			break;
	}
	return rV;
}

value *MakeConstant(link *t,int val)
{
	value *v = new_value();
	v->type = clone_type(t,&v->etype);
	v->type->select.s.const_val.v_ulong = val;
	v->type->select.s.sclass = SYMTAB_CONSTANT;
	v->ValLoc = VALUE_IS_CONSTANT;
	return v;
}

value *DeReferencePointer(value *v)
{
	if(IS_POINTER(v->type->next))
	{
		link *d = v->type->next;
		discard_link(d);
		v->type->next = NULL;
		v->ValLoc = VALUE_POINT_TO;
	}
	else
		fprintf(stderr,"Trying to Defreence Non-Pointer type\n");
	return v;
}

static const char * const SetClrOps[] = {
	"CLC",
	"SEC",
	"CLI",
	"SEI"
};

void GenSetClr(FILE *out,int op)
{
	fprintf(out,"\t%s\n",SetClrOps[op]);
}

void GenLDAwithINDEX(FILE *out,value *v,int indexreg)
{
	/*************************************************
	** Generate an LDA <adr>,<index> intructu9ion
	**
	** parameters
	**	out.....pointer to output file stream
	**	v.......value to load
	**	indexreg...index register to use 1->X, 2->Y
	*************************************************/
	REGSsetConst(Regs,REGS_A,-1);	//if A set to const, release
	REGsetValue(Regs,REGS_A,v);		//set to current value in A
	fprintf(out,"\tLDA\t%s,%c\n",v->name,(indexreg==REGS_Y)?'Y':'X');
}

static const char * const ShiftOps[] = {
 "ASL",	
 "ROL",
 "LSR",	
 "ROR"	
};

void GenShift(FILE *out,int op,int word,value *v)
{
	switch(v->ValLoc)
	{
		case VALUE_IN_MEM:	//value is located in a variable location
		case VALUE_IN_TMP:	//value is located in a temporary location
			fprintf(out,"\t%s\t%s+%d\n",ShiftOps[op],v->name,word);
			break;
		case VALUE_IN_A	:	//value is located in the accumulator
			fprintf(out,"\t%s\tA\n",ShiftOps[op]);
			break;
		case VALUE_IS_CONSTANT:	//the value is a constant
		case VALUE_POINT_TO:	//a value in a temp points to the value
			fprintf(stderr,"Invalid Locations for Shift Operation\n");
			break;
	}
}

void OutputLable(FILE *out,char *s)
{
	fprintf(out,"%s:\n",s);
}

const char * const BranchOps[] = {
"BEQ",	//0
"BNE",	//1
"BMI",	//2
"BPL",	//3
"BCC",	//4
"BCS",	//5
"BVC",	//6
"BVS"	//7
};

void GenBranch(FILE *out,int op,char *label)
{
	fprintf(out,"\t%s\t%s\n",BranchOps[op],label);
}

static const char * const IndexOp[] = {
	"LDX",
	"LDY",
	"CPX",
	"CPY",
	"STX",
	"STY"
};

void GenIndexOp(FILE *out, int op, int word, value *v)
{
	int c;

	switch(v->ValLoc)
	{
		case VALUE_IN_MEM:	//value is located in a variable location
		case VALUE_IN_TMP:	//value is located in a temporary location
			fprintf(out,"\t%s\t%s+%d\n",IndexOp[op],v->name,word);
			break;
		case VALUE_IN_A	:	//value is located in the accumulator
			break;
		case VALUE_IS_CONSTANT:	//the value is a constant
			switch(word)
			{
				case 0:
					c = LOW(v->type->V_ULONG);
					break;
				case 1:
					c = LOWMID(v->type->V_ULONG);
					break;
				case 2:
					c = HIGHMID(v->type->V_ULONG);
					break;
				case 3:
					c = HIGH(v->type->V_ULONG);
					break;
			}
			if((op == INDEX_STX) || (op == INDEX_STY))
				fprintf(stderr,"Cannot Store Index to Immediate Value\n");
			fprintf(out,"\t%s\t#%d\n",IndexOp[op],c);
			break;
		case VALUE_POINT_TO:	//a value in a temp points to the value
			printf("Do I need this?\n");
			break;
	}
}

void GenJump(FILE *out,char *Lable)
{
	fprintf(out,"\tJMP\t%s\n",Lable);
}

void GenJumpSub(FILE *out, symbol *dest)
{
	fprintf(out,"\tJSR\t%s\n",dest->name);
}

static int LableNumber;

void ResetLable(void)
{
	LableNumber = 0;
}

char *GenLabel(char *bname)
{
	char *Bfr;

	Bfr = malloc(64);	//allocate memory for lable

	if(bname)
		sprintf(Bfr,"%s_Lab%d",bname,LableNumber);
	else
		sprintf(Bfr,"Lab%d",LableNumber);
	++LableNumber;
	return Bfr;
}

void GenSymbolRname(symbol *pSym,char *pfix)
{
	if(pfix == NULL) pfix = "";
	while(pSym)
	{
		sprintf(pSym->rname,"%s_%s",pfix,pSym->name);
		pSym = pSym->next;
	}
}
