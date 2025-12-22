#ifndef _SGESTRING_H
#define _SGESTRING_H

#ifdef __cplusplus
extern "C" {
#endif

/** @file sgestring.h
 * @brief Functions to help handling string data
 */

/*
 * Copyright (c) 2007 Heiko Irrgang
 *
 * The license and distribution terms for this file may be
 * found in the file COPYING in this distribution or at
 * http://agnosent.com/wolfcms/open-source/sge2d/license.html
 */

/**
 * @defgroup sgeString
 * @brief String handling functions
 *
 * @{
 */

/**
 * @brief test if a character is a whitespace character (space, newline, tab, ...)
 * @param c the character to test
 * @return YES/NO depending if the character is a whitespace character
 */
int sgeCharIsWhitespace(char c);

/**
 * @brief trim all whitespace characters from beginning of end of a string
 * @param str the string to remove whitspaces from
 * @return a poiner to a new character string
 *
 * This function does create a new char * pointer, the original
 * char * is unaltered
 */
char *sgeTrim(char *str);

/**
 * @brief convert a string to lower case
 * @param str the string to make a lower case copy from
 * @return a new copy of str all lower case
 */
char *sgeLower(char *str);

/**
 * @brief convert a string to upper case
 * @param str the string to make a upper case copy from
 * @return a new copy of str all upper case
 */
char *sgeUpper(char *str);

/**
 * @brief return the name of a config string
 * @param str the config string in the form of "name = value"
 * @return a new char * pointer or NULL if no '=' in string
 */
char *sgeConfigNameFromString(char *str);

/**
 * @brief return the value of a config string
 * @param str the config string in the form of "name = value"
 * @return a new char * pointer or NULL if no '=' in string
 */
char *sgeConfigValueFromString(char *str);

// }@

#ifdef __cplusplus
}
#endif

#endif
