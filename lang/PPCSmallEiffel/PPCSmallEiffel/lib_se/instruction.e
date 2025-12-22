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
deferred class INSTRUCTION
--
-- For all differents kinds of Eiffel instruction.
--
   
inherit 
   GLOBALS
      redefine fill_tagged_out_memory 
      end; 

   
feature 

   fill_tagged_out_memory is
      local
	 p: POSITION;
	 ct: TYPE;
	 rtm: STRING;
      do
	 p := start_position;
	 if p /= Void then
	    p.fill_tagged_out_memory;
	 end;
	 if run_compound /= Void then
	    ct := run_compound.current_type;
	    if ct /= Void then
	       rtm := ct.run_time_mark;
	       if rtm /= Void then
		  tagged_out_memory.append(" ct=");
		  tagged_out_memory.append(rtm);
	       end;
	    end;
	 end;
      end;

   run_compound: COMPOUND;
	 -- When not Void, the instruction is checked and belongs to
	 -- this compound
      
   start_position: POSITION is
	 -- Of the first character of the instruction.
      deferred
      ensure
	 Result /= Void
      end;
   
   pretty_print is
      require
	 fmt.indent_level >= 3;
      deferred
      ensure
	 fmt.indent_level = old fmt.indent_level;
      end;
   
   use_current: BOOLEAN is 
      -- Does instruction use Current ?
      require
	 is_checked;
	 small_eiffel.is_ready;
      deferred 
      end;
   
   to_runnable(rc: like run_compound): like Current is
      -- Gives a checked instruction runnable in `rc.current_type'.
      require
	 rc /= Void;
	 rc.current_type /= Void;
	 rc.current_type.is_run_type
      deferred
      ensure
	 nb_errors = 0 implies Result /= Void;
	 Result /= Void implies Result.run_compound = rc;
      end;
   
   is_checked: BOOLEAN is
	 -- Instruction is checked ?
      do
	 Result := run_compound /= Void;
      end;
   
   run_class: RUN_CLASS is
      require
	 is_checked
      do
	 Result := run_compound.run_class;
      ensure
	 Result /= Void;
      end;
   
   current_type: TYPE is
      require
	 is_checked
      do
	 if run_compound /= Void then
	    Result := run_compound.current_type;
	 end;
      ensure
	 Result /= Void;
      end;
   
   end_mark_comment: BOOLEAN is 
	 -- True for instructions with a possible end mark comment 
	 -- like instruction "loop" "debug" or "check" for example.
      deferred
      end;

   afd_check is
	 -- After Falling Down Check.
      require
	 is_checked;
      deferred
      end;
   
   compile_to_c is
      require
	 is_checked;
	 cpp.on_c
      deferred
      ensure	 
	 cpp.on_c
      end;

   compile_to_jvm is
      require
	 is_checked
      deferred
      ensure	 
      end;
   
   is_pre_computable: BOOLEAN is
	 -- Assume the current instruction is inside a once function.
	 -- Result is true when the instruction can be precomputed.
      require
	 is_checked;
	 small_eiffel.is_ready
      deferred
      end;

feature {EIFFEL_PARSER}
   
   add_comment(c: COMMENT): INSTRUCTION is
	 -- Attach `c' to the instruction.
      require
	 eiffel_parser.is_running
      do
	 if c = Void or else c.count = 0 then
	    Result := Current
	 elseif end_mark_comment then
	    if c.count = 1 then
	       Result := Current;
	    else
	       !INSTRUCTION_WITH_COMMENT!Result.make(Current,c);
	    end;
	 else
	    !INSTRUCTION_WITH_COMMENT!Result.make(Current,c);
	 end;
      end;
   
feature {INSTRUCTION}
   
   set_run_compound(rc: like run_compound) is
      do
	 run_compound := rc;
      ensure	 
	 run_compound = rc;
      end;
   
feature {NONE}
   
   pretty_print_assignment(rhs: EXPRESSION; op: STRING; lhs: EXPRESSION) is
      local
	 semi_colon_flag: BOOLEAN;
      do
	 rhs.pretty_print;
	 fmt.put_character(' ');
	 fmt.put_string(op);
	 fmt.put_character(' ');
	 semi_colon_flag := fmt.semi_colon_flag;
	 fmt.level_incr;
	 fmt.set_semi_colon_flag(false);
	 lhs.pretty_print;
	 fmt.set_semi_colon_flag(semi_colon_flag);
	 if semi_colon_flag then
	    fmt.put_character(';');
	 end;
	 fmt.level_decr;
      end;
   
end -- INSTRUCTION

