
#              !!!CAUTION, YOU USE THIS SW AT YOUR OWN RISK!!!
#              -----------------------------------------------

# THIS SAMPLE CODE WILL RESET THE AMIGA WHEN AN UPPER CASE 'Y' IS ENTERED.
# ENSURE THAT NOTHING OF IMPORTANCE IS BEING DONE ON THE AMIGA IN USE!!!

# Idea copyright, (C)2007, B.Walker, G0LCU.
# Written so kids can understand it.

# $VER: Reset.py_Version_0.00.02_(C)2007_B.Walker_G0LCU.

# Only one import required.
import os

def main():
	# Set reboot as global.
	global reboot

	# Allocate a definate value.
	reboot = "N"

	# This will soft RESET the computer!
	# UPPER CASE ONLY, SO !!!CAUTION!!!
	print '\f'
	reboot = raw_input('Do you want to reboot, (Y/N):- ')
	if reboot == 'Y':os.system('PYTHON:Plugins/Reboot')
main()
# Program end.
