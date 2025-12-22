import os
import string
def main():
	myaddress = '0'
	mybyte = 0
	print
	myaddress = raw_input('Input address in decimal:- ')
	if not string.strip(myaddress): myaddress = '0'
	mybyte = (os.system('PYTHON:peek ' + myaddress))
	print
	print 'Memory address in decimal is',myaddress,'and decimal byte value is',mybyte
	print
main()
