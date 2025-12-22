
# Checking the left mouse button on the fly.
# 'CLMB' is Check Left Mouse Button.
# Peek the register 12574721 for bit 6 set to 0.
# (C)2007, B.Walker, G0LCU.
#
# (This method CAN easily be used for checking the joystick FIRE button also.)
#
# $VER: CLMB.py_Version_00.10.00_(C)2007_B.Walker_G0LCU.

# Do any necessary imports.
import os

# The main test loop.
def main():
	# Set lmb, (left mouse button) as global.
	global lmb

	# Allocate a definate value to lmb.
	lmb = 255

	print "\f\nPress the left mouse button, (IGNORE the UNSEEN error!).\n"
	# Set foreground and background colours the same to hide the AmigaDOS error.
	os.system('PYTHON:Plugins/Color 0 0')
	# Peek the register 12574721 to test bit 6, the left mouse button bit.
	while 1:
		os.system('PYTHON:Plugins/Locate 4 1')
		lmb = os.system('PYTHON:Plugins/peek 12574721')
		# 'Remove' the games port bit, bit 7. This ASSUMES that the
		# games/joystick port is UNUSED for this demo.
		if lmb >= 128:lmb = lmb - 128
		if lmb <= 63:break
	# Come here after the lmb is pressed.
	# Reset the colours again.
	os.system('PYTHON:Plugins/Color 1 0')
	# Clean up the print position.
	os.system('PYTHON:Plugins/Locate 4 1')
	print "Hello World!.\n"
main()
# That's all there is to it... :)
