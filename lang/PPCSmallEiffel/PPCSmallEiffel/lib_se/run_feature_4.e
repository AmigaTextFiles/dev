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
class RUN_FEATURE_4

inherit RUN_FEATURE redefine base_feature end;
   
creation {FUNCTION} make
   
feature 
   
   base_feature: FUNCTION;
      
   local_vars: LOCAL_VAR_LIST;
	 -- Runnable local var list if any.

   static_value_mem: INTEGER;

feature 
   
   is_pre_computable: BOOLEAN is false;
   
   is_static: BOOLEAN is 
      do 
	 if isa_in_line then
	    Result := is_static_flag;
	 end;
      end;
   
   afd_check is
      do
	 routine_afd_check;
      end;

   can_be_dropped: BOOLEAN is
      do
	 Result := ((arguments = Void) and then 
		    (local_vars = Void) and then
		    (require_assertion = Void) and then
		    (ensure_assertion = Void) and then
		    (rescue_compound = Void));
	 if Result then
	    if routine_body /= Void then
	       Result := false;
	    end;		    
	 end;
      end;

   is_empty_or_null_body: BOOLEAN is
      do
	 if isa_in_line then
	    Result := in_line_status = C_empty_or_null_body;
	 end;
      end;

   is_attribute_reader: FEATURE_NAME is
	 -- Gives Void or the attribute read.
      local
	 c0: CALL_0;
	 rf: RUN_FEATURE;
      do
	 if isa_in_line then
	    if in_line_status = C_attribute_reader then
	       c0 ?= body_one_result;
	       rf := c0.run_feature;
	       Result := rf.name;
	    end;
	 end;
      end;

   is_direct_call_on_attribute: FEATURE_NAME is
	 -- Gives Void or the target attribute.
      local
	 c: CALL;
	 rf: RUN_FEATURE;
      do
	 if isa_in_line then
	    inspect
	       in_line_status
	    when C_dca then
	       c ?= body_one_result;
	       c ?= c.target;
	       rf := c.run_feature;
	       Result := rf.name;
	    else
	    end;
	 end;
      end;

   mapping_c is
      local
	 tcbd: BOOLEAN;
      do
	 if isa_in_line then
	    in_line;
	 elseif use_current then
	    default_mapping_function;
	 else
	    tcbd := cpp.target_cannot_be_dropped;
	    if tcbd then
	       cpp.put_character(',');
	    end;
	    mapping_name;
	    cpp.put_character('(');
	    if arguments /= Void then
	       cpp.put_arguments;
	    end;
	    cpp.put_character(')');
	    if tcbd then
	       cpp.put_character(')');
	    end;
	 end;
      end;
      
   c_define is
      do
	 if isa_in_line then
	    cpp.incr_inlined_function_count;
	    nothing_comment;
	 else
	    if use_current then
	       cpp.incr_function_count;
	    else
	       cpp.incr_real_function_count;
	    end;
	    define_prototype;
	    define_opening;
	    if routine_body /= Void then
	       routine_body.compile_to_c;
	    end;
	    define_closing;
	    cpp.put_string(fz_15);
	 end;
      end;

