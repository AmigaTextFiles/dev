-- This file is  free  software, which  comes  along  with  SmallEiffel. This
-- software  is  distributed  in the hope that it will be useful, but WITHOUT 
-- ANY  WARRANTY;  without  even  the  implied warranty of MERCHANTABILITY or
-- FITNESS  FOR A PARTICULAR PURPOSE. You can modify it as you want, provided
-- this header is kept unaltered, and a notification of the changes is added.
-- You  are  allowed  to  redistribute  it and sell it, alone or as a part of 
-- another product.
--          Copyright (C) 1994-98 LORIA - UHP - CRIN - INRIA - FRANCE
--            Dominique COLNET and Suzanne COLLIN - colnet@loria.fr 
--                       http://www.loria.fr/SmallEiffel
--
class DEMO1

creation make 

feature

   make is
      local
	 std_rand: MIN_STAND;
	 count, range, column: INTEGER;
      do
	 io.put_string("Using the MIN_STAND random number generator.%N%
		       %How many numbers ? ");
	 io.read_integer;
	 count := io.last_integer;
	 io.put_string("Range ( > 1)     ? ");
	 io.read_integer;
	 range := io.last_integer;
	 from
	    !!std_rand.make;
	 until
	    count = 0
	 loop
	    std_rand.next;
	    io.put_integer(std_rand.last_integer(range));
	    count := count - 1;
	    if column = 6 then
	       io.put_string("%N");
	       column := 0;
	    else
	       column := column + 1;
	       io.put_string("%T");
	    end;
	 end;
	 io.put_string("%N");
      end;

end -- DEMO1

