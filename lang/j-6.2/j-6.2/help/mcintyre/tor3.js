      NB. Scaling to range 0 - 1
      
      from=. -~
      setrl=. 9!:1
      setrl 7^5
 
      qrl=. 9!:0
      qrl 0
      from=. -~
      list=. 20 from ?10#40
      list ,: list - <./list
      h=. -<./	   NB. Hook
      list ,: h list
      f=. ,: h     NB. Hook
      f list
      NB. ---------------------------
      
      g=. % >./	   NB. Hook
      scale=. g@h
      scale list
      scale
      scale f.
      setrl 7^5

      NB.  Selecting values less than or equal to 0
 
      list=. 10-~?10#20
      (list <:0) # list
      list
      h=. <:&0     NB. Hook
      g=. #
      (h list)  g list
      f=. g~ h
      f list
      h=. <: 0:    NB. Alternative
      f list
      f
      f f.
      NB. -------------------------------------
      NB. Shape, Rank, and Tally
      
      ]y3=. i. 3 4 5
      $y3
      $$y3
      #y3
      2 0 1 { y3
      1 { y3
      {. y3
      y2=. {. y3
      y1=. {. y3
      shape=. $
      rank=. $@$
      tally=. #
      s=. <@shape
      r=. <@rank
      t=. <@tally
      g=. shape`rank`tally    NB. Gerund
      f=. g `: 0
      f y3
      srt=. s`r`t             NB. Gerund
      h=. srt `: 0
      h@> y3;y2;y1;5
      NB. --------------------------------
      NB. Items

      <y3
      <"2 y3
      <"1 y3
      <"0 y3
      # y3
      <"2 y3
      NB. Box items
      
      # y2=. i. 4 5
      <"1 y2
      #y1
      <"0 y1=. i.5
      bi=. <"_1    NB. Box items
      bi y3
      bi y2
      bi y2
      bi y1
      bi 5
      2 0 { y3
      2 0 { y2
      2 0 { y1
      1{y3
      (<1 2 3) { y3
     NB. --------------------------------- 
     NB. scattered indexing
      
      (1 2 3; 0 2 4; 2 3 1) { y3
      ]d=. <"0 i. 5 6
      li=. [ { i.@$@]    NB. Linear Index.   Forl
      1 4 li d
      (<2 5) li d
      x=. 9 8 7 6,: 5 4 3 2
      (<x) 17} d
      (x;'London') ((2 5;4 2) li d) } d
      m=. i. 6 6
      i=. 2 2;2 4; 4 2; 4 4
      x=. 100 101 102 103
      f=. >@[ +/ .* ,&1@#@]
      f
      i f m
      x (i f m) } m
