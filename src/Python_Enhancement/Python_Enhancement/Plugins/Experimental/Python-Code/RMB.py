
# Right Mouse Button hold using Python 1.4x minimum.
# Original idea copyright, (C)2007, B.Walker, G0LCU.
# A simple demonstration on using the Right Mouse Button under Python.
#
# $VER: RMB.py_Version_0.00.02_(C)2007_B.Walker_G0LCU.

# The only import required.
import os

# Then main working loop.
def main():
	print '\f'
	print 'Press the right mouse button when ready...'
	os.system('PYTHON:Plugins/Experimental/RMB')
	print
	print 'You should now see me... :)'
	print
	print 'Press the right mouse button again...'
	os.system('PYTHON:Plugins/Experimental/RMB')
	print '\f'
	print 'Now press again to stop the program...'
	os.system('PYTHON:Plugins/Experimental/RMB')
	print '\f'
main()
