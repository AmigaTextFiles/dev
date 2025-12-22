
/* Author Anders Kjeldsen */

#ifndef GTEXTHANDLER_CPP
#define GTEXTHANDLER_CPP

#include "gmisc/GTextHandler.h"
#include "gsystem/GBuffer.cpp"


GTextHandler::GTextHandler(GSTRPTR string)
{
	memset((GAPTR)this, 0, sizeof(GTextHandler));
	int len;
	if (string)
	{
		len = strlen(string);

		if ( InitGBuffer(len+1, "GTextHandler") )	
		{
			strcpy((GSTRPTR)Buffer, string);
			
			UCaseIsLCase = FALSE;
			TextStart = (GSTRPTR)Buffer;
			TextCurrent = (GSTRPTR)Buffer;
		}
		else
		{
//			WriteLog("GTextHandler(string): Was not able to allocate string-buffer\n");
			TextStart = NULL;
			TextCurrent = NULL;			
		}
	}
	else
	{
//		WriteLog("GTextHandler(string): string == NULL\n");
		TextStart = NULL;
		TextCurrent = NULL;	
	}
}

GTextHandler::GTextHandler(GSTRPTR filename, GUWORD start, GUWORD len)
{
	memset((GAPTR)this, 0, sizeof(GTextHandler));
//	if (Buffer) WriteLog("Buffer is something");
	if ( InitGBuffer(filename, start, len, "GTextHandler") )	
	{
		UCaseIsLCase = FALSE;
		TextStart = (GSTRPTR)Buffer;
		TextCurrent = (GSTRPTR)Buffer;
	}
	else
	{
//		WriteLog("GTextHandler(string): Was not able to allocate string-buffer\n");
		TextStart = NULL;
		TextCurrent = NULL;	
	}
}

GTextHandler::~GTextHandler()
{
}

BOOL GTextHandler::RefreshTextPtr()
{
		TextStart = (GSTRPTR)Buffer;
		TextCurrent = (GSTRPTR)Buffer;
		return TRUE;
};

BOOL GTextHandler::InitGTextHandler(GSTRPTR filename, GUWORD start, GUWORD len, GSTRPTR objtype)
{
	if ( InitGBuffer(filename, start, len, objtype) )
	{
		UCaseIsLCase = FALSE;
		TextStart = (GSTRPTR)Buffer;
		TextCurrent = (GSTRPTR)Buffer;
		return TRUE;
	}
	else
	{
//		WriteLog("InitGTextHandler(string): Was not able to allocate string-buffer\n");
		TextStart = NULL;
		TextCurrent = NULL;
		return FALSE;
	}
}

BOOL GTextHandler::InitGTextHandler(GSTRPTR string, GSTRPTR objtype)
{
	int len;
	if (string)
	{
		len = strlen(string);	
		if ( InitGBuffer(len+16, objtype) )
		{
			strcpy((GSTRPTR)Buffer, string);
			
			UCaseIsLCase = FALSE;
			TextStart = (GSTRPTR)Buffer;
			TextCurrent = (GSTRPTR)Buffer;
			return TRUE;
		}
		else
		{
//			WriteLog("InitGTextHandler(string): Was not able to allocate string-buffer\n");
			TextStart = NULL;
			TextCurrent = NULL;
			return FALSE;
		}
	}
	else
	{
//		WriteLog("InitGTextHandler(string): string == NULL\n");
		TextStart = NULL;
		TextCurrent = NULL;
		return FALSE;
	}
}

void GTextHandler::InitTypes()		// Should be used (Sets 0x20 as space etc.);
{
	CharDefs[0] = GTEXT_EOT | GTEXT_NEWLINE | GTEXT_SPACE | GTEXT_TAB | GTEXT_BREAK;
	CharDefs[0x20] = GTEXT_SPACE;
	CharDefs[0xa] = GTEXT_NEWLINE;
	CharDefs[0x9] = GTEXT_TAB;

	GCharArea tempgca;

	tempgca.From = 'a';
	tempgca.To = 'z';
	SetCharDef(&tempgca, GTEXT_LETTER, GTEXT_SET_SET);

	tempgca.From = 'A';
	tempgca.To = 'Z';
	SetCharDef(&tempgca, GTEXT_LETTER, GTEXT_SET_SET);

	tempgca.From = '0';
	tempgca.To = '9';
	SetCharDef(&tempgca, GTEXT_NUMBER, GTEXT_SET_SET);
}

void GTextHandler::ClearTypes()		// Clears 
{
	for (int i=0; i<256; i++)
	{
		CharDefs[i] = 0;
	}
}

