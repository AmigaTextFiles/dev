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
class PARENT
   --   
   -- To store the inheritance options for one parent of a class.
   --

inherit 
   GLOBALS
      redefine fill_tagged_out_memory 
      end;

creation {EIFFEL_PARSER} make 

feature 
   
   parent_list: PARENT_LIST;
	 -- Corresponding one;
   
   type: TYPE;
	 -- Declaration type mark of the parent.
   
   comment: COMMENT;
	 -- Associated heading comment.

feature {PARENT} -- Optionnal list in syntaxical order :
   
   rename_list: RENAME_LIST;
   
   export_list: EXPORT_LIST;

   undefine_list: FEATURE_NAME_LIST

   redefine_list: FEATURE_NAME_LIST;

   select_list: FEATURE_NAME_LIST;

feature {NONE}
   
   make(t: like type) is
      require
	 t /= Void;
	 not t.is_anchored;
	 t.start_position /= Void;
      do
	 type := t;
	 if forbidden_parent_list.fast_has(type.written_mark) then
	    eh.add_position(type.start_position);
	    eh.append("You cannot inherit %"");
	    eh.append(type.written_mark);
	    fatal_error("%" (not yet implemented).");
	 end;
      ensure
	 type = t
      end;
   
feature 

   start_position: POSITION is
      do
	 Result := type.start_position;
      end;
   
   has_undefine(fn: FEATURE_NAME): BOOLEAN is
      do
	 if undefine_list /= Void then
	    Result := undefine_list.has(fn);
	 end;
      end;
   
   look_up_for(rc: RUN_CLASS; fn: FEATURE_NAME): E_FEATURE is
      require
	 rc /= Void;
	 fn /= Void
      local
	 fn2: like fn;
	 f: E_FEATURE;
      do
	 if rename_list = Void or else not rename_list.affect(fn) then
	    f := type.look_up_for(rc,fn);
	    Result := apply_undefine(f,fn);
	 else
	    fn2 := rename_list.to_old_name(fn);
	    if fn2 /= fn then
	       f := type.look_up_for(rc,fn2);
	       Result := apply_undefine(f,fn2);
	    else
	       check
		  fn /= rename_list.to_new_name(fn);
	       end;
	       f := type.look_up_for(rc,fn);
	       if f = Void then
		  eh.add_position(fn.start_position);
		  eh.append(fz_09);
		  eh.append(fn.to_string);
		  fatal_error("%" is not a feature of the parent.");
	       end;
	    end;	    
	 end;
      end;
   
   collect_for(code: INTEGER; fn: FEATURE_NAME) is
      require
	 code = code_require or else code = code_ensure;
	 fn /= Void
      local
	 fn2: like fn;
      do
	 if rename_list = Void or else not rename_list.affect(fn) then
	    type.base_class.collect_for(code,fn);
	 else
	    fn2 := rename_list.to_old_name(fn);
	    if fn2 /= fn then
	       type.base_class.collect_for(code,fn2);
	    end;
	 end;
      end;
      
   has_redefine(fn: FEATURE_NAME): BOOLEAN is
      require
	 fn /= Void
      do
	 if redefine_list /= Void then
	    Result := redefine_list.has(fn);
	 end;
      end;
   
   fill_tagged_out_memory is
      local
	 p: POSITION;
      do
	 p := start_position;
	 if p /= Void then
	    p.fill_tagged_out_memory;
	 end;
      end;

feature {PARENT_LIST}

   multiple_check(other: like Current) is
	 -- Note : is called twice (whith swap) for each couple of
	 -- parents.
      require
	 other /= Current;
	 parent_list = other.parent_list
      local
	 bc1, bc2: BASE_CLASS;
	 i: INTEGER;
	 fn1, fn2: FEATURE_NAME;
      do
	 bc1 := type.base_class;
	 bc2 := other.type.base_class;
	 if bc1 = bc2 or else 
	    bc1.is_subclass_of(bc2) or else
	    bc2.is_subclass_of(bc1)
	  then
	    if redefine_list /= Void then
	       from
		  i := redefine_list.count
	       until
		  i = 0
	       loop
		  fn1 := redefine_list.item(i);
		  if other.rename_list = Void then
		  elseif other.rename_list.affect(fn1) then
		     fn2 := other.rename_list.to_new_name(fn1);
		     if fn2 /= fn1 then
			if select_list /= Void then
			   if select_list.has(fn1) then
			      if other.select_list /= Void then
				 if other.select_list.has(fn2) then
				    select_conflict(fn1,fn2);
				 end;
			      end;
			   elseif other.select_list = Void then
			      missing_select(fn1,fn2);
			   elseif not other.select_list.has(fn2) then
			      missing_select(fn1,fn2);
			   end;
			elseif other.select_list = Void then
			   missing_select(fn1,fn2);
			elseif not other.select_list.has(fn2) then
			   missing_select(fn1,fn2);
			end;
		     else
		     end;
		  end;
		  i := i - 1;
	       end;
	    end;
	 else
	    -- Nothing because of swapped duplicate call.
	 end;
      end;

   smallest_ancestor(ctx: TYPE): TYPE is
      require
	 ctx.is_run_type;
      do
	 if type.is_generic then
	    Result := type.to_runnable(ctx);
	 else
	    Result := type;
	 end;
      ensure
	 Result.is_run_type;
      end;

   do_rename(fn: FEATURE_NAME): like fn is
      do
	 if rename_list = Void then
	    Result := fn;
	 else
	    Result := rename_list.to_new_name(fn);
	 end;
      end;
   
feature {EIFFEL_PARSER}
   
   set_comment(c: like comment) is
      do
	 comment := c;
      end;
   
   add_rename(rp: RENAME_PAIR) is
      require
	 rp /= Void
      do
	 if rename_list = Void then
	    !!rename_list.make(<<rp>>);
	 else
	    rename_list.add_last(rp);
	 end;
      end;
   
   set_export(el: EXPORT_LIST) is
      require
	 el /= Void
      do
	 export_list := el;
      ensure
	 export_list = el
      end;
   
   set_undefine(fl: ARRAY[FEATURE_NAME]) is
      require
	 fl /= Void
      do
	 !!undefine_list.make(fl);
      end;
   
   set_redefine(fl: ARRAY[FEATURE_NAME]) is
      require
	 fl /= Void;
      do
	 !!redefine_list.make(fl);
      end;
   
   set_select(fl: ARRAY[FEATURE_NAME]) is
      require
	 fl /= Void
      do
	 !!select_list.make(fl);
      end;
   
feature {PARENT_LIST}

   is_a_vncg(t1, t2: TYPE): BOOLEAN is
      require
	 t1.run_type = t1;
	 t2.run_type = t2;
	 t2.generic_list /= Void;
	 eh.empty
      local
	 rank, i: INTEGER;
	 gl, gl1, gl2: ARRAY[TYPE];
	 tfg: TYPE_FORMAL_GENERIC;
	 rt: TYPE;
	 type_bc, t2_bc: BASE_CLASS;
	 type_bcn, t2_bcn: STRING;
      do
	 type_bc := type.base_class;
	 type_bcn := type_bc.base_class_name.to_string;
	 t2_bc := t2.base_class;
	 t2_bcn := t2_bc.base_class_name.to_string;
	 if type_bcn = t2_bcn then -- Here is a good parent :
	    gl := type.generic_list;
	    gl2 := t2.generic_list;
	    if gl = Void or else gl.count /= gl2.count then
	       eh.add_position(type.start_position);
	       eh.add_position(t2.start_position);
	       fatal_error("Bad number of generic arguments.");
	    end;
	    if t1.is_generic then 
	       gl1 := t1.generic_list;
	       from
		  Result := true;
		  i := gl2.count;
	       until
		  not Result or else i = 0
	       loop
		  if gl.item(i).is_formal_generic then
		     tfg ?= gl.item(i);
		     check
			tfg /= Void
		     end;
		     rank := tfg.rank;
		     Result :=  gl1.item(rank).is_a(gl2.item(i));
		  else
		     --
		     -- eh.add_type(type," is the good parent. ");
		     -- eh.add_type(t1," is T1. ");
		     -- eh.add_type(t2," is T2. ");
		     -- eh.print_as_warning;
		     --
		     rt := gl.item(i).to_runnable(t1).run_type;
		     Result := rt.is_a(gl2.item(i));
		  end;
		  i := i - 1;
	       end;
	    else
	       Result := type.is_a(t2);
	    end;
	    if not Result then
	       eh.cancel;
	    end;
	 elseif type_bc.is_subclass_of(t2_bc) then
	    if t1.is_generic then
	       rt := type.to_runnable(t1).run_type;
	       Result := type_bc.is_a_vncg(rt,t2);
	    else
	       Result := type_bc.is_a_vncg(type,t2);
	    end;
	    if not Result then
	       eh.cancel;
	    end;
	 end;
      ensure
	 eh.empty
      end;

   has(fn: FEATURE_NAME): BOOLEAN is
      do
	 if rename_list = Void then
	    Result := type.base_class.has(fn);
	 else
	    Result := type.base_class.has(rename_list.to_old_name(fn));
	 end;
      end;
   
   clients_for(fn: FEATURE_NAME): CLIENT_LIST is
      require
	 fn /= Void
      local
	 old_fn: like fn;
      do
	 if rename_list = Void then
	    if export_list = Void then
	       Result := type.base_class.clients_for(fn);
	    else
	       Result := export_list.clients_for(fn);
	       if Result = Void then
		  Result := type.base_class.clients_for(fn);
	       end;
	    end;
	 else
	    old_fn := rename_list.to_old_name(fn);
	    if export_list = Void then
	       Result := type.base_class.clients_for(old_fn);
	    else
	       Result := export_list.clients_for(old_fn);
	       if Result = Void then
		  Result := type.base_class.clients_for(old_fn);
	       end;
	    end;
	 end;
      end;
   
   pretty_print is
      local
	 end_needed: BOOLEAN;
      do
	 fmt.set_indent_level(1);
	 fmt.indent;
	 type.pretty_print;
	 if rename_list = Void and then
	    export_list = Void and then
	    undefine_list = Void and then
	    redefine_list = Void and then
	    select_list = Void then
	    fmt.put_character(';');
	 end;
	 if comment /= Void then
	    fmt.put_character(' ');
	    comment.pretty_print;
	 end;
	 if rename_list /= Void then
	    end_needed := true;
	    rename_list.pretty_print;
	 end;
	 if export_list /= Void then
	    end_needed := true;
	    export_list.pretty_print;
	 end;
	 if undefine_list /= Void then
	    end_needed := true;
	    fmt.set_indent_level(2);
	    fmt.indent;
	    fmt.keyword("undefine");
	    undefine_list.pretty_print;
	 end;
	 if redefine_list /= Void then
	    end_needed := true;
	    fmt.set_indent_level(2);
	    fmt.indent;
	    fmt.keyword("redefine");
	    redefine_list.pretty_print;
	 end;
	 if select_list /= Void then
	    end_needed := true;
	    fmt.set_indent_level(2);
	    fmt.indent;
	    fmt.keyword("select");
	    select_list.pretty_print;
	 end;
	 if end_needed then
	    fmt.set_indent_level(2);
	    fmt.indent;
	    fmt.keyword("end;");
	 end;
	 fmt.set_indent_level(1);
	 fmt.indent;
      end;
   
   get_started(pl: like parent_list) is
      require
	 pl /= Void;
      local
	 i: INTEGER;
	 wbc, pbc: BASE_CLASS;
	 fn, old_fn, new_fn: FEATURE_NAME;
	 all_check: BOOLEAN;
      do
	 all_check := run_control.all_check;
	 parent_list := pl;
	 pbc := type.base_class;
	 wbc := parent_list.base_class;
	 if all_check and then rename_list /= Void then
	    rename_list.get_started(pbc);
	 end;
	 if all_check and then undefine_list /= Void then
	    from  
	       i := undefine_list.count;
	    until
	       i = 0
	    loop
	       fn := undefine_list.item(i);
	       old_fn := get_old_name(fn);
	       if old_fn = Void and then not pbc.has(fn) then
		  eh.add_position(fn.start_position);
		  fatal_error("Cannot undefine unexistant feature (VDUS.1).");
	       end;
	       i := i - 1;
	    end;
	 end;
	 if redefine_list /= Void then
	    from
	       i := redefine_list.count;
	    until
	       i = 0 
	    loop
	       fn := redefine_list.item(i);
	       if not wbc.proper_has(fn) then
		  eh.add_position(fn.start_position);
		  fatal_error("Redefinition not found.");
	       end;
	       if all_check then
		  old_fn := get_old_name(fn);
		  if old_fn = Void and then not pbc.has(fn) then
		     eh.add_position(fn.start_position);
		     fatal_error("Cannot redefine unexistant feature (VDRS.1).");
		  end;
	       end;
	       i := i - 1;
	    end;
	 end;
	 if all_check and then select_list /= Void then
	    from
	       i := select_list.count;
	    until
	       i = 0 
	    loop
	       fn := select_list.item(i);
	       old_fn := get_old_name(fn);
	       if old_fn = Void and then not pbc.has(fn) then
		  eh.add_position(fn.start_position);
		  fatal_error(em1);
	       end;
	       new_fn := get_new_name(fn);
	       if new_fn /= Void then
		  if get_old_name(new_fn) = Void then
		     eh.add_position(new_fn.start_position);
		     eh.add_position(fn.start_position);
		     fatal_error(em1);
		  end;
	       end;
	       i := i - 1;
	    end;
	 end;
      ensure
	 parent_list = pl
      end;

feature {NONE}

   forbidden_parent_list: ARRAY[STRING] is
      once
	 Result := <<us_none,us_boolean,us_integer,us_character,
		     us_real,us_double,us_bit,us_pointer,
		     us_native_array>>;
      end;

feature {NONE}

   get_old_name(fn: FEATURE_NAME): like fn is
      do
	 if rename_list /= Void then
	    Result := rename_list.to_old_name(fn);
	    if Result = fn then
	       Result := Void;
	    end;
	 end;
      end;

   get_new_name(fn: FEATURE_NAME): like fn is
      do
	 if rename_list /= Void then
	    Result := rename_list.to_new_name(fn);
	    if Result = fn then
	       Result := Void;
	    end;
	 end;
      end;

   check_no_old_name(fn: FEATURE_NAME) is
      local
	 old_name: like fn;
      do
	 if rename_list /= Void then
	    old_name := rename_list.to_old_name(fn);
	    if old_name /= fn then
	       eh.add_position(fn.start_position);
	       eh.add_position(old_name.start_position);
	       eh.append("Feature %"");
	       eh.append(old_name.to_string);
	       fatal_error("%" is renamed.");
	    end;
	 end;
      end;

feature {PARENT}

   going_down(trace: FIXED_ARRAY[PARENT]; fn: FEATURE_NAME;): FEATURE_NAME is
      require
	 trace /= Void;
	 fn /= Void
      local
	 previous: like Current;
      do
	 if rename_list = Void then
	    Result := fn;
	 else
	    Result := rename_list.to_new_name(fn);
	 end;
	 if not trace.empty then
	    previous := trace.last;
	    trace.remove_last;
	    Result := previous.going_down(trace,Result);
	 end;
      ensure
	 Result /= Void
      end;

feature {PARENT_LIST}

   up_to_original(bottom: BASE_CLASS; top_fn: FEATURE_NAME): FEATURE_NAME is
      local
	 old_name: FEATURE_NAME;
	 bc: BASE_CLASS;
      do
	 bc := type.base_class;
	 if rename_list = Void then
	    Result := bc.up_to_original(bottom,top_fn);
	 elseif rename_list.affect(top_fn) then
	    old_name := rename_list.to_old_name(top_fn);
	    if old_name /= top_fn then
	       Result := bc.up_to_original(bottom,old_name);
	    end;
	 else
	    Result := bc.up_to_original(bottom,top_fn);
	 end;
      end;

   going_up(trace: FIXED_ARRAY[PARENT]; top: BASE_CLASS; 
	    top_fn: FEATURE_NAME;): FEATURE_NAME is
      local
	 bc: BASE_CLASS;
      do
	 bc := type.base_class;
	 if bc = top then
	    Result := going_down(trace,top_fn);
	 elseif bc.is_general then
	    Result := going_down(trace,top_fn);
	 elseif bc.is_subclass_of(top) then
	    trace.add_last(Current);
	    Result := bc.going_up(trace,top,top_fn);
	 end;
      end;

   has_select_for(fn: FEATURE_NAME): BOOLEAN is
      do
	 if select_list /= Void then
	    Result := select_list.has(fn);
	 end;
      end;

feature {NONE}

   apply_undefine(f: E_FEATURE; fn: FEATURE_NAME): E_FEATURE is
      local
	 fnkey: STRING;
	 index: INTEGER;
      do
	 if has_undefine(fn) then
	    fnkey := fn.to_key;
	    if undefine_memory1 = Void then
	       undefine_memory1 := <<fnkey>>;
	       Result := f.try_to_undefine(fn,parent_list.base_class);
	       undefine_memory2 := <<Result>>;
	    else
	       index := undefine_memory1.fast_index_of(fnkey);
	       if index > undefine_memory1.upper then
		  undefine_memory1.add_last(fnkey);
		  Result := f.try_to_undefine(fn,parent_list.base_class);
		  undefine_memory2.add_last(Result);
	       else
		  Result := undefine_memory2.item(index);
	       end;
	    end;
	 else
	    Result := f;
	 end;
      end;

   undefine_memory1: ARRAY[STRING];

   undefine_memory2: ARRAY[E_FEATURE];

feature {NONE}

   select_conflict(fn1, fn2: FEATURE_NAME) is
      do
	 eh.add_position(fn1.start_position)
	 eh.add_position(fn2.start_position)
	 eh.append("Select conflict for those features.");
	 eh.print_as_fatal_error;
      end;

   missing_select(fn1, fn2: FEATURE_NAME) is
      do
	 eh.add_position(fn1.start_position)
	 eh.add_position(fn2.start_position)
	 eh.append("Missing select clause for those features.");
	 eh.print_as_fatal_error;
      end;

feature

   em1: STRING is "Cannot select unexistant feature (VMSS).";

invariant
   
   not type.is_anchored;
   
   type.start_position /= Void;
   
end -- PARENT

