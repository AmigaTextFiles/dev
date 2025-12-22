-- Part of SmallEiffel -- Read DISCLAIMER file -- Copyright (C) 
-- Dominique COLNET and Suzanne COLLIN -- colnet@loria.fr
--
class EXAMPLE
   --
   -- The Eiffel program is running first, then call the C program 
   -- which is in charge to print the contents of `values' using
   -- `item' of ARRAY[INTEGER].
   --
   -- To compile this example, use command :
   --   
   --         compile -cecil cecil.se example c_prog.c
   --

creation make

feature

   make is
      do
	 values := <<1,2,3>>;
	 call_c_prog(values.to_pointer);
      end;

feature {NONE}

   values: ARRAY[INTEGER];

   call_c_prog(pointer_to_values: POINTER) is
      external "C_WithoutCurrent"
      alias "c_prog"
      end;

end -- EXAMPLE
