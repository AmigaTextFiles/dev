;/* Execute me to compile.
sc NOSTKCHK NOSTDIO Test4.c
slink Test4.o to Test4
quit
*/

void __saveds main()
{
  long z = 0, a = 0;

  do
  {
    a += 7;
    z++;
  } while (z <= 20000000);

}
