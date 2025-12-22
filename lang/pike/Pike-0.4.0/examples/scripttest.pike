#!/usr/local/bin/pike

/*
   This example requires example/host from
   aminet:util/libs/script.lzh to be running.
*/

#include <stdio.h>

int
main ()
{
  string s;

  arexx_host ("script-library-test");
  arexx_export ("TESTVAR", "hi");
  arexx_cmd ("testfunction");
  s = arexx_import ("TESTVAR");
  write ("Result = " + s + ".\n");
  exit (0);
}
