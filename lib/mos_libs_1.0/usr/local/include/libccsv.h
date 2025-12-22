/*
 * libccsv.h
 *
 *  Created on: 2012-10-10
 *      Author: bofu
 * Description: head file for CSV lib
 *    Capacity:
 *       1.The max length of each line is 4096(include comma)
 *       2.The max length of each data is 128
 *
 */

#ifndef LIBCCSV_H_
#define LIBCCSV_H_

#define MAX_LINE_LENGTH 4097
#define MAX_DATA_LENGTH 128
typedef unsigned long CSV_HANDLE;
#define ERROR_RETURN (CSV_HANDLE)0

//CSV file title
typedef enum CSV_TITLE_MODE{
	NO_TITLE_CTM = 0,
	TITLED_CTM = 1,
} CSV_TITLE_MODE;

//operate code for CSV file
typedef enum CSV_OPERT_MODE{
	READ_COM = 0,
	WRITE_COM = 1,
} CSV_OPERT_MODE;

//CSV mode file
typedef struct CSV_MODE{
	CSV_TITLE_MODE ctmTitleValue;
	CSV_OPERT_MODE comOpCodValue;
} CSV_MODE;

/*Initialize a CSV file
 * return 0 if there is a error.
 * return a CSV_HANDDLE value , if there is no error.
 * */
CSV_HANDLE initCSV(char *strFileName,CSV_MODE cmModeValue);

/*Close the CSV file*/
void closeCSV(CSV_HANDLE chHandleValue);

/*Get the value
 * uiRow start from 1
 * uiCol start from 1 also*/
char *getValue(CSV_HANDLE chHandleValue,unsigned int uiRow,unsigned int uiCol);
#endif /* LIBCCSV_H_ */
