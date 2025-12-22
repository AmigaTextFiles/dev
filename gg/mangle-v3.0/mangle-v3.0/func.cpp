#include "main.h"

bool is_letter(char ch)
{
  if((ch>='a' && ch<='z') || (ch>='A' && ch<='Z'))
    return true;
  else
    return false;
}

bool is_number(char ch, char next='a')
{
  if((ch>='0' && ch<='9') || (ch=='-' && is_number(next)))
    return true;
  else
    return false;
}

bool move(char* from, char* to)
{
  if(rename(from,to))
    return false;
  else
    return true;
}

bool is_whitespace(char c)
{
  return ((c==' ' || c=='\t') ? true : false);
}
