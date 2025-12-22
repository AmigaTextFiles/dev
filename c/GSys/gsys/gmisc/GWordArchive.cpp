
/* Author Anders Kjeldsen */

#ifndef GWORDARCHIVE_CPP
#define GWORDARCHIVE_CPP

#include "gmisc/GWordArchive.h"#include "gsystem/GFile.cpp"


GWordArchive::GWordArchive(GSTRPTR filename)
{
	memset((void *)this, 0, sizeof (GWordArchive) );

	if ( InitObject("GWordArchive") )
	{
		if ( !(Open(filename)) ) Errors++;
	}
}

GWordArchive::~GWordArchive()
{
	if (UseCache) CacheOff();
}

/*
Higher = lavere i alfabetet
Lower = høyere i alfabetet 
  */

GUWORD CoolStrCmp(GSTRPTR s1, GSTRPTR s2)
{
	GUWORD *l1 = (GUWORD *) s1;
	GUWORD *l2 = (GUWORD *) s2;
	GUWORD diff = 0;
	while ( *l1 && ! (diff = ((*l2++) - (*l1++)) ) );
	return diff;
}

BOOL GWordArchive::DumpWord(GSTRPTR word)
{
	FileChunk fc;
	if (strlen(word) < 67)
	{
		memset((void *)&fc, 0, sizeof(FileChunk));
		strcpy(fc.Data, word);
		fc.Lower = -1;
		fc.Higher = -1;
		fc.Head = -1;

		FileChunk current;
		Seek(0, GSEEK_START);

		if (FileSize <= 0)
		{
//			char gwainfo[256];
//			strcpy(gwainfo, "GWordArchive v1.0b");
//			CacheWrite((void *)&gwainfo, 100, TRUE);
//			Seek(100, GSEEK_START);
			CacheWrite((void *)&fc, sizeof(FileChunk), TRUE);
			return TRUE;
		}
		for (int i=0; i < 256; i++)
		{
			CacheRead((void *)&current, sizeof(FileChunk), FALSE);

			int diff = strcmp(fc.Data, current.Data);
			if (diff > 0)
			{
				if (current.Higher >= 0)
				{
					Seek(current.Higher, GSEEK_START);
				}
				else
				{
					current.Higher = FileSize;
					fc.Head = FilePtr;
					CacheWrite((void *)&current, sizeof(FileChunk), FALSE);
					Seek(0, GSEEK_END);
					CacheWrite((void *)&fc, sizeof(FileChunk), TRUE);
					return true;
				}
			}
			else if (diff < 0)
			{
				if (current.Lower >= 0)
				{
					Seek(current.Lower, GSEEK_START);
				}
				else
				{
					current.Lower = FileSize;
					fc.Head = FilePtr;
					CacheWrite((void *)&current, sizeof(FileChunk), FALSE);
					Seek(0, GSEEK_END);
					CacheWrite((void *)&fc, sizeof(FileChunk), TRUE);
					return true;
				}
			}
			else
			{
				WriteLog("Word already excists ");
				WriteLog(word);
				WriteLog("\n");
				return FALSE;
			}
		}
		WriteLog("Your code sucks!\n");
	}
	return FALSE;
}

BOOL GWordArchive::FindWord(GSTRPTR word)
{
	if (strlen(word) < 67)
	{
		FileChunk current;
		Seek(0, GSEEK_START);

		if (FileSize <= 0)
		{
			WriteLog("Database is empty\n");
			return TRUE;
		}

		for (int i=0; i < 256; i++)
		{
			CacheRead((void *)&current, sizeof(FileChunk), TRUE);
			char temp[256];
			sprintf(temp, "level %d word '%s'\n", i, current.Data);
			WriteLog(temp);
			int diff = strcmp(word, current.Data);
			if (diff > 0)
			{
				//WriteLog("1");
				if (current.Higher >= 0) Seek(current.Higher, GSEEK_START);
				else
				{
					WriteLog("\nWord not found\n");
					return FALSE;
				}
			}
			else if (diff < 0)
			{
				//WriteLog("0");
				if (current.Lower >= 0) Seek(current.Lower, GSEEK_START);
				else
				{
					WriteLog("\nWord not found\n");
					return FALSE;
				}
			}
			else
			{
				char temp[256];
				sprintf(temp, "\nfound word '%s' at level %d\n", word, i);
				WriteLog(temp);
				return TRUE;
			}
		}
		WriteLog("Your code sucks!\n");
	}
	return FALSE;
}

