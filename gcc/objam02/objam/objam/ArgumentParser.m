/*
** ObjectiveAmiga: Implementation of class ArgumentParser
** See GNU:lib/libobjam/ReadMe for details
*/


#import <objam/ArgumentParser.h>


@implementation ArgumentParser

// Initialize and free instances

- init:(void *)args with:(const char *)template
{
  if(![super init]) return nil;
  if(!(templateString=NXCopyStringBufferFromZone(template,[self zone]))) return [self free];
  if(!(rdArgs=(struct RDArgs *)AllocDosObject(DOS_RDARGS,NULL))) return [self free];
  rdArgs->RDA_Flags=RDAF_NOPROMPT;
  rdArgs->RDA_DAList=NULL;
  argSpace=(LONG*)args;
  bufLen=1024; // Currently fixed size
  return self;
}

- free
{
  if(rdArgs) FreeDosObject(DOS_RDARGS,(void *)rdArgs);
  if(templateString) free(templateString);
  return [super free];
}

// Parse items

- parseString:(const char *)str
{
  int strLen=strlen(str);
  struct RDArgs *success;
  char *tmpStr;

  if(!(tmpStr=(char *)NXZoneMalloc([self zone],strLen+2))) return nil;

  sprintf(tmpStr,"%s\n",str); // String must end with \n

  rdArgs->RDA_Source.CS_Buffer=tmpStr;
  rdArgs->RDA_Source.CS_Length=strLen+1;
  rdArgs->RDA_Source.CS_CurChr=0;
  rdArgs->RDA_Buffer=NULL;

  success=ReadArgs(templateString,argSpace,rdArgs);

  free(tmpStr);

  if(success) return self; else return nil;
}

- parseFile:(const char *)fileName
{
  BPTR file;
  char *lineBuffer, *p;
  id retval=nil;

  if(file=Open((char *)fileName,MODE_OLDFILE))
  {
    if(lineBuffer=NXZoneMalloc([self zone],bufLen))
    {
      retval=self;
      while(FGets(file,lineBuffer,bufLen-1))
      {
	for(p=lineBuffer;*p==' ' || *p=='\t';p++); // Skip leading spaces and TABs
	if(*p=='#' || *p==';' || *p=='-' || *p=='/' || *p=='*') continue; // Skip comment lines
	if(![self parseString:p]) retval=nil; // Parse line
      }
      free(lineBuffer);
    }
    Close(file);
  }

  return retval;
}

- parseVariable:(const char*)varName
{
  char *lineBuffer;
  id retval=nil;

  if(!(lineBuffer=NXZoneMalloc([self zone],bufLen))) return nil;
  if(GetVar((char*)varName,lineBuffer,bufLen-1,NULL)!=-1) if([self parseString:lineBuffer]) retval=self;
  free(lineBuffer);
  return retval;
}

- parseCommandline
{
  id retval;

  rdArgs->RDA_Flags|=RDAF_STDIN;
  rdArgs->RDA_Flags&=~RDAF_NOPROMPT;
  retval=[self parseString:GetArgStr()];
  rdArgs->RDA_Flags&=~RDAF_STDIN;
  rdArgs->RDA_Flags|=RDAF_NOPROMPT;

  return retval;
}

@end
