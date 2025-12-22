
#                                !!!BEWARE!!!
#                                ------------

# THIS SAMPLE CODE WILL CHANGE WORKBENCH PALETTE REGISTER 3 TO DARK GREY.
# IT IS SOFT BLUE IN DEFAULT MODE.
# ENSURE THAT NOTHING OF IMPORTANCE IS RUNNING ON THE AMIGA!!!

# Idea copyright, (C)2007, B.Walker, G0LCU.
# Written so kids can understand it.

# Palette:-
# Palette <register> <red> <green> <blue><RETURN/ENTER>
#
# Where:-
# 'register' ia a value from 0 to 7, (31).
# 'red' is a floating point value from 0.00 to 1.00.
# 'blue' is a floating point value from 0.00 to 1.00.
# 'green' is a floating point value from 0.00 to 1.00.
#
# $VER: Palette.py_Version_0.00.02_(C)2007_B.Walker_G0LCU.

# Only one import required.
import os

def main():
	# !!!BEWARE!!!
	print '\f'
	os.system('PYTHON:Plugins/Palette 3 0.33 0.33 0.33')
main()
# Program end.
