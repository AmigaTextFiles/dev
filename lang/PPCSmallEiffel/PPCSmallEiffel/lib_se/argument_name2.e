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
class ARGUMENT_NAME2
   --
   -- An argument name used somewhere.
   --

inherit ARGUMENT_NAME;

creation {TMP_NAME,FORMAL_ARG_LIST} refer_to
   
creation {ARGUMENT_NAME2} make_runnable
   
feature {NONE}

   refer_to(sp: POSITION; fal: FORMAL_ARG_LIST; r: like rank) is
      local
	 declaration_name: ARGUMENT_NAME1;
      do
	 start_position := sp;
	 rank := r;
	 declaration_name := fal.name(r);
	 to_string := declaration_name.to_string;
	 result_type := declaration_name.result_type;
      end;

feature

   to_runnable(ct: TYPE): like Current is
      local
	 rf: RUN_FEATURE;
	 rt: TYPE;
      do
	 rf := small_eiffel.top_rf;
	 rt := rf.arguments.type(rank);
	 if current_type = Void then
	    current_type := ct;
	    result_type := rt;
	    Result := Current;
	 else
	    !!Result.make_runnable(Current,ct,rt);
	 end;
      end;

end -- ARGUMENT_NAME2

