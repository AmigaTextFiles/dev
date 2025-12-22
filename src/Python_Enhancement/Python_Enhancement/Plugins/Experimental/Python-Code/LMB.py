
# Left Mouse Button hold using Python 1.4x minimum.
# Original idea copyright, (C)2007, B.Walker, G0LCU.
# A simple demonstration on using the Left Mouse Button under Python.
#
# $VER: LMB.py_Version_0.00.02_(C)2007_B.Walker_G0LCU.

# The only import required.
import os

# Then main working loop.
def main():
	print '\f'
	print 'Press the left mouse button when ready...'
	os.system('PYTHON:Plugins/Experimental/LMB')
	print
	print 'You should now see me... :)'
	print
	print 'Press the left mouse button again...'
	os.system('PYTHON:Plugins/Experimental/LMB')
	print '\f'
	print 'Now press again to stop the program...'
	os.system('PYTHON:Plugins/Experimental/LMB')
	print '\f'
main()
