/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 1998  Niels Froehling <Niels.Froehling@Informatik.Uni-Oldenburg.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#define	LIBQTOOLS_CORE
#include "../include/libqtools.h"

char *preProcessor = 0;

/*
 * disk-tools
 */

void CreatePath(register char *fileName)
{
  char *delAdr1 = fileName, *delAdr2 = fileName;

  while ((delAdr2 = (char *)__strchr(delAdr1, CHAR_FOR_DIR))) {
    *delAdr2 = '\0';
    mkdir(fileName, ALLPERMS);
    *delAdr2 = CHAR_FOR_DIR;
    delAdr1 = ++delAdr2;
  }
}

char *GetExt(register char *Name)
{
  if (Name) {
    char *Ext = (char *)__strrchr(Name, '.');

    if (!Ext)
      return (char *)__strchr(Name, '\0');
    else {
      /*
       * delete everything after 4 chars 
       * Ext[4] = '\0';
       */
      return ++Ext;
    }
  }
  else
    return 0;
}

void StripExt(register char *Name)
{
  if (Name) {
    char *Ext;

    if ((Ext = (char *)__strrchr(Name, '.')))
      *Ext = '\0';
  }
}

void ReplaceExt(register char *Name, register char *newExt)
{
  if (Name) {
    char *Ext;

    if ((Ext = (char *)__strrchr(Name, '.'))) {
      *++Ext = '\0';
      __strcpy(Ext, newExt);
    }
    else {
      __strcat(Name, ".");
      __strcat(Name, newExt);
    }
  }
}

/*
 * get the file-part of a path
 */
char *GetFile(register char *Name)
{
  if (Name) {
    char *Ext = (char *)__strrchr(Name, CHAR_FOR_DIR);

    if (!Ext)
      return Name;
    else {
      return ++Ext;
    }
  }
  else
    return 0;
}

/*
 * check for valid unix-path
 */
void ValidateDir(register char *Name)
{
  short int len = __strlen(Name);

  while (Name[len] == CHAR_FOR_DIR)
    Name[len--] = '\0';
}

void *GetVoidF(register HANDLE getFile)
{
  void *voidData = 0;
  int size;

  __lseek(getFile, 0, SEEK_END);
  size = __ltell(getFile);
  __lseek(getFile, 0, SEEK_SET);

  if ((voidData = (void *)tmalloc(size + 1))) {
    char *byteData = (char *)voidData;

    __read(getFile, voidData, size);
    byteData[size] = '\0';
  }
  else
    eprintf(failed_memory, size, "void data");

  return voidData;
}

void *GetVoid(register char *fileName)
{
  HANDLE getFile = __open(fileName, H_READ_BINARY);
  void *voidData = 0;

  if (getFile > 0) {
    voidData = GetVoidF(getFile);
    __close(getFile);
  }

  return voidData;
}

void *GetPreProcessed(register char *fileName)
{
  if (preProcessor) {
    char *tmpName;
    void *tmpData = 0;

    if ((tmpName = tmpnam(0))) {
      char *exeLine;

      if ((exeLine = (char *)tmalloc(__strlen(preProcessor) + 1 + __strlen(fileName) + 1 + __strlen(tmpName) + 1))) {
	__strcpy(exeLine, preProcessor);
	__strcat(exeLine, " ");
	__strcat(exeLine, fileName);
	__strcat(exeLine, " ");
	__strcat(exeLine, tmpName);

	system(exeLine);

	tmpData = GetVoid(tmpName);
	remove(tmpName);
      }
    }

    return tmpData;
  }
  else
    return GetVoid(fileName);
}

/*
 * allocate greatest buffer for a given size that is available
 * first tries with maximum memory and then tries with smaller
 * buffers upto an error
 */
void *SmartBuffer(int len, int *clusters, int *clustersize, int *rest)
{
  void *buffer = 0;

  *clusters = 1;
  *clustersize = len;
  *rest = 0;

  if (*clustersize > 0) {
    while (*clustersize > 0) {
      if ((buffer = tmalloc(*clustersize))) {
	break;
      }
      else {
	*clustersize >>= 1;
	*clusters <<= 1;
	*rest = len % *clustersize;
      }
    }
  }
  else
    buffer = (void *)tmalloc(1);

  return buffer;
}

/*
 * cuts bytes out of a file
 * (file is REAL shorter)
 * stores cutted bytes if buffer != 0
 */
