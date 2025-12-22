indexing
   author: "Thomas Aglassinger <agi@giga.or.at>";
   copyright: "Public domain.";
   amiga_version: "$VER scan_javadoc 1.0 (13.8.99)";
   description: "A little tool included with vahunz invoked by %
                %Vahunz-Tschak to create a java dignorary from Javadoc %
                %index files in HTML format.";
   compiler: "Compiled with SmallEiffel -0.78";

class SCAN_JAVADOC

creation {ANY} 
   make

feature {NONE} 
   
   identifier_of(line: STRING): STRING is 
      -- Java identifier in a line matching the pattern
      -- "<A HREF=...<B>identifier</B>..." or `Void' of none.
      require 
         line /= Void; 
      local 
         first_b: INTEGER;
         last_b: INTEGER;
         bracket: INTEGER;
         period: INTEGER;
      do  
         if line.has_prefix("<DT><A HREF=%"") then 
            first_b := line.index_of_string("<B>");
            last_b := line.index_of_string("</B>");
            Result := line.substring(first_b + 3,last_b - 1);
            bracket := Result.index_of('(');
            if bracket < Result.count + 1 then 
               Result := Result.substring(1,bracket - 1);
            end; 
            period := Result.index_of('.');
            if period < Result.count + 1 then 
               Result := Result.substring(period + 1,Result.count);
            end; 
         end; 
      end -- identifier_of
   
   stdin: expanded STD_INPUT;
   
   exceptions: expanded EXCEPTIONS;

feature {ANY} 
   
   make is 
      -- Do it.
      local 
         name: STRING;
      do  
         from 
         until 
            stdin.end_of_input
         loop 
            stdin.read_line;
            name := identifier_of(stdin.last_string);
            if name /= Void then 
               print("-");
               print(name);
               print("%N");
            end; 
         end; 
      rescue 
         if exceptions.is_signal then 
            print("***Break%N");
            exceptions.die(5);
         end; 
      end -- make

end -- class SCAN_JAVADOC
