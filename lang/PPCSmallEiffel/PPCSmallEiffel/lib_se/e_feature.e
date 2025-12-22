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
deferred class E_FEATURE
--
-- For all possible Features : procedure, function, attribute, 
-- constants, once procedure, once function, ...
--   

inherit GLOBALS;
   
feature  
   
   base_class: BASE_CLASS;
	 -- The class where the feature is really written.
   
   names: FEATURE_NAME_LIST; 
	 -- All the names of the feature.
   
   arguments: FORMAL_ARG_LIST is
	 -- Arguments if any.
      deferred
      end;
   
   result_type: TYPE;
	 -- Result type if any.

   header_comment: COMMENT;
	 -- Header comment for a routine or following comment for
	 -- an attribute.
   
   require_assertion: E_REQUIRE is
	 -- Not Void if any.
      deferred
      end;
   
   ensure_assertion: E_ENSURE is
	 -- Not Void if any.
      deferred
      end;

   local_vars: LOCAL_VAR_LIST;
	 -- Local var list if any.
   
   clients: CLIENT_LIST;
	 -- Authorized clients list of the corresponding feature
	 -- clause in the base definition class.
   
   frozen mapping_c_name_in(str: STRING) is
      do
	 base_class.mapping_c_in(str);
	 str.append(first_name.to_key);
      end;

   frozen mapping_c_name is
      local
	 s: STRING;
      do
	 s := "    ";
	 s.clear;
	 mapping_c_name_in(s);
	 cpp.put_string(s);
      end;
   
   base_class_name: CLASS_NAME is
	 -- Name of the class where the feature is really written.
      do
	 Result := base_class.base_class_name;
      end;
   
   first_name: FEATURE_NAME is
	 -- Return the principal (first) name of the feature.
      do
	 Result := names.item(1);
      ensure
	 Result /= void
      end; 

   start_position: POSITION is
      do
	 Result := first_name.start_position;
      end;
   
   to_run_feature(t: TYPE; fn: FEATURE_NAME): RUN_FEATURE is
	 -- If possible, gives the checked runnable feature for `t'. 
	 -- Note: corresponding run_class dictionary is updated
	 --       with this new feature.
      require
	 t.is_run_type;
	 fn /= Void;
      deferred
      ensure
	 Result /= Void implies t.run_class.at(fn) = Result;
	 Result = Void implies nb_errors > 0
      end;
   
   is_exported_to(c: BASE_CLASS): BOOLEAN is
      do
	 Result := clients.gives_permission_to(c.base_class_name);
      end;
   
   is_deferred: BOOLEAN is do end;
   
   is_merge_with(other: E_FEATURE; rc: RUN_CLASS): BOOLEAN is
	 -- True when headings of Current can be merge with heading 
	 -- of `other' in `rc'.
      require
	 Current /= other;
      do
	 if result_type /= other.result_type then
	    if result_type = Void or else other.result_type = Void then
	       eh.add_position(other.start_position);
	       error(start_position,"One has Result but not the other.");
	    end;
	 end;
	 if arguments /= other.arguments then
	    if arguments = Void or else other.arguments = Void then
	       eh.add_position(other.start_position);
	       error(start_position,"One has argument(s) but not the other.");
	    elseif arguments.count /= other.arguments.count then 
	       eh.add_position(other.start_position);
	       error(start_position,"Incompatible number of arguments.");
	    end;
	 end;
	 if result_type /= Void then
	    if not result_type.is_a_in(other.result_type,rc) then
	       eh.error(em1);
	    end;
	 end;
	 if arguments /= Void then
	    if not arguments.is_a_in(other.arguments,rc) then
	       eh.add_position(other.start_position);
	       error(start_position,em1);
	    end;
	 end;
	 Result := nb_errors = 0; 
      end;
   
   can_hide(other: E_FEATURE; rc: RUN_CLASS): BOOLEAN is
	 -- True when headings of Current can be hide with
	 -- heading of `other' in `rc'.
      require
	 Current /= other;
      do
	 if result_type /= other.result_type then
	    if result_type = Void or else other.result_type = Void then
	       eh.add_position(other.start_position);
	       error(start_position,"One has Result but not the other.");
	    end;
	 end;
	 if arguments /= other.arguments then
	    if arguments = Void or else other.arguments = Void then
	       eh.add_position(other.start_position);
	       error(start_position,"One has argument(s) but not the other.");
	    elseif arguments.count /= other.arguments.count then 
	       eh.add_position(other.start_position);
	       error(start_position,"Incompatible number of arguments.");
	    end;
	 end;
	 if nb_errors = 0 then
	    if result_type /= Void then
	       if not result_type.is_a_in(other.result_type,rc) then
		  eh.append(em2);
		  eh.append(rc.current_type.run_time_mark);
		  eh.error(fz_dot);
	       end;
	    end;
	 end;
	 if nb_errors = 0 then
	    if arguments /= Void then
	       if not arguments.is_a_in(other.arguments,rc) then
		  eh.add_position(other.start_position);
		  eh.add_position(start_position)
		  eh.append(em2);
		  eh.append(rc.current_type.run_time_mark);
		  eh.error(fz_dot);
	       end;
	    end;
	 end;
	 Result := nb_errors = 0; 
      end;

