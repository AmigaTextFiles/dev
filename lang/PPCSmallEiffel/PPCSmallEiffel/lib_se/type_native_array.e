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
class TYPE_NATIVE_ARRAY

inherit TYPE redefine generic_list end;

creation make 

creation {TYPE_NATIVE_ARRAY} make_runnable

feature

   base_class_name: CLASS_NAME;
   
   generic_list: ARRAY[TYPE];
   
   written_mark: STRING;
   
   run_type: like Current;
	 -- Not Void when runnable.

feature

   is_expanded: BOOLEAN is true;

   is_reference: BOOLEAN is false;

   is_generic: BOOLEAN is true;

   is_basic_eiffel_expanded: BOOLEAN is false;

   is_dummy_expanded: BOOLEAN is false;

   is_user_expanded: BOOLEAN is false;

feature {NONE}
      
   make(sp: like start_position; of_what: TYPE) is
      require
	 sp /= Void;
	 of_what /= Void
      do
	 !!base_class_name.make(us_native_array,sp);
	 generic_list := <<of_what>>;
	 tmp_str.copy(us_native_array);
	 tmp_str.extend('[');
	 tmp_str.append(of_what.written_mark);
	 tmp_str.extend(']');
	 written_mark := unique_string.item(tmp_str);
      ensure
	 start_position = sp
      end;

   make_runnable(sp: like start_position; of_what: TYPE) is
      require
	 sp /= Void;
	 of_what.run_type = of_what
      do
	 make(sp,of_what);
	 run_type := Current;
      ensure
	 is_run_type;
	 written_mark = run_time_mark
      end;

