
#              !!!YOU USE THIS SOFTWARE AT YOUR OWN RISK!!!
#              --------------------------------------------

# This is the compliment of Mouse.b/Mouse to decode the horizontal,
# vertical and left mouse button state. This is slowish at the moment.
# Original idea copyright, (C)2007, B.Walker, G0LCU.
#
# $VER: Mouse.py_Version_0.00.02_(C)2007_B.Walker_G0LCU.

# This is the only import required.
import os

# Clear the screen.
print '\f'

# Main program start.
def main():
	# Set all variables as global.
	global mousex
	global mousey
	global lmb
	global rc

	# Allocate definate values.
	mousex = 0
	mousey = 0
	lmb = 0
	rc = 0

	while 1:
		# Set the print position to the top left hand corner.
		os.system('PYTHON:Plugins/Locate 1 1')
		# Set foreground and backgorund colours the same.
		# WHY???
		# To prevent an AMIGADOS RC error report being shown.
		os.system('PYTHON:Plugins/Color 0 0')
		# Now obtain encoded mouse parameters.
		rc = os.system('PYTHON:Plugins/Experimental/Mouse')
		# Do a correction for the print position for the RC codes
		# from 0 to 9 inclusive.
		if rc <= 9:print
		# AMIGADOS error(s) printed but NOT shown on screen here.
		# Now do all of the calculations.
		lmb = int(rc/16777216)
		mousex = int((rc - (16777216*lmb))/4096)
		mousey = rc - 16777216*lmb - 4096*mousex
		# Reset the colours back to default format.
		os.system('PYTHON:Plugins/Color 1 0')
		# Print the NOW VISIBLE results to the screen.
		print "   Horizontal position =",mousex,"\b. Vertical position =",mousey,"\b. LMB =",lmb,"\b.        "
main()
# Program end.
