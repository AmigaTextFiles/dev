{ ==
  == The Standard-ML Benchmark Suite
  ==
  == }


SPEC Benchmark = 

 STREAM + 
 INTEGER +
 TIMER +
 INTEGER_UTIL +

OPNS startclock :: system -> (integer,system).
EQNS startclock S = (0,start_timer S).


MACROS
      (#yes,#avail) = available S.
      
      #msg = #avail+
              (if #yes then ""
               else "No automatic timer - use your favourite watch!\n\n")
              +"The SML Benchmark Suite\n"
              +"-----------------------\n"
              +" 1) tak\n"
              +" 2) fib\n"
              +" 3) hexa\n"
              +" 4) histo\n"
              +" 5) tree 10\n"
              +" 6) tree 13\n"
              +" 7) tree 16\n"
              +"\n"
              +"Select Test\n".
      (_,#test,#read) = read(1,#msg).
      (#cmp,#clock) = startclock #read.
      (#sec,#hsec,#gettime) = elapsed_time (stop_timer #clock).
      #doit #T = if (if #cmp==#T then true else true)
                 then #gettime+
                     (if #yes then 
                         "Time: "+
                         integer_string(#sec)+"."+integer_string(#hsec)+" sec\n"
                      else "")
                 else #clock+"Something odd happend\n".

OPNS goal :: system -> system.
EQNS goal S = case #test of
                1: #doit (bench_tak  10)
               |2: #doit (bench_fib  10)
               |3: #doit (bench_hexa 10)
               |4: #doit (bench_histo 10)
               |5: #doit (bench_tree 10 10)
               |6: #doit (bench_tree 13 10)
               |7: #doit (bench_tree 16 10)
               else #read+"Wrong Selection\n".

{--- Binary tree ---}

OPNS rand :: integer -> integer.
EQNS rand N = (N*1309+13849) _mod 65536.

SORTS tree ::= leaf integer | node integer tree tree.
      ints ::= [integer].

OPNS maketree :: integer -> tree.
MACROS #i = rand Depth.
EQNS maketree Depth = if Depth == 0
                      then leaf #i
                      else node #i (maketree (Depth-1)) (maketree (Depth-1)).
 
OPNS depthfirst :: tree -> ints -> ints.
EQNS depthfirst (leaf I) L = I:L.
     depthfirst (node I T1 T2) L = I : (depthfirst T2 (depthfirst T1 L)).

OPNS rev :: ints -> ints.
EQNS rev L = rev L [].
  
  OPNS rev :: ints -> ints -> ints.
  EQNS rev [] H = H.
       rev (A:R) H = rev R (A:H).

OPNS hd :: ints -> integer.
EQNS hd (A:_) = A::integer.
     hd [] = 0.

OPNS tree :: integer -> integer.
EQNS tree N = hd (rev (rev (rev (rev (depthfirst (maketree N) []))))).

OPNS bench_tree :: integer -> integer -> integer.
EQNS bench_tree S N = if N <= 0 then N else (tree S)+bench_tree S (N-1).

{--- histo -- non-r-transparent ---}

IMPORTS ARRAY ACTUAL SORTS data=integer. END+

OPNS period :: (integer,integer,integer) -> ints.
EQNS period (N,T,Z) = if N==0 then []
                      elsif Z>T then period(N-1,T,1)
                                else Z:(period(N,T,Z+1)).

OPNS histo :: integer -> ints -> array.
EQNS histo N S = histloop S (array(create_array(N,0))).

OPNS histloop :: ints -> array -> array.
EQNS histloop [] H = H.
     histloop (X:XS) H =
        let X = X-1.
            (_,V) = value(X,0,H).
            (_,H) = assign(X,V+1,H).
        in histloop XS H.
     
     
OPNS hist_bench :: integer.
EQNS hist_bench = integer(value(0,0,histo 200 (period(200,200,1)))).

OPNS bench_histo :: integer -> integer.
EQNS bench_histo N = if N <= 0 then N else (hist_bench)+bench_histo (N-1).

{--- hexa ---}

{IMPORTS FUNCOMP +}

OPNS double,
     quad,
     oct    :: (integer->integer) -> integer -> integer.
     succ   :: integer -> integer.
     (integer->integer) * (integer->integer) :: integer->integer.

EQNS double F = F          * F.
     quad   F = (double F) * (double F).
     oct    F = (quad F)   * (quad F).
     succ N = N+1.
     (F * G) X = F(G X).

OPNS hexa :: (integer,integer) -> integer.
EQNS hexa (X,N) = if N == 0 then X
                            else hexa(((oct succ) * (oct succ)) X,N-1).
       

OPNS bench_hexa :: integer -> integer.
EQNS bench_hexa N = if N <= 0 then N else hexa(0,10000)+bench_hexa (N-1).

{--- fib ---}

OPNS fib :: integer -> integer.
EQNS fib N = if N < 2 then 1 else fib (N-1) + fib (N-2).

OPNS bench_fib :: integer -> integer.
EQNS bench_fib N = if N <= 0 then N else (fib 20)+bench_fib (N-1).

{--- tak ---}

OPNS tak :: (integer,integer,integer) -> integer.
EQNS tak (X,Y,Z) = if not (Y<X)
                   then Z
                   else tak (tak(X-1,Y,Z),tak(Y-1,Z,X),tak(Z-1,X,Y)).

OPNS bench_tak :: integer -> integer.
EQNS bench_tak N = if N <= 0 then N else (tak (28,14,7))+bench_tak (N-1).

 
END.
