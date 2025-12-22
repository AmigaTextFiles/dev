/************************************************************************/
/* Atmel assembler V1.01                                                */
/* (C)2000 LJS                                                          */
/* This should compile on anything!                                     */
/*                                                                      */
/* 1)Removed NULL at end of constant strings                            */
/* 2)Shift Left/Right (< >) is now as for C ( << >> )                   */
/* 3)Removed temporary file, now done to a buffer.                      */
/* 4)No upper limit on number of labels (except for avail RAM).         */
/* 5)'def' added to allow small text replacements.                      */
/* 6)Maths precedence is now /*+-&|<>                                   */
/* 7)New line at end of file no longer needed.                          */
/* 8)Handling of undefined labels containing X,Y and Z                  */
/* 9)Corrected error on an undefined beginning with H !                 */
/*10)Constant strings used to have spaces removed ! "Hell o" == "Hello" */
/*11)Text strings with commas processed wrong.                          */
/*12)Buffer cleans up correctly.                                        */
/************************************************************************/

#include<stdio.h>
#include<string.h>
#include<stdlib.h>

typedef unsigned long ULONG;
typedef unsigned char BYTE;

#include "buff.h"
#include "errors.h"

/* #define DUMP_BUFFER "tmp1.tmp" */

#define CODEFILE "Atmel.txt"
#define MAXOPCODES 256
#define OPLENGTH   8
#define MAX_SR_LINE 16      /*16 bytes max on one S Record line*/

char *Errors[]={"OK",
								"Bad constant",
								"File error",
								"Unrecognised opcode",
								"Operand error",
								"Out of range",
								"Bad code generated",
								"Use registers >15",
								"Use registers 24, 26, 28 and 30",
								"Redeclared label",
								"Relative address must be even",
								"Code must be at an even address",
								"Can't open file for inclusion",
								"Out of memory",
                "Missing quote's",
                "Division by zero",
                "Missing brackets",
                "Formula to complex",
                "Constant not defined",
                "Source line too long"
							 };

#define D_ORG     0
#define D_END     1
#define D_EQU     2
#define D_INCL    3
#define D_NEWFILE 4
#define D_ENDNEW  5
#define D_CONSTB  6
#define D_CONSTW  7
#define D_DEFINE  8

char *Directives[]={"ORG",
										"END",
										"EQU",
										"INCLUDE",
										"FILE",
										"ENDFILE",
										"DB",
										"DW",
                    "DEF",
										NULL
									 };

#include "struct.h"

struct ACode *Codes[MAXOPCODES];
extern struct ACode InternCodes[];

int Error=0;
long LineNumber=0;
struct DStack *Files=NULL;
struct Labels *LabelStack = NULL;
BYTE SRBuffer[MAX_SR_LINE];
BYTE SROffset;
BYTE InternalTable = 0;

int SRIn=0;

#include "proto.h"
#include "str_p.h"      /* String function prototypes */

char *FGets(char *Str, int Size, FILE *In);
void ConvertLine( char *Line, char *First, char *Second, char *Third );

int main(int argc, char *argv[])
{
  MEMBUFF *Tempfile;
	int Count;
	char *Outfile, *Listfile=NULL;

	printf(" Atmel cross assembler (C)2000 LJS By Lee Atkins.\n");
  printf(" Version date "__DATE__"\n");
	if(argc<2)
	{
		printf(" Asm <source file> <output file> <list file>\n");
		return 1;
	}

	if (argc>2)
	{
		Outfile=argv[2];
	}
	else
	{
		Outfile="a.out";
	}

	if (argc==4)
	{
		Listfile=argv[3];
	}

	for(Count=0; Count<MAXOPCODES; Count++)
	{
		Codes[Count]=NULL;
	}

  printf(" Loading machine file..\r");
	if(ParseCodes(CODEFILE))
	{
    if(InternalTable)
    {
      printf(" Using internal code table.\n");
    }
    else
    {
      printf(" Using machine file "CODEFILE"\n");
    }

		PushFiles(argv[1],NULL);
    Tempfile=OpenBuffer();
	  if(Tempfile!=NULL)
	  {
      printf(" Preprocessing.........\r");
		  if(PreProcess(argv[1],Tempfile))
		  {

        printf(" Assembling :%s\n Output on  :%s\n",argv[1],Outfile);
			  if(Listfile)
			  {
				  printf(" List on    :%s\n",Listfile);
			  }
			  Assemble(Tempfile,Outfile,Listfile,argv[1]);
		  }

	    if(Error)
	    {
		    printf(" File  : %s\n",Files->Data);
		    printf(" Error %d Line %ld %s.\n",Error,LineNumber,Errors[Error]);
	    }
	    else
	    {
        printf(" Bytes used : %d\n",SRIn);
		    printf(" Assembled with no errors.\n");
	    }

#ifdef DUMP_BUFFER
      BuffDump(DUMP_BUFFER,Tempfile);
#endif

      KillBuffer(Tempfile);
    }
    else
    {
      printf(" Out of memory!\n");
    }
  }
	else
	{
	  printf(" Error parsing machine file!\n");
	}

  if(InternalTable != 1)
  {
    FreeCodes();
  }
	FreeLabelStack();
	while(PopFiles());

	return 1;
}

