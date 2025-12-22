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
deferred class CALL_INFIX_EQ_NEQ
   --
   -- Root for "=" and "/=".
   --

inherit 
   CALL_INFIX
      undefine compile_to_c
      redefine afd_check, use_current, to_runnable, finalize
      end;

feature 

   precedence: INTEGER is 6;
   
   frozen use_current: BOOLEAN is
      do
	 Result := target.use_current or else arg1.use_current;
      end;

   frozen afd_check is
      do
	 target.afd_check;
	 arg1.afd_check;
      end;

   frozen to_runnable(ct: TYPE): like Current is
      do
	 if current_type = Void then
	    to_runnable_equal_not_equal(ct);
	    result_type := type_boolean;
	    if nb_errors = 0 then
	       Result := Current;
	    end;
	 else
	    !!Result.make(target,feature_name.start_position,arg1);
	    Result := Result.to_runnable(ct);
	 end;
      end;
   
   isa_dca_inline_argument: INTEGER is
	 -- *** FAIRE ***
      do
      end;

   dca_inline_argument(formal_arg_type: TYPE) is
	 -- *** FAIRE ***
      do
      end;

feature {RUN_FEATURE_4}

   frozen dca_inline(formal_arg_type: TYPE) is
      do
	 cpp.put_character('(');
	 cpp.put_target_as_value;
	 cpp.put_character(')');
	 if operator.first = '=' then
	    cpp.put_string(fz_c_eq);
	 else
	    cpp.put_string(fz_c_neq);
	 end;
	 cpp.put_character('(');
	 arg1.dca_inline_argument(formal_arg_type);
	 cpp.put_character(')');
      end;

feature {RUN_FEATURE_3,RUN_FEATURE_4}

   finalize is
      do
      end;

feature {NONE}

   frozen to_runnable_equal_not_equal(ct: TYPE) is
	 -- Because there is no feature definition for "=" and "/=".
      require
	 ct /= Void;
	 current_type = Void;
      local
	 t: like target;
	 a: like arguments;
	 tt, at: TYPE;
      do
	 current_type := ct;
	 t := target.to_runnable(ct);
	 if t = Void then
	    error(target.start_position,"Bad target.");
	 else
	    target := t;
	 end;
	 a := arguments.to_runnable(ct);
	 if a /= Void then
	    arguments := a;
	 end;
	 if nb_errors = 0 then
	    tt := target.result_type.run_type;
	    at := arg1.result_type.run_type;
	    if tt.is_none then
	       if at.is_expanded then
		  at.used_as_reference;
	       end;
	    elseif at.is_none then
	       if tt.is_expanded then
		  tt.used_as_reference;
	       end;
	    elseif tt.is_reference then
	       if at.is_reference then
		  if tt.is_a(at) then
		  else
		     eh.cancel;
		     if at.is_a(tt) then
		     else
			error_comparison("Reference/Reference");
		     end;
		  end;
	       elseif not at.is_a(tt) then
		  error_comparison("Reference/Expanded");
	       else
		  at.used_as_reference;
	       end;
	    else
	       if at.is_expanded then
		  if at.is_basic_eiffel_expanded then
		     if tt.is_a(at) then
		     else
			eh.cancel;
			if at.is_a(tt) then
			else
			   error_comparison("Expanded/Expanded");
			end;
		     end;
		  elseif tt.is_bit then
		     bit_limitation(tt,at);
		  elseif not at.is_a(tt) then
		     error_comparison("Expanded/Expanded");
		  end;
	       elseif not tt.is_a(at) then
		  error_comparison("Expanded/Reference");
	       else
		  tt.used_as_reference;
	       end;
	    end;
	 end;
      ensure
	 current_type = ct;
      end;

   error_comparison(str: STRING) is
      do
	 eh.add_position(feature_name.start_position);
	 eh.append(" Comparison ");
	 eh.append(str); 
	 eh.append(" Not Valid. Context of Types interpretation is ");
	 eh.add_type(current_type,fz_dot);
	 eh.print_as_error;
      end;

   bit_limitation(t1, t2: TYPE) is
      require
	 t1.is_bit;
	 t2.is_bit
      local
	 b1, b2: TYPE_BIT;
      do
	 b1 ?= t1;
	 b2 ?= t2;
	 if b1.nb /= b2.nb then
	    eh.add_position(feature_name.start_position);
	    eh.append("Comparison between ");
	    eh.add_type(b1," and ");
	    eh.add_type(b2,
            " is not yet implemented (you can work arround doing an %
	    %assignment in a local variable).");
	    eh.print_as_fatal_error;
	 end;
      end;

