/*
-- Part of SmallEiffel -- Read DISCLAIMER file -- Copyright (C) 
-- Dominique COLNET and Suzanne COLLIN -- colnet@loria.fr
--
For EXTERNAL_DEMO */

#include <stdio.h>

void integer2c(int i){
  printf("%d\n",i);
}

void character2c(char c){
  printf("'%c'\n",c);
}

void boolean2c(int b){
  printf("%d\n",b);
}

void real2c(float r){
  printf("%f\n",r);
}

void double2c(double d){
  printf("%f\n",d);
}

void string2c(char *s){
  printf("%s",s);
}

void any2c(void *a){
  if (a == NULL) {
    printf("NULL\n");
  }
  else {
    printf("not NULL\n");
  }
}

void current2c(void *a){
  any2c(a);
}

int integer2eiffel(void){
  return -6;
}

char character2eiffel(void){
  return '\n';
}