void GTextHandler::SetUCaseIsLCase(BOOL b)
{
	UCaseIsLCase = b;
}

BOOL GTextHandler::GetUCaseIsLCase()
{
	return UCaseIsLCase;
}

void GTextHandler::SetCharDef(GSTRPTR str, GUSHORT flags, GUSHORT setmode)
{
	if (str)
	{
		if ( setmode == GTEXT_SET_SET )
		{
			while(*str)
			{
				CharDefs[*str] = flags;
				str++;
			}
		}
		else if ( setmode == GTEXT_SET_OR )
		{
			while(*str)
			{
				CharDefs[*str] |= flags;
				str++;
			}
		}
		else if ( setmode == GTEXT_SET_CLR )
		{
			flags = flags^0xffff;
			while(*str)
			{
				CharDefs[*str] &= flags;
				str++;
			}
		}
	}
}

void GTextHandler::SetCharDef(char x, GUSHORT flags, GUSHORT setmode)
{
	if ( setmode == GTEXT_SET_SET )	CharDefs[x] = flags;
	else if ( setmode == GTEXT_SET_OR ) CharDefs[x] |= flags;
	else if ( setmode == GTEXT_SET_CLR ) CharDefs[x] &= flags^0xffff;
}

void GTextHandler::SetCharDef(GCharArea *gchararea, GUSHORT flags, GUSHORT setmode)
{
	if (gchararea)
	{
		if (gchararea->From && gchararea->To )
		{
			GUBYTE s,e;
			s = (GUBYTE) gchararea->From;
			e = (GUBYTE) gchararea->To;
			if ( setmode == GTEXT_SET_SET )
			{
				for (;s<=e;s++)
				{
					CharDefs[s] = flags;
				}
				gchararea++;
			}
			else if ( setmode == GTEXT_SET_OR )
			{
				for (;s<=e;s++)
				{
					CharDefs[s] |= flags;
				}
				gchararea++;
			}
			else if ( setmode == GTEXT_SET_CLR )
			{
				flags = flags ^ 0xffff;
				for (;s<=e;s++)
				{
					CharDefs[s] &= flags;
				}
				gchararea++;
			}
		}
	}
}

GUSHORT GTextHandler::GetCharDef()
{
	return CharDefs[ *TextCurrent ];
}

GUBYTE GTextHandler::GetChar()
{
	return *TextCurrent;

}

BOOL GTextHandler::CmpChars(char a, char b)
{
	if ( UCaseIsLCase ) {
		if ( ('A' <= a) && (a <= 'Z') ) a+=32;
		if ( ('A' <= b) && (b <= 'Z') ) b+=32;
	}
	if (a==b) return TRUE;
	else return FALSE;
}

GWORD GTextHandler::CpyUntilNextIncident(GSTRPTR dest, GSTRPTR incidents)
{
	GUWORD index = 0;
	while ( (!CmpIncidents(incidents)) && (*TextCurrent != 0) )
	{
		*dest++ = *TextCurrent++;
		index++;
	}
	*dest = 0;
	return index;
}

GWORD GTextHandler::CpyReqType(GSTRPTR dest, GUSHORT flags, GUSHORT demand)
{
	if ( (CharDefs[ *TextCurrent ] & GTEXT_EOT) )
	{
		*dest=0;
		return NULL;
	}

	GSTRPTR old = dest;

	switch (demand)
	{
		case GTEXT_EQ:
			while ( (CharDefs[*TextCurrent] == flags) && !(CharDefs[ *TextCurrent ] & GTEXT_EOT))
			{
//				if (CharDefs[*TextCurrent] & GTEXT_EOT) return NULL;
				*dest++ = *TextCurrent++;
			}
		break;
		case GTEXT_ALL:
			while ( ((CharDefs[*TextCurrent] & flags) == flags) && !(CharDefs[ *TextCurrent ] & GTEXT_EOT) )
			{
//				if (CharDefs[*TextCurrent] & GTEXT_EOT) return NULL;
				*dest++ = *TextCurrent++;
			}
		break;

		case GTEXT_ANY:
			while ( (CharDefs[*TextCurrent] & flags) && !(CharDefs[ *TextCurrent ] & GTEXT_EOT))
			{
//				if (CharDefs[*TextCurrent] & GTEXT_EOT) return NULL;
				*dest++ = *TextCurrent++;
			}
		break;

		case GTEXT_NOTEQ:
			while ( (CharDefs[*TextCurrent] != flags) && !(CharDefs[ *TextCurrent ] & GTEXT_EOT))
			{
//				if (CharDefs[*TextCurrent] & GTEXT_EOT) return NULL;
				*dest++ = *TextCurrent++;
			}
		break;

		case GTEXT_NOTALL:
			while ( ((CharDefs[*TextCurrent] & flags) != flags) && !(CharDefs[ *TextCurrent ] & GTEXT_EOT))
			{
//				if (CharDefs[*TextCurrent] & GTEXT_EOT) return NULL;
				*dest++ = *TextCurrent++;
			}
		break;

		case GTEXT_NONE:
			while ( (!(CharDefs[*TextCurrent] & flags)) && !(CharDefs[ *TextCurrent ] & GTEXT_EOT))
			{
//				if (CharDefs[*TextCurrent] & GTEXT_EOT) return NULL;
				*dest++ = *TextCurrent++;
			}
		break;
				if (CharDefs[*TextCurrent] & GTEXT_EOT) return NULL;
		return NULL;
	}
	*dest = 0;
	if (CharDefs[*TextCurrent] & GTEXT_EOT) return NULL;
	return (GUWORD)dest - (GUWORD)old;
}

