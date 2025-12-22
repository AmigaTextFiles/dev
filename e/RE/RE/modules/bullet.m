LIBRARY BulletBase
	OpenEngine()(d0:PTR)=-30,
	CloseEngine(a0)=-36,
	SetInfoA(a0,a1:PTR TO TagItem)(d0:ULONG)=-42,
	SetInfo(a0,a1:LIST OF TagItem)(d0:ULONG)=-42,
	ObtainInfoA(a0,a1:PTR TO TagItem)(d0:ULONG)=-48,
	ObtainInfo(a0,a1:LIST OF TagItem)(d0:ULONG)=-48,
	ReleaseInfoA(a0,a1:PTR TO TagItem)(d0:ULONG)=-54,
	ReleaseInfo(a0,a1:LIST OF TagItem)(d0:ULONG)=-54
