--          This file is part of SmallEiffel The GNU Eiffel Compiler.
--          Copyright (C) 1994-98 LORIA - UHP - CRIN - INRIA - FRANCE
--            Dominique COLNET and Suzanne COLLIN - colnet@loria.fr 
--                       http://www.loria.fr/SmallEiffel
-- SmallEiffel is  free  software;  you can  redistribute it and/or modify it 
-- under the terms of the GNU General Public License as published by the Free
-- Software  Foundation;  either  version  2, or (at your option)  any  later 
-- version. SmallEiffel is distributed in the hope that it will be useful,but
-- WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
-- or  FITNESS FOR A PARTICULAR PURPOSE.   See the GNU General Public License 
-- for  more  details.  You  should  have  received a copy of the GNU General 
-- Public  License  along  with  SmallEiffel;  see the file COPYING.  If not,
-- write to the  Free Software Foundation, Inc., 59 Temple Place - Suite 330,
-- Boston, MA 02111-1307, USA.
--
class ASSIGNMENT
--
-- For instruction like :
--                          foo := bar;
--                          foo := bar + 1;
--
-- 

inherit INSTRUCTION;
   
creation make
   
feature 
   
   left_side: EXPRESSION;
   
   right_side: EXPRESSION;
   
feature

   make(ls: like left_side; rs: like right_side) is
      require
	 ls.is_writable;
	 ls.start_position /= Void;
	 rs /= Void
      do
	 left_side := ls;
	 right_side := rs;
      ensure
	 left_side = ls;
	 right_side = rs
      end; 
   
feature
   
   end_mark_comment: BOOLEAN is false;

