#ifndef FEELIN_SUPPORT_PARSE_VALUES_H
#define FEELIN_SUPPORT_PARSE_VALUES_H

typedef bool32 (*f_parse_values_func)  (STRPTR Value, uint32 ValueLength, APTR UserData);

uint32 f_parse_values(STRPTR Source, f_parse_values_func Func, APTR UserData);

#endif