BOOL GTextHandler::JumpChars(GWORD x)	// no upper limit
{
	TextCurrent+=x;
	if (TextCurrent > TextStart)
	{
		Jumped = x;
		return TRUE;
	}
	Jumped = 0;
	return FALSE;
}

BOOL GTextHandler::JumpLines(GWORD x)		// x=0 return to start of line
{
	GSTRPTR old = TextCurrent;
	if (x>0)
	{
		for (int l=0; l<x; l++)
		{
			while ( ! ( CharDefs[ *TextCurrent ] & GTEXT_NEWLINE ) )
			{
				TextCurrent++;
			}
			if ( CharDefs[ *TextCurrent ] & GTEXT_EOT )
			{
				Jumped = (GWORD) (TextCurrent-old);
				return FALSE;
			}
			TextCurrent++;
		}
	}
	else
	{
		x = -x+1;
		for (int l=0; l<x; l++)
		{
			while ( ! ( CharDefs[ *TextCurrent ] & GTEXT_NEWLINE ) )
			{
				TextCurrent--;
			}
			if ( TextCurrent < TextStart )
			{
				Jumped = (GWORD) (TextStart-old);
				return FALSE;
			}
			if ( CharDefs[ *TextCurrent ] & GTEXT_EOT )
			{
				Jumped = (GWORD) (TextCurrent-old);
				return FALSE;
			}
			TextCurrent--;
		}
		TextCurrent+=2;
	}
	Jumped = (GWORD) (TextCurrent-old);
	return TRUE;
}

BOOL GTextHandler::JumpLine(GWORD x)
{
	GSTRPTR old = TextCurrent;
	if (x>0)
	{
		TextCurrent = TextStart;
		if (JumpLines(x))
		{
			Jumped = -(GWORD)old-Jumped;
			return TRUE;
		}
		else
		{
			Jumped = -(GWORD)old-Jumped;
			return FALSE;
		}
	}
	else if (x==0)
	{
//		TextCurrent = TextStart;
//		return (GWORD)(old-TextStart);
		TextCurrent = TextStart;
		Jumped = -(GWORD) (old-TextStart);
		return TRUE;
	}
	Jumped = 0;
	return FALSE;
}

BOOL GTextHandler::JumpChar(GWORD x)
{
	GSTRPTR old = TextCurrent;
	if (x>0)
	{
		TextCurrent = TextStart;
		if (JumpChars(x))
		{
			Jumped = -(GWORD)old-Jumped;
			return TRUE;
		}
		else
		{
			Jumped = -(GWORD)old-Jumped;
			return FALSE;
		}
	}
	else if (x==0)
	{
		TextCurrent = TextStart;
		Jumped = -(GWORD) (old-TextStart);
		return TRUE;
	}
	return NULL;
}

BOOL GTextHandler::CmpIncidents(GSTRPTR incidents)
{
	GSTRPTR text;
	while ( (*incidents != 0) && (*text != 0) )
        {
		text = TextCurrent;
		while ( *incidents == *text )
		{
//			printf("%c", *incidents);
			incidents++;
			text++;
		}
		if ( (*incidents == '|') || (*incidents == 0) ) return TRUE;
		while ( (*incidents != '|') && ( *incidents != 0) ) incidents++;
		if (*incidents == '|') incidents++;
	}
	return FALSE;
}

