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
class MANIFEST_STRING_POOL
   --
   -- Unique global object in charge of MANIFEST_STRING used.
   --

inherit GLOBALS;

feature {NONE}
   
   ms_list: FIXED_ARRAY[MANIFEST_STRING] is
      once
	 !!Result.with_capacity(2048);
      end;

   dummy_ms_list: FIXED_ARRAY[MANIFEST_STRING] is
      once
	 !!Result.with_capacity(16);
      end;

feature

   count: INTEGER is
      do
	 Result := ms_list.count;
      end;

feature {MANIFEST_STRING}

   add_last(ms: MANIFEST_STRING) is
      require
	 ms /= Void;
	 not small_eiffel.is_ready
      do
	 check
	    not ms_list.has(ms)
	 end;
	 ms_list.add_last(ms);
      end;
   
feature {C_PRETTY_PRINTER}

   used_for_inline(ms: MANIFEST_STRING) is
      do
	 dummy_ms_list.add_last(ms);
      end;

   define_se_ms is
      require
	 small_eiffel.string_at_run_time
      do
	 header.copy("T7*se_ms(int c,char*e)");
	 body.copy(fz_t7_star);
	 body.extend('s');
	 body.extend('=');
	 if gc_handler.is_on then
	    type_string.gc_call_new_in(body);
	    body.append(fz_00);
	 else
	    body.append("malloc(sizeof(T7));%N");
	    if type_string.run_class.is_tagged then
	       body.append("s->id=7;%N");
	    end;
	 end;
	 body.append(
	    "s->_count=c;%N%
	    %s->_capacity=c+1;%N%
	    %s->_storage=");
	 if gc_handler.is_on then
	    body.append(fz_new);
	    body.extend('9');
	 else
	    body.append(us_malloc);
	 end;
	 body.append(
            "(c+1);%N%
	    %memcpy(s->_storage,e,c);%N%
	    %return s;");
	 cpp.put_c_function(header,body);
	 --
	 cpp.put_c_function("T7*e2s(char*e)",
            "return se_ms(strlen(e),e);");
	 --
	 cpp.put_c_function("char*s2e(T7*s)",
	    "char*e=malloc(1+s->_count);%N%
	    %memcpy(e,s->_storage,s->_count);%N%
	    %e[s->_count]='\0';%N%
	    %return e;");
      end;
   
   c_define is
      require
	 cpp.on_c
      local
	 i, j, nb: INTEGER;
	 ms: MANIFEST_STRING;
      do
	 echo.print_count("Manifest String",ms_list.count);
	 from -- For *.h --
	    i := ms_list.upper;
	 until
	    i < 0
	 loop
	    ms := ms_list.item(i);
	    if not_dummy(ms) then
	       header.copy(fz_t7_star);
	       header.append(ms.mapping_c);
	       cpp.put_extern1(header);
	    end;
	    i := i - 1;
	 end;
	 from
	    i := ms_list.upper;
	    nb := 1;
	 until
	    i < 0
	 loop
	    header.copy(fz_void);
	    header.extend(' ');
	    header.append(fz_se_msi);
	    nb.append_in(header);
	    header.append(fz_c_void_args);
	    from 
	       body.clear;
	       j := nb_ms_per_function;
	    until
	       j = 0 or else i < 0
	    loop
	       ms := ms_list.item(i);
	       if not_dummy(ms) then
		  body.append(ms.mapping_c);
		  body.append("=se_ms(");
		  ms.count.append_in(body);
		  body.extend(',');
		  string_to_c_code(ms.to_string,body);
		  body.append(fz_14);
	       end;
	       j := j - 1;
	       i := i - 1;
	    end;
	    cpp.put_c_function(header,body);
	    nb := nb + 1;
	 end;
      ensure
	 cpp.on_c
      end;

   c_call_initialize is
      require
	 cpp.on_c
      local 
	 i, j, nb: INTEGER;
      do
	 from
	    i := ms_list.upper;
	    nb := 1;
	 until
	    i < 0
	 loop
	    cpp.put_string(fz_se_msi);
	    cpp.put_integer(nb);
	    cpp.put_string(fz_c_no_args_procedure);
	    i := i - nb_ms_per_function;
	    nb := nb + 1;
	 end;
      ensure
	 cpp.on_c
      end;

feature {GC_HANDLER}

   gc_mark_in(str: STRING) is
      local
	 i: INTEGER;
	 ms: MANIFEST_STRING;
      do
	 from
	    i := ms_list.upper;
	 until
	    i < 0
	 loop
	    ms := ms_list.item(i);
	    if not_dummy(ms) then
	       str.append(fz_gc_mark);
	       str.extend('7');
	       str.extend('(');
	       str.append(ms.mapping_c);
	       str.extend(')');
	       str.append(fz_00);
	    end;
	    i := i - 1;
	 end;
      end;

feature {JVM}

   jvm_define_fields is
      local
	 cp: like constant_pool;
	 ms: MANIFEST_STRING;
	 name_idx, string_idx, i: INTEGER;
      do
	 if not ms_list.empty then
	    cp := constant_pool;
	    string_idx := cp.idx_eiffel_string_descriptor;
	    from
	       i := ms_list.upper;
	    until
	       i < 0
	    loop
	       ms := ms_list.item(i);
	       if not_dummy(ms) then
		  name_idx := cp.idx_uft8(ms.mapping_c);
		  field_info.add(9,name_idx,string_idx);
	       end;
	       i := i - 1;
	    end;
	 end;
      end;

   jvm_initialize_fields is
      local
	 cp: like constant_pool;
	 ca: like code_attribute;
	 ms: MANIFEST_STRING;
	 i: INTEGER;
      do
	 if not ms_list.empty then
	    cp := constant_pool;
	    ca := code_attribute;
	    from
	       i := ms_list.upper;
	    until
	       i < 0
	    loop
	       ms := ms_list.item(i);
	       if not_dummy(ms) then
		  ca.opcode_push_manifest_string(ms.to_string);
		  ca.opcode_putstatic(ms.fieldref_idx,-1);
	       end;
	       i := i - 1;
	    end;
	 end;
      end;

feature {C_PRETTY_PRINTER}

   string_to_c_code(s: STRING; c_code: STRING) is
      local
	 i: INTEGER;
      do
	 c_code.extend('%"');
	 from  
	    i := 1;
	 until
	    i > s.count
	 loop
	    character_to_c_code(s.item(i),c_code);
	    i := i + 1;
	 end;
	 c_code.extend('%"');
      end;
   
   character_to_c_code(c: CHARACTER; c_code: STRING) is
      do
	 if c = '%N' then
	    c_code.extend('\');
	    c_code.extend('n');
	 elseif c = '\' then
	    c_code.extend('\');
	    c_code.extend('\');
	 elseif c = '%"' then
	    c_code.extend('\');
	    c_code.extend('%"');
	 elseif c = '%'' then
	    c_code.extend('\');
	    c_code.extend('%'');
	 elseif c.code < 32 or else 122 < c.code then
	    c_code.extend('\');
	    c.code.to_octal.append_in(c_code);
	    c_code.extend('%"');
	    c_code.extend('%"');
	 else
	    c_code.extend(c);
	 end;
      end;
   

feature {NONE}

   not_dummy(ms: MANIFEST_STRING): BOOLEAN is
      do
	 Result := not dummy_ms_list.fast_has(ms);
      end;
   
   header: STRING is
      once
	 !!Result.make(32);
      end;

   body: STRING is
      once
	 !!Result.make(512);
      end;

   fz_se_msi: STRING is "se_msi";

   nb_ms_per_function: INTEGER is 20;

end -- MANIFEST_STRING_POOL

