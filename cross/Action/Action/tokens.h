#ifndef TOKENS__H
#define TOKENS__H

	enum {
		eof	=	0,
		AND	=	256,
		ANDassign,			// =&
		OR,					// OR
		ORassign,			// =|
		XORassign,			// =%
		ADDassign,			// =+
		SUBassign,			// =-
		MULassign,			// =*
		DIVassign,			// =/
		MODassign,			// =MOD
		LSHassign,			// ==RSH
		RSHassign,			// ==LSH
		EQUAL,				// ==
		NEQ,			// <>
		GTE,			// >=
		LTE,			// <=
		STRING,
		ARRAY,
		POINTER,
		BYTE,
		CARD,
		INT,
		TYPE,
		TYPEDEF,
		IDENTIFIER,
		CONSTANT,
		DO,
		OD,
		IF,
		ELSEIF,
		ELSE,
		FI,
		FOR,
		TO,
		STEP,
		WHILE,
		UNTIL,
		EXIT,
		PROC,
		FUNC,
		RETURN,
		BEGIN,
		END,
		MODULE,
		LSH,
		RSH,
		MOD,
		THEN,
		CHAR,
		HEX_CONSTANT,
		CHAR_CONSTANT,
		DEFINE,
		XOR,
		LONG,
		PROCIDENT,
		FUNCIDENT,
		RECTYPE,
		PRETURN,
		INCLUDE
	}
;

typedef struct {
	int TokenID;
	char *yytext;
}token;

#endif