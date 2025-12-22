with System;
with Interfaces; use Interfaces;
with Interfaces.C; use Interfaces.C;
with Interfaces.C.Strings; use Interfaces.C.Strings;

with Utility_Hooks; use utility_hooks;
with intuition_classusr; use intuition_classusr;
with intuition_classes; use intuition_classes;
with exec_exec; use exec_exec;
with exec_ports; use exec_ports;
with exec_lists; use exec_lists;
with exec_io; use exec_io;

with devices_inputevent; use devices_inputevent;
with devices_timer; use devices_timer;

with Incomplete_type; use Incomplete_type;
package amiga_lib is

--#ifndef LIBRARIES_COMMODITIES_H
--#include <libraries/commodities.h>
--#endif

procedure BeginIO( ioReq : IORequest_Ptr );
pragma Import (C, BeginIO, "BeginIO" );
function CreateExtIO( port : MsgPort_Ptr; ioSize : Integer ) return IORequest_Ptr;
pragma Import (C, CreateExtIO, "CreateExtIO" );
function CreatePort( name : Chars_Ptr; pri : Integer ) return MsgPort_Ptr;
pragma Import (C, CreatePort, "CreatePort" );
function CreateStdIO( port : MsgPort_Ptr ) return IOStdReq_Ptr;
pragma Import (C, CreateStdIO, "CreateStdIO" );
function CreateTask( name : Chars_Ptr; pri : Integer; initPC : Integer_Ptr; StackSize : Unsigned_32 ) return AmigaTask_Ptr;
pragma Import (C, CreateTask, "CreateTask" );
procedure DeleteExtIO( ioReq : IORequest_Ptr );
pragma Import (C, DeleteExtIO, "DeleteExtIO" );
procedure DeletePort( ioReq : MsgPort_Ptr );
pragma Import (C, DeletePort, "DeletePort" );
procedure DeleteStdIO( ioReq : IOStdReq_Ptr );
pragma Import (C, DeleteStdIO, "DeleteStdIO" );
procedure DeleteTask( A_task : AmigaTask_Ptr );
pragma Import (C, DeleteTask, "DeleteTask" );
procedure NewList( list : List_Ptr );
pragma Import (C, NewList, "NewList" );
procedure AddTOF( i : Isrvstr_Ptr; p : System.Address; a : Integer );
pragma Import (C, AddTOF, "AddTOF" );
procedure RemTOF( i : Isrvstr_Ptr );
pragma Import (C, RemTOF, "RemTOF" );
procedure waitbeam( b : Integer );
pragma Import (C, waitbeam, "waitbeam" );
function afp( string : Chars_Ptr ) return FLOAT;
pragma Import (C, afp, "afp" );
procedure arnd( place : Integer; exp : Integer; string : Chars_Ptr );
pragma Import (C, arnd, "arnd" );
function dbf( exp : Unsigned_32; mant : Unsigned_32 ) return FLOAT;
pragma Import (C, dbf, "dbf" );
function fpa( fnum : FLOAT; string : Chars_Ptr ) return INTEGER;
pragma Import (C, fpa, "fpa" );
procedure fpbcd( fnum : FLOAT; string : Chars_Ptr );
pragma Import (C, fpbcd, "fpbcd" );
function TimeDelay( unit : Integer; secs : Unsigned_32 ; microsecs : Unsigned_32 ) return INTEGER;
pragma Import (C, TimeDelay, "TimeDelay" );
function DoTimer( time : timeval_Ptr ; unit : Integer; command : Integer ) return INTEGER;
pragma Import (C, DoTimer, "DoTimer" );
procedure ArgArrayDone;
pragma Import (C, ArgArrayDone, "ArgArrayDone" );
function ArgArrayInit( argc : Integer; argv : Integer_8_Ptr_Ptr ) return Integer_8_Ptr_Ptr;
pragma Import (C, ArgArrayInit, "ArgArrayInit" );
function ArgInt( tt : Unsigned_8_Ptr_Ptr; an_entry : Chars_Ptr; defaultval : Integer ) return INTEGER;
pragma Import (C, ArgInt, "ArgInt" );
function ArgString( tt : Unsigned_8_Ptr_Ptr; an_entry : Chars_Ptr; defaulstring : Chars_Ptr ) return Chars_Ptr;
pragma Import (C, ArgString, "ArgString" );
function HotKey( description : Chars_Ptr; port : MsgPort_Ptr; id : Integer ) return CxObj_Ptr;
pragma Import (C, HotKey, "HotKey" );
function InvertString( str : Chars_Ptr; km : KeyMap_Ptr ) return InputEvent_Ptr;
pragma Import (C, InvertString, "InvertString" );
procedure FreeIEvents( events : InputEvent_Ptr );
pragma Import (C, FreeIEvents, "FreeIEvents" );
function CheckRexxMsg( rexxmsg : Message_Ptr ) return Boolean;
pragma Import (C, CheckRexxMsg, "CheckRexxMsg" );
function GetRexxVar( rexxmsg : Message_Ptr; name : Unsigned_8_Ptr; result : Unsigned_8_Ptr_Ptr ) return INTEGER;
pragma Import (C, GetRexxVar, "GetRexxVar" );
function SetRexxVar( rexxmsg : Message_Ptr; name : Unsigned_8_Ptr; value : Unsigned_8_Ptr;length : Integer ) return INTEGER;
pragma Import (C, SetRexxVar, "SetRexxVar" );
function callHookPkt( hook_Ptr : Hook_Ptr; obj : Object_Ptr; message : Integer_Ptr ) return Unsigned_32;
pragma Import (C, callHookPkt, "callHookPkt" );
function SetSuperAttrs( cl : IClass_Ptr; obj : Object_Ptr; Tag1 : Unsigned_32 ) return Unsigned_32;
pragma Import (C, SetSuperAttrs, "SetSuperAttrs" );

function DoMethodA( obj : Object_Ptr ; message : Msg ) return Unsigned_32;
function DoSuperMethodA( cl : IClass_Ptr; obj : Object_Ptr; Message : Msg ) return Unsigned_32;
function CoerceMethodA( cl : IClass_Ptr; obj : Object_Ptr ; Message : Msg ) return Unsigned_32;

end amiga_lib;
