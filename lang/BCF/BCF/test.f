      program matmul
c siehe RUS BI 3/88 (Rechenzentrum Uni Stuttgart)
c dort sind Rechenzeiten fr ber 20 Rechner aufgelistet
c z.B. PC/AT02+80287 fr n=100: 133 Sec. REAL, 454 Sec.(!) DOUBLE PRECISION
c mit Option deBugcode=aus ergibt sich REAL 123, DOUBLE PRECISION 199 Sec.
      parameter(n=8)
      dimension f1(n,n),  f2(n,n),  f3(n,n)
c      REAL f1,f2,f3,a,s,p23,p19,p12,p0
      DOUBLE PRECISION f1,f2,f3,a,s,p23,p19,p12,p0
      parameter(p23=2.3,p19=1.9,p12=1.2,p0=0)
c      CALL BCFOSD
       print *,'Matrixmultiplikation, n=',n
        a=p12
        do 1 i=1,n
         do 2 j=1,n
          f1(j,i)=a
          a=a+p23
 2       continue
 1      continue
        do 11 i=1,n
         do 12 j=1,n
          f2(j,i)=a
          a=a+p19
 12      continue
 11     continue
        do 3 i=1,n
        do 3 j=1,n
         s=p0
         do 4 k=1,n
 4        s=s+f1(i,k)*f2(k,j)
        f3(i,j)=s
 3      continue
        write(*,'(f30.14)')f3(n,n)
        stop
        end


