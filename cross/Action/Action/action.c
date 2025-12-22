	#include "tokens.h"
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "actionlexer.h"
	#include "symtab.h"
	#include "decl.h"
	#include "value.h"
	#include "abstract.h"
	#include "nodeid.h"
	#include "nodeman.h"
	#include "nodeproc.h"
	#include "misc.h"
	#include "codegen.h"
	#include "gen.h"

/*
AnaGram, A System for Syntax Directed Programming
Copyright (c) 1993-2002, Parsifal Software.
All Rights Reserved.

Version 2.01.08a   Feb 28 2002

Serial number 2P17253
Registered to:
  Parsifal Software
  AnaGram 2.01 Master
*/

#ifndef ACTION_H_1279326587
#include "action.h"
#endif

#ifndef ACTION_H_1279326587
#error Mismatched header file
#endif

#include <ctype.h>
#include <stdio.h>

#define RULE_CONTEXT (&((PCB).cs[(PCB).ssx]))
#define ERROR_CONTEXT ((PCB).cs[(PCB).error_frame_ssx])
#define CONTEXT ((PCB).cs[(PCB).ssx])



action_pcb_type action_pcb;
#define PCB action_pcb
#define INPUT_VALUE(type) *(type *) &(PCB).input_value

/*  Line 780, D:/Projects/Action/action.syn */
#define SYNTAX_ERROR syntaxError()
int SymtabFlag = 1;
int IfLevel = 0;
int ScopeLevel = 0;

void syntaxError(void)
{
	extern int yyLine,yyCol;

	fprintf(stderr,"%s, line %d, column %d\n", \
  (PCB).error_message, yyLine, yyCol);
  exit(1);
}

/***************************************************
** PROCRoutine
**  Create a node for a proceedure or function
** block
**
** parameters:
**	s1...pointer to symbol for function declaration (includes args)
**	s2...Pointer to symbol for local variables
**	n1...pointer to node for statement list
**  n2...pointer to node for return statement
**
**************************************************/

NODE *PROCRoutine(symbol *s1,symbol *s2,NODE *n1,NODE *n2)
{
	NODE *pN,*pL;
	if(s2)	//are there any local variables?
	{
		MarkSymbolsAsLocal(s2);
		pL = MakeLeaf(NODEID_PROCLOCALS,s2,s1);
		n1 = MakeList(pL,n1);
	}
	if(n1)pN = MakeNode(NODEID_PROC,n1,n2);
	else pN = MakeNode(NODEID_PROC,n2,NULL);
	pN->symb = s1;	//add proc name to nodes
	MarkSymbolsAsLocal(s1->type->next->SYMTAB_ARGS);
	return pN;
}

symbol *PROCdecl(symbol *s, int V, symbol *s1)
{
	link *spec = new_link();
	link *decl = new_link();
	spec->tclass=SYMTAB_SPECIFIER;
	spec->V_ULONG = V;	//this determines the address to call if the proc was initialized
	spec->SYMTAB_NOUN = SYMTAB_VOID;
	decl->SYMTAB_DCL_TYPE = SYMTAB_FUNCTION;
	s->Token = PROCIDENT;	//checked by lexer
	spec->next = decl;
	s->type = spec;
	s->etype = decl;
	decl->SYMTAB_ARGS = s1;		//point to argument declarations
	s->level = 0;
	return s;
}

/********************************************
** Create declarator for a FUNCTION
**
** Parameters:
**	l........specifier for function type
**  s.......,symbol table entry for function name
**  V.......value of optional function address init
**  s1.......chain of symbols that specify parameter list
**
** returns: Symbol s
********************************************/

symbol *FUNCdecl(link *l,symbol *s, int V, symbol *s1)
{
 	link *decl = new_link();
	decl->SYMTAB_DCL_TYPE = SYMTAB_FUNCTION;
	s->Token = FUNCIDENT;	//checked by lexer
	l->next = decl;
	l->V_ULONG = V;	//this determines the address to call if the proc was initialized
	s->level = 0;
	s->type = l;
	s->etype = decl;
	decl->SYMTAB_ARGS = s1;		//point to argument declarations
	return s;
}


void yyparse(void)
{
	/***************************************
	** THIS is the function that we call to
	** parse the ACTION! input file.
	**************************************/

	int tokenID;
	extern int yylex(void);
	char *yytext;
	char *s;

	init_action();
	do
	{
		tokenID = yylex();	//get the next token
		yytext = GetLexBuff();	//get the current lex buffer
		s = malloc(strlen(yytext)+1);
		strcpy(s,yytext);	//copy the lex buffer
		PCB.input_code = tokenID;	//this is the next token
		PCB.input_value.TokenID = tokenID;	//current token value tokenID
		PCB.input_value.yytext = s;	//current toeken value lex buffer contents
		PCB.input_context.TokenID = tokenID;	//tokenID for context member
		PCB.input_context.yytext = s;			//lex buff for token context
		action();	//parse the next token
	}while(tokenID > 0);
}


#ifndef CONVERT_CASE
#define CONVERT_CASE(c) (c)
#endif
#ifndef TAB_SPACING
#define TAB_SPACING 8
#endif

#define ag_rp_1() (ScopeLevel=0)

static void ag_rp_3(NODE * n) {
/* Line 158, D:/Projects/Action/action.syn */
print_tree(n);process_tree(n);RemoveLocalsFromSymtab(Symbol_tab);
}

static void ag_rp_4(NODE * n) {
/* Line 159, D:/Projects/Action/action.syn */
print_tree(n);process_tree(n);RemoveLocalsFromSymtab(Symbol_tab);
}

#define ag_rp_5(s1) (PROCRoutine(s1,NULL,NULL,NULL))

#define ag_rp_6(s1, s2) (PROCRoutine(s1,s2,NULL,NULL))

#define ag_rp_7(s1, n1) (PROCRoutine(s1,NULL,n1,NULL))

#define ag_rp_8(s1, n1, n2) (PROCRoutine(s1,NULL,n1,n2))

#define ag_rp_9(s1, n2) (PROCRoutine(s1,NULL,NULL,n2))

#define ag_rp_10(s1, s2, n1) (PROCRoutine(s1,s2,n1,NULL))

#define ag_rp_11(s1, s2, n2) (PROCRoutine(s1,s2,NULL,n2))

#define ag_rp_12(s1, s2, n1, n2) (PROCRoutine(s1,s2,n1,n2))

#define ag_rp_13(s, s1) (PROCdecl(s,0,s1))

#define ag_rp_14(s, V) (PROCdecl(s,V,NULL))

#define ag_rp_15(s) (PROCdecl(s,0,NULL))

#define ag_rp_16(s, V, s1) (PROCdecl(s,V,s1))

#define ag_rp_17(n) (n)

#define ag_rp_18(n) (n)

#define ag_rp_19(v) (v)

#define ag_rp_20() (MakeNode(NODEID_RETURN,NULL,NULL))

#define ag_rp_21(s1) (PROCRoutine(s1,NULL,NULL,NULL))

#define ag_rp_22(s1, s2) (PROCRoutine(s1,s2,NULL,NULL))

#define ag_rp_23(s1, n1) (PROCRoutine(s1,NULL,n1,NULL))

#define ag_rp_24(s1, n1, n2) (PROCRoutine(s1,NULL,n1,n2))

#define ag_rp_25(s1, n2) (PROCRoutine(s1,NULL,NULL,n2))

#define ag_rp_26(s1, s2, n1) (PROCRoutine(s1,s2,n1,NULL))

#define ag_rp_27(s1, s2, n2) (PROCRoutine(s1,s2,NULL,n2))

#define ag_rp_28(s1, s2, n1, n2) (PROCRoutine(s1,s2,n1,n2))

#define ag_rp_29(l, s) (FUNCdecl(l,s, 0, NULL))

#define ag_rp_30(l, s, V) (FUNCdecl(l,s, V, NULL))

#define ag_rp_31(l, s, s1) (FUNCdecl(l,s, 0, s1))

#define ag_rp_32(l, s, V, s1) (FUNCdecl(l,s, V, s1))

#define ag_rp_33(n1) (MakeNode(NODEID_RETURN,n1,NULL))

#define ag_rp_34() (NULL)

#define ag_rp_35(n) (n)

#define ag_rp_36(n1, n2) (MakeList(n1,n2))

#define ag_rp_37(n) (n)

#define ag_rp_38(n) (n)

#define ag_rp_39(n) (n)

#define ag_rp_40(n) (n)

#define ag_rp_41(n) (n)

#define ag_rp_42(n) (n)

#define ag_rp_43(n) (n)

#define ag_rp_44(n1) (MakeNode(NODEID_RETURN,n1,NULL))

#define ag_rp_45() (MakeNode(NODEID_RETURN,NULL,NULL))

#define ag_rp_46() (MakeNode(NODEID_EXIT,NULL,NULL))

#define ag_rp_47(n1, n2) (MakeNode(NODEID_PROCCALL,n1,n2))

#define ag_rp_48(n1) (MakeNode(NODEID_PROCCALL,n1,NULL))

#define ag_rp_49(n1, n2) (MakeNode(NODEID_FUNCCALL,n1,n2))

#define ag_rp_50(n1) (MakeNode(NODEID_FUNCCALL,n1,NULL))

static NODE * ag_rp_51(token t) {
/* Line 230, D:/Projects/Action/action.syn */
						symbol *pSym = findsym( Symbol_tab,t.yytext  );
						return MakeLeaf(NODEID_PROCIDENT,pSym,NULL);
					
}

static NODE * ag_rp_52(token t) {
/* Line 235, D:/Projects/Action/action.syn */
						symbol *pSym = findsym( Symbol_tab,t.yytext  );
						return MakeLeaf(NODEID_PROCIDENT,pSym,NULL);
					
}

#define ag_rp_53(n) (n)

#define ag_rp_54(n) (n)

#define ag_rp_55(n) (n)

#define ag_rp_56(n) (n)

#define ag_rp_57(n1, n2) (MakeNode(NODEID_DOLOOP,n1,n2))

#define ag_rp_58() (NULL)

#define ag_rp_59(n1) (MakeNode(NODEID_UNTIL,n1,NULL))

static NODE * ag_rp_60(NODE * n1, NODE * n2) {
/* Line 250, D:/Projects/Action/action.syn */
							n2->id = NODEID_WHILEDOLOOP;
							return MakeNode(NODEID_WHILE,n1,n2);
						
}

static NODE * ag_rp_61(NODE * n1, NODE * n2, NODE * n3, NODE * n4, NODE * n5) {
/* Line 255, D:/Projects/Action/action.syn */
					NODE *start = MakeNode(NODEID_FORSTART,n1,n2);
					NODE *to = MakeNode(NODEID_FORTO,n3,NULL);
					NODE *FOR = MakeNode(NODEID_FOR,start,to);
					if(n4) MakeList(start,n4);
					n5->id = NODEID_FORDOLOOP;
					MakeList(start,n5);
					return FOR;
               
}

#define ag_rp_62() (NULL)

#define ag_rp_63(n) (MakeNode(NODEID_STEP,n,NULL))

#define ag_rp_64(n) (MakeNode(NODEID_IFSTMT,n,NULL))

#define ag_rp_65(n1, n2) (MakeNode(NODEID_IFSTMT,n1,n2))

#define ag_rp_66(n1, n2) (MakeNode(NODEID_IFSTMT,n1,n2))

static NODE * ag_rp_67(NODE * n1, NODE * n2, NODE * n3) {
/* Line 271, D:/Projects/Action/action.syn */
				NODE *n =MakeNode(NODEID_IFSTMT,n1,n2);
				MakeList(n1,n3);
				return n;
			  
}

#define ag_rp_68() (IfLevel--)

#define ag_rp_69() (IfLevel++)

#define ag_rp_70(n1, n2) (MakeNode(NODEID_IF,n1,n2))

#define ag_rp_71(n) (n)

#define ag_rp_72(nl, n) (MakeList(nl,n))

#define ag_rp_73(n1, n2) (MakeNode(NODEID_ELSEIF,n1,n2))

#define ag_rp_74(n1) (MakeNode(NODEID_ELSE,n1,NULL))

#define ag_rp_75(n1, n2) (MakeNode(NODEID_EQUALS,n1,n2))

#define ag_rp_76(n1, n2) (MakeNode(NODEID_ADDEQ,n1,n2))

#define ag_rp_77(n1, n2) (MakeNode(NODEID_SUBEQ,n1,n2))

#define ag_rp_78(n1, n2) (MakeNode(NODEID_MULEQ,n1,n2))

#define ag_rp_79(n1, n2) (MakeNode(NODEID_DIVEQ,n1,n2))

#define ag_rp_80(n1, n2) (MakeNode(NODEID_MODEQ,n1,n2))

#define ag_rp_81(n1, n2) (MakeNode(NODEID_LSHEQ,n1,n2))

#define ag_rp_82(n1, n2) (MakeNode(NODEID_RSHEQ,n1,n2))

#define ag_rp_83(n1, n2) (MakeNode(NODEID_ANDEQ,n1,n2))

#define ag_rp_84(n1, n2) (MakeNode(NODEID_OREQ ,n1,n2))

#define ag_rp_85(n1, n2) (MakeNode(NODEID_XOREQ,n1,n2))

#define ag_rp_86(n1, n2) (MakeNode(NODEID_OR,n1,n2))

#define ag_rp_87(n1) (n1)

#define ag_rp_88(n1, n2) (MakeNode(NODEID_AND,n1,n2))

#define ag_rp_89(n1) (n1)

#define ag_rp_90(n1, n2) (MakeNode(NODEID_EQ,n1,n2))

#define ag_rp_91(n1, n2) (MakeNode(NODEID_LT,n1,n2))

#define ag_rp_92(n1, n2) (MakeNode(NODEID_GT,n1,n2))

#define ag_rp_93(n1, n2) (MakeNode(NODEID_NE,n1,n2))

#define ag_rp_94(n1, n2) (MakeNode(NODEID_GTE,n1,n2))

#define ag_rp_95(n1, n2) (MakeNode(NODEID_LTE,n1,n2))

#define ag_rp_96(n1, n2) (MakeNode(NODEID_NE,n1,n2))

#define ag_rp_97(n1) (n1)

#define ag_rp_98(n1, n2) (MakeNode(NODEID_BITAND,n1,n2))

#define ag_rp_99(n1, n2) (MakeNode(NODEID_BITXOR,n1,n2))

#define ag_rp_100(n1, n2) (MakeNode(NODEID_BITOR,n1,n2))

#define ag_rp_101(n1) (n1)

#define ag_rp_102(n1, n2) (MakeNode(NODEID_LSH,n1,n2))

#define ag_rp_103(n1, n2) (MakeNode(NODEID_RSH,n1,n2))

#define ag_rp_104(n1) (n1)

#define ag_rp_105(n1, n2) (MakeNode(NODEID_ADD,n1,n2))

#define ag_rp_106(n1, n2) (MakeNode(NODEID_SUB,n1,n2))

#define ag_rp_107(n1) (n1)

#define ag_rp_108(n1, n2) (MakeNode(NODEID_MUL,n1,n2))

#define ag_rp_109(n1, n2) (MakeNode(NODEID_DIV,n1,n2))

#define ag_rp_110(n1, n2) (MakeNode(NODEID_MOD,n1,n2))

#define ag_rp_111(n1) (n1)

#define ag_rp_112(n1) (n1)

#define ag_rp_113(n1) (MakeNode(NODEID_NEGATIVE,n1,NULL))

