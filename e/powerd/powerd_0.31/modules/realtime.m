LIBRARY RealTimeBase
	LockRealTime(D0)(d0)=-30,
	UnlockRealTime(A0)(d0)=-36,
	CreatePlayerA(a0:PTR TO TagItem)(d0)=-42,
	CreatePlayer(a0:LIST OF TagItem)(d0)=-42,
	DeletePlayer(A0)(d0)=-48,
	SetPlayerAttrsA(a0,a1:PTR TO TagItem)(d0)=-54,
	SetPlayerAttrs(a0,a1:LIST OF TagItem)(d0)=-54,
	SetConductorState(A0,D0,D1)(d0)=-60,
	ExternalSync(A0,D0,D1)(d0)=-66,
	NextConductor(A0)(d0)=-72,
	FindConductor(A0)(d0)=-78,
	GetPlayerAttrsA(a0,a1:PTR TO TagItem)(d0)=-84,
	GetPlayerAttrs(a0,a1:LIST OF TagItem)(d0)=-84