#ifdef	UNLIMITED
bool CutOff(HANDLE procFile, int byteValue, void *buffer)
{
  if (byteValue && procFile) {
    int begin = __ltell(procFile);
    int difference;

    if (buffer) {
      if (__read(procFile, buffer, byteValue) != byteValue)
	return FALSE;
    }

    /* cut of in steps */
    __lseek(procFile, 0, SEEK_END);
    difference = __lseek(procFile, 0, SEEK_CUR) - begin - byteValue;
    if ((buffer = (void *)tmalloc(difference))) {
      __lseek(procFile, begin + byteValue, SEEK_SET);
      __read(procFile, buffer, difference);
      __lseek(procFile, begin, SEEK_SET);
      __write(procFile, buffer, difference);
      __lseek(procFile, begin, SEEK_SET);
      if (ftruncate(procFile, begin + difference) == -1)
	printf("failed to truncate file to %d bytes\n", begin + difference);
      free(buffer);
      return TRUE;
    }
    else
      return FALSE;
  }
  else
    return TRUE;
}
#else
bool CutOff(HANDLE procFile, int byteValue, void *buffer)
{
  if (byteValue && procFile) {
    bool success;
    int clusters, clustersize, rest;
    int begin;
    int difference;

    if (buffer)
      if (__read(procFile, buffer, byteValue) != byteValue)
	return FALSE;

    success = FALSE;
    begin = __lseek(procFile, 0, SEEK_CUR);

    /* cut of in steps */
    __lseek(procFile, 0, SEEK_END);
    difference = __lseek(procFile, 0, SEEK_CUR) - begin - byteValue;

    if ((buffer = SmartBuffer(difference, &clusters, &clustersize, &rest))) {
	/* copy forwards */
	__lseek(procFile, begin + byteValue, SEEK_SET);
	while (clusters--) {
	  if (__read(procFile, buffer, clustersize) != clustersize) {
	    break;
	  }
	  __lseek(procFile, -clustersize - byteValue, SEEK_CUR);	/* seek backward */
	  if (__write(procFile, buffer, clustersize) != clustersize) {
	    break;
	  }
	  __lseek(procFile, byteValue, SEEK_CUR);		/* seek forward */
	}

	if (clusters == -1) {
	  if (rest) {
	    if (__read(procFile, buffer, rest) == rest) {
	      __lseek(procFile, -rest - byteValue, SEEK_CUR);	/* seek backward */
	      if (__write(procFile, buffer, rest) == rest)
		success = TRUE;
	    }
	  }
	  else
	    success = TRUE;
	}

      if (success) {
	__lseek(procFile, begin, SEEK_SET);
	if (ftruncate(procFile, begin + difference) == -1)
	  success = FALSE;
      }

      tfree(buffer);
    }

    return success;
  }
  else
    return TRUE;
}
#endif

/*
 * pastes bytes to a file
 * (file is REAL longer)
 * write bytes if buffer != 0
 */
#ifdef	UNLIMITED
bool PasteIn(HANDLE procFile, int byteValue, void *buffer)
{
  if (byteValue && procFile) {
    int begin = __ltell(procFile);
    int difference;
    void *bufferNew;

    if (!buffer)
      buffer = (void *)PasteIn;					/* copy something */

    /* paste in in steps */
    __lseek(procFile, 0, SEEK_END);
    difference = __lseek(procFile, 0, SEEK_CUR) - begin;
    if ((bufferNew = (void *)tmalloc(difference)) && buffer) {
      __lseek(procFile, begin, SEEK_SET);
      __read(procFile, bufferNew, difference);
      __lseek(procFile, begin, SEEK_SET);
      __write(procFile, buffer, byteValue);
      __write(procFile, bufferNew, difference);
      __lseek(procFile, begin, SEEK_SET);
      free(bufferNew);
      return TRUE;
    }
    else
      return FALSE;
  }
  else
    return TRUE;
}
#else
bool PasteIn(HANDLE procFile, int byteValue, void *buffer)
{
  if (byteValue && procFile) {
    bool success;
    int clusters, clustersize, rest, begin, difference;
    void *copybuffer;

    success = FALSE;
    begin = __lseek(procFile, 0, SEEK_CUR);

    /* paste in in steps */
    __lseek(procFile, 0, SEEK_END);
    difference = __lseek(procFile, 0, SEEK_CUR) - begin;

    if ((copybuffer = SmartBuffer(difference, &clusters, &clustersize, &rest))) {
	/* copy backwards */
	__lseek(procFile, 0, SEEK_END);
	while (clusters--) {
	  __lseek(procFile, -clustersize, SEEK_CUR);
	  if (__read(procFile, copybuffer, clustersize) != clustersize) {
	    break;
	  }
	  __lseek(procFile, -clustersize + byteValue, SEEK_CUR);
	  if (__write(procFile, copybuffer, clustersize) != clustersize) {
	    break;
	  }
	}

	if (clusters == -1) {
	  if (rest) {
	    __lseek(procFile, -rest, SEEK_CUR);
	    if (__read(procFile, copybuffer, rest) == rest) {
	      __lseek(procFile, -rest + byteValue, SEEK_CUR);
	      if (__write(procFile, copybuffer, rest) == rest)
		success = TRUE;
	    }
	  }
	  else
	    success = TRUE;
	}

      if (success) {
	if (buffer) {
	  __lseek(procFile, begin, SEEK_SET);
	  if (__write(procFile, buffer, byteValue) != byteValue)
	    success = FALSE;
	}
	else
	  __lseek(procFile, begin + byteValue, SEEK_SET);
      }

      tfree(copybuffer);
    }

    return success;
  }
  else
    return TRUE;
}
#endif