#define ag_rp_114(n) (n)

static NODE * ag_rp_115(char * s) {
/* Line 339, D:/Projects/Action/action.syn */
					NODE *pN;
					pN = MakeLeaf(NODEID_STRING,s,NULL);
					return pN;
			   
}

static NODE * ag_rp_116(int V) {
/* Line 344, D:/Projects/Action/action.syn */
					char *s = malloc(32);
					symbol *pSym;
					link *l;
					sprintf(s,"%d",V);
					pSym = new_symbol(s,ScopeLevel );
					free(s);
					l = new_link();
					l->tclass = SYMTAB_SPECIFIER;
					l->select.s.noun = SYMTAB_INT;
					l->select.s.sclass = SYMTAB_CONSTANT;
					l->V_INT = V;
					sprintf(pSym->name,"%d",V);
					pSym->type = pSym->etype = l;
					return MakeLeaf(NODEID_CONSTANT,pSym,NULL);
				
}

#define ag_rp_117(n) (n)

#define ag_rp_118(n) (n)

static NODE * ag_rp_119(CLIST * cL) {
/* Line 364, D:/Projects/Action/action.syn */
		DATABLOCK *pD;
		NODE *pN;

		pD = malloc(sizeof(DATABLOCK));
		ClistToDataBlock(pD,cL);
		pN = MakeLeaf(NODEID_CODEBLOCK,NULL,pD);
		return pN;

}

#define ag_rp_120(v) (newCLIST(v))

static CLIST * ag_rp_121(CLIST * cL, int v) {
/* Line 375, D:/Projects/Action/action.syn */
				CLIST *pCL = newCLIST(v);
				return CLISTchain(cL,pCL);
			 
}

#define ag_rp_122(n) (MakeNode(NODEID_ARGUMENTS,n,NULL))

#define ag_rp_123(n1) (n1)

#define ag_rp_124(n1, n2) (MakeList(n2,n1))

#define ag_rp_125(n) (n)

#define ag_rp_126(n1) (MakeNode(NODEID_ADDRESSOF,n1,NULL))

#define ag_rp_127(n) (n)

#define ag_rp_128(n) (n)

#define ag_rp_129(n) (n)

#define ag_rp_130(n) (n)

#define ag_rp_131(n1) (MakeNode(NODEID_CONTENTSOF,n1,NULL))

#define ag_rp_132(n1, n2) (MakeNode(NODEID_ARRAYREF,n1,n2))

#define ag_rp_133(n1, n2) (MakeNode(NODEID_MEMBER,n1,n2))

static NODE * ag_rp_134(token t) {
/* Line 403, D:/Projects/Action/action.syn */
						symbol *pSym = findsym( Symbol_tab,t.yytext  );
						return MakeLeaf(NODEID_IDENT,pSym,NULL);
					
}

static void ag_rp_135(symbol * s) {
/* Line 414, D:/Projects/Action/action.syn */
						GenSymbolRname(s,NULL);
						OutputData(OutFile,s);
                      
}

static void ag_rp_136(symbol * s) {
/* Line 418, D:/Projects/Action/action.syn */
						GenSymbolRname(s,NULL);
						OutputData(OutFile,s);
                      
}

#define ag_rp_137(s) (s)

#define ag_rp_138(S1, S2) (JoinSymbolChains(S1,S2))

#define ag_rp_139(s) (s)

#define ag_rp_140(s) (s)

#define ag_rp_141(s) (s)

#define ag_rp_142(s) (s)

#define ag_rp_143(s) (s)

#define ag_rp_144(s) (s)

#define ag_rp_145(s) (s)

#define ag_rp_146(sL, s1) (JoinSymbolChains(sL,s1))

#define ag_rp_147(sL, s1) (JoinSymbolChains(sL,s1))

#define ag_rp_148(s) (s)

#define ag_rp_149(s) (s)

#define ag_rp_150(s) (s)

#define ag_rp_151(s) (s)

#define ag_rp_152(s) (s)

#define ag_rp_153(s) (s)

static symbol * ag_rp_154(link * l, symbol * s1) {
/* Line 445, D:/Projects/Action/action.syn */
						ABSTRACT *pA = newABSTRACT();
						AbstractBuildDeclarator(pA,SYMTAB_POINTER,0,NULL);
						add_spec_to_decl (l,s1);
						add_spec_to_decl(pA->type,s1);
						return s1;
                  
}

#define ag_rp_155(s) (s)

static symbol * ag_rp_156(symbol * sL, symbol * s) {
/* Line 454, D:/Projects/Action/action.syn */
					     symbol *pS = sL;	//we need to make a forward facubg kust
					     while(pS->next) pS = pS->next;
					     pS->next = s;
						 return sL;
					
}

#define ag_rp_157(s) (s)

static symbol * ag_rp_158(symbol * s, int A) {
/* Line 462, D:/Projects/Action/action.syn */
				     s->iv.initval = A;
					 s->init = SYMTAB_INIT_ADDRESS;
					 return s;
				  
}

static symbol * ag_rp_159(link * l, symbol * s1) {
/* Line 468, D:/Projects/Action/action.syn */
						link *pD;
						link *pL;
						symbol *pS =s1;
						while(pS)
						{
							pD = pS->type;
							pL = new_link();
							memcpy(pL,l,sizeof(link));
							pS->type = pL;
							pL->next = pD;
							//pD->next = pL;
							pS->etype = pD;
							pS = pS->next;
						}
						return s1;
                 
}

#define ag_rp_160(s) (s)

static symbol * ag_rp_161(symbol * sL, symbol * s) {
/* Line 487, D:/Projects/Action/action.syn */
						symbol *pS = sL;
						while(pS->next) pS = pS->next;
						pS->next = s;
						return sL;
					
}

static symbol * ag_rp_162(symbol * s) {
/* Line 494, D:/Projects/Action/action.syn */
					   ABSTRACT *pA = newABSTRACT();
					   AbstractBuildDeclarator(pA,SYMTAB_ARRAY,0,NULL);
					   add_spec_to_decl (pA->type,s);
					   return s;
				  
}

static symbol * ag_rp_163(symbol * s, int D) {
/* Line 501, D:/Projects/Action/action.syn */
					   ABSTRACT *pA = newABSTRACT();
					   AbstractBuildDeclarator(pA,SYMTAB_ARRAY,D,NULL);
					   add_spec_to_decl (pA->type,s);
					   return s;
				  
}

static symbol * ag_rp_164(symbol * s, int D, int A) {
/* Line 508, D:/Projects/Action/action.syn */
					   ABSTRACT *pA = newABSTRACT();
					   s->iv.initval = A;
					   s->init = SYMTAB_INIT_ADDRESS;
					   AbstractBuildDeclarator(pA,SYMTAB_ARRAY,D,NULL);
					   add_spec_to_decl (pA->type,s);
					   return s;
				  
}

static symbol * ag_rp_165(symbol * s, int D, CLIST * cL) {
/* Line 516, D:/Projects/Action/action.syn */
					   ABSTRACT *pA = newABSTRACT();
					   DATABLOCK *pD = malloc(sizeof(DATABLOCK));
					   ClistToDataBlock(pD, cL);
					   s->iv.arrinit = pD->data;
					   s->initSize = pD->size;
					   s->init = SYMTAB_INIT_ARRAY;
					   AbstractBuildDeclarator(pA,SYMTAB_ARRAY,D,NULL);
					   add_spec_to_decl (pA->type,s);
					   return s;
				  
}

static symbol * ag_rp_166(symbol * s, int D, char * sc) {
/* Line 527, D:/Projects/Action/action.syn */
					   ABSTRACT *pA = newABSTRACT();
					   s->iv.arrinit = sc;
					   s->initSize = strlen(sc);
					   s->init = SYMTAB_INIT_ARRAY;
					   AbstractBuildDeclarator(pA,SYMTAB_ARRAY,D,NULL);
					   pA->type->select.d.string_flag = 1;	//initdacte this is a string
					   add_spec_to_decl (pA->type,s);
					   return s;
				  
}

static symbol * ag_rp_167(symbol * s, int A) {
/* Line 538, D:/Projects/Action/action.syn */
					   ABSTRACT *pA = newABSTRACT();
					   s->iv.initval = A;
					   s->init = SYMTAB_INIT_ADDRESS;
					   AbstractBuildDeclarator(pA,SYMTAB_ARRAY,0,NULL);
					   add_spec_to_decl (pA->type,s);
					   return s;
				  
}

static symbol * ag_rp_168(symbol * s, CLIST * cL) {
/* Line 547, D:/Projects/Action/action.syn */
					   ABSTRACT *pA = newABSTRACT();
					   DATABLOCK *pD = malloc(sizeof(DATABLOCK));
					   ClistToDataBlock(pD, cL);
					   s->iv.arrinit = pD->data;
					   s->initSize = pD->size;
					   s->init = SYMTAB_INIT_ARRAY;
					   AbstractBuildDeclarator(pA,SYMTAB_ARRAY,pD->size,NULL);
					   add_spec_to_decl (pA->type,s);
					   return s;
				  
}

static symbol * ag_rp_169(symbol * s, char * sc) {
/* Line 558, D:/Projects/Action/action.syn */
					   ABSTRACT *pA = newABSTRACT();
					   s->iv.arrinit = sc;
					   s->initSize = strlen(sc);
//				printf("**STRING size = %d\n",s->initSize);
					   s->init = SYMTAB_INIT_ARRAY;
					   AbstractBuildDeclarator(pA,SYMTAB_ARRAY,s->initSize,NULL);
					   pA->type->select.d.string_flag = 1;	//initdacte this is a string
					   add_spec_to_decl (pA->type,s);
					   return s;
				  
}

static symbol * ag_rp_170(link * l, symbol * s) {
/* Line 571, D:/Projects/Action/action.syn */
add_spec_to_decl (l,s); return s;
}

#define ag_rp_171() (new_type_spec ("char"))

#define ag_rp_172() (new_type_spec ("char"))

#define ag_rp_173() (new_type_spec ("int"))

#define ag_rp_174() (new_type_spec ("unsigned"))

#define ag_rp_175() (new_type_spec ("long"))

#define ag_rp_176(s) (s)

static symbol * ag_rp_177(symbol * sL, symbol * s) {
/* Line 581, D:/Projects/Action/action.syn */
					symbol *pS = sL;
					while(pS->next) pS = pS->next;
					pS->next = s;
					return sL;
			
}

#define ag_rp_178(s) (s)

static symbol * ag_rp_179(symbol * s, int v) {
/* Line 589, D:/Projects/Action/action.syn */
					s->iv.initval = v;
					s->init = SYMTAB_INIT_ADDRESS;
					return s;
				   
}

static symbol * ag_rp_180(symbol * s, int v) {
/* Line 594, D:/Projects/Action/action.syn */
					s->iv.initval = v;
					s->init = SYMTAB_INIT_VALUE;
					return s;
				   
}

static CLIST * ag_rp_181(int v) {
/* Line 600, D:/Projects/Action/action.syn */
						return newCLIST(v);
				  
}

static CLIST * ag_rp_182(CLIST * cL, int v) {
/* Line 603, D:/Projects/Action/action.syn */
				    CLIST *pCL = newCLIST(v);
				    return CLISTchain(cL,pCL);
			      
}

#define ag_rp_183(v) (v)

#define ag_rp_184(v) (v)

#define ag_rp_185(v1, v2) (v1+v2)

#define ag_rp_186() (0)

#define ag_rp_187(v) (v)

#define ag_rp_188() (-1)

static symbol * ag_rp_189(symbol * t, symbol * s) {
/* Line 619, D:/Projects/Action/action.syn */
				    link *l,*pD;
					symbol *pS = s;
					while(pS)
					{
						l = new_link();	//create new specifier
						memcpy(l,t->type,sizeof(link));
						l->tdef = 0;
						pD = new_link();
						pD->SYMTAB_DCL_TYPE = SYMTAB_POINTER;
						pS->type = l;
						l->next = pD;
						pS->etype = pD;
						pS = pS->next;
					}
					return s;
				
}

static symbol * ag_rp_190(symbol * t, symbol * s) {
/* Line 637, D:/Projects/Action/action.syn */
				    link *l;
					symbol *pS = s;
					while(pS)
					{
						l = new_link();	//create new specifier
						memcpy(l,t->type,sizeof(link));
						l->tdef = 0;
						pS->type = l;
						pS->etype = l;
						pS = pS->next;
					}
					return s;
                 
}

static symbol * ag_rp_191(token t) {
/* Line 652, D:/Projects/Action/action.syn */
				symbol *pSym;
				pSym = findsym( Symbol_tab,t.yytext  );
				if(pSym == NULL) fprintf(stderr,"Could not find %s\n",t.yytext);
				return pSym;
              
}

static symbol * ag_rp_192(symbol * s) {
/* Line 658, D:/Projects/Action/action.syn */
s->Token = RECTYPE;return s; 
}

static symbol * ag_rp_193(symbol * sL, symbol * s) {
/* Line 660, D:/Projects/Action/action.syn */
				symbol *pS = sL;
				while(pS->next) pS = pS->next;
				pS->next = s;
				s->Token = RECTYPE;
				return sL;
			
}

#define ag_rp_194(s) (s)

static symbol * ag_rp_195(symbol * s, int A) {
/* Line 669, D:/Projects/Action/action.syn */
				    s->init = SYMTAB_INIT_ADDRESS;
					s->iv.initval = A;
					return s;
				  
}

#define ag_rp_196(S) (S)

#define ag_rp_197(s) (s)

static symbol * ag_rp_198(symbol * sL, symbol * s) {
/* Line 677, D:/Projects/Action/action.syn */
s->next=sL;return s;
}

static symbol * ag_rp_199(symbol * S1, symbol * S2) {
/* Line 680, D:/Projects/Action/action.syn */
						/*****************************
						** OK, this is probably the
						** most difficult part of the
						** entire compiler.  We need
						** to deal with TWO symbol
						** tables here, the struct_def
						** table and the symbol_tab
						** table.
						*****************************/
						link *pL;
						structdef *pSD;
						pL = new_link();
						pL->tclass = 1;	//set to specifier
						pL->tdef = 1;	//a typedef chain
						pL->select.s.noun = SYMTAB_STRUCTURE;
						pL->select.s.sclass = SYMTAB_TYPEDEF;
						pSD = new_structdef(S1->name);	/* create struct def */
						pL->select.s.const_val.v_struct = pSD;
						add_spec_to_decl(pL,S1);
						pSD->fields = S2;	/* set field chain */
						pSD->size =  figure_struct_offsets(S2,1);
						addsym( Struct_tab, pSD );
						S1->Token = TYPEDEF;
						return S1;
                   
}

#define ag_rp_200() (SymtabFlag=1)

#define ag_rp_201() (SymtabFlag=0)

#define ag_rp_202(s) (s)

#define ag_rp_203(s) (s)

#define ag_rp_204(S) (S)

static symbol * ag_rp_205(symbol * sL, symbol * s) {
/* Line 715, D:/Projects/Action/action.syn */
s->next = sL;return s;
}

static symbol * ag_rp_206(symbol * S, int C) {
/* Line 718, D:/Projects/Action/action.syn */
            link *l = new_link();
			l->tclass = SYMTAB_SPECIFIER;
			l->SYMTAB_NOUN = SYMTAB_INT;
			l->SYMTAB_SCLASS = SYMTAB_CONSTANT;
			l->V_INT = C;
			add_spec_to_decl (l,S);
			return S;

          
}

