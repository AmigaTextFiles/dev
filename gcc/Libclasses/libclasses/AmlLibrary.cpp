
#ifndef _AMLLIBRARY_CPP
#define _AMLLIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/AmlLibrary.h>

AmlLibrary::AmlLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("aml.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open aml.library") );
	}
}

AmlLibrary::~AmlLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

LONG AmlLibrary::RexxDispatcher(struct RexxMsg * rxm)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = rxm;

	__asm volatile ("jsr a6@(-30)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (LONG) _res;
}

APTR AmlLibrary::CreateServerA(struct TagItem * tags)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = tags;

	__asm volatile ("jsr a6@(-36)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (APTR) _res;
}

VOID AmlLibrary::DisposeServer(APTR server)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = server;

	__asm volatile ("jsr a6@(-42)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

ULONG AmlLibrary::SetServerAttrsA(APTR server, struct TagItem * tags)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = server;
	register void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-48)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (ULONG) _res;
}

ULONG AmlLibrary::GetServerAttrsA(APTR server, struct TagItem * tags)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = server;
	register void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-54)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (ULONG) _res;
}

ULONG AmlLibrary::GetServerHeaders(APTR server, ULONG flags)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = server;
	register unsigned int d0 __asm("d0") = flags;

	__asm volatile ("jsr a6@(-60)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (ULONG) _res;
}

LONG AmlLibrary::GetServerArticles(APTR server, APTR folder, struct Hook * hook, ULONG flags)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = server;
	register void * a1 __asm("a1") = folder;
	register void * a2 __asm("a2") = hook;
	register unsigned int d0 __asm("d0") = flags;

	__asm volatile ("jsr a6@(-66)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2), "r" (d0)
	: "a0", "a1", "a2", "d0");
	return (LONG) _res;
}

APTR AmlLibrary::CreateFolderA(APTR server, struct TagItem * tags)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = server;
	register void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-72)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (APTR) _res;
}

BOOL AmlLibrary::DisposeFolder(APTR folder)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = folder;

	__asm volatile ("jsr a6@(-78)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (BOOL) _res;
}

APTR AmlLibrary::OpenFolderA(APTR server, struct TagItem * tags)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = server;
	register void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-84)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (APTR) _res;
}

BOOL AmlLibrary::SaveFolder(APTR folder)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = folder;

	__asm volatile ("jsr a6@(-90)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (BOOL) _res;
}

BOOL AmlLibrary::RemFolder(APTR folder)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = folder;

	__asm volatile ("jsr a6@(-96)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (BOOL) _res;
}

ULONG AmlLibrary::SetFolderAttrsA(APTR folder, struct TagItem * tags)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = folder;
	register void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-102)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (ULONG) _res;
}

ULONG AmlLibrary::GetFolderAttrsA(APTR folder, struct TagItem * tags)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = folder;
	register void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-108)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (ULONG) _res;
}

BOOL AmlLibrary::AddFolderArticle(APTR folder, ULONG type, APTR data)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = folder;
	register unsigned int d0 __asm("d0") = type;
	register void * a1 __asm("a1") = data;

	__asm volatile ("jsr a6@(-114)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (a1)
	: "a0", "d0", "a1");
	return (BOOL) _res;
}

BOOL AmlLibrary::RemFolderArticle(APTR folder, APTR article)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = folder;
	register void * a1 __asm("a1") = article;

	__asm volatile ("jsr a6@(-120)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (BOOL) _res;
}

ULONG AmlLibrary::ReadFolderSpool(APTR folder, STRPTR importfile, ULONG flags)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = folder;
	register char * a1 __asm("a1") = importfile;
	register unsigned int d0 __asm("d0") = flags;

	__asm volatile ("jsr a6@(-126)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0)
	: "a0", "a1", "d0");
	return (ULONG) _res;
}

ULONG AmlLibrary::WriteFolderSpool(APTR folder, STRPTR exportfile, ULONG flags)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = folder;
	register char * a1 __asm("a1") = exportfile;
	register unsigned int d0 __asm("d0") = flags;

	__asm volatile ("jsr a6@(-132)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0)
	: "a0", "a1", "d0");
	return (ULONG) _res;
}

ULONG AmlLibrary::ScanFolderIndex(APTR folder, struct Hook * hook, ULONG flags)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = folder;
	register void * a1 __asm("a1") = hook;
	register unsigned int d0 __asm("d0") = flags;

	__asm volatile ("jsr a6@(-138)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0)
	: "a0", "a1", "d0");
	return (ULONG) _res;
}

