/* AREXX script for converting GNU compiler error messages
 * into AREXX commands for the SAS/C message browser
 * Copyright (C)1994 by Armin Vogt
 *
 * $Id: gnutoscmsg.rexx,v 1.5 1994/08/02 18:59:13 Armin_Vogt Exp Armin_Vogt $
 *
 * email: armin@uni-paderborn.de
 *
 *
 * Start this script with 'Rx <name_of_this_file>' in the background.
 * It will then start the SCMSG command and wait for input
 * from the 'pipe:gnu_errors'.
 * Now start your compiler and redirect its output to 'pipe:gnu_errors'.
 * Shut down the script with writing a single line "quit" to 'pipe:gnu_errors'.
 * This script can handle both Amiga and Unix path specifications.
 */
 
   
   if SHOW(P,"SC_SCMSG")~=0 then
      ADDRESS 'SC_SCMSG' "clear"    /* cause SCMSG to clear all messages */
      
   inputfile = "pipe:gnu_errors"
   if OPEN("errors",inputfile) then
   do
      say "pipe opened."
      input = ""
      firstmsg = 0
      
      do until input="quit"
         
         input = READLN("errors")
         if input ~= "" & input ~= "quit" then 
         do
            /*say ">" input*/
            
            /* Check wether the SCMSG port is already there. 
               If he's not start scmsg. */
            if SHOW(P,"SC_SCMSG")=0 then
            do
               ADDRESS COMMAND "Run sc:c/scmsg"
               /* give the previous command time to load scmsg */
               ADDRESS COMMAND "Wait SEC=2"
            end   
            /* Divide line into file+linenumber and error text */
            input = STRIP(input)    /* remove leading and trailing spaces */
            parse VALUE input WITH  Line ": " Text
            
            if Text ~= "" then /* if no ': ' found -> no gcc output at all */
            do
               lp = LASTPOS(":",Line)  /* Find ":" in front of the line number */
               Number = RIGHT(Line,LENGTH(Line)-lp)
               if DATATYPE(Number)=NUM then 
               do
                  File = LEFT(Line,lp-1)
                  Line = Number
                  Class = "Error"
               end
               else 
               do
                  File = Line;
                  Line = 0       /* no error number present -> info line*/
                  Class = "Info"
               end

               if FIND(Text,"warning:")~=0 then 
                  Class = "Warning"

               if LEFT(File,1)="/" then   /* transform unix path into Amiga path */
               do 
                  File = DELSTR(File,1,1);   /* delete leading '/' */
                  File = OVERLAY(":",File,POS("/",File),1); /* overwrite second '/' with ':' */
               end
               say """"File""" """File""" """Line"""  """Class""" """Text""""
            
               if firstmsg=1 then   /* on start of a new file clear all messages.. */
               do                   /* to this file present in SCMSG. */
                  ADDRESS 'SC_SCMSG' "newbld """File""
                  firstmsg = 0;
               end                  
               /* send the message to SCMSG with the 'newmsg' command */
               ADDRESS 'SC_SCMSG' "newmsg """File""" """File""" "Line" 0 """" 0 "Class" 0 "Text""
            end
         end   /* if input ~= "" & input ~= "quit" then */
         else firstmsg = 1            /* indicate first message on new compilatin unit */
      end   /* do until input="quit" */

      CLOSE("errors")
   end
   else say inputfile " could not be opened!"
