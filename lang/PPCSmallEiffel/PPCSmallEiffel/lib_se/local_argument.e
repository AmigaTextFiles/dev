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
deferred class LOCAL_ARGUMENT
   --
   -- Common root to handle local variables (LOCAL_NAME) or formal
   -- argument names (ARGUMENT_NAME).
   --

inherit 
   NAME;
   EXPRESSION undefine is_writable end;

feature

   start_position: POSITION;
	 -- Of the first character of the name.
   
   rank: INTEGER;
	 -- Of in the corresponding Eiffel flat list.
   
   result_type: TYPE;
	 -- Type declaration mark.

feature

   can_be_dropped: BOOLEAN is true;
    
   frozen to_key: STRING is
      do
	 Result := to_string;
      end;

   is_pre_computable: BOOLEAN is false;

feature {NONE} -- Parsing Creation procedures :

   make(sp: POSITION; n: STRING) is
	 -- At declaration place.
      require
	 sp /= Void;
	 n /= Void;
      do
	 start_position := sp;
	 to_string := unique_string.item(n);
      ensure
	 start_position = sp;
	 to_string = unique_string.item(n)
      end;

   refer_to(sp: POSITION; dcl: DECLARATION_LIST; r: like rank) is
	 -- Using name `r' of `dcl' at place `sp'.
      require
	 sp /= Void;
	 dcl /= Void;
	 r >= 1;
	 r <= dcl.count;
      deferred
      ensure
	 dcl.rank_of(to_string) = r;
	 rank = r
      end;

feature {DECLARATION_LIST}

   name_clash is
	 -- Check name clash between argument/feature or name clash
	 -- between local/feature.
	 -- Note : clash between local/argument are checked during
	 --        parsing.
      require
	 current_type /= Void
      deferred
      end;
      
feature

   is_static: BOOLEAN is false;
   
   use_current: BOOLEAN is false;

feature

   frozen compile_to_c_old is
      do 
      end;
      
   frozen compile_to_jvm_old is
      do 
      end;
      
   frozen compile_target_to_jvm is
      do
	 standard_compile_target_to_jvm;
      end;

   precedence: INTEGER is
      do
	 Result := atomic_precedence;
      end;

   print_as_target is
      do
	 fmt.put_string(to_string);
	 fmt.put_character('.');
      end;

   frozen short is
      local
	 i: INTEGER;
	 c: CHARACTER;
      do
	 short_print.hook("Ban");
	 from
	    i := 1;
	 until
	    i > to_string.count
	 loop
	    c := to_string.item(i);
	    if c = '_' then
	       short_print.hook_or("Uan","_");
	    else
	       short_print.a_character(c);
	    end;
	    i := i + 1;
	 end;
	 short_print.hook("Aan");
      end;

   frozen short_target is
      do
	 short;
	 short_print.a_dot;
      end;

feature {DECLARATION_LIST}

   set_rank(r: like rank) is
      require
	 r >= 1
      do
	 rank := r;
      ensure
	 rank = r
      end;

feature {DECLARATION_LIST,DECLARATION}

   set_result_type(rt: like result_type) is
      require
	 rt /= Void
      do
	 result_type := rt;
      ensure 
	 result_type = rt
      end;

feature {NONE}

   make_runnable(model: like Current; ct, rt: TYPE) is
      do
	 standard_copy(model);
	 current_type := ct;
	 result_type := rt;
      end;

feature {NONE}

   em_ba: STRING is "Bad argument.";

   em_bl: STRING is "Bad local variable.";

invariant

   start_position /= Void;

end -- LOCAL_ARGUMENT

