#ifndef _DATABASE_PARSE_H_
#define _DATABASE_PARSE_H_ 1
/* Parse.h
 *
 * These constants are used for the pre-parsed key-expressions.
 */
#define K_PLUS			'+'	/* Token for concatenating two expressions */
#define K_STRING		0x80	/* Token for a string value */
#define K_INTEGER		0x81	/* Token for an integer value */
#define K_LOGIC		0x82	/* Token for a boolean value */
#define K_DATE			0x83	/* Token for a date value */
#define K_TIME			0x84	/* Token for a time value */
#define K_FLOAT		0x85	/* Token for a floating point value */
#define K_RESERVED	0x86	/* Reserved for future datatypes */
#define K_STOP			0x87	/* token to force end of evaluation */
#define K_VAL			0x88	/* Token for "VAR(" - string to number */
#define K_STR			0x89	/* Token for "STR(" - number to string */
#define K_UPPER		0x8A	/* Token for "UPPER(" - all chars to uppercase */
#define K_LOWER		0x8B	/* Token for "LOWER(" - all chars to lowercase */
#define K_STRZERO		0x8C	/* Token for "STRZERO(" - "STR" fill up using '0' */
#define K_LTOC			0x8D	/* Token for "LTOC(" - Logic to char */
#define K_DTOS			0x8E	/* Token for "DTOS(" - Date to string */
#define K_TTOS			0x8F	/* Token for "TTOS(" - Time to char */

#endif			/* _DATABASE_PARSE_H_ */