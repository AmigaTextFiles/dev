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
 * PAK-tools
 *
 * entryName    == 0  -> OP_EXTRACT all
 * destDir == 0  -> OP_EXTRACT to current directory
 */

/*
 *
 */

bool CheckPAK(HANDLE pakFile, struct packheader *Header, bool newWad)
{
  if (pakFile) {
    __lseek(pakFile, 0, SEEK_END);
    if (!__ltell(pakFile)) {
      if (newWad) {
	/*
	 * file is new 
	 */
	Header->magic.integer = BigLong(MAGIC_PACK);
	Header->offset = LittleLong(sizeof(struct packheader));

	Header->size = LittleLong(0);
	__write(pakFile, Header, sizeof(struct packheader));

	return TRUE;
      }
      else
	return FALSE;
    }
    else {
      __lseek(pakFile, 0, SEEK_SET);
      __read(pakFile, Header, sizeof(struct packheader));

      return Header->magic.integer == BigLong(MAGIC_PACK) ? TRUE : FALSE;
    }
  }
  else
    return FALSE;
}

struct packentry *SearchPAK(char *entryName, struct packheader *Header, struct packentry *allEntries)
{
  int i;

  for (i = 0; i < (LittleLong(Header->size) / sizeof(struct packentry)); i++) {
    if (!fnmatch(entryName, allEntries->name, FNM_PATHNAME))
      return allEntries;
    allEntries++;
  }
  return 0;
}

/* findpak return ever one entry more than exists! */
struct packentry *FindPAK(HANDLE pakFile, char *entryName, struct packheader *Header, struct packentry **Entry)
{
  struct packentry *allEntries;

  __lseek(pakFile, LittleLong(Header->offset), SEEK_SET);
  if ((*Entry = allEntries = (struct packentry *)tmalloc(LittleLong(Header->size) + sizeof(struct packentry)))) {
    __read(pakFile, allEntries, LittleLong(Header->size));
    if (entryName)
      return SearchPAK(entryName, Header, allEntries);
    else
      return 0;    /* not in pakfile */
  }
  else
    return (struct packentry *)-1;
}

