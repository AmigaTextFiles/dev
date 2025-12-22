-- Utility Library v0.2				Last Update:        18.10.2005
-- [Fabio Falcucci] 						       Allanon
------------------------------------------------------------------------------
--| CONVERTION BETWEEN STRINGS/NUMBER
--|    Functions to handle/read/write values into files or memory chuncks ----------------------------------------+-------------------------------------
--| char, error 		= Byte2Char(value)
--| string, error		= Word2String(value)
--| string, error		= Long2String(value)
--| value, error		= Char2Byte(character)
--| value, error		= String2Word(string)
--| value, error		= String2Long(string)
------------------------------------------------------------------------------
--| COMMON NUMERIC FUNCTIONS
------------------------------------------------------------------------------
--| value, error		= Int(value)
------------------------------------------------------------------------------
--| COMMON STRING FUNCTIONS
------------------------------------------------------------------------------
--| string, error		= Right(string, count)
--| string, error		= Left(string, count)
------------------------------------------------------------------------------
--| COMMONT FILE FUNCTIONS
------------------------------------------------------------------------------
--| check, filename, error	= FilenameSuffix(filename, suffix, force)
--| check, sysmessage		= FilenameExists(filename)
------------------------------------------------------------------------------

------------------------------------------------------------------------------
function Byte2Char(value)
--+---------------------------------------------------------------------------
--| Convert a numeric value (byte) into a single character
--|    INPUT:  value     --> Value to convert
--|    OUTPUT: character --> Converted character or <nil> if something goes
--|                          wrong
--|            error     --> Error/Warning description
--+---------------------------------------------------------------------------
	if value == nil then
	   --> Illegal value
	   return nil, "Byte2Char(): Tried to convert a <nil> value." end
	   
	if value < 0 or value > 255 then
	   --> Out of range
		return nil, "Byte2Char(): Cannot convert, <value> must be between 0 and 255."
	else
	   --> Convert value
		return string.char(value)
	end
end
------------------------------------------------------------------------------
function Word2String(value)
--+---------------------------------------------------------------------------
--| Convert a numeric value (word) into a 2 character string
--|    INPUT:  value     --> Value to convert
--|    OUTPUT: string    --> Converted string (2 characters) or <nil> if 
--|                          something goes wrong
--|            error     --> Error/Warning description
--+---------------------------------------------------------------------------
	if value == nil then
	   --> Illegal value
	   return nil,"Word2String(): Tried to convert a <nil> value." end
	   
	if value < 0 or value > 65535 or value == nil then
	   --> Out of range
	   return nil, "Word2String(): Cannot convert, <value> must be between 0 and 65535."
	else
	   --> Convert value
	   second = Int( value/256 )
	   first  = value - second*256
	   return string.char(first) .. string.char(second)
	end
end
------------------------------------------------------------------------------
function Long2String(value)
--+---------------------------------------------------------------------------
--| Convert a numeric value (long) into a 4 characters string
--|    INPUT:  value     --> Value to convert
--|    OUTPUT: string    --> Converted string (4 characters) or <nil> if 
--|			     something goes wrong
--|            error     --> Error/Warning description
--+---------------------------------------------------------------------------
	if value == nil then character
	   --> Illegal value
	   return nil, "Long2String(): Tried to convert a <nil> value." end
	   
	if value < 0 or value > 4294967296 or value == nil then
	   --> Out of range
	   return nil, "Long2String(): Cannot convert, <value> must be between 0 and 4294967296."
	else
	   fourth  = Int( value/16777216 )
	   value   = value - fourth*16777216
	   thirdth = Int( value/65536 )
	   value   = value - thirdth*65536
	   second  = Int( value/256 )
	   first   = value - second*256
	   return string.char(first) .. string.char(second) .. string.char(thirdth) .. string.char(fourth)
	end
