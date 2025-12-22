/*
This file is licensed to you under the license specified in the included file
`LICENSE'. Look there for further details.
*/


#ifndef _GENGETOPT_GGOS_H
#define _GENGETOPT_GGOS_H

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

struct gengetopt_option
{
  char short_opt;
  char * long_opt;
  char * desc;
  int type; /* values in `argsdef.h' */
  int flagstat ;
  int required;
  struct gengetopt_option * next;
  char * var_arg; /* canonized long_opt + "_arg" = argument var */
  int default_given ; /* if a default is given */
  char * default_string ; /* default value for this option, if string */
  double default_num ; /* default value for this option, if numeric */
};

#endif /* _GENGETOPT_GGOS_H */