BOOL AmlLibrary::ExpungeFolder(APTR folder, APTR trash, struct Hook * hook)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = folder;
	register void * a1 __asm("a1") = trash;
	register void * a2 __asm("a2") = hook;

	__asm volatile ("jsr a6@(-144)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2)
	: "a0", "a1", "a2");
	return (BOOL) _res;
}

ULONG AmlLibrary::CreateFolderIndex(APTR folder)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = folder;

	__asm volatile ("jsr a6@(-150)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (ULONG) _res;
}

ULONG AmlLibrary::SortFolderIndex(APTR folder, ULONG field)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = folder;
	register unsigned int d0 __asm("d0") = field;

	__asm volatile ("jsr a6@(-156)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (ULONG) _res;
}

APTR AmlLibrary::CreateArticleA(APTR folder, struct TagItem * tags)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = folder;
	register void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-162)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (APTR) _res;
}

BOOL AmlLibrary::DisposeArticle(APTR article)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = article;

	__asm volatile ("jsr a6@(-168)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (BOOL) _res;
}

APTR AmlLibrary::OpenArticle(APTR server, APTR folder, ULONG msgID, ULONG flags)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = server;
	register void * a1 __asm("a1") = folder;
	register unsigned int d0 __asm("d0") = msgID;
	register unsigned int d1 __asm("d1") = flags;

	__asm volatile ("jsr a6@(-174)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1)
	: "a0", "a1", "d0", "d1");
	return (APTR) _res;
}

BOOL AmlLibrary::CopyArticle(APTR folder, APTR article)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = folder;
	register void * a1 __asm("a1") = article;

	__asm volatile ("jsr a6@(-180)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (BOOL) _res;
}

ULONG AmlLibrary::SetArticleAttrsA(APTR article, struct TagItem * tags)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = article;
	register void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-186)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (ULONG) _res;
}

ULONG AmlLibrary::GetArticleAttrsA(APTR article, struct TagItem * tags)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = article;
	register void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-192)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (ULONG) _res;
}

BOOL AmlLibrary::SendArticle(APTR server, APTR article, UBYTE * from_file)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = server;
	register void * a1 __asm("a1") = article;
	register void * a2 __asm("a2") = from_file;

	__asm volatile ("jsr a6@(-198)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2)
	: "a0", "a1", "a2");
	return (BOOL) _res;
}

BOOL AmlLibrary::AddArticlePartA(APTR article, APTR part, struct TagItem * tags)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = article;
	register void * a1 __asm("a1") = part;
	register void * a2 __asm("a2") = tags;

	__asm volatile ("jsr a6@(-204)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2)
	: "a0", "a1", "a2");
	return (BOOL) _res;
}

VOID AmlLibrary::RemArticlePart(APTR article, APTR part)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = article;
	register void * d0 __asm("d0") = part;

	__asm volatile ("jsr a6@(-210)"
	: 
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
}

APTR AmlLibrary::GetArticlePart(APTR article, ULONG partnum)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = article;
	register unsigned int d0 __asm("d0") = partnum;

	__asm volatile ("jsr a6@(-216)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (APTR) _res;
}

ULONG AmlLibrary::GetArticlePartAttrsA(APTR part, struct TagItem * tags)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = part;
	register void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-222)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (ULONG) _res;
}

ULONG AmlLibrary::SetArticlePartAttrsA(APTR part, struct TagItem * tags)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = part;
	register void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-228)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (ULONG) _res;
}

APTR AmlLibrary::CreateArticlePartA(APTR article, struct TagItem * tags)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = article;
	register void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-234)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (APTR) _res;
}

VOID AmlLibrary::DisposeArticlePart(APTR part)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = part;

	__asm volatile ("jsr a6@(-240)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

BOOL AmlLibrary::GetArticlePartDataA(APTR article, APTR part, struct TagItem * tags)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = article;
	register void * a1 __asm("a1") = part;
	register void * a2 __asm("a2") = tags;

	__asm volatile ("jsr a6@(-246)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2)
	: "a0", "a1", "a2");
	return (BOOL) _res;
}

BOOL AmlLibrary::SetArticlePartDataA(APTR part, struct TagItem * tags)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = part;
	register void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-252)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (BOOL) _res;
}

