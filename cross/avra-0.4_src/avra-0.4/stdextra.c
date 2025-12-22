/********************************************************************
 * Extra standard functions
 */

#include <stdio.h>
#include <ctype.h>

#include "misc.h"


/********************************************************************
 * Case insensetive strcmp()
 */

int nocase_strcmp(char *s, char *t)
	{
	int i;

	for(i = 0; tolower(s[i]) == tolower(t[i]); i++)
		if(s[i] == '\0')
			return(0);
	return(tolower(s[i]) - tolower(t[i]));
	}


/********************************************************************
 * Case insensetive strncmp()
 */

int nocase_strncmp(char *s, char *t, int n)
	{
	int i;

	for(i = 0; (tolower(s[i]) == tolower(t[i])); i++, n--)
		if((s[i] == '\0') || (n == 1))
			return(0);
	return(tolower(s[i]) - tolower(t[i]));
	}


/********************************************************************
 * Case insensetive strstr()
 */

char *nocase_strstr(char *s, char *t)
	{
	int i = 0, j, found = False;

	while((s[i] != '\0') && !found)
		{
		j = 0;
		while(tolower(t[j]) == tolower(s[i + j]))
			{
			j++;
			if(t[j] == '\0')
				{
				found = True;
				break;
				}
			else if(s[i + j] == '\0')
				break;
			}
		i++;
		}
	i--;
	if(found)
		return(&s[i]);
	return(NULL);
	}


/********************************************************************
 * ascii to hex
 * ignores "0x"
 */

int atox(char *s)
	{
	int i = 0, ret = 0;

	while(s[i] != '\0')
		{
		ret <<= 4;
		if((s[i] <= 'F') && (s[i] >= 'A'))
			ret |= s[i] - 'A' + 10;
		else if((s[i] <= 'f') && (s[i] >= 'a'))
			ret |= s[i] - 'a' + 10;
		else if((s[i] <= '9') && (s[i] >= '0'))
			ret |= s[i] - '0';
		i++;
		}
	return(ret);
	}


/********************************************************************
 * n ascii chars to int
 */

int atoi_n(char *s, int n)
	{
	int i = 0, ret = 0;

	while((s[i] != '\0') && n)
		{
		ret = 10 * ret + (s[i] - '0');
		i++;
		n--;
		}
	return(ret);
	}


/********************************************************************
 * n ascii chars to hex
 * 0 < n <= 8
 * ignores "0x"
 */

int atox_n(char *s, int n)
	{
	int i = 0, ret = 0;

	while((s[i] != '\0') && n)
		{
		ret <<= 4;
		if((s[i] <= 'F') && (s[i] >= 'A'))
			ret |= s[i] - 'A' + 10;
		else if((s[i] <= 'f') && (s[i] >= 'a'))
			ret |= s[i] - 'a' + 10;
		else if((s[i] <= '9') && (s[i] >= '0'))
			ret |= s[i] - '0';
		i++;
		n--;
		}
	return(ret);
	}







