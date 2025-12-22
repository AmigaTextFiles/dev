/*
 * ARexx program to print out earthrexx.library documentation
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * This program will print out all documentation required for
 * "earthrexx.library" in the correct order. It makes use of PPType
 * (supplied with this disc) so make sure that you have the correct
 * page length set up in Preferences.
 *
 */

address COMMAND
call addlib("rexxsupport.library",0,-30,0)

'PPType README_FIRST'
'PPType ARexxInterface.doc'
'PPType IDCMPLoop.doc'
'PPType RexxFunctions.doc'
'PPType Argstrings.doc'
'PPType MemoPads.doc'

call TypeDir ("autodocs")
call TypeDir ("userfuncs")

'PPType :include/earth/earthrexx.i'
'PPType :include/earth/earthrexx.h'

exit

/* Function to type all files in a directory in alphabetical order */

TypeDir:
parse arg directory

allfiles = showdir(directory,'F')
i = 0
do forever
	parse var allfiles nextfile allfiles
	i = i + 1
	filename.i = nextfile
	if allfiles == '' then leave
end
numfiles = i

/* Sort into alphabetical order */
do i = 1 to numfiles
	do j = i+1 to numfiles
		do
		if upper(filename.i) > upper(filename.j) then
			do
				tempname   = filename.i
				filename.i = filename.j
				filename.j = tempname
			end
		end
	end
end

/* Print them out */
do i = 1 to numfiles
	'PPType' directory || '/' || filename.i
end

return

