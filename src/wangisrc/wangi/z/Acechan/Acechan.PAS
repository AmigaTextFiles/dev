(*****************************************************************************
 *
 * Acechan -- Produces data files which contain random data spread info.
 * (c)1995 Lee "Wangi" Kindness
 *
 *)

Program Acechan;

Uses
	Exec, AmigaDos, Amiga, Graphics;

Const
	{ Version string }
	VERSTAG : String[29] = '$VER: Acechan 1.3 (12.06.95)'#0;

Type
	tConfig = Record
		cf_Outfile    : String; { name of file to output to          }
		cf_Min,                 { minimum value of range             }
		cf_Max,                 { maximum value in range             }
		cf_Iterations,          { number of iterations               }
		cf_dp,                  { number of decimal places in output }
		cf_HashPer    : LONG;   { Hash for every n items             }
		cf_NoSysHog,            { Hog the system?                    }
		cf_RawOnly    : Boolean;{ do the graphical representation?   }
	End;

(*****************************************************************************)
Function GetInput(VAR cfg : tConfig) : Boolean;
{ Get options from the command line, using Amiga functions }

Const
	TEMP : String[90] = 'MINIMUM/N,MAXIMUM/N,ITERATIONS/N,DP/K/N,RAWONLY/S,SCALE=HASHPER/K/N,NOSYSHOG/S,OUTPUTFILE'#0;
	OPT_MIN   = 0; { minimum value of range             }
	OPT_MAX   = 1; { maximum value in range             }
	OPT_ITER  = 2; { number of iterations               }
	OPT_DP    = 3; { number of decimal places in output }
	OPT_RAW   = 4; { do the graphical representation?   }
	OPT_HAPER = 5; { hash per n items                   }
	OPT_NSYSH = 6;
	OPT_FILE  = 7; { name of file to output to          }
	rda : Array[OPT_MIN..OPT_FILE] Of Pointer = (NIL);

Var
	RDArgs : pRDArgs;

Begin
	GetInput := False;
	{ init cfg to defaults }
	With cfg do Begin
		cf_Min        := 1;
		cf_Max        := 100;
		cf_Iterations := 1000;
		cf_dp         := 4;
		cf_Outfile    := 'acechan.results';
		cf_RawOnly    := False;
		cf_NoSysHog   := False;
		cf_HashPer    := 1;
	End;
	RDArgs := ReadArgs(@TEMP[1], @rda, NIL);
	If RDArgs <> NIL Then Begin
		If rda[OPT_MIN] <> NIL Then
			cfg.cf_Min := pLONG(rda[OPT_MIN])^;
		If rda[OPT_MAX] <> NIL Then
			cfg.cf_Max := pLONG(rda[OPT_MAX])^;
		If rda[OPT_ITER] <> NIL Then
			cfg.cf_Iterations := pLONG(rda[OPT_ITER])^;
		If cfg.cf_Iterations < 10 Then
			cfg.cf_Iterations := 10;
		If rda[OPT_DP] <> NIL Then
			cfg.cf_dp := pLONG(rda[OPT_DP])^;
		If rda[OPT_RAW] <> NIL Then
			cfg.cf_RawOnly := True;
		If rda[OPT_HAPER] <> NIL Then
			cfg.cf_HashPer := pLONG(rda[OPT_HAPER])^;
		If rda[OPT_NSYSH] <> NIL Then
			cfg.cf_NoSysHog := True;
		If rda[OPT_FILE] <> NIL then
			cfg.cf_Outfile := PtrToPas(rda[OPT_FILE]);
		FreeArgs(RDArgs);
		GetInput := True;
	End;
End;

(*****************************************************************************)
Procedure DoIt(VAR cfg : tConfig);

(*****************)
(*
 * Set of functions to handle the 'array' type memory heap
 * quite a lot of dodgy programming here :)... Well not really, it is equiv.
 * to an array allocation in C...
 * If you are not an Amiga programmer then this might help:
 *  LONG = LongInt;
 *  pLONG = ^LONG;
 *  AllocVec allocates memory from the system, MENF_CLEAR specifying that
 *  it should be initilised to zeros, FreeVec will free this memory. I used
 *  Amiga kernal functions rather than portable pascal ones because the pascal
 *  ones use heap space...:(
 *)

Function AllocBuf : pLONG;
Begin
	AllocBuf := AllocVec((Sizeof(LONG) * (cfg.cf_Max - cfg.cf_Min + 1)), MEMF_CLEAR);
	(*
	 * Using standard pascal functions:
	 *
	 * VAR
	 *   p, e : pLONG;
	 *   n    : LONG;
	 *
	 * GetMem(p, (Sizeof(LONG) * (cfg.cf_Max - cfg.cf_Min + 1)));
	 * If p <> NIL Then Begin
	 *   FillChar(p^, (Sizeof(LONG) * (cfg.cf_Max - cfg.cf_Min + 1)), 0);
	 * End;
	 * AllocBuf := p;
	 *)
