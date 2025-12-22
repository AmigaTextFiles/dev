;/* Execute me to compile.
sc NOSTKCHK NOSTDIO Test8.c
slink Test8.o to Test8
quit
*/

void __saveds main()
{
  long z = 0, a = 0, b = 0;

  for (a = 1;a < 20;a++)
  {
    for (b = 1;b < 500000;b++)
    {
      z = *((char *)(a + b + 120));
    }
  }
}