end
------------------------------------------------------------------------------
function Char2Byte(cha)
--+---------------------------------------------------------------------------
--| Convert a character to a numeric value (byte)
--|    INPUT:  character --> Character to convert
--|    OUTPUT: value     --> Converted value (byte) or <nil> if something goes
--|                          wrong
--|            error     --> Error/Warning description
--+---------------------------------------------------------------------------
	if cha == nil then 
	   --> Illegal value
	   return nil, "Char2Byte(): Tried to convert a <nil> value." end
	   
	l = string.len(cha)
	if l == 1 then
	   --> Single character string, converting
	   return string.byte(cha)
	else
	   --> Multiple character string, converting first char + warning message
	   return string.byte(cha), "Char2Byte(): Converted only the first character."
	end--+---------------------------------------------------------------------------
--| Convert a 2 characters string to a numeric value (word)
--|    INPUT:  string    --> 2 character string to convert
--|    OUTPUT: value     --> Converted value (word) or <nil> if something goes
--|                          wrong
--|            error     --> Error/Warning description
--+---------------------------------------------------------------------------
	
	return string.byte(cha), msg
end	
------------------------------------------------------------------------------
function String2Word(cha)
--+---------------------------------------------------------------------------
--| Convert a 2 characters string to a numeric value (word)
--|    INPUT:  string    --> 2 character string to convert
--|    OUTPUT: value     --> Converted value (word) or <nil> if something goes
--|                          wrong
--|            error     --> Error/Warning description
--+---------------------------------------------------------------------------
	if cha == nil then 
	   --> Illegal value
	   return nil end
	   
	l = string.len(cha)
	if l == 2 then
	   --> 2 character string, converting
	   return string.byte(cha,1) + string.byte(cha,2)*256
	
	elseif l == 1 then
	   --> Single character string, adjusting adding a blank character
	   cha = cha .. string.char(0)
	   string.byte(cha,1) + string.byte(cha,2)*256, "String2Word(): Single character string, added a blank character."

	elseif l > 2 then
	   --> String lenght > 2, convert only first 2 characters
	   string.byte(cha,1) + string.byte(cha,2)*256, "String2Word(): String lenght > 2, converted only the first 2 characters."
	end
end	
------------------------------------------------------------------------------
function String2Long(cha)
--+---------------------------------------------------------------------------
--| Convert a 4 characters string to a numeric value (long)
--|    INPUT:  string    --> 4 character string to convert
--|    OUTPUT: value     --> Converted value (long) or <nil> if something goes
--|                          wrong
--|            error     --> Error/Warning description
--+---------------------------------------------------------------------------
	if cha == nil then 
	   --> Illegal value
	   return nil end
	   
	l = string.len(cha)
	if l == 4 then
	   --> 4 characters string, converting
	   return string.byte(cha,1) + string.byte(cha,2)*256 + string.byte(cha,3)*65536 +
	          string.byte(cha,4)*16777216
		  
	elseif l==3 then
	   --> 3 characters string, adjusting adding a blank character
	   cha = cha .. string.char(0)
	   return string.byte(cha,1) + string.byte(cha,2)*256 + string.byte(cha,3)*65536 +
	          string.byte(cha,4)*16777216, "String2Long(): 3 characters string, adding a blank character."
		
	elseif l == 2 then
	   --> 2 characters string, adjusting adding 2 blank characters
	   cha = cha .. string.char(0) .. string.char(0)
	   return string.byte(cha,1) + string.byte(cha,2)*256 + string.byte(cha,3)*65536 +
	          string.byte(cha,4)*16777216, "String2Long(): 2 characters string, adding 2 blank characters."

	elseif l == 1 then
	   --> 1 character string, adjusting adding 3 blank characters
	   cha=cha .. string.char(0) .. string.char(0) .. string.char(0)
	   return string.byte(cha,1) + string.byte(cha,2)*256 + string.byte(cha,3)*65536 +
	          string.byte(cha,4)*16777216, "String2Long():  1 character string, adding 3 blank characters."
	elseif l > 4 then
	   --> String lenght > 4, converting only the first 4 characters
	   return string.byte(cha,1) + string.byte(cha,2)*256 + string.byte(cha,3)*65536 +
	          string.byte(cha,4)*16777216, "String2Long():  String lenght > 4, converted only the first 4 characters."   
	end
