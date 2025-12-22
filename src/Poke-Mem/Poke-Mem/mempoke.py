import os
def main():
	pokeaddress = '0'
	pokebyte = '0'
	print
	print 'Poking a single memory location only...'
	print
	pokeaddress = raw_input('Input address in decimal:- ')
	print
	pokebyte = raw_input('Input byte value in decimal:- ')
	if pokeaddress == '': pokeaddress = '0'
	if pokeaddress == chr(13): pokeaddress = '0'
	if pokeaddress == chr(10): pokeaddress = '0'
	if pokeaddress == chr(10) + chr(13): pokeaddress = '0'
	if pokeaddress == chr(13) + chr(10): pokeaddress = '0'
	if pokebyte == '': pokebyte = '0'
	if pokebyte == chr(13): pokebyte = '0'
	if pokebyte == chr(10): pokebyte = '0'
	if pokebyte == chr(10) + chr(13): pokebyte = '0'
	if pokebyte == chr(13) + chr(10): pokebyte = '0'
	os.system('PYTHON:pokeb ' + pokeaddress + ' ' + pokebyte)
	print
	print 'Now peek the same memory location as a test...'
	execfile('PYTHON:Lib/peekmem.py')
main()