feature {PARENT}

   frozen try_to_undefine(fn: FEATURE_NAME; 
			  bc: BASE_CLASS): DEFERRED_ROUTINE is
	 -- When class `bc' has an undefine clause for `fn'.
	 -- Compute the corresponding undefined feature.
	 -- Check for (VDUS).
	 -- Not Void when no errors.
      require
	 fn /= Void;
	 bc.base_class_name.is_subclass_of(base_class_name)
      do
	 fn.undefine_in(bc);
	 Result := try_to_undefine_aux(fn,bc);
	 if Result /= Void then
	    Result.set_clients(clients);
	 else
	    bc.fatal_undefine(fn);
	 end;
      ensure
	 Result /= Void
      end;
   
feature {FEATURE_CLAUSE,E_FEATURE}
   
   set_clients(c: like clients) is
      require
	 c /= Void;
      do
	 clients := c;
      ensure
	 clients = c;
      end;
   
feature 
   
   set_header_comment(hc: like header_comment) is
      do
	 header_comment := hc;
      end;
   
feature -- Pretty printing :
   
   pretty_print is
      require
	 fmt.indent_level = 1;
      deferred
      ensure
	 fmt.indent_level = 1;
      end;
   
   frozen pretty_print_profile is
      do
	 pretty_print_names;
	 fmt.set_indent_level(2);
	 pretty_print_arguments;
	 fmt.set_indent_level(3);
	 if result_type /= Void then
	    fmt.put_string(": ");
	    result_type.pretty_print;
	 end;
      end;
   
