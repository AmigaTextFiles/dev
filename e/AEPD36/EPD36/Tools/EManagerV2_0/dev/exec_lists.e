OPT MODULE
OPT EXPORT

MODULE 'exec/lists','exec/nodes'

CONST LIST_CLEAN=0,
      LIST_REMOVE=1

PROC p_AjouteNode( ptr_list:PTR TO lh, node_name )
/*===============================================================================
 = Para         : address of list,the name of a node,adr to copy node if adr<>0.
 = Return       : the number of the new selected node in the list.
 = Description  : Add a node and return the new current node (for LISTVIEW_KIND).
 ===============================================================================*/
    DEF a_node:PTR TO ln,
        nn=NIL

    a_node := New( SIZEOF ln )
    a_node.succ := 0
    a_node.name := String( StrLen( node_name ) )
    StrCopy( a_node.name, node_name, ALL )
    AddTail( ptr_list, a_node )
    nn := p_GetNumNode( ptr_list, a_node )
    IF nn = -1
      ptr_list.head := a_node
      a_node.pred := 0
      nn := 0
    ENDIF
ENDPROC nn

PROC p_CleanList(ptr_list:PTR TO lh, mode)
/*===============================================================================
 = Para         : Address of a List,if doit<>0 free data,the data,just clean or clean and remove.
 = Return       : Address of clean list.
 = Description  : Remove all nodes in the list.
 ==============================================================================*/
    DEF c_node:PTR TO ln
    DEF p=0,pivadr
    DEF rdat:PTR TO LONG

    c_node := ptr_list.head
    WHILE c_node
      p:=0
      IF c_node.succ<>0
        IF c_node.name THEN DisposeLink(c_node.name)
        IF c_node.succ=0 THEN RemTail(ptr_list)
        IF c_node.pred=0 THEN RemHead(ptr_list)
        IF (c_node.succ<>0) AND (c_node.pred<>0) THEN Remove(c_node)
      ENDIF
      c_node:=c_node.succ
    ENDWHILE
    IF mode=LIST_CLEAN
      ptr_list.tail:=0
      ptr_list.head:=ptr_list.tail
      ptr_list.tailpred:=ptr_list.head
      ptr_list.type:=0
      ptr_list.pad:=0
      RETURN ptr_list
    ELSEIF mode=LIST_REMOVE
      IF ptr_list THEN Dispose(ptr_list)
      RETURN NIL
    ENDIF
ENDPROC

PROC p_CountNodes(list:PTR TO lh)
/*===============================================================================
 = Para         : address of a list
 = Return       : number of nodes in the list.
 = Description  : count nodes in the list.
 ==============================================================================*/
    DEF count=0
    DEF e_node:PTR TO ln
    e_node:=list.head
    WHILE e_node
        IF e_node.succ<>0 THEN INC count
        e_node:=e_node.succ
    ENDWHILE
ENDPROC count

PROC p_EnleveNode( ptr_list:PTR TO lh, num_node ) /*"p_EnleveNode(ptr_list:PTR TO lh,num_node,doit,dat:PTR TO LONG)"*/
/*===============================================================================
 = Para         : Address of a list,number of a node,if doit<>0 free data,tha data.
 = Return       : The number of the new selected node in the list.
 = Description  : Remove a node.
 ==============================================================================*/
    DEF e_node:PTR TO ln
    DEF new_e_node:PTR TO ln
    DEF count=0,retour=NIL
    DEF p=0,pivadr
    DEF rdat:PTR TO LONG

    e_node:=ptr_list.head
    WHILE e_node
        p:=0
        IF count=num_node
            IF e_node.succ=0
                RemTail(ptr_list)
                retour:=num_node-1
            ELSEIF e_node.pred=0
                RemHead(ptr_list)
                retour:=num_node
                new_e_node:=p_GetAdrNode(ptr_list,num_node)
                ptr_list.head:=new_e_node
                new_e_node.pred:=0
            ELSEIF (e_node.succ<>0) AND (e_node.pred<>0)
                Remove(e_node)
                retour:=num_node-1
            ENDIF
            IF e_node.name THEN DisposeLink(e_node.name)
        ENDIF
        INC count
        e_node:=e_node.succ
    ENDWHILE
ENDPROC retour

