#ifndef TWICPP_DATASTRUCTURES_ARRAY_H
#define TWICPP_DATASTRUCTURES_ARRAY_H

//
//  $VER: Array.h       1.0 (23 Jan 1997)
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

#ifndef TWICPP_EXCEPTIONS_EXCEPTIONS_H
#include <twiclasses/exceptions/exceptions.h>
#endif

///

/// template <class T> class TWiArray

template <class T> class TWiArray
    {
    private:
        ULONG FieldSize;
        T *Field;
        ULONG TopIndex;
        VOID extend(const ULONG);
        VOID copy(const T *, const ULONG);
    public:
        TWiArray(ULONG size = 16) : FieldSize(0), Field(NULL), TopIndex(0) { extend(size); };
        TWiArray(const TWiArray<T> &s) : FieldSize(0), Field(NULL), TopIndex(s.TopIndex) { copy(s.Field, s.FieldSize); };
        ~TWiArray() { delete[] Field; };
        TWiArray<T> &operator= (const TWiArray<T> &);
        T &operator[](ULONG);
        operator APTR() const { return((APTR)Field); };
        ULONG size() const { return(FieldSize); };
        ULONG length() const { return(TopIndex); };
        T &addTail() { return(operator[](TopIndex++)); };
        T &insert(const ULONG);
        VOID rem(const ULONG);
        VOID remTail() { TopIndex--; };
        VOID clear();
    };

///

/// template <class T> VOID         TWiArray<T>::extend(const ULONG)

template <class T> VOID TWiArray<T>::extend(const ULONG minsize)
    {
    ULONG newsize = FieldSize * 2;
    if (minsize > newsize)
        newsize = minsize;
    else
        ;
    T *newfield = new T[newsize];
    if (newfield != NULL)
        {
        if (Field != NULL)
            {
            for (LONG i = (LONG)FieldSize - 1  ;  i >= 0  ;  i--)
                *(newfield+i) = *(Field+i);
            delete[] Field;
            }
        else
            ;
        FieldSize = newsize;
        Field = newfield;
        }
    else
        throw TWiMemX(sizeof(T)*newsize);
    };

///
/// template <class T> VOID         TWiArray<T>::copy(const T*, const ULONG)

template <class T> VOID TWiArray<T>::copy(const T *src, const ULONG ssize)
    {
    delete[] Field;
    FieldSize = ssize;
    if (src == NULL)
        Field = NULL;
    else
        if ((Field = new T[ssize]) != NULL)
            for (LONG i = ssize - 1  ;  i >= 0  ;  i--)
                *(Field+i) = *(src+i);
        else
            throw TWiMemX(sizeof(T)*ssize);
    };

///
/// template <class T> TWiArray<T> &TWiArray<T>::operator=(const TWiArray<T> &)

template <class T> TWiArray<T> &TWiArray<T>::operator=(const TWiArray<T> &s)
    {
    if (this != &s)
        {
        copy(s.Field, s.FieldSize);
        TopIndex = s.TopIndex;
        }
    else
        ;
    return(*this);
    };

///
/// template <class T> T           &TWiArray<T>::operator[](ULONG)

template <class T> T &TWiArray<T>::operator[](ULONG i)
    {
    if (i >= FieldSize)
        extend(i+1);
    else
        ;
    return(Field[i]);
    };

///
/// template <class T> T           &TWiArray<T>::insert(const ULONG)

template <class T> T &TWiArray<T>::insert(const ULONG index)
    {
    TopIndex++;
    if (TopIndex >= FieldSize)
        extend(TopIndex+1);
    else
        ;
    for (ULONG i = TopIndex  ;  i > index  ;  i--)
        Field[i] = Field[i-1];
    return(Field[index]);
    };

///
/// template <class T> VOID         TWiArray<T>::remove(const ULONG)

template <class T> VOID TWiArray<T>::rem(const ULONG index)
    {
    TopIndex--;
    for (ULONG i = index  ;  i < TopIndex  ;  i++)
        Field[i] = Field[i+1];
    };

///
/// template <class T> VOID         TWiArray<T>::clear()

template <class T> VOID TWiArray<T>::clear()
    {
    delete[] Field;
    Field = NULL;
    FieldSize = 0;
    TopIndex = 0;
    };

///

/// template <class T> class TWiArrayCursor

template <class T> class TWiArrayCursor
    {
    private:
        TWiArray<T> *Array;
        LONG ArrayIndex;
    public:
        TWiArrayCursor(TWiArray<T> &a) : Array(&a), ArrayIndex(0) { };
        operator VOID *() { return(isDone() ? NULL : this); };
        BOOL operator! () { return(isDone()); };
        VOID first() { ArrayIndex = 0; };
        VOID last() { ArrayIndex = Array->length(); };
        VOID next() { ArrayIndex++; };
        VOID prev() { ArrayIndex--; };
        LONG index() const { return(ArrayIndex); };
        T &item() { return((*Array)[(ULONG)ArrayIndex]); };
        BOOL isDone() { return(ArrayIndex >= Array->length() || ArrayIndex < 0); };
    };

///

#endif
