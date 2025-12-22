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
class IFTHENELSE
--
-- The conditionnal instruction : "if ... then ... elseif ... else ... end".
--

inherit 
   INSTRUCTION 
      redefine copy, is_equal 
      select fill_tagged_out_memory
      end;
   IF_GLOBALS
      undefine fill_tagged_out_memory
      end;
   
creation make

feature 
   
   start_position: POSITION;
	 -- Of keyword "if".
   
   ifthenlist: IFTHENLIST;
   
   else_compound: COMPOUND;
	 -- Not Void if any.

feature {NONE}
   
   make(sp: like start_position) is
      do
	 start_position := sp;
      end;
   
feature

   is_pre_computable: BOOLEAN is false;

   end_mark_comment: BOOLEAN is true;
   
feature

   use_current: BOOLEAN is
      do
	 if ifthenlist.use_current then
	    Result := true;
	 elseif else_compound /= Void then
	    Result := else_compound.use_current;
	 end;
      end;

   afd_check is
      do
	 ifthenlist.afd_check;
	 if else_compound /= Void then
	    else_compound.afd_check;
	 end;
      end;

   compile_to_c is   
      local
	 static_value: INTEGER;
      do
	 check
	    ifthenlist.count > 0
	 end;
	 cpp.put_string("/*IF*/");
	 static_value := ifthenlist.compile_to_c;
	 inspect
	    static_value
	 when static_false then
	    cpp.put_string("/*AE*/%N");
	    if else_compound /= Void then
	       else_compound.compile_to_c;
	    end;
	 when static_true then
	 when non_static then
	    if else_compound /= Void then
	       cpp.put_string("else {%N");
	       else_compound.compile_to_c;
	       cpp.put_string("}%N");
	    end;
	 end;
	 cpp.put_string("/*FI*/");
      end;
   
   compile_to_jvm is
      local
	 static_value: INTEGER;
      do
	 check
	    ifthenlist.count > 0
	 end;
	 static_value := ifthenlist.compile_to_jvm;
	 inspect
	    static_value
	 when static_false then
	    -- Always else :
	    if else_compound /= Void then
	       else_compound.compile_to_jvm;
	    end;
	 when static_true then
	    -- Never else :
	    ifthenlist.compile_to_jvm_resolve_branch;
	 when non_static then
	    -- Else is possible :
	    if else_compound /= Void then
	       else_compound.compile_to_jvm;
	    end;
	    ifthenlist.compile_to_jvm_resolve_branch;
	 end;
      end;
   
   to_runnable(rc: like run_compound): like Current is
      local
	 ne: INTEGER;
	 itl: like ifthenlist;
	 ec: like else_compound;
      do
	 ne := nb_errors;
	 if run_compound = Void then
	    run_compound := rc;
	    itl := ifthenlist.to_runnable(rc);
	    if itl = Void then
	       check
		  nb_errors - ne > 0
	       end;
	    else
	       ifthenlist := itl;
	    end;
	    if nb_errors - ne = 0 and then else_compound /= Void then
	       ec := else_compound.to_runnable(current_type);
	       if ec = Void then
		  check
		     nb_errors - ne > 0
		  end;
	       else
		  else_compound := ec;
	       end;
	    end;
	    if itl /= Void then
	       Result := Current
	    end;
	 else
	    Result := twin.to_runnable(rc);
	 end;
      end;
   
   copy(other: like Current) is
      do
	 start_position := other.start_position;
	 ifthenlist := other.ifthenlist;
	 else_compound := other.else_compound;
      end;
   
   is_equal(other: like Current): BOOLEAN is
      do
	 if Current = other then
	    Result := true;
	 else
	    Result := start_position = other.start_position;
	 end;
      end;
      
   add_if_then(expression: EXPRESSION; then_compound: COMPOUND) is
      require
	 expression /= void;
      local
	 ifthen: IFTHEN;
      do
	 !!ifthen.make(expression,then_compound);
	 if ifthenlist = Void then
	    !!ifthenlist.make(<<ifthen>>);
	 else
	    ifthenlist.add_last(ifthen);
	 end;
      end;

   pretty_print is
      do
	 check
	    ifthenlist.count > 0;
	 end;
	 fmt.keyword("if");
	 ifthenlist.pretty_print;
	 if else_compound /= Void then
	    fmt.indent;
	    fmt.keyword("else");
	    else_compound.pretty_print;
	 end;
	 fmt.indent;
	 fmt.keyword("end;");
	 if fmt.print_end_if then
	    fmt.put_end("if");
	 end;
      end;

feature {EIFFEL_PARSER}
   
   set_else_compound(ec: like else_compound) is
      do
	 else_compound := ec;
      ensure
	 else_compound = ec;
      end;
   
end -- IFTHENELSE

