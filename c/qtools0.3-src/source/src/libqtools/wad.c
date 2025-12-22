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
#include "../include/libqdisplay.h"

/*
 * WAD2-tools
 *
 * entryName    == 0 -> OP_EXTRACT all
 * destDir == 0 -> OP_EXTRACT to current directory
 */

bool CheckWAD2(HANDLE wadFile, struct wadheader * Header, bool newWad)
{
  if (wadFile) {
    __lseek(wadFile, 0, SEEK_END);
    if (!__ltell(wadFile)) {
      if (newWad) {
	/* file is new */
	Header->magic.integer = BigLong(MAGIC_WAD2);
	Header->offset = LittleLong(sizeof(struct wadheader));

	Header->numentries = LittleLong(0);
	__write(wadFile, Header, sizeof(struct wadheader));

	return TRUE;
      }
      else
	return FALSE;
    }
    else {
      __lseek(wadFile, 0, SEEK_SET);
      __read(wadFile, Header, sizeof(struct wadheader));

      return Header->magic.integer == BigLong(MAGIC_WAD2) ? TRUE : FALSE;
    }
  }
  else
    return FALSE;
}

struct wadentry *SearchWAD2(char *entryName, struct wadheader *Header, struct wadentry *allEntries, filetype wadType)
{
  int i;

  for (i = 0; i < LittleLong(Header->numentries); i++) {
    if (!fnmatch(entryName, allEntries->name, FNM_PATHNAME))
      /* if ((allEntries->type == wadType) || (wadType == TYPE_UNKNOWN)) */
        return allEntries;
    allEntries++;
  }

  return 0;
}

/* findwad2 return ever one entry more than exists! */
struct wadentry *FindWAD2(HANDLE wadFile, char *entryName, struct wadheader *Header, struct wadentry **Entry, filetype wadType)
{
  struct wadentry *allEntries;

  __lseek(wadFile, LittleLong(Header->offset), SEEK_SET);
  if ((*Entry = allEntries = (struct wadentry *)tmalloc((LittleLong(Header->numentries) + 1) * sizeof(struct wadentry)))) {
    __read(wadFile, allEntries, (LittleLong(Header->numentries)) * sizeof(struct wadentry));

    if (entryName)
      return SearchWAD2(entryName, Header, allEntries, wadType);
    else
      return 0;    /* not in wadFile */
  }
  else
    return (struct wadentry *)-1;
}

struct palpic *GetWAD2Picture(HANDLE wadFile, struct wadentry *Entry)
{
  struct palpic *Picture = 0;

  __lseek(wadFile, LittleLong(Entry->offset), SEEK_SET);

  switch (Entry->type) {
    case WAD2_PALETTE:
      /* there MUST be only one palette in the wad, which is exactly the one we took above */
      if ((Picture = pmalloc(16, 16, 0, Entry->name))) {
	short int i;

	for (i = 0; i < 256; i++)
	  Picture->rawdata[i] = (unsigned char)i;
      }
      break;
    case WAD2_STATUSBAR:
    case WAD2_CONPIC:
      switch (Entry->compr) {
	case CMP_NONE:
	case CMP_MIP0:
	  Picture = GetLMP(wadFile, Entry->name);
	  break;
	case CMP_LZ77:
	case (CMP_LZ77 | CMP_MIP0):{
	    struct lump *Lump;

	    if ((Lump = (struct lump *)GetLZ77(wadFile, LittleLong(Entry->wadsize)))) {
	      Picture = ParseLMP(Lump, Entry->name);
	      tfree(Lump);
	    }
	  }
	  break;
	default:
	  break;
      }
      break;
    case WAD2_MIPMAP:
    case 0:     /* fix me!!! this is bogus */
      switch (Entry->compr) {
	case CMP_NONE:
	case CMP_MIP0:
	  Picture = GetMipMap(wadFile, MIPMAP_0);
	  break;
	case CMP_LZ77:
	case (CMP_LZ77 | CMP_MIP0):{
	    struct mipmap *MipMap;

	    if ((MipMap = (struct mipmap *)GetLZ77(wadFile, LittleLong(Entry->wadsize)))) {
	      Picture = ParseMipMap(MipMap, MIPMAP_0);
	      tfree(MipMap);
	    }
	  }
	  break;
	default:
	  break;
      }
      break;
    default:
      break;
  }
  return Picture;
}

