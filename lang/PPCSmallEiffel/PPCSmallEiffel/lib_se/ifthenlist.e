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
class IFTHENLIST

inherit IF_GLOBALS;

creation make
   
feature {NONE}

   list: ARRAY[IFTHEN];
   
   run_compound: COMPOUND;
	 -- When not Void, Current is checked and belongs to
	 -- this compound

feature 
   
   make(l: like list) is
      require
	 not l.empty;
	 l.lower = 1;
      do
	 list := l;
      ensure
	 list = l;
      end;
   
   pretty_print is
      local
	 i: INTEGER;
      do
	 from  
	    i := 1;
	 until
	    i > list.upper
	 loop
	    list.item(i).pretty_print;
	    i := i + 1;
	    if i <= list.upper then
	       fmt.indent;
	       fmt.keyword("elseif");
	    end;
	 end;
      end;

   afd_check is
      local 
	 i: INTEGER;
      do
	 from
	    i := list.upper;
	 until
	    i = 0
	 loop
	    list.item(i).afd_check;
	    i := i - 1;
	 end;
      end;

   compile_to_c: INTEGER is
	 -- state 0: no printing done.
	 -- state 1: already print `non_static'.
	 -- state 2: end of list or previous `static_true'.
      local
	 state, previous, i: INTEGER;
      do
	 from
	    i := 1;
	 until
	    state = 2
	 loop
	    inspect 
	       state
	    when 0 then
	       if i > list.upper then
		  state := 2;
		  Result := previous; 
	       else
		  previous := list.item(i).compile_to_c(false);
		  inspect 
		     previous
		  when non_static then
		     state := 1;
		  when static_false then
		  when static_true then
		     Result := static_true;
		     state := 2;
		  end;
	       end;
	    else -- 1
	       if i > list.upper then
		  state := 2;
		  inspect 
		     previous
		  when static_true then
		     Result := static_true;
		  else
		     Result := non_static;
		  end;
	       else
		  previous := list.item(i).compile_to_c(true);
		  inspect 
		     previous
		  when non_static then
		  when static_false then
		  when static_true then
		     state := 2;
		     Result := static_true;
		  end;
	       end;
	    end;
	    i := i + 1;
	 end;
      ensure
	 (<<static_true,static_false,non_static>>).fast_has(Result)
      end;
   
   compile_to_jvm: INTEGER is
      local
	 i: INTEGER;
      do
	 from
	    Result := list.item(1).compile_to_jvm;
	    i := 2;
	 until
	    Result = static_true or else i > list.upper
	 loop
	    inspect
	       list.item(i).compile_to_jvm
	    when static_true then
	       Result := static_true
	    when static_false then
	       if Result = static_false then
	       else
		  Result := non_static;
	       end;
	    else -- non_static :
	       Result := non_static;
	    end;
	    i := i + 1;
	 end;
      ensure
	 (<<static_true,static_false,non_static>>).fast_has(Result)
      end;

   use_current: BOOLEAN is   
      local      
	 i: INTEGER;
      do
	 from  
	    i := 1;
	 until
	    i > list.upper or else Result
	 loop
	    Result := list.item(i).use_current;
	    i := i + 1;
	 end;
      end;
   
   count: INTEGER is
      do
	 Result := list.upper;
      end;
   
   to_runnable(rc: COMPOUND): like Current is
      require
	 rc.current_type.is_run_type
      local 
	 i: INTEGER;
      do
	 if run_compound /= Void then
	    !!Result.make(list.twin);
	    Result := Result.to_runnable(rc);
	 else
	    run_compound := rc;
	    from  
	       i := 1;
	    until
	       i > list.upper or else nb_errors > 0
	    loop
	       list.put(list.item(i).to_runnable(rc),i);
	       debug
		  if nb_errors = 0 then
		     check
			list.item(i) /= Void;
		     end;
		  end;
	       end;
	       i := i + 1;
	    end;
	    Result := Current;
	 end;
      end;
   
feature {IFTHENELSE}
   
   add_last(it: IFTHEN) is
      require
	 it /= Void
      do
	 list.add_last(it);
      ensure
	 count = old count + 1
      end;

feature {IFTHENELSE}

   compile_to_jvm_resolve_branch is
      local
	 i, static: INTEGER;
      do
	 from
	    i := 1;
	    static := non_static;
	 until
	    static = static_true or else i > list.upper
	 loop
	    static := list.item(i).compile_to_jvm_resolve_branch;
	    i := i + 1;
	 end;
      end;
   
invariant

   list.lower = 1;
   
   count >= 1;
   
end -- IFTHENLIST

