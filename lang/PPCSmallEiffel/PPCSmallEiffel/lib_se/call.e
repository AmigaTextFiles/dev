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
deferred class CALL
--
-- For all sort of feature calls with result value.
-- So it does not include procedure calls (see PROC_CALL).
--
-- Classification: CALL_0 when 0 argument, CALL_1 when 
-- 1 argument and CALL_N when N arguments.
--

inherit 
   CALL_PROC_CALL
      undefine fill_tagged_out_memory
      end;
   EXPRESSION;      

feature  
   
   result_type: TYPE;
	 -- When checked, the result_type of the call.
   
feature  

   is_static: BOOLEAN is
      deferred
      end;

   frozen call_is_static: BOOLEAN is
      local
	 rc: RUN_CLASS;
	 running: ARRAY[RUN_CLASS];
	 rf: like run_feature;
      do
	 if run_feature /= Void then
	    rc := run_feature.run_class;
	    if rc /= Void then
	       running := rc.running;
	       if running /= Void and then running.count = 1 then
		  rf := running.first.dynamic(run_feature);
		  if rf.is_static then
		     static_value_mem := rf.static_value_mem;
		     Result := true;
		  end;
	       end;
	    end;
	 end;
      end;

   frozen mapping_c_target(target_type: TYPE) is
      local
	 flag: BOOLEAN;
	 actual_type: like result_type;
      do
	 flag := cpp.call_invariant_start(target_type);
	 actual_type := result_type.run_type;
	 if actual_type.is_reference then
	    if target_type.is_reference then
	       -- Reference into Reference :
	       cpp.put_character('(');
	       cpp.put_character('(');
	       cpp.put_character('T');
	       cpp.put_integer(target_type.id);
	       cpp.put_character('*');
	       cpp.put_character(')');
	       cpp.put_character('(');
	       compile_to_c;
	       cpp.put_character(')');
	       cpp.put_character(')');
	    else
	       -- Reference into Expanded :
	       actual_type.to_expanded;
	       cpp.put_character('(');
	       compile_to_c;
	       cpp.put_character(')');
	    end;
	 else
	    if target_type.is_reference then
	       -- Expanded into Reference :
	       actual_type.to_reference;
	       cpp.put_character('(');
	       compile_to_c;
	       cpp.put_character(')');
	    else
	       -- Expanded into Expanded :
	       if target_type.need_c_struct then
		  cpp.put_character('&');
		  cpp.put_character('(');
		  compile_to_c;
		  cpp.put_character(')');
	       else
		  compile_to_c;
	       end;
	    end;
	 end;
	 if flag then
	    cpp.call_invariant_end;
	 end;
      end;

   frozen mapping_c_arg(formal_arg_type: TYPE) is
      local
	 actual_type: like result_type;
      do
	 actual_type := result_type.run_type;
	 if actual_type.is_reference then
	    if formal_arg_type.is_reference then
	       -- Reference into Reference :
	       compile_to_c;
	    else
	       -- Reference into Expanded :
	       actual_type.to_expanded;
	       cpp.put_character('(');
	       compile_to_c;
	       cpp.put_character(')');
	    end;
	 else
	    if formal_arg_type.is_reference then
	       -- Expanded into Reference :
	       actual_type.to_reference;
	       cpp.put_character('(');
	       compile_to_c;
	       cpp.put_character(')');
	    else
	       -- Expanded into Expanded :
	       if formal_arg_type.need_c_struct then
		  cpp.put_character('&');
		  cpp.put_character('(');
		  compile_to_c;
		  cpp.put_character(')');
	       else
		  compile_to_c;
	       end;
	    end;
	 end;
      end;

   compile_to_c is
      do
	 call_proc_call_c2c;
      end;
   
   frozen compile_to_c_old is
      do
	 target.compile_to_c_old;
	 if arg_count > 0 then
	    arguments.compile_to_c_old;
	 end;
      end;
   
   frozen compile_to_jvm_old is
      do
	 target.compile_to_jvm_old;
	 if arg_count > 0 then
	    arguments.compile_to_jvm_old;
	 end;
      end;
   
   precedence: INTEGER is
      do
	 Result := dot_precedence;
      end;
   
   frozen c_simple: BOOLEAN is do end;
   
   print_as_target is
      do
	 pretty_print;
	 fmt.put_character('.');
      end;
   
   frozen compile_target_to_jvm is
      do
	 standard_compile_target_to_jvm;
      end;

   frozen compile_to_jvm_assignment(a: ASSIGNMENT) is
      do
      end;

   frozen compile_to_jvm_into(dest: TYPE): INTEGER is
      do
	 Result := standard_compile_to_jvm_into(dest);
      end;
   
feature {NONE}
   
   frozen to_runnable_0(ct: TYPE) is
      require
	 ct /= Void;
	 current_type = Void
      do
	 current_type := ct;
	 cpc_to_runnable(ct);
	 result_type := run_feature.result_type;
	 if result_type = Void then
	    eh.add_position(run_feature.start_position);
	    error(feature_name.start_position,
		  "Feature found has no result.");
	 elseif result_type.is_like_current then
	    result_type := target.result_type;
	 end;
      ensure
	 current_type = ct;
      end;
   
feature {CREATION_CALL,EXPRESSION_WITH_COMMENT}
      
   jvm_assign is
      do
      end;

end -- CALL

