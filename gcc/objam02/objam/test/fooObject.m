#include <stdio.h>
#include "fooObject.h"

@implementation FooObject

- setFoo:(unsigned int)val
{
  foo=val;
  return self;
}

- printFoo
{
  printf("FooObject [%s] contains [%d]\n",[self name],[self getFoo]);
}

- (unsigned int)getFoo
{
  return foo;
}

- read:(TypedStream*)stream
{
  [super read:stream];
  objc_read_types(stream,"I",&foo);
  return self;
}

- write:(TypedStream*)stream
{
  [super write:stream];
  objc_write_types(stream,"I",&foo);
  return self;
}

@end
