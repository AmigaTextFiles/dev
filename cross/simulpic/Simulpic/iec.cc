/*
 * Copyright (c) 1996 Tommaso Cucinotta, Alessandro Evangelista, Luigi Rizzo
 * All rights reserved.
 *
 *    Dip. di Ingegneria dell'Informazione, Universita of Pisa,
 *    via Diotisalvi 2 -- 56126 Pisa.
 *    email: simulpic@iet.unipi.it
 * 	
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *      This product includes software developed by
 *	Tommaso Cucinotta, Alessandro Evangelista and Luigi Rizzo
 * 4. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
 * ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

/*
 *
 *  Project: SimulPIC
 *  Program: IEC  (Input Event Compiler)
 *
 *  Notes:   Compiles input event files before using SimulPIC.EXE
 *
 */


#include <stdio.h>
#include <string.h>
#include <stdlib.h>

typedef enum {
  IN_0, IN_1, OUT
  } state;

#define OK 0x00
#define SYNTAX 0x01
#define MCLR_VALUE 0x02
#define RB_VALUE 0x03
#define RA_VALUE 0x04
#define UNEXPECTED_EOF 0x05
#define CANNOT_OPEN 0x06
#define MCLR_RAB 0x07
#define BAD_ARG 0x08
#define BEGIN_EXPECTED 0x09
#define TIME 0x0A
#define EQUAL 0x0B
#define BAD_TIME 0x0C

void get_next();
int get_token();
int get_time();
int get_line();
void quit(int);
void set_pin(state *port, int pin);
void write_line();
void main(int argc, char *argv[]);

FILE *input, *output;
char line[256];
char tokbuf[80];
char* token;
char* lptr;
long double Time;

struct {
  state RA[5];
  state RB[8];
  char MCLR;
  } pin;


void get_next()
{
  if (*token == NULL)
    if(!get_token())
      quit(SYNTAX);
}

int get_token()
{
  if(sscanf(lptr, "%s", tokbuf)== 1) {
    while(*lptr ==' ') lptr++;
    while((*lptr !=' ') && (*lptr != NULL)) lptr++;
    token = tokbuf;
    return 1;
    }
  else
    return 0;
}

int get_time()
{
  static double last_time = -1E-10;

  if (sscanf(token, "%lf", &Time) == 1)
    if((Time > last_time)) {
      last_time = Time;
      return 1;
      }
    else
      quit(BAD_TIME);

  if(strcmp(token,"end")==0)
      quit(OK);

  return 0;
}

int get_line()
{
  if (fgets(line, sizeof(line)-1, input) != NULL) {
    lptr = line;
    printf(line);
    return 1;
    }
  else
    return 0;
}

void set_pin(state* port, int pin)
{
  switch(*token) {
    case '0':
      port[pin] = IN_0;
      break;
    case '1' :
      port[pin] = IN_1;
      break;
    case '-' :
      port[pin] = OUT;
      break;
    default:
      quit(RB_VALUE);
    }
}

char state_to_char(state s)
{
  switch(s) {
    case IN_0:
      return '0';
    case IN_1:
      return '1';
    case OUT:
      return '-';
  }
  return '?';
}

void write_line()
{
  for(int i=4; i>=0; i--)
    fprintf(output,"%c", state_to_char(pin.RA[i]));
  fprintf(output," ");
  for(i=7; i>=0; i--)
    fprintf(output,"%c", state_to_char(pin.RB[i]));
  fprintf(output, " %d", pin.MCLR);
  fprintf(output, " %6.2lf\n", Time);


}

void quit(int s)
{
  switch(s) {
    case OK:
      fclose(input);
      fclose(output);
      exit(0);
    case SYNTAX:
      puts("Error: syntax error");
      break;
    case MCLR_VALUE:
      puts("Error: MCLR value expected");
      break;
    case RB_VALUE:
      puts("Error: RB value expected");
      break;
    case RA_VALUE:
      puts("Error: RA value expected");
      break;
    case UNEXPECTED_EOF:
      puts("Error: unexpected end of file");
      break;
    case CANNOT_OPEN:
      puts("Error: can't open file");
      break;
    case MCLR_RAB:
      puts("Error: 'MCLR','RAx','RBx' expected");
      break;
    case BAD_ARG:
      puts("Usage: ic <source file> <desination file>");
      break;
    case BEGIN_EXPECTED:
      puts("Error: 'begin' expected");
      break;
    case TIME:
      puts("Error: <time field> expected");
      break;
    case EQUAL:
      puts("Error: '=' expected");
      break;
    case BAD_TIME:
      puts("Error: bad <time field>");
      break;
    }


  fclose(input);
  fclose(output);
  exit(-1);
}

void main(int argc, char *argv[])
{
  int begin_found = 0;
  int i, num;


  for(i=4; i>=0; i--)
    pin.RA[i] = OUT;
  for(i=7; i>=0; i--)
    pin.RB[i] = OUT;
  pin.MCLR = 1;

  puts("Input Events Compiler for PIC16C84\n");


  if(argc != 3)
    quit(BAD_ARG);

  if((input = fopen(argv[1], "rt")) == NULL)
    quit(CANNOT_OPEN);

  if((output = fopen(argv[2], "w+t")) == NULL)
    quit(CANNOT_OPEN);


  while(1) {

    if(!get_line())
      quit(UNEXPECTED_EOF);

    if (!get_token())
      continue;

    if(*token == '#')
      continue;

    if (!begin_found) {
      if(strcmp(token,"begin") != 0)
         quit(BEGIN_EXPECTED);
      begin_found = 1;
      if (!get_token())
         continue;
      }

    if (!get_time())
       quit(Time);

    while(get_token()) {

      switch(*token) {

        case 'M':
          if (strncmp(token,"MCLR",4) !=0)
            quit(MCLR_RAB);
          token +=4;
          get_next();
          if (*token != '=')
            quit(EQUAL);
          token++;
          get_next();
          switch(*token) {
            case '0' :
              pin.MCLR = 0;
              break;
            case '1' :
              pin.MCLR = 1;
              break;
            default:
              quit(MCLR_VALUE);
            }
          break;

        case 'R':
          token++;
          switch(*token) {
            case 'A':
              token++;
              if ((*token >= '0') && (*token <= '4')) {
                num = *token - '0';
                token++;
                get_next();
                if (*token != '=')
                  quit(EQUAL);
                token++;
                get_next();
                set_pin(pin.RA, num);
                }
              else {
                if (*token == NULL)
                  get_token();
                if (*token != '=')
                  quit(EQUAL);
                token++;
                get_next();
                if (strlen(token) == 5)
                  for(num=4;num>=0;num--) {
                    if (*token != 'u')
                      set_pin(pin.RA, num);
                    token++;
                    }
                else
                  quit(RA_VALUE);
                }
              break;
            case 'B':
              token++;
              if ((*token >= '0') && (*token <= '7')) {
                num = *token - '0';
                token++;
                get_next();
                if (*token != '=')
                  quit(EQUAL);
                token++;
                get_next();
                set_pin(pin.RB, num);
                }
              else {
                if (*token == NULL)
                  get_token();
                if (*token != '=')
                  quit(EQUAL);
                token++;
                get_next();
                if (strlen(token) == 8)
                  for(num=7;num>=0;num--) {
                    if (*token != 'u')
                      set_pin(pin.RB, num);
                    token++;
                    }
                else
                  quit(RB_VALUE);
                }
              break;

            default:
              quit(SYNTAX);
            }
            break;

        default:
          quit(SYNTAX);
        }
      } /* fine while(get_token()) */


   write_line();

   }
}