struct rawdata *GetWAD2Raw(HANDLE wadFile, struct wadentry *Entry)
{
  struct rawdata *rawData = 0;

  __lseek(wadFile, LittleLong(Entry->offset), SEEK_SET);

  switch (Entry->compr) {
    case CMP_NONE:
      rawData = GetRaw(wadFile, Entry->name, LittleLong(Entry->wadsize));
      break;
    case CMP_MIP0:{
	struct palpic *MipMap;

	if ((MipMap = GetMipMap(wadFile, MIPMAP_0))) {
	  if ((rawData = rmalloc(MIP_MULT(LittleLong(MipMap->width) * LittleLong(MipMap->height)) + sizeof(struct mipmap), Entry->name)))
	    PasteMipMap((struct mipmap *)rawData->rawdata, MipMap);
	  pfree(MipMap);
	}
      }
      break;
    case CMP_LZ77:{
	char *Data;

	if ((Data = GetLZ77(wadFile, LittleLong(Entry->wadsize)))) {
	  rawData = ParseRaw(Data, Entry->name, LittleLong(Entry->memsize));
	  tfree(Data);
	}
      }
      break;
    case (CMP_LZ77 | CMP_MIP0):{
	struct mipmap *GetMip;
	struct palpic *MipMap;

	if ((GetMip = (struct mipmap *)GetLZ77(wadFile, LittleLong(Entry->wadsize)))) {
	  if ((MipMap = ParseMipMap(GetMip, MIPMAP_0))) {
	    if ((rawData = rmalloc(MIP_MULT(LittleLong(MipMap->width) * LittleLong(MipMap->height)) + sizeof(struct mipmap), Entry->name)))
	      PasteMipMap((struct mipmap *)rawData->rawdata, MipMap);
	    pfree(MipMap);
	  }
	  tfree(GetMip);
	}
      }
      break;
    default:
      break;
  }

  return rawData;
}

