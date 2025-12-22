#ifndef PROTO_DATATYPES_H
#define PROTO_DATATYPES_H

#ifndef DATATYPES_DATATYPESCLASS_H
#include <datatypes/datatypesclass.h>
#endif
#include <clib/datatypes_protos.h>
#if defined(__OPTIMIZE__) && !defined(__NOINLINES__)
#include <inline/datatypes.h>
#endif
#ifndef __NOLIBBASE__
extern struct Library *DataTypesBase;
#endif

#endif
