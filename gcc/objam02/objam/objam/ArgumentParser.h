/*
** ObjectiveAmiga: Interface to class ArgumentParser
** See GNU:lib/libobjam/ReadMe for details
*/


// The ArgumentParser class provides a straight-forward way of parsing command
// lines, configuration files, etc. with the dos.library function ReadArgs().


#import <objc/Object.h>

#include <proto/dos.h>


@interface ArgumentParser: Object
{
  @private
  LONG *argSpace;
  char *templateString;
  struct RDArgs *rdArgs;
  unsigned int bufLen;
}

// Initialize and free instances

- init:(void *)args with:(const char *)template;
- free;

// Parse items

- parseString:(const char *)str;
- parseFile:(const char *)fileName;
- parseVariable:(const char*)varName;
- parseCommandline; //-- Doesn't work yet!!!

@end
