#ifndef TWICPP_UTILITY_TAG_H
#define TWICPP_UTILITY_TAG_H

//
//  $VER: Tag.h         1.0 (23 Jan 1997)
//
//    c 1997 Thomas Wilhelmi
//
//
// Address : Taunusstrasse 14
//           61138 Niederdorfelden
//           Germany
//
//  E-Mail : willi@twi.rhein-main.de
//
//   Phone : +49 (0)6101 531060
//   Fax   : +49 (0)6101 531061
//
//
//  $HISTORY:
//
//  06 Jan 1997 :   1.0 : first public Release
//

/// Includes

#ifndef EXEC_MEMORY_H
#include <exec/memory.h>
#endif

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

#ifndef _INCLUDE_PRAGMA_UTILITY_LIB_H
#include <pragma/utility_lib.h>
#endif

///

/// class TWiTag

class TWiTag
    {
    private:
        struct TagItem *TagArray;
        VOID freeTagArray();
        struct TagItem *findTagEnd();
    public:
        TWiTag() : TagArray(NULL) { };
        TWiTag(const Tag, ...);
        TWiTag(const struct TagItem *);
        TWiTag(const TWiTag &);
        ~TWiTag() { freeTagArray(); };
        TWiTag &operator= (const TWiTag &);
        struct TagItem *tags() const { return(TagArray); };
        VOID append(const TWiTag &);
        VOID append(const Tag, ...);
        VOID append(const struct TagItem *);
        VOID set(const TWiTag &);
        VOID set(const Tag, ...);
        VOID set(const struct TagItem *);
        struct TagItem *find(const Tag t) const { return(FindTagItem((Tag)t,TagArray)); };
        ULONG getData(const Tag t, const ULONG dflt) const { return(GetTagData((Tag)t,(ULONG)dflt,TagArray)); };
        ULONG filter(const LONG logic, const Tag *tags) { return(FilterTagItems(TagArray,(Tag *)tags,(LONG)logic)); };
        ULONG filter(const LONG, const Tag, ... );
    };

///
/// class TWiTagCursor

class TWiTagCursor
    {
    private:
        struct TagItem *TagArray;
        struct TagItem *Cursor;
        struct TagItem *Position;
    public:
        TWiTagCursor(const TWiTag &);
        TWiTagCursor(const struct TagItem *);
        ~TWiTagCursor() { };
        BOOL isDone() const { return(Position == NULL); };
        VOID first();
        VOID next();
        struct TagItem *item() const { return(Position); };
        Tag itemTag() const;
        ULONG itemData() const;
    };

///

#endif
