NB.  This file can be used as a script input file to J Version 5.1a.
NB.  September 1992

NB.  Donald B. McIntyre
NB.  Luachmhor, 1 Church Road
NB.  KINFAUNS, PERTH PH2 7LD
NB.  SCOTLAND - U.K.
NB.  Telephone:  In the UK:      0738-86-726
NB.  From USA and Canada:   011-1-738-86-726
NB.  email:  donald.mcintyre@almac.co.uk

apv=. {.@] + [* (i.@>.@>:)@(%~ |@-/)
NB. Arithmetic Progression Vector:   0.5 apv _2 5

bi=. <"_1                 NB. Box items
boxchar=. 9!:6            NB. Enquire on current setting of box characters
NB. 9!:7 ]218 194 191  195 197 180  192 193 217  179 196 { a. NB. reset box
NB. 9!:7 (9$'+'),'|-'     NB. Set alternative box characters

by=. ' '&;@,.@[,.]
clean=. ] * (<:|)         NB. Set to zero. Tolerance on left

copy=. 2!:4&<          NB. Copy single item.   'apv' copy 'util.ws'
copy=. ;:@[ 2!:4 <@]   NB. Copy item(s). 'qrl setrl' copy 'util.ws'
copyws=. 2!:1@< 2!:4 < NB. Copy all items from locale.  copyws 'util.ws'

(;:'lf cr eof')=. 10 13 26{a.
NB. Carriage Return, Line Feed, End of File

E=. ].@([.(+&)) - ].      NB. c <- c c c ; c <- c v c
S=. ([.(%&))@E            NB. Secant slope
S=. 'S' f.
D=. 1e_8 S                NB. a <- n c    Derivative adverb
D=. 'D' f.
NB.(1 E *:) 1 2 3 4
NB. (0.01 S *:) 1 2 3 4
NB. *: D _2 _1 0 1 2 3

dfr=. rfd^:_1             NB. Degrees From Radians
diag=. (<0 1)&|:          NB. Diagonal
dir=. 0!:0 'dir'          NB. Directory of current subdirectory
display=. 5!:2@<          NB. ]x=. display 'exp'
drop=. 1!:55@<            NB. Drop 'junk.fil'
each=. &.>                NB. # each 'abc';'defg';'hijkl'
edit=. 8!:9               NB. Edit a character string
erase=. 4!:55@;:          NB. Erase named object(s) erase: 'f g h'
exp=. /:@\:@[ { #@[ {. ]  NB. Expand.   1 0 1 exp 7 8
fsize=. 1!:4@<            NB. File size
gauss=. {.@] + {:@] * -&6@%&1e9@(+/@?@($&1e9)@(12&,))@[
NB.  100 gauss 0 1 NB. 100 normally distributed values mean 0, sd 1
getedit=. edit@read       NB. Read a file into the J editor
host=. 0!:0               NB. host 'dir c:\*.bat'
im=. =@i.                 NB. Identity Matrix
ip=. +/ .*                NB. Inner Product
linear=. 5!:5@<           NB. Linear representation 

noun=. 2 [ verb=. 3 [ adverb=. 4 [ conjunction=. 5
names=. >@(4!:1)  NB. 'e' names verb,adverb
NB. Optional left argument:  initial letter(s)

over=. ({.,.@;}.)@":@,
qrl=. 9!:0                NB. Query Random Link:  qrl 0
read=. 1!:1&<             NB. x=. read 'out1.fil'
rfd=. %&180@o.            NB. Radians From Degrees

rlfe=. >@((#~ ~:&lf)&.>@(<;.1~ =&lf))
NB. Remove Line-Feeds from Edited lines:  ]x=. rlfe editor ''

round=. [ * <.@+&0.5@%~   NB. Round y to nearest x
NB. (10^-i.6) round o.1
NB. 5 10 50 100 150 5000 10000 25000 round 123456
NB.  x=. 5 50 500 5000 [y=. 646464 64646 6464 646
NB.  y by x over |: x round"0 1 y

save=. 2!:2@<    NB. Save all Global Names.  save 'my.ws'
setrl=. 9!:1     NB. Set Random Link:  setrl 7^5
table=. '[ by ] over [ x.f. / ]' : 1   NB.  + table i.5
time=. 6!:0      NB. Time stamp
timeit=. 6!:2    NB. timeit '+/i.1000'
tree=. 5!:4 @<   NB. Tree 'exp'

t=. >;:'NA NA noun verb adverb conjunction other'
type=. {&t@(4!:0@<)  NB. No need to "fix" this
erase 't'

wdfe=. write~ ,&eof@(;@(,&cr&.>@(<;.1~ =&lf)))@]
NB. Write DOS File from Edited Lines:  'out.fil' wdfe xx=. edit ''

wsnl=. 2!:1@<    NB. List of names in locale. x=. list 'stat.ws'

write=. 1!:2 <   NB. Write string (left) to file (right)
NB.  'Now is the time' write 'out0.fil'
NB.  (,x,"1 cr,lf) write 'out1.fil' [ x=. ":i.3 4

writes=. 1!:2&2  NB. Write on Screen: x=. writes 'This message'

xedit=. ".&.>@(<;._1~ =&lf)
NB. Execute Edited Lines, giving boxed results:  x=. xedit editor ''
NB. Function definitions cannot be executed by (".)
NB. Write a DOS file; then execute it as a script.
NB. -----------------------------------------
script=. 0!:2&<
NB. 'out.fil' script 'in.fil'   OR   script 'in.fil
NB.  OR   'out.fil' script ''

sscript=. 0!:3@< NB. Silent Script

off=. 0!:55      NB. Return to DOS with:    off 0
NB.  Return to DOS with:   Ctrl d   <Enter>
