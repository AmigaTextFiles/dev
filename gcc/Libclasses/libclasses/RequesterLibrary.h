
#ifndef _REQUESTERLIBRARY_H
#define _REQUESTERLIBRARY_H

#include <exec/types.h>
#include <intuition/classes.h>

class RequesterLibrary
{
public:
	RequesterLibrary();
	~RequesterLibrary();

	static class RequesterLibrary Default;

	Class * REQUESTER_GetClass();

private:
	struct Library *Base;
};

RequesterLibrary RequesterLibrary::Default;

#endif

