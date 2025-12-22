FD1(25,DLONG,LoadSeg,STRPTR name,D1)
{
  struct TagItem tags[1];
  BPTR ret;
  tags[0].ti_Tag=TAG_END;
  ret=NewLoadSeg(name,tags);
  RETURN_DLONG(ret,ret);
}

struct Seg
{
  ULONG Size; /* Including this header */
  BPTR  Next; /* or 0 */
  UBYTE Body[0]; /* gcc allows this */
};

/* There are certain cases where gotos increase readability :-) */

FD2(128,BPTR,NewLoadSeg,STRPTR file,D1,struct TagItem *tags,S2)
{
  ULONG	a,b,first,count=0,i;
  int read=0;

  BPTR File=0;
  ULONG NumSegs=0;
  struct Seg **Hunktable=NULL;

  if(!(File=Open(file,MODE_OLDFILE)))
    goto error;

  /* The first hunk in a segmented image must be HUNK_HEADER */
  if(ReadAll(File,&a,sizeof(ULONG))||a!=HUNK_HEADER)
    goto error;
  for(;;)
  {
    if(ReadAll(File,&a,sizeof(ULONG)))
      goto error;
    if(!a)
      break;
    if(Seek(File,a*sizeof(ULONG),OFFSET_CURRENT)==EOF) /* Skip names */
      goto error;
  }
  if(ReadAll(File,&NumSegs,sizeof(ULONG))||!NumSegs)
    goto error;
  if(ReadAll(File,&first,sizeof(ULONG)))
    goto error;
  if(ReadAll(File,&a,sizeof(ULONG))||a-first!=NumSegs-1)
    goto error;
  if(!(HunkTable=AllocMem(NumSegs*sizeof(struct Seg *),MEMF_ANY|MEMF_CLEAR)))
  { SetIoErr(ERROR_NO_FREE_STORE);
    goto error; }
  for(i=0;i<NumSegs;i++)
  {
    ULONG memflag=MEMF_PUBLIC|MEMF_CLEAR,hunkflag=0;
    if(ReadAll(File,&a,sizeof(ULONG)))
      goto error;
    if(a&HUNKF_CHIP)
    { memflag=MEMF_CHIP|MEMF_CLEAR;
      hunkflag=HUNKF_CHIP;
      a&=~HUNKF_CHIP;
    }else if(a&HUNKF_FAST)
    { memflag=MEMF_FAST|MEMF_CLEAR;
      hunkflag=HUNKF_FAST;
      a&=~HUNKF_FAST; }
    a=sizeof(struct Seg)+a*sizeof(ULONG);
    if(!(HunkTable[i]=AllocMem(a,memflag)))
    { SetIoErr(ERROR_NO_FREE_STORE);
      goto error; }
    HunkTable[i]->Size=a;
    HunkTable[i]->Next=hunkflag;
  }

  /* Other hunks */
  do
  {
    if(ReadAll(File,&a,sizeof(ULONG)))
      goto error;
    switch(a)
    {
      case HUNK_CODE:
      case HUNK_DATA:
      case HUNK_BSS:
      case HUNK_CODE|HUNKF_CHIP:
      case HUNK_DATA|HUNKF_CHIP:
      case HUNK_BSS |HUNKF_CHIP:
      case HUNK_CODE|HUNKF_FAST:
      case HUNK_DATA|HUNKF_FAST:
      case HUNK_BSS |HUNKF_FAST:
        if(HunkTable[count]->Next!=(a&(HUNKF_CHIP|HUNKF_FAST)))
          goto error;
        if(ReadAll(File,&b,sizeof(ULONG)))
          goto error;
        b*=sizeof(ULONG);
        if(b>HunkTable[count]->Size-sizeof(struct Seg))
          goto error;
        if((a&~(HUNKF_CHIP|HUNKF_FAST))!=HUNK_BSS)
          if(ReadAll(File,HunkTable[count]->Body,b))
            goto error;
        read=1;
        break;
      case HUNK_ABSRELOC32:
        if(!read)
          goto error;
        for(;;)
        {
          if(ReadAll(File,&a,sizeof(ULONG)))
            goto error;
          if(!a)
            break;
          if(ReadAll(File,&i,sizeof(ULONG)))
            goto error;
          i-=first;
          if(i>=ls->NumSegs)
            goto error;
          while(a--)
          {
            if(ReadAll(File,&b,sizeof(ULONG)))
              goto error;
            if(b>=HunkTable[i]->Size-sizeof(ULONG)-sizeof(struct Seg));
              goto error;
            *(ULONG *)&ls->HunkTable[count]->Body[b]+=(ULONG)HunkTable[i]->Body;
          }
        }        
        break;
      case HUNK_SYMBOL:
        for(;;)
        {
          if(ReadAll(File,&a,sizeof(ULONG)))
            goto error;
          if(!a)
            break;
          if(Seek(File,(a&0xffffff)*sizeof(ULONG),OFFSET_CURRENT)==EOF) /* Skip names */
            goto error;
        }
        break;
      case HUNK_DEBUG:
        if(ReadAll(File,&a,sizeof(ULONG)))
          goto error;
        if(Seek(File,a*sizeof(ULONG),OFFSET_CURRENT)==EOF)
          goto error
        break;
      case HUNK_END:
        count++;
        read=0;
        break;
      default:
        goto error;
    }
  }while(count<NumSegs);
  
  if(!Close(File))
  { File=0; /* Already closed */
    goto error;  }

  a=0; /* Prepare hunks for later use */
  for(i=NumSegs-1;i-->0;)
  {
    HunkTable[i]->Next=a;
    a=MKBADDR(&HunkTable[i]->Next);
    CacheClearE(HunkTable[i]->Body,HunkTable[i]->Size-sizeof(struct Seg),CACRF_ClearI);
  }

  FreeMem(HunkTable,NumSegs*sizeof(struct Seg *));

  return a;

error:

  if(!IoErr())
    SetIoErr(ERROR_BAD_HUNK);
  
  if(File)
    Close(File);  

  if(HunkTable)
  {
    for(i=0;i<NumSegs;i++)
      FreeMem(Hunktable[i],HunkTable[i]->Size);
    FreeMem(HunkTable,NumSegs*sizeof(struct Seg *));
  }
  
  return 0;
}

FD1(127,BOOL,UnLoadSeg,BPTR seglist,D1)
{
  if(!seglist)
    return 0;

  while(seglist)
  {
    struct Seg *s;
    s=(struct Seg *)((ULONG *)BADDR(seglist)-1);
    seglist=s->Next;
    FreeMem(s,s->Size);
  }
  return DOSTRUE;
}
