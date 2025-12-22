{

This is an ACE Basic source file

--------------------------------------------------------------
This file reads in a text file, line by line, 
and checks each line's length, in bytes.

The longest line is recorded as LONGEST, and written
as an ENVironment variable LINELENGTH.
--------------------------------------------------------------
}



IF ARGCOUNT<>1 THEN
     
     COLOR 3,0    
     PRINT 
     PRINT " I need the filename of a textfile, please."
     PRINT " I will read the file to find the longest line of the file."
     PRINT " I will write the file  ENV:LINELENGTH. 
     PRINT " This will hold the LENGTH of longest line of the file."
     COLOR 2,1
     PRINT " Try again, pretty please."
     PRINT
     COLOR 1,0 

     STOP

END IF

{
--------------------------------------------------------------
     Set up the variables
--------------------------------------------------------------
}

a$=""
LONGEST%=0
THIS_LINE%=0

infile$=arg$(1)

{
--------------------------------------------------------------
     OPEN the file and try it
--------------------------------------------------------------
}



OPEN "I",#1,infile$

IF ERR THEN

     COLOR 2,1
     PRINT
     PRINT infile$; " does not exist. Try again.""
     PRINT
     COLOR 1,0
     
     STOP

END IF

{
--------------------------------------------------------------
     The file exists. Start getting lines
--------------------------------------------------------------
}

LINE_COUNT=0

PRINT
PRINT "    Working on "infile$ "......."
PRINT

WHILE NOT EOF (1)

  LINE INPUT #1,a$
  THIS_LINE%=LEN(a$)

    IF THIS_LINE%>LONGEST% THEN
      LONGEST%=THIS_LINE%
    END IF
++LINE_COUNT
WEND

CLOSE 1

{
--------------------------------------------------------------
     All done. Write the ENV file and close
--------------------------------------------------------------
}


OPEN "O",#1,"ENV:LINELENGTH"
PRINT #1,LONGEST%
CLOSE 1


COLOR 2,1
PRINT
PRINT "The longest line in " infile$ " is" LONGEST% "characters long."
PRINT "The number of lines is" LINE_COUNT 
PRINT
COLOR 1,0

STOP