feature

   smallest_ancestor(other: TYPE): TYPE is
      local
	 rto: TYPE;
      do
	 rto := other.run_type;
	 if rto.is_a(run_type) then
	    Result := rto;
	 elseif run_type.is_a(rto) then
	    Result := run_type;
	 else
	    Result := type_any;
	 end;
	 eh.cancel;
      end;

   run_time_mark: STRING is
      do
	 if is_run_type then
	    Result := run_type.written_mark;
	 end;
      end;

   is_run_type: BOOLEAN is
      local
	 t: TYPE;
      do
	 if run_type /= Void then
	    Result := true;
	 else
	    t := generic_list.item(1);
	    if t.is_run_type and then t.run_type = t then
	       run_type := Current;
	       load_basic_features;	 
	       Result := true;
	    end;
	 end;
      end;

   to_runnable(ct: TYPE): like Current is 
      local
	 elt1, elt2: TYPE;
	 rt: like Current;
	 rc: RUN_CLASS;
      do
	 if run_type = Current then
	    Result := Current;
	 else
	    elt1 := generic_list.item(1);
	    elt2 := elt1.to_runnable(ct);
	    if elt2 = Void or else not elt2.is_run_type then
	       if elt2 /= Void then
		  eh.add_position(elt2.start_position);
	       end;
	       error(elt1.start_position,fz_bga);
	    end;
	    if nb_errors = 0 then
	       elt2 := elt2.run_type;
	       if run_type = Void then
		  Result := Current;
		  if elt2 = elt1 then
		     run_type := Current;
		     load_basic_features;	 
		  else
		     !!run_type.make_runnable(start_position,elt2);
		     run_type.load_basic_features;
		  end;
	       else
		  Result := twin;
		  !!rt.make_runnable(start_position,elt2);
		  Result.set_run_type(rt);
		  rt.load_basic_features;
	       end;	       
	    end;
	 end;
	 -- Access `run_class' :
-- ***	 rc := Result.generic_list.item(1).run_class;
-- *** REMOVE OR NOT ???
	 rc := Result.run_class;
	 rc.set_at_run_time;
      end;
   
   expanded_initializer: RUN_FEATURE_3 is
      do
      end;

   start_position: POSITION is
      do
	 Result := base_class_name.start_position;
      end;

   is_a(other: TYPE): BOOLEAN is
      do
	 -- Because of VNCE :
	 Result := run_time_mark = other.run_time_mark;
	 if not Result then
	    eh.add_type(Current,fz_inako);
	    eh.add_type(other,fz_dot);
	 end;
      end;

   has_creation(fn: FEATURE_NAME): BOOLEAN is
      do
      end;

   id: INTEGER is
      do
	 Result := run_class.id;
      end;

   run_class: RUN_CLASS is
      do
	 if is_run_type then
	    Result := small_eiffel.run_class(run_type);
	 end;
      end;

   space_for_variable, space_for_object: INTEGER is
      do
	 Result := space_for_pointer;
      end;

feature -- For C ANSI :

   c_header_pass1 is
      do
      end;

   c_header_pass2 is
      local
	 elt_type: TYPE;
      do
	 elt_type := generic_list.item(1).run_type;
	 tmp_string.copy(fz_typedef);
	 c_type_in(tmp_string);
	 tmp_string.extend('T');
	 id.append_in(tmp_string);
	 tmp_string.append(fz_00);
	 cpp.put_string(tmp_string);
      end;

   c_header_pass3 is
      do
      end;

   c_header_pass4 is
      do
      end;

   need_c_struct: BOOLEAN is
      do
      end;

   c_initialize is
      do
	 cpp.put_string(fz_null);
      end;

   c_initialize_in(str: STRING) is
      do
	 str.append(fz_null);
      end;

   c_type_for_argument_in(str: STRING) is
      do 
	 str.extend('T');
	 id.append_in(str);
      end;

   c_type_for_target_in(str: STRING) is
      do
	 c_type_for_argument_in(str);
      end;

   c_type_for_result_in(str: STRING) is
      do
	 c_type_for_argument_in(str);
      end;

feature -- For Java byte code :

   jvm_method_flags: INTEGER is 9;

   jvm_target_descriptor_in, jvm_descriptor_in(str: STRING) is
      do
	 str.extend('[');
	 generic_list.item(1).jvm_descriptor_in(str);
      end;

   jvm_return_code is
      do
	 code_attribute.opcode_areturn;
      end;

   jvm_push_local(offset: INTEGER) is
      do
	 code_attribute.opcode_aload(offset);
      end;

   jvm_check_class_invariant is
      do
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
      do
      end;

   jvm_to_expanded: INTEGER is
      do
	 Result := 1;
      end;

   jvm_convert_to(destination: TYPE): INTEGER is
      do
	 Result := 1;
      end;

feature {RUN_CLASS,TYPE}

   need_gc_mark_function: BOOLEAN is true;

   call_gc_sweep_in(str: STRING) is
      do
      end;

   gc_info_in(str: STRING) is
      do
	 -- Print gc_info_nbXXX :
	 str.append(fz_printf);
	 str.extend('(');
	 str.extend('%"');
	 str.append(run_time_mark);
	 str.append(fz_10);
	 gc_info_nb_in(str);
	 str.append(fz_14);
      end;

   gc_define1 is
      local
	 rc: RUN_CLASS;
	 rcid: INTEGER;
      do
	 rc := run_class;
	 rcid := rc.id;
	 -- -------------------------------- Declare gc_info_nbXXX :
	 if gc_handler.info_flag then
	    tmp_string.copy(fz_int);
	    tmp_string.extend(' ');
	    gc_info_nb_in(tmp_string);
	    cpp.put_extern2(tmp_string,'0');
	 end;
      end;

   gc_define2 is
      local
	 elt_type: TYPE;
	 elt_rc: RUN_CLASS;
	 rcid: INTEGER;
      do
	 elt_type := generic_list.item(1);
	 elt_rc := elt_type.run_class;
	 rcid := run_class.id;
	 -- ----------------------------- Definiton for gc_markXXX :
	 header.copy(fz_void);
	 header.extend(' ');
	 gc_mark_in(header);
	 header.append("(gcnah*h)");
	 body.clear;
	 gc_if_unmarked_in(body);
	 gc_set_marked_in(body);
	 if elt_type.is_reference or else elt_rc.gc_mark_to_follow then
	    body.extend('{');
	    c_type_in(body);
	    body.remove_last(1);
	    body.extend(' ');
	    body.extend('o');
	    body.append(fz_00);
	    c_type_in(body);
	    body.append("p1=((void*)(h+1));%N");
	    c_type_in(body);
	    body.append(
               "p2=p1+((((h->size)-sizeof(gcnah))/sizeof(o))-1);%N%
	       %for(;p2>=p1;p2--){%N%
	       %o=*p2;%N");
	    gc_handler.native_array_mark(body,elt_rc);
	    body.extend('}');
	    body.extend('}');
	 end;
	 body.extend('}');
	 cpp.put_c_function(header,body);
	 -- --------------------------------- Definiton for newXXX :
	 header.clear;
	 header.extend('T');
	 rcid.append_in(header);
	 header.extend(' ');
	 header.append(fz_new);
	 rcid.append_in(header);
	 header.extend('(');
	 header.append(fz_int);
	 header.extend(' ');
	 header.extend('n');
	 header.extend(')');
	 body.copy(
            "gcnah*r;%N%
	    %int i;%N%
	    %int s=((n*sizeof(T");
	 if elt_type.is_reference then
	    body.extend('0');
	    body.extend('*');
	 else
	    elt_type.id.append_in(body);
	 end;
	 body.append(
            "))+sizeof(gcnah));%N");
	 if gc_handler.info_flag then
            gc_info_nb_in(body);
            body.append("++;%N");
         end;
	 body.append("i=s&");
	 (gc_handler.nafl_size - 1).append_in(body);
	 body.append(
	    ";%N%
	    %r=nafl[i];%N%
	    %if(r!=NULL){%N%
	    %if(r->size==s)%N%
	    %nafl[i]=r->header.next;%N%
	    %else{%N%
	    %gcnah*p = r;%N%
	    %r = r->header.next;%N%
	    %while(r!=NULL){%N%
	    %if(r->size==s){%N%
	    %p->header.next=r->header.next;%N%
	    %break;}%N%
	    %p = r;%N%
	    %r = r->header.next;%N%
	    %}}}%N%
	    %if(r==NULL){%N%
	    %r=malloc(s);%N%
	    %r->size=s;%N%
	    %if(gcmt_na_used++==gcmt_na_max){%N%
	    %gcmt_na_max<<=1;%N%
	    %gcmt_na=realloc(gcmt_na,(gcmt_na_max+1)*sizeof(void*));%N%
	    %}%N%
	    %for(i=gcmt_na_used-2;%
	    %(i>=0)&&(gcmt_na[i]>r);%
	    %i--){%N%
	    %gcmt_na[i+1]=gcmt_na[i];%N%
	    %}%N%
	    %gcmt_na[++i]=r;%N");
	 body.append(
	    "}%N%
	    %((void)memset(r+1,0,s-sizeof(gcnah)));%N%
	    %(r->header.flag)=GCFLAG_UNMARKED;%N%
	    %(r->mfp)=");
	 gc_mark_in(body);
	 body.append(
            ";%N%
	    %return((void*)(r+1));");
	 cpp.put_c_function(header,body);
      end;

   gc_initialize is
      do
      end;

feature {TYPE_NATIVE_ARRAY}
   
   set_run_type(t: like run_type) is
      do
	 run_type := t;
      end;

   load_basic_features is
	 -- Force some basic feature to be loaded.
      require
	 run_type = Current
      local
	 elt_type: TYPE;
	 rf: RUN_FEATURE;
	 rc: RUN_CLASS;
      do
	 rc := run_class;
	 rc.set_at_run_time;
	 elt_type := generic_list.item(1);
	 if elt_type.is_expanded then
	    elt_type.run_class.set_at_run_time;
	 end;
	 rf := rc.get_feature_with(us_item);
	 rf := rc.get_feature_with(us_put);
	 if elt_type.expanded_initializer /= Void then
	    rf := rc.get_feature_with(us_clear_all);
	 end;
      end;

feature {NONE}
   
   c_type_in(str: STRING) is
      local
	 elt_type: TYPE;
      do
	 elt_type := generic_list.item(1);
	 str.extend('T');
	 if elt_type.is_reference then
	    str.extend('0');
	    str.extend('*');
	 else
	    elt_type.id.append_in(str);
	 end;
	 str.extend('*');
      end;
	 
   tmp_str: STRING is
      once
	 !!Result.make(32);
      end;

feature {TYPE}

   frozen short_hook is
      do
	 short_print.a_class_name(base_class_name);
	 short_print.hook_or("open_sb","[");
	 generic_list.first.short_hook;
	 short_print.hook_or("close_sb","]");
      end;
        
end -- TYPE_NATIVE_ARRAY

