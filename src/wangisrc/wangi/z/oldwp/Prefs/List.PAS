{ create a new MyNode, initilising certain values }
Function Add_Name;
VAR
	namenode : pMyNode;
	strn     : STRPTR;

begin
	namenode := AllocRemember(@RememberKey, sizeof(tMyNode), MEMF_CLEAR OR MEMF_PUBLIC);
	namenode^.wi_Node.ln_Name := CStrConstPtrAR(@RememberKey, name);
	namenode^.wi_Node.ln_Type := NT_USER;
	namenode^.wi_Node.ln_Succ := NIL;
	namenode^.wi_Node.ln_Pred := NIL;
	namenode^.wi_Node.ln_Pri  := 0;
	namenode^.wi_Cmd[0]       := CStrConstPtrAR(@RememberKey, '');
	namenode^.wi_Cmd[1]       := CStrConstPtrAR(@RememberKey, '');
	namenode^.wi_RexxCmd      := CStrConstPtrAR(@RememberKey, '');
	namenode^.wi_RexxPort     := CStrConstPtrAR(@RememberKey, '');
	namenode^.wi_HotKey       := CStrConstPtrAR(@RememberKey, '');
	namenode^.wi_Priority     := 0;
	namenode^.wi_Stack        := 4096;
	namenode^.wi_Output       := CStrConstPtrAR(@RememberKey, '');
	namenode^.wi_Type         := TYPE_SHELL;
	AddHead(CurrentList, pNode(namenode));
	add_name := namenode;
end;

{ Detach the list from the Listview gadget }
Procedure DetachObjectList;

VAR 
	Tag_Array : array[0..1] of tTagItem;

begin
	Tag_Array[0].ti_Tag  := GTLV_Labels;
	Tag_Array[0].ti_Data := $FFFFFFFF;
	Tag_Array[1].ti_Tag  := TAG_END;
	GT_SetGadgetAttrsA(gads[G_LV], Thewindow, NIL, @Tag_Array);
end;

{ disable list manipulation gadgets }
Procedure DisableObjectGadgets(Disable : byte);

begin
	DisableGadget(gads[G_B_TOP],     TheWindow, Disable);
	DisableGadget(gads[G_B_UP],      TheWindow, Disable);
	DisableGadget(gads[G_B_DOWN],    TheWindow, Disable);
	DisableGadget(gads[G_B_BOTTOM],  TheWindow, Disable);
	DisableGadget(gads[G_B_REMOVE],  TheWindow, Disable);
	DisableGadget(gads[G_B_COPY],    TheWindow, Disable);
end;

{ Attach the list to the Listview gadget }
Procedure AttachObjectList;

VAR 
	Tag_Array : array[0..4] of tTagItem;

begin
	Tag_Array[0].ti_Tag  := GTLV_Labels;
	Tag_Array[0].ti_Data := LONG(CurrentList);
	Tag_Array[1].ti_Tag  := GTLV_Top;      
	Tag_Array[1].ti_Data := CurrentTop;
	Tag_Array[2].ti_Tag  := GTLV_Selected; 
	Tag_Array[2].ti_Data := CurrentOrd;
	if currentord <> -1 then begin
		Tag_Array[3].ti_Tag  := GTLV_MakeVisible; 
		Tag_Array[3].ti_Data := CurrentOrd;
	End else begin
		Tag_Array[3].ti_Tag  := TAG_IGNORE; 
		Tag_Array[3].ti_Data := 0;
	End;
	Tag_Array[4].ti_Tag  := TAG_END;
	GT_SetGadgetAttrsA(gads[G_LV], TheWindow, NIL, @Tag_Array);
end;

{ sort the list using a bubble sort }
Procedure SortGadgetFunc;

VAR
	notfinished : Boolean;
	first, second, tmpnode : pNode;
	n,i :integer;

begin
	IF CurrentList^.lh_Head^.ln_Succ <> NIL then begin
		wl := pointer(rtLockWindow(TheWindow));
		notfinished := true;
		(* Detach object list *)
		DetachObjectList;
		tmpnode := currentlist^.lh_Head;
		i := 0;
		while tmpnode <> NIL do begin
			tmpnode := tmpnode^.ln_Succ;
			i := i + 1;
		end;
		i := i-2;

		(* Sort list (quick & dirty bubble sort) *)
		while (notfinished) do begin

			(* Reset not finished flag *)
			notfinished := FALSE;

			(* Get first node *)
			first := currentlist^.lh_Head;
			if first <> NIL then begin
				n := 0;
				(* One bubble sort round *)
				second := first^.ln_Succ;
				while n <> i do begin

					(* Compare *)
					n := n + 1;
					if (stricmp(first^.ln_Name,second^.ln_Name)>0) then begin
						(* Swap *)
						Remove(first);
						Insert_(CurrentList,first,second);
						notfinished := TRUE;
					end else
						(* Next *)
						first := second;
					second := first^.ln_Succ;
				end;
			end;
		end;
		(* Reset pointers *)
		CurrentNode := NIL;
		CurrentOrd := -1;
		CurrentTop := 0;

		(* Deactivate object gadgets *)
		DisableObjectGadgets(TRUE_);

		(* Attach object list *)
		AttachObjectList;
		rtUnLockWindow(TheWindow, wl);
	end;
end;

{ calculate the down value from a given across }
Function CalcDown;

VAR
	tmpnode : pNode;
	o : integer;
	down : integer;
	tags : array[0..1] of tTagItem;

begin
	DetachObjectList;
	tmpnode := currentlist^.lh_Head;
	o := -1;
	while tmpnode <> NIL do begin
		tmpnode := tmpnode^.ln_Succ;
		o := o + 1;
	end;
	down := o div across;
	while (down * across) < o do begin
		down := down + 1;
	end;
	if (gad <> NIL) and (win <> NIL) then begin
		tags[0].ti_Tag  := GTNM_Number;
		tags[0].ti_Data := down;
		tags[1].ti_Tag  := TAG_DONE;
		GT_SetGadgetAttrsA(gad, Win, NIL, @tags);
	End;
	AttachObjectList;
	calcdown := down; 
end;