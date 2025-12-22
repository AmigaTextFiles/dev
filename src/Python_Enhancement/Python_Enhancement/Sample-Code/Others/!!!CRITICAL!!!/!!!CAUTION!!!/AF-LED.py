
#                             !!!CAUTION!!!
#                             -------------

#              !!!YOU USE THIS SOFTWARE AT YOUR OWN RISK!!!
#              --------------------------------------------

# This uses the 'poke' command to change the Audio Filter and Power LED
# ON/OFF.
# This is for classic AMIGAs ONLY, but works on WinUAE.

# This is copyright, (C)2007, B.Walker, G0LCU.
# It uses the 'poke' command to do this task.
# It is used in byte mode and changes one register ONLY.
# The register address is 12574721 and the byte value is 254 for OFF and
# 252 for ON.

# Do all necessary imports.
import os

# The simple main loop.
def main():
	# Set any 'variables' to global.
	global filter

	# Allocate a definate value.
	filter = "F"

	while 1:
		print "\f"
		print "                   Switching the audio filter ON and OFF."
		print
		print "                             ~F~ or ~f~ for ON."
		print
		print "                             ~L~ or ~l~ for OFF."
		print
		print "                             ~S~ or ~s~ to Stop."
		print
		filter = raw_input('                 Press the required letter<RETURN/ENTER>:- ')
		if filter == "F": os.system('PYTHON:Plugins/poke b 12574721 252')
		if filter == "f": os.system('PYTHON:Plugins/poke b 12574721 252')
		if filter == "L": os.system('PYTHON:Plugins/poke b 12574721 254')
		if filter == "l": os.system('PYTHON:Plugins/poke b 12574721 254')
		if filter == "S": break
		if filter == "s": break
	print "\f"
main()
