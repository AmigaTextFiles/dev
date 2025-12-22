#define TOUPPER(a) (a<'a'||a>'z'?a:a-'a'+'A')
#define TOLOWER(a) (a<'A'||a>'Z'?a:a-'A'+'a')

FD1(29,UBYTE,ToUpper,UBYTE char,D0)
{
  return TOUPPER(char);
}

FD1(30,UBYTE,ToLower,UBYTE char,D0)
{
  return TOLOWER(char);
}

FD2(27,LONG,Stricmp,STRPTR string1,A0,STRPTR string2,A1)
{
  LONG r;
  do
  {
    r=TOUPPER(*string1)-TOUPPER(*string2);
    string1++;
  }while(!r&&*string2++);
  return r;
}

FD3(28,LONG,Strnicmp,STRPTR string1,A0,STRPTR string2,A1,LONG length,D0)
{
  LONG r=0;
  if(length)
    do
    {
      r=TOUPPER(*string1)-TOUPPER(*string2);
      string1++;
    }while(!r&&*string2++&&--length);
  return r;
}
