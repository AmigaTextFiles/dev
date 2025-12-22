#include <objc/Object.h>

@interface FooObject: Object
{
  unsigned int foo;
}

- setFoo:(unsigned int)val;
- printFoo;
- (unsigned int)getFoo;
- read:(TypedStream*)stream;
- write:(TypedStream*)stream;

@end
