/*
    just a silly example
*/

MODULE 'tools/poolstrings', 'amigalib/mempools'
MODULE 'exec/memory'

PROC main()
    DEF pool, str1:PTR TO CHAR, str2:PTR TO CHAR

    -> this is our pool
    pool:=libCreatePool(MEMF_PUBLIC, 50, 20)
    IF pool
        -> let's allocate a string 10 bytes long
        str1:=poolString(10, pool)
        -> remember to check the string before using it!
        IF str1
            -> our string can be safely manipulated
            -> like any other estring :)
            StrCopy(str1, 'hi!', STRLEN)
            PrintF('string "\s" is \d bytes long\n', str1, EstrLen(str1))

            StrAdd(str1, ' How are you?', STRLEN)
            PrintF('string "\s" is now \d bytes long\n', str1, EstrLen(str1))

            -> create another string
            str2:=poolString(15, pool)
            IF str2
                -> copy some silly characters
                StrCopy(str2, 'some silly characters!', STRLEN)

                -> link the two string
                -> ***WARNING*** you can link ONLY string that
                -> are in the SAME memory pool!!!!!!!!
                Link(str1, str2)

                PrintF('the address of the tail of str1 is \d\n' +
                       'and should be the equal to \d\n', Next(str1), str2)
            ENDIF
            -> this should not be necessary, since libDeletePool()
            -> will automatically deallocate our string
            poolDisposeLink(str1, pool)
            libDeletePool(pool)
        ENDIF
    ENDIF
ENDPROC

