/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _memory.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#include <LEDA/basic.h>

//------------------------------------------------------------------------------
// Memory Management
//------------------------------------------------------------------------------

//const int memory_block_bytes = 4092; // size of block 2^k - 4  bytes
const int memory_block_bytes = 8188; // size of block 2^13 - 4  bytes
const int memory_max_size    = 255;  // maximal size of structures in bytes

memory_elem_ptr        memory_free_list[256];     //memory_max_size + 1

static long int        memory_total_count[256]; 
static memory_elem_ptr memory_block_list[256];
static int             memory_block_count[256];
static int             memory_initialized = 0;


static void memory_init()
{ for(int i = 0; i <= memory_max_size; i++)
  { memory_free_list[i]   = 0;
    memory_total_count[i] = 0;
    memory_block_list[i]  = 0;
    memory_block_count[i] = 0;
   }
  memory_initialized = 1;
 }


memory_elem_ptr memory_allocate_block(int b)
{ 
  if (memory_initialized == 0) memory_init();

  if (b > memory_max_size) 
     error_handler(1,string("allocate_block: size (%d bytes) too big",b));

  //allocate new block and slice it into chunks of size b bytes

  register memory_elem_ptr p;
  register memory_elem_ptr stop;

  register int words = (b + sizeof(void*) - 1)/sizeof(void*);

  int bytes = words * sizeof(void*);
  int num   = memory_block_bytes/bytes - 2;

  memory_block_count[b]++;
  memory_total_count[b] += num;

  if ((p=memory_elem_ptr(malloc(memory_block_bytes))) == 0 )
   { cout << "memory allocation: out of memory\n";
     print_statistics();
     exit(1);
    }

  //insert block into list of used blocks
  p->next = memory_block_list[b];
  memory_block_list[b] = p;
  p += words;

  memory_free_list[b] = p;

  stop = p + (num-1)*words;
  stop->next = 0;

  while (p < stop) p = (p->next = p+words);

  return memory_free_list[b];
}


void memory_clear()
{ 
  register memory_elem_ptr p;
  int i;
  long used;

  for (i=1;i<=memory_max_size;i++)
  { p = memory_free_list[i];
    used = memory_total_count[i];
    while (p) { used--; p = p->next; }

    if (used==0)
    { while (memory_block_list[i])
      { p = memory_block_list[i];
        memory_block_list[i] = p->next;
        memory_block_count[i]--;
        free((char*)p);
       }
      memory_free_list[i] = 0;
      memory_total_count[i] = 0;
     }
   }

}


void memory_kill()
{ register memory_elem_ptr p;
  int i;

  for (i=1;i<=memory_max_size;i++)
  { while (memory_block_list[i])
    { p = memory_block_list[i];
      memory_block_list[i] = p->next;
      free((char*)p);
     }
    memory_free_list[i] = 0;
    memory_total_count[i] = 0;
    memory_block_count[i] = 0;
   }


}

memory_elem_ptr allocate_bytes(int bytes)
{ memory_elem_ptr p = memory_free_list[bytes];
  if (p==0) p = memory_allocate_block(bytes);
  memory_free_list[bytes] = p->next;
  return p;
}

void deallocate_bytes(void* p, int bytes)
{ memory_elem_ptr(p)->next = memory_free_list[bytes];
  memory_free_list[bytes] = memory_elem_ptr(p);
 }


memory_elem_ptr allocate_bytes_with_check(int bytes)
{ memory_elem_ptr p = memory_free_list[bytes];
  if (p==0) p = memory_allocate_block(bytes);
  memory_free_list[bytes] = p->next;
  printf("allocate(%d):   %x\n",bytes,p);
  fflush(stdout);
  return p;
}

void deallocate_bytes_with_check(void* p, int bytes)
{ printf("deallocate(%d): %x\n",bytes,p);
  fflush(stdout);
  memory_elem_ptr q = memory_free_list[bytes];
  while(q && q != memory_elem_ptr(p)) q = q->next;
  if (q) error_handler(999,string("LEDA memory: pointer %d deleted twice",p));
  memory_elem_ptr(p)->next = memory_free_list[bytes];
  memory_free_list[bytes] = memory_elem_ptr(p);
 }


memory_elem_ptr allocate_words(int words)
{ int bytes = words * sizeof(void*);
  memory_elem_ptr p = memory_free_list[bytes];
  if (p==0) p = memory_allocate_block(bytes);
  memory_free_list[bytes] = p->next;
  return p;
}

void deallocate_words(void* p, int words)
{ int bytes = words * sizeof(void*);
  memory_elem_ptr(p)->next = memory_free_list[bytes];
  memory_free_list[bytes] = memory_elem_ptr(p);
 }


int used_memory()
{ long int total_bytes=0;

  for (int i=1;i<=memory_max_size;i++)
     total_bytes += i*memory_total_count[i];

  return total_bytes;
 }



void print_statistics()
{
  cout.flush();

  long int total,free,used;
  long int total_bytes=0, free_bytes=0, used_bytes=0, b;


  printf("\n");
  printf("\t+--------------------------------------------------+\n");
  printf("\t|   size     used     free     blocks     bytes    |\n"); 
  printf("\t+--------------------------------------------------+\n");

  for (int i=1;i<=memory_max_size;i++)
    if ((total = memory_total_count[i]) > 0 || memory_free_list[i])
    { printf("\t|   %3d    ",i);
      fflush(stdout);
      memory_elem_ptr p = memory_free_list[i];
      free = 0;
      while (p) { free++; p = p->next; }
      b = total*i; 
      used = total - free;
      free_bytes  += free*i;
      used_bytes  += used*i;
      total_bytes += b;
      printf("%6ld   %6ld    %6d   %8ld    |\n",
              used,free,memory_block_count[i],b);
     }

 float kb = float(total_bytes)/1024;
 float sec = used_time();

 printf("\t+--------------------------------------------------+\n");
 printf("\t|   time:%6.2f sec              space:%8.2f kb |\n",sec,kb);
 printf("\t+--------------------------------------------------+\n");
 printf("\n");
 fflush(stdout);

}
