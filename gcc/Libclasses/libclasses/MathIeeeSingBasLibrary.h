
#ifndef _MATHIEEESINGBASLIBRARY_H
#define _MATHIEEESINGBASLIBRARY_H

#include <exec/types.h>

class MathIeeeSingBasLibrary
{
public:
	MathIeeeSingBasLibrary();
	~MathIeeeSingBasLibrary();

	static class MathIeeeSingBasLibrary Default;

	LONG IEEESPFix(FLOAT parm);
	FLOAT IEEESPFlt(LONG integer);
	LONG IEEESPCmp(FLOAT leftParm, FLOAT rightParm);
	LONG IEEESPTst(FLOAT parm);
	FLOAT IEEESPAbs(FLOAT parm);
	FLOAT IEEESPNeg(FLOAT parm);
	FLOAT IEEESPAdd(FLOAT leftParm, FLOAT rightParm);
	FLOAT IEEESPSub(FLOAT leftParm, FLOAT rightParm);
	FLOAT IEEESPMul(FLOAT leftParm, FLOAT rightParm);
	FLOAT IEEESPDiv(FLOAT dividend, FLOAT divisor);
	FLOAT IEEESPFloor(FLOAT parm);
	FLOAT IEEESPCeil(FLOAT parm);

private:
	struct Library *Base;
};

MathIeeeSingBasLibrary MathIeeeSingBasLibrary::Default;

#endif