static symbol * ag_rp_207(symbol * S, char * str) {
/* Line 728, D:/Projects/Action/action.syn */
            link *l = new_link();
			l->tclass = SYMTAB_SPECIFIER;
			l->SYMTAB_NOUN = SYMTAB_MACRO;
			l->SYMTAB_SCLASS = SYMTAB_CONSTANT;
			l->V_STRING = str;
			add_spec_to_decl (l,S);
			return S;
		
}

static char * ag_rp_208(token t) {
/* Line 738, D:/Projects/Action/action.syn */
    char *s;
	int l;

	l = strlen(t.yytext);
	s = malloc(l+1);
	strcpy(s,t.yytext);
//	printf("STRING=%s\n",s);
	return s;

}

static symbol * ag_rp_209(token t) {
/* Line 749, D:/Projects/Action/action.syn */
	symbol *pSym = new_symbol(t.yytext,ScopeLevel );
	AddSymbolToSymTab(SymtabFlag,pSym);
	return pSym;

}

static NODE * ag_rp_210(token t) {
/* Line 755, D:/Projects/Action/action.syn */
	symbol *pSym = findsym( Symbol_tab,t.yytext  );
	if(pSym == NULL) fprintf(stderr,"Undefined Symbol %s\n",t.yytext);
	return MakeLeaf(NODEID_IDENT,pSym,NULL);

}

static NODE * ag_rp_211(token t) {
/* Line 761, D:/Projects/Action/action.syn */
	char *s = malloc(strlen(t.yytext)+1);
	strcpy(s,t.yytext);
	return MakeLeaf(NODEID_IDENT,s,NULL);

}

static int ag_rp_212(token t) {
/* Line 767, D:/Projects/Action/action.syn */
			int v = (int)strtol(t.yytext,NULL,16);
			return v;

}

static int ag_rp_213(token t) {
/* Line 771, D:/Projects/Action/action.syn */
		   int v = atoi(t.yytext);
		   return v;

}

static int ag_rp_214(token t) {
/* Line 775, D:/Projects/Action/action.syn */
		   return t.yytext[0];

}


#define READ_COUNTS 
#define WRITE_COUNTS 
#undef V
#define V(i,t) (*t (&(PCB).vs[(PCB).ssx + i]))
#undef VS
#define VS(i) (PCB).vs[(PCB).ssx + i]

#ifndef GET_CONTEXT
#define GET_CONTEXT CONTEXT = (PCB).input_context
#endif

typedef enum {
  ag_action_1,
  ag_action_2,
  ag_action_3,
  ag_action_4,
  ag_action_5,
  ag_action_6,
  ag_action_7,
  ag_action_8,
  ag_action_9,
  ag_action_10,
  ag_action_11,
  ag_action_12
} ag_parser_action;


#ifndef NULL_VALUE_INITIALIZER
#define NULL_VALUE_INITIALIZER = { 0 }
#endif

static action_vs_type const ag_null_value NULL_VALUE_INITIALIZER;

static const unsigned char ag_rpx[] = {
    0,  0,  1,  1,  0,  0,  0,  0,  0,  2,  3,  4,  5,  6,  7,  8,  9, 10,
   11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28,
   29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46,
   47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64,
   65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82,
   83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99,100,
  101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,
  119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,
  137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,
  155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,
  173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,
  191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,
  209,210,211,212,213
};
#define AG_TCV(x) (((int)(x) >= 0 && (int)(x) <= 313) ? ag_tcv[(x)] : 0)

static const unsigned char ag_tcv[] = {
   11,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 96,
    0,103,100,  0, 24, 26,110,107,123,109,130,112,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0, 94, 30, 95,  0,124,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,118,  0,120,128,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,102,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0, 92, 87, 90, 88, 89, 80, 81, 82, 83, 84, 85, 86,  0, 99,
   97, 98,166,143,141,146,149,148,157,155,153,168, 57, 59, 74, 77, 78, 72,
   63, 65, 67, 62, 60, 46, 22, 35, 32,  0,  0, 13,104,106,113, 75,147,167,
  169,163,  0,150, 51, 52,132, 45
};

#ifndef SYNTAX_ERROR
#define SYNTAX_ERROR fprintf(stderr,"%s, line %d, column %d\n", \
  (PCB).error_message, (PCB).line, (PCB).column)
#endif

#ifndef FIRST_LINE
#define FIRST_LINE 1
#endif

#ifndef FIRST_COLUMN
#define FIRST_COLUMN 1
#endif

#ifndef PARSER_STACK_OVERFLOW
#define PARSER_STACK_OVERFLOW {fprintf(stderr, \
   "\nParser stack overflow, line %d, column %d\n",\
   (PCB).line, (PCB).column);}
#endif

#ifndef REDUCTION_TOKEN_ERROR
#define REDUCTION_TOKEN_ERROR {fprintf(stderr, \
    "\nReduction token error, line %d, column %d\n", \
    (PCB).line, (PCB).column);}
#endif


#ifndef AG_NEWLINE
#define AG_NEWLINE 10
#endif

#ifndef AG_RETURN
#define AG_RETURN 13
#endif

#ifndef AG_FORMFEED
#define AG_FORMFEED 12
#endif

#ifndef AG_TABCHAR
#define AG_TABCHAR 9
#endif

static void ag_track(void) {
  switch ((PCB).input_code) {
  case AG_NEWLINE:
    (PCB).column = 1, (PCB).line++;
  case AG_RETURN:
  case AG_FORMFEED:
    break;
  case AG_TABCHAR:
    (PCB).column += (TAB_SPACING) - ((PCB).column - 1) % (TAB_SPACING);
    break;
  default:
    (PCB).column++;
  }
  (PCB).read_flag = 1;
}


static void ag_prot(void) {
  int ag_k;
  ag_k = 128 - ++(PCB).btsx;
  if (ag_k <= (PCB).ssx) {
    (PCB).exit_flag = AG_STACK_ERROR_CODE;
    PARSER_STACK_OVERFLOW;
    return;
  }
  (PCB).bts[(PCB).btsx] = (PCB).sn;
  (PCB).bts[ag_k] = (PCB).ssx;
  (PCB).vs[ag_k] = (PCB).vs[(PCB).ssx];
  (PCB).ss[ag_k] = (PCB).ss[(PCB).ssx];
  (PCB).cs[ag_k] = (PCB).cs[(PCB).ssx];
}

static void ag_undo(void) {
  if ((PCB).drt == -1) return;
  while ((PCB).btsx) {
    int ag_k = 128 - (PCB).btsx;
    (PCB).sn = (PCB).bts[(PCB).btsx--];
    (PCB).ssx = (PCB).bts[ag_k];
    (PCB).vs[(PCB).ssx] = (PCB).vs[ag_k];
    (PCB).ss[(PCB).ssx] = (PCB).ss[ag_k];
    (PCB).cs[(PCB).ssx] = (PCB).cs[ag_k];
  }
  (PCB).token_number = (action_token_type) (PCB).drt;
  (PCB).ssx = (PCB).dssx;
  (PCB).sn = (PCB).dsn;
  (PCB).drt = -1;
}


static const unsigned char ag_tstt[] = {
13,0,1,10,12,
163,157,155,150,149,148,147,146,22,0,2,8,9,14,15,16,17,18,19,34,133,134,135,
  136,137,138,139,154,
13,11,0,12,
153,0,23,
163,157,155,153,150,149,148,147,146,132,118,74,63,62,57,51,46,45,32,0,2,7,
  20,33,34,37,38,39,40,41,42,43,44,47,53,54,55,56,64,68,73,79,125,126,127,
  129,133,134,135,136,137,138,139,154,
163,157,155,153,150,149,148,147,146,132,118,74,63,62,57,51,46,45,32,0,2,7,
  20,21,34,37,38,39,40,41,42,43,44,47,53,54,55,56,64,68,73,79,125,126,127,
  129,133,134,135,136,137,138,139,154,
153,141,0,3,23,156,
153,143,141,35,0,4,23,151,
153,0,23,164,165,
153,0,23,158,159,
150,149,148,147,146,22,0,8,9,17,18,19,34,
163,157,155,150,149,148,147,146,22,0,2,8,9,16,17,18,19,34,133,134,135,136,
  137,138,139,154,
30,24,0,27,
169,168,167,166,153,132,124,109,52,24,0,36,49,50,64,79,101,105,108,111,114,
  115,116,117,125,126,127,129,
130,0,
169,168,167,166,153,132,124,109,52,24,0,36,49,50,61,64,79,91,93,101,105,108,
  111,114,115,116,117,125,126,127,129,
128,24,0,
153,132,118,74,63,62,60,59,57,51,46,45,0,20,28,29,37,38,39,40,41,42,43,44,
  47,53,54,55,56,64,68,73,79,125,126,127,129,
153,0,64,
169,168,167,166,153,132,124,109,52,24,0,36,49,50,61,64,79,91,93,101,105,108,
  111,114,115,116,117,125,126,127,129,
78,77,72,0,69,70,71,76,
24,0,
24,0,
89,88,87,86,85,84,83,82,81,80,30,0,
169,168,167,153,110,0,117,119,121,152,
153,132,118,74,63,62,57,51,46,45,32,0,33,37,38,39,40,41,42,43,44,47,53,54,
  55,56,64,68,73,79,125,126,127,129,
153,143,141,0,4,23,151,
163,157,155,153,150,149,148,147,146,132,118,74,63,62,57,51,46,45,32,0,2,20,
  33,34,37,38,39,40,41,42,43,44,47,53,54,55,56,64,68,73,79,125,126,127,
  129,133,134,135,136,137,138,139,154,
153,132,118,74,63,62,57,51,46,45,32,0,21,37,38,39,40,41,42,43,44,47,53,54,
  55,56,64,68,73,79,125,126,127,129,
163,157,155,153,150,149,148,147,146,132,118,74,63,62,57,51,46,45,32,0,2,20,
  21,34,37,38,39,40,41,42,43,44,47,53,54,55,56,64,68,73,79,125,126,127,
  129,133,134,135,136,137,138,139,154,
30,0,
123,0,
153,0,3,23,156,
30,0,
123,0,
153,0,5,23,144,
153,0,6,23,142,
153,0,23,
30,0,
123,0,
118,0,160,
123,0,
35,0,
169,168,167,153,110,0,31,117,121,152,
24,0,
155,150,149,148,147,146,26,0,2,25,34,136,137,138,139,140,154,
24,0,
153,0,64,
169,168,167,166,153,132,124,109,52,24,0,36,49,50,64,79,101,105,108,111,114,
  115,116,117,125,126,127,129,
169,168,167,166,153,132,124,109,52,24,0,49,50,64,79,111,114,115,116,117,125,
  126,127,129,
113,112,110,0,
109,107,0,
106,104,0,
103,102,100,0,
153,0,131,
103,102,100,0,
99,98,97,96,95,94,30,0,
92,0,
90,75,0,
169,168,167,166,153,132,124,109,52,24,0,36,49,50,64,79,101,105,108,111,114,
  115,116,117,125,126,127,129,
153,132,118,74,63,62,57,51,46,45,0,37,38,39,40,41,42,43,44,47,53,54,55,56,
  64,68,73,79,125,126,127,129,
60,59,0,58,
30,0,
90,57,0,56,
169,168,167,166,153,132,124,109,52,24,0,36,49,50,61,64,79,91,93,101,105,108,
  111,114,115,116,117,125,126,127,129,
78,77,72,0,69,70,76,
153,132,118,74,72,63,62,57,51,46,45,0,20,28,29,37,38,39,40,41,42,43,44,47,
  53,54,55,56,64,68,73,79,125,126,127,129,
72,0,69,
169,168,167,166,153,132,124,109,52,24,0,36,49,50,64,79,101,105,108,111,114,
  115,116,117,125,126,127,129,
169,168,167,166,153,132,124,109,52,26,24,0,36,48,49,50,64,79,101,105,108,
  111,114,115,116,117,122,125,126,127,129,
169,168,167,166,153,132,124,109,52,24,0,36,49,50,64,79,101,105,108,111,114,
  115,116,117,125,126,127,129,
169,168,167,166,153,132,124,109,52,24,0,36,49,50,64,79,101,105,108,111,114,
  115,116,117,125,126,127,129,
169,168,167,166,153,132,124,109,52,24,0,36,49,50,64,79,101,105,108,111,114,
  115,116,117,125,126,127,129,
169,168,167,166,153,132,124,109,52,24,0,36,49,50,64,79,101,105,108,111,114,
  115,116,117,125,126,127,129,
169,168,167,166,153,132,124,109,52,24,0,36,49,50,64,79,101,105,108,111,114,
  115,116,117,125,126,127,129,
169,168,167,166,153,132,124,109,52,24,0,36,49,50,64,79,101,105,108,111,114,
  115,116,117,125,126,127,129,
169,168,167,166,153,132,124,109,52,24,0,36,49,50,64,79,101,105,108,111,114,
  115,116,117,125,126,127,129,
169,168,167,166,153,132,124,109,52,24,0,36,49,50,64,79,101,105,108,111,114,
  115,116,117,125,126,127,129,
169,168,167,166,153,132,124,109,52,24,0,36,49,50,64,79,101,105,108,111,114,
  115,116,117,125,126,127,129,
169,168,167,166,153,132,124,109,52,24,0,36,49,50,64,79,101,105,108,111,114,
  115,116,117,125,126,127,129,
169,168,167,166,153,132,124,109,52,24,0,36,49,50,64,79,101,105,108,111,114,
  115,116,117,125,126,127,129,
107,0,
169,168,167,153,120,110,0,117,121,152,
153,132,118,74,63,62,57,51,46,45,32,0,33,37,38,39,40,41,42,43,44,47,53,54,
  55,56,64,68,73,79,125,126,127,129,
153,132,118,74,63,62,57,51,46,45,32,0,21,37,38,39,40,41,42,43,44,47,53,54,
  55,56,64,68,73,79,125,126,127,129,
169,168,167,153,110,0,31,117,121,152,
153,0,23,156,
123,0,
169,168,167,153,118,110,0,31,117,121,152,
153,0,23,151,
30,24,0,
123,0,
30,0,
123,0,
30,24,0,27,
169,168,167,166,0,116,117,
153,0,23,165,
155,150,149,148,147,146,0,2,25,34,136,137,138,139,140,154,161,
153,0,23,159,
107,0,
155,150,149,148,147,146,26,0,2,25,34,136,137,138,139,140,154,
155,150,149,148,147,146,123,26,0,2,34,136,137,138,139,140,154,
169,168,167,166,153,132,124,109,52,26,24,0,36,48,49,50,64,79,101,105,108,
  111,114,115,116,117,122,125,126,127,129,
103,102,100,26,0,
169,168,167,166,153,132,124,109,52,24,0,49,50,64,79,111,114,115,116,117,125,
  126,127,129,
169,168,167,166,153,132,124,109,52,24,0,49,50,64,79,111,114,115,116,117,125,
  126,127,129,
169,168,167,166,153,132,124,109,52,24,0,49,50,64,79,111,114,115,116,117,125,
  126,127,129,
169,168,167,166,153,132,124,109,52,24,0,49,50,64,79,108,111,114,115,116,117,
  125,126,127,129,
169,168,167,166,153,132,124,109,52,24,0,49,50,64,79,108,111,114,115,116,117,
  125,126,127,129,
169,168,167,166,153,132,124,109,52,24,0,49,50,64,79,105,108,111,114,115,116,
  117,125,126,127,129,
169,168,167,166,153,132,124,109,52,24,0,49,50,64,79,105,108,111,114,115,116,
  117,125,126,127,129,
169,168,167,166,153,132,124,109,52,24,0,49,50,64,79,101,105,108,111,114,115,
  116,117,125,126,127,129,
169,168,167,166,153,132,124,109,52,24,0,49,50,64,79,101,105,108,111,114,115,
  116,117,125,126,127,129,
169,168,167,166,153,132,124,109,52,24,0,49,50,64,79,101,105,108,111,114,115,
  116,117,125,126,127,129,
169,168,167,166,153,132,124,109,52,24,0,36,49,50,64,79,101,105,108,111,114,
  115,116,117,125,126,127,129,
169,168,167,166,153,132,124,109,52,24,0,36,49,50,64,79,101,105,108,111,114,
  115,116,117,125,126,127,129,
169,168,167,166,153,132,124,109,52,24,0,36,49,50,64,79,101,105,108,111,114,
  115,116,117,125,126,127,129,
169,168,167,166,153,132,124,109,52,24,0,36,49,50,64,79,101,105,108,111,114,
  115,116,117,125,126,127,129,
169,168,167,166,153,132,124,109,52,24,0,36,49,50,64,79,101,105,108,111,114,
  115,116,117,125,126,127,129,
169,168,167,166,153,132,124,109,52,24,0,36,49,50,64,79,101,105,108,111,114,
  115,116,117,125,126,127,129,
169,168,167,166,153,132,124,109,52,24,0,36,49,50,64,79,101,105,108,111,114,
  115,116,117,125,126,127,129,
169,168,167,166,153,132,124,109,52,24,0,36,49,50,64,79,93,101,105,108,111,
  114,115,116,117,125,126,127,129,
169,168,167,166,153,132,124,109,52,24,0,36,49,50,64,79,91,93,101,105,108,
  111,114,115,116,117,125,126,127,129,
153,132,118,78,77,74,72,63,62,57,51,46,45,0,20,28,29,37,38,39,40,41,42,43,
  44,47,53,54,55,56,64,68,73,79,125,126,127,129,
103,102,100,26,0,
169,168,167,166,153,132,124,109,52,24,0,36,49,50,61,64,79,91,93,101,105,108,
  111,114,115,116,117,125,126,127,129,
59,0,
169,168,167,166,153,132,124,109,52,24,0,36,49,50,64,79,101,105,108,111,114,
  115,116,117,125,126,127,129,
90,75,0,
72,0,69,
103,102,100,26,0,
103,102,100,0,
123,0,
26,0,
103,102,100,0,
103,102,100,0,
103,102,100,0,
103,102,100,0,
103,102,100,0,
103,102,100,0,
103,102,100,0,
103,102,100,0,
103,102,100,0,
103,102,100,0,
103,102,100,0,
169,168,167,153,110,0,117,152,
107,0,
169,168,167,0,117,
169,168,167,166,153,118,110,0,31,116,117,121,152,
169,168,167,0,117,
153,0,23,144,
169,168,167,153,110,0,31,117,121,152,
153,0,23,142,
24,0,
155,150,149,148,147,146,26,0,2,25,34,136,137,138,139,140,154,
155,150,149,148,147,146,123,0,2,34,136,137,138,139,140,154,
120,0,162,
155,150,149,148,147,146,123,26,0,2,34,136,137,138,139,140,154,
155,150,149,148,147,146,0,2,34,136,137,138,139,140,154,
26,0,
113,112,110,0,
113,112,110,0,
109,107,0,
109,107,0,
106,104,0,
106,104,0,
106,104,0,
103,102,100,0,
103,102,100,0,
103,102,100,0,
103,102,100,0,
103,102,100,0,
103,102,100,0,
103,102,100,0,
99,98,97,96,95,94,30,0,
92,0,
90,0,
103,102,100,65,0,
153,132,118,78,77,74,72,63,62,57,51,46,45,0,20,28,29,37,38,39,40,41,42,43,
  44,47,53,54,55,56,64,68,73,79,125,126,127,129,
169,168,167,166,153,132,124,109,52,24,0,36,49,50,64,79,101,105,108,111,114,
  115,116,117,125,126,127,129,
120,0,
169,168,167,0,117,145,
26,0,
155,150,149,148,147,146,26,0,2,25,34,136,137,138,139,140,154,
155,150,149,148,147,146,123,26,0,2,34,136,137,138,139,140,154,
169,168,167,166,153,132,124,109,52,24,0,36,49,50,64,79,101,105,108,111,114,
  115,116,117,125,126,127,129,
103,102,100,0,
169,168,167,120,0,117,
30,0,
155,150,149,148,147,146,123,26,0,2,34,136,137,138,139,140,154,
103,102,100,67,57,0,66,
169,168,167,166,153,118,110,0,31,116,117,121,152,
169,168,167,166,153,132,124,109,52,24,0,36,49,50,64,79,101,105,108,111,114,
  115,116,117,125,126,127,129,
57,0,56,
169,168,167,0,117,145,
103,102,100,0,
169,168,167,120,0,117,
  0
};


