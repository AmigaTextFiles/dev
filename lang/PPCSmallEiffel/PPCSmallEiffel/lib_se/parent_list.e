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
class PARENT_LIST
   -- 
   -- To store the parent list of a class.
   -- 

inherit GLOBALS;

creation make
   
feature 
   
   base_class: BASE_CLASS;
	 -- Where the parent list is written.
      
   start_position: POSITION;
	 -- Of the keyword "inherit".
   
   heading_comment: COMMENT;
	 -- Global comment of the inherit clause.
   
feature {NONE}
   
   list: ARRAY[PARENT];
      
feature 
   
   make(bc: like base_class; sp: like start_position; 
	hc: like heading_comment; l: like list) is
      require
	 bc /= Void;
	 sp /= Void;
	 l.lower = 1 and not l.empty;
      do
	 base_class := bc;
	 heading_comment := hc;
	 start_position := sp;
	 list := l;
      ensure
	 base_class = bc;
	 start_position = sp;
	 heading_comment = hc;
	 list = l;
      end;
   
   count: INTEGER is
      do
	 Result := list.upper;
      end;
   
   up_to_any_in(pl: FIXED_ARRAY[BASE_CLASS]) is
      local
	 i: INTEGER;
	 p: PARENT;
	 bc: BASE_CLASS;
      do
	 from  
	    i := list.upper;
	 until
	    i = 0 
	 loop
	    p := list.item(i);
	    bc := p.type.base_class;
	    if not pl.fast_has(bc) then
	       pl.add_last(bc);
	    end;
	    i := i - 1;
	 end;
	 from  
	    i := list.upper;
	 until
	    i = 0 
	 loop
	    p := list.item(i);
	    bc := p.type.base_class;
	    if bc /= class_any then
	       bc.up_to_any_in(pl);
	    end;
	    i := i - 1;
	 end;
      end;

   base_class_name: CLASS_NAME is
      do
	 Result := base_class.base_class_name;
      end;
   
   has_redefine(fn: FEATURE_NAME): BOOLEAN is
      require
	 fn /= Void
      local
	 i: INTEGER;
      do
	 from  
	    i := 1;
	 until
	    Result or else i > list.upper
	 loop
	    Result := list.item(i).has_redefine(fn); 
	    i := i + 1;
	 end;
      end;
   
   super: PARENT is
      require
	 count = 1
      do
	 Result := list.first;
      end;

feature {TYPE}

   smallest_ancestor(ctx: TYPE): TYPE is
      require
	 ctx.is_run_type;
      local
	 i: INTEGER;
	 p: PARENT;
	 sa: TYPE;
      do
	 from  
	    i := list.upper;
	 until
	    i = 0
	 loop
	    p := list.item(i);
	    sa := p.smallest_ancestor(ctx).run_type;
	    if Result = Void then
	       Result := sa;
	    else
	       Result := sa.smallest_ancestor(Result);
	    end;
	    if Result.is_any then
	       i := 0;
	    else
	       i := i - 1;
	    end;
	 end;
      ensure
	 Result.is_run_type;
      end;