PROC p_GetAdrNode(ptr_list:PTR TO lh,num_node) /*"p_GetAdrNode(ptr_list:PTR TO lh,num_node)"*/
/*===============================================================================
 = Para         : Address of a list,number of a node.
 = Return       : Address of node or -1.
 = Description  : Find the address of a node.
 ==============================================================================*/
    DEF g_node:PTR TO ln
    DEF count=0

    g_node:=ptr_list.head
    WHILE g_node
        IF count=num_node THEN RETURN g_node
        INC count
        g_node:=g_node.succ
    ENDWHILE
ENDPROC -1

PROC p_GetNumNode(ptr_list:PTR TO lh,adr_node) /*"p_GetNumNode(ptr_list:PTR TO lh,adr_node)"*/
/*===============================================================================
 = Para         : Address of a list,address of a node.
 = Return       : The number of the node,else -1.
 = Description  : Find the num of a node.
 ==============================================================================*/
    DEF g_node:PTR TO ln
    DEF count=0
    g_node:=ptr_list.head
    WHILE g_node
        IF g_node=adr_node THEN RETURN count
        INC count
        g_node:=g_node.succ
    ENDWHILE
ENDPROC -1

PROC p_InitList()
/*===============================================================================
 = Para         : NONE.
 = Return       : Address of the new list if ok,else NIL.
 = Description  : Initialise a list.
 ==============================================================================*/
    DEF i_list:PTR TO lh
    i_list:=New(SIZEOF lh)
    i_list.tail:=0
    i_list.head:=i_list.tail
    i_list.tailpred:=i_list.head
    i_list.type:=0
    i_list.pad:=0
ENDPROC i_list

PROC p_InsertNode( ptr_list:PTR TO lh, num, name:PTR TO CHAR )
  DEF node:PTR TO ln,
      listnode:PTR TO ln

  IF node := New( SIZEOF ln )
    node.name := String( 256 )
    StrCopy( node.name, name, ALL )
    IF ( listnode := p_GetAdrNode( ptr_list, num ) ) <> -1
      Insert( ptr_list, node, listnode )
    ENDIF
  ENDIF
ENDPROC ptr_list

PROC p_SwapNodes( list:PTR TO lh, numA, numB )
/*********************************************
 Parameter    : Adresse der Node-Liste,
                Nummer 1. Node,
                Nummer 2. Node
 Funktion     : Tauscht die Einträge er angegebenen Nodes
 Rückgabe     : Adresse der Liste
*********************************************/

  DEF nodeA:PTR TO ln,
      nodeB:PTR TO ln,
      dummy

  IF dummy := p_CountNodes( list ) - 1 
    IF ( numA < dummy ) AND
       ( numB < dummy ) AND
       ( numA >= 0 ) AND
       ( numB >= 0 )
      nodeA := p_GetAdrNode( list, numA )
      nodeB := p_GetAdrNode( list, numB )
      dummy := nodeA.name
      nodeA.name := nodeB.name
      nodeB.name := dummy
    ENDIF
  ENDIF
ENDPROC list

PROC p_SortList( list:PTR TO lh )
/********************************************************
 Parameter    : Adresse der Node-Liste
 Funktion     : sortiert die Liste nach dem Alphabet
 Rückgabe     : Adresse der Node-Liste
********************************************************/

  DEF num,
      cnt:REG,
      nodeA:PTR TO ln,
      nodeB:PTR TO ln,
      dummy,
      buf1[256]:STRING,
      buf2[256]:STRING,
      fl


  IF num := p_CountNodes( list )
    DEC num
    IF num
      REPEAT
        fl := TRUE
        FOR cnt := 0 TO (num-1)
          nodeA := p_GetAdrNode( list, cnt )
          nodeB := p_GetAdrNode( list, (cnt+1) )
          StrCopy( buf1, nodeA.name, ALL )
          UpperStr( buf1 )
          StrCopy( buf2, nodeB.name, ALL )
          UpperStr( buf2 )
          IF OstrCmp( buf1, buf2, ALL ) = -1
            dummy := nodeA.name
            nodeA.name := nodeB.name
            nodeB.name := dummy
            fl := FALSE
          ENDIF
        ENDFOR
      UNTIL fl
    ENDIF
  ENDIF
ENDPROC list

