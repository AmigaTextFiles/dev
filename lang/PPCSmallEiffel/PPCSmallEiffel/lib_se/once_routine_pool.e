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
class ONCE_ROUTINE_POOL
   --
   -- Unique global object in charge of runnable once routines.
   --

inherit GLOBALS;

feature {NONE}
   
   procedure_list: FIXED_ARRAY[RUN_FEATURE_5] is
      once
	 !!Result.with_capacity(32);
      end;
   
   procedure_flag_list: FIXED_ARRAY[INTEGER];

   function_list: FIXED_ARRAY[RUN_FEATURE_6] is
      once
	 !!Result.with_capacity(32);
      end;
   
   function_flag_list: FIXED_ARRAY[INTEGER];

   flag_list: FIXED_ARRAY[INTEGER] is
      once
	 !!Result.with_capacity(32);
      end;

feature {RUN_FEATURE_5}

   add_procedure(rf5: RUN_FEATURE_5) is
      require
	 rf5 /= Void
      do
	 check
	    not procedure_list.has(rf5)
	 end;
	 procedure_list.add_last(rf5);
      end;
   
feature {RUN_FEATURE_6}

   add_function(rf6: RUN_FEATURE_6) is
      require
	 rf6 /= Void
      do
	 check
	    not function_list.has(rf6)
	 end;
	 function_list.add_last(rf6);
      end;
   
feature {GC_HANDLER}

   gc_mark_in(str: STRING) is
      local
	 i, id: INTEGER;
	 rf6: RUN_FEATURE_6;
	 t: TYPE;
      do
	 if function_list.count > 0 then
	    from
	       i := function_list.upper;
	    until
	       i < 0
	    loop
	       rf6 := function_list.item(i);
	       t := rf6.result_type;
	       if t.need_gc_mark_function then
		  id := t.id;
		  if t.is_reference then
		     str.append(fz_c_if_neq_null);
		     rf6.once_result_in(str);
		     str.extend(')');
		     str.append(fz_gc_mark);
		     id.append_in(str);
		     str.extend('(');
		     str.append(fz_cast_void_star);
		     rf6.once_result_in(str);
		     str.extend(')');
		  elseif t.is_user_expanded then
		  else
		  end;
		  str.append(fz_00);
	       end;
	       i := i - 1;
	    end;
	 end;

      end;

feature {JVM}

   fields_count: INTEGER;

   jvm_define_fields is
      local
	 byte_idx, idx_flag, i: INTEGER;
	 rf5: RUN_FEATURE_5;
	 rf6: RUN_FEATURE_6;
	 bf: E_FEATURE;
	 name_list: FIXED_ARRAY[INTEGER];
      do
	 !!name_list.with_capacity(fields_count);
	 if function_list.count > 0 then
	    from
	       i := function_list.upper;
	       byte_idx := constant_pool.idx_uft8(fz_41);
	    until
	       i < 0
	    loop
	       rf6 := function_list.item(i);
	       bf := rf6.base_feature;
	       idx_flag := idx_name_for_flag(bf);
	       if name_list.fast_has(idx_flag) then
	       else
		  name_list.add_last(idx_flag);
		  -- ---------- Static field for flag :
		  field_info.add(9,idx_flag,byte_idx);
		  -- ---------- Static field for result :
		  field_info.add(9,
				 idx_name_for_result(bf),
				 idx_descriptor(rf6.result_type.run_type));
	       end;
	       i := i - 1;
	    end;
	 end;
	 if procedure_list.count > 0 then
	    from
	       i := procedure_list.upper;
	       byte_idx := constant_pool.idx_uft8(fz_41);
	    until
	       i < 0
	    loop
	       rf5 := procedure_list.item(i);
	       bf := rf5.base_feature;
	       idx_flag := idx_name_for_flag(bf);
	       if name_list.fast_has(idx_flag) then
	       else
		  name_list.add_last(idx_flag);
		  -- ---------- Static field for flag :
		  field_info.add(9,idx_flag,byte_idx);
	       end;
	       i := i - 1;
	    end;
	 end;
      end;

   jvm_initialize_fields is
      local
	 i: INTEGER;
      do
	 if flag_list.count > 0 then
	    from
	       i := flag_list.upper;
	    until
	       i < 0
	    loop
	       -- Set once flag :
	       code_attribute.opcode_iconst_0;
	       code_attribute.opcode_putstatic(flag_list.item(i),-1);
	       i := i - 1;
	    end;
	 end;
      end;

feature {RUN_FEATURE_5,RUN_FEATURE_6}

   idx_fieldref_for_flag(rf: RUN_FEATURE): INTEGER is
      require
	 rf /= Void
      do
	 prepare_flag(rf.base_feature);
	 Result := constant_pool.idx_fieldref3(jvm_root_class,
					       flag_string,
					       fz_41);
      end;

feature {RUN_FEATURE_6}

   idx_fieldref_for_result(rf6: RUN_FEATURE_6): INTEGER is
      require
	 rf6 /= Void
      do
	 prepare_result(rf6.base_feature);
	 prepare_descriptor(rf6.result_type.run_type);
	 Result := constant_pool.idx_fieldref3(jvm_root_class,
					       result_string,
					       descriptor_string);
      end;


feature {NONE}

   idx_descriptor(rt: TYPE): INTEGER is
      require
	 rt /= Void
      do
	 prepare_descriptor(rt);
	 Result := constant_pool.idx_uft8(descriptor_string);
      end

   idx_name_for_result(bf: E_FEATURE): INTEGER is
      require
	 bf /= Void
      do
	 prepare_result(bf);
	 Result := constant_pool.idx_uft8(result_string);
      end

   idx_name_for_flag(bf: E_FEATURE): INTEGER is
      require
	 bf /= Void
      do
	 prepare_flag(bf);
	 Result := constant_pool.idx_uft8(flag_string);
      end

   flag_string: STRING is
      once
	 !!Result.make(32);
      end;

   prepare_flag(bf: E_FEATURE) is
      do
	 flag_string.clear;
	 flag_string.extend('f');
	 bf.base_class.id.append_in(flag_string);
	 flag_string.append(bf.first_name.to_key);
      end;

   result_string: STRING is
      once
	 !!Result.make(32);
      end;

   prepare_result(bf: E_FEATURE) is
      do
	 result_string.clear;
	 result_string.extend('r');
	 bf.base_class.id.append_in(result_string);
	 result_string.append(bf.first_name.to_key);
      end;

   prepare_descriptor(rt: TYPE) is
      do
	 descriptor_string.clear;
	 if rt.is_reference then
	    descriptor_string.append(jvm_root_descriptor)
	 else
	    rt.jvm_descriptor_in(descriptor_string)
	 end;	 
      end;

   descriptor_string: STRING is
      once
	 !!Result.make(32);
      end;

end -- ONCE_ROUTINE_POOL

