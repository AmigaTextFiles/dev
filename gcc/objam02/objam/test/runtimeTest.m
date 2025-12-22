#include <stdio.h>
#import <objc/Object.h>


void zoneTest(void)
{
  NXZone *zone;
  void *mem;
  const char *zoneName="Test Zone";

  puts("\n======================================== Zone Test");

  if(zone=NXCreateZone(vm_page_size,vm_page_size,YES))
  {
    NXNameZone(zone,zoneName);
    printf("Zone created at %d with name '%s'.\n",(int)zone,zoneName);
    if(mem=NXZoneMalloc(zone,20))
    {
      printf("Memory allocated at %d.\n",(int)mem);
      
      NXZonePtrInfo(mem);
      
      NXZoneFree(zone,mem);
      puts("Memory freed.");
    }
    NXDestroyZone(zone);
    puts("Zone destroyed.");
  }
}


void atomTest(void)
{
  NXAtom atom1,atom2,atom3,atom4;
  static const char *str1="foo";

  puts("\n======================================== Atom Test");

  atom1=NXUniqueStringNoCopy(str1);
  atom2=NXUniqueString("bar");
  atom3=NXUniqueString("foobar");
  atom4=NXUniqueString("bar");

  printf("Addresses: %x, %x, %x, %x\n",atom1,atom2,atom3,atom4);
  printf("Contents: %s, %s, %s, %s\n",atom1,atom2,atom3,atom4);

  if(atom3==NXUniqueString("foobar")) puts("Same.");
  else puts("Different.");
}


int main(void)
{
  if(ObjcBase) puts("Opened objc.library successfully.");
  else { puts("No ObjcBase!"); return 20; }
  
  zoneTest();
  atomTest();
  
  return 0;
}
