
#ifndef GERROR_H
#define GERROR_H

//#include "gsystem/GObject.h"
//#include "gsystem/GObject.cpp"

class GError
{
public:
	GError(GSTRPTR id, GSTRPTR errormsg);
	~GError();

	BOOL ChangeMsg(GSTRPTR errormsg);
	void PrintError();
	void PrintErrors();

	GSTRPTR GetID() { return ID; };
	GSTRPTR GetMsg() { return Msg; };

	BOOL AttachError(GError *next);
	BOOL DetachError();

	GError *GetNextError() { return NextError; };
	GError *GetPrevError() { return PrevError; };
protected:
//	void SetNextError(GError *next) { NextError = next; };
//	void SetPrevError(GError *prev) { PrevError = prev; };
	GError *PrevError;
	GError *NextError;
private:
	GSTRPTR ID;
	GSTRPTR Msg;	
};

#endif /* GERROR_H */

