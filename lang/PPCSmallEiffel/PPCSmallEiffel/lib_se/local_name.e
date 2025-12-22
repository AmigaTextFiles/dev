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
deferred class LOCAL_NAME
   --
   -- Handling of local variables.
   --

inherit LOCAL_ARGUMENT;

feature

   is_writable: BOOLEAN is true;
   
   isa_dca_inline_argument: INTEGER is 0;
	 -- A voir ....

   dca_inline_argument(formal_arg_type: TYPE) is
	 -- *** FAIRE ***
      do
      end;

   frozen mapping_c_target(target_type: TYPE) is
      local
	 flag: BOOLEAN;
	 rt: like result_type;
      do
	 flag := cpp.call_invariant_start(target_type);
	 rt := result_type.run_type;
	 if rt.is_reference then
	    if target_type.is_reference then
	       -- Reference into Reference :
	       cpp.put_character('(');
	       cpp.put_character('(');
	       cpp.put_character('T');
	       cpp.put_integer(target_type.id);
	       cpp.put_character('*');
	       cpp.put_character(')');
	       compile_to_c;
	       cpp.put_character(')');
	    else
	       -- Reference into Expanded :
	       rt.to_expanded;
	       cpp.put_character('(');
	       compile_to_c;
	       cpp.put_character(')');
	    end;
	 elseif target_type.is_reference then
	    -- Expanded into Reference :
	    rt.to_reference;
	    cpp.put_character('(');
	    compile_to_c;
	    cpp.put_character(')');
	 else
	    -- Expanded into Expanded :
	    if rt.need_c_struct then
	       cpp.put_character('&');
	    end;
	    compile_to_c;
	 end;
	 if flag then
	    cpp.call_invariant_end;
	 end;
      end;

   frozen mapping_c_arg(formal_arg_type: TYPE) is
      local
	 rt: like result_type;
      do
	 rt := result_type.run_type;
	 if rt.is_reference then
	    if formal_arg_type.is_reference then
	       -- Reference into Reference :
	       compile_to_c;
	    else
	       -- Reference into Expanded :
	       rt.to_expanded;
	       cpp.put_character('(');
	       compile_to_c;
	       cpp.put_character(')');
	    end;
	 elseif formal_arg_type.is_reference then
	    -- Expanded into Reference :
	    rt.to_reference;
	    cpp.put_character('(');
	    compile_to_c;
	    cpp.put_character(')');
	 else
	    -- Expanded into Expanded :
	    if rt.need_c_struct then
	       cpp.put_character('&');
	    end;
	    compile_to_c;
	 end;
      end;

   compile_to_c is
	 -- Using a local.
      do
	 cpp.print_local(to_string);
      end;
   
feature

   compile_to_jvm is
      local
	 jvm_offset: INTEGER;
      do
	 jvm_offset := jvm.local_offset_of(Current);
	 result_type.run_type.jvm_push_local(jvm_offset);
      end;
   
   compile_to_jvm_assignment(a: ASSIGNMENT) is
      local
	 space, jvm_offset: INTEGER;
      do
	 jvm_offset := jvm.local_offset_of(Current);
	 space := a.right_side.compile_to_jvm_into(result_type.run_type);
	 result_type.run_type.jvm_write_local(jvm_offset);
      end;
   
   jvm_branch_if_false: INTEGER is
      do
	 compile_to_jvm;
	 Result := code_attribute.opcode_ifeq;
      end;

   jvm_branch_if_true: INTEGER is
      do
	 compile_to_jvm;
	 Result := code_attribute.opcode_ifne;
      end;

   compile_to_jvm_into(dest: TYPE): INTEGER is
      do
	 Result := standard_compile_to_jvm_into(dest);
      end;

feature {DECLARATION_LIST}

   name_clash is
      local
	 rc: RUN_CLASS;
	 rf: RUN_FEATURE;
      do
	 if base_class_written.has_feature(to_string) then
	    rc := current_type.run_class;
	    rf := rc.get_feature_with(to_string)
	    if rf /= Void then
	       eh.add_position(rf.start_position);
	    end;
	    eh.add_position(start_position);
	    fatal_error("Conflict between local/feature name (VRLE).");
	 end;
      end;
   
feature {NONE}

   tmp_string: STRING is
      once
	 !!Result.make(256);
      end;

feature {CREATION_CALL,EXPRESSION_WITH_COMMENT}
      
   jvm_assign is
      local
	 jvm_offset: INTEGER;
      do
	 jvm_offset := jvm.local_offset_of(Current);
	 result_type.run_type.jvm_write_local(jvm_offset);
      end;

end -- LOCAL_NAME