int ParseCodes(char *FileName)
{
 FILE *Infile;
 int Count=0, Part=0, OneOfFour=0;
 char InText, InStr[36],Finished=0;

	/*Gets code from code file FileName*/

 Infile=fopen(FileName,"r");
 if(Infile==NULL)
 {
   InternalTable = 1;
   while(InternCodes[Part].Opcode != NULL)
   {
     Codes[Part]=&InternCodes[Part];
     Part++;
   }
   return 1;
 }
 else
 {
   do
   {
	   do
	   {
		   do
		   {
			   InText=fgetc(Infile);
		   }while( (InText<33) && (InText!=EOF) );
		   if(InText==EOF)
		   {
			   fclose(Infile);
			   return 1;
		   }
		   if(InText=='*')
		   {
         do
         {
           InText=fgetc(Infile);
         }while( (InText!='*') && (InText!=EOF) );
         if(InText==EOF)
         {
           fclose(Infile);
           return 0;
         }
		   }
	   }while(InText=='*');

	   Count=0;
	   do
	   {
		   InStr[Count++]=InText;
		   if(Count==36)
		   {
			   Count--;
         fclose(Infile);
         return 0;
		   }
		   InText=fgetc(Infile);
       if(InText=='*')
       {
         fclose(Infile);
         return 0;
       }
	   }while(InText>32);
	   InStr[Count]=0;        /*terminate*/

	   switch(OneOfFour)
	   {
		   case 0:
						Codes[Part]=(struct ACode*)malloc(sizeof(struct ACode));
						if(Codes[Part]==NULL)
						{
							Finished=2;
						}
            else
            {
              Codes[Part]->Operand=NULL;
              Codes[Part]->Code=NULL;
              Codes[Part]->Flag=NULL;
						  Codes[Part]->Opcode=(char*)malloc(strlen(InStr)+1);
						  if(Codes[Part]->Opcode==NULL)
						  {
							  Finished=2;
						  }
              else
              {
						    strcpy(Codes[Part]->Opcode,InStr);
						    OneOfFour++;
              }
            }
						break;

		   case 1:
					 Codes[Part]->Operand=(char*)malloc(strlen(InStr)+1);
					 if(Codes[Part]->Operand==NULL)
					 {
						 Finished=2;
					 }
           else
           {
					   strcpy(Codes[Part]->Operand,InStr);
					   OneOfFour++;
           }
					 break;

		   case 2:
					 Codes[Part]->Code=(char*)malloc(strlen(InStr)+1);
					 if(Codes[Part]->Code==NULL)
					 {
						 Finished=2;
					 }
           else
           {
					   strcpy(Codes[Part]->Code,InStr);
					   OneOfFour++;
           }
					 break;
		   case 3:
					 Codes[Part]->Flag=(char*)malloc(strlen(InStr)+1);
					 if(Codes[Part]->Flag==NULL)
					 {
             Finished=2;
					 }
           else
           {
					   strcpy(Codes[Part]->Flag,InStr);
					   OneOfFour=0;
					   Part++;
					   if(Part==MAXOPCODES)
					   {
						   Finished=2;
					   }
           }
					 break;
	   } /*end switch*/
   }while(!Finished);
   fclose(Infile);
   if(Finished==1)
   {
     return 1;
   }
   else
   {
     return 0;
   }
 }
}

int FreeCodes(void)
{
 /*Frees Codes array*/
 int Count;

 for(Count=0; Count<MAXOPCODES; Count++)
 {
	 if(Codes[Count]!=NULL)
	 {
		 if(Codes[Count]->Opcode!=NULL)
		 {
			 free(Codes[Count]->Opcode);
			 Codes[Count]->Opcode=NULL;
		 }
		 if(Codes[Count]->Operand!=NULL)
		 {
			 free(Codes[Count]->Operand);
			 Codes[Count]->Operand=NULL;
		 }
		 if(Codes[Count]->Code!=NULL)
		 {
			 free(Codes[Count]->Code);
			 Codes[Count]->Code=NULL;
		 }
		 if(Codes[Count]->Flag!=NULL)
		 {
			 free(Codes[Count]->Flag);
			 Codes[Count]->Flag=NULL;
		 }
		 free(Codes[Count]);
		 Codes[Count]=NULL;
	 }
 }
 return 1;
}

char *FGets(char *Str, int Size, FILE *In)
{
  char *p=Str, Some = 0;
  int k;

  do
  {
    k=fgetc(In);
    if (k == -1)
    {
      if(Some) return (Str);
      return (NULL);
    }
    Some = 1;
    *p++=k;
  }while( (--Size) && (k!='\n') );
  *p++=0;
  if(Size == 0)
  {
    Error = LONGLINE;
  }
  return(Str);
}

