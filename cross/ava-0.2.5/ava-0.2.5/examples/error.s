#arch AT90S1200
#print "Target device: AT90S1200"

#ifndef A
#  error  Macro A is not defined
#endif

#print "A: " A

#if A==2
#  error "A equals 2 -- check it out :)"
#endif
