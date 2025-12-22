program AskDDTI;

uses Exec, datatypes, Amiga, AmigaDOS, IFFParse, Intuition, Icon, Workbench;

CONST
	Template : String[29] = 'FILE/A,COARSE/S,NODATATYPE/S'#0;
	RD_Array : Array [0..3] of LongInt = (0);
	Ver      : String[25] = 'AskDDTI 1.2 Lee Kindness'#0;
	
VAR
	RDArg  : pRDArgs;
	l, dl1, 
	dl2    : BPTR;
	dt     : pDataType;
	BName, ts,
	IName  : String;
	FName  : STRPTR;
	buf    : String[7];
	OK     : Boolean;
	RemKey : pRemember;
	dobj   : pDiskObject;

function CStrConstPtrAR(rk:ppRemember; s : string): STRPTR;

var  p : STRPTR;
begin
  s := s + #0;                                    { Make "C" string }
  p := AllocRemember(rk, length(s), MEMF_CLEAR);  { Get some mem for it }
  move(s[1], p^, length(s));                      { Move s into newly alloc'd mem }
  CStrConstPtrAR := p                               { Return the pointer }
end;

begin
	RemKey := NIL;
	if pExecBase(SysBase)^.Softver >= 36 then begin
		IntuitionBase := pIntuitionBase(OpenLibrary('intuition.library',34));
		IconBase := OpenLibrary('icon.library',36);
		IFFParseBase := OpenLibrary('iffparse.library',36);
		datatypesBase := OpenLibrary('datatypes.library',39);
		if (IntuitionBase <> NIL) and (IFFParseBase <> NIL)
		   and (IconBase <> NIL) then begin
			RDArg := NIL;
			RDArg := ReadArgs(@Template[1],@RD_Array,RDArg);
			
			if RD_Array[0] <> 0 then begin
				l := lock(Pointer(RD_Array[0]), ACCESS_READ);
				if l <> NULL then begin
					ok := NameFromLock(l, @ts, 180);
					dl1 := ParentDir(l);
					if dl1 = NULL then begin
						{ disk if NULL (root file system) parent }
						FName := CStrConstPtrAR(@RemKey,PtrToPas(@ts)+'disk');
					end else begin
						FName := @ts;
					end;
					unlock(dl1);
			
					dobj := GetDiskObjectNew(FName);
					
					if dobj <> NIL then begin
						if NOT((dobj^.do_Type = WBPROJECT) or (dobj^.do_Type = WBTOOL)) then begin
							Write('  Would load in system default icon ("');
							CASE dobj^.do_Type of
								WBDISK : Writeln('ENV:Sys/def_disk")');
								WBDRAWER : Writeln('ENV:Sys/def_drawer")');
								WBGARBAGE : Writeln('ENV:Sys/def_Trashcan")');
								WBKICK : Writeln('ENV:Sys/def_kick")');
							end;
								
						end else begin
							if (DataTypesBase <> NIL) and (RD_Array[2] = 0) then begin
								dl2 := Lock(FName, SHARED_LOCK);
								if dl2 <> NULL then begin
									dt := ObtainDataTypeA(DTST_FILE, Pointer(dl2), NIL);
									if dt <> NIL then begin
										if  RD_Array[1] = 0 then begin
											if dt^.dtn_Header^.dth_ID = $62696E61 {bina} then
												BName := 'Use sys tool'
											else
												BName := PtrToPas(dt^.dtn_Header^.dth_Name);
										end else begin
											if dt^.dtn_Header^.dth_ID = $62696E61 {bina} then
												BName := 'Use sys tool'
											else
												BName := PtrToPas(IDToStr(dt^.dtn_Header^.dth_GroupID ,@buf));
										end;
									
										if BName <> 'Use sys tool' then begin
											IName := 'ENV:Sys/def_'+BName;
											Writeln('  Would load in "',IName,'"');
											if RD_Array[1] = 0 then begin
												IName := 'ENV:Sys/def_'+PtrToPas(dt^.dtn_Header^.dth_BaseName);
												Writeln('  If above was not present "',IName,'" would be loaded');
												IName := 'ENV:Sys/def_'+PtrToPas(IDToStr(dt^.dtn_Header^.dth_GroupID ,@buf));
												Writeln('  If above was not present "',IName,'" would be loaded');
											end;
											Writeln('  If that failed then the default project icon would be loaded');
										end else
											Writeln('  Would load in system default icon ("ENV:Sys/def_tool")');
										
										ReleaseDataType(dt);
									end;
									unlock(dl2);
								end;
							end else
								writeln('  Datatypes not available would load default tool or project'); 
						end;
						FreeDiskObject(dobj);
					end;
					UnLock(l);
				end;
			end;
			FreeArgs(RDArg);
			FreeRemember(@RemKey, True);
			CloseLibrary(DataTypesBase);
			CloseLibrary(IFFParseBase);
			CloseLibrary(IconBase);
			CloseLibrary(pLibrary(IntuitionBase));
		end;
	end;
end.