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
class PROC_CALL_N
   --
   -- For a procedure call with more than one argument. 
   --  

inherit PROC_CALL;
   
creation make
   
feature 
   
   arguments: EFFECTIVE_ARG_LIST;
   
   make(t: like target; sn: like feature_name; a: like arguments) is
      require
	 t /= Void;
	 sn /= Void;
	 a.count > 1
      do
	 target := t;
	 feature_name := sn;
	 arguments := a;
      end;

feature
   
   to_runnable(rc: like run_compound): like Current is
      local
	 a: like arguments;
      do
	 if run_compound = Void then
	    to_runnable_0(rc);
	    if nb_errors = 0 then
	       a := arguments.to_runnable(current_type);
	       if a = Void then
		  error(arguments.start_position,fz_bad_arguments)
	       else
		  arguments := a;
	       end;
	    end;
	    if nb_errors = 0 then
	       arguments.match_with(run_feature); 
	    end;
	    if nb_errors = 0 then
	       Result := Current;
	    end;
	 else
	    !!Result.make(target,feature_name,arguments);
	    Result := Result.to_runnable(rc);
	 end;
      end;
   
   arg_count: INTEGER is 
      do
	 Result := arguments.count;
      end;
   
   pretty_print is
      do
	 target.print_as_target;
	 fmt.put_string(feature_name.to_string);
	 fmt.level_incr;
	 arguments.pretty_print;
	 fmt.level_decr;
	 if fmt.semi_colon_flag then
	    fmt.put_character(';');
	 end;
      end;
   
   compile_to_jvm is
      do
	 call_proc_call_c2jvm;
      end;
   
feature {CREATION_CALL}

   make_runnable(rc: like run_compound; 
		 w: like target; a: like arguments;
		 rf: RUN_FEATURE): like Current is
      do
	 if run_compound = Void then
	    Result := Current;
	    Result.make(w,feature_name,a);
	    run_compound := rc;
	    run_feature := rf;
	 else
	    !!Result.make(w,feature_name,a);
	    Result.set_run_compound(rc);
	    Result.set_run_feature(rf);
	 end;
      end;

invariant
   
   arguments.count > 1
   
end -- PROC_CALL_N

