-> It's only a little example to see the usage of the functions

->OPT OSVERSION=37

MODULE 'tools/bits'

PROC main()
DEF a, b, c, str[40]:ARRAY OF CHAR

   a:=$10; b:=$11223344; c:=$12345678

   Print('Initial value for the next tests is $\h.\n',a)
   Print('BitSet   : bit 6       = $\h\n', bitset(a, 6))
   Print('BitClear : bit 4       = $\h\n', bitclear(a, 4))
   Print('BitTest  : bit 3       = $\h\n', bittest(a, 3))
   Print('BitTest  : bit 4       = $\h\n', bittest(a, 4))
   Print('BitChange: bit 5       = $\h\n', bitchange(a, 5))
   Print('BitDSet  : bit 3 dep 1 = $\h\n', bitdset(a, 3, 1))
   Print('BitDSet  : bit 3 dep 0 = $\h\n', bitdset(a, 3, 0))

   Print('\nInitial value for swapping is $11223344.\n')
   Print('SWAP_LONG              = $\h\n', swap(b, SWAP_LONG))
   Print('SWAP_HIGH              = $\h\n', swap(b, SWAP_HIGH))
   Print('SWAP_LOW               = $\h\n', swap(b, SWAP_LOW))
   Print('SWAP_INNER             = $\h\n', swap(b, SWAP_INNER))
   Print('SWAP_OUTER             = $\h\n', swap(b, SWAP_OUTER))

   Print('\nInitial value for string functions is $12345678.\n')
   Print('BinToStr SIZE_LONG     = %\s\n', bintostr(c, SIZE_LONG, str))
   Print('BinToStr SIZE_WORD     = %\s\n', bintostr(c, SIZE_WORD, str))
   Print('BinToStr SIZE_BYTE     = %\s\n', bintostr(c, SIZE_BYTE, str))
   Print('BinToStr other: 11     = %\s\n', bintostr(c, 11, str))

   Print('\nInitial string for reconverting into a number is\n  -> \'\s\'\n',bintostr(c, SIZE_LONG, str))
   Print('StrToBin SIZE_LONG     = $\h\n', strtobin(str, SIZE_LONG))
   Print('StrToBin SIZE_WORD     = $\h\n', strtobin(str, SIZE_WORD))
   Print('StrToBin SIZE_BYTE     = $\h\n', strtobin(str, SIZE_BYTE))
   Print('StrToBin other: 11     = $\h\n', strtobin(str, 11))
ENDPROC
