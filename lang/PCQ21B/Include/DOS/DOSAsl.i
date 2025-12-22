
{$I   "Include:Exec/Libraries.i"}
{$I   "Include:Exec/Lists.i"}
{$I   "Include:DOS/DOS.i"}


{**********************************************************************
************************ PATTERN MATCHING ******************************
************************************************************************

* structure expected by MatchFirst, MatchNext.
* Allocate this structure and initialize it as follows:
*
* Set ap_BreakBits to the signal bits (CDEF) that you want to take a
* break on, or NULL, if you don't want to convenience the user.
*
* If you want to have the FULL PATH NAME of the files you found,
* allocate a buffer at the END of this structure, and put the size of
* it into ap_Strlen.  If you don't want the full path name, make sure
* you set ap_Strlen to zero.  In this case, the name of the file, and stats
* are available in the ap_Info, as per usual.
*
* Then call MatchFirst() and then afterwards, MatchNext() with this structure.
* You should check the return value each time (see below) and take the
* appropriate action, ultimately calling MatchEnd() when there are
* no more files and you are done.  You can tell when you are done by
* checking for the normal AmigaDOS return code ERROR_NO_MORE_ENTRIES.
*
}

Type
       AChain = Record
        an_Child,
        an_Parent   : ^AChain;
        an_Lock     : BPTR;
        an_Info     : FileInfoBlock;
        an_Flags    : Byte;
        an_String   : Array[0..0] of Char;   { FIX!! }
       END;
       AChainPtr = ^AChain;


       AnchorPath = Record
        ap_Base,                    { pointer to first anchor }
        ap_Last  : AChainPtr;       { pointer to last anchor }
        ap_BreakBits,               { Bits we want to break on }
        ap_FoundBreak : Integer;    { Bits we broke on. Also returns ERROR_BREAK }
        ap_Flags      : Byte;       { New use for extra word. }
        ap_Reserved   : Byte;
        ap_Strlen     : Short;      { This is what ap_Length used to be }
        ap_Info       : FileInfoBlock;
        ap_Buf        : Array[0..0] of Char;     { Buffer for path name, allocated by user !! }
        { FIX! }
       END;
       AnchorPathPtr = ^AnchorPath;


CONST
    APB_DOWILD    =  0;       { User option ALL }
    APF_DOWILD    =  1;

    APB_ITSWILD   =  1;       { Set by MatchFirst, used by MatchNext  }
    APF_ITSWILD   =  2;       { Application can test APB_ITSWILD, too }
                                { (means that there's a wildcard        }
                                { in the pattern after calling          }
                                { MatchFirst).                          }

    APB_DODIR     =  2;       { Bit is SET IF a DIR node should be }
    APF_DODIR     =  4;       { entered. Application can RESET this }
                                { bit after MatchFirst/MatchNext to AVOID }
                                { entering a dir. }

    APB_DIDDIR    =  3;       { Bit is SET for an "expired" dir node. }
    APF_DIDDIR    =  8;

    APB_NOMEMERR  =  4;       { Set on memory error }
    APF_NOMEMERR  =  16;

    APB_DODOT     =  5;       { IF set, allow conversion of '.' to }
    APF_DODOT     =  32;      { CurrentDir }

    APB_DirChanged  = 6;       { ap_Current->an_Lock changed }
    APF_DirChanged  = 64;      { since last MatchNext call }


    DDB_PatternBit  = 0;
    DDF_PatternBit  = 1;
    DDB_ExaminedBit = 1;
    DDF_ExaminedBit = 2;
    DDB_Completed   = 2;
    DDF_Completed   = 4;
    DDB_AllBit      = 3;
    DDF_AllBit      = 8;
    DDB_Single      = 4;
    DDF_Single      = 16;

{
 * Constants used by wildcard routines, these are the pre-parsed tokens
 * referred to by pattern match.  It is not necessary for you to do
 * anything about these, MatchFirst() MatchNext() handle all these for you.
 }

    P_ANY         =  $80;    { Token for '*' or '#?  }
    P_SINGLE      =  $81;    { Token for '?' }
    P_ORSTART     =  $82;    { Token for '(' }
    P_ORNEXT      =  $83;    { Token for '|' }
    P_OREND       =  $84;    { Token for ')' }
    P_NOT         =  $85;    { Token for '~' }
    P_NOTEND      =  $86;    { Token for }
    P_NOTCLASS    =  $87;    { Token for '^' }
    P_CLASS       =  $88;    { Token for '[]' }
    P_REPBEG      =  $89;    { Token for '[' }
    P_REPEND      =  $8A;    { Token for ']' }
    P_STOP        =  $8B;    { token to force end of evaluation }

{ Values for an_Status, NOTE: These are the actual bit numbers }

    COMPLEX_BIT   =  1;       { Parsing complex pattern }
    EXAMINE_BIT   =  2;       { Searching directory }

{
 * Returns from MatchFirst(), MatchNext()
 * You can also get dos error returns, such as ERROR_NO_MORE_ENTRIES,
 * these are in the dos.h file.
 }

    ERROR_BUFFER_OVERFLOW  = 303;     { User OR internal buffer overflow }
    ERROR_BREAK            = 304;     { A break character was received }
    ERROR_NOT_EXECUTABLE   = 305;     { A file has E bit cleared }

PROCEDURE MatchEnd(A : AnchorPathPtr);
    External;

FUNCTION MatchFirst(pattern : String; A : AnchorPathPtr) : Integer;
    External;

FUNCTION MatchNext(A : AnchorPathPtr) : Integer;
    External;

FUNCTION MatchPattern(pattern : Address; Str : String) : Boolean;
    External;

FUNCTION MatchPatternNoCase(pattern : Address; Str : String) : Boolean;
    External;

FUNCTION ParsePattern(pattern, Buffer : String; BufferSize : Integer) : Integer;
    External;

FUNCTION ParsePatternNoCase(pattern, Buffer : String; BufferSize : Integer) : Integer;
    External;


