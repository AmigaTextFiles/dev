
{
	ExecOther.i of PCQ Pascal

	This file defines the Exec routines that are not defined
	elsewhere.
}

Procedure Debug(Param : Integer);	{ Always pass zero for now }
    External;

Function GetCC : Integer;
    External;

Procedure RawDoFmt(Form : String;
		   data : Address;
		   putChProc : Address;
		   putChData : Address);
    External;

Function SetSR(newSR, mask : Integer) : Integer;
    External;



{ -- 2.0 fcts. -- }

Procedure CacheClearE( cxa : Address; lenght, caches : Integer);
    External;

Procedure CacheClearU;
    External;

Type
    oldbits = Integer;

Function CacheControl( cachebits, cachemask: Integer ): OldBits; 
    External;


Procedure CachePostDMA( vaddress, length_IntPtr : Address; flags : Integer );
    External;


Function CachePreDMA(	vaddress, length_intPtr : Address;
			flags : Integer): Address;
    External;


Procedure ChildFree( tid : Integer);
    External;

Procedure ChildOrphan( tid : Integer);
    External;


Procedure ChildStatus( tid : Integer);
    External;


Procedure ChildWait( tid : Integer);
    External;


Procedure ColdReboot;
    External;


Procedure StackSwap( StackSwapRecord : Address );
    External;

