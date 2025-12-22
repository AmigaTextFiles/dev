
/* Bitmanipulationen in AmigaE */

PROC main()
 WriteF('\d\n',bset(0,0))
 WriteF('\d\n',bclr(7,0))
 WriteF('\d\n',bclr(6,1))
 WriteF('\d\n',exp(2,5))
ENDPROC

PROC btst(var,bit) RETURN IF (var AND exp(2,bit))=0 THEN 0 ELSE 1
PROC bset(var,bit) RETURN (exp(2,bit) OR var)
PROC bclr(var,bit) RETURN ((%11111111111111111111111111111111-exp(2,bit)) AND var)
PROC exp(x,y) RETURN IF y=0 THEN 1 ELSE Mul(x,exp(x,(y-1)))

/*        mfG,
            TOB


He who reads many fortunes gets confused.

*/

