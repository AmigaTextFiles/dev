   NB.  This file can be used as a script input file to J Version 5.1a.
   NB.  September 1992
   
   NB.  Donald B. McIntyre
   NB.  Luachmhor, 1 Church Road
   NB.  KINFAUNS, PERTH PH2 7LD
   NB.  SCOTLAND - U.K.
   NB.  Telephone:  In the UK:      0738-86-726
   NB.  From USA and Canada:   011-1-738-86-726
   NB.  email:  donald.mcintyre@almac.co.uk



      NB. Econometrics example. Based on Frank Wykoff, Pomona College
      ]z=. ?10#100      NB. Simulate the (independent variable)
      ]x=. 1,.z         NB. Append 1
      ]u=. 10%~?10#100  NB. Simulate an unknown influence
      ]m=. 1,.z,.u      NB. Set up the model:  y = a +bz +u
      c=. 3 2 1         NB. Suppose these are the coefficients
      ip=. +/ .*        NB. Inner Product
      ]y=. m ip c       NB. y is the dependent variable
      y %. m            NB. c can be recovered from z and u
      ]d=. z,.y         NB. Suppose d is known.   z= d + fy + v
      mean=. +/%#       NB. Fork
      mean d            NB. Means of z and y
      dev=. -"1 mean    NB. Deviations from the means
      ]t=. dev d
      dev=. -"_1 _ mean NB. Generalize for any rank
      t-: dev d
      ss=. +/@*:        NB. Sums of Squares
      ssdm=. ss@dev     NB. SS of deviations from means
      ssdm d
      var=. ssdm % <:@# NB. Variances
      var d             NB. Variances of z and y
      sd=. %:@var       NB. Standard deviations
      sd d
      ]c0=. y%.x        NB. Least Squares coefficients for model
      ]yp0=. x ip c0    NB. Predicted values of y
      ss y-yp0          NB. SS of residuals
      c1=. 8 2          NB. Take rounded values
      yp1=. x ip c1     NB.   and recompute predicted values of y
      y,"0 1 yp0,.yp1   NB. Tabulate values of y, yp0, yp1
      ss y-yp1          NB. SS is now larger

      NB.  Model:  z = d + fY + gV

      ]v=. 1+100%~?10#100     NB. Create v
      ]m=. 1,.y,.v
      c=. _1 3.5 2      NB. Suppose these are the coefficients
      ]z=. m ip c       NB. Now determine z
      s=. (?10#2){1 _1  NB. Add "experimental error" to z
      e=. s*0.05*z
      z=. z+e

      ]c0=. z%.m        NB. "Observed" coefficients
      zp=. m ip c0      NB. Predicted values of z
      z,.zp,.z-zp
      ss z-zp           NB. ss residuals
      ss z- m ip _30.3613 3.56557 17.4062    NB.  Minimum
      ss z- m ip _30.36   3.57    17.41
      ss z- m ip _30.35   3.55    17.4
