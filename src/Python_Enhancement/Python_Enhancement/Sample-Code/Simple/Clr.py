
# Setting up a basic error beep and clear screen for Python 1.4 and greater.
# Original idea by B.Walker, G0LCU.
# Tested on Python 1.4 for a stock AMIGA 1200 and Python 2.4.2 on Windows ME
# and XP-SP2, in Command Prompt mode.
# ----------------------
# Usage in other files:-
# import Clr
# ----------------------
# Called as:-
# Clr.beep()
# Clr.cls()
# Clr.both()
# ----------------------
# The ~if~ statement selects the correct format for the platform in use.
# ----------------------

# Import necessary modules for this to work.
import os
import sys

# Generate a beep when called.
def beep():
	# A stock AMIGA 1200 using Python 1.4 or greater.
	# This assumes that the sound is enabled in the PREFS: drawer.
	# AND/OR the screen flash is enabled also.
	if sys.platform=='amiga':
		print '\a\v'

	# MS Windows (TM), from Windows ME upwards. Used in Command
	# Prompt mode for best effect.
	# The *.WAV file can be anything of your choice.
	# CHORD.WAV is the default.
	if sys.platform=='win32':
		os.system('SNDREC32.EXE "C:\WINDOWS\MEDIA\CHORD.WAV" /EMBEDDING /PLAY /CLOSE')

	# Add here for other OSs.
	# Add here any peculiarities.
	# if sys.platform=='some_platform':
		# Play some sound for an error beep.

# Do a clear screen, with the limitations as shown.
def cls():
	# A stock AMIGA 1200 using Python 1.4 or greater.
	if sys.platform=='amiga':
		print '\f',

	# MS Windows (TM), from Windows ME upwards.
	# This is for the Command Prompt version ONLY both windowed AND/OR
	# screen.
	# From a Command Prompt window, press Alt-ENTER to switch to a
	# screen and the same again to switch back.
	if sys.platform=='win32':
		print os.system("CLS"),chr(13)," ",chr(13),

	# Add here for other OSs.
	# Add here any peculiarities.
	# if sys.platform=='some_platform':
		# Perform a clear screen routine.

# Do both if required.
def both():
	beep()
	cls()
