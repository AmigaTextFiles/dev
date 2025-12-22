
#ifndef GHTMLREADER_H
#define GHTMLREADER_H

#include "gmisc/GTextHandler.h"

class	GHTMLReader : public GTextHandler
{
public:
	GHTMLReader();
	GHTMLReader(GSTRPTR filename, GWORD start, GWORD len);
	GHTMLReader(GSTRPTR string);	// string = html text
	~GHTMLReader() {};

	BOOL ParseAttr(GSTRPTR name, GSTRPTR value);
	BOOL ParseTag(GSTRPTR dest);
	BOOL ParseUntilNextTag(GSTRPTR dest);
	BOOL JumpNextTag();
//	STRPTR JumpEndOfTag();
//	STRPTR JumpNextAttr();
private:
//	GTextHandler *Text;
};

#endif /* GHTMLREADER_H */


