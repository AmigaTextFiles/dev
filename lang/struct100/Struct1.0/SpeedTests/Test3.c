;/* Execute me to compile.
sc NOSTKCHK NOSTDIO Test3.c
slink Test3.o to Test3 lib lib:sc.lib
quit
*/

void __saveds main()
{
  long z = 0, a = 0, k;

  for (z = 1;z < 6000000;z++)
  {
    k = z % 2;
    if (k == 0) a += 7;
    else a += 15;
  };
}
