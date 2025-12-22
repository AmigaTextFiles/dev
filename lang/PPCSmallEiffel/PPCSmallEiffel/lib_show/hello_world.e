class HELLO_WORLD
--
-- The "Hi World program" for SmallEiffel :-)   
--   
-- To compile type command : compile hello_world 
-- Run with command : a.out   
--
-- To compile an optimized version type : compile hello_world -boost -O2
--
creation make
   
feature
   
   make is
      do
	 io.put_string("Hello World.%N");
      end;
   
end -- HELLO_WORLD
