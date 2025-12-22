
#ifndef _MATHTRANSLIBRARY_H
#define _MATHTRANSLIBRARY_H

#include <exec/types.h>

class MathTransLibrary
{
public:
	MathTransLibrary();
	~MathTransLibrary();

	static class MathTransLibrary Default;

	FLOAT SPAtan(FLOAT parm);
	FLOAT SPSin(FLOAT parm);
	FLOAT SPCos(FLOAT parm);
	FLOAT SPTan(FLOAT parm);
	FLOAT SPSincos(FLOAT * cosResult, FLOAT parm);
	FLOAT SPSinh(FLOAT parm);
	FLOAT SPCosh(FLOAT parm);
	FLOAT SPTanh(FLOAT parm);
	FLOAT SPExp(FLOAT parm);
	FLOAT SPLog(FLOAT parm);
	FLOAT SPPow(FLOAT power, FLOAT arg);
	FLOAT SPSqrt(FLOAT parm);
	FLOAT SPTieee(FLOAT parm);
	FLOAT SPFieee(FLOAT parm);
	FLOAT SPAsin(FLOAT parm);
	FLOAT SPAcos(FLOAT parm);
	FLOAT SPLog10(FLOAT parm);

private:
	struct Library *Base;
};

MathTransLibrary MathTransLibrary::Default;

#endif

