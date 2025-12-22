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
class WRITABLE_ATTRIBUTE
--
-- For instance variables (ordinary attribute).
--

inherit
   ATTRIBUTE
      rename make_e_feature as make
      export {ANY} make
      end;
 
creation make
   
feature 
   
   to_run_feature(t: TYPE; fn: FEATURE_NAME): RUN_FEATURE_2 is
      do
	 !!Result.make(t,fn,Current);
      end;
   
feature {C_PRETTY_PRINTER}

   stupid_switch(up_rf: RUN_FEATURE; r: ARRAY[RUN_CLASS]): BOOLEAN is
      local
	 offset1, offset2, i: INTEGER;
	 dyn_rf2: RUN_FEATURE_2;
	 dyn_rc: RUN_CLASS;
      do
	 from
	    i := r.upper;
	    dyn_rc := r.item(i);
	    dyn_rf2 ?= dyn_rc.dynamic(up_rf);
	    if dyn_rf2 /= Void then
	       offset1 := dyn_rc.offset_of(dyn_rf2);
	       Result := true;
	       i := i - 1;
	    end;
	 until
	    not Result or else i = 0
	 loop
	    dyn_rc := r.item(i);
	    dyn_rf2 ?= dyn_rc.dynamic(up_rf);
	    if dyn_rf2 /= Void then
	       offset2 := dyn_rc.offset_of(dyn_rf2);
	       Result := offset1 = offset2;
	       i := i - 1;
	    else
	       Result := false;
	    end;
	 end;
      end;

feature {NONE}
   
   pretty_tail is do end;

end -- WRITABLE_ATTRIBUTE

