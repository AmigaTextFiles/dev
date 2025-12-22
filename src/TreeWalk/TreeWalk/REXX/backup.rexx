/*
 * backup - do daily backup of it's argument.
 *
 * For each argument dev (with no ':'), find all files on dev: that
 * are newer than dev:last-backup, and copy them (complete with directory
 * structure) to backup:
 *
 * See build-exclusions for how the exclusions list is built.
 *
 *	Copyright (C) 1989, 1990  Mike Meyer
 *
 *	This program is free software; you can redistribute it and/or modify
 *	it under the terms of the Free Software License as published by
 *	the Free Software Foundation; either version 1, or any later version.
 *
 *	This program is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU General Public License for more details.
 */

dev = arg(1)
signal on error
options failat 1

logfile = 'logs:backup.log'

if ~exists(logfile) then 'copy nil: to' logfile

if index(dev, ':') = 0 then dev = dev':'

call log 'Backup of' dev 'starting,' disksize('backup') 'blocks free on backup:'
if exists(dev'last-backup') then
	filter = "file && date > "dev"last-backup.date"
else do
	call log "Doing full backup of" dev
	filter = "file"
	end

call build_exclusions
'treewalk dir' dev' filter "'filter' && backup && false"'
'date >' dev'last-backup'
call log 'Backup of' dev 'done,' disksize('backup') 'blocks free on backup:'
call setclip "daily.backup"
exit

/*
 * build_exclusions - returns a treewalk filter expression to test
 * names in the file against the exclusion list.
 */
build_exclusions: procedure expose logfile

	'execio read s:backup-exclusions stem excludes.'
	out = "true"
	do i = 1 to excludes.0
		if left(excludes.i, 1) = '#' then iterate i
		if verify(excludes.i, ":/", 'Match') = 0 then
			out = out "&& name !* '"excludes.i"'"
		else out = out "&& filename !* '"excludes.i"'"
		end
	call setclip "daily.backup", out
	return

/*
 * Returns the # of free blocks on the backup disk.
 */
disksize: procedure expose logfile

	'info | execio locate' arg(1) 'for 1 var dataline'
	return word(dataline, 4)


/*
 * Catch command errors, and diagnose them for the user.
 */
error:

	if syntax = 2 then do
		call log "Interrupted; backup incomplete." disksize('backup') "blocks free."
		exit
		end

	call log 'line' sigl 'failed; backup incomplete.'
	call log disksize('backup') "blocks free on daily:"
	exit

/*
 * Log - log the message we've been given.
 */
log: procedure expose logfile
	parse arg message

	if ~open(file, logfile, 'Append') then do
		say "Can't open" logfile', exiting!'
		exit
		end
	call writeln file, date() time() || ':' message
	call close file
	return