static unsigned const char ag_astt[2567] = {
  1,7,0,1,2,1,1,2,2,2,2,2,2,1,7,2,1,1,3,1,3,1,2,2,1,2,2,2,2,2,2,2,1,1,3,7,2,
  2,7,1,1,1,2,2,2,2,2,2,2,2,1,2,1,1,1,2,2,1,1,4,2,1,1,2,1,2,2,2,2,2,2,2,2,1,
  2,2,2,2,1,1,1,1,2,2,2,1,2,2,2,2,2,2,2,1,1,1,2,2,2,2,2,2,2,2,1,2,1,1,1,2,2,
  1,2,4,2,1,1,2,1,2,2,2,2,2,2,2,2,1,2,2,2,2,1,1,1,1,2,2,2,1,2,2,2,2,2,2,2,1,
  2,1,7,1,1,2,2,1,1,1,7,1,1,2,2,7,1,1,2,2,7,1,1,2,2,2,2,2,2,1,5,1,1,3,2,2,1,
  1,1,2,2,2,2,2,2,1,7,2,1,1,3,1,2,2,1,2,2,2,2,2,2,2,1,1,1,7,1,2,2,2,2,2,2,1,
  1,2,1,7,1,2,1,1,2,1,1,1,2,2,2,2,2,2,2,2,1,1,7,2,2,2,2,2,2,1,1,2,1,7,1,2,1,
  1,1,2,1,1,1,1,1,2,2,2,2,2,2,2,2,1,2,1,4,2,2,1,2,1,1,4,4,1,2,2,1,7,1,1,2,2,
  2,2,2,2,2,2,2,1,2,2,2,2,1,1,1,1,2,2,2,1,2,7,1,2,2,2,2,2,2,1,1,2,1,7,1,2,1,
  1,1,2,1,1,1,1,1,2,2,2,2,2,2,2,2,1,1,1,2,7,2,1,1,2,1,4,1,7,1,1,1,1,1,1,1,1,
  1,1,1,7,2,2,2,2,2,7,2,1,1,2,2,2,1,2,1,1,1,2,2,1,1,4,2,2,2,2,2,2,2,2,2,1,2,
  2,2,2,1,1,1,1,2,2,2,1,2,1,1,7,1,1,2,1,1,2,2,2,2,2,2,2,2,1,2,1,1,1,2,2,1,1,
  4,2,1,2,1,2,2,2,2,2,2,2,2,1,2,2,2,2,1,1,1,1,2,2,2,1,2,2,2,2,2,2,2,1,2,2,1,
  2,1,1,1,2,2,1,2,4,2,2,2,2,2,2,2,2,2,1,2,2,2,2,1,1,1,1,2,2,2,1,1,1,2,2,2,2,
  2,2,2,2,1,2,1,1,1,2,2,1,2,4,2,1,2,1,2,2,2,2,2,2,2,2,1,2,2,2,2,1,1,1,1,2,2,
  2,1,2,2,2,2,2,2,2,1,1,4,1,4,2,7,1,1,2,1,4,1,4,2,7,1,1,2,2,7,1,1,2,2,7,1,1,
  7,1,4,2,7,1,1,4,1,7,2,2,2,2,2,7,2,2,1,2,1,7,2,2,2,2,2,2,2,7,2,1,1,2,2,2,2,
  2,1,1,7,2,7,2,2,2,2,2,2,2,1,1,2,1,7,1,2,1,1,2,1,1,1,2,2,2,2,2,2,2,2,1,2,2,
  2,2,2,2,1,1,2,1,7,2,1,1,2,2,2,2,2,2,2,2,2,1,1,1,1,4,1,1,4,1,1,4,1,1,1,4,2,
  7,2,1,1,1,4,1,1,1,1,1,1,1,4,1,4,1,1,7,2,2,2,2,2,2,1,1,2,1,7,1,2,1,1,2,1,1,
  1,2,2,2,2,2,2,2,2,1,2,2,1,2,1,1,1,2,2,1,4,2,2,2,2,2,2,2,2,1,2,2,2,2,1,1,1,
  1,2,2,2,1,1,4,7,1,1,7,1,1,7,2,2,2,2,2,2,2,1,1,2,1,7,1,2,1,1,1,2,1,1,1,1,1,
  2,2,2,2,2,2,2,2,1,1,1,2,7,2,1,2,2,2,1,2,4,1,1,1,2,2,1,7,1,2,2,2,2,2,2,2,2,
  2,2,1,2,2,2,2,1,1,1,1,2,2,2,1,2,7,2,2,2,2,2,2,2,1,1,2,1,7,1,2,1,1,2,1,1,1,
  2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,1,1,2,2,1,7,1,1,2,1,1,2,1,1,1,2,2,2,2,2,1,2,
  2,2,1,2,2,2,2,2,2,1,1,2,1,7,1,2,1,1,2,1,1,1,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,
  1,1,2,1,7,1,2,1,1,2,1,1,1,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,1,1,2,1,7,1,2,1,1,
  2,1,1,1,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,1,1,2,1,7,1,2,1,1,2,1,1,1,2,2,2,2,2,
  2,2,2,1,2,2,2,2,2,2,1,1,2,1,7,1,2,1,1,2,1,1,1,2,2,2,2,2,2,2,2,1,2,2,2,2,2,
  2,1,1,2,1,7,1,2,1,1,2,1,1,1,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,1,1,2,1,7,1,2,1,
  1,2,1,1,1,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,1,1,2,1,7,1,2,1,1,2,1,1,1,2,2,2,2,
  2,2,2,2,1,2,2,2,2,2,2,1,1,2,1,7,1,2,1,1,2,1,1,1,2,2,2,2,2,2,2,2,1,2,2,2,2,
  2,2,1,1,2,1,7,1,2,1,1,2,1,1,1,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,1,1,2,1,7,1,2,
  1,1,2,1,1,1,2,2,2,2,2,2,2,2,1,1,4,2,2,2,2,2,2,7,2,1,2,2,2,1,2,1,1,1,2,2,1,
  1,4,2,2,2,2,2,2,2,2,2,1,2,2,2,2,1,1,1,1,2,2,2,1,2,2,1,2,1,1,1,2,2,1,2,4,2,
  2,2,2,2,2,2,2,2,1,2,2,2,2,1,1,1,1,2,2,2,1,2,2,2,2,2,7,2,2,1,2,2,7,1,2,1,4,
  2,2,2,2,1,2,7,2,2,1,2,2,7,1,2,1,1,4,1,4,1,4,1,4,1,1,7,1,2,2,2,2,7,2,2,2,7,
  1,2,2,2,2,2,2,2,7,2,1,1,2,2,2,2,2,1,1,2,7,1,2,1,4,2,2,2,2,2,2,2,7,2,1,1,2,
  2,2,2,2,1,2,2,2,2,2,2,1,2,7,2,1,2,2,2,2,2,1,2,2,2,2,2,2,1,1,2,2,1,7,1,1,2,
  1,1,2,1,1,1,2,2,2,2,2,1,2,2,2,1,1,1,1,2,7,2,2,2,2,2,2,1,1,2,1,7,2,1,1,2,2,
  2,2,2,2,2,2,2,1,2,2,2,2,2,2,1,1,2,1,7,2,1,1,2,2,2,2,2,2,2,2,2,1,2,2,2,2,2,
  2,1,1,2,1,7,2,1,1,2,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,1,1,2,1,7,2,1,1,2,1,2,2,
  2,2,2,2,2,2,1,2,2,2,2,2,2,1,1,2,1,7,2,1,1,2,1,2,2,2,2,2,2,2,2,1,2,2,2,2,2,
  2,1,1,2,1,7,2,1,1,2,1,1,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,1,1,2,1,7,2,1,1,2,1,
  1,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,1,1,2,1,7,2,1,1,2,1,1,1,2,2,2,2,2,2,2,2,1,
  2,2,2,2,2,2,1,1,2,1,7,2,1,1,2,1,1,1,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,1,1,2,1,
  7,2,1,1,2,1,1,1,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,1,1,2,1,7,1,2,1,1,2,1,1,1,2,
  2,2,2,2,2,2,2,1,2,2,2,2,2,2,1,1,2,1,7,1,2,1,1,2,1,1,1,2,2,2,2,2,2,2,2,1,2,
  2,2,2,2,2,1,1,2,1,7,1,2,1,1,2,1,1,1,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,1,1,2,1,
  7,1,2,1,1,2,1,1,1,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,1,1,2,1,7,1,2,1,1,2,1,1,1,
  2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,1,1,2,1,7,1,2,1,1,2,1,1,1,2,2,2,2,2,2,2,2,1,
  2,2,2,2,2,2,1,1,2,1,7,1,2,1,1,2,1,1,1,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,1,1,2,
  1,7,1,2,1,1,2,1,1,1,1,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2,1,1,2,1,7,1,2,1,1,2,1,
  1,1,1,1,2,2,2,2,2,2,2,2,1,2,2,1,4,4,2,4,1,1,1,2,2,1,7,1,2,2,2,2,2,2,2,2,2,
  2,1,2,2,2,2,1,1,1,1,2,2,2,1,1,1,1,2,7,2,2,2,2,2,2,1,1,2,1,7,1,2,1,1,1,2,1,
  1,1,1,1,2,2,2,2,2,2,2,2,1,2,7,2,2,2,2,2,2,1,1,2,1,7,1,2,1,1,2,1,1,1,2,2,2,
  2,2,2,2,2,1,1,1,7,2,7,2,1,1,1,2,7,1,1,1,4,1,4,2,7,1,1,1,4,1,1,1,4,1,1,1,4,
  1,1,1,4,1,1,1,4,1,1,1,4,1,1,1,4,1,1,1,4,1,1,1,4,1,1,1,4,1,1,1,4,2,2,2,2,2,
  7,2,2,1,4,2,2,2,7,1,2,2,2,2,2,1,2,7,2,2,2,1,2,2,2,2,7,1,2,7,1,2,2,2,2,2,2,
  7,2,2,1,2,2,7,1,2,1,7,2,2,2,2,2,2,2,7,2,1,1,2,2,2,2,2,1,2,2,2,2,2,2,1,4,2,
  1,2,2,2,2,2,1,2,7,2,2,2,2,2,2,2,1,2,7,2,1,2,2,2,2,2,1,2,2,2,2,2,2,7,2,1,2,
  2,2,2,2,1,2,7,1,1,1,4,1,1,1,4,1,1,4,1,1,4,1,1,4,1,1,4,1,1,4,1,1,1,4,1,1,1,
  4,1,1,1,4,1,1,1,4,1,1,1,4,1,1,1,4,1,1,1,4,1,1,1,1,1,1,1,4,1,4,1,4,1,1,1,1,
  7,2,2,1,4,4,2,4,1,1,1,2,2,1,7,1,2,2,2,2,2,2,2,2,2,2,1,2,2,2,2,1,1,1,1,2,2,
  2,1,2,2,2,2,2,2,1,1,2,1,7,1,2,1,1,2,1,1,1,2,2,2,2,2,2,2,2,1,2,7,2,2,2,7,2,
  1,1,7,2,2,2,2,2,2,2,7,2,1,1,2,2,2,2,2,1,2,2,2,2,2,2,1,2,7,2,1,2,2,2,2,2,1,
  2,2,2,2,2,2,1,1,2,1,7,1,2,1,1,2,1,1,1,2,2,2,2,2,2,2,2,1,1,1,1,4,2,2,2,2,7,
  2,1,4,2,2,2,2,2,2,1,2,7,2,1,2,2,2,2,2,1,1,1,1,1,4,7,1,2,2,2,2,2,1,2,7,2,2,
  2,1,2,2,2,2,2,2,2,1,1,2,1,7,1,2,1,1,2,1,1,1,2,2,2,2,2,2,2,2,1,1,7,2,2,2,2,
  7,2,1,1,1,1,4,2,2,2,2,7,2,11
};


