-- Part of SmallEiffel -- Read DISCLAIMER file -- Copyright (C) 
-- Dominique COLNET and Suzanne COLLIN -- colnet@loria.fr
--
class EXAMPLE
   --
   -- The Eiffel program is running first, then call the C program 
   -- which is in charge to print the contents of `animals' using
   -- `lower'/`upper'/`item' of ARRAY[ANIMAL].
   --
   -- To compile this example, use command :
   --   
   --         compile -cecil cecil.se example c_prog.c
   --

creation make

feature

   make is
      local
	 cat: CAT;
	 dog: DOG;
      do
	 !!cat;
	 !!dog;
	 animals := <<cat,dog,cat>>;
	 call_c_prog(animals.to_pointer);
      end;

feature {NONE}

   animals: ARRAY[ANIMAL];

   call_c_prog(animals_ptr: POINTER) is
      external "C_WithoutCurrent"
      alias "c_prog"
      end;

end -- EXAMPLE