end    
------------------------------------------------------------------------------
function Int(value)
--+---------------------------------------------------------------------------
--| Returns the integer part of the passed value
--|    INPUT:  value	--> Number to process
--|    OUTPUT: value	--> Integer part of the passed number or <nil> if
--|                         something goes wrong
--|	       error	--> Error/Warning description
--+---------------------------------------------------------------------------
	if value == nil then
	   --> Illegal value
	   return nil, "Int(): Cannot process a <nil> value." end
	   
	return value - math.mod(value,1)
end
------------------------------------------------------------------------------
function FilenameSuffix(filename, suffix, force)
--+---------------------------------------------------------------------------
--| Check if the given <filename> has the specified <suffix>, and if <force>
--| is not <nil> add to the filename the given <suffix>.
--|    INPUT:  filename		--> File name to process
--|            suffix		--> File suffix to check/add
--|            force		--> Suffix forcing flag
--|    OUTPUT: check		--> "Yes" if <suffix> is present otherwise "No".
--|            filename		--> Processed file name
--|            error		--> Error/Warning description
--+---------------------------------------------------------------------------
   if filename == nil then
      --> Illegal file name
      return nil, nil, "FilenameSuffix(): Cannot proceed, <filename> is <nil>."
   end
   
   sffxlen = string.len(suffix) + 1
   if sffxlen < 2 then
      --> Illegal suffix
      return nil, nil, "FilenameSuffix(): Cannot proceed, <suffix> is <nil>."
   end
   
   --> Check <filename> suffix
   sffix = string.sub(filename, -sffxlen)
   if sffix ~= suffix then
      --> Provided suffix not present
      if force ~= nil then
         --> Adding the provided suffix
         filename = filename .. suffix		
         return "Yes", filename, nil
      else
         return "No", filename, nil
      end
  else
      return "Yes", filename, nil
   end

end
------------------------------------------------------------------------------
function FilenameExists(filename)
--+---------------------------------------------------------------------------
--| Return "Yes" if the supplied <filename> exists otherwise returns "No".
--|    INPUT:  filename		--> File name to check
--|    OUTPUT: check		--> "Yes" if <filename> exists, otherwise "No"
--|            error		--> System Error/Warning description
--+---------------------------------------------------------------------------
   --> Try to open the provided <filename>
   fh, msg = io.open(filename)
   
   --> Check if the filehandle is valid
   if fh == nil then 
      --> <filename> does not exists or is unavailable
      return "No", msg
   else
      --> <filename> exists and is available
      fh:close()
      return "Yes", msg
   end
end
------------------------------------------------------------------------------
function Right(strng, count)
--+---------------------------------------------------------------------------
--| Returns the left side of the given string, or nil if something is wrong
--|    INPUT:  strng		--> String
--|            count		--> Characters to extract
--|    OUTPUT: strng		--> Right side of the source string
--|            error		--> Error/Warning decription
--+---------------------------------------------------------------------------
   if strng == nil then
      --> Illegal source string 
      return nil, "Right(): Cannot proceed, the string is empty." end
   
   l = string.len(strng)
   if count > l then 
      return strng, "Right(): Requested lenght is greater than source string lenght." end
   
   return string.sub(strng, l - count + 1)
end
------------------------------------------------------------------------------
function Left(strng, count)
--+---------------------------------------------------------------------------
--| Returns the left side of the given string, or nil if something is wrong
--| Returns the left side of the given string, or nil if something is wrong
--|    INPUT:  strng		--> String
--|            count		--> Characters to extract
--|    OUTPUT: strng		--> Left side of the source string
--|            error		--> Error/Warning decription
--+---------------------------------------------------------------------------
   if strng == nil then 
      --> Illegal source string
      return nil, "Left(): Cannot proceed, the string is empty." end
   
   l = string.len(strng)
   if count > l then 
      return strng, "Left(): Requested lenght is greater than source string lenght." end
   
   return string.sub(strng, 0, count)
end
