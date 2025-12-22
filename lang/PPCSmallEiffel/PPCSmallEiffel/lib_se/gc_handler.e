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
class GC_HANDLER
   -- 
   -- GARBAGE_COLLECTOR_HANDLER
   --

inherit GLOBALS;

creation make

feature

   is_on: BOOLEAN;
	 -- True when the Garbage Collector is produced.

   info_flag: BOOLEAN;
	 -- True when the Garbage Collector Info need to be printed.
   
feature {NONE}

   make is
      do
      end;

feature

   enable is
      do
	 is_on := true;
      end;
   
   set_info_flag is
      do
	 is_on := true;
	 info_flag := true;
      end;
   
feature {SMALL_EIFFEL}

   define1 is
      require
	 is_on
      local
	 i, j: INTEGER;
      do
	 cpp.swap_on_h;
	 echo.put_string("Adding Garbage Collector.%N");
	 cpp.put_string(
	    "#define GCFLAG_UNMARKED 1%N%
	    %#define GCFLAG_MARKED 2%N%
	    %typedef union u_gcfsh gcfsh;%N%
	    %union u_gcfsh {gcfsh*next;int flag;};%N%
	    %typedef struct s_gcnah gcnah;%N%
	    %struct s_gcnah{int size;%N%
	    %void(*mfp)(gcnah*);%N%
	    %union {gcnah*next;int flag;double padding;}header;%N%
	    %};%N%
	    %extern gcnah*nafl[];%N");
	 cpp.put_extern5("void**gc_root_main",fz_null);
	 cpp.put_extern5("void**gcmt_fs1",fz_null);
	 cpp.put_extern5("void**gcmt_fs2",fz_null);
	 cpp.put_extern5("void(**gcmt_fsf)(void*,void*)",fz_null);
	 cpp.put_extern5("int gcmt_fs_max","1023");
	 cpp.put_extern2("int gcmt_fs_used",'0');
	 cpp.put_extern5("gcnah**gcmt_na",fz_null);
	 cpp.put_extern5("int gcmt_na_max","1023");
	 cpp.put_extern2("int gcmt_na_used",'0');
	 cpp.swap_on_c;
	 from
	    cpp.put_string("gcnah*nafl[");
	    cpp.put_integer(nafl_size);
	    cpp.put_string("]={%NNULL,");
	    i := nafl_size - 2;
	    j := 7;
	 until
	    i = 0
	 loop
	    if j = 0 then
	       cpp.put_character('%N');
	       j := 7;
	    else
	       j := j - 1;
	    end;
	    cpp.put_string(fz_null);
	    cpp.put_character(',');
	    i := i - 1;
	 end;
	 cpp.put_string(fz_null);
	 cpp.put_character('}');
	 cpp.put_character(';');
	 cpp.put_character('%N');
	 cpp.swap_on_h;
	 if info_flag then
	    cpp.put_extern2("int gc_start_count",'0');
	 end;
      end;

   define2 is
      require
	 is_on
      local
	 i: INTEGER;
	 rc: RUN_CLASS;
	 rcd: DICTIONARY[RUN_CLASS,STRING];
      do
	 rcd := small_eiffel.run_class_dictionary;
	 cpp.put_c_function("void gc_mark_na(void*p)",
	    "gcnah*n=((gcnah*)p-1);%N%
	    %if(gcmt_na_used==0)return;%N%
	    %if(n<*gcmt_na)return;%N%
	    %if(gcmt_na[gcmt_na_used-1]<n)return;%N%
	    %{int i1=0;%N%
	    %int i2=gcmt_na_used-1;%N%
	    %int m=i2>>1;%N%
	    %for(;i1<i2;m=((i1+i2)>>1)){%N%
	    %if(gcmt_na[m]<n)i1=m+1;%N%
	    %else i2=m;}%N%
	    %if(n==gcmt_na[i2])(*(n->mfp))(n);%N%
	    %}");
	 cpp.put_c_function("void gc_mark(void*p)",
	    "if(p<=*gcmt_fs1){%N%
	    %gc_mark_na(p);%Nreturn;%N}%N%
	    %if(gcmt_fs2[gcmt_fs_used-1]<p){%N%
	    %gc_mark_na(p);%Nreturn;%N}%N%
	    %{int i1=0; int m;%N%
            %int i2=gcmt_fs_used-1;%N%
            %for(;i1<i2;){%N%
            %m=((i1+i2)>>1);%N%
            %if(gcmt_fs1[m]<=p)%Ni1=m+1;%Nelse%Ni2=m;%N}%N%
	    %if(p<gcmt_fs1[i2])%Ni2--;%N%
            %if(gcmt_fs2[i2]<p){%N%
	    %gc_mark_na(p);%Nreturn;%N}%N%
	    %if(p==gcmt_fs1[i2])return;%N%
	    %(*gcmt_fsf[i2])(p,gcmt_fs1[i2]);%N%
	    %}");
	 cpp.put_c_function("void gc_start(void)",
	    "jmp_buf env;%N%
            %(void)setjmp(env);%N%
            %gc_start_aux(((void**)&env));");
	 body.clear;
	 body.append( 
            "if(sp>gc_root_main){%N%
            %for(sp+=(sizeof(jmp_buf)/sizeof(void*));sp>=gc_root_main;sp--)%N%
            %gc_mark(*sp);}%N%
            %else {%N%
            %for(sp-=(sizeof(jmp_buf)/sizeof(void*));sp<=gc_root_main;sp++)%N%
            %gc_mark(*sp);}%N");
	 if info_flag then
	    body.append("gc_start_count++;%N");
	 end;
	 manifest_string_pool.gc_mark_in(body);
	 once_routine_pool.gc_mark_in(body);
	 call_gc_sweep(rcd);
	 body.append(
            "{int h;%N%
	    %gcnah**p=gcmt_na+gcmt_na_used-1;%N%
	    %gcnah*n;%N%
	    %for(;p>=gcmt_na;p--){%N%
	    %n=*p;%N%
	    %switch(n->header.flag){%N%
	    %case GCFLAG_MARKED:n->header.flag=GCFLAG_UNMARKED;%N%
	    %break;%N%
	    %case GCFLAG_UNMARKED:h=n->size&");
	 (nafl_size - 1).append_in(body);
	 body.append(
	    ";%N%
	    %n->header.next=nafl[h];%N%
	    %nafl[h]=n;%N%
	    %break;%N%
	    %}}}");
	 cpp.put_c_function("void gc_start_aux(void**sp)",body);
	 cpp.swap_on_h;
	 from   
	    i := 1;
	 until
	    i > rcd.count
	 loop
	    rc := rcd.item(i);
	    rc.gc_define1;
	    i := i + 1;
	 end;
	 cpp.swap_on_c;
	 from   
	    i := 1;
	 until
	    i > rcd.count
	 loop
	    rc := rcd.item(i);
	    rc.gc_define2;
	    i := i + 1;
	 end;
	 from   
	    i := run_class_list.upper;
	 until
	    i < 0
	 loop
	    switch_for(run_class_list.item(i));
	    i := i - 1;
	 end;
	 if info_flag then
	    define_gc_info(rcd);
	 end;
      end;

feature {TYPE}

   threshold_start(id: INTEGER): INTEGER is
      local
	 nb: INTEGER;
	 log2_nb: DOUBLE;
      do
	 Result := 9;
	 inspect
	    id
	 when 7,9 then
	    nb := manifest_string_pool.count;
	    if nb > 0 then
	       log2_nb := nb.log / (2).log;
	       nb := log2_nb.rounded + 2;
	       if nb > Result then
		  Result := nb;
	       end;
	    end;
	 else
	 end;
      end;

feature {TYPE_NATIVE_ARRAY}

   nafl_size: INTEGER is 2048;

feature {C_PRETTY_PRINTER}

   initialize is
	 -- Initializing inside main function.
      require
	 gc_handler.is_on
      local
	 i: INTEGER;
	 rc: RUN_CLASS;
	 rcd: DICTIONARY[RUN_CLASS,STRING];
      do
	 body.copy(
	    "gcmt_fs1=malloc((gcmt_fs_max+1)*sizeof(void*));%N%
	    %gcmt_fs2=malloc((gcmt_fs_max+1)*sizeof(void*));%N%
	    %gcmt_fsf=malloc((gcmt_fs_max+1)*sizeof(void*));%N%
	    %gcmt_na=malloc((gcmt_na_max+1)*sizeof(void*));%N");
	 cpp.put_string(body);
	 rcd := small_eiffel.run_class_dictionary;
	 from   
	    i := 1;
	 until
	    i > rcd.count
	 loop
	    rc := rcd.item(i);
	    rc.gc_initialize;
	    i := i + 1;
	 end;
      end;

feature {CREATION_CALL,C_PRETTY_PRINTER}   
   
   put_new(rc: RUN_CLASS) is
	 -- Basic allocation of in new temporary `n' local.
      require
	 rc.at_run_time;
	 rc.current_type.is_reference;
	 cpp.on_c
      local
	 ct: TYPE;
	 id: INTEGER;
      do
	 ct := rc.current_type;
	 id := rc.id;
	 body.clear;
	 body.extend('T');
	 id.append_in(body);
	 body.extend('*');
	 body.extend('n');
	 body.extend('=');
	 if is_on then
	    body.append(fz_new);
	    id.append_in(body);
	    body.extend('(');
	    body.extend(')');
	 elseif ct.need_c_struct then
	    body.append(us_malloc);
	    body.extend('(');
	    body.append(fz_sizeof);
	    body.extend('(');
	    body.extend('*');
	    body.extend('n');
	    body.extend(')');
	    body.extend(')');
	    body.append(fz_00);
	    body.extend('*');
	    body.extend('n');
	    body.extend('=');
	    body.extend('M');
	    id.append_in(body);
	 else
	    -- Object has no attributes :
	    body.append(us_malloc);
	    body.extend('(');
	    body.extend('1');
	    body.extend(')');
	 end;
	 body.append(fz_00);
	 cpp.put_string(body);
      end;

feature {RUN_CLASS}

   call_gc_mark(str: STRING; rf2: RUN_FEATURE_2) is
      require
	 str /= Void;
	 rf2.result_type.run_class.at_run_time
      local
	 rc: RUN_CLASS;
	 ct: TYPE;
	 field: STRING;
	 r: ARRAY[RUN_CLASS];
      do
	 ct := rf2.result_type;
	 if ct.need_gc_mark_function then
	    field := rf2.name.to_string;
	    if ct.is_expanded then
	       if ct.is_user_expanded then
		  str.append("RUN_CLASS : GARGGLLL");
	       else
		  str.append(fz_c_if_neq_null);
		  str.append("(o->_");
		  str.append(field);
		  str.append(fz_13);
		  ct.gc_mark_in(str);
		  str.append("(((gcnah*)(o->_");
		  str.append(field);
		  str.append("))-1);%N");
	       end;
	    else
	       rc := ct.run_class;
	       r := rc.running;
	       check
		  r.count >= 1
	       end;
	       str.append("if(NULL!=(o->_");
	       str.append(field);
	       str.append("))");
	       if r.count > 1 then
		  if not run_class_list.fast_has(rc) then
		     run_class_list.add_last(rc);
		  end;
		  str.extend('X');
		  ct.gc_mark_in(str);
	       else
		  r.first.current_type.gc_mark_in(str);
	       end;
	       str.append("(((void*)(o->_");
	       str.append(field);
	       str.append(")));%N");
	    end;
	 end;
      end;

feature {TYPE_NATIVE_ARRAY}

   native_array_mark(str: STRING; rc: RUN_CLASS) is
      local
	 ct: TYPE;
	 r: ARRAY[RUN_CLASS];
      do
	 ct := rc.current_type;
	 if ct.is_reference then
	    str.append("if(NULL!=o)")
	 end;
	 r := rc.running;
	 check
	    r.count >= 1;
	 end;
	 if r.count > 1 then
	    if not run_class_list.fast_has(rc) then
	       run_class_list.add_last(rc);
	    end;
	    str.extend('X');
	    ct.gc_mark_in(str);
	 else
	    r.first.current_type.gc_mark_in(str);
	 end;
	 str.extend('(');
	 if ct.is_expanded then
	    str.extend('&');
	 else
	    str.append(fz_cast_void_star);
	 end;
	 str.extend('o');
	 str.extend(')');
	 str.append(fz_00);
      end;
   
feature {NONE}

   run_class_list: FIXED_ARRAY[RUN_CLASS] is
      once
	 !!Result.with_capacity(32);
      end;

feature {NONE}

   switch_for(rc: RUN_CLASS) is
      local
	 ct: TYPE;
	 r: ARRAY[RUN_CLASS];
      do
	 header.clear;
	 header.append(fz_void);
	 header.extend(' ');
	 header.extend('X');
	 ct := rc.current_type;
	 ct.gc_mark_in(header);
	 header.extend('(');
	 header.append(fz_t0_star);
	 header.extend('o');
	 header.extend(')');
	 body.clear;
	 r := rc.running;
	 sort_running(r);
	 body.append("{int i=o->id;%N");
	 c_dicho(r,1,r.upper);
	 body.extend('}');
	 cpp.put_c_function(header,body);
      end;

feature {NONE}

   c_dicho(r: ARRAY[RUN_CLASS]; bi, bs: INTEGER) is
	 -- Produce dichotomic inspection code for Current id.
      require
	 bi <= bs
      local
	 m: INTEGER;
	 rc: RUN_CLASS;
      do
	 if bi = bs then
	    rc := r.item(bi);
	    rc.current_type.gc_mark_in(body);
	    body.extend('(');
	    body.extend('(');
	    body.extend('T');
	    rc.id.append_in(body);
	    body.extend('*');
	    body.extend(')');
	    body.extend('o');
	    body.extend(')');
	    body.append(fz_00);
	 else	    
	    m := (bi + bs) // 2;
	    rc := r.item(m);
	    body.append("if (i <= ");
	    rc.id.append_in(body);
	    body.append(") {%N");
	    c_dicho(r,bi,m);
	    body.append("} else {%N");
	    c_dicho(r,m + 1,bs);
	    body.extend('}');
	 end;
      end;

feature {NONE}

   call_gc_sweep(rcd: DICTIONARY[RUN_CLASS,STRING]) is
      require
	 is_on
      local
	 i: INTEGER;
	 rc: RUN_CLASS;
      do
	 from   
	    i := 1;
	 until
	    i > rcd.count
	 loop
	    rc := rcd.item(i);
	    rc.call_gc_sweep_in(body);
	    i := i + 1;
	 end;
      end;

feature {NONE}

   define_gc_info(rcd: DICTIONARY[RUN_CLASS,STRING]) is
      local
	 i: INTEGER;
	 rc: RUN_CLASS;
      do
	 header.clear;
	 header.append(fz_void);
	 header.extend(' ');
	 header.append(fz_gc_info);
	 header.append(fz_c_void_args);
	 body.clear;
	 from   
	    i := 1;
	 until
	    i > rcd.count
	 loop
	    rc := rcd.item(i);
	    rc.gc_info_in(body);
	    i := i + 1;
	 end;
	 body.append(
           "printf(%"gcmt_fs_used = %%d\n%",gcmt_fs_used);%N%
	   %printf(%"gcmt_fs_max = %%d\n%",gcmt_fs_max);%N%
           %printf(%"gcmt_na_used = %%d\n%",gcmt_na_used);%N%
	   %printf(%"gcmt_na_max = %%d\n%",gcmt_na_max);%N%
	   %printf(%"GC called %%d time(s)\n%",gc_start_count);%N");
	 cpp.put_c_function(header,body);
      end;

feature {NONE}

   header: STRING is
      once
	 !!Result.make(64);
      end;

   body: STRING is
      once
	 !!Result.make(512);
      end;

end -- GC_HANDLER

