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
class FUNCTION
   
inherit EFFECTIVE_ROUTINE;
   
creation make
   
feature 
   
   make(n: like names;  
	fa: like arguments; t: like result_type; 
	om: like obsolete_mark;
	hc: like header_comment;
	ra: like require_assertion; lv: like local_vars;
	rb: like routine_body) is
      require
	 t /= void
      do
	 make_effective_routine(n,fa,om,hc,ra,lv,rb);
	 result_type := t;
      end;
   
   to_run_feature(t: TYPE; fn: FEATURE_NAME): RUN_FEATURE_4 is
      do
	 check_obsolete;
	 !!Result.make(t,fn,Current);
      end;
   
feature {C_PRETTY_PRINTER}

   stupid_switch(up_rf: RUN_FEATURE; r: ARRAY[RUN_CLASS]): BOOLEAN is
      local
	 rf4: RUN_FEATURE_4;
	 fn: FEATURE_NAME;
      do
	 rf4 ?= r.first.dynamic(up_rf);
	 if rf4.is_empty_or_null_body then
	    Result := true;
	 else
	    fn := rf4.is_attribute_reader;
	    if fn /= Void then
	       Result := cpp.stupid_switch(up_rf.run_class.get_feature(fn));
	    else
	       fn := rf4.is_direct_call_on_attribute;
	       if fn /= Void then
		  Result := cpp.stupid_switch(up_rf.run_class.get_feature(fn));
	       else 
		  Result := stupid_switch_item(up_rf,r);
	       end;
	    end;
	 end;
      end;

feature {NONE}

   stupid_switch_item(up_rf: RUN_FEATURE; r: ARRAY[RUN_CLASS]): BOOLEAN is
      local
	 f: E_FEATURE;
	 bcn: STRING;
	 i: INTEGER;
	 rf: RUN_FEATURE;
      do
	 f := up_rf.base_feature;
	 if us_item = f.first_name.to_string then
	    bcn := f.base_class.base_class_name.to_string;
	    if us_array = bcn or else us_fixed_array = bcn then
	       from
		  i := r.upper;
		  Result := true;
	       until
		  not Result or else i = 0
	       loop
		  rf := r.item(i).dynamic(up_rf);
		  if rf.result_type.is_expanded then
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
	 !DEFERRED_FUNCTION!Result.from_effective(fn,arguments,
						  result_type,
						  require_assertion,
						  ensure_assertion,
						  bc);
      end;
   
end -- FUNCTION

