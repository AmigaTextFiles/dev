typedef struct
{
  int type;
  char *name;
  char *label;
  char *target;
  char *index;
  int number;
  void *sn1;
  void *sn2;
  void *sn3;
  void *sn4;
  int lineno;
  char *filename;
} treenode;

treenode *node(int type);
treenode *node1(int type, treenode *n1);
treenode *node2(int type, treenode *n1, treenode *n2);
treenode *node3(int type, treenode *n1, treenode *n2, treenode *n3);
treenode *node4(int type, treenode *n1, treenode *n2, treenode *n3, treenode *n4);
void walktree(treenode *this, int mode, char *breaklabel, treenode *sw);
