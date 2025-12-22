
# Changing the font sizes using the AMIGADOS 'SetFont' command.
# This simple code is copyright, (C)04-01-2007, B.Walker, G0LCU.
# It NEEDS 'SetFont' to be in the AMIGAs 'C:' volume.
# Written so that kids can understand it... :)
# The requirements are similar to Coloured-Text.py.
# Every time 'SetFont' is called it WILL clear the screen so ALLOW
# for this in YOUR code!!!

# Standard import.
import os

def main():
	# This is the method to change a font size.
	os.system('C:SetFont topaz SIZE 8')
	print
	print "This is the standard topaz 8 system font..."
	print
	raw_input('Press ENTER:- ')
	os.system('C:SetFont topaz SIZE 16')
	print
	print "Now topaz 16 font..."
	print
	raw_input('Press ENTER:- ')
	os.system('C:SetFont topaz SIZE 8')
	print
	print "Reset back to topaz 8 font..."
	print
main()
