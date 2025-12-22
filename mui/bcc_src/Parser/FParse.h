#ifndef FPARSE_H
#define FPARSE_H

#include <string.h>
#include "Str.h"

#define NON 0
#define SEP	1
#define ALN	2
#define BRC	4
#define PNT 8
#define OPR 16
#define CNT 32

struct tpos {
	char *Tok;
	short TokLen;
	short TokType;

	long LineN;
	short MBracket, CBracket, SBracket;
	
	tpos( void );
	tpos &operator=( tpos &tp );
	void reset( void );
	short used( void ) { return Tok ? 1 : 0; }
};
	
class FParse : public tpos {

	char *Data;
	long Len;

	void ClearData( void ) { Data = 0; Len = 0; }

public:

	String Name;
	short ErrorBuf;
	struct tpos Prev, Survey, SurveyPrev;

	FParse() { ClearData(); }
	~FParse();
	short Load( char *name );
	short Next( void );
	short OK( void ) { return Len ? 1 : 0; }
	void Error( short num );
	
	void StartSurvey();
	void StopSurvey();
	void Reset( void ) { Tok = Data; TokLen = 0; }
	
	virtual char **ErrorStrings( void );
	
};

#endif
