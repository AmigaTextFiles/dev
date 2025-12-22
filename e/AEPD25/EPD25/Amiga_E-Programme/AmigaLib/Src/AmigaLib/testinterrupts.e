-> allocentry.e - Example of allocating several memory areas.

MODULE 'exec/memory'

CONST ALLOCERROR=$80000000

-> E-Note: like the Assembly version, a ml does not contain a me, so body[4]
OBJECT memBlocks
  head:ml              -> One entry in the header, additional entries follow
  body[4]:ARRAY OF me  -> directly as part of the same dat