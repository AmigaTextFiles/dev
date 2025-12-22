;/* Execute me to compile.
sc NOSTKCHK NOSTDIO Test7.c
slink Test7.o to Test7
quit
*/

void __saveds main()
{
  long z = 0, a = 0, b = 0;

  for (z = 1;z < 8000000;z++)
  {
    if (300-97+b > 300-97+a) a += 1;
    else b += 1;
  }
}
