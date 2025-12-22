-- Part of SmallEiffel -- Read DISCLAIMER file -- Copyright (C) 
-- Dominique COLNET and Suzanne COLLIN -- colnet@loria.fr
--
class EXTERNAL_DEMO
   --   
   -- How to use external (calling C from Eiffel);
   --
   -- You can compile this file doing :
   --       compile external_demo make src.c
   -- or doing :
   --       compile external_demo make src.o
   -- 
   -- Execution should gives output like `external_demo.good_output'.
   --
creation {ANY}
   make
   
feature {ANY}
   
   make is
      do
	 integer2c(6);
	 character2c('a');
	 boolean2c(true);
	 real2c(3.5);
	 double2c((3.5).to_double);
	 double2c(3.5);
	 string2c(("Hi C World %N").to_external);
	 any2c(Current);
	 any2c("Hi");
	 current2c;
	 std_output.put_integer(integer2eiffel);
	 std_output.put_character(character2eiffel);
      end;
   
   integer2c(i: INTEGER) is
	 -- Send an INTEGER to C
      external "C_WithoutCurrent"
      end;
   
   character2c(c: CHARACTER) is
	 -- Send a CHARACTER to C
      external "C_WithoutCurrent"
      end;
   
   boolean2c(b: BOOLEAN) is
	 -- Send a BOOLEAN to C
      external "C_WithoutCurrent"
      end;
   
   real2c(r: REAL) is
	 -- Send a REAL to C
      external "C_WithoutCurrent"
      end;
   
   double2c(d: DOUBLE) is
	 -- Send a DOUBLE to C
      external "C_WithoutCurrent"
      end;

   string2c(s: POINTER) is
	 -- Send a STRING to C
      external "C_WithoutCurrent"
      end;

   any2c(a: ANY) is
	 -- Send a reference to C
      external "C_WithoutCurrent"
      end;

   current2c is
	 -- Also send Current to C.
      external "C_WithCurrent"
      end;

   integer2eiffel: INTEGER is
	 -- Receive an INTEGER from C
      external "C_WithoutCurrent"
      end;

   character2eiffel: CHARACTER is
	 -- Receive a CHARACTER from C
      external "C_WithoutCurrent"
      end;

end -- EXTERNAL_DEMO

