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
class E_INSPECT
   --
   -- The Eiffel inspect instruction.
   --
   
inherit INSTRUCTION;
   
creation make
   
feature 
   
   start_position: POSITION;
	 -- Of keyword `inspect'.
   
   expression: EXPRESSION;
	 -- Heading expression after keyword `inspect'.
   
   when_list: WHEN_LIST;
	 -- List of when clauses.
   
   else_position: POSITION;
	 -- Of the keyword `else' if any.
   
   else_compound: COMPOUND; 
	 -- Else compound if any. 
   
feature {NONE}
   
   make(sp: like start_position; exp: like expression) is
      require
	 sp /= Void;
	 exp /= Void;
      do
	 start_position := sp;
	 expression := exp;
      ensure
	 start_position = sp;
	 expression = exp;
      end;
   
feature 

   is_pre_computable: BOOLEAN is false;

   end_mark_comment: BOOLEAN is true;
   
feature

   afd_check is 
      do 
	 expression.afd_check;
	 if when_list /= Void then
	    when_list.afd_check;
	 end;
	 if else_compound /= Void then
	    else_compound.afd_check;
	 end;
      end;

   includes(v: INTEGER): BOOLEAN is
      -- True if a when clause includes `v'.
      do
	 Result := when_list.includes_integer(v);
      end;
   
   compile_to_c is
      do
	 cpp.inspect_incr;
	 cpp.put_string("{int ");
	 cpp.put_inspect;
	 cpp.put_character('=');
	 expression.compile_to_c;
	 cpp.put_string(fz_00);
	 if when_list = Void then
	    if else_position = Void then
	       if run_control.no_check then
		  cpp.put_error1(em2,start_position);
	       end;
	    elseif else_compound /= Void then
	       else_compound.compile_to_c;
	    end;
	 else
	    when_list.compile_to_c(else_position);
	    if else_position = Void then
	       if run_control.no_check then
		  cpp.put_character(' ');
		  cpp.put_string(fz_else);
		  cpp.put_character('{');
		  cpp.put_error1(em2,start_position);
		  cpp.put_character('}');
	       end;
	    elseif else_compound /= Void then
	       cpp.put_character(' ');
	       cpp.put_string(fz_else);
	       cpp.put_character('{');
	       else_compound.compile_to_c;
	       cpp.put_character('}');
	    end;
	 end;
	 cpp.put_string(fz_12);
	 cpp.inspect_decr;
      end;
   
   compile_to_jvm is
      do
	 expression.compile_to_jvm;
	 if when_list /= Void then
	    when_list.compile_to_jvm(else_position);
	 end;
	 if else_compound /= Void then
	    if run_control.no_check then
	       -- *** Code pour crash ***
	    end;
	    else_compound.compile_to_jvm;
	 end;
	 if when_list /= Void then
	    when_list.compile_to_jvm_resolve_branch;
	 end;
	 code_attribute.opcode_pop;
      end;

   use_current: BOOLEAN is
      do
	 Result := Result or else expression.use_current;
	 if when_list /= Void then
	    Result := Result or else when_list.use_current;
	 end;
	 if else_compound /= Void then
	    Result := Result or else else_compound.use_current;
	 end;	 
      end;
   
   add_when(e_when: E_WHEN) is
      require
	 e_when /= Void
      do
	 if when_list = Void then
	    !!when_list.make(<<e_when>>);
	 else
	    when_list.add_last(e_when);
	 end;
      end;
   
   set_else_compound(sp: like else_position; ec: like else_compound) is
      do
	 else_position := sp;
	 else_compound := ec;
      end;
   
   to_runnable(rc: like run_compound): like Current is
      local
	 e: like expression;
	 te: TYPE;
	 wl: WHEN_LIST;
      do
	 if run_compound = Void then
	    run_compound := rc;
	    e := expression.to_runnable(current_type);
	    if nb_errors = 0 then
	       expression := e;
	       te := e.result_type.run_type;
	       --                  ********
	       --                  VIRABLE
	    end;
	    if nb_errors = 0 then
	       if te.is_character then
		  if when_list /= Void then
		     when_list := when_list.to_runnable_character(Current);
		     if when_list = Void then
			error(start_position,em1);
		     end;
		  end;		  
	       elseif te.is_integer then
		  if when_list /= Void then
		     when_list := when_list.to_runnable_integer(Current);
		     if when_list = Void then
			error(start_position,em1);
		     end;
		  end;		  
	       else
		  eh.append("Expression must be INTEGER or CHARACTER.");
		  eh.add_type(te," is not allowed.");
		  eh.add_position(start_position);
		  eh.print_as_error;
	       end; 
	    end;
	    if else_compound /= Void then
	       else_compound := else_compound.to_runnable(current_type);
	    end;
	    Result := Current
	 else
	    Result := twin;
	    !!wl.from_when_list(when_list);
	    Result.set_when_list(wl);
	    Result.set_run_compound(Void);
	    Result := Result.to_runnable(rc);
	 end;
      end;
   
feature    
   
   pretty_print is
      do
	 fmt.keyword(fz_inspect);
	 fmt.level_incr;
	 if not fmt.zen_mode then
	    fmt.indent;
	 end;
	 fmt.set_semi_colon_flag(false);
	 expression.pretty_print;
	 fmt.level_decr;
	 fmt.indent;
	 if when_list /= Void then
	    when_list.pretty_print;
	 end;
	 if else_compound = Void then
	    if else_position /= Void then
	       fmt.indent;
	       fmt.keyword(fz_else);
	    end;
	 else
	    fmt.indent;
	    fmt.keyword(fz_else);
	    fmt.level_incr;
	    else_compound.pretty_print;
	    fmt.level_decr;
	 end;
	 fmt.indent;
	 fmt.keyword("end;");
	 if fmt.print_end_inspect then
	    fmt.put_end(fz_inspect);
	 end;
      end;
   
feature {E_INSPECT}
   
   set_when_list(wl: like when_list) is
      do
	 when_list := wl;
      ensure
	 when_list = wl;
      end;
   
feature {NONE}
   
   em1: STRING is "Bad inspect.";
   
   em2: STRING is "Invalid inspect (nothing selected).";
   
invariant
   
   expression /= Void;
   
end -- E_INSPECT