feature {NONE}

   is_manifest_array(e: EXPRESSION): BOOLEAN is
      local
	 ma: MANIFEST_ARRAY;
      do
	 ma ?= e;
	 Result := ma /= Void;
      end;

feature {NONE} -- Low level comparison tools :

   cmp_bit(equal_test: BOOLEAN; t: TYPE) is
      require
	 t.is_bit
      local
	 tb: TYPE_BIT;
      do
	 tb ?= t;
	 if tb.is_c_unsigned_ptr then
	    if equal_test then
	       cpp.put_character('!');
	    end;
	    cpp.put_string("memcmp((");
	    target.mapping_c_arg(t);
	    cpp.put_string("),(");
	    arg1.mapping_c_arg(t);
	    cpp.put_string("),");
	    cpp.put_integer(tb.space_for_variable);
	    cpp.put_string(")");
	 else
	    cpp.put_character('(');
	    target.compile_to_c;
	    cpp.put_character(')');
	    if equal_test then
	       cpp.put_string(fz_c_eq);
	    else
	       cpp.put_string(fz_c_neq);
	    end;
	    cpp.put_character('(');
	    arg1.compile_to_c;
	    cpp.put_character(')');
	 end;
      end;

   cmp_user_expanded(equal_test: BOOLEAN; t: TYPE) is
      require
	 t.is_user_expanded
      local
	 mem_id: INTEGER;
      do
	 if t.is_dummy_expanded then
	    cpp.put_character('(');
	    target.compile_to_c;
	    cpp.put_character(',');
	    arg1.compile_to_c;
	    cpp.put_character(',');
	    if equal_test then
	       cpp.put_character('1');
	    else
	       cpp.put_character('0');
	    end;
	    cpp.put_character(')');
	 else
	    mem_id := t.id;
	    if equal_test then
	       cpp.put_character('!');
	    end;
	    cpp.put_string(fz_se_cmpt);
	    cpp.put_integer(mem_id);
	    cpp.put_string("((");
	    target.compile_to_c;
	    cpp.put_string("),(");
	    arg1.compile_to_c;
	    cpp.put_string("))");
	 end;
      end;

   cmp_basic_eiffel_expanded(equal_test: BOOLEAN; t1, t2: TYPE) is
      require
	 t1.is_basic_eiffel_expanded;
	 t2.is_basic_eiffel_expanded
      local
	 flag: BOOLEAN;
      do
	 flag := t1.is_real or else t2.is_real;
	 if flag then
	    cpp.put_string(fz_cast_float);
	 end;
	 cpp.put_character('(');
	 target.compile_to_c;
	 if flag then
	    cpp.put_string(fz_13);
	 end;
	 cpp.put_character(')');
	 if equal_test then
	    cpp.put_string(fz_c_eq);
	 else
	    cpp.put_string(fz_c_neq);
	 end;
	 cpp.put_character('(');
	 if flag then
	    cpp.put_string(fz_cast_float);
	 end;
	 arg1.compile_to_c;
	 cpp.put_character(')');
	 if flag then
	    cpp.put_string(fz_13);
	 end;
      end;

   cmp_basic_ref(equal_test: BOOLEAN) is
      do
	 cpp.put_character('(');
	 target.compile_to_c;
	 cpp.put_character(')');
	 if equal_test then
	    cpp.put_string(fz_c_eq);
	 else
	    cpp.put_string(fz_c_neq);
	 end;
	 cpp.put_character('(');
	 cpp.put_string(fz_cast_void_star);
	 cpp.put_character('(');
	 arg1.compile_to_c;
	 cpp.put_character(')');
	 cpp.put_character(')');
      end;

   fz_cast_float: STRING is "((float)(";

end -- CALL_INFIX_EQ_NEQ

