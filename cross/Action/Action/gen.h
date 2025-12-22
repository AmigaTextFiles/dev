#ifndef GEN__H
#define GEN__H

#define ACCOP_ADC	0
#define ACCOP_SBC	1
#define ACCOP_CMP	2
#define ACCOP_AND	3
#define ACCOP_ORA	4
#define ACCOP_EOR	5
#define ACCOP_LDA	6
#define ACCOP_STA	7


#define XFER_TAY	0
#define XFER_TAX	1
#define XFER_TYA	2
#define XFER_TXA	3
#define XFER_TXS	4
#define XFER_TSX	5

#define STACK_PLA	0
#define STACK_PHA	1
#define STACK_PLP	2
#define STACK_PHP	3

#define STATUS_CLC	0
#define STATUS_SEC	1
#define STATUS_CLI	2	//enable interrupts
#define STATUS_SEI	3	//disable interrupts

#define REG_INC		1
#define REG_DEC		0

#define SHIFT_ASL	0
#define SHIFT_ROL	1
#define SHIFT_LSR	2
#define SHIFT_ROR	3

#define BRANCH_BEQ	0
#define BRANCH_BNE	1
#define BRANCH_BMI	2
#define BRANCH_BPL	3
#define BRANCH_BCC	4
#define BRANCH_BCS	5
#define BRANCH_BVC	6
#define BRANCH_BVS	7

#define INDEX_LDX	0
#define INDEX_LDY	1
#define INDEX_CPX	2
#define INDEX_CPY	3
#define INDEX_STX	4
#define INDEX_STY	5

extern const char * const AccOps[];

extern int ValInMem(value *v);
extern value *ConvertToBOOL(FILE *out,value *v);
extern value *SaveByteToTemp(FILE *out,value *v);
extern value *ValueInAccumulator(link *t);
extern value *BOOLInAccumulator(void);
extern value *ValueInTemp(link *t);
extern value *SaveToTemp(FILE *out,value *v);
extern value *GenLDA(FILE *out,value *v);
extern value *MakeConstant(link *t,int v);
extern value *DeReferencePointer(value *v);
extern void GenInc(FILE *out,int dir, int word, value *pV);
extern void GenIncReg(FILE *out,int reg,int dir);
extern void GenLoadRegWithConst(FILE *out,int reg,int v);
extern void GenLoadRegWithVal(FILE *out,int reg,int word,value *v);
extern void GenTransfer(FILE *out,int op);
extern void GenStackOper(FILE *out,int op);
extern void GenAccOps(FILE *out,int Op,int OpWord,value *pV);
extern void GenAccOpsConst(FILE *out,int Op,int OpWord,int v);
extern void GenSetClr(FILE *out,int op);
extern void GenLoadReg(FILE *out,int reg, int word, value *v);
extern void GenShift(FILE *out,int op,int word,value *v);
extern void GenBranch(FILE *out,int op,char *label);
extern void GenIndexOp(FILE *out, int op, int word, value *v);
extern void GenJump(FILE *out,char *Lable);
extern void GenJumpSub(FILE *out, symbol *Lable);
extern void OutputLable(FILE *out,char *s);
extern void ResetLable(void);
extern char *GenLabel(char *bname);
extern void GenSymbolRname(symbol *pSym,char *pfix);


#endif
