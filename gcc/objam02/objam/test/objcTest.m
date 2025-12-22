#include <stdio.h>
#include <objc/objc.h>
#include "fooObject.h"


void testfoo(void)
{
  id foo;

  if(foo=[FooObject new])
  {
    printf("Value 1: %d\n", [[foo setFoo:42] getFoo]);
    printf("Value 2: %d\n", [[foo setFoo:17] getFoo]);
    if(!([foo storeOn:"ram:foo.tds"])) puts("Error writing object.");
    printf("Default zone: %x\n",NXDefaultMallocZone());
    [foo printForDebugger];
    [foo free];
  }
  else puts("Error creating object.");

  if(foo=[FooObject readFrom:"ram:foo.tds"])
  {
    printf("Value: %d\n", [foo getFoo]);
    [foo free];
  }
  else puts("Error reading object.");
}


int main(void)
{
  testfoo();
  return 0;
}
