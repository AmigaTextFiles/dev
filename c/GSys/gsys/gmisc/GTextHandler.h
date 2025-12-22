
#ifndef GTEXTHANDLER_H
#define GTEXTHANDLER_H

#include "gsystem/GBuffer.h"
//#include "gsystem/GBufferMet.h"

/*
 * Char-Types 
 * 
 */

#define GTEXT_NODEF	0		// could be used as an "illegal" i guess..
#define GTEXT_SPACE	1		// fine for splitting words
#define GTEXT_TAB	1<<1		// see SPACE
#define GTEXT_NEWLINE	1<<2		// fine for splitting lines
#define GTEXT_BREAK	1<<3		// it will always stop for a break(point) (not true!)
#define GTEXT_LETTER	1<<5
#define GTEXT_NUMBER	1<<6
#define GTEXT_EOT	1<<7		// will force the program not to go any further
#define	GTEXT_USER1	1<<8
#define	GTEXT_USER2	1<<9
#define	GTEXT_USER3	1<<10
#define	GTEXT_USER4	1<<11
#define	GTEXT_USER5	1<<12
#define	GTEXT_USER6	1<<13
#define	GTEXT_USER7	1<<14
#define	GTEXT_USER8	1<<15

/*
 * Cpy & Jump-modes (used for Cpy & Jump)
 *
 */

#define GTEXT_EQ	0	// while EQ copy/jump	// flag = chartype
#define GTEXT_ALL	1	// while ALL copy/jump	// (flag & chartype) = flag
#define GTEXT_ANY	2	// while ANY copy/jump	// (flag & chartype) > 0
#define GTEXT_NOTEQ	5	// while NOTEQ copy/jump (!EQ)
#define GTEXT_NOTALL	6	// while NOTALL cpy/jump (!ALL)
#define GTEXT_NONE	7	// while NONE copy/jump (!ANY)

/*
 * Set-modes
 *
 */

#define GTEXT_SET_SET	1
#define GTEXT_SET_OR	2
#define GTEXT_SET_AND	3
#define GTEXT_SET_CLR	4

typedef struct	// fra og med, til og med
{
	GWORD From, To;
} GCharArea;

class	GTextHandler : public GBuffer
{
protected:
	GTextHandler() { memset((GAPTR)this, 0, sizeof(GTextHandler));};
public:
	GTextHandler(GSTRPTR filename, GUWORD start, GUWORD len);	// if start=-1, it doesn't care about it
	GTextHandler(GSTRPTR string);
	~GTextHandler();

	BOOL InitGTextHandler(GSTRPTR filename, GUWORD start, GUWORD len, GSTRPTR objtype);
	BOOL InitGTextHandler(GSTRPTR string, GSTRPTR objtype);

	BOOL RefreshTextPtr();

	void InitTypes();		// Should be used (Sets 0x20 as space etc.);
	void ClearTypes();		// Clears 

	void	SetUCaseIsLCase(BOOL b);
	BOOL	GetUCaseIsLCase();
	void	SetGetOnlyLowerCase(BOOL b) {};
	BOOL	GetGetOnlyLowerCase() { return FALSE; };

	void	SetCharDef(GSTRPTR str, GUSHORT flags, GUSHORT setmode);	// End Of Text
	void	SetCharDef(char x, GUSHORT flags, GUSHORT setmode);
	void	SetCharDef(GCharArea *gchararea, GUSHORT flags, GUSHORT setmode);

	BOOL	IsCharType(GUSHORT flags, GUSHORT demand);
	GUSHORT	GetCharDef();
	GUBYTE	GetChar();

	BOOL	CmpIncidents(GSTRPTR incidents);

	GWORD	CpyUntilNextIncident(GSTRPTR dest, GSTRPTR incidents);
	GWORD	CpyReqType(GSTRPTR dest, GUSHORT flags, GUSHORT demand);

	GWORD	GetJumped() { return Jumped; };

	BOOL 	JumpChars(GWORD x);	// relative
	BOOL	JumpLines(GWORD x);	// relative
	BOOL	JumpLine(GWORD x);	// not relative
	BOOL	JumpChar(GWORD x);	// not relative

	BOOL	JumpNextIncident(GSTRPTR incidents);	// "case1|case2|..|caseN"
	BOOL	JumpNextReqType(GUSHORT flags, GUSHORT demand);
	BOOL	JumpNextAppearance(GSTRPTR str);
	BOOL	JumpNextChar(char c);

	BOOL	CmpChars(char a, char b);

protected:
	BOOL	UCaseIsLCase;
	GWORD	Jumped;
	GSTRPTR	TextStart;
	GSTRPTR	TextCurrent;
	GUSHORT	CharDefs[256];
};

#endif /* GTEXTHANDLER_H */

