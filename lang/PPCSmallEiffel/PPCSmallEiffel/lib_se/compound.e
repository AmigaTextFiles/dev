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
class COMPOUND 
   --
   -- A list of Eiffel instructions.
   --

inherit GLOBALS;

creation {EIFFEL_PARSER,COMPOUND}
   make
   
feature  
   
   header_comment: COMMENT;
   
   current_type: TYPE;
	 -- Not Void when checked.
   
feature {NONE} 
   
   list: ARRAY[INSTRUCTION];
   
feature {EIFFEL_PARSER,COMPOUND}
   
   make(hc: like header_comment; l: like list) is
      require
	 hc /= Void or else l /= Void;
	 l /= Void implies l.lower = 1 and not l.empty;
      do
	 header_comment := hc;
	 list := l;
      ensure 
	 header_comment = hc;
	 list = l;
      end;
   
feature 
   
   count: INTEGER is
      do
	 if list /= Void then
	    Result := list.upper;
	 end;
      end;
      
   first: INSTRUCTION is
      do
	 if list /= Void then
	    Result := list.first;
	 end;
      end;
   
   start_position: POSITION is
      do
	 if list /= Void then
	    Result := list.first.start_position;
	 end;
      end;
   
   run_class: RUN_CLASS is
      do
	 Result := current_type.run_class;
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
	    from  
	       i := 1;
	    until
	       i > list.upper
	    loop
	       list.item(i).compile_to_c;
	       i := i + 1;
	    end;
	 end;
      end;
   
   c2jvm: BOOLEAN is
	 -- Result is false when no byte code is produced.
      local
	 pc: INTEGER;
      do
	 pc := code_attribute.program_counter;
	 compile_to_jvm;
	 Result := pc /= code_attribute.program_counter;
      end;
   
   compile_to_jvm is
      local
	 i: INTEGER;
      do
	 if list /= Void then
	    from  
	       i := 1;
	    until
	       i > list.upper
	    loop
	       list.item(i).compile_to_jvm;
	       i := i + 1;
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
   
   to_runnable(ct: TYPE): like Current is
      require
	 ct.run_type = ct;
	 nb_errors = 0;
      local
	 i: INTEGER;
	 i1, i2: INSTRUCTION;
      do
	 if current_type = Void then
	    current_type := ct;
	    if list /= Void then
	       from
		  i := list.upper;
	       until
		  i = 0
	       loop
		  i1 := list.item(i);
		  i2 := i1.to_runnable(Current);
		  if nb_errors > 0 then
		     eh.append("Bad instruction (when interpreted in ");
		     eh.append(current_type.written_mark);
		     eh.add_position(i1.start_position);
		     fatal_error(").");
		  else
		     check
			i2.run_compound = Current;
		     end;
		     list.put(i2,i);
		  end;
		  i := i - 1;
	       end;
	    end;
	    Result := Current;
	 else
	    if list = Void then
	       !!Result.make(header_comment,Void);
	    else
	       !!Result.make(header_comment,list.twin);
	    end;
	    Result := Result.to_runnable(ct);
	 end;
      ensure 
	 Result /= Void implies Result.current_type = ct
      end;
   
   pretty_print is
      require
	 fmt.indent_level >= 2;
      local
	 i: INTEGER;
      do
	 fmt.level_incr;
	 fmt.indent;
	 if header_comment /= Void then
	    header_comment.pretty_print;
	 end;
	 if list /= Void then
	    from  
	       i := 1;
	    until
	       i > list.upper
	    loop
	       fmt.set_semi_colon_flag(true);
	       fmt.indent;
	       list.item(i).pretty_print;
	       i := i + 1;
	    end;
	 end;
	 fmt.level_decr;
      ensure
	 fmt.indent_level = old fmt.indent_level;
      end;

   empty_or_null_body: BOOLEAN is
      do
	 Result := list = Void;
      end;

invariant
   
   header_comment /= Void or else list /= Void;
   
   list /= Void implies list.lower = 1 and not list.empty;
   
end -- COMPOUND 

