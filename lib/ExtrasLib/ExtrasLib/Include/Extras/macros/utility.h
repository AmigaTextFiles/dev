#ifndef EXTRAS_MACROS_UTILITY_H
#define EXTRAS_MACROS_UTILITY_H

#ifndef PROTO_UTILITY_H
#include <proto/utility.h>
#endif

#define ProcessTagList(TagList,Tag,TState) TState=TagList; while(Tag=NextTagItem(&TState))

#endif /* EXTRAS_MACROS_UTILITY_H */
