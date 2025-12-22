#ifndef CPP_TWIMUI_MISC_H
#define CPP_TWIMUI_MISC_H

#ifndef EXEC_MEMORY_H
#include <exec/memory.h>
#endif

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef _INCLUDE_STRING_H
#include <string.h>
#endif

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

class TWiMemX
	{
	private:
		ULONG WantedSize;
		ULONG WantedFlags;
	public:
		TWiMemX(ULONG s, ULONG f = MEMF_ANY) : WantedSize(s), WantedFlags(f) { };
		ULONG size() const { return(WantedSize); };
		ULONG flags() const { return(WantedFlags); };
	};

class TWiBuff
	{
	private:
		APTR databuff;
		ULONG buffsize;
		BOOL privbuff;
	public:
		TWiBuff(const ULONG initsize = 256);
		TWiBuff(const APTR, const ULONG);
		TWiBuff(const TWiBuff &);
		~TWiBuff();
		TWiBuff &operator= (const TWiBuff &);
		APTR buffer() const { return(databuff); };
		ULONG size() const { return(databuff ? buffsize : 0); };
		void doubleBuff();
		void setBuffSize(ULONG);
	};

class TWiHelpArray
	{
	private:
		void extend(const ULONG);
		UBYTE *v;
		ULONG element_size;
		ULONG size;
	public:
		TWiHelpArray(ULONG es, ULONG s = 16);
		TWiHelpArray(const TWiHelpArray &);
		TWiHelpArray &operator= (const TWiHelpArray &);
		~TWiHelpArray() { delete [] v; };
		operator APTR () const { return((APTR) v); };
		void &operator[] (const ULONG);
		ULONG esize() const { return(element_size); };
		ULONG count() const { return(size); };
	};

template <class T> class array : private TWiHelpArray
	{
	public:
		array(ULONG s = 16) : TWiHelpArray(sizeof(T),s) { };
		ULONG count() const { return(TWiHelpArray::count()); };
		T &operator[] (ULONG i) { return((T &) TWiHelpArray::operator[] (i)); };
	};

class TWiHelpArrayList : public TWiHelpArray
	{
	private:
		ULONG top;
	public:
		TWiHelpArrayList(ULONG es, ULONG s = 16) : TWiHelpArray(es,s) { top = 0; };
		ULONG length() const { return(top); };
		void &addTail() { return(TWiHelpArray::operator[](top++)); };
		void &insert(const ULONG index);
		void remove(const ULONG index);
		void remTail();
		void clear() { top = 0; };
	};

class TWiHelpArrayCursor
	{
	private:
		TWiHelpArrayList *list;
		LONG pos;
	public:
		TWiHelpArrayCursor(TWiHelpArrayList &);
		void first() { pos = 0; };
		void last() { pos = list->length() - 1; };
		void next();
		void prev();
		void &item() { return(list->operator[](pos)); };
		BOOL isDone() { return(pos >= list->length()  ||  pos < 0); };
	};

template <class T> class TWiArrayList : private TWiHelpArrayList
	{
	friend class TWiArrayCursor<T>;
	public:
		TWiArrayList(ULONG s = 16) : TWiHelpArrayList(sizeof(T),s) { };
		ULONG count() { return(TWiHelpArrayList::count()); };
		ULONG length() const { return(TWiHelpArrayList::length()); };
		T &operator[] (ULONG i) { return((T &) TWiHelpArray::operator[] (i)); };
		T &addTail() { return((T &) TWiHelpArrayList::addTail()); };
		T &insert(const ULONG index) { return((T &) TWiHelpArrayList::insert(index)); };
		void remove(const ULONG index) { TWiHelpArrayList::remove(index); }
		void remTail() { TWiHelpArrayList::remTail(); };
		void clear() { TWiHelpArrayList::clear(); };
	};

template <class T> class TWiArrayCursor : private TWiHelpArrayCursor
	{
	public:
		TWiArrayCursor(TWiArrayList<T> &l) : TWiHelpArrayCursor((TWiHelpArrayList &)l) { };
		void first() { TWiHelpArrayCursor::first(); };
		void last() { TWiHelpArrayCursor::last(); };
		void next() { TWiHelpArrayCursor::next(); };
		void prev() { TWiHelpArrayCursor::prev(); };
		T &item() { return((T &) TWiHelpArrayCursor::item()); };
		BOOL isDone() const { return(TWiHelpArrayCursor::isDone()); };
	};

