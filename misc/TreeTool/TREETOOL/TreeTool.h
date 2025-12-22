/* -------------------------------------------------------------  */
/* TreeTool.h                                                     */
/* -------------------------------------------------------------  */
/* Headers file for TreeTool.c: Prototypes and structure def.     */
/* -------------------------------------------------------------  */

#ifndef BOOL
#define BOOL int
#endif

#ifndef TRUE
#define TRUE 1
#endif

#ifndef FALSE
#define FALSE 0
#endif

#ifndef NULL
#define NULL 0L
#endif

#ifndef	NODEHEADER
struct node {
              void         *data;
              struct node *NextNode;
              struct node *FirstLeftSon;
              struct node *PreviousNode;
            };

typedef struct node *NODE_HANDLE;

NODE_HANDLE tt_NewNode(NODE_HANDLE , void *);
void        tt_KillNode(NODE_HANDLE , void (*)() );
NODE_HANDLE tt_GetLeftBrother(NODE_HANDLE);
NODE_HANDLE tt_GetRightBrother(NODE_HANDLE);
void        tt_GetSuperMariosBrother();
NODE_HANDLE tt_GetFirstSon(NODE_HANDLE);
NODE_HANDLE tt_GetLastSon(NODE_HANDLE);
NODE_HANDLE tt_GetFather(NODE_HANDLE);
void *      tt_SetNodeData(NODE_HANDLE,void *);
void *      tt_GetNodeData(NODE_HANDLE);
void	      tt_ApplyFunction(NODE_HANDLE, void (*)());

#define NODEHEADER
#endif
