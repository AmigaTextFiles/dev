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
class E_CHECK
   --
   -- Instruction "check ... end;".
   --
   
inherit INSTRUCTION redefine is_pre_computable end;

creation make

feature 
      
   check_invariant: CHECK_INVARIANT;
   
feature 
      
   make(sp: like start_position; hc: COMMENT; l: ARRAY[ASSERTION]) is
      require
	 sp /= Void;
	 not l.empty;
      do
	 !!check_invariant.make(sp,hc,l);
      ensure
	 start_position = sp;
	 check_invariant.list = l;
      end; 
   
feature

   end_mark_comment: BOOLEAN is true;

feature
   
   start_position: POSITION is
	 -- Of keyword "check".
      do
	 Result := check_invariant.start_position;
      end;
   
   to_runnable(rc: like run_compound): like Current is
      local
	 al: like check_invariant;
      do
	 if run_compound = Void then
	    run_compound := rc;
	    if run_control.all_check then
	       al := check_invariant.to_runnable(rc.current_type);
	       if al = Void then
		  error(start_position,"Bad check list.");
	       else
		  check_invariant := al;
		  Result := Current;
	       end;
	    else
	       Result := Current;
	    end;
	 else
	    !!Result.make(start_position,Void,check_invariant.list);
	    Result := Result.to_runnable(rc);
	 end;
      end;
   
   afd_check is   
      do
	 if run_control.all_check then
	    check_invariant.afd_check;
	 end;
      end;
   
   compile_to_c is   
      do
	 if run_control.all_check then
	    check_invariant.compile_to_c;
	 end;
      end;
   
   compile_to_jvm is
      do
	 if run_control.all_check then
	    check_invariant.compile_to_jvm(true);
	 end;
      end;
   
   is_pre_computable: BOOLEAN is 
      do
	 if run_control.all_check then
	    Result := check_invariant.is_pre_computable;
	 else
	    Result := true;
	 end;
      end;

   use_current: BOOLEAN is   
      do
	 if run_control.all_check then
	    Result := check_invariant.use_current;
	 end;
      end;
   
   pretty_print is
      do
	 check_invariant.pretty_print;
	 fmt.put_string("end;");
	 if fmt.print_end_check then
	    fmt.put_end("check");
	 end;
      end;

invariant
   
   check_invariant /= Void;

end -- E_CHECK

