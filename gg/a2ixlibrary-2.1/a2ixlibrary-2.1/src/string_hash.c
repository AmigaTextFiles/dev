#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct _node
{
  unsigned long hash;
  char *name;
  struct _node *left, *right;
} node;

static node *tree;

static unsigned long hash(char *s)
{
  unsigned long h = 0, g;

  while (*s)
  {
    h = (h << 4) + *s++;
    if (g = h & 0xf0000000)
      h ^= g >> 24;
      h &= ~g;
  }
  return h;
}

static node **find_node(node **n, unsigned long hash)
{
  node *tmp = *n;

  if (tmp == NULL)
    return n;
  if (tmp->hash == hash)
    return n;
  if (tmp->hash < hash)
    return find_node(&tmp->left, hash);
  return find_node(&tmp->right, hash);
}

static void add_hash(char *name)
{
  node *n = calloc(1, sizeof(node));
  node **tmp;
  
  if (n == NULL)
  {
    fprintf(stderr, "Out of memory!\n");
    exit(1);
  }
  n->hash = hash(name);
  n->name = strdup(name);
  if (n->name == NULL)
  {
    fprintf(stderr, "Out of memory!\n");
    exit(1);
  }
  tmp = find_node(&tree, n->hash);
  if (*tmp)
  {
    fprintf(stderr, "Warning: hash value %08x (%s) already in use by %s!\n",
            hash, name, (*tmp)->name);
  }
  else
  {
    *tmp = n;
  }
}

main(int argc, char **argv)
{
/* Amiga - g++ produces longer function names! */
/*  char buf[100];*/
  char buf[1024];

  while (gets(buf))
  {
    int l = strlen(buf);
    
    if (argc == 2)
    {
      add_hash(buf + 2);
      printf(".global _%s_%s_shared_ptr\n_%s_%s_shared_ptr:\n.long 0x%lx",
	     buf, argv[1], buf, argv[1], hash(buf + 2));
    }
    else
    {
      add_hash(buf);
      printf(".long 0x%lx", hash(buf), buf);
    }
    putchar('\n');
  }
}
