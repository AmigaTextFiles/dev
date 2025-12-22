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
class ARGUMENT_NAME1
   --
   -- An argument name in some declaration list.
   --

inherit ARGUMENT_NAME;

creation {TMP_NAME} make

creation {ARGUMENT_NAME1} make_runnable

feature
   
   to_runnable(ct: TYPE): like Current is
      local
	 t1, t2: TYPE;
      do
	 t1 := result_type;
	 t2 := t1.to_runnable(ct);
	 if t2 = Void then
	    eh.add_position(t1.start_position);
	    error(start_position,em_ba);
	 end;
	 if current_type = Void then
	    current_type := ct;
	    result_type := t2;
	    Result := Current;
	 else
	    !!Result.make_runnable(Current,ct,t2);
	 end;
      end;

feature {DECLARATION_LIST}

   name_clash is
      local
	 rf: RUN_FEATURE;
	 rc: RUN_CLASS;
      do
	 if base_class_written.has_feature(to_string) then
	    rc := current_type.run_class;
	    rf := rc.get_feature_with(to_string);
	    if rf /= Void then
	       eh.add_position(rf.start_position);
	    end;
	    error(start_position,
		  "Conflict between argument/feature name (VRFA).");
	 end;
      end;

end -- ARGUMENT_NAME1

