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
deferred class ASSERTION_LIST
   --
   -- To store a list of assertions (see ASSERTION).
   --
   -- See also : CLASS_INVARIANT, E_REQUIRE, E_ENSURE, 
   --            LOOP_INVARIANT and CHECK_INVARIANT.
   --
   
inherit GLOBALS;
   
feature 
   
   name: STRING is 
      deferred
      end;
   
   start_position: POSITION;
	 -- If any, the position of the first letter of `name'.
   
   header_comment: COMMENT;
	 
feature {ASSERTION_LIST,E_CHECK,E_FEATURE}
   
   list: ARRAY[ASSERTION];
	 
feature 

   current_type: TYPE;
	 -- Not Void when checked in.
   
   set_current_type(ct: like current_type) is
      do
	 current_type := ct;
      end;
   
   afd_check is
      local
	 i: INTEGER;
      do
	 if list /= Void then
	    from
	       i := list.upper;
	    until
	       i = 0
	    loop
	       list.item(i).afd_check;
	       i := i - 1;
	    end;
	 end;
      end;
   
   compile_to_c is
      local
	 i: INTEGER;
      do
	 if list /= Void then
	    cpp.put_string("if(!se_af){se_af=1;%N");
	    from
	       i := 1;
	    until
	       i > list.upper
	    loop
	       cpp.set_check_assertion_mode(check_assertion_mode);
	       list.item(i).compile_to_c;
	       i := i + 1;
	    end;
	    cpp.put_string("se_af=0;}%N");
	 end;
      end;
   
   frozen compile_to_jvm(last_chance: BOOLEAN) is
	 -- If `last_chance' is true, this assertion list 
	 -- must be true : an error message is printed at run 
	 -- time and the result is not pushed on the JVM stack.
	 -- When `last_chance' is false, the result is left on top
	 -- of the JVM stack and no error message is produced 
	 -- whatever the result is.
      local
	 point_true, i: INTEGER;
	 ca: like code_attribute;
      do
	 if list /= Void then
	    ca := code_attribute;
	    ca.check_opening;
	    if last_chance then
	       from
		  i := 1;
	       until
		  i > list.upper
	       loop
		  list.item(i).compile_to_jvm(true);
		  i := i + 1;
	       end;
	    else
	       from
		  points_false.clear;
		  i := 1;
	       until
		  i > list.upper
	       loop
		  list.item(i).compile_to_jvm(false);
		  points_false.add_last(ca.opcode_ifeq);
		  i := i + 1;
	       end;
	       ca.opcode_iconst_1;
	       point_true := ca.opcode_goto;
	       ca.resolve_with(points_false);
	       ca.opcode_iconst_0;
	       ca.resolve_u2_branch(point_true);
	    end;
	    ca.check_closing;
	 end;
      end;
   
   is_pre_computable: BOOLEAN is 
      local
	 i: INTEGER;
      do
	 if list = Void then
	    Result := true;
	 else
	    from
	       i := list.upper;
	       Result := true;
	    until
	       not Result or else i = 0
	    loop
	       Result := list.item(i).is_pre_computable;
	       i := i - 1;
	    end;
	 end;
      end;

   use_current: BOOLEAN is
      local
	 i: INTEGER;
      do
	 if list /= Void then
	    from  
	       i := list.upper;
	    until
	       Result or else i = 0
	    loop
	       Result := list.item(i).use_current;
	       i := i - 1;
	    end;
	 end;
      end;
   
feature {NONE}

   make(sp: like start_position; hc: like header_comment; l: like list) is
      require
	 l /= Void implies not l.empty;
	 hc /= Void or else l /= Void;
      do
	 start_position := sp;
	 header_comment := hc;
	 list := l;
      ensure
	 start_position = sp;
	 header_comment = hc;
	 list = l;
      end;
   
feature {NONE}

   from_runnable(l: like list) is
      require
	 l.lower = 1;
	 l.upper >= 1;
      do
	 list := l;
	 current_type := list.item(1).current_type;
      ensure
	 current_type /= Void;
      end;
   
feature 
   
   empty: BOOLEAN is
      do
	 Result := list = Void;
      end;
   
   run_class: RUN_CLASS is
      do
	 Result := current_type.run_class;
      end;
   
   to_runnable(ct: TYPE): like Current is
      require
	 ct.run_type = ct;
      do
	 if current_type = Void then
	    current_type := ct;
	    if list /= Void then
	       list := runnable(list,ct,small_eiffel.top_rf); 
	    end;
	    if nb_errors = 0 then
	       Result := Current;
	    end;
	 else
	    Result := twin;
	    Result.set_current_type(Void);
	    Result := Result.to_runnable(ct);
	 end;
      ensure
	 nb_errors = 0 implies Result /= Void
      end;
   
   pretty_print is
      local
	 i: INTEGER;
      do
	 fmt.indent;
	 fmt.keyword(name);
	 fmt.level_incr;
	 if header_comment /= Void then
	    header_comment.pretty_print;
	 else
	    fmt.indent;
	 end;
	 if list /= Void then
	    from  
	       i := 1;
	    until
	       i > list.upper		  
	    loop
	       if fmt.zen_mode and i = list.upper then
		  fmt.set_semi_colon_flag(false);
	       else
		  fmt.set_semi_colon_flag(true);
	       end;	       
	       fmt.indent;	       
	       list.item(i).pretty_print;
	       i := i + 1;
	    end;
	 end;
	 fmt.level_decr;
	 fmt.indent;
      ensure
	 fmt.indent_level = old fmt.indent_level;
      end;

   set_header_comment(hc: like header_comment) is
      do
	 header_comment := hc;
      end;

feature {E_FEATURE,RUN_CLASS}
   
   add_into(collector: ARRAY[ASSERTION]) is
      local
	 i: INTEGER;
	 a: ASSERTION;
      do
	 if list /= Void then
	    from  
	       i := 1;
	    until
	       i > list.upper
	    loop
	       a := list.item(i);
	       if not collector.fast_has(a) then
		  collector.add_last(a);
	       end;
	       i := i + 1;
	    end;
	 end;
      end;
      
feature {NONE}

   points_false: FIXED_ARRAY[INTEGER] is
      once
	 !!Result.with_capacity(12);
      end;

   check_assertion_mode: STRING is
      deferred
      end;
   
invariant
   
   list /= Void implies (list.lower = 1 and not list.empty);
   
end -- ASSERTION_LIST

