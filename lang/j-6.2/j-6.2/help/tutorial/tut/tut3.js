                       TABLES Da
   prices=. 3 1 4 2
   orders=. 2 0 2 1
   prices * orders
6 0 8 2
   prices */ orders
6 0 6 3
2 0 2 1
8 0 8 4
4 0 4 2

   TO READ A TABLE,
   BORDER IT BY ITS ARGUMENTS:

   over=.({.,.@;}.)&":@,
   by=.(,~"_1 ' '&;&,.)~
   prices by orders over prices */ orders
+-+-------+
| |2 0 2 1|
+-+-------+
|3|6 0 6 3|
|1|2 0 2 1|
|4|8 0 8 4|
|2|4 0 4 2|
+-+-------+
