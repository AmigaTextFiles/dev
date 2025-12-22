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
class TYPE_POINTER
   --   
   -- Handling special type POINTER.
   --
   
inherit TYPE_BASIC_EIFFEL_EXPANDED redefine is_pointer end;
   
creation make
   
feature 
   
   id: INTEGER is 8;

feature 
   
   make(sp: like start_position) is
      do
	 !!base_class_name.make(us_pointer,sp);
      end;
   
   is_pointer: BOOLEAN is true;

   smallest_ancestor(other: TYPE): TYPE is
      local
	 rto: TYPE;
      do
	 rto := other.run_type;
	 if rto.is_pointer then
	    Result := Current;
	 else
	    Result := type_pointer_ref.smallest_ancestor(rto);
	 end;
      end;
   
   is_a(other: TYPE): BOOLEAN is
      do
	 if other.is_pointer then
	    Result := true;
	 else
	    Result := base_class.is_subclass_of(other.base_class);
	    if Result then
	       used_as_reference;
	    end;
	 end;
	 if not Result then
	    eh.add_type(Current," does not match with ");
	    eh.add_type(other,fz_dot);
	 end;
      end;

   space_for_variable, space_for_object: INTEGER is
      do
	 Result := space_for_pointer;
      end;

   to_reference is
      do
	 cpp.to_reference(Current,type_pointer_ref);
      end;
   
   to_expanded is
      do
	 cpp.to_expanded(type_pointer_ref,Current);
      end;

   to_runnable(rt: TYPE): like Current is
      do
	 Result := Current;
	 check_type;
      end;
   
   written_mark, run_time_mark: STRING is
      do
	 Result := us_pointer;
      end;
   
   c_type_for_argument_in(str: STRING) is
      do
	 str.append(fz_void);
	 str.extend('*');
      end;

   cast_to_ref is
      do
	 type_pointer_ref.mapping_cast;
      end;

   mapping_c is
      do
	 cpp.put_string("T8");
      end;

   jvm_descriptor_in(str: STRING) is
      do
	 str.append(fz_21);
      end;

   jvm_return_code is
      do
	 code_attribute.opcode_areturn;
      end;

   jvm_push_local(offset: INTEGER) is
      do
	 code_attribute.opcode_aload(offset);
      end;

   jvm_push_default: INTEGER is
      do
	 code_attribute.opcode_aconst_null;
	 Result := 1;
      end;

   jvm_initialize_local(offset: INTEGER) is
      do
	 code_attribute.opcode_aconst_null;
	 jvm_write_local(offset);
      end;

   jvm_write_local(offset: INTEGER) is
      do
	 code_attribute.opcode_astore(offset);
      end;

   jvm_xnewarray is
      local
	 idx: INTEGER;
      do
	 idx := constant_pool.idx_java_lang_object;
	 code_attribute.opcode_anewarray(idx);
      end;

   jvm_xastore is
      do
	 code_attribute.opcode_aastore;
      end;

   jvm_xaload is
      do
	 code_attribute.opcode_aaload;
      end;

   jvm_if_x_eq: INTEGER is
      do
	 Result := code_attribute.opcode_if_acmpeq;
      end;

   jvm_if_x_ne: INTEGER is
      do
	 Result := code_attribute.opcode_if_acmpne;
      end;

   jvm_to_reference is
      local
	 rc: RUN_CLASS;
	 idx: INTEGER;
	 ca: like code_attribute;
      do
	 ca := code_attribute;
	 rc := type_pointer_ref.run_class;
	 idx := rc.fully_qualified_constant_pool_index;
	 ca.opcode_new(idx);
	 ca.opcode_dup_x1;
	 ca.opcode_swap;
	 idx := constant_pool.idx_fieldref4(idx,us_item,fz_21);
	 ca.opcode_putfield(idx,-2);
      end;

   jvm_to_expanded: INTEGER is
      do
	 Result := 1;
      end;

   jvm_convert_to(destination: TYPE): INTEGER is
      do
	 if destination.is_reference then
	    jvm_to_reference;
	 end;
	 Result := 1;
      end;

   used_as_reference is
      once
	 load_ref(us_pointer_ref);
      end;

feature {NONE}
   
   check_type is
      -- Do some checking for type POINTER to be runnable.
      local
	 bc: BASE_CLASS;
	 rc: RUN_CLASS;
      once
	 bc := base_class;
	 if nb_errors = 0 then
	    rc := run_class;
	 end;
	 if nb_errors = 0 then
	    if not bc.is_expanded then
	       error(start_position,"POINTER must be expanded.");
	    end;
	 end;
      end;

end -- TYPE_POINTER

