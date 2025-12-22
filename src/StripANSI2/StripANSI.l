%{
/*****************************************************************************
 **
 *        File:   StripANSI.l - Strip ANSI files of ANSI codes
 **
 *     Project:   JMA Utilities
 *
 *     Created:   Wednesday 26-Jan-94 00:24:02
 *
 *      Author:   Jon M. Armstrong
 *                315 Dale Drive
 *                Farmington, New York 14425
 *
 *                (c) Copyright 1994
 *
 *  Notes:
 *
 *   I'm tired of picking up text/documentation files that contain
 *   ANSI escape codes and other helpful character sequences.
 *   Personally,  I like using my favorite text editor, as opposed
 *   to a 'More' or 'Less' reader.
 *
 *   This huge utility strips a few ANSI-ish sequences from any file.
 *
 *   This file, if you haven't guessed, is the source code for this
 *   very complex utility :).
 *
 *   To rebuild this utility, try the following:
 *
 *     flex -8 StripANSI.l
 *     gcc -o StripANSI2 -O2 -s lex.yy.c
 *
 *   I used flex version 2.3 and gcc version 2.3.3 to generate the
 *   included Amiga executable.  The ixemul.library is probably
 *   required to run this program.  If you have gcc for the Amiga,
 *   you are likely to also have ixemul.library.  If you rebuild this
 *   with another compiler, you may not have this restriction.
 *
 *   This archive contains at least one (1) sample file containing
 *   character sequences that the utility will strip and a script
 *   that shows how the utility is used to strip the file.  The
 *   resulting output file is also included.
 *
 *   Usage: StripANSI2 < Input.file > Output.file
 *
 *   It almost took longer for me to type this short description
 *   than it took to write the code.  I didn't use a formal ANSI
 *   reference to write this, so I'm sure there are a few sequences
 *   that aren't covered, as well as a few invalid sequences that
 *   are covered.
 *
 *   Feel free to drop me a line, if you have any questions.
 *   I try to listen in on the FIDO Amiga programming echo.
 *
 *   Have fun.
 *
 *    $Log: StripANSI.l,v $
 *
 *****************************************************************************/

static int lines=0;
static int chars=0;
static int kills=0;
%}


Digit       [0-9]
Ps          [0-9;]*
Pn          [0-9]*
OverStrike  (.\b)
ESC         (\x1b)
CSI0        (\x9b)
CSI         (({CSI0})|({ESC}\[))
TMode1      ({Pn}[ ][@ACE])
TMode2      (([?]?){Pn}([a-zA-Z@\`]|(\"q)|(!p)))
TMode3      ({Pn}[;]{Pn}[frHR])
TMode4      ({Pn}[;]{Pn}[ ][BDG])
TMode5      ({Ps}[a-zA-Z])
TMode6      ({Ps}[ ][FH])
TermModes   ({TMode1}|{TMode2}|{TMode3}|{TMode4}|{TMode5}|{TMode6})
ESCCODES    ([abcD-W78\\\]\^]|([#]{Digit}))
CSICODES    ({TermModes})
ANSI        ({OverStrike}|({CSI}{CSICODES})|({ESC}{ESCCODES}))
NPrintable  ([^\n\t \-\xadA-Za-z0-9!@#$\%^&*()_+|=`,./<>/?;':"~{}\\\[\]])

%%
{ANSI}          {kills++;}
{NPrintable}    {kills++;}

"\n"{2,}	{printf("\n\n");chars+=2;lines+=2;}
"\n"		{ECHO;chars++;lines++;}
.		{ECHO;chars++;}

%%
int yyerror(s)
char *s ;
{
}

main()
{
  yylex();
}