int PreProcess(char *Filename, MEMBUFF *Tempfile)
{
	FILE *Infile;
  char Line[128], First[128], Second[128], Third[128];
  char TempStr[128], Flag;
	int PC=0, Tmp, FileCount, WordPC=0, NewSz, Address;
  struct Labels *Result;

	LineNumber=0;

	Infile=fopen(Filename,"r");
	if(Infile==NULL)
	{
		printf("Can't open %s\n",Filename);
		return 0;
	}

	FileCount=0;
  do
  {
    /* Had to write my own fgets() cos some implementations are slightly */
    /* different */
	  while( (FGets(Line,128,Infile)) && (Error==0))
	  {
      LineNumber++;
		  StripComments(Line);
		  StripCrudd(Line);
		  StrUpr(Line);
      /* Make us multi format compatible ! */
      ConvertLine(Line, First, Second, Third);
		  RemoveSpace(First);
		  RemoveSpace(Second);
		  RemoveChar(Second,'.');
		  RemoveSpaceTSF(Third);

		  if(*First)
		  { /*Add label in stack*/
        if(strcmp(Second,Directives[D_EQU])==0)
			  {
          Replace(Third);
				  Address=StrToInt(Third);
				  Flag='E';
        }
			  else if(strcmp(Second,Directives[D_DEFINE])==0)
        {
          Replace(Third);
				  Flag='M';
        }
        else
			  {
				  Address=WordPC;
				  Flag='A';
			  }
        if(Error==0)
        {
			    if(IsInStack(First))
	        {
  		      Error=REPEATLABEL;
  			    fclose(Infile);
  				  return 0;
  			  }
		  	  if(Flag=='E')
          {
			      Second[0]=0;
			      Third[0]=0;
			    }

          if(Flag == 'M')
          {
            Result = AddLabel(First, Address, Flag, Third);
            Second[0]=0;
			      Third[0]=0;
          }
          else
          {
            Result = AddLabel(First, Address, Flag, NULL);
          }
          if( Result == NULL)
	  		  {
            Error=MEM;
		  	    fclose(Infile);
		  		  return 0;
		  	  }
          First[0]=0;
        }
        else
        {
          Error=0;
        }
		  }

		  if(*Second)
		  {
        ProcessOperand(Third);
        Error=0;

			  if( (Tmp=FindCode(Second)) !=MAXOPCODES )
			  {
				  NewSz=CodeLength(Tmp);
          PC+=NewSz;
          WordPC+=NewSz>>1;
			  }
			  else
			  {
				  /*could be a directive*/
				  Tmp=FindDirective(Second);
				  if(Directives[Tmp]!=NULL)
				  {
					  /*It is!*/
				  	switch(Tmp)
					  {
              case D_EQU:
                   break;
              case D_DEFINE:
                   break;
						  case D_CONSTB:
						  		 NewSz=ConstantLength(Third,1);
                   PC+=NewSz;
                   WordPC+=NewSz>>1;
							  	 break;
						  case D_CONSTW:
							  	 NewSz=ConstantLength(Third,2);
                   PC+=NewSz;
                   WordPC+=NewSz>>1;
						   		 break;
						  case D_ORG:
							  	 PC=StrToInt(Third);
                   WordPC=PC;
							  	 break;
						  case D_NEWFILE:
							  	 PushFiles(Third,NULL);
							  	 LineNumber=0;
						   		 break;
						  case D_ENDNEW:
							  	 PopFiles();
							  	 break;
						  case D_INCL:
							  	 RemoveChar(Third,'"');
					   			 sprintf(TempStr," FILE \"%s\" \n",Third);
                   BuffPutS(TempStr,Tempfile);
					   			 PushFiles(Third,Infile);  /*Save current file stuff*/
					   			 Infile=fopen(Third,"rb");
						  		 if(Infile==NULL)
						   		 {
									   Error=NOFILE;
									   Infile=PopFiles();
									   fclose(Infile);
									   return 0;
								   }
								   First[0]=0;
								   Second[0]=0;
								   Third[0]=0;
								   FileCount++;
								   LineNumber=0;
								   break;
						  case D_END:
							  	 First[0]=0;
							   	 Second[0]=0;
								   Third[0]=0;
								   break;
              default:
                   Error=NOTOP;
                   break;
					  }/*end switch*/
				  }
          else
          {
            Error=NOTOP;
          }
			  }
		  }
		  sprintf(TempStr,"%s %s %s\n",First,Second,Third);
      BuffPutS(TempStr,Tempfile);
	  }

	  fclose(Infile);
	  if( (FileCount) && (Error==0) )
	  {
		  BuffPutS(" ENDFILE",Tempfile);
		  Infile=PopFiles();
	  }
  }while( (FileCount--) && (Error==0) );
	if(Error==0) return 1;
	return 0;
}

int FreeLabelStack(void)
{
  struct Labels *Tmp;

  while(LabelStack)
  {
    Tmp = LabelStack->Last;
    if(LabelStack->Macro) free(LabelStack->Macro);
    if(LabelStack->Label) free(LabelStack->Label);
    free(LabelStack);
    LabelStack = Tmp;
  }
  return 1;
}

struct Labels *AddLabel(char *Name, int Address, char Flag, char *Macro)
{
  struct Labels *Tmp;

  Tmp = (struct Labels*)malloc(sizeof(struct Labels));
  if(Tmp != NULL)
  {
    Tmp->Last  = LabelStack;
    Tmp->Macro = NULL;
    Tmp->Label = (char*)malloc(strlen(Name)+1);
    if(Tmp->Label != NULL)
    {
      strcpy(Tmp->Label, Name);
      Tmp->Address = Address;
      Tmp->Flag = Flag;
      if(Macro)
      {
        Tmp->Macro = (char*)malloc(strlen(Macro)+1);
        if(Tmp->Macro != NULL)
        {
          strcpy(Tmp->Macro, Macro);
          LabelStack = Tmp;
          return Tmp;
        }
      }
      else
      {
        LabelStack = Tmp;
        return Tmp;
      }
      free(Tmp->Label);
    }
    free(Tmp);
  }
  return NULL;
}