feature
   
   is_pre_computable: BOOLEAN is 
      local
	 call: CALL;
	 rf6: RUN_FEATURE_6;
      do
	 if left_side.is_result then
	    if right_side.is_pre_computable then
	       call ?= right_side;
	       if call /= Void then
		  rf6 ?= call.run_feature;
		  Result := rf6 = Void;
	       else
		  Result := true;
	       end;
	    end;
	 end;
      end;
   
   afd_check is
      do
	 right_side.afd_check;
      end;

   compile_to_c is
      local
	 left_run_type, right_run_type: TYPE;
	 trace: BOOLEAN;
      do
	 trace := trace_instruction;
	 if trace then
	    cpp.rs_push_position('1',start_position);
	 end;
	 left_run_type := left_type.run_type;
	 right_run_type := right_type.run_type;
	 if left_run_type.is_reference then
	    if right_run_type.is_reference then
	       -- ------------------------ Reference into Reference :
	       left_side.compile_to_c;
	       cpp.put_character('=');
	       if right_side.is_current then
		  cpp.put_string(fz_cast_t0_star);
	       end;
	       right_side.compile_to_c;
	       cpp.put_string(fz_00);
	    else
	       -- ------------------------- Expanded into Reference :
	       left_side.compile_to_c;
	       cpp.put_character('=');
	       right_run_type.to_reference;
	       cpp.put_character('(');
	       right_side.compile_to_c;
	       cpp.put_character(')');
	       cpp.put_string(fz_00);
	    end;
	 else
	    check
	       left_run_type.is_expanded
	    end;
	    if right_run_type.is_reference then
	       -- ------------------------- Reference into Expanded :
	       -- (std_copy or fail when Void).
	       eh.add_position(left_side.start_position);
	       fatal_error("Not Yet Implemented %
			   %(ASSIGNMENT/Reference into Expanded).");
	    else
	       -- -------------------------- Expanded into Expanded :
	       if left_run_type.is_bit then
		  bit_into_bit(left_run_type,right_run_type);
	       else
		  c_coding1;
	       end;
	    end;
	 end;
	 if trace then
	    cpp.rs_pop_position;
	 end;
      end;
   
   compile_to_jvm is
      do
	 left_side.compile_to_jvm_assignment(Current);
      end;
   
   use_current: BOOLEAN is
      do
	 Result := left_side.use_current;
	 Result := Result or else right_side.use_current;
      end;
      
   right_type: TYPE is
      require
	 right_side.is_checked
      do
	 Result := right_side.result_type;
      ensure
	 Result /= Void
      end;
   
   left_type: TYPE is
      do
	 Result := left_side.result_type;
      ensure
	 Result /= Void
      end;
   
   start_position: POSITION is
      do
	 Result := left_side.start_position;
      end;
   
   to_runnable(rc: like run_compound): like Current is
      local
	 left_run_type, right_run_type: TYPE;
	 e: EXPRESSION;
      do
	 if run_compound = Void then
	    run_compound := rc;
	    e := left_side.to_runnable(current_type);
	    if e = Void then
	       error(left_side.start_position,fz_blhsoa);
	    else
	       left_side := e;
	    end;
	    e := right_side.to_runnable(current_type);
	    if e = Void then
	       error(right_side.start_position,fz_brhsoa);
	    else
	       right_side := e;
	    end;
	    if nb_errors = 0 then
	       if not right_side.is_a(left_side) then
		  error(left_side.start_position," Bad assignment.");
	       end;
	    end;
	    if nb_errors = 0 then
	       left_run_type := left_type.run_type;
	       right_run_type := right_type.run_type;
	       if left_run_type.is_reference then
		  if right_run_type.is_reference then
		     -- ------------------------- Reference into Reference :
		  else
		     -- -------------------------- Expanded into Reference :
		     right_run_type.used_as_reference;
		  end;
	       else
		  if right_run_type.is_reference then
		     -- -------------------------- Reference into Expanded :
		     if right_side.is_void then
			eh.add_position(right_side.start_position);
			eh.append("Void may not be assigned to an %
				  %expanded entity. Left hand side is ");
			eh.add_type(left_type,".");
			eh.print_as_error;
		     else
			warning(left_side.start_position,
				"ASSIGNMENT/Not Yet Implemented.");
		     end;
		  else
		     -- --------------------------- Expanded into Expanded :
		  end;
	       end;
	    end;
	    if nb_errors = 0 then
	       Result := Current;
	    end;
	 else
	    !!Result.make(left_side,right_side);
	    Result := Result.to_runnable(rc);
	 end;
      end;
   
   pretty_print is
      do
	 pretty_print_assignment(left_side,":=",right_side);
      end;

feature {NONE}

   c_coding1 is
      do
	 left_side.compile_to_c;
	 cpp.put_character('=');
	 right_side.compile_to_c;
	 cpp.put_string(fz_00);
      end;

   bit_into_bit(left_t, right_t: TYPE) is
      require
	 left_t.is_bit;
	 right_t.is_bit
      local 
	 left, right: TYPE_BIT;
      do
	 left ?= left_t;
	 right ?= right_t;
	 if left.is_c_char then -- ------- unsigned char <- unsigned char
	    if left.nb = right.nb then
	       c_coding1;
	    else
	       left_side.compile_to_c;
	       cpp.put_character('=');
	       right_side.compile_to_c;
	       cpp.put_string(fz_c_shift_right);
	       cpp.put_integer(left.nb - right.nb);
	       cpp.put_string(fz_00);
	    end;
	 elseif left.is_c_int then 
	    if right.is_c_int then -- ------------- unsigned <- unsigned
	       if left.nb = right.nb then
		  c_coding1; 
	       else
		  left_side.compile_to_c;
		  cpp.put_character('=');
		  right_side.compile_to_c;
		  cpp.put_string(fz_c_shift_right);
		  cpp.put_integer(left.nb - right.nb);
		  cpp.put_string(fz_00);
	       end;
	    else  -- ----------------------------------- unsigned <- unsigned char
	       check
		  right.is_c_char
	       end;
	       left_side.compile_to_c;
	       cpp.put_string("=((unsigned)");
	       right_side.compile_to_c;
	       cpp.put_string(")<<((CHAR_BIT*sizeof(unsigned))-CHAR_BIT-(");
	       cpp.put_integer(left.nb);
	       cpp.put_character('-');
	       cpp.put_integer(right.nb);
	       cpp.put_string(fz_16);
	    end;
	 else 
	    check 
	       left.is_c_unsigned_ptr
	    end;
	    if right.is_c_unsigned_ptr then -- -- unsigned* <- unsigned*
	       cpp.put_string("memcpy(");
	       left_side.mapping_c_arg(left);
	       cpp.put_character(',');
	       right_side.mapping_c_arg(right);
	       cpp.put_character(',');
	       cpp.put_integer(left.space_for_variable);
	       cpp.put_character(')');
	       cpp.put_string(fz_00);
	    elseif right.is_c_int then -- ------- unsigned* <- unsigned
	       cpp.put_string("memset(&"); 
	       left_side.compile_to_c;
	       cpp.put_string(",0,sizeof(");
	       left_side.compile_to_c;
	       cpp.put_string(fz_16);
	    else -- ---------------------------------- unsigned* <- unsigned char
	        check
                   right.is_c_char
                end;
	    end;
	 end;
      end;

feature {NONE}

   trace_instruction: BOOLEAN is
      local
          ci: CALL_INFIX;
      do
         if run_control.no_check then
            if right_side.c_simple then
            elseif right_type.is_basic_eiffel_expanded then
               ci ?= right_side;
               if ci /= Void then
                  if ci.target.c_simple and then ci.arg1.c_simple then
                  else
                     Result := true;
                  end;
	       end;
	    else
	       Result := true;
	    end;
	 end;
      end;
				  
invariant
   
   left_side.is_writable;
   
   right_side /= Void
   
end -- ASSIGNMENT

