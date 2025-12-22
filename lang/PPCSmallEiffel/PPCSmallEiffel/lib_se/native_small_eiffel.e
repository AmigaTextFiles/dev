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
class NATIVE_SMALL_EIFFEL

inherit NATIVE;
   
feature
   
   need_prototype: BOOLEAN is false;

feature

   language_name: STRING is
      do
	 Result := fz_se;
      end;

   stupid_switch(name: STRING): BOOLEAN is
      do
	 if us_generating_type = name then
	    Result := true;
	 elseif us_generator = name then
	    Result := true;
	 elseif us_to_pointer = name then
	    Result := true;
	 end;
      end;

   c_define_procedure(rf7: RUN_FEATURE_7; bcn, name: STRING) is
      do
	 if us_bit_n = bcn then
	    c_define_procedure_bit(rf7,name);
	 end;
      end;

   c_mapping_procedure(rf7: RUN_FEATURE_7; bcn, name: STRING) is
      local
	 t: TYPE;
      do
	 if us_copy = name or else us_standard_copy = name then
	    t := rf7.current_type;
	    if t.is_reference then
	       cpp.put_string("*((T");
	       cpp.put_integer(t.id);
	       cpp.put_string("*)(");
	       cpp.put_target_as_value;
	       cpp.put_string("))=*((T");
	       cpp.put_integer(t.id);
	       cpp.put_string("*)(");
	       cpp.put_ith_argument(1);
	       cpp.put_string(fz_16);
	    elseif t.is_basic_eiffel_expanded then
	       cpp.put_target_as_value;
	       cpp.put_string(fz_00);
	       cpp.put_ith_argument(1);
	       cpp.put_string(fz_00);
	    else
	       cpp.put_string("{void* d=");
	       cpp.put_target_as_target;
	       cpp.put_string(";%NT");
	       cpp.put_integer(t.id);
	       cpp.put_string(" s;%Ns=*(");
	       cpp.put_ith_argument(1);
	       cpp.put_string(");%Nmemcpy(d,&s,sizeof(s));}%N");
	    end;
	 elseif us_flush_stream = name then
	    if cpp.target_cannot_be_dropped then
	       cpp.put_string(fz_14);
	    end;
	    cpp.put_string("fflush(");
	    cpp.put_ith_argument(1);
	    cpp.put_string(fz_14);
	 elseif us_write_byte = name then
	    cpp.put_string("putc(");
	    cpp.put_ith_argument(2);
	    cpp.put_string(",((FILE*)(");
	    cpp.put_ith_argument(1);
	    cpp.put_string(")));%N");
	 elseif us_print_run_time_stack = name then
	    cpp.put_string("rsp();%N");
	 elseif us_die_with_code = name then
	    if cpp.target_cannot_be_dropped then
	       cpp.put_string(fz_14);
	    end;
	    cpp.put_string("exit(");
	    cpp.put_ith_argument(1);
	    cpp.put_string(fz_14);
	 elseif us_se_system = name then
	    cpp.put_string("system(((char*)_p));");
	 elseif us_c_inline_c = name then
	    cpp.put_c_inline_c;
	 elseif us_c_inline_h = name then
	    cpp.put_c_inline_h;
	 elseif us_trace_switch = name then
	    cpp.put_trace_switch;
	 elseif us_native_array = bcn then
	    c_mapping_native_array_procedure(rf7,name);
	 elseif us_memory = name then
	    if us_free = name then
	       if gc_handler.is_on then
		  if cpp.cannot_drop_all then
		     cpp.put_string(fz_14);
		  end;
	       else
		  cpp.put_string(us_free);
		  cpp.put_character('(');
		  cpp.put_ith_argument(1);
		  cpp.put_string(fz_14);
	       end;
	    end;
	 elseif us_bit_n = bcn then
	    c_mapping_bit_procedure(rf7,name);
	 elseif us_sprintf_pointer = name then
	    cpp.put_string("{void*p=");
	    cpp.put_target_as_value;
	    cpp.put_string(";%Nsprintf((");
	    cpp.put_ith_argument(1);
	    cpp.put_string("),%"%%p%",p);}%N");
	 elseif us_sprintf_double = name then
	    cpp.sprintf_double_is_used;
	    cpp.put_string("{int i;%N%
			   %double d=");
	    cpp.put_target_as_value;
	    cpp.put_string(";%N%
                           %sprintf(_spfd+2,%"%%d%",(");
	    cpp.put_ith_argument(2);
	    cpp.put_string("));%N%
			   %for(i=2;_spfd[i]!=0;i++);%N%
			   %_spfd[i]='f';%N%
			   %_spfd[++i]=0;%N%
			   %sprintf((");
	    cpp.put_ith_argument(1);
	    cpp.put_string("),_spfd,d);%N}%N");
	 elseif us_se_rename = name then
	    cpp.put_string("rename(((char*)");
	    cpp.put_ith_argument(2);
	    cpp.put_string("),((char*)");
	    cpp.put_ith_argument(4);
	    cpp.put_string(fz_16);
	 elseif us_se_remove = name then
	    cpp.put_string("remove(((char*)");
	    cpp.put_ith_argument(2);
	    cpp.put_string(fz_16);
	 end;
      end;

   c_define_function(rf8: RUN_FEATURE_8; bcn, name: STRING) is
      local
	 elt_type: TYPE;
	 ct: TYPE;
	 rc: RUN_CLASS;
	 rf: RUN_FEATURE;
	 rf7: RUN_FEATURE_7;
      do
	 if us_bit_n = bcn then
	    c_define_function_bit(rf8,name);
	 elseif us_general = bcn then
	    if us_is_equal = name or else us_standard_is_equal = name then
	       ct := rf8.current_type;
	       rc := ct.run_class;
	       if ct.is_basic_eiffel_expanded or else native_array(ct) then
	       elseif rc.is_tagged then
		  rf8.c_define_with_body(
                     "R=((C->id==a1->id)?!memcmp(C,a1,sizeof(*C)):0);");
               elseif rc.writable_attributes = Void then
		  if run_control.boost then
		  else
		     rf8.c_define_with_body("R=1;");
		  end;
	       elseif run_control.boost then
               else
		  rf8.c_define_with_body("R=!memcmp(C,a1,sizeof(*C));");
	       end;
	    elseif us_standard_twin = name then
	       c_define_standard_twin(rf8,rf8.current_type);
	    elseif us_twin = name then
	       ct := rf8.current_type;
	       rc := ct.run_class;
	       rf := rc.get_copy;
	       rf7 ?= rf;
	       if rf7 /= Void then
		  c_define_standard_twin(rf8,ct);
	       else
		  c_define_twin(rf8,ct,rc,rf);
	       end;
	    end;
	 elseif us_native_array = bcn then
	    if us_calloc = name then
	       ct := rf8.current_type;
	       elt_type := ct.generic_list.item(1).run_type;
	       if elt_type.expanded_initializer /= Void then
		  body.copy("R=malloc(a1);%N%
			    %r");
		  ct.id.append_in(body);
		  body.append("clear_all(R,a1-1);%N");
		  rf8.c_define_with_body(body);
	       end;
	    end
         end;
      end;

   c_mapping_function(rf8: RUN_FEATURE_8; bcn, name: STRING) is
      local
	 cbd: BOOLEAN;
	 ct: TYPE;
	 rc: RUN_CLASS;
	 rf: RUN_FEATURE;
	 rf7: RUN_FEATURE_7;
      do
	 if us_stderr = name then
	    cpp.put_string(us_stderr);
	 elseif us_stdin = name then
	    cpp.put_string(us_stdin);
	 elseif us_stdout = name then
	    cpp.put_string(us_stdout);
	 elseif us_general = bcn then
	    if us_generating_type = name then
	       cpp.put_generating_type(rf8.current_type);
	    elseif us_generator = name then
	       cpp.put_generator(rf8.current_type);
	    elseif us_to_pointer = name then
	       cpp.put_to_pointer;
	    elseif us_object_size = name then
	       cpp.put_object_size(rf8.current_type);
	    elseif us_is_equal = name or else us_standard_is_equal = name then
	       ct := rf8.current_type;
	       rc := ct.run_class;
	       if ct.is_basic_eiffel_expanded or else native_array(ct) then
		  cpp.put_character('(');
		  cpp.put_target_as_value;
		  cpp.put_character(')');
		  cpp.put_string(fz_c_eq);
		  cpp.put_character('(');
		  cpp.put_ith_argument(1);
		  cpp.put_character(')');
	       elseif rc.is_tagged then
		  rf8.default_mapping_function;
               elseif rc.writable_attributes = Void then
		  if run_control.boost then
		     cbd := cpp.cannot_drop_all;
		     if cbd then
			cpp.put_character(',');
		     end;
		     cpp.put_character('1');
		     if cbd then
			cpp.put_character(')');
		     end;
		  else
		     rf8.default_mapping_function;
		  end;
	       elseif run_control.boost then
		  cpp.put_string("!memcmp(");
		  cpp.put_target_as_target;
		  cpp.put_character(',');
		  cpp.put_ith_argument(1);
		  cpp.put_string(",sizeof(T");
		  cpp.put_integer(rc.id);
		  cpp.put_string(fz_13);
	       else 
		  rf8.default_mapping_function;
	       end;
	    elseif us_standard_twin = name then
	       c_mapping_standard_twin(rf8,rf8.current_type);
	    elseif us_twin = name then
	       ct := rf8.current_type;
	       rc := ct.run_class;
	       rf := rc.get_copy;
	       rf7 ?= rf;
	       if rf7 /= Void then
		  c_mapping_standard_twin(rf8,ct);
	       else
		  rf8.default_mapping_function;
	       end;
	    elseif us_is_basic_expanded_type = name then
	       cbd := cpp.cannot_drop_all;
	       if cbd then
		  cpp.put_character(',');
	       end;
	       if rf8.current_type.is_basic_eiffel_expanded then
		  cpp.put_character('1');
	       else
		  cpp.put_character('0');
	       end;
	       if cbd then
		  cpp.put_character(')');
	       end;
	    elseif us_is_expanded_type = name then
	       cbd := cpp.cannot_drop_all;
	       if cbd then
		  cpp.put_character(',');
	       end;
	       if rf8.current_type.is_expanded then
		  cpp.put_character('1');
	       else
		  cpp.put_character('0');
	       end;
	       if cbd then
		  cpp.put_character(')');
	       end;
	    elseif us_se_argc = name then
	       cpp.put_string(us_se_argc);
	    elseif us_se_argv = name then
	       cpp.put_string("((T0*)e2s(se_argv[_i]))");
	    elseif us_se_getenv = name then
	       cpp.put_string(
               "(NULL==(_p=getenv((char*)_p)))?NULL:((T0*)e2s((char*)_p))");
	    end;
	 elseif us_native_array = bcn then
	    c_mapping_native_array_function(rf8,name);
	 elseif us_integer = bcn then
	    c_mapping_integer_function(rf8,name);
	 elseif us_real = bcn then
	    c_mapping_real_function(rf8,name);
	 elseif us_double = bcn then
	    c_mapping_double_function(rf8,name);
	 elseif us_boolean = bcn then
	    if us_implies = name then
	       cpp.put_string("(!(");
	       cpp.put_target_as_value;
	       cpp.put_string("))||(");
	       cpp.put_arguments;
	       cpp.put_character(')');
	    else
	       check
		  rf8.arg_count = 1;
	       end;
	       cpp.put_character('(');
	       cpp.put_target_as_value;
	       if us_or_else = name then
		  cpp.put_string(")||(");
	       else
		  check 
		     us_and_then = name;
		  end;
		  cpp.put_string(")&&(");
	       end;
	       cpp.put_arguments;
	       cpp.put_character(')');
	    end;
	 elseif us_character = bcn then
	    if us_code = name then
	       cpp.put_string("((unsigned char)");
	       cpp.put_target_as_value;
	       cpp.put_character(')');
	    else
	       check
		  us_to_bit = name or else us_to_integer = name
	       end;
	       cpp.put_target_as_value;
	    end;
	 elseif us_pointer = bcn then
	    check
	       us_is_not_void = name
	    end;
	    cpp.put_string("(NULL!=");
	    cpp.put_target_as_value;
	    cpp.put_character(')');
         elseif us_platform = bcn then
	    cbd := cpp.target_cannot_be_dropped;
	    if cbd then
	       cpp.put_character(',');
	    else 
	       cpp.put_character(' ');
	    end;
	    if us_character_bits = name then
	       cpp.put_string("CHAR_BIT");
	    elseif us_integer_bits = name or else
	           us_boolean_bits = name
	     then
	       cpp.put_string("(CHAR_BIT*sizeof(int))");
	    elseif us_real_bits = name then
	       cpp.put_string("(CHAR_BIT*sizeof(float))");
	    elseif us_double_bits = name then
	       cpp.put_string("(CHAR_BIT*sizeof(double))");
	    elseif us_pointer_bits = name then
	       cpp.put_string("(CHAR_BIT*sizeof(void*))");
	    elseif us_minimum_character_code = name then
	       cpp.put_string("CHAR_MIN");
	    elseif us_minimum_double = name then
	       cpp.put_string("DBL_MIN");
	    elseif us_minimum_integer = name then
	       cpp.put_string("INT_MIN");
	    elseif us_minimum_real = name then
	       cpp.put_string("FLT_MIN");
	    elseif us_maximum_character_code = name then
	       cpp.put_string("CHAR_MAX");
	    elseif us_maximum_double = name then
	       cpp.put_string("DBL_MAX");
	    elseif us_maximum_integer = name then
	       cpp.put_string("INT_MAX");
	    elseif us_maximum_real = name then
	       cpp.put_string("FLT_MAX");
	    end;
	    if cbd then
	       cpp.put_character(')');
	    else
	       cpp.put_character(' ');
	    end;
         elseif us_eof_code = name then
	    cbd := cpp.cannot_drop_all;
	    if cbd then
	       cpp.put_character(',');
	    end;
--***	    cpp.put_string("((unsigned char)EOF)");
	    cpp.put_string("(EOF)");
	    if cbd then
	       cpp.put_character(')');
	    end;
	 elseif us_feof = name then
	    cpp.put_string("feof((FILE*)(");
	    cpp.put_ith_argument(1);
	    cpp.put_string(fz_13);
         elseif us_sfr_open = name then
	    cpp.put_string(fz_open);
	    cpp.put_character('(');
	    cpp.put_ith_argument(2);
	    cpp.put_string(",%"r%")");
         elseif us_sfw_open = name then
	    cpp.put_string(fz_open);
	    cpp.put_character('(');
	    cpp.put_ith_argument(2);
	    cpp.put_string(",%"w%")");
         elseif us_se_string2double = name then
	    cpp.put_string("(sscanf(_p,%"%%lf%",&R),R)");
	 elseif us_bit_n = bcn then
	    c_mapping_bit_function(rf8,name);
         elseif us_bitn = name then
            cpp.put_character('(');
            cpp.put_target_as_value;
            cpp.put_string(")->bit_n");
	 elseif us_pointer_size = name then
	    cpp.put_string(fz_sizeof);
	    cpp.put_character('(');
	    cpp.put_string(fz_t0_star);
	    cpp.put_character(')');
	 elseif us_read_byte = name then
	    cpp.put_string("getc((FILE*)(");
	    cpp.put_ith_argument(1);
            cpp.put_string(fz_13);
	 end;
      end;

   jvm_add_method_for_function(rf8: RUN_FEATURE_8; bcn, name: STRING) is
      local
	 ct: TYPE;
	 rc: RUN_CLASS;
	 rf: RUN_FEATURE;
	 rf7: RUN_FEATURE_7;
      do
	 if us_general = bcn then
	    if us_twin = name then
	       ct := rf8.current_type;
	       rc := ct.run_class;
	       rf := rc.get_copy;
	       rf7 ?= rf;
	       if rf7 /= Void then
	       else
		  jvm.add_method(rf8);
	       end;
	    elseif us_generating_type = name then
	       jvm.add_method(rf8);
	    elseif us_generator = name then
	       jvm.add_method(rf8);
	    end;
	 elseif us_sfw_open = name then
	    jvm.add_method(rf8);
	 elseif us_sfr_open = name then
	    jvm.add_method(rf8);
	 elseif us_se_string2double = name then
	    jvm.add_method(rf8);
	 end;
      end;

   jvm_define_function(rf8: RUN_FEATURE_8; bcn, name: STRING) is
      local
	 ct: TYPE;
	 rc: RUN_CLASS;
	 rf: RUN_FEATURE;
	 rf7: RUN_FEATURE_7;
	 rc_idx, field_idx, point1: INTEGER;
	 cp: like constant_pool;
	 ca: like code_attribute;
      do
	 cp := constant_pool;
	 ca := code_attribute;
	 if us_general = bcn then
	    if us_twin = name then
	       ct := rf8.current_type;
	       rc := ct.run_class;
	       rf := rc.get_copy;
	       rf7 ?= rf;
	       if rf7 /= Void then
	       else
		  jvm_define_twin(rf8,rc,rf);
	       end;
	    elseif us_generating_type = name then
	       rf8.jvm_opening;
	       ct := rf8.current_type;
	       rc := ct.run_class;
	       rc_idx := rc.fully_qualified_constant_pool_index;
	       field_idx := cp.idx_fieldref_generating_type(rc_idx);
	       ca.opcode_getstatic(field_idx,1);
	       ca.opcode_dup;
	       point1 := ca.opcode_ifnonnull;
	       ca.opcode_pop;
	       ca.opcode_push_manifest_string(ct.run_time_mark);
	       ca.opcode_dup;
	       ca.opcode_putstatic(field_idx,-1);
	       ca.resolve_u2_branch(point1);
	       rf8.jvm_closing_fast;
	    elseif us_generator = name then
	       rf8.jvm_opening;
	       ct := rf8.current_type;
	       rc := ct.run_class;
	       rc_idx := rc.fully_qualified_constant_pool_index;
	       field_idx := cp.idx_fieldref_generator(rc_idx);
	       ca.opcode_getstatic(field_idx,1);
	       ca.opcode_dup;
	       point1 := ca.opcode_ifnonnull;
	       ca.opcode_pop;
	       ca.opcode_push_manifest_string(ct.base_class_name.to_string);
	       ca.opcode_dup;
	       ca.opcode_putstatic(field_idx,-1);
	       ca.resolve_u2_branch(point1);
	       rf8.jvm_closing_fast;
	    end;
	 elseif us_sfw_open = name then
	    jvm_sfw_open(rf8);
	 elseif us_sfr_open = name then
	    jvm_sfr_open(rf8);
	 elseif us_se_string2double = name then
	    jvm_se_string2double(rf8);
	 end;
      end;

   jvm_mapping_function(rf8: RUN_FEATURE_8; bcn, name: STRING) is
      local
	 ct: TYPE;
	 rc: RUN_CLASS;
	 rf: RUN_FEATURE;
	 rf7: RUN_FEATURE_7;
	 point1, point2, space, idx: INTEGER;
	 cp: like constant_pool;
	 ca: like code_attribute;
      do
	 ca := code_attribute;
	 cp := constant_pool;
	 if us_to_pointer = name then
	    jvm.push_target;
	 elseif us_stdin = name then
	    ca.opcode_system_in;
         elseif us_stdout = name then
	    ca.opcode_system_out;
         elseif us_stderr = name then
	    ca.opcode_system_err;
	 elseif us_integer = bcn then
	    jvm_mapping_integer_function(rf8,name);
	 elseif us_real = bcn then
	    jvm_mapping_real_function(rf8,name);
	 elseif us_double = bcn then
	    jvm_mapping_double_function(rf8,name);
	 elseif us_native_array = bcn then
	    jvm_mapping_native_array_function(rf8,name);
	 elseif us_character = bcn then
	    if us_code = name then
	       jvm.push_target;
	       ca.opcode_dup;
	       point1 := ca.opcode_ifge;
	       ca.opcode_sipush(255);
	       ca.opcode_iand;
	       ca.resolve_u2_branch(point1);
	    elseif us_to_integer = name then
	       jvm.push_target;
	    else
	       check
		  us_to_bit = name
	       end;
	       jvm_int_to_bit(rf8.result_type,8);
	    end;
	 elseif us_is_not_void = name then
	    jvm.push_target;
	    point1 := ca.opcode_ifnonnull;
	    ca.opcode_iconst_0;
	    point2 := ca.opcode_goto;
	    ca.resolve_u2_branch(point1);
	    ca.opcode_iconst_1;
	    ca.resolve_u2_branch(point2);
	 elseif us_implies = name then
	    jvm.push_target;
	    point1 := ca.opcode_ifeq;
	    space := jvm.push_ith_argument(1);
	    point2 := ca.opcode_goto;
	    ca.resolve_u2_branch(point1);
	    ca.opcode_iconst_1;
	    ca.resolve_u2_branch(point2);
	 elseif us_general = bcn then
	    if us_generating_type = name then
	       rf8.routine_mapping_jvm;
	    elseif us_generator = name then
	       rf8.routine_mapping_jvm;
	    elseif us_to_pointer = name then
	       fe_nyi(rf8);
	    elseif us_object_size = name then
	       jvm.drop_target;
	       ct := rf8.current_type;
	       jvm_object_size(ct);
	    elseif us_is_equal = name or else 
	       us_standard_is_equal = name 
	     then
	       jvm_standard_is_equal(rf8.current_type);
	    elseif us_standard_twin = name then
	       jvm_standard_twin(rf8.current_type);
	    elseif us_twin = name then
	       ct := rf8.current_type;
	       rc := ct.run_class;
	       rf := rc.get_copy;
	       rf7 ?= rf;
	       if rf7 /= Void then
		  jvm_standard_twin(ct);
	       else
		  rf8.routine_mapping_jvm;
	       end;
	    elseif us_is_basic_expanded_type = name then
	       jvm.drop_target;
	       if rf8.current_type.is_basic_eiffel_expanded then
		  ca.opcode_iconst_1;
	       else
		  ca.opcode_iconst_0;
	       end;
	    elseif us_is_expanded_type = name then
	       jvm.drop_target;
	       if rf8.current_type.is_expanded then
		  ca.opcode_iconst_1;
	       else
		  ca.opcode_iconst_0;
	       end;
	    elseif us_se_argc = name then
	       jvm.push_se_argc;
	    elseif us_se_argv = name then
	       jvm.push_se_argv;
	    elseif us_se_getenv = name then
	       jvm_se_getenv;
	    else
	       fe_nyi(rf8);
	    end;
         elseif us_platform = bcn then
	    jvm.drop_target;
	    if us_character_bits = name then
	       ca.opcode_bipush(8);
	    elseif us_integer_bits = name then
	       ca.opcode_bipush(32);
	    elseif us_boolean_bits = name then
	       ca.opcode_bipush(32);
	    elseif us_real_bits = name then
	       ca.opcode_bipush(32);
	    elseif us_double_bits = name then
	       ca.opcode_bipush(64);
	    elseif us_pointer_bits = name then
	       ca.opcode_bipush(32);
	    elseif us_minimum_character_code = name then
	       ca.opcode_bipush(0);
	    elseif us_minimum_double = name then
	       idx := cp.idx_fieldref3(fz_62,fz_98,fz_77);
	       ca.opcode_getstatic(idx,2);
	    elseif us_minimum_integer = name then
	       ca.opcode_iconst_m1;
	       ca.opcode_iconst_1;
	       ca.opcode_iushr;
	       ca.opcode_ineg;
	       ca.opcode_iconst_m1;
	       ca.opcode_iadd;
	    elseif us_minimum_real = name then
	       idx := cp.idx_fieldref3(fz_26,fz_98,fz_78);
	       ca.opcode_getstatic(idx,1);
	    elseif us_maximum_character_code = name then
	       ca.opcode_sipush(255);
	    elseif us_maximum_double = name then
	       idx := cp.idx_fieldref3(fz_62,fz_95,fz_77);
	       ca.opcode_getstatic(idx,2);
	    elseif us_maximum_integer = name then
	       ca.opcode_iconst_m1;
	       ca.opcode_iconst_1;
	       ca.opcode_iushr;
	    elseif us_maximum_real = name then
	       idx := cp.idx_fieldref3(fz_26,fz_95,fz_78);
	       ca.opcode_getstatic(idx,1);
	    end;
         elseif us_eof_code = name then
	    ca.opcode_iconst_m1;
         elseif us_sfr_open = name then
	    rf8.routine_mapping_jvm;
         elseif us_sfw_open = name then
	    rf8.routine_mapping_jvm;
         elseif us_se_string2double = name then
	    rf8.routine_mapping_jvm;
	 elseif us_pointer_size = name then
	    ca.opcode_bipush(32);
	 elseif us_bit_n = bcn then
	    jvm_mapping_bit_function(rf8,name);
         elseif us_bitn = name then
	    jvm.push_target;
	    ct := rf8.current_type;
	    rc := ct.run_class;
	    idx := rc.fully_qualified_constant_pool_index;
	    idx := cp.idx_fieldref4(idx,us_bitn,fz_a9);
	    ca.opcode_getfield(idx,0);
         elseif us_read_byte = name then
	    space := jvm.push_ith_argument(1);
	    idx := cp.idx_methodref3(fz_69,fz_70,fz_71);
	    ca.opcode_invokevirtual(idx,0);
	 else
	    fe_nyi(rf8);
	 end;
      end;

   jvm_add_method_for_procedure(rf7: RUN_FEATURE_7; bcn, name: STRING) is
      do
	 if us_sprintf_double = name then
	    jvm.add_method(rf7);
	 elseif us_se_rename = name then
	    jvm.add_method(rf7);
	 elseif us_se_remove = name then
	    jvm.add_method(rf7);
	 end;
      end;

   jvm_define_procedure(rf7: RUN_FEATURE_7; bcn, name: STRING) is
      do
	 if us_sprintf_double = name then
	    jvm_define_sprintf_double(rf7);
	 elseif us_se_rename = name then
	    jvm_define_se_rename(rf7);
	 elseif us_se_remove = name then
	    jvm_define_se_remove(rf7);
	 end;
      end;

   jvm_mapping_procedure(rf7: RUN_FEATURE_7; bcn, name: STRING) is
      local
	 space, idx: INTEGER;
	 t: TYPE;
	 ca: like code_attribute;
      do
	 ca := code_attribute;
	 if us_copy = name or else us_standard_copy = name then
	    t := rf7.current_type;
	    if t.is_basic_eiffel_expanded then
	       jvm.drop_target;
	       jvm.drop_ith_argument(1);
	    else
	       jvm_copy(rf7.current_type);
	    end;
	 elseif us_flush_stream = name then
	    jvm.drop_target;
	    space := jvm.push_ith_argument(1);
	    idx := constant_pool.idx_methodref3(fz_25,"flush",fz_29);
	    ca.opcode_invokevirtual(idx,-1);
	 elseif us_write_byte = name then
	    space := jvm.push_ith_argument(1);
	    space := jvm.push_ith_argument(2);
	    idx := constant_pool.idx_methodref3(fz_25,"write",fz_27);
	    ca.opcode_invokevirtual(idx,-2);
	 elseif us_die_with_code = name then
	    jvm.drop_target;
	    space := jvm.push_ith_argument(1);
	    ca.opcode_system_exit;
	 elseif us_free = name then
	    jvm.drop_target;
	 elseif us_print_run_time_stack = name then
	    jvm.drop_target;
	    ca.opcode_runtime_trace_instructions(true);
	 elseif us_native_array = bcn then
	    jvm_mapping_native_array_procedure(rf7,name);
	 elseif us_sprintf_pointer = name then
	    -- *** A FAIRE ***
	    jvm.drop_target;
	    space := jvm.push_ith_argument(1);
	    ca.opcode_dup;
	    ca.opcode_iconst_0;
	    ca.opcode_bipush(('1').code);
	    ca.opcode_bastore;
	    ca.opcode_iconst_1;
	    ca.opcode_bipush(('0').code);
	    ca.opcode_bastore;
	 elseif us_sprintf_double = name then
	    rf7.routine_mapping_jvm;
	 elseif us_se_rename = name then
	    rf7.routine_mapping_jvm;
	 elseif us_se_remove = name then
	    rf7.routine_mapping_jvm;
	 elseif us_se_system = name then
	    jvm_se_system;
	 elseif us_bit_n = bcn then
	    jvm_mapping_bit_procedure(rf7,name);
	 else
	    fe_nyi(rf7);
	 end;
      end;

feature

   use_current(er: EXTERNAL_ROUTINE): BOOLEAN is
      local
	 n: STRING;
      do
	 n := er.first_name.to_string;
	 if us_se_argc = n then
	 elseif us_read_byte = n then
	 elseif us_se_argv = n then
	 elseif us_se_rename = n then
	 elseif us_se_remove = n then
	 elseif us_se_system = n then
	 elseif us_write_byte = n then
	 else
	    Result := true;
	 end;
      end;

feature {NONE}

   jvm_se_string2double(rf8: RUN_FEATURE_8) is 
      local
	 idx: INTEGER;
	 cp: like constant_pool;
	 ca: like code_attribute;
      do
	 cp := constant_pool;
	 ca := code_attribute;
	 rf8.jvm_opening;
	 -- New Java String :
	 idx := cp.idx_class2(fz_32);
	 ca.opcode_new(idx);
	 ca.opcode_dup;
	 ca.opcode_aload_2;
	 ca.opcode_iconst_0;
	 ca.opcode_aload_1;
	 idx := cp.idx_methodref3(fz_32,fz_35,fz_65);
	 ca.opcode_invokespecial(idx,-4);
	 -- Double.valueOf0(String) :
	 idx := cp.idx_methodref3(fz_62,fz_60,fz_61);
	 ca.opcode_invokestatic(idx,1);
	 ca.opcode_dstore(3);
	 rf8.jvm_closing;
      end;

   jvm_se_system is
      local
	 space, idx: INTEGER;
	 cp: like constant_pool;
	 ca: like code_attribute;
      do
	 cp := constant_pool;
	 ca := code_attribute;
	 -- Runtime.getRuntime() :
	 idx := cp.idx_methodref3(fz_53,fz_55,fz_56);
	 ca.opcode_invokestatic(idx,1);
	 -- New Java String :
	 idx := cp.idx_class2(fz_32);
	 ca.opcode_new(idx);
	 ca.opcode_dup;
	 space := jvm.push_ith_argument(2);
	 ca.opcode_iconst_0;
	 space := jvm.push_ith_argument(1);
	 idx := cp.idx_methodref3(fz_32,fz_35,fz_65);
	 ca.opcode_invokespecial(idx,-4);
	 -- aProcess.exec(String);
	 idx := cp.idx_methodref3(fz_53,fz_89,fz_90);
	 ca.opcode_invokevirtual(idx,-1);
	 -- aProcess.waitFor();
	 idx := cp.idx_methodref3(fz_92,fz_91,fz_71);
	 ca.opcode_invokevirtual(idx,0);
	 ca.opcode_pop;
      end;

   jvm_sfr_open(rf8: RUN_FEATURE_8) is 
      local
	 point, idx: INTEGER;
	 cp: like constant_pool;
	 ca: like code_attribute;
      do
	 cp := constant_pool;
	 ca := code_attribute;
	 rf8.jvm_opening;
	 -- New Java String :
	 idx := cp.idx_class2(fz_32);
	 ca.opcode_new(idx);
	 ca.opcode_dup;
	 ca.opcode_aload_2;
	 ca.opcode_iconst_0;
	 ca.opcode_aload_1;
	 idx := cp.idx_methodref3(fz_32,fz_35,fz_65);
	 ca.opcode_invokespecial(idx,-4);
	 ca.opcode_astore_3;
	 -- New java/io/File :
	 idx := cp.idx_class2(fz_85);
	 ca.opcode_new(idx);
	 ca.opcode_dup;
	 ca.opcode_aload_3;
	 idx := cp.idx_methodref3(fz_85,fz_35,fz_57);
	 ca.opcode_invokespecial(idx,0);
	 ca.opcode_astore_3;
	 -- if exists :
	 ca.opcode_aload_3;
	 idx := cp.idx_methodref3(fz_85,fz_86,fz_87);
	 ca.opcode_invokevirtual(idx,0);
	 point := ca.opcode_ifeq;
	 -- New java/io/FileInputstream :
	 idx := cp.idx_class2(fz_67);
	 ca.opcode_new(idx);
	 ca.opcode_dup;
	 ca.opcode_aload_3;
	 idx := cp.idx_methodref3(fz_67,fz_35,fz_88);
	 ca.opcode_invokespecial(idx,-2);
	 ca.opcode_areturn;
	 ca.resolve_u2_branch(point);
	 ca.opcode_aconst_null;
	 ca.opcode_astore_3;
	 rf8.jvm_closing;
      end;

   jvm_sfw_open(rf8: RUN_FEATURE_8) is 
      local
	 idx: INTEGER;
	 cp: like constant_pool;
	 ca: like code_attribute;
      do
	 cp := constant_pool;
	 ca := code_attribute;
	 rf8.jvm_opening;
	 -- New java/lang/String :
	 idx := cp.idx_class2(fz_32);
	 ca.opcode_new(idx);
	 ca.opcode_dup;
	 ca.opcode_aload_2;
	 ca.opcode_iconst_0;
	 ca.opcode_aload_1;
	 idx := cp.idx_methodref3(fz_32,fz_35,fz_65);
	 ca.opcode_invokespecial(idx,-4);
	 ca.opcode_astore_3;
	 -- New java/io/File :
	 idx := cp.idx_class2(fz_85);
	 ca.opcode_new(idx);
	 ca.opcode_dup;
	 ca.opcode_aload_3;
	 idx := cp.idx_methodref3(fz_85,fz_35,fz_57);
	 ca.opcode_invokespecial(idx,0);
	 ca.opcode_astore_3;
	 -- New java/io/FileOutputStream :
	 idx := cp.idx_class2(fz_72);
	 ca.opcode_new(idx);
	 ca.opcode_dup;
	 ca.opcode_aload_3;
	 idx := cp.idx_methodref3(fz_72,fz_35,fz_88);
	 ca.opcode_invokespecial(idx,-2);
	 ca.opcode_astore_3;
	 rf8.jvm_closing;
      end;


   new_jvm_open(rf8: RUN_FEATURE_8; jio: STRING) is 
	 -- Where `jio' is a Java class name.
      local
	 pc1, pc2, pc3: INTEGER;
	 idx: INTEGER;
	 cp: like constant_pool;
	 ca: like code_attribute;
      do
	 cp := constant_pool;
	 ca := code_attribute;
	 rf8.jvm_opening;
	 -- New java/lang/String :
	 idx := cp.idx_class2(fz_32);
	 ca.opcode_new(idx);
	 ca.opcode_dup;
	 ca.opcode_aload_2;
	 ca.opcode_iconst_0;
	 ca.opcode_aload_1;
	 idx := cp.idx_methodref3(fz_32,fz_35,fz_65);
	 ca.opcode_invokespecial(idx,-4);
	 ca.opcode_astore_3;
	 -- New Input/Output Java :
	 pc1 := ca.program_counter;
	 idx := cp.idx_class2(fz_67);
	 ca.opcode_new(idx);
	 ca.opcode_dup;
	 ca.opcode_aload_3;
	 idx := cp.idx_methodref3(jio,fz_35,fz_68);
	 ca.opcode_invokespecial(idx,-2);
	 ca.opcode_areturn;
	 pc2 := ca.program_counter;
	 pc3 := ca.program_counter;
	 ca.opcode_pop;
	 ca.opcode_aconst_null;
	 ca.opcode_astore_3;
	 idx := cp.idx_class2(fz_84);

--***
	 pc1 := ca.program_counter;
	 ca.opcode_nop;
	 ca.opcode_nop;
	 
	 pc2 := ca.program_counter;
	 ca.opcode_nop;
	 ca.opcode_nop;
	 
	 pc3 := ca.program_counter;
	 ca.opcode_nop;
	 ca.opcode_nop;
	 

	 ca.add_exception(pc1,pc2,pc3,idx);
	 rf8.jvm_closing;
      end;

   new_small_jvm_open(rf8: RUN_FEATURE_8; jio: STRING) is 
	 -- Where `jio' is a Java class name.
      local
	 pc1, pc2, pc3: INTEGER;
	 idx: INTEGER;
	 cp: like constant_pool;
	 ca: like code_attribute;
      do
	 cp := constant_pool;
	 ca := code_attribute;
	 rf8.jvm_opening;

	 pc1 := ca.program_counter;
	 ca.opcode_nop;
	 ca.opcode_nop;
	 
	 pc2 := ca.program_counter;
	 idx := ca.opcode_goto;
	 ca.opcode_nop;
	 
	 pc3 := ca.program_counter;
	 ca.opcode_pop;
	 ca.opcode_nop;
	 

	 ca.add_exception(pc1,pc2,pc3,cp.idx_class2(fz_84));
	 
	 ca.resolve_u2_branch(idx);
	 rf8.jvm_closing;
      end;

   jvm_se_getenv is
      local
	 space, point1, idx: INTEGER;
	 cp: like constant_pool;
	 ca: like code_attribute;
      do
	 cp := constant_pool;
	 ca := code_attribute;
	 -- Create a Java string from arguments :
	 idx := cp.idx_class2(fz_32);
	 ca.opcode_new(idx);
	 ca.opcode_dup;
	 space := jvm.push_ith_argument(2);
	 ca.opcode_iconst_0;
	 space := jvm.push_ith_argument(1);
	 idx := cp.idx_methodref3(fz_32,fz_35,fz_65);
	 ca.opcode_invokespecial(idx,-2);
	 -- Call java/lang/System getProperty :
	 idx := cp.idx_methodref3(fz_36,fz_79,fz_80);
	 ca.opcode_invokestatic(idx,0);
	 -- Create corresponding Eiffel STRING :
	 ca.opcode_dup;
	 point1 := ca.opcode_ifeq;
	 ca.opcode_java_string2eiffel_string;
	 ca.resolve_u2_branch(point1);
      end;

   jvm_object_size(ct: TYPE) is
      local
	 t: TYPE;
	 space, i: INTEGER;
	 wa: ARRAY[RUN_FEATURE_2];
      do
	 if ct.is_basic_eiffel_expanded then
	    space := ct.jvm_stack_space;
	 else
	    wa := ct.run_class.writable_attributes;
	    if wa /= Void then
	       from
		  i := wa.upper;
	       until
		  i = 0
	       loop
		  t := wa.item(i).result_type;
		  space := space + t.jvm_stack_space;
		  i := i - 1;
	       end;
	    end;
	 end;
	 code_attribute.opcode_push_integer(space);
      end;

   c_mapping_standard_twin(rf8: RUN_FEATURE_8; ct: TYPE) is
      do
	 if ct.is_basic_eiffel_expanded then
	    cpp.put_target_as_value;
	 elseif ct.is_expanded then
	    if ct.is_dummy_expanded then
	       cpp.put_target_as_target;
	    elseif native_array(ct) then
	       cpp.put_target_as_target;
	    else
	       rf8.default_mapping_function;
	    end;
	 else
	    rf8.default_mapping_function;
	 end;
      end;

   c_define_standard_twin(rf8: RUN_FEATURE_8; ct: TYPE) is
      do
	 if ct.is_basic_eiffel_expanded then
	 elseif ct.is_expanded then
	    if ct.is_dummy_expanded then
	    elseif native_array(ct) then
	    else
	       rf8.c_define_with_body("memcpy(&R,C,sizeof(R));");
	    end;
	 else
	    if gc_handler.is_on then
	       body.clear;
	       body.extend('R');
	       body.extend('=');
	       body.extend('(');
	       body.append(fz_cast_void_star);
	       ct.gc_call_new_in(body);
	       body.extend(')');
	       body.append(fz_00);
	    else
	       body.copy("R=malloc(sizeof(*C));%N");
	    end;
	    body.extend('*');
	    body.extend('(');
	    body.extend('(');
	    body.extend('T');
	    ct.id.append_in(body);
	    body.extend('*');
	    body.extend(')');
	    body.extend('R');
	    body.extend(')');
	    body.extend('=');
	    body.extend('*');
	    body.extend('C');
	    body.append(fz_00);
	    rf8.c_define_with_body(body);
	 end;
      end;

   c_define_twin(rf8: RUN_FEATURE_8; ct: TYPE; rc: RUN_CLASS;  
		 cpy: RUN_FEATURE) is
      require
	 rf8 /= Void;
	 ct.is_reference or ct.is_user_expanded;
	 rc = ct.run_class;
	 cpy /= Void
      local
	 id: INTEGER;
      do
	 rf8.c_opening;
	 if ct.is_reference then
	    if gc_handler.is_on then
	       body.clear;
	       body.extend('R');
	       body.extend('=');
	       body.extend('(');
	       body.append(fz_cast_void_star);
	       ct.gc_call_new_in(body);
	       body.extend(')');
	       body.append(fz_00);
	       cpp.put_string(body);
	    else
	       id := rc.id;
	       cpp.put_string("R=malloc(sizeof(*C));%N");
	       cpp.put_string("*((T");
	       cpp.put_integer(id);
	       cpp.put_string("*)R)=M");
	       cpp.put_integer(id);
	       cpp.put_string(fz_00);
	    end;
	 end;
	 cpp.inside_twin(cpy);
	 rf8.c_closing;
      end;

   jvm_mapping_native_array_function(rf8: RUN_FEATURE_8; name: STRING) is
      local
	 elt_type: TYPE;
	 space: INTEGER;
	 rc: RUN_CLASS;
	 loc1, point1, point2: INTEGER;
	 ca: like code_attribute;
      do
	 elt_type := rf8.current_type.generic_list.item(1).run_type;
	 if us_element_sizeof = name then
	    jvm.drop_target;
	    space := elt_type.jvm_stack_space;
	    code_attribute.opcode_push_integer(space);
	 elseif us_item = name then
	    jvm.push_target;
	    space := jvm.push_ith_argument(1);
	    elt_type.jvm_xaload;
	 elseif us_calloc = name then
	    jvm.drop_target;
	    space := jvm.push_ith_argument(1);
	    elt_type.jvm_xnewarray;
	    if elt_type.is_user_expanded and then
	       not elt_type.is_dummy_expanded 
	     then
	       ca := code_attribute;
	       rc := elt_type.run_class;
	       loc1 := ca.extra_local_size1;
	       ca.opcode_dup;
	       ca.opcode_arraylength;
	       ca.opcode_istore(loc1);
	       point1 := ca.program_counter;
	       ca.opcode_iload(loc1);
	       point2 := ca.opcode_ifle;
	       ca.opcode_iinc(loc1,255);
	       ca.opcode_dup;
	       ca.opcode_iload(loc1);
	       rc.jvm_expanded_push_default;
	       ca.opcode_aastore;
	       ca.opcode_goto_backward(point1);
	       ca.resolve_u2_branch(point2);
	    end;
	 elseif name = us_from_pointer then
	    jvm.drop_target;
	    space := jvm.push_ith_argument(1);
	 else
	    fe_nyi(rf8);
	 end;
      end;

   jvm_mapping_native_array_procedure(rf7: RUN_FEATURE_7; name: STRING) is
      local
	 elt_type: TYPE;
	 space: INTEGER;
      do
	 elt_type := rf7.current_type.generic_list.item(1).run_type;
	 if us_put = name then
	    jvm.push_target;
	    space := jvm.push_ith_argument(2);
	    space := jvm.push_ith_argument(1);
	    elt_type.jvm_xastore;
	 else
	    check
	       us_free = name
	    end;
	    jvm.drop_target;
	 end;
      end;

   c_mapping_native_array_function(rf8: RUN_FEATURE_8; name: STRING) is
      local
	 elt_type: TYPE;
	 tcbd: BOOLEAN;
	 rf: RUN_FEATURE;
      do
	 elt_type := rf8.current_type.generic_list.item(1).run_type;
	 if us_element_sizeof = name then
	    tcbd := cpp.target_cannot_be_dropped;
	    if tcbd then
	       cpp.put_character(',');
	    end;
	    tmp_string.copy(fz_sizeof);
	    tmp_string.extend('(');
	    elt_type.c_type_for_argument_in(tmp_string);
	    tmp_string.extend(')');
	    cpp.put_string(tmp_string);
	    if tcbd then
	       cpp.put_character(')');
	    end;
	 elseif name = us_calloc then
	    if elt_type.expanded_initializer = Void then
	       tcbd := cpp.target_cannot_be_dropped;
	       if tcbd then
		  cpp.put_character(',');
	       end;
	       if gc_handler.is_on then
		  cpp.put_string(fz_new);
		  cpp.put_integer(rf8.current_type.id);
		  cpp.put_character('(');
		  cpp.put_ith_argument(1);
		  cpp.put_character(')');
	       else
		  cpp.put_string(us_calloc);
		  cpp.put_character('(');
		  cpp.put_ith_argument(1);
		  tmp_string.clear;
		  tmp_string.extend(',');
		  tmp_string.append(fz_sizeof);
		  tmp_string.extend('(');
		  elt_type.c_type_for_result_in(tmp_string);
		  tmp_string.append(fz_13);
		  cpp.put_string(tmp_string);
	       end;
	       if tcbd then
		  cpp.put_character(')');
	       end;
	    else
	       rf8.default_mapping_function;
	    end;
	 elseif name = us_from_pointer then
	    tcbd := cpp.target_cannot_be_dropped;
	    if tcbd then
	       cpp.put_character(',');
	    end;
	    cpp.put_ith_argument(1);
	    if tcbd then
	       cpp.put_character(')');
	    end;
	 else
	    check 
	       us_item = name
	    end;
	    cpp.put_character('(');
	    cpp.put_target_as_value;
	    cpp.put_string(")[");
	    cpp.put_ith_argument(1);
	    cpp.put_character(']');
	 end;
      end;

   c_mapping_native_array_procedure(rf7: RUN_FEATURE_7; name: STRING) is
      local
	 elt_type: TYPE;
      do
	 elt_type := rf7.current_type.generic_list.item(1).run_type;
	 if name = us_put then
	    if elt_type.is_user_expanded then
	       if elt_type.is_dummy_expanded then
		  if cpp.cannot_drop_all then
		     cpp.put_string(fz_14);
		  end;
	       else
		  cpp.put_string("memcpy((");
		  cpp.put_target_as_value;
		  cpp.put_string(")+(");
		  cpp.put_ith_argument(2);
		  cpp.put_string("),");
		  cpp.put_ith_argument(1);
		  cpp.put_string(",sizeof(T");
		  cpp.put_integer(elt_type.id);
		  cpp.put_string(fz_16);
	       end;
	    else
	       cpp.put_character('(');
	       cpp.put_target_as_value;
	       cpp.put_string(")[");
	       cpp.put_ith_argument(2);
	       cpp.put_string("]=(");
	       cpp.put_ith_argument(1);
	       cpp.put_string(fz_14);
	    end;
	 elseif name = us_free then
	    cpp.put_string(us_free);
	    cpp.put_character('(');
	    cpp.put_target_as_value;
	    cpp.put_string(fz_14);
	 end;
      end;

   jvm_copy(t: TYPE) is
      require
	 not t.is_basic_eiffel_expanded
      local
	 rc: RUN_CLASS;
	 wa: ARRAY[RUN_FEATURE_2];
	 rf2: RUN_FEATURE_2;
	 idx, space, i: INTEGER;
      do
	 rc := t.run_class;
	 wa := rc.writable_attributes;
	 if wa = Void then
	    jvm.drop_target;
	    jvm.drop_ith_argument(1);
	 else
	    from
	       jvm.push_target;
	       space := jvm.push_ith_argument(1);
	       i := wa.upper;
	    until
	       i = 0
	    loop
	       if i > 1 then
		  code_attribute.opcode_dup2;
	       end;
	       rf2 := wa.item(i);
	       idx := constant_pool.idx_fieldref(rf2);
	       space := rf2.result_type.jvm_stack_space;
	       code_attribute.opcode_getfield(idx,space - 1);
	       code_attribute.opcode_putfield(idx,-(space + 1));
	       i := i - 1;
	    end;
	 end;
      end;

   jvm_define_sprintf_double(rf7: RUN_FEATURE_7) is
      require
	 rf7 /= Void
      local
	 idx, loc1, loc2: INTEGER;
	 point1, point2, point3: INTEGER;
	 cp: like constant_pool;
	 ca: like code_attribute;
      do
	 cp := constant_pool;
	 ca := code_attribute;
	 rf7.jvm_opening;
	 -- Double.toString(double) :
	 ca.opcode_dload_0;
	 idx := cp.idx_methodref3(fz_62,fz_63,fz_64);
	 ca.opcode_invokestatic(idx,1);
	 ca.opcode_java_string2bytes_array;
	 -- loc1 is for the byte array :
	 loc1 := ca.extra_local_size1;
	 ca.opcode_astore(loc1);
	 -- Copy of the integral part :
	 loc2 := ca.extra_local_size1;
	 ca.opcode_iconst_0;
	 ca.opcode_istore(loc2);
	 point1 := ca.program_counter;
	 ca.opcode_aload(loc1);
	 ca.opcode_arraylength;
	 ca.opcode_iload(loc2);
	 point2 := ca.opcode_if_icmple;
	 ca.opcode_aload_2;
	 ca.opcode_iload(loc2);
	 ca.opcode_aload(loc1);
	 ca.opcode_iload(loc2);
	 ca.opcode_baload;
	 ca.opcode_bastore;
	 ca.opcode_aload(loc1);
	 ca.opcode_iload(loc2);
	 ca.opcode_baload;
	 ca.opcode_bipush(('.').code);
	 ca.opcode_iinc(loc2,1);
	 point3 := ca.opcode_if_icmpeq;
	 ca.opcode_goto_backward(point1);
	 ca.resolve_u2_branch(point2);
	 ca.resolve_u2_branch(point3);
	 -- Copy of the fractional part :
	 point1 := ca.program_counter;
	 ca.opcode_aload(loc1);
	 ca.opcode_arraylength;
	 ca.opcode_iload(loc2);
	 point2 := ca.opcode_if_icmple;
	 ca.opcode_iload_3;
	 point3 := ca.opcode_ifeq;
	 ca.opcode_aload_2;
	 ca.opcode_iload(loc2);
	 ca.opcode_aload(loc1);
	 ca.opcode_iload(loc2);
	 ca.opcode_baload;
	 ca.opcode_bastore;
	 ca.opcode_iinc(loc2,1);
	 ca.opcode_iinc(3,255);
	 ca.opcode_goto_backward(point1);
	 ca.resolve_u2_branch(point2);
	 ca.resolve_u2_branch(point3);
	 -- Add some more '0' :
	 point1 := ca.program_counter;
	 ca.opcode_iload_3;
	 point2 := ca.opcode_ifeq;
	 ca.opcode_aload_2;
	 ca.opcode_iload(loc2);
	 ca.opcode_bipush(('0').code);
	 ca.opcode_bastore;
	 ca.opcode_iinc(loc2,1);
	 ca.opcode_iinc(3,255)
	 ca.opcode_goto_backward(point1);
	 ca.resolve_u2_branch(point2);
	 -- Adding the extra '%/0' :
	 ca.opcode_aload_2;
	 ca.opcode_iload(loc2);
	 ca.opcode_iconst_0;
	 ca.opcode_bastore;
	 rf7.jvm_closing;
      end;

   jvm_define_se_rename(rf7: RUN_FEATURE_7) is
      require
	 rf7 /= Void
      local
	 idx, loc1, loc2: INTEGER;
	 cp: like constant_pool;
	 ca: like code_attribute;
      do
	 cp := constant_pool;
	 ca := code_attribute;
	 rf7.jvm_opening;
	 -- New Java String :
	 idx := cp.idx_class2(fz_32);
	 ca.opcode_new(idx);
	 ca.opcode_dup;
	 ca.opcode_aload_2;
	 ca.opcode_iconst_0;
	 ca.opcode_aload_1;
	 idx := cp.idx_methodref3(fz_32,fz_35,fz_65);
	 ca.opcode_invokespecial(idx,-4);
	 loc1 := ca.extra_local_size1;
	 ca.opcode_istore(loc1);
	 -- New java/io/File :
	 idx := cp.idx_class2(fz_85);
	 ca.opcode_new(idx);
	 ca.opcode_dup;
	 ca.opcode_aload(loc1);
	 idx := cp.idx_methodref3(fz_85,fz_35,fz_57);
	 ca.opcode_invokespecial(idx,0);	
	 ca.opcode_istore(loc1);
	 -- New Java String :
	 idx := cp.idx_class2(fz_32);
	 ca.opcode_new(idx);
	 ca.opcode_dup;
	 ca.opcode_aload(4);
	 ca.opcode_iconst_0;
	 ca.opcode_aload_3;
	 idx := cp.idx_methodref3(fz_32,fz_35,fz_65);
	 ca.opcode_invokespecial(idx,-4);
	 loc2 := ca.extra_local_size1;
	 ca.opcode_istore(loc2);
	 -- New java/io/File :
	 idx := cp.idx_class2(fz_85);
	 ca.opcode_new(idx);
	 ca.opcode_dup;
	 ca.opcode_aload(loc2);
	 idx := cp.idx_methodref3(fz_85,fz_35,fz_57);
	 ca.opcode_invokespecial(idx,0);	
	 ca.opcode_istore(loc2);
	 -- java/io/File.renameTo :
	 ca.opcode_aload(loc1);
	 ca.opcode_aload(loc2);
	 idx := cp.idx_methodref3(fz_85,fz_b3,fz_b4);
	 ca.opcode_invokevirtual(idx,0);
	 ca.opcode_pop;
	 rf7.jvm_closing;
      end;

   jvm_define_se_remove(rf7: RUN_FEATURE_7) is
      require
	 rf7 /= Void
      local
	 idx, loc1: INTEGER;
	 cp: like constant_pool;
	 ca: like code_attribute;
      do
	 cp := constant_pool;
	 ca := code_attribute;
	 rf7.jvm_opening;
	 -- New Java String :
	 idx := cp.idx_class2(fz_32);
	 ca.opcode_new(idx);
	 ca.opcode_dup;
	 ca.opcode_aload_2;
	 ca.opcode_iconst_0;
	 ca.opcode_aload_1;
	 idx := cp.idx_methodref3(fz_32,fz_35,fz_65);
	 ca.opcode_invokespecial(idx,-4);
	 loc1 := ca.extra_local_size1;
	 ca.opcode_istore(loc1);
	 -- New java/io/File :
	 idx := cp.idx_class2(fz_85);
	 ca.opcode_new(idx);
	 ca.opcode_dup;
	 ca.opcode_aload(loc1);
	 idx := cp.idx_methodref3(fz_85,fz_35,fz_57);
	 ca.opcode_invokespecial(idx,0);
	 -- java/io/File delete :
	 idx := cp.idx_methodref3(fz_85,fz_b2,fz_87);
	 ca.opcode_invokevirtual(idx,0);
	 ca.opcode_pop;
	 rf7.jvm_closing;
      end;

   jvm_define_twin(rf8: RUN_FEATURE_8; rc: RUN_CLASS; cpy: RUN_FEATURE) is
      require
	 rc = rf8.current_type.run_class;
	 cpy /= Void
      local
	 idx, space, i: INTEGER;
	 wa: ARRAY[RUN_FEATURE_2];
	 rf2: RUN_FEATURE_2;
      do
	 rf8.jvm_opening;
	 wa := rc.writable_attributes;
	 idx := rc.fully_qualified_constant_pool_index;
	 code_attribute.opcode_new(idx);
	 code_attribute.opcode_astore_1;
	 if wa /= Void then
	    from
	       i := wa.upper;
	    until
	       i = 0
	    loop
	       rf2 := wa.item(i);
	       code_attribute.opcode_aload_1;
	       idx := constant_pool.idx_fieldref(rf2);
	       space := rf2.result_type.jvm_push_default;
	       code_attribute.opcode_putfield(idx,-(space + 1));
	       i := i - 1;
	    end;
	 end;
	 jvm.inside_twin(cpy);
	 rf8.jvm_closing;
      end;

   jvm_standard_is_equal(t: TYPE) is
      local
	 ca: like code_attribute;
	 rc: RUN_CLASS;
	 wa: ARRAY[RUN_FEATURE_2];
	 point1, point2, space: INTEGER;
      do
	 ca := code_attribute;
	 jvm.push_target;
	 space := jvm.push_ith_argument(1);
	 if t.is_basic_eiffel_expanded or else native_array(t) then
	    point1 := t.jvm_if_x_eq;
	    ca.opcode_iconst_0;
	    point2 := ca.opcode_goto;
	    ca.resolve_u2_branch(point1);
	    ca.opcode_iconst_1;
	    ca.resolve_u2_branch(point2);
	 else
	    rc := t.run_class;
	    wa := rc.writable_attributes;
	    if t.is_expanded then
	       if wa = Void then
		  ca.opcode_pop;
		  ca.opcode_pop;
		  ca.opcode_iconst_1;
	       else
		  jvm_standard_is_equal_aux(rc,wa);
	       end;
	    else
	       jvm_standard_is_equal_aux(rc,wa);
	    end;
	 end;
      end;

   jvm_standard_twin(t: TYPE) is
      require
	 t /= Void
      local
	 rc: RUN_CLASS;
	 wa: ARRAY[RUN_FEATURE_2];
      do
	 if t.is_basic_eiffel_expanded or else native_array(t) then
	    jvm.push_target;
	 else
	    rc := t.run_class;
	    wa := rc.writable_attributes;
	    if t.is_expanded then
	       if wa = Void then
		  jvm.push_target;
	       else
		  jvm_standard_twin_aux(rc,wa);
	       end;
	    else
	       jvm_standard_twin_aux(rc,wa);
	    end;
	 end;
      end;

   jvm_standard_twin_aux(rc: RUN_CLASS; wa: ARRAY[RUN_FEATURE_2]) is
      require
	 rc /= Void
      local
	 ca: like code_attribute;
	 rf2: RUN_FEATURE_2;
	 idx, space, i: INTEGER;
      do
	 ca := code_attribute;
	 idx := rc.fully_qualified_constant_pool_index;
	 ca.opcode_new(idx);
	 if wa = Void then
	    jvm.drop_target;
	 else
	    jvm.push_target;
	    from
	       i := wa.upper;
	    until
	       i = 0
	    loop
	       rf2 := wa.item(i);
	       ca.opcode_dup2;
	       idx := constant_pool.idx_fieldref(rf2);
	       space := rf2.result_type.jvm_stack_space;
	       ca.opcode_getfield(idx,space - 1);
	       ca.opcode_putfield(idx,space + 1);
	       i := i - 1;
	    end;
	    ca.opcode_pop;
	 end;
      end;

   jvm_mapping_integer_function(rf8: RUN_FEATURE_8; name: STRING) is
      local
	 point1, point2, space: INTEGER;
	 ca: like code_attribute;
      do
	 ca := code_attribute;
	 if us_slash = name then
	    jvm.push_target;
	    ca.opcode_i2d;
	    space := jvm.push_ith_argument(1);
	    ca.opcode_i2d;
	    ca.opcode_ddiv;
	 elseif rf8.arg_count = 1 then
	    jvm.push_target;
	    space := jvm.push_ith_argument(1);
	    if us_plus = name then
	       ca.opcode_iadd;
	    elseif us_minus = name then
	       ca.opcode_isub;
	    elseif us_muls = name then
	       ca.opcode_imul;
	    elseif us_slash_slash = name then
	       ca.opcode_idiv;
	    elseif us_backslash_backslash = name then
	       ca.opcode_irem;
	    else -- < > <= >= only
	       if us_gt = name then
		  point1 := ca.opcode_if_icmpgt;
	       elseif us_lt = name then
		  point1 := ca.opcode_if_icmplt;
	       elseif us_le = name then
		  point1 := ca.opcode_if_icmple;
	       else
		  point1 := ca.opcode_if_icmpge;
	       end;
	       ca.opcode_iconst_0;
	       point2 := ca.opcode_goto;
	       ca.resolve_u2_branch(point1);
	       ca.opcode_iconst_1;
	       ca.resolve_u2_branch(point2);
	    end;
 	 elseif us_to_character = name then
	    jvm.push_target;
	    code_attribute.opcode_i2b;
	 elseif us_to_bit = name then
	    jvm_int_to_bit(rf8.result_type,32);
	 else
	    check
	       us_minus = name
	    end;
	    jvm.push_target;
	    code_attribute.opcode_ineg
	 end;
      end;

   jvm_mapping_real_function(rf8: RUN_FEATURE_8; name: STRING) is
      local
	 point1, point2, space: INTEGER;
	 ca: like code_attribute;
      do
	 ca := code_attribute;
	 if rf8.arg_count = 1 then
	    jvm.push_target;
	    space := jvm.push_ith_argument(1);
	    if us_plus = name then
	       ca.opcode_fadd;
	    elseif us_minus = name then
	       ca.opcode_fsub;
	    elseif us_muls = name then
	       ca.opcode_fmul;
	    elseif us_slash = name then
	       ca.opcode_fdiv;
	    else
	       ca.opcode_fcmpg;
	       if us_gt = name then     -- gt
		  point1 := ca.opcode_ifgt;
	       elseif us_lt = name then -- lt
		  point1 := ca.opcode_iflt;
	       elseif us_le = name then -- le
		  point1 := ca.opcode_ifle;
	       elseif us_ge = name then -- ge
		  point1 := ca.opcode_ifge;
	       end;
	       ca.opcode_iconst_0;
	       point2 := ca.opcode_goto;
	       ca.resolve_u2_branch(point1);
	       ca.opcode_iconst_1;
	       ca.resolve_u2_branch(point2);
	    end;
	 elseif us_minus = name then
	    jvm.push_target;
	    ca.opcode_fneg
	 elseif us_to_double = name then
	    jvm.push_target;
	    ca.opcode_f2d;
	 end;
      end;

   jvm_mapping_double_function(rf8: RUN_FEATURE_8; name: STRING) is
      local
	 point1, point2, space, idx: INTEGER;
	 ca: like code_attribute;
      do
	 ca := code_attribute;
	 if rf8.arg_count = 1 then
	    jvm.push_target;
	    space := jvm.push_ith_argument(1);
	    if us_plus = name then
	       ca.opcode_dadd;
	    elseif us_minus = name then
	       ca.opcode_dsub;
	    elseif us_muls = name then
	       ca.opcode_dmul;
	    elseif us_slash = name then
	       ca.opcode_ddiv;
	    elseif us_pow = name then
	       ca.opcode_i2d;
	       idx := constant_pool.idx_methodref3(fz_93,"pow",fz_99);
	       ca.opcode_invokestatic(idx,-2);
	    else
	       ca.opcode_dcmpg;
	       if us_gt = name then     -- gt
		  point1 := ca.opcode_ifgt;
	       elseif us_lt = name then -- lt
		  point1 := ca.opcode_iflt;
	       elseif us_le = name then -- le
		  point1 := ca.opcode_ifle;
	       elseif us_ge = name then -- ge
		  point1 := ca.opcode_ifge;
	       end;
	       ca.opcode_iconst_0;
	       point2 := ca.opcode_goto;
	       ca.resolve_u2_branch(point1);
	       ca.opcode_iconst_1;
	       ca.resolve_u2_branch(point2);
	    end;
	 elseif us_minus = name then
	    jvm.push_target;
	    ca.opcode_dneg;
	 elseif us_to_real = name then
	    jvm.push_target;
	    ca.opcode_d2f;
	 elseif us_double_floor = name then
	    jvm.push_target;
	    idx := constant_pool.idx_methodref3(fz_93,us_floor,fz_94);
	    ca.opcode_invokestatic(idx,0);
	 elseif us_truncated_to_integer = name then
	    jvm.push_target;
	    idx := constant_pool.idx_methodref3(fz_93,us_floor,fz_94);
	    ca.opcode_invokestatic(idx,0);
	    ca.opcode_d2i;
	 else -- Same name in java/lang/Math :
	    jvm.push_target;
	    idx := constant_pool.idx_methodref3(fz_93,name,fz_94);
	    ca.opcode_invokestatic(idx,0);
	 end;
      end;

feature {NONE}

   body: STRING is
      once
	 !!Result.make(128);
      end;

   c_mapping_integer_function(rf8: RUN_FEATURE_8; name: STRING) is
      do
	 if rf8.arg_count = 1 then
            if us_slash = name then
	       cpp.put_character('(');
	       cpp.put_character('(');
               cpp.put_string(fz_double);
	       cpp.put_character(')');
	       cpp.put_character('(');
	    else
	       cpp.put_character('(');
            end;
	    cpp.put_target_as_value;
            if us_slash = name then
               cpp.put_string(fz_13);
	    else
	       cpp.put_character(')');
            end;
	    if us_slash_slash = name then
               cpp.put_string(us_slash);
	    elseif us_backslash_backslash = name then
	       cpp.put_string("%%");
            else
	       cpp.put_string(name);
            end;
	    cpp.put_character('(');
	    cpp.put_arguments;
	    cpp.put_character(')');
	 elseif us_to_character = name then
	    cpp.put_string("((char)(");
	    cpp.put_target_as_value;
	    cpp.put_string(fz_13);
	 elseif us_to_bit = name then
	    cpp.put_target_as_value;
	 else
	    cpp.put_string(name);
	    cpp.put_character('(');
	    cpp.put_target_as_value;
	    cpp.put_character(')');
	 end;
      end;
   
   c_mapping_real_function(rf8: RUN_FEATURE_8; name: STRING) is
      do
	 if rf8.arg_count = 1 then
	    cpp.put_character('(');
	    cpp.put_target_as_value;
	    cpp.put_character(')');
	    cpp.put_string(name);
	    cpp.put_character('(');
	    cpp.put_arguments;
	    cpp.put_character(')');
	 elseif us_to_double = name then
	    cpp.put_character('(');
	    cpp.put_character('(');
	    cpp.put_string(fz_double)
	    cpp.put_character(')');
	    cpp.put_character('(');
	    cpp.put_target_as_value;
	    cpp.put_character(')');
	    cpp.put_character(')');
	 else
	    cpp.put_string(name);
	    cpp.put_character('(');
	    cpp.put_target_as_value;
	    cpp.put_character(')');
	 end;
      end;

   c_mapping_double_function(rf8: RUN_FEATURE_8; name: STRING) is
      do
	 cpp.add_c_library("-lm");
	 if us_pow = name then
	    cpp.put_string("pow((");
	    cpp.put_target_as_value;
	    cpp.put_string("),(double)(");
	    cpp.put_arguments;
	    cpp.put_string(fz_13);
	 elseif us_double_floor = name then
	    cpp.put_string(us_floor);
	    cpp.put_character('(');
	    cpp.put_target_as_value;
	    cpp.put_character(')');
	 elseif us_truncated_to_integer = name then
	    cpp.put_string("((int)floor(");
	    cpp.put_target_as_value;
	    cpp.put_string(fz_13);
	 elseif us_to_real = name then
	    cpp.put_character('(');
	    cpp.put_character('(');
	    cpp.put_string(fz_float);
	    cpp.put_character(')');
	    cpp.put_character('(');
	    cpp.put_target_as_value;
	    cpp.put_character(')');
	    cpp.put_character(')');
	 elseif name.count <= 2 and then rf8.arg_count = 1 then
	       cpp.put_character('(');
	       cpp.put_target_as_value;
	       cpp.put_character(')');
	       cpp.put_string(name);
	       cpp.put_character('(');
	       cpp.put_arguments;
	       cpp.put_character(')');
	 else
	    cpp.put_string(name);
	    cpp.put_character('(');
	    cpp.put_target_as_value;
	    cpp.put_character(')');
	 end;
      end;
   
   c_define_procedure_bit(rf7: RUN_FEATURE_7; n: STRING) is
      local
	 type_bit: TYPE_BIT;
      do
	 type_bit ?= rf7.current_type;
	 if us_put_0 = n then
	    if type_bit.is_c_unsigned_ptr then
	       rf7.c_define_with_body(
               "{char *bp=((char*)C)+((a1-1)/CHAR_BIT);%N%
	       %*bp&=(~(((unsigned char)1)<<(CHAR_BIT-1-(a1-1)%%CHAR_BIT)));}");
            end;
	 elseif us_put_1 = n then
	    if type_bit.is_c_unsigned_ptr then
	       rf7.c_define_with_body(
               "{char *bp=((char*)C)+((a1-1)/CHAR_BIT);%N%
               %*bp|=(((unsigned char)1)<<(CHAR_BIT-1-(a1-1)%%CHAR_BIT));}");
            end;
	 elseif us_put = n then
	    if type_bit.is_c_unsigned_ptr then
	       rf7.c_define_with_body(
               "{char *bp=((char*)C)+((a2-1)/CHAR_BIT);%N%
               %if(a1){%N%
               %*bp|=(((unsigned char)1)<<(CHAR_BIT-1-(a2-1)%%CHAR_BIT));}%N%
               %else {%N%
               %*bp&=(~(((unsigned char)1)<<(CHAR_BIT-1-(a2-1)%%CHAR_BIT)));}}");
	    end;
	 end;
      end;

feature {NONE}

   tmp_string: STRING is
      once
	 !!Result.make(32);
      end;

feature {NONE}

   fe_nyi(rf: RUN_FEATURE) is
      do
	 eh.add_position(rf.start_position);
	 eh.append("Sorry, but this feature is not yet implemented for %
                   %Current type ");
	 eh.append(rf.current_type.run_time_mark);
	 fatal_error(" (if you cannot work around mail %"colnet@loria.fr%").");
      end;

   jvm_bit_to_int(size: INTEGER) is
      local
	 idx: INTEGER;
	 point1, point2: INTEGER;
	 loc1, loc2: INTEGER;
	 ca: like code_attribute;
	 cp: like constant_pool;
      do
	 ca := code_attribute;
	 cp := constant_pool;
	 jvm.push_target;
	 loc1 := ca.extra_local_size1;
	 ca.opcode_iconst_0;
	 ca.opcode_istore(loc1);
	 loc2 := ca.extra_local_size1;
	 ca.opcode_iconst_0;
	 ca.opcode_istore(loc2);
	 ca.opcode_iconst_1;
	 point1 := ca.program_counter;
	 point2 := ca.opcode_ifeq;
	 ca.opcode_iload(loc2);
	 ca.opcode_iconst_1;
	 ca.opcode_ishl;
	 ca.opcode_istore(loc2);
	 ca.opcode_dup;
	 ca.opcode_iload(loc1);
	 idx := cp.idx_methodref3(fz_a0,fz_a2,fz_a3);
	 ca.opcode_invokevirtual(idx,-1);
	 ca.opcode_iload(loc2);
	 ca.opcode_ior;
	 ca.opcode_istore(loc2);
	 ca.opcode_iinc(loc1,1);
-- ***
--	 ca.opcode_dup;
--	 idx := cp.idx_methodref3(fz_a0,"size",fz_71);
--	 ca.opcode_invokevirtual(idx,0);
         ca.opcode_push_integer(size);
-- ***
	 ca.opcode_iload(loc1);
	 ca.opcode_isub;
	 ca.opcode_goto_backward(point1);
	 ca.resolve_u2_branch(point2);
	 ca.opcode_pop;
	 ca.opcode_iload(loc2);
      end;

   jvm_int_to_bit(type_bit: TYPE; nb_bit: INTEGER) is
      local
	 idx: INTEGER;
	 point1, point2, point3: INTEGER;
	 loc1, loc2: INTEGER;
	 ca: like code_attribute;
	 cp: like constant_pool;
      do
	 ca := code_attribute;
	 cp := constant_pool;
	 jvm.push_target;
	 loc1 := ca.extra_local_size1;
	 ca.opcode_push_integer(nb_bit);
	 ca.opcode_istore(loc1);
	 loc2 := ca.extra_local_size1;
	 idx := type_bit.jvm_push_default;
	 ca.opcode_istore(loc2);
	 ca.opcode_iconst_1;
	 point1 := ca.program_counter;
	 point2 := ca.opcode_ifeq;
	 ca.opcode_iinc(loc1,255);
	 ca.opcode_dup;
	 ca.opcode_iconst_1;
	 ca.opcode_iand;
	 point3 := ca.opcode_ifeq;
	 ca.opcode_iload(loc2);
	 ca.opcode_iload(loc1);
	 idx := cp.idx_methodref3(fz_a0,fz_a4,fz_27);
	 ca.opcode_invokevirtual(idx,-2);
	 ca.resolve_u2_branch(point3);
	 ca.opcode_iconst_1;
	 ca.opcode_iushr;
	 ca.opcode_iload(loc1);
	 ca.opcode_goto_backward(point1);
	 ca.resolve_u2_branch(point2);
	 ca.opcode_pop;
	 ca.opcode_iload(loc2);
      end;

   jvm_mapping_bit_function(rf8: RUN_FEATURE_8; name: STRING) is
      local
	 type_bit: TYPE_BIT;
	 space, idx: INTEGER;
	 point1, point2, point3: INTEGER;
	 loc1, loc2: INTEGER;
	 ca: like code_attribute;
	 cp: like constant_pool;
      do
	 ca := code_attribute;
	 cp := constant_pool;
	 type_bit ?= rf8.current_type;
	 if us_count = name then
	    jvm.drop_target;
	    ca.opcode_push_integer(type_bit.nb);
	 elseif us_item = name then
	    jvm.push_target;
	    space := jvm.push_ith_argument(1);
	    ca.opcode_iconst_1;
	    ca.opcode_isub;
	    idx := cp.idx_methodref3(fz_a0,fz_a2,fz_a3);
	    ca.opcode_invokevirtual(idx,-1);
         elseif us_shift_right = name then
	    jvm.push_target;
	    space := jvm.push_ith_argument(1);
	    loc1 := ca.extra_local_size1;
	    loc2 := ca.extra_local_size1;
	    ca.opcode_istore(loc2);
	    space := type_bit.jvm_push_default;
	    ca.opcode_swap;
	    ca.opcode_push_integer(type_bit.nb);
	    ca.opcode_istore(loc1);
	    ca.opcode_iload(loc1);
	    ca.opcode_iload(loc2);
	    ca.opcode_isub;
	    ca.opcode_istore(loc2);
	    ca.opcode_iload(loc2);
	    point1 := ca.program_counter;
	    point2 := ca.opcode_ifeq;
	    ca.opcode_iinc(loc1,255);
	    ca.opcode_iinc(loc2,255);
	    ca.opcode_dup2;
	    ca.opcode_iload(loc2);
	    idx := cp.idx_methodref3(fz_a0,fz_a2,fz_a3);
	    ca.opcode_invokevirtual(idx,-1);
	    point3 := ca.opcode_ifne;
	    ca.opcode_pop;
	    ca.opcode_iload(loc2);
	    ca.opcode_goto_backward(point1);
	    ca.resolve_u2_branch(point3);
	    ca.opcode_iload(loc1);
	    idx := cp.idx_methodref3(fz_a0,fz_a4,fz_27);
	    ca.opcode_invokevirtual(idx,-2);
	    ca.opcode_iload(loc2);
	    ca.opcode_goto_backward(point1);
	    ca.resolve_u2_branch(point2);
	    ca.opcode_pop;
         elseif us_shift_left = name then
	    jvm.push_target;
	    space := jvm.push_ith_argument(1);
	    loc1 := ca.extra_local_size1;
	    loc2 := ca.extra_local_size1;
	    ca.opcode_istore(loc1);
	    space := type_bit.jvm_push_default;
	    ca.opcode_swap;
	    ca.opcode_push_integer(type_bit.nb);
	    ca.opcode_istore(loc2);
	    ca.opcode_iload(loc2);
	    ca.opcode_iload(loc1);
	    ca.opcode_isub;
	    ca.opcode_istore(loc1);
	    ca.opcode_iload(loc1);
	    point1 := ca.program_counter;
	    point2 := ca.opcode_ifeq;
	    ca.opcode_iinc(loc1,255);
	    ca.opcode_iinc(loc2,255);
	    ca.opcode_dup2;
	    ca.opcode_iload(loc2);
	    idx := cp.idx_methodref3(fz_a0,fz_a2,fz_a3);
	    ca.opcode_invokevirtual(idx,-1);
	    point3 := ca.opcode_ifne;
	    ca.opcode_pop;
	    ca.opcode_iload(loc1);
	    ca.opcode_goto_backward(point1);
	    ca.resolve_u2_branch(point3);
	    ca.opcode_iload(loc1);
	    idx := cp.idx_methodref3(fz_a0,fz_a4,fz_27);
	    ca.opcode_invokevirtual(idx,-2);
	    ca.opcode_iload(loc1);
	    ca.opcode_goto_backward(point1);
	    ca.resolve_u2_branch(point2);
	    ca.opcode_pop;
         elseif us_xor = name then
	    jvm.push_target;
	    ca.opcode_dup;
	    space := jvm.push_ith_argument(1);
	    idx := cp.idx_methodref3(fz_a0,us_xor,fz_b1);
	    ca.opcode_invokevirtual(idx,0);
         elseif us_or = name then
	    jvm.push_target;
	    ca.opcode_dup;
	    space := jvm.push_ith_argument(1);
	    idx := cp.idx_methodref3(fz_a0,us_or,fz_b1);
	    ca.opcode_invokevirtual(idx,0);
         elseif us_not = name then
	    jvm.push_target;
	    loc1 := ca.extra_local_size1;
	    ca.opcode_push_integer(type_bit.nb);
	    ca.opcode_istore(loc1);
	    ca.opcode_iload(loc1);
	    point1 := ca.program_counter;
	    point2 := ca.opcode_ifeq;
	    ca.opcode_iinc(loc1,255);
	    ca.opcode_dup;
	    ca.opcode_iload(loc1);
	    idx := cp.idx_methodref3(fz_a0,fz_a2,fz_a3);
	    ca.opcode_invokevirtual(idx,-1);
	    point3 := ca.opcode_ifne;
	    ca.opcode_dup;
	    ca.opcode_iload(loc1);
	    idx := cp.idx_methodref3(fz_a0,fz_a4,fz_27);
	    ca.opcode_invokevirtual(idx,-2);
	    ca.opcode_iload(loc1);
	    ca.opcode_goto_backward(point1);
	    ca.resolve_u2_branch(point3);
	    ca.opcode_dup;
	    ca.opcode_iload(loc1);
	    idx := cp.idx_methodref3(fz_a0,fz_a5,fz_27);
	    ca.opcode_invokevirtual(idx,-2);
	    ca.opcode_iload(loc1);
	    ca.opcode_goto_backward(point1);
	    ca.resolve_u2_branch(point2);
         elseif us_and = name then
	    jvm.push_target;
	    ca.opcode_dup;
	    space := jvm.push_ith_argument(1);
	    idx := cp.idx_methodref3(fz_a0,us_and,fz_b1);
	    ca.opcode_invokevirtual(idx,0);
         elseif us_to_character = name then
	    jvm_bit_to_int(8);
         elseif us_to_integer = name then
	    jvm_bit_to_int(32);
	 end;
      end;

   jvm_mapping_bit_procedure(rf7: RUN_FEATURE_7; name: STRING) is
      local
	 type_bit: TYPE_BIT;
	 space, idx, point1, point2: INTEGER;
	 ca: like code_attribute;
	 cp: like constant_pool;
      do
	 ca := code_attribute;
	 cp := constant_pool;
	 type_bit ?= rf7.current_type;
	 if name = us_put_0 then
	    jvm.push_target;
	    space := jvm.push_ith_argument(1);
	    ca.opcode_iconst_1;
	    ca.opcode_isub;
	    idx := cp.idx_methodref3(fz_a0,fz_a5,fz_27);
	    ca.opcode_invokevirtual(idx,-2);
	 elseif name = us_put_1 then
	    jvm.push_target;
	    space := jvm.push_ith_argument(1);
	    ca.opcode_iconst_1;
	    ca.opcode_isub;
	    idx := cp.idx_methodref3(fz_a0,fz_a4,fz_27);
	    ca.opcode_invokevirtual(idx,-2);
	 else
            check
               name = us_put
            end;
	    jvm.push_target;
	    space := jvm.push_ith_argument(1);
	    space := jvm.push_ith_argument(2);
	    ca.opcode_iconst_1;
	    ca.opcode_isub;
	    ca.opcode_swap;
	    point1 := ca.opcode_ifne;
	    idx := cp.idx_methodref3(fz_a0,fz_a5,fz_27);
	    ca.opcode_invokevirtual(idx,-2);
	    point2 := ca.opcode_goto;
	    ca.resolve_u2_branch(point1);
	    idx := cp.idx_methodref3(fz_a0,fz_a4,fz_27);
	    ca.opcode_invokevirtual(idx,-2);
	    ca.resolve_u2_branch(point2);
	 end;
      end;

   c_mapping_bit_procedure(rf7: RUN_FEATURE_7; name: STRING) is
      local
	 type_bit: TYPE_BIT;
      do
	 type_bit ?= rf7.current_type;
	 if name = us_put_0 then
	    if type_bit.is_c_unsigned_ptr then
	       rf7.default_mapping_procedure;
	    else
	       mapping_bit_put_0(type_bit,1);
	    end;
	 elseif name = us_put_1 then
	    if type_bit.is_c_unsigned_ptr then
	       rf7.default_mapping_procedure;
	    else
	       mapping_bit_put_1(type_bit,1);
	    end;
	 else
            check
               name = us_put
            end;
	    if type_bit.is_c_unsigned_ptr then
	       rf7.default_mapping_procedure;
	    else
	       cpp.put_string("if(");
	       cpp.put_ith_argument(1);
	       cpp.put_string("){%N");
	       mapping_bit_put_1(type_bit,2);
	       cpp.put_string("} else {%N");
	       mapping_bit_put_0(type_bit,2);
	       cpp.put_string(fz_12);
	    end;
	 end;
      end;

   mapping_bit_put_1(type_bit: TYPE_BIT; arg: INTEGER) is
      do
	 cpp.put_target_as_value;
	 cpp.put_string("|=(((unsigned ");
	 if type_bit.is_c_char then
	    cpp.put_string(fz_char);
         else
	    cpp.put_string(fz_int);
         end;
	 cpp.put_string(")1)<<((CHAR_BIT");
	 if type_bit.is_c_int then
	    cpp.put_string("*sizeof(unsigned)");
         end;
	 cpp.put_string(")-(");
	 cpp.put_ith_argument(arg);
	 cpp.put_string(")));%N");
      end;

   mapping_bit_put_0(type_bit: TYPE_BIT; arg: INTEGER) is
      do
         cpp.put_target_as_value;
	 cpp.put_string("&=(~(((unsigned ");
	 if type_bit.is_c_char then
            cpp.put_string(fz_char);
         else
	    cpp.put_string(fz_int);
	 end;
	 cpp.put_string(")1)<<((CHAR_BIT");
	 if type_bit.is_c_int then
	    cpp.put_string("*sizeof(unsigned)");
         end;
	 cpp.put_string(")-(");
	 cpp.put_ith_argument(arg);
	 cpp.put_string("))));%N");
      end;

   c_mapping_bit_function(rf8: RUN_FEATURE_8; name: STRING) is
      local
	 type_bit: TYPE_BIT;
	 boost: BOOLEAN;
      do
	 type_bit ?= rf8.current_type;
	 boost := run_control.boost;
	 if us_count = name then
	    cpp.put_integer(type_bit.nb);
	 elseif us_item = name then
	    if type_bit.is_c_unsigned_ptr then
	       rf8.default_mapping_function;
	    elseif boost then
	       cpp.put_string(fz_17);
	       cpp.put_target_as_target;
	       cpp.put_string(")>>((CHAR_BIT");
	       if type_bit.is_c_int then
		  cpp.put_string("*sizeof(unsigned)");
	       end;
	       cpp.put_string(")-(");
	       cpp.put_arguments;
	       cpp.put_string(")))&1");
	    else
	       rf8.default_mapping_function;
	    end;
         elseif us_shift_right = name then
	    if type_bit.is_c_unsigned_ptr then
	       rf8.default_mapping_function;
	    elseif boost then
	       cpp.put_string(fz_17);
	       cpp.put_target_as_target;
	       cpp.put_string(")>>(");
	       cpp.put_ith_argument(1);
	       cpp.put_string(fz_13);
	    else
	       rf8.default_mapping_function;
	    end;
         elseif us_shift_left = name then
	    if type_bit.is_c_unsigned_ptr then
	       rf8.default_mapping_function;
	    elseif boost then
	       cpp.put_string(fz_17);
	       cpp.put_target_as_target;
	       cpp.put_string(")<<(");
	       cpp.put_ith_argument(1);
	       cpp.put_string(fz_13);
	    else
	       rf8.default_mapping_function;
	    end;
         elseif us_xor = name then
	    if type_bit.is_c_unsigned_ptr then
	       fe_nyi(rf8);
	    else
	       cpp.put_character('(');
	       cpp.put_target_as_target;
	       cpp.put_character(')');
	       cpp.put_character('^');
	       cpp.put_character('(');
	       cpp.put_ith_argument(1);
	       cpp.put_character(')');
	    end;
         elseif us_or = name then
	    if type_bit.is_c_unsigned_ptr then
	       fe_nyi(rf8);
	    else
	       cpp.put_character('(');
	       cpp.put_target_as_target;
	       cpp.put_character(')');
	       cpp.put_character('|');
	       cpp.put_character('(');
	       cpp.put_ith_argument(1);
	       cpp.put_character(')');
	    end;
         elseif us_not = name then
	    if type_bit.is_c_unsigned_ptr then
	       fe_nyi(rf8);
	    else
	       cpp.put_character(' ');
	       cpp.put_character('~');
	       cpp.put_character('(');
	       cpp.put_target_as_target;
	       cpp.put_character(')');
	    end;
         elseif us_and = name then
	    if type_bit.is_c_unsigned_ptr then
	       fe_nyi(rf8);
	    else
	       cpp.put_character('(');
	       cpp.put_target_as_target;
	       cpp.put_character(')');
	       cpp.put_character('&');
	       cpp.put_character('(');
	       cpp.put_ith_argument(1);
	       cpp.put_character(')');
	    end;
         elseif us_to_character = name then
	    cpp.put_target_as_value;
         elseif us_to_integer = name then
	    cpp.put_target_as_value;
	 end;
      end;

   c_define_function_bit(rf8: RUN_FEATURE_8; name: STRING) is
      local
	 type_bit: TYPE_BIT;
	 no_check: BOOLEAN;
      do
	 type_bit ?= rf8.current_type;
	 no_check := run_control.no_check;
	 if us_count = name then
	 elseif us_item = name then
	    if type_bit.is_c_unsigned_ptr then
	       rf8.c_define_with_body(
	       "{R=((((unsigned char*)C)[(a1-1)/CHAR_BIT])%
               %>>(CHAR_BIT-1-(a1-1)%%CHAR_BIT))&1;}")
	    elseif no_check then
	       if type_bit.is_c_char then
		  rf8.c_define_with_body("R=((C>>(CHAR_BIT-a1))&1);");
	       else
		  rf8.c_define_with_body(
		  "R=((C>>((CHAR_BIT*sizeof(unsigned))-a1))&1);");
	       end;
	    end;
	 elseif us_shift_left = name then
	    if type_bit.is_c_unsigned_ptr then
               body.copy( 
               "int d=a1%%(CHAR_BIT*sizeof(unsigned));%N%
               %int D=a1/(CHAR_BIT*sizeof(unsigned));%N%
               %int c=CHAR_BIT*sizeof(unsigned)-d;%N%
               %int f=(");
               type_bit.nb.append_in(body);
               body.append(
               "-1)/(CHAR_BIT*sizeof(unsigned))-D;%N%
               %int i=0;%N%
               %for(;i<f;i++) R[i]=(C[i+D]<<d)|(C[i+D+1]>>c);%N%
               %R[f]=((C[(");
               type_bit.nb.append_in(body);
               body.append(
               "-1)/(CHAR_BIT*sizeof(unsigned))])&((~0)<<(CHAR_BIT*%
               %sizeof(unsigned)-");
               type_bit.nb.append_in(body);
               body.append("%%(CHAR_BIT*sizeof(unsigned)))))<<d;");
	       rf8.c_define_with_body(body);
	    else
	       rf8.c_define_with_body("R=(C<<a1);");
	    end;
	 elseif us_shift_right = name then
	    if type_bit.is_c_unsigned_ptr then
	       body.copy(
               "int d=a1%%(CHAR_BIT*sizeof(unsigned));%N%
               %int D=a1/(CHAR_BIT*sizeof(unsigned));%N%
               %int c=CHAR_BIT*sizeof(unsigned)-d;%N%
               %int i=(");
	       type_bit.nb.append_in(body);
               body.append(
               ")/(CHAR_BIT*sizeof(unsigned));%N%
               %for(;i>D;i--) R[i]=(C[i-D]>>d)|(C[i-D-1]<<c);%N%
               %R[D]=C[0]>>d;");
	       rf8.c_define_with_body(body);
	    else
	       rf8.c_define_with_body("R=(C>>a1);");
	    end;
	 end;
      end;

feature {NONE}

   native_array(t: TYPE): BOOLEAN is
      do
         Result := t.base_class_name.to_string = us_native_array;
      end;

   unknown_native(rf: RUN_FEATURE) is
      do
	 eh.add_position(rf.start_position);
	 fatal_error("Unknown native feature.");
      end;

end -- NATIVE_SMALL_EIFFEL


