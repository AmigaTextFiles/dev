SCANNER PhoneLogScanner


EXPORT  {/* EXPORT */
         #include "StringMem.h"   /* For 'PutString' */
         #include "Idents.h"      /* For 'MakeIdent' */
         #include "Positions.h"
         #include "System.h"

         typedef struct {
                         tPosition  Position;
                         tStringRef lexstring;
                         int        number;
                        } PhoneLogScanner_tScanAttribute;

         extern void PhoneLogScanner_ErrorAttribute(int Token, PhoneLogScanner_tScanAttribute *Attribute);
         /* EXPORT */}

GLOBAL  {/* GLOBAL */
         /* #include <stdio.h> */
         #include <stdlib.h>


         unsigned short program = 0;


         void PhoneLogScanner_ErrorAttribute(int Token, PhoneLogScanner_tScanAttribute *Attribute)
          {
           switch(Token)
            {
             case 1  : Attribute->number = 0;
                       break;
             case 2  : Attribute->lexstring = PutString("UNKNOWN",7);
                       break;
             default :
                       break;
            }
          }
         /* GLOBAL */}

LOCAL   {/* LOCAL */
         char Word[256];
         int  length;
         /* LOCAL */}

BEGIN   {/* BEGIN */}

CLOSE   {/* CLOSE */}

DEFAULT {/* DEFAULT */
         /* unmatched characters */
         printf("%d,%d : %c\n",PhoneLogScanner_Attribute.Position.Line,PhoneLogScanner_Attribute.Position.Column,yyChBufferIndexReg[-1]);
         /* DEFAULT */}

EOF     {/* EOF */
         /* EOF */}


DEFINE

digi   = {0-9}.
letter = {a-z A-Z}.


START TEXT


RULES

/* Keywords */
#STD#	"<PHONELOG"	: {return(20);}
#STD#	"</PHONELOG>"	: {return(21);}
#STD#	"<ENTRY>"	: {return(22);}
#STD#	"</ENTRY>"	: {return(23);}
#STD#	"<HOST>"	: {return(24);}
#STD#	"</HOST>"	: {return(25);}
#STD#	"<NUMBER>"	: {
                           yyStart(TEXT);
                           return(26);
                          }
#STD#	"</NUMBER>"	: {return(27);}
#STD#	"<HOSTNAME>"	: {
                           yyStart(TEXT);
                           return(28);
                          }
#STD#	"</HOSTNAME>"	: {return(29);}
#STD#	"<START>"	: {return(30);}
#STD#	"</START>"	: {return(31);}
#STD#	"<END>"		: {return(32);}
#STD#	"</END>"	: {return(33);}
#STD#	"<DATE>"	: {
                           yyStart(TEXT);
                           return(34);
                          }
#STD#	"</DATE>"	: {return(35);}
#STD#	"<TIME>"	: {
                           yyStart(TEXT);
                           return(36);
                          }
#STD#	"</TIME>"	: {return(37);}
#STD#	"<PERIOD>"	: {
                           yyStart(TEXT);
                           return(38);
                          }
#STD#	"</PERIOD>"	: {return(39);}
#STD#	"<MARK>"	: {return(40);}
#STD#	"</MARK>"	: {return(41);}
#STD#	"<PROGRAM"	: {
                           program=1;
                           return(42);
                          }
#STD#	"</PROGRAM>"	: {
                           program=0;
                           return(43);
                          }
#STD#	"<MARKNAME>"	: {
                           yyStart(TEXT);
                           return(44);
                          }
#STD#	"</MARKNAME>"	: {return(45);}
#STD#	"<REASON>"	: {
                           yyStart(TEXT);
                           return(46);
                          }
#STD#	"</REASON>"	: {return(47);}
#STD#	"<BUSY>"	: {return(48);}
#STD#	"</BUSY>"	: {return(49);}
#STD#	"<NOANSWER>"	: {return(50);}
#STD#	"</NOANSWER>"	: {return(51);}


/* Attributes */
#STD#	"version"	: {return(80);}
#STD#	"revision"	: {return(81);}


/* Other */
#STD#	"="		: {return(10);}
#STD#	">"		: {
                           if (program)
                             yyStart(TEXT);
                           return(11);
                          }


/* Zahlen erkennen und uebergeben */
#STD#	digi*		: {
                           length = PhoneLogScanner_GetWord(Word);
                           PhoneLogScanner_Attribute.number = atoi(Word);
                           /* sscanf(Word,"%d",&PhoneLogScanner_Attribute.number); */
                           return(1);
		          }

/* Text */
#TEXT#	(-{<})*		: {
                           length = PhoneLogScanner_GetWord(Word);
                           PhoneLogScanner_Attribute.lexstring = PutString(Word,length);
                           yyPrevious;
		 	   return(2);
     			  }
#TEXT# "</NUMBER>"	: {
                           PhoneLogScanner_Attribute.lexstring = PutString("",0);
                           yyPrevious;
                           return(27);
                          }
#TEXT# "</HOSTNAME>"	: {
                           PhoneLogScanner_Attribute.lexstring = PutString("",0);
                           yyPrevious;
                           return(29);
                          }
#TEXT# "</DATE>"	: {
                           PhoneLogScanner_Attribute.lexstring = PutString("",0);
                           yyPrevious;
                           return(35);
                          }
#TEXT# "</TIME>"	: {
                           PhoneLogScanner_Attribute.lexstring = PutString("",0);
                           yyPrevious;
                           return(37);
                          }
#TEXT# "</PERIOD>"	: {
                           PhoneLogScanner_Attribute.lexstring = PutString("",0);
                           yyPrevious;
                           return(39);
                          }
#TEXT# "</MARKNAME>"	: {
                           PhoneLogScanner_Attribute.lexstring = PutString("",0);
                           yyPrevious;
                           return(45);
                          }
#TEXT# "</REASON>"	: {
                           PhoneLogScanner_Attribute.lexstring = PutString("",0);
                           yyPrevious;
                           return(47);
                          }
#TEXT# "</PROGRAM>"	: {
                           PhoneLogScanner_Attribute.lexstring = PutString("",0);
                           yyPrevious;
                           program=0;
                           return(43);
                          }