feature {NONE}   
   
   initialize is
      do
	 arguments := base_feature.arguments;
	 if arguments /= Void and then arguments.count > 0 then
	    arguments := arguments.to_runnable(current_type);
	 end;
	 result_type := base_feature.result_type.to_runnable(current_type);
	 local_vars := base_feature.local_vars;
	 if local_vars /= Void and then local_vars.count > 0 then
	    local_vars := local_vars.to_runnable(current_type);
	 end;
	 routine_body := base_feature.routine_body;
	 if routine_body /= Void then
	    routine_body := routine_body.to_runnable(current_type);
	 end;
	 if run_control.require_check then
	    require_assertion := base_feature.run_require(Current);
	 end;
	 if run_control.ensure_check then
	    ensure_assertion := base_feature.run_ensure(Current);
	 end;
      end;
   
   in_line_status: INTEGER;
	 -- Value 0 means not computed.
	 -- Value -1 means not `isa_in_line'.

   is_static_flag: BOOLEAN;

   isa_in_line: BOOLEAN is
      do
	 if run_control.boost then
	    inspect 
	       in_line_status
	    when -1 then
	    when 0 then
	       Result := true;
	       if empty_or_null_body then
		  in_line_status := C_empty_or_null_body;
	       elseif value_reader then
		  in_line_status := C_value_reader;
	       elseif attribute_reader then
		  in_line_status := C_attribute_reader;
	       elseif result_is_current then
		  in_line_status := C_result_is_current;
	       elseif direct_call then
		  in_line_status := C_direct_call;
	       elseif dca then
		  in_line_status := C_dca;
	       elseif a_eq_neq then
		  in_line_status := C_a_eq_neq;
	       elseif dc_pco1 then
		  in_line_status := C_dc_pco1;
	       elseif dc_pco2 then
		  in_line_status := C_dc_pco2;
	       elseif direct_cse_call then
		  in_line_status := C_direct_cse_call;
	       else
		  in_line_status := -1;
		  Result := false;
	       end;
	    else
	       Result := true;
	    end;
	 end;
      end;

   empty_or_null_body: BOOLEAN is
	 -- The body is empty or has only unreacheable code.
      local
	 rb: COMPOUND;
      do
	 rb := routine_body;
	 if (rb = Void or else rb.empty_or_null_body)
	    and then local_vars = Void 
	  then
	    static_value_mem := 0;
	    is_static_flag := true;
	    Result := true;
	 end;
      end;

   value_reader: BOOLEAN is
	 -- True when the function body has only one instruction 
	 -- of the form :
	 --      Result := <expression>;
	 -- Where <expression> is statically computable.
      local
	 e: EXPRESSION;
	 c0: CALL_0;
      do
	 e := body_one_result;
	 if e /= Void and then local_vars = Void then
	    c0 ?= e;
	    if c0 /= Void and then 
	       c0.target.is_current and then
	       c0.run_feature = Current 
	     then
	       eh.add_position(e.start_position);
	       fatal_error("Infinite recursive call.");
	    elseif e.is_static then
	       Result := true;
	       static_value_mem := e.static_value;
	       is_static_flag := true;
	    end;
	 end;
      end;

   attribute_reader: BOOLEAN is
	 -- True when the function has no arguments, no locals, and 
	 -- when the body has only one instruction of the form :
	 --      Result := attribute;
	 -- Where `attribute' is a RUN_FEATURE_2.
      local
	 e: EXPRESSION;
	 c0: CALL_0;
	 rf2: RUN_FEATURE_2;
      do
	 e := body_one_result;
	 if e /= Void and then local_vars = Void then
	    c0 ?= e;
	    if c0 /= Void then
	       if c0.target.is_current then
		  rf2 ?= c0.run_feature;
		  if rf2 /= Void then
		     Result := true;
		  end;
	       end;
	    end;
	 end;
      end;

   result_is_current: BOOLEAN is
      local
	 e: EXPRESSION;
      do
	 e := body_one_result;
	 if e /= Void and then local_vars = Void then
	    if e.is_current then
	       Result := true;
	    end;
	 end;
      end;

   direct_call: BOOLEAN is
	 -- True when the function has no arguments, no locals, and 
	 -- when the body has only one instruction of the form :
	 --    Result := foo(<args>);
	 -- Where <args> can be an empty list or a statically 
	 -- computable one.
	 -- Where `foo' is a RUN_FEATURE_4.
      local
	 e: EXPRESSION;
	 c: CALL;
	 args: EFFECTIVE_ARG_LIST;
	 rf4: RUN_FEATURE_4;
      do
	 e := body_one_result;
	 if e /= Void and then
	    arguments = Void and then 
	    local_vars = Void 
	  then
	    c ?= e;
	    if c /= Void then
	       if c.target.is_current then
		  rf4 ?= c.run_feature;
		  if rf4 /= Void then
		     args := c.arguments;
		     if args = Void then
			Result := true;
		     else
			Result := args.is_static;
		     end;
		  end;
	       end;
	    end;
	 end;
      end;

   dca: BOOLEAN is
	 -- Direct Call on Attribute.
      local
	 c: CALL;
	 rf: RUN_FEATURE;
	 args: EFFECTIVE_ARG_LIST;
      do
	 c := body_one_result_dca;
	 if c /= Void and then local_vars = Void then
	    rf := c.run_feature;
	    if rf /= Void then
	       if rf /= Current then
		  args := c.arguments;
		  if args = Void then
		     Result := arg_count = 0;
		  else
		     Result := args.isa_dca_inline(Current,rf);
		  end;
	       end;
	    end;
	 end;
      end;

   a_eq_neq: BOOLEAN is
	 -- Attribute "=" or "/=".
      local
	 c: CALL;
	 rf: RUN_FEATURE;
	 e: EXPRESSION;
      do
	 c := body_one_result_dca;
	 if c /= Void and then local_vars = Void then
	    rf := c.run_feature;
	    if rf = Void and then c.arg_count = 1 then
	       -- For "=" and "/=" :
	       e := c.arguments.expression(1);
	       inspect
		  e.isa_dca_inline_argument
	       when 0 then
	       when -1 then
		  Result := arg_count = 0;
	       else
		  Result := arg_count = 1;
	       end;
	    end;
	 end;
      end;

   dc_pco1: BOOLEAN is
      local
	 c: CALL;
	 rf6: RUN_FEATURE_6;
      do
	 c := body_one_dc_pco;
	 if c /= Void and then c.target.is_current then
	    rf6 ?= c.run_feature;
	    if rf6 /= Void then
	       Result := not rf6.use_current;
	    end;
	 end;
      end;

   dc_pco2: BOOLEAN is
      local
	 c1, c2: CALL;
	 rf6: RUN_FEATURE_6;
      do
	 c1 := body_one_dc_pco;
	 if c1 /= Void then
	    c2 ?= c1.target;
	    if c2 /= Void then
	       rf6 ?= c2.run_feature;
	       if rf6 /= Void and then 
		  not rf6.use_current and then
		  c2.target.is_current 
		then
		  Result := true;
	       end;
	    end;
	 end;
      end;

   direct_cse_call: BOOLEAN is
      local
	 c: CALL;
	 rf8: RUN_FEATURE_8;
      do
	 if arguments = Void and then local_vars = Void then
	    c ?= body_one_result;
	    if c /= Void and then c.arguments = Void then
	       c ?= c.target;
	       if c /= Void and then c.target.is_current then
		  if c.arguments = Void then
		     rf8 ?= c.run_feature;
		     if rf8 /= Void then
			Result := rf8.name.to_string = us_to_pointer;
		     end;
		  end;
	       end;
	    end;
	 end;
      end;

   in_line is
      local
	 a: ASSIGNMENT;
	 e: EXPRESSION;
	 flag: BOOLEAN;
	 c: CALL;
	 rf: RUN_FEATURE;
	 rc: RUN_CLASS;
	 cien: CALL_INFIX_EQ_NEQ;
      do
	 cpp.put_string("/*(IRF4.");
	 cpp.put_integer(in_line_status);
	 cpp.put_string(name.to_string);
	 cpp.put_string(fz_close_c_comment);
	 inspect
	    in_line_status
	 when C_empty_or_null_body then
	    flag := cpp.cannot_drop_all;
	    if flag then
	       cpp.put_character(',');
	    end;
	    result_type.run_type.c_initialize;
	    if flag then
	       cpp.put_character(')');
	    end;
	 when C_value_reader then
	    flag := cpp.cannot_drop_all;
	    if flag then
	       cpp.put_character(',');
	    end;
	    a ?= routine_body.first;
	    e := a.right_side;
	    cpp.put_character('(');
	    e.compile_to_c; 
	    cpp.put_character(')');
	    if flag then
	       cpp.put_character(')');
	    end;
	 when C_attribute_reader then
	    flag := cpp.arguments_cannot_be_dropped;
	    if flag then
	       cpp.put_character(',');
	    end;
	    a ?= routine_body.first;
	    c ?= a.right_side;
	    c.run_feature.mapping_c;
	    if flag then
	       cpp.put_character(')');
	    end;
	 when C_result_is_current then
	    flag := cpp.arguments_cannot_be_dropped;
	    if flag then
	       cpp.put_character(',');
	    end;
	    tmp_string.clear;
	    tmp_string.extend('(');
	    tmp_string.extend('(');
	    result_type.run_type.c_type_for_result_in(tmp_string);
	    tmp_string.extend(')');
	    tmp_string.extend('(');
	    cpp.put_string(tmp_string);
	    cpp.put_target_as_value;
	    cpp.put_string(fz_13);
	    if flag then
	       cpp.put_character(')');
	    end;
	 when C_direct_call then
	    a ?= routine_body.first;
	    c ?= a.right_side;
	    rf := c.run_feature;
	    cpp.push_same_target(rf,c.arguments);
	    rf.mapping_c;
	    cpp.pop;
	 when C_dca then
	    a ?= routine_body.first;
	    c ?= a.right_side;
	    c.finalize;
	    cpp.push_inline_dca(Current,c);
	    c.run_feature.mapping_c;
	    cpp.pop;
	 when C_a_eq_neq then
	    a ?= routine_body.first;
	    cien ?= a.right_side;
	    cpp.push_inline_dca(Current,cien);
	    cien.dca_inline(cien.arg1.result_type);
	    cpp.pop;
	 when C_dc_pco1, C_dc_pco2 then
	    flag := cpp.target_cannot_be_dropped;
	    if flag then
	       cpp.put_character(',');
	    end;
	    a ?= routine_body.first;
	    c ?= a.right_side;
	    rf := c.run_feature;
	    cpp.push_direct(rf,c.target,c.arguments);
	    rf.mapping_c;
	    cpp.pop;
	    if flag then
	       cpp.put_character(')');
	    end;
	 when C_direct_cse_call then
	    a ?= routine_body.first;
	    c ?= a.right_side;
	    rf := c.run_feature;
	    cpp.push_same_target(rf,c.arguments);
	    rf.mapping_c;
	    cpp.pop;
	 end;
	 cpp.put_string("/*)*/");
      end;
   
   compute_use_current is
      do
	 if current_type.is_reference and then run_control.no_check then
	    use_current_state := ucs_true;
	 else
	    std_compute_use_current;
	 end;
      end;

   body_one_result: EXPRESSION is
	 -- Gives the RHS expression if the body has only one 
	 -- instruction of the form :
	 --        Result := <RHS>;
      local
	 rb: like routine_body;
	 a: ASSIGNMENT;
      do
	 rb := routine_body;
	 if rb /= Void and then rb.count = 1 then
	    a ?= rb.first;
	    if a /= Void then
	       if a.left_side.is_result then
		  Result := a.right_side;
	       end;
	    end;
	 end;
      end;

   body_one_result_dca: CALL is
      local
	 c: CALL;
	 c0c: CALL_0_C;
	 rf2: RUN_FEATURE_2;
	 rf: RUN_FEATURE;
	 r: ARRAY[RUN_CLASS];
      do
	 c ?= body_one_result;
	 if c /= Void then
	    c0c ?= c.target;
	    if c0c /= Void then
	       if c0c.target.is_current then
		  rf2 ?= c0c.run_feature;
		  if rf2 /= Void then
		     r := rf2.run_class.running;
		     if r /= Void and then r.count = 1 then
			rf := c.run_feature;
			if rf /= Void then
			   r := rf.run_class.running;
			   if r /= Void and then r.count = 1 then
			      Result := c;
			   end;
			else -- Basic "=" and "/=" :
			   Result := c;
			end;
		     end;
		  end;
	       end;
	    end;
	 end;
      end;

   body_one_dc_pco: CALL is
      local
	 c: CALL;
	 args: EFFECTIVE_ARG_LIST;
      do
	 c ?= body_one_result;
	 if c /= Void and then 
	    local_vars = Void and then
	    arguments = Void
	  then
	    args := c.arguments;
	    if args = Void or else args.is_static then
	       Result := c;
	    end;
	 end;
      end;

feature {NONE}

   C_empty_or_null_body  : INTEGER is 1;
   C_value_reader        : INTEGER is 2;
   C_attribute_reader    : INTEGER is 3;
   C_result_is_current   : INTEGER is 4;
   C_direct_call         : INTEGER is 5;
   C_dca                 : INTEGER is 6;
   C_a_eq_neq            : INTEGER is 7;
   C_dc_pco1             : INTEGER is 8;
   C_dc_pco2             : INTEGER is 9;
   C_direct_cse_call     : INTEGER is 10;

feature {NONE}

   tmp_string: STRING is
      once
	 !!Result.make(8);
      end;

feature {RUN_CLASS}

   jvm_field_or_method is
      do
	 jvm.add_method(Current);
      end;

feature 

   mapping_jvm is
      do
	 routine_mapping_jvm;
      end;

feature {JVM}

   jvm_define is
      do
	 method_info_start;
	 jvm_define_opening;
	 if routine_body /= Void then
	    routine_body.compile_to_jvm;
	 end;
	 jvm_define_closing;
	 result_type.run_type.jvm_return_code;
	 method_info.finish;
      end;
   
feature {NONE}

   update_tmp_jvm_descriptor is
      do
	 routine_update_tmp_jvm_descriptor;
      end;

end -- RUN_FEATURE_4