feature {BASE_CLASS}
   
   up_to_original(bottom: BASE_CLASS; top_fn: FEATURE_NAME): FEATURE_NAME is
      local
	 p1, p2: PARENT;
	 fn1, fn2, new_fn: FEATURE_NAME;
	 i: INTEGER;
      do
	 from
	    i := list.upper;
	 until
	    i = 0 or else fn1 /= Void
	 loop
	    p1 := list.item(i);
	    fn1 := p1.up_to_original(bottom,top_fn);
	    i := i - 1;
	 end;
	 from
	 until
	    i = 0 
	 loop
	    p2 := list.item(i);
	    fn2 := p2.up_to_original(bottom,top_fn);
	    if fn2 /= Void then
	       new_fn := p2.do_rename(top_fn);
	       if p2.has_select_for(new_fn) then
		  p1 := p2;
		  fn1 := fn2;
	       end;
	    end;
	    i := i - 1;
	 end;
	 if fn1 /= Void then
	    if fn1.to_string /= top_fn.to_string then
	       Result := repeated_inheritance(p1,fn1,top_fn);
	    else
	       Result := fn1;
	    end;
	 end;
      end;

   clients_for(fn: FEATURE_NAME): CLIENT_LIST is
      require
	 fn /= Void
      local
	 i: INTEGER;
	 cl: CLIENT_LIST;
      do
	 from  
	    i := list.upper;
	 until
	    i = 0
	 loop
	    cl := list.item(i).clients_for(fn); 
	    if Result = Void then
	       Result := cl;
	    elseif cl /= Void then
	       Result := Result.append(cl);
	    end;
	    if Result /= Void and then Result.gives_permission_to_any then
	       i := 0;
	    else
	       i := i - 1;
	    end;
	 end;
      ensure
	 Result /= Void
      end;

   going_up(trace: FIXED_ARRAY[PARENT]; top: BASE_CLASS; 
	    top_fn: FEATURE_NAME;): FEATURE_NAME is
      require
	 top /= Void;
	 top_fn /= Void
      local
	 i: INTEGER;
	 p1, p2: PARENT;
	 fn1, fn2: FEATURE_NAME;
      do
	 from
	    i := list.upper;
	 until
	    fn1 /= Void or else i = 0
	 loop
	    p1 := list.item(i);
	    fn1 := p1.going_up(trace,top,top_fn);
	    i := i - 1;
	 end;
	 from
	 until
	    i = 0
	 loop
	    p2 := list.item(i);
	    fn2 := p2.going_up(trace,top,top_fn);
	    if fn2 /= Void then
	       if p2.has_select_for(fn2) then
		  p1 := p2;
		  fn1 := fn2;
	       end;
	    end;
	    i := i - 1;
	 end;
	 Result := fn1;
      end;

   is_a_vncg(t1, t2: TYPE): BOOLEAN is
      require
	 t1.run_type = t1;
	 t2.run_type = t2;
	 t2.generic_list /= Void;
	 eh.empty
      local
	 i: INTEGER;
      do
	 from
	    i := list.upper;
	 until
	    Result or else i = 0
	 loop
	    Result := list.item(i).is_a_vncg(t1,t2);
	    i := i - 1;
	 end;
      ensure
	 eh.empty
      end;

   has(fn: FEATURE_NAME): BOOLEAN is
      local
	 i: INTEGER;
      do
	 from
	    i := list.upper;
	 until
	    Result or else i = 0
	 loop
	    Result := list.item(i).has(fn);
	    i := i - 1;
	 end;
      end;
   
   collect_invariant(rc: RUN_CLASS) is
      require
	 rc /= Void
      local
	 i: INTEGER;
      do
	 from
	    i := list.upper;
	 until
	    i = 0
	 loop
	    list.item(i).type.base_class.collect_invariant(rc);
	    i := i - 1;
	 end;
      end;
   
   inherit_cycle_check is
      local
	 i: INTEGER;
	 p: PARENT;
	 bc: BASE_CLASS;
      do
	 from  
	    i := list.upper;
	 until
	    i = 0
	 loop
	    p := list.item(i);
	    bc := p.type.base_class;
	    if bc = Void then
	       eh.add_position(p.start_position);
	       fatal_error(fz_cnf);
	    else
	       bc.inherit_cycle_check;
	    end;
	    i := i - 1;
	 end;
      end;

   has_parent(c: BASE_CLASS): BOOLEAN is
      require
	 not c.is_any
      local
	 i: INTEGER;
	 bc: BASE_CLASS;
      do
	 from  
	    i := list.upper;
	 until
	    i = 0
	 loop
	    bc := list.item(i).type.base_class;
	    if c = bc then
	       Result := true;
	       i := 0;
	    elseif bc.is_subclass_of_aux(c) then
	       Result := true;
	       i := 0;
	    else
	       i := i - 1;
	    end;
	 end;
      end;

