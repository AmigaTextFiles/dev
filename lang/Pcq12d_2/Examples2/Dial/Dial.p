Program Dial;

{   Dieses Programm ist Cardware !
    Wenn es Dir gefällt oder Du Teile des Quellcodes verwendest,
    dann schick mir bitte eine Postkarte oder eine email.
           
    Andreas Tetzl
    Liebethaler Str. 18
    01796 Pirna
    
    email: A.TETZL@saxonia.sn.in-berlin.de

    compiler: PCQ-Pascal v1.2d mit OS3.1 Includes
}

{///"Includes"}
{$I "Include:Utils/StringLib.i"}
{$I "Include:DOS/DOS.i"}
{$I "Include:DOS/RDArgs.i"}
{$I "Include:Intuition/Intuition.i"}
{$I "Include:Intuition/IntuitionBase.i"}
{$I "Include:Intuition/sgHooks.i"}
{$I "Include:Libraries/GadTools.i"}
{$I "Include:Exec/Libraries.i"}
{$I "Include:Exec/Ports.i"}
{$I "Include:Exec/Memory.i"}
{$I "Include:Exec/Nodes.i"}
{$I "Include:Exec/Lists.i"}
{$I "Include:Utility/Utility.i"}
{$I "Include:Utils/TagUtils.i"}
{$I "Include:Utils/StrToInt.i"}
{$I "Include:Utils/Parameters.i"}
{$I "Include:Libraries/Commodities.i"}
{$I "Include:Workbench/Startup.i"}
{$I "Include:Workbench/WorkBench.i"}
{$I "Include:Workbench/Icon.i"}
{///}

{///"TYPE"}
Type
    NumberNode = Record
     ExecNode : Node;
     Number : Array[0..31] of Char;
    end;
    NumberNodePtr = ^NumberNode;
{///}

{///"CONST"}
CONST
 StdInName : String = NIL;
 StdOutName : String = NIL;

 StdHotkey = "alt f1";
 StdPhoneBook = "Telefonbuch";

 version = "$VER: Dial 1.1 (19.2.95)";

 TopazAttr : TextAttr = ("topaz.font",8,FS_NORMAL,FPF_ROMFONT);

 ng : Array[0..3] of NewGadget = (
               (10,16,280,83,"Name",@TopazAttr,0,PLACETEXT_ABOVE,NIL,NIL),
               (10,98,280,15,NIL,@TopazAttr,1,0,NIL,NIL),
               (10,117,100,15,"Wählen",@TopazAttr,2,PLACETEXT_IN,NIL,NIL),
               (190,117,100,15,"Verbergen",@TopazAttr,3,PLACETEXT_IN,NIL,NIL));

 Gadget_Types : Array[0..3] of Short = ( LISTVIEW_KIND,
                                         STRING_KIND,
                                         BUTTON_KIND,
                                         BUTTON_KIND);


 nm : Array[0..6] of NewMenu = (
        (NM_Title,"Projekt",NIL,0,0,NIL),
        (NM_Item,"Verbergen ","H",0,0,NIL),
        (NM_Item,"Info      ","A",0,0,NIL),
        (NM_Item,"Beenden   ","Q",0,0,NIL),
        (NM_Title,"Telefonbuch",NIL,0,0,NIL),
        (NM_Item,"neu laden","T",0,0,NIL),
        (NM_END,NIL,NIL,0,0,NIL));


    EVT_HOTKEY : Integer = 1;


    nb : newbroker = (

    NB_VERSION,
    "Dial",           { string to identify this broker }
    "Dial V1.1 @ 1995 by Andreas Tetzl",
    "Wählt Telefonnummern mit MFV",
    NBU_UNIQUE OR NBU_NOTIFY,    
    COF_SHOW_HIDE, 0, NIL, 0
    );
{///}

{///"VAR"}
VAR Str, Title : String;
    IB : IntuitionBasePtr;
    i,j : Integer;
    Win : WindowPtr;
    Scr : ScreenPtr;
    GList : GadgetPtr;
    Gads : Array[0..3] of GadgetPtr;
    CMsg : CxMsgPtr;
    vi : Address;
    TagList : Address;
    DirLock : FileLock;
    position : Integer;
    broker_mp : MsgPortPtr;
    broker,filter,sender,Ctranslate : CxObjPtr;
    cxsigflag : Integer;
    msgid, msgtype : Integer;
    returnvalue : Boolean;
    MenuStrip : MenuPtr;
    CX_POPUP : Boolean;
    CX_POPKEY : String;
    CX_PRIORITY : Integer;
    PhoneBook : String;
    SortList : Boolean;
    entries : Integer;
    Numbers : ListPtr;
    num : Integer;  { Nummer des selektierten Eintrages im ListView }
    null_request : Requester;  { Um das Fenster zu blockieren }
    OS3 : Boolean;
    ScrFont : TextAttrPtr;
    Win_Width, Win_Height : Integer;  { Wird von LayoutGadgets() gesetzt }
    longname : String;  { Wird von AddNumber() gesetzt. Die Breite des Fensters }
                        { richtet sich nach der Länge dies Strings. }
    MyHook : Hook;
    MySGWork : SGWorkPtr;     { Für den Edithook des StrGads }
    SGH : Integer;
{///}

{///"PROCEDURE CloseWin"}
PROCEDURE CloseWin;
VAR Msg : MessagePtr;
Begin
 If Win=NIL then Return;
 { Nachichten vom IDCMP-Port entfernen }
 Msg:=GetMsg(Win^.UserPort);
 While Msg<>NIL do
  Begin
   ReplyMsg(Msg);
   Msg:=GetMsg(Win^.UserPort);
  end;
 IF Win<>NIL THEN 
  Begin
   CloseWindow(Win);
   Win:=NIL;
  end;
 IF GList<>NIL THEN 
  Begin
   FreeGadgets(GList);
   Dispose(GList);
   GList:=NIL;
  end;

 If MenuStrip<>NIL then 
  Begin
   FreeMenus(MenuStrip);
   MenuStrip:=NIL;
  end;

 IF vi<>NIL THEN 
  Begin
   FreeVisualInfo(vi);
   vi:=NIL;
  end;
 IF Scr<>NIL THEN 
  Begin
   UnlockPubScreen(NIL,Scr);
   Scr:=NIL;
  end;
end;
{///}

{///"PROCEDURE Req"}
PROCEDURE Req(Txt : String);
const
    es : EasyStruct = (0,0,NIL,NIL,NIL);

VAR i : Integer;

begin
 es.es_StructSize:=SizeOf(EasyStruct);
 es.es_Flags:=0;
 es.es_Title:="Info";
 es.es_TextFormat:=Txt;
 es.es_GadgetFormat:="OK";

 i:=EasyRequestArgs(NIL,adr(es),0,NIL);
END;
{///}

{///"PROCEDURE AddNumber"}
PROCEDURE AddNumber(Name, Number : String);
VAR NewNode, MyNode : NumberNodePtr;
Begin
 { Längsten String merken (für LayoutGadgets) }
 If StrLen(name)>StrLen(longname) then StrCpy(longname,name);

 New(NewNode);
 NewNode^.execnode.ln_Name:=AllocString(128);
 StrnCpy(NewNode^.execnode.ln_Name,Name,Strlen(Name)-1);
 StrnCpy(adr(NewNode^.Number),Number,Strlen(Number)-1);

 If SortList=FALSE then     { NoSort aktiv }
  Begin
   AddTail(Numbers,NodePtr(NewNode));
   Inc(entries);
   Return;
  end;

 { NoSort nicht aktiv ... }

 MyNode:=NumberNodePtr(Numbers^.lh_Head);
 
 If entries=0 then  { erster Eintrag }
  Begin
   AddTail(Numbers,NodePtr(NewNode));
   Inc(entries);
   Return;
  end;
 
 If StriCmp(Name,MyNode^.execnode.ln_Name)<0 then
  begin
   AddHead(Numbers,NodePtr(NewNode));  { vor den ersten Eintrag }
   Inc(entries);
   Return;
  end;

 While MyNode<>NIL do
  Begin
   If (StriCmp(Name,MyNode^.execnode.ln_Name)>=0) and
      (StriCmp(Name,MyNode^.execnode.ln_Succ^.ln_name)<0) then
    Begin
     Insert(Numbers,NodePtr(NewNode),NodePtr(MyNode));  { einfügen }
     Inc(entries);
     Return;
    end;
   MyNode:=NumberNodePtr(MyNode^.execnode.ln_succ);
  end;

 AddTail(Numbers,NodePtr(NewNode));    { hinten anhängen }
 Inc(entries);
END;
{///}

{///"PROCEDURE FreeNumbers"}
PROCEDURE FreeNumbers;
VAR MyNode, Nextnode : NumberNodePtr;
Begin
 StrCpy(longname,"");
 
 MyNode:=NumberNodePtr(RemTail(Numbers));
 While MyNode<>NIL do
  Begin
   FreeString(MyNode^.execnode.ln_Name);
   Dispose(MyNode);
   MyNode:=NumberNodePtr(RemTail(Numbers));
  end;
end;
{///}

{///"PROCEDURE GetNumber"}
FUNCTION GetNumber(num : WORD) : String;
VAR MyNode : NumberNodePtr;
    i : Integer;
begin
 If num<0 then GetNumber:=NIL;
 i:=0;
 MyNode:=NumberNodePtr(Numbers^.lh_Head);
 While MyNode<>NIL do
  begin
   If i=num then GetNumber:=adr(MyNode^.Number);
   Inc(i);
   MyNode:=NumberNodePtr(MyNode^.execnode.ln_succ);
  end;

 GetNumber:=NIL;
end;
{///}

{///"PROCEDURE SearchName"}
FUNCTION SearchName(c : Char) : Integer;
{ Sucht nach einem Eintrag, der mit einem bestimmten Buchstaben
  anfängt. }
VAR MyNode : NumberNodePtr;
    i : Integer;
begin
 i:=0;
 MyNode:=NumberNodePtr(Numbers^.lh_Head);
 While MyNode<>NIL do
  begin
   If ToUpper(c)=ToUpper(MyNode^.execnode.ln_name[0]) then SearchName:=i;
   Inc(i);
   MyNode:=NumberNodePtr(MyNode^.execnode.ln_succ);
  end;

 SearchName:=-1;   { Nicht gefunden }
end;
{///}

{///"PROCEDURE CleanExit"}
PROCEDURE CleanExit(Why : String; RC:Integer);
VAR Msg : MessagePtr;
Begin
 If Win<>NIL then CloseWin;
 
 { Nachichten entfernen }
 If broker_mp<>NIL then
  Begin
   CMsg:=CxMsgPtr(GetMsg(broker_mp));
   While CMsg<>NIL do
    Begin
     ReplyMsg(MessagePtr(Cmsg));
     CMsg:=CxMsgPtr(GetMsg(broker_mp));
    end;
   DeleteMsgPort(broker_mp);
  end;
 If Broker<>NIL then DeleteCxObjAll(broker);
 If CxBase<>NIL then CloseLibrary(CxBase);
 IF gadToolsBase<>NIL THEN CloseLibrary(GadToolsBase);
 IF UtilityBase<>NIL THEN CloseLibrary(UtilityBase);
 If IB<>NIL then CloseLibrary(LibraryPtr(IB));
 FreeNumbers;

 If Why<>NIL then Req(Why);
 FreeString(Str);
 FreeString(CX_POPKEY);
 FreeString(Title);
 FreeString(PhoneBook);
 FreeString(longName);
 Dispose(Numbers);
 Exit(RC);
end;
{///}

{///"PROCEDURE LockWindow"}
PROCEDURE LockWindow(Win : WindowPtr; MyReq : RequesterPtr);
const
  waitPointer : CHIP Array[0..35] of WORD =
   (
    $0000, $0000,     { reserved, must be NULL }

    $0400, $07C0,
    $0000, $07C0,
    $0100, $0380,
    $0000, $07E0,
    $07C0, $1FF8,
    $1FF0, $3FEC,
    $3FF8, $7FDE,
    $3FF8, $7FBE,
    $7FFC, $FF7F,
    $7EFC, $FFFF,
    $7FFC, $FFFF,
    $3FF8, $7FFE,
    $3FF8, $7FFE,
    $1FF0, $3FFC,
    $07C0, $1FF8,
    $0000, $07E0,

    $0000, $0000      { reserved, must be NULL }
    );

Begin
 If Win=NIL then Return;
 
 InitRequester(MyReq);
 If Request(adr(null_request),Win) then
  SetPointer(Win,adr(WaitPointer),16,16,-6,0);
end;
{///}

{///"PROCEDURE UnlockWindow"}
PROCEDURE UnlockWindow(Win : WindowPtr; MyReq : RequesterPtr);
Begin
 If Win=NIL then Return;
 ClearPointer(Win);
 EndRequest(MyReq,Win);
end;
{///}

{///"PROCEDURE ReadPhoneBook"}
PROCEDURE ReadPhoneBook;
VAR Datei : FileHandle;
    name, num : String;
    OldLock : FileLock;
Begin
 name:=AllocString(128);
 num:=AllocString(32);

 If DirLock<>NIL then OldLock:=CurrentDir(DirLock);
 Datei:=DOSOpen(PhoneBook,MODE_OLDFILE);
 If DirLock<>NIL then OldLock:=CurrentDir(OldLock);
 
 If Datei=NIL then
  Begin
   StrCpy(Str,"Finde Telefonbuchdatei\n\"");
   StrCat(Str,PhoneBook);
   StrCat(Str,"\" nicht");
   CleanExit(Str,10);
  end;

 entries:=0;

 Repeat
  Str:=FGets(Datei,Str,128);
  While (IsAlpha(Str[0])=FALSE) and (Str<>NIL) do Str:=FGets(Datei,Str,128);
  If Str=NIL then
   Begin
    DOSClose(Datei);
    FreeString(name);
    FreeString(num);
    Return;
   end;
  StrCpy(name,Str);
  
  Str:=FGets(Datei,Str,64);
  While (Str[0]<>'#') and (Str<>NIL) do Str:=FGets(Datei,Str,128);
  If Str=NIL then
   Begin
    DOSClose(Datei);
    FreeString(name);
    FreeString(num);
    Return;
   end;

  StrCpy(num,adr(Str[1]));
  AddNumber(name,num);
 Until FALSE;
end;
{///}

{///"PROCEDURE Dial"}
PROCEDURE Dial(number : String);
Begin
{$A
; This source dials a number, it can do either DTMF or CCITT5. It has built
; in letter recognition. Ie ABC -> 1, DEF -> 2 which can be switched off.
; It is also variable speed. Feel free to use in your programmes.
;
; NB: This isnt the source of the programme dial, just the routine which
; dials numbers. Dial is merely a frontend to this:

; some vars from hardware/custom.i

dmacon      EQU   $096
adkcon      EQU   $09E

aud         EQU   $0A0
aud0        EQU   $0A0
aud1        EQU   $0B0
aud2        EQU   $0C0
aud3        EQU   $0D0

* AudChannel
ac_ptr      EQU   $00   ; ptr to start of waveform data
ac_len      EQU   $04   ; length of waveform in words
ac_per      EQU   $06   ; sample period
ac_vol      EQU   $08   ; volume
ac_dat      EQU   $0A   ; sample pair
ac_SIZEOF   EQU   $10


        move.l  4(sp),a0     ; Parameter nach a0

        movem.l d1/d4-d7/a3-a5,-(sp)                ;a0=number in ascii         
        lea     DTMF,a1                             ;chr(0) to end
Start   move.l  a0,a4
        move.l  a1,a5
        moveq   #SnSize,d0
        moveq   #2,d1                               ;MEMF_CHIP
        move.l  $4,a6
        jsr     -198(a6)                            ;AllocMem()
        move.l  d0,a0
        move.l  #SnWaveS,a1
        moveq   #SnSize-1,d1

CopyBf  move.b  (a1)+,(a0)+
        dbf     d1,CopyBf

        move.l  a5,a1
        move.l  a4,a0

        clr.l   d2
        move.b  Speed,d2

NextTone
        clr.l   d1
        move.b  (a0)+,d1                            
        cmp.b   #'*',d1
        beq     Special
        cmp.b   #"#",d1
        beq     Special

        cmp.b   #"0",d1
        blt     SkipNote
        cmp.b   #"9",d1
        bgt     NotDigit

        sub.b   #"0",d1
DoneConv
        lsl     #2,d1                               ;*4
        move.w  0(a1,d1.w),d4                       ;Lookup table in words
        move.w  2(a1,d1.w),d5                       ;get period of both tones
        bsr     SoundTone
        bra     Pause
SkipNote
        tst.b   (a0)
        bne     NextTone

        move.l  d0,a1
        moveq   #SnSize,d0
        move.l  $4,a6
        jsr     -210(a6)                            ;FreeMem()

        movem.l (sp)+,d1/d4-d7/a3-a5
        rts

Special moveq.w #10,d1                              ;* & #
        cmpi.b  #"#",d1                             ;(does anyone want the
        bne     NoAdN                               ;a,b,c or d tones?)
        addq.w  #1,d1
NoAdN   bra     DoneConv

NotDigit                                            ;Handles a-y
        tst.b   Letter                              ;-nl -ignore letters
        bne     SkipNote
        
        cmp.b   #"Q",d1                             ;Q & Z = 1
        beq     DoLQZ
        cmp.b   #"Z",d1
        beq     DoLQZ       
        bgt     SmallCase
        cmp.b   #"A",d1                             ;=> 1-9
        blt     SkipNote
        cmp.b   #"Q",d1
        blt     NoDif
        subq.b  #1,d1
NoDif   sub.b   #59,d1
        divu    #3,d1
        bra     DoneConv
DoLQZ   move.l  #1,d1
        bra     DoneConv

SmallCase
        cmp.b   #"z",d1
        beq     DoLQZ                               ;Q and Z come on the 
        bgt     SkipNote
        cmp.b   #"q",d1                             ;Number 1 button 
        beq     DoLQZ                               ;sometimes
        cmp.b   #"a",d1
        blt     SkipNote
        cmp.b   #"q",d1
        blt     NoDifS
        subq.b  #1,d1
NoDifS  sub.b   #91,d1
        divu    #3,d1
        bra     DoneConv

SoundTone
        lea     $dff000,a5
        lea     aud1(a5),a3                         ;Right channel only
        lea     aud2(a5),a4                         ;N.B Don't be clever
        move.w  #$000f,dmacon(a5)                   ;and use stereo it 
        move.l  d0,(a3)                             ;doesn't work then.
        move.l  d0,(a4)
        move.w  #SnSize/2,ac_len(a3)
        move.w  #SnSize/2,ac_len(a4)
        move.w  #64,ac_vol(a3)
        move.w  #64,ac_vol(a4)
        move.w  d4,ac_per(a3)
        move.w  d5,ac_per(a4)
        move.w  #$00ff,adkcon(a5)
        move.w  #$8206,dmacon(a5)

timedelay
        bsr     GetTime
        move.l  d7,d6
Cont    bsr     GetTime
        sub.l   d6,d7
        cmp.l   d2,d7
        bgt     StopNote        
        bra     Cont

StopNote
        move.w  #$0006,dmacon(a5)
        rts

Pause   bsr     GetTime
        move.l  d7,d6
Cont2   bsr     GetTime
        sub.l   d6,d7
        cmpi.l  #2,d7
        bgt     SkipNote
        bra     Cont2

GetTime clr.l   d7                                  ;Stuff the timer.device
        move.b  $bfea01,d7                          ;we programme direct
        lsl.l   #4,d7                               ;via PIA
        lsl.l   #4,d7
        move.b  $bfe901,d7
        lsl.l   #4,d7
        lsl.l   #4,d7
        move.b  $bfe801,d7
        rts

        even
DTMF    dc.w    238,166                         ;0
        dc.w    319,186                         ;1
        dc.w    319,166                         ;2
        dc.w    319,151                         ;3
        dc.w    290,184                         ;4
        dc.w    290,166                         ;5
        dc.w    290,151                         ;6
        dc.w    263,184                         ;7
        dc.w    263,166                         ;8
        dc.w    263,151                         ;9
        dc.w    238,184                         ;* 
        dc.w    238,151                         ;# 

Speed   dc.b    5                               ;Speed
Letter  dc.b    1                               ;0 = use letter recognitiion

        even
SnWaveS
        dc.b    0,49
        dc.b    90,117
        dc.b    127,117
        dc.b    90,49
        dc.b    0,-49
        dc.b    -90,-117
        dc.b    -127,-117
        dc.b    -90,-49
SnWaveE 
SnSize  EQU SnWaveE-SnWaveS

}
end;
{///}

{///"PROCEDURE About"}
PROCEDURE About;
const
    lines = 11;
    txt : Array[1..lines] of String =
          ("Dial V1.1\n",
           "Datum: 19.02.1995\n",
           "Copyright © 1995 by Andreas Tetzl\n\n",
           "ThanX to Andrew Leppard 4 his dial engine.\n",
           "Dieses Programm ist Cardware.\n",
           "Wenn es Dir gefällt, dann schick' mir bitte\n",
           "eine Postkarte oder eine email.\n",
           "\nAndreas Tetzl\n",
           "Liebethaler Str. 18\n",
           "01796 Pirna\n",
           "\nemail: A.TETZL@saxonia.sn.in-berlin.de");

VAR body : String;
    i : Integer;

begin
 body:=AllocString(300);
 StrCpy(body,"");
 For i:=1 to lines do StrCat(body,txt[i]);

 Req(body);

 FreeString(body);
end;
{///}

{///"FUNCTION EditHookCode"}
FUNCTION EditHookCode : Integer;
VAR Str : String;
Begin
 {$A    move.l  a2,_MySGWork
        move.l  a1,_SGH      }

 { Bei bestimmten Tasten (siehe unten) in Verbindung mit der rechten
   AMIGA-Taste wird der Event direkt an den IDCMP Port des Fensters
   weitergeschickt und werden dort als VanillaKey oder MenuPick
   verarbeitet. }
 If (MySGWork^.IEvent^.ie_Qualifier AND IEQUALIFIER_RCOMMAND)=IEQUALIFIER_RCOMMAND then
  Begin
   Case Chr(MySGWork^.Code) of
    'h' : MySGWork^.Actions:=SGA_END+SGA_REUSE;  { (h)ide (Menu) }
    'a' : MySGWork^.Actions:=SGA_END+SGA_REUSE;  { (a)bout (Menu) }
    'q' : MySGWork^.Actions:=SGA_END+SGA_REUSE;  { (q)uit (Menu) }
   end;
  end;
 EditHookCode:=-1;
end;
{///}

{///"PROCEDURE ProcessIDCMP"}
PROCEDURE ProcessIDCMP;
VAR Msg : IntuiMessagePtr;
    Class : Integer;
    Code, Qual : Short;
    Gadgetnum: Short;
    Iadr : GadgetPtr;
    StrInfo : StringInfoPtr;
    Secs, Micros, OldSecs, OldMicros : Integer;

begin
 REPEAT
  i:=Wait(cxsigflag OR (1 shl Win^.UserPort^.mp_SigBit) OR SIGBREAKF_CTRL_C);

  If i=SIGBREAKF_CTRL_C then CleanExit(NIL,0);

  If i=cxsigflag then
  { CXMsg -> zum Hauptprogramm zurück }
   Begin
    CloseWin;
    Return;
   end;

  Msg:=GT_GetIMsg(Win^.UserPort);
  While Msg<>NIL do
   BEGIN
    Class:=Msg^.Class;
    Code:=Msg^.Code;
    Qual:=Msg^.Qualifier;
    Secs:=Msg^.Seconds;
    Micros:=Msg^.Micros;
    IF Class=IDCMP_GADGETUP THEN Iadr:=Msg^.Iaddress;
    GT_ReplyIMsg(Msg);

    IF Class=IDCMP_GADGETUP THEN
     BEGIN
      GadgetNum:=Iadr^.GadgetID;
      CASE Gadgetnum of
       0 : Begin 
            num:=Code;

            StrInfo:=Gads[1]^.SpecialInfo;
            If (DoubleClick(OldSecs,OldMicros,Secs,Micros)) and 
               (StrEq(StrInfo^.Buffer,GetNumber(Code))) then
             Begin
              LockWindow(Win,adr(null_request));
              Dial(GetNumber(Code));
              UnlockWindow(Win,adr(null_request));
             end;

            OldSecs:=Secs;
            OldMicros:=Micros;
            
            TagList:=CreateTagList(GTST_String,GetNumber(Code),
                                   TAG_END);
            GT_SetGadgetAttrsA(Gads[1],Win,NIL,TagList);
            FreetagItems(TagList);
           end;
       1 : Begin
            num:=-1;
            TagList:=CreateTagList(GTLV_Selected,num,
                                   TAG_END);
            GT_SetGadgetAttrsA(Gads[0],Win,NIL,TagList);
            FreeTagItems(TagList);
           end;
       2 : Begin
            StrInfo:=Gads[1]^.SpecialInfo;
            lockWindow(Win,adr(null_request));
            Dial(StrInfo^.Buffer);
            UnlockWindow(Win,adr(null_request));
           end;
       3 : Begin
            CloseWin;
            Return;
           end;
      END;
     END;

    If Class=IDCMP_VANILLAKEY then
     Begin
      Case Code of
       13       : Begin     { RETURN }
                   StrInfo:=Gads[1]^.SpecialInfo;
                   lockWindow(Win,adr(null_request));
                   Dial(StrInfo^.Buffer);
                   UnlockWindow(Win,adr(null_request));
                  end;
       27       : Begin     { ESC }
                   CloseWin;
                   Return;
                  end;
       Ord('0')..Ord('9') : If ActivateGadget(Gads[1],Win,NIL) then; { Zahl gedrückt -> StrGad aktivieren }
       else
        Begin
         i:=SearchName(Chr(Code));
         If i>=0 then
          Begin
           num:=i;
           TagList:=CreateTagList(GTLV_Selected,num,
                                  GTLV_Top,num,
                                  TAG_END);
           GT_SetGadgetAttrsA(Gads[0],Win,NIL,TagList);
           FreeTagItems(TagList);

           { Strgad aktualisieren }
           TagList:=CreateTagList(GTST_String,GetNumber(num),
                                  TAG_END);
           GT_SetGadgetAttrsA(Gads[1],Win,NIL,TagList);
           FreetagItems(TagList);
          end;
        end;
      end;
     end;

    If Class=IDCMP_RAWKEY then
     Begin
      Case ($7F AND Code) of
       77       : Begin
                   If ((Qual AND IEQUALIFIER_LSHIFT)<>0) or 
                      ((Qual AND IEQUALIFIER_RSHIFT)<>0) then
                    Begin
                     Inc(num,8);   { Shift + Cursor runter: einen Eintrag vor }
                     If num>=entries then num:=entries-1;
                    end
                   else
                    Begin
                     Inc(num);     { Cursor runter: einen Eintrag vor }
                     If num>=entries then num:=entries-1;
                    end;

                   If OS3 then
                    Begin
                     TagList:=CreateTagList(GTLV_Selected,num,
                                            GTLV_MakeVisible,num,
                                            TAG_END);
                    end
                   else
                    Begin
                     TagList:=CreateTagList(GTLV_Selected,num,
                                            GTLV_Top,num,
                                            TAG_END);
                    end;
                   GT_SetGadgetAttrsA(Gads[0],Win,NIL,TagList);
                   FreeTagItems(TagList);

                    { Strgad aktualisieren }
                   TagList:=CreateTagList(GTST_String,GetNumber(num),
                                          TAG_END);
                   GT_SetGadgetAttrsA(Gads[1],Win,NIL,TagList);
                   FreetagItems(TagList);

                  end;
       76       : Begin
                   If ((Qual AND IEQUALIFIER_LSHIFT)<>0) or 
                      ((Qual AND IEQUALIFIER_RSHIFT)<>0) then
                    Begin
                     Dec(num,8);   { Shift + Cursor hoch: einen Eintrag zurück }
                     If num<0 then num:=0;
                    end
                   else
                    begin
                     Dec(num);     { Cursor hoch: einen Eintrag zurück }
                     If num<0 then num:=0;
                    end;
                   
                   If OS3 then
                    Begin
                     TagList:=CreateTagList(GTLV_Selected,num,
                                            GTLV_MakeVisible,num,
                                            TAG_END);
                    end
                   else
                    Begin
                     TagList:=CreateTagList(GTLV_Selected,num,
                                            GTLV_Top,num,
                                            TAG_END);
                    end;
                   GT_SetGadgetAttrsA(Gads[0],Win,NIL,TagList);
                   FreeTagItems(TagList);
                  
                    { Strgad aktualisieren }
                   TagList:=CreateTagList(GTST_String,GetNumber(num),
                                          TAG_END);
                   GT_SetGadgetAttrsA(Gads[1],Win,NIL,TagList);
                   FreetagItems(TagList);
                  end;
     end;
    end;


    CASE Class of
     IDCMP_MENUPICK : Begin
                       If MenuNum(Code)=0 then
                        Begin
                         Case ItemNum(Code) of
                          0 : Begin
                               CloseWin;
                               Return;
                              end;
                          1 : Begin
                               lockWindow(Win,adr(null_request));
                               About;
                               UnlockWindow(Win,adr(null_request));
                              end;
                          2 : CleanExit(NIL,0);
                         end;
                        end;
                       If MenuNum(Code)=1 then
                        Begin
                         Case ItemNum(Code) of
                          0 : Begin
                               TagList:=CreateTagList(GTLV_Labels,-1,
                                                      TAG_END);
                               GT_SetGadgetAttrsA(Gads[0],Win,NIL,TagList);
                               FreeTagItems(TagList);

                               FreeNumbers;
                               Dispose(Numbers);
                               New(Numbers);
                               NewList(Numbers);
                               ReadPhoneBook;

                               TagList:=CreateTagList(GTLV_Labels,Numbers,
                                                      TAG_END);
                               GT_SetGadgetAttrsA(Gads[0],Win,NIL,TagList);
                               FreeTagItems(TagList);
                              end;
                         end;
                        end;

                      end;
     IDCMP_REFRESHWINDOW : BEGIN
                            GT_BeginRefresh(Win);
                            GT_EndRefresh(Win,TRUE);
                           END;
     IDCMP_CLOSEWINDOW : Begin
                          CloseWin;
                          Return;
                         end;
    END;
    Msg:=GT_GetIMsg(Win^.UserPort);
   END;
 UNTIL FALSE;
end;
{///}

{///"PROCEDURE LayoutGadgets"}
PROCEDURE LayoutGadgets;
VAR YSize : Integer;
    IText : IntuiText;  { Die Länge der Texte werden über IntuiTextLength() ermittelt }
    GadgetWidth : Integer;
Begin
 YSize:=ScrFont^.ta_YSize+5;

 IText.ITextFont:=ScrFont;
 IText.IText:=longname; { Längster Name aus Telefonbuch }
 Win_Width:=IntuiTextLength(adr(Itext))+40;

 If Win_Width>Scr^.Width then
  Begin
   ScrFont:=adr(TopazAttr);   { Wenn der Font zu groß ist auf Topaz zurückstellen }
   IText.ITextFont:=ScrFont;
   IText.IText:=longname;
   Win_Width:=IntuiTextLength(adr(Itext))+40;
  end;

 IText.ITextFont:=ScrFont;
 IText.IText:="Verbergen";
 GadgetWidth:=IntuiTextLength(adr(Itext))+10;

 If Win_Width<2*GadgetWidth+40 then Win_Width:=2*GadgetWidth+40;

 { ListView }
 ng[0].ng_TopEdge:=YSize+8;
 ng[0].ng_Width:=Win_Width-20;
 ng[0].ng_Height:=YSize*8;

 { Nummer }
 ng[1].ng_TopEdge:=ng[0].ng_TopEdge+ng[0].ng_Height+8;
 ng[1].ng_Width:=Win_Width-20;
 ng[1].ng_Height:=YSize+2;

 { Wählen }
 ng[2].ng_TopEdge:=ng[1].ng_TopEdge+ng[1].ng_Height+7;
 ng[2].ng_Width:=GadgetWidth;
 ng[2].ng_Height:=YSize+4;

 { Verbergen }
 ng[3].ng_LeftEdge:=ng[0].ng_LeftEdge+ng[0].ng_Width-ng[2].ng_Width;
 ng[3].ng_TopEdge:=ng[2].ng_TopEdge;
 ng[3].ng_Width:=ng[2].ng_Width;
 ng[3].ng_Height:=YSize+4;

 Win_Height:=ng[3].ng_TopEdge+ng[3].ng_Height+5;
 If Win_Height>Scr^.Height then CleanExit("Bildauflösung zu klein !",10);
  { Sollte eigentlich nicht passieren, oder hat jemand einen Screen, der nur 100
    Pixel hoch ist ? }
end;
{///}

{///"PROCEDURE OpenWin"}
PROCEDURE OpenWin;
const
 IDCMP=IDCMP_CLOSEWINDOW OR IDCMP_GADGETUP OR IDCMP_VANILLAKEY OR
       IDCMP_MENUPICK OR IDCMP_RAWKEY OR LISTVIEWIDCMP;

Begin
 New(GList);
 
 Scr:=LockPubScreen(NIL);  { WB Screen ... }
 If Scr=NIL then CleanExit("Bekomme keinen lock auf WB-Screen",10);

 ScrFont:=Scr^.Font;

 vi:=GetVisualInfoA(Scr,NIL);
 IF vi=NIL THEN CleanExit("Bekomme kein VisualInfo vom Public-Screen",10);

 Gads[0] := CreateContext( Adr(GList) );  { !! Address of GadgetPtr !! }
 IF Gads[0]=NIL THEN CleanExit("Kann Gadgets nicht erstellen",10);

 MyHook.h_Entry:=adr(EditHookCode);
 TagList:=CreateTagList(GTLV_Labels,Numbers,
                        GTLV_ShowSelected,NIL,
                        GTLV_Selected,num,
                        GTST_String,GetNumber(num),
                        GTST_EditHook,adr(MyHook),
                        TAG_DONE     );

 LayoutGadgets;

 ng[0].ng_VisualInfo:=vi;
 ng[0].ng_TextAttr:=ScrFont;
 Gads[0]:=CreateGadgetA(Gadget_Types[0],Gads[0],adr(ng[0]),TagList);
 For i:=1 to 3 do
  BEGIN
   ng[i].ng_VisualInfo:=vi;
   ng[i].ng_TextAttr:=ScrFont;
   Gads[i]:=CreateGadgetA(Gadget_Types[i],Gads[i-1],adr(ng[i]),TagList);
  END;

 FreeTagItems(TagList);
 IF Gads[3]=NIL THEN CleanExit("Kann Gadgets nicht erzeugen",10);

 If OS3 then
  Begin
   TagList:=CreateTagList(GTMN_FrontPen,1,     { Ab OS3.0 FronPen auf 1 setzten, }
                          TAG_END);
  end
 else TagList:=NIL;                            { darunter: default = 0           }
 MenuStrip:=CreateMenusA(adr(nm),TagList);
 If TagList<>NIL then FreeTagItems(TagList);

 If MenuStrip=NIL then CleanExit("Kann Menu nicht erzeugen",10);
 If LayoutMenusA(MenuStrip,vi,NIL)=FALSE then CleanExit("Kann Menu nicht erzeugen",10);

 StrCpy(Title,"Dial: Hotkey = <");
 StrCat(Title,CX_POPKEY);
 StrCat(Title,">");

 TagList:=CreateTagList(WA_Left,Scr^.MouseX-(Win_Width div 2),
                        WA_Top,Scr^.MouseY-(Win_Height div 2),
                        WA_InnerWidth,Win_Width,
                        WA_InnerHeight,Win_Height,
                        WA_Title,Title,
                        WA_CustomScreen,Scr,
                        WA_Gadgets,GList,
                        WA_IDCMP,IDCMP,
                        WA_DragBar,TRUE,
                        WA_NewLookMenus,TRUE,
                        WA_CloseGadget,TRUE,
                        WA_DepthGadget,TRUE,
                        WA_GimmeZeroZero,TRUE,
                        WA_Activate,TRUE,
                        TAG_DONE   );

 Win:=OpenWindowTagList(NIL,TagList);
 FreeTagItems(TagList);
 IF Win=NIL THEN CleanExit("Kann Fenster nicht öffnen",10);
 IF NOT SetMenuStrip(Win,MenuStrip) THEN CleanExit("Kann Menu nicht erzeugen !",10);
 GT_RefreshWindow(Win,NIL);
end;
{///}

{///"PROCEDURE ProcessToolTypes"}
PROCEDURE ProcessToolTypes;
VAR  WBMsg : WBStartupPtr;
     i : Integer;
     DiskObj : DiskObjectPtr;
     OldLock : FileLock;
     ToolTypes : Address;
     Str : String;

Begin
  { "Voreinstellungen", falls beim ToolType-lesen etwas schiefgeht
    werden diese Werte genommen }
  StrCpy(CX_POPKEY,StdHotkey);
  CX_POPUP:=TRUE;
  CX_PRIORITY:=0;
  StrCpy(PhoneBook,StdPhoneBook);
  SortList:=TRUE;

  WBMsg:=GetStartupMsg;
  If WBMsg=NIL then Return;  { Vom CLI gestartet }

  DirLock:=WBMsg^.sm_ArgList^[1].wa_Lock;

  IconBase:=OpenLibrary(ICONNAME,0);
  If IconBase=NIL then Return;

  OldLock:=CurrentDir(WBMSg^.sm_ArgList^[1].wa_Lock);
  DiskObj:=GetDiskObject(WBMsg^.sm_ArgList^[1].wa_Name);
  
  If DiskObj=NIL then 
   Begin
    CloseLibrary(IconBase);
    Return;
   end;

  ToolTypes:=DiskObj^.do_ToolTypes;

  Str:=FindToolType(ToolTypes,"CX_POPUP");
  If MatchToolValue(Str,"NO") then CX_POPUP:=FALSE else CX_POPUP:=TRUE;

  Str:=FindToolType(ToolTypes,"CX_POPKEY");
  StrCpy(CX_POPKEY,Str);
  If StrEQ(CX_POPKEY,"") then StrCpy(CX_POPKEY,StdHotkey);

  Str:=FindToolType(ToolTypes,"CX_PRIORITY");
  i:=StrToLong(Str,adr(CX_PRIORITY));
  If (CX_PRIORITY>127) or (CX_PRIORITY<-127) then CX_PRIORITY:=0;

  Str:=FindToolType(ToolTypes,"PhoneBook");
  StrCpy(PhoneBook,Str);
  If StrEQ(PhoneBook,"") then StrCpy(PhoneBook,StdPhoneBook);

  Str:=FindToolType(ToolTypes,"Sort");
  If MatchToolValue(Str,"NO") then SortList:=FALSE;

  OldLock:=CurrentDir(OldLock);
  FreeDiskObject(DiskObj);
  CloseLibrary(IconBase);
end;
{///}

{///"PROCEDURE ProcessArgs"}
PROCEDURE ProcessArgs;
const template = "CP=CX_PRIORITY/N,CK=CX_POPKEY/K,CU=CX_POPUP/K,PH=PhoneBook/K,Sort/K";

VAR  rda : RDArgsPtr;
     vec : Array[0..4] of Address;

BEGIN
  { "Voreinstellungen", falls bei ReadArgs() etwas schiefgeht oder ein 
    Argument nicht angegeben ist werden diese Werte genommen. }
  StrCpy(CX_POPKEY,StdHotkey);
  CX_POPUP:=TRUE;
  CX_PRIORITY:=0;
  StrCpy(PhoneBook,StdPhoneBook);
  SortList:=TRUE;

  vec[0]:=NIL;
  vec[1]:=NIL;  { Die Werte immer vorher mit NULL belegen !  }
  vec[2]:=NIL;  { Wenn ein Argument nicht angegeben ist wird }
  vec[3]:=NIL;  { der Wert nicht verändert.                  }
  vec[4]:=NIL;

  rda:=ReadArgs(Template,adr(vec),NIL);
  If rda=NIL then
   Begin
    If PrintFault(IoErr,NIL) then;
    CleanExit(NIL,0);
   end;

  If vec[0]<>NIL then CopyMem(vec[0],adr(CX_PRIORITY),4);
  If vec[1]<>NIL then StrCpy(CX_POPKEY,vec[1]);
  If vec[2]<>NIL then StrCpy(Str,vec[2]);
  If StriEq(Str,"NO") then CX_POPUP:=FALSE;
  If vec[3]<>NIL then StrCpy(PhoneBook,vec[3]);
  If vec[4]<>NIL then StrCpy(Str,vec[4]);
  If StriEq(Str,"NO") then SortList:=FALSE;

  If (CX_PRIORITY>127) or (CX_PRIORITY<-127) then CX_PRIORITY:=0;

  FreeArgs(rda);
END;
{///}

{///"PROCEDURE OpenAll"}
PROCEDURE OpenAll;
VAR l : FileLock;
    WBMsg : WBStartupPtr;
    FromWB : Boolean;

Begin
 Title:=AllocString(100);
 CX_POPKEY:=AllocString(100);
 Str:=AllocString(200);
 PhoneBook:=AllocString(100);
 longname:=AllocString(100);

 New(Numbers);
 NewList(Numbers);

 WBMsg:=GetStartupMsg;
 If WBMsg<>NIL then FromWB:=TRUE else FromWB:=FALSE;

 If FromWB then
  ProcessToolTypes
 else
  ProcessArgs;

 UtilityBase:=OpenLibrary("utility.library",37);
 IF UtilityBase=NIL THEN CleanExit("Benötige mindestens OS V2.0 !",20);

 If LibraryPtr(UtilityBase)^.lib_Version>=39 then OS3:=TRUE else OS3:=FALSE;

 GadToolsBase:=OpenLibrary("gadtools.library",37);
 IF GadToolsBase=NIL THEN CleanExit("Kann GadTools.Library nicht öffnen !??",10);

 IB:=IntuitionBasePtr(OpenLibrary("intuition.library",37));
 If IB=NIL then CleanExit("Kann intuition.library nicht öffnen !??",10);

 CxBase := OpenLibrary("commodities.library", 37);
 If CxBase=NIL then CleanExit("Benötige die Commodities.library !",10);

 broker_mp := CreateMsgPort;
 If broker_mp=NIL then CleanExit("Kann Broker-Port nicht erstellen !??",10);

 cxsigflag := 1 shl broker_mp^.mp_SigBit;
 nb.nb_Port := broker_mp;
 nb.nb_Pri:=CX_PRIORITY;

 broker := CxBroker(adr(nb), NIL);
 If Broker=NIL then CleanExit(NIL,10);  { Wenn das passiert wurde das Programm
                                          ein zweites Mal gestartet. Das zuerst
                                          gestartete Programm erhält eine Message
                                          und öffnet sein Fenster. }

 filter := CreateCxObj(CX_FILTER, Integer(CX_POPKEY) ,0);
 AttachCxObj(broker, filter);
 sender := CreateCxObj(CX_SEND,Integer(broker_mp), EVT_HOTKEY);
 AttachCxObj(filter, sender);
 Ctranslate := CreateCxObj(CX_TRANSLATE,0,0);
 AttachCxObj(filter, Ctranslate);

 If CxObjError(filter)<>0 then 
  Begin
   StrCpy(Str,"Fehler bei der Installation des Hotkeys:\n");
   StrCat(Str,CX_POPKEY);
   StrCat(Str,"\nBitte überprüfen Sie CX_POPKEY !");
   CleanExit(Str,10);
  end;
 If ActivateCxObj(broker, 1)=0 then;

 ReadPhoneBook;
end;
{///}

{///"Main"}
Begin
 OpenAll;

 If CX_POPUP=TRUE then
  Begin
   OpenWin;
   ProcessIDCMP;
  end;

 returnvalue:=TRUE;
 while returnvalue do
  Begin
   i := Wait(cxsigflag OR SIGBREAKF_CTRL_C);

   If i=SIGBREAKF_CTRL_C then CleanExit(NIL,0);

   CMsg:=CXMsgPtr(GetMsg(broker_mp));
   While CMsg<>NIL do
    Begin
     msgid := CxMsgID(Cmsg);
     msgtype := CxMsgType(Cmsg);
     ReplyMsg(MessagePtr(Cmsg));

     Case MsgType of
      CXM_IEVENT : Begin
                    If msgid=EVT_HOTKEY then
                     Begin
                      OpenWin;
                      ProcessIDCMP;
                     end;
                   end;
      CXM_COMMAND : Begin
                     Case msgid of
                      CXCMD_APPEAR  : Begin
                                       OpenWin;
                                       ProcessIDCMP;
                                      end;
                      CXCMD_DISABLE : Begin
                                       If ActivateCxObj(broker, 0)=0 then;
                                      end;
                      CXCMD_ENABLE  : begin
                                       If ActivateCxObj(broker, 1)=0 then;
                                      end;
                      CXCMD_KILL    : Begin
                                       returnvalue := FALSE;
                                      end;
                      CXCMD_UNIQUE  : Begin
                                       { Programm neu gestartet }
                                       OpenWin;
                                       ProcessIDCMP;
                                      end;
                     end;
                    end;
     end;

     CMsg:=CXMsgPtr(GetMsg(broker_mp));
    end;
  end;

 CleanExit(NIL,0);
end.
{///}

