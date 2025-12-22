
#ifndef _MATHIEEESINGTRANSLIBRARY_H
#define _MATHIEEESINGTRANSLIBRARY_H

#include <exec/types.h>

class MathIeeeSingTransLibrary
{
public:
	MathIeeeSingTransLibrary();
	~MathIeeeSingTransLibrary();

	static class MathIeeeSingTransLibrary Default;

	FLOAT IEEESPAtan(FLOAT parm);
	FLOAT IEEESPSin(FLOAT parm);
	FLOAT IEEESPCos(FLOAT parm);
	FLOAT IEEESPTan(FLOAT parm);
	FLOAT IEEESPSincos(FLOAT * cosptr, FLOAT parm);
	FLOAT IEEESPSinh(FLOAT parm);
	FLOAT IEEESPCosh(FLOAT parm);
	FLOAT IEEESPTanh(FLOAT parm);
	FLOAT IEEESPExp(FLOAT parm);
	FLOAT IEEESPLog(FLOAT parm);
	FLOAT IEEESPPow(FLOAT exp, FLOAT arg);
	FLOAT IEEESPSqrt(FLOAT parm);
	FLOAT IEEESPTieee(FLOAT parm);
	FLOAT IEEESPFieee(FLOAT parm);
	FLOAT IEEESPAsin(FLOAT parm);
	FLOAT IEEESPAcos(FLOAT parm);
	FLOAT IEEESPLog10(FLOAT parm);

private:
	struct Library *Base;
};

MathIeeeSingTransLibrary MathIeeeSingTransLibrary::Default;

#endif