int StripComments(char *Txt)
{
	int Len=0;

	while((*Txt!=';') && (Len<127) && (*Txt))
	{
		Txt++;
		Len++;
    if(*Txt=='"')
    {
      Txt++;
      Len++;
      while( (*Txt!='"') && (Len<127) && (*Txt) )
      {
        Txt++;
        Len++;
      }
      if( (Len==127) || (*Txt!='"') )
      {
        Error=MISSINGQUOTE;
        return 0;
      }
    }
	}
	*Txt=0;
	return 1;
}

int CodeLength(int Code)
{
	int Result;

	if(Codes[Code]==NULL)
	{
		return 0;
	}
	Result=strlen(Codes[Code]->Code);
	if(strchr(Codes[Code]->Code,'!'))
	{
		Result-=CountChar(Codes[Code]->Code,'!');
	}
	Result/=OPLENGTH;

	return Result;
}


int IsInStack(char *Str)
{
	struct Labels *Tmp;

  Tmp = LabelStack;
  while(Tmp)
  {
		if(strcmp(Str,Tmp->Label)==0)
		{
			return 1;
		}
    Tmp = Tmp->Last;
	}
	return 0;
}


int FindCode(char *Str)
{
	int Count;

	for (Count=0; Count<MAXOPCODES; Count++)
	{
		if(Codes[Count]!=NULL)
		{
			if(strcmp(Str,Codes[Count]->Opcode)==0)
			{
				return Count;
			}
		}
	}
	return Count;
}

int FindDirective(char *Str)
{
	int Count=0;

	while(Directives[Count])
	{
		if(strcmp(Str,Directives[Count])==0)
		{
			return Count;
		}
		Count++;
	}
	return Count;
}

int ProcessOperand(char *Str)
{
	char *Ptr,Left[128],Right[128],Comma;

  if(strlen(Str) == 0)
  {
    return 1;
  }

  Left[0]=0;
  Right[0]=0;
	Ptr=Str;
	Comma=0;
	while( (*Str!=',') && (*Str) )
	{
		Str++;
	}
	if(*Str==',')
	{
		*Str=0;
		Str++;
		Comma=1;
	}
	else
	{
		Str=Ptr;
	}

	strcpy(Left,Ptr);
	strcpy(Right,Str);
	Replace(Left);
	strcpy(Ptr,Left);
	if(Comma)
	{
   Replace(Right);
	 strcat(Ptr,",");
	 strcat(Ptr,Right);
	}
	return 0;
}

int Replace(char *Str)
{
  int Ret, Result = 0;
  char Work[128],Returned[128], *Sep="+-*/&|<>)",*Tmp;
  char *Orig, *Op=" ", *StrIn, BitOfMath=0;

  Work[0]=0;
  Orig=Str;
  StrIn=Str;
  while(*Str)
  {
    if(*Str=='(')
    {
      *Op=*Str;
      strcat(Work,Op);
      Orig++;
    }
    else
    {
      Tmp=Sep;
      while( (*Tmp) && (*Tmp!=*Str))
      {
        Tmp++;
      }
      if(*Tmp)
      {
        /*Found a maths operator*/
        BitOfMath=1;
        *Str=0;
        Result += ReplaceLabels(Orig,Returned);
        strcat(Work,Returned);
        *Op=*Tmp;
        strcat(Work,Op);
        Orig=Str+1;
      }
    }
    Str++;
  }
  Result += ReplaceLabels(Orig,Returned);
  strcat(Work,Returned);
  if(BitOfMath)
  {
    Ret=Math(Work);
    if(!Error)
    {
      sprintf(StrIn,"$%X",Ret);
    }
    else
    {
      strcpy(StrIn,Work);
    }
  }
  else
  {
    strcpy(StrIn,Work);
  }

  return (Result);
}

/*****************************************
* ReplaceLabels()
* Searches for a label in the label stack.
* Copies the labels value into Res.
*****************************************/
int ReplaceLabels(char *Str, char *Res)
{
	struct Labels *Tmp;

  Tmp = LabelStack;
	while(Tmp)
	{
		if(Tmp->Label!=NULL)
		{
			if(strcmp(Str, Tmp->Label)==0)
			{
        if(Tmp->Macro)
        {
          strcpy(Res,Tmp->Macro);
        }
        else
        {
  			  sprintf(Res,"$%04X",Tmp->Address);
        }
				return 1;
			}
		}
    Tmp = Tmp->Last;
	}
  strcpy(Res,Str);
	return 0;
}

int StrToInt(char *Str)
{
	/*Converts an asciiz number string into an int*/
	/*Detects input type as being in hex,dec or bin*/
	/*$aa, 0aaH is hex, %1001, 1001b is binary*/

	int Result;

	StrUpr(Str);
	if(strchr(Str,'H')!=NULL)
	{
		Result=HexToInt(Str);
	}
	else if(strchr(Str,'$')!=NULL)
	{
		Result=HexToInt(Str);
	}
	else if(strchr(Str,'%')!=NULL)
	{
		Result=BinToInt(Str);
	}
	else if(strchr(Str,'B')!=NULL)
	{
		Result=BinToInt(Str);
	}
	else
	{
		if(!Validate(Str,"-+0123456789"))
		{
			Error=CONSTANT;
			return 0;
		}
		Result=atoi(Str);
	}
	return Result;
}

