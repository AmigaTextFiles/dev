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
class KNIGHT
--|
--| In this program a knight try to go over the n*n squares of a 
--| chessboard without pass by the same square again.
--| The position of the knigth is given by a number.
--|  
--|  Auteur: Christophe ALEXANDRE
--|  date :  Thu Mar 21 1996
--
-- Here is an example of solution on a 7 X 7 chesboard,
-- knigth starting at position <1,1> :
--                 ----------------------
--                 | 1|28|37|24| 3|26|17|
--                 ----------------------
--                 |36|39| 2|27|18|11| 4|
--                 ----------------------
--                 |29|42|23|38|25|16| 9|
--                 ----------------------
--                 |40|35|30|19|10| 5|12|
--                 ----------------------
--                 |43|22|41|32|15| 8|47|
--                 ----------------------
--                 |34|31|20|45|48|13| 6|
--                 ----------------------
--                 |21|44|33|14| 7|46|49|
--                 ----------------------
--

inherit ANY redefine print_on end;
   
creation make

feature 

   make is
      local
	 size, line, column: INTEGER;
      do
	 size := ask("Enter the chess-board size : ",3,99);
	 line := ask("Enter the start line : ",1,size);
	 column := ask("enter the start column : ",1,size);
	 knight(size,line,column)
      end;

feature {NONE}

   chessboard: ARRAY2[INTEGER];

   nb_tries: INTEGER;
   
   tl: ARRAY[INTEGER] is 
      once
	 Result := <<-2,-1,1,2,2,1,-1,-2>>;
      end;
   
   tc: ARRAY[INTEGER] is
      once
	 Result := <<1,2,2,1,-1,-2,-2,-1>>;
      end;
     
   knight(size, line, column: INTEGER) is
      require
	 size >= 3;
	 1 <= line;
	 line <= size;
	 1 <= column;
	 column <= size;
      do
	 !!chessboard.make(1,size,1,size); 
	 chessboard.put(1,line,column);
	 if solution(line,column) then
	    print_on(std_output);
	 else
	    io.put_string("Sorry, there is no solution.%N");
	 end;
	 io.put_string("%NNumber of tries : ");
	 io.put_integer(nb_tries);
	 io.put_new_line;
      end; -- knight
   
   solution(line,column:INTEGER):BOOLEAN is
      local
	 value,i : INTEGER;
      do
	 if chessboard.count = chessboard.item(line,column) then
	    Result := true;
	 else
	    from  
	       i := 1;	       
	       value := chessboard.item(line,column);
	    until
	       Result or else i > 8 
	    loop
	       Result := try(line+tl.item(i),column+tc.item(i),value);
	       i := i + 1;
	    end;
	 end;
      end; -- solution
   
   try(line,column,value:INTEGER): BOOLEAN is
	 -- try to place the knight by used cross back-tracking method
      do
	 nb_tries := nb_tries + 1;
	 if chessboard.valid_index(line,column) then
	    if chessboard.item(line,column) = 0 then
	       chessboard.put(value+1,line,column);
	       Result := solution(line,column);      
	       if not Result then
		  chessboard.put(0,line,column)
	       end;
	    end;	       
	 end
      end; -- try
   
   ask(s:STRING; min, max: INTEGER):INTEGER is 
	 -- ask a question until its answer is all right
      local
	 stop: BOOLEAN;
      do
	 from
	 until
	    stop
	 loop
	    io.put_string(s);
	    io.read_integer;
	    Result := io.last_integer;
	    if Result < min then
	       io.put_string("Value too small.%N");
	    elseif max < Result then
	       io.put_string("Value too big.%N");
	    else
	       stop := true;
	    end;
	 end;
      end;
      
   print_on(file: OUTPUT_STREAM) is
	 -- display the cheesboard 
      local
	 line,column : INTEGER;
	 separator : STRING;
      do
	 from  
	    !!separator.blank(3 * chessboard.upper1 + 1);
	    separator.fill_with('-');
	    separator.extend('%N')
	    file.put_string(separator);
	    line := chessboard.lower1	    
	 until
	    line > chessboard.upper1
	 loop
	    from  
	       column := chessboard.lower2	       
	    until
	       column > chessboard.upper2
	    loop
	       if chessboard.item(line,column) < 10 then
		  file.put_string("| "); 
	       else
		  file.put_character('|');
	       end;
	       file.put_integer(chessboard.item(line,column));
	       column := column + 1;
	    end;
	    file.put_string("|%N");
	    file.put_string(separator);
	    line := line + 1;
	 end;
      end; -- print_on
  
end -- KNIGHT
