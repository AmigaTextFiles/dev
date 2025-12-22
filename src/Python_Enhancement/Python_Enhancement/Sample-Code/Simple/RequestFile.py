
# Running an executable file from anywhere using Python 1.4x.
# This idea is copyright, (C)2007, B.Walker, G0LCU.
# It needs RequestFile to be in the AMIGAs 'C:' volume.
# Written so that kids can understand it.
# The requirements are similar to Coloured-Text.py.

# Do any necessary imports.
import os

def main():
	# Only one line is needed for this demo.
	# This will _STOP_ with an error if the file is NOT executable!!!
	# IMPORTANT NOTE...
        # NOTICE THE REVERSE INVERTED COMMAS-> `???` IN THE LINE BELOW!!!
	os.system('Run >NIL: `RequestFile`')
main()