int HexToInt(char *Str)
{
/* converts a hex string into an int*/
	int Result=0,Weight=1,C=1;
	char *Tmp;

	Tmp=Str;
	if(strchr(Str,'$')!=NULL)
	{
		Tmp=strchr(Str,'$');
		Tmp++;
	}
	else
	{
		while(*Str)
		{
			Str++;
		}
		while(*Str!='H')
		{
			Str--;
		}
		*Str=0;
	}
	Str=Tmp+strlen(Tmp);

	if( (!Validate(Tmp,"0123456789ABCDEF")) || (*Tmp == 0) )
	{
		Error=CONSTANT;
		return 0;
	}
	while(Str!=Tmp)
	{
		Str--;
		Result+=(*Str<'A' ? (*Str-'0'):(10+(*Str-'A')) ) * Weight;
		Weight<<=4;
		C++;
	}
	return Result;
}

int BinToInt(char *Str)
{
 /*Converts a binary string into an int*/
	int Result=0,Weight=1;
	char *Tmp;

	Tmp=Str;
	if(strchr(Str,'%')!=NULL)
	{
		Tmp=strchr(Str,'%');
		Tmp++;
	}
	else
	{
		while(*Str)
		{
			Str++;
		}
		while(*Str!='B')
		{
			Str--;
		}
		*Str=0;
	}
	Str=Tmp+strlen(Tmp);
	if( (!Validate(Tmp,"01")) || (*Tmp == 0) )
	{
		Error=CONSTANT;
		return 0;
	}
	while(Str!=Tmp)
	{
		Str--;
		Result+=(*Str-'0') * Weight;
		Weight<<=1;
	}
	return Result;
}

