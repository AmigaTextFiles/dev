
# An example of 'Val' usage.
# This shows how to overcome the minor limitations of the 'Val' command.
# Original idea copyright, (C)2007, B.Walker, G0LCU.
#
# Usage:-
# Val <somestring><RETURN/ENTER>
# Where:-
# 'somestring' is ANY string at all!
#
# $VER: Val.py_Version_0.00.10_(C)2007_B.Walker_G0LCU.

# These imports ARE required.
import os
import string

def main():
	# Made global purely for my use!
	global somestring
	global somevalue

	# Dedicate values to variables.
	somestring = '0'
	somevalue = 0

	# The printed text is self explanitory.
	print '\fStart with a valid numerical string, IGNORE any HIDDEN AMIGADOS errors!'
	somestring = '1234567'
	os.system('PYTHON:Plugins/Color 0 0')
	somevalue = os.system('PYTHON:Plugins/Val ' + somestring)
	os.system('PYTHON:Plugins/Color 1 0')
	print 'The ASCII number =',somestring,'and the RC =',somevalue,'\b.'
	print
	print 'Now a number much bigger than the allowable maximum!'
	somestring = '123456789012'
	os.system('PYTHON:Plugins/Color 0 0')
	somevalue = os.system('PYTHON:Plugins/Val ' + somestring)
	os.system('PYTHON:Plugins/Color 1 0')
	print 'The ASCII number =',somestring,'and the RC =',somevalue,'\b.'
	print
	print 'Now just pure TEXT ASCII characters ONLY.'
	somestring = 'ghij240klmn'
	os.system('PYTHON:Plugins/Color 0 0')
	somevalue = os.system('PYTHON:Plugins/Val ' + somestring)
	os.system('PYTHON:Plugins/Color 1 0')
	print
	print 'The ASCII number =',somestring,'and the RC =',somevalue,'\b.'
	print
	print 'A leading number combination of characters.'
	somestring = '12345lk-+jhf'
	os.system('PYTHON:Plugins/Color 0 0')
	somevalue = os.system('PYTHON:Plugins/Val ' + somestring)
	os.system('PYTHON:Plugins/Color 1 0')
	print 'The ASCII number =',somestring,'and the RC =',somevalue,'\b.'
	print
	# This is the IMPORTANT bit!!!
	print 'When ASCII numerical value of exactly -1 is used.'
	somestring = '-1'
	os.system('PYTHON:Plugins/Color 0 0')
	somevalue = os.system('PYTHON:Plugins/Val ' + somestring)
	os.system('PYTHON:Plugins/Color 1 0')
	print '\vThe ASCII number =',somestring,'and the RC =',somevalue,'\b.'
	print
	# This is also IMPORTANT!!!
	print 'Because the ASCII representation of -1 is a valid numerical value'
	print 'just use ~somevalue = string.atoi(somestring)~ instead.....'
	somevalue = string.atoi(somestring)
	print 'The ASCII number =',somestring,'and the pseudo-RC =',somevalue,'\b.'
	print
main()
# That's all there is to it! :)
