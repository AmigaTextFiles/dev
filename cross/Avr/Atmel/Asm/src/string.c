/**************************************************************************/
/*                                                                        */
/* STRING.C                                                               */
/*                                                                        */
/* Various string manipulating functions.                                 */
/* LJS 2000                                                               */
/**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "str_p.h"

#ifndef max
 #define max(a,b) ((a) > (b) ? (a):(b))
#endif

/****************************************************************/
/*                                                              */
/* Function:@CountChar                                          */
/* Args    :Pointer to string, char                             */
/* Returns :Result                                              */
/*                                                              */
/* Description: Counts occurances of a char in a string.        */
/*                                                              */
/****************************************************************/
int CountChar(char *S, char C)
{
	int Result=0;
	while(*S)
	{
		if(*S==C)
		{
			Result++;
		}
		S++;
	}
	return Result;
}

/****************************************************************/
/*                                                              */
/* Function:@StrCpyChar                                         */
/* Args    :                                                    */
/* Returns :Pointer to input string.                            */
/*                                                              */
/* Description: Copy Src to Dest until end of Src or Stop char  */
/*              is reached.                                     */
/*                                                              */
/****************************************************************/
char *StrCpyChar(char *Dest, char *Src, char Stop)
{
	char C;

	if(Src==NULL)
	{
		*Dest=0;
		return NULL;
	}

	do
	{
		C=*Src;
		Src++;
		if(C==0)
		{
			*Dest=0;
			return NULL;
		}
		if(C==Stop)
		{
			C=0;
		}
		*Dest=C;
		Dest++;
	}while(C);
	while(*Src==Stop)
	{
		Src++;
	}
	return Src;
}

/****************************************************************/
/*                                                              */
/* Function:@StripCrudd                                         */
/* Args    :Pointer to string                                   */
/* Returns :1                                                   */
/*                                                              */
/* Description: Removes rubbish from a string, replace with ' ' */
/*                                                              */
/****************************************************************/
int StripCrudd(char *S)
{
	while(*S)
	{
		if(*S<32)
		{
			*S=32;
		}
		else if(*S==':')
		{
			*S=' ';
		}
		S++;
	}
	return 1;
}

/****************************************************************/
/*                                                              */
/* Function:@RemoveChar                                         */
/* Args    :Pointer to string, char                             */
/* Returns :1                                                   */
/*                                                              */
/* Description: Removes all instances of char from a string.    */
/*             Squashes up string to fill spaces.               */
/*                                                              */
/****************************************************************/
int RemoveChar(char *S, char T)
{
	/*Removes a character from a string*/
	char *Temp;
	Temp=S;
	while(*S)
	{
		if(*S==T)
		{
			*S=' ';
		}
		S++;
	}
	RemoveSpace(Temp);
	return 1;
}

/****************************************************************/
/*                                                              */
/* Function:@RemoveSpace                                        */
/* Args    :Pointer to string                                   */
/* Returns :1                                                   */
/*                                                              */
/* Description: Compresses out ' ' in a string                  */
/*                                                              */
/****************************************************************/
int RemoveSpace(char *S)
{
	/*Removes space from a string*/
	char *T;

	while(*S)
	{
		if(*S==' ')
		{
			T=S;
			while(*T)
			{
				*T=*(T+1);
				T++;
			}
		}
		else
		{
			S++;
		}
	}
	return 1;
}

int RemoveSpaceTSF(char *S)
{
  /* Remove Space Text String Friendly */
	/* Removes space from a string but not if in quotes "" */
	char *T;

	while(*S)
	{
		if(*S==' ')
		{
			T=S;
			while(*T)
			{
				*T=*(T+1);
				T++;
			}
		}
		else if (*S=='"')
    {
      S++;
      while( (*S) && (*S!='"') )
      {
        S++;
      }
      if(*S)
      {
        S++;
      }
    }
    else
		{
			S++;
		}
	}
	return 1;
}

int Validate(char *Str, char *Comp)
{
 /*Checks a string for invalid characters*/
	char *Tmp;
	unsigned char Result=0;

	Tmp=Comp;
	while(*Str)
	{
		Comp=Tmp;
		Result=0;
		while(*Comp)
		{
			if(*Str==*Comp)
			{
				Result=1;
			}
			Comp++;
		}
		if(Result==0)
		{
			return 0;
		}
		Str++;
	}
	return 1;
}

int StripDontCare(char *Str)
{
/*Replaces 'X' with '0' in a string*/
	while(*Str)
	{
		if(*Str=='X')
		{
			*Str='0';
		}
		Str++;
	}
	return 1;
}

void StrUpr(char *String)
{
  unsigned char TextCount=0;

  while(*String)
  {
    if(*String=='"') /*Dont upper constant text*/
    {
      TextCount=~TextCount;
    }
    if ( ('a' <= *String) && (*String <= 'z') && (TextCount==0) )
    {
		  *String= *String + 'A' - 'a';
    }
    String++;
  }
}

void SwapStrings(char *StrA, char *StrB)
{
  char Tmp;
  int Count;

  Count=max(strlen(StrA), strlen(StrB));
  while(Count)
  {
    Tmp = *StrA;
    *StrA = *StrB;
    *StrB = Tmp;
    StrA++;
    StrB++;
    Count--;
  }
}
