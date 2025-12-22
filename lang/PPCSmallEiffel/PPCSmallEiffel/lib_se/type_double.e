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
class TYPE_DOUBLE
   --
   -- Handling of DOUBLE type mark.
   --
   
inherit 
   TYPE_BASIC_EIFFEL_EXPANDED
      redefine is_double 
      end;
   
creation make

feature

   is_double: BOOLEAN is true;
   
   id: INTEGER is 5;

feature 
   
   make(sp: like start_position) is
      do
	 !!base_class_name.make(us_double,sp);
      end;
   
   used_as_reference is
      once
	 load_ref(us_double_ref);
      end;

   space_for_variable, space_for_object: INTEGER is
      do
	 Result := (0.0).to_double.object_size;
      end;

   is_a(other: TYPE): BOOLEAN is
      do
	 if other.is_double then
	    Result := true;
	 else
	    Result := base_class.is_subclass_of(other.base_class);
	    if Result then
	       used_as_reference;
	    end;
	 end;
	 if not Result then
	    eh.add_type(Current,fz_inako);
	    eh.add_type(other,fz_dot);
	 end;
      end;

   smallest_ancestor(other: TYPE): TYPE is
      local
	 rto: TYPE;
      do
	 rto := other.run_type;
	 if rto.is_integer then 
	    Result := Current;
	 elseif rto.is_real then 
	    Result := Current;
	 elseif rto.is_double then 
	    Result := Current;
	 else
	    Result := type_double_ref.smallest_ancestor(rto);
	 end;
      end;
   
   to_runnable(rt: TYPE): like Current is
      do
	 Result := Current;
	 check_type;
      end;
   
   written_mark, run_time_mark: STRING is
      do
	 Result := us_double
      end;
   
   c_type_for_argument_in(str: STRING) is
      do
	 str.append(fz_double);
      end;
   
   cast_to_ref is
      do
	 type_double_ref.mapping_cast;
      end;

   jvm_descriptor_in(str: STRING) is
      do
	 str.extend('D');
      end;

   jvm_return_code is
      do
	 code_attribute.opcode_dreturn;
      end;

   jvm_push_local(offset: INTEGER) is
      do
	 code_attribute.opcode_dload(offset);
      end;

   jvm_push_default: INTEGER is
      do
	 code_attribute.opcode_dconst_0;
	 Result := 2;
      end;

   jvm_initialize_local(offset: INTEGER) is
      do
	 code_attribute.opcode_dconst_0;
	 jvm_write_local(offset);
      end;

   jvm_write_local(offset: INTEGER) is
      do
	 code_attribute.opcode_dstore(offset);
      end;

   jvm_xnewarray is
      do
	 code_attribute.opcode_newarray(7);
      end;

   jvm_xastore is
      do
	 code_attribute.opcode_dastore;
      end;

   jvm_xaload is
      do
	 code_attribute.opcode_daload;
      end;

   jvm_if_x_eq: INTEGER is
      local
	 ca: like code_attribute;
      do
	 ca := code_attribute;
	 ca.opcode_dcmpg;
	 Result := ca.opcode_ifeq;
      end;

   jvm_if_x_ne: INTEGER is
      local
	 ca: like code_attribute;
      do
	 ca := code_attribute;
	 ca.opcode_dcmpg;
	 Result := ca.opcode_ifne;
      end;

   jvm_to_reference is
      local
	 rc: RUN_CLASS;
	 idx: INTEGER;
	 ca: like code_attribute;
      do
	 ca := code_attribute;
	 rc := type_double_ref.run_class;
	 idx := rc.fully_qualified_constant_pool_index;
	 ca.opcode_new(idx);
	 ca.opcode_dup_x2;
	 ca.opcode_dup_x2;
	 ca.opcode_pop;
	 idx := constant_pool.idx_fieldref4(idx,us_item,fz_77);
	 ca.opcode_putfield(idx,-3);
      end;

   jvm_to_expanded: INTEGER is
      do
	 Result := 2;
      end;

   jvm_convert_to(destination: TYPE): INTEGER is
      do
	 if destination.is_reference then
	    jvm_to_reference;
	    Result := 1;
	 else
	    check
	       destination.is_double
	    end;
	    Result := 2;
	 end;
      end;

   to_reference is
      do
	 cpp.to_reference(Current,type_double_ref);
      end;

   to_expanded is
      do
	 cpp.to_expanded(type_double_ref,Current);
      end;
   
feature {NONE}
   
   check_type is
      -- Do some checking for type DOUBLE.
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
	       error(start_position,"DOUBLE must be expanded.");
	    end;
	 end;
      end;
   
invariant
   
   written_mark = us_double
      
end -- TYPE_DOUBLE

