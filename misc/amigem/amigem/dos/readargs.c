LONG FindArg(STRPTR template,STRPTR keyword)
{
  LONG ret=0;
  while(*template)
  {
    char *key=keyword;
    for(;;)
    {
      if(*template=='/')
      {
        if(!*key)
          return ret;
        while(*template&&*template!=',')
          template++;
        break;
      }else if(*template=='=')
      {
        if(!*key)
          return ret;
        break;
      }else if(ToUpper(*key)!=ToUpper(*template))
      {
        while(*template&&*template!='='&&*template!=',')
          template++;
        break;
      }
      key++;
      template++;
    }
    if(*template&&*template++==',')
      ret++;
  }
  return -1;
}

#define GET(input) \
(input==0l?FGetC(Input()):input->CurChr>=input->Length?EOF:input->Buffer[input->CurChr++])
#define UNGET(input) (input==0l?UnGetC(Input(),-1):input->CurChr--)

LONG ReadItem(STRPTR buffer,LONG maxchars,struct CSource *input)
{
  int c;
  LONG ret;
  do
  {
    c=GET(input);
  }while(c==' '||c=='\t');
  if(c=='\"')
  {
    ret=ITEM_QUOTED;
    c=GET(input);
    while(c!='\"')
    {
      if(maxchars<2||c=='\n'||c==EOF)
      {
        ret=ITEM_ERROR;
        break;
      }
      maxchars--;
      if(c=='*')
      {
        c=GET(input);
        if(c=='e'||c=='E')
          c=0x1b;
        else if(c=='n'||c=='N')
          c='\n';
        else if(c=='\n'||c==EOF)
        {
          ret=ITEM_ERROR;
          break;
	}
      }
      *buffer++=c;
      c=GET(input);
    }
  }else if(c=='=')
    ret=ITEM_EQUAL;
  else
  {
    ret=ITEM_UNQUOTED;
    if(c==';'||c=='\n'||c==EOF)
      ret=ITEM_NOTHING;
    else
      do
      {
        if(maxchars<2)
        {
          ret=ITEM_ERROR;
          break;
        }
        maxchars--;
        *buffer++=c;
        c=GET(input);
      }while(c!=' '&&c!='\t'&&c!='='&&c!=';'&&c!='\n'&&c!=EOF);
  }
  if(!maxchars)
    ret=ITEM_ERROR;
  else
    *buffer++='\0';
  if(c!=EOF)
    UNGET(input);
  else if(IoErr())
    ret=ITEM_ERROR;
  return ret;
}
