/* default_values.c test */

/* it will use default values */

#include <stdlib.h>
#include <stdio.h>

#include "default_values_cmd.h"

void
print_args (void);

static struct gengetopt_args_info args_info;

int
main (int argc, char **argv)
{  
  if (default_values_cmd_parser (argc, argv, &args_info) != 0)
    exit(1) ;

  printf ("Value of foo: %d\n", args_info.foo_arg);
  printf ("Value of bar: %s\n", args_info.bar_arg);

  return 0;
}