feature {BASE_CLASS}
   
   first_parent_for(c: BASE_CLASS): PARENT is
	 -- Gives the first parent going to `c'.
      local
	 i: INTEGER;
	 pbc: BASE_CLASS;
      do
	 from  
	    i := 1;
	 until
	    Result /= Void
	 loop
	    Result := list.item(i);
	    pbc := Result.type.base_class;
	    if pbc = c then
	    elseif pbc.is_subclass_of(c) then
	    else
	       Result := Void;
	    end;
	    i := i + 1;
	 end;
      ensure
	 Result /= Void
      end;
   
   next_parent_for(c: BASE_CLASS; previous: PARENT): like previous is
	 -- Gives the next one or Void.
      local
	 i: INTEGER;
	 pbc: BASE_CLASS;
      do
	 from  
	    from
	       i := 1;
	    until
	       Result = previous
	    loop
	       Result := list.item(i);
	       i := i + 1;
	    end;
	    Result := Void;
	 until
	    Result /= Void or else i > list.count
	 loop
	    Result := list.item(i);
	    pbc := Result.type.base_class;
	    if pbc = c then
	    elseif pbc.is_subclass_of(c) then
	    else
	       Result := Void;
	    end;
	    i := i + 1;
	 end;
      end;

feature {BASE_CLASS}

   header_comment_for(ci: CLASS_INVARIANT) is
      local
	 i: INTEGER;
      do
	 from
	    i := list.upper;
	 until
	    i = 0 or else ci.header_comment /= Void
	 loop
	    list.item(i).type.base_class.header_comment_for(ci);
	    i := i - 1;
	 end;
      end;

feature {BASE_CLASS}
   
   get_started is
      local
	 i1, i2: INTEGER;
	 p1, p2: PARENT;
      do
	 from  
	    i1 := list.upper;
	 until
	    i1 = 0
	 loop
	    list.item(i1).get_started(Current);
	    i1 := i1 - 1;
	 end;
	 if list.upper > 1 then
	    -- Checking select :
	    from  
	       i2 := list.upper;
	    until
	       i2 = 1
	    loop
	       from
		  i1 := 1;
	       invariant
		  i1 < i2 + 1
	       variant
		  i2 - i1
	       until
		  i1 = i2
	       loop
		  p1 := list.item(i1);
		  p2 := list.item(i2);
		  p1.multiple_check(p2);
		  p2.multiple_check(p1);
		  i1 := i1 + 1;
	       end;
	       i2 := i2 - 1;
	    end;
	 end;
      end;

feature {BASE_CLASS}

   look_up_for(rc: RUN_CLASS; fn: FEATURE_NAME): E_FEATURE is
      local
	 i: INTEGER;
	 p1, p2: PARENT;
	 f1, f2: E_FEATURE;
      do
	 from
	    i := list.upper;
	 until
	    f1 /= Void or else i = 0
	 loop
	    p1 := list.item(i);
	    f1 := p1.look_up_for(rc,fn);
	    i := i - 1;
	 end;
	 from
	 until
	    i = 0 
	 loop
	    p2 := list.item(i);
	    f2 := p2.look_up_for(rc,fn);
	    if f2 = Void then
	    elseif f1 = f2 then
	    elseif not f2.is_merge_with(f1,rc) then
	       eh.add_position(start_position);
	       eh.add_position(f1.start_position);
	       eh.add_position(f2.start_position);
	       fatal_error(fz_ich);
	    elseif f2.is_deferred then
	    elseif f1.is_deferred then
	       f1 := f2;
	       p1 := p2;
	    elseif p1.has_redefine(fn) then
	       if p2.has_redefine(fn) then
	       else
		  eh.add_position(fn.start_position);
		  eh.add_position(p2.start_position);
		  eh.add_position(f2.start_position);
		  eh.append(em1); 
		  eh.print_as_fatal_error;
	       end;
	    elseif p2.has_redefine(fn) then
	       eh.add_position(fn.start_position);
	       eh.add_position(p1.start_position);
	       eh.add_position(f1.start_position);
	       eh.append(em1); 
	       eh.print_as_fatal_error;
	    else
	       eh.add_position(p2.start_position);
	       eh.add_position(p1.start_position);
	       eh.add_position(f1.start_position);
	       eh.add_position(f2.start_position);
	       eh.append(em1); 
	       eh.print_as_fatal_error;
	    end;
	    i := i - 1;
	 end;
	 Result := f1;
      end;
   
   collect_for(code: INTEGER; fn: FEATURE_NAME) is
      require
	 code = code_require or else code = code_ensure;
	 fn /= Void;
      local
	 i: INTEGER;
      do
	 from
	    i := 1;
	 until
	    i > list.upper
	 loop
	    list.item(i).collect_for(code,fn);
	    i := i + 1;
	 end;
      end;
   
   pretty_print is
      local
	 i: INTEGER;
      do
	 fmt.set_indent_level(0);
	 if fmt.zen_mode then
	    fmt.indent;
	 else
	    fmt.skip(1);
	 end;
	 fmt.keyword("inherit");
	 fmt.set_indent_level(1);
	 fmt.indent;
	 if heading_comment /= Void then
	    heading_comment.pretty_print;
	 end;
	 from  
	    i := 1;
	 until
	    i > list.upper
	 loop
	    list.item(i).pretty_print;
	    i := i + 1;
	 end;
      end;

feature {NONE}

   repeated_inheritance(p1: PARENT; fn1, top_fn: FEATURE_NAME): FEATURE_NAME is
      require
	 p1 /= void;
	 fn1 /= Void;
	 top_fn /= Void
      local
	 i: INTEGER;
	 p2: PARENT;
	 bc1: BASE_CLASS;
      do
--***	 eh.add_position(p1.start_position);
--***	 eh.add_position(top_fn.start_position);
--***	 warning(fn1.start_position,"REPEATED INHERITANCE");

	 from
	    bc1 := p1.type.base_class;
	    i := list.upper;
	 until
	    i = 0
	 loop
	    p2 := list.item(i);
	    if p1 /= p2 then
	       if bc1 = p2.type.base_class then
		  if p2.do_rename(fn1).to_string = top_fn.to_string then
		     Result := top_fn;
		  elseif p1.do_rename(fn1).to_string = top_fn.to_string then
		     Result := top_fn;
		  end;
	       end;
	    end;
	    i := i - 1;
	 end;
	 if Result = Void then
	    Result := fn1;
	 end;
      ensure
	 top_fn /= Void
      end;
	    

feature {NONE}

   em1: STRING is "Inheritance clash.";

invariant
   
   base_class /= Void;
   
   list.lower = 1;
   
   not list.empty;
   
end -- PARENT_LIST

