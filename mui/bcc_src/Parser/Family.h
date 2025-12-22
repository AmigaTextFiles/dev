#ifndef FAMILY_H
#define FAMILY_H

class Family {
	struct Family *Succ,*Pred,*Head,*Tail,*TailPred;
public:
	Family();
	~Family();
	void AddTail( Family *child );
	void AddHead( Family *child );
	void AddAfter( Family *child );
	inline Family *Next( void )
	{
		return Succ;
	}
	inline Family *Prev( void )
	{
		return Pred;
	}
	inline Family *First( void )
	{
		return Head;
	}
	Family *Last( void );
	void Remove( void );
	int isEmpty( void );
	void KillChildren( void );
	Family *Parent( void );
	void Disconnect( void );
	void Adopt( Family *f );
	void Swap( Family *f );
	short Count( void );
};

#define FScan(typ,var,root)\
typ* var;\
for( var = (typ*)(root)->First(); var->Next(); var = (typ*)var->Next() )

#define SafeFScan(typ,var,root)\
typ *var, *varnext;\
for( var = (typ*)(root)->First(); varnext = (typ*)var->Next(); var = varnext )

#endif
