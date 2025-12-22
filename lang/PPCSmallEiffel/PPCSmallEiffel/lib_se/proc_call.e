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
deferred class PROC_CALL
--
-- For all sort of procedure calls.
-- Does not include function calls (see CALL).
--
-- Classification: E_PROC_0 when 0 argument, PROC_CALL_1 when 
-- 1 argument and PROC_CALL_N when N arguments.
--
   
inherit
   CALL_PROC_CALL
      undefine fill_tagged_out_memory
      end;
   INSTRUCTION;
   
feature 
   
   is_pre_computable: BOOLEAN is false;

   end_mark_comment: BOOLEAN is false;

   frozen compile_to_c is
      do
	 cpp.rs_push_position('3',start_position);
	 call_proc_call_c2c;
	 cpp.rs_pop_position;
      end;

feature {CREATION_CALL}

   make_runnable(rc: like run_compound; 
		 w: like target; a: like arguments;
		 rf: RUN_FEATURE): like Current is
      deferred
      end;

feature {PROC_CALL}

   set_run_feature(rf: like run_feature) is
      do
	 run_feature := rf;
      ensure
	 run_feature = rf
      end;

feature {NONE}
   
   to_runnable_0(rc: like run_compound) is
	 -- Set `current_type', `target' and `run_feature'.
      require
	 run_compound = Void;
      do
	 run_compound := rc;
	 cpc_to_runnable(current_type);
	 if run_feature.result_type /= Void then
	    eh.add_position(run_feature.start_position);
	    error(feature_name.start_position,
		  "Feature found is not a procedure.");
	 end;
      ensure
	 run_compound = rc;
      end;
   
end -- PROC_CALL