bool ExtractWAD2(HANDLE wadFile, FILE * script, char *destDir, char *entryName, unsigned char outType, operation procOper, filetype wadType)
{
  struct wadheader Header;
  struct wadentry *Entry, *allEntries;
  struct rgb *oldCache = cachedPalette;
  bool retval = FALSE;

  if (CheckWAD2(wadFile, &Header, FALSE)) {
    /* we assume that the dir is at the end of the file!!!!! */
    switch ((long int)(Entry = FindWAD2(wadFile, entryName, &Header, &allEntries, wadType))) {
      case -1:
	eprintf(failed_memory, (LittleLong(Header.numentries) + 1) * sizeof(struct wadentry), "wadentries");
	break;
      case 0:
	if ((entryName) && (*entryName != '\0') && (outType != TYPE_WAD2)) {
	  eprintf("no entry %s found in wad\n", entryName);
	  break;
	}
      default:{
	  struct rgb *Palette;
	  int i, parseCount;

	  parseCount = LittleLong(Header.numentries);
	  retval = TRUE;
	  Palette = 0;

	  if (!((outType == TYPE_NONE) || (outType == TYPE_RAW)) &&
	      ((procOper == OP_VIEW) || (procOper == OP_EXTRACT))) {
	    /*
	     * first search for a palette in the wad-file and use that instead
	     * of default palette 
	     */
	    struct wadentry *palEntry = allEntries;

	    for (i = 0; i < parseCount; i++) {
	      if (palEntry->type == WAD2_PALETTE) {
		__lseek(wadFile, LittleLong(palEntry->offset), SEEK_SET);
		switch (palEntry->compr) {
		  case CMP_NONE:
		  case CMP_MIP0:
		    if ((Palette = (struct rgb *)tmalloc(256 * 3)))
		      __read(wadFile, Palette, 256 * 3);
		    break;
		  case CMP_LZ77:
		  case (CMP_LZ77 | CMP_MIP0):
		    Palette = (struct rgb *)GetLZ77(wadFile, LittleLong(palEntry->wadsize));
		    break;
		  default:
		    break;
		}
		mprintf("use wads built-in palette\n");
		break;
	      }
	      palEntry++;
	    }

	    /* we take the new palette for conversions */
	    if (!Palette)
	      Palette = GetPalette();
	    else
	      cachedPalette = Palette;
	  }

	  /* process only ONE */
	  if (Entry && (outType != TYPE_WAD2)) {
	    i = Entry - allEntries;
	    parseCount = i + 1;
	  }
	  /* reset and process ALL */
	  else {
	    i = 0;
	    Entry = allEntries;
	  }

	  for (; i < parseCount; i++, Entry++) {
	    char fileName[NAMELEN_PATH];
	    
	    strnlower(Entry->name, NAMELEN_WAD);
	    
	    __strncpy(fileName, destDir, NAMELEN_PATH - 1);
	    __strncat(fileName, Entry->name, NAMELEN_PATH - 1);

	    if (outType == TYPE_NONE) {
	      AppendType(fileName, Entry->type, ".xxx");
	      switch (Entry->type) {
		case WAD2_STATUSBAR:
		case WAD2_CONPIC:	outType = TYPE_LUMP;   break;
		case WAD2_MIPMAP:	outType = TYPE_MIPMAP; break;
		case WAD2_PALETTE:
		default:		outType = TYPE_NONE;   break;
	      }
	    }
	    else
	      AppendType(fileName, outType, ".xxx");

	    /* this is bad style, and only fixes the missing raw-lump specifier fo wad-files */
	    if (!__strcmp(Entry->name, "colormap") ||
		!__strcmp(Entry->name, "conchars"))
	      ReplaceExt(fileName, "xxx");

	    switch (procOper) {
	      case OP_EXTRACT:
		if (outType == TYPE_WAD2) {
		  struct rawdata *rawData;

		  mprintf(oper_extract, Entry->name, entryName);
		  if ((rawData = GetWAD2Raw(wadFile, Entry))) {
		    retval = AddWAD2(0, rawData, entryName, OP_ADD, Entry->type);
		    rfree(rawData);
		  }
		  else
		    retval = FALSE;
		}
		else {
		  FILE *fileDst;

		  mprintf(oper_extract, Entry->name, fileName);
		  CreatePath(fileName);
		  if ((fileDst = __fopen(fileName, F_WRITE_BINARY))) {
		    /* these are special types */
		    /* this is bad style, and only fixes the missing raw-lump specifier fo wad-files */
	            if (!__strcmp(Entry->name, "colormap") ||
			!__strcmp(Entry->name, "conchars") ||
			(outType == TYPE_NONE)) {
		      struct rawdata *rawData;

		      if ((rawData = GetWAD2Raw(wadFile, Entry))) {
			retval = PutRaw(fileno(fileDst), rawData);
			rfree(rawData);
		      }
		      else
		        retval = FALSE;
		    }
		    else {
		      struct palpic *Picture;

		      if ((Picture = GetWAD2Picture(wadFile, Entry))) {
			switch (outType) {
			  case TYPE_LUMP:   retval = PutLMP(fileno(fileDst), Picture);    break;
			  case TYPE_MIPMAP: retval = PutMipMap(fileno(fileDst), Picture); break;
			  default:	    retval = PutImage(fileDst, Picture, outType); break;
			}
			pfree(Picture);
		      }
		      else
		        retval = FALSE;
		    }
		    __fclose(fileDst);
		  }
		  else
		    eprintf(failed_fileopen, fileName);
		}
		break;
	      case OP_VIEW:{
		  struct palpic *Picture;

		  mprintf(oper_view, Entry->name, fileName);
		  /* these are special types */
		  /* this is bad style, and only fixes the missing raw-lump specifier fo wad-files */
	          if (!__strcmp(Entry->name, "colormap") ||
		      !__strcmp(Entry->name, "conchars")) {
		    struct rawdata *rawPicture;
		    
		    if ((rawPicture = GetWAD2Raw(wadFile, Entry))) {
		      if (DisplayPicture(rawPicture->rawdata, Entry->name, 256, 64, 8, TRUE))
		        i = parseCount;
		      rfree(rawPicture);
		    }
		  }
		  else if ((Picture = GetWAD2Picture(wadFile, Entry))) {
		    if (Entry->type != WAD2_MIPMAP) {
		      if (DisplayPicture(Picture->rawdata, Picture->name, Picture->width, Picture->height, 8, TRUE))
		        i = parseCount;
		    }
		    else {
		      if (DisplayMipMap(Picture->rawdata, Picture->name, Picture->width, Picture->height, 8, TRUE))
		        i = parseCount;
		    }
		    pfree(Picture);
		  }
		  else
		    retval = FALSE;
		}
		break;
	      case OP_DELETE:{
		  int diff, last;

		  diff = LittleLong(Entry->wadsize);
		  last = LittleLong(Entry->offset);

		  mprintf(oper_delete, Entry->name, fileName);
		  /* delete from disk */
		  __lseek(wadFile, last, SEEK_SET);
		  if ((retval = CutOff(wadFile, diff, 0))) {
		    int content;

		    /* correct header */
		    content = LittleLong(Header.numentries) - 1;
		    Header.numentries = LittleLong(content);
		    Header.offset = LittleLong(LittleLong(Header.offset) - diff);

		    /* delete from memlist */
		    __memcpy(Entry, Entry + 1, (content - i) * sizeof(struct wadentry));
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
		    __lseek(wadFile, 0, SEEK_SET);
		    __write(wadFile, &Header, sizeof(struct wadheader));

		    /* dump entries */
		    __lseek(wadFile, LittleLong(Header.offset), SEEK_SET);
		    __write(wadFile, allEntries, LittleLong(Header.numentries) * sizeof(struct wadentry));

		    /* cut off removed entry */
		    retval = CutOff(wadFile, sizeof(struct wadentry), 0);
		  }
		}
		break;
	      case OP_LIST:
	      case OP_DEFAULT:
	      default:
		mprintf("%16s %8d (%8d bytes, offset: %8x, type: %c, compr: %1d)\n", Entry->name, LittleLong(Entry->wadsize), LittleLong(Entry->memsize), LittleLong(Entry->offset), Entry->type, (int)Entry->compr);
		break;
	    }

	    if (script)
	      fprintf(script, "update %s as %s as %c\n", fileName, Entry->name, Entry->type);
	  }
	}
	break;
    }
    tfree(allEntries);
  }
  else
    eprintf("no valid wadfile\n");

  cachedPalette = oldCache;
  return retval;
}

