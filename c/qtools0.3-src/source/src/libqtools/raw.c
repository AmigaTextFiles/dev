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

/*
 * rmalloc/rfree
 */

struct rawdata *rmalloc(register int size, register char *rawName)
{
  struct rawdata *rawData = 0;

  if ((rawData = (struct rawdata *)tmalloc(size + sizeof(struct rawdata)))) {
    rawData->size = size;
    if (!rawName)
      rawName = "nameLess";
    rawData->name = smalloc(rawName);
  }
  else
    eprintf(failed_memory, size + sizeof(struct rawdata), "raw data");

  return rawData;
}

void rfree(register struct rawdata *rawData)
{
  if (rawData) {
    if (rawData->name)
      tfree(rawData->name);
    tfree(rawData);
  }
}

/*
 * compressed
 */

char Compression = CMP_NONE;

char *GetLZ77(register HANDLE file, register int readsize)
{
  char *inData, *outData = 0;

  if (!readsize) {
    int oldoffset = __ltell(file);

    __lseek(file, 0, SEEK_END);
    readsize = __ltell(file);
    __lseek(file, oldoffset, SEEK_SET);
  }

  if ((inData = (char *)tmalloc(readsize))) {
    int size;

    __read(file, inData, readsize);
    if ((size = LZWSSize(inData)) > ERROR) {
      mprintf("prepare to decrunch %d bytes ... \n", size);
      if ((outData = (char *)tmalloc(size))) {
	if (LZWSDecrunch(size, inData, outData) < ERROR) {
	  eprintf("failed to decrunch\n");
	  tfree(outData);
	  outData = 0;
	}
      }
      else
	eprintf(failed_memory, size, "decrunch");
    }
    tfree(inData);
  }
  else
    eprintf(failed_memory, readsize, "read crunched");

  return outData;
}

char *ParseLZ77(register char *inData, register int readsize)
{
  char *outData = 0;

  if (readsize > 0) {
    int size;

    if ((size = LZWSSize(inData)) > ERROR) {
      mprintf("prepare to decrunch %d bytes ... \n", size);
      if ((outData = (char *)tmalloc(size))) {
	if (LZWSDecrunch(size, inData, outData) < ERROR) {
	  eprintf("failed to decrunch\n");
	  tfree(outData);
	  outData = 0;
	}
      }
      else
	eprintf(failed_memory, size, "decrunch");
    }
  }

  return outData;
}

int PutLZ77(register HANDLE file, register char *inData, register int size)
{
  char *outData, *saveData;
  int retval = -1;

  if ((outData = (char *)tmalloc(size))) {
    if ((retval = LZWSCrunch(size, size, size * 2, inData, outData)) > ERROR) {
      mprintf("crunched %d to %d (%d%%)\n", size, retval, ((retval * 100) / size));
      if (__write(file, outData, retval) != retval)
	retval = -1;

      if ((saveData = (char *)tmalloc(size))) {
	int error, byte;

	if ((error = LZWSDecrunch(size, outData, saveData)) > ERROR) {
	  for (byte = 0; byte < size; byte++) {
	    if (inData[byte] != saveData[byte])
	      break;
	  }
	  if (byte != size)
	    eprintf("difference at %d\n", byte);
	}
	tfree(saveData);
      }
    }
    tfree(outData);
  }
  else
    eprintf(failed_memory, size, "write crunched");

  return retval;
}

int PasteLZ77(register char *outData, register char *inData, register int size)
{
  return LZWSCrunch(size, size, size * 2, inData, outData);
}

/*
 * Unknown/Raw
 */
struct rawdata *GetRaw(register HANDLE file, register char *rawName, register int size)
{
  struct rawdata *rawData = 0;

  if (!size) {
    int oldoffset = __ltell(file);

    __lseek(file, 0, SEEK_END);
    size = __ltell(file);
    __lseek(file, oldoffset, SEEK_SET);
  }

  if ((rawData = rmalloc(size + 1, rawName))) {
    __read(file, rawData->rawdata, size);
    rawData->size--;
  }

  return rawData;
}

struct rawdata *ParseRaw(register char *mem, register char *rawName, register int size)
{
  struct rawdata *rawData = 0;

  if (size)
    if ((rawData = rmalloc(size + 1, rawName))) {
      __memcpy(rawData->rawdata, mem, size);
      rawData->size--;
    }

  return rawData;
}

bool PutRaw(register HANDLE file, register struct rawdata * rawData)
{
  if (__write(file, rawData->rawdata, rawData->size) != rawData->size)
    return FALSE;
  else
    return TRUE;
}

bool PasteRaw(register char *mem, register struct rawdata * rawData)
{
  __memcpy(mem, rawData->rawdata, rawData->size);
  return TRUE;
}
