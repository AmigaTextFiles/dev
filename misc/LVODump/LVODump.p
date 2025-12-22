{ ************************************************************************ }
{ ************************************************************************ }
{ **************************                    ************************** }
{ ************************ }  PROGRAM LVODump;  { ************************ }
{ **************************                    ************************** }
{ ************************************************************************ }
{ ************************************************************************ }
{ **                                                                    ** }
{ **  This programs prints to standard output a list of Library Vectors ** }
{ **  Offsets for the library specified as the parameter,  in a format  ** }
{ **  very similar to that of RKM: Libraries and Devices, appendix D.   ** }
{ **                                                                    ** }
{ **  The .fd file can be specified without the complete path if it is  ** }
{ **  either in the current directory or in the fd: logical volume.     ** }
{ **                                                                    ** }
{ ************************************************************************ }
{ **                                                                    ** }
{ **                    Created by  Marco Favaretto                     ** }
{ **            -------------------------------------------             ** }
{ **                   Compiled with KickPascal 2.10                    ** }
{ **                                                                    ** }
{ ************************************************************************ }
{ **                                                                    ** }
{ **  History:                                                          ** }
{ **                                                                    ** }
{ **  950831    1.0     First release                                   ** }
{ **                                                                    ** }
{ ************************************************************************ }
{ ************************************************************************ }


{$OPT A-,B-,I-,S-,T-}                   { all compiler options off         }


CONST
        YES = TRUE;                     { boolean value                    }
        NO = FALSE;                     { boolean value                    }

        HEAD = 1;                       { see RemoveSpaces()               }
        TAIL = 2;                       { see RemoveSpaces()               }

        BIASSTEP = 6;                   { bias step, right!                }

        SPACE = ' ';                    { word & output columns separator  }
        TAB   = #$09;                   { output columns separator         }
        LF    = #$0A;                   { input terminator                 }
        COMMA = ',';                    { template separator               }
        COLON = ':';                    { template/option list separator   }
        SLASH = '/';                    { template separator               }
        POINT = '.';                    { option list terminator           }

        EMPTYSTRING = '';
        MAXSTRLEN = 255;

        TEMPLATEREQUEST = '?';          { user request for template        }


TYPE

{ ___ IMPORTANT: do not modify the order of ErrorType options, because ___ }
{ ___            doing so will alter the errorcodes of the program     ___ }

        ErrorType = (SYNTAX, NOFILENAME, FILENOTFOUND, NOBIAS, INVALIDBIAS,
                     UNKNOWNDIRECTIVE);

{ ___ IMPORTANT: do not modify the order of ParamType and DirectiveType __ }
{ ___            options; otherwise, you MUST modify the related string __ }
{ ___            definition in LVODumpSupport.s in the same way.        __ }

        ParamType = (UNKNOWN_PAR, FILENAME_PAR, NOTAB_PAR, NOHEADER_PAR,
                     NOBASE_PAR, NOPRIVATE_PAR);

        DirectiveType = (UNKNOWN_DIR, BASE_DIR, BIAS_DIR, PRIVATE_DIR,
                         PUBLIC_DIR, END_DIR);

        InString = string[MAXSTRLEN];   { for readln from text files, so   }
                                        { the length is no longer limited  }
                                        { to 80 chars per line             }

VAR
        InFile:       TEXT;             { .fd file in input                }
        InLine:       InString;         { a line from input file           }
        FName:        string;           { .fd file name                    }
        Bias:         long;             { library vector offset counter    }
        BaseName:     string;           { name of library base             }
        Separator:    char;             { column separator                 }
        PrintHeader:  boolean;          { flag for output header           }
        PrintBase:    boolean;          { flag for output basename         }
        PrintPrivate: boolean;          { flag for private LVO output      }
        HeaderOut:    boolean;          { flag for header (NOT) printed    }
        IsPublic:     boolean;          { flag for private LVO             }

{ ___ Following vars are uses as Typed Constants with predefined values __ }
{ ___ (look at LVODumpSupport.s)                                        __ }

        CTEMPLATE:    string;  IMPORT;  { COMMA + command template         }
        TEMPLATE:     string;  IMPORT;  { command template                 }
        CDIRECTIVES:  string;  IMPORT;  { COMMA + list of .fd directives   }
        DIRECTIVES:   string;  IMPORT;  { list of .fd directives           }
        FNAMEEND:     string;  IMPORT;  { the .fd files ends this way      }
        FDPATH:       string;  IMPORT;  { logical volume for .fd. files    }
        BANNER:       string;  IMPORT;  { copyright message and syntax     }


{$LINK 'LVODumpSupport.o'}

PROCEDURE UpCaseStr(VAR a0:InString); EXTERNAL;


{ ___ Output error message and terminate program _________________________ }
{ ________________________________________________________________________ }

PROCEDURE ShowError(er: ErrorType);

VAR
        s: InString;

