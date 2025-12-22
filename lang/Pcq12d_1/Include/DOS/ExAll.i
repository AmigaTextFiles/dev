
{$I   "Include:UTility/Hooks.i"}

{  NOTE: V37 dos.library, when doing ExAll() emulation, and V37 filesystems  }
{  will return an error if passed ED_OWNER.  If you get ERROR_BAD_NUMBER,    }
{  retry with ED_COMMENT to get everything but owner info.  All filesystems  }
{  supporting ExAll() must support through ED_COMMENT, and must check Type   }
{  and return ERROR_BAD_NUMBER if they don't support the type.               }

{   values that can be passed for what data you want from ExAll() }
{   each higher value includes those below it (numerically)       }
{   you MUST chose one of these values }
CONST
     ED_NAME        = 1;
     ED_TYPE        = 2;
     ED_SIZE        = 3;
     ED_PROTECTION  = 4;
     ED_DATE        = 5;
     ED_COMMENT     = 6;
     ED_OWNER       = 7;
{
 *   Structure in which exall results are returned in.  Note that only the
 *   fields asked for will exist!
 }
Type
       ExAllData = Record
        ed_Next     : ^ExAllData;
        ed_Name     : String;
        ed_Type,
        ed_Size,
        ed_Prot,
        ed_Days,
        ed_Mins,
        ed_Ticks    : Integer;
        ed_Comment  : String;     {   strings will be after last used field }
        ed_OwnerUID,              { new for V39 }
        ed_OwnerGID : WORD;
       END;
       ExAllDataPtr = ^ExAllData;

{
 *   Control structure passed to ExAll.  Unused fields MUST be initialized to
 *   0, expecially eac_LastKey.
 *
 *   eac_MatchFunc is a hook (see utility.library documentation for usage)
 *   It should return true if the entry is to returned, false if it is to be
 *   ignored.
 *
 *   This structure MUST be allocated by AllocDosObject()!
 }

       ExAllControl = Record
        eac_Entries,                {   number of entries returned in buffer      }
        eac_LastKey  : Integer;     {   Don't touch inbetween linked ExAll calls! }
        eac_MatchString : String;   {   wildcard string for pattern match OR NULL }
        eac_MatchFunc : HookPtr;    {   optional private wildcard FUNCTION     }
       END;
       ExAllControlPtr = ^ExAllControl;

{ functions in V37 or higher }

FUNCTION ExAll(F : FileLock; Buffer : Address; BufferSize, InfoType : Integer; Control : ExAllControlPtr) : Boolean;
    External;

{ functions in V39 or higher }

PROCEDURE ExAllEnd(F : FileLock; Buffer : Address; BufferSize, InfoType : Integer; Control : ExAllControlPtr);
    External;

