External;

{
	SameName.p

	This include file contains only one function: SameName.
This routine implements the simplest parts of AmigaDOS pattern matching.
At this point that's just the  # and ? operators, plus the single quote ',
which you place before a # or ? meant to be matched literaly.  Check out
the AmigaDOS books for more information.
	The source for this is in Runtime/Extras, and the object code
is in PCQ.lib
}


Function SameName(Mask, Target : String) : Boolean;

type
    CompState = (initial, two_char, char_series, any_char, star);
var
    MaskPos,
    TargetPos : Short;
    State : CompState;
begin
    MaskPos := 0;
    TargetPos := 0;
    State := initial;
    while true do
	case State of
	  initial : case Mask[MaskPos] of
		      '#' : begin
				MaskPos := Succ(MaskPos);
				State := char_series;
			    end;
		      '?' : begin
				MaskPos := Succ(MaskPos);
				State := any_char;
			    end;
		     '\'' : begin
				MaskPos := Succ(MaskPos);
				State := two_char;
			    end;
		    else
			State := two_char;
		    end;
	  two_char: if Mask[MaskPos] = Target[TargetPos] then begin
			if Mask[MaskPos] = '\0' then
			    SameName := True;
			MaskPos := Succ(MaskPos);
			TargetPos := Succ(TargetPos);
			State := initial;
		    end else
			SameName := False;
	  char_series :
		    case Mask[MaskPos] of
		      '?' : begin
				MaskPos := Succ(MaskPos);
				State := Star;
			    end;
		     '\0' : SameName := False;
		    else begin
			     while Target[TargetPos] = Mask[MaskPos] do
				 TargetPos := Succ(TargetPos);
			     MaskPos := Succ(MaskPos);
			     State := initial;
			 end;
		    end;
	  any_char: begin
			TargetPos := Succ(TargetPos);
			State := initial;
		    end;
	  star    : begin
			while (Target[TargetPos] <> Mask[MaskPos]) and
				(Target[TargetPos] <> '\0') do
			    TargetPos := Succ(TargetPos);
			state := initial;
		    end;
	end;
end;

