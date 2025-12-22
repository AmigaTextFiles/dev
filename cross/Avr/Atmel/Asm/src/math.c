/*******************************************************
* Maths routines for the Atmel cross assembler         *
* (c)1999 LJS                                          *
*                                                      *
* Takes an expression and evaluates it.                *
*******************************************************/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

#include "errors.h"

#define MAXBUFFER 1024
extern int Error;

void InsertChar(char *S, char Ch);
int Evaluate(char *Exp);
int EvalBit(char *Bit);
int BracketOut(char *Str);
int CheckBrackets(char *Str);
int Math(char *Str);
void RemoveSpace(char *S);

int StrToInt(char *Str);     /*Converts hex,dec,bin*/

int Math(char *Str)
{
	int Result;
  char *Local, *Bit, Sign;

  if(strlen(Str)>=MAXBUFFER)
  {
    Error = MEM;
    return 0;
  }

  Local=(char*)malloc(MAXBUFFER);
  if(Local==NULL)
  {
    Error=MEM;
    return 0;
  }
  strcpy(Local,Str);            /*Take a local copy of the original expression*/
  if(CheckBrackets(Local)==0)
  {
    Bit = Local;
    while(*Bit)
    {
      Sign = *Bit;
      Bit++;
      if( (*Bit == '>') || (*Bit == '<') )  /*Splat >> & << to > & <*/
      {
        if(Sign == *Bit)
        {
          *Bit = ' ';    /*Change the second one to a space*/
        }
      }
    }
    RemoveSpace(Local);
	  Result=BracketOut(Local);
		if(Result)
		{
		  Result=Evaluate(Local);
	 	}
  }
  else
  {
    Error=BRACKETS;
  }
  free(Local);
 return Result;
}

int Evaluate(char *Exp)
{
	char *Work, *Double, *Temp;
	int Result;

  if(CheckBrackets(Exp))
  {
    return 0;
  }

  if( (strlen(Exp)+2) >=MAXBUFFER)
  {
    Error = MEM;
    return 0;
  }

	Work=(char*)malloc(MAXBUFFER);
	if(Work==NULL)
	{
		Error=MEM;
		return 0;
	}
	Double=(char*)malloc(MAXBUFFER);
	if(Double==NULL)
	{
		Error=MEM;
		free(Work);
		return 0;
	}

	Work[0]='(';
	Work[1]=0;
	strcat(Work,Exp);
	strcat(Work,")");
	Temp=Work;
	do
	{
		while( (*Temp!=')') && (*Temp) )
		{
			Temp++;
		}
		if(*Temp)
		{
			while(*Temp!='(')
			{
				Temp--;
			}
			Result=EvalBit(Temp);
			*Temp=0;
			sprintf(Double,"%s%d",Work,Result);
			while(*Temp!=')')
			{
				Temp++;
			}
			Temp++;
			strcat(Double,Temp);
			strcpy(Work,Double);
		}
		Temp=Work;
	}while(*Temp=='(');

	free(Work);
	free(Double);
	return Result;
}

int EvalBit(char *Bit)
{
	int Result=0, Os, Loop, Left, Right;
	char Part[2][8],Sign;

	for(Loop=0; Loop<2; Loop++)
	{
		Sign=*Bit;
		Bit++;
		Os=0;
		do
		{
			Part[Loop][Os]=*Bit;
			Os++;
			Bit++;                /*Gets -'s as well*/
		}while( (isxdigit(*Bit) || (*Bit=='$') || (*Bit=='%')) && (Os<8) );
		Part[Loop][Os]=0;
	}

	Left=StrToInt(Part[0]);
  if(Sign!=')')
  {
	  Right=StrToInt(Part[1]);
  }

	switch(Sign)
	{
		case '+':Result=Left+Right;
						break;
		case '-':Result=Left-Right;
						break;
		case '*':Result=Left*Right;
						break;
		case '/':if(Right)
						 {
							 Result=Left/Right;
						 }
						 else
						 {
							 Error=DIVZERO;
						 }
						break;
		case '&':Result=Left&Right;
						break;
		case '|':Result=Left|Right;
						break;
		case '>':Result=Left>>Right;
						break;
		case '<':Result=Left<<Right;
						break;
		default:Result=Left;
					 break;
	}
 return Result;
}

void InsertChar(char *S, char Ch)
{
	char TempA, TempB;

  if( (strlen(S)+1) >= MAXBUFFER)
  {
    Error = TOOCOMPLEX;
    return;
  }

	TempA=*S;
	*S=Ch;
	while(*S)
	{
		S++;
		TempB=*S;
		*S=TempA;
		TempA=TempB;
	}
}

int BracketOut(char *Str)
{
	char *Order="/*+-&|<>";
	char *Temp,*StrPtr;
	int Bracket;

	while(*Order)
	{
		Temp=Str;
		while(*Temp)
		{
			if(*Temp==*Order)
			{
				StrPtr=Temp;
				Bracket=0;
				do
				{
					StrPtr--;
					if(*StrPtr==')')
						Bracket++;
					else if(*StrPtr=='(')
						Bracket--;
				}while( ((Bracket) || isxdigit(*StrPtr) || (*StrPtr=='$') || (*StrPtr=='%')) && (StrPtr>Str) );
				if(StrPtr>Str)
				{
					StrPtr++;
				}
        else if(StrPtr<Str)
        {
          return 1;
        }
				Temp++;
				InsertChar(StrPtr,'(');
        if(Error) return 0;
				Temp++;
				Bracket=0;
				if(*Temp)
				{
					do
					{
						if(*Temp=='(')
							Bracket++;
						else if(*Temp==')')
							Bracket--;

						Temp++;
					}while( ((Bracket) || isxdigit(*Temp)  || (*Temp=='$') || (*Temp=='%')) && (*Temp));
				}
				InsertChar(Temp,')');
        if(Error) return 0;
			}
			else
			{
				Temp++;
			}
		}
		Order++;
	}
	return 1;
}

int CheckBrackets(char *Str)
{
  int result=0;

  while(*Str)
  {
    if(*Str=='(')
      result++;
    if(*Str==')')
      result--;
    Str++;
  }
 return result;
}