bool ExtractPAK(HANDLE pakFile, FILE * script, char *destDir, char *entryName, unsigned char outType, operation procOper, bool recurse)
{
  struct packheader Header;
  struct packentry *Entry, *allEntries;
  bool retval = FALSE;

  if (CheckPAK(pakFile, &Header, FALSE)) {
    /* we assume that the dir is at the end of the file!!!!! */
    switch ((long int)(Entry = FindPAK(pakFile, entryName, &Header, &allEntries))) {
      case -1:
	eprintf(failed_memory, LittleLong(Header.size) + sizeof(struct packentry), "packentries");
	break;
      case 0:
	if ((entryName) && (*entryName != '\0')) {
	  eprintf("no entry %s found in pak\n", entryName);
	  break;
	}
      default:{
	  int i, parseCount;
	  
	  parseCount = (LittleLong(Header.size) / sizeof(struct packentry));
	  retval = TRUE;

	  /* process only ONE (case 0:) */
	  if (Entry) {
	    i = Entry - allEntries;
	    parseCount = i + 1;
	  }
	  /* reset and process ALL (default:) */
	  else {
	    i = 0;
	    Entry = allEntries;
	  }

	  for (; i < parseCount; i++, Entry++) {
	    char fileName[NAMELEN_PATH];

	    strnlower(Entry->name, NAMELEN_PAK);

	    __strncpy(fileName, destDir, NAMELEN_PATH - 1);
	    __strncat(fileName, Entry->name, NAMELEN_PATH - 1);

	    switch (procOper) {
	      case OP_EXTRACT:{
		  HANDLE fileDst;

		  mprintf(oper_extract, Entry->name, fileName);
		  CreatePath(fileName);

		  if ((fileDst = __open(fileName, H_WRITE_BINARY)) > 0) {
		    struct rawdata *rawData;

		    __lseek(pakFile, LittleLong(Entry->offset), SEEK_SET);
		    if ((rawData = GetRaw(pakFile, Entry->name, LittleLong(Entry->size)))) {
		      retval = PutRaw(fileDst, rawData);
		      rfree(rawData);
		      /* processName at this point */
		      if (recurse && retval)
			retval = processName(fileName, 0, 0, outType, 0, 0, procOper, script ? TRUE : FALSE, recurse);
		    }
		    else {
		      eprintf(failed_memory, LittleLong(Entry->size), fileName);
		      retval = FALSE;
		    }

		    __close(fileDst);
		  }
		  else {
		    eprintf(failed_fileopen, fileName);
		    retval = FALSE;
		  }
		}
		break;
	      case OP_DELETE:{
		  int diff, last;

		  diff = LittleLong(Entry->size);
		  last = LittleLong(Entry->offset);

		  mprintf(oper_delete, Entry->name, fileName);
		  /* delete from disk */
		  __lseek(pakFile, last, SEEK_SET);
		  if ((retval = CutOff(pakFile, diff, 0))) {
		    int content;

		    /* correct header */
		    content = LittleLong(Header.size) / sizeof(struct packentry);
		    Header.size = LittleLong(LittleLong(Header.size) - sizeof(struct packentry));
		    Header.offset = LittleLong(LittleLong(Header.offset) - diff);

		    /* delete from memlist */
		    __memcpy(Entry, Entry + 1, LittleLong(Header.size));
		    /* delete from loop */
		    parseCount--;
		    i--;
		    Entry--;

		    /* correct all following offsets */
		    while (content--)
		      /* correct all, that come afterwards */
		      if (LittleLong(allEntries[content].offset) >= last)
			allEntries[content].offset = LittleLong(LittleLong(Entry->offset) - diff);

		    /* dump header */
		    __lseek(pakFile, 0, SEEK_SET);
		    __write(pakFile, &Header, sizeof(struct packheader));

		    /* dump entries */
		    __lseek(pakFile, LittleLong(Header.offset), SEEK_SET);
		    __write(pakFile, allEntries, LittleLong(Header.size));

		    /* cut off removed entry */
		    retval = CutOff(pakFile, sizeof(struct packentry), 0);
		  }
		}
		break;
	      case OP_LIST:
	      case OP_DEFAULT:
	      default:
		mprintf("%54s %8d bytes (offset: %8x)\n", Entry->name, LittleLong(Entry->size), LittleLong(Entry->offset));
		break;
	    }

	    if (script)
	      fprintf(script, "update %s as %s as %c\n", fileName, Entry->name, 'P');
	  }
	}
	break;
    }
    tfree(allEntries);
  }
  else
    eprintf("no valid pakfile\n");

  return retval;
}

