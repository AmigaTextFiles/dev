/*
** ObjectiveAmiga: Simple demo for class RexxHost
** See GNU:lib/libobjam/ReadMe for details
*/


#import <objam/RexxHost.h>


@interface MyRexx: RexxHost
- rxcVERSION;
- rxcLINE;
@end


@implementation MyRexx

- rxcVERSION
{
  [self replyRexxCmd:"rexxTest for ObjectiveAmiga" rc:RC_OK];
}

- rxcLINE
{
  LONG *args[4];

  if([self readArgs:(LONG *)args tpl:"X1/A/N,Y1/A/N,X2/A/N,Y2/A/N"])
    printf("Draw line from (%d,%d) to (%d,%d).\n",*args[0],*args[1],*args[2],*args[3]);
}

@end


int main(void)
{
  id host;
  if(host=[[MyRexx alloc] initHost:"REXXTEST"]) [[host run] free];
  return 0;
}
