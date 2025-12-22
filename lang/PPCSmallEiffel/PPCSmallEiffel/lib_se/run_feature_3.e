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
class RUN_FEATURE_3
   
inherit RUN_FEATURE redefine base_feature end;
   
creation {PROCEDURE} make
   
feature 
   
   base_feature: PROCEDURE;
      
   local_vars: LOCAL_VAR_LIST;
	 -- Runnable local var list if any.
   
feature 
   
   is_static: BOOLEAN is false;
   
   static_value_mem: INTEGER is 0;

   can_be_dropped: BOOLEAN is false
   
   is_pre_computable: BOOLEAN is 
      do
	 if arguments = Void then
	    if routine_body = Void then
	       Result := true; 
	    else
	       if local_vars = Void then
		  Result := routine_body.is_pre_computable;
	       end;
	    end;
	 end;
      end;

   afd_check is
      do
	 routine_afd_check;
      end;

   is_empty_or_null_body: BOOLEAN is
      do
	 if isa_in_line then
	    Result := in_line_status = C_empty_or_null_body;
	 end;
      end;

   is_attribute_writer: SIMPLE_FEATURE_NAME is
      local
	 a: ASSIGNMENT;
      do
	 if isa_in_line then
	    if in_line_status = C_attribute_writer then
	       a ?= routine_body.first;
	       Result ?= a.left_side;
	    end;
	 end;
      end;

   mapping_c is
      do
	 if isa_in_line then
	    in_line;
	 elseif use_current then
	    default_mapping_procedure;
	 else
	    if cpp.target_cannot_be_dropped then 
	       cpp.put_string(fz_14);
	    end;
	    mapping_name;
	    cpp.put_character('(');
	    if arg_count > 0 then
	       cpp.put_arguments;
	    end;
	    cpp.put_string(fz_14);
	 end;
      end;
   
   c_define is
      do
	 if isa_in_line then
	    cpp.incr_inlined_procedure_count;
	    nothing_comment;
	 else
	    if use_current then
	       cpp.incr_procedure_count;
	    else
	       cpp.incr_real_procedure_count;
	    end;
	    define_prototype;
	    define_opening;
	    if routine_body /= Void then
	       routine_body.compile_to_c;
	    end;
	    define_closing;
	    cpp.put_string(fz_12);
	 end;
      end;
   