BOOL GWordArchive::HardFindWord(GSTRPTR word)
{
	if (strlen(word) < 67)
	{
		FileChunk current;
		Seek(0, GSEEK_START);

		if (FileSize <= 0)
		{
			WriteLog("Database is empty\n");
			return TRUE;
		}

//		for (int i=0; i < 256; i++)
		while (1)
		{
			CacheRead((void *)&current, sizeof(FileChunk), TRUE);
			int diff = strcmp(word, current.Data);
			if (diff != 0)
			{
				if ( ! Seek(sizeof(FileChunk), GSEEK_CURRENT) )
				{
					return FALSE;
				}
			}
			else
			{
				char temp[256];
				sprintf(temp, "\nfound word '%s' Head= %d\n", word, current.Head);
				Seek(current.Head, GSEEK_START);
				CacheRead((void *)&current, sizeof(FileChunk), FALSE);
				WriteLog(temp);
				WriteLog("Head: ");
				WriteLog(current.Data);
				WriteLog("\n");
				return TRUE;
			}
		}
		WriteLog("Your code sucks!\n");
	}
	return FALSE;
}

//GUWORD GWordArchive::CountWords()
//{
//}

BOOL GWordArchive::CacheOn(GWORD size)
{
	if (Cache)
	{
		if (CSize != size) delete Cache;
		else return TRUE;
	}
	Cache = new char[size];
	if (Cache)
	{
		CSize = size;
		UseCache = TRUE;

		return ReloadCache();
	}
	else
	{
		CSize = 0;
		UseCache = FALSE;
		return FALSE;
	}
}

BOOL GWordArchive::CacheOff()
{
	if (Cache)
	{
		GWORD rsize = CSize;
		if ( (CPos + CSize) > FileSize )
		{
			rsize = FileSize - CPos;
		}
		if (CPos > FileSize) return FALSE;

		Seek(CPos, GSEEK_START);
		Write(Cache, rsize);
		char temp[256];
		sprintf(temp, "last size: %d\n", rsize);
		WriteLog(temp);

		delete Cache;
		Cache = NULL;
		CSize = 0;
		UseCache = FALSE;
		return TRUE;
	}
	else
	{
		CSize = 0;
		UseCache = FALSE;
		return TRUE;
	}
}

BOOL GWordArchive::ReloadCache()
{
//	char *Cache;
//	GWORD CPos;
//	GWORD CSize;
	if (Cache)
	{
		GWORD rsize = CSize;
		if ( (CPos + CSize) > FileSize )
		{
			rsize = FileSize - (CPos);
		}
		if (CPos > FileSize) return FALSE;
		Seek(CPos, GSEEK_START);
		return Read(Cache, rsize);
	}
	return FALSE;
}

BOOL GWordArchive::UpdateCache()
{
//	WriteLog("UpdateCache\n");
	if (Cache)
	{
		GWORD rsize = CSize;
		if ( (CPos + CSize) > FileSize )
		{
			rsize = FileSize - (CPos);
		}
		if (CPos > FileSize) return FALSE;

		GWORD old = FilePtr;
		Seek(CPos, GSEEK_START);
		Write(Cache, rsize);
		Seek(old, GSEEK_START);
		CPos = FilePtr;
		ReloadCache();
	}
	return TRUE;
}

