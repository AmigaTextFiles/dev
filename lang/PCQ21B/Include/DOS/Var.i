
{$I   "Include:Exec/Nodes.i"}

{      the structure in the pr_LocalVars list }
{      Do NOT allocate yourself, use SetVar()!!! This structure may grow in }
{      future releases!  The list should be left in alphabetical order, and }
{      may have multiple entries with the same name but different types.    }
Type
       LocalVar = Record
        lv_Node  : Node;
        lv_Flags : Short;
        lv_Value : String;
        lv_Len   : Integer;
       END;
       LocalVarPtr = ^LocalVar;

{
 * The lv_Flags bits are available to the application.  The unused
 * lv_Node.ln_Pri bits are reserved for system use.
 }

CONST
{      bit definitions for lv_Node.ln_Type: }
       LV_VAR               =   0;       {      an variable }
       LV_ALIAS             =   1;       {      an alias }
{      to be or'ed into type: }
       LVB_IGNORE           =   7;       {      ignore this entry on GetVar, etc }
       LVF_IGNORE           =   $80;

{      definitions of flags passed to GetVar()/SetVar()/DeleteVar() }
{      bit defs to be OR'ed with the type: }
{      item will be treated as a single line of text unless BINARY_VAR is used }
       GVB_GLOBAL_ONLY       =  8   ;
       GVF_GLOBAL_ONLY       =  $100;
       GVB_LOCAL_ONLY        =  9   ;
       GVF_LOCAL_ONLY        =  $200;
       GVB_BINARY_VAR        =  10  ;            {      treat variable as binary }
       GVF_BINARY_VAR        =  $400;

{ this is only supported in >= V39 dos.  V37 dos ignores this. }
{ this causes SetVar to affect ENVARC: as well as ENV:.        }
      GVB_SAVE_VAR           = 12 ;     { only with GVF_GLOBAL_VAR }
      GVF_SAVE_VAR           = $1000 ;


FUNCTION DeleteVar(name : String; VarType : Integer) : Boolean;
    External;

FUNCTION FindVar(name : String; flags : Integer) : LocalVarPtr;
    External;

FUNCTION GetVar(name : String; Buffer : String; BufferSize : Integer; flags : Integer) : Integer;
    External;

FUNCTION SetVar(name, new : String; len, flags : Integer) : Boolean;
    External;


