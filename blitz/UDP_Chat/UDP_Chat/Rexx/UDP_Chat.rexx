/* ARexx script to get UDP_Chat to log into a UDP_Chat Server */
/* For use with AmiComSys 1.12+ */
/* $VER: UDP_Chat.rexx 1.0 (27.07.98) Anton Reinauer */

UDP_CHAT ="UDP_Stuff:UDP_Chat"  
UDP_CHAT_FIND ='WaitForPort UDP_Chat' 

/*  You have to change UDP_Chat to wherever UDP_Chat is on your hard drive
as AmiComSys runs the Arexx script from it's directory :-/
*/ 

if ~show('P','UDP_Chat') then      /* check for the UDP_Chat arexx port */
  do
      ADDRESS COMMAND "C:Run <>NIL: " || UDP_CHAT 
   end

/*  If UDP_Chat isn't already running, then run it.*/ 

ADDRESS AMICOMSYS;      /* Get info from AmiComSys */
OPTIONS RESULTS;

GET stem info. CLIENTLIST;    /* get client info from AmicomSys*/

/* "stem info." inserts the results to the structure 'info.'. */
/* "var s" would have inserted all the results to one string in s. */
/* "CLIENTLIST": We want to read the client list information. */

s=info.selected;          /* get info from selected client*/

ADDRESS COMMAND UDP_CHAT_FIND  /* wait for the UDP_Chat Arexx port to appear*/
IF RC = 0 THEN
  do
    ADDRESS "UDP_Chat"
    CONNECTTOSERVER info.hostnames.s   /* Send host name of person selected 
 				       in list, to connect to. */
  end

/* Send the host address got from AmiComSys and send it to UDP_Chat */


EXIT;
