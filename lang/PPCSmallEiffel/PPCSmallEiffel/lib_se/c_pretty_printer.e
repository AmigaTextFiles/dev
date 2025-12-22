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
class C_PRETTY_PRINTER
   --
   -- Handling of C code pretty printing.
   -- Also known as `cpp'.
   --
   
inherit CODE_PRINTER;
   
creation make

feature

feature {NONE}
   
   out_c: STD_FILE_WRITE is
	 -- The current *.c output file.
      once
	 !!Result.make;
      end;
   
   out_h: STD_FILE_WRITE;
	 -- The *.h output file.
   
   current_out: STD_FILE_WRITE;
	 -- Is `out_c' or `out_h'.
   
   out_make: STD_FILE_WRITE is
	 -- The *.make output file.
      once
	 !!Result.make;
      end;
   
feature 
   
   make is do end;

feature    
   
   get_started is
      require
	 small_eiffel.is_ready
      local
	 no_check: BOOLEAN;
	 body: STRING;
      do
	 echo.file_removing(path_make);
	 no_check := run_control.no_check;
	 top := -1;
	 backup_sfw_connect(out_c,path_c);
	 current_out := out_c;
	 add_first_include;
	 !!out_h.make;
	 sfw_connect(out_h,path_h);
	 current_out := out_h;
	 put_banner(out_h);
	 -- Global struct :
	 out_h.put_string(
            "%N%
	    %#include <stdio.h>%N%
	    %#include <string.h>%N%
	    %#include <math.h>%N%
	    %#include <stdlib.h>%N%
	    %#include <signal.h>%N%
	    %#include <stddef.h>%N%
	    %#include <stdarg.h>%N%
	    %#include <limits.h>%N%
	    %#include <float.h>%N%
	    %#include <setjmp.h>%N%
	    %#include <sys/types.h>%N%
	    %#include <sys/stat.h>%N%
	    %#include <fcntl.h>%N%
	    %#ifndef O_RDONLY%N%
	    %#include <sys/file.h>%N%
	    %#endif%N%
	    %#ifndef O_RDONLY%N%
	    %#define O_RDONLY 0000%N%
	    %#endif%N%
	    %typedef struct S0 T0;%N%
	    %struct S0{int id;};%N");
	 cdef_id(us_integer,2);
	 cdef_id(us_character,3);
	 cdef_id(us_real,4);
	 cdef_id(us_double,5);
	 cdef_id(us_boolean,6);
	 cdef_id(us_pointer,8);
	 cdef_id(fz_expanded,10);
	 cdef_id("REF",11);
	 cdef_id("LINK",12);
	 cdef_id("FTAG",13);
	 cdef_id("NAME",14);
	 cdef_id("COLUMN",15);
	 cdef_id("LINE",16);
	 cdef_id("PATH",17);
	 cdef_id("DOING",18);
	 cdef_id("INV",19);
	 cdef_id(us_bit,20);
	 if no_check then
	    put_extern3("tag_pos_1","assignment");
	    put_extern3("tag_pos_2","boolean exp.");
	    put_extern3("tag_pos_3","instruction");
	    put_extern3("tag_pos_4","assertion");
	    put_extern3("tag_pos_5","creation call");
	    put_extern3("tag_pos_6","variant exp.");
	    put_extern3(us_current,us_current);
	    put_extern3(us_result,us_result);
	    put_extern1("double*rs_bot");
	    put_extern1("double*rs");
	    put_extern1("double*rs_lb");
	    put_extern1("double*rs_top");
	    put_c_function("void se_rsg(int sz)",
	       "if(rs+sz<rs_top)return;%N%
	       %{int osz=(rs_top-rs_bot+1);%N%
               %int nsz;%N%
               %double*nrs_bot;%N%
               %int msz=262144;%N%
               %nsz=osz*2;%N%
               %nrs_bot=(void*)malloc(nsz*sizeof(double));%N%
               %if((osz>msz)||(nrs_bot==NULL)){%N%
               %printf(%"Stack Overflow (limit = %%d).\n%",msz);%N%
               %rsp();if(!se_rspf)exit(0);}%N%
               %((void)memcpy(nrs_bot,rs_bot,osz*sizeof(double)));%N%
               %rs_lb=nrs_bot+(rs_lb-rs_bot);%N%
               %rs=nrs_bot+(rs-rs_bot);%N%
               %rs_top=nrs_bot+(nsz-1);%N%
               %free(rs_bot);%N%
               %rs_bot=nrs_bot;%N%
               %return;}");
	    put_c_function("void rs_link(char*tag)",
	       "se_rsg(1024);%N%
	       %*((int*)rs++)=LINKid;%N%
	       %*((int*)rs)=(rs-rs_lb);%N%
	       %rs_lb=rs++;%N%
	       %*((int*)rs++)=FTAGid;%N%
	       %*((char**)rs++)=tag;");
	    put_c_function("void rs_unlink(void)",
	       "rs=rs_lb-1;%N%
	       %rs_lb=rs_lb-(*((int*)rs_lb));");
	    body :=
 	       "*((int*)rs++)=LINEid;%N%
	       %*((int*)rs++)=l;%N%
	       %*((int*)rs++)=COLUMNid;%N%
	       %*((int*)rs++)=c;%N%
	       %*((int*)rs++)=PATHid;%N%
	       %*((int*)rs++)=f;%N%
	       %*((int*)rs++)=DOINGid;%N%
	       %*((char**)rs++)=tp;";
	    if run_control.trace then
	       body.append(
               "if (se_trace_flag){%N%
	       %fprintf(se_trace_file,%"line %%d column %%d in %
               %%%s\n%",l,c,p[f]);%N%
               %fflush(se_trace_file);}");
	    end;
	    put_c_function("void rs_pPOS(char* tp,int l,int c,int f)",
			   body);
	    put_c_function("int rs_pop_int(int e)",
	       "rs-=8;%N%
	       %return e;");
	    put_c_function("void rs_pINT(int*i,char*n)",
	       "*((int*)rs++)=NAMEid;%N%
	       %*((char**)rs++)=n;%N%
	       %*((int*)rs++)=INTEGERid;%N%
	       %*((int**)rs++)=i;");
	    put_c_function("void rs_pCHA(char*c,char*n)",
	       "*((int*)rs++)=NAMEid;%N%
	       %*((char**)rs++)=n;%N%
	       %*((int*)rs++)=CHARACTERid;%N%
	       %*((char**)rs++)=c;");
	    put_c_function("void rs_pBOO(int*b,char*n)",
	       "*((int*)rs++)=NAMEid;%N%
	       %*((char**)rs++)=n;%N%
	       %*((int*)rs++)=BOOLEANid;%N%
	       %*((int**)rs++)=b;");
	    put_c_function("void rs_pREA(float*r,char*n)",
	       "*((int*)rs++)=NAMEid;%N%
	       %*((char**)rs++)=n;%N%
	       %*((int*)rs++)=REALid;%N%
	       %*((float**)rs++)=r;");
	    put_c_function("void rs_pDOU(double*d,char*n)",
	       "*((int*)rs++)=NAMEid;%N%
	       %*((char**)rs++)=n;%N%
	       %*((int*)rs++)=DOUBLEid;%N%
	       %*((double**)rs++)=d;");
	    put_c_function("void rs_pPOI(void*p,char*n)",
	       "*((int*)rs++)=NAMEid;%N%
	       %*((char**)rs++)=n;%N%
	       %*((int*)rs++)=POINTERid;%N%
	       %*((void**)rs++)=p;");
	    put_c_function("void rs_pBIT(void*p,char*n)",
	       "*((int*)rs++)=NAMEid;%N%
	       %*((char**)rs++)=n;%N%
	       %*((int*)rs++)=BITid;%N%
	       %*((void**)rs++)=p;");
	    put_c_function("void rs_pREF(void**r,char*n)",
	       "*((int*)rs++)=NAMEid;%N%
	       %*((char**)rs++)=n;%N%
	       %*((int*)rs++)=REFid;%N%
	       %*((void***)rs++)=r;");
	    put_c_function("void rs_pEXP(void*e,char*n)",
	       "*((int*)rs++)=NAMEid;%N%
	       %*((char**)rs++)=n;%N%
	       %*((int*)rs++)=expandedid;%N%
	       %*((void**)rs++)=e;");
	    put_extern2("int se_af",'0');
	    put_extern2("int se_rspf",'0');
	    put_extern1("int se_af_rlc");
	    put_extern1("int se_af_rlr");
	 end;
	 if run_control.require_check then
	    put_c_function("void ac_req(int v)",
	       "if (!v && se_af_rlc)%N% 
	       %error0(%"Require Assertion Violated.%");%N%
	       %se_af_rlr=se_af_rlr&&v;%N%
	       %rs-=8;");
	 end;
	 if run_control.ensure_check then
	    put_c_function("void ac_ens(int v)",
	       "if (!v) error0(%"Ensure Assertion Violated.%");%N%
	       %rs-=8;");
	 end;
	 if run_control.invariant_check then
	    put_c_function("void ac_inv(int v)",
	       "if (!v) error0(%"Class Invariant Violation.%");%N%
	       %rs-=8;");
	    put_c_function("int se_rciaux(double* sp)",
	       "if((*((char**)sp))!=Current) return 0;%
               %sp++; if((*((int*)sp))!=REFid) return 0;%
	       %return 1;");
	    put_c_function("int se_rci(void*C)",
	       "double*lb=rs_lb;%N%
               %double*sp;%N%
	       %if(se_af)return 0;%N%
	       %if(se_rspf)return 0;%N%
               %while(1){%N%
               %if(lb==rs_bot)return 0;%N%
	       %sp=lb+4;%N%
               %if(se_rciaux(sp)){%N%
               %sp+=2;%N%
               %if((**((void***)sp))==C)break;}%N%
	       %lb=lb-(*((int*)lb));}%N%
               %while(1){%N%
	       %lb=lb-(*((int*)lb));%N%
               %if(lb==rs_bot)return 1;%N%
	       %sp=lb+4;%N%
               %if(se_rciaux(sp)){%N%
               %sp+=2;%N%
               %if((**((void***)sp))==C)return 0;}}");
	 end;
	 if run_control.loop_check then
	    put_c_function("void ac_liv(int v)",
	       "if (!v) error0(%"Loop Invariant Violation.%");%N%
	       %rs-=8;");
	    put_c_function("int lvc(int lc,int lv1,int lv2)",
	       "if (lc==0){if (lv2 < 0){%N% 
	       %rsp();%N%
	       %printf(%"Bad First Variant Value = %%d\n%",lv2);}%N%
	       %else {rs-=8;return lv2;}}%N%
	       %else if ((lv2 < 0)||(lv2 >= lv1)){%N% 
	       %rsp();%N%
	       %printf(%"Loop Body Count = %%d (done)\n%
	       %New Variant = %%d\n%
	       %Previous Variant = %%d\n%",lc,lv2,lv1);}%N%
	       %else {rs-=8;return lv2;}%N%
	       %printf(%"*** Error at Run Time *** : Bad Loop Variant.\n%");%N%
	       %if(!se_rspf)exit(1);");
	 end;
	 if run_control.all_check then
	    put_c_function("void ac_civ(int v)",
	       "if (!v) error0(%"Check Assertion Violated.%");%N%
	       %rs-=8;");
	 end;
	 current_out := out_c;
      ensure
	 on_c
      end;
   
   swap_on_c is
      do
	 current_out := out_c;
      ensure
	 on_c;
      end;
   
   swap_on_h is
      do
	 current_out := out_h;
      ensure
	 on_h;
      end;
   
   on_h: BOOLEAN is
      require
	 small_eiffel.is_ready
      do
	 Result := current_out = out_h;
      end;
   
   on_c: BOOLEAN is
      require
	 small_eiffel.is_ready
      do
	 Result := current_out = out_c;
      end;
   
feature {SWITCH_COLLECTION}

   incr_elt_c_count(i: INTEGER) is
      do
	 check
	    out_c.is_connected;
	 end;
	 if no_split then
	 else
	    elt_c_count := elt_c_count + i;
	    if elt_c_count > elt_c_count_max then
	       elt_c_count := 0;
	       out_c.put_character('%N');
	       out_c.disconnect;
	       split_count := split_count + 1;
	       path_c_copy_in(path_c,split_count);
	       backup_sfw_connect(out_c,path_c);
	       add_first_include;
	       if current_out /= out_h then
		  current_out := out_c;
	       end;
	    end;
	 end;
      end;

feature -- Printing C code :
   
   put_extern1(decl: STRING) is
      do
	 incr_elt_c_count(1);
	 out_h.put_string(fz_extern);
	 out_h.put_string(decl);
	 out_h.put_string(fz_00);
	 out_c.put_string(decl);
	 out_c.put_string(fz_00);
      end;
   
   put_extern2(decl: STRING; init: CHARACTER) is
      do
	 incr_elt_c_count(1);
	 out_h.put_string(fz_extern);
	 out_h.put_string(decl);
	 out_h.put_string(fz_00);
	 out_c.put_string(decl);
	 out_c.put_character('=');
	 out_c.put_character(init);
	 out_c.put_string(fz_00);
      end;
   
   put_extern3(var, value: STRING) is
      do
	 incr_elt_c_count(1);
	 out_c.put_string("char ");
	 out_c.put_string(var);
	 out_c.put_string("[]=%"");
	 out_c.put_string(value);
	 out_c.put_string("%";%N");
	 out_h.put_string("extern char ");
	 out_h.put_string(var);
	 out_h.put_character('[');
	 out_h.put_character(']');
	 out_h.put_string(fz_00);
      end;
   
   put_extern4(t, var: STRING; value: INTEGER) is
      do
	 incr_elt_c_count(1);
	 out_c.put_string(t);
	 out_c.put_character(' ');
	 out_c.put_string(var);
	 out_c.put_character('[');
	 out_c.put_integer(value);
	 out_c.put_string("];%N");
	 out_h.put_string(fz_extern);
	 out_h.put_string(t);
	 out_h.put_character(' ');
	 out_h.put_string(var);
	 out_h.put_character('[');
	 out_h.put_character(']');
	 out_h.put_string(fz_00);
      end;
   
   put_extern5(decl: STRING; init: STRING) is
      do
	 incr_elt_c_count(1);
	 out_h.put_string(fz_extern);
	 out_h.put_string(decl);
	 out_h.put_string(fz_00);
	 out_c.put_string(decl);
	 out_c.put_character('=');
	 out_c.put_string(init);
	 out_c.put_string(fz_00);
      end;
   
   put_c_heading(heading: STRING) is
      do
	 incr_elt_c_count(15);
	 out_h.put_string(heading);
	 out_h.put_string(fz_00);
	 out_c.put_string(heading);
	 out_c.put_string(fz_11);
      end;
   
   put_c_function(heading, body:STRING) is
      require
	 not heading.empty;
	 not body.empty
      do
	 incr_elt_c_count(15);
	 put_c_heading(heading);
	 out_c.put_string(body);
	 out_c.put_string(fz_12);
      end;
   
   put_string(c: STRING) is
      require
	 small_eiffel.is_ready
      do
	 current_out.put_string(c);
      end;
   
   put_string_c(s: STRING) is
      require
	 small_eiffel.is_ready;
	 on_c
      do
	 tmp_string.clear;
	 manifest_string_pool.string_to_c_code(s,tmp_string);
	 out_c.put_string(tmp_string);
      end;
   
   put_character(c: CHARACTER) is
      require
	 small_eiffel.is_ready
      do
	 current_out.put_character(c);
      end;
   
   put_integer(i: INTEGER) is
      require
	 small_eiffel.is_ready
      do
	 current_out.put_integer(i);
      end;
   
   put_real(r: REAL) is
      require
	 small_eiffel.is_ready
      do
	 current_out.put_real(r);
      end;
   
   put_position(p: POSITION) is
      require
	 small_eiffel.is_ready
      do
	 if p = Void then
	    put_string("0,0,0");
	 else
	    put_integer(p.line);
	    put_character(',');
	    put_integer(p.column);
	    put_character(',');
	    put_integer(p.base_class.id);
	 end;
      end;
   
   put_target_as_target is
	 -- Produce C code to pass the current stacked target as
	 -- a target of a new call : user expanded are passed with
	 -- a pointer and class invariant code is produced.
      require
	 small_eiffel.is_ready
      local
	 code: INTEGER;
	 rf: RUN_FEATURE;
	 target: EXPRESSION;
	 args: EFFECTIVE_ARG_LIST;
	 tt: TYPE;
	 ivt_flag: BOOLEAN;
      do
	 code := stack_code.item(top); 
	 inspect
	    code
	 when C_direct_call then 
	    target := stack_target.item(top);
	    tt := stack_rf.item(top).current_type;
	    target.mapping_c_target(tt);
	 when C_check_id then 
	    target := stack_target.item(top);
	    rf := stack_rf.item(top);
	    tt := rf.current_type;
	    check 
	       tt.is_reference; 
	    end;
	    if run_control.boost then
	       target.mapping_c_target(tt);
	    else
	       ivt_flag := call_invariant_start(tt);
	       check_id(target,rf.id);
	       if ivt_flag then
		  call_invariant_end;
	       end;
	    end;
	 when C_inline_dca then 
	    put_character('(');
	    stack_rf.item(top).current_type.mapping_cast;
	    put_character('(');
	    put_target_as_value;
	    put_string(fz_13);
	 when C_same_target then 
	    rf := stack_rf.item(top);
	    args := stack_args.item(top);
	    top := top - 1;
	    put_target_as_target;
	    top := top + 1;
	    stack_code.put(code,top);
	    stack_rf.put(rf,top);
	    stack_args.put(args,top);
	 else
	    common_put_target;
	 end;
      end;
   
   put_target_as_value is
	 -- Produce C code for a simple access to the stacked target.
	 -- User's expanded values are not given using a pointer.
	 -- There is no C code to check the class invariant.
      require
	 small_eiffel.is_ready
      local
	 code: INTEGER;
	 rf, static_rf: RUN_FEATURE;
	 target: EXPRESSION;
	 args: EFFECTIVE_ARG_LIST;
	 c0c: CALL_0_C;
	 direct_rf: RUN_FEATURE;
      do
	 code := stack_code.item(top);
	 inspect
	    code
	 when C_direct_call then 
	    stack_target.item(top).compile_to_c;
	 when C_check_id then 
	    stack_rf.item(top).current_type.mapping_cast;
	    stack_target.item(top).compile_to_c;
	 when C_inline_dca then 
	    rf := stack_rf.item(top);
	    target := stack_target.item(top);
	    args := stack_args.item(top);
	    static_rf := stack_static_rf.item(top);
	    top := top - 1;
	    c0c ?= target;
	    direct_rf := c0c.run_feature;
	    direct_rf.mapping_c;
	    top := top + 1;
	    stack_code.put(code,top);
	    stack_rf.put(rf,top);
	    stack_target.put(target,top);
	    stack_args.put(args,top);
	    stack_static_rf.put(static_rf,top);
	 when C_same_target then 
	    rf := stack_rf.item(top);
	    args := stack_args.item(top);
	    top := top - 1;
	    put_target_as_value;
	    top := top + 1;
	    stack_code.put(code,top);
	    stack_rf.put(rf,top);
	    stack_args.put(args,top);
	 else
	    common_put_target;
	 end;
      end;
   
   target_cannot_be_dropped: BOOLEAN is
	 -- True when top target cannot be dropped because we are 
	 -- not sure that target is non Void or that target has 
	 -- no side effects. When Result is true, printed 
	 -- C code is : "(((void)(<target>))"
      require
	 small_eiffel.is_ready
      do
	 inspect
	    stack_code.item(top)
	 when C_direct_call, C_check_id then
	    Result := not stack_target.item(top).can_be_dropped;
	 when C_inline_dca then
	    Result := true;
	 when C_same_target then 
	    top := top - 1;
	    Result := target_cannot_be_dropped;
	    top := top + 1;
	 else
	 end;
	 if Result then
	    put_string("((/*UT*/(void)(");
	    put_target_as_target;
	    put_string(fz_13);
	 end;
      end;

   arguments_cannot_be_dropped: BOOLEAN is
	 -- True when arguments cannot be dropped.
	 -- Printed C code is like :
	 --  "(((void)<exp1>),((void)<exp2>),...((void)<expN>)"
      do
	 if not no_args_to_eval then
	    Result := true;
	    put_string("((/*UA*/(void)(");
	    put_arguments;
	    put_string(fz_13);
	 end;
      end;

   cannot_drop_all: BOOLEAN is
	 -- Result is true when something (target or one argument)
	 -- cannot be dropped. Thus when something cannot be dropped,
	 -- Result is true and C code is printed : 
	 --  "(((void)<exp1>),((void)<exp2>),...((void)<expN>)"
      do
	 if target_cannot_be_dropped then
	    Result := true;
	    put_character(',');
	    if arguments_cannot_be_dropped then
	       put_character(')');
	    else
	       put_character('0');
	    end;
	 else
	    Result := arguments_cannot_be_dropped;
	 end;
      end;

   no_args_to_eval: BOOLEAN is
	 -- True if there is no C code to produce to eval arguments.
	 -- For example because there are  no arguments or because
	 -- we are inside a switching function for example.
      require
	 small_eiffel.is_ready
      local
	 code: INTEGER;
	 args: EFFECTIVE_ARG_LIST;
      do
	 code := stack_code.item(top);
	 inspect 
	    code
	 when C_direct_call, 
              C_check_id, 
              C_inside_new,
	      C_same_target
	  then
	    args := stack_args.item(top);
	    if args = Void then
	       Result := true;
	    else
	       Result := args.can_be_dropped;
	    end;
	 when C_inline_dca then
	    top := top - 1;
	    Result := no_args_to_eval;
	    top := top + 1;
	 else
	    Result := true;
	 end;
      end;

   put_arguments is
      -- Produce code to access effective arguments list.
      require
	 small_eiffel.is_ready
      local
	 code: INTEGER;
	 rf, static_rf: RUN_FEATURE;
	 target: EXPRESSION;
	 args: EFFECTIVE_ARG_LIST;
	 fal: FORMAL_ARG_LIST;
	 switch: SWITCH;
      do
	 code := stack_code.item(top);
	 inspect 
	    code
	 when C_expanded_initialize then
	 when C_inside_twin then
	    put_ith_argument(1);
	 when C_direct_call then
	    fal := stack_rf.item(top).arguments;
	    stack_args.item(top).compile_to_c(fal);
	 when C_check_id then
	    fal := stack_rf.item(top).arguments;
	    stack_args.item(top).compile_to_c(fal);
	 when C_switch then
	    fal := stack_rf.item(top).arguments;
	    static_rf := stack_static_rf.item(top);
	    switch.put_arguments(static_rf,fal);
	 when C_inside_new then
	    fal := stack_rf.item(top).arguments;
	    stack_args.item(top).compile_to_c(fal);
	 when C_inline_dca then
	    rf := stack_rf.item(top);
	    target := stack_target.item(top);
	    args := stack_args.item(top);
	    static_rf := stack_static_rf.item(top);
	    top := top - 1;
	    args.dca_inline(rf.arguments);
	    top := top + 1;
	    stack_code.put(code,top);
	    stack_rf.put(rf,top);
	    stack_target.put(target,top);
	    stack_args.put(args,top);
	    stack_static_rf.put(static_rf,top);
	 when C_same_target then
	    fal := stack_rf.item(top).arguments;
	    stack_args.item(top).compile_to_c(fal);
	 when C_inline_one_pc then
	 end;
      end;
   
   put_ith_argument(index: INTEGER) is
      -- Produce code to access to the ith argument.
      require
	 small_eiffel.is_ready
	 index >= 1
      local
	 code: INTEGER;
	 rf, static_rf: RUN_FEATURE;
	 target: EXPRESSION;
	 args: EFFECTIVE_ARG_LIST;
	 fal: FORMAL_ARG_LIST;
	 switch: SWITCH;
      do
	 code := stack_code.item(top);
	 inspect 
	    code
	 when C_direct_call then
	    fal := stack_rf.item(top).arguments;
	    stack_args.item(top).compile_to_c_ith(fal,index);
	 when C_check_id then
	    fal := stack_rf.item(top).arguments;
	    stack_args.item(top).compile_to_c_ith(fal,index);
	 when C_switch then
	    fal := stack_rf.item(top).arguments;
	    static_rf := stack_static_rf.item(top);
	    switch.put_ith_argument(static_rf,fal,index);
	 when C_inside_new then
	    fal := stack_rf.item(top).arguments;
	    stack_args.item(top).compile_to_c_ith(fal,index);
	 when C_inline_dca then
	    rf := stack_rf.item(top);
	    target := stack_target.item(top);
	    args := stack_args.item(top);
	    static_rf := stack_static_rf.item(top);
	    top := top - 1;
	    if rf /= Void then
	       args.dca_inline_ith(rf.arguments,index);
	    else
	       -- No rf for "=" and "/=".
	       args.dca_inline_ith(static_rf.arguments,index);
	    end;
	    top := top + 1;
	    stack_code.put(code,top);
	    stack_rf.put(rf,top);
	    stack_target.put(target,top);
	    stack_args.put(args,top);
	    stack_static_rf.put(static_rf,top);
	 when C_same_target then
	    fal := stack_rf.item(top).arguments;
	    stack_args.item(top).compile_to_c_ith(fal,index);
	 when C_inline_one_pc then
	    print_argument(index);
	 when C_inside_twin then
	    check
	       index = 1
	    end;
	    if stack_rf.item(top).current_type.is_reference then
	       put_string("((T0*)C)");
	    else
	       put_string("*C");
	    end;
	 end;
      end;
   
feature {NATIVE_SMALL_EIFFEL}

   put_c_inline_h is
      local
	 c_code: MANIFEST_STRING;
      do
	 c_code := get_inline_ms;
	 if c_inline_h_mem.has(c_code) then
	 else
	    c_inline_h_mem.add_last(c_code);
	    out_h.put_string(c_code.to_string);
	    out_h.put_character('%N');
	 end;
      end;

   put_c_inline_c is
      local
	 c_code: MANIFEST_STRING;
      do
	 c_code := get_inline_ms;
	 out_c.put_string(c_code.to_string);
      end;

   put_trace_switch is
      do
	 if run_control.trace then
	    put_string("se_trace_flag=(");
	    put_ith_argument(1);
	    put_string(fz_14);
	 end;
      end;

feature {NATIVE_SMALL_EIFFEL}

   put_generating_type(t: TYPE) is 
      local
	 rc: RUN_CLASS;
      do
	 generator_used := true;
	 generating_type_used := true;
	 put_string(fz_cast_t0_star);
	 put_character('(');
	 put_character('t');
	 put_character('[');
	 if t.is_reference then
	    rc := t.run_class;
	    if rc.is_tagged then
	       put_character('(');
	       put_target_as_value;
	       put_character(')');
	       put_string(fz_arrow_id);
	    else
	       put_integer(rc.id);
	    end;
	 else
	    put_integer(t.id);
	 end;
	 put_character(']');
	 put_character(')');
      end;

   put_generator(t: TYPE) is 
      require
	 t.is_run_type;
      local
	 rc: RUN_CLASS;
      do
	 generator_used := true;
	 put_string(fz_cast_t0_star);
	 put_character('(');
	 put_character('g');
	 put_character('[');
	 if t.is_reference then
	    rc := t.run_class;
	    if rc.is_tagged then
	       put_character('(');
	       put_target_as_value;
	       put_character(')');
	       put_string(fz_arrow_id);
	    else
	       put_integer(rc.id);
	    end;
	 else
	    put_integer(t.id);
	 end;
	 put_character(']');
	 put_character(')');
      end;   
   
   put_to_pointer is 
      do
	 put_string("((void*)");
	 put_target_as_value;
	 put_character(')');
      end;

   put_object_size(t: TYPE) is 
      require
	 t.is_run_type;
      local
	 tcbd: BOOLEAN;
      do
	 tcbd := target_cannot_be_dropped;
	 if tcbd then
	    out_c.put_character(',');
	 end;
	 out_c.put_string("sizeof(T");
	 out_c.put_integer(t.id);
	 out_c.put_character(')');
	 if tcbd then
	    out_c.put_character(')');
	 end;
      end;   
   
feature {NONE}

   c_inline_h_mem: FIXED_ARRAY[MANIFEST_STRING] is
      once
	 !!Result.with_capacity(4);
      end;

feature {SMALL_EIFFEL}

   cecil_define is
      local
	 save_out_h: like out_h;
      do
	 cecil_pool.c_define_internals;
	 save_out_h := out_h;
	 cecil_pool.c_define_users;
	 out_h := save_out_h;
      end;

feature {CECIL_POOL}

   connect_cecil_out_h(user_path_h: STRING) is
      require
	 out_h = Void
      do
	 !!out_h.make;
	 sfw_connect(out_h,user_path_h);
      end;

   disconnect_cecil_out_h is
      do
	 out_h.disconnect;
      end;

feature {TYPE}
   
   to_reference(src, dest: TYPE) is
	 -- Put the name of the corresponding conversion 
	 -- fonction. Memorize arguments for later definition 
	 -- of the function.
      require
	 small_eiffel.is_ready;
	 src.is_expanded;
	 dest.is_reference;
      local
	 src_rc, dest_rc: RUN_CLASS;
      do
	 src_rc := src.run_class;
	 dest_rc := dest.run_class;
	 check
	    src_rc.at_run_time;
	    dest_rc.at_run_time;
	 end;
	 if to_reference_mem = Void then
	    to_reference_mem := <<src_rc,dest_rc>>;
	 elseif not to_reference_mem.fast_has(src_rc) then
	    to_reference_mem.add_last(src_rc);
	    to_reference_mem.add_last(dest_rc);
	 end;
	 tmp_string.clear;
	 conversion_name(dest_rc.id);
	 put_string(tmp_string);
      end;

   to_expanded(src, dest: TYPE) is
	 -- Put the name of the corresponding conversion 
	 -- fonction. Memorize arguments for later definition 
	 -- of the function.
      require
	 small_eiffel.is_ready;
	 src.is_reference;
	 dest.is_expanded;
      local
	 src_rc, dest_rc: RUN_CLASS;
      do
	 src_rc := src.run_class;
	 dest_rc := dest.run_class;
	 check
	    src_rc.at_run_time;
	    dest_rc.at_run_time;
	 end;
	 if to_expanded_mem = Void then
	    to_expanded_mem := <<src_rc,dest_rc>>;
	 elseif not to_expanded_mem.fast_has(src_rc) then
	    to_expanded_mem.add_last(src_rc);
	    to_expanded_mem.add_last(dest_rc);
	 end;
	 tmp_string.clear;
	 conversion_name(dest_rc.id);
	 put_string(tmp_string);
      end;
   
feature {NONE} -- Automatic Type Conversion stuff :
   
   to_expanded_mem, to_reference_mem: ARRAY[RUN_CLASS];
      
   conversion_name(dest_id: INTEGER) is
      do
	 tmp_string.append(fz_to_t);
	 dest_id.append_in(tmp_string);
      end; 
   
   define_to_reference is 
      local
	 i: INTEGER;
	 src_rc, dest_rc: RUN_CLASS;
	 src_type, dest_type: TYPE;
      do
	 from
	    i := 1;
	 until
	    i > to_reference_mem.upper
	 loop
	    src_rc := to_reference_mem.item(i);
	    i := i + 1;
	    dest_rc := to_reference_mem.item(i);
	    i := i + 1;
	    src_type := src_rc.current_type;
	    dest_type := dest_rc.current_type;
	    echo.put_string(msg2);
	    echo.put_string(src_type.run_time_mark);
	    echo.put_string(" to ");
	    echo.put_string(dest_type.run_time_mark);
	    echo.put_string(msg1);
	    tmp_string.copy(fz_t0_star);
	    conversion_name(dest_rc.id);
	    tmp_string.extend('(');
	    src_type.c_type_for_target_in(tmp_string);
	    tmp_string.append(" s)");
	    put_c_heading(tmp_string);
	    swap_on_c;
	    tmp_string.clear;
	    dest_type.c_type_for_target_in(tmp_string);
	    tmp_string.append("d;%Nd=((void*)malloc(sizeof(*d)));%N");
	    if dest_rc.is_tagged then
	       tmp_string.extend('d');
	       tmp_string.append(fz_arrow_id);
	       tmp_string.extend('=');
	       dest_rc.id.append_in(tmp_string);
	       tmp_string.extend(';');
	    end;
	    tmp_string.append("%Nd->_item=s;%Nreturn (T0*)d;}%N");
	    out_c.put_string(tmp_string);
	 end;
      end;
   
   define_to_expanded is 
      local
	 i: INTEGER;
	 src_rc, dest_rc: RUN_CLASS;
	 src_type, dest_type: TYPE;
      do
	 from
	    i := 1;
	 until
	    i > to_expanded_mem.upper
	 loop
	    src_rc := to_expanded_mem.item(i);
	    i := i + 1;
	    dest_rc := to_expanded_mem.item(i);
	    i := i + 1;
	    src_type := src_rc.current_type;
	    dest_type := dest_rc.current_type;
	    echo.put_string(msg2);
	    echo.put_string(src_type.run_time_mark);
	    echo.put_string(" to ");
	    echo.put_string(dest_type.run_time_mark);
	    echo.put_string(msg1);
	    tmp_string.clear;
	    dest_type.c_type_for_result_in(tmp_string);
	    tmp_string.extend(' ');
	    conversion_name(dest_rc.id);
	    tmp_string.append("(T0*s)");
	    out_h.put_string(tmp_string);
	    out_h.put_string(fz_00);
	    out_c.put_string(tmp_string);
	    tmp_string.copy(fz_11);

	    -- NYI ...

	    tmp_string.append(fz_12);
	    out_c.put_string(tmp_string);
	 end;
      end;
   
feature {NONE}
   
   push_void(rf: RUN_FEATURE; t: EXPRESSION; args: EFFECTIVE_ARG_LIST) is
      require
	 rf /= Void;
	 t /= Void
      do
	 error_void_or_bad_type(t);
	 push_direct(rf,t,args);
	 sure_void_count := sure_void_count + 1;
      end;
   
feature {CECIL_POOL,RUN_FEATURE}

   push_direct(rf: RUN_FEATURE; t: EXPRESSION; args: EFFECTIVE_ARG_LIST) is
      require
	 rf /= Void;
	 t /= Void
      do
	 stack_push(C_direct_call);
	 stack_rf.put(rf,top);
	 stack_target.put(t,top);
	 stack_args.put(args,top);
	 direct_call_count := direct_call_count + 1;
      end;

feature {RUN_FEATURE_3}

   push_inline_one_pc is
      do
	 stack_push(C_inline_one_pc);
      end;

feature {RUN_FEATURE_3,RUN_FEATURE_4}
   
   push_inline_dca(relay_rf: RUN_FEATURE; dpca: CALL_PROC_CALL) is
      -- Where `dpca' is inside `relay_rf'.
      require
	 relay_rf /= Void;
	 dpca /= Void
      do
	 stack_push(C_inline_dca);
	 stack_rf.put(dpca.run_feature,top);
	 stack_static_rf.put(relay_rf,top);
	 stack_target.put(dpca.target,top);
	 stack_args.put(dpca.arguments,top);
	 direct_call_count := direct_call_count + 1;
      end;

   push_same_target(rf: RUN_FEATURE; args: EFFECTIVE_ARG_LIST) is
      require
	 rf /= Void
      do
	 stack_push(C_same_target);
	 stack_rf.put(rf,top);
	 stack_args.put(args,top);
      end;
   
feature {CECIL_POOL}

   push_cpc(up_rf: RUN_FEATURE; r: ARRAY[RUN_CLASS]; 
	    t: EXPRESSION; args: EFFECTIVE_ARG_LIST) is
      local
	 dyn_rf: RUN_FEATURE;
      do
	 if r = Void then
	    push_void(up_rf,t,args);
	    up_rf.mapping_c;
	    pop;
	 elseif r.count = 1 then
	    dyn_rf := r.first.dynamic(up_rf);
	    push_check(dyn_rf,t,args);
	    dyn_rf.mapping_c;
	    pop;
	 else
	    use_switch(up_rf,r,t,args);
	 end;
      end;

feature {NONE}
   
   push_check(rf: RUN_FEATURE; t: EXPRESSION; args: EFFECTIVE_ARG_LIST) is
      require
	 rf /= Void;
	 t /= Void;
      do
	 stack_push(C_check_id);
	 stack_rf.put(rf,top);
	 stack_target.put(t,top);
	 stack_args.put(args,top);
      end;
   
feature {SWITCH}
   
   push_switch(rf, static_rf: RUN_FEATURE) is
      require
	 rf /= Void;
	 static_rf /= Void;
	 rf.run_class.dynamic(static_rf) = rf
      do
	 stack_push(C_switch);
	 stack_rf.put(rf,top);
	 stack_static_rf.put(static_rf,top);
	 stack_args.put(Void,top); -- *** ?????? ****
      end;
      
feature {NONE}

   expanded_initializer(t: TYPE; a: RUN_FEATURE) is
	 -- ***** CHANGE THIS ******
	 -- Call the expanded initializer for type `t' if any.
	 -- The result is assigned in writable `w' or to attribute 
	 -- `a' of the brand new created object in "n".
      require 
	 t.is_expanded;
	 a /= Void
      local
	 rf: RUN_FEATURE;
      do
	 rf := t.expanded_initializer;
	 if rf /= Void then
	    stack_push(C_expanded_initialize);
	    stack_target.put(Void,top);
	    stack_rf.put(a,top);
	    direct_call_count := direct_call_count + 1;
	    rf.mapping_c;
	    pop;
--***	    if call_invariant_start(rf.current_type) then
--***	       put_character('&');
--***	       w.compile_to_c;
--***	       call_invariant_end;
--***	       put_string(fz_00);
--***	    end;
	 end;
      end;

feature {CREATION_CALL_3_4,LOCAL_VAR_LIST}

   expanded_writable(rf3: RUN_FEATURE_3; writable: EXPRESSION) is
	 -- Call the expanded initializer `rf3' using `writable'
	 -- as target.
      require 
	 rf3.current_type.is_expanded;
	 writable /= Void 
      do
	 stack_push(C_expanded_initialize);
	 stack_target.put(writable,top);
	 stack_rf.put(Void,top); -- *** UNNEEDED ???
	 direct_call_count := direct_call_count + 1;
	 rf3.mapping_c;
	 pop;
	 if call_invariant_start(rf3.current_type) then
	    put_character('&');
	    writable.compile_to_c;
	    call_invariant_end;
	    put_string(fz_00);
	 end;
      end;

feature {CREATION_CALL}   
   
   push_new(rf: RUN_FEATURE; args: EFFECTIVE_ARG_LIST) is
      --    *************** 3 ???
      require
	 rf /= Void;
      do
	 stack_push(C_inside_new);
	 stack_rf.put(rf,top);
	 stack_args.put(args,top);
	 direct_call_count := direct_call_count + 1;
      end;

feature {NATIVE}

   inside_twin(cpy: RUN_FEATURE) is
      do
	 stack_push(C_inside_twin);
	 stack_rf.put(cpy,top);
	 cpy.mapping_c;
	 pop;
      end;
   
feature {NONE}
   
   use_switch(up_rf: RUN_FEATURE; r: ARRAY[RUN_CLASS]; 
	      t: EXPRESSION; args: EFFECTIVE_ARG_LIST) is
      require
	 up_rf /= Void;
	 r.count > 1
	 t /= Void;
	 on_c;
      local
	 rt, target_type: TYPE;
	 rc: RUN_CLASS;
	 rf: RUN_FEATURE;
	 switch: SWITCH;
      do
	 if run_control.boost and then 
	    stupid_switch(up_rf) 
	  then
	    direct_call_count := direct_call_count + 1;
	    switch_collection.remove(up_rf);
	    put_string(fz_open_c_comment);
	    put_character('X');
	    put_integer(up_rf.current_type.id);
	    put_string(fz_close_c_comment);
	    rt := up_rf.result_type;
	    if rt /= Void then
	       tmp_string.copy(fz_17);
	       rt.c_type_for_result_in(tmp_string);
	       tmp_string.extend(')');
	       put_string(tmp_string);
	    end;
	    rc := r.item(1);
	    rf := rc.dynamic(up_rf);
	    push_direct(rf,t,args);
	    rf.mapping_c;
	    pop;
	    if rt /= Void then
	       put_character(')');
	    end;
	 else
	    switch_count := switch_count + 1;
	    out_c.put_string(switch.name(up_rf));
	    out_c.put_character('(');
	    if run_control.no_check then
	       put_position(t.start_position)
	       out_c.put_character(',');
	    end;
	    t.compile_to_c;
	    if args /= Void then
	       out_c.put_character(',');
	       args.compile_to_c(up_rf.arguments);
	    end;
	    put_character(')');
	    if up_rf.result_type = Void then
	       out_c.put_string(fz_00);
	    end;
	 end;
      end;
   
feature {E_FEATURE}

   stupid_switch(up_rf: RUN_FEATURE): BOOLEAN is
      require
	 small_eiffel.is_ready;
	 up_rf.run_class.running /= Void
      local
	 r: ARRAY[RUN_CLASS];
	 i: INTEGER;
	 f1, f2: E_FEATURE;
	 rc: RUN_CLASS;
      do
	 from
	    r := up_rf.run_class.running;
	    Result := true;
	    i := r.upper;
	    f1 := up_rf.base_feature;
	 until
	    not Result or else i = 0
	 loop
	    rc := r.item(i);
	    f2 := rc.dynamic(up_rf).base_feature;
	    Result := f1 = f2;
	    i := i - 1;
	 end;
	 if Result then
	    Result := f1.stupid_switch(up_rf,r);
	 end;
      end;

feature  -- Handling errors at run time :
   
   put_error0(msg: STRING) is
	 -- Print `msg' and then stop execution. 
	 -- Also print stack when not -boost.
      do
	 put_string("error0(");
	 put_string_c(msg);
	 put_string(fz_14);
      end;

   put_error1(msg: STRING; p: POSITION) is
	 -- Print `msg' for position `p' and then stop execution. 
	 -- Also print stack when not -boost.
      do
	 put_string("error1(");
	 put_string_c(msg);
	 put_character(',');
	 put_position(p)
	 put_string(fz_14);
      end;
   
   put_comment(str: STRING) is
      do
	 put_string(fz_open_c_comment);
	 put_string(str);
	 put_string(fz_close_c_comment);
      end;

   put_comment_line(str: STRING) is
      do
	 put_character('%N');
	 put_comment(str);
	 put_character('%N');
      end;

   define_main(rf3: RUN_FEATURE_3) is
      local
	 id: INTEGER;
	 rc: RUN_CLASS;
	 ct: TYPE;
      do
	 echo.put_string("Define main function.%N");
	 ct := rf3.current_type;
	 id := ct.id;
	 rc := rf3.run_class;
	 swap_on_c;
	 split_c_now;
	 put_extern1("int se_argc");
	 put_extern1("char**se_argv");
	 if run_control.trace then
	    put_extern1("FILE *se_trace_file");
	    put_extern2("int se_trace_flag",'0');
	 end;
	 if vms_system = system_name then
	    put_string(fz_void);
	 else
	    put_string(fz_int);
	 end;
	 put_string(" main(int argc,char*argv[]){%N");
	 if gc_handler.is_on then
	    gc_handler.initialize;
	 end;
	 put_string("se_initialize();%N{%N");
	 if gc_handler.is_on then
	    put_string("jmp_buf env;%N");
	 end;
	 gc_handler.put_new(rc);
	 if gc_handler.is_on then
	    put_string("(void)setjmp(env);%N%
		       %gc_root_main=((void**)(&env));%N");
	 end;
	 put_string(
            "se_argc=argc; se_argv=argv;%N%
	    %#ifdef SIGINT%Nsignal(SIGINT,sigrsp);%N#endif%N%
	    %#ifdef SIGQUIT%Nsignal(SIGQUIT,sigrsp);%N#endif%N%
	    %#ifdef SIGTERM%Nsignal(SIGTERM,sigrsp);%N#endif%N%
	    %#ifdef SIGBREAK%Nsignal(SIGBREAK,sigrsp);%N#endif%N%
	    %#ifdef SIGKILL%Nsignal(SIGKILL,sigrsp);%N#endif%N");
	 manifest_string_pool.c_call_initialize;
	 if run_control.no_check then
	    put_string(
	       "#define rs_isz 4096%N%
	       %rs_bot=(void*)malloc(rs_isz*sizeof(double));%N%
	       %rs=rs_bot;%N%
	       %rs_top=rs_bot+(rs_isz-1);%N%
	       %rs_lb=rs_bot;%N");
	 end;
	 expanded_attributes(ct);
	 if sprintf_double_flag then
	    put_string("_spfd=malloc(32);%N%
		       %_spfd[0]='%%';%N%
		       %_spfd[1]='.';%N");
	 end;
	 once_pre_computing;
	 if run_control.trace then
	    put_string(
            "printf(%"Writing \%"trace.se\%" file.\n%");%N%
	    %se_trace_file=fopen(%"trace.se%",%"w%");%N%
            %se_trace_flag=1;%N");
	 end;
	 push_new(rf3,Void);
	 rf3.mapping_c;
	 pop;
	 if run_control.invariant_check then
	    if rc.invariant_assertion /= Void then
	       put_character('i');
	       put_integer(id);
	       put_character('(');
	       put_character('n');
	       put_character(')');
	       put_string(fz_00);
	    end;
	 end;
	 if run_control.no_check then
	    put_string(
               "if (rs != rs_bot){%N%
	       %printf(%"\n***Internal SmallEiffel Stack Error.\n%");%N%
	       %rsp();}");
	 end;
	 if gc_handler.info_flag then
	    put_string(fz_gc_info);
	    put_string(fz_c_no_args_procedure);
	 end;
	 put_string("exit(0);}}%N");
	 incr_elt_c_count(10);
	 echo.put_string("Symbols used: ");
	 echo.put_integer(unique_string.count);
	 echo.put_string(fz_b6);
	 manifest_string_pool.c_define;
      end;

   define_used_basics is
	 -- Produce C code only when used.
      local
	 no_check: BOOLEAN;
      do
	 no_check := run_control.no_check;
	 echo.put_string("Define used basics.%N");
	 if sprintf_double_flag then
	    put_extern1("char*_spfd");
	 end;
	 if small_eiffel.string_at_run_time then
	    manifest_string_pool.define_se_ms;
	 end;
	 manifest_array_pool.c_define;
	 if no_check then
	    put_c_function("void rsp(void)",
	      "if(se_rspf)return;se_rspf=1;%N%
               %printf(%"Eiffel program crash at run time.\n%");%N%
	       %printf(%"Final Run Stack :\n%");%N%
	       %{double*sp=(rs_bot-1);%N%
	       %while (1) {se_af=1;%N%
	       %sp++;%N%
	       %if (sp >= rs) break;%N%
	       %if (sp > rs_top) break;%N%
	       %switch (*((int*)sp++)){%N%
	       %case LINKid: continue;%N%
	       %case FTAGid:{%N%
	       %printf(%"=====================================%
	       %=========================\n%");%N%
	       %printf(%"------ %%s\n%",*((char**)sp));%N%
	       %continue;}%N%
	       %case NAMEid:{%N%
	       %printf(%"%%s = %",*((char**)sp));%N%
	       %continue;}%N%
	       %case POINTERid:{%N%
	       %printf(%"External POINTER `%%p'.\n%",**(void***)sp);%N%
               %continue;}%N%
	       %case BITid:{%N%
	       %printf(%"BIT_N\n%");%N%
               %continue;}%N%
	       %case REFid:{void*o=(**(T0***)sp);%N%
	       %if (o) {se_print(o,o); printf(%"\n%");}%N%
	       %else printf(%"Void\n%");continue;}%N%
	       %case expandedid:{%N%
	       %printf(%"expanded object\n%");continue;}%N%
	       %case INTEGERid:{%N%
	       %printf(%"%%d\n%",**(int**)sp);continue;}%N%
	       %case CHARACTERid:{%N%
	       %printf(%"'%%c'\n%",**(char**)sp);continue;}%N%
	       %case BOOLEANid:{%N%
	       %if (**(int**)sp) printf(%"true\n%");%N%
	       %else printf(%"false\n%");continue;}%N%
	       %case REALid:{%N%
	       %printf(%"%%f\n%",(double)**(float**)sp);%N%
	       %continue;}%N%
	       %case DOUBLEid:{%N%
	       %printf(%"%%f\n%",**(double**)sp);continue;}%N%
	       %case LINEid:{%N%
	       %printf(%"line %%d %",*(int*)sp);%N%
	       %continue;}%N%
	       %case COLUMNid:{%N%
	       %printf(%"column %%d %",*(int*)sp);%N%
	       %continue;}%N%
	       %case PATHid:{%N%
	       %printf(%"file %%s %",p[*(int*)sp]);%N%
	       %continue;}%N%
	       %case DOINGid:{%N%
	       %printf(%"(%%s)\n%",*(char**)sp);continue;}%N%
	       %case INVid:{%N%
	       %printf(%"Class Invariant of %%s\n%",*(char**)sp);%N%
	       %continue;}%N%
	       %default:{%N% 
	       %printf(%"Stack Damaged ... Sorry.\n%");%N%
	       %exit(1);}}}%N%
	       %printf(%"===================== End of Run Stack %
	       %==========================\n\n%");se_af=0;se_rspf=0;%N}");
	 else
	    put_c_function("void rsp(void)",
	       "printf(%"Eiffel program crash at run time.\n%");%N%
	       %printf(%"No trace when using option \%"-boost\%"\n%");");
	 end;
	 if no_check then 
	    put_c_function("void error0(char*m)",
	       "rsp();%N%
	       %printf(%"*** Error at Run Time *** : %%s\n%",m);%N%
	       %if(!se_rspf)exit(1);");
	    put_c_function("void error1(char*m,int l,int c,int f)",
	       "rsp();%N%
	       %printf(%"Line : %%d column %%d in %%s.\n%",%
	       %l,c,p[f]);%N%
	       %printf(%"*** Error at Run Time *** : %%s\n%",m);%N%
	       %if(!se_rspf)exit(1);");
	    put_c_function("void error2(T0*o,int l,int c,int f)",
	       "printf(%"Target Type %%s not legal.\n%",s2e(t[o->id]));%N%
	       %error1(%"Bad target.%",l,c,f);");
	    put_c_function("T0*vc(void*o,int l,int c,int f)",
	       "if (!o) error1(%"Call with a Void target.%",l,c,f);%N%
	       %return o;");
	    put_c_function("T0*ci(int id,void*o,int l,int c,int f)",
	       "if (id == (vc(o,l,c,f)->id)) return o;%N%
	       %rsp();%N%
	       %printf(%"Line : %%d column %%d in %%s.\n%",%
	       %l,c,p[f]);%N%
	       %printf(%"*** Error at Run Time *** : %");%N%
	       %printf(%"Target is not valid (not the good type).\n%");%N%
	       %printf(%"Expected :%%s, Actual :%%s.\n%",%N%
	       %s2e(t[id]),s2e(t[((T0*)o)->id]));%N%
	       %if(!se_rspf)exit(1);");
	    put_c_function("void evobt(void*o,int l,int c,int f)",
	       "if (!o) error1(%"Target is Void.%",l,c,f);%N%
	       %else error2(o,l,c,f);");
	 end;
	 put_c_function("void sigrsp(int sig)",
	    "printf(%"Received signal %%d (man signal).\n%",sig);%N%
            %rsp();%N%
	    %exit(1);");
	 switch_collection.c_define;
	 if to_expanded_mem /= Void then   
	    define_to_expanded;
	 end;
	 if to_reference_mem /= Void then   
	    define_to_reference;
	 end;
	 if sure_void_count > 0 then
	    echo.put_string("Calls with a Void target : ");
	    echo.put_integer(sure_void_count);
	    echo.put_string(" (yes it is dangerous).%N");
	 end;
	 echo.print_count("Direct Call",direct_call_count);
	 echo.print_count("Check Id Call",check_id_count);
	 echo.print_count("Switched Call",switch_count);
	 echo.print_count("Inlined Procedure",inlined_procedure_count);
	 echo.print_count("Inlined Function",inlined_function_count);
	 echo.print_count("Static Expression",static_expression_count);
	 echo.print_count("Real Procedure",real_procedure_count);
	 echo.print_count("Real Function",real_function_count);
	 echo.print_count("Procedure",procedure_count);
	 echo.print_count("Function",function_count);
	 if pre_computed_once /= Void then
	    echo.print_count("Pre-Computed Once Function Call",
			     pre_computed_once.count);
	 end;
	 echo.put_string("Internal stacks size used : ");
	 echo.put_integer(stack_code.count);
	 echo.put_character('%N');
	 define_initialize;
      end;

feature {NONE}
   
   define_is_equal_prototype(id: INTEGER) is
      do
	 tmp_string.copy(fz_int);
	 tmp_string.extend(' ');
	 tmp_string.extend('r');
	 (id).append_in(tmp_string);
	 tmp_string.append(us_is_equal);
	 tmp_string.append("(T");
	 (id).append_in(tmp_string);
	 tmp_string.append("*C, T0*a1)");
	 out_h.put_string(tmp_string);
	 out_c.put_string(tmp_string);
      end;

feature 
   
   trace_boolean_expression(e: EXPRESSION) is
	 -- Produce a C boolean expression including trace code.
      require
	 e.result_type.is_boolean;
	 run_control.no_check;
      do
	 rs_push_position('2',e.start_position);
	 put_string(",rs_pop_int(");
	 e.compile_to_c;
	 put_character(')');
      end;
   
feature {ASSERTION}
   
   check_assertion(e: EXPRESSION) is
	 -- Produce a C boolean expression including trace code
	 -- and assertion check.
      require
	 e.result_type.is_boolean
      local
	 static: BOOLEAN;
      do
	 static := e.is_static; 
	 if not static or else e.static_value = 0 then
	    rs_push_position('4',e.start_position);
	    put_string("ac_");
	    put_string(check_assertion_mode);
	    put_character('(');
	    if static then
	       static_expression_count := static_expression_count + 1;
	       put_character('0');
	    else
	       e.compile_to_c;
	    end;
	    put_string(fz_14);
	 end;
      end;
   
feature {NONE}
   
   check_assertion_mode: STRING;

feature {ASSERTION_LIST}
   
   set_check_assertion_mode(s: STRING) is
      require
	 s /= Void
      do
	 check_assertion_mode := s;
      ensure
	 check_assertion_mode = s
      end;   
   
feature {NONE}
   
   error_void_or_bad_type(e: EXPRESSION) is
      require
	 e /= Void;
	 e.result_type.is_run_type;
      do
	 eh.add_position(e.start_position);
	 eh.append("Call on a Void or a bad target. Dynamic ");
	 eh.add_type(e.result_type.run_type," is concerned. ")
	 eh.print_as_warning;
	 if run_control.boost then
	    put_string("(rsp();exit(1);)");
	 else
	    put_string("evobt(");
	    e.compile_to_c;
	    put_character(',');
	    put_position(e.start_position);
	    put_character(')');
	 end;
      end;
   
feature {RUN_FEATURE} -- Run stack link/push/unlink :
   
   rs_link(rf: RUN_FEATURE) is
      do
	 put_string("rs_link(");
	 rf.put_tag;	 
	 put_string(fz_14);
      end;
   
   rs_unlink is
      do
	 put_string("rs_unlink();%N");
      end;
   
   rs_push_current(t: TYPE) is
      require
	 t.run_type = t;
      do
	 rs_push(us_current,"C",t);
      end;
   
   rs_push_result(t: TYPE) is
      require
	 t.run_type = t;
      do
	 rs_push(us_result,"R",t);
      end;
   
   rs_push_argument(src_name: STRING; rank: INTEGER; t: TYPE) is
      require
	 src_name /= Void;
	 t.run_type = t;
	 rank > 0;
      do
	 tmp_string.clear;
	 tmp_string.extend('a');
	 rank.append_in(tmp_string);
	 rs_push(src_name,tmp_string,t);
      end;

feature {LOCAL_NAME1}
   
   rs_push_local(src_name: STRING; t: TYPE) is
      require
	 src_name /= Void;
	 t.run_type = t;
      do
	 tmp_string.clear;
	 tmp_string.extend('_');
	 tmp_string.append(src_name);
	 rs_push(src_name,tmp_string,t);
      end;
   
feature {INSTRUCTION,IFTHEN}
   
   rs_push_position(msg_nb: CHARACTER; p: POSITION) is
      do
	 if run_control.no_check then
	    put_string("rs_pPOS(tag_pos_");
	    put_character(msg_nb);
	    put_character(',');
	    put_position(p);
	    put_character(')');
	    if msg_nb /= '2' then
	       put_string(fz_00);
	    end;
	 end;
      end;
   
   rs_pop_position is
      do
	 if run_control.no_check then
	    put_string("rs-=8;%N");
	 end;
      end;
         
feature  -- Numbering of inspect variables :
   
   inspect_incr is
      do
	 inspect_level := inspect_level + 1;
      end;
   
   inspect_decr is
      do
	 inspect_level := inspect_level - 1;
      end;

   put_inspect is
      do
	 put_character('z');
	 put_integer(inspect_level);
      end;

feature {NONE}
   
   inspect_level: INTEGER;

feature -- Printing Current, local or argument :

   inline_level_incr is
      do
	 inline_level := inline_level + 1;
      end;

   inline_level_decr is
      do
	 inline_level := inline_level - 1;
      end;

   print_current is
      local
	 level: INTEGER;
      do
	 put_character('C');
	 level := inline_level;
	 if level > 0 then
	    put_integer(level);
	 end;
      end;

   print_argument(rank: INTEGER) is
      local
	 code: INTEGER;
      do
	 code := ('a').code + inline_level;
	 put_character(code.to_character);
	 put_integer(rank);
      end;

   print_local(name: STRING) is
      local
	 level: INTEGER;
      do
	 from
	    level := inline_level + 1;
	 until
	    level = 0
	 loop
	    put_character('_');
	    level := level - 1;
	 end;
	 put_string(name);
      end;

feature {NONE}
   
   inline_level: INTEGER;
   
feature {NONE}

   check_id(e: EXPRESSION; id: INTEGER) is
	 -- Produce a C expression checking that `e' is not void and 
	 -- that `e' is really of type `id'.
	 -- The result of the C expression is the pointer to the
	 -- corresponding Object.
      require
	 e.result_type.run_type.is_reference;
	 id > 0;
      do
	 if run_control.no_check then
	    put_character('(');
	    put_character('(');
	    put_character('T');
	    put_integer(id);
	    put_string("*)ci(");
	    put_integer(id);
	    put_character(',');
	    e.compile_to_c;
	    put_character(',');
	    put_position(e.start_position);
	    put_string(fz_13);
	    check_id_count := check_id_count + 1;
	 else
	    e.compile_to_c;
	    direct_call_count := direct_call_count + 1;
	 end;
      end;
   
   same_base_feature(r: ARRAY[RUN_CLASS]; up_rf: RUN_FEATURE): BOOLEAN is 
      -- True if all have the same final name and the same base_feature.
      require
	 not r.empty;
	 up_rf /= Void
      local
	 i: INTEGER;
	 up_bf, bf: E_FEATURE;
	 up_name, name: FEATURE_NAME;
	 rf: RUN_FEATURE;
      do
	 from
	    up_bf := up_rf.base_feature;
	    up_name := up_rf.name;
	    i := r.lower;
	    Result := true;
	 until
	    not Result or else i > r.upper
	 loop
	    rf := r.item(i).dynamic(up_rf);
	    bf := rf.base_feature;
	    name := rf.name;
	    Result := name.is_equal(up_name) and then bf = up_bf;
	    i := i + 1;
	 end;
      end;

feature {SMALL_EIFFEL}

   generating_type_used: BOOLEAN;
   
   generator_used: BOOLEAN;
   
feature {E_LOOP}
   
   variant_check(e: EXPRESSION) is
      do
	 rs_push_position('6',e.start_position);
	 put_string("v=lvc(c++,v,");
	 e.compile_to_c;
	 put_string(fz_14);
      end;
   
feature {NONE}
   
   rs_push(src_name, c_name: STRING; t: TYPE) is
      require
	 src_name /= Void;
	 c_name /= Void;
	 t.run_type = t;
	 run_control.no_check
      local
	 str: STRING;
      do
	 put_string("rs_p")
	 if t.is_reference then
	    put_string("REF((void**)");
	 else
	    if t.is_basic_eiffel_expanded then
	       str := t.written_mark;
	       put_character(str.item(1));
	       put_character(str.item(2));
	       put_character(str.item(3));
	    elseif t.is_bit then
	       put_string("BIT");
	    else 
	       put_string("EXP");
	    end;
	    put_character('(');
	 end;
	 put_character('&');
	 put_string(c_name);
	 put_character(',');
	 if src_name = us_current then
	    put_string(us_current);
	 elseif src_name = us_result then
	    put_string(us_result);
	 else
	    put_string_c(src_name);
	 end;
	 put_string(fz_14);
      end;
   
feature {NONE}
   
   tmp_string: STRING is
      once
	 !!Result.make(256);
      end;
   
   tmp_string2: STRING is
      once
	 !!Result.make(128);
      end;
   
   tmp_string3: STRING is
      once
	 !!Result.make(128);
      end;
   
feature {NONE}
   
   once_pre_computing is
      local
	 i: INTEGER;
	 of_array: ARRAY[E_FEATURE];
	 rf6: RUN_FEATURE_6;
	 of: ONCE_FUNCTION;
      do
	 if pre_computed_once /= Void then
	    echo.put_string(fz_04);
	    echo.put_string(fz_05);
	    from  
	       i := pre_computed_once.upper;
	       !!of_array.with_capacity(1 + i // 2,1);
	    until
	       i = 0
	    loop
	       rf6 := pre_computed_once.item(i);
	       of := rf6.base_feature;
	       if not of_array.fast_has(of) then
		  of_array.add_last(of);
		  rf6.c_pre_computing;
	       end;
	       i := i - 1;
	    end;
	    echo.print_count(fz_04,of_array.count);
	 end;
      end;
   
feature {NONE}
   
   need_invariant(target_type: TYPE): RUN_CLASS is
	 -- Give the good RUN_CLASS when `target_type' need some 
	 -- class invariant checking.
      require
	 target_type.is_run_type
      do
	 if run_control.invariant_check then
	    Result := target_type.run_type.run_class;
	    if Result.at_run_time and then
	       Result.invariant_assertion /= Void then
	    else
	       Result := Void;
	    end;
	 end;
      end;

feature {RUN_FEATURE}

   current_class_invariant(current_type: TYPE) is
	 -- Add some C code to check class invariant with Current at 
	 -- the end of a routine.
      require
	 current_type.is_run_type
      local
	 rc: RUN_CLASS;
      do
	 rc := need_invariant(current_type);
	 if rc /= Void then
	    if rc.current_type.is_reference then
	       put_string("if(se_rci(C))");
	    end;
	    put_character('i');
	    put_integer(rc.id);
	    put_character('(');
	    put_character('C');
	    put_character(')');
	    put_string(fz_00);
	 end;
      end;
   
feature 
   
   call_invariant_start(target_type: TYPE): BOOLEAN is
	 -- Start printing call of invariant only when it is needed 
	 -- (`target_type' really has an invariant and when mode is 
	 -- `-invariant_check').  
	 -- When Result is true, `call_invariant_end' must be called to 
	 -- finish the job.
      require
	 target_type.is_run_type;
      local
	 rc: RUN_CLASS;
      do
	 rc := need_invariant(target_type);
	 if rc /= Void then
	    out_c.put_character('i');
	    out_c.put_integer(rc.id);
	    out_c.put_character('(');
	    Result := true;
	 end;
      end;

   call_invariant_end is
      do
	 out_c.put_character(')');
      end;
   
feature {NONE}
   
   define_initialize is
	 -- Very very last definitions ;-);
      local
	 no_check: BOOLEAN;
      do
	 no_check := run_control.no_check;
	 echo.put_string("Define initialize stuff.%N");
	 small_eiffel.define_extern_tables;
	 if no_check then
	    split_c_now;
	 end;
	 put_c_heading("void se_initialize(void)");
	 swap_on_c;
	 if no_check then
	    small_eiffel.initialize_path_table;
	 end;
	 if generator_used then
	    small_eiffel.initialize_generator;
	 end;
	 if generating_type_used then
	    small_eiffel.initialize_generating_type;
	 end;
	 put_string(fz_12);
	 if no_check then
	    split_c_now;
	 end;
      end;
   
feature {NONE}
   
   cdef_id(str: STRING; id: INTEGER) is
      do
	 tmp_string.clear;
	 tmp_string.extend('#');
	 tmp_string.append(fz_define);
	 tmp_string.extend(' ');
	 tmp_string.append(str);
	 tmp_string.append("id ");
	 id.append_in(tmp_string);
	 tmp_string.extend('%N');
	 out_h.put_string(tmp_string);
      end;

feature {CREATION_CALL}
   
   expanded_attributes(rt: TYPE) is
	 -- Produce C code to initialize expanded attribute
	 -- of the new object juste created in variable "n".
      require
	 small_eiffel.is_ready;
	 rt.is_run_type
      local
	 wa: ARRAY[RUN_FEATURE];
	 a: RUN_FEATURE;
	 at: TYPE;
	 i: INTEGER;
	 rf3: RUN_FEATURE_3;
      do
	 wa := rt.run_class.writable_attributes;
	 if wa /= Void then
	    from  
	       i := wa.upper;
	    until
	       i = 0
	    loop
	       a := wa.item(i);
	       at := a.result_type.run_type;

	       rf3 := at.expanded_initializer;
	       if rf3 /= Void then
		  stack_push(C_expanded_initialize);
		  stack_target.put(Void,top);
		  stack_rf.put(a,top);
		  direct_call_count := direct_call_count + 1;
		  rf3.mapping_c;
		  pop;
--***	          if call_invariant_start(rf.current_type) then
--***	             put_character('&');
--***	             w.compile_to_c;
--***	             call_invariant_end;
--***	             put_string(fz_00);
--***	          end;
	       end;
	       i := i - 1;
	    end;
	 end;
      end;
   
feature {NONE} -- Splitting of the C code:
   
   split_count: INTEGER;
	 -- Number of *.c files.
   
   elt_c_count: INTEGER;
	 -- Number of elements already in current *.c file.
   
   elt_c_count_max: INTEGER is 1960;
	 -- One unit is about 1 source line.
   
   path_h: STRING is
      once
	 Result := run_control.root_class;
	 if Result = Void then
	    fatal_error("No <root class>.");
	 else
	    Result := to_bcn(Result);
	    Result.to_lower;
	    if dos_system = system_name then
	       from
	       until
		  Result.count <= 4
	       loop
		  Result.remove_last(1);
	       end;
	    end;
	    Result.append(h_suffix);
	 end;
      ensure
	 Result.has_suffix(h_suffix);
      end;
   
   path_c: STRING is
      once
	 if no_split then
	    Result := path_h.twin;
	    Result.remove_suffix(h_suffix);
	    Result.append(c_suffix);
	 else
	    split_count := 1;
	    !!Result.make(path_h.count + 2);
	    path_c_copy_in(Result,split_count);
	 end;
      ensure
	 Result.has_suffix(c_suffix);
      end;
   
   path_make: STRING is
      once
	 Result := path_h.twin;
	 Result.remove_last(h_suffix.count);
	 Result.append(make_suffix);
      end;
   
feature {NONE}

   output_name: STRING;
	 -- Void means default "a.out".
   
   add_first_include is
      do
	 put_banner(out_c);
	 out_c.put_string("#include %"");
	 out_c.put_string(path_h);
	 out_c.put_string(fz_18);
      end;
   
feature {RUN_CLASS}

   split_c_start_run_class is
	 -- May split here to add some padding space.
      do
	 if no_split then
	 elseif split_rc_count >= 9 then
	    split_c_now;
	    split_rc_count := 0;
	 else
	    split_rc_count := split_rc_count + 1;
	 end;
      end;

   split_rc_count: INTEGER;

feature {SWITCH_COLLECTION}
   
   split_c_now is
	 -- Assume `out_c' has finished current C function (or current
	 -- C entity).
      do
	 incr_elt_c_count(elt_c_count_max + 1);
      end;

feature {NONE}

   put_banner(output: STD_FILE_WRITE) is
      require
	 output /= Void;
	 output.is_connected;
      do
	 output.put_string(fz_open_c_comment);
	 output.put_string(
            "%N-- ANSI C code generated by :%N");
	 output.put_string(small_eiffel.copyright);
	 output.put_string(fz_close_c_comment);
	 output.put_character('%N');
      end;
   
feature  

   c_compiler: STRING is 
      once
	 !!Result.make(12);
	 tmp_string.copy(small_eiffel_directory);
	 add_directory(tmp_string,fz_sys);
	 tmp_string.append("compiler.");
	 tmp_string.append(system_name);
	 echo.sfr_connect(tmp_file_read,tmp_string);
	 tmp_file_read.read_line_in(Result);
	 tmp_file_read.disconnect;
      end;

   c_linker: STRING is 
      once
	 !!Result.make(12);
	 tmp_string.copy(small_eiffel_directory);
	 add_directory(tmp_string,fz_sys);
	 tmp_string.append("linker.");
	 tmp_string.append(system_name);
	 echo.sfr_connect(tmp_file_read,tmp_string);
	 tmp_file_read.read_line_in(Result);
	 tmp_file_read.disconnect;
      end;

   set_no_strip is
      do
	 no_strip := true;
      end;
      
   set_no_split is
      do
	 no_split := true;
      end;
      
   add_c_library(lib: STRING) is
      require
	 lib.has_prefix("-l");
      do
	 if c_library_list = Void then
	    c_library_list := <<lib>>;
	 elseif c_library_list.has(lib) then
	 else
	    c_library_list.add_last(lib);
	 end;
      end;
   
   add_c_compiler_option(op: STRING) is
      require
	 op /= Void
      do
	 if c_compiler_options = Void then
	    !!c_compiler_options.make(10);
	 end;
	 c_compiler_options.append(op);
	 c_compiler_options.extend(' ');
      end;
   
   add_c_object(file_o: STRING) is
      require
	 file_o.has_suffix(o_suffix) or file_o.has_suffix(c_suffix); 
      do
	 if c_object_list = Void then
	    c_object_list := <<file_o>>;
	 elseif c_object_list.has(file_o) then
	 else
	    c_object_list.add_last(file_o);
	 end;
      end;
   
   set_output_name(on: like output_name) is
      require
	 on /= Void
      do
	 output_name := on;
      ensure	 
	 output_name = on;
      end;
   
   write_make_file is 
      local
	 score: DOUBLE;
      do
	 out_h.put_character('%N');
	 out_h.disconnect;
	 out_c.put_character('%N');
	 out_c.disconnect;
	 sfw_connect(out_make,path_make);
	 if no_split then
	    write_make_file_no_split;
	 else
	    write_make_file_split;
	 end;
	 if not no_strip then
	    print_strip;
	 end;
	 out_make.disconnect;
	 if nb_errors > 0 then
	    echo.file_removing(path_make);
	 else
	    echo.put_string("Type inference score : ");
	    score := direct_call_count + check_id_count; 
	    score := (score / (score + switch_count)) * 100.0;
	    echo.put_double_format(score,2);
	    echo.put_character('%%');
	    echo.put_character('%N');
	 end;
	 eiffel_parser.show_nb_warnings;
	 eiffel_parser.show_nb_errors;
	 echo.put_string(fz_02);
      end;
   
feature {NONE}

   oflag: STRING;

   add_oflag is
      do
	 if output_name /= Void then
	    if oflag = Void then
	       tmp_string.append("-o ");
	    else
	       tmp_string.append(oflag);
	    end;
	    tmp_string.append(output_name);
	    tmp_string.extend(' ');
	 end;
      end;

feature 

   set_oflag(str: STRING) is
      do
	 oflag := str;
      end;
   
feature {NONE}
   
   print_strip is
      require
	 not no_strip;
      do
	 if os2_system = system_name or else 
	    unix_system = system_name
	  then
	    tmp_string.clear;
	    if os2_system = system_name then
	       tmp_string.append("emxbind -qs ");
	    else
	       tmp_string.append("strip ");
	    end;
	    if output_name = Void then
	       tmp_string.append("a.out");
	    else
	       tmp_string.append(output_name);
	    end;
	    echo_make;
	 end;	 
      end;
      
   call_c_compiler is
      do
	 tmp_string.copy(c_compiler);
	 tmp_string.extend(' ');
	 if c_compiler_options /= Void then
	    tmp_string.append(c_compiler_options);
	 end;
      end;
   
   call_c_linker is
      do
	 tmp_string.copy(c_linker);
	 tmp_string.extend(' ');
	 if c_compiler_options /= Void then
	    tmp_string.append(c_compiler_options);
	 end;
      end;
   
   tmp_string_object_library is
      local
	 i: INTEGER;
      do
	 if c_object_list /= Void then
	    from  
	       i := c_object_list.lower;
	    until
	       i > c_object_list.upper
	    loop
	       tmp_string.extend(' ');
	       tmp_string.append(c_object_list.item(i));
	       i := i + 1;
	    end;	    
	 end;
	 if c_library_list /= Void then
	    from  
	       i := c_library_list.lower;
	    until
	       i > c_library_list.upper
	    loop
	       tmp_string.extend(' ');
	       tmp_string.append(c_library_list.item(i));
	       i := i + 1;
	    end;	    
	 end;
      end;
   
   echo_make is
      do
	 out_make.put_string(tmp_string);
	 out_make.put_character('%N');
      end;
   
   no_strip: BOOLEAN; 
   
   no_split: BOOLEAN; 

   c_compiler_options: STRING;
   
   c_object_list, c_library_list: ARRAY[STRING];
   
   c_code_saved: BOOLEAN;

feature {NONE}

   get_inline_ms: MANIFEST_STRING is
      local
	 e: EXPRESSION;
      do
	 e := stack_args.item(top).expression(1);
	 Result ?= e;
	 if Result = Void then
	    eh.add_position(e.start_position);
	    fatal_error("Bad usage of C inlining.");
	 end;
	 manifest_string_pool.used_for_inline(Result);
      end;

feature {NONE}

   backup_sfw_connect(sfw: STD_FILE_WRITE; c_path: STRING) is
      do
	 tmp_string3.copy(c_path);
	 tmp_string3.extend('~');
	 echo_rename_file(c_path,tmp_string3);
	 sfw_connect(sfw,c_path);
      end;

   path_c_copy_in(str: STRING; number: INTEGER) is
      do
	 str.clear;
	 str.append(path_h);
	 str.remove_last(h_suffix.count);
	 number.append_in(str);
	 str.append(c_suffix);
      end;

   path_o_in(str: STRING; number: INTEGER) is
      do
	 str.append(path_h);
	 str.remove_last(h_suffix.count);
	 number.append_in(str);
	 str.append(o_suffix);
      end;

feature {NONE}

   write_make_file_split is 
      require
	 not no_split
      local
	 i: INTEGER;
      do
	 from  
	    i := split_count;
	 until
	    i = 0
	 loop
	    path_c_copy_in(tmp_string,i);
	    tmp_string2.copy(tmp_string);
	    tmp_string2.extend('~');
	    tmp_string3.clear;
	    path_o_in(tmp_string3,i);
	    if file_exists(tmp_string3) and then
	       file_tools.same_files(tmp_string,tmp_string2) then
	       echo.put_string(fz_01);
	       echo.put_string(tmp_string3);
	       echo.put_string("%" saved.%N");
	    else
	       echo.file_removing(tmp_string3);
	       call_c_compiler;
	       tmp_string.append("-c ");
	       tmp_string.append(tmp_string2);
	       tmp_string.remove_last(1);
	       echo_make;
	    end;
	    i := i - 1;
	    echo.file_removing(tmp_string2);
	 end;
	 call_c_linker;
	 add_oflag;
	 from
	    i := 1;
	 until
	    i > split_count
	 loop
	    path_o_in(tmp_string,i);
	    tmp_string.extend(' ');
	    i := i + 1;
	 end;
	 tmp_string_object_library;
	 echo_make;
      end;

   write_make_file_no_split is 
      require
	 no_split
      do
	 call_c_compiler;
	 add_oflag;
	 tmp_string.append(path_c);
	 tmp_string_object_library;
	 echo_make;
      end;

feature {NONE}

   common_put_target is
      local
	 rf: RUN_FEATURE;
	 flag: BOOLEAN;
	 e: EXPRESSION;
	 ct: TYPE;
      do
	 inspect
	    stack_code.item(top)
	 when C_inside_twin then 
	    rf := stack_rf.item(top);
	    ct := rf.current_type;
	    if ct.is_reference then
	       put_character('(');
	       ct.mapping_cast;
	       put_character('R');
	       put_character(')');
	    else
	       put_character('&');
	       put_character('R');
	    end;
	 when C_inside_new then 
	    put_character('n');
	 when C_switch then 
	    rf := stack_rf.item(top);
	    flag := call_invariant_start(rf.current_type);
	    put_character('(');
	    put_character('(');
	    put_character('T');
	    put_integer(rf.id);
	    put_character('*');
	    put_character(')');
	    put_character('C');
	    put_character(')');
	    if flag then
	       call_invariant_end;
	    end;
	 when C_expanded_initialize then
	    e := stack_target.item(top);
	    if e /= Void then
	       put_character('&');
	       e.compile_to_c;
	    else
	       out_c.put_string("&n->_");
	       out_c.put_string(stack_rf.item(top).name.to_string);
	    end;
	 when C_inline_one_pc then
	    print_current;
	 end;
      end;

feature {NONE}

   msg1: STRING is " type conversion.%N";
   msg2: STRING is "Automatic ";


feature {CALL_PROC_CALL}

   put_cpc(cpc: CALL_PROC_CALL) is
      local
	 target: EXPRESSION;
	 target_type: TYPE;
	 running: ARRAY[RUN_CLASS];
	 run_feature: RUN_FEATURE;
      do
	 target := cpc.target;
	 target_type := target.result_type.run_type;
	 run_feature := cpc.run_feature;
	 if target_type.is_expanded then
	    push_direct(run_feature,target,cpc.arguments);
	    run_feature.mapping_c;
	    pop;
	 elseif target.is_current then
	    push_direct(run_feature,target,cpc.arguments);
	    run_feature.mapping_c;
	    pop;
	 elseif target.is_manifest_string then
	    push_direct(run_feature,target,cpc.arguments);
	    run_feature.mapping_c;
	    pop;
	 else
	    push_cpc(run_feature,
		     target_type.run_class.running,
		     target,
		     cpc.arguments);
	 end;
      end;

feature {NATIVE_SMALL_EIFFEL}

   sprintf_double_is_used is
      do
	 sprintf_double_flag := true;
      end;

feature {NONE}

   sprintf_double_flag: BOOLEAN;

end -- C_PRETTY_PRINTER

