      script=. 0!:2&<
      display=. 9!:3
      display 2 4 5
 
      NB.  Markov from John Davis "Statistics" 2nd Ed p. 158-161
      
      m=. 0 11 36 21 52,: 28 0 4 4 0
      m=. m, 34 2 0 45 13,: 29 1 45 0 3
      m=. m, 28 23 9 8 0

      sum=. +/
      rows=. "1
      sr=. ,"1 0 sum rows
      sr m          

      gsum=. +/@,                   NB. Grand sum
      diag=. (<0 1)&|:
      diag m
      i.5 5
      diag i.5 5
      ]n=. 1000 (diag i.5 5) } m
      g=. diag@i.@$@] }
      n-: 1000 g m

      sum rows n
      gsum n        NB. Grand sum

      h=. *: @ (sum rows) % gsum
      h n
      h

      ]z=. (h n) g n
      z-: n g~ (h n)
      f=. g~ h                        NB. Hook                                    
      z-: f n

      h
      limit=. ^: _
      ]tfd =. f limit n   NB. Transition frequency with diagonals


      NB. Marginal probability vector
      
      mpv=. sum rows % gsum     NB. Fork
      mpv tfd


      NB. Expected Probabilities
      
      expprob=. */~@mpv
      expprob tfd


      NB. Expected frequencies
             
      expfreq=. expprob * gsum
      ]z=. expfreq tfd
      z-: expfreq@(f limit) n

                                    