int Assemble(MEMBUFF *Tempfile, char *Out, char *List, char *Name)
{
	FILE *Outfile=NULL, *SRecord=NULL;
	int Count,Found,Replaced,Tmp,PC=0,OldPC=0,PrintPC=0, SRPC=0,CodePC=0;
	char Line[128], First[128], Second[128], Repeat[128], *Ptr;
	char OrigFirst[128], OrigSecond[128], Third[128];
	char Code[33], Map[8],*Indirect,*Post,*Pre, *Temp, Flag;
	ULONG CodeData;
  int Address;

	LineNumber=0;

	BuffRewind(Tempfile);

	if(List)
	{
		Outfile=fopen(List,"wb");
		if(Outfile==NULL)
		{
			Error=FILE_ERROR;
			return 0;
		}
	}

	SRecord=fopen(Out,"w");
	if(SRecord==NULL)
	{
		if(Outfile) fclose(Outfile);
		Error=FILE_ERROR;
		return 0;
	}

	StartSRecord(SRecord,Name);

	do
	{
		do
		{
      Line[0] = 0;
			BuffGetS(Line,128,Tempfile);
			LineNumber++;
			StripCrudd(Line);
			/* StrUpr(Line); */
			Ptr=StrCpyChar(First,Line,' ');
			Ptr=StrCpyChar(Second,Ptr,' ');
			StrCpyChar(Third,Ptr,0);
			RemoveSpace(First);
			RemoveSpace(Second);
      RemoveSpaceTSF(Third);
		}while((*Second==0) && (!BuffEOF(Tempfile)));

		if(*Second == 0)
		{
			FinishSRecord(SRecord,SRPC-1);
			if(Outfile)
      {
        DumpLabels(Outfile);
        fclose(Outfile);
      }
			fclose(SRecord);
			return 1;
		}

    strcpy(OrigFirst,Second);     /*Save for output to list file*/
		strcpy(OrigSecond,Third);

    if(!strchr(Third,'"'))   /*Test for a text string*/
    {
      ProcessOperand(Third);
      /*Look for code*/
      Indirect=strchr(Third,'X');
		  if(Indirect==NULL)
		  {
			  Indirect=strchr(Third,'Y');
		  }
		  if(Indirect==NULL)
		  {
			  Indirect=strchr(Third,'Z');
		  }
    }
    else
    {
      Indirect=NULL;
    }

		if(Indirect!=NULL)
		{
      Error=0;    /*These will produce an error in the maths bits*/
			Post=strchr(Third,'+');
			Pre=strchr(Third,'-');
			if(Post)
			{
				if(Post<Indirect)
				{
					Pre=Post;
					Post=NULL;
				}
				else if(Post>Indirect)
				{
					Pre=NULL;
				}
			}
			else if(Pre)
			{
				if(Pre>Indirect)
				{
					Post=Pre;
					Pre=NULL;
				}
				else if(Pre<Indirect)
				{
					Post=NULL;
				}
			}
      else
      {
        Indirect = NULL;    /* Was a false alarm */
      }
		}

		do
		{
			Count=0;
			Found=0;
			Replaced=0;
			while((Count<MAXOPCODES) && (Codes[Count]) && (!Found))
			{
				if(strcmp(Codes[Count]->Opcode,Second)==0)
				{
					if(Indirect)
					{
						Temp=strchr(Codes[Count]->Operand,*Indirect);
						if(Temp!=NULL)
						{
							if(Pre)
							{
								if(*(Temp-1)==*Pre)
								{
									Found=1;
								}
							}
							else if(Post)
							{
								if(*(Temp+1)==*Post)
								{
									Found=1;
								}
							}
							else if(strchr(Third,*Temp))
							{
								Found=1;
							}
						}
					}
					else
					{
						Found=1;
					}
				}
				if(!Found)
				{
					Count++;
				}
			}
			if(Found)
			{
				if(*Codes[Count]->Flag=='A')
				{
					strcpy(Second,Codes[Count]->Flag+1);
					strcpy(Repeat,Third);
					strcat(Third,",");
					strcat(Third,Repeat);
					Replaced=1;
				}
			}
		}while(Replaced);

		if(!Found)
		{
			if(!AsmDirective(Second))
			{
				Error=NOTOP;
				fclose(Outfile);
				fclose(SRecord);
				return 0;
			}
			else
			{
				Tmp=FindDirective(Second);
				if(Directives[Tmp]!=NULL)
				{
					/*It is!*/
					switch(Tmp)
					{
						case D_CONSTB:
								 if(Outfile)
								 {
									 fprintf(Outfile,"%ld\t",LineNumber);
									 fprintf(Outfile,"%04X  ",PrintPC);
								 }
								 PutConstants(Outfile,SRecord,Third,&SRPC,1);
								 if(Outfile)
								 {
									 fprintf(Outfile,"\t%s %s\n",OrigFirst,OrigSecond);
								 }
                 PC=SRPC;
								 PrintPC=SRPC>>1;
                 CodePC=PrintPC;
								 break;
						case D_CONSTW:
								 if(Outfile)
								 {
									 fprintf(Outfile,"%ld\t",LineNumber);
									 fprintf(Outfile,"%04X  ",PrintPC);
								 }
								 PutConstants(Outfile,SRecord,Third,&SRPC,2);
								 if(Outfile)
								 {
									 fprintf(Outfile,"\t%s %s\n",OrigFirst,OrigSecond);
								 }
                 PC=SRPC;
								 PrintPC=SRPC>>1;
                 CodePC=PrintPC;
								 break;

						case D_ORG:
								 FlushSRBuffer(SRecord,SRPC-1);
								 PC=StrToInt(Third);
								 PrintPC=PC;
                 CodePC=PC;
								 SRPC=PC<<1;
								 break;
						case D_NEWFILE:
								 PushFiles(Third,NULL);
								 LineNumber=0;
								 break;
						case D_ENDNEW:
								 PopFiles();
                 LineNumber++;
								 break;
            case D_EQU:
                  Replace(Third);
				          Address=StrToInt(Third);
				          Flag='E';
                  if(IsInStack(First))
			            {
				            Error=REPEATLABEL;
                  }
                  if(AddLabel(First, Address, Flag, NULL)==NULL)
			            {
                    Error=MEM;
                  }
                  break;
					}
				}
			}
		}
		else
		{
			strcpy(Code,Codes[Count]->Code);
			strcpy(Map,Codes[Count]->Operand);
			OldPC=PC;
			PC+=CodeLength(Count);  /*Next address*/
      CodePC+=(PC-OldPC)>>1;
			CodeData=CreateCode(Code,Map,Third,Codes[Count]->Flag,CodePC);
			if(Outfile)
			{
				fprintf(Outfile,"%ld\t",LineNumber);
				fprintf(Outfile,"%04X  %04lX ",PrintPC,CodeData);
        PrintPC+=(PC-OldPC)>>1;
				fprintf(Outfile,"\t%s %s\n",OrigFirst,OrigSecond);
			}
			if( (PC-OldPC)==4)
			{
				PutSRBuffer(SRecord,CodeData>>16,SRPC);
				PutSRBuffer(SRecord,(CodeData>>24)&255,SRPC+1);
        PutSRBuffer(SRecord,CodeData&255,SRPC+2);
			  PutSRBuffer(SRecord,CodeData>>8,SRPC+3);
			}
      else
      {
        PutSRBuffer(SRecord,CodeData&255,SRPC);
			  PutSRBuffer(SRecord,CodeData>>8,SRPC+1);
      }
      if(SRPC&1)
			{
				Error=ALLIGNMENT;
			}
			SRPC+=(PC-OldPC);
		}

	}while( Error==0 );
	FinishSRecord(SRecord,SRPC);
	if(Outfile)
	{
		DumpLabels(Outfile);
		fclose(Outfile);
	}
	fclose(SRecord);
	return 1;
}

