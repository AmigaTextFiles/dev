" ------------------------------------------------------------------- "
" The EList Class implements Exec list functions.                     "
" ------------------------------------------------------------------- "

Class EList :Object ! private listName !
[
   insertNode: nodeObj Into: listObj after: predObj
      <primitive 209 4 41 listObj nodeObj predObj>
|
   addHead: nodeObj to: listObj
      <primitive 209 4 42 listObj nodeObj>
|
   addTail: nodeObj to: listObj
      <primitive 209 4 43 listObj nodeObj>
|
   removeNode: nodeObj
      <primitive 209 4 44 nodeObj>
|
   removeHeadFrom: listObj
      ^ <primitive 209 4 45 listObj>
|
   removeTailFrom: listObj
      ^ <primitive 209 4 46 listObj>
|
   enqueue: nodeObj toList: listObj
      <primitive 209 4 47 listObj nodeObj>
|
   findNamedNode: nodeName in: listObj
      ^ <primitive 209 4 48 listObj nodeName>
|
   dispose 
      <primitive 209 0 2 private>.

      ^ nil
|
   listToStringArray
   
      ^ <primitive 209 4 105 private>
|
   new: newListName
      private  <- <primitive 209 0 1 99>.
     
      listName <- newListName.
      
      ^ self
]

" -------------------------------------------------------------------- "
" What good is an EList without ENodes??                               "
" -------------------------------------------------------------------- "
 
Class ENode :Object ! private myName !
[
   new: newNodeName ! temp !
      private <- <primitive 209 0 1 105>.
      temp    <- <primitive 209 0 0 (newNodeName size)>.

      <primitive 209 0 5 temp newNodeName 0>.
      <primitive 209 0 6 private temp 10>.

      myName <- newNodeName.
      
      ^ self
|
   dispose
      <primitive 209 0 2 <primitive 209 0 7 private 10> >.
      <primitive 209 0 2 private>.

      ^ nil
|
   successor ! bytes succNode !
      bytes <- ByteArray new: 4.
      
      <primitive 209 0 3 private bytes 0>.
      
      succNode <- (bytes at: 1) bitShift: 24.
      succNode <- succNode + ((bytes at: 2) bitShift: 16).
      succNode <- succNode + ((bytes at: 3) bitShift: 8).
      succNode <- succNode +  (bytes at: 4).

      ^ succNode " This node is next in a EList "
|
   predecessor ! bytes predNode !
      bytes <- ByteArray new: 4.
      
      <primitive 209 0 3 private bytes 4>.
      
      predNode <- (bytes at: 1) bitShift: 24.
      predNode <- predNode + ((bytes at: 2) bitShift: 16).
      predNode <- predNode + ((bytes at: 3) bitShift: 8).
      predNode <- predNode +  (bytes at: 4).

      ^ predNode " This node is before me in a EList "
|
   nodeType ! bytes !
      bytes <- ByteArray new: 2.
      
      <primitive 209 0 3 private bytes 8>.
      
      ^ bytes at: 1
|
   nodePriority ! bytes !
      bytes <- ByteArray new: 2.
      
      <primitive 209 0 3 private bytes 9>.
      
      ^ bytes at: 1
|
   nodeName
      ^ myName
|
   setSuccessor: successorNode
      <primitive 209 0 6 private successorNode 0>.
|
   setPredecessor: predecessorNode
      <primitive 209 0 6 private predecessorNode 4>.
|
   setNodeType: nodeType  " nodeType has to be an Integer! "
      <primitive 209 0 6 private (nodeType bitAnd: 16rFF) 8>.
|
   setNodePriority: newPriority
      <primitive 209 0 6 private (newPriority bitAnd: 16rFF) 9>.
|
   changeNodeName: newNodeName ! temp !

      <primitive 209 0 2 <primitive 209 0 7 private 10> >.

      temp <- <primitive 209 0 0 (newNodeName size)>.

      <primitive 209 0 5 temp newNodeName 0>.
      <primitive 209 0 6 private temp 10>.
      
      myName <- newNodeName
]
