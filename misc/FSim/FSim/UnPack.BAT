;.K ""
echo "This script will unpack the following lharc archives:"
echo ""
echo "	FSim_1.lzh	=>	FSim:"
echo "	FSim_2.lzh	=>	FSim:"
echo "	FSim_3.lzh	=>	FSim:"
echo ""

ask "Do you have a blank disk ready?"
if not WARN
	echo "Try again when you do ..."
	echo "All Done. "
	endcli
endif

ask "Is floppy drive df1: free?"
if not WARN
	echo "Let´s try to do the unpacking from RAM disk!"
	echo "Formatting and unpacking disk by using DF0:"
	sys:system/format drive df0: name FSim noicons

	echo "Copying FSim_1.lzh to RAM: ..."
	copy FSim_1.lzh to RAM:
	lharc -x -a -m x ram:FSim_1.lzh Fsim:
	delete ram:FSim_1.lzh

	echo "Copying FSim_2.lzh to RAM: ..."
	copy FSim_2.lzh to RAM:
	lharc -x -a -m x ram:FSim_2.lzh Fsim:
	delete ram:FSim_2.lzh

	echo "Copying FSim_3.lzh to RAM: ..."
	copy FSim_3.lzh to RAM:
	lharc -x -a -m x ram:FSim_3.lzh Fsim:
	delete ram:FSim_3.lzh

	endcli
endif

echo "Formatting and unpacking disk."

sys:system/format drive df1: name FSim noicons

lharc -x -a -m x FSim_1.lzh Fsim:
lharc -x -a -m x FSim_2.lzh Fsim:
lharc -x -a -m x FSim_3.lzh Fsim:

echo "All Done. "
endcli
