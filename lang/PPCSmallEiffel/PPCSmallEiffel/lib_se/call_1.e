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
deferred class CALL_1
   --
   -- For calls with only one argument.
   --   

inherit CALL;
   
feature 
   
   arguments: EFFECTIVE_ARG_LIST;
   
feature 
   
   make(t: like target; fn: like feature_name; a: like arguments) is
      require
	 t /= Void;
	 fn /= Void;
	 a /= Void;
      do
	 target := t;
	 feature_name := fn;
	 arguments := a;
      ensure
	 target = t;
	 feature_name = fn;
	 arguments = a;
      end;
   
feature 

   can_be_dropped: BOOLEAN is do end;
   -- ******************************* VERIFIER CA ???

   is_pre_computable: BOOLEAN is false;
   
   arg1: EXPRESSION is
      do
	 Result := arguments.first;
      end;
   
   arg_count: INTEGER is 1;
   
   to_runnable(ct: TYPE): like Current is
      local
	 a: like arguments;
	 tla: TYPE_LIKE_ARGUMENT;
      do
	 if current_type = Void then
	    to_runnable_0(ct);
	    a := arguments.to_runnable(ct);
	    if a = Void then
	       error(arg1.start_position,fz_bad_argument);
	    else
	       arguments := a;
	    end;
	    if nb_errors = 0 then 
	       arguments.match_with(run_feature); 
	    end;
	    if nb_errors = 0 then
	       tla ?= result_type;
	       if tla /= Void then
		  result_type := arg1.result_type.run_type;
	       end;
	    end;
	    if nb_errors = 0 then
	       Result := Current;
	    end;
	 else
	    Result := twin;
	    Result.set_current_type(Void);
	    Result := Result.to_runnable(ct);
	 end;
      end;
   
feature {NONE}
   
   with_target(t: like target) is
      require
	 t.is_checked;
      do
	 target := t;
      end;
   
invariant
   
   arguments.count = 1
   
end -- CALL_1

