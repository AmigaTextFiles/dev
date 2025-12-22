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
class TYPE_LIKE_FEATURE
--
-- For an anchored declaration type mark using a feature name.
-- 
-- See also TYPE_LIKE_ARG and TYPE_LIKE_CURRENT.
--   

inherit 
   TYPE_ANCHORED 
      redefine is_like_feature, like_feature
      end;
   
creation make
   
feature 
   
   like_what: FEATURE_NAME;
   
   written_mark: STRING;
   
feature 
   
   make(sp: like start_position; lw: like like_what) is
      require
	 sp /= Void;
	 lw /= Void
      do
	 start_position := sp;
	 like_what := lw;
	 tmp_written_mark.copy(fz_like_foo);
	 tmp_written_mark.append(like_what.to_string);
	 written_mark := unique_string.item(tmp_written_mark);
      ensure
	 start_position = sp
      end;
   
   like_feature: FEATURE_NAME is
      do
	 Result := like_what; 
      end;
   
   is_like_feature: BOOLEAN is true;
   
   to_runnable(ct: TYPE): like Current is
      local
	 t: TYPE;
	 f: E_FEATURE;
	 rc: RUN_CLASS;
      do
	 anchor_cycle_start;
	 rc := ct.run_class;
	 f := ct.look_up_for(rc,like_what);
	 if f = Void then
	    error(start_position,"Bad anchor. Feature not found.");
	 else
	    t := f.result_type;
	    if t = Void then
	       eh.add_position(f.start_position);
	       error(start_position,
		     "Bad anchor. Feature found cannot be an anchor.");
	    else
	       t := t.to_runnable(ct);
	       if t = Void then
		  error(start_position,fz_bad_anchor);
	       else
		  Result := ultimate_run_type(t.run_type);
	       end;
	    end;
	 end;
	 anchor_cycle_end;
      end;
   
feature {TYPE}

   short_hook is
      do
	 short_print.hook_or("like","like ");
	 like_what.short;
      end;

end -- TYPE_LIKE_FEATURE

