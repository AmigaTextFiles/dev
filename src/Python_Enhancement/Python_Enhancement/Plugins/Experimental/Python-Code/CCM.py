
# CCM, CheckChipMem example code.
# Original idea copyright, (C)2007, B.Walker, G0LCU.
#
# Syntax:-
# CheckChipMem <block> <type><RETURN/ENTER>
# Where:-
# 'block' is a value from 4 to 65536.
# 'type' is 'C', 'c', 'F', 'f', 'P' or 'p' for Chip, Fast or Public memory.
#
# $VER: CCM.py_Version_0.00.04_(C)2007_B.Walker_G0LCU.

# Do any necessary imports.
import os

# The main program.
def main():
	# Set start address as a global value.
	global addr

	# Allocate a definate value.
	addr = 16777215

	print '\f'
	addr = os.system('PYTHON:Plugins/Experimental/CheckChipMem 4096 P')
	print
	raw_input('This is a normal AMIGADOS error report, press ENTER to continue:- ')
	print '\f'
	print 'CheckChipMem will allocate 4096 bytes of (P)ublic memory.'
	print 'It will then CLEAR all of these 4096 bytes to value zero.'
	print 'Lastly the cleared memory is then released back to the system.'
	print
	print 'The start address is at',addr,'decimal.'
	print
main()
# That's all there is to it!... :)
