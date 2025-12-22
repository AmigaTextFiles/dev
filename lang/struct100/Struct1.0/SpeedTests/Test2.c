;/* Execute me to compile.
sc NOSTKCHK NOSTDIO Test2.c
slink Test2.o to Test2
quit
*/

void __saveds main()
{
  long z, a = 0, y;

  for(y = 2000;y != 0;y--)
  {
    for(z = 20000;z != 0;z--)
    {
      a += 7;
    }
  }
}
