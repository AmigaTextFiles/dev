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
class CALL_0_C
   -- Other calls without argument.

inherit CALL_0;

creation make

feature

   short is
      do
	 target.short_target;
	 feature_name.short;
      end;

   short_target is
      do
	 short;
	 short_print.a_dot;
      end;

   bracketed_pretty_print, pretty_print is
      do
	 target.print_as_target;
	 fmt.put_string(feature_name.to_string);
      end;
   
   is_pre_computable: BOOLEAN is
      do
	 if target.is_current then
	    Result := run_feature.is_pre_computable;
	 end;
      end;

   is_static: BOOLEAN is
      local
	 name: STRING;
	 tt: TYPE;
	 tb: TYPE_BIT;
      do
	 if run_feature /= Void then
	    tt := target.result_type;
	    name := run_feature.name.to_string;
	    if us_is_expanded_type = name then
	       Result := true;
	       if tt.is_expanded then
		  static_value_mem := 1;
	       end;
	    elseif us_is_basic_expanded_type = name then
	       Result := true;
	       if tt.is_basic_eiffel_expanded then
		  static_value_mem := 1;
	       end;
	    elseif us_count = name and then tt.is_bit then
	       Result := true;
	       tb ?= tt;
	       static_value_mem := tb.nb;
	    elseif target.is_current then
	       if run_feature.is_static then
		  Result := true;
		  static_value_mem := run_feature.static_value_mem;
	       else
		  Result := call_is_static;
	       end;
	    else
	       Result := call_is_static;
	    end;
	 end;
      end;

   isa_dca_inline_argument: INTEGER is
      -- *** A FAIRE ??? ***
      do
      end;

   dca_inline_argument(formal_arg_type: TYPE) is
	 -- *** FAIRE ***
      do
      end;

   compile_to_jvm is
      local
	 n: STRING;
      do
	 n := feature_name.to_string;
	 if us_is_expanded_type = n then
	    if target.result_type.is_expanded then
	       code_attribute.opcode_iconst_1;
	    else
	       code_attribute.opcode_iconst_0;
	    end;
	 elseif us_is_basic_expanded_type = n then
	    if target.result_type.is_basic_eiffel_expanded then
	       code_attribute.opcode_iconst_1;
	    else
	       code_attribute.opcode_iconst_0;
	    end;
	 else
	    call_proc_call_c2jvm;
	 end;
      end;
   
   jvm_branch_if_false: INTEGER is
      do
	 Result := jvm_standard_branch_if_false;
      end;

   jvm_branch_if_true: INTEGER is
      do
	 Result := jvm_standard_branch_if_true;
      end;
   
end -- CALL_0_C

