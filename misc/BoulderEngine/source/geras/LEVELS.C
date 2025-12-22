/* ===================================
   == BOULDER CAVES DATA TRANSFER   ==
   == ©1993 by SAVELSOFT inc.       ==
   =================================== */

level(n)
SHORT n;
{
SHORT i;
setlevel(n);
for(i=0;i<390;i++)
 {
  ek[i]=database(i);
 }
TIM=ssda(1);
CRISTAL=ssda(2);
HMAGMA=ssda(3);
ITEMS=ssda(4);
BONUS=ssda(5);
}

