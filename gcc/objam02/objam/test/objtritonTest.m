// This program opens a Triton window containing a listview gadget with the
// contents of a specified directory and waits for the user to close it.

#include <stdio.h>
#import <objtriton/TRApplication.h>
#import <objam/FileList.h>
#import <objam/ArgumentParser.h>

// Our own custom class

@interface DirWin: TRWindow { id list; }
  -initDir:(const char *)n; -free; -tritonMessage:(struct TR_Message *)trMsg; @end
@implementation DirWin
- initDir:(const char *)n {
  if(![super init]) return [self free];
  if(!(list=[FileList new])) return [self free];
  if(![list name:n]) return [self free];
  if(![list addDirectory:n]) return [self free];
  if(![self open:WindowTitle([list name]),WindowID(1),ListSS([list execList],1,0,0),EndProject])
    return [self free];
  return self; }
- free {
  [self close];
  if(list) [list free];
  return [super free]; }
- tritonMessage:(struct TR_Message *)trMsg {
  if(trMsg->trm_Class==TRMS_CLOSEWINDOW) [OAApp terminate:self];
  return self; }
@end

id argParser;

void fail(const char *txt)
{
  puts(txt);
  if(OAApp) [OAApp free];
  if(argParser) [argParser free];
  exit(20);
}

int main(void)
{
  char *defDir="";
  char **dirNamePtr=&defDir;

  // Set up everything
  if(!(OAApp=[[Application alloc] init:"objtritonTest"])) fail("Can't create ObjectiveAmiga application.");
  if(!(TRApp=[[TRApplication alloc] init])) fail("Can't create Triton application.");
  if(![TRApp runFromAppKit]) fail("Can't run Triton application.");
  if(!(argParser=[[ArgumentParser alloc] init:dirNamePtr with:"DIR=DIRNAME"]))
    fail("Can't create argument parser.");
  if(!([argParser parseCommandline])) fail("Can't parse args.");
  if(!([[DirWin alloc] initDir:*dirNamePtr])) fail("Can't open window.");
  [argParser free];

  // Run the Application; this message won't return
  [OAApp run];
}
