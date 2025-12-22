
/* Author Anders Kjeldsen */

#ifndef GBUFFER_CPP
#define GBUFFER_CPP

#include "gsystem/GBuffer.h"
#include "gsystem/GObject.cpp"

GBuffer::GBuffer(GSTRPTR filename, GUWORD start, GUWORD len)
{
	memset((void *)this, 0, sizeof (class GBuffer) );
//	WriteLog("Init\n");
	if ( InitGObject("GBuffer") )
	{
//		WriteLog("Inited\n");
		Locked = TRUE;
		Buffer = NULL;	// Load() checks if Buffer is non-zero!
//		WriteLog("Load\n");
		if ( Load(filename, start, len) )
		{
		}
	}
}

GBuffer::GBuffer(GUWORD size)
{
	memset((void *)this, 0, sizeof (class GBuffer) );
	if ( InitGObject("GBuffer") )
	{
		Locked = TRUE;
		Buffer = (GAPTR) new char[size];

		if (Buffer)
		{
			Size = size;
			FilePtr = 0;
		}
	}
}

GBuffer::~GBuffer()
{
	if (Buffer)
	{
		delete Buffer;
	}
}

BOOL GBuffer::InitGBuffer(GSTRPTR filename, GUWORD start, GUWORD len, GSTRPTR objtype)
{
	if (Buffer)
	{
		delete Buffer;
	}
//	WriteLog("memset\n");
	memset((void *)this, 0, sizeof (class GBuffer) );
	if ( InitGObject(objtype) )
	{

		Locked = TRUE;
		Buffer = NULL;
//		WriteLog("Load\n");
		if ( Load(filename, start, len ) )
		{
			return TRUE;
		}
		return FALSE;
	}
	return FALSE;
}

BOOL GBuffer::InitGBuffer(GUWORD size, GSTRPTR objtype)
{
	if (Buffer)
	{
		delete Buffer;
	}

	memset((void *)this, 0, sizeof (class GBuffer) );
	if ( InitGObject(objtype) )
	{
		Locked = TRUE;
		Buffer = (GAPTR) new char[size];

		if (Buffer)
		{
			Size = size;
			FilePtr = 0;
			return TRUE;
		}
		return FALSE;
	}
	return FALSE;
}

GAPTR GBuffer::LockBuf() 
{ 
	if (!Buffer)
	{
//		WriteLog("Loading of backed up memory is not available yet!\n");
		return NULL;
	}
	else
	{
		Locked = TRUE; 
		return Buffer;
	}
} 

/*

BOOL GBuffer::Load(GSTRPTR filename, GUWORD start, GUWORD len)
{
	if (Buffer)
	{
		delete Buffer;
		Buffer = NULL;
	}

	HANDLE fh;
	DWORD SizeHigh;
	SizeHigh = 0;

	if (filename)
	{
		if ( fh = CreateFile( filename, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, NULL, NULL) )
		{
			Size = GetFileSize(fh, &SizeHigh);
			if (Size > start)
			{
				if ( Size != -1)
				{
					FileSize = Size;
					if ( len != 0 )
					{
						GWORD delta = Size-(start+len);
						if (delta < 0)
						{
							len+= delta;
						}
						Size = len;
					}
					else
					{
						len = Size;
					}

					Buffer = (GAPTR) new char[Size+16];
					if (Buffer)
					{
						if ( SetFilePointer(fh, start, NULL, FILE_BEGIN) != -1 )
						{
							FilePtr = start;
							strncpy(FileName, filename, 255);
							SizeHigh = 0;
							ReadFile(fh, Buffer, Size, &SizeHigh, 0);
							((char *)Buffer)[Size] = 0;
							return TRUE;
						}
						else WriteLog("Load: SetFilePointer Failed\n");
					}
				}
			}
			CloseHandle(fh);
		}
	}
	return FALSE;
}
*/
/*
BOOL GBuffer::Seek(GWORD offset, GUWORD seekmode)
{
	if ( seekmode == GSEEK_START ) FilePtr = 0;
	else if ( seekmode == GSEEK_END ) FilePtr = FileSize;

	if (*FileName && FileSize)
	{
		FilePtr += offset;
		if (FilePtr && (FilePtr < FileSize) )
		{
			return TRUE;
		}
	}
	return FALSE;
}

// note: it updates the FilePtr !
GUWORD GBuffer::Peek(GUWORD len)
{
	HANDLE fh;
	DWORD SizeHigh;
	SizeHigh = 0;
	GWORD delta;
	
	if (*FileName && FileSize)
	{
		if ( fh = CreateFile( FileName, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, NULL, NULL) )
		{
			if (FileSize > FilePtr)
			{
				delta = FileSize-(FilePtr+len);
				if (delta < 0)
				{
					len+= delta;
				}

				if ( Size != len )
				{
					if (Buffer) delete Buffer;
					Buffer = (GAPTR) new char[len+16];
					((char *)Buffer)[len] = 0;
				}
				Size = len;
				if (Buffer)
				{
					if ( SetFilePointer(fh, FilePtr, NULL, FILE_BEGIN) != -1 )
					{
						FilePtr += Size;
//						SizeHigh = 0;
						ReadFile(fh, Buffer, Size, &SizeHigh, 0);
						return Size;
					}
					else WriteLog("Load: SetFilePointer Failed\n");
				}
			}
			CloseHandle(fh);
		}
	}
	return FALSE;
}

*/

#endif /* GBUFFER_CPP */

