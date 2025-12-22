/*-----------------------------------------------------------------**
**                                                                 **
**                        NODE ID's                                **
**                                                                 **
**  ID's of nodes for Abstract Syntax Tree for C Compiler          **
**                                                                 **
**-----------------------------------------------------------------*/

#ifndef NODEIDS__H
#define NODEIDS__H

enum {
	NODEID_EQUALS,		//0
	NODEID_MULEQ,       //1
	NODEID_DIVEQ,		//2
	NODEID_MODEQ,		//3
	NODEID_ADDEQ,		//4
	NODEID_SUBEQ,       //5
	NODEID_ANDEQ,		//6
	NODEID_OREQ,		//7
	NODEID_XOREQ,		//8
	NODEID_LSHEQ,		//9
	NODEID_RSHEQ,		//10
	NODEID_OR,			//11
	NODEID_AND,			//13
	NODEID_BITOR,		//13
	NODEID_BITXOR,		//14
	NODEID_BITAND,		//15
	NODEID_EQ,			//16
	NODEID_NE,			//17
	NODEID_LT,			//18
	NODEID_GT,			//19
	NODEID_LTE,			//20
	NODEID_GTE,			//21
	NODEID_LSH,			//22
	NODEID_RSH,			//23
	NODEID_ADD,			//24
	NODEID_SUB,			//25
	NODEID_MUL,			//26
	NODEID_DIV,			//27
	NODEID_MOD,			//28
	NODEID_COMPLEMENT,	//29
	NODEID_ADDRESSOF,	//30
	NODEID_CONTENTSOF,	//31
	NODEID_NEGATIVE,	//32
	NODEID_CODEBLOCK,	//33
	NODEID_MEMBER,		//34
	NODEID_FUNCCALL,	//35
	NODEID_ARGUMENTS,	//36
	NODEID_CONSTANT,	//37
	NODEID_IDENT,		//38
	NODEID_STRING,		//39
	NODEID_FOR,			//40
	NODEID_DOLOOP,		//41
	NODEID_WHILE,		//42
	NODEID_IF,			//43
	NODEID_ELSEIF,		//44
	NODEID_ELSE,		//45
	NODEID_RETURN,		//46
	NODEID_UNTIL,		//47
	NODEID_EXIT,		//48
	NODEID_STEP,		//49
	NODEID_PROC,		//50
	NODEID_FUNC,		//51
	NODEID_IFSTMT,		//52
	NODEID_FORSTART,	//53
	NODEID_FORTO,		//54
	NODEID_ARRAYREF	,	//55
	NODEID_PROCCALL,	//56
	NODEID_PROCIDENT,	//57
	NODEID_PROCLOCALS,	//58
	NODEID_FORDOLOOP,	//59
	NODEID_WHILEDOLOOP	//60
};

#endif	//NODEIDS__H
