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
class RENAME_LIST
   
inherit GLOBALS;
   
creation {ANY}
   make
   
feature {NONE}
   
   list: ARRAY[RENAME_PAIR];
   
feature {ANY}
   
   make(l: like list) is
      require
	 l.lower = 1;
	 not l.empty;
      do
	 list := l;
      ensure	 
	 list = l
      end;
   
   affect(fn: FEATURE_NAME): BOOLEAN is
	 -- Does Current affect `fn' (new or old as well) ?
      require
	 fn /= Void
      local
	 i: INTEGER;
	 rp: RENAME_PAIR;
	 fn_to_key: STRING;
      do
	 from  
	    i := list.upper;
	 until
	    Result or else i = 0 
	 loop
	    rp := list.item(i);
	    fn_to_key := fn.to_key;
	    if rp.new_name.to_key = fn_to_key or else 
	       rp.old_name.to_key = fn_to_key 
	     then
	       Result := true;
	    else
	       i := i - 1;
	    end;
	 end;
      end;
   
   pretty_print is
      local
	 icount, i: INTEGER;
      do
	 fmt.set_indent_level(2);
	 fmt.indent;
	 fmt.keyword("rename");
	 from  
	    i := 1;
	 until
	    i > list.upper
	 loop
	    list.item(i).pretty_print;
	    i := i + 1;
	    icount := icount + 1;
	    if i <= list.upper then
	       fmt.put_string(", ");
	       if icount > 3 then
		  icount := 0;
		  fmt.set_indent_level(3);
		  fmt.indent;
	       end;
	    end;
	 end;
      end;
   
   to_old_name(fn: FEATURE_NAME): like fn is
	 -- Going up. Gives back `fn' or the old name if any. 
      require
	 fn /= Void;
      local
	 i: INTEGER;
	 fn_to_key: STRING;
      do
	 from  
	    i := 1;
	    fn_to_key := fn.to_key;
	 until
	    Result /= Void or else i > list.upper
	 loop
	    if list.item(i).new_name.to_key = fn_to_key then
	       Result := list.item(i).old_name;
	    end;
	    i := i + 1;
	 end;
	 if Result = Void then
	    Result := fn;
	 end;
      ensure 
	 Result /= Void
      end;
      
   to_new_name(fn: FEATURE_NAME): like fn is
	 -- Going down. Gives back `fn' or the new name if any.
      require
	 fn /= Void;
      local
	 i: INTEGER;
	 fn_to_key: STRING;
      do
	 from  
	    i := 1;
	    fn_to_key := fn.to_key;
	 until
	    Result /= Void or else i > list.upper
	 loop
	    if list.item(i).old_name.to_key = fn_to_key then
	       Result := list.item(i).new_name;
	    end;
	    i := i + 1;
	 end;
	 if Result = Void then
	    Result := fn;
	 end;
      ensure 
	 Result /= Void
      end;
   
feature {PARENT}
   
   add_last(rp: RENAME_PAIR) is
      require
	 rp /= Void
      do
	 list.add_last(rp);
      end;
   
   get_started(pbc: BASE_CLASS) is
      require
	 run_control.all_check
      local
	 i, j: INTEGER;
	 rp1, rp2: RENAME_PAIR;
      do
	 from
	    i := list.upper;
	 until
	    i = 0
	 loop
	    rp1 := list.item(i);
	    if not pbc.has(rp1.old_name) then
	       eh.add_position(rp1.old_name.start_position);
	       fatal_error("Cannot rename inexistant feature (VHRC.1).");
	    end;
	    i := i - 1;
	    from
	       j := i;
	    until
	       j = 0
	    loop
	       rp2 := list.item(j);
	       if rp2.old_name.to_key = rp1.old_name.to_key then
		  eh.add_position(rp1.old_name.start_position);
		  eh.add_position(rp2.old_name.start_position);
		  fatal_error("Multiple rename for the same feature (VHRC.2).");
	       end;
	       j := j - 1;
	    end;
	 end;
      end;
   
invariant
   
   list.lower = 1;
   
   not list.empty;
   
end -- RENAME_LIST

