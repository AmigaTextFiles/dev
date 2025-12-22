
#                             !!!CAUTION!!!
#                             -------------

#              !!!YOU USE THIS SOFTWARE AT YOUR OWN RISK!!!
#              --------------------------------------------

# This uses the 'poke' command to change the old style monitor modes from
# PAL to NTSC. This is for classic AMIGAs ONLY, but works on WinUAE.
# DO NOT USE IF YOUR TV OR MONITOR DOES NOT SUPPORT BOTH MODES!!!

# Changing the, (TV), video mode from PAL to NTSC.
# This is copyright, (C)2007, B.Walker, G0LCU.
# It uses the 'poke' command to do this task.
# It is used in byte mode and changes one register ONLY.
# The register address is 14676444 and the byte value is 0 for NTSC and
# 32 for PAL.

# Do all necessary imports.
import os

# The simple main loop.
def main():
	# Set any 'variables' to global.
	global videomode

	# Allocate a definate value.
	videomode = "P"

	while 1:
		print "\f"
		print "          Changing the video mode from PAL to NTSC and vice-versa."
		print
		print "                            ~P~ or ~p~ for PAL."
		print
		print "                            ~N~ or ~n~ for NTSC."
		print
		print "                            ~S~ or ~s~ to Stop."
		print
		videomode = raw_input('                Press the required letter<RETURN/ENTER>:- ')
		if videomode == "P": os.system('PYTHON:Plugins/poke b 14676444 32')
		if videomode == "p": os.system('PYTHON:Plugins/poke b 14676444 32')
		if videomode == "N": os.system('PYTHON:Plugins/poke b 14676444 0')
		if videomode == "n": os.system('PYTHON:Plugins/poke b 14676444 0')
		if videomode == "S": break
		if videomode == "s": break
	print "\f"
main()