ULONG CreateCode(char *Code, char *Map, char *Operand, char *Flag,int PC)
{
	char Part[128], *Temp, MapPart[128], *MapTemp;
	int Count, Work, Steps, Step,Len;
	ULONG Result;

	if(strcmp(Map,"-")==0)
	{
		Result=BinToULong(Code);
		return Result;
	}

	memset(MapPart,0,128);

	Temp=Code;
	if(strchr(Map,',')!=NULL)
	{
		Steps=2;
	}
	else
	{
		Steps=1;
	}

	for(Step=0; Step<Steps; Step++)
	{
		Code=Temp;
		if (Validate(Code,"01"))
		{
			break;
		}

		Len=strlen(Code);
		Count=0;
		MapTemp=Map;
		while((*Operand) && (*Operand!=','))
		{
			Part[Count]=*Operand;
			MapPart[Count]=*Map;
			Count++;
			Operand++;
			Map++;
		}
		Part[Count]=0;
		MapPart[Count]=0;
		Map=MapTemp;

		if(*Map=='R')
		{
			if(Part[0]=='R')
			{
				Work=StrToInt(&Part[1]);
				if(*Flag=='S')
				{
					if(Work<16)
					{
						Error=REG16;
						return 0;
					}
					Work-=16;
				}
				if(*Flag=='U')
				{
					if( (Work<24) || (Work&1) )
					{
						Error=UPPERREGS;
						return 0;
					}
					Work=(Work>>1)&3;
				}
				Map++;
			}
			else
			{
				Error=WRONGOP;
				return 0;
			}
		}
		else if(*Map=='k')
		{
			if( (strchr(Operand,',')!=NULL) && (Steps==1) )
			{
				Error=WRONGOP;
				return 0;
			}
			Work=StrToInt(Part);
			if(*Flag=='R')
			{
				Work=(Work-PC);

				if((Work>63) || (Work<-64))
				{
					Error=RANGE;
					return 0;
				}
				Work&=127;
			}
			else if(*Flag=='L')
			{
				Work=(Work-PC);
				Work&=4095;
			}
      else if(*Flag=='N')
			{
				Work&=0xFFFF;
			}
		}
		else if(*Map=='K')
		{
			Work=StrToInt(Part);
		}
		else if(MapPart[2]=='q')
		{
			Work=StrToInt(&Part[2]);
			Map+=2;
		}
		else
		{
		 if(!Validate(MapPart,"XYZ,+-"))
		 {
			 Work=StrToInt(Part);
		 }
		 else
		 {
			 Work=0;
		 }
		}

		Code+=(Len-1);
		while(Len)
		{
			if( (*Code=='!') && (*(Code+1)!='K') )
			{
				Code++;
				if(*Code=='1')
				{
					*Code='0';
				}
				else
				{
					*Code='1';
				}
				Code--;
				*Code=' ';
				RemoveSpace(Code);
			}
			if(*Code==*Map)
			{
				if(Work&1)
				{
					*Code='1';
				}
				else
				{
					*Code='0';
				}
				Work>>=1;
			}

			if(*Code=='X')     /*Don't care bit*/
			{
				*Code='0';
			}

			Code--;
			Len--;
		}
		if(Work>0)          /*-ve numbers are ok!*/
		{
			Error=RANGE;
			return 0;
		}
		Operand++;
		while( (*Map) && (*Map!=',') )
		{
			Map++;
		}
		Map++;
	}
	Code=Temp;
	Result=BinToULong(Code);
	return Result;
}

ULONG BinToULong(char *Str)
{
/*Converts binary to ulong!*/
	int Len;
	ULONG Weight=1,Result=0;

	StripDontCare(Str);
	Len=strlen(Str);
	Str+=Len-1;
	while(Len)
	{
		if(Weight==0)
		{
			Error=RANGE;
			return 0;
		}
		if(*Str=='1')
		{
			Result|=Weight;
		}
		else if(*Str!='0')
		{
			Error=BADCODE;
			return 0;
		}
		Weight<<=1;
		Str--;
		Len--;
	}
	return Result;
}

int AsmDirective(char *Str)
{
	int Count=0;

	while(Directives[Count]!=NULL)
	{
		if(strcmp(Str,Directives[Count])==0)
		{
			return 1;
		}
		Count++;
	}
	return 0;
}

int PushFiles(char *Str, FILE *H)
{
	struct DStack *Temp;

	if(Files==NULL)
	{
		Files=(struct DStack*)malloc(sizeof(struct DStack));
		if(Files==NULL)
		{
			Error=MEM;
			return 0;
		}
		Files->Last=NULL;
		Files->Data=(char*)malloc(strlen(Str)+1);
		if(Files->Data==NULL)
		{
			Error=MEM;
			return 0;
		}
		Files->Line=LineNumber;
		Files->Handle=H;
		strcpy(Files->Data,Str);
	}
	else
	{
		Temp=Files;
		Files=(struct DStack*)malloc(sizeof(struct DStack));
		if(Files==NULL)
		{
			Error=MEM;
			Files=Temp;
			return 0;
		}
		Files->Last=Temp;
		Files->Data=(char*)malloc(strlen(Str)+1);
		if(Files->Data==NULL)
		{
			Error=MEM;
			return 0;
		}
		strcpy(Files->Data,Str);
		Files->Line=LineNumber;
		Files->Handle=H;
	}
	return 1;
}

FILE *PopFiles(void)
{
	struct DStack *Temp;
	FILE *TempFile;

	if(Files)
	{
		if(Files->Data!=NULL)
		{
			free(Files->Data);
			Files->Data=NULL;
		}
		LineNumber=Files->Line;
		TempFile=Files->Handle;
		Temp=Files->Last;
		free(Files);
		Files=Temp;
		return TempFile;
	}
	return NULL;
}