feature {NONE}   
   
   initialize is
      do
	 arguments := base_feature.arguments;
	 if arguments /= Void then
	    arguments := arguments.to_runnable(current_type);
	 end;
	 local_vars := base_feature.local_vars;
	 if local_vars /= Void then
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
      
   isa_in_line: BOOLEAN is
      do
	 if run_control.boost then
	    inspect 
	       in_line_status
	    when -1 then
	    when 0 then
	       Result := true;
               if us_copy = name.to_string then
		  in_line_status := -1;
		  Result := false;
	       elseif empty_or_null_body then
		  in_line_status := C_empty_or_null_body;
	       elseif do_not_use_current then
		  in_line_status := C_do_not_use_current;
	       elseif attribute_writer then
		  in_line_status := C_attribute_writer;
	       elseif direct_call then
		  in_line_status := C_direct_call;
		  -- *** UTILISER AUSSI isa_dca_inline ... pour la 
		  -- -0.85 
		  -- ****  IDEM DANS RUN_FEATURE_4
	       elseif dca then
		  in_line_status := C_dca;
	       elseif one_pc then
		  in_line_status := C_one_pc;
	       else
		  in_line_status := -1;
		  Result := false;
	       end;
	    else
	       Result := true;
	    end;
	 end;
      end;
   
   in_line is
      require
	 isa_in_line;
      local
	 flag: BOOLEAN;
	 a: ASSIGNMENT;
	 w: FEATURE_NAME;
	 e: EXPRESSION;
	 pc: PROC_CALL;
	 rf: RUN_FEATURE;
      do
	 cpp.put_string("/*[IRF3.");
	 cpp.put_integer(in_line_status);
	 cpp.put_string(name.to_string);
	 cpp.put_string(fz_close_c_comment);
	 inspect 
	    in_line_status 
	 when C_empty_or_null_body then
	    if cpp.cannot_drop_all then
	       cpp.put_string(fz_14);
	    end;
	    if need_local_vars then
	       cpp.put_character('{');
	       define_opening;
	       define_closing;
	       cpp.put_character('}');
	    end;
	 when C_do_not_use_current then
	    if cpp.target_cannot_be_dropped then
	       cpp.put_string(fz_14);
	    end;
	    flag := need_local_vars;
	    if flag then
	       cpp.put_character('{');
	       define_opening;
	    end;
	    routine_body.compile_to_c;
	    if flag then
	       define_closing;
	       cpp.put_character('}');
	    end;
	 when C_attribute_writer then
	    flag := need_local_vars;
	    if flag then
	       cpp.put_character('{');
	       define_opening;
	    end;
	    a ?= routine_body.first;
	    w ?= a.left_side;
	    w := w.name_in(current_type.base_class);
	    cpp.put_character('(');
	    cpp.put_character('(');
	    cpp.put_character('(');
	    current_type.mapping_cast;
	    cpp.put_character('(');
	    cpp.put_target_as_target;
	    cpp.put_string(fz_13);
	    cpp.put_string(fz_b5);
	    cpp.put_string(w.to_string);
	    cpp.put_character(')');
	    cpp.put_character('=');
	    cpp.put_character('(');
	    e := a.right_side;
	    if arguments = Void then
	       e.compile_to_c;
	    else
	       cpp.put_arguments;
	    end;	    
	    cpp.put_character(')');
	    cpp.put_string(fz_00);
	    if flag then
	       define_closing;
	       cpp.put_character('}');
	    end;
	 when C_direct_call then
	    flag := need_local_vars;
	    if flag then
	       cpp.put_character('{');
	       define_opening;
	    end;
	    pc ?= routine_body.first;
	    rf := pc.run_feature;
	    cpp.push_same_target(rf,pc.arguments);
	    rf.mapping_c;
	    cpp.pop;
	    if flag then
	       define_closing;
	       cpp.put_character('}');
	    end;
	 when C_dca then
	    pc ?= routine_body.first;
	    pc.finalize;
	    cpp.push_inline_dca(Current,pc);
	    pc.run_feature.mapping_c;
	    cpp.pop;
	 when C_one_pc then
	    if not use_current then
	       if cpp.target_cannot_be_dropped then 
		  cpp.put_string(fz_14);
	       end;
	    end;
	    cpp.put_character('{');
	    if use_current then
	       tmp_string.clear;
	       current_type.c_type_for_target_in(tmp_string);
	       tmp_string.extend(' ');
	       cpp.put_string(tmp_string);
	       cpp.inline_level_incr;
	       cpp.print_current;
	       cpp.inline_level_decr;
	       cpp.put_character('=');
	       cpp.put_target_as_target;
	       cpp.put_string(fz_00);
	    end;
	    if arguments /= Void then
	       arguments.inline_one_pc;
	    end;
	    if need_local_vars then
	       local_vars.inline_one_pc;
	       cpp.inline_level_incr;
	       local_vars.initialize_expanded;
	       cpp.inline_level_decr;
	    end;
	    cpp.push_inline_one_pc;
	    cpp.inline_level_incr;
	    routine_body.compile_to_c;
	    cpp.inline_level_decr;
	    cpp.pop;
	    cpp.put_character('}');
	 end;
	 cpp.put_string("/*]*/%N");
      end;

feature {NONE}

   compute_use_current is
      do
	 if current_type.is_reference and then run_control.no_check then
	    use_current_state := ucs_true;
	 else
	    std_compute_use_current;
	 end;
      end;