static const unsigned char ag_pstt[] = {
1,0,0,2,2,
8,9,197,181,180,179,178,177,3,1,151,4,5,4,11,4,10,9,10,7,141,145,146,147,
  148,149,150,6,
1,1,2,3,
215,3,12,
8,9,197,216,181,180,179,178,177,140,24,75,18,19,17,57,52,21,13,27,151,27,25,
  31,26,41,43,44,45,46,47,48,49,22,59,60,61,62,16,20,15,23,134,135,136,14,
  143,145,146,147,148,149,150,6,
8,9,197,216,181,180,179,178,177,140,24,75,18,19,17,57,52,21,26,11,151,29,28,
  15,26,41,43,44,45,46,47,48,49,22,59,60,61,62,16,20,15,23,134,135,136,14,
  143,145,146,147,148,149,150,6,
215,32,6,31,30,198,
215,35,36,37,7,34,33,182,
215,8,38,39,210,
215,9,40,41,203,
181,180,179,178,177,3,7,4,5,8,9,10,42,
8,9,197,181,180,179,178,177,3,11,151,4,5,5,10,9,10,7,142,145,146,147,148,
  149,150,6,
43,45,12,44,
220,219,218,214,216,140,47,49,58,48,13,53,124,46,16,131,52,51,50,117,118,
  120,121,122,134,135,136,14,
54,14,
220,219,218,214,216,140,47,49,58,48,15,55,124,46,58,16,131,57,56,52,51,50,
  117,118,120,121,122,134,135,136,14,
137,59,133,
216,140,24,75,18,19,40,40,17,57,52,21,17,60,61,23,41,43,44,45,46,47,48,49,
  22,59,60,61,62,16,20,15,23,134,135,136,14,
216,18,62,
220,219,218,214,216,140,47,49,58,48,19,55,124,46,63,16,131,57,56,52,51,50,
  117,118,120,121,122,134,135,136,14,
66,64,74,20,70,67,65,77,
68,51,
69,22,
70,71,72,73,74,75,76,77,78,79,80,23,
220,219,218,192,194,24,193,82,81,190,
216,140,24,75,18,19,17,57,52,21,13,29,30,42,43,44,45,46,47,48,49,22,59,60,
  61,62,16,20,15,23,134,135,136,14,
215,35,36,26,34,33,182,
8,9,197,216,181,180,179,178,177,140,24,75,18,19,17,57,52,21,13,28,151,83,33,
  26,41,43,44,45,46,47,48,49,22,59,60,61,62,16,20,15,23,134,135,136,14,
  144,145,146,147,148,149,150,6,
216,140,24,75,18,19,17,57,52,21,26,13,14,42,43,44,45,46,47,48,49,22,59,60,
  61,62,16,20,15,23,134,135,136,14,
8,9,197,216,181,180,179,178,177,140,24,75,18,19,17,57,52,21,26,12,151,84,17,
  26,41,43,44,45,46,47,48,49,22,59,60,61,62,16,20,15,23,134,135,136,14,
  144,145,146,147,148,149,150,6,
85,200,
86,196,
215,32,87,30,198,
88,184,
89,176,
215,35,91,90,166,
215,36,93,92,161,
215,37,94,
95,38,
96,209,
207,40,97,
98,202,
37,42,
220,219,218,192,194,43,25,193,99,190,
100,44,
197,181,180,179,178,177,21,45,159,101,26,156,155,157,158,154,6,
102,46,
216,47,132,
220,219,218,214,216,140,47,49,58,48,48,103,124,46,16,131,52,51,50,117,118,
  120,121,122,134,135,136,14,
220,219,218,214,216,140,47,49,58,48,49,124,46,16,131,119,118,120,121,122,
  134,135,136,14,
104,105,106,113,
107,108,110,
109,110,107,
111,112,113,39,
217,54,139,
111,112,113,103,
114,115,116,117,118,119,120,95,
121,93,
122,123,58,
220,219,218,214,216,140,47,49,58,48,59,124,124,46,16,131,52,51,50,117,118,
  120,121,122,134,135,136,14,
216,140,24,75,18,19,17,57,52,21,24,42,43,44,45,46,47,48,49,22,59,60,61,62,
  16,20,15,23,134,135,136,14,
125,64,61,126,
127,62,
122,17,63,66,
220,219,218,214,216,140,47,49,58,48,64,55,124,46,128,16,131,57,56,52,51,50,
  117,118,120,121,122,134,135,136,14,
66,64,74,65,72,129,78,
216,140,24,75,40,18,19,17,57,52,21,66,60,80,23,41,43,44,45,46,47,48,49,22,
  59,60,61,62,16,20,15,23,134,135,136,14,
74,67,71,
220,219,218,214,216,140,47,49,58,48,68,130,124,46,16,131,52,51,50,117,118,
  120,121,122,134,135,136,14,
220,219,218,214,216,140,47,49,58,54,48,69,131,133,124,46,16,131,52,51,50,
  117,118,120,121,122,132,134,135,136,14,
220,219,218,214,216,140,47,49,58,48,70,134,124,46,16,131,52,51,50,117,118,
  120,121,122,134,135,136,14,
220,219,218,214,216,140,47,49,58,48,71,135,124,46,16,131,52,51,50,117,118,
  120,121,122,134,135,136,14,
220,219,218,214,216,140,47,49,58,48,72,136,124,46,16,131,52,51,50,117,118,
  120,121,122,134,135,136,14,
220,219,218,214,216,140,47,49,58,48,73,137,124,46,16,131,52,51,50,117,118,
  120,121,122,134,135,136,14,
220,219,218,214,216,140,47,49,58,48,74,138,124,46,16,131,52,51,50,117,118,
  120,121,122,134,135,136,14,
220,219,218,214,216,140,47,49,58,48,75,139,124,46,16,131,52,51,50,117,118,
  120,121,122,134,135,136,14,
220,219,218,214,216,140,47,49,58,48,76,140,124,46,16,131,52,51,50,117,118,
  120,121,122,134,135,136,14,
220,219,218,214,216,140,47,49,58,48,77,141,124,46,16,131,52,51,50,117,118,
  120,121,122,134,135,136,14,
220,219,218,214,216,140,47,49,58,48,78,142,124,46,16,131,52,51,50,117,118,
  120,121,122,134,135,136,14,
220,219,218,214,216,140,47,49,58,48,79,143,124,46,16,131,52,51,50,117,118,
  120,121,122,134,135,136,14,
220,219,218,214,216,140,47,49,58,48,80,144,124,46,16,131,52,51,50,117,118,
  120,121,122,134,135,136,14,
145,126,
220,219,218,192,125,194,82,193,146,190,
216,140,24,75,18,19,17,57,52,21,13,32,34,42,43,44,45,46,47,48,49,22,59,60,
  61,62,16,20,15,23,134,135,136,14,
216,140,24,75,18,19,17,57,52,21,26,16,18,42,43,44,45,46,47,48,49,22,59,60,
  61,62,16,20,15,23,134,135,136,14,
220,219,218,192,194,85,201,193,99,190,
215,86,30,199,
86,195,
220,219,218,192,147,194,88,185,193,99,190,
215,89,33,183,
148,149,168,
150,165,
151,163,
152,160,
43,154,94,153,
220,219,218,214,95,213,212,
215,96,38,211,
197,181,180,179,178,177,97,159,155,26,156,155,157,158,154,6,156,
215,98,40,204,
145,189,
197,181,180,179,178,177,20,100,159,157,26,156,155,157,158,154,6,
197,181,180,179,178,177,158,19,101,159,26,156,155,157,158,152,6,
220,219,218,214,216,140,47,49,58,56,48,102,131,159,124,46,16,131,52,51,50,
  117,118,120,121,122,132,134,135,136,14,
111,112,113,123,103,
220,219,218,214,216,140,47,49,58,48,104,124,46,16,131,116,118,120,121,122,
  134,135,136,14,
220,219,218,214,216,140,47,49,58,48,105,124,46,16,131,115,118,120,121,122,
  134,135,136,14,
220,219,218,214,216,140,47,49,58,48,106,124,46,16,131,114,118,120,121,122,
  134,135,136,14,
220,219,218,214,216,140,47,49,58,48,107,124,46,16,131,160,117,118,120,121,
  122,134,135,136,14,
220,219,218,214,216,140,47,49,58,48,108,124,46,16,131,161,117,118,120,121,
  122,134,135,136,14,
220,219,218,214,216,140,47,49,58,48,109,124,46,16,131,162,50,117,118,120,
  121,122,134,135,136,14,
220,219,218,214,216,140,47,49,58,48,110,124,46,16,131,163,50,117,118,120,
  121,122,134,135,136,14,
220,219,218,214,216,140,47,49,58,48,111,124,46,16,131,164,51,50,117,118,120,
  121,122,134,135,136,14,
220,219,218,214,216,140,47,49,58,48,112,124,46,16,131,165,51,50,117,118,120,
  121,122,134,135,136,14,
220,219,218,214,216,140,47,49,58,48,113,124,46,16,131,166,51,50,117,118,120,
  121,122,134,135,136,14,
220,219,218,214,216,140,47,49,58,48,114,167,124,46,16,131,52,51,50,117,118,
  120,121,122,134,135,136,14,
220,219,218,214,216,140,47,49,58,48,115,168,124,46,16,131,52,51,50,117,118,
  120,121,122,134,135,136,14,
220,219,218,214,216,140,47,49,58,48,116,169,124,46,16,131,52,51,50,117,118,
  120,121,122,134,135,136,14,
220,219,218,214,216,140,47,49,58,48,117,170,124,46,16,131,52,51,50,117,118,
  120,121,122,134,135,136,14,
220,219,218,214,216,140,47,49,58,48,118,171,124,46,16,131,52,51,50,117,118,
  120,121,122,134,135,136,14,
220,219,218,214,216,140,47,49,58,48,119,172,124,46,16,131,52,51,50,117,118,
  120,121,122,134,135,136,14,
220,219,218,214,216,140,47,49,58,48,120,173,124,46,16,131,52,51,50,117,118,
  120,121,122,134,135,136,14,
220,219,218,214,216,140,47,49,58,48,121,55,124,46,16,131,174,52,51,50,117,
  118,120,121,122,134,135,136,14,
220,219,218,214,216,140,47,49,58,48,122,55,124,46,16,131,175,56,52,51,50,
  117,118,120,121,122,134,135,136,14,
216,140,24,40,40,75,40,18,19,17,57,52,21,123,60,76,23,41,43,44,45,46,47,48,
  49,22,59,60,61,62,16,20,15,23,134,135,136,14,
111,112,113,138,124,
220,219,218,214,216,140,47,49,58,48,125,55,124,46,176,16,131,57,56,52,51,50,
  117,118,120,121,122,134,135,136,14,
63,126,
220,219,218,214,216,140,47,49,58,48,127,177,124,46,16,131,52,51,50,117,118,
  120,121,122,134,135,136,14,
122,178,128,
74,129,73,
111,112,113,50,130,
111,112,113,129,
179,128,
53,133,
111,112,113,91,
111,112,113,90,
111,112,113,89,
111,112,113,88,
111,112,113,87,
111,112,113,86,
111,112,113,85,
111,112,113,84,
111,112,113,83,
111,112,113,82,
111,112,113,81,
220,219,218,192,194,145,193,191,
145,127,
220,219,218,147,180,
220,219,218,214,192,181,194,148,173,175,193,99,190,
220,219,218,149,182,
215,150,90,167,
220,219,218,192,194,151,164,193,99,190,
215,152,92,162,
183,153,
197,181,180,179,178,177,35,154,159,184,26,156,155,157,158,154,6,
197,181,180,179,178,177,158,208,159,26,156,155,157,158,152,6,
206,156,205,
197,181,180,179,178,177,158,22,157,159,26,156,155,157,158,152,6,
197,181,180,179,178,177,158,159,26,156,155,157,158,153,6,
55,159,
104,105,106,112,
104,105,106,111,
107,108,109,
107,108,108,
109,110,106,
109,110,105,
109,110,104,
111,112,113,102,
111,112,113,101,
111,112,113,100,
111,112,113,99,
111,112,113,98,
111,112,113,97,
111,112,113,96,
114,115,116,117,118,119,120,94,
121,92,
122,65,
111,112,113,185,177,
216,140,24,40,40,75,40,18,19,17,57,52,21,178,60,79,23,41,43,44,45,46,47,48,
  49,22,59,60,61,62,16,20,15,23,134,135,136,14,
220,219,218,214,216,140,47,49,58,48,179,186,124,46,16,131,52,51,50,117,118,
  120,121,122,134,135,136,14,
186,180,
220,219,218,181,187,187,
188,182,
197,181,180,179,178,177,36,183,159,189,26,156,155,157,158,154,6,
197,181,180,179,178,177,158,37,184,159,26,156,155,157,158,152,6,
220,219,218,214,216,140,47,49,58,48,185,190,124,46,16,131,52,51,50,117,118,
  120,121,122,134,135,136,14,
111,112,113,130,
220,219,218,174,187,188,
191,169,
197,181,180,179,178,177,158,38,189,159,26,156,155,157,158,152,6,
111,112,113,192,68,190,193,
220,219,218,214,192,194,194,191,170,172,193,99,190,
220,219,218,214,216,140,47,49,58,48,192,195,124,46,16,131,52,51,50,117,118,
  120,121,122,134,135,136,14,
17,193,67,
220,219,218,194,187,196,
111,112,113,69,
220,219,218,171,196,188,
  0
};


