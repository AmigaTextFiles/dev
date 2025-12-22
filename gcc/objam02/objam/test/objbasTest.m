#include <stdio.h>
#include <objc/objc.h>
#include <objbas/IdArray.h>
#include <objbas/String.h>


void testarray(void)
{
  id myArray;
  int i;

  if(myArray=[IdArray with:3, [String str:"Testing:"], [String str:"- foo"], [String str:"- bar"]])
  {
    for(i=0;i<[myArray capacity];i++) printf("%d: %s\n",i,[[myArray at:i] str]);
    [myArray storeOn:"ram:myArray.nib"];
    [myArray freeContents];
    [myArray free];
  }
  else puts("Error creating IdArray object.");

  if(myArray=[IdArray readFrom:"ram:myArray.nib"])
  {
    for(i=0;i<[myArray capacity];i++) printf("%d: %s\n",i,[[myArray at:i] str]);
    [myArray freeContents];
    [myArray free];
  }
  else puts("Error reading ram:myArray.nib.");
}


int main(void)
{
  testarray();
  return 0;
}
