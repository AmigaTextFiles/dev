#include <stdio.h>
#include "eiffel.h"

c_prog (void *animals) {
  int i;
  void* eiffel_string;
  char* c_string;
  
  for (i=array_of_animal_lower(animals);
       i <= array_of_animal_upper(animals);
       i++) {
    eiffel_string = cry(array_of_animal_item(animals,i));
    c_string = string_to_external(eiffel_string);
    printf("%s\n",c_string);
  }
}


