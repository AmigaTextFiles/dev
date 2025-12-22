/* FVList class in use:
	Let's build a list of aliens for some game
*/
/*--------------------------------------------------------------------------*/
MODULE 'FVMods/FVList'
/*--------------------------------------------------------------------------*/
OBJECT alien OF fvnode
	alientype:LONG			-> give the alien some silly attributes
	speed:LONG
	speedincrease:LONG
ENDOBJECT
/*--------------------------------------------------------------------------*/
PROC addAlien(root,type,speed,speedincrease) OF alien
     self::fvnode.make(root)
     self.alientype := type
     self.speed := speed
     self.speedincrease := speedincrease
ENDPROC
/*--------------------------------------------------------------------------*/
PROC show() OF alien
	PrintF('Node:\n\taddress=\h\n\tchild=\h\n\troot=\h\n\tAlienType = \d\n\tAlienSpeed = \d\n\tAlienSpeedincrease = \d\n-------------------\n',self,self.giveChild(),self.giveRoot(),self.alientype,self.speed,self.speedincrease)
ENDPROC
/*--------------------------------------------------------------------------*/
PROC	increaseAlienSpeeds(r:PTR TO fvlist)
     DEF a:PTR TO alien

	IF (a := r.giveChild())
		PrintF('Increasing alien speeds\n')
		WHILE a
               a.speed := a.speed + a.speedincrease
			a := a.giveChild()
		ENDWHILE
	ELSE
     	PrintF('Cannot increase alien speeds, because list is empty\n')
	ENDIF
ENDPROC
/*--------------------------------------------------------------------------*/
PROC main()
	DEF	root:PTR TO fvlist,
		node:PTR TO alien,
		intermediate:PTR TO alien

	Delay(50)
	NEW root.make(NIL)
	NEW node.addAlien(root,1,26,1)
	intermediate := NEW node.addAlien(root,5,15,2)
	NEW node.addAlien(root,2,32,3)
	root.show()
	increaseAlienSpeeds(root)	-> let's do something useful :) with the alien members
	PrintF('Pausing...\n')
	Delay(100)
	root.show()

	PrintF('Killing an alien: alien \h... DIE!\n',intermediate)
	intermediate.delete()		-> kill'im
	PrintF('Pausing...\n')
	Delay(100)
	root.show()

	PrintF('\nquitting...\nnow,root = \h\n',root)
     END root					-> frees root and all linked nodes too
	PrintF('root = \h, if it is 0, then root is also freed.\n',root)
ENDPROC
