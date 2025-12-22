-> It's only a little example to see the usage of the functions

OPT OSVERSION=37

MODULE 'tools/bits'

PROC main()
DEF a, b, c, str[40]:ARRAY OF CHAR

   a:=$10; b:=$11223344; c:=$12345678

   WriteF('Initial value for the next tests is $\h.\n',a)
   WriteF('BitSet   : bit 6       = $\h\n', bitset(a, 6))
   WriteF('BitClear : bit 4       = $\h\n', bitclear(a, 4))
   WriteF('BitTest  : bit 3       = $\h\n', bittest(a, 3))
   WriteF('BitTest  : bit 4       = $\h\n', bittest(a, 4))
   WriteF('BitChange: bit 5       = $\h\n', bitchange(a, 5))
   WriteF('BitDSet  : bit 3 dep 1 = $\h\n', bitdset(a, 3, 1))
   WriteF('BitDSet  : bit 3 dep 0 = $\h\n', bitdset(a, 3, 0))

   WriteF('\nInitial value for swapping is $11223344.\n')
   WriteF('SWAP_LONG              = $\h\n', swap(b, SWAP_LONG))
   WriteF('SWAP_HIGH              = $\h\n', swap(b, SWAP_HIGH))
   WriteF('SWAP_LOW               = $\h\n', swap(b, SWAP_LOW))
   WriteF('SWAP_INNER             = $\h\n', swap(b, SWAP_INNER))
   WriteF('SWAP_OUTER             = $\h\n', swap(b, SWAP_OUTER))

   WriteF('\nInitial value for string functions is $12345678.\n')
   WriteF('BinToStr SIZE_LONG     = %\s\n', bintostr(c, SIZE_LONG, str))
   WriteF('BinToStr SIZE_WORD     = %\s\n', bintostr(c, SIZE_WORD, str))
   WriteF('BinToStr SIZE_BYTE     = %\s\n', bintostr(c, SIZE_BYTE, str))
   WriteF('BinToStr other: 11     = %\s\n', bintostr(c, 11, str))

   WriteF('\nInitial string for reconverting into a number is\n  -> ''\s''\n',bintostr(c, SIZE_LONG, str))
   WriteF('StrToBin SIZE_LONG     = $\h\n', strtobin(str, SIZE_LONG))
   WriteF('StrToBin SIZE_WORD     = $\h\n', strtobin(str, SIZE_WORD))
   WriteF('StrToBin SIZE_BYTE     = $\h\n', strtobin(str, SIZE_BYTE))
   WriteF('StrToBin other: 11     = $\h\n', strtobin(str, 11))
ENDPROC
