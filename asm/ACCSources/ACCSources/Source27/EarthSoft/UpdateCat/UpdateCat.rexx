/* ARexx program to catalogue your entire disc collection onto the
 * directory "Catalogue:".
 *
 * There are two ways you can do this:
 * 	(1) Floppy disc users should keep a single disc whose volume
 *	    name is "Catalogue".
 *	(2) Hard drive users should ASSIGN the name "Catalogue:" to a
 *	    directory on their hard drive.
 *
 * You can choose which drive to use for READING your collection by
 * modifying the following assignment.
 *
 * (this prog is written to minimise disc swaps for single drive users)
 */

/* Modify this to make df1 or df2 the source drive */
drive = 'df0'

say ''
lastdisc = ''
do forever
	/* Wait until user is ready */
	name = ''
	do while (name = '') | (name = lastdisc) | (name = 'Catalogue') | (name = 'Help')
		say '9B419B4B'x || 'Place disc to catalogue in drive' drive || ': and press ENTER when ready'
		pull x
		say '9B419B4B9B41'x
		if x = 'Q' then exit

		/* Get the disc's volume-name */
		address command 'Info >T:drive_info' drive || ':'
		call open('TEMP','T:drive_info','R')
		info = readln('TEMP')
		info = readln('TEMP')
		info = readln('TEMP')
		info = readln('TEMP')
		call close('TEMP')
		address command 'Delete T:drive_info'
		parse var info . . . . . . . name
		name = strip(name,'B')
		if left(name,6) = 'Only  ' then name = substr(name,7)
	end
	lastdisc = name

	/* Allow user to modify name */
	say '9B419B4B'x || 'Enter name for catalogue entry,'
	say 'or just press ENTER to use "'name'"'
	parse pull newname
	if newname = '' then newname = name
	newname = strip(newname,'B')
	say '9B419B4B9B419B4B9B419B4B'x || newname
	if newname='q' | newname='Q' then iterate
	say ''

	/* Open the catalogue file */
	open(CATF, 'T:cat', 'W')

	/* Write the volume name */
	writeln(CATF,name)

	/* Recursively catalogue all directories */
	call catdir(':',0)

	/* Close the file */
	call close(CATF)
	address command 'Copy T:cat "Catalogue:' || newname || '"'
	address command 'Delete T:cat'

	x = ''
	do until (x = 'Y') | (x = 'N')
		say '9B419B4B'x
		say 'Catalogue another disc?'
		pull x
		if x = '' then x = 'Y'
	end
	say '9B419B4B9B419B4B9B41'x
	if x = 'N' then leave
end
say '9B419B4B9B41'x
exit

/*========================================================*/
/* Recursive subroutine to catalogue a directory	  */
/*========================================================*/
catdir:
parse arg rdir,level
dir.level = rdir

/* Write the directory name */
sdir = strip(rdir,'T','/')
say '9B419B4B'x || sdir
writeln(CATF,sdir)

/* List all files in that directory */
files = showdir(drive || rdir, 'F', '/')
do forever
	parse var files nextfile '/' files
	if nextfile == '' then leave
	writeln(CATF,nextfile)
end

/* Recursively do the same for each subdirectory */
dirs.level = showdir(drive || rdir, 'D', '/')
do forever
	parse var dirs.level nextdir '/' dirs
	dirs.level = strip(dirs,'L')
	if nextdir == '' then leave
	call catdir(dir.level || nextdir || '/', level+1)
	level = level - 1
end
return