feature {RUN_FEATURE}
   
   run_require(rf: RUN_FEATURE): RUN_REQUIRE is
	 -- Collect all (inherited) require assertions for 
	 -- `rf'. Unless return Void (no assertion at all).
      require
	 rf /= Void;
	 rf.base_feature = Current;
      local
	 i: INTEGER;
	 r: like runnable;
	 er: E_REQUIRE;
	 hc: COMMENT;
	 ar: ARRAY[E_REQUIRE];

      do
	 require_collector.clear;
	 rf.current_type.base_class.collect_for(code_require,rf.name);
	 if not require_collector.empty then
	    from  
	       i := 1;
	    until
	       i > require_collector.upper
	    loop
	       er := require_collector.item(i);
	       hc := er.header_comment;
	       if not er.empty then
		  r := runnable(er.list,rf.current_type,rf);
		  if r /= Void then
		     !!er.from_runnable(r);
		     er.set_header_comment(hc);
		     if ar = Void then
			ar := <<er>>;
		     else
			ar.add_last(er);
		     end;
		  end;
	       end;
	       i := i + 1;
	    end;	    
	    if ar /= Void then
	       !!Result.make(ar);
	    end;
	 end;
      end;
   
   run_ensure(rf: RUN_FEATURE): E_ENSURE is
      require
	 rf /= Void;
	 rf.base_feature = Current;
      local
	 r: like runnable;
      do
	 assertion_collector.clear;
	 header_comment_memory.clear;
	 rf.current_type.base_class.collect_for(code_ensure,rf.name);
	 r := runnable(assertion_collector,rf.current_type,rf);
	 if r /= Void then
	    !!Result.from_runnable(r);
	    Result.set_header_comment(header_comment_memory.item);
	    header_comment_memory.clear;
	 end;
      end;
   
feature {NONE}
   
   require_collector: ARRAY[E_REQUIRE] is
      once
	 !!Result.make(1,10);
      end;
   
   assertion_collector: ARRAY[ASSERTION] is
      once
	 !!Result.make(1,10);
      end;
   
   header_comment_memory: MEMO[COMMENT] is
      once
	 !!Result;
      end;
   
feature {BASE_CLASS}
   
   collect_for(code: INTEGER) is
      do
	 if code = code_require then
	    if require_assertion /= Void then
	       if not require_collector.fast_has(require_assertion) then
		  require_collector.add_last(require_assertion);
	       end;
	    end;
	 else
	    check
	       code = code_ensure;
	    end;
	    if ensure_assertion /= Void then
	       header_comment_memory.set_item(ensure_assertion.header_comment);
	       ensure_assertion.add_into(assertion_collector);
	    end;
	 end;
      end;
   
feature {NONE}
   
   frozen pretty_print_names is
	 -- Print only the names of the feature.
      local
	 i: INTEGER;
      do
	 from
	    i := 1;
	    pretty_print_one_name(names.item(i));
	    i := i + 1;
	 until
	    i > names.count
	 loop
	    fmt.put_string(", ");
	    pretty_print_one_name(names.item(i));
	    i := i + 1;
	 end;
      end;
   
   frozen pretty_print_one_name(a_name: FEATURE_NAME) is
      do
	 if a_name.is_frozen then
	    fmt.keyword("frozen");
	 end;
	 a_name.definition_pretty_print;
      end;
   
   pretty_print_arguments is do end;

   make_e_feature(n: like names; t: like result_type) is
      require
	 n.count >= 1;
      do
	 names := n; 
	 result_type := t; 
      ensure
	 names = n;
	 result_type = t;
      end;
   
feature {FEATURE_CLAUSE}
   
   add_into(fd: DICTIONARY[E_FEATURE,STRING]) is
	 -- Also check for multiple definitions.
      local
	 i: INTEGER;
	 fn: FEATURE_NAME;
      do
	 base_class := names.item(1).start_position.base_class;
	 from
	    i := 1;
	 until
	    i > names.count
	 loop
	    fn := names.item(i);
	    if fd.has(fn.to_key) then
	       fn := fd.at(fn.to_key).first_name;
	       eh.add_position(fn.start_position);
	       eh.add_position(names.item(i).start_position);
	       eh.error("Double definition of feature ");
	       eh.append(fn.to_string);
	       eh.error(fz_dot);
	    else
	       fd.put(Current,fn.to_key);
	    end;
	    i := i + 1;
	 end;
      end;

feature {C_PRETTY_PRINTER}

   stupid_switch(up_rf: RUN_FEATURE; r: ARRAY[RUN_CLASS]): BOOLEAN is
	 -- True when it is stupid do such a switch.
	 -- Assume all `base_feature' of `r' is Current.
      require
	 run_control.boost;
	 small_eiffel.is_ready;
	 up_rf.base_feature = Current;
	 up_rf.run_class.running = r;
	 r.count > 1
      deferred
      end;

feature {NONE}
   
   try_to_undefine_aux(fn: FEATURE_NAME; 
		       bc: BASE_CLASS): DEFERRED_ROUTINE is
      require
	 fn /= Void;
	 bc /= Void
      deferred
      end;

   em1: STRING is " Cannot merge thoses features.";
   em2: STRING is " Cannot inherit thoses features in "

invariant
   
   names /= Void;
   
end -- E_FEATURE

