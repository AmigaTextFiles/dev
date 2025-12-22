
# Clearing the screen and reseting the print position to the top left
# hand corner and sounding an error beep.
# For Python Version 1.4 minimum.
# Original idea copyright, (C)2007, B.Walker, G0LCU.
#
# CSEB stands for ClearScn-ErrorBeep...
#
# $VER: CSEB.py_Version_0.00.04_(C)2007_B.Walker_G0LCU.

# Do any necessary imports.
import os

def main():
	# This also clears the screen!
	print '\f'
	print '(C)2007, Barry Walker, G0LCU.'
	print
	print 'Email:-  wisecracker@tesco.net'
	print
	print 'URL:-    http://homepages.tesco.net/wisecracker/G0LCU.HTM'
	print
	raw_input('Press <RETURN/ENTER> for a beep:- ')
	os.system('PYTHON:Plugins/ErrorBeep')
	print
	raw_input('Press <RETURN/ENTER> to clear the screen:- ')
	os.system('PYTHON:Plugins/ClearScn')
	# That's all there is to it... :)
main()
