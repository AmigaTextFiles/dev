      script=. 0!:2&<
      NB. 'session.log' script ''
      display=. 9!:3
      display 2 4 5
      NB. ---------------------------------
      NB. TORONTO, Sept 1992.   Donald B. McIntyre
      NB. Luachmhor, Church Road
      NB. Kinfauns, Perth PH2 7LD
      NB. Scotland - U.K.
      NB. 011-44-738-86-726
      NB. donald.mcintyre@almac.co.uk
      NB.-----------------------------------

      two=. 2 [ three=. 3 [ half=. 0.5 [ quarter=. %4
      to=. and=. plus=. added=. +
      a=. show=. ]
      do=. ".
      show s=. '(three and a half) added to (two and a quarter)'
      do s
      x=. three and a half [ y=. two and a quarter
      show z=. x added to y
      z-: x plus y
      z-: x + y
      3.5+2.25
      NB. ------------------------------
      minus=. -     NB. verb
      x minus y
      cross=. ~     NB. adverb
      from=. minus cross     NB. New verb
      x from y
      into=. % cross         NB. New verb
      x into y
      with=. &      NB. conjunction
      third=. % with 3       NB. Bonding
      12 % 3        NB. Dyadic
      third 12      NB. Monadic
      with3=. with 3         NB. adverb
      % with3 12    NB. Divide
      * with3 2     NB. Times
      ^ with3 2     NB. Power 
      NB. --------------------------------
      <'cat'        NB. Box
      ;:'||.|:'     NB. Word formation
      s=. 'NA NA noun verb adverb conjunction other'
      #s            NB. Tally or count
      ;:s           NB. Box words
      #;:s          NB. Count words
      >;:s          NB. Open
      atop=. @      NB. conjunction
      v=. > atop ;: NB. new verb: 2 verbs joined by a conjunction
      $t=. v s    NB. shape
      2 4 { t 	    NB. dyadic. Take items 2 and 4 from t
      NB. -----------------------------------
      f=. { with t  NB. monadic
      f 2 4         NB. select from t
      g=. 4!:0	    NB. Foreign	conjunction making a verb
      h=. <         NB. Box
      atop=. @      NB. conjuncction
      type=. f@g@h  NB. make a verb by compounding three verbs
      NB.  Compare:    log sin root x
      NB.  ss is SUM after SQUARES after DEVIATIONS
      type
      type=. type f.  NB. Fix
      type
      type 't'
      type 'type'
      insert=. /
      type 'insert'
      integers=. i.
      type 'integers'
      ]list=. i.10
      total=. plus insert
      type 'total'
      total list
      count=. tally=. #
      count list 
      scan=. /\
      type 'scan'
      + scan list
      type 'with3'
      type 'with'
      type 'atop'
      NB. ----------------------------------------
      mean=. total % count    NB. Fork
      mean list
      f g h            NB. train:  3 verbs     Fork
      d e f g h        NB. train:  5 verbs     Fork
      %/&3 e~ f g h    NB. train:  5 verbs     Fork
      %/&3 d e~ f g h  NB. Hook:   6 verbs     Hook

      
