
#                              !!!IMPORTANT!!!
#                              ---------------
#
#                   !!!THIS IS PURELY EXPERIMENTAL ONLY!!!
#                   --------------------------------------
#
#   THE RMB MAY NEED TO BE PRESSED MORE THAN ONCE TO REACH 'Hello World!.'.
#                                 SO BEWARE!
#
# Checking the right mouse button on the fly.
# 'CRMB' is Check Right Mouse Button.
# Peek the register 14675990 for bit 2 set to 0.
# (C)2007, B.Walker, G0LCU.
#
# $VER: CRMB.py_Version_00.10.07_(C)2007_B.Walker_G0LCU.

# Do any necessary imports.
import os

# The main test loop.
def main():
	# Set rmb, (right mouse button) as global.
	global rmb

	# Allocate a definate value to rmb.
	rmb = 255

	print "\f\nPress the right mouse button, (IGNORE the UNSEEN error!).\n"
	# Set foreground and background colours the same to hide the AmigaDOS error.
	os.system('PYTHON:Plugins/Color 0 0')
	# Peek the register 14675990 to test bit 2, the right mouse button bit.
	while 1:
		os.system('PYTHON:Plugins/Locate 4 1')
		rmb = os.system('PYTHON:Plugins/peek 14675990')
		# Remove all other bits down to bit 2.
		if rmb >= 128:rmb = rmb - 128
		if rmb >= 64:rmb = rmb - 64
		if rmb >= 32:rmb = rmb - 32
		if rmb >= 16:rmb = rmb - 16
		if rmb >= 8:rmb = rmb - 8
		if rmb <= 3:break
	# Come here after the rmb is pressed.
	# Reset the colours again.
	os.system('PYTHON:Plugins/Color 1 0')
	# Clean up the print position.
	os.system('PYTHON:Plugins/Locate 4 1')
	print "Hello World!.\n"
main()
# That's all there is to it... :)
