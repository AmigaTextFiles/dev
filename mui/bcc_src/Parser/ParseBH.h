#include "ParseFile.h"
#include "ClassDef.h"

class ParseBH: public ParseFile {

	void IfDefBeg( void );
	void IfDefEnd( void );

	short switches;

public:

	ClassDef *classdef;

	short Start( void );
	short DoClass( void );

	
};