static const unsigned short ag_sbt[] = {
     0,   5,  33,  37,  40,  94, 148, 154, 162, 167, 172, 185, 211, 215,
   243, 245, 276, 279, 316, 319, 350, 358, 360, 362, 374, 384, 418, 425,
   478, 512, 565, 567, 569, 574, 576, 578, 583, 588, 591, 593, 595, 598,
   600, 602, 612, 614, 631, 633, 636, 664, 688, 692, 695, 698, 702, 705,
   709, 717, 719, 722, 750, 782, 786, 788, 792, 823, 830, 866, 869, 897,
   928, 956, 984,1012,1040,1068,1096,1124,1152,1180,1208,1236,1238,1248,
  1282,1316,1326,1330,1332,1343,1347,1350,1352,1354,1356,1360,1367,1371,
  1388,1392,1394,1411,1428,1459,1464,1488,1512,1536,1561,1586,1612,1638,
  1665,1692,1719,1747,1775,1803,1831,1859,1887,1915,1944,1974,2012,2017,
  2048,2050,2078,2081,2084,2089,2093,2095,2097,2101,2105,2109,2113,2117,
  2121,2125,2129,2133,2137,2141,2149,2151,2156,2169,2174,2178,2188,2192,
  2194,2211,2227,2230,2247,2262,2264,2268,2272,2275,2278,2281,2284,2287,
  2291,2295,2299,2303,2307,2311,2315,2323,2325,2327,2332,2370,2398,2400,
  2406,2408,2425,2442,2470,2474,2480,2482,2499,2506,2519,2547,2550,2556,
  2560,2566
};


static const unsigned short ag_sbe[] = {
     1,  14,  35,  38,  59, 113, 150, 158, 163, 168, 178, 194, 213, 225,
   244, 255, 278, 291, 317, 329, 353, 359, 361, 373, 379, 395, 421, 444,
   489, 531, 566, 568, 570, 575, 577, 579, 584, 589, 592, 594, 596, 599,
   601, 607, 613, 621, 632, 634, 646, 674, 691, 694, 697, 701, 703, 708,
   716, 718, 721, 732, 760, 784, 787, 790, 802, 826, 841, 867, 879, 908,
   938, 966, 994,1022,1050,1078,1106,1134,1162,1190,1218,1237,1244,1259,
  1293,1321,1327,1331,1338,1344,1349,1351,1353,1355,1358,1364,1368,1377,
  1389,1393,1401,1419,1439,1463,1474,1498,1522,1546,1571,1596,1622,1648,
  1675,1702,1729,1757,1785,1813,1841,1869,1897,1925,1954,1987,2016,2027,
  2049,2060,2080,2082,2088,2092,2094,2096,2100,2104,2108,2112,2116,2120,
  2124,2128,2132,2136,2140,2146,2150,2154,2163,2172,2175,2183,2189,2193,
  2201,2218,2228,2238,2253,2263,2267,2271,2274,2277,2280,2283,2286,2290,
  2294,2298,2302,2306,2310,2314,2322,2324,2326,2331,2345,2380,2399,2403,
  2407,2415,2433,2452,2473,2478,2481,2490,2504,2513,2529,2548,2553,2559,
  2564,2566
};


static const unsigned char ag_fl[] = {
  1,2,1,2,2,2,1,1,2,1,1,1,2,2,3,2,3,3,4,5,5,4,6,1,1,2,1,1,2,2,3,2,3,3,4,
  5,6,6,7,2,0,1,2,1,1,1,1,1,1,1,4,1,1,4,3,4,3,1,1,1,1,1,1,4,0,2,3,8,0,2,
  2,3,3,4,1,1,4,1,2,4,2,3,3,3,3,3,3,3,3,3,3,3,3,1,3,1,3,3,3,3,3,3,3,1,3,
  3,3,1,3,3,1,3,3,1,3,3,3,1,1,2,1,1,1,3,1,3,1,2,1,1,3,1,2,1,1,1,1,2,4,3,
  1,1,2,1,2,1,1,1,1,1,1,1,2,3,1,1,1,1,1,1,3,1,3,1,3,3,1,3,1,4,6,8,6,3,5,
  3,2,1,1,1,1,1,1,3,1,3,5,1,2,1,1,3,1,1,1,3,2,1,1,3,1,3,2,1,3,4,1,1,1,2,
  1,3,3,3,1,1,1,1,1,1,1
};

static const unsigned char ag_ptt[] = {
    0,  1, 10, 10, 12, 14, 14, 16, 16, 17, 17, 18, 18, 18, 18, 18, 18, 18,
   18,  9,  9,  9,  9, 28, 28, 27, 21, 19, 19, 19, 19, 19, 19, 19, 19,  8,
    8,  8,  8, 33, 29, 20, 20, 37, 37, 37, 38, 38, 38, 38, 44, 44, 42, 43,
   43, 49, 49, 47, 50, 39, 39, 39, 39, 56, 58, 58, 54, 55, 66, 66, 53, 53,
   53, 53, 69, 73, 68, 71, 71, 76, 70, 41, 41, 41, 41, 41, 41, 41, 41, 41,
   41, 41, 61, 61, 91, 91, 93, 93, 93, 93, 93, 93, 93, 93, 36, 36, 36, 36,
  101,101,101,105,105,105,108,108,108,108,111,111,114,114,114,114,114, 40,
  119,119, 48,122,122,115,115, 79, 79, 79, 79,125,126,127,129, 15, 15,  7,
    7,133,133,133,133,133,133,133, 25, 25, 25,140,140,140,140,140,137,  6,
    6,142,142,136,  5,  5,144,144,144,144,144,144,144,144,  2, 34, 34, 34,
   34, 34,  4,  4,151,151,151,145,145, 31,121,121,152,152,152,139,138,154,
    3,  3,156,156,134,158,158,159,162,160,161,135,164,164,165,165,116, 23,
   64,131,117,117,117
};


