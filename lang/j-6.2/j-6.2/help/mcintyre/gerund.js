   NB.  This file can be used as a script input file to J Version 5.1a.
   NB.  September 1992
   
   NB.  Donald B. McIntyre
   NB.  Luachmhor, 1 Church Road
   NB.  KINFAUNS, PERTH PH2 7LD
   NB.  SCOTLAND - U.K.
   NB.  Telephone:  In the UK:      0738-86-726
   NB.  From USA and Canada:   011-1-738-86-726
   NB.  email:  donald.mcintyre@almac.co.uk

      y3=. i.3 4 5           NB. A rank-3 table
      <"_1 y3                NB. Box items
      <"0 y3                 NB. Box rank-0 cells

      2 0 1{y3               NB. Select items
      1{y3
      {.y3                   NB. Head
      {:y3                   NB. Tail

      y2=. {.y3              NB. A rank-2 table
      y1=. {.y2              NB. A rank-1 list

      shape=. $
      rank=. $@$
      tally=. #

      rank y3
      tally y3
      shape y2
      rank y2
      tally y2

      g=. shape ` rank ` tally        NB. Gerund
      f=. g `: 0                        NB. Evoke gerund
      f y3
      f y2
      f y1

      s=. <@shape
      r=. <@rank
      t=. <@tally

      srt=. s`r`t               NB. Gerund
      h=. srt `: 0
      h y3
      h@> y3;y2;y1;5

      (1|.srt) `: 0 y3          NB. Verbs can manipulate gerunds

      $g1=. |: srt,:|.srt
      f=. g1 `:0 &.> 
      f y3;y2;y1;5

      g2=. +`-`*`%`+:`-:`*:`%:
      g2=. 2 2 2$g2
      v=. g2 `: 0
      ]y=. (i.2 3),_1 _2 _3
      $z=. v y
      z