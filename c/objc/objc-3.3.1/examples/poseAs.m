
#include "objpak.h"

= Foo : Object {}
- foo { printf("foo\n"); return self; }
=:

= Bar : Foo {}
- foo { printf("bar\n"); return self; }
=:

= Zot : Foo {}
=:

int
main()
{
    id zot = [Foo new];

    [zot foo];
    [[Zot new] foo];
    [[Bar new] foo];

    [Bar poseAs:[Foo self]];

    [zot foo];
    
    [[Foo new] foo];
    [[Bar new] foo];
    [[Zot new] foo];
    [[[Object findClass:"Foo"] new] foo];
}

