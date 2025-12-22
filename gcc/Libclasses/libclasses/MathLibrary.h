
#ifndef _MATHLIBRARY_H
#define _MATHLIBRARY_H

#include <exec/types.h>

class MathLibrary
{
public:
	MathLibrary();
	~MathLibrary();

	static class MathLibrary Default;

	LONG SPFix(FLOAT parm);
	FLOAT SPFlt(LONG integer);
	LONG SPCmp(FLOAT leftParm, FLOAT rightParm);
	LONG SPTst(FLOAT parm);
	FLOAT SPAbs(FLOAT parm);
	FLOAT SPNeg(FLOAT parm);
	FLOAT SPAdd(FLOAT leftParm, FLOAT rightParm);
	FLOAT SPSub(FLOAT leftParm, FLOAT rightParm);
	FLOAT SPMul(FLOAT leftParm, FLOAT rightParm);
	FLOAT SPDiv(FLOAT leftParm, FLOAT rightParm);
	FLOAT SPFloor(FLOAT parm);
	FLOAT SPCeil(FLOAT parm);

private:
	struct Library *Base;
};

MathLibrary MathLibrary::Default;

#endif

