
/* Author Anders Kjeldsen */

#ifndef GFILE_CPP
#define GFILE_CPP

#include "gsystem/GFile.h"
#include "gsystem/GObject.cpp"

GFile::GFile(GSTRPTR filename)
{
	memset((void *)this, 0, sizeof (class GFile) );

	if ( InitGObject("GFile") )
	{
		if (! FileOpen(filename) )
		{
			AddError("GFile", "Open() failed");
		}
	}
}

GFile::~GFile()
{
	FileClose();
}

BOOL GFile::FileOpen(GSTRPTR filename)
{
	if (FH) FileClose();

#ifdef GWINDOWS
	DWORD FileSizeHigh = 0;
#endif

	if (filename)
	{
#ifdef GAMIGA
		FH = Open(filename, MODE_READWRITE);
		if ( FH )
		{
			Seek(FH, 0, OFFSET_END);
			FileSize = Seek(FH, 0, OFFSET_BEGINNING);
			if ( strlen(filename) > 255 )
			{
				Close(FH);
				FH = NULL;
				return FALSE;
			}
			else
			{
				strcpy(FileName, filename);
				return TRUE;
			}
		}
#endif

#ifdef GWINDOWS
		if ( FH = CreateFile( filename, GENERIC_READ | GENERIC_WRITE, FILE_SHARE_READ | FILE_SHARE_WRITE, NULL, OPEN_ALWAYS, NULL, NULL) )
		{
			FileSize = GetFileSize(FH, &FileSizeHigh);
			if (strlen(filename) > 255)
			{
				CloseHandle(FH);
				return FALSE;
			}
			else 
			{
				strcpy(FileName, filename);
				return TRUE;
			}
		}
#endif

	}
	return FALSE;
}

BOOL GFile::FileClose()
{
	if (FH)
	{
#ifdef GAMIGA
		Close(FH);
#endif
#ifdef GWINDOWS
		CloseHandle(FH);
#endif
		FH = NULL;
		*FileName = 0;
		return TRUE;
	}
	return FALSE;
}

BOOL GFile::FileLock() 
{ 
	return FALSE;
} 

BOOL GFile::FileUnLock() 
{ 
	return TRUE;
} 

BOOL GFile::FileSeek(GWORD offset, GUWORD seekmode)
{
	if (*FileName && FH)
	{
		GWORD temp = FilePtr;
		if ( seekmode == GSEEK_START ) temp = 0;
		else if ( seekmode == GSEEK_END ) temp = FileSize;

		temp += offset;
#ifdef GAMIGA
		if ( Seek(FH, temp, OFFSET_BEGINNING) != -1 )
#endif
#ifdef GWINDOWS
		if ( SetFilePointer(FH, temp, NULL, FILE_BEGIN) != -1 )
#endif
		{
			FilePtr = temp;
//			WriteLog("Seek ok\n");
			return TRUE;
		}
	}
	return FALSE;
}

BOOL GFile::FileRead(GAPTR buffer, GUWORD len)
{
#ifdef GWINDOWS
	DWORD FileSizeHigh = 0;
#endif
	GWORD delta;
	if (FH && buffer)
	{
		if (FileSize >= FilePtr)
		{
			delta = FileSize-(FilePtr+len);
			if (delta < 0)
			{
				len+= delta;
			}
#ifdef GAMIGA
			Seek(FH, FilePtr, OFFSET_BEGINNING);
			if ( Read(FH, buffer, len) )
			{
				Seek(FH, FilePtr, OFFSET_BEGINNING);
				return TRUE;
			}
			else AddError("ReadError", "Read Failed");
#endif

#ifdef GWINDOWS
			SetFilePointer(FH, FilePtr, 0, FILE_BEGIN);
			if ( ReadFile(FH, buffer, len, &FileSizeHigh, 0) )
			{
				SetFilePointer(FH, FilePtr, 0, FILE_BEGIN);
				return TRUE;
			}
#endif
		}
		else AddError("WriteError", "FilePtr too big");
	}
	else AddError("WriteError", "No File");
	Seek(FH, FilePtr, OFFSET_BEGINNING);
	return FALSE;
}

BOOL GFile::FileWrite(GAPTR buffer, GUWORD len)
{
#ifdef GWINDOWS
	DWORD FileSizeHigh = 0;
#endif

	if (FH && buffer)
	{
		if (FileSize >= FilePtr)
		{
#ifdef GAMIGA
			Seek(FH, FilePtr, OFFSET_BEGINNING);
			if ( Write(FH, buffer, len) )
			{
				Seek(FH, 0, OFFSET_END);
				FileSize = Seek(FH, FilePtr, OFFSET_BEGINNING);
				return TRUE;
			}
			else AddError("WriteError", "Write Failed");
#endif

#ifdef GWINDOWS
			SetFilePointer(FH, FilePtr, 0, FILE_BEGIN);
			if ( WriteFile(FH, buffer, len, &FileSizeHigh, 0) )
			{
				SetFilePointer(FH, FilePtr, 0, FILE_BEGIN);
				FileSize = GetFileSize(FH, &FileSizeHigh);
				return TRUE;
			}
#endif
		}
		else AddError("WriteError", "FilePtr too big");
	}
	else AddError("WriteError", "No File");
	Seek(FH, FilePtr, OFFSET_BEGINNING);
	return FALSE;
}

#endif /* GFILE_CPP */