static void ag_ra(void)
{
  switch(ag_rpx[(PCB).ag_ap]) {
    case 1: ag_rp_1(); break;
    case 2: ag_rp_3(V(0,(NODE * *))); break;
    case 3: ag_rp_4(V(0,(NODE * *))); break;
    case 4: V(0,(NODE * *)) = ag_rp_5(V(0,(symbol * *))); break;
    case 5: V(0,(NODE * *)) = ag_rp_6(V(0,(symbol * *)), V(1,(symbol * *))); break;
    case 6: V(0,(NODE * *)) = ag_rp_7(V(0,(symbol * *)), V(1,(NODE * *))); break;
    case 7: V(0,(NODE * *)) = ag_rp_8(V(0,(symbol * *)), V(1,(NODE * *)), V(2,(NODE * *))); break;
    case 8: V(0,(NODE * *)) = ag_rp_9(V(0,(symbol * *)), V(1,(NODE * *))); break;
    case 9: V(0,(NODE * *)) = ag_rp_10(V(0,(symbol * *)), V(1,(symbol * *)), V(2,(NODE * *))); break;
    case 10: V(0,(NODE * *)) = ag_rp_11(V(0,(symbol * *)), V(1,(symbol * *)), V(2,(NODE * *))); break;
    case 11: V(0,(NODE * *)) = ag_rp_12(V(0,(symbol * *)), V(1,(symbol * *)), V(2,(NODE * *)), V(3,(NODE * *))); break;
    case 12: V(0,(symbol * *)) = ag_rp_13(V(1,(symbol * *)), V(3,(symbol * *))); break;
    case 13: V(0,(symbol * *)) = ag_rp_14(V(1,(symbol * *)), V(2,(int *))); break;
    case 14: V(0,(symbol * *)) = ag_rp_15(V(1,(symbol * *))); break;
    case 15: V(0,(symbol * *)) = ag_rp_16(V(1,(symbol * *)), V(2,(int *)), V(4,(symbol * *))); break;
    case 16: V(0,(NODE * *)) = ag_rp_17(V(0,(void * *))); break;
    case 17: V(0,(NODE * *)) = ag_rp_18(V(0,(NODE * *))); break;
    case 18: V(0,(int *)) = ag_rp_19(V(1,(int *))); break;
    case 19: V(0,(NODE * *)) = ag_rp_20(); break;
    case 20: V(0,(NODE * *)) = ag_rp_21(V(0,(symbol * *))); break;
    case 21: V(0,(NODE * *)) = ag_rp_22(V(0,(symbol * *)), V(1,(symbol * *))); break;
    case 22: V(0,(NODE * *)) = ag_rp_23(V(0,(symbol * *)), V(1,(NODE * *))); break;
    case 23: V(0,(NODE * *)) = ag_rp_24(V(0,(symbol * *)), V(1,(NODE * *)), V(2,(NODE * *))); break;
    case 24: V(0,(NODE * *)) = ag_rp_25(V(0,(symbol * *)), V(1,(NODE * *))); break;
    case 25: V(0,(NODE * *)) = ag_rp_26(V(0,(symbol * *)), V(1,(symbol * *)), V(2,(NODE * *))); break;
    case 26: V(0,(NODE * *)) = ag_rp_27(V(0,(symbol * *)), V(1,(symbol * *)), V(2,(NODE * *))); break;
    case 27: V(0,(NODE * *)) = ag_rp_28(V(0,(symbol * *)), V(1,(symbol * *)), V(2,(NODE * *)), V(3,(NODE * *))); break;
    case 28: V(0,(symbol * *)) = ag_rp_29(V(0,(link * *)), V(2,(symbol * *))); break;
    case 29: V(0,(symbol * *)) = ag_rp_30(V(0,(link * *)), V(2,(symbol * *)), V(3,(int *))); break;
    case 30: V(0,(symbol * *)) = ag_rp_31(V(0,(link * *)), V(2,(symbol * *)), V(4,(symbol * *))); break;
    case 31: V(0,(symbol * *)) = ag_rp_32(V(0,(link * *)), V(2,(symbol * *)), V(3,(int *)), V(5,(symbol * *))); break;
    case 32: V(0,(NODE * *)) = ag_rp_33(V(1,(NODE * *))); break;
    case 33: V(0,(void * *)) = ag_rp_34(); break;
    case 34: V(0,(NODE * *)) = ag_rp_35(V(0,(NODE * *))); break;
    case 35: V(0,(NODE * *)) = ag_rp_36(V(0,(NODE * *)), V(1,(NODE * *))); break;
    case 36: V(0,(NODE * *)) = ag_rp_37(V(0,(NODE * *))); break;
    case 37: V(0,(NODE * *)) = ag_rp_38(V(0,(NODE * *))); break;
    case 38: V(0,(NODE * *)) = ag_rp_39(V(0,(NODE * *))); break;
    case 39: V(0,(NODE * *)) = ag_rp_40(V(0,(NODE * *))); break;
    case 40: V(0,(NODE * *)) = ag_rp_41(V(0,(NODE * *))); break;
    case 41: V(0,(NODE * *)) = ag_rp_42(V(0,(NODE * *))); break;
    case 42: V(0,(NODE * *)) = ag_rp_43(V(0,(NODE * *))); break;
    case 43: V(0,(NODE * *)) = ag_rp_44(V(2,(NODE * *))); break;
    case 44: V(0,(NODE * *)) = ag_rp_45(); break;
    case 45: V(0,(NODE * *)) = ag_rp_46(); break;
    case 46: V(0,(NODE * *)) = ag_rp_47(V(0,(NODE * *)), V(2,(NODE * *))); break;
    case 47: V(0,(NODE * *)) = ag_rp_48(V(0,(NODE * *))); break;
    case 48: V(0,(NODE * *)) = ag_rp_49(V(0,(NODE * *)), V(2,(NODE * *))); break;
    case 49: V(0,(NODE * *)) = ag_rp_50(V(0,(NODE * *))); break;
    case 50: V(0,(NODE * *)) = ag_rp_51(V(0,(token *))); break;
    case 51: V(0,(NODE * *)) = ag_rp_52(V(0,(token *))); break;
    case 52: V(0,(NODE * *)) = ag_rp_53(V(0,(NODE * *))); break;
    case 53: V(0,(NODE * *)) = ag_rp_54(V(0,(NODE * *))); break;
    case 54: V(0,(NODE * *)) = ag_rp_55(V(0,(NODE * *))); break;
    case 55: V(0,(NODE * *)) = ag_rp_56(V(0,(NODE * *))); break;
    case 56: V(0,(NODE * *)) = ag_rp_57(V(1,(NODE * *)), V(2,(NODE * *))); break;
    case 57: V(0,(NODE * *)) = ag_rp_58(); break;
    case 58: V(0,(NODE * *)) = ag_rp_59(V(1,(NODE * *))); break;
    case 59: V(0,(NODE * *)) = ag_rp_60(V(1,(NODE * *)), V(2,(NODE * *))); break;
    case 60: V(0,(NODE * *)) = ag_rp_61(V(1,(NODE * *)), V(3,(NODE * *)), V(5,(NODE * *)), V(6,(NODE * *)), V(7,(NODE * *))); break;
    case 61: V(0,(NODE * *)) = ag_rp_62(); break;
    case 62: V(0,(NODE * *)) = ag_rp_63(V(1,(NODE * *))); break;
    case 63: V(0,(NODE * *)) = ag_rp_64(V(0,(NODE * *))); break;
    case 64: V(0,(NODE * *)) = ag_rp_65(V(0,(NODE * *)), V(1,(NODE * *))); break;
    case 65: V(0,(NODE * *)) = ag_rp_66(V(0,(NODE * *)), V(1,(NODE * *))); break;
    case 66: V(0,(NODE * *)) = ag_rp_67(V(0,(NODE * *)), V(1,(NODE * *)), V(2,(NODE * *))); break;
    case 67: ag_rp_68(); break;
    case 68: ag_rp_69(); break;
    case 69: V(0,(NODE * *)) = ag_rp_70(V(1,(NODE * *)), V(3,(NODE * *))); break;
    case 70: V(0,(NODE * *)) = ag_rp_71(V(0,(NODE * *))); break;
    case 71: V(0,(NODE * *)) = ag_rp_72(V(0,(NODE * *)), V(1,(NODE * *))); break;
    case 72: V(0,(NODE * *)) = ag_rp_73(V(1,(NODE * *)), V(3,(NODE * *))); break;
    case 73: V(0,(NODE * *)) = ag_rp_74(V(1,(NODE * *))); break;
    case 74: V(0,(NODE * *)) = ag_rp_75(V(0,(NODE * *)), V(2,(NODE * *))); break;
    case 75: V(0,(NODE * *)) = ag_rp_76(V(0,(NODE * *)), V(2,(NODE * *))); break;
    case 76: V(0,(NODE * *)) = ag_rp_77(V(0,(NODE * *)), V(2,(NODE * *))); break;
    case 77: V(0,(NODE * *)) = ag_rp_78(V(0,(NODE * *)), V(2,(NODE * *))); break;
    case 78: V(0,(NODE * *)) = ag_rp_79(V(0,(NODE * *)), V(2,(NODE * *))); break;
    case 79: V(0,(NODE * *)) = ag_rp_80(V(0,(NODE * *)), V(2,(NODE * *))); break;
    case 80: V(0,(NODE * *)) = ag_rp_81(V(0,(NODE * *)), V(2,(NODE * *))); break;
    case 81: V(0,(NODE * *)) = ag_rp_82(V(0,(NODE * *)), V(2,(NODE * *))); break;
    case 82: V(0,(NODE * *)) = ag_rp_83(V(0,(NODE * *)), V(2,(NODE * *))); break;
    case 83: V(0,(NODE * *)) = ag_rp_84(V(0,(NODE * *)), V(2,(NODE * *))); break;
    case 84: V(0,(NODE * *)) = ag_rp_85(V(0,(NODE * *)), V(2,(NODE * *))); break;
    case 85: V(0,(NODE * *)) = ag_rp_86(V(0,(NODE * *)), V(2,(NODE * *))); break;
    case 86: V(0,(NODE * *)) = ag_rp_87(V(0,(NODE * *))); break;
    case 87: V(0,(NODE * *)) = ag_rp_88(V(0,(NODE * *)), V(2,(NODE * *))); break;
    case 88: V(0,(NODE * *)) = ag_rp_89(V(0,(NODE * *))); break;
    case 89: V(0,(NODE * *)) = ag_rp_90(V(0,(NODE * *)), V(2,(NODE * *))); break;
    case 90: V(0,(NODE * *)) = ag_rp_91(V(0,(NODE * *)), V(2,(NODE * *))); break;
    case 91: V(0,(NODE * *)) = ag_rp_92(V(0,(NODE * *)), V(2,(NODE * *))); break;
    case 92: V(0,(NODE * *)) = ag_rp_93(V(0,(NODE * *)), V(2,(NODE * *))); break;
    case 93: V(0,(NODE * *)) = ag_rp_94(V(0,(NODE * *)), V(2,(NODE * *))); break;
    case 94: V(0,(NODE * *)) = ag_rp_95(V(0,(NODE * *)), V(2,(NODE * *))); break;
    case 95: V(0,(NODE * *)) = ag_rp_96(V(0,(NODE * *)), V(2,(NODE * *))); break;
    case 96: V(0,(NODE * *)) = ag_rp_97(V(0,(NODE * *))); break;
    case 97: V(0,(NODE * *)) = ag_rp_98(V(0,(NODE * *)), V(2,(NODE * *))); break;
    case 98: V(0,(NODE * *)) = ag_rp_99(V(0,(NODE * *)), V(2,(NODE * *))); break;
    case 99: V(0,(NODE * *)) = ag_rp_100(V(0,(NODE * *)), V(2,(NODE * *))); break;
    case 100: V(0,(NODE * *)) = ag_rp_101(V(0,(NODE * *))); break;
    case 101: V(0,(NODE * *)) = ag_rp_102(V(0,(NODE * *)), V(2,(NODE * *))); break;
    case 102: V(0,(NODE * *)) = ag_rp_103(V(0,(NODE * *)), V(2,(NODE * *))); break;
    case 103: V(0,(NODE * *)) = ag_rp_104(V(0,(NODE * *))); break;
    case 104: V(0,(NODE * *)) = ag_rp_105(V(0,(NODE * *)), V(2,(NODE * *))); break;
    case 105: V(0,(NODE * *)) = ag_rp_106(V(0,(NODE * *)), V(2,(NODE * *))); break;
    case 106: V(0,(NODE * *)) = ag_rp_107(V(0,(NODE * *))); break;
    case 107: V(0,(NODE * *)) = ag_rp_108(V(0,(NODE * *)), V(2,(NODE * *))); break;
    case 108: V(0,(NODE * *)) = ag_rp_109(V(0,(NODE * *)), V(2,(NODE * *))); break;
    case 109: V(0,(NODE * *)) = ag_rp_110(V(0,(NODE * *)), V(2,(NODE * *))); break;
    case 110: V(0,(NODE * *)) = ag_rp_111(V(0,(NODE * *))); break;
    case 111: V(0,(NODE * *)) = ag_rp_112(V(0,(NODE * *))); break;
    case 112: V(0,(NODE * *)) = ag_rp_113(V(1,(NODE * *))); break;
    case 113: V(0,(NODE * *)) = ag_rp_114(V(0,(NODE * *))); break;
    case 114: V(0,(NODE * *)) = ag_rp_115(V(0,(char * *))); break;
    case 115: V(0,(NODE * *)) = ag_rp_116(V(0,(int *))); break;
    case 116: V(0,(NODE * *)) = ag_rp_117(V(1,(NODE * *))); break;
    case 117: V(0,(NODE * *)) = ag_rp_118(V(0,(NODE * *))); break;
    case 118: V(0,(NODE * *)) = ag_rp_119(V(1,(CLIST * *))); break;
    case 119: V(0,(CLIST * *)) = ag_rp_120(V(0,(int *))); break;
    case 120: V(0,(CLIST * *)) = ag_rp_121(V(0,(CLIST * *)), V(1,(int *))); break;
    case 121: V(0,(NODE * *)) = ag_rp_122(V(0,(NODE * *))); break;
    case 122: V(0,(NODE * *)) = ag_rp_123(V(0,(NODE * *))); break;
    case 123: V(0,(NODE * *)) = ag_rp_124(V(0,(NODE * *)), V(2,(NODE * *))); break;
    case 124: V(0,(NODE * *)) = ag_rp_125(V(0,(NODE * *))); break;
    case 125: V(0,(NODE * *)) = ag_rp_126(V(1,(NODE * *))); break;
    case 126: V(0,(NODE * *)) = ag_rp_127(V(0,(NODE * *))); break;
    case 127: V(0,(NODE * *)) = ag_rp_128(V(0,(NODE * *))); break;
    case 128: V(0,(NODE * *)) = ag_rp_129(V(0,(NODE * *))); break;
    case 129: V(0,(NODE * *)) = ag_rp_130(V(0,(NODE * *))); break;
    case 130: V(0,(NODE * *)) = ag_rp_131(V(0,(NODE * *))); break;
    case 131: V(0,(NODE * *)) = ag_rp_132(V(0,(NODE * *)), V(2,(NODE * *))); break;
    case 132: V(0,(NODE * *)) = ag_rp_133(V(0,(NODE * *)), V(2,(NODE * *))); break;
    case 133: V(0,(NODE * *)) = ag_rp_134(V(0,(token *))); break;
    case 134: ag_rp_135(V(0,(symbol * *))); break;
    case 135: ag_rp_136(V(1,(symbol * *))); break;
    case 136: V(0,(symbol * *)) = ag_rp_137(V(0,(symbol * *))); break;
    case 137: V(0,(symbol * *)) = ag_rp_138(V(0,(symbol * *)), V(1,(symbol * *))); break;
    case 138: V(0,(symbol * *)) = ag_rp_139(V(0,(symbol * *))); break;
    case 139: V(0,(symbol * *)) = ag_rp_140(V(0,(symbol * *))); break;
    case 140: V(0,(symbol * *)) = ag_rp_141(V(0,(symbol * *))); break;
    case 141: V(0,(symbol * *)) = ag_rp_142(V(0,(symbol * *))); break;
    case 142: V(0,(symbol * *)) = ag_rp_143(V(0,(symbol * *))); break;
    case 143: V(0,(symbol * *)) = ag_rp_144(V(0,(symbol * *))); break;
    case 144: V(0,(symbol * *)) = ag_rp_145(V(0,(symbol * *))); break;
    case 145: V(0,(symbol * *)) = ag_rp_146(V(0,(symbol * *)), V(1,(symbol * *))); break;
    case 146: V(0,(symbol * *)) = ag_rp_147(V(0,(symbol * *)), V(2,(symbol * *))); break;
    case 147: V(0,(symbol * *)) = ag_rp_148(V(0,(symbol * *))); break;
    case 148: V(0,(symbol * *)) = ag_rp_149(V(0,(symbol * *))); break;
    case 149: V(0,(symbol * *)) = ag_rp_150(V(0,(symbol * *))); break;
    case 150: V(0,(symbol * *)) = ag_rp_151(V(0,(symbol * *))); break;
    case 151: V(0,(symbol * *)) = ag_rp_152(V(0,(symbol * *))); break;
    case 152: V(0,(symbol * *)) = ag_rp_153(V(0,(symbol * *))); break;
    case 153: V(0,(symbol * *)) = ag_rp_154(V(0,(link * *)), V(2,(symbol * *))); break;
    case 154: V(0,(symbol * *)) = ag_rp_155(V(0,(symbol * *))); break;
    case 155: V(0,(symbol * *)) = ag_rp_156(V(0,(symbol * *)), V(2,(symbol * *))); break;
    case 156: V(0,(symbol * *)) = ag_rp_157(V(0,(symbol * *))); break;
    case 157: V(0,(symbol * *)) = ag_rp_158(V(0,(symbol * *)), V(2,(int *))); break;
    case 158: V(0,(symbol * *)) = ag_rp_159(V(0,(link * *)), V(2,(symbol * *))); break;
    case 159: V(0,(symbol * *)) = ag_rp_160(V(0,(symbol * *))); break;
    case 160: V(0,(symbol * *)) = ag_rp_161(V(0,(symbol * *)), V(2,(symbol * *))); break;
    case 161: V(0,(symbol * *)) = ag_rp_162(V(0,(symbol * *))); break;
    case 162: V(0,(symbol * *)) = ag_rp_163(V(0,(symbol * *)), V(2,(int *))); break;
    case 163: V(0,(symbol * *)) = ag_rp_164(V(0,(symbol * *)), V(2,(int *)), V(5,(int *))); break;
    case 164: V(0,(symbol * *)) = ag_rp_165(V(0,(symbol * *)), V(2,(int *)), V(6,(CLIST * *))); break;
    case 165: V(0,(symbol * *)) = ag_rp_166(V(0,(symbol * *)), V(2,(int *)), V(5,(char * *))); break;
    case 166: V(0,(symbol * *)) = ag_rp_167(V(0,(symbol * *)), V(2,(int *))); break;
    case 167: V(0,(symbol * *)) = ag_rp_168(V(0,(symbol * *)), V(3,(CLIST * *))); break;
    case 168: V(0,(symbol * *)) = ag_rp_169(V(0,(symbol * *)), V(2,(char * *))); break;
    case 169: V(0,(symbol * *)) = ag_rp_170(V(0,(link * *)), V(1,(symbol * *))); break;
    case 170: V(0,(link * *)) = ag_rp_171(); break;
    case 171: V(0,(link * *)) = ag_rp_172(); break;
    case 172: V(0,(link * *)) = ag_rp_173(); break;
    case 173: V(0,(link * *)) = ag_rp_174(); break;
    case 174: V(0,(link * *)) = ag_rp_175(); break;
    case 175: V(0,(symbol * *)) = ag_rp_176(V(0,(symbol * *))); break;
    case 176: V(0,(symbol * *)) = ag_rp_177(V(0,(symbol * *)), V(2,(symbol * *))); break;
    case 177: V(0,(symbol * *)) = ag_rp_178(V(0,(symbol * *))); break;
    case 178: V(0,(symbol * *)) = ag_rp_179(V(0,(symbol * *)), V(2,(int *))); break;
    case 179: V(0,(symbol * *)) = ag_rp_180(V(0,(symbol * *)), V(3,(int *))); break;
    case 180: V(0,(CLIST * *)) = ag_rp_181(V(0,(int *))); break;
    case 181: V(0,(CLIST * *)) = ag_rp_182(V(0,(CLIST * *)), V(1,(int *))); break;
    case 182: V(0,(int *)) = ag_rp_183(V(0,(int *))); break;
    case 183: V(0,(int *)) = ag_rp_184(V(0,(int *))); break;
    case 184: V(0,(int *)) = ag_rp_185(V(0,(int *)), V(2,(int *))); break;
    case 185: V(0,(int *)) = ag_rp_186(); break;
    case 186: V(0,(int *)) = ag_rp_187(V(0,(int *))); break;
    case 187: V(0,(int *)) = ag_rp_188(); break;
    case 188: V(0,(symbol * *)) = ag_rp_189(V(0,(symbol * *)), V(2,(symbol * *))); break;
    case 189: V(0,(symbol * *)) = ag_rp_190(V(0,(symbol * *)), V(1,(symbol * *))); break;
    case 190: V(0,(symbol * *)) = ag_rp_191(V(0,(token *))); break;
    case 191: V(0,(symbol * *)) = ag_rp_192(V(0,(symbol * *))); break;
    case 192: V(0,(symbol * *)) = ag_rp_193(V(0,(symbol * *)), V(2,(symbol * *))); break;
    case 193: V(0,(symbol * *)) = ag_rp_194(V(0,(symbol * *))); break;
    case 194: V(0,(symbol * *)) = ag_rp_195(V(0,(symbol * *)), V(2,(int *))); break;
    case 195: V(0,(symbol * *)) = ag_rp_196(V(1,(symbol * *))); break;
    case 196: V(0,(symbol * *)) = ag_rp_197(V(0,(symbol * *))); break;
    case 197: V(0,(symbol * *)) = ag_rp_198(V(0,(symbol * *)), V(2,(symbol * *))); break;
    case 198: V(0,(symbol * *)) = ag_rp_199(V(0,(symbol * *)), V(2,(symbol * *))); break;
    case 199: ag_rp_200(); break;
    case 200: ag_rp_201(); break;
    case 201: V(0,(symbol * *)) = ag_rp_202(V(0,(symbol * *))); break;
    case 202: V(0,(symbol * *)) = ag_rp_203(V(1,(symbol * *))); break;
    case 203: V(0,(symbol * *)) = ag_rp_204(V(0,(symbol * *))); break;
    case 204: V(0,(symbol * *)) = ag_rp_205(V(0,(symbol * *)), V(2,(symbol * *))); break;
    case 205: V(0,(symbol * *)) = ag_rp_206(V(0,(symbol * *)), V(2,(int *))); break;
    case 206: V(0,(symbol * *)) = ag_rp_207(V(0,(symbol * *)), V(2,(char * *))); break;
    case 207: V(0,(char * *)) = ag_rp_208(V(0,(token *))); break;
    case 208: V(0,(symbol * *)) = ag_rp_209(V(0,(token *))); break;
    case 209: V(0,(NODE * *)) = ag_rp_210(V(0,(token *))); break;
    case 210: V(0,(NODE * *)) = ag_rp_211(V(0,(token *))); break;
    case 211: V(0,(int *)) = ag_rp_212(V(0,(token *))); break;
    case 212: V(0,(int *)) = ag_rp_213(V(0,(token *))); break;
    case 213: V(0,(int *)) = ag_rp_214(V(0,(token *))); break;
  }
}

#define TOKEN_NAMES action_token_names
const char *const action_token_names[170] = {
  "action",
  "action",
  "FundDecl",
  "RecIdentList",
  "FundIdentList",
  "ArrIdentList",
  "PtrIdentList",
  "SystemDecls",
  "FUNCdecl",
  "PROCdecl",
  "modules",
  "eof",
  "module",
  "MODULE",
  "ProgModules",
  "GlobalDecls",
  "Routines",
  "Routine",
  "PROCroutine",
  "FUNCroutine",
  "Statements",
  "ProcReturn",
  "PROC",
  "DeclIdent",
  "'('",
  "VarDecl",
  "')'",
  "ProcInit",
  "OptStmtList",
  "nothing",
  "'='",
  "Addr",
  "RETURN",
  "FuncReturn",
  "FundType",
  "FUNC",
  "BitExp",
  "Stmt",
  "SimpStmt",
  "StructStmt",
  "CodeBlock",
  "AssignStmt",
  "EXITStmt",
  "ProcCall",
  "Return",
  "PRETURN",
  "EXIT",
  "ProcIdent",
  "Arguments",
  "FuncCall",
  "FuncIdent",
  "PROCIDENT",
  "FUNCIDENT",
  "IFstmt",
  "WHILEloop",
  "FORloop",
  "DOloop",
  "DO",
  "OptUntil",
  "OD",
  "UNTIL",
  "CondExp",
  "WHILE",
  "FOR",
  "Ident",
  "TO",
  "OptStep",
  "STEP",
  "IFpart",
  "EndIf",
  "ELSEpart",
  "ELSEIFlist",
  "FI",
  "StartIf",
  "IF",
  "THEN",
  "ELSEIFpart",
  "ELSEIF",
  "ELSE",
  "MemContents",
  "ADDassign",
  "SUBassign",
  "MULassign",
  "DIVassign",
  "MODassign",
  "LSHassign",
  "RSHassign",
  "ANDassign",
  "ORassign",
  "XORassign",
  "OR",
  "AndExp",
  "AND",
  "RelExp",
  "'<'",
  "'>'",
  "'#'",
  "GTE",
  "LTE",
  "NEQ",
  "'&'",
  "ShiftExp",
  "'|'",
  "'%'",
  "LSH",
  "AddExp",
  "RSH",
  "'+'",
  "MulExp",
  "'-'",
  "'*'",
  "Urnary",
  "'/'",
  "MOD",
  "Primary",
  "MemRef",
  "StrConst",
  "Constant",
  "'['",
  "CompConstList",
  "']'",
  "CompConst",
  "BitExpList",
  "','",
  "'@'",
  "PtrRef",
  "ArrRef",
  "RecRef",
  "'^'",
  "RecordIdent",
  "'.'",
  "MembrIdent",
  "RECTYPE",
  "SystemDecl",
  "TYPEdecl",
  "DEFINEdecl",
  "ArrDecl",
  "PtrDecl",
  "RecDecl",
  "RecPtrDecl",
  "BaseVarDecl",
  "POINTER",
  "PtrIdent",
  "ARRAY",
  "ArrIdent",
  "ConstList",
  "BYTE",
  "CHAR",
  "INT",
  "CARD",
  "LONG",
  "FundIdent",
  "BaseCompConst",
  "IDENTIFIER",
  "RecType",
  "TYPEDEF",
  "RecIdent",
  "TYPE",
  "TypeIdentList",
  "TypeIdent",
  "LBracket",
  "FieldInit",
  "RBracket",
  "DEFINE",
  "DefIdentList",
  "DefIdent",
  "STRING",
  "HEX_CONSTANT",
  "CONSTANT",
  "CHAR_CONSTANT",

};

