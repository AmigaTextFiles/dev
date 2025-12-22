OPT LINK='*file.o'

MODULE 'dos','dos/dos','exec','exec/memory'

LIBRARY LINK
  loadFile(filename),
  freeFile(mem)