/*
 * inputs:
 *  inPic  - a picture that should be converted to the wadtype, that is a high-level-call
 *  inData - some data, we dont know what it is, and what wadType it should be
 *  Entry  - the entry we associate the data to, type must be set before, wadsize and mem-
 *           size will be set by the routine
 *
 * in compression-case the size of rawData is wrong, ever expect the entry-sizes are the
 * right ones, never the rawdata-sizes
 */
struct rawdata *PutWAD2Raw(struct palpic *inPic, struct rawdata *inData, struct wadentry *Entry)
{
  struct rawdata *rawData = 0;
  int newsize;
  
  if (inData) {
    switch (Compression & CMP_LZ77) {
      case CMP_NONE:
        rawData = inData;
        newsize = rawData->size;
	break;
      case CMP_LZ77:
	if((rawData = rmalloc(inData->size * 2, inData->name)))
	  if((newsize = PasteLZ77(rawData->rawdata, (char *)inData->rawdata, inData->size)) <= ERROR) {
	    rfree(rawData);
	    rawData = 0;
	  }
	break;
    }

    if(rawData) {
      Entry->memsize = LittleLong(rawData->size);
      Entry->wadsize = LittleLong(newsize);
    }
  }
  else if (inPic) {
    /*
     * convert all the different types to rawData and then recall
     * PutWADRaw itself to handle compression after all
     */
    switch (Entry->type) {
      case WAD2_PALETTE:
	if((rawData = rmalloc(256 * 3, inPic->name)))
	  __memcpy(rawData->rawdata, inPic->palette, 256 * 3);
	break;
      case WAD2_MIPMAP:
	switch (Compression & CMP_MIP0) {
	  case CMP_NONE:
	    if((rawData = rmalloc(MIP_MULT(inPic->width * inPic->height) + sizeof(struct mipmap), inPic->name)))
	      if(!PasteMipMap((struct mipmap *)rawData->rawdata, inPic)) {
	        rfree(rawData);
	        rawData = 0;
	      }
	    break;
	  case CMP_MIP0:
	    if((rawData = rmalloc((inPic->width * inPic->height) + sizeof(struct mipmap), inPic->name)))
	      if(!PasteMipMap0((struct mipmap *)rawData->rawdata, inPic)) {
	        rfree(rawData);
	        rawData = 0;
	      }
	    break;
	}
	break;
      case WAD2_STATUSBAR:
      case WAD2_CONPIC:
	if((rawData = rmalloc((inPic->width * inPic->height) + sizeof(struct lump), inPic->name)))
	  if(!PasteLMP((struct lump *)rawData->rawdata, inPic)) {
	    rfree(rawData);
	    rawData = 0;
	  }
	break;
      default:
	eprintf("you must specify the wad-entry-type\n");
	break;
    }

    if(rawData) {
      if (Compression & CMP_LZ77) {
        struct rawdata *cmpData;
    
        cmpData = PutWAD2Raw(0, rawData, Entry);
        rfree(rawData);
        rawData = cmpData;
      }
      else
        Entry->memsize = Entry->wadsize = LittleLong(rawData->size);
    }
  }
  else
    eprintf("nothing to add\n");

