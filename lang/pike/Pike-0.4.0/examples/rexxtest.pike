#!/usr/local/bin/pike

int
main ()
{
  int t;

  if (1)
  {
    arexx_host ("rexx_ced");
    for (t=0; t<10; t++)
    {
      arexx_cmd ("down");
      arexx_cmd ("down");
      arexx_cmd ("down");
      arexx_cmd ("up");
      arexx_cmd ("up");
      arexx_cmd ("up");
    }
  }
  if (1)
  {
    arexx_host ("MULTIVIEW.1");
    arexx_cmd ("open name s:startup-sequence");
  }
}
