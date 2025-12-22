External;

{$I "Pascal.i"}


    Procedure Error(msg : String);
	External;


Procedure Optimize(Expr : ExprPtr);
var
    Param : ExprPtr;

    Function BinaryOptimize : Boolean;
    begin
	with Expr^ do begin
	    Optimize(Left);
	    Optimize(Right);
	    if (Left^.Kind = Const1) and (Right^.Kind = Const1) then begin
		Kind := Const1;
		BinaryOptimize := True;
	    end else
		BinaryOptimize := False;
	end;
    end;

begin
    with Expr^ do begin
	if Kind <= xor1 then begin
	    if Kind <= or1 then begin
		case Kind of              { From and1 to or1 } 
		  and1 : if BinaryOptimize then
			     Value := Left^.Value and Right^.Value
                         else if (Left^.Kind = Const1) and
                                 (Left^.Value = 0) and
                                 ShortCircuit then begin
                             Kind := Const1;
                             Value := 0;
                         end else if (Right^.Kind = Const1) and
                                     (Right^.Value = 0) and
                                     ShortCircuit then begin
                             Kind := Const1;
                             Value := 0;
                         end;
		  const1 : ;
		  div1 : if BinaryOptimize then begin
			     if Left^.Value <> 0 then
				 Value := Right^.Value div Left^.Value
			     else begin
				 Error("Division by zero in DIV expression");
				 Value := 1;
				 EType := BadType;
			     end;
			 end else if (Left^.Kind = Const1) and
					(Left^.Value = 0) then
			     Error("Division by zero in DIV expression");
		  func1: begin
			     Param := Expr^.Left;	
			     while Param <> Nil do begin
				 Optimize(Param);
				 Param := Param^.Next;
			     end;
			 end;
		  mod1 : if BinaryOptimize then begin
			     if Left^.Value <> 0 then
				 Value := Right^.Value mod Left^.Value
			     else begin
				 Error("Division by zero in MOD expression");
				 Value := 1;
				 EType := BadType;
			     end;
			 end else if (Left^.Kind = Const1) and
					(Left^.Value = 0) then
				Error("Division by zero in MOD expression");
		  not1 : begin
			     Optimize(Left);
			     if Left^.Kind = Const1 then begin
				 Value := not Left^.Value;
				 Kind := Const1;
			     end;
			 end;
		  or1  : if BinaryOptimize then
			     Value := Left^.Value or Right^.Value
                         else if (Left^.Kind = Const1) and
                                 (Left^.Value = -1) and
                                 ShortCircuit then begin
                             Value := -1;
                             Kind := Const1;
                         end else if (Right^.Kind = Const1) and
                                     (Right^.Value = -1) and
                                     ShortCircuit then begin
                             Value := -1;
                             Kind := Const1;
                         end;
		else
		    Writeln(OutFile, '1:Did not optimize ', Ord(Kind));
		end;
	    end else begin
		case Kind of		{ from shl1 to xor1 }
		  shl1 : if BinaryOptimize then
			     Value := Left^.Value shl Right^.Value
			 else if Right^.Kind = Const1 then begin
			     if (Right^.Value) and 31 = 0 then
				 Expr^ := Left^;
			 end;
		  shr1 : if BinaryOptimize then
			     Value := Left^.Value shr Right^.Value
			 else if Right^.Kind = Const1 then begin
			     if (Right^.Value) and 31 = 0 then
				 Expr^ := Left^;
			 end;
		  type1: Optimize(Left);
		  var1 : ;
		  xor1 : if BinaryOptimize then
			     Value := Left^.Value xor Right^.Value;
		else
		    Writeln(OutFile, '2:Did not optimize ', Ord(Kind));
		end;
	    end;
	end else begin
	    if Kind <= minus1 then begin
		case Kind of
		  numeral1 : ;
		  asterisk1 :
			if BinaryOptimize then begin
			    if EType = RealType then
				Value := Integer(Real(Left^.Value) *
						Real(Right^.Value))
			    else
				Value := Left^.Value * Right^.Value;
			end else if Left^.Kind = Const1 then begin
			    if Left^.Value = 0 then begin { zero for anything }
				Value := 0;
				Kind := Const1;
			    end else if (EType^.Object = ob_ordinal) and
					(Left^.Value = 1) then begin
				if Right^.EType^.Size < 4 then begin
				    Kind := Short2Long;
				    Left := Right;
				    Right := Nil;
				end else
				    Expr^ := Right^;
			    end;
			end;
		  equal1 :
			if BinaryOptimize then begin
			    if Left^.EType = RealType then
				Value := Ord(Real(Left^.Value) =
						Real(Right^.Value))
			    else
				Value := Ord(Left^.Value = Right^.Value);
			end;
		  greater1 :
			if BinaryOptimize then begin
			    if Left^.EType = RealType then
				Value := Ord(Real(Left^.Value) >
						Real(Right^.Value))
			    else
				Value := Ord(Left^.Value > Right^.Value);
			end;
		  leftbrack1 :
			begin
			    Optimize(Right);
			    if (Right^.Kind = Const1) and
				(Left^.EType^.Object = ob_array) then begin
				if RangeCheck then begin
				    if (Right^.Value < Left^.EType^.Lower) or
				       (Right^.Value > Left^.EType^.Upper) then
					Error("Index out of range");
				end;
				Kind := Period1;
				Value := Right^.Value;
			    end;
			end;
		  less1 :
			if BinaryOptimize then begin
			    if Left^.EType = RealType then
				Value := Ord(Real(Left^.Value) <
						Real(Right^.Value))
			    else
				Value := Ord(Left^.Value < Right^.Value);
			end;
		  minus1 :
			if Right = Nil then begin { Unary minus }
			    Optimize(Left);
			    if Left^.Kind = Const1 then begin
				if EType = RealType then
				    Value := Integer(-Real(Left^.Value))
				else
				    Value := -Left^.Value;
				Kind := Const1;
				if EType = ByteType then
				    EType := ShortType;
			    end;
			end else if BinaryOptimize then begin
			    if EType = RealType then
				Value := Integer(Real(Right^.Value) -
						Real(Left^.Value))
			    else
				Value := Right^.Value - Left^.Value;
			end else if Left^.Kind = Const1 then begin
			    if Left^.Value = 0 then
				Expr^ := Right^;
			end;
		else
		    Writeln(OutFile,'3:Did not optimize ', Ord(Kind));
		end;
	    end else if Kind <= realnumeral1 then begin
		case Kind of { notequal1 through realnumeral1 }
		  notequal1 :
			if BinaryOptimize then begin
			    if Left^.EType = RealType then
				Value := Ord(Real(Left^.Value) <>
						Real(Right^.Value))
			    else
				Value := Ord(Left^.Value <> Right^.Value);
			end;
		  notgreater1 :
			if BinaryOptimize then begin
			    if Left^.EType = RealType then
				Value := Ord(Real(Left^.Value) <=
						Real(Right^.Value))
			    else
				Value := Ord(Left^.Value <= Right^.Value);
			end;
		  notless1 :
			if BinaryOptimize then begin
			    if Left^.EType = RealType then
				Value := Ord(Real(Left^.Value) >=
						Real(Right^.Value))
			    else
				Value := Ord(Left^.Value >= Right^.Value);
			end;
		  period1 : Optimize(Left);
		  plus1 :
			if BinaryOptimize then begin
			    if EType = RealType then
				Value := Integer(Real(Left^.Value) +
						Real(Right^.Value))
			    else
				Value := Left^.Value + Right^.Value;
			end else if Left^.Kind = Const1 then begin
			    if Left^.Value = 0 then
				Expr^ := Right^;
			end;
		  quote1 : ;
		  carat1 : begin
				Optimize(Left);
				if Right <> Nil then
				    Optimize(Right);
			   end;
		  at1 : Optimize(Left);
		  realdiv1 :
			if BinaryOptimize then begin
			    if Left^.Value <> 0 then
				Value := Integer(Real(Right^.Value) /
						Real(Left^.Value))
			    else begin
				Error("Division by zero in '/' expression");
				Value := 1;
				EType := BadType;
			    end;
			end;
		  realnumeral1 : ;
		else
		    Writeln(OutFile, '4:Did not optimize ', Ord(Kind));
		end;
	    end else begin
		case Kind of		{ int2real1 through field1 }
		  int2real :
			begin
			    Optimize(Left);
			    if Left^.Kind = Const1 then begin
				Value := Integer(Float(Left^.Value));
				Kind := Const1;
			    end;
			end;
		  real2int :
			begin
			    Optimize(Left);
			    if Left^.Kind = Const1 then begin
				Value := Trunc(Real(Left^.Value));
				Kind := Const1;
			    end;
			end;
		  short2long :
			begin
			    Optimize(Left);
			    if Left^.Kind = Const1 then begin
				Value := Left^.Value;
				Kind := Const1;
			    end else if Left^.Kind = byte2short then begin
				Kind := byte2long;
				Left := Left^.Left;
			    end;
			end;
		  byte2short :
			begin
			    Optimize(Left);
			    if Left^.EType^.Size > 1 then
				Expr^ := Left^
			    else if Left^.Kind = Const1 then begin
				Kind := Const1;
				Value := Left^.Value and 255;
			    end;
			end;
		  byte2long : ;
		  stanfunc1 :
			if (Value < 7) or (Value > 9) then begin
			    Optimize(Left);
			    if Left^.Kind = Const1 then begin
				if (Value < 15) or (Value > 16) then begin
				    case Value of
				      1,2 : Value := Left^.Value;
				      3 : Value := Ord(Odd(Left^.Value));
				      4 : if EType = RealType then
					      Value := Integer(Abs(Real(Left^.Value)))
					  else
					      Value := Abs(Left^.Value);
				      5 : Value := Succ(Left^.Value);
				      6 : Value := Pred(Left^.Value);
				      10: Value := Trunc(Real(Left^.Value));
				      11: Value := Round(Real(Left^.Value));
				      12: Value := Integer(Float(Left^.Value));
				      13: Value := Integer(Floor(Real(Left^.Value)));
				      14: Value := Integer(Ceil(Real(Left^.Value)));
				      17: Value := Bit(Left^.Value);
				      18: Value := Integer(Sqr(Real(Left^.Value)));
				      19: Value := Integer(Sin(Real(Left^.Value)));
				      20: Value := Integer(Cos(Real(Left^.Value)));
				      21: Value := Integer(Sqrt(Real(Left^.Value)));
				      22: Value := Integer(Tan(Real(Left^.Value)));
				      23: Value := Integer(ArcTan(Real(Left^.Value)));
				      24: Value := Integer(Ln(Real(Left^.Value)));
				      25: Value := Integer(Exp(Real(Left^.Value)));
				    end;
				    Kind := Const1;
				end;
			    end;
			end else if (Value = 7) or (Value = 8) then begin
			    Optimize(Left^.Next);	{ Record size }
			    Optimize(Left);		{ File expression }
			    Optimize(Right);		{ Filename }
			end;
		  field1 : ;
		else
		    Writeln(OutFIle, '5:Did not optimize ', Ord(Kind));
		end;
	    end;
	end; { else }
	if (Kind = Const1) and (EType = ByteType) and (Value < 0) then
	    EType := ShortType;
    end; { with }
end; { Optimize }
