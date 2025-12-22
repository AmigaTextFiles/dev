
# System requesters for Python Version 1.4x minimum.
# Original idea (C)2007, B.Walker, G0LCU.
#
# Syntax:-
# MsgBox <message$> <button1$> <button2$><RETURN/ENTER>
#
# Msg <message$> <button1$><RETURN/ENTER>
#
# $VER: Messages.py_Version_0.00.04_(C)2007_B.Walker_G0LCU.

# Do any necessary imports.
import os

def main():
	# Set the return code, rc, as global.
	global rc

	# Allocate a definate value.
	rc = 0

	print '\f'
	print 'The first requester will give a return code and a choice.'
	print
	raw_input('Press RETURN/ENTER to continue:- ')
	# NOTE!!! Notice the inverted commas for the single title argument!!!
	rc = os.system('PYTHON:Plugins/MsgBox "This is the title." ONE ZERO')
	print
	print 'This button gives a return code of',rc,'\b.'
	print
	print 'The second requester is for information ONLY without any return code.'
	print
	raw_input('Press RETURN/ENTER to continue:- ')
	# NOTE!!! Notice the inverted commas for the single title argument!!!
	os.system('PYTHON:Plugins/Msg "(C)2007, B.Walker, G0LCU." OK.')
	print
main()
# Dead simple eh!... :)