BOOL GTextHandler::JumpNextIncident(GSTRPTR incidents)
{
	GSTRPTR old = TextCurrent;
	while ( (!CmpIncidents(incidents)) && !(CharDefs[*TextCurrent] & GTEXT_EOT) )
	{
		TextCurrent++;
	}
	Jumped = (GWORD) (TextCurrent-old);
	if (CharDefs[*TextCurrent] & GTEXT_EOT) return FALSE;
	return TRUE;
//	if ( *TextCurrent == 0 ) return 0;
//	else return (GWORD) (TextCurrent-old);
}

BOOL GTextHandler::JumpNextReqType(GUSHORT flags, GUSHORT demand)
{
	GSTRPTR old = TextCurrent;
	if ( (CharDefs[ *TextCurrent ] & GTEXT_EOT) ) return FALSE;

	switch (demand)
	{
		case GTEXT_EQ:
			while ( (CharDefs[*TextCurrent] != flags) && !(CharDefs[ *TextCurrent ] & GTEXT_EOT) )
			{
//				if (CharDefs[*TextCurrent] & GTEXT_EOT) return NULL;
//				printf("(%c)", *TextCurrent);
				TextCurrent++;
			}
		break;
		case GTEXT_ALL:
			while ( ((CharDefs[*TextCurrent] & flags) != flags) && !(CharDefs[ *TextCurrent ] & GTEXT_EOT) )
			{
//				if (CharDefs[*TextCurrent] & GTEXT_EOT) return NULL;
//				printf("(%c)", *TextCurrent);
				TextCurrent++;
			}
		break;

		case GTEXT_ANY:
			while ( (!(CharDefs[*TextCurrent] & flags)) && !(CharDefs[ *TextCurrent ] & GTEXT_EOT))
			{
//				if (CharDefs[*TextCurrent] & GTEXT_EOT) return NULL;
//				printf("(%c)", *TextCurrent);
				TextCurrent++;
			}
		break;

		case GTEXT_NOTEQ:
			while ( (CharDefs[*TextCurrent] == flags) && !(CharDefs[ *TextCurrent ] & GTEXT_EOT) )
			{
//				if (CharDefs[*TextCurrent] & GTEXT_EOT) return NULL;
//				printf("(%c)", *TextCurrent);
				TextCurrent++;
			}
		break;

		case GTEXT_NOTALL:
			while ( ((CharDefs[*TextCurrent] & flags) == flags) && !(CharDefs[ *TextCurrent ] & GTEXT_EOT) )
			{
//				if (CharDefs[*TextCurrent] & GTEXT_EOT) return NULL;
//				printf("(%c)", *TextCurrent);
				TextCurrent++;
			}
		break;

		case GTEXT_NONE:
			while ( (CharDefs[*TextCurrent] & flags) && !(CharDefs[ *TextCurrent ] & GTEXT_EOT))
			{
//				if (CharDefs[*TextCurrent] & GTEXT_EOT) return NULL;
//				printf("(%c)", *TextCurrent);
				TextCurrent++;
			}
		break;

		Jumped = (GWORD) (TextCurrent-old);
		return FALSE;
	}
	Jumped = (GWORD) (TextCurrent-old);
	if (CharDefs[*TextCurrent] & GTEXT_EOT) return FALSE;
	return TRUE;
}

BOOL GTextHandler::JumpNextAppearance(GSTRPTR str)
{
	GSTRPTR old = TextCurrent;
//	if ( (CharDefs[ *TextCurrent ] & GTEXT_EOT) ) return NULL;
//	WriteLog("JumpNextAppearance\n");
//	char temp[256];
	while (! ( CharDefs[*TextCurrent] & GTEXT_EOT ) )
	{
		char *tcur = TextCurrent;
		char *strb = str;
		while ( (CmpChars(*strb, *tcur)) && !(CharDefs[ *tcur ] & GTEXT_EOT) )
		{
			strb++;
			tcur++;
		}

		if ( *strb == 0 ) {
//			sprintf(temp, "before %x - after %x\n", old, TextCurrent);
//			WriteLog(temp);
			Jumped = TextCurrent-old;
			return TRUE;
		}
		
		TextCurrent++;
	}
	Jumped = (GWORD) (TextCurrent-old);
//	sprintf(temp, "before %x - after %x\n", old, TextCurrent);
//	WriteLog(temp);
	return FALSE;
		
}

BOOL GTextHandler::JumpNextChar(char c)
{
	GSTRPTR old = TextCurrent;
	while ( (!(CharDefs[ *TextCurrent ] & GTEXT_EOT)) && (! CmpChars( *TextCurrent, c) ) ) TextCurrent++;
	Jumped = (GWORD) (TextCurrent-old);
	if ( CharDefs[*TextCurrent] & GTEXT_EOT ) return FALSE;
	return TRUE;
}

#endif /* GTEXTHANDLER_CPP */