int StartSRecord(FILE *File, char *Name)
{
	int Checksum, Temp;
	char *Orig;

	Orig=Name;
	fprintf(File,"S0");
	Temp=0;
	while( (*Name) && (*Name!='.') )
	{
		Temp++;
		Name++;
	}
	Name=Orig;
	Temp+=3;      /*+address +checksum*/
	Checksum=Temp;
	fprintf(File,"%02X",Temp);
	fprintf(File,"0000");
	while( (*Name) && (*Name!='.') )
	{
		fprintf(File,"%02X",*Name);
		Checksum+=*Name;
		Name++;
	}
	Checksum=~Checksum;
	fprintf(File,"%02X\n",(Checksum&255));
	SROffset=0;
	return 1;
}

int PutSRBuffer(FILE *File, BYTE Data, int PC)
{
  SRIn++;

	SRBuffer[SROffset]=Data;
	SROffset++;
	if(SROffset==MAX_SR_LINE)
	{
		FlushSRBuffer(File,PC);
	}
	return 1;
}

int FlushSRBuffer(FILE *Outfile,int PC)
{
	int C,Count;
	int Checksum;

	Count=SROffset;
	if(Count==0)
	{
		return 1;
	}
	fprintf(Outfile,"S1");
	fprintf(Outfile,"%02X",Count+3);  /*+3 for checksum and address*/
	Checksum=Count+3;
	fprintf(Outfile,"%04X",PC-Count+1);
	Checksum+=((PC-Count+1)>>8);
	Checksum+=((PC-Count+1)&255);
	for(C=0; C<Count; C++)
	{
		fprintf(Outfile,"%02X",SRBuffer[C]);
		Checksum+=SRBuffer[C];
	}
	Checksum=~Checksum;
	fprintf(Outfile,"%02X\n",(Checksum&255));
	SROffset=0;
	return 1;
}

int FinishSRecord(FILE *F,int PC)
{
	 FlushSRBuffer(F,PC);
	 fprintf(F,"S9030000FC\n");
	 return 1;
}

int ConstantLength(char *S, BYTE Size)
{
	char Work[128];
	int Os,Result=0;

	do
	{
    Os=0;
		while((*S) && (*S!=','))
		{
			Work[Os]=*S;
			Os++;
			if(Os==128)
			{
				Os--;
			}
			S++;
		}
		Work[Os]=0;
		if(*S==',')
		{
			S++;
		}
		Os=0;
		if(Work[Os]=='"')
		{
			Os++;
			while((Work[Os]!='"') && (Work[Os]))
			{
				Result+=Size;  /*Do we want word long chars? !!!!*/
				Os++;
			}
			/* Result+=Size; */   /*For the NULL, Dont put a null*/
		}
		else
		{
			Result+=Size;
		}
	}while(*S);

	return Result;
}

int PutConstants(FILE *List,FILE *Out,char *S,int *PC, BYTE Size)
{
	char Work[128];
	unsigned int Temp;
	int Os, Width=0;

	do
  {
	  if(*S==',')
	  {
	   	S++;
	  }

		if( (*S=='"') && (Size==1) )
		{
      S++;
			while( (*S!='"') && (*S) )
			{
				PutSRBuffer(Out,(BYTE)*S,*PC);
				if(List)
				{
					fprintf(List,"%02X",*S);
          Width++;
          if(Width==2)
          {
            Width=0;
            fprintf(List,"\n              ");
          }
				}
				*PC=*PC+1;
				S++;
			}
      if(*S)
      {
        S++;
      }
      /*  Dont stuff in a null !!! */
		}
		else if(*S)
		{
      Os=0;
		  while((*S) && (*S!=','))
		  {
			  Work[Os]=*S;
			  Os++;
			  if(Os==127)
			  {
				  Os--;
			  }
			  S++;
		  }
      if(*S)
      {
        S++;
      }
      Work[Os]=0;
			Temp=StrToInt(Work);
			if(List)
			{
				fprintf(List,"%02X",Temp&255);
        Width++;
        if(Width==2)
        {
          Width=0;
          fprintf(List,"\n              ");
        }
			}
			PutSRBuffer(Out,Temp&255,*PC);
			*PC=*PC+1;
			if(Size==2)
			{
				if(List)
				{
					fprintf(List,"%02X",Temp>>8);
          Width++;
          if(Width==2)
          {
            Width=0;
            fprintf(List,"\n              ");
          }
				}
				PutSRBuffer(Out,Temp>>8,*PC);
				*PC=*PC+1;
			}
		}
	}while(*S);
	return 1;
}

void DumpLabels(FILE *List)
{
	struct Labels *Tmp;
  fprintf(List,"\n\n");

  Tmp = LabelStack;
	while(Tmp)
	{
		if(Tmp->Label!=NULL)
		{
      if(Tmp->Flag=='E')
      {
			  fprintf(List,"%s\t\t$%04X\tE\n",Tmp->Label,Tmp->Address);
      }
      else if(Tmp->Flag == 'M')
      {
        fprintf(List,"%s\t\t%s\tM\n",Tmp->Label,Tmp->Macro);
      }
      else
      {
        fprintf(List,"%s\t\t$%04X\tL\n",Tmp->Label,Tmp->Address);
      }
		}
    Tmp = Tmp->Last;
	}
}

