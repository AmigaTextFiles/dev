;/* Execute me to compile.
sc NOSTKCHK NOSTDIO Test6.c
slink Test6.o to Test6
quit
*/

void __saveds main()
{
  long z = 0, a = 0;

  for (z = 0;z < 16000000;z++)
  {
    a += 7;
  }
}
