//
//
//

#include <stdio.h>
#include <string.h>
#include <assert.h>
#include "pm.h"

//
//
//

uint8_t get8u( uint8_t *b ) {
  return *b;
}

uint16_t get16u( uint8_t *b ) {
  return ((b[1] << 8) | *b);
}

uint32_t get24u( uint8_t *b ) {
  return ((b[2] << 16) | (b[1] << 8) | *b);
}

uint32_t get32u( uint8_t *b ) {
  return ((b[3] << 24) | (b[2] << 16) | (b[1] << 8) | *b);
}

//
//
//

int8_t get8( uint8_t *b ) {
  return *b;
}

int16_t get16( uint8_t *b ) {
  return ((b[1] << 8) | *b);
}

int32_t get32( uint8_t *b ) {
  return ((b[3] << 24) | (b[2] << 16) | (b[1] << 8) | *b);
}

//
//
//

int getR( unsigned char *m ) {
  return *m & 0x07;
}

int getra( unsigned char *m ) {
	return *m & 0x07;
}

int getrb( unsigned char *m ) {
	return (*m & 0x38) >> 3;
}


//
//
//


int retr8( unsigned char *b, char *s, int mem ) {
	switch (mem & 0x07) {
	case 0x00: case 0x01: case 0x02: case 0x03:
		sprintf(s,"%s",r8_24_names[mem]);
		return 0;
	case 0x04:
		sprintf(s,"(NN+%02XH)",b[1]);
		return 1;
	case 0x05:
		sprintf(s,"(%04XH)",get16u(b+1));
		return 2;
	case 0x06: case 0x07:
		sprintf(s,"(%s)",r8_24_names[mem]);
		return 0;
	}
	return 0;
}

int retr8_imm( unsigned char *b, char *s, int mem ) {
	switch (mem & 0x07) {
	case 0x00: case 0x01: case 0x02: case 0x03:
		sprintf(s,"%s,%02XH",r8_24_names[mem],b[1]);
		return 1;
	case 0x04:
		sprintf(s,"(%s+%02XH),%02XH",r8_24_names[mem],b[1],b[2]);
		return 1+1;
	case 0x05: case 0x06: case 0x07:
		sprintf(s,"(%s),%02XH",r8_24_names[mem],b[1]);
		return 1;
	}
	return 0;
}

int retr16_imm( unsigned char *b, char *s, int mem ) {
	switch (mem & 0x07) {
	case 0x00: case 0x01: case 0x02: case 0x03:
		sprintf(s,"%s,%02X%02XH",r8_24_names[mem],b[2],b[1]);
		return 2;
	case 0x04:
		sprintf(s,"(%s+%02XH),%02X%02XH",r8_24_names[mem],b[1],b[3],b[2]);
		return 1+2;
	case 0x05: case 0x06: case 0x07:
		sprintf(s,"(%s),%02X%02XH",r8_24_names[mem],b[2],b[1]);
		return 2;
	}
	return 0;
}

int retr8_mem( unsigned char *b, char *s, int rb, int ra ) {
	int i,l;

	switch (rb) {
	case 0x00: case 0x01: case 0x02: case 0x03:
		sprintf(s,"%s,",r8_24_names[rb]);
		i = 0;
		break;
	case 0x04:
		sprintf(s,"(NN+%02XH),",b[1]);
		i= 1;
		break;
	case 0x05: case 0x06: case 0x07:
		sprintf(s,"(%s),",r8_24_names[rb]);
		i = 0;
		break;
	}

	l = strlen(s);

	switch (ra) {
	case 0x00: case 0x01: case 0x02: case 0x03:
		sprintf(s+l,"%s",r8_24_names[ra]);
		break;
	case 0x04:
		sprintf(s+l,"(NN+%02XH)",b[1]);
		i++;
		break;
	case 0x05: case 0x06: case 0x07:
		sprintf(s+l,"(%s)",r8_24_names[ra]);
		break;
	}

	return i;
}

int retr16_mem( unsigned char *b, char *s, int rb, int ra ) {
	int i,l;

	switch (rb) {
	case 0x00: case 0x01: case 0x02: case 0x03:
		sprintf(s,"%s,",r16_24_names[rb]);
		i = 0;
		break;
	case 0x04:
		sprintf(s,"(NN+%02XH),",b[1]);
		i= 1;
		break;
	case 0x05:
		sprintf(s,"(%04XH),",get16u(b+1));
		i= 1;
		break;
	case 0x06: case 0x07:
		sprintf(s,"(%s),",r16_24_names[rb]);
		i = 0;
		break;
	}

	l = strlen(s);

	switch (ra) {
	case 0x00: case 0x01: case 0x02: case 0x03:
		sprintf(s+l,"%s",r16_24_names[ra]);
		break;
	case 0x04:
		sprintf(s+l,"(NN+%02XH)",r16_24_names[ra],b[1]);
		i++;
		break;
	case 0x05: case 0x06: case 0x07:
		sprintf(s+l,"(%s)",r16_24_names[ra]);
		break;
	}

	return i;
}



int retr16( unsigned char *b, char *s, int mem ) {
	int i;

	switch (mem & 0x07) {
	case 0x00: case 0x01: case 0x02: case 0x03:
		sprintf(s,"%s",r16_24_names[mem]);
		return 1;
	case 0x04:
		sprintf(s,"(%s+%02XH)",r16_24_names[mem],b[1]);
		return 1+1;
	case 0x05: case 0x06: case 0x07:
		sprintf(s,"(%s)",r16_24_names[mem]);
		return 1;
	}
	return 0;
}


//
//
//