Begin

   CASE er OF

         SYNTAX:           write(BANNER);
         NOFILENAME:       write('Missing filename.');
         FILENOTFOUND:     write('File not found: ' + FName);
         NOBIAS:           write(FName + ': missing bias directive.');
         INVALIDBIAS:      write(FName + ': invalid bias value.');
         UNKNOWNDIRECTIVE: write(FName + ': unknown directive.')

      End;

   IF er > FILENOTFOUND THEN    { in this case (only) InFile is open       }
      Close(InFile);

   Halt(ord(er) + 21)           { exit error code                          }

End;


{ ___ Remove head and tail spaces from a string __________________________ }
{ ________________________________________________________________________ }

FUNCTION RemoveSpaces(s:InString, Where:byte): InString;

VAR
        First, Last: byte;

Begin
   First := 1;
   IF (Where AND HEAD) = HEAD THEN
      WHILE (s[First] IN [SPACE, TAB]) DO
         Inc(First);

   Last := length(s);
   IF (Where AND TAIL) = TAIL THEN
      WHILE (Last >= First) AND (s[Last] IN [SPACE, TAB, LF]) DO
         Dec(Last);

   RemoveSpaces := copy(s, First, Last-First+1)
End;


{ ___ Extract (and possibly remove) the first word from a string _________ }
{ ________________________________________________________________________ }

FUNCTION GetFirstWord(VAR s:InString, cut:boolean): InString;

VAR
        z: byte;

Begin
   z := pos(SPACE,s);
   IF z = 0 THEN Begin

      z := pos(TAB,s);
      IF z = 0 THEN
         z := length(s) + 1

      End;

   GetFirstWord := copy(s,1,z-1);

   IF cut THEN
      s := RemoveSpaces(copy(s,z,MAXSTRLEN), HEAD)

End;
 

{ ___ Convert a long to hexadecimal string of p chars ____________________ }
{ ________________________________________________________________________ }

FUNCTION Hex(n:long, p:byte):string;

CONST
        HEXDIGITS='0123456789ABCDEF';

VAR
        s: string[9];
        z: byte;

Begin
   z := 9;
   s := '000000000';

   WHILE n > 0 DO Begin
      Dec(z);
      s[z] := HEXDIGITS.[(n MOD 16)+1];
      n := n DIV 16
      End;

   Hex := copy(s,9-p,p)
End;


{ ___ Compare an option (string) with a list of options __________________ }
{ ________________________________________________________________________ }

FUNCTION CheckOption(Pattern: string; Opt:InString): integer;

VAR
        z:   byte;
        s:   string;
        p_s: str;
        c:   integer;

Begin

   c := 0;

   s := COMMA + Opt + SLASH;
   z := pos(s, Pattern);
   IF z = 0 THEN Begin

      s := COMMA + Opt + COMMA;
      z := pos(s, Pattern);
      IF z = 0 THEN Begin

         s := COMMA + Opt + COLON;
         z := pos(s, Pattern);
         IF z = 0 THEN Begin

            s := COMMA + Opt + POINT;
            z := pos(s, Pattern);
            IF z = 0 THEN Begin

               CheckOption := c;
               Exit
               End

            End

         End

      End;

   s := copy(Pattern, 1, z-1);
   p_s := s;

   REPEAT
      Inc(c);
      z := pos(COMMA, p_s);
      p_s := str(long(p_s)+z)
   UNTIL z = 0;

   CheckOption := c

End;


{ ___ Compare each parameter on command line with template _______________ }
{ ________________________________________________________________________ }

FUNCTION CheckParameter(Param: InString): ParamType;

VAR
        z:  integer;
        cp: ParamType;

Begin

   UpCaseStr(Param);
   z := CheckOption(CTEMPLATE, Param);
   
   cp := UNKNOWN_PAR;
   WHILE z > 0 DO Begin
      cp := succ(cp);
      Dec(z)
      End;

   CheckParameter := cp

End;


{ ___ Analyse the parameter line _________________________________________ }
{ ________________________________________________________________________ }

PROCEDURE AnalyzeParameterLine;


VAR
        ParmLine: InString;
        Param:    InString;

Begin
   ParmLine := RemoveSpaces(copy(parameterstr,1,parameterlen), HEAD + TAIL);

   IF ParmLine = EMPTYSTRING THEN
      ShowError(NOFILENAME);

{$OPT B+}                               { let the user break from here...  }

   WHILE ParmLine = TEMPLATEREQUEST DO Begin

      write(TEMPLATE);
      readln(ParmLine);
      ParmLine := RemoveSpaces(ParmLine, HEAD + TAIL)
      End;

