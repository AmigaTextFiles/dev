;/* Execute me to compile.
sc NOSTKCHK NOSTDIO Test5.c
slink Test5.o to Test5
quit
*/

void __saveds main()
{
  long z = 0, a = 0;

  while (z < 16000000)
  {
    a += 7;
    z += 1;
  }
}
