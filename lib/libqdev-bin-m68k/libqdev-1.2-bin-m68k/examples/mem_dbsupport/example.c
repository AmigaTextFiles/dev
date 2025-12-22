/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mem_dbsupport.o
 *
*/

#include "../gid.h"



/*
 * Normally this func. will be silent, no debug info of any kind
 * will be generated, but as soon as the 'arg' reaches its maximum
 * relevance will be triggered.
*/
LONG function_1(LONG arg)
{
  LONG res = 0;


  QDEVDEBUG(QDEVDBFARGS "(arg = 0x%08lx)\n", arg);

  if (arg == 0x7FFFFFFF)
  {
    QDEVDEBUG_R(
             QDEVDBSPACE "Warning! First argument is too high!\n");

    res = -1;
  }

  return res;

  QDEVDEBUGIO(QDEVDBF_IRRELEVANT);
}

/*
 * This function will emit the debug info only once, regardless of
 * how many times it was called.
*/
void function_2(void)
{
  QDEVDEBUG(QDEVDBFARGS "(void)\n");

  QDEVDEBUG(
        QDEVDBSPACE "You will see this just once, but we loop!\n");

  QDEVDEBUGIO(QDEVDBF_OUTPUTONCE);
}

/*
 * This will allow to track each operation as it happens. The prog
 * will slow down.
*/
LONG function_3(LONG in)
{
  LONG div = 3;


  QDEVDEBUG(QDEVDBFARGS "(in = %ld)\n", in);

  QDEVDEBUG(QDEVDBSPACE "About to divide 'in' by %ld ...\n", div);

  in /= div; 

  QDEVDEBUG(QDEVDBSPACE "About to increase the 'div' by 1 ...\n");

  div++;

  QDEVDEBUG(QDEVDBSPACE "About to (OR) 'in' with 'div' ...\n");

  in |= div;

  QDEVDEBUG(QDEVDBSPACE "Okay, the 'in' equals now %ld .\n", in);

  return in;

  QDEVDEBUGIO(QDEVDBF_HEAVYSTEPS | QDEVDBF_LIGHTSTEPS);
}

/*
 * Do not forget to connect serial terminal or to launch 'sashimi'
 * before lauchning this example!
*/
int GID_main(void)
{
  LONG loops = 32;


  QDEVDEBUG(QDEVDBFARGS "(void)\n");

  FPrintf(Output(),
                   "This program generates debug output and sends "
                            "it over the built-in serial port!\n");

  function_1(0x3FFFFFFF);

  function_1(0x5FFFFFFF);

  function_1(0x7FFFFFFF);

  while (loops--)
  {
    function_2();
  }

  function_3(2012);

  return 0;

  QDEVDEBUGIO();
}