End;

Procedure FreeBuf(buf : pLONG);
Begin
	FreeVec(buf);
	(*
	 * Using standard pascal functions:
	 *
	 * FreeMem(buf, (Sizeof(LONG) * (cfg.cf_Max - cfg.cf_Min + 1)));
	 *)
End;

Procedure IncBuf(buf : pLONG; entry : LONG);
Var
	e : pLONG;
Begin
	e := pLONG(LONG(buf) + ((entry - cfg.cf_Min) * Sizeof(LONG)));
	inc(e^);
End;

Function AccessBuf(buf : pLONG; entry : LONG) : LONG;
Var
	e : pLONG;
Begin
	e := pLONG(LONG(buf) + ((entry - cfg.cf_Min) * Sizeof(LONG)));
	AccessBuf := e^;
End;

Function RandRange(min, max : LONG) : LONG;
Begin
	RandRange := Random(max - min + 1) + min;
End;
	
(*****************)

Var
	buf : pLONG;
	n, num, y, currentnumhash : LONG;
	f : Text;
	
Begin
	Randomize;
	With cfg Do Begin
		buf := AllocBuf;
		If buf <> NIL Then begin
			{ generate the random spread }
			For n := 1 To cf_Iterations do Begin
				num := RandRange(cf_Min, cf_Max);
				IncBuf(buf, num);
				{ wait a while... if wished }
				If cf_NoSysHog Then
					WaitTOF;
			End;
			{ create the output file }
			{ Assign(f, cf_OutFile); }
			{$I-} ReWrite(f, cf_Outfile); {$I+}
			If IOResult = 0 Then Begin
				Writeln(f, '; Data results file created by Acechan, ©Lee Kindness');
				Writeln(f, '; ',verstag);
				Writeln(f, ';');
				Writeln(f, '; Preferences:');
				Writeln(f, '; OUTPUTFILE = "',cf_Outfile,'"');
				Writeln(f, '; MINIMUM    = ',cf_Min);
				Writeln(f, '; MAXIMUM    = ',cf_Max);
				Writeln(f, '; ITERATIONS = ',cf_Iterations);
				Writeln(f, '; DP         = ',cf_dp);
				Writeln(f, '; RAWONLY    = ',cf_RawOnly);
				Writeln(f, '; HASHPER    = ',cf_HashPer);
				Writeln(f, '; NOSYSHOG   = ',cf_NoSYSHog);
				{ the raw data }
				Writeln(f, ';');
				Writeln(f, '; RAW DATA:');
				Writeln(f, ';');
				For n := cf_Min to cf_Max do
					Writeln(f, n:5,' : ',AccessBuf(buf, n):5,', ',((AccessBuf(buf, n)/cf_Iterations)*100):0:cf_dp,'%');
				If NOT cf_RawOnly Then Begin
					{ the distribution 'curve' }
					Writeln(f, ';');
					Writeln(f, '; DISTRIBUTED REPRESENTATION');
					Writeln(f, ';');
					
					For n := cf_Min to cf_Max do Begin
						Write(f, n:5,' ');
						num := AccessBuf(buf, n);
						currentnumHash := 0;
						for y := 1 to num Do Begin
							inc(currentnumhash);
							If currentnumhash >= cf_HashPer Then begin
								currentnumhash := 0;
								Write(f, '#');
							End;
						End;
						Writeln(f, '  ',num,' ',((AccessBuf(buf, n)/cf_Iterations)*100):0:cf_dp,'%');
					End;
				End;
				Writeln(f, ';');
				Writeln(f, '; END OF FILE');
				Writeln(f, ';');
				Writeln('Finished... Data file is "',cf_OutFile,'"');
				Close(f);
			End;
			FreeBuf(buf);
		End Else
			Writeln('Insuficient memory... try lowering MAXIMUM');
	End;
End;

(*****************************************************************************)
Procedure Main;

Var
	cfg : tConfig;

Begin
	If pLibrary(SysBase)^.lib_Version >= 36 Then Begin
		If pLibrary(DosBase)^.lib_Version >= 36 Then Begin
			GfxBase := pGfxBase(OpenLibrary('graphics.library', 0));
			if GfxBase <> NIL Then Begin
				If GetInput(cfg) Then Begin
					DoIt(cfg);
				End;
			CloseLibrary(pLibrary(GfxBase));
			End;
		End Else Writeln('requires dos 36');
	End Else Writeln('requires exec 36');
End;

(*****************************************************************************)
Begin main End.

(*****************************************************************************)