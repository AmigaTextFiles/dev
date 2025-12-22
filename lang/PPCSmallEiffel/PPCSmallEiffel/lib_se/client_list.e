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
class CLIENT_LIST
   --   
   -- To store a list of clients class like : {FOO,BAR}
   -- 
   
inherit GLOBALS;

creation {EIFFEL_PARSER,CLIENT_LIST}
   make, omitted

creation {CLIENT_LIST}
   merge

feature {NONE}
   
   start_position: POSITION;
	 -- Of the the opening bracket when list is really written.
   
feature {CLIENT_LIST}
   
   list: CLASS_NAME_LIST;
   
feature {NONE}
   
   make(sp: like start_position; l: ARRAY[CLASS_NAME]) is
	 -- When the client list is really written.
	 -- 
	 -- Note : {NONE} has the same meaning as {}.
      require
	 sp /= Void;
	 l /= Void implies not l.empty
      do
	 start_position := sp;
	 if l /= Void then
	    !!list.make(l);
	 end;
      ensure      
	 start_position = sp;
      end;
   
   omitted is
	 -- When the client list is omitted. 
	 --
	 -- Note : it has the same meaning as {ANY}.
      do
      end;
   
   merge(sp: like start_position; l1, l2: like list) is
      require
	 sp /= Void
      do
	 start_position := sp;
	 !!list.merge(l1,l2);
      end;

feature 
   
   is_omitted: BOOLEAN is
      do
	 Result := start_position = Void;
      end;
   
   pretty_print is
      do
	 if is_omitted then
	    if fmt.zen_mode then
	    else	       
	       fmt.put_string("{ANY}");
	    end
	 else 
	    if list = Void then
	       if fmt.zen_mode then
		  fmt.put_string("{}");
	       else
		  fmt.put_string("{NONE}");
	       end;
	    else
	       fmt.put_character('{');
	       fmt.set_indent_level(2);
	       list.pretty_print;
	       fmt.put_character('}');
	    end;
	 end;
      end;

   gives_permission_to(cn: CLASS_NAME): BOOLEAN is
	 -- True if the client list give permission to `cn'.
	 -- When false, `eh' is preloaded with beginning of 
	 -- error message.
      require
	 cn /= Void
      do
	 if is_omitted then
	    Result := true;    
	    -- Because it is as : {ANY}.
	 elseif list = Void then
	    -- Because it is as : {NONE}.
	 else
	    Result := list.gives_permission_to(cn);
	 end;
	 if not Result then
	    eh.add_position(start_position);
	    eh.append(cn.to_string); 
	    eh.append(" is not allowed to use feature.");
	 end;
      end;
   
feature {PARENT_LIST}

   append(other: like Current): like Current is
      require
	 other /= Void
      do
	 if (Current = other or else 
	     is_omitted or else 
	     gives_permission_to_any)
	  then
	    Result := Current;
	 elseif (other.is_omitted or else
		 other.gives_permission_to_any)
	  then
	    Result := other;
	 else
	    !!Result.merge(start_position,list,other.list);
	 end;
      end;

feature

   gives_permission_to_any: BOOLEAN is
      do
	 if is_omitted then
	    Result := true;    
	    -- Because it is as : {ANY}.
	 elseif list = Void then
	    -- Because it is as : {NONE}.
	 else
	    Result := list.gives_permission_to_any;
	 end;
      end;

end -- CLIENT_LIST