APTR AmlLibrary::CreateAddressEntryA(struct TagItem * tags)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = tags;

	__asm volatile ("jsr a6@(-258)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (APTR) _res;
}

BOOL AmlLibrary::DisposeAddressEntry(APTR addr)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = addr;

	__asm volatile ("jsr a6@(-264)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (BOOL) _res;
}

APTR AmlLibrary::OpenAddressEntry(APTR server, ULONG fileid)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = server;
	register unsigned int d0 __asm("d0") = fileid;

	__asm volatile ("jsr a6@(-270)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (APTR) _res;
}

LONG AmlLibrary::SaveAddressEntry(APTR server, APTR addr)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = server;
	register void * a1 __asm("a1") = addr;

	__asm volatile ("jsr a6@(-276)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (LONG) _res;
}

BOOL AmlLibrary::RemAddressEntry(APTR server, APTR addr)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = server;
	register void * a1 __asm("a1") = addr;

	__asm volatile ("jsr a6@(-282)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (BOOL) _res;
}

ULONG AmlLibrary::GetAddressEntryAttrsA(APTR addr, struct TagItem * tags)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = addr;
	register void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-288)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (ULONG) _res;
}

ULONG AmlLibrary::SetAddressEntryAttrsA(APTR addr, struct TagItem * tags)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = addr;
	register void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-294)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (ULONG) _res;
}

BOOL AmlLibrary::MatchAddressA(APTR addr, struct TagItem * tags)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = addr;
	register void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-300)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (BOOL) _res;
}

APTR AmlLibrary::FindAddressEntryA(APTR server, struct TagItem * tags)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = server;
	register void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-306)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (APTR) _res;
}

APTR AmlLibrary::HuntAddressEntryA(APTR server, struct TagItem * tags)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = server;
	register void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-312)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (APTR) _res;
}

ULONG AmlLibrary::ScanAddressIndex(APTR server, struct Hook * hook, ULONG type, ULONG flags)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = server;
	register void * a1 __asm("a1") = hook;
	register unsigned int d0 __asm("d0") = type;
	register unsigned int d1 __asm("d1") = flags;

	__asm volatile ("jsr a6@(-318)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (d0), "r" (d1)
	: "a0", "a1", "d0", "d1");
	return (ULONG) _res;
}

BOOL AmlLibrary::AddCustomField(APTR addr, STRPTR field, STRPTR data)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = addr;
	register char * a1 __asm("a1") = field;
	register char * a2 __asm("a2") = data;

	__asm volatile ("jsr a6@(-324)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1), "r" (a2)
	: "a0", "a1", "a2");
	return (BOOL) _res;
}

BOOL AmlLibrary::RemCustomField(APTR addr, STRPTR field)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = addr;
	register char * a1 __asm("a1") = field;

	__asm volatile ("jsr a6@(-330)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (BOOL) _res;
}

STRPTR AmlLibrary::GetCustomFieldData(APTR addr, STRPTR field)
{
	register STRPTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = addr;
	register char * a1 __asm("a1") = field;

	__asm volatile ("jsr a6@(-336)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (STRPTR) _res;
}

APTR AmlLibrary::CreateDecoderA(struct TagItem * tags)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = tags;

	__asm volatile ("jsr a6@(-342)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (APTR) _res;
}

VOID AmlLibrary::DisposeDecoder(APTR dec)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = dec;

	__asm volatile ("jsr a6@(-348)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

ULONG AmlLibrary::GetDecoderAttrsA(APTR dec, struct TagItem * tags)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = dec;
	register void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-354)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (ULONG) _res;
}

ULONG AmlLibrary::SetDecoderAttrsA(APTR dec, struct TagItem * tags)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = dec;
	register void * a1 __asm("a1") = tags;

	__asm volatile ("jsr a6@(-360)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (ULONG) _res;
}

LONG AmlLibrary::Decode(APTR dec, ULONG type)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = dec;
	register unsigned int d0 __asm("d0") = type;

	__asm volatile ("jsr a6@(-366)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (LONG) _res;
}

LONG AmlLibrary::Encode(APTR dec, ULONG type)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = dec;
	register unsigned int d0 __asm("d0") = type;

	__asm volatile ("jsr a6@(-372)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0)
	: "a0", "d0");
	return (LONG) _res;
}


#endif