{$OPT B-}                               { ...to here.                      }
 
   WHILE ParmLine > EMPTYSTRING DO Begin
      Param := GetFirstWord(ParmLine, YES);
      CASE CheckParameter(Param) OF

            UNKNOWN_PAR:   IF FName = '' THEN
                                 FName := Param
                              ELSE
                                 ShowError(SYNTAX);

            FILENAME_PAR:  IF FName = '' THEN
                                FName := GetFirstWord(ParmLine, YES)
                             ELSE
                                ShowError(SYNTAX);

            NOTAB_PAR:     Separator := SPACE;

            NOHEADER_PAR:  PrintHeader := NO;

            NOBASE_PAR:    PrintBase := NO;

            NOPRIVATE_PAR: PrintPrivate := NO

         End { CASE }

      End; { WHILE }

   IF FName = EMPTYSTRING THEN
      ShowError(NOFILENAME)

End;


{ ___ Extract Bias value from a ##bias directive _________________________ }
{ ________________________________________________________________________ }

FUNCTION GetBias(s:InString): long;

VAR
        err: integer;
        v:   long;

Begin
   Val(s, v, err);
   IF err <> 0 THEN
      ShowError(INVALIDBIAS);
   GetBias := v
End;


{ ___ Compare each directive in InLine with directives list ______________ }
{ ________________________________________________________________________ }

FUNCTION CheckDirective(Dir: InString): DirectiveType;

VAR
        z:  integer;
        cd: DirectiveType;

Begin

   UpCaseStr(Dir);
   z := CheckOption(CDIRECTIVES, Dir);
   
   cd := UNKNOWN_DIR;
   WHILE z > 0 DO Begin
      cd := succ(cd);
      Dec(z)
      End;

   CheckDirective := cd

End;


{ ___ Analyse each line and produce output _______________________________ }
{ ________________________________________________________________________ }

PROCEDURE ProcessLine(s:InString);

VAR
        z: byte;

Begin
   CASE s[1] OF
 
         '*': ;

         '#': CASE CheckDirective(GetFirstWord(s, YES)) OF

                    BIAS_DIR:    bias := GetBias(s);

                    BASE_DIR:    IF PrintBase THEN
                                    BaseName := s;

                    PUBLIC_DIR:  IsPublic := YES;

                    PRIVATE_DIR: IsPublic := NO;

                    END_DIR:     ;

                    UNKNOWN_DIR: ShowError(UNKNOWNDIRECTIVE)

                 End;

      OTHERWISE Begin

         IF Bias = MAXLONGINT THEN
            ShowError(NOBIAS);

         IF (NOT HeaderOut) AND PrintHeader THEN Begin

            HeaderOut := YES;

            z := pos(FNAMEEND, FName);
            IF z<>0 THEN
                  write(copy(FName,1,z-1))
               ELSE
                  write(FName);

            write(' Library Vectors Offsets');

            IF (BaseName <> EMPTYSTRING) AND PrintBase THEN
                  writeln('   (Base name: ',BaseName,')')
               ELSE
                  writeln

            End;
            
         IF PrintPrivate OR IsPublic THEN Begin
            write(Bias:4,Separator,'$',Hex(65536-Bias,4),Separator);
            writeln('-$',Hex(Bias,4),Separator,s)
            End;

         Bias := Bias + BIASSTEP
         End

      End

End;


{ ___ Open input file and do the real work _______________________________ }
{ ________________________________________________________________________ }

PROCEDURE ProcessFile;

Begin

{ ___ Try to open file ___________________________________________________ }

   Assign(InFile, FName);
   Reset(InFile);
   IF IOResult <> 0 THEN Begin

      Assign(InFile, FName + FNAMEEND);
      Reset(InFile);
      IF IOResult <> 0 THEN Begin

         Assign(InFile, FDPATH + FName);
         Reset(InFile);
         IF IOResult <> 0 THEN Begin

            Assign(InFile, FDPATH + FName + FNAMEEND);
            Reset(InFile);
            IF IOResult <> 0 THEN

               ShowError(FILENOTFOUND);

            End
         End
      End;


{$OPT B+}                               { the user can break from here     }

{ ___ Scan file line by line, producing output ___________________________ }

   REPEAT                               { Note that readln set EOF to TRUE }
      readln(InFile,InLine);            { when it reads the last line from }
      ProcessLine(InLine)               { the file, and not when it tries  }
   UNTIL EOF(InFile);                   { to read the (unexisting) next.   }

{$OPT B-}                               { the user needs to break no more  }

   Close(InFile)

End;


{ ___ Set up the global variables ________________________________________ }
{ ________________________________________________________________________ }

PROCEDURE SetUpVars;

Begin
   Bias := MAXLONGINT;
   FName := EMPTYSTRING;
   BaseName := EMPTYSTRING;

   PrintHeader := YES;
   PrintBase := YES;
   PrintPrivate := YES;
   Separator := TAB;

   HeaderOut := NO;
   IsPublic := YES
End;


{ ___ Main program _______________________________________________________ }
{ ________________________________________________________________________ }

Begin
   SetUpVars;
   AnalyzeParameterLine;
   ProcessFile
End.
