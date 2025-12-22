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
class RUN_FEATURE_1
   
inherit RUN_FEATURE redefine base_feature, address_of end;
   
creation {CST_ATT} make
   
feature 

   base_feature: CST_ATT;
   
   value: EXPRESSION;
   
   local_vars: LOCAL_VAR_LIST is do end;
   
   is_static: BOOLEAN is 
      do 
	 Result := value.is_static;
      end;
   
   static_value_mem: INTEGER is
      do
	 Result := value.static_value;
      end;

   can_be_dropped: BOOLEAN is true;

   afd_check is do end;

   mapping_c is
      local
	 real_constant: REAL_CONSTANT;
      do
	 if result_type.is_double then
	    real_constant ?= value;
	    check
	       real_constant /= Void;
	    end;
	    cpp.put_string(real_constant.to_string);
	 else
	    value.compile_to_c;
	 end;
      end;
   
   c_define is 
      do 
	 nothing_comment;
      end;
   
   address_of is
      do
	 eh.add_position(start_position);
	 fatal_error("Cannot access address of a constant (VZAA).");
      end;

   compute_use_current is
      do
	 std_compute_use_current;
      end;
   
   is_pre_computable: BOOLEAN is true;
   
feature {NONE}   
   
   initialize is
      local      
	 i: INTEGER;
      do
	 i := base_feature.names.index_of(name);
	 value := base_feature.value(i);
	 value := value.to_runnable(current_type);
	 result_type := base_feature.result_type.to_runnable(current_type);
      end;
   
feature {RUN_FEATURE}

   jvm_field_or_method is
      do
      end;

feature

   mapping_jvm is
      local
	 space: INTEGER;
      do
	 jvm.drop_target;
	 space := value.compile_to_jvm_into(result_type);
      end;

feature {JVM}

   jvm_define is
      do
      end;
   
feature {NONE}

   update_tmp_jvm_descriptor is
      do
      end;

end -- RUN_FEATURE_1

