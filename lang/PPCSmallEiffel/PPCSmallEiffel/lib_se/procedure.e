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
class PROCEDURE

inherit
   EFFECTIVE_ROUTINE
      rename make_effective_routine as make
      export {ANY} make
      end;
   
creation make

feature

   to_run_feature(t: TYPE; fn: FEATURE_NAME): RUN_FEATURE_3 is
      do
	 check_obsolete;
	 !!Result.make(t,fn,Current);
      end;
   
feature {C_PRETTY_PRINTER}

   stupid_switch(up_rf: RUN_FEATURE; r: ARRAY[RUN_CLASS]): BOOLEAN is
      local
	 rf3: RUN_FEATURE_3;
	 sfn: SIMPLE_FEATURE_NAME;
      do
	 rf3 ?= r.first.dynamic(up_rf);
	 if rf3.is_empty_or_null_body then
	    Result := true;
	 else
	    sfn := rf3.is_attribute_writer;
	    if sfn /= Void then
	       Result := cpp.stupid_switch(up_rf.run_class.get_feature(sfn));
	    else 
	       Result := stupid_switch_put(up_rf,r);
	    end;
	 end;
      end;

feature {NONE}
   
   stupid_switch_put(up_rf: RUN_FEATURE; r: ARRAY[RUN_CLASS]): BOOLEAN is
      local
	 f: E_FEATURE;
	 bcn: STRING;
	 i: INTEGER;
	 rf: RUN_FEATURE;
      do
	 f := up_rf.base_feature;
	 if us_put = f.first_name.to_string then
	    bcn := f.base_class.base_class_name.to_string;
	    if us_array = bcn or else us_fixed_array = bcn then
	       from
		  i := r.upper;
		  Result := true;
	       until
		  not Result or else i = 0
	       loop
		  rf := r.item(i).dynamic(up_rf);
		  if rf.arguments.type(1).is_expanded then
		     Result := false;
		  end;
		  i := i - 1;
	       end;
	    end;
	 end;
      end;
   
   try_to_undefine_aux(fn: FEATURE_NAME; 
		       bc: BASE_CLASS): DEFERRED_ROUTINE is
      do
	 !DEFERRED_PROCEDURE!Result.from_effective(fn,arguments,
						   require_assertion,
						   ensure_assertion,
						   bc);
      end;
      
invariant
   
   result_type = Void
   
end -- PROCEDURE

