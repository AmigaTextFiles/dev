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
class PROC_CALL_0
   --
   -- For procedure calls without argument (only Current).
   --   
   
inherit PROC_CALL;

creation make

feature

   arg_count: INTEGER is 0;
     
feature 
   
   make(t: like target; fn: like feature_name) is
      require
	 t /= Void;
	 fn /= Void;
      do
	 target := t;
	 feature_name := fn;
      end;

feature
   
   arguments: EFFECTIVE_ARG_LIST is
      do
      end;

   to_runnable(rc: like run_compound): like Current is
      do
	 if run_compound = Void then
	    to_runnable_0(rc);
	    if nb_errors = 0 and then run_feature.arg_count > 0 then
	       eh.add_position(feature_name.start_position);
	       error(run_feature.start_position,
		     "Feature found has argument(s).");
	    end;
	    if nb_errors = 0 then
	       Result := Current;
	    end;
	 else
	    !!Result.make(target,feature_name);
	    Result := Result.to_runnable(rc);
	 end;
      end;
   
   compile_to_jvm is
      do
	 call_proc_call_c2jvm;
      end;

   pretty_print is
      do
	 target.print_as_target;
	 fmt.put_string(feature_name.to_string);
	 if fmt.semi_colon_flag then
	    fmt.put_character(';');
	 end;
      end;
      
feature {CREATION_CALL}

   make_runnable(rc: like run_compound; 
		 w: like target; a: like arguments;
		 rf: RUN_FEATURE): like Current is
      do
	 if run_compound = Void then
	    Result := Current;
	    Result.make(w,feature_name);
	    run_compound := rc;
	    run_feature := rf;
	 else
	    !!Result.make(w,feature_name);
	    Result.set_run_compound(rc);
	    Result.set_run_feature(rf);
	 end;
      end;

invariant
   
   arguments = Void;
   
end -- PROC_CALL_0

