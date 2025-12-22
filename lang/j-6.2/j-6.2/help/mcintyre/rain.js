NB.  This file can be used as a script input file to J Version 4.1x2.
NB.  It was prepared for the J Workshop in London, 27 March 1992,
NB.  organised by Anthony Camacho for The British APL Association.

NB.  Donald B. McIntyre
NB.  Luachmhor, 1 Church Road
NB.  KINFAUNS, PERTH PH2 7LD
NB.  SCOTLAND - U.K.
NB.  Telephone:  In the UK:      0738-86-726
NB.  From USA and Canada:   011-1-738-86-726

NB.   Using J with External Data:  Example of rain data
NB.   VECTOR 1992, In Press
NB.   ASCII file "data.in" is read and file "data.out" is written
   read=. 1!:1 @ <              NB.  Read input file
   write=. [ 1!:2 <@]           NB.  Write to a file.   Fork
   write=. 1!:2 <@]             NB.  Write to a file.   Hook

NB.  "data.in" is as ASCII file with 12 rows of 10 columns
NB.  X stands for missing data.   Replace by _1
   y=. read 'data.in'

NB. Line feed;  New line;  End of file
   lf=. 10 { a. [ nl=. 13 { a. [ eof=. 26 { a.
   ]i=. u # i. # u=. y = 'X'   NB.  Indices of X in the string
   ,i +/0 1
   (+:#i)$'_1'
   z=. ((+:#i)$'_1') (,i +/0 1)}y   NB. Amend the string

NB. Define verbs to amend the string
   h=. 'X'&=@] # i.@#
   h y
   g=. ,@(+/&0 1)@h
   g y
   f=. $&'_1' @ (+:@#@h)
   f y

   z-: (f y) (g y)} y
   amend=. '(f y.) (g y.)} y.' : ''
   z-: amend y

   amend=. f g@]} ]
   amend
   z-: amend y
   
NB.  Convert character string to numeric matrix
   d=. 12 8 $ ". z #~ -. z e. lf,nl,eof

NB.  Illustration of "cut"
   s=. '1 2 3',lf,'4 5 6',lf,'7 8 9',lf
   cut=. <;._2
   cut s
   ;  cut s        NB.  Raze
   ,. cut s        NB.  Ravel
   >  cut s        NB.  Open
   $ ".&.> cut s
   execute=. > @ (".&.> @ <;._2)
   1 + execute s

   d -: data=. execute z#~ -. z e. nl,eof
   data

NB.  Indexes of missing values represented by _1
   (,u)#i.#,u=. 0>data

   h=. 0&>@,
   g=. (] # i.@#)@h     NB.  Fork
   g=. (# i.@#)@ h      NB.  Hook
   ir=. g f.
NB. Index in Ravel of matrix
NB. Fix ir so that the names g and h can be reused
   ir data

NB. Row indexes
   <.8%~ir data
   (<.@(%&8)) ir data
   
NB. Column indexes
   8|ir data

   {:$ data

   row=. <. @ (ir % {:@$)
   row data
   
   column=. {:@$ | ir
   column data

   f=. row ,. column
   f data

   ix=. <"1 @(row ,. column)  NB.  Row & Column indexes
   ]i=. ix data
   ]z=. i{data
   z-: ({~ ix) data     NB.  Hook
   z-: (ir data){,data
   z-: (ir { ,) data    NB.  Fork

NB.  Mean of rows with missing data (represented by _1)
   mean=. +/%#
   ]m=. mean"1 (row data){data
    m-: mean"1 ({~row) data          NB.  Hook

   mean n=. 1 _9 2 3 _1 4 0 5
   (>:&0 # ]) n          NB.  Fork

NB. Change this fork into a hook
   h=. >:&0              NB.  Monadic
   h n
   g=. #~                NB.  Dyadic
   n g (h n)
   (g h) n               NB.  Hook
   (#~ >:&0) n           NB.  Hook

NB.  Mean over positive or zero values
   pzmean=. mean @ (>:&0 # ])
   pzmean n

NB.  Replace _1 by row means
   ]m=. pzmean"1 ({~row) data
      ]i=. ir data
      (ir data){,data
      (ir { ,) data
      ]x=. m i}data
      amend=. ir@]} 
      x-: m amend data
NB.  Catenate Annual and Monthly means and the grand mean
   ymean=. ,"2 1 mean     NB.  Hook
   ymean x
   (ymean x),"1 0 (mean"1 x),mean ,x
   
   ]s=. 7.2":((,"2 1 mean) x),"1 0 (mean"1 x),mean ,x
   ]s=. 6.2":((,"2 1 mean) x),"1 0 (mean"1 x),mean ,x
   
NB.  Write an ASCII file with New Line and Line Feed characters
   (,s,"1 nl,lf) write 'data.out'
   
NB.  Display as a table
   f=. <@(7.2&":)
   g=. f&:(,:@ mean"1) ,: f@ mean @ ,
   h=. f , f@ mean
   table =. h ,"0 1 g
   ]t=. table x
   $t

NB.  Change the format
   f=. <@(6.2&":)
   ]t=. table x
