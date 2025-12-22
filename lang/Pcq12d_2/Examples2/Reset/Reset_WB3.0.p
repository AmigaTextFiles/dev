Program Reset;

{    Reset V1.0
     © 1993 by Andreas Tetzl.
     Dieses Programm ist Freeware.

 Die Datei TrapHandler.o muß zum Objektcode dazugelinkt werden. }

{$I "Include:Intuition/Intuition.i"}
{$I "Include:Graphics/Graphics.i"}
{$I "Include:Graphics/Pens.i"}
{$I "Include:Exec/ExecBase.i"}
{$I "Include:Exec/Interrupts.i"}
{$I "Include:Exec/Ports.i"}
{$I "Include:Exec/Tasks.i"}
{$I "Include:Exec/Memory.i"}
{$I "Include:Exec/Interrupts.i"}
{$I "Include:Exec/Devices.i"}
{$I "Include:Utils/IOUtils.i"}
{$I "Include:Devices/KeyBoard.i"}
{$I "Include:Exec/IO.i"}
{$I "Include:Libraries/DOS.i"}
{$I "Include:Utils/StringLib.i"}

Const  StdIn = NIL;   	{ Damit auf der WB kein Window geöffnet wird }
	  StdOut = StdIn;

Type MyData = Record
      MyTask : TaskPtr;
      MySignal : Integer;
     end;
     

VAR  KeyIO             : IOStdReqPtr;
     KeyMP             : MsgPortPtr;
     KeyHandler        : InterruptPtr;
     MyDataStuff       : MyData;
     MySignal, OpenDev : Integer;
     SysBase           : ExecBasePtr;
     
Procedure ColdReboot;
Begin
{$A
	move.l	$4,a6
	jmp		-726(a6)		; ColdReboot Exec.lib V37+
}
end;

Procedure Reset;
Const

   Topaz : TextAttr = ("topaz.font",8,FS_NORMAL,FPB_ROMFONT);
		
   WarmGadgetText : IntuiText = (1,0,JAM1,3,3,@Topaz,"WarmStart",NIL);
   KaltGadgetText : IntuiText = (1,0,JAM1,3,3,@Topaz,"KaltStart",NIL);

   ResetText : IntuiText=(1,0,JAM1,16,10,@Topaz,"Reset in    Sekunden",NIL);
   Zeit      : IntuiText=(1,0,JAM2,119,27,@Topaz,"  ",NIL);

VAR  Win : WindowPtr;
     RP : RastPortPtr;
	Msg, MsgCpy : IntuiMessagePtr;
	Time, i : Short;
	Gad : GadgetPtr;

Begin
  Win:=BuildSysRequest(NIL,adr(ResetText),adr(WarmGadgetText),adr(KaltGadgetText),GADGETUP_f,200,40);
  SetWindowTitles(Win,"Reset V1.0 by Andreas Tetzl",NIL);
  
  Time:=10;
  Repeat
   i:=IntToStr(Zeit.IText,Time);
   StrCat(Zeit.IText," ");
   PrintIText(Win^.RPort,adr(Zeit),0,0);
   For i:=1 to 5 do
    Begin
     Delay(10);
     Msg:=IntuiMessagePtr(GetMsg(Win^.UserPort));
     If Msg<>NIL then
      Begin
       Gad:=Msg^.Iaddress;
       If Gad^.GadgetID=1 then   { Warmstart }
        ColdReboot;    { Reset }
       If Gad^.GadgetID=0 then   { Kaltstart }
        Begin
         Forbid;                     { Damit sich Viren nicht neu installieren können }
         SysBase^.ColdCapture:=NIL;  { Resetvektoren löschen }
         SysBase^.CoolCapture:=NIL;
         SysBase^.WarmCapture:=NIL;
         SysBase^.KickMemPtr:=NIL;
         SysBase^.KickTagPtr:=NIL;
         SysBase^.KickCheckSum:=NIL;
         ColdReboot;         { Reset }
        end;         
      end;
    end;
   Dec(Time);
  Until Time=0;   { Nach Zehn Sekunden wird automatisch ein Reset ausgeführt }
end;

Procedure Meldung;
VAR  Con : FileHandle;
	z : Integer;
Begin
  Con:=DOSOpen("con:128/100/320/50/Reset",MODE_NEWFILE);
  If Con=NIL then Return;
  z:=DOSWrite(Con,"Reset V1.0 von Andreas Tetzl installiert\n",42);
  Delay(100);
  DOSClose(Con);
end;

Procedure ResetHandler;
External;

Function WaitForSignal(MySignal : Integer) : Short;
Begin
  WaitForSignal:=Wait(MySignal);
end;

Procedure CleanExit;
Begin
  If OpenDev=0 then CloseDevice(KeyIO);
  If KeyIO<>NIL then DeleteStdIO(KeyIO);
  If KeyMP<>NIL then DeletePort(KeyMP);
  If MySignal<>-1 then FreeSignal(MySignal);
  DisplayBeep(NIL);
end;

Begin
  {$A	move.l	$4,_SysBase   }
  OpenDev:=1;

  New(KeyHandler);
  MySignal:=AllocSignal(-1);
  If MySignal=-1 then CleanExit;

  MyDataStuff.MyTask:=FindTask(NIL);
  MyDataStuff.MySignal:=1 SHL MySignal;
  KeyMP:=CreatePort(NIL,0);
  If KeyMP=NIL then CleanExit;

  KeyIO:=CreateStdIO(KeyMP);
  If KeyIO=NIL then CleanExit;
  
  OpenDev:=OpenDevice("keyboard.device",0,KeyIO,0);
  If OpenDev<>0 then CleanExit;
  

  KeyHandler^.is_Code:=adr(ResetHandler);
  KeyHandler^.is_Data:=adr(MyDataStuff);
  Keyhandler^.is_Node.ln_Pri:=16;
  KeyHandler^.is_Node.ln_name:="Reset";
  KeyIO^.io_Data:=KeyHandler;
  KeyIO^.io_Command:=KBD_ADDRESETHANDLER;            { ResetHandler installieren }
  If DoIO(KeyIO)<>0 then CleanExit;
  Meldung;
  If WaitForSignal(MyDataStuff.MySignal)=0 then      { auf Reset warten }
   Begin
    Reset;
   end;
end.
