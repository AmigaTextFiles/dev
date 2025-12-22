
/* Author Anders Kjeldsen */

#ifndef GHTMLREADER_CPP
#define GHTMLREADER_CPP

#include "gmisc/GHTMLReader.h"
#include "gmisc/GTextHandler.cpp"

GHTMLReader::GHTMLReader(GSTRPTR string)
{
	memset((void *)this, 0, sizeof (class GHTMLReader) );

//	GTextHandler(string);
	if ( InitGTextHandler(string, "GHTMLReader") )
	{
		UCaseIsLCase = FALSE;

		InitTypes();
		SetCharDef("<>=", GTEXT_BREAK, GTEXT_SET_OR);
		SetCharDef("0123456789-/", GTEXT_LETTER, GTEXT_SET_OR);
	}
}

GHTMLReader::GHTMLReader(GSTRPTR filename, GWORD start, GWORD len)
{
	memset((void *)this, 0, sizeof (class GHTMLReader) );
//	GTextHandler(string);
	if ( InitGTextHandler(filename, start, len, "GHTMLReader") )
	{
		UCaseIsLCase = FALSE;

		InitTypes();
		SetCharDef("<>=", GTEXT_BREAK, GTEXT_SET_OR);
		SetCharDef("0123456789-/", GTEXT_LETTER, GTEXT_SET_OR);
	}
}

/*

ParseAttr(STRPTR name, STRPTR value)
parses the attribute-name in the string name,
and the attribute-value in the strinv value, 
if there is no value, the string is immediately
null-terminated.

*/

BOOL GHTMLReader::ParseAttr(GSTRPTR name, GSTRPTR value)
{
	GSTRPTR old = TextCurrent;
	SetCharDef('=', GTEXT_BREAK, GTEXT_SET_SET);
	SetCharDef('"', GTEXT_USER1, GTEXT_SET_SET);

// name
	if ( JumpNextReqType(GTEXT_SPACE | GTEXT_TAB | GTEXT_NEWLINE, GTEXT_NONE) )
	{
		if ( GetChar() == '>')
		{
			TextCurrent++;
			return FALSE;	// no more attributes
		}
		else
		{
			CpyReqType(name, GTEXT_LETTER | GTEXT_NUMBER, GTEXT_ANY);
			JumpNextReqType(GTEXT_LETTER | GTEXT_NUMBER, GTEXT_NONE);
		}
// value
		if ( JumpNextReqType(GTEXT_SPACE | GTEXT_TAB | GTEXT_NEWLINE, GTEXT_NONE) )
		{
			if ( GetChar() == '=' )
			{
				TextCurrent++;
				if ( JumpNextReqType(GTEXT_SPACE | GTEXT_TAB | GTEXT_NEWLINE, GTEXT_NONE) )
				{
					if ( GetChar() == '"' )
					{
						TextCurrent++;
						CpyReqType(value, GTEXT_USER1, GTEXT_NONE);
						TextCurrent++;
						return TRUE;
					}
					else if ( GetCharDef() == GTEXT_BREAK )
					{
						TextCurrent++;
//						WriteLog("Unexpected Break\n");
						return FALSE;
					}
					else
					{
						CpyReqType(value, GTEXT_SPACE | GTEXT_TAB | GTEXT_NEWLINE | GTEXT_BREAK, GTEXT_NONE);
						// GTEXT_LETTER | GTEXT_NUMBER
						return TRUE;
					}
				}
				else
				{
					*value=0;
//					WriteLog("Unexpected end of file!\n");
					return FALSE;
				}
			}
			else
			{
				*value=0;
//				WriteLog("An attribute not on the form =x, and the char is %c\n", *TextCurrent);
				return FALSE;
			}
		}
	}
	else
	{
//		WriteLog("End of text or similar\n");
		return NULL;
	}

	SetCharDef('"', GTEXT_NODEF, GTEXT_SET_SET);
	SetCharDef('=', GTEXT_NODEF, GTEXT_SET_SET);
	return TRUE;
}

BOOL GHTMLReader::ParseTag(GSTRPTR dest)
{
	SetCharDef('=', GTEXT_BREAK, GTEXT_SET_SET);
	JumpChars(1);
	if ( GetCharDef() != GTEXT_BREAK)
	{
		CpyReqType(dest, GTEXT_SPACE | GTEXT_TAB | GTEXT_NEWLINE | GTEXT_BREAK, GTEXT_NONE);
		if ( JumpNextReqType(GTEXT_SPACE | GTEXT_TAB | GTEXT_NEWLINE | GTEXT_BREAK, GTEXT_ANY) )
		{		
			return TRUE;
		}
		else return FALSE;
	}
	else return FALSE;
}

BOOL GHTMLReader::ParseUntilNextTag(GSTRPTR dest)
{
	SetCharDef('=', GTEXT_NODEF, GTEXT_SET_SET);
	CpyReqType(dest, GTEXT_BREAK, GTEXT_NONE);
	if ( JumpNextReqType(GTEXT_BREAK, GTEXT_ANY) ) return TRUE;
	else return FALSE;

}

BOOL GHTMLReader::JumpNextTag()
{
	SetCharDef('=', GTEXT_NODEF, GTEXT_SET_SET);

	while (	JumpNextReqType(GTEXT_BREAK, GTEXT_ANY) )
	{
		if ( GetChar() == '<' )
		{
			return TRUE;
		}
		if ( GetChar() == '>' )
		{
			JumpChars(1);
//			WriteLog("Unexpected closing tag found! This can happen if an attribute has only one ""\n");
			return TRUE;
		}
		JumpChars(1);
	}
	return FALSE;
}

#endif /* GHTMLREADER_CPP */