bool AddPAK(struct palpic * inPic, struct rawdata * inData, char *pakName, operation procOper)
{
  char *procName;
  HANDLE pakFile = __open(pakName, H_READWRITE_BINARY_OLD);
  struct packheader Header;
  struct packentry *Entry, *allEntries;
  bool retval = FALSE;

  if (pakFile < 0)
    pakFile = __open(pakName, H_READWRITE_BINARY_NEW);

  if (pakFile > 0) {
    if (CheckPAK(pakFile, &Header, TRUE)) {
      if (inPic) {
	procName = inPic->name;
	ReplaceExt(procName, "lmp");
      }
      else if (inData)
	procName = inData->name;

      strlower(procName);

      /* we assume that the dir is at the end of the file!!!!! */
      switch ((long int)(Entry = FindPAK(pakFile, procName, &Header, &allEntries))) {
	case -1:
	  eprintf(failed_memory, LittleLong(Header.size) + sizeof(struct packentry), "packentries");
	  break;
	case 0:
	  strnlower(Entry->name, NAMELEN_WAD);

	  switch (procOper) {
	    case OP_REPLACE:
	      eprintf("no entry %s found to replace in pak %s\n", procName, pakName);
	      break;
	    case OP_UPDATE:
	      mprintf(oper_update, Entry->name[0] ? Entry->name : procName, pakName);
	      goto skip1;
	    case OP_ADD:
	    case OP_DEFAULT:
	    default:
	      mprintf(oper_add, Entry->name[0] ? Entry->name : procName, pakName);
	    skip1:
	      __lseek(pakFile, LittleLong(Header.offset), SEEK_SET);
	      /* seek to end of data */
	      Entry = allEntries + (LittleLong(Header.size) / sizeof(struct packentry));
	      Entry->offset = Header.offset;

	      if (inData)
		retval = PutRaw(pakFile, inData);
	      else if (inPic)
		retval = PutLMP(pakFile, inPic);
	      else
		eprintf("nothing to add\n");

	      if (retval) {
		Entry->size = LittleLong(__ltell(pakFile) - LittleLong(Header.offset));
		__strncpy(Entry->name, procName, NAMELEN_PAK);
		Header.size = LittleLong(LittleLong(Header.size) + sizeof(struct packentry));

		Header.offset = LittleLong(__ltell(pakFile));
		/* write directory */
		if (__write(pakFile, allEntries, LittleLong(Header.size)) == LittleLong(Header.size)) {
		  __lseek(pakFile, 0, SEEK_SET);
		  /* write header */
		  __write(pakFile, &Header, sizeof(struct packheader));
		}
		else
		  retval = FALSE;
	      }
	      else
		eprintf(failed_filewritesize, procName, pakName);

	      break;
	  }
	  tfree(allEntries);
	  break;
	default:
	  strnlower(Entry->name, NAMELEN_WAD);

	  switch (procOper) {
	    case OP_REPLACE:
	      mprintf(oper_replace, Entry->name[0] ? Entry->name : procName, pakName);
	      goto skip2;
	    case OP_UPDATE:
	      mprintf(oper_update, Entry->name[0] ? Entry->name : procName, pakName);
	    skip2:{
		int diff, last, newsize;

		newsize = (inData ? inData->size : ((inPic->width * inPic->height) + sizeof(struct lump)));

		diff = LittleLong(Entry->size) - newsize;
		last = LittleLong(Entry->offset);

		__lseek(pakFile, last, SEEK_SET);
		if (diff > 0) {
		  if (CutOff(pakFile, diff, 0))
		    retval = TRUE;
		}
		else if (diff < 0) {
		  if (PasteIn(pakFile, -diff, 0))
		    retval = TRUE;
		}

		if (retval) {
		  int content;

		  __lseek(pakFile, last, SEEK_SET);

		  if (inData)
		    retval = PutRaw(pakFile, inData);
		  else if (inPic)
		    retval = PutLMP(pakFile, inPic);

		  /* correct header */
		  content = LittleLong(Header.size) / sizeof(struct packentry);
		  Header.offset = LittleLong(LittleLong(Header.offset) - diff);

		  /* correct all following offsets */
		  while (content--)
		    /* correct all, that come afterwards */
		    if (LittleLong(allEntries[content].offset) >= last)
		      allEntries[content].offset = LittleLong(LittleLong(Entry->offset) - diff);

		  /* correct entry */
		  Entry->size = LittleLong(newsize);
		  Entry->offset = LittleLong(last);

		  /* dump header */
		  __lseek(pakFile, 0, SEEK_SET);
		  __write(pakFile, &Header, sizeof(struct packheader));

		  /* dump entries */
		  __lseek(pakFile, LittleLong(Header.offset), SEEK_SET);
		  __write(pakFile, &allEntries, LittleLong(Header.size));
		}
	      }
	      break;
	    case OP_ADD:
	    case OP_DEFAULT:
	    default:
	      eprintf("old entry %s found in pak %s\n", procName, pakName);
	      break;
	  }
	  tfree(allEntries);
	  break;
      }
      __close(pakFile);
    }
    else
      eprintf("no valid pakfile %s\n", pakName);
  }
  else
    eprintf(failed_fileopen, pakName);

  return retval;
}
