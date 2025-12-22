/************************************************************************************
** Action: Get()
** Object: Sound
*/

LIBFUNC struct Sound * SND_Get(mreg(__a0) struct Stats *Stats)
{
  struct Sound *Sound;

  if (Sound = AllocMemBlock(sizeof(struct Sound), MEM_RESOURCED|Stats->MemFlags)) {
     Sound->Head.ID      = ID_SOUND;
     Sound->Head.Version = VER_SOUND;
     Public->OpenCount++;
     return(Sound);
  }
  else {
     ErrCode(ERR_FAILED);
     return(NULL);
  }
}

/************************************************************************************
** Action: Init()
** Object: Sound
**
** Initialises a sound for the play routine.  Currently this function only supports
** sounds of type IFF, but support for sound files like WAVE should be implemented
** in child modules anyway.
**
** To Do
** -----
** IFF needs to support setting of period/octave and frequency.
*/

LIBFUNC LONG SND_Init(mreg(__a0) struct Sound *Sound)
{
  LONG *lngptr, *bodyptr, filesize, read;
  struct File *file = NULL;
  LONG error = ERR_FAILED;

  if (SndAlloc IS NULL) {
     if (LIBAllocAudio() IS ERR_OK) {
        DPrintF("Init:","Audio channels allocated.");
        SndAlloc = 1;
     }
     else DPrintF("!Init:","Could not allocate audio channels from the OS.");
  }

  if ((Sound->Source) AND (Sound->prvHeader IS NULL)) {
     if (file = Get(ID_FILE|GET_NOTRACK)) {
        file->Source = Sound->Source;
        file->Flags  = FL_READ|FL_OLDFILE|FL_FIND;

        if (Init(file, NULL)) {
           if ((filesize = GetFSize(file)) > 0) {
              if (Sound->prvHeader = AllocMemBlock(filesize, MEM_SOUND)) {
                 if ((read = Read(file, Sound->prvHeader, filesize)) != filesize) {
                    DPrintF("!Init:","Error - could only read %ld of %ld bytes.",read,filesize);
                    goto exit;
                 }
              }
              else {
                 ErrCode(ERR_MEMORY);
                 goto exit;
              }
           }
           else {
              DPrintF("!Init:","Could not obtain a file size.");
              goto exit;
           }
        }
        else goto exit;
     }
     else goto exit;
  }

  if (lngptr = Sound->prvHeader) {
     if ((lngptr[0] != CODE_FORM) OR (lngptr[2] != CODE_8SVX)) {
        DPrintF("Init:","Sound file identified as being raw data.");

        Sound->Length = GetMemSize(Sound->prvHeader);
        if (Sound->Data IS NULL) {
           Sound->Data = Sound->prvHeader;
        }
     }
     else {
        DPrintF("Init:","Processing IFF Sound file.");

        if (bodyptr = FindHeader(lngptr, CODE_BODY)) {
           if (Sound->Length IS NULL) {
              Sound->Length = bodyptr[-1];
           }

           if (Sound->Data IS NULL) {
              Sound->Data = bodyptr;
           }
        }
        else {
           DPrintF("!Init:","IFF BODY header not found!");
           goto exit;
        }
     }
  }
  else {
     DPrintF("!Init:","No Sound->prvHeader.");
     goto exit;
  }

  if (Sound->Octave IS NULL) Sound->Octave = OCT_C2;
  if (Sound->Volume IS NULL) Sound->Volume = 100;
  error = ERR_OK;

exit:
  if (file) Free(file);

  if (error IS ERR_OK) {
     SoundCount++;      /* Keep a counter of initialised Sounds in the system */
  }
  else {
     FreeMemBlock(Sound->prvHeader);
     Sound->prvHeader = NULL;
  }

  return(error);
}

/************************************************************************************
** Action: Load()
** Object: Sound
*/

LIBFUNC struct Sound * SND_Load(mreg(__a0) struct File *Source)
{
  return(InitTags(NULL,
    TAGS_SOUND,  NULL,
    SA_Source, Source,
    TAGEND));
}

/************************************************************************************
** Action: Free()
** Object: Sound
*/

LIBFUNC void SND_Free(mreg(__a0) struct Sound *Sound)
{
  if (Sound->prvHeader) {
     FreeMemBlock(Sound->prvHeader);
  }

  Public->OpenCount--;
  SoundCount--;

  if ((SoundCount IS NULL) AND (SndAlloc != NULL)) {
      LIBFreeAudio();
      SndAlloc = NULL;
  }
}

