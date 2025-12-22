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
class CALL_N
--
-- For calls with more than one argument : "bar.foo(...)".
-- For other calls, use CALL_0 or CALL_1.
--  

inherit CALL;
   
creation make
   
feature 
   
   arguments: EFFECTIVE_ARG_LIST;
   
   make(t: like target; sn: like feature_name; a: like arguments) is
      require
	 t /= void;
	 sn /= void;
	 a.count > 1;
      do
	 target := t;
	 feature_name := sn;
	 arguments := a;
      end;
   
feature

   is_pre_computable: BOOLEAN is false;
   
   is_static: BOOLEAN is
      do
	 Result := call_is_static;
      end;

   isa_dca_inline_argument: INTEGER is
	 -- *** FAIRE ***
      do
      end;

   dca_inline_argument(formal_arg_type: TYPE) is
	 -- *** FAIRE ***
      do
      end;

   arg_count: INTEGER is
      do
	 Result := arguments.count;
      end;
   
   can_be_dropped: BOOLEAN is do end;
   
   to_runnable(ct: TYPE): like Current is
      local
	 a: like arguments;
	 tla: TYPE_LIKE_ARGUMENT;
	 e: EXPRESSION;
      do
	 if current_type = Void then
	    to_runnable_0(ct);
	    a := arguments.to_runnable(ct);
	    if a = Void then
	       error(arguments.start_position,fz_bad_arguments);
	    else
	       arguments := a;
	    end;
	    if nb_errors = 0 then 
	       arguments.match_with(run_feature); 
	    end;
	    if nb_errors = 0 then
	       tla ?= result_type;
	       if tla /= Void then
		  e := arguments.expression(tla.rank);
		  result_type := e.result_type.run_type;
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
   
   frozen bracketed_pretty_print, frozen pretty_print is
      do
	 target.print_as_target;
	 fmt.put_string(feature_name.to_string);
	 fmt.level_incr;
	 arguments.pretty_print;
	 fmt.level_decr;
      end;

   short is
      do
	 target.short_target;
	 feature_name.short;
	 arguments.short;
      end;
   
   short_target is
      do
	 short;
	 short_print.a_dot;
      end;

   compile_to_jvm is
      do
	 call_proc_call_c2jvm;
      end;
   
   jvm_branch_if_false: INTEGER is
      do
	 Result := jvm_standard_branch_if_false;
      end;

   jvm_branch_if_true: INTEGER is
      do
	 Result := jvm_standard_branch_if_true;
      end;
   
invariant
   
   arguments.count > 1
   
end -- CALL_N

