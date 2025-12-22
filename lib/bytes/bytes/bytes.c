
//
// bytes.c
//
// Copyright (c) 2012 TJ Holowaychuk <tj@vision-media.ca>
//

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "bytes.h"

#ifdef USE_VSTRING
#include "vstring.h"
#endif

// bytes

#define KB 1024
#define MB 1024 * KB
#define GB 1024 * MB

/*
 * Convert the given `str` to byte count.
 */

long long
string_to_bytes(const char *str) {
  long long val = strtoll(str, NULL, 10);
  if (!val) return -1;
  if (strstr(str, "kb")) return val * KB;
  if (strstr(str, "mb")) return val * MB;
  if (strstr(str, "gb")) return val * GB;
  return val;
}

/*
 * Convert the given `bytes` to a string. This
 * value must be `free()`d by the user.
 */
#ifdef USE_VSTRING
char *
bytes_to_string(long long bytes) {
  long div = 1;
  long len = 2;
  char *str;
  const char *unit;
  vstring *vs = NULL;

  str = malloc(24);
	vs = vs_init(vs, NULL, VS_TYPE_STATIC, str, 24);

  if (bytes < KB) { unit = "b"; len = 1; }
  else if (bytes < MB) { unit = "kb"; div = KB; }
  else if (bytes < GB) { unit = "mb"; div = MB; }
  else { unit = "gb"; div = GB; }

  if (
    !vs_pushint(vs, bytes / div) ||
    !vs_pushstr(vs, unit, len) ||
    !vs_finalize(vs))
  {
    free(str);
    str = NULL;
  }

  vs_deinit(vs);
  return str;
  return str;
}
#else
char *
bytes_to_string(long long bytes) {
  long div = 1;
  char *str, *fmt;
  if (bytes < KB) { fmt = "%lldb"; }
  else if (bytes < MB) { fmt = "%lldkb"; div = KB; }
  else if (bytes < GB) { fmt = "%lldmb"; div = MB; }
  else { fmt = "%lldgb"; div = GB; }
  asprintf(&str, fmt, bytes / div);
  return str;
}
#endif