class TWiStr
	{
	protected:
		ULONG len;
		TWiBuff buffer;
	public:
		TWiStr(const STRPTR = NULL);
		TWiStr(const ULONG, const STRPTR);
		TWiStr(const TWiStr &s) : len(s.len), buffer(s.buffer) { };
		TWiStr(const UBYTE);
		virtual ~TWiStr();
		operator STRPTR() const { return((STRPTR)buffer.buffer()); };
		TWiStr &operator= (const TWiStr &);
		TWiStr &operator= (const STRPTR);
		TWiStr &operator+= (const TWiStr &);
		TWiStr &operator+= (const STRPTR);
		UBYTE &operator[] (ULONG);
		ULONG length() const { return(len); };
		ULONG bufsize() const { return(buffer.size()); };
		TWiStr left(const ULONG) const;
		TWiStr right(const ULONG) const;
		TWiStr mid(const ULONG, const ULONG) const;
		void doubleBuff() { buffer.doubleBuff(); };
		void shrinkBuff();
		void setBuffSize(const ULONG);
	};

TWiStr operator+ (const TWiStr &, const TWiStr &);

BOOL operator== (const TWiStr &s1, const TWiStr &s2) { return(strcmp((STRPTR)s1,(STRPTR)s2) == 0); };
BOOL operator!= (const TWiStr &s1, const TWiStr &s2) { return(strcmp((STRPTR)s1,(STRPTR)s2) != 0); };
BOOL operator<  (const TWiStr &s1, const TWiStr &s2) { return(strcmp((STRPTR)s1,(STRPTR)s2) <  0); };
BOOL operator>  (const TWiStr &s1, const TWiStr &s2) { return(strcmp((STRPTR)s1,(STRPTR)s2) >  0); };
BOOL operator<= (const TWiStr &s1, const TWiStr &s2) { return(strcmp((STRPTR)s1,(STRPTR)s2) <= 0); };
BOOL operator>= (const TWiStr &s1, const TWiStr &s2) { return(strcmp((STRPTR)s1,(STRPTR)s2) >= 0); };

class ostream &operator<< (ostream &, const TWiStr &);

class istream &operator>> (istream &, TWiStr &);

class TWiStrArray
	{
	friend class TWiStrCursor;
	private:
		TWiHelpArrayList strs;
	public:
		TWiStrArray(STRPTR string1, ...);
		TWiStrArray(STRPTR *strings = NULL);
		ULONG length() const { return(strs.length()); };
		STRPTR *strings();
		STRPTR &operator[] (const ULONG);
		void addTail(const STRPTR);
		void insert(const STRPTR, const ULONG);
		void remTail();
		void remove(const ULONG);
	};

class TWiStrCursor : public TWiHelpArrayCursor
	{
	public:
		TWiStrCursor(TWiStrArray &);
		STRPTR item();
	};

class TWiFormat
	{
	private:
		TWiBuff Buff;
		TWiStr Fmt;
		ULONG Index;
		void TWiPutChar(UBYTE, TWiFormat *);
		static void put_char(register __d0 const UBYTE, register __a3 TWiFormat *);

	public:
		TWiFormat(const STRPTR pFmt = NULL) : Fmt(pFmt), Buff(0UL), Index(0UL) { };
		TWiFormat(const STRPTR pStr, const ULONG pLng) : Fmt(pStr), Buff(pLng), Index(0UL) { };
		TWiFormat(const ULONG pLng) : Fmt(), Buff(pLng), Index(0UL) { };
		TWiFormat(const TWiFormat &pFmt) : Fmt(pFmt.Fmt), Buff(pFmt.Buff), Index(pFmt.Index) { };
		~TWiFormat() { };
		void setFormat(const STRPTR pFmt) { Fmt = pFmt; };
		void setBuffer(const ULONG lBuff) { Buff.setBuffSize(lBuff); };
		STRPTR format(const ULONG, ...);
		STRPTR format(const APTR);
		STRPTR getFormat() const { return(Fmt); };
		STRPTR getBuff() const { return((STRPTR)Buff.buffer()); };
	};

class TWiTag
	{
	private:
		struct TagItem *taglist;
		void freetaglist();
		struct TagItem *findtagend();
	public:
		TWiTag() : taglist(NULL) { };
		TWiTag(const Tag tag1Type, ...);
		TWiTag(const struct TagItem *);
		TWiTag(const TWiTag &);
		TWiTag &operator = (const TWiTag &);
		~TWiTag() { freetaglist(); };
		struct TagItem *tags() const { return taglist };
		void append(const TWiTag *);
		void append(const Tag, ...);
		void append(const struct TagItem *);
		void set(const TWiTag *tags);
		void set(const Tag tag1Type, ...);
		void set(const struct TagItem *tags);
		struct TagItem *find(const Tag tagType) const;
		ULONG getData(const Tag tagType, const ULONG defaultData) const;
		ULONG filter(const LONG logic, const Tag tagTypes[]);
		ULONG filter(const LONG logic, const Tag tag1, ... );
	};

class TWiTagCursor
	{
	private:
		struct TagItem *taglist;
		struct TagItem *cursor;
		struct TagItem *pos;
	public:
		TWiTagCursor(const TWiTag &);
		TWiTagCursor(struct TagItem *);
		BOOL isDone() const { return(pos == NULL); };
		void first();
		void next();
		struct TagItem *item() const { return(pos); };
		Tag itemTag() const;
		ULONG itemData() const;
	};

#endif
