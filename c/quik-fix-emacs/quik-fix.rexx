/*======================================================================
** quik-fix.rexx
*/


/*
** Config
*/
EMACS_STARTUP = "C:runback GNUEmacs:temacs"


DIRECTORY = pragma('D')
EMACS_QUIK_FIX_START = '(quik-fix-start "'DIRECTORY'")'
EMACS_PORT = "EMACS1"



/*
** Get the port, start emacs if it is not already running
*/
if ~ show( 'p', EMACS_PORT ) then do

	say "Cannot find port named" EMACS_PORT
	say "Starting GNU Emacs..."

	address command	EMACS_STARTUP '-e' EMACS_QUIK_FIX_START
end
else do
	address value EMACS_PORT
	EMACS_QUIK_FIX_START
end


/*
** Wait for Emacs to respond with STOP or RECOMPLE
*/
addlib("rexxsupport.library",0,-30,0)

openport( QuikFix )

NOPACKET = x'0000 0000'
MESSAGE = waitpkt( QuikFix )
 
if MESSAGE = 1 then do
	PACKET = GETPKT( QuikFix )
	if PACKET = NOPACKET then
		nop /* Error Handling if needed */
	else do
		RESPONSE = getarg(PACKET)
		reply(PACKET,0)

		select;
      			when RESPONSE = "RECOMPILE" then exit 0
      			when RESPONSE = "STOP" then exit 1
      			otherwise say "Emacs returned invalid response'" RESPONSE "'"
			end
	end
end
