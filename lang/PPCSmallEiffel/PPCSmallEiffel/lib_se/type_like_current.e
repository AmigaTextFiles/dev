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
class TYPE_LIKE_CURRENT
--
-- For an anchored declaration type mark on Current.
-- 
-- See also TYPE_LIKE_ARG and TYPE_LIKE.
--   

inherit TYPE_ANCHORED redefine is_like_current end;
   
creation make
   
feature 
   
   like_what: E_CURRENT;
   
   make(sp: like start_position; lw: EXPRESSION) is
      require
	 sp /= Void;
	 lw /= Void;
	 lw.is_current
      do
	 start_position := sp;
	 like_what ?= lw;
	 -- *** SHOULD BE DONE IN EIFFEL_PARSER ***
      ensure      
      	 start_position = sp;
	 like_what = lw;
      end;
   
feature 
   
   is_like_current: BOOLEAN is true;
   
   to_runnable(ct: TYPE): like Current is
      do
	 if run_type = Void then
	    run_type := ct.run_type;
	    Result := Current;
	 else
	    !!Result.make(start_position,like_what);
	    Result := Result.to_runnable(ct);
	 end;
      end;

   written_mark: STRING is
      do
	 Result := us_like_current;
      end;
   
feature {TYPE}

   short_hook is
      do
	 short_print.hook_or("like","like ");
	 short_print.hook_or(us_current,us_current);
      end;

invariant
   
   like_what /= Void

end -- TYPE_LIKE_CURRENT

