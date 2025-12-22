/*
** ObjectiveAmiga: Interface to class FileList
** See GNU:lib/libobjam/ReadMe for details
*/


// This descendant of ExecList allows you to easily create file lists. Normally
// you will inherit from FileList and overwrite -addFile: in order to sort out
// and rename files.


#import <objam/ExecList.h>


@interface FileList: ExecList

// Parse a directory and add its contents to the list

- addDirectory:(const char *)dirName;

// Add a file
// - Overwrite this function in descendants of FileList
//   for implementing renaming or pattern matching.

- addFile:(const char *)fileName;

@end