feature {NONE}

   empty_or_null_body: BOOLEAN is
	 -- The body is empty or has only unreacheable code.
      local
	 rb: COMPOUND;
      do
	 rb := routine_body;
	 Result := (rb = Void or else rb.empty_or_null_body);
      end;

   do_not_use_current: BOOLEAN is
      do
	 if not routine_body.use_current then
	    Result := arguments = Void;
	 end;
      end;
   
   attribute_writer: BOOLEAN is
	 -- True when body as only one instruction is of 
	 -- the form :  
	 --            feature_name := <expression>;
	 -- And when <expression> is an argument or a statically
	 -- computable value.
      local
	 rb: like routine_body;
	 a: ASSIGNMENT;
	 args: like arguments;
	 an2: ARGUMENT_NAME2;
	 wa: SIMPLE_FEATURE_NAME;
      do
	 rb := routine_body;
	 args := arguments;
	 if rb /= Void and then rb.count = 1 then
	    a ?= rb.first;
	    if a /= Void then
	       wa ?= a.left_side;
	       if wa /= Void then
		  if args = Void then
		     Result := not a.right_side.use_current;
		  elseif args.count = 1 then
		     an2 ?= a.right_side;
		     Result := an2 /= Void;
		  end;
	       end;
	    end;
	 end;
      end;

   direct_call: BOOLEAN is
	 -- True when the procedure has no arguments, no locals, 
	 -- and when the body has only one instruction of the 
	 -- form : foo(<args>);
	 -- Where <args> can be an empty list or a statically 
	 -- computable one and where `foo' is a RUN_FEATURE_3.
      local
	 rb: like routine_body;
	 pc: PROC_CALL;
	 args: EFFECTIVE_ARG_LIST;
	 rf3: RUN_FEATURE_3;
      do
	 rb := routine_body;
	 if rb /= Void and then
	    rb.count = 1 and then
	    arguments = Void and then 
	    local_vars = Void 
	  then
	    pc ?= rb.first;
	    if pc /= Void then
	       if pc.target.is_current then
		  rf3 ?= pc.run_feature;
		  if rf3 /= Void then
		     args := pc.arguments;
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
      local
	 pc: PROC_CALL;
	 rf: RUN_FEATURE;
	 args: EFFECTIVE_ARG_LIST;
      do
	 pc := body_one_dpca;
	 if pc /= Void and then local_vars = Void then
	    rf := pc.run_feature;
	    if rf /= Current then
	       args := pc.arguments;
	       if args = Void then
		  Result := arg_count = 0;
	       else
		  Result := args.isa_dca_inline(Current,rf);
	       end;
	    end;
	 end;
      end;

   one_pc: BOOLEAN is
      local
	 rb: like routine_body;
	 pc: PROC_CALL;
	 rf: RUN_FEATURE;
	 r: ARRAY[RUN_CLASS];
      do
	 rb := routine_body;
	 if rb /= Void and then rb.count = 1 then
	    pc ?= rb.first;
	    if pc /= Void then
	       rf := pc.run_feature;
	       if rf /= Void and then rf /= Current then
		  r := rf.run_class.running;
		  if r /= Void and then r.count = 1 then
		     Result := true;
		  end;
	       end;
	    end;
	 end;
      end;

   body_one_dpca: PROC_CALL is
	 -- Gives Void or the only one direct PROC_CALL on 
	 -- an attribute of Current target.
      local
	 rb: like routine_body;
	 pc: PROC_CALL;
	 c0c: CALL_0_C;
	 rf2: RUN_FEATURE_2;
	 r: ARRAY[RUN_CLASS];
      do
	 if local_vars = Void then
	    rb := routine_body;
	    if rb /= Void and then rb.count = 1 then
	       pc ?= rb.first;
	       if pc /= Void then
		  c0c ?= pc.target;
		  if c0c /= Void and then c0c.target.is_current then
		     rf2 ?= c0c.run_feature;
		     if rf2 /= Void then
			r := rf2.run_class.running;
			if r /= Void and then r.count = 1 then
			   r := pc.run_feature.run_class.running;
			   if r /= Void and then r.count = 1 then
			      Result := pc;
			   end;
			end;
		     end;
		  end;
	       end;
	    end;
	 end;
      end;

   need_local_vars: BOOLEAN is
      do
	 if local_vars /= Void then
	    Result := local_vars.produce_c;
	 end;
      end;

feature {NONE}

   tmp_string: STRING is
      once
	 !!Result.make(32);
      end;

feature {NONE}

   C_empty_or_null_body : INTEGER is 1;
   C_do_not_use_current : INTEGER is 2;
   C_attribute_writer   : INTEGER is 3;
   C_direct_call        : INTEGER is 4;
   C_dca                : INTEGER is 5;
   C_one_pc             : INTEGER is 6;
   
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
	 code_attribute.opcode_return;
	 method_info.finish;
      end;
   
feature {NONE}

   update_tmp_jvm_descriptor is
      do
	 routine_update_tmp_jvm_descriptor;
      end;

feature {SMALL_EIFFEL}

   do_not_inline is
      do
	 in_line_status := -1;
      end;

invariant
   
   result_type = Void;
   
end -- RUN_FEATURE_3

