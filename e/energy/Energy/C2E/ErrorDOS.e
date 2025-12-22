/*
	ErrorDOS.e for AmigaDOS 3.0
	Print Message text for AmigaDOS errors along with probable causes
	and suggestions for recovery.

	Author: Marco Talamelli
	E-Mail: Marco_Talamelli@amp.flashnet.it
*/

OPT OSVERSION=37

PROC recovery() IS PrintF('\n\e[34m\e[3m  Recovery suggestion:\e[0m\n')

PROC cause() IS PrintF('\n\e[32m\e[3m  Probable cause:\e[0m\n')

PROC main()
  DEF myargs:PTR TO LONG,rdargs,code
  myargs:=[0]
  IF rdargs:=ReadArgs('ERROR/N',myargs,NIL)
code:=Long(myargs[0])
        SELECT code
            	CASE 103
                	PrintF('\e[33m\e[3m  103: Not enough memory\e[0m\n')
                	cause()
                	PrintF('  Not enough memory in your Amiga to carry out the operation.\n')
                	 recovery()
                	PrintF('  Close any unnecessary windows and applications,'+
			' then re-issue\n  the command. If it still doesn\at work, reboot.'+
			' Memory may be\n  sufficient, but fragmented. It is possible that'+
			' you may need\n  to add more RAM to your system.\n\n')
            	CASE 104
                	PrintF('\e[33m\e[3m  104: Process table full\e[0m\n')
                	cause()
                	PrintF('  There is a limit to the number of possible processes.\n')
				 recovery()
				PrintF('  Stop one or more tasks.\n\n')
		CASE 114
				PrintF('\e[33m\e[3m  114: Bad template\e[0\n')
				cause()
				PrintF('  Incorrect command line.\n')
				recovery()
				PrintF('  Verify the correct command format.\n\n')
		CASE 115
				PrintF('\e[33m\e[3m  115: Bad number\e[0\n')
				cause()
				PrintF('  The program was expecting a numerical argument.\n')
				recovery()
				PrintF('  Verify the correct command format.\n\n')
		CASE 116
				PrintF('\e[33m\e[3m  116: Required argument missing\0[0\n')
				cause()
				PrintF('  Incorrect command line.\n')
				recovery()
				PrintF('  Verify the correct command format.\n\n')
		CASE 117
				PrintF('\e[33m\e[3m  117: Argument after "=" missing\e[0\n')
				cause()
				PrintF('  Incorrect command line.\n')
				recovery()
				PrintF('  Verify the correct command format.\n\n')
		CASE 118
				PrintF('\e[33m\e[3m  118: Too many arguments\e[0\n')
				cause()
				PrintF('  Incorrect command line.\n')
				recovery()
				PrintF('  Verify the correct command format.\n\n')
		CASE 119
				PrintF('\e[33m\e[3m  119: Unmatched quotes\e[0\n')
				cause()
				PrintF('  Incorrect command line.\n')
				recovery()
				PrintF('  Verify the correct command format.\n\n')
            CASE 120
                PrintF('\e[33m\e[3m  120: Argument line invalid or too long\e[0m\n')
                cause()
                PrintF('  Your command line is incorrect or contains too many arguments.\n')
                 recovery()
		PrintF('  Verify the correct command format.\n')

            CASE 121
                PrintF('\e[33m\e[3m  121: File is not executable\e[0m\n')
                cause()
                PrintF('  You misspelled the command name, or the file may not be a loadable\n '+
			' (program or script) file.\n')
                 recovery()
                PrintF('  Retype the filename and make sure that the file is a program file.\n'+
			'  In order to execute a sqript, either the s bit must be set or the\n'+
			'  EXECUTE command must be used.\n\n')

            CASE 122
                PrintF('\e[33m\e[3m  122: Invalid resident library\e[0m\n')
				cause()
				PrintF('  You are trying to use commands with a previous version.\n')
				 recovery()
				PrintF('  Reboot with the current version of AmigaDOS.\n\n')
            CASE 202
                PrintF('\e[33m\e[3m  202: Object in use\e[0m\n')
                cause()
                PrintF('  The specified file or directory is already being used by another\n'+
		'  application. If an application is reading a file, no other program\n  can'+
		' write to it, and vice versa.\n')
                 recovery()
                PrintF('  Stop the other application that is using the file or directory, and\n'+
			'  re-issue the command.\n\n')

            CASE 203
                PrintF('\e[33m\e[3m  203: Object already exists\e[0m\n')
                cause()
                PrintF('  The name that you specified already belongs to another file or directory.\n')
                 recovery()
                PrintF('  Use another name, or delete the existing file or directory, and replace it.\n\n')

            CASE 204
                PrintF('\e[33m\e[3m  204: Directory not found\e[0m\n')
		cause()
		PrintF('  AmigaDOS cannot find the directory you specified. You may have made\n'+
			'  a typing or spelling error.\n')
		recovery()
		PrintF('  Check the directory name (use DIR if necessary). Re-issue the command.\n\n')

            CASE 205
                PrintF('\e[33m\e[3m  205: Object not found\e[0m\n')
                cause()
                PrintF('  AmigaDOS cannot find the file or device you specified.\n  You may have'+
			' made a typing or spelling error.\n')
                 recovery()
                PrintF('  Check the filename (use DIR) or the device name (use INFO).\n  Re-issue the command.\n\n')

            CASE 206
                PrintF('\e[33m\e[3m  206: Invalid window description\e[0m\n')
                cause()
                PrintF('  This occurs when specifying a window size for a Shell, ED, or ICONX window.\n'+
			'  You may have made the window too big or too small, or you may have omitted\n'+
			'  an argument. This error also occurs with the NEWSHELL command, if you supply\n'+
			'  a device name that is not a window.\n')
                 recovery()
                PrintF('  Re-issue the window specification.\n\n')

            CASE 209
                PrintF('\e[33m\e[3m  209: Packet request type unknown\e[0m\n')
                cause()
                PrintF('  You have asked a device handler to attempt an operation it cannot do.\n'+
			'  For example, the console handler cannot rename anything.\n')
                 recovery()
                PrintF('  Check the request code passed to device handlers for the appropriate request.\n\n')

            CASE 210
                PrintF('\e[33m\e[3m  210: Object name invalid\e[0m\n')
                cause()
                PrintF('  There is an invalid character in the filename or the filename is too long.\n')
		recovery()
		PrintF('  Re-type the name, being sure not to use any invalid characters or exceed\n'+
			'  the maximum length.\n\n')

            CASE 211
                PrintF('\e[33m\e[3m  211: Invalid object lock\e[0m\n')
                cause()
                PrintF('  You have used something that is not a valid lock.\n')
                recovery()
                PrintF('  Check that your only passes valid locks to AmigaDOS calls that expect locks.\n\n')

            CASE 212
                PrintF('\e[33m\e[3m  212: Object not of required type\e[0m\n')
                cause()
                PrintF('  You may have specified a filename for an operation that requires a directory\n'+
			'  name, or vice versa.\n')
                recovery()
		PrintF('  Verify the correct command format.\n\n')

            CASE 213
                PrintF('\e[33m\e[3m  213: Disk not validated\e[0m\n')
                cause()
                PrintF('  If you have just inserted a disk, the disk validation process may be\n'+
			'  in progress. It is also possible that the disk is corrupt.\n')
                recovery()
                PrintF('  If you\ave just inserted the disk, wait for the validation process to finish.\n'+
			'  This may take less than a minute for a floppy disk or up to several minutes\n'+
			'  for a hard disk. If the disk is corrupt, it cannot be validated.\n'+
			'  In this CASE, try to retrieve the disk\as files and copy them to another disk.\n\n')

            CASE 214
                PrintF('\e[33m\e[3m  214: Disk is write-protected\e[0m\n')
                cause()
                PrintF('  The plastic tab is in the write-protect position.\n')
                recovery()
                PrintF('  Remove the disk, move the tab, and re-insert the disk. Or use a different disk.\n\n')

            CASE 215
                PrintF('\e[33m\e[3m  215: Rename across devices attempted\e[0m\n')
                cause()
                PrintF('  RENAME only changes a filename on the same volume.\n'+
			'  You can use RENAME to move a file from one directory to another,\n'+
			'  but you cannot move files from one volume to another.\n')
                 recovery()
                PrintF('  Use COPY to copy the file to the destination volume.\n'+
			'  Delete it from the source volume, if desired. Then use RENAME.\n\n')

            CASE 216
                PrintF('\e[33m\e[3m  216: Directory not empty\e[0m\n')
                cause()
                PrintF('  This error occurs if you attempt to delete a directory that\n'+
			'  contains files or sudirectories.\n')
                 recovery()
                PrintF('  If you are sure you want to delete the complete directory, use\n'+
			'  the ALL option of DELETE.\n\n')

	    CASE 217
		PrintF('\e[33m\e[3m  217: Too many levels\e[0m\n')
		cause()
		PrintF('  You\ave exceeded the limit of 15 soft links.\n')
		 recovery()
		PrintF('  Reduce the number of soft links.\n\n')
            CASE 218
                PrintF('\e[33m\e[3m  218: Device (or volume) not mounted\e[0m\n')
                cause()
                PrintF('  If the device is a floppy disk, it has not been inserted in a drive.\n'+
			'  If it is another type of device, it has not been mounted with MOUNT\n'+
			'  or the name is misspelled.\n')
                 recovery()
                PrintF('  Insert the correct floppy disk, mount the device, check the spelling\n'+
			'  of the device name, or revise your MountList file.\n\n')

            CASE 219
                PrintF('\e[33m\e[3m  219: Seek error\e[0m\n')
                cause()
                PrintF('  You have attempted to call SEEK with invalid arguments.\n')
                 recovery()
                PrintF('  Make sure that you only SEEK within the file.\n'+
			'  You cannot SEEK outside the bounds of the file.\n\n')

            CASE 220
                PrintF('\e[33m\e[3m  220: Comment is too long\e[0m\n')
                cause()
                PrintF('  Your filenote has exceeded the maximum number of characters (79).\n')
                 recovery()
                PrintF('  Use a shorter filenote.\n\n')
            CASE 221
                PrintF('\e[33m\e[3m  221: Disk is full\e[0m\n')
                cause()
                PrintF('  There is not enough room on the disk to perform the requested operation.\n')
                 recovery()
                PrintF('  Delete some unnecessary files or directories, or use a different disk.\n\n')

            CASE 222
                PrintF('\e[33m\e[3m  222: Object is protected from deletion\e[0m\n')
                cause()
                PrintF('  The d (deletable) protection bit of the file or directory is clear.\n')
                 recovery()
                PrintF('  If you are certain that you want to delete the file or directory,\n'+
			'  use PROTECT to set the d bit or use the FORCE option of DELETE.\n\n')

            CASE 223 
                PrintF('\e[33m\e[3m  223: File is write protected\e[0m\n')
                cause()
                PrintF('  The w (writable) protection bit of the file is clear.\n')
                 recovery()
                PrintF('  If you are certain that you want to overwrite the file,\n'+
		'  use PROTECT to set the w bit.\n\n')

            CASE 224 
                PrintF('\e[33m\e[3m  224: File is read protected\e[0m\n')
                cause()
                PrintF('  The r (readable) protection bit of the file is clear.\n')
                 recovery()
                PrintF('  Use PROTECT to set the r bit of the file.\n\n')

            CASE 225
                PrintF('\e[33m\e[3m  225: Not a valid DOS disk\e[0m\n')
                cause()
                PrintF('  The disk in the drive is not an AmigaDOS disk, it has not\n'+
			'  been formatted, or it is corrupt.\n')
                 recovery()
		PrintF('  Check to make sure you are using the correct disk.\n'+
			'  If you know the disk worked before, use a disk recovery\n'+
			'  program to salvage its files. If the disk has not been formatted,\n'+
			'  use FORMAT to do so.\n\n')

            CASE 226
                PrintF('\e[33m\e[3m  226: No disk in drive\e[0m\n')
                cause()
                PrintF('  The disk is not properly inserted in the specified drive.\n')
                 recovery()
                PrintF('  Insert the appropriate disk in the specified drive.\n\n')

            CASE 232
                PrintF('\e[33m\e[3m  232: No more entries in directory\e[0m\n')
                cause()
                PrintF('  This indicates that the AmigaDOS call EXNEXT has no more\n'+
			'  entries in the directory you are examining.\n')
                 recovery()
                PrintF('  Stop calling EXNEXT.\n\n')

		CASE 2
			PrintF('\e[33m\e[3m  2: Object is soft link\e[0m\n')
			cause()
			PrintF('  You tried to perform an operation on a soft link that\n'+
				'  should only be performed on a file or directory.\n')
			recovery()
			PrintF('  AmigaDOS uses Action_Read_Link to resolve the soft link\n'+
				'  and retries the operation.\n\n')

            DEFAULT
                PrintF('\d is an unrecognized error code.\n',Long(myargs[0]))
	    ENDSELECT
    FreeArgs(rdargs)
  ELSE
    PrintF('Bad Args!\n')
  ENDIF
ENDPROC
