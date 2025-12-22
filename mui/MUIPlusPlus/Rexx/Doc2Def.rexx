/* Converts MUI autodocs to MUIDefs files */

parse arg destination

whitespace = '09'x || ' '

/* Get the files to convert */

call rtfilerequest(,,"Select files to convert",,"rtfi_flags=freqf_multiselect",files)

do i = 1 to files.count
	call CreateDefsFile(files.i)
end

exit

/* Given the name of an autodoc file this will create it's muidefs file */

CreateDefsFile:
	parse arg fileName
	parse var fileName 'MUI_' className '.doc'

	if className = '' then do
		parse var fileName 'MCC_' className '.doc'

		if className = '' then do
			say fileName "is not a MUI autodoc"
			return
		end
	end

	if ~open(file,fileName,'read') then do
		say "Could not open" fileName
		return
	end

	destName = destination || className'.muidefs'

	if ~open(destFile,destName,'write') then do
		say "Could not open destination file" destName "for writing"
		call close(file)
		return
	end

	say "Converting" fileName "to" destName"..."

	do while ~eof(file)
		line = strip(readln(file),'b',whitespace)

		if line = 'NAME' then do
			line = strip(readln(file),'b',whitespace)

			tag = word(line,1)

			if word(line,words(line)) = '(OBSOLETE)' then do
				obselete = 'O'
				line = substr(line,1,wordindex(line,words(line)) - 1)
			end

			else obselete = 'N'

			if left(tag,4) = 'MUIA' then do
				/* Get name of attribute */

				parse var tag 'MUIA_' class '_' attribute

				/* Nofity and Area classes do not have a class name before
				   attribute names in tags */

				if attribute = '' then attribute = class

				if attribute = 'Object' then do
					call writech(stdout,className "class has an attribute called Object, enter new name: ")
					parse pull attribute
				end

				/* Get type */

				type = right(line,length(line) - lastpos(',',line) - 1)

				/* There is a bug in the MUI documentation that has Broker
				   instead of CxObj * */

				if strip(type) = 'Broker *' then type = 'CxObj *'

				/* There is also a bug in NList documentation that has Obj *
				   as type for Object * */

				if strip(type) = 'Obj *' then type = 'Object *'

				/* Check whether it is setable, getable or initializer */

				parse var line with _ '[' usage ']' _

				call writeln(destFile,"attribute" tag attribute obselete usage type)
			end

			else do
				/* Get name of method */

				parse var tag 'MUIM_' class '_' method

				/* Nofity and Area classes do not have a class name before
				   attribute names in tags */

				if method = '' then method = class

				/* Get parameters to method */

				do forever
					if strip(readln(file),'b',whitespace) = 'SYNOPSIS' then break
				end

				parse value readln(file) with 'DoMethod(' _ ',' _ ',' params ');'

				call writeln(destFile,"method" tag method obselete params)
			end
		end
	end

	call close(file)
	call close(destFile)

return
