Program DefIconer;

{************* $F-,I-,R-,S-,V-,M 2,1,1,15}
{***** $F-,I+,R+,S+,V+,M 2,1,1,15}


USES
	Exec, Intuition, Commodities, Icon, 
	Workbench, DataTypes, DOS, Amiga, 
	AmigaDOS, IFFParse, DataTypesClass;

TYPE
	tProgVars = Record
		TEXT,
		ICONDIR     : String[80];
		COARSE, 
		NODATATYPE, 
		NOTOOLWIN, 
		DEFAULTTOOL,
		NOTOOL      : Boolean;
	End; {tProgVars}
	
	pStrNode = ^tStrNode;
	tStrNode = record
		sn_node : tNode;
		sn_Name : String;
		sn_Lock : BPTR;
	end;
	
CONST		
	RKey : pRemember = NIL;
	Version : String[31] = '$VER: DefDTIcon 1.6 (05.11.94)'#0;
	
VAR
	V : tProgVars;
		
function CStrConstPtrAR(rk : ppRemember; s : String) : STRPTR;

var  p : STRPTR;
begin
  s := s + #0;                                    { Make "C" string }
  p := AllocRemember(rk, length(s), MEMF_CLEAR);  { Get some mem for it }
  move(s[1], p^, length(s));                      { Move s into newly alloc'd mem }
  CStrConstPtrAR := STRPTR(p);                    { Return the pointer }
end;
							
{$I ToolType.PAS}
{$I IDPort.PAS}
{$I ProcessMsg.PAS}
{$I AppMenu.PAS}



Procedure Main;



VAR
	IDPort, AppPort : pMsgPort;
	AppMenu : pAppMenuItem;
	n : LONG;
	ez : pEasyStruct;
	
CONST
	portname : String[13] = 'DDTI_ID_PORT'#0;
	
Begin
	IntuitionBase := pIntuitionBase(OpenLibrary('intuition.library',0));
	If IntuitionBase <> NIL then begin
		IconBase := OpenLibrary('icon.library',37);
		If IconBase <> NIL then begin
			WorkBenchBase := OpenLibrary('workbench.library',37);
			If WorkbenchBase <> NIL then begin
				IFFParseBase := OpenLibrary('iffparse.library',36);
				if IFFParseBase <> NIL then begin
					DataTypesBase := OpenLibrary('datatypes.library',39);
				
					if CheckIDPortOrSetup(IDPort, @portname[1]) then begin
						GetToolTypes(V);
						IF InitAppICons(V, AppPort, AppMenu) then begin
							ProcessMessage(IDPort, AppPort);
							
							ez := AllocRemember(@RKey, Sizeof(tEasyStruct), MEMF_CLEAR);
							if ez <> NIL then begin
								With ez^ do begin
									es_StructSize :=  Sizeof(tEasyStruct);
									es_Title := CStrConstPtrAR(@RKey, 'DefDTIcon Quitting');
									es_TextFormat := CStrConstPtrAR(@RKey, 'DefDTIcon Copyright ©Lee Kindness.'#10+
									                                       'Trying to bring some conformity to all those gastly icons :-)'#10+
									                                       ''#10+
									                                       'Comments to:'#10+
									                                       ' Lee Kindness'#10+
									                                       ' 8 Craigmarn Road'#10+
									                                       ' Portlethen Village'#10+
									                                       ' Aberdeen AB1 4QR'#10+
									                                       ' SCOTLAND');
									es_GadgetFormat := CStrConstPtrAR(@RKey, 'Quit');
									n := EasyRequestArgs(NIL, ez, NIL, NIL);
								End;
							End;
							CleanAppMenu(AppPort,AppMenu);
						end;
						CleanIDPort(IDPort);
					end;
					
					CloseLibrary(pLibrary(DataTypesBase));
					CloseLibrary(pLibrary(IFFParseBase));
				end;
				CloseLibrary(pLibrary(WorkBenchBase));
			End;
			CloseLibrary(pLibrary(IconBase));
		End;
		FreeRemember(@RKey, True);
		CloseLibrary(pLibrary(IntuitionBase));
	End;
End;

Begin
Main;
End.
