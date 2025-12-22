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
class E_LOOP
   --   
   -- The Eiffel instruction : "from ... until ... loop ... end".
   --

inherit INSTRUCTION;
      
creation make

feature 

   start_position: POSITION;
	 -- Of letter 'f' of "from".
   
   initialize: COMPOUND;

   invariant_clause: LOOP_INVARIANT;

   variant_clause: LOOP_VARIANT;

   until_expression: EXPRESSION;

   loop_body: COMPOUND;

feature {NONE}

   make(sp: like start_position;
	i: like initialize; 
	ic : like invariant_clause; 
	vc: like variant_clause; 
	ue : like until_expression;
	lb : like loop_body) is
      require
	 sp /= Void;
	 ue /= Void;
      do
	 start_position := sp;
	 initialize := i; 
	 invariant_clause := ic; 
	 variant_clause := vc; 
	 until_expression := ue;
	 loop_body := lb;
      ensure
	 start_position = sp;
	 initialize = i; 
	 invariant_clause = ic; 
	 variant_clause = vc; 
	 until_expression = ue;
	 loop_body = lb;
      end;

feature

   is_pre_computable: BOOLEAN is false;

   end_mark_comment: BOOLEAN is true;
   
feature

   afd_check is
      do
	 if run_control.loop_check then
	    if variant_clause /= Void then
	       variant_clause.afd_check;
	    end;
	    if invariant_clause /= Void then
	       invariant_clause.afd_check;
	    end;
	 end;
	 if initialize /= Void then
	    initialize.afd_check;
	 end;
	 until_expression.afd_check;
	 if loop_body /= Void then
	    loop_body.afd_check;
	 end;
      end;
   
   compile_to_c is
      local
	 loop_check, variant_flag, invariant_flag: BOOLEAN;
      do
	 loop_check := run_control.loop_check; 
	 if loop_check and then variant_clause /= Void then
	    cpp.put_string("{int c=0;int v=0;%N");
	    variant_flag := true;
	 end;
	 if initialize /= Void then
	    initialize.compile_to_c;
	 end;
	 if loop_check and then invariant_clause /= Void then
	    invariant_clause.compile_to_c;
	    invariant_flag := true;
	 end;
	 cpp.put_string("while (!(");
	 if run_control.no_check then
	    cpp.trace_boolean_expression(until_expression);
	 else
	    until_expression.compile_to_c;
	 end;
	 cpp.put_string(")) {%N");
	 if variant_flag then
	    cpp.variant_check(variant_clause.expression);
	 end;
	 if loop_body /= Void then
	    loop_body.compile_to_c;
	 end;
	 if invariant_flag then
	    invariant_clause.compile_to_c;
	 end;
	 cpp.put_string(fz_12);
	 if variant_flag then
	    cpp.put_string(fz_12);
	 end;
      end;
   
   compile_to_jvm is
      local
	 point1, point2: INTEGER
      do
	 if initialize /= Void then
	    initialize.compile_to_jvm;
	 end;
	 point1 := code_attribute.program_counter;
	 if invariant_clause /= Void then
	    if run_control.loop_check then
	       invariant_clause.compile_to_jvm(true);
	    end;
	 end;	 
	 point2 := until_expression.jvm_branch_if_true;
	 if loop_body /= Void then
	    loop_body.compile_to_jvm;
	 end;
	 code_attribute.opcode_goto_backward(point1);
	 code_attribute.resolve_u2_branch(point2);
      end;
   
   use_current: BOOLEAN is   
      local
	 loop_check: BOOLEAN;
      do
	 loop_check := run_control.loop_check; 
	 if loop_check and then variant_clause /= Void then
	    Result := Result or else variant_clause.use_current;
	 end;
	 if initialize /= Void then
	    Result := Result or else initialize.use_current;
	 end;
	 Result := Result or else until_expression.use_current;
	 if loop_check and then invariant_clause /= Void then
	    Result := Result or else invariant_clause.use_current;
	 end;
	 if loop_body /= Void then
	    Result := Result or else loop_body.use_current;
	 end;
      end;
   
   to_runnable(rc: like run_compound): like Current is
      local
	 ue : like until_expression;
	 loop_check: BOOLEAN;
      do
	 loop_check := run_control.loop_check; 
	 if run_compound = Void then
	    run_compound := rc;
	    if initialize /= Void then
	       initialize := initialize.to_runnable(current_type);
	       if initialize = Void then
		  error(start_position,"Bad initialisation part.");
	       end;
	    end;
	    if loop_check and then invariant_clause /= Void then
	       invariant_clause := invariant_clause.to_runnable(rc.current_type);
	       if invariant_clause = Void then
		  error(start_position,"Bad invariant.");
	       end;
	    end;
	    if loop_check and then variant_clause /= Void then
	       variant_clause := variant_clause.to_runnable(current_type);
	       if variant_clause = Void then
		  error(start_position,"Bad variant for this loop.");
	       end;
	    end;
	    ue := until_expression.to_runnable(current_type);
	    if ue /= Void then
	       if not ue.result_type.is_boolean then
		  error(ue.start_position,
			"Expression of until must be BOOLEAN.");
		  eh.add_type(ue.result_type,fz_is_not_boolean);
		  eh.print_as_error;
	       end;
	       until_expression := ue;
	    else
	       error(start_position, "This loop has an invalid expression.");
	    end;
	    if loop_body /= Void then
	       loop_body := loop_body.to_runnable(current_type);
	       if loop_body = Void then
		  error(start_position,"Invalid loop body.");
	       end;
	    end;
	    if nb_errors = 0 then
	       Result := Current;
	    end;
	 else
	    !!Result.make(start_position,initialize,invariant_clause,
			  variant_clause,until_expression,loop_body); 
	    Result := Result.to_runnable(rc);
	 end;
      end;
   
   pretty_print is
      local
	 semi_colon_flag: BOOLEAN;
      do
	 fmt.indent;
	 fmt.keyword(fz_from);
	    if initialize /= Void then
	       initialize.pretty_print;
	    end;
	 if invariant_clause /= Void then
	    invariant_clause.pretty_print;
	 end;
	 if variant_clause /= Void then
	    fmt.indent;
	    fmt.keyword(fz_variant);
	    semi_colon_flag := fmt.semi_colon_flag;
	    fmt.set_semi_colon_flag(false);
	    variant_clause.pretty_print;
	    fmt.set_semi_colon_flag(semi_colon_flag);
	 end;
	 fmt.indent;
	 fmt.keyword(fz_until);
	 fmt.level_incr;
	 fmt.indent;
	 fmt.set_semi_colon_flag(false);
	 until_expression.pretty_print;
	 fmt.level_decr;
	 fmt.indent;
	 fmt.keyword(fz_loop);
	 fmt.indent;
	 if loop_body /= Void then
	    loop_body.pretty_print;
	 end;
	 fmt.indent;
	 fmt.keyword("end;");
	 if fmt.print_end_loop then
	    fmt.put_end(fz_loop);
	 end;
      end;

invariant
   
   start_position /= Void;
   
   until_expression /= Void;
   
end -- E_LOOP

