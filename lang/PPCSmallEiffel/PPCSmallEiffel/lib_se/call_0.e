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
deferred class CALL_0
   --
   -- For calls without argument (only Current).
   --

inherit 
   CALL 
      redefine to_integer, compile_to_c
      end;
     
feature 
   
   make(t: like target; fn: like feature_name) is
      require
	 t /= void;
	 fn /= void;
      do
	 target := t;
	 feature_name := fn;
      ensure
	 target = t;
	 feature_name = fn
      end;
   
   to_integer: INTEGER is
      local
	 rf1: RUN_FEATURE_1;
      do
	 rf1 ?= run_feature;
	 if rf1 = Void then
	    error(start_position,fz_iinaiv);
	 else
	    Result := rf1.value.to_integer;
	 end;
      end;
   
   can_be_dropped: BOOLEAN is 
      do	 
	 if target.can_be_dropped then
	    Result := run_feature.can_be_dropped;
	 end;
      end;
   
   arg_count: INTEGER is
      do
	 Result := 0;
      end;
   
   to_runnable(ct: TYPE): like Current is
      do
	 if current_type = Void then
	    to_runnable_0(ct);
	    if nb_errors = 0 and then run_feature.arg_count > 0 then
	       eh.add_position(feature_name.start_position);
	       error(run_feature.start_position,"Feature found has arguments.");
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
   
   compile_to_c is
	 -- *** DESCENDRE CE MACHIN DANS CALL_0_C ????? ****
	 -- VIRER LES REDEFINE.
      local
	 n: STRING;
      do
	 n := feature_name.to_string;
	 if us_is_expanded_type = n then
	    if target.result_type.run_type.is_expanded then
	       cpp.put_character('1');
	    else
	       cpp.put_character('0');
	    end;
	 elseif us_is_basic_expanded_type = n then
	    if target.result_type.is_basic_eiffel_expanded then
	       cpp.put_character('1');
	    else
	       cpp.put_character('0');
	    end;
	 else
	    call_proc_call_c2c;
	 end;
      end;

   arguments: EFFECTIVE_ARG_LIST is do end;
   
invariant
   
   arguments = Void
   
end -- CALL_0

