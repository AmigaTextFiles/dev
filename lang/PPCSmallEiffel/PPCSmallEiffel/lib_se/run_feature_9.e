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
class RUN_FEATURE_9

inherit RUN_FEATURE redefine base_feature, address_of end;

creation {DEFERRED_ROUTINE} make
   
feature 
   
   base_feature: DEFERRED_ROUTINE;
   
   is_pre_computable: BOOLEAN is false;
   
   is_static: BOOLEAN is false;
   
feature

   afd_check is
      do
	 routine_afd_check;
	 small_eiffel.afd_check_deferred(Current);
      end;

   mapping_c is
      do
      end;
   
   can_be_dropped: BOOLEAN is
      do
      end;
   
   c_define is
      do
      end;
   
   address_of is
      do
      end;
   
   local_vars: LOCAL_VAR_LIST is do end;
   
   static_value_mem: INTEGER is do end;

feature {NONE}   
   
   initialize is
      do
	 arguments := base_feature.arguments;
	 if arguments /= Void and then arguments.count > 0 then
	    arguments := arguments.to_runnable(current_type);
	 end;
	 result_type := base_feature.result_type;
	 if result_type /= Void then
	    result_type := result_type.to_runnable(current_type);
	 end;
      end;
   
   compute_use_current is
      do
      end;

feature {RUN_CLASS}

   jvm_field_or_method is
      do
      end;

feature

   mapping_jvm is
      do
      end;

feature {JVM}

   jvm_define is
      do
      end;
   
feature {NONE}

   update_tmp_jvm_descriptor is
      do
	 routine_update_tmp_jvm_descriptor;
      end;

invariant
   
   require_assertion = Void;
   
   local_vars = Void;
   
   routine_body = Void;
   
   ensure_assertion = Void;
   
   rescue_compound = Void;

end -- RUN_FEATURE_9

