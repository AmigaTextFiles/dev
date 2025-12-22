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
class TYPE_LIKE_ARGUMENT
   --
   -- For an anchored declaration type mark using a formal argument.
   -- 
   -- See also TYPE_LIKE and TYPE_LIKE_CURRENT.
   -- 

inherit TYPE_ANCHORED;
   
creation make
   
feature 
   
   like_what: ARGUMENT_NAME2;

   written_mark: STRING;

feature {NONE}
   
   make(sp: like start_position; lw: like like_what) is
      require
	 sp /= Void;
	 lw /= Void;
      do
	 start_position := sp;
	 like_what := lw;
	 tmp_written_mark.copy(fz_like_foo);
	 tmp_written_mark.append(like_what.to_string);
	 written_mark := unique_string.item(tmp_written_mark);
      ensure
	 start_position = sp;
	 like_what = lw;
      end;

feature
   
   to_runnable(ct: TYPE): like Current is
      local
	 t: TYPE;
      do
	 anchor_cycle_start;
	 t := like_what.result_type.to_runnable(ct);
	 if t = Void then
	    error(start_position,fz_bad_anchor);
	 end;
	 Result := ultimate_run_type(t);
	 anchor_cycle_end;
      end;

feature 
   
   rank: INTEGER is
      do
	 Result := like_what.rank;
      end;

feature {TYPE}

   short_hook is
      do
	 short_print.hook_or("like","like ");
	 like_what.short;
      end;

invariant
   
   not ("Current").same_as(like_what.to_string)

end -- TYPE_LIKE_ARGUMENT

