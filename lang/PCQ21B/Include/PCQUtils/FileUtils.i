{
    Include:PCQUtils/FileUtils.i

    This is some fileutils to use with PCQ Pascal.

    Author:  Nils Sjoholm  (nils.sjoholm@mailbox.swipnet.se)
}


{
    FileType returns an integer redarding the type of thefile.
    If it's a file -3, a dir 2 and if the thefile does not exist
    it returns 0.
}

CONST  IS_FILE    = -3;
       IS_DIR     =  2;
       IS_NOTHING =  0;

FUNCTION FileType(thefile :  STRING): Integer;
EXTERNAL;

{
    ValidPath returns True if ThePath is a dir else it
    returns False.
}
FUNCTION ValidPath(ThePath : STRING): Boolean;
EXTERNAL;

{
    FileSize returns the SIZE OF the file. It uses the
    FileInfoBlock to get the size.
}
FUNCTION FileSize(FileName : STRING) : Integer;
EXTERNAL;

{
    FileExists returns a boolean value that indicates whether the
    specified file exists.
}
FUNCTION FileExists(Name : STRING) : Boolean;
EXTERNAL;

{
    This function returns a file's date and time as the number of
    seconds after January 1, 1978 that the file was created.
}
FUNCTION FileAge(FName : STRING) : Integer;
EXTERNAL;

{
     MakePath creates all new directories in a path.
     If you write:   IF MakePath("ram:this/is/all/new/dirs") THEN
     it tries to make all dirs in the path. MakePath returns TRUE
     if it can create all dirs or the dirs exists.
}
FUNCTION MakePath(Path : STRING): BOOLEAN;
EXTERNAL;

{
     ExpandFileName expands the given filename to a fully qualified filename.
     The resulting string consists of a drive or device, a colon, a root relative
     directory path, and a filename. It uses NameFromLock internaly. If no
     lock on FileName it returns an empty string.
}
FUNCTION ExpandFileName(FileName: STRING): STRING;
EXTERNAL;

{
     ExtractFilePath extracts the drive and directory parts of the given
     filename. The resulting string is the rightmost characters of FileName,
     up to and including the colon or backslash that separates the path
     information from the name and extension. The resulting string is empty
     if FileName contains no drive and directory parts.
}
FUNCTION ExtractFilePath(FileName: STRING): STRING;
EXTERNAL;

{
     ExtractFileName extracts the name and extension parts of the given
     filename. The resulting string is the leftmost characters of FileName,
     starting with the first character after the colon or slash that
     separates the path information from the name and extension. The resulting
     string is equal to FileName if FileName contains no drive and directory
     parts.
}
FUNCTION ExtractFileName(FileName: STRING): STRING;
EXTERNAL;

{
     ExtractFileExt extracts the extension part of the given filename. The
     resulting string includes the period character that separates the name
     and extension parts. The resulting string is empty if the given filename
     has no extension.
}
FUNCTION ExtractFileExt(FileName: STRING): STRING;
EXTERNAL;

{
    ExtractFileDir extracts the drive and directory parts of the given
    filename. The resulting string is a directory name suitable for passing
    to SetCurrentDir, CreateDir, etc. The resulting string is empty if
    FileName contains no drive and directory parts.
}
FUNCTION ExtractFileDir(FileName: STRING): STRING;
EXTERNAL;
{
     ChangeFileExt changes the extension of a filename. FileName specifies a
     filename with or without an extension, and Extension specifies the new
     extension for the filename. The new extension can be a an empty string or
     a period followed by any characters.
}
FUNCTION ChangeFileExt(FileName, Extension: STRING): STRING;
EXTERNAL;

{
     PathOf extracts the path of a complete filepath specification.
     Functions as ExtractFilePath.
}
FUNCTION PathOf(Name : STRING): STRING;
EXTERNAL;

{
     PathAndFile combines and returns the Path and FName as a complete
     file specification. The Path doesn't have to end with a slash ("/")
     or a colon (":"). Any errors the returnstring is empty.
}
FUNCTION PathAndFile(Path,FName : STRING): STRING;
EXTERNAL;

{
     FileOf extracts the file name portion of a complete file path
     specification. Functions as ExtractFileName.
}
FUNCTION FileOf(Name : STRING): STRING;
EXTERNAL;

{
    GetProgName gives you the name of the starting program. The function
    will give you the name from Workbench or from cli.
}
FUNCTION GetProgName(): STRING;
EXTERNAL;