BOOL GWordArchive::CacheRead(GAPTR buffer, GWORD len, BOOL force)
{
//	char temp[512];
	if (UseCache)
	{
		if (FilePtr < CPos)	// starter under
		{
			if ( (FilePtr + len) > CPos ) // går over
			{
//				WriteLog(".. and inside\n");
				if (force) UpdateCache();
				else
				{
					GWORD flen = CPos-FilePtr;
					Read(buffer, flen);	// foran cachen
					buffer = (GAPTR) ((GUWORD)buffer + flen);
					len -= flen;
					Seek(CPos, GSEEK_START);
				}
			}
			else
			{
				if (force) UpdateCache();
				else
				{
					Read(buffer, len);
					return TRUE;
				}
			}
		}
		if ( (FilePtr + len) > (CPos + CSize) )
		{
			if ( FilePtr < (CPos + CSize) )
			{
				if (force) UpdateCache();
				else
				{
					GWORD flen = (FilePtr + len) - (CPos + CSize);
					GWORD oldfp = FilePtr;
					Seek(CPos + CSize, GSEEK_START);
					Read((GAPTR) ((GUWORD)buffer+(len-flen)), flen);
					len -= flen;
					Seek(oldfp, GSEEK_START);
				}
			}
			else
			{
				if (force) UpdateCache();
				else
				{
					Read(buffer, len);
					return TRUE;
				}
			}
		}

		GWORD offset = FilePtr - CPos;
		memcpy(buffer, Cache+offset, len);

		return TRUE;
	}
	else
	{
		return Read(buffer, len);
	}
}

BOOL GWordArchive::CacheWrite(GAPTR buffer, GWORD len, BOOL force)
{
//	char temp[512];
//	sprintf(temp, "FilePtr %d Len %d Cache %d\n", FilePtr, len, FileSize);
//	WriteLog(temp);

	GWORD filesize = FileSize;

	if (UseCache)
	{
		if (FilePtr < CPos)	// starter under
		{
			if ( (FilePtr + len) > CPos ) // går over
			{
				if (force) UpdateCache();
				else
				{
					GWORD flen = CPos-FilePtr;
					Write(buffer, flen);	// foran cachen
					buffer = (GAPTR) ((GUWORD)buffer + flen);
					len -= flen;
					Seek(CPos, GSEEK_START);
				}
			}
			else
			{
				if (force) UpdateCache();
				else
				{
//					WriteLog("Writes outside only\n");
					Write(buffer, len);
					if ( FileSize < filesize )
					{
						FileSize = filesize;
					}
					return TRUE;
				}
			}
		}
		if ( (FilePtr + len) > (CPos + CSize) )
		{
			if ( FilePtr < (CPos + CSize) )
			{
//				WriteLog("Still inside\n");
				if (force) UpdateCache();
				else
				{
					GWORD flen = (FilePtr + len) - (CPos + CSize);
					GWORD oldfp = FilePtr;
					Seek(CPos + CSize, GSEEK_START);
					Write((GAPTR) ((GUWORD)buffer+(len-flen)), flen);
					len -= flen;
					Seek(oldfp, GSEEK_START);
				}
			}
			else
			{
				if (force) UpdateCache();
				else
				{
//					WriteLog("Writes outside only\n");
					Write(buffer, len);
					if ( FileSize < filesize )
					{	
						FileSize = filesize;
					}
					return TRUE;
				}
			}
		}

		if ( FileSize < filesize )
		{
			FileSize = filesize;
		}

//		sprintf(temp, "1 FilePtr %d Len %d Cache %d\n", FilePtr, len, FileSize);
//		WriteLog(temp);

		GWORD offset = FilePtr - CPos;
		memcpy(Cache+offset, buffer, len);

		if ( (FilePtr + len) > FileSize)
		{
			FileSize = FilePtr + len;
		}

//		char temp[512];
//		sprintf(temp, "FilePtr %d Len %d Cache %x\n", FilePtr, len, Cache);
//		WriteLog(temp);

		return TRUE;
	}


	else
	{
		return Write(buffer, len);
	}
}

/*
		if ( ((FilePtr + len) > (CPos + CSize)) || (FilePtr < CPos) )
		{
			if (force) UpdateCache();
			else
			{
				Write(buffer, len);
				if ( ((FilePtr + len) > CPos) || (FilePtr < (CPos + CSize)) )
				{
					ReloadCache();
				}
				return TRUE;
			}
		}
		GWORD offset = FilePtr-CPos;
		memcpy(Cache+offset, buffer, len);

		if ( (FilePtr + len) > FileSize)
		{
			FileSize = FilePtr + len;
		}
		return TRUE;
	}
*/

#endif /* GWORDARCHIVEMET */