#ifndef MISSING_FORMAT
#define MISSING_FORMAT "Missing %s"
#endif
#ifndef UNEXPECTED_FORMAT
#define UNEXPECTED_FORMAT "Unexpected %s"
#endif
#ifndef UNNAMED_TOKEN
#define UNNAMED_TOKEN "input"
#endif


static void ag_diagnose(void) {
  int ag_snd = (PCB).sn;
  int ag_k = ag_sbt[ag_snd];

  if (*TOKEN_NAMES[ag_tstt[ag_k]] && ag_astt[ag_k + 1] == ag_action_8) {
    sprintf((PCB).ag_msg, MISSING_FORMAT, TOKEN_NAMES[ag_tstt[ag_k]]);
  }
  else if (ag_astt[ag_sbe[(PCB).sn]] == ag_action_8
          && (ag_k = (int) ag_sbe[(PCB).sn] + 1) == (int) ag_sbt[(PCB).sn+1] - 1
          && *TOKEN_NAMES[ag_tstt[ag_k]]) {
    sprintf((PCB).ag_msg, MISSING_FORMAT, TOKEN_NAMES[ag_tstt[ag_k]]);
  }
  else if ((PCB).token_number && *TOKEN_NAMES[(PCB).token_number]) {
    sprintf((PCB).ag_msg, UNEXPECTED_FORMAT, TOKEN_NAMES[(PCB).token_number]);
  }
  else if (isprint(((PCB).input_code)) && ((PCB).input_code) != '\\') {
    char buf[20];
    sprintf(buf, "\'%c\'", (char) ((PCB).input_code));
    sprintf((PCB).ag_msg, UNEXPECTED_FORMAT, buf);
  }
  else sprintf((PCB).ag_msg, UNEXPECTED_FORMAT, UNNAMED_TOKEN);
  (PCB).error_message = (PCB).ag_msg;


}
static int ag_action_1_r_proc(void);
static int ag_action_2_r_proc(void);
static int ag_action_3_r_proc(void);
static int ag_action_4_r_proc(void);
static int ag_action_1_s_proc(void);
static int ag_action_3_s_proc(void);
static int ag_action_1_proc(void);
static int ag_action_2_proc(void);
static int ag_action_3_proc(void);
static int ag_action_4_proc(void);
static int ag_action_5_proc(void);
static int ag_action_6_proc(void);
static int ag_action_7_proc(void);
static int ag_action_8_proc(void);
static int ag_action_9_proc(void);
static int ag_action_10_proc(void);
static int ag_action_11_proc(void);
static int ag_action_8_proc(void);


static int (*const  ag_r_procs_scan[])(void) = {
  ag_action_1_r_proc,
  ag_action_2_r_proc,
  ag_action_3_r_proc,
  ag_action_4_r_proc
};

static int (*const  ag_s_procs_scan[])(void) = {
  ag_action_1_s_proc,
  ag_action_2_r_proc,
  ag_action_3_s_proc,
  ag_action_4_r_proc
};

static int (*const  ag_gt_procs_scan[])(void) = {
  ag_action_1_proc,
  ag_action_2_proc,
  ag_action_3_proc,
  ag_action_4_proc,
  ag_action_5_proc,
  ag_action_6_proc,
  ag_action_7_proc,
  ag_action_8_proc,
  ag_action_9_proc,
  ag_action_10_proc,
  ag_action_11_proc,
  ag_action_8_proc
};


static int ag_action_10_proc(void) {
  (PCB).btsx = 0, (PCB).drt = -1;
  ag_track();
  return 0;
}

static int ag_action_11_proc(void) {
  (PCB).btsx = 0, (PCB).drt = -1;
  (*(token *) &(PCB).vs[(PCB).ssx]) = (PCB).input_value;
  (PCB).ssx--;
  ag_ra();
  (PCB).ssx++;
  ag_track();
  return 0;
}

static int ag_action_3_r_proc(void) {
  int ag_sd = ag_fl[(PCB).ag_ap] - 1;
  if (ag_sd) (PCB).sn = (PCB).ss[(PCB).ssx -= ag_sd];
  (PCB).btsx = 0, (PCB).drt = -1;
  (PCB).reduction_token = (action_token_type) ag_ptt[(PCB).ag_ap];
  ag_ra();
  return (PCB).exit_flag == AG_RUNNING_CODE;
}

static int ag_action_3_s_proc(void) {
  int ag_sd = ag_fl[(PCB).ag_ap] - 1;
  if (ag_sd) (PCB).sn = (PCB).ss[(PCB).ssx -= ag_sd];
  (PCB).btsx = 0, (PCB).drt = -1;
  (PCB).reduction_token = (action_token_type) ag_ptt[(PCB).ag_ap];
  ag_ra();
  return (PCB).exit_flag == AG_RUNNING_CODE;
}

static int ag_action_4_r_proc(void) {
  int ag_sd = ag_fl[(PCB).ag_ap] - 1;
  if (ag_sd) (PCB).sn = (PCB).ss[(PCB).ssx -= ag_sd];
  (PCB).reduction_token = (action_token_type) ag_ptt[(PCB).ag_ap];
  return 1;
}

static int ag_action_2_proc(void) {
  (PCB).btsx = 0, (PCB).drt = -1;
  if ((PCB).ssx >= 128) {
    (PCB).exit_flag = AG_STACK_ERROR_CODE;
    PARSER_STACK_OVERFLOW;
  }
  (*(token *) &(PCB).vs[(PCB).ssx]) = (PCB).input_value;
  GET_CONTEXT;
  (PCB).ss[(PCB).ssx] = (PCB).sn;
  (PCB).ssx++;
  (PCB).sn = (PCB).ag_ap;
  ag_track();
  return 0;
}

static int ag_action_9_proc(void) {
  if ((PCB).drt == -1) {
    (PCB).drt=(PCB).token_number;
    (PCB).dssx=(PCB).ssx;
    (PCB).dsn=(PCB).sn;
  }
  ag_prot();
  GET_CONTEXT;
  (PCB).ss[(PCB).ssx] = (PCB).sn;
  (PCB).ssx++;
  (PCB).sn = (PCB).ag_ap;
  return (PCB).exit_flag == AG_RUNNING_CODE;
}

static int ag_action_2_r_proc(void) {
  (PCB).ssx++;
  (PCB).sn = (PCB).ag_ap;
  return 0;
}

static int ag_action_7_proc(void) {
  --(PCB).ssx;
  (PCB).exit_flag = AG_SUCCESS_CODE;
  return 0;
}

static int ag_action_1_proc(void) {
  (PCB).exit_flag = AG_SUCCESS_CODE;
  ag_track();
  return 0;
}

static int ag_action_1_r_proc(void) {
  (PCB).exit_flag = AG_SUCCESS_CODE;
  return 0;
}

static int ag_action_1_s_proc(void) {
  (PCB).exit_flag = AG_SUCCESS_CODE;
  return 0;
}

static int ag_action_4_proc(void) {
  int ag_sd = ag_fl[(PCB).ag_ap] - 1;
  (PCB).reduction_token = (action_token_type) ag_ptt[(PCB).ag_ap];
  (PCB).btsx = 0, (PCB).drt = -1;
  (*(token *) &(PCB).vs[(PCB).ssx]) = (PCB).input_value;
  if (ag_sd) (PCB).sn = (PCB).ss[(PCB).ssx -= ag_sd];
  else GET_CONTEXT;
  (PCB).ss[(PCB).ssx] = (PCB).sn;
  ag_track();
  while ((PCB).exit_flag == AG_RUNNING_CODE) {
    unsigned ag_t1 = ag_sbe[(PCB).sn] + 1;
    unsigned ag_t2 = ag_sbt[(PCB).sn+1] - 1;
    do {
      unsigned ag_tx = (ag_t1 + ag_t2)/2;
      if (ag_tstt[ag_tx] < (unsigned char)(PCB).reduction_token) ag_t1 = ag_tx + 1;
      else ag_t2 = ag_tx;
    } while (ag_t1 < ag_t2);
    (PCB).ag_ap = ag_pstt[ag_t1];
    if ((ag_s_procs_scan[ag_astt[ag_t1]])() == 0) break;
  }
  return 0;
}

static int ag_action_3_proc(void) {
  int ag_sd = ag_fl[(PCB).ag_ap] - 1;
  (PCB).btsx = 0, (PCB).drt = -1;
  (*(token *) &(PCB).vs[(PCB).ssx]) = (PCB).input_value;
  if (ag_sd) (PCB).sn = (PCB).ss[(PCB).ssx -= ag_sd];
  else GET_CONTEXT;
  (PCB).ss[(PCB).ssx] = (PCB).sn;
  ag_track();
  (PCB).reduction_token = (action_token_type) ag_ptt[(PCB).ag_ap];
  ag_ra();
  while ((PCB).exit_flag == AG_RUNNING_CODE) {
    unsigned ag_t1 = ag_sbe[(PCB).sn] + 1;
    unsigned ag_t2 = ag_sbt[(PCB).sn+1] - 1;
    do {
      unsigned ag_tx = (ag_t1 + ag_t2)/2;
      if (ag_tstt[ag_tx] < (unsigned char)(PCB).reduction_token) ag_t1 = ag_tx + 1;
      else ag_t2 = ag_tx;
    } while (ag_t1 < ag_t2);
    (PCB).ag_ap = ag_pstt[ag_t1];
    if ((ag_s_procs_scan[ag_astt[ag_t1]])() == 0) break;
  }
  return 0;
}

static int ag_action_8_proc(void) {
  ag_undo();
  (PCB).exit_flag = AG_SYNTAX_ERROR_CODE;
  ag_diagnose();
  SYNTAX_ERROR;
  ag_track();
  return (PCB).exit_flag == AG_RUNNING_CODE;
}

static int ag_action_5_proc(void) {
  int ag_sd = ag_fl[(PCB).ag_ap];
  (PCB).btsx = 0, (PCB).drt = -1;
  if (ag_sd) (PCB).sn = (PCB).ss[(PCB).ssx -= ag_sd];
  else {
    GET_CONTEXT;
    (PCB).ss[(PCB).ssx] = (PCB).sn;
  }
  (PCB).reduction_token = (action_token_type) ag_ptt[(PCB).ag_ap];
  ag_ra();
  while ((PCB).exit_flag == AG_RUNNING_CODE) {
    unsigned ag_t1 = ag_sbe[(PCB).sn] + 1;
    unsigned ag_t2 = ag_sbt[(PCB).sn+1] - 1;
    do {
      unsigned ag_tx = (ag_t1 + ag_t2)/2;
      if (ag_tstt[ag_tx] < (unsigned char)(PCB).reduction_token) ag_t1 = ag_tx + 1;
      else ag_t2 = ag_tx;
    } while (ag_t1 < ag_t2);
    (PCB).ag_ap = ag_pstt[ag_t1];
    if ((ag_r_procs_scan[ag_astt[ag_t1]])() == 0) break;
  }
  return (PCB).exit_flag == AG_RUNNING_CODE;
}

static int ag_action_6_proc(void) {
  int ag_sd = ag_fl[(PCB).ag_ap];
  (PCB).reduction_token = (action_token_type) ag_ptt[(PCB).ag_ap];
  if ((PCB).drt == -1) {
    (PCB).drt=(PCB).token_number;
    (PCB).dssx=(PCB).ssx;
    (PCB).dsn=(PCB).sn;
  }
  if (ag_sd) {
    (PCB).sn = (PCB).ss[(PCB).ssx -= ag_sd];
  }
  else {
    ag_prot();
    (PCB).vs[(PCB).ssx] = ag_null_value;
    GET_CONTEXT;
    (PCB).ss[(PCB).ssx] = (PCB).sn;
  }
  while ((PCB).exit_flag == AG_RUNNING_CODE) {
    unsigned ag_t1 = ag_sbe[(PCB).sn] + 1;
    unsigned ag_t2 = ag_sbt[(PCB).sn+1] - 1;
    do {
      unsigned ag_tx = (ag_t1 + ag_t2)/2;
      if (ag_tstt[ag_tx] < (unsigned char)(PCB).reduction_token) ag_t1 = ag_tx + 1;
      else ag_t2 = ag_tx;
    } while (ag_t1 < ag_t2);
    (PCB).ag_ap = ag_pstt[ag_t1];
    if ((ag_r_procs_scan[ag_astt[ag_t1]])() == 0) break;
  }
  return (PCB).exit_flag == AG_RUNNING_CODE;
}


void init_action(void) {
  unsigned ag_t1;
  ag_t1 = 0;
  (PCB).ss[0] = (PCB).sn = (PCB).ssx = 0;
  (PCB).exit_flag = AG_RUNNING_CODE;
  (PCB).line = FIRST_LINE;
  (PCB).column = FIRST_COLUMN;
  (PCB).btsx = 0, (PCB).drt = -1;
  while (ag_tstt[ag_t1] == 0) {
    (PCB).ag_ap = ag_pstt[ag_t1];
    (ag_gt_procs_scan[ag_astt[ag_t1]])();
    ag_t1 = ag_sbt[(PCB).sn];
  }
}

void action(void) {
  (PCB).token_number = (action_token_type) AG_TCV((PCB).input_code);
  while (1) {
    unsigned ag_t1 = ag_sbt[(PCB).sn];
    unsigned ag_t2 = ag_sbe[(PCB).sn] - 1;
    do {
      unsigned ag_tx = (ag_t1 + ag_t2)/2;
      if (ag_tstt[ag_tx] > (unsigned char)(PCB).token_number)
        ag_t1 = ag_tx + 1;
      else ag_t2 = ag_tx;
    } while (ag_t1 < ag_t2);
    if (ag_tstt[ag_t1] != (unsigned char)(PCB).token_number)
      ag_t1 = ag_sbe[(PCB).sn];
    (PCB).ag_ap = ag_pstt[ag_t1];
    if ((ag_gt_procs_scan[ag_astt[ag_t1]])() == 0) break;
  }
}


