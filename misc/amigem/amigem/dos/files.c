
FD2(5,BPTR,Open,STRPTR name,D1,LONG accessMode,D2)
{
  struct TagItem nt[1];
  BPTR fh;
  BPTR dir=NULL;
  ULONG l;

  l=strlen(name);
  if(!(n=(UBYTE *)Allocvec(l+BSTROFFSET+1,MEMF_PUBLIC)))
  {
    SetIoErr(ERROR_NO_FREE_STORE);
    return NULL;
  }
  n++;

  CopyMem(name,n,l+1);  
  *PathPart(n)=0;
  dir=Lock(n,ACCESS_READ);

  CopyMem(name,n,l+1);
  
  
  
  nt[0].ti_Tag=TAG_END;
  fh=(BPTR)AllocDosObject(DOS_FILEHANDLE,nt);
}
