{ --- Intuition replacement functions ---
  -           Part of:                  -
  -     "The Gadget Engine Proyect"     -
  -    (c) 2001-2002 by Pablo Roldan    -
  ---------------------------------------}

{$I "Include:Intuition/Intuition.i"}
{$I "Include:Libraries/GE_GadgetClass.i"}
{$I "Include:Libraries/GEngine.i"}
{$I "Include:Libraries/GE_Classes.i"}

Type

 WinList = Record
      wl_Node      : MinNode;
      wl_Window    : WindowPtr; {Window Address}
      wl_ObjCount  : Short; {Number of objects (gadgets) attached to window}
      wl_ActiveObj : Address; {Current object (gadget) the user is playing with}
 end;

 WinListPtr = ^WinList;

{--------}

{Function ge_GetMsg(gPort: MsgPortPtr): MessagePtr;

Var
 gm: IntuiMessagePtr;

Begin
 gm: IntuiMessagePtr(GetMsg(gPort));
 With gm^ do begin
  Case class of
   GADGETDOWN_f:
   GADGETUP_f:
   MOUSEMOVE_f:
  end;
 end;
 ge_GetMsg:= MessagePtr(gm);
end;}


{ --- NOTAS:
  -  1ro: Tomar Intuimessage
  -  2do: Buscar ventana en lista de ventanas con objetos
    (creada por ge_addgadget, ge_addglist, ge_RemoveGadget y ge_RemoveGList)
  -  3ro: Si IntuiMessage.class= GADGETDOWN_f entonces mandar metodo GGM_HITTEST
     a IntuiMessage.IAddress (Gadget) (Coordenadas del mouse relativas a la
     esquina superior izquierda del GADGET), en caso afirmativo, mandar metodo
     GGM_GOACTIVE y setearlo como activo en la lista de ventanas con objs
  -  4to: continuara...}

Function GE_AddGadget(Win : WindowPtr; Gad : GadgetPtr; Pos : Short) : Short;

Var
 Ll,Ll2: WinListPtr;

Begin
 if (Win<>Nil)and(Gad<>Nil) then begin
  if GE_IsObject(Gad) then begin
   {Writeln("Is");}
   Ll:= WinListPtr(GEngineBase^.eb_WinList.mlh_head); Ll2:= Ll;
   While (Ll^.wl_Node.mln_Succ<>Nil)and(Ll^.wl_Window<>Win) do Begin
    Ll2:= Ll;
    Ll:= WinListPtr(Ll^.wl_Node.mln_Succ);
   end;
   Ll:= Ll2;
   if Ll^.wl_Window = Win then
    inc(Ll^.wl_ObjCount)
   else begin
    Ll2:= AllocMem(SizeOf(WinList),MEMF_CLEAR+MEMF_PUBLIC);
    if Ll2<>Nil then begin
     Ll2^.wl_Window:= Win;
     Ll2^.wl_ObjCount:= 1;
     AddHead(Adr(GEngineBase^.eb_WinList),NodePtr(Ll2));
    end;
   end;
  end{ else
   Writeln("is not")};
  GE_AddGadget:= AddGadget(Win,Gad,Pos);
 end;
 GE_AddGadget:=0;
end;

Function GE_RemoveGadget(Win: WindowPtr; Gad:GadgetPtr):Short;
Var
 Ll,Ll2: WinListPtr;
 I: Short;
{-Falta verificar que no este activo-}
Begin
 if (Win<>Nil)and(Gad<>Nil) then begin
  I:= RemoveGadget(Win,Gad);
  if (I<>-1)and GE_IsObject(Gad) then begin
   Ll:= WinListPtr(GEngineBase^.eb_WinList.mlh_head); Ll2:= Ll;
   While (Ll^.wl_Node.mln_Succ<>Nil)and(Ll^.wl_Window<>Win) do Begin
    Ll2:= Ll;
    Ll:= WinListPtr(Ll^.wl_Node.mln_Succ);
   end;
   Ll:= Ll2;
   if Ll^.wl_Window = Win then begin
    dec(Ll^.wl_ObjCount);
    if Ll^.wl_ObjCount=0 then begin
     Remove(NodePtr(Ll));
     FreeMem(Ll,SizeOf(WinList));
    end;
   end;
  end;
  GE_RemoveGadget:= I;
 end;
 GE_RemoveGadget:=-1;
end;
