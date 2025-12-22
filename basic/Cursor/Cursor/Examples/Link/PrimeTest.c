
void ISPRIME(long number,short *isprime) {
  long i;
  if (number < 2) {
    *isprime = 0;
    return;
    }
  for (i=2;i*i<=number;i++)
    {
    if ((number % i) == 0) {
      *isprime = 0;
      return;
      }
    }
  *isprime = -1;
  return;
  }

