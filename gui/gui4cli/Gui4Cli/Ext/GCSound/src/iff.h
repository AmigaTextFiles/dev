
// IFF 8SVX file handling routines - no stereo yet..

// ===============================================================
// LoadSample() - return new handle
// - Allocate handle, open file & fill in handle structure
// - Read in the sample (or part of it if too long) into buffers
// ===============================================================
struct myhandle *loadsample (char *filename, struct base *bs)
{
  struct myhandle *h = NULL;
  LONG   hd;
  BOOL   okflag = 0;
  struct DosLibrary *DOSBase;
  struct ExecBase *SysBase;
  DOSBase=bs->dosbase; SysBase=bs->sysbase;

  if (!(h = (struct myhandle *)AllocVec(sizeof(struct myhandle), CLEANMEM)))
  {   PutStr ("No memory!\n");
      return (NULL);
  }
  strcpy (h->path, filename);
  h->bs = bs;

  // open file
  if (!(h->fp = Open (filename, MODE_OLDFILE)))
  {   PrintFault(IoErr(), NULL);
      goto abort;
  }

  // check file & get "FORM" length
  FRead (h->fp, &hd, 4, 1);
  if (hd != ID_FORM)
  {   PutStr ("Not and IFF file!\n");
      goto abort;
  }
  Seek (h->fp, 4, OFFSET_CURRENT);  // skip length

  // check if it's an 8SVX
  FRead (h->fp, &hd, 4, 1);
  if (hd != ID_8SVX)
  {   PutStr ("Not and 8SVX file!\n");
      goto abort;
  }

  // read header structure VHDR
  if ((getchunk (ID_VHDR, h->fp, DOSBase, SysBase)) <= 0)
      goto abort;
  FRead (h->fp, &h->vh, sizeof(struct VoiceHeader), 1);
  
  // goto data
  if ((h->bodylength = getchunk (ID_BODY, h->fp, DOSBase, SysBase)) <= 0)
      goto abort;

  // store start of data position
  h->bodystart = Seek (h->fp, 0, OFFSET_CURRENT);
  
  // ---------- read in data..

  // if it's a short sample, get it & close the file
  if (h->bodylength <= BUFFER_SIZE)
  {
      h->buffsize = h->bodylength;
      h->buff1 = (UBYTE *)AllocVec(h->buffsize + 6, MEMF_CHIP | MEMF_CLEAR);
      if (!(h->buff1))
      {   PutStr ("No memory!\n");
          goto abort;
      }
      if ((Read (h->fp, h->buff1, h->buffsize)) != h->buffsize)
      {   PutStr ("Read error!\n");
          goto abort;
      }
      Close (h->fp); h->fp = NULL;
  }
  else  // long sample - use double buffering
  {
      h->buffsize = BUFFER_SIZE / 2;
      h->buff1 = (UBYTE *)AllocVec(h->buffsize + 6, MEMF_CHIP | MEMF_CLEAR);
      h->buff2 = (UBYTE *)AllocVec(h->buffsize + 6, MEMF_CHIP | MEMF_CLEAR);
      if (!(h->buff1) || !(h->buff2))
      {   PutStr ("No memory!\n");
          goto abort;
      }
      if ((Read (h->fp, h->buff1, h->buffsize)) == h->buffsize)
      {   if ((Read (h->fp, h->buff2, h->buffsize)) == h->buffsize)
              okflag = 1;
      }
      if (!okflag) goto abort;
      // do not close file
  }

  // structure filled ok..
  h->next = NULL;
  return (h);

  abort:
  if (h) freehandle (h);
  Printf ("Error parsing file %s\n", filename);
  return (NULL);
}


// ===============================================================
//  getchunk()
//  look for named chunk, return it's length or -1
//  file ptr is advanced to after the size - i.e. start of data
// ===============================================================

LONG getchunk (LONG head, BPTR fp, 
               struct DosLibrary *DOSBase, struct ExecBase *SysBase)
{
  LONG hd;
  BOOL flag = FALSE;
  LONG skip, length = -1; 	// default: return -1

  // read header:
  while (!flag && (FRead (fp, &hd, 4, 1) == 1))
  {
      // Have we found the right chunk?
      if (hd == head)
      {    // yes..
           if ((FRead (fp, &length, 4, 1)) == 1)
                return (length);
           return (-1L);
      }
      // otherwise move forward..
      if ((FRead (fp, &skip, 4, 1)) == 1)
      {   
         Seek (fp, skip, OFFSET_CURRENT);
      }
      else ++flag;
  }
  return (-1L);
}

// ===============================================================
//	initialise loaded sample - set speed etc
// ===============================================================
void initsample (struct myhandle *h, char *alias, struct base *bs)
{
   struct myhandle *hh;

   if (!h) return;
   h->speed  = bs->clock / h->vh.vh_SamplesPerSec;
   h->volume = h->vh.vh_Volume / 1024;
   h->times  = 1;
   stccpy (h->alias, alias, 35);

// Printf ("=================\n", NULL);
// Printf ("OneShot=%ld - Repeat=%ld\n", (LONG)h->vh.vh_OneShotHiSamples, (LONG)h->vh.vh_RepeatHiSamples);
// Printf ("Volume=%ld - Speed=%ld\n", h->volume, h->speed);

   // link handle
   if (!bs->toph) bs->toph = h;
   else 
   {  for (hh=bs->toph; hh->next; hh = hh->next);
      hh->next = h;
   }
}

// ===============================================================
//	reload sample
// ===============================================================
BOOL reload (struct myhandle *h)
{
   struct DosLibrary *DOSBase;
   struct ExecBase *SysBase;
   DOSBase=h->bs->dosbase; SysBase=h->bs->sysbase;
   if (!h || !h->fp) return (0);

   Seek (h->fp, h->bodystart, OFFSET_BEGINNING);
   if ((Read (h->fp, h->buff1, h->buffsize)) == h->buffsize)
   {   if ((Read (h->fp, h->buff2, h->buffsize)) == h->buffsize)
          return (1);
   }
   PutStr ("Error reading file!\n");
   return (0);
}

// ===============================================================
//  freehandle()
//  free handle , close file etc..
// ===============================================================

void freehandle (struct myhandle *h)
{
   struct DosLibrary *DOSBase;
   struct ExecBase *SysBase;
   DOSBase=h->bs->dosbase; SysBase=h->bs->sysbase;

   if (h)
   {   if (h->buff1) FreeVec (h->buff1);
       if (h->buff2) FreeVec (h->buff2);
       if (h->fp) Close (h->fp);
       FreeVec (h);
   }
}

// ===============================================================
//  remlink()
//  unlink sample, ready to free it..
// ===============================================================

void remlink (struct myhandle *h)
{
   struct base *bs;
   struct myhandle *hh;

   if (!h) return;
   bs = h->bs;
   
   if (h == bs->toph)
       bs->toph = bs->toph->next;
   else
   {   hh = bs->toph;
       while (hh && (hh->next != h)) hh = hh->next;
       if (hh) hh->next = h->next;
   }
   h->next = NULL;
}



