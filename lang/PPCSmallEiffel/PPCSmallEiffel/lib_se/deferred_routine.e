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
deferred class DEFERRED_ROUTINE
   --
   -- For all sorts of deferred routines.   
   --

inherit ROUTINE redefine is_deferred end;
   
feature {ANY}
   
   to_run_feature(t: TYPE; fn: FEATURE_NAME): RUN_FEATURE_9 is
      do
	 check_obsolete;
	 !!Result.make(t,fn,Current);
      end;
   
   is_deferred: BOOLEAN is do Result := true; end;
   
   pretty_print_routine_body is
      do
	 fmt.put_string("%Ndeferred%N");
      end; 

feature {C_PRETTY_PRINTER}

   frozen stupid_switch(up_rf: RUN_FEATURE; r: ARRAY[RUN_CLASS]): BOOLEAN is
      do
      end;

feature {NONE}
   
   try_to_undefine_aux(fn: FEATURE_NAME;
		       bc: BASE_CLASS): DEFERRED_ROUTINE is
      do
	 Result := Current;
      end;
      
end -- DEFERRED_ROUTINE

