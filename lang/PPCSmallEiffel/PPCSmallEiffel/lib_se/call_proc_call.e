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
deferred class CALL_PROC_CALL
--
-- Common root for CALL and PROC_CALL.
--

inherit GLOBALS;

feature -- Common attributes :

   target: EXPRESSION;
	 -- Target of the call.
   
   feature_name: FEATURE_NAME;
	 -- Selector name of the call.

   run_feature: RUN_FEATURE;
	 -- When checked, corresponding (static) run feature.

feature -- Common deferred :

   arg_count: INTEGER is
      deferred
      ensure 
	 Result >= 0
      end;
   
   arguments: EFFECTIVE_ARG_LIST is
	 -- Arguments of the call if any.
      deferred
      ensure
	 Result = Void or else Result.count > 0
      end;

   current_type: TYPE is
      deferred
      end;

   is_checked: BOOLEAN is
      deferred
      end;

feature 

   start_position: POSITION is
      do
	 Result := feature_name.start_position; 
      end;

   use_current, frozen standard_use_current: BOOLEAN is
      do
	 if arg_count > 0 then
	    Result := arguments.use_current;
	 end;
	 if Result then
	 elseif target.is_current then
	    Result := run_feature.use_current;
	 else
	    Result := target.use_current;
	 end;
      end;

feature 

   afd_check is
      local
	 rc: RUN_CLASS;
	 running: ARRAY[RUN_CLASS];
      do
	 rc := target.result_type.run_class;
	 running := rc.running;
	 if running = Void then
	    eh.add_position(target.start_position);
	    eh.append("Call on a Void target in the living Eiffel code. %
		      %No instance of type ");
	    eh.append(rc.current_type.run_time_mark);
	    eh.append(fz_07)
	    eh.print_as_warning;
	    rc.set_at_run_time;
	 elseif running.count > 0 then
	    switch_collection.update(target,run_feature);
	 end;
	 target.afd_check;
	 if arg_count > 0 then
	    arguments.afd_check;
	 end;
      end;

feature {RUN_FEATURE_3,RUN_FEATURE_4}

   finalize is
	 -- For inlining of direct calls on an attribute.
      require
	 is_checked;
	 small_eiffel.is_ready;
	 run_control.boost;
	 current_type.run_class.running.count = 1
      local
	 ct: TYPE;
	 rc: RUN_CLASS;
	 rf: RUN_FEATURE;
	 r: ARRAY[RUN_CLASS];
      do
	 rf := run_feature;
	 rc := rf.current_type.run_class;
	 if not rc.at_run_time then
	    rf := rc.running.first.dynamic(rf);
	    run_feature := rf;
	 end;
      ensure
	 run_feature.current_type.run_class.at_run_time
      end;

feature {NONE}
   
   cpc_to_runnable(ct: TYPE) is
      require
	 ct /= Void;
      local
	 t: like target;
	 rc: RUN_CLASS;
      do
	 t := target.to_runnable(ct);
	 if t = Void then
	    eh.add_position(target.start_position);
	    fatal_error("Bad target.");
	 end;
	 target := t;
	 check
	    target.current_type = ct
	 end;
	 rc := target.result_type.run_class;
	 run_feature := rc.get_rf(Current);
	 switch_collection.update(target,run_feature);
      ensure
	 target.is_checked;
	 run_feature /= Void
      end;

feature {NONE}

   frozen call_proc_call_c2c is
      do
	 cpp.put_cpc(Current);
      end;
   
   frozen call_proc_call_c2jvm is
      do
	 jvm.b_put_cpc(Current);
      end;

invariant

   target /= Void;
   
   feature_name /= Void
   
end -- CALL_PROC_CALL

