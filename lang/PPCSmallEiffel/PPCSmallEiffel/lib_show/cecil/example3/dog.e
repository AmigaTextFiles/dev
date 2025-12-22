-- Part of SmallEiffel -- Read DISCLAIMER file -- Copyright (C) 
-- Dominique COLNET and Suzanne COLLIN -- colnet@loria.fr
--
class DOG inherit ANIMAL

feature 

   cry: STRING is 
      do
	 Result := "BARK";
      end;

end 

