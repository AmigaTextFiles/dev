#ifndef PROTO_BULLTET_H
#define PROTO_BULLTET_H

#include <clib/bullet_protos.h>
#if defined(__OPTIMIZE__) && !defined(__NOINLINES__)
#include <inline/bullet.h>
#endif
#ifndef __NOLIBBASE__
extern struct Library *BulletBase;
#endif

#endif
