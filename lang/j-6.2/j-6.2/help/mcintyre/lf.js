NB.  This file can be used as a script input file to J Version 5.1a.
NB.  August 1992

NB.  Donald B. McIntyre
NB.  Luachmhor, 1 Church Road
NB.  KINFAUNS, PERTH PH2 7LD
NB.  SCOTLAND - U.K.
NB.  Telephone:  In the UK:      0738-86-726
NB.  From USA and Canada:   011-1-738-86-726
NB.  email:  donald.mcintyre@almac.co.uk
   
   NB.   Using J with External Data:  Inserting Line Feeds
   NB.   VECTOR Vol.8#4 (April 1992) 97-110
   
NB.  Reads four files:  tut10.in  tut11.in  tut12.in  tut13.in
NB.  Writes corresponding files with extension .out
      read=. 1!:1@<
      lf=. 10{a. [  nl=. 13{a.

      ]x=. read 'tut11.in'
      +/ x =/ 13 10 { a.

      h=. <;.2~ =&nl        NB.  Hook
      each=. &.>
      g=. ,&lf each
      edit=. ; @ (g @ h)
      input=. edit @ read
      input=. input f.

      infiles=. 'tut10.in';'tut11.in';'tut12.in';'tut13.in'
      outfiles=. 'tut10.out';'tut11.out';'tut12.out';'tut13.out'

      output=. 1!:2~ >               NB.   Hook
      outfiles output"0 input each infiles

      read 'tut11.in'
      read 'tut11.out'
