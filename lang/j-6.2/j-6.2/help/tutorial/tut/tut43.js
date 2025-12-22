        FAMILIES OF FUNCTIONS Ob
   c=. 4 2 _3 2 1
   vandermonde
1  1  1   1   1    1    1
1  2  3   4   5    6    7
1  4  9  16  25   36   49
1  8 27  64 125  216  343
1 16 81 256 625 1296 2401
   c +/ . * vandermonde
6 28 118 348 814 1636 2958
   
   poly=. '':'x.+/ . *|:y.^/i.#x.'
   c poly x
6 28 118 348 814 1636 2958
