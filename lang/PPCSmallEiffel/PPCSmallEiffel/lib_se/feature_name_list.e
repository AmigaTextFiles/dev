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
class FEATURE_NAME_LIST
   --
   -- A list of FEATURE_NAME (FEATURE_NAME, INFIX_NAME and
   -- PREFIX_NAME mixed).
   --
   
inherit GLOBALS;
   
creation make
   
feature {NONE}
   
   list: ARRAY[FEATURE_NAME];
   
feature 
   
   make(l: like list) is
	 -- Note: also check for multiple occurrences.
      require   
	 l.lower = 1;
	 not l.empty;
      local
	 i, i2: INTEGER;
      do
	 list := l;
	 from  
	    i := l.upper;
	 until
	    i = 0 
	 loop
	    i2 := index_of(l.item(i));
	    if i2 /= i then
	       eh.add_position(l.item(i2).start_position);
	       eh.add_position(l.item(i).start_position);
	       fatal_error("Same feature name appears twice.");
	    end;
	    i := i - 1;
	 end;
      ensure
	 list = l;
      end;
   
feature
   
   has(fn: FEATURE_NAME): BOOLEAN is
      require
	 fn /= Void
      do
	 Result := index_of(fn) > 0 ;
      end;
   
   feature_name(fn_key: STRING): FEATURE_NAME is
      require
	 fn_key = unique_string.item(fn_key)
      local
	 i: INTEGER;
      do
	 from  
	    i := 1;
	 until
	    fn_key = item(i).to_key or else i > count
	 loop
	    i := i + 1;
	 end;
	 if i <= count then
	    Result := item(i);
	 end;
      end;
   
   pretty_print is
      local
	 i, icount: INTEGER;
      do
	 from  
	    i := 1;
	 until
	    i > count
	 loop
	    fmt.set_indent_level(3);
	    list.item(i).definition_pretty_print;
	    i := i + 1;
	    icount := icount + 1;
	    if i <= count then
	       fmt.put_string(", ");
	       if icount > 4 then
		  fmt.set_indent_level(3);
		  fmt.indent;
		  icount := 0;
	       end;
	    end;
	 end;
      end;

   short is
      local
	 i, icount: INTEGER;
      do
	 from  
	    i := 1;
	 until
	    i > count
	 loop
	    list.item(i).short;
	    i := i + 1;
	    if i <= count then
	       short_print.hook_or("fnl_sep",", ");
	    end;
	 end;
      end;
   
   item(i: INTEGER): FEATURE_NAME is
      require
	 1 <= i;
	 i <= count;
      do
	 Result := list.item(i);
      end;
   
   count: INTEGER is
      do 
	 Result := list.upper;
      end;

feature {FEATURE_CLAUSE}

   for_short(fc: FEATURE_CLAUSE; heading_done: BOOLEAN; bcn: CLASS_NAME;
	     sort: BOOLEAN; rf_list: FIXED_ARRAY[RUN_FEATURE]; 
	     rc: RUN_CLASS): BOOLEAN is
      local
	 i: INTEGER;
	 fn: FEATURE_NAME;
	 rf: RUN_FEATURE;
      do
	 Result := heading_done;
	 from  
	    i := 1;
	 until
	    i > count
	 loop
	    fn := list.item(i);
	    rf := rc.get_rf_with(fn);
	    if not rf_list.fast_has(rf) then
	       rf_list.add_last(rf);
	       if not sort then
		  if not heading_done then
		     Result := true;
		     fc.do_heading_for_short(bcn);
		  end;
		  short_print.a_run_feature(rf);
	       end;
	    end;
	    i := i + 1;
	 end;
      end;
   
feature {RUN_FEATURE_1}

   index_of(fn: FEATURE_NAME): INTEGER is
      require
	 fn /= Void;
      local
	 fn_key: STRING;
      do
	 fn_key := fn.to_key;
	 from  
	    Result := list.upper;
	 until
	    Result = 0 or else fn_key = item(Result).to_key
	 loop
	    Result := Result - 1;
	 end;
      ensure
	 0 <= Result;
	 Result <= count;
	 Result > 0 implies fn.to_key = item(Result).to_key
      end;

feature {CREATION_CLAUSE}

   short_for_creation is
      local
	 i: INTEGER;
      do
	 from  
	    i := 1;
	 until
	    i > count
	 loop
	    short_print.a_feature(list.item(i));
	    i := i + 1;
	 end;
      end;
   
invariant
   
   count >= 1;
   
   list.lower = 1;
   
end -- FEATURE_NAME_LIST