  Entry->compr = Compression;
  return rawData;
}

bool AddWAD2(struct palpic *inPic, struct rawdata *inData, char *wadName, operation procOper, filetype wadType)
{
  char *procName;
  HANDLE wadFile = __open(wadName, H_READWRITE_BINARY_OLD);
  struct wadheader Header;
  struct wadentry *Entry, *allEntries;
  bool retval = FALSE;

  if (wadFile < 0)
    wadFile = __open(wadName, H_READWRITE_BINARY_NEW);

  if (wadFile > 0) {
    if (CheckWAD2(wadFile, &Header, TRUE)) {
      if (inPic)
	procName = inPic->name;
      else if (inData)
	procName = inData->name;

      strlower(procName);

      /* we assume that the dir is at the end of the file!!!!! */
      switch ((long int)(Entry = FindWAD2(wadFile, procName, &Header, &allEntries, wadType))) {
	case -1:
	  eprintf(failed_memory, LittleLong(Header.numentries) * sizeof(struct wadentry), "wadentries");

	  break;
	case 0:
	  strnlower(Entry->name, NAMELEN_WAD);

	  switch (procOper) {
	    case OP_REPLACE:
	      eprintf("no entry %s found to replace in wad %s\n", procName, wadName);
	      break;
	    case OP_UPDATE:
	      mprintf(oper_update, Entry->name[0] ? Entry->name : procName, wadName);
	      goto skip3;
	    case OP_ADD:
	    case OP_DEFAULT:
	    default:
	      mprintf(oper_add, Entry->name[0] ? Entry->name : procName, wadName);
	    skip3:
	      __lseek(wadFile, LittleLong(Header.offset), SEEK_SET);
	      /*
	       * seek to end of data and write data
	       */
	      Entry = allEntries + LittleLong(Header.numentries);
	      Entry->offset = Header.offset;
	      Entry->type = wadType;

	      if (inData) {
		switch (Compression) {
		  case CMP_NONE:
		  case CMP_MIP0:
		    retval = PutRaw(wadFile, inData);
		    break;
		  case CMP_LZ77:
		  case (CMP_MIP0 | CMP_LZ77):{
		      retval = PutLZ77(wadFile, (char *)inData->rawdata, inData->size) > ERROR ? TRUE : FALSE;
		      Entry->memsize = LittleLong(inData->size);
		    }
		    break;
		  default:
		    break;
		}
	      }
	      else if (inPic) {
		switch (wadType) {
		  case WAD2_PALETTE:
		    switch (Compression) {
		      case CMP_NONE:
		      case CMP_MIP0:
			if (__write(wadFile, inPic->palette, 256 * 3) == (256 * 3)) {
			  retval = TRUE;
			}
			break;
		      case CMP_LZ77:
		      case (CMP_MIP0 | CMP_LZ77):{
			  retval = PutLZ77(wadFile, (char *)inPic->palette, (256 * 3)) > ERROR ? TRUE : FALSE;
			  Entry->memsize = LittleLong(256 * 3);
			}
			break;
		      default:
			break;
		    }
		    break;
		  case WAD2_MIPMAP:
		    switch (Compression) {
		      case CMP_NONE:
			retval = PutMipMap(wadFile, inPic);
			break;
		      case CMP_MIP0:
			retval = PutMipMap0(wadFile, inPic);
			break;
		      case CMP_LZ77:{
			  struct mipmap *MipMap;

			  if ((MipMap = (struct mipmap *)tmalloc(MIP_MULT(inPic->width * inPic->height) + sizeof(struct mipmap)))) {
			    if ((retval = PasteMipMap(MipMap, inPic))) {
			      retval = PutLZ77(wadFile, (char *)MipMap, MIP_MULT(inPic->width * inPic->height) + sizeof(struct mipmap)) > ERROR ? TRUE : FALSE;
			      Entry->memsize = LittleLong(MIP_MULT(inPic->width * inPic->height) + sizeof(struct mipmap));
			    }
			    tfree(MipMap);
			  }
			}
			break;
		      case (CMP_MIP0 | CMP_LZ77):{
			  struct mipmap *MipMap;

			  if ((MipMap = (struct mipmap *)tmalloc((inPic->width * inPic->height) + sizeof(struct mipmap)))) {
			    if ((retval = PasteMipMap0(MipMap, inPic))) {
			      retval = PutLZ77(wadFile, (char *)MipMap, (inPic->width * inPic->height) + sizeof(struct mipmap)) > ERROR ? TRUE : FALSE;
			      Entry->memsize = LittleLong((inPic->width * inPic->height) + sizeof(struct mipmap));
			    }
			    tfree(MipMap);
			  }
			}
			break;
		      default:
			break;
		    }
		    break;
		  case WAD2_STATUSBAR:
		  case WAD2_CONPIC:
		    switch (Compression) {
		      case CMP_NONE:
		      case CMP_MIP0:
			retval = PutLMP(wadFile, inPic);
			break;
		      case CMP_LZ77:
		      case (CMP_MIP0 | CMP_LZ77):{
			  struct lump *Lump;

			  if ((Lump = (struct lump *)tmalloc((inPic->width * inPic->height) + sizeof(struct lump)))) {
			    if ((retval = PasteLMP(Lump, inPic))) {
			      retval = PutLZ77(wadFile, (char *)Lump, (inPic->width * inPic->height) + sizeof(struct lump)) > ERROR ? TRUE : FALSE;
			      Entry->memsize = LittleLong(MIP_MULT(inPic->width * inPic->height) + sizeof(struct lump));
			    }
			    tfree(Lump);
			  }
			}
			break;
		      default:
			break;
		    }
		    break;
		  default:
		    eprintf("you must specify the wad-entry-type\n");
		    break;
		}
	      }
	      else
		eprintf("nothing to add\n");

	      if (retval) {
		Entry->wadsize = LittleLong(__ltell(wadFile) - LittleLong(Header.offset));
		if ((Entry->compr = Compression) == CMP_NONE)
		  Entry->memsize = Entry->wadsize;
		__strncpy(Entry->name, procName, NAMELEN_WAD);
		Header.numentries = LittleLong(LittleLong(Header.numentries) + 1);
		Header.offset = LittleLong(__ltell(wadFile));
		/* write directory */
		if (__write(wadFile, allEntries, LittleLong(Header.numentries) * sizeof(struct wadentry)) == (LittleLong(Header.numentries) * sizeof(struct wadentry))) {
		  /* write header */
		  __lseek(wadFile, 0, SEEK_SET);
		  __write(wadFile, &Header, sizeof(struct wadheader));
		}
		else {
		  eprintf(failed_filewrite, wadName);
		  retval = FALSE;
		}
	      }
	      else
		eprintf("cannot write data %c %s to wad %s\n", wadType, procName, wadName);
	      break;
	  }
	  tfree(allEntries);
	  break;
	default:
	  strnlower(Entry->name, NAMELEN_WAD);

	  switch (procOper) {
	    case OP_REPLACE:
	      mprintf(oper_replace, Entry->name[0] ? Entry->name : procName, wadName);
	      goto skip4;
	    case OP_UPDATE:
	      mprintf(oper_update, Entry->name[0] ? Entry->name : procName, wadName);
	    skip4:{
#if 0
		int diff, last;

		diff = LittleLong(Entry->wadsize);
		last = LittleLong(Entry->offset);

		if((writeData = PutWAD2Raw(inPic, inData, Entry))) {
		  diff -= LittleLong(Entry->wadsize);

		  __lseek(wadFile, last, SEEK_SET);
		  if (diff > 0) {
		    if (CutOff(wadFile, diff, 0))
		      retval = TRUE;
		  }
		  else if (diff < 0) {
		    if (PasteIn(wadFile, -diff, 0))
		      retval = TRUE;
		  }

		  if (retval) {
		    int content;

		    /* dump data */
		    __lseek(wadFile, last, SEEK_SET);
		    __write(wadfile, writeData->rawdata, LittleLong(Entry->wadsize));

		    /* correct header */
		    content = LittleLong(Header.numentries);
		    Header.offset = LittleLong(LittleLong(Header.offset) - diff);

		    /* correct all following offsets */
		    while (content--)
		      /* correct all, that come afterwards */
		      if (LittleLong(allEntries[content].offset) >= last)
		        allEntries[content].offset = LittleLong(LittleLong(Entry->offset) - diff);

		    /* correct entry */
		    Entry->offset = LittleLong(last);

		    /* dump header */
		    __lseek(wadFile, 0, SEEK_SET);
		    __write(wadFile, &Header, sizeof(struct packheader));

		    /* dump entries */
		    __lseek(wadFile, LittleLong(Header.offset), SEEK_SET);
		    __write(wadFile, &allEntries, LittleLong(Header.size));
		  }
		}
#endif
	      }
	      break;
	    case OP_ADD:
	    case OP_DEFAULT:
	    default:
	      eprintf("old entry %s found in wad %s\n", procName, wadName);
	      break;
	  }
	  tfree(allEntries);
	  break;
      }
      __close(wadFile);
    }
    else
      eprintf("no valid wadfile %s\n", wadName);
  }
  else
    eprintf(failed_fileopen, wadName);

  return retval;
}
