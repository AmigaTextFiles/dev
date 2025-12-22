# Speicherverwaltung für CLISP
# Bruno Haible 22.6.1995

# Inhalt:
# Modulverwaltung
# Debug-Hilfen
# Speichergröße
# Speicherlängenbestimmung
# Garbage Collection
# Speicherbereitstellungsfunktionen
# Zirkularitätenfeststellung
# elementare Stringfunktionen
# andere globale Hilfsfunktionen
# Initialisierung
# Speichern und Laden von MEM-Files
# Fremdprogrammaufruf
# Version

#include "lispbibl.c"
#include "aridecl.c" # für NUM_STACK
#ifdef ENABLE_NLS
#ifdef STDC_HEADERS
#include <string.h>
#endif
#endif

# In diesem File haben die Tabellenmacros eine andere Verwendung:
  #undef LISPSPECFORM
  #undef LISPFUN
  #undef LISPSYM
  #undef LISPOBJ

# Tabelle aller SUBRs: ausgelagert nach SPVWTABF
# Größe dieser Tabelle:
  #define subr_anz  (sizeof(subr_tab)/sizeof(subr_))

# Tabelle aller FSUBRs: ausgelagert nach CONTROL
# Größe dieser Tabelle:
  #define fsubr_anz  (sizeof(fsubr_tab)/sizeof(fsubr_))

# Tabelle aller Pseudofunktionen: ausgelagert nach STREAM
# Größe dieser Tabelle:
  #define pseudofun_anz  (sizeof(pseudofun_tab)/sizeof(Pseudofun))

# Tabelle aller festen Symbole: ausgelagert nach SPVWTABS
# Größe dieser Tabelle:
  #define symbol_anz  (sizeof(symbol_tab)/sizeof(symbol_))

# Tabelle aller sonstigen festen Objekte: ausgelagert nach SPVWTABO
# Größe dieser Tabelle:
  #define object_anz  (sizeof(object_tab)/sizeof(object))

# Durchlaufen durch subr_tab:
# (NB: subr_tab_ptr_as_object(ptr) wandelt einen durchlaufenden Pointer
# in ein echtes Lisp-Objekt um.)
  #ifdef MAP_MEMORY_TABLES
    local uintC total_subr_anz;
    #define for_all_subrs(statement)  \
      { var reg6 subr_* ptr = (subr_*)&subr_tab; # subr_tab durchgehen \
        var reg5 uintC count;                                          \
        dotimesC(count,total_subr_anz, { statement; ptr++; } );        \
      }
  #else
    #define for_all_subrs(statement)  \
      { var reg7 module_* module; # modules durchgehen                  \
        for_modules(all_modules,                                        \
          { var reg5 subr_* ptr = module->stab;                         \
            var reg6 uintC count;                                       \
            dotimesC(count,*module->stab_size, { statement; ptr++; } ); \
          });                                                           \
      }
  #endif

# Beim Durchlaufen durch symbol_tab:
# Wandelt einen durchlaufenden Pointer in ein echtes Lisp-Objekt um.
  #ifdef MAP_MEMORY_TABLES
    #define symbol_tab_ptr_as_object(ptr)  as_object((oint)(ptr))
  #else
    #define symbol_tab_ptr_as_object(ptr)  type_pointer_object(symbol_type,ptr)
  #endif
# Durchlaufen durch symbol_tab:
  #define for_all_constsyms(statement)  \
    { var reg6 symbol_* ptr = (symbol_*)&symbol_tab; # symbol_tab durchgehen \
      var reg5 uintC count;                                                  \
      dotimesC(count,symbol_anz, { statement; ptr++; } );                    \
    }

# Durchlaufen durch object_tab:
  #define for_all_constobjs(statement)  \
    { var reg5 module_* module; # modules durchgehen                      \
      for_modules(all_modules,                                            \
        { var reg3 object* objptr = module->otab; # object_tab durchgehen \
          var reg4 uintC count;                                           \
          dotimesC(count,*module->otab_size, { statement; objptr++; } );  \
        });                                                               \
    }

# Semaphoren: decide whether an interrupt request is ignored (/= 0)
# or has effect (all = 0).
# Werden mit set_break_sem_x gesetzt und mit clr_break_sem_x wieder gelöscht.
  global break_sems_ break_sems;
  # break_sem_1 == break_sems.einzeln[0]
  #   gesetzt, solange die Speicherverwaltung eine Unterbrechung verbietet
  #   (damit leerer Speicher nicht von der GC durchlaufen werden kann)
  # break_sem_2 == break_sems.einzeln[1]
  #   für Package-Verwaltung auf unterem Niveau und Hashtable-Verwaltung
  # break_sem_3 == break_sems.einzeln[2]
  #   für Package-Verwaltung auf höherem Niveau
  # break_sem_4 == break_sems.einzeln[3]
  #   set while (AMIGADOS) DOS or external functions are being called.

# GC-Statistik:
  global uintL  gc_count = 0;      # Zähler für GC-Aufrufe
  global uintL2 gc_space =         # Größe des von der GC insgesamt bisher
                                   # wiederbeschafften Platzes (64-Bit-Akku)
    #ifdef intQsize
      0
    #else
      {0,0}
    #endif
    ;
# Zeit, die die GC verbraucht:
  global internal_time gc_time =        # GC-Zeitverbrauch bisher insgesamt
    #ifdef TIME_1
    0
    #endif
    #ifdef TIME_2
    {0,0}
    #endif
    ;

# ------------------------------------------------------------------------------
#                          Modulverwaltung

#ifdef DYNAMIC_MODULES

  extern uintC subr_tab_data_size;
  extern uintC object_tab_size;
  local module_ main_module =
    { "clisp",
      (subr_*)&subr_tab_data, &subr_tab_data_size,
      (object*)&object_tab, &object_tab_size,
      TRUE, NULL, NULL, NULL, NULL,
      NULL # Hier beginnt die Liste der anderen Module
    };
  local module_ ** last_module = &main_module.next; # zeigt aufs Ende der Liste
  global uintC module_count = 0;

  global void add_module (module_ * new_module);
  global void add_module(module)
    var reg1 module_ * module;
    { *last_module = module; last_module = &module->next;
      module_count++;
    }

  #define for_modules(which,statement)  \
    module = (which); until (module==NULL) { statement; module = module->next; }
  #define all_modules  &main_module
  #define all_other_modules  main_module.next

#else

  #define main_module  modules[0]

  #define for_modules(which,statement)  \
    module = (which); until (module->name==NULL) { statement; module++; }
  #define all_modules  &modules[0]
  #define all_other_modules  &modules[1]

#endif

# ------------------------------------------------------------------------------
#                            Debug-Hilfen

# uintL in Dezimalnotation direkt übers Betriebssystem ausgeben:
# dez_out(zahl)
  global void dez_out_ (uintL zahl);
  global void dez_out_(zahl)
    var reg1 uintL zahl;
    { var struct { uintB contents[10+1]; } buffer;
      # 10-Byte-Buffer reicht, da zahl < 2^32 <= 10^10 .
      var reg2 uintB* bufptr = &buffer.contents[10]; # Pointer in den Buffer
      *bufptr = 0; # ASCIZ-String-Ende
      do { *--bufptr = '0'+(zahl%10); zahl=floor(zahl,10); }
         until (zahl==0);
      asciz_out((char*)bufptr);
    }

# uintL in Hexadezimalnotation direkt übers Betriebssystem ausgeben:
# hex_out(zahl)
  global void hex_out_ (unsigned long zahl);
  local char hex_table[] = "0123456789ABCDEF";
  global void hex_out_(zahl)
    var reg1 unsigned long zahl;
    { var struct { uintB contents[2*sizeof(unsigned long)+1]; } buffer;
      # 8/16-Byte-Buffer reicht, da zahl < 2^32 <= 16^8 bzw. zahl < 2^64 <= 16^16 .
      var reg2 uintB* bufptr = &buffer.contents[2*sizeof(unsigned long)]; # Pointer in den Buffer
      *bufptr = 0; # ASCIZ-String-Ende
      do { *--bufptr = hex_table[zahl%16]; zahl=floor(zahl,16); }
         until (zahl==0);
      asciz_out((char*)bufptr);
    }

# Speicherbereich in Hexadezimalnotation direkt übers Betriebssystem ausgeben:
# mem_hex_out(buf,count);
  global void mem_hex_out (void* buf, uintL count);
  global void mem_hex_out(buf,count)
    var reg5 void* buf;
    var reg3 uintL count;
    { var DYNAMIC_ARRAY(reg4,cbuf,char,3*count+1);
      var reg2 uintB* ptr1 = buf;
      var reg1 char* ptr2 = &cbuf[0];
      dotimesL(count,count,
        { *ptr2++ = ' ';
          *ptr2++ = hex_table[floor(*ptr1,16)]; *ptr2++ = hex_table[*ptr1 % 16];
          ptr1++;
        });
      *ptr2 = '\0';
      asciz_out(cbuf);
      FREE_DYNAMIC_ARRAY(cbuf);
    }

# Lisp-Objekt in Lisp-Notation relativ direkt übers Betriebssystem ausgeben:
# object_out(obj);
# kann GC auslösen
  global void object_out (object obj);
  global void object_out(obj)
    var object obj;
    { pushSTACK(obj);
      pushSTACK(var_stream(S(terminal_io),strmflags_wr_ch_B)); # Stream *TERMINAL-IO*
      prin1(&STACK_0,STACK_1); # Objekt ausgeben
      terpri(&STACK_0); # Newline ausgeben
      skipSTACK(2);
    }

# ------------------------------------------------------------------------------
#                         Schnelles Programm-Ende

# jmp_buf zur Rückkehr zum Original-Wert des SP beim Programmstart:
  local jmp_buf original_context;

# LISP sofort verlassen:
# quit_sofort(exitcode);
# > exitcode: 0 bei normalem, 1 bei abnormalem Programmende
  # Wir müssen den SP auf den ursprünglichen Wert setzen.
  # (Bei manchen Betriebssystemen wird erst der vom Programm belegte
  # Speicher mit free() zurückgegeben, bevor ihm die Kontrolle entzogen
  # wird. Für diese kurze Zeit muß man den SP vernünftig setzen.)
  local int exitcode;
  #define quit_sofort(xcode)  exitcode = xcode; longjmp(&!original_context,1)

# ------------------------------------------------------------------------------
#                         Speicherverwaltung allgemein

/*

Overview over CLISP's garbage collection
----------------------------------------

Knowing that most malloc() implementations are buggy and/or slow, and
because CLISP needs to perform garbage collection, CLISP has its own memory
management subsystem in spvw.d.

Three kinds of storage are distinguished:
  * Lisp data (the "heap"), i.e. storage which contains Lisp objects and
    is managed by the garbage collector.
  * Lisp stack (called STACK), contains Lisp objects,
  * C data (including program text, data, malloc()ed memory).

A Lisp object is one word, containing a tag (partial type information)
and either immediate data (e.g. fixnums or short floats) or a pointer
to storage. Pointers to C data have tag = machine_type = 0, pointers to
Lisp stack have tag = system_type, most other pointers point to Lisp data.

Let's turn to these Lisp objects that consume regular Lisp memory.
Every Lisp object has a size which is determined when the object is
allocated (using one of the allocate_... routines). The size can be
computed from the type tag and - if necessary - the length field of
the object's header. The length field always contains the number of
elements of the object. The number of bytes is given by the function
speicher_laenge().

Lisp objects which contain exactly 2 Lisp objects (i.e. conses, complex
numbers, ratios) are stored in a separate area and occupy 2 words each.
All other Lisp objects have "varying length" (well, more precisely,
not a fixed length) and include a word for garbage collection purposes
at their beginning.

The garbage collector is invoked when an allocate_...() request
cannot be fulfilled. It marks all objects which are "live" (may be
reached from the "roots"), compacts these objects and unmarks them.
Non-live objects are lost; their storage is reclaimed.

2-pointer objects are compacted by a simple hole-filling algorithm:
fill the most-left object into the most-right hole, and so on, until
the objects are contiguous at the right and the hole is contiguous at the
left.

Variable-length objects are compacted by sliding them down (their address
decreases).

There are 5 memory models. Which one is used, depends on the operating system.

SPVW_MIXED_BLOCKS_OPPOSITE: The heap consists of one block of fixed length
(allocated at startup). The variable-length objects are allocated from
the left, the 2-pointer objects are allocated from the right. There is a
hole between them. When the hole shrinks to 0, GC is invoked. GC slides
the variable-length objects to the left and concentrates the 2-pointer
objects at the right end of the block again.
When no more room is available, some reserve area beyond the right end
of the block is halved, and the 2-pointer objects are moved to the right
accordingly.
(+) Simple management.
(+) No fragmentation at all.
(-) The total heap size is limited.

SPVW_MIXED_BLOCKS && TRIVIALMAP_MEMORY: The heap consists of two big blocks,
one for variable-length objects and one for 2-pointer objects. Both have a
hole to the right, but are extensible to the right.
(+) Total heap size grows depending on the application's needs.
(+) No fragmentation at all.
(*) Works only when SINGLEMAP_MEMORY were possible as well.

SPVW_MIXED_PAGES: The heap consists of many small pages (usually around
8 KB). There are two kinds of pages: one for 2-pointer objects, one for
variable-length objects. The set of all pages of a fixed kind is called
a "Heap". Each page has its hole (free space) at its end. For every heap,
the pages are kept sorted according to the size of their hole, using AVL
trees. Garbage collection is invoked when the used space has grown by
25% since the last GC; until that point new pages are allocated from
the operating system. The GC compacts the data in each page separately:
data is moved to the left. Emptied pages are given back to the OS.
If the holes then make up more than 25% of the occupied storage, a second
GC turn moves objects across pages, from nearly empty ones to nearly full
ones, with the aim to free as most pages as possible.

(-) every allocation requires AVL tree operations -> slower
(+) Total heap size grows depending on the application's needs.
(+) Works on operating systems which don't provide large contiguous areas.

SPVW_PURE_PAGES: Just like SPVW_MIXED_PAGES, except that every page contains
data of only a single type tag, i.e. there is a Heap for every type tag.

(-) every allocation requires AVL tree operations -> slower
(+) Total heap size grows depending on the application's needs.
(+) Works on operating systems which don't provide large contiguous areas.
(-) More fragmentation because objects of different type never fit into
    the same page.

SPVW_PURE_BLOCKS: There is a big block of storage for each type tag.
Each of these blocks has its data to the left and the hole to the right,
but these blocks are extensible to the right (because there's enough room
between them). A garbage collection is triggered when the allocation amount
since the last GC reaches 50% of the amount of used space at the last GC,
but at least 512 KB. The garbage collection cleans up each block separately:
data is moved left.

(+) Total heap size grows depending on the application's needs.
(+) No 16 MB total size limit.
(*) Works only in combination with SINGLEMAP_MEMORY.


The following combinations of memory model and mmap tricks are possible:

                       GENERATIONAL_GC -------------+
                                                     \
                    MULTIMAP_MEMORY -------------+    \
                  SINGLEMAP_MEMORY -----------+   \    \
                TRIVIALMAP_MEMORY -------- +   \   \    \
               no MAP_MEMORY -----------+   \   \   \    \
                                         \   \   \   \    \
SPVW_MIXED_BLOCKS_OPPOSITE              | X |   |   | X | X |
SPVW_MIXED_BLOCKS && TRIVIALMAP_MEMORY  |   | X |   |   | X |
SPVW_PURE_BLOCKS                        |   |   | X |   | X |
SPVW_MIXED_PAGES                        | X |   |   |   |   |
SPVW_PURE_PAGES                         | X |   |   |   |   |

Historically, the different memory models were developed in the following
order (1 = first, ...):
SPVW_MIXED_BLOCKS_OPPOSITE              | 1 |   |   | 2 | 9 |
SPVW_MIXED_BLOCKS && TRIVIALMAP_MEMORY  |   | 7 |   |   | 8 |
SPVW_PURE_BLOCKS                        |   |   | 5 |   | 6 |
SPVW_MIXED_PAGES                        | 3 |   |   |   |   |
SPVW_PURE_PAGES                         | 4 |   |   |   |   |


The burden of GC upon the rest of CLISP:

Every subroutine marked with "kann GC auslösen" may invoke GC. GC moves
all the Lisp objects and updates the pointers. But the GC looks only
on the STACK and not in the C variables. (Anything else wouldn't be portable.)
Therefore at every "unsafe" point - i.e. every call to such a subroutine -
all the C variables of type `object' MUST BE ASSUMED TO BECOME GARBAGE.
(Except for `object's that are known to be unmovable, e.g. immediate data
or Subrs.) Pointers inside Lisp data (e.g. to the characters of a string or
to the elements of a simple-vector) become INVALID as well.

The workaround is usually to allocate all the needed Lisp data first and
do the rest of the computation with C variables, without calling unsafe
routines, and without worrying about GC.


Foreign Pointers
----------------

Pointers to C functions and to malloc()ed data can be hidden in Lisp
objects of type machine_type; GC will not modify its value. But one should
not dare to assume that a C stack pointer or the address of a C function
in a shared library fulfills the same requirements.

If another pointer is to be viewed as a Lisp object, it is best to box it,
e.g. in a simple-bit-vector or in an Fpointer. (See allocate_fpointer().)

*/


# Methode der Speicherverwaltung:
#if defined(SPVW_BLOCKS) && defined(SPVW_MIXED)
  #define SPVW_MIXED_BLOCKS
  #if !defined(TRIVIALMAP_MEMORY)
    # Blocks grow like this:       |******-->     <--****|
    #define SPVW_MIXED_BLOCKS_OPPOSITE
  #else # defined(TRIVIALMAP_MEMORY)
    # Blocks grow like this:       |******-->      |***-->
  #endif
#endif
#if defined(SPVW_BLOCKS) && defined(SPVW_PURE) # z.B. UNIX_LINUX ab Linux 0.99.7
  #define SPVW_PURE_BLOCKS
#endif
#if defined(SPVW_PAGES) && defined(SPVW_MIXED) # z.B. SUN3, AMIGA, HP9000_800
  #define SPVW_MIXED_PAGES
#endif
#if defined(SPVW_PAGES) && defined(SPVW_PURE) # z.B. SUN4, SUN386
  #define SPVW_PURE_PAGES
#endif

# Gesamtspeicheraufteilung:
# 1. C-Programm. Speicher wird vom Betriebssystem zugeteilt.
#    Nach Programmstart unverschieblich.
# 2. C-Stack. Speicher wird vom C-Programm geholt.
#    Unverschieblich.
# 3. C-Heap. Hier unbenutzt.
#ifdef SPVW_MIXED_BLOCKS
# 4. LISP-Stack und LISP-Daten.
#    4a. LISP-Stack. Unverschieblich.
#    4b. Objekte variabler Länge. (Unverschieblich).
#    4c. Conses u.ä. Verschieblich mit move_conses.
#    Speicher hierfür wird vom Betriebssystem angefordert (hat den Vorteil,
#    daß bei EXECUTE dem auszuführenden Fremdprogramm der ganze Speicher
#    zur Verfügung gestellt werden kann, den LISP gerade nicht braucht).
#    Auf eine Unterteilung in einzelne Pages wird hier verzichtet.
#          || LISP-      |Objekte         |    leer  |Conses| Reserve |
#          || Stack      |variabler Länge              u.ä. |         |
#          |STACK_BOUND  |         objects.end   conses.start |         |
#        MEMBOT   objects.start                         conses.end    MEMTOP
#endif
#ifdef SPVW_PURE_BLOCKS
# 4. LISP-Stack. Unverschieblich.
# 5. LISP-Daten. Für jeden Typ ein großer Block von Objekten.
#endif
#ifdef SPVW_MIXED_PAGES
# 4. LISP-Stack. Unverschieblich.
# 5. LISP-Daten.
#    Unterteilt in Pages für Objekte variabler Länge und Pages für Conses u.ä.
#endif
#ifdef SPVW_PURE_PAGES
# 4. LISP-Stack. Unverschieblich.
# 5. LISP-Daten. Unterteilt in Pages, die nur Objekte desselben Typs enthalten.
#endif

# Kanonische Adressen:
# Bei MULTIMAP_MEMORY kann man über verschiedene Pointer auf dieselbe Speicher-
# stelle zugreifen. Die Verwaltung der Heaps benötigt einen "kanonischen"
# Pointer. Über diesen kann zugegriffen werden, und er kann mit >=, <=
# verglichen werden. heap_start und heap_end sind kanonische Adressen.
  #ifdef MULTIMAP_MEMORY
    #define canonaddr(obj)  upointer(obj)
    #define canon(address)  ((address) & oint_addr_mask)
  #else
    #define canonaddr(obj)  (aint)ThePointer(obj)
    #define canon(address)  (address)
  #endif
  # Es gilt canonaddr(obj) == canon((aint)ThePointer(obj)).

# ------------------------------------------------------------------------------
#                          Eigenes malloc(), free()

#ifdef AMIGAOS

# Eigenes malloc(), free() nötig wegen Resource Tracking.

  # Flag, das anzeigt, ob der Prozessor ein 68000 ist.
  local boolean cpu_is_68000;
  #if defined(MC68000)
    #define CPU_IS_68000  TRUE
  #elif defined(MC680Y0)
    #define CPU_IS_68000  FALSE
  #else
    #define CPU_IS_68000  cpu_is_68000
  #endif

  # Flag für AllocMem().
  #define default_allocmemflag  MEMF_ANY
  #if !(defined(WIDE) || defined(MC68000))
    # Es kann sein, daß wir mit MEMF_ANY Speicher außerhalb des
    # 24/26-Bit-Adreßraums bekommen, den wir nicht nutzen können.
    # Dann versuchen wir's nochmal.
    local uintL retry_allocmemflag;  # wird in init_amiga() gesetzt.
  #endif

  # Doppelt verkettete Liste aller bisher belegten Speicherblöcke führen:
  typedef struct MemBlockHeader { struct MemBlockHeader * next;
                                  #ifdef SPVW_PAGES
                                  struct MemBlockHeader * * prev;
                                  #endif
                                  uintL size;
                                  oint usable_memory[unspecified]; # "oint" erzwingt Alignment
                                }
          MemBlockHeader;
  local MemBlockHeader* allocmemblocks = NULL;
  #ifdef SPVW_PAGES
  # Für alle p = allocmemblocks{->next}^n (n=0,1,...) mit !(p==NULL) gilt
  # *(p->prev) = p.
  #endif

  # Speicher vom Betriebssystem holen:
  local void* allocmem (uintL amount, uintL allocmemflag);
  local void* allocmem(amount,allocmemflag)
    var reg2 uintL amount;
    var reg3 uintL allocmemflag;
    { amount = round_up(amount+offsetofa(MemBlockHeader,usable_memory),4);
     {var reg1 void* address = AllocMem(amount,allocmemflag);
      if (!(address==NULL))
        { ((MemBlockHeader*)address)->size = amount;
          ((MemBlockHeader*)address)->next = allocmemblocks;
          #ifdef SPVW_PAGES
          ((MemBlockHeader*)address)->prev = &allocmemblocks;
          if (!(allocmemblocks == NULL))
            { if (allocmemblocks->prev == &allocmemblocks) # Sicherheits-Check
                { allocmemblocks->prev = &((MemBlockHeader*)address)->next; }
                else
                { abort(); }
            }
          #endif
          allocmemblocks = (MemBlockHeader*)address;
          address = &((MemBlockHeader*)address)->usable_memory[0];
        }
      return address;
    }}

  # Speicher dem Betriebssystem zurückgeben:
  local void freemem (void* address);
  local void freemem(address)
    var reg2 void* address;
    { var reg1 MemBlockHeader* ptr = (MemBlockHeader*)((aint)address - offsetofa(MemBlockHeader,usable_memory));
      #ifdef SPVW_PAGES
      if (*(ptr->prev) == ptr) # Sicherheits-Check
        { var reg2 MemBlockHeader* ptrnext = ptr->next;
          *(ptr->prev) = ptrnext; # ptr durch ptr->next ersetzen
          if (!(ptrnext == NULL)) { ptrnext->prev = ptr->prev; }
          FreeMem(ptr,ptr->size);
          return;
        }
      #else
      # Spar-Implementation, die nur in der Lage ist, den letzten allozierten
      # Block zurückzugeben:
      if (allocmem == ptr) # Sicherheits-Check
        { allocmem = ptr->next; # ptr durch ptr->next ersetzen
          FreeMem(ptr,ptr->size);
          return;
        }
      #endif
        else
        { abort(); }
    }

  #define malloc(amount)  allocmem(amount,default_allocmemflag)
  #define free  freemem

#endif

#ifdef NEED_MALLOCA

# Eigener alloca()-Ersatz.
# ptr = malloca(size) liefert einen Speicherblock gegebener Größe. Er kann
# (muß aber nicht) mit freea(ptr) freigegeben werden.
# freea(ptr) gibt alle seit der Allozierung von ptr per malloca()
# gelieferten Speicherblöcke zurück, einschließlich ptr selbst.

# Die so allozierten Speicherblöcke bilden eine verkettete Liste.
typedef struct malloca_header
               { struct malloca_header * next;
                 oint usable_memory[unspecified]; # "oint" erzwingt Alignment
               }
        malloca_header;

# Verkettete Liste der Speicherblöcke, der jüngste ganz vorn, der älteste
# ganz hinten.
  local malloca_header* malloca_list = NULL;

# malloca(size) liefert einen Speicherblock der Größe size.
  global void* malloca (size_t size);
  global void* malloca(size)
    var reg2 size_t size;
    { var reg1 malloca_header* ptr = (malloca_header*)malloc(offsetofa(malloca_header,usable_memory) + size);
      if (!(ptr == NULL))
        { ptr->next = malloca_list;
          malloca_list = ptr;
          return &ptr->usable_memory;
        }
        else
        {
          #ifdef VIRTUAL_MEMORY
          //: DEUTSCH "Kein virtueller Speicher mehr verfügbar: RESET" 
          //: ENGLISH "Virtual memory exhausted. RESET"
          //: FRANCAIS "La mémoire virtuelle est épuisée : RAZ" 
          err_asciz_out(GETTEXT("out of virtual memory"));
          #else
          //: DEUTSCH "Speicher voll: RESET" 
          //: ENGLISH "Memory exhausted. RESET"
          //: FRANCAIS "La mémoire est épuisée : RAZ"
          err_asciz_out(GETTEXT("out of memory"));
          #endif
          reset();
    }   }

# freea(ptr) gibt den Speicherblock ab ptr und alle jüngeren frei.
  global void freea (void* ptr);
  global void freea(address)
    var reg4 void* address;
    { var reg3 malloca_header* ptr = (malloca_header*)
        ((aint)address - offsetofa(malloca_header,usable_memory));
      var reg1 malloca_header* p = malloca_list;
      loop
        { var reg2 malloca_header* n = p->next;
          free(p);
          if (!(p == ptr))
            { p = n; }
            else
            { malloca_list = n; break; }
        }
    }

#endif # NEED_MALLOCA

# ------------------------------------------------------------------------------
#                          Page-Allozierung

# Anzahl der möglichen Typcodes überhaupt.
  #define typecount  bit(oint_type_len<=8 ? oint_type_len : 8)

#ifdef MULTIMAP_MEMORY

# Das Betriebssystem erlaubt es, denselben (virtuellen) Speicher unter
# verschiedenen Adressen anzusprechen.
# Dabei gibt es allerdings Restriktionen:
# - Die Adressenabbildung kann nur für ganze Speicherseiten auf einmal
#   erstellt werden.
# - Wir brauchen zwar nur diesen Adreßraum und nicht seinen Inhalt, müssen
#   ihn aber mallozieren und dürfen ihn nicht freigeben, da er in unserer
#   Kontrolle bleiben soll.

# Länge einer Speicherseite des Betriebssystems:
  local /* uintL */ aint map_pagesize; # wird eine Zweierpotenz sein, meist 4096.

# Initialisierung:
# initmap() bzw. initmap(tmpdir)

# In einen Speicherbereich [map_addr,map_addr+map_len-1] leere Seiten legen:
# (map_addr und map_len durch map_pagesize teilbar.)
# zeromap(map_addr,map_len)

# Auf einen Speicherbereich [map_addr,map_addr+map_len-1] Seiten legen,
# die unter den Typcodes, die in typecases angegeben sind, ansprechbar
# sein sollen:
# multimap(typecases,imm_typecases,imm_flag,map_addr,map_len,save_flag);

# Alle immutablen Objekte mutabel machen:
# immutable_off();

# Alle immutablen Objekte wieder immutabel machen:
# immutable_on();

# Beendigung:
# exitmap();

# Diese Typen kennzeichnen Objekte mit !immediate_type_p(type):
  #define MM_TYPECASES  \
    case_array: case_record: case_system: \
    case_bignum: case_ratio: case_ffloat: case_dfloat: case_lfloat: case_complex: \
    case_symbolflagged: case_cons:

# Diese Typen kennzeichnen immutable Objekte:
  #ifdef IMMUTABLE
    #ifdef IMMUTABLE_CONS
      #define IMM_TYPECASES_1  case imm_cons_type:
    #else
      #define IMM_TYPECASES_1
    #endif
    #ifdef IMMUTABLE_ARRAY
      #define IMM_TYPECASES_2  \
        case imm_sbvector_type: case imm_sstring_type: case imm_svector_type: case imm_array_type: \
        case imm_bvector_type: case imm_string_type: case imm_vector_type:
    #else
      #define IMM_TYPECASES_2
    #endif
    #define IMM_TYPECASES  IMM_TYPECASES_1 IMM_TYPECASES_2
    local tint imm_types[] =
      {
        #ifdef IMMUTABLE_CONS
        imm_cons_type,
        #endif
        #ifdef IMMUTABLE_ARRAY
        imm_sbvector_type,
        imm_sstring_type,
        imm_svector_type,
        imm_array_type,
        imm_bvector_type,
        imm_string_type,
        imm_vector_type,
        #endif
      };
    #define imm_types_count  (sizeof(imm_types)/sizeof(tint))
    # Fehlermeldung:
      nonreturning_function(local, fehler_immutable, (void));
      local void fehler_immutable()
        { 
          //: DEUTSCH "Versuch der Modifikation unveränderlicher Daten."
          //: ENGLISH "Attempt to modify read-only data"
          //: FRANCAIS "Tentative de modification d'un objet non modifiable."
          fehler(error,GETTEXT("modify of read-only data"));
        }
  #else
    #define IMM_TYPECASES
    #define fehler_immutable()
  #endif

#if defined(IMMUTABLE) && !defined(GENERATIONAL_GC)
  nonreturning_function(local, fehler_cannot_remap_immutable_objects_read_only, (void));
  local void fehler_cannot_remap_immutable_objects_read_only ()
    {
      //: DEUTSCH ""
      //: ENGLISH "Cannot remap immutable objects read-only."
      //: FRANCAIS ""
      asciz_out(GETTEXT("Cannot remap immutable objects read-only."));
      errno_out(errno);
      quit_sofort(1);
    }

  nonreturning_function(local, fehler_cannot_remap_immutable_objects_read_write, (void));
  local void fehler_cannot_remap_immutable_objects_read_write ()
    { 
      //: DEUTSCH ""
      //: ENGLISH "Cannot remap immutable objects read/write."
      //: FRANCAIS ""
      asciz_out(GETTEXT("Cannot remap immutable objects read/write."));
      errno_out(errno);
      quit_sofort(1);
    }
#endif

#ifdef MULTIMAP_MEMORY_VIA_FILE

  # Debug level for tempfile: 0 = remove file immediately
  #                           1 = filename depends on process id
  #                           2 = reuse file next time
  #define TEMPFILE_DEBUG_LEVEL  0

  local char tempfilename[MAXPATHLEN]; # Name eines temporären Files
  local int zero_fd; # Handle von /dev/zero
  # Zugriff auf /dev/zero: /dev/zero hat manchmal Permissions 0644. Daher
  # OPEN() mit nur O_RDONLY statt O_RDWR. Daher MAP_PRIVATE statt MAP_SHARED.

  local int initmap (char* tmpdir);
  local int initmap(tmpdir)
    var reg3 char* tmpdir;
    # Virtual Memory Mapping aufbauen:
    { # Wir brauchen ein temporäres File.
      # tempfilename := (string-concat tmpdir "/" "lisptemp.mem")
      {var reg1 char* ptr1 = tmpdir;
       var reg2 char* ptr2 = &tempfilename[0];
       while (!(*ptr1 == '\0')) { *ptr2++ = *ptr1++; }
       if (!((ptr2 > &tempfilename[0]) && (ptr2[-1] == '/')))
         { *ptr2++ = '/'; }
       ptr1 = "lisptemp.mem";
       while (!(*ptr1 == '\0')) { *ptr2++ = *ptr1++; }
       #if (TEMPFILE_DEBUG_LEVEL > 0)
       *ptr2++ = '.';
       #if (TEMPFILE_DEBUG_LEVEL == 1)
       { unsigned int pid = getpid();
         *ptr2++ = ((pid >> 12) & 0x0f) + 'a';
         *ptr2++ = ((pid >> 8) & 0x0f) + 'a';
         *ptr2++ = ((pid >> 4) & 0x0f) + 'a';
         *ptr2++ = (pid & 0x0f) + 'a';
       }
       #endif
       *ptr2++ = '0';
       #endif
       *ptr2 = '\0';
      }
      { var reg1 int fd = OPEN("/dev/zero",O_RDONLY,my_open_mask);
        if (fd<0)
          { 
            //: DEUTSCH "Kann /dev/zero nicht öffnen." 
            //: ENGLISH "Cannot open /dev/zero ."
            //: FRANCAIS "Ne peux pas ouvrir /dev/zero ." 
            asciz_out(GETTEXT("cannot open /dev/zero"));
            errno_out(errno);
            return -1; # error
          }
        zero_fd = fd;
      }
      return 0;
    }

  #ifdef HAVE_MSYNC
    typedef struct { void* mm_addr; uintL mm_len; } mmap_interval;
    local mmap_interval mmap_intervals[256]; # 256 ist reichlich.
    local mmap_interval* mmap_intervals_ptr = &mmap_intervals[0];
    local void msync_mmap_intervals (void);
    local void msync_mmap_intervals()
      { var reg1 mmap_interval* ptr = &mmap_intervals[0];
        until (ptr==mmap_intervals_ptr)
          { if (msync((MMAP_ADDR_T)ptr->mm_addr,ptr->mm_len,MS_INVALIDATE) < 0)
              { asciz_out("msync(0x"); hex_out(ptr->mm_addr); asciz_out(",0x");
                hex_out(ptr->mm_len); asciz_out(",MS_INVALIDATE)");
                asciz_out(DEUTSCH ? " scheitert." :
                          ENGLISH ? " fails." :
                          FRANCAIS ? " - erreur." :
                          ""
                         );
                errno_out(errno);
              }
            ptr++;
      }   }
  #else
     #define msync_mmap_intervals()
  #endif

  local int fdmap (int fd, void* map_addr, uintL map_len, int readonly, int shared);
  local int fdmap(fd,map_addr,map_len,readonly,shared)
    var reg3 int fd;
    var reg1 void* map_addr;
    var reg2 uintL map_len;
    var reg4 int readonly;
    var reg5 int shared;
    { if ( (void*) mmap(map_addr, # gewünschte Adresse
                        map_len, # Länge
                        readonly ? PROT_READ : PROT_READ | PROT_WRITE, # Zugriffsrechte
                        (shared ? MAP_SHARED : 0) | MAP_FIXED, # genau an diese Adresse!
                        fd, 0 # File ab Position 0 legen
                       )
           == (void*)(-1)
         )
        { 
          //: DEUTSCH "Kann keinen Speicher an Adresse 0x" 
          //: ENGLISH "Cannot map memory to address 0x"
          //: FRANCAIS "Ne peux pas placer de la mémoire à l'adresse 0x" 
          asciz_out(GETTEXT("cannot map memory to address 0x"));
          hex_out(map_addr);
          //: DEUTSCH " legen."
          //: ENGLISH " ." 
          //: FRANCAIS " ."
          asciz_out(GETTEXT("[end]cannot map to address 0x"));
          errno_out(errno);
          return -1; # error
        }
      #ifdef HAVE_MSYNC
      mmap_intervals_ptr->mm_addr = map_addr; mmap_intervals_ptr->mm_len = map_len;
      mmap_intervals_ptr++;
      #endif
      return 0;
    }

  local int zeromap (void* map_addr, uintL map_len);
  local int zeromap(map_addr,map_len)
    var reg1 void* map_addr;
    var reg2 uintL map_len;
    { return fdmap(zero_fd,map_addr,map_len,FALSE,FALSE); }

  local int open_temp_fd (uintL map_len);
  local int open_temp_fd(map_len)
    var reg2 uintL map_len;
    { var reg1 int fd;
      #if (TEMPFILE_DEBUG_LEVEL > 0)
      tempfilename[strlen(tempfilename)-1]++;
      #endif
      #if (TEMPFILE_DEBUG_LEVEL <= 1)
      fd = OPEN(tempfilename,O_RDWR|O_CREAT|O_TRUNC|O_EXCL,my_open_mask);
      #else
      fd = OPEN(tempfilename,O_RDWR|O_CREAT,my_open_mask);
      #endif
      if (fd<0)
        {
          //: DEUTSCH "Kann "
          //: ENGLISH "Cannot open " 
          //: FRANCAIS "Ne peux pas ouvrir "
          asciz_out(GETTEXT("cannot open"));
          asciz_out(tempfilename);

          //: DEUTSCH " nicht öffnen."
          //: ENGLISH " ."
          //: FRANCAIS " ."
          asciz_out(GETTEXT("[end]cannot open"));
          errno_out(errno);
          return -1; # error
        }
      #if (TEMPFILE_DEBUG_LEVEL == 0)
      # und öffentlich unzugänglich machen, indem wir es löschen:
      # (Das Betriebssystem löscht das File erst dann, wenn am Ende dieses
      # Prozesses in _exit() ein close(fd) durchgeführt wird.)
      if ( unlink(tempfilename) <0)
        { 
          //: DEUTSCH "Kann "
          //: ENGLISH "Cannot delete "
          //: FRANCAIS "Ne peux pas effacer "
          asciz_out(GETTEXT("cannot delete"));
          asciz_out(tempfilename);
          //: DEUTSCH " nicht löschen."
          //: ENGLISH " ."
          //: FRANCAIS " ."
          asciz_out(GETTEXT("[end]cannot delete"));
          errno_out(errno);
          return -1; # error
        }
      #endif
      # überprüfen, ob genug Plattenplatz da ist:
      { var struct statfs statbuf;
        if (!( fstatfs(fd,&statbuf) <0))
          if (!(statbuf.f_bsize == (long)(-1)) && !(statbuf.f_bavail == (long)(-1)))
            { var reg2 uintL available = (uintL)(statbuf.f_bsize) * (uintL)(statbuf.f_bavail);
              if (available < map_len)
                # auf der Platte ist voraussichtlich zu wenig Platz
                { 
                  //: DEUTSCH "** WARNUNG: ** Zu wenig freier Plattenplatz für "
                  //: ENGLISH "** WARNING: ** Not enough free disk space for "
                  //: FRANCAIS "** AVERTISSEMENT : ** Trop peu de place disque restante sur "
                  asciz_out(GETTEXT("out of disk space"));
                  asciz_out(tempfilename);
                  //: DEUTSCH  " ."
                  //: ENGLISH  " ."
                  //: FRANCAIS " ."
                  asciz_out(GETTEXT("[end]out of disk space"));
                  asciz_out(CRLFstring);
                  //: DEUTSCH "Bitte LISP mit weniger Speicher (Option -m) neu starten."
                  //: ENGLISH "Please restart LISP with less memory (option -m)."
                  //: FRANCAIS "Prière de relancer LISP avec moins de mémoire (option -m)."
                  asciz_out(GETTEXT("restart with less memory"));
                  asciz_out(CRLFstring);
      }     }   }
      # Auf Größe map_len aufblähen:
      { var uintB dummy = 0;
        if (( lseek(fd,map_len-1,SEEK_SET) <0) || (!( full_write(fd,&dummy,1) ==1)))
          { 
            //: DEUTSCH "Kann "
            //: ENGLISH "Cannot make "
            //: FRANCAIS "Ne peux pas agrandir "
            asciz_out(GETTEXT("cannot make file long enough"));
            asciz_out(tempfilename);
            //: DEUTSCH " nicht aufblähen." 
            //: ENGLISH " long enough." 
            //: FRANCAIS " ." 
            asciz_out(GETTEXT("[end]cannot make file long enough"));
            errno_out(errno);
            return -1; # error
      }   }
      return fd;
    }

  #if !defined(MAP_MEMORY_TABLES)
    # Kopiert den Inhalt des Intervalls [map_addr..map_addr+map_len-1] ins File.
    local int fdsave (int fd, void* map_addr, uintL map_len);
    local int fdsave(fd,map_addr,map_len)
      var reg2 int fd;
      var reg3 void* map_addr;
      var reg4 uintL map_len;
      { if (( lseek(fd,0,SEEK_SET) <0) || (!( full_write(fd,map_addr,map_len) == map_len)))
          { 
            //: DEUTSCH "Kann "
            //: ENGLISH "Cannot fill "
            //: FRANCAIS "Ne peux pas remplir "
            asciz_out(GETTEXT("cannot fill file"));
            asciz_out(tempfilename);
            //: DEUTSCH " nicht füllen."
            //: ENGLISH " ."
            //: FRANCAIS " ."
            asciz_out(GETTEXT("[end]cannot fill file"));
            errno_out(errno);
            return -1; # error
          }
        return 0;
      }
  #else
    #define fdsave(fd,map_addr,map_len)  0
  #endif

  local int close_temp_fd (int fd);
  local int close_temp_fd(fd)
    var reg1 int fd;
    { if ( CLOSE(fd) <0)
        {
          //: DEUTSCH "Kann " 
          //: ENGLISH "Cannot close " 
          //: FRANCAIS "Ne peux pas fermer " 
          asciz_out(GETTEXT("cannot close"));
          asciz_out(tempfilename);
          //: DEUTSCH " nicht schließen."
          //: ENGLISH " ."
          //: FRANCAIS " ."
          asciz_out(GETTEXT("[end]cannot close"));
          errno_out(errno);
          return -1; # error
        }
      return 0;
    }

  # Vorgehen bei multimap:
  # 1. Temporäres File aufmachen
    #define open_mapid(map_len)  open_temp_fd(map_len) # -> fd
  # 2. File mehrfach überlagert in den Speicher legen
    #define map_mapid(fd,map_addr,map_len,readonly)  fdmap(fd,map_addr,map_len,readonly,TRUE)
  # 3. File schließen
  # (Das Betriebssystem schließt und löscht das File erst dann, wenn am
  # Ende dieses Prozesses in _exit() ein munmap() durchgeführt wird.)
    #define close_mapid(fd)  close_temp_fd(fd)

  #ifndef IMMUTABLE
    #define multimap1(type,typecases,imm_typecases,mapid,map_addr,map_len)  \
      { switch (type)        \
          { typecases        \
              if ( map_mapid(mapid,ThePointer(type_pointer_object(type,map_addr)),map_len,FALSE) <0) \
                goto no_mem; \
              break;         \
            default: break;  \
      }   }
  #else
    #ifndef GENERATIONAL_GC
      #define multimap1(type,typecases,imm_typecases,mapid,map_addr,map_len)  \
        { var reg3 int readonly;                            \
          switch (type)                                     \
            { typecases                                     \
                switch (type)                               \
                  { imm_typecases  readonly = TRUE; break;  \
                    default:       readonly = FALSE; break; \
                  }                                         \
                if ( map_mapid(mapid,ThePointer(type_pointer_object(type,map_addr)),map_len,readonly) <0) \
                  goto no_mem;                              \
                break;                                      \
              default: break;                               \
        }   }
    #else
      #define multimap1(type,typecases,imm_typecases,mapid,map_addr,map_len)  \
        { switch (type)                                     \
            { typecases                                     \
                if ( map_mapid(mapid,ThePointer(type_pointer_object(type,map_addr)),map_len,FALSE) <0) \
                  goto no_mem;                              \
                switch (type)                               \
                  { imm_typecases                           \
                      xmprotect((aint)ThePointer(type_pointer_object(type,map_addr)),map_len,PROT_READ); \
                      break;                                \
                    default:                                \
                      break;                                \
                  }                                         \
                break;                                      \
              default: break;                               \
        }   }
    #endif
  #endif

  #if !defined(IMMUTABLE) || defined(GENERATIONAL_GC)
    #define done_mapid(imm_flag,mapid,map_addr,map_len)  \
      if ( close_mapid(mapid) <0) \
        goto no_mem;
    #define immutable_off()
    #define immutable_on()
    #define exitmap()  msync_mmap_intervals()
  #else # defined(IMMUTABLE) && !defined(GENERATIONAL_GC)
    typedef struct { int mm_mapid; aint mm_addr; uintL mm_len; } mmapping;
    local mmapping bigblock[1];
    local mmapping* bigblock_ptr = &bigblock[0];
    #define done_mapid(imm_flag,mapid,map_addr,map_len)  \
      if (imm_flag)                     \
        { bigblock[0].mm_mapid = mapid; \
          bigblock[0].mm_addr = map_addr; bigblock[0].mm_len = map_len; \
          bigblock_ptr++;               \
        }                               \
        else                            \
        { if ( close_mapid(mapid) <0)   \
            goto no_mem;                \
        }

    local void immutable_off (void);
    local void immutable_off()
      { var reg1 tint* tptr = &imm_types[0];
        var reg2 uintC count;
        dotimesC(count,imm_types_count,
          { var reg3 void* map_addr = ThePointer(type_pointer_object(*tptr,bigblock[0].mm_addr));
            if (map_mapid(bigblock[0].mm_mapid,map_addr,bigblock[0].mm_len,FALSE) <0)
              fehler_cannot_remap_immutable_objects_read_write();
            tptr++;
          });
      }

    local void immutable_on (void);
    local void immutable_on()
      { var reg1 tint* tptr = &imm_types[0];
        var reg2 uintC count;
        dotimesC(count,imm_types_count,
          { var reg3 void* map_addr = ThePointer(type_pointer_object(*tptr,bigblock[0].mm_addr));
            if (map_mapid(bigblock[0].mm_mapid,map_addr,bigblock[0].mm_len,TRUE) <0)
              fehler_cannot_remap_immutable_objects_read_only();
            tptr++;
          });
      }
    #define exitmap()  \
      { if (!(bigblock_ptr == &bigblock[0])) \
          close_mapid(bigblock[0].mm_mapid); \
        msync_mmap_intervals();              \
      }
  #endif

  #define multimap(typecases,imm_typecases,imm_flag,map_addr,map_len,save_flag)  \
    { # Temporäres File aufmachen:                            \
      var reg2 int mapid = open_mapid(map_len);               \
      if (mapid<0) goto no_mem;                               \
      if (save_flag) { if ( fdsave(mapid,(void*)map_addr,map_len) <0) goto no_mem; } \
      # und mehrfach überlagert in den Speicher legen:        \
      { var reg1 oint type;                                   \
        for (type=0; type < typecount; type++)                \
          { multimap1(type,typecases,imm_typecases,mapid,map_addr,map_len); } \
      }                                                       \
      # und evtl. öffentlich unzugänglich machen:             \
      done_mapid(imm_flag,mapid,map_addr,map_len);            \
    }

#endif # MULTIMAP_MEMORY_VIA_FILE

#ifdef MULTIMAP_MEMORY_VIA_SHM

# Virtual Memory Mapping über Shared Memory aufbauen:

  local int initmap (void);
  local int initmap()
    {
     #ifdef UNIX_LINUX
      { var struct shminfo shminfo;
        if ( shmctl(0,IPC_INFO,(struct shmid_ds *)&shminfo) <0)
          if (errno==ENOSYS)
            { 
              //: DEUTSCH "Compilieren Sie Ihr Betriebssystem neu mit Unterstützung von SYSV IPC."
              //: ENGLISH "Recompile your operating system with SYSV IPC support."
              //: FRANCAIS "Recompilez votre système opérationnel tel qu'il comprenne IPC SYSV."
              asciz_out(GETTEXT("need IPC support"));
              asciz_out(CRLFstring);
              return -1; # error
      }     }
     #endif
     return 0;
    }

  local int open_shmid (uintL map_len);
  local int open_shmid(map_len)
    var reg2 uintL map_len;
    { var reg1 int shmid = shmget(IPC_PRIVATE,map_len,0700|IPC_CREAT); # 0700 = 'Read/Write/Execute nur für mich'
      if (shmid<0)
        { 
          //: DEUTSCH "Kann kein privates Shared-Memory-Segment aufmachen." 
          //: ENGLISH "Cannot allocate private shared memory segment." 
          //: FRANCAIS "Ne peux pas allouer de segment privé de mémoire partagée." 
          asciz_out(GETTEXT("cannot allocate private shared memory segment"));
          errno_out(errno);
          return -1; # error
        }
      return shmid;
    }

  #ifndef SHM_REMAP  # Nur UNIX_LINUX benötigt SHM_REMAP in den shmflags
    #define SHM_REMAP  0
  #endif
  local int idmap (int shmid, void* map_addr, int shmflags);
  local int idmap(shmid,map_addr,shmflags)
    var reg2 int shmid;
    var reg1 void* map_addr;
    var reg3 int shmflags;
    { if ( shmat(shmid,
                 map_addr, # Adresse
                 shmflags # Flags (Default: Read/Write)
                )
           == (void*)(-1)
         )
        {
          //: DEUTSCH "Kann kein Shared-Memory an Adresse 0x"
          //: ENGLISH "Cannot map shared memory to address 0x"
          //: FRANCAIS "Ne peux pas placer de la mémoire partagée à l'adresse 0x"
          asciz_out(GETTEXT("cannot map shared memory to address 0x"));
          hex_out(map_addr);
          //: DEUTSCH " legen."
          //: ENGLISH "."
          //: FRANCAIS "."
          asciz_out(GETTEXT("[end]cannot map shared memory to address 0x"));
          errno_out(errno);
          return -1; # error
        }
      return 0;
    }

  #if !defined(MAP_MEMORY_TABLES)
    # Kopiert den Inhalt des Intervalls [map_addr..map_addr+map_len-1] ins
    # Shared-Memory-Segment.
    local int shmsave (int shmid, void* map_addr, uintL map_len);
    local int shmsave(shmid,map_addr,map_len)
      var reg2 int shmid;
      var reg3 void* map_addr;
      var reg4 uintL map_len;
      { var reg1 void* temp_addr = shmat(shmid,
                                         0, # Adresse: beliebig
                                         0 # Flags: brauche keine
                                        );
        if (temp_addr == (void*)(-1))
          { 
            //: DEUTSCH "Kann Shared Memory nicht füllen." 
            //: ENGLISH "Cannot fill shared memory." 
            //: FRANCAIS "Ne peux pas remplir la mémoire partagée." 
            asciz_out(GETTEXT("cannot fill shared memory"));
            errno_out(errno);
            return -1; # error
          }
        memcpy(temp_addr,map_addr,map_len);
        if (shmdt(temp_addr) < 0)
          {
            //: DEUTSCH "Konnte Shared Memory nicht füllen."
            //: ENGLISH "Could not fill shared memory."
            //: FRANCAIS "Ne pouvais pas remplir la mémoire partagée."
            asciz_out(GETTEXT("could not fill shared memory"));
            errno_out(errno);
            return -1; # error
          }
        return 0;
      }
  #else
    #define shmsave(shmid,map_addr,map_len)  0
  #endif

  local int close_shmid (int shmid);
  local int close_shmid(shmid)
    var reg1 int shmid;
    { if ( shmctl(shmid,IPC_RMID,NULL) <0)
        { 
          //: DEUTSCH "Kann Shared-Memory-Segment nicht entfernen."
          //: ENGLISH "Cannot remove shared memory segment."
          //: FRANCAIS "Ne peux pas retirer un segment de mémoire partagée."
          asciz_out(GETTEXT("cannot remove shared memory segment"));
          errno_out(errno);
          return -1; # error
        }
      return 0;
    }

  local int zeromap (void* map_addr, uintL map_len);
  local int zeromap(map_addr,map_len)
    var reg3 void* map_addr;
    var reg2 uintL map_len;
    { var reg1 int shmid = open_shmid(map_len);
      if (shmid<0)
        { return -1; } # error
      if (idmap(shmid,map_addr,0) < 0)
        { return -1; } # error
      return close_shmid(shmid);
    }

  # Vorgehen bei multimap:
  # 1. Shared-Memory-Bereich zur Verfügung stellen
    #define open_mapid(map_len)  open_shmid(map_len) # -> shmid
  # 2. Shared-Memory mehrfach überlagert in den Speicher legen
    #define map_mapid(shmid,map_addr,map_len,flags)  idmap(shmid,map_addr,flags)
  # 3. öffentlich unzugänglich machen, indem wir ihn löschen:
  # (Das Betriebssystem löscht den Shared Memory erst dann, wenn am
  # Ende dieses Prozesses in _exit() ein munmap() durchgeführt wird.)
    #define close_mapid(shmid)  close_shmid(shmid)

  #ifndef IMMUTABLE
    #define multimap1(type,typecases,imm_typecases,mapid,map_addr,map_len)  \
      { switch (type)                                  \
          { typecases                                  \
              if ( map_mapid(mapid, ThePointer(type_pointer_object(type,map_addr)), map_len, \
                             (type==0 ? SHM_REMAP : 0) \
                            )                          \
                   <0                                  \
                 )                                     \
                goto no_mem;                           \
              break;                                   \
            default: break;                            \
      }   }
  #else
    #ifndef GENERATIONAL_GC
      #define multimap1(type,typecases,imm_typecases,mapid,map_addr,map_len)  \
        { var reg6 int readonly;                            \
          switch (type)                                     \
            { typecases                                     \
                switch (type)                               \
                  { imm_typecases  readonly = TRUE; break;  \
                    default:       readonly = FALSE; break; \
                  }                                         \
                if ( map_mapid(mapid, ThePointer(type_pointer_object(type,map_addr)), map_len, \
                               (readonly ? SHM_RDONLY : 0) | (type==0 ? SHM_REMAP : 0) \
                              )                             \
                     <0                                     \
                   )                                        \
                  goto no_mem;                              \
                break;                                      \
              default: break;                               \
        }   }
    #else
      #define multimap1(type,typecases,imm_typecases,mapid,map_addr,map_len)  \
        { switch (type)                                     \
            { typecases                                     \
                if ( map_mapid(mapid, ThePointer(type_pointer_object(type,map_addr)), map_len, \
                               (type==0 ? SHM_REMAP : 0)    \
                              )                             \
                     <0                                     \
                   )                                        \
                  goto no_mem;                              \
                switch (type)                               \
                  { imm_typecases                           \
                      xmprotect((aint)ThePointer(type_pointer_object(type,map_addr)),map_len,PROT_READ); \
                      break;                                \
                    default:                                \
                      break;                                \
                  }                                         \
                break;                                      \
              default: break;                               \
        }   }
    #endif
  #endif

  #if !defined(IMMUTABLE) || defined(GENERATIONAL_GC)
    #define done_mapid(imm_flag,mapid,map_addr,map_len)  \
      if ( close_mapid(mapid) <0) \
        goto no_mem;
    #define immutable_off()
    #define immutable_on()
    #define exitmap()
  #else # defined(IMMUTABLE) && !defined(GENERATIONAL_GC)
    typedef struct { int mm_mapid; aint mm_addr; uintL mm_len; } mmapping;
    local mmapping bigblock[256]; # Hoffentlich reicht 256, da 256*64KB = 2^24 ??
    local mmapping* bigblock_ptr = &bigblock[0];
    # Wann werden Shared-Memory-Segmente freigegeben? Je nachdem,
    # ob shmat() auf einem Shared-Memory-Segment funktioniert, das bereits
    # mit shmctl(..,IPC_RMID,NULL) entfernt wurde, aber noch nattch > 0 hat.
    #ifdef SHM_RMID_VALID # UNIX_LINUX || ...
      #define SHM_RM_atonce  TRUE
      #define SHM_RM_atexit  FALSE
    #else # UNIX_SUNOS4 || ...
      #define SHM_RM_atonce  FALSE
      #define SHM_RM_atexit  TRUE
    #endif
    #define done_mapid(imm_flag,mapid,map_addr,map_len)  \
      if (imm_flag)                                                          \
        { bigblock_ptr->mm_mapid = mapid;                                    \
          bigblock_ptr->mm_addr = map_addr; bigblock_ptr->mm_len = map_len;  \
          bigblock_ptr++;                                                    \
          if (SHM_RM_atonce)                                                 \
            { if ( close_mapid(mapid) <0)                                    \
                goto no_mem;                                                 \
            }                                                                \
        }                                                                    \
        else                                                                 \
        { if ( close_mapid(mapid) <0)                                        \
            goto no_mem;                                                     \
        }
    local void immutable_off (void);
    local void immutable_off()
      { var reg3 tint* tptr = &imm_types[0];
        var reg4 uintC count;
        dotimesC(count,imm_types_count,
          { var reg1 mmapping* ptr = &bigblock[0];
            until (ptr==bigblock_ptr)
              { var reg2 void* map_addr = ThePointer(type_pointer_object(*tptr,ptr->mm_addr));
                if ((shmdt(map_addr) <0) ||
                    (map_mapid(ptr->mm_mapid, map_addr, ptr->mm_len, 0) <0))
                  fehler_cannot_remap_immutable_objects_read_write();
                ptr++;
              }
            tptr++;
          });
      }
    local void immutable_on (void);
    local void immutable_on()
      { var reg3 tint* tptr = &imm_types[0];
        var reg4 uintC count;
        dotimesC(count,imm_types_count,
          { var reg1 mmapping* ptr = &bigblock[0];
            until (ptr==bigblock_ptr)
              { var reg2 void* map_addr = ThePointer(type_pointer_object(*tptr,ptr->mm_addr));
                if ((shmdt(map_addr) <0) ||
                    (map_mapid(ptr->mm_mapid, map_addr, ptr->mm_len, SHM_RDONLY) <0))
                  fehler_cannot_remap_immutable_objects_read_only();
                ptr++;
              }
            tptr++;
          });
      }
    #if SHM_RM_atexit
      #define exitmap()  \
        { var reg1 mmapping* ptr = &bigblock[0];                           \
          until (ptr==bigblock_ptr) { close_mapid(ptr->mm_mapid); ptr++; } \
        }
    #else
      #define exitmap()
    #endif
  #endif

  #define multimap(typecases,imm_typecases,imm_flag,total_map_addr,total_map_len,save_flag)  \
    { var reg4 uintL remaining_len = total_map_len;                                    \
      var reg5 aint map_addr = total_map_addr;                                         \
      do { var reg3 uintL map_len = (remaining_len > SHMMAX ? SHMMAX : remaining_len); \
           # Shared-Memory-Bereich aufmachen:                                          \
           var reg2 int mapid = open_mapid(map_len);                                   \
           if (mapid<0) goto no_mem;                                                   \
           if (save_flag && (map_addr==total_map_addr))                                \
             { if ( shmsave(mapid,(void*)total_map_addr,total_map_len) <0) goto no_mem; } \
           # und mehrfach überlagert in den Speicher legen:                            \
           { var reg1 oint type;                                                       \
             for (type=0; type < typecount; type++)                                    \
               { multimap1(type,typecases,imm_typecases,mapid,map_addr,map_len); }     \
           }                                                                           \
           # und evtl. öffentlich unzugänglich machen:                                 \
           done_mapid(imm_flag,mapid,map_addr,map_len);                                \
           map_addr += map_len; remaining_len -= map_len;                              \
         }                                                                             \
         until (remaining_len==0);                                                     \
    }

#endif # MULTIMAP_MEMORY_VIA_SHM

#endif # MULTIMAP_MEMORY

#if defined(SINGLEMAP_MEMORY) || defined(TRIVIALMAP_MEMORY)

# Das Betriebssystem erlaubt es, an willkürlichen Adressen Speicher hinzulegen,
# der sich genauso benimmt wie malloc()-allozierter Speicher.

# Länge einer Speicherseite des Betriebssystems:
  local /* uintL */ aint map_pagesize; # wird eine Zweierpotenz sein, meist 4096.

# Initialisierung:
# initmap()

# In einen Speicherbereich [map_addr,map_addr+map_len-1] leere Seiten legen:
# (map_addr und map_len durch map_pagesize teilbar.)
# zeromap(map_addr,map_len)

#ifdef HAVE_MACH_VM

  local int initmap (void);
  local int initmap()
    { return 0; }

  local int zeromap (void* map_addr, uintL map_len);
  local int zeromap(map_addr,map_len)
    var void* map_addr;
    var reg1 uintL map_len;
    { if (!(vm_allocate(task_self(), (vm_address_t*) &map_addr, map_len, FALSE)
            == KERN_SUCCESS
         ) )
        { 
          //: DEUTSCH "Kann keinen Speicher an Adresse 0x"
          //: ENGLISH "Cannot map memory to address 0x"
          //: FRANCAIS "Ne peux pas placer de la mémoire à l'adresse 0x" 
          asciz_out(GETTEXT("cannot map memory to address 0x"));
          hex_out(map_addr);
          //: DEUTSCH " legen."
          //: ENGLISH " ." 
          //: FRANCAIS " ."
          asciz_out(GETTEXT("[end]cannot map memory to address 0x"));
          asciz_out(CRLFstring);
          return -1; # error
        }
      return 0;
    }

  # Ein Ersatz für die mmap-Funktion. Nur für Files geeignet.
  #define MAP_FIXED    0
  #define MAP_PRIVATE  0
  global RETMMAPTYPE mmap (addr,len,prot,flags,fd,off)
    var MMAP_ADDR_T addr;
    var MMAP_SIZE_T len;
    var int prot; # sollte PROT_READ | PROT_WRITE sein??
    var int flags; # sollte MAP_FIXED | MAP_PRIVATE sein??
    var int fd; # sollte ein gültiges Handle sein
    var off_t off;
    { switch (vm_allocate(task_self(), (vm_address_t*) &addr, len, FALSE))
        { case KERN_SUCCESS:
            break;
          default:
            errno = EINVAL; return (RETMMAPTYPE)(-1);
        }
      switch (map_fd(fd, off, (vm_address_t*) &addr, 0, len))
        { case KERN_SUCCESS:
            return addr;
          case KERN_INVALID_ADDRESS:
          case KERN_INVALID_ARGUMENT:
          default:
            errno = EINVAL; return (RETMMAPTYPE)(-1);
    }   }

  # Ein Ersatz für die munmap-Funktion.
  global int munmap(addr,len)
    var reg2 MMAP_ADDR_T addr;
    var reg3 MMAP_SIZE_T len;
    { switch (vm_deallocate(task_self(),addr,len))
        { case KERN_SUCCESS:
            return 0;
          case KERN_INVALID_ADDRESS:
          default:
            errno = EINVAL; return -1;
    }   }

  # Ein Ersatz für die mprotect-Funktion.
  global int mprotect(addr,len,prot)
    var reg2 MMAP_ADDR_T addr;
    var reg3 MMAP_SIZE_T len;
    var reg4 int prot;
    { switch (vm_protect(task_self(),addr,len,0,prot))
        { case KERN_SUCCESS:
            return 0;
          case KERN_PROTECTION_FAILURE:
            errno = EACCES; return -1;
          case KERN_INVALID_ADDRESS:
          default:
            errno = EINVAL; return -1;
    }   }

#else

# Beide mmap()-Methoden gleichzeitig anzuwenden, ist unnötig:
#ifdef HAVE_MMAP_ANON
  #undef HAVE_MMAP_DEVZERO
#endif

#ifdef HAVE_MMAP_DEVZERO
  local int zero_fd; # Handle von /dev/zero
  # Zugriff auf /dev/zero: /dev/zero hat manchmal Permissions 0644. Daher
  # OPEN() mit nur O_RDONLY statt O_RDWR. Daher MAP_PRIVATE statt MAP_SHARED.
  #ifdef MAP_FILE
    #define map_flags  MAP_FILE | MAP_PRIVATE
  #else
    #define map_flags  MAP_PRIVATE
  #endif
#endif
#ifdef HAVE_MMAP_ANON
  #define zero_fd  -1 # irgendein ungültiges Handle geht!
  #define map_flags  MAP_ANON | MAP_PRIVATE
#endif

  local int initmap (void);
  local int initmap()
    {
      #ifdef HAVE_MMAP_DEVZERO
      { var reg1 int fd = OPEN("/dev/zero",O_RDONLY,my_open_mask);
        if (fd<0)
          { 
            //: DEUTSCH "Kann /dev/zero nicht öffnen."
            //: ENGLISH "Cannot open /dev/zero ."
            //: FRANCAIS "Ne peux pas ouvrir /dev/zero ."
            asciz_out(GETTEXT("cannot open /dev/zero"));
            errno_out(errno);
            return -1; # error
          }
        zero_fd = fd;
      }
      #endif
      return 0;
    }

  local int zeromap (void* map_addr, uintL map_len);
  local int zeromap(map_addr,map_len)
    var reg1 void* map_addr;
    var reg2 uintL map_len;
    { if ( (void*) mmap(map_addr, # gewünschte Adresse
                        map_len, # Länge
                        PROT_READ | PROT_WRITE, # Zugriffsrechte
                        map_flags | MAP_FIXED, # genau an diese Adresse!
                        zero_fd, 0 # leere Seiten legen
                       )
           == (void*)(-1)
         )
        { 
          //: DEUTSCH "Kann keinen Speicher an Adresse 0x"
          //: ENGLISH "Cannot map memory to address 0x"
          //: FRANCAIS "Ne peux pas placer de la mémoire à l'adresse 0x"
          asciz_out(GETTEXT("cannot map memory to address 0x"));
          hex_out(map_addr);
          //: DEUTSCH " legen." 
          //: ENGLISH " ." 
          //: FRANCAIS " ."
          asciz_out(GETTEXT("[end]cannot map memory to address 0x"));
          errno_out(errno);
          return -1; # error
        }
      return 0;
    }

#endif # HAVE_MACH_VM

# Immutable Objekte gibt es nicht.
  #define fehler_immutable()

#endif # SINGLEMAP_MEMORY || TRIVIALMAP_MEMORY

# ------------------------------------------------------------------------------
#                           Page-Verwaltung

# Page-Deskriptor:
typedef struct { aint start;   # Pointer auf den belegten Platz (aligned)
                 aint end;     # Pointer hinter den belegten Platz (aligned)
                 union { object firstmarked; uintL l; aint d; void* next; }
                       gcpriv; # private Variable während GC
               }
        _Page;

# Page-Deskriptor samt dazugehöriger Verwaltungsinformation:
# typedef ... Page;
# Hat die Komponenten page_start, page_end, page_gcpriv.

# Eine Ansammlung von Pages:
# typedef ... Pages;

# Eine Ansammlung von Pages und die für sie nötige Verwaltungsinformation:
# typedef ... Heap;

#ifdef SPVW_PAGES

#if !defined(VIRTUAL_MEMORY) || defined(BROKEN_MALLOC)
# Jede Page enthält einen Header für die AVL-Baum-Verwaltung.
# Das erlaubt es, daß die AVL-Baum-Verwaltung selbst keine malloc-Aufrufe
# tätigen muß.
#else # defined(VIRTUAL_MEMORY) && !defined(BROKEN_MALLOC)
# Bei Virtual Memory ist es schlecht, wenn die GC alle Seiten anfassen muß.
# Daher sei die AVL-Baum-Verwaltung separat.
#define AVL_SEPARATE
#endif

#define AVLID  spvw
#define AVL_ELEMENT  uintL
#define AVL_EQUAL(element1,element2)  ((element1)==(element2))
#define AVL_KEY  AVL_ELEMENT
#define AVL_KEYOF(element)  (element)
#define AVL_COMPARE(key1,key2)  (sintL)((key1)-(key2))
#define NO_AVL_MEMBER
#define NO_AVL_INSERT
#define NO_AVL_DELETE

#include "avl.c"

typedef struct NODE
               { NODEDATA nodedata;        # NODE für AVL-Baum-Verwaltung
                 #define page_room  nodedata.value # freier Platz in dieser Page (in Bytes)
                 _Page page;       # Page-Deskriptor, bestehend aus:
                 #define page_start  page.start  # Pointer auf den belegten Platz (aligned)
                 #define page_end    page.end    # Pointer auf den freien Platz (aligned)
                 #define page_gcpriv page.gcpriv # private Variable während GC
                 aint m_start;     # von malloc gelieferte Startadresse (unaligned)
                 aint m_length;    # bei malloc angegebene Page-Länge (in Bytes)
               }
        NODE;
#define HAVE_NODE

#if !defined(AVL_SEPARATE)
  # NODE innerhalb der Seite
  #define sizeof_NODE  sizeof(NODE)
  #define page_start0(page)  round_up((aint)page+sizeof(NODE),varobject_alignment)
  #define free_page(page)  begin_system_call(); free((void*)page->m_start); end_system_call();
#else
  # NODE extra
  #define sizeof_NODE  0
  #define page_start0(page)  round_up(page->m_start,varobject_alignment)
  #define free_page(page)  begin_system_call(); free((void*)page->m_start); free((void*)page); end_system_call();
#endif

#include "avl.c"

typedef NODE Page;

typedef Page* Pages;

typedef struct { Pages inuse;     # Die gerade benutzten Pages
                 # _Page reserve; # Eine Reserve-Page ??
                 # Bei Heap für Objekte fester Länge:
                 Pages lastused; # Ein Cache für die letzte benutzte Page
               }
        Heap;

# Größe einer normalen Page = minimale Pagegröße. Durch sizeof(cons_) teilbar.
  # Um offset_pages_len (s.u.) nicht zu groß werden zu lassen, darf die
  # Pagegröße nicht zu klein sein.
  #if (oint_addr_len<=32)
    #define oint_addr_relevant_len  oint_addr_len
  #else
    #if defined(DECALPHA) && defined(UNIX_OSF)
      # Alle Adressen liegen zwischen 1*2^32 und 2*2^32. Also faktisch doch
      # nur ein Adreßraum von 2^32.
      #define oint_addr_relevant_len  32
    #endif
  #endif
  #define min_page_size_brutto  bit(oint_addr_relevant_len/2)
  #define std_page_size  round_down(min_page_size_brutto-sizeof_NODE-(varobject_alignment-1),sizeof(cons_))

# Eine Dummy-Page für lastused:
  local NODE dummy_NODE;
  #define dummy_lastused  (&dummy_NODE)

#endif

#ifdef SPVW_BLOCKS

typedef _Page Page;
#define page_start   start
#define page_end     end
#define page_gcpriv  gcpriv

typedef Page Pages;

#ifdef GENERATIONAL_GC
# Für jede physikalische Speicherseite der alten Generation merken wir uns,
# um auf diese Seite nicht zugreifen zu müssen, welche Pointer auf Objekte
# der neuen Generation diese enthält.
# Solange man auf die Seite nicht schreibend zugreift, bleibt diese Information
# aktuell. Nachdem man auf die Seite aber schreibend zugegriffen hat, muß man
# diese Information bei der nächsten GC neu erstellen. Dies sollte man aber
# machen, ohne auf die Seite davor oder danach zugreifen zu müssen.
typedef struct { object* p; # Adresse des Pointers, innerhalb eines alten Objekts
                 object o;  # o = *p, Pointer auf ein neues Objekt
               }
        old_new_pointer;
typedef struct { # Durchlaufen der Pointer in der Seite benötigt Folgendes:
                   # Fortsetzung des letzten Objekts der Seite davor:
                   object* continued_addr;
                   uintC continued_count;
                   # Erstes Objekt, das in dieser Seite (oder später) beginnt:
                   aint firstobject;
                 # Der Cache der Pointer auf Objekte der neuen Generation:
                 int protection; # PROT_NONE : Nur der Cache ist gültig.
                                 # PROT_READ : Seite und Cache beide gültig.
                                 # PROT_READ_WRITE : Nur die Seite ist gültig.
                 uintL cache_size; # Anzahl der gecacheten Pointer
                 old_new_pointer* cache; # Cache aller Pointer in die neue
                                         # Generation
               }
        physpage_state;
#endif

typedef struct { Pages pages;
                 #ifndef SPVW_MIXED_BLOCKS_OPPOSITE
                 # d.h. SPVW_PURE_BLOCKS || (SPVW_MIXED_BLOCKS && TRIVIALMAP_MEMORY)
                 aint heap_limit;
                 #endif
                 #ifdef GENERATIONAL_GC
                 aint heap_gen0_start;
                 aint heap_gen0_end;
                 aint heap_gen1_start;
                 physpage_state* physpages;
                 #endif
               }
        Heap;
#define heap_start  pages.page_start
#define heap_end    pages.page_end
#ifndef SPVW_MIXED_BLOCKS_OPPOSITE
# Stets heap_start <= heap_end <= heap_limit.
# Der Speicher zwischen heap_start und heap_end ist belegt,
# der Speicher zwischen heap_end und heap_limit ist frei.
# heap_limit wird, wenn nötig, vergrößert.
#else
# Stets heap_start <= heap_end.
# Der Speicher zwischen heap_start und heap_end ist belegt,
#endif
#ifdef GENERATIONAL_GC
#ifndef SPVW_MIXED_BLOCKS_OPPOSITE
# Die Generation 0 (ältere Generation) beginnt bei heap_gen0_start,
#                                      geht bis    heap_gen0_end.
# Die Generation 1 (neuere Generation) beginnt bei heap_gen1_start,
#                                      geht bis    heap_end.
# heap_gen0_start und heap_gen1_start sind durch physpagesize teilbar.
# Zwischen heap_gen0_end und heap_gen1_start ist eine Lücke von weniger als
# einer Page.
# heap_start ist entweder = heap_gen0_start oder = heap_gen1_start.
#else
# Die Generation 0 (ältere Generation) beginnt bei heap_gen0_start,
#                                      geht bis    heap_gen0_end.
# Bei mem.varobjects:
#   Generation 1 (neuere Generation) beginnt bei heap_gen1_start,
#                                    geht bis    heap_end.
#   heap_gen0_start und heap_gen1_start sind durch physpagesize teilbar.
#   Zwischen heap_gen0_end und heap_gen1_start ist eine Lücke von weniger als
#   einer Page.
#   heap_start ist entweder = heap_gen0_start oder = heap_gen1_start.
# Bei mem.conses:
    #define heap_gen1_end  heap_gen1_start
#   Generation 1 (neuere Generation) beginnt bei heap_start,
#                                    geht bis    heap_gen1_end.
#   heap_gen1_end und heap_gen0_end sind durch physpagesize teilbar.
#   Zwischen heap_gen1_end und heap_gen0_start ist eine Lücke von weniger als
#   einer Page.
#   heap_end ist entweder = heap_gen1_end oder = heap_gen0_end.
#endif
# Der Status von Adresse addr (heap_gen0_start <= addr < heap_gen0_end) wird
# von physpages[(addr>>physpageshift)-(heap_gen0_start>>physpageshift)] gegeben.
# physpages=NULL ist möglich, wenn nicht genügend Platz da war!
#endif

#endif

#ifdef SPVW_MIXED

# Zwei Heaps: einer für Objekte variabler Länge, einer für Conses u.ä.
#define heapcount  2

#endif

#ifdef SPVW_PURE

# Ein Heap für jeden möglichen Typcode
#define heapcount  typecount

#endif

# Für jeden möglichen Heap (0 <= heapnr < heapcount) den Typ des Heaps feststellen:
# is_cons_heap(heapnr)
# is_varobject_heap(heapnr)
# is_heap_containing_objects(heapnr)
# is_unused_heap(heapnr)
#ifdef SPVW_MIXED
  #define is_cons_heap(heapnr)  ((heapnr)==1)
  #define is_varobject_heap(heapnr)  ((heapnr)==0)
  #define is_heap_containing_objects(heapnr)  (TRUE)
  #define is_unused_heap(heapnr)  (FALSE)
#endif
#ifdef SPVW_PURE
  #define is_cons_heap(heapnr)  (mem.heaptype[heapnr] == 0)
  #define is_varobject_heap(heapnr)  (mem.heaptype[heapnr] > 0)
  #define is_heap_containing_objects(heapnr)  ((mem.heaptype[heapnr] >= 0) && (mem.heaptype[heapnr] < 2))
  #define is_unused_heap(heapnr)  (mem.heaptype[heapnr] < 0)
#endif

# Durchlaufen aller CONS-Pages:
# for_each_cons_page(page, [statement, das 'var Page* page' benutzt] );

# Durchlaufen aller Pages von Objekten variabler Länge:
# for_each_varobject_page(page, [statement, das 'var Page* page' benutzt] );

# Durchlaufen aller Pages:
# for_each_page(page, [statement, das 'var Page* page' benutzt] );

#ifdef SPVW_BLOCKS
  #define map_heap(heap,pagevar,statement)  \
    { var reg1 Page* pagevar = &(heap).pages; statement; }
#endif
#ifdef SPVW_PAGES
  #define map_heap(heap,pagevar,statement)  \
    { AVL_map((heap).inuse,pagevar,statement); }
#endif

#ifdef SPVW_MIXED

#define for_each_cons_heap(heapvar,statement)  \
  { var reg3 Heap* heapvar = &mem.conses; statement; }
#define for_each_varobject_heap(heapvar,statement)  \
  { var reg3 Heap* heapvar = &mem.varobjects; statement; }
#define for_each_heap(heapvar,statement)  \
  { var reg4 uintL heapnr;                                        \
    for (heapnr=0; heapnr<heapcount; heapnr++)                    \
      { var reg3 Heap* heapvar = &mem.heaps[heapnr]; statement; } \
  }

#define for_each_cons_page(pagevar,statement)  \
  map_heap(mem.conses,pagevar,statement)
#define for_each_cons_page_reversed for_each_cons_page
#define for_each_varobject_page(pagevar,statement)  \
  map_heap(mem.varobjects,pagevar,statement)
#define for_each_page(pagevar,statement)  \
  { var reg4 uintL heapnr;                           \
    for (heapnr=0; heapnr<heapcount; heapnr++)       \
      map_heap(mem.heaps[heapnr],pagevar,statement); \
  }

#endif

#ifdef SPVW_PURE

# Innerhalb der Schleife ist heapnr die Nummer des Heaps.

#define for_each_cons_heap(heapvar,statement)  \
  { var reg4 uintL heapnr;                                          \
    for (heapnr=0; heapnr<heapcount; heapnr++)                      \
      if (mem.heaptype[heapnr] == 0)                                \
        { var reg3 Heap* heapvar = &mem.heaps[heapnr]; statement; } \
  }
#define for_each_varobject_heap(heapvar,statement)  \
  { var reg4 uintL heapnr;                                          \
    for (heapnr=0; heapnr<heapcount; heapnr++)                      \
      if (mem.heaptype[heapnr] > 0)                                 \
        { var reg3 Heap* heapvar = &mem.heaps[heapnr]; statement; } \
  }
#define for_each_heap(heapvar,statement)  \
  { var reg4 uintL heapnr;                                          \
    for (heapnr=0; heapnr<heapcount; heapnr++)                      \
      if (mem.heaptype[heapnr] >= 0)                                \
        { var reg3 Heap* heapvar = &mem.heaps[heapnr]; statement; } \
  }

#define for_each_cons_page(pagevar,statement)  \
  { var reg4 uintL heapnr;                             \
    for (heapnr=0; heapnr<heapcount; heapnr++)         \
      if (mem.heaptype[heapnr] == 0)                   \
        map_heap(mem.heaps[heapnr],pagevar,statement); \
  }
#define for_each_cons_page_reversed(pagevar,statement)  \
  { var reg4 uintL heapnr;                             \
    for (heapnr=heapcount; heapnr-- > 0; )             \
      if (mem.heaptype[heapnr] == 0)                   \
        map_heap(mem.heaps[heapnr],pagevar,statement); \
  }
#define for_each_varobject_page(pagevar,statement)  \
  { var reg4 uintL heapnr;                             \
    for (heapnr=0; heapnr<heapcount; heapnr++)         \
      if (mem.heaptype[heapnr] > 0)                    \
        map_heap(mem.heaps[heapnr],pagevar,statement); \
  }
#define for_each_page(pagevar,statement)  \
  { var reg4 uintL heapnr;                             \
    for (heapnr=0; heapnr<heapcount; heapnr++)         \
      if (mem.heaptype[heapnr] >= 0)                   \
        map_heap(mem.heaps[heapnr],pagevar,statement); \
  }

#endif

# ------------------------------------------------------------------------------

# Speichergrenzen der LISP-Daten:
  local struct { aint MEMBOT;
                 # dazwischen der LISP-Stack
                 Heap heaps[heapcount];
                 #ifdef SPVW_PURE
                 sintB heaptype[heapcount];
                   # zu jedem Typcode: 0 falls Conses u.ä.
                   #                   1 falls Objekte variabler Länge mit Pointern,
                   #                   2 falls Objekte variabler Länge ohne Pointer,
                   #                  -1 falls unbenutzter Typcode
                 #endif
                 #ifdef SPVW_MIXED
                  #define varobjects  heaps[0] # Objekte variabler Länge
                  #define conses      heaps[1] # Conses u.ä.
                 #endif
                 #if defined(SPVW_MIXED_BLOCKS) && defined(GENERATIONAL_GC)
                 sintB heapnr_from_type[typecount]; # Tabelle type -> heapnr
                 #endif
                 #ifdef SPVW_MIXED_BLOCKS_OPPOSITE
                  # dazwischen leer, frei für LISP-Objekte
                 #define MEMRES    conses.heap_end
                 # dazwischen Reserve
                 aint MEMTOP;
                 #endif
                 #if defined(SPVW_PURE_BLOCKS) || defined(TRIVIALMAP_MEMORY) || defined(GENERATIONAL_GC)
                 uintL total_room; # wieviel Platz belegt werden darf, ohne daß GC nötig wird
                 #ifdef GENERATIONAL_GC
                 boolean last_gc_full; # ob die letzte GC eine volle war
                 uintL last_gcend_space0; # wieviel Platz am Ende der letzten GC belegt war
                 uintL last_gcend_space1; # (von Generation 0 bzw. Generation 1)
                 #endif
                 #endif
                 #ifdef SPVW_PAGES
                 Pages free_pages; # eine Liste freier normalgroßer Pages
                 uintL total_space; # wieviel Platz die belegten Pages überhaupt enthalten
                 uintL used_space; # wieviel Platz gerade belegt ist
                 uintL last_gcend_space; # wieviel Platz am Ende der letzten GC belegt war
                 boolean last_gc_compacted; # ob die letzte GC schon kompaktiert hat
                 uintL gctrigger_space; # wieviel Platz belegt werden darf, bis die nächste GC nötig wird
                 #endif
               }
        mem;
  #if defined(SPVW_MIXED_BLOCKS_OPPOSITE) && !defined(GENERATIONAL_GC)
    #define RESERVE       0x00800L  # 2 KByte Speicherplatz als Reserve
  #else
    #define RESERVE             0   # brauche keine präallozierte Reserve
  #endif
  #define MINIMUM_SPACE 0x10000L  # 64 KByte als minimaler Speicherplatz
                                  #  für LISP-Daten

# Stack-Grenzen:
  global void* SP_bound;    # SP-Wachstumsgrenze
  global void* STACK_bound; # STACK-Wachstumsgrenze
  #if defined(EMUNIX) && defined(WINDOWS)
    global void* SP_start;  # SP bei Programmstart
  #endif

# Bei Überlauf eines der Stacks:
  nonreturning_function(global, SP_ueber, (void));
  global void SP_ueber()
    { 
      //: DEUTSCH "Programmstack-Überlauf: RESET"
      //: ENGLISH "Program stack overflow. RESET"
      //: FRANCAIS "Débordement de pile de programme : RAZ"
      err_asciz_out(GETTEXT("program stack overflow"));
      reset();
    }
  nonreturning_function(global, STACK_ueber, (void));
  global void STACK_ueber()
    { 
      //: DEUTSCH "LISP-Stack-Überlauf: RESET"
      //: ENGLISH "Lisp stack overflow. RESET"
      //: FRANCAIS "Débordement de pile Lisp : RAZ"
      asciz_out(GETTEXT("lisp stack overflow"));
      reset();
    }

# Überprüfung des Speicherinhalts auf GC-Festigkeit:
  #if defined(SPVW_PAGES) && defined(DEBUG_SPVW)
    # Überprüfen, ob die Verwaltung der Pages in Ordnung ist:
      #define CHECK_AVL_CONSISTENCY()  check_avl_consistency()
      local void check_avl_consistency (void);
      local void check_avl_consistency()
        { var reg4 uintL heapnr;
          for (heapnr=0; heapnr<heapcount; heapnr++)
            { AVL(AVLID,check) (mem.heaps[heapnr].inuse); }
        }
    # Überprüfen, ob die Grenzen der Pages in Ordnung sind:
      #define CHECK_GC_CONSISTENCY()  check_gc_consistency()
      local void check_gc_consistency (void);
      local void check_gc_consistency()
        { for_each_page(page,
            if ((sintL)page->page_room < 0)
              { asciz_out(NLstring);
                //: DEUTSCH "Page bei Adresse 0x"
                //: ENGLISH "Page bei Adresse 0x"
                //: FRANCAIS "Page bei Adresse 0x"
                asciz_out(GETTEXT("Page bei Adresse 0x"));
                hex_out(page);
                //: DEUTSCH " übergelaufen!!"
                //: ENGLISH " übergelaufen!!"
                //: FRANCAIS " übergelaufen!!"
                asciz_out(GETTEXT(" übergelaufen!!"));
                asciz_out(NLstring);
                abort(); 
              }
            if (!(page->page_start == page_start0(page)))
              { asciz_out(NLstring);
                //: DEUTSCH "Page bei Adresse 0x"
                //: ENGLISH "Page bei Adresse 0x"
                //: FRANCAIS "Page bei Adresse 0x"
                asciz_out(GETTEXT("Page bei Adresse 0x"));
                hex_out(page);
                //: DEUTSCH " inkonsistent!!"
                //: ENGLISH " inkonsistent!!"
                //: FRANCAIS " inkonsistent!!"
                asciz_out(GETTEXT(" inkonsistent!!"));
                asciz_out(NLstring);
                abort(); 
              }
            if (!(page->page_end + page->page_room
                  == round_down(page->m_start + page->m_length,varobject_alignment)
               ) )
              {
                asciz_out(NLstring); 
                //: DEUTSCH "Page bei Adresse 0x"
                //: ENGLISH "Page bei Adresse 0x"
                //: FRANCAIS "Page bei Adresse 0x"
                asciz_out(GETTEXT("Page bei Adresse 0x"));
                hex_out(page);
                //: DEUTSCH " inkonsistent!!"
                //: ENGLISH " inkonsistent!!"
                //: FRANCAIS " inkonsistent!!"
                asciz_out(GETTEXT(" inkonsistent!!"));
                asciz_out(NLstring);
                abort(); 
              }
            );
        }
    # Überprüfen, ob während der kompaktierenden GC
    # die Grenzen der Pages in Ordnung sind:
      #define CHECK_GC_CONSISTENCY_2()  check_gc_consistency_2()
      local void check_gc_consistency_2 (void);
      local void check_gc_consistency_2()
        { for_each_page(page,
            if ((sintL)page->page_room < 0)
              { 
                asciz_out(NLstring);
                //: DEUTSCH "Page bei Adresse 0x"
                //: ENGLISH "Page bei Adresse 0x"
                //: FRANCAIS "Page bei Adresse 0x"
                asciz_out(GETTEXT("Page bei Adresse 0x"));
                hex_out(page);
                //: DEUTSCH " übergelaufen!!"
                //: ENGLISH " übergelaufen!!"
                //: FRANCAIS " übergelaufen!!"
                asciz_out(GETTEXT(" übergelaufen!!"));
                asciz_out(NLstring);
                abort();
              }
            if (!(page->page_end + page->page_room - (page->page_start - page_start0(page))
                  == round_down(page->m_start + page->m_length,varobject_alignment)
               ) )
              { asciz_out(NLstring);
                //: DEUTSCH "Page bei Adresse 0x"
                //: ENGLISH "Page bei Adresse 0x"
                //: FRANCAIS "Page bei Adresse 0x"
                asciz_out(GETTEXT("Page bei Adresse 0x"));
                hex_out(page); 
                //: DEUTSCH " inkonsistent!!"
                //: ENGLISH " inkonsistent!!"
                //: FRANCAIS " inkonsistent!!"
                asciz_out(GETTEXT(" inkonsistent!!"));
                asciz_out(NLstring);
                abort(); 
              }
            );
        }
  #else
    #define CHECK_AVL_CONSISTENCY()
    #define CHECK_GC_CONSISTENCY()
    #define CHECK_GC_CONSISTENCY_2()
  #endif
  #ifdef DEBUG_SPVW
    # Überprüfen, ob die Tabellen der Packages halbwegs in Ordnung sind:
      #define CHECK_PACK_CONSISTENCY()  check_pack_consistency()
      global void check_pack_consistency (void);
      global void check_pack_consistency()
        { var reg9 object plist = O(all_packages);
          while (consp(plist))
            { var reg8 object pack = Car(plist);
              var object symtabs[2];
              var uintC i;
              symtabs[0] = ThePackage(pack)->pack_external_symbols;
              symtabs[1] = ThePackage(pack)->pack_internal_symbols;
              for (i = 0; i < 2; i++)
                { var reg6 object symtab = symtabs[i];
                  var reg4 object table = TheSvector(symtab)->data[1];
                  var reg3 uintL index = TheSvector(table)->length;
                  until (index==0)
                    { var reg1 object entry = TheSvector(table)->data[--index];
                      var reg2 uintC count = 0;
                      while (consp(entry))
                        { if (!msymbolp(Car(entry))) abort();
                          entry = Cdr(entry);
                          count++; if (count>=10000) abort();
                }   }   }
              plist = Cdr(plist);
        }   }
  #else
      #define CHECK_PACK_CONSISTENCY()
  #endif

# ------------------------------------------------------------------------------
#                       Speichergröße

# Liefert die Größe des von den LISP-Objekten belegten Platzes.
  global uintL used_space (void);
  #ifdef SPVW_BLOCKS
   #ifdef SPVW_MIXED_BLOCKS_OPPOSITE
    global uintL used_space()
      {
        #if !defined(GENERATIONAL_GC)
          #define Heap_used_space(h)  ((uintL)((h).pages.end - (h).pages.start))
          return Heap_used_space(mem.varobjects) # Platz für Objekte variabler Länge
                 + Heap_used_space(mem.conses); # Platz für Conses
        #else # defined(GENERATIONAL_GC)
          return (uintL)(mem.varobjects.heap_gen0_end - mem.varobjects.heap_gen0_start)
                 + (uintL)(mem.varobjects.heap_end - mem.varobjects.heap_gen1_start)
                 + (uintL)(mem.conses.heap_gen1_end - mem.conses.heap_start)
                 + (uintL)(mem.conses.heap_gen0_end - mem.conses.heap_gen0_start);
        #endif
      }
   #else
    global uintL used_space()
      { var reg4 uintL sum = 0;
        #if !defined(GENERATIONAL_GC)
          for_each_page(page, { sum += page->page_end - page->page_start; } );
        #else # defined(GENERATIONAL_GC)
          for_each_heap(heap,
            { sum += (heap->heap_gen0_end - heap->heap_gen0_start)
                     + (heap->heap_end - heap->heap_gen1_start);
            });
        #endif
        return sum;
      }
   #endif
  #endif
  #ifdef SPVW_PAGES
    #if 0
    global uintL used_space()
      { var reg4 uintL sum = 0;
        for_each_page(page, { sum += page->page_end - page->page_start; } );
        return sum;
      }
    #else
    # Da die Berechnung von used_space() auf jede Page einmal zugreift, was
    # viel Paging bedeuten kann, wird das Ergebnis in mem.used_space gerettet.
    global uintL used_space()
      { return mem.used_space; }
    #endif
  #endif

# Liefert die Größe des für LISP-Objekte noch verfügbaren Platzes.
  global uintL free_space (void);
  #ifdef SPVW_BLOCKS
   #if defined(SPVW_MIXED_BLOCKS_OPPOSITE) && !defined(GENERATIONAL_GC)
    global uintL free_space()
      { return (mem.conses.heap_start-mem.varobjects.heap_end); } # Platz in der großen Lücke
   #else
    global uintL free_space()
      { return mem.total_room; } # Platz, der bis zur nächsten GC verbraucht werden darf
   #endif
  #endif
  #ifdef SPVW_PAGES
    #if 0
    global uintL free_space()
      { var reg4 uintL sum = 0;
        for_each_page(page, { sum += page->page_room; } );
        return sum;
      }
    #else
    # Da die Berechnung von free_space() auf jede Page einmal zugreift, was
    # viel Paging bedeuten kann, wird das Ergebnis mit Hilfe von mem.used_space
    # berechnet.
    global uintL free_space()
      { return mem.total_space - mem.used_space; }
    #endif
  #endif

#ifdef SPVW_PAGES
  # Berechnet mem.used_space und mem.total_space neu.
  # Das check-Flag gibt an, ob dabei mem.used_space gleich bleiben muß.
  local void recalc_space (boolean check);
  local void recalc_space(check)
    var reg6 boolean check;
    { var reg4 uintL sum_used = 0;
      var reg5 uintL sum_free = 0;
      for_each_page(page,
                    { sum_used += page->page_end - page->page_start;
                      sum_free += page->page_room;
                    }
                   );
      if (check)
        { if (!(mem.used_space == sum_used)) abort(); }
        else
        { mem.used_space = sum_used; }
      mem.total_space = sum_used + sum_free;
    }
#endif

# ------------------------------------------------------------------------------
#                   Speicherlängenbestimmung

# Bei allen Objekten variabler Länge (die von links nach rechts wachsen)
# steht (außer während der GC) in den ersten 4 Bytes ein Pointer auf sich
# selbst, bei Symbolen auch noch die Flags.

# Liefert den Typcode eines Objekts variabler Länge an einer gegebenen Adresse:
  #define typecode_at(addr)  mtypecode(((Varobject)(addr))->GCself)
  # oder (äquivalent):
  # define typecode_at(addr)  (((((Varobject)(addr))->header_flags)>>(oint_type_shift%8))&tint_type_mask)
# Fallunterscheidungen nach diesem müssen statt 'case_symbol:' ein
# 'case_symbolwithflags:' enthalten.
  #define case_symbolwithflags  \
    case symbol_type:                                        \
    case symbol_type|bit(constant_bit_t):                    \
    case symbol_type|bit(keyword_bit_t)|bit(constant_bit_t): \
    case symbol_type|bit(special_bit_t):                     \
    case symbol_type|bit(special_bit_t)|bit(constant_bit_t): \
    case symbol_type|bit(special_bit_t)|bit(keyword_bit_t)|bit(constant_bit_t)

# UP, bestimmt die Länge eines LISP-Objektes variabler Länge (in Bytes).
# (Sie ist durch varobject_alignment teilbar.)
  local uintL speicher_laenge (void* addr);
  # Varobject_aligned_size(HS,ES,C) liefert die Länge eines Objekts variabler
  # Länge mit HS=Header-Size, ES=Element-Size, C=Element-Count.
  # Varobject_aligned_size(HS,ES,C) = round_up(HS+ES*C,varobject_alignment) .
    #define Varobject_aligned_size(HS,ES,C)  \
      ((ES % varobject_alignment) == 0               \
       ? # ES ist durch varobject_alignment teilbar  \
         round_up(HS,varobject_alignment) + (ES)*(C) \
       : round_up((HS)+(ES)*(C),varobject_alignment) \
      )
  # Länge eines Objekts, je nach Typ:
    #define size_symbol()  # Symbol \
      round_up( sizeof(symbol_), varobject_alignment)
    #define size_sbvector(length)  # simple-bit-vector \
      ( ceiling( (uintL)(length) + 8*offsetofa(sbvector_,data), 8*varobject_alignment ) \
        * varobject_alignment                                                           \
      )
    #define size_sstring(length)  # simple-string \
      round_up( (uintL)(length) + offsetofa(sstring_,data), varobject_alignment)
    #define size_svector(length)  # simple-vector \
      Varobject_aligned_size(offsetofa(svector_,data),sizeof(object),(uintL)(length))
    #define size_array(size)  # Nicht-simpler Array, mit \
      # size = Dimensionszahl + (1 falls Fill-Pointer) + (1 falls Displaced-Offset) \
      Varobject_aligned_size(offsetofa(array_,dims),sizeof(uintL),(uintL)(size))
    #define size_srecord(length)  # Simple-Record \
      Varobject_aligned_size(offsetofa(record_,recdata),sizeof(object),(uintL)(length))
    #define size_xrecord(length,xlength)  # Extended-Record \
      Varobject_aligned_size(offsetofa(record_,recdata),sizeof(uintB),(sizeof(object)/sizeof(uintB))*(uintL)(length)+(uintL)(xlength))
    #define size_bignum(length)  # Bignum \
      Varobject_aligned_size(offsetofa(bignum_,data),sizeof(uintD),(uintL)(length))
    #ifndef WIDE
    #define size_ffloat()  # Single-Float \
      round_up( sizeof(ffloat_), varobject_alignment)
    #endif
    #define size_dfloat()  # Double-Float \
      round_up( sizeof(dfloat_), varobject_alignment)
    #define size_lfloat(length)  # Long-Float \
      Varobject_aligned_size(offsetofa(lfloat_,data),sizeof(uintD),(uintL)(length))

#ifdef SPVW_MIXED

  local uintL speicher_laenge (addr)
    var reg2 void* addr;
    { switch (typecode_at(addr) & ~bit(garcol_bit_t)) # Typ des Objekts
        { case_symbolwithflags: # Symbol
            return size_symbol();
          case_sbvector: # simple-bit-vector
            return size_sbvector(((Sbvector)addr)->length);
          case_sstring: # simple-string
            return size_sstring(((Sstring)addr)->length);
          case_svector: # simple-vector
            return size_svector(((Svector)addr)->length);
          case_array1: case_obvector: case_ostring: case_ovector:
            # Nicht-simpler Array:
            { var reg2 uintL size;
              size = (uintL)(((Array)addr)->rank);
              if (((Array)addr)->flags & bit(arrayflags_fillp_bit)) { size += 1; }
              if (((Array)addr)->flags & bit(arrayflags_dispoffset_bit)) { size += 1; }
              # size = Dimensionszahl + (1 falls Fill-Pointer) + (1 falls Displaced-Offset)
              return size_array(size);
            }
          case_record: # Record
            if (((Record)addr)->rectype < 0)
              return size_srecord(((Srecord)addr)->reclength);
              else
              return size_xrecord(((Xrecord)addr)->reclength,((Xrecord)addr)->recxlength);
          case_bignum: # Bignum
            return size_bignum(((Bignum)addr)->length);
          #ifndef WIDE
          case_ffloat: # Single-Float
            return size_ffloat();
          #endif
          case_dfloat: # Double-Float
            return size_dfloat();
          case_lfloat: # Long-Float
            return size_lfloat(((Lfloat)addr)->len);
          case_machine:
          case_char:
          case_subr:
          case_system:
          case_fixnum:
          case_sfloat:
          #ifdef WIDE
          case_ffloat:
          #endif
            # Das sind direkte Objekte, keine Pointer.
          /* case_ratio: */
          /* case_complex: */
          default:
            # Das sind keine Objekte variabler Länge.
            /*NOTREACHED*/ abort();
    }   }

  #define var_speicher_laenge_
  #define calc_speicher_laenge(addr)  speicher_laenge((void*)(addr))

#endif # SPVW_MIXED

#ifdef SPVW_PURE

  # spezielle Funktionen für jeden Typ:
  inline local uintL speicher_laenge_symbol (addr) # Symbol
    var reg1 void* addr;
    { return size_symbol(); }
  inline local uintL speicher_laenge_sbvector (addr) # simple-bit-vector
    var reg1 void* addr;
    { return size_sbvector(((Sbvector)addr)->length); }
  inline local uintL speicher_laenge_sstring (addr) # simple-string
    var reg1 void* addr;
    { return size_sstring(((Sstring)addr)->length); }
  inline local uintL speicher_laenge_svector (addr) # simple-vector
    var reg1 void* addr;
    { return size_svector(((Svector)addr)->length); }
  inline local uintL speicher_laenge_array (addr) # nicht-simpler Array
    var reg1 void* addr;
    { var reg2 uintL size;
      size = (uintL)(((Array)addr)->rank);
      if (((Array)addr)->flags & bit(arrayflags_fillp_bit)) { size += 1; }
      if (((Array)addr)->flags & bit(arrayflags_dispoffset_bit)) { size += 1; }
      # size = Dimensionszahl + (1 falls Fill-Pointer) + (1 falls Displaced-Offset)
      return size_array(size);
    }
  inline local uintL speicher_laenge_record (addr) # Record
    var reg1 void* addr;
    { if (((Record)addr)->rectype < 0)
        return size_srecord(((Srecord)addr)->reclength);
        else
        return size_xrecord(((Xrecord)addr)->reclength,((Xrecord)addr)->recxlength);
    }
  inline local uintL speicher_laenge_bignum (addr) # Bignum
    var reg1 void* addr;
    { return size_bignum(((Bignum)addr)->length); }
  #ifndef WIDE
  inline local uintL speicher_laenge_ffloat (addr) # Single-Float
    var reg1 void* addr;
    { return size_ffloat(); }
  #endif
  inline local uintL speicher_laenge_dfloat (addr) # Double-Float
    var reg1 void* addr;
    { return size_dfloat(); }
  inline local uintL speicher_laenge_lfloat (addr) # Long-Float
    var reg1 void* addr;
    { return size_lfloat(((Lfloat)addr)->len); }

  # Tabelle von Funktionen:
  typedef uintL (*speicher_laengen_fun) (void* addr);
  local speicher_laengen_fun speicher_laengen[heapcount];

  local void init_speicher_laengen (void);
  local void init_speicher_laengen()
    { var reg1 uintL heapnr;
      for (heapnr=0; heapnr<heapcount; heapnr++)
        { switch (heapnr)
            { case_symbol:
                speicher_laengen[heapnr] = &speicher_laenge_symbol; break;
              case_sbvector:
                speicher_laengen[heapnr] = &speicher_laenge_sbvector; break;
              case_sstring:
                speicher_laengen[heapnr] = &speicher_laenge_sstring; break;
              case_svector:
                speicher_laengen[heapnr] = &speicher_laenge_svector; break;
              case_array1: case_obvector: case_ostring: case_ovector:
                speicher_laengen[heapnr] = &speicher_laenge_array; break;
              case_record:
                speicher_laengen[heapnr] = &speicher_laenge_record; break;
              case_bignum:
                speicher_laengen[heapnr] = &speicher_laenge_bignum; break;
              #ifndef WIDE
              case_ffloat:
                speicher_laengen[heapnr] = &speicher_laenge_ffloat; break;
              #endif
              case_dfloat:
                speicher_laengen[heapnr] = &speicher_laenge_dfloat; break;
              case_lfloat:
                speicher_laengen[heapnr] = &speicher_laenge_lfloat; break;
              case_machine:
              case_char:
              case_subr:
              case_system:
              case_fixnum:
              case_sfloat:
              #ifdef WIDE
              case_ffloat:
              #endif
                # Das sind direkte Objekte, keine Pointer.
              /* case_ratio: */
              /* case_complex: */
              default:
                # Das sind keine Objekte variabler Länge.
                speicher_laengen[heapnr] = (speicher_laengen_fun)&abort; break;
    }   }   }

  #define var_speicher_laenge_  \
    var reg5 speicher_laengen_fun speicher_laenge_ = speicher_laengen[heapnr];
  #define calc_speicher_laenge(addr)  (*speicher_laenge_)((void*)(addr))

#endif # SPVW_PURE

# ------------------------------------------------------------------------------
#            Hilfsfunktion für den Generational Garbage-Collector

#ifdef GENERATIONAL_GC # impliziert SPVW_PURE_BLOCKS <==> SINGLEMAP_MEMORY
                       # oder       SPVW_MIXED_BLOCKS und TRIVIALMAP_MEMORY
                       # oder       SPVW_MIXED_BLOCKS_OPPOSITE

local /* uintL */ aint physpagesize;  # = map_pagesize
local uintL physpageshift; # 2^physpageshift = physpagesize

typedef enum { handler_failed, handler_immutable, handler_done }
        handle_fault_result;
local handle_fault_result handle_fault (aint address);

# Unterroutine für protection: PROT_NONE -> PROT_READ
local int handle_read_fault (aint address, physpage_state* physpage);
local int handle_read_fault(address,physpage)
  var reg4 aint address;
  var reg3 physpage_state* physpage;
  { # Seite auf den Stand des Cache bringen:
    { var reg2 uintL count = physpage->cache_size;
      if (count > 0)
        { var reg1 old_new_pointer* ptr = physpage->cache;
          #if !defined(NORMAL_MULTIMAP_MEMORY)
          if (mprotect((MMAP_ADDR_T)address, physpagesize, PROT_READ_WRITE) < 0)
            return -1;
          #endif
          dotimespL(count,count, { *(ptr->p) = ptr->o; ptr++; } );
    }   }
    # Seite read-only einblenden:
    #if !defined(MULTIMAP_MEMORY)
    if (mprotect((MMAP_ADDR_T)address, physpagesize, PROT_READ) < 0)
      return -1;
    #else # MULTIMAP_MEMORY
    ASSERT(address == upointer(address));
    #ifdef MINIMAL_MULTIMAP_MEMORY
    if (mprotect((MMAP_ADDR_T)ThePointer(type_pointer_object(machine_type,address)), physpagesize, PROT_READ) < 0)
      return -1;
    if (mprotect((MMAP_ADDR_T)ThePointer(type_pointer_object(imm_type,address)), physpagesize, PROT_READ) < 0)
      return -1;
    #else # NORMAL_MULTIMAP_MEMORY
    { var reg1 uintL type;
      for (type = 0; type < typecount; type++)
        if (mem.heapnr_from_type[type] >= 0) # type in MM_TYPECASES aufgeführt?
          { if (mprotect((MMAP_ADDR_T)ThePointer(type_pointer_object(type,address)), physpagesize, PROT_READ) < 0)
              return -1;
    }     }
    #endif
    #endif
    physpage->protection = PROT_READ;
    return 0;
  }

# Unterroutine für protection: PROT_READ -> PROT_READ_WRITE
local int handle_readwrite_fault (aint address, physpage_state* physpage);
local int handle_readwrite_fault(address,physpage)
  var reg2 aint address;
  var reg1 physpage_state* physpage;
  { # Seite read-write einblenden:
    #if !defined(NORMAL_MULTIMAP_MEMORY)
    if (mprotect((MMAP_ADDR_T)address, physpagesize, PROT_READ_WRITE) < 0)
      return -1;
    #else # NORMAL_MULTIMAP_MEMORY
    ASSERT(address == upointer(address));
    { var reg1 uintL type;
      for (type = 0; type < typecount; type++)
        if (mem.heapnr_from_type[type] >= 0) # type in MM_TYPECASES aufgeführt?
          switch (type)
            { default:
                if (mprotect((MMAP_ADDR_T)ThePointer(type_pointer_object(type,address)), physpagesize, PROT_READ_WRITE) < 0)
                  return -1;
              IMM_TYPECASES # type in IMM_TYPECASES aufgeführt -> bleibt read-only
                break;
    }       }
    #endif
    physpage->protection = PROT_READ_WRITE;
    return 0;
  }

local handle_fault_result handle_fault(address)
  var reg6 aint address;
  { var reg3 uintL heapnr;
    var reg5 object obj = as_object((oint)address << oint_addr_shift);
    var reg4 aint uaddress = canon(address); # hoffentlich = canonaddr(obj);
    #if defined(MULTIMAP_MEMORY) && defined(IMMUTABLE)
    var reg7 boolean is_immutable;
    #ifdef MINIMAL_MULTIMAP_MEMORY
    is_immutable = (as_oint(obj) & bit(immutable_bit_o) ? TRUE : FALSE);
    #else
    switch (typecode(obj))
      { IMM_TYPECASES # Zugriff auf ein immutables Objekt
          is_immutable = TRUE; break;
        default:
          is_immutable = FALSE; break;
      }
    #endif
    #else
    #define is_immutable  0
    #endif
    #ifdef SPVW_PURE_BLOCKS
    heapnr = typecode(obj);
    #elif defined(TRIVIALMAP_MEMORY)
    heapnr = (uaddress >= mem.heaps[1].heap_gen0_start ? 1 : 0);
    #else # SPVW_MIXED_BLOCKS_OPPOSITE
    heapnr = (uaddress >= mem.heaps[1].heap_start ? 1 : 0);
    #endif
    if (!is_heap_containing_objects(heapnr)) goto error1;
    {var reg2 Heap* heap = &mem.heaps[heapnr];
     if (!((heap->heap_gen0_start <= uaddress) && (uaddress < heap->heap_gen0_end)))
       { if (is_immutable) return handler_immutable; else goto error2; }
     if (heap->physpages == NULL)
       { if (is_immutable) return handler_immutable; else goto error3; }
     {var reg1 physpage_state* physpage =
        &heap->physpages[(uaddress>>physpageshift)-(heap->heap_gen0_start>>physpageshift)];
      switch (physpage->protection)
        { case PROT_NONE:
            # protection: PROT_NONE -> PROT_READ
            if (handle_read_fault(uaddress & -physpagesize,physpage) < 0) goto error4;
            return handler_done;
          case PROT_READ:
            # protection: PROT_READ -> PROT_READ_WRITE
            if (is_immutable)
              return handler_immutable; # Schreibzugriff auf ein immutables Objekt
            if (handle_readwrite_fault(uaddress & -physpagesize,physpage) < 0) goto error5;
            return handler_done;
          default:
            if (is_immutable)
              return handler_immutable; # Schreibzugriff auf ein immutables Objekt
            goto error6;
        }
      error4:
        { var int saved_errno = errno;
          asciz_out(CRLFstring);
          //: DEUTSCH "handle_fault error4 ! mprotect(0x"
          //: ENGLISH "handle_fault error4 ! mprotect(0x"
          //: FRANCAIS "handle_fault error4 ! mprotect(0x"
          asciz_out(GETTEXT("handle_fault error4 ! mprotect(0x"));
          hex_out(address & -physpagesize);
          asciz_out(",0x"); hex_out(physpagesize); asciz_out(",...) -> "); errno_out(saved_errno);
        }
        goto error;
      error5:
        { var int saved_errno = errno;
          asciz_out(CRLFstring);
          //: DEUTSCH "handle_fault error5 ! mprotect(0x"
          //: ENGLISH "handle_fault error5 ! mprotect(0x"
          //: FRANCAIS "handle_fault error5 ! mprotect(0x"
          asciz_out(GETTEXT("handle_fault error5 ! mprotect(0x"));
          hex_out(address & -physpagesize); asciz_out(",0x");
          hex_out(physpagesize); asciz_out(","); dez_out(PROT_READ_WRITE);
          asciz_out(") -> "); errno_out(saved_errno);
        }
        goto error;
      error6:
        asciz_out(CRLFstring);
        //: DEUTSCH "handle_fault error6 ! protection = "
        //: ENGLISH "handle_fault error6 ! protection = "
        //: FRANCAIS "handle_fault error6 ! protection = "
        asciz_out(GETTEXT("handle_fault error6 ! protection = "));
        dez_out(physpage->protection);
        goto error;
     }
     error2:
       asciz_out(CRLFstring);
       //: DEUTSCH "handle_fault error2 ! address = 0x"
       //: ENGLISH "handle_fault error2 ! address = 0x"
       //: FRANCAIS "handle_fault error2 ! address = 0x"
       asciz_out(GETTEXT("handle_fault error2 ! address = 0x"));
       hex_out(address); asciz_out(" not in [0x");
       hex_out(heap->heap_gen0_start); asciz_out(",0x");
       hex_out(heap->heap_gen0_end); asciz_out(") !");
       goto error;
     error3:
       asciz_out(CRLFstring);
       //: DEUTSCH "handle_fault error3 !"
       //: ENGLISH "handle_fault error3 !"
       //: FRANCAIS "handle_fault error3 !"
       asciz_out(GETTEXT("handle_fault error3 !"));
       goto error;
    }
    error1:
      asciz_out(CRLFstring);
       //: DEUTSCH "handle_fault error1 !"
       //: ENGLISH "handle_fault error1 !"
       //: FRANCAIS "handle_fault error1 !"
      asciz_out(GETTEXT("handle_fault error1 !"));
      goto error;
    error:
    return handler_failed;
    #undef is_immutable
  }

#ifdef SPVW_MIXED_BLOCKS
# Systemaufrufe wie read() und write() melden kein SIGSEGV, sondern EFAULT.
# handle_fault_range(PROT_READ,start,end) macht einen Adreßbereich lesbar,
# handle_fault_range(PROT_READ_WRITE,start,end) macht ihn schreibbar.
global boolean handle_fault_range (int prot, aint start_address, aint end_address);
global boolean handle_fault_range(prot,start_address,end_address)
  var reg3 int prot;
  var reg6 aint start_address;
  var reg5 aint end_address;
  { 
    #if defined(MULTIMAP_MEMORY) && defined(IMMUTABLE)
    var reg8 boolean is_immutable;
    #ifdef MINIMAL_MULTIMAP_MEMORY
    is_immutable = (((oint)start_address << oint_addr_shift) & bit(immutable_bit_o) ? TRUE : FALSE);
    #else # NORMAL_MULTIMAP_MEMORY
    var reg7 tint type = typecode(as_object((oint)start_address << oint_addr_shift));
    switch (type)
      { IMM_TYPECASES # Zugriff auf ein immutables Objekt
          is_immutable = TRUE; break;
        default:
          is_immutable = FALSE; break;
      }
    #endif
    #else
    #define is_immutable  0
    #endif
    start_address = canon(start_address);
    end_address = canon(end_address);
    if (!(start_address < end_address)) { return TRUE; }
   {var reg4 Heap* heap = &mem.heaps[0]; # varobject_heap
    if ((end_address <= heap->heap_gen0_start) || (heap->heap_gen0_end <= start_address))
      return TRUE; # nichts zu tun, aber seltsam, daß überhaupt ein Fehler kam
    if (heap->physpages == NULL)
      { if (is_immutable) { fehler_immutable(); }
        return FALSE;
      }
    if ((prot & PROT_WRITE) && is_immutable) { fehler_immutable(); }
    { var reg2 aint address;
      for (address = start_address & -physpagesize; address < end_address; address += physpagesize)
        if ((heap->heap_gen0_start <= address) && (address < heap->heap_gen0_end))
          { var reg1 physpage_state* physpage =
              &heap->physpages[(address>>physpageshift)-(heap->heap_gen0_start>>physpageshift)];
            if (!(physpage->protection & PROT_READ) && (prot & PROT_READ_WRITE))
              # protection: PROT_NONE -> PROT_READ
              { if (handle_read_fault(address,physpage) < 0)
                  return FALSE;
              }
            if (!(physpage->protection & PROT_WRITE) && (prot & PROT_WRITE))
              # protection: PROT_READ -> PROT_READ_WRITE
              { if (handle_readwrite_fault(address,physpage) < 0)
                  return FALSE;
              }
    }     }
    return TRUE;
    #undef is_immutable
  }}
#endif

# mprotect() mit Ausstieg im Falle des Scheiterns
local void xmprotect (aint addr, uintL len, int prot);
local void xmprotect(addr,len,prot)
  var reg1 aint addr;
  var reg2 uintL len;
  var reg3 int prot;
  { if (mprotect((MMAP_ADDR_T)addr,len,prot) < 0)
      { 
        //: DEUTSCH "mprotect() klappt nicht."
        //: ENGLISH "mprotect() failed."
        //: FRANCAIS "mprotect() ne fonctionne pas."
        asciz_out(GETTEXT("mprotect failed"));
        errno_out(errno);
        abort();
  }   }

#ifdef MULTIMAP_MEMORY
  # mehrfaches mprotect() auf alle Mappings eines Adreßbereiches
  local void xmmprotect (aint addr, uintL len, int prot);
  local void xmmprotect(addr,len,prot)
    var reg2 aint addr;
    var reg3 uintL len;
    var reg4 int prot;
    {
      #ifdef NORMAL_MULTIMAP_MEMORY
      var reg1 uintL type;
      for (type = 0; type < typecount; type++)
        if (mem.heapnr_from_type[type] >= 0) # type in MM_TYPECASES aufgeführt?
          { xmprotect((aint)ThePointer(type_pointer_object(type,addr)),len,prot); }
      #else # MINIMAL_MULTIMAP_MEMORY
      xmprotect((aint)ThePointer(type_pointer_object(machine_type,addr)),len,prot);
      xmprotect((aint)ThePointer(type_pointer_object(imm_type,addr)),len,prot);
      #endif
    }
#else
  #define xmmprotect  xmprotect
#endif

#ifdef IMMUTABLE # impliziert SPVW_MIXED_BLOCKS_OPPOSITE

# Implementation von immutable_on() und immutable_off(), basierend auf
# mprotect(). Nur für Betriebssysteme, die mprotect() auf Shared Memory
# korrekt implementieren.

  #undef immutable_off
  #undef immutable_on

  # immutable_on_off(...);
  # modifiziert die Protection der Seiten, die zu den Typcodes in IMM_TYPECASES
  # gehören.
  # physpage->protection == PROT_NONE --> mprotect(..,..,PROT_NONE)
  # physpage->protection == PROT_READ --> mprotect(..,..,PROT_READ)
  # physpage->protection == PROT_READ_WRITE && flag --> mprotect(..,..,PROT_READ)
  # physpage->protection == PROT_READ_WRITE && !flag --> mprotect(..,..,PROT_READ_WRITE)

  # mehrfaches mprotect() auf alle Immutable-Mappings eines Adreßbereiches
  local void ximmprotect (aint addr, uintL len, int prot);
  local void ximmprotect(addr,len,prot)
    var reg2 aint addr;
    var reg3 uintL len;
    var reg4 int prot;
    {
      #ifdef NORMAL_MULTIMAP_MEMORY
      var reg1 uintL type;
      for (type = 0; type < typecount; type++)
        switch (type)
          { IMM_TYPECASES # type in IMM_TYPECASES aufgeführt?
              xmprotect((aint)ThePointer(type_pointer_object(type,addr)),len,prot);
              break;
            default:
              break;
          }
      #else # MINIMAL_MULTIMAP_MEMORY
      xmprotect((aint)ThePointer(type_pointer_object(imm_type,addr)),len,prot);
      #endif
    }

  local void immutable_on_off (int oldprotrw, int newprotrw);
  local void immutable_on_off(oldprotrw,newprotrw)
    var reg9 int oldprotrw;
    var reg8 int newprotrw;
    { var reg2 aint address;
      # Minimiere die Anzahl der nötigen mprotect()-Aufrufe: Auf Halde steht
      # ein mprotect-Aufruf für das Intervall [todo_address,address-1].
      var reg1 aint todo_address = 0;
      var reg3 int todo_prot; # Parameter für mprotect-Aufruf, falls !(todo_address==0)
      #define do_todo()  \
        { if (todo_address)                                               \
            { if (todo_address < address)                                 \
                ximmprotect(todo_address,address-todo_address,todo_prot); \
              todo_address = 0;                                           \
        }   }
      #define addto_todo(old_prot,new_prot)  \
        { if (todo_address && (todo_prot == new_prot))            \
            {} # incrementiere address                            \
            else                                                  \
            { do_todo();                                          \
              if (!(old_prot==new_prot))                          \
                { todo_address = address; todo_prot = new_prot; } \
        }   }
      # Heap 0 durchlaufen:
      { var reg7 Heap* heap = &mem.heaps[0];
        address = heap->heap_gen0_start & -physpagesize;
        if (heap->physpages == NULL)
          { addto_todo(oldprotrw,newprotrw); }
          else
          { var reg4 physpage_state* physpage = heap->physpages;
            var reg6 uintL pagecount =
              (((heap->heap_gen0_end + (physpagesize-1)) & -physpagesize)
               - (heap->heap_gen0_start & -physpagesize)
              ) >> physpageshift;
            var reg5 uintL count;
            dotimesL(count,pagecount,
              { switch (physpage->protection)
                  { case PROT_NONE: addto_todo(PROT_NONE,PROT_NONE); break;
                    case PROT_READ: addto_todo(PROT_READ,PROT_READ); break;
                    case PROT_READ_WRITE: addto_todo(oldprotrw,newprotrw); break;
                    default: abort();
                  }
                physpage++;
                address += physpagesize;
              });
          }
        address = (heap->heap_gen0_end + (physpagesize-1)) & -physpagesize;
        #if 0 # unnötig
        addto_todo(oldprotrw,newprotrw);
        address = (heap->heap_end + (physpagesize-1)) & -physpagesize;
        #endif
      }
      # Nun kommen Generation 1 von Heap 0, die große Lücke, Generation 1 von Heap 1.
      addto_todo(oldprotrw,newprotrw);
      # Heap 1 durchlaufen:
      { var reg7 Heap* heap = &mem.heaps[1];
        #if 0 # unnötig
        address = heap->heap_start & -physpagesize;
        addto_todo(oldprotrw,newprotrw);
        #endif
        address = heap->heap_gen0_start & -physpagesize;
        if (heap->physpages == NULL)
          { addto_todo(oldprotrw,newprotrw); }
          else
          { var reg4 physpage_state* physpage = heap->physpages;
            var reg6 uintL pagecount =
              (((heap->heap_gen0_end + (physpagesize-1)) & -physpagesize)
               - (heap->heap_gen0_start & -physpagesize)
              ) >> physpageshift;
            var reg5 uintL i;
            for (i = 0; i < pagecount; i++, physpage++, address += physpagesize)
              switch (physpage->protection)
                { case PROT_NONE: addto_todo(PROT_NONE,PROT_NONE); break;
                  case PROT_READ: addto_todo(PROT_READ,PROT_READ); break;
                  case PROT_READ_WRITE: addto_todo(oldprotrw,newprotrw); break;
                  default: abort();
                }
          }
        address = (heap->heap_gen0_end + (physpagesize-1)) & -physpagesize;
      }
      do_todo();
    }

  #define immutable_off()  immutable_on_off(PROT_READ,PROT_READ_WRITE)
  #define immutable_on()  immutable_on_off(PROT_READ_WRITE,PROT_READ)

#endif # IMMUTABLE && GENERATIONAL_GC

# Versionen von malloc() und realloc(), bei denen der Input auch = NULL sein darf:
  #define xfree(ptr)  \
    if (!((ptr)==NULL)) free(ptr);
  #define xrealloc(ptr,size)  \
    (((ptr)==NULL) ? (void*)malloc(size) : (void*)realloc(ptr,size))

#endif # GENERATIONAL_GC

# ------------------------------------------------------------------------------
#                       Garbage-Collector

# Gesamtstrategie:
# 1. Pseudorekursives Markieren durch Setzen von garcol_bit.
# 2. Verschieben der Objekte fester Länge (Conses u.ä.),
#    Durchrechnen der Verschiebungen der Objekte variabler Länge.
# 3. Aktualisieren der Pointer.
# 4. Durchführen der Verschiebungen der Objekte variabler Länge.

#ifdef GENERATIONAL_GC
  # Alte Generation mit Hilfe des Cache auf den aktuellen Stand bringen:
  local void prepare_old_generation (void);
  local void prepare_old_generation()
    { var reg8 uintL heapnr;
      for (heapnr=0; heapnr<heapcount; heapnr++)
        if (is_heap_containing_objects(heapnr))
          { var reg7 Heap* heap = &mem.heaps[heapnr];
            var reg5 aint gen0_start = heap->heap_gen0_start;
            var reg6 aint gen0_end = heap->heap_gen0_end;
            gen0_start = gen0_start & -physpagesize;
            gen0_end = (gen0_end + (physpagesize-1)) & -physpagesize;
            if (gen0_start < gen0_end)
              { if (!(heap->physpages==NULL))
                  { # Erst read-write einblenden:
                    xmmprotect(gen0_start, gen0_end-gen0_start, PROT_READ_WRITE);
                    # Dann den Cache entleeren:
                    {var reg3 physpage_state* physpage = heap->physpages;
                     var reg4 uintL physpagecount;
                     dotimespL(physpagecount, (gen0_end-gen0_start) >> physpageshift,
                       { if (physpage->protection == PROT_NONE)
                           { var reg2 uintL count = physpage->cache_size;
                             if (count > 0)
                               { var reg1 old_new_pointer* ptr = physpage->cache;
                                 dotimespL(count,count, { *(ptr->p) = ptr->o; ptr++; } );
                           }   }
                         physpage->protection = PROT_READ_WRITE;
                         xfree(physpage->cache); physpage->cache = NULL;
                         physpage++;
                       });
                     /* xfree(heap->physpages); heap->physpages = NULL; */
                  } }
                # Dann die Lücke zwischen der alten und der neuen Generation so
                # füllen, daß die Kompaktierungs-Algorithmen funktionieren:
                if (is_cons_heap(heapnr))
                  { var reg1 object* ptr;
                    var reg2 uintL count;
                    #ifdef SPVW_MIXED_BLOCKS_OPPOSITE
                    ptr = (object*) heap->heap_gen1_end;
                    count = (heap->heap_gen0_start - heap->heap_gen1_end)/sizeof(object);
                    #else
                    ptr = (object*) heap->heap_gen0_end;
                    count = (heap->heap_gen1_start - heap->heap_gen0_end)/sizeof(object);
                    #endif
                    dotimesL(count,count, { *ptr++ = nullobj; } );
                  }
              }
    }     }
#endif

# Test, ob ein Objekt obj in der gerade ignorierten Generation liegt.
# in_old_generation(obj,type,heapnr)
# > obj: Objekt mit !immediate_type_p(type = typecode(obj))
# > heapnr: 0 bei Objekt variabler Länge, 1 bei Cons o.ä.
# < TRUE falls man eine "kleine" Generational GC durchführt und
#   obj in der alten Generation liegt.
# Vorsicht bei Symbolen: Ist obj eines der konstanten Symbole, so ist das
# Ergebnis nicht spezifiziert!
#ifdef GENERATIONAL_GC
  #ifdef SPVW_PURE_BLOCKS
    #define in_old_generation(obj,type,heapnr)  \
      (canonaddr(obj) < mem.heaps[type].heap_start)
  #else # SPVW_MIXED_BLOCKS
    #ifdef SPVW_MIXED_BLOCKS_OPPOSITE
      #define in_old_generation_0(obj)  \
        (canonaddr(obj) < mem.varobjects.heap_start)
      #define in_old_generation_1(obj)  \
        (canonaddr(obj) >= mem.conses.heap_end)
      #define in_old_generation_general(obj)  \
        (in_old_generation_0(obj) || in_old_generation_1(obj))
      #ifdef GNU
        # meist ist heapnr konstant, das erlaubt Optimierung:
        #define in_old_generation(obj,type,heapnr)  \
          (__builtin_constant_p(heapnr)                                        \
           ? (heapnr==0 ? in_old_generation_0(obj) : in_old_generation_1(obj)) \
           : in_old_generation_general(obj)                                    \
          )
      #else
        #define in_old_generation(obj,type,heapnr)  \
          in_old_generation_general(obj)
      #endif
    #else
      #define in_old_generation(obj,type,heapnr)  \
        (canonaddr(obj) < mem.heaps[heapnr].heap_start)
    #endif
  #endif
#else
  #define in_old_generation(obj,type,heapnr)  FALSE
#endif

# Markierungs-Unterprogramm
  # Verfahren: Markierungsroutine ohne Stackbenutzung (d.h.
  #  nicht "rekursiv") durch Abstieg in die zu markierende
  #  Struktur mit Pointermodifikation (Pointer werden umgedreht,
  #  damit sie als "Ariadnefaden" zurück dienen können)
  # Konvention: ein Objekt X gilt als markiert, wenn
  #  - ein Objekt variabler Länge: Bit garcol_bit,(X) gesetzt
  #  - ein Zwei-Pointer-Objekt: Bit garcol_bit,(X) gesetzt
  #  - ein SUBR/FSUBR: Bit garcol_bit,(X+const_offset) gesetzt
  #  - Character, Short-Float, Fixnum etc.: stets.
  local void gc_mark (object obj);
  # Markierungsbit an einer Adresse setzen: mark(addr);
    #define mark(addr)  *(oint*)(addr) |= wbit(garcol_bit_o)
  # Markierungsbit an einer Adresse setzen: unmark(addr);
    #define unmark(addr)  *(oint*)(addr) &= ~wbit(garcol_bit_o)
  # Markierungsbit an einer Adresse abfragen: if (marked(addr)) ...
    #ifdef fast_mtypecode
      #define marked(addr)  (mtypecode(*(object*)(addr)) & bit(garcol_bit_t))
    #else
      #if !(garcol_bit_o == 32-1) || defined(WIDE)
        #define marked(addr)  (*(oint*)(addr) & wbit(garcol_bit_o))
      #else # garcol_bit_o = 32-1 = Vorzeichenbit
        #define marked(addr)  (*(sintL*)(addr) < 0)
      #endif
    #endif
  # Markierungsbit in einem Objekt setzen:
    #define with_mark_bit(obj)  as_object(as_oint(obj) | wbit(garcol_bit_o))
  # Markierungsbit in einem Objekt löschen:
    #define without_mark_bit(obj)  as_object(as_oint(obj) & ~wbit(garcol_bit_o))
  local void gc_mark(obj)
    var reg4 object obj;
    { var reg2 object dies = obj; # aktuelles Objekt
      var reg3 object vorg = nullobj; # Vorgänger-Objekt
      down: # Einsprung für Abstieg.
            # dies = zu markierendes Objekt, vorg = sein Vorgänger
            switch (typecode(dies))
              { case_cons:
                case_ratio:
                case_complex:
                  # Objekt mit genau 2 Pointern (Cons u.ä.)
                  if (in_old_generation(dies,typecode(dies),1))
                    goto up; # ältere Generation nicht markieren
                  { var reg1 oint* dies_ = (oint*)ThePointer(dies);
                    if (marked(dies_)) goto up; # markiert -> hoch
                    mark(dies_); # markieren
                  }
                  { var reg1 object dies_ = objectplus(dies,(soint)(sizeof(cons_)-sizeof(object))<<(oint_addr_shift-addr_shift));
                                          # mit dem letzten Pointer anfangen
                    var reg1 object nachf = *(object*)ThePointer(dies_); # Nachfolger
                    *(object*)ThePointer(dies_) = vorg; # Vorgänger eintragen
                    vorg = dies_; # aktuelles Objekt wird neuer Vorgänger
                    dies = nachf; # Nachfolger wird aktuelles Objekt
                    goto down; # und absteigen
                  }
                case_symbol: # Symbol
                  if (in_old_generation(dies,typecode(dies),0))
                    goto up; # ältere Generation (dazu zählt auch die symbol_tab!) nicht markieren
                  { var reg1 oint* dies_ = (oint*)(TheSymbol(dies));
                    if (marked(dies_)) goto up; # markiert -> hoch
                    mark(dies_); # markieren
                    mark(pointerplus(dies_,symbol_objects_offset)); # ersten Pointer markieren
                  }
                  { var reg1 object dies_ = objectplus(dies,(soint)(sizeof(symbol_)-sizeof(object))<<(oint_addr_shift-addr_shift));
                                          # mit dem letzten Pointer anfangen
                    var reg1 object nachf = *(object*)(TheSymbol(dies_)); # Nachfolger
                    *(object*)(TheSymbol(dies_)) = vorg; # Vorgänger eintragen
                    vorg = dies_; # aktuelles Objekt wird neuer Vorgänger
                    dies = nachf; # Nachfolger wird aktuelles Objekt
                    goto down; # und absteigen
                  }
                case_sbvector: # simple-bit-vector
                case_sstring: # simple-string
                case_bignum: # Bignum
                #ifndef WIDE
                case_ffloat: # Single-Float
                #endif
                case_dfloat: # Double-Float
                case_lfloat: # Long-Float
                  # Objekte variabler Länge, die keine Pointer enthalten:
                  if (in_old_generation(dies,typecode(dies),0))
                    goto up; # ältere Generation nicht markieren
                  mark(TheVarobject(dies)); # markieren
                  goto up; # und hoch
                case_array1: case_obvector: case_ostring: case_ovector:
                  # Arrays, die nicht simple sind:
                  if (in_old_generation(dies,typecode(dies),0))
                    goto up; # ältere Generation nicht markieren
                  { var reg1 oint* dies_ = (oint*)TheArray(dies);
                    if (marked(dies_)) goto up; # markiert -> hoch
                    mark(dies_); # markieren
                  }
                  { var reg1 object dies_ = objectplus(dies,(soint)(array_data_offset)<<(oint_addr_shift-addr_shift));
                                          # Datenvektor ist der erste und einzige Pointer
                    var reg1 object nachf = *(object*)TheArray(dies_); # Nachfolger
                    *(object*)TheArray(dies_) = vorg; # Vorgänger eintragen
                    mark(TheArray(dies_)); # ersten und einzigen Pointer markieren
                    vorg = dies_; # aktuelles Objekt wird neuer Vorgänger
                    dies = nachf; # Nachfolger wird aktuelles Objekt
                    goto down; # und absteigen
                  }
                case_svector: # simple-vector
                  if (in_old_generation(dies,typecode(dies),0))
                    goto up; # ältere Generation nicht markieren
                  { var reg1 oint* dies_ = (oint*)TheSvector(dies);
                    if (marked(dies_)) goto up; # markiert -> hoch
                    mark(dies_); # markieren
                  }
                  { var reg1 uintL len = TheSvector(dies)->length;
                    if (len==0) goto up; # Länge 0: wieder hoch
                   {var reg1 object dies_ = objectplus(dies,
                                              ((soint)offsetofa(svector_,data) << (oint_addr_shift-addr_shift))
                                              + (len * (soint)sizeof(object) << (oint_addr_shift-addr_shift))
                                              - ((soint)sizeof(object) << (oint_addr_shift-addr_shift)) );
                                              # mit dem letzten Pointer anfangen
                    var reg1 object nachf = *(object*)TheSvector(dies_); # Nachfolger
                    *(object*)TheSvector(dies_) = vorg; # Vorgänger eintragen
                    mark(&TheSvector(dies)->data[0]); # ersten Pointer markieren
                    vorg = dies_; # aktuelles Objekt wird neuer Vorgänger
                    dies = nachf; # Nachfolger wird aktuelles Objekt
                    goto down; # und absteigen
                  }}
                case_record:
                  # Record:
                  if (in_old_generation(dies,typecode(dies),0))
                    goto up; # ältere Generation nicht markieren
                  { var reg1 oint* dies_ = (oint*)TheRecord(dies);
                    if (marked(dies_)) goto up; # markiert -> hoch
                    mark(dies_); # markieren
                  }
                  { var reg1 uintL len = Record_length(dies);
                    if (len==0) goto up; # Länge 0: wieder hoch
                   {var reg1 object dies_ = objectplus(dies,
                                              ((soint)offsetofa(record_,recdata) << (oint_addr_shift-addr_shift))
                                            + (len * (soint)sizeof(object) << (oint_addr_shift-addr_shift))
                                            - ((soint)sizeof(object) << (oint_addr_shift-addr_shift)) );
                                            # mit dem letzten Pointer anfangen
                    var reg1 object nachf = *(object*)TheRecord(dies_); # Nachfolger
                    *(object*)TheRecord(dies_) = vorg; # Vorgänger eintragen
                    mark(&TheRecord(dies)->recdata[0]); # ersten Pointer markieren
                    vorg = dies_; # aktuelles Objekt wird neuer Vorgänger
                    dies = nachf; # Nachfolger wird aktuelles Objekt
                    goto down; # und absteigen
                  }}
                case_machine: # Maschinenadresse
                case_char: # Character
                case_system: # Frame-Pointer, Read-Label, System
                case_fixnum: # Fixnum
                case_sfloat: # Short-Float
                #ifdef WIDE
                case_ffloat: # Single-Float
                #endif
                  # Das sind direkte Objekte, keine Pointer.
                  goto up;
                case_subr: # SUBR
                  { var reg1 oint* dies_ = (oint*)pointerplus(TheSubr(dies),subr_const_offset);
                    if (marked(dies_)) goto up; # markiert -> hoch
                    # markieren später
                  }
                  { var reg1 object dies_ = objectplus(dies,
                                              (soint)(subr_const_offset+(subr_const_anz-1)*sizeof(object))<<(oint_addr_shift-addr_shift));
                                              # mit dem letzten Pointer anfangen
                    var reg1 object nachf = *(object*)TheSubr(dies_); # Nachfolger
                    *(object*)TheSubr(dies_) = vorg; # Vorgänger eintragen
                    # ersten Pointer (und damit das SUBR selbst) markieren:
                    mark(pointerplus(TheSubr(dies),subr_const_offset));
                    vorg = dies_; # aktuelles Objekt wird neuer Vorgänger
                    dies = nachf; # Nachfolger wird aktuelles Objekt
                    goto down; # und absteigen
                  }
                default:
                  # Das sind keine Objekte.
                  /*NOTREACHED*/ abort();
              }
      up:   # Einsprung zum Aufstieg.
            # dies = gerade markiertes Objekt, vorg = sein Vorgänger
            if (eq(vorg,nullobj)) # Endekennzeichen erreicht?
              return; # ja -> fertig
            if (!marked(ThePointer(vorg))) # schon durch?
              # nein ->
              # nächstes Element weiter links (Komme von up, gehe nach down)
              # dies = gerade markiertes Objekt, in *vorg einzutragen
              { var reg3 object vorvorg = *(object*)ThePointer(vorg); # alter Vorgänger
                *(object*)ThePointer(vorg) = dies; # Komponente zurückschreiben
                vorg = objectplus(vorg,-(soint)(sizeof(object))<<(oint_addr_shift-addr_shift)); # zur nächsten Komponente
                if (marked(ThePointer(vorg))) # dort schon markiert?
                  { dies = # nächste Komponente, ohne Markierung
                           without_mark_bit(*(object*)ThePointer(vorg));
                    *(object*)ThePointer(vorg) = # alten Vorgänger weiterschieben, dabei Markierung erneuern
                           with_mark_bit(vorvorg);
                  }
                  else
                  { dies = *(object*)ThePointer(vorg); # nächste Komponente, ohne Markierung
                    *(object*)ThePointer(vorg) = vorvorg; # alten Vorgänger weiterschieben
                  }
                goto down;
              }
            # schon durch -> wieder aufsteigen
            { var reg3 object vorvorg = # alten Vorgänger holen, ohne Markierungsbit
                                        without_mark_bit(*(object*)ThePointer(vorg));
              *(object*)ThePointer(vorg) = dies; # erste Komponente zurückschreiben
              switch (typecode(vorg))
                { case_cons:
                  case_ratio:
                  case_complex:
                    # Objekt mit genau 2 Pointern (Cons u.ä.)
                    { mark(ThePointer(vorg)); # wieder markieren
                      dies = vorg; # Cons wird aktuelles Objekt
                      vorg = vorvorg; goto up; # weiter aufsteigen
                    }
                  case_symbol:
                    # Symbol
                    { dies = objectplus(vorg,-(soint)symbol_objects_offset<<(oint_addr_shift-addr_shift)); # Symbol wird aktuelles Objekt
                      vorg = vorvorg; goto up; # weiter aufsteigen
                    }
                  case_svector:
                    # simple-vector mit mindestens 1 Komponente
                    { dies = objectplus(vorg,-(soint)offsetofa(svector_,data)<<(oint_addr_shift-addr_shift)); # Svector wird aktuelles Objekt
                      vorg = vorvorg; goto up; # weiter aufsteigen
                    }
                  case_array1: case_obvector: case_ostring: case_ovector:
                    # Nicht-simple Arrays:
                    { dies = objectplus(vorg,-(soint)array_data_offset<<(oint_addr_shift-addr_shift)); # Array wird aktuelles Objekt
                      vorg = vorvorg; goto up; # weiter aufsteigen
                    }
                  case_record:
                    # Record:
                    { dies = objectplus(vorg,-(soint)offsetofa(record_,recdata)<<(oint_addr_shift-addr_shift)); # Record wird aktuelles Objekt
                      vorg = vorvorg; goto up; # weiter aufsteigen
                    }
                  case_subr: # SUBR
                    { mark(TheSubr(vorg)); # wieder markieren
                      dies = objectplus(vorg,-(soint)subr_const_offset<<(oint_addr_shift-addr_shift)); # SUBR wird aktuelles Objekt
                      vorg = vorvorg; goto up; # weiter aufsteigen
                    }
                  case_machine: # Maschinenadresse
                  case_char: # Character
                  case_system: # Frame-Pointer, Read-Label, System
                  case_fixnum: # Fixnum
                  case_sfloat: # Short-Float
                  #ifdef WIDE
                  case_ffloat: # Single-Float
                  #endif
                    # Das sind direkte Objekte, keine Pointer.
                  case_sbvector: # simple-bit-vector
                  case_sstring: # simple-string
                  case_bignum: # Bignum
                  #ifndef WIDE
                  case_ffloat: # Single-Float
                  #endif
                  case_dfloat: # Double-Float
                  case_lfloat: # Long-Float
                    # Objekte variabler Länge, die keine Pointer enthalten.
                  default:
                    # Das sind keine Objekte.
                    /*NOTREACHED*/ abort();
    }       }   }

#ifdef GENERATIONAL_GC

# Nummer der Generation, die bereinigt wird.
# 0 : alles (Generation 0 + Generation 1)
# 1 : nur Generation 1
local uintC generation;

# Sparsames Durchlaufen durch alle Pointer einer physikalischen Seite:
# walk_physpage(heapnr,physpage,pageend,heapend,walkfun);
# Hierfür ist wesentlich, daß varobject_alignment ein Vielfaches
# von sizeof(object) ist.
  #define walk_physpage(heapnr,physpage,pageend,heapend,walkfun)  \
    { { var reg2 uintC count = physpage->continued_count;             \
        if (count > 0)                                                \
          { var reg1 object* ptr = physpage->continued_addr;          \
            dotimespC(count,count, { walkfun(*ptr); ptr++; } );       \
      }   }                                                           \
      { var reg4 aint physpage_end =                                  \
          (pageend < heapend ? pageend : heapend);                    \
        walk_area(heapnr,physpage->firstobject,physpage_end,walkfun); \
    } }
  #ifdef SPVW_PURE
    #define walk_area(heapnr,physpage_start,physpage_end,walkfun)  \
      { var reg3 aint objptr = physpage_start;                          \
        switch (heapnr)                                                 \
          { case_cons:                                                  \
            case_ratio:                                                 \
            case_complex:                                               \
              # Objekt mit genau 2 Pointern (Cons u.ä.)                 \
              { var reg1 object* ptr = (object*)objptr;                 \
                while ((aint)ptr < physpage_end)                        \
                  { walkfun(*ptr); ptr++; }                             \
              }                                                         \
              break;                                                    \
            case_symbol: # Symbol                                       \
              while (objptr < physpage_end)                             \
                { var reg1 object* ptr = (object*)(objptr+symbol_objects_offset); \
                  var reg2 uintC count;                                 \
                  dotimespC(count,(sizeof(symbol_)-symbol_objects_offset)/sizeof(object), \
                    { if ((aint)ptr < physpage_end)                     \
                        { walkfun(*ptr); ptr++; }                       \
                        else break;                                     \
                    });                                                 \
                  objptr += size_symbol();                              \
                }                                                       \
              break;                                                    \
            case_array1: case_obvector: case_ostring: case_ovector:     \
              # Arrays, die nicht simple sind:                          \
              while (objptr < physpage_end)                             \
                { var reg1 object* ptr = &((Array)objptr)->data;        \
                  if ((aint)ptr < physpage_end)                         \
                    { walkfun(*ptr); }                                  \
                  objptr += speicher_laenge_array((Array)objptr);       \
                }                                                       \
              break;                                                    \
            case_svector: # simple-vector                               \
              while (objptr < physpage_end)                             \
                { var reg2 uintL count = ((Svector)objptr)->length;     \
                  var reg1 object* ptr = &((Svector)objptr)->data[0];   \
                  objptr += size_svector(count);                        \
                  dotimesL(count,count,                                 \
                    { if ((aint)ptr < physpage_end)                     \
                        { walkfun(*ptr); ptr++; }                       \
                        else break;                                     \
                    });                                                 \
                }                                                       \
              break;                                                    \
            case_record: # Record                                       \
              while (objptr < physpage_end)                             \
                { var reg2 uintC count;                                 \
                  var reg1 object* ptr = &((Record)objptr)->recdata[0]; \
                  objptr += (((Record)objptr)->rectype < 0              \
                             ? (count = ((Srecord)objptr)->reclength, size_srecord(count)) \
                             : (count = ((Xrecord)objptr)->reclength, size_xrecord(count,((Xrecord)objptr)->recxlength)) \
                            );                                          \
                  dotimesC(count,count,                                 \
                    { if ((aint)ptr < physpage_end)                     \
                        { walkfun(*ptr); ptr++; }                       \
                        else break;                                     \
                    });                                                 \
                }                                                       \
              break;                                                    \
            default:                                                    \
              # Solche Objekte kommen nicht vor.                        \
              /*NOTREACHED*/ abort();                                   \
      }   }
  #endif
  #ifdef SPVW_MIXED
    #define walk_area(heapnr,physpage_start,physpage_end,walkfun)  \
      { var reg3 aint objptr = physpage_start;                                   \
        switch (heapnr)                                                          \
          { case 0: # Objekte variabler Länge                                    \
              while (objptr < physpage_end)                                      \
                { switch (typecode_at(objptr)) # Typ des nächsten Objekts        \
                    { case_symbolwithflags: # Symbol                             \
                        { var reg1 object* ptr = (object*)(objptr+symbol_objects_offset); \
                          var reg2 uintC count;                                  \
                          dotimespC(count,(sizeof(symbol_)-symbol_objects_offset)/sizeof(object), \
                            { if ((aint)ptr < physpage_end)                      \
                                { walkfun(*ptr); ptr++; }                        \
                                else break;                                      \
                            });                                                  \
                          objptr += size_symbol();                               \
                        }                                                        \
                        break;                                                   \
                      case_array1: case_obvector: case_ostring: case_ovector:    \
                        # Arrays, die nicht simple sind:                         \
                        { var reg1 object* ptr = &((Array)objptr)->data;         \
                          if ((aint)ptr < physpage_end)                          \
                            { walkfun(*ptr); }                                   \
                          objptr += speicher_laenge((Array)objptr);              \
                        }                                                        \
                        break;                                                   \
                      case_svector: # simple-vector                              \
                        { var reg2 uintL count = ((Svector)objptr)->length;      \
                          var reg1 object* ptr = &((Svector)objptr)->data[0];    \
                          objptr += size_svector(count);                         \
                          dotimesL(count,count,                                  \
                            { if ((aint)ptr < physpage_end)                      \
                                { walkfun(*ptr); ptr++; }                        \
                                else break;                                      \
                            });                                                  \
                        }                                                        \
                        break;                                                   \
                      case_record: # Record                                      \
                        { var reg2 uintC count;                                  \
                          var reg1 object* ptr = &((Record)objptr)->recdata[0];  \
                          objptr += (((Record)objptr)->rectype < 0               \
                                     ? (count = ((Srecord)objptr)->reclength, size_srecord(count)) \
                                     : (count = ((Xrecord)objptr)->reclength, size_xrecord(count,((Xrecord)objptr)->recxlength)) \
                                    );                                           \
                          dotimesC(count,count,                                  \
                            { if ((aint)ptr < physpage_end)                      \
                                { walkfun(*ptr); ptr++; }                        \
                                else break;                                      \
                            });                                                  \
                        }                                                        \
                        break;                                                   \
                      default: # simple-bit-vector, simple-string, bignum, float \
                        objptr += speicher_laenge((Varobject)objptr);            \
                        break;                                                   \
                }   }                                                            \
              break;                                                             \
            case 1: # 2-Pointer-Objekte                                          \
              { var reg1 object* ptr = (object*)objptr;                          \
                while ((aint)ptr < physpage_end)                                 \
                  { walkfun(*ptr); ptr++; }                                      \
              }                                                                  \
              break;                                                             \
            default: /*NOTREACHED*/ abort();                                     \
      }   }
  #endif
# Dasselbe als Funktion:
# walk_physpage_(heapnr,physpage,pageend,heapend,walkstep);
# bzw. walk_area_(heapnr,physpage_start,physpage_end,walkstep);
  typedef void (*walkstep_fun)(object* ptr);
  local void walk_physpage_ (uintL heapnr, physpage_state* physpage, aint pageend, aint heapend, walkstep_fun walkstep);
  local void walk_physpage_(heapnr,physpage,pageend,heapend,walkstep)
    var reg8 uintL heapnr;
    var reg6 physpage_state* physpage;
    var reg7 aint pageend;
    var reg7 aint heapend;
    var reg5 walkstep_fun walkstep;
    {
      #define walkstep1(obj)  walkstep(&(obj))
      walk_physpage(heapnr,physpage,pageend,heapend,walkstep1);
      #undef walkstep1
    }
  local void walk_area_ (uintL heapnr, aint physpage_start, aint physpage_end, walkstep_fun walkstep);
  local void walk_area_(heapnr,physpage_start,physpage_end,walkstep)
    var reg6 uintL heapnr;
    var reg7 aint physpage_start;
    var reg4 aint physpage_end;
    var reg5 walkstep_fun walkstep;
    {
      #define walkstep1(obj)  walkstep(&(obj))
      walk_area(heapnr,physpage_start,physpage_end,walkstep1);
      #undef walkstep1
    }

  local void gc_mark_at (object* ptr);
  local void gc_mark_at(ptr)
    var reg1 object* ptr;
    { gc_mark(*ptr); }

#endif

# Markierungsphase:
  # Es werden alle "aktiven" Strukturen markiert.
  # Aktiv ist alles, was erreichbar ist
  # - vom LISP-Stack aus  oder
  # - bei Generational-GC: von der alten Generation aus  oder
  # - als Programmkonstanten (dazu gehört auch die Liste aller Packages).
  local void gc_markphase (void);
  local void gc_markphase()
    { { var reg1 object* objptr = &STACK_0; # Pointer, der durch den STACK läuft
        until (eq(*objptr,nullobj)) # bis STACK zu Ende ist:
          { if ( *((oint*)objptr) & wbit(frame_bit_o) ) # Beginnt hier ein Frame?
             { if (( *((oint*)objptr) & wbit(skip2_bit_o) ) == 0) # Ohne skip2-Bit?
                objptr skipSTACKop 2; # ja -> um 2 weiterrücken
                else
                objptr skipSTACKop 1; # nein -> um 1 weiterrücken
             }
             else
             { # normales Objekt, markieren:
               var reg2 object obj = *objptr;
               switch (typecode(obj)) # evtl. Symbol-Flags entfernen
                 { case_symbolflagged:
                     #ifndef NO_symbolflags
                     obj = symbol_without_flags(obj);
                     #endif
                   default: break;
                 }
               gc_mark(obj);
               objptr skipSTACKop 1; # weiterrücken
      }   }  }
      #ifdef GENERATIONAL_GC
      # Alte Generation markieren, wobei man sie sehr sparsam durchläuft:
      if (generation > 0)
        { var reg7 uintL heapnr;
          for (heapnr=0; heapnr<heapcount; heapnr++)
            if (is_heap_containing_objects(heapnr)) # Objekte, die keine Pointer enthalten,
                                                    # braucht man nicht zu durchlaufen.
              { var reg6 Heap* heap = &mem.heaps[heapnr];
                var reg4 aint gen0_start = heap->heap_gen0_start;
                var reg5 aint gen0_end = heap->heap_gen0_end;
                if (gen0_start < gen0_end)
                  if (heap->physpages==NULL)
                    { walk_area_(heapnr,gen0_start,gen0_end,gc_mark_at); } # fallback
                    else
                    { var reg3 physpage_state* physpage = heap->physpages;
                      gen0_start &= -physpagesize;
                      do { gen0_start += physpagesize;
                           if ((physpage->protection == PROT_NONE)
                               || (physpage->protection == PROT_READ)
                              )
                             # Cache ausnutzen, gecachte Pointer markieren:
                             { var reg2 uintL count = physpage->cache_size;
                               if (count > 0)
                                 { var reg1 old_new_pointer* ptr = physpage->cache;
                                   dotimespL(count,count, { gc_mark(ptr->o); ptr++; } );
                             }   }
                             else
                             # ganzen Page-Inhalt markieren:
                             { walk_physpage_(heapnr,physpage,gen0_start,gen0_end,gc_mark_at); }
                           physpage++;
                         }
                         while (gen0_start < gen0_end);
        }     }     }
      #endif
      # Alle Programmkonstanten markieren:
      for_all_subrs( gc_mark(subr_tab_ptr_as_object(ptr)); ); # subr_tab durchgehen
      #if !defined(GENERATIONAL_GC)
      for_all_constsyms( gc_mark(symbol_tab_ptr_as_object(ptr)); ); # symbol_tab durchgehen
      #else
      # gc_mark() betrachtet wegen des Macros in_old_generation() alle konstanten
      # Symbole als zur alten Generation zugehörig und durchläuft sie nicht.
      for_all_constsyms( # symbol_tab durchgehen
        { gc_mark(ptr->symvalue);
          gc_mark(ptr->symfunction);
          gc_mark(ptr->proplist);
          gc_mark(ptr->pname);
          gc_mark(ptr->homepackage);
        });
      #endif
      for_all_constobjs( gc_mark(*objptr); ); # object_tab durchgehen
    }

# UP: Stellt fest, ob ein Objekt noch "lebt".
# D.h. ob nach der Markierungsphase das Markierungsbit gesetzt ist.
  local boolean alive (object obj);
  local boolean alive(obj)
    var reg1 object obj;
    { switch (typecode(obj)) # je nach Typ
        { case_cons: # Cons
          case_ratio: # Ratio
          case_complex: # Complex
            if (in_old_generation(obj,typecode(obj),1)) return TRUE;
            if (marked(ThePointer(obj))) return TRUE; else return FALSE;
          case_symbol: # Symbol
          case_array: # Array
          case_bignum: # Bignum
          #ifndef WIDE
          case_ffloat: # Single-Float
          #endif
          case_dfloat: # Double-Float
          case_lfloat: # Long-Float
          case_record: # Record
            if (in_old_generation(obj,typecode(obj),0)) return TRUE;
            if (marked(ThePointer(obj))) return TRUE; else return FALSE;
          case_subr: # Subr
            if (marked((oint*)pointerplus(TheSubr(obj),subr_const_offset)))
              return TRUE; else return FALSE;
          case_machine: # Maschinenpointer
          case_char: # Character
          case_system: # Frame-pointer, Read-label, system
          case_fixnum: # Fixnum
          case_sfloat: # Short-Float
          #ifdef WIDE
          case_ffloat: # Single-Float
          #endif
            return TRUE;
          default:
            # Das sind keine Objekte.
            /*NOTREACHED*/ abort();
    }   }

# SUBRs und feste Symbole demarkieren:
  local void unmark_fixed_varobjects (void);
  local void unmark_fixed_varobjects()
    { for_all_subrs( unmark((aint)ptr+subr_const_offset); ); # jedes Subr demarkieren
      #if !defined(GENERATIONAL_GC)
      for_all_constsyms( unmark(&((Symbol)ptr)->GCself); ); # jedes Symbol in symbol_tab demarkieren
      #else
      # Da wir die konstanten Symbole nicht markiert haben, sondern nur ihren
      # Inhalt, brauchen wir sie auch nicht zu demarkieren.
      #endif
    }

#if !defined(MORRIS_GC)

 #ifdef SPVW_MIXED_BLOCKS_OPPOSITE

  # CONS-Zellen zwischen page->page_start und page->page_end oben
  # konzentrieren:
  local void gc_compact_cons_page (Page* page);
  local void gc_compact_cons_page(page)
    var reg3 Page* page;
    # Dabei wandert der Pointer p1 von unten und der Pointer p2 von
    # oben durch den Speicherbereich, bis sie kollidieren. Es
    # werden dabei markierte Strukturen über unmarkierte geschoben.
    { var reg1 aint p1 = page->page_start; # untere Grenze
      var reg2 aint p2 = page->page_end; # obere Grenze
      sweeploop:
        # Suche nächstobere unmarkierte Zelle <p2 und demarkiere dabei alle:
        sweeploop1:
          if (p1==p2) goto sweepok2; # Grenzen gleich geworden -> fertig
          p2 -= sizeof(cons_); # nächste Zelle von oben erfassen
          if (marked(p2)) # markiert?
            { unmark(p2); # demarkieren
              goto sweeploop1;
            }
        # p1 <= p2, p2 zeigt auf eine unmarkierte Zelle.
        # Suche nächstuntere markierte Zelle >=p1:
        sweeploop2:
          if (p1==p2) goto sweepok1; # Grenzen gleich geworden -> fertig
          if (!marked(p1)) # unmarkiert?
            { p1 += sizeof(cons_); # bei der nächstunteren Zelle
              goto sweeploop2; # weitersuchen
            }
        # p1 < p2, p1 zeigt auf eine markierte Zelle.
        unmark(p1); # demarkieren
        # Zelleninhalt in die unmarkierte Zelle kopieren:
        ((object*)p2)[0] = ((object*)p1)[0];
        ((object*)p2)[1] = ((object*)p1)[1];
        *(object*)p1 = type_pointer_object(0,p2); # neue Adresse hinterlassen
        mark(p1); # und markieren (als Erkennung fürs Aktualisieren)
        p1 += sizeof(cons_); # Diese Zelle ist fertig.
        goto sweeploop; # weiter
      sweepok1: p1 += sizeof(cons_); # letztes unmarkiertes Cons übergehen
      sweepok2:
      # p1 = neue untere Grenze des Cons-Bereiches
      page->page_start = p1;
    }

 #else

  # CONS-Zellen zwischen page->page_start und page->page_end unten
  # konzentrieren:
  local void gc_compact_cons_page (Page* page);
  local void gc_compact_cons_page(page)
    var reg3 Page* page;
    # Dabei wandert der Pointer p1 von unten und der Pointer p2 von
    # oben durch den Speicherbereich, bis sie kollidieren. Es
    # werden dabei markierte Strukturen über unmarkierte geschoben.
    { var reg1 aint p1 = page->page_start; # untere Grenze
      var reg2 aint p2 = page->page_end; # obere Grenze
      sweeploop:
        # Suche nächstobere markierte Zelle <p2:
        sweeploop1:
          if (p1==p2) goto sweepok2; # Grenzen gleich geworden -> fertig
          p2 -= sizeof(cons_); # nächste Zelle von oben erfassen
          if (!marked(p2)) goto sweeploop1; # unmarkiert?
        # p1 <= p2, p2 zeigt auf eine markierte Zelle.
        unmark(p2); # demarkieren
        # Suche nächstuntere unmarkierte Zelle >=p1 und demarkiere dabei alle:
        sweeploop2:
          if (p1==p2) goto sweepok1; # Grenzen gleich geworden -> fertig
          if (marked(p1)) # markiert?
            { unmark(p1); # demarkieren
              p1 += sizeof(cons_); # bei der nächstoberen Zelle
              goto sweeploop2; # weitersuchen
            }
        # p1 < p2, p1 zeigt auf eine unmarkierte Zelle.
        # Zelleninhalt von der markierten in die unmarkierte Zelle kopieren:
        ((object*)p1)[0] = ((object*)p2)[0];
        ((object*)p1)[1] = ((object*)p2)[1];
        *(object*)p2 = type_pointer_object(0,p1); # neue Adresse hinterlassen
        mark(p2); # und markieren (als Erkennung fürs Aktualisieren)
        p1 += sizeof(cons_); # Diese Zelle ist fertig.
        goto sweeploop; # weiter
      sweepok1: p1 += sizeof(cons_); # letztes markiertes Cons übergehen
      sweepok2:
      # p1 = neue obere Grenze des Cons-Bereiches
      page->page_end = p1;
    }

 #endif

#else # defined(MORRIS_GC)

# Algorithmus siehe:
# [F. Lockwood Morris: A time- and space-efficient garbage collection algorithm.
#  CACM 21,8 (August 1978), 662-665.]

  # Alle unmarkierten CONS-Zellen löschen und die markierten CONS-Zellen demarkieren,
  # damit das Markierungsbit für die Rückwärtspointer zur Verfügung steht.
  local void gc_morris1 (Page* page);
  local void gc_morris1(page)
    var reg4 Page* page;
    { var reg1 aint p1 = page->page_start; # untere Grenze
      var reg2 aint p2 = page->page_end; # obere Grenze
      var reg3 aint d = 0; # freien Speicher mitzählen
      until (p1==p2)
        { if (!marked(p1))
            { ((object*)p1)[0] = nullobj;
              ((object*)p1)[1] = nullobj;
              d += sizeof(cons_);
            }
            else
            { unmark(p1);
              #ifdef DEBUG_SPVW
              if (eq(((object*)p1)[0],nullobj) || eq(((object*)p1)[1],nullobj))
                abort();
              #endif
            }
          p1 += sizeof(cons_); # Diese Zelle ist fertig.
        }
      page->page_gcpriv.d = d; # freien Speicher abspeichern
    }

 #ifdef SPVW_MIXED_BLOCKS_OPPOSITE

  # Es gibt nur eine einzige Page mit Zwei-Pointer-Objekten.

  local void gc_morris2 (Page* page);
  local void gc_morris2(page)
    var reg7 Page* page;
    { # Jede Zelle innerhalb eines Cons enthält nun eine Liste aller
      # Adressen von Pointern auf diese Zelle, die aus einer Wurzel heraus
      # oder aus einem Varobject heraus auf diese Zelle zeigen.
      #
      # Die nicht gelöschten Conses von links nach rechts durchlaufen:
      # (Zwischendurch enthält jede Zelle eine Liste aller Adressen
      # von Pointern auf diese Zelle, die aus einer Wurzel heraus,
      # aus einem Varobject heraus oder aus einem weiter links liegenden
      # Cons auf diese Zelle zeigen.)
      var reg4 aint p1 = page->page_start; # untere Grenze
      var reg5 aint p2 = p1 + page->gcpriv.d; # spätere untere Grenze
      var reg6 aint p1limit = page->page_end; # obere Grenze
      until (p1==p1limit) # stets p1 <= p2 <= p1limit
        { # Beide Zellen eines Cons werden genau gleich behandelt.
          var reg1 object obj = *(object*)p1;
          if (!eq(obj,nullobj))
            { # p1 wird nach p2 verschoben.
              # Die bisher registrierten Pointer auf diese Zelle werden aktualisiert:
              until ((as_oint(obj) & wbit(garcol_bit_o)) == 0) # Liste abarbeiten
                { obj = without_mark_bit(obj);
                 {var reg2 aint p = upointer(obj);
                  var reg3 object next_obj = *(object*)p;
                  *(object*)p = type_pointer_object(typecode(obj),p2);
                  obj = next_obj;
                }}
              # Falls die Zelle einen Pointer "nach rechts" enthält, wird er umgedreht.
              { var reg3 tint type = typecode(obj);
                switch (type)
                  { case_cons: case_ratio: case_complex:
                      { var reg2 aint p = upointer(obj);
                        if (!in_old_generation(obj,type,1) && (p > p1))
                          { # Für spätere Aktualisierung
                            # p1 in die Liste der Pointer auf p einhängen:
                            *(object*)p1 = *(object*)p;
                            *(object*)p = with_mark_bit(type_pointer_object(type,p1));
                            break;
                      }   }
                    default:
                      *(object*)p1 = obj;
              }   }
              p2 += sizeof(object);
            }
          p1 += sizeof(object);
        }
      if (!(p2==p1limit)) abort();
    }
  local void gc_morris3 (Page* page);
  local void gc_morris3(page)
    var reg7 Page* page;
    { # Jede Zelle innerhalb eines Cons enthält nun wieder den ursprünglichen
      # Inhalt.
      #
      # Die nicht gelöschten Conses von rechts nach links durchlaufen
      # und dabei rechts kompaktieren:
      # (Zwischendurch enthält jede Zelle eine Liste aller Adressen
      # von Pointern auf diese Zelle, die aus einem weiter rechts liegenden
      # Cons auf diese Zelle zeigen.)
      var reg6 aint p1limit = page->page_start; # untere Grenze
      var reg4 aint p1 = page->page_end; # obere Grenze
      var reg5 aint p2 = p1; # obere Grenze
      #ifdef DEBUG_SPVW
      until (p1==p1limit)
        { p1 -= 2*sizeof(object);
          if (eq(*(object*)p1,nullobj)+eq(*(object*)(p1^sizeof(object)),nullobj)==1)
            abort();
        }
      p1 = page->page_end;
      #endif
      until (p1==p1limit) # stets p1limit <= p1 <= p2
        { # Beide Zellen eines Cons werden genau gleich behandelt.
          p1 -= sizeof(object);
          #ifdef DEBUG_SPVW
          if (eq(*(object*)p1,nullobj)+eq(*(object*)(p1^sizeof(object)),nullobj)==1)
            abort();
          if (!((p1 % (2*sizeof(object))) == 0))
            { if (!((p2 % (2*sizeof(object))) == 0))
                abort();
            }
          #endif
         {var reg1 object obj = *(object*)p1;
          if (!eq(obj,nullobj))
            { p2 -= sizeof(object);
              # p1 wird nach p2 verschoben.
              # Die neu registrierten Pointer auf diese Zelle werden aktualisiert:
              until ((as_oint(obj) & wbit(garcol_bit_o)) == 0) # Liste abarbeiten
                { obj = without_mark_bit(obj);
                 {var reg2 aint p = upointer(obj);
                  var reg3 object next_obj = *(object*)p;
                  *(object*)p = type_pointer_object(typecode(obj),p2);
                  obj = next_obj;
                }}
              #ifdef DEBUG_SPVW
              if (eq(obj,nullobj)) abort();
              #endif
              *(object*)p2 = obj;
              { var reg5 tint type = typecode(obj);
                if (!immediate_type_p(type)) # unverschieblich -> nichts tun
                  switch (type)
                    { case_cons: case_ratio: case_complex: # Zwei-Pointer-Objekt
                        { var reg4 aint p = upointer(obj);
                          if (p < p1) # Pointer nach links?
                            { # Für spätere Aktualisierung
                              # p2 in die Liste der Pointer auf p einhängen:
                              #ifdef DEBUG_SPVW
                              if (eq(*(object*)p,nullobj)) abort();
                              #endif
                              *(object*)p2 = *(object*)p;
                              *(object*)p = with_mark_bit(type_pointer_object(type,p2));
                            }
                          elif (p == p1) # Pointer auf sich selbst?
                            { *(object*)p2 = type_pointer_object(type,p2); }
                        }
                        break;
                      default: # Objekt variabler Länge
                        if (marked(ThePointer(obj))) # markiert?
                          *(object*)p2 = type_untype_object(type,untype(*(object*)ThePointer(obj)));
                        break;
              }     }
            }}
        }
      # p2 = neue untere Grenze des Cons-Bereiches
      if (!(p2 == page->page_start + page->page_gcpriv.d)) abort();
      page->page_start = p2;
    }

 #elif defined(SPVW_MIXED_BLOCKS) # TRIVIALMAP_MEMORY

  local void gc_morris2 (Page* page);
  local void gc_morris2(page)
    var reg7 Page* page;
    { # Jede Zelle innerhalb eines Cons enthält nun eine Liste aller
      # Adressen von Pointern auf diese Zelle, die aus einer Wurzel heraus
      # oder aus einem Varobject heraus auf diese Zelle zeigen.
      #
      # Die nicht gelöschten Conses von rechts nach links durchlaufen:
      # (Zwischendurch enthält jede Zelle eine Liste aller Adressen
      # von Pointern auf diese Zelle, die aus einer Wurzel heraus,
      # aus einem Varobject heraus oder aus einem weiter rechts liegenden
      # Cons auf diese Zelle zeigen.)
      var reg5 aint p1 = page->page_end; # obere Grenze
      var reg4 aint p2 = p1 - page->gcpriv.d; # spätere obere Grenze
      var reg6 aint p1limit = page->page_start; # untere Grenze
      #ifdef DEBUG_SPVW
      until (p1==p1limit)
        { p1 -= 2*sizeof(object);
          if (eq(*(object*)p1,nullobj)+eq(*(object*)(p1^sizeof(object)),nullobj)==1)
            abort();
        }
      p1 = page->page_end;
      #endif
      until (p1==p1limit) # stets p1limit <= p2 <= p1
        { # Beide Zellen eines Cons werden genau gleich behandelt.
          p1 -= sizeof(object);
          #ifdef DEBUG_SPVW
          if (eq(*(object*)p1,nullobj)+eq(*(object*)(p1^sizeof(object)),nullobj)==1)
            abort();
          #endif
         {var reg1 object obj = *(object*)p1;
          if (!eq(obj,nullobj))
            { p2 -= sizeof(object);
              # p1 wird nach p2 verschoben.
              # Die bisher registrierten Pointer auf diese Zelle werden aktualisiert:
              until ((as_oint(obj) & wbit(garcol_bit_o)) == 0) # Liste abarbeiten
                { obj = without_mark_bit(obj);
                 {var reg2 aint p = upointer(obj);
                  var reg3 object next_obj = *(object*)p;
                  *(object*)p = type_pointer_object(typecode(obj),p2);
                  obj = next_obj;
                }}
              # obj = ursprünglicher Inhalt der Zelle p1.
              #ifdef DEBUG_SPVW
              if (eq(obj,nullobj)) abort();
              #endif
              # Falls die Zelle einen Pointer "nach links" enthält, wird er umgedreht.
              { var reg3 tint type = typecode(obj);
                switch (type)
                  { case_cons: case_ratio: case_complex:
                      { var reg2 aint p = upointer(obj);
                        if (!in_old_generation(obj,type,1) && (p < p1))
                          { # Für spätere Aktualisierung
                            # p1 in die Liste der Pointer auf p einhängen:
                            *(object*)p1 = *(object*)p;
                            *(object*)p = with_mark_bit(type_pointer_object(type,p1));
                            break;
                      }   }
                    default:
                      *(object*)p1 = obj;
            } }   }
        }}
      if (!(p2==p1limit)) abort();
    }
  local void gc_morris3 (Page* page);
  local void gc_morris3(page)
    var reg7 Page* page;
    { # Jede Zelle innerhalb eines Cons enthält nun wieder den ursprünglichen
      # Inhalt.
      #
      # Die nicht gelöschten Conses von links nach rechts durchlaufen
      # und dabei links kompaktieren:
      # (Zwischendurch enthält jede Zelle eine Liste aller Adressen
      # von Pointern auf diese Zelle, die aus einem weiter links liegenden
      # Cons auf diese Zelle zeigen.)
      var reg6 aint p1limit = page->page_end; # obere Grenze
      var reg4 aint p1 = page->page_start; # untere Grenze
      var reg5 aint p2 = p1; # untere Grenze
      until (p1==p1limit) # stets p1limit <= p1 <= p2
        { # Beide Zellen eines Cons werden genau gleich behandelt.
          var reg1 object obj = *(object*)p1;
          if (!eq(obj,nullobj))
            { # p1 wird nach p2 verschoben.
              # Die neu registrierten Pointer auf diese Zelle werden aktualisiert:
              until ((as_oint(obj) & wbit(garcol_bit_o)) == 0) # Liste abarbeiten
                { obj = without_mark_bit(obj);
                 {var reg2 aint p = upointer(obj);
                  var reg3 object next_obj = *(object*)p;
                  *(object*)p = type_pointer_object(typecode(obj),p2);
                  obj = next_obj;
                }}
              # obj = richtiger Inhalt der Zelle p1.
              { var reg5 tint type = typecode(obj);
                if (!immediate_type_p(type)) # unverschieblich -> nichts tun
                  switch (type)
                    { case_cons: case_ratio: case_complex: # Zwei-Pointer-Objekt
                        { var reg4 aint p = upointer(obj);
                          if (p > p1) # Pointer nach rechts?
                            { # Für spätere Aktualisierung
                              # p2 in die Liste der Pointer auf p einhängen:
                              #ifdef DEBUG_SPVW
                              if (eq(*(object*)p,nullobj)) abort();
                              #endif
                              *(object*)p2 = *(object*)p;
                              *(object*)p = with_mark_bit(type_pointer_object(type,p2));
                            }
                          elif (p == p1) # Pointer auf sich selbst?
                            { *(object*)p2 = type_pointer_object(type,p2); }
                          else
                            { *(object*)p2 = obj; }
                        }
                        break;
                      default: # Objekt variabler Länge
                        if (marked(ThePointer(obj))) # markiert?
                          *(object*)p2 = type_untype_object(type,untype(*(object*)ThePointer(obj)));
                          else
                          *(object*)p2 = obj;
                        break;
                    }
                  else # unverschieblich oder Pointer in die alte Generation -> nichts tun
                  { *(object*)p2 = obj; }
              }
              p2 += sizeof(object);
            }
          p1 += sizeof(object);
        }
      # p2 = neue obere Grenze des Cons-Bereiches
      if (!(p2 == page->page_end - page->page_gcpriv.d)) abort();
      page->page_end = p2;
    }

 #else # SPVW_PURE_BLOCKS <==> SINGLEMAP_MEMORY

  # gc_morris2 und gc_morris3 müssen je einmal für jede Page aufgerufen werden,
  # und zwar gc_morris2 von rechts nach links, dann gc_morris3 von links nach rechts
  # (im Sinne der Anordnung der Adressen)!

  local void gc_morris2 (Page* page);
  local void gc_morris2(page)
    var reg7 Page* page;
    { # Jede Zelle innerhalb eines Cons enthält nun eine Liste aller
      # Adressen von Pointern auf diese Zelle, die aus einer Wurzel heraus
      # oder aus einem Varobject heraus auf diese Zelle zeigen.
      #
      # Die nicht gelöschten Conses von rechts nach links durchlaufen:
      # (Zwischendurch enthält jede Zelle eine Liste aller Adressen
      # von Pointern auf diese Zelle, die aus einer Wurzel heraus,
      # aus einem Varobject heraus oder aus einem weiter rechts liegenden
      # Cons auf diese Zelle zeigen.)
      var reg4 aint p1 = page->page_end; # obere Grenze
      var reg3 aint p2 = p1 - page->gcpriv.d; # spätere obere Grenze
      var reg5 aint p1limit = page->page_start; # untere Grenze
      until (p1==p1limit) # stets p1limit <= p2 <= p1
        { # Beide Zellen eines Cons werden genau gleich behandelt.
          p1 -= sizeof(object);
         {var reg1 object obj = *(object*)p1;
          if (!eq(obj,nullobj))
            { p2 -= sizeof(object);
              # p1 wird nach p2 verschoben.
              # Die bisher registrierten Pointer auf diese Zelle werden aktualisiert:
              until ((as_oint(obj) & wbit(garcol_bit_o)) == 0) # Liste abarbeiten
                { obj = without_mark_bit(obj);
                 {var reg2 object next_obj = *(object*)pointable(obj);
                  *(object*)pointable(obj) = as_object(p2);
                  obj = next_obj;
                }}
              # obj = ursprünglicher Inhalt der Zelle p1.
              # Falls die Zelle einen Pointer "nach links" enthält, wird er umgedreht.
              if (is_cons_heap(typecode(obj))
                  && !in_old_generation(obj,typecode(obj),1)
                  && ((aint)pointable(obj) < p1)
                 )
                { # Für spätere Aktualisierung
                  # p1 in die Liste der Pointer auf obj einhängen:
                  *(object*)p1 = *(object*)pointable(obj);
                  *(object*)pointable(obj) = with_mark_bit(as_object(p1));
                }
                else
                { *(object*)p1 = obj; }
            }
        }}
      if (!(p2==p1limit)) abort();
    }
  local void gc_morris3 (Page* page);
  local void gc_morris3(page)
    var reg7 Page* page;
    { # Jede Zelle innerhalb eines Cons enthält nun wieder den ursprünglichen
      # Inhalt.
      #
      # Die nicht gelöschten Conses von links nach rechts durchlaufen
      # und dabei links kompaktieren:
      # (Zwischendurch enthält jede Zelle eine Liste aller Adressen
      # von Pointern auf diese Zelle, die aus einem weiter links liegenden
      # Cons auf diese Zelle zeigen.)
      var reg6 aint p1limit = page->page_end; # obere Grenze
      var reg4 aint p1 = page->page_start; # untere Grenze
      var reg3 aint p2 = p1; # untere Grenze
      until (p1==p1limit) # stets p1limit <= p1 <= p2
        { # Beide Zellen eines Cons werden genau gleich behandelt.
          var reg1 object obj = *(object*)p1;
          if (!eq(obj,nullobj))
            { # p1 wird nach p2 verschoben.
              # Die neu registrierten Pointer auf diese Zelle werden aktualisiert:
              until ((as_oint(obj) & wbit(garcol_bit_o)) == 0) # Liste abarbeiten
                { obj = without_mark_bit(obj);
                 {var reg2 object next_obj = *(object*)pointable(obj);
                  *(object*)pointable(obj) = as_object(p2);
                  obj = next_obj;
                }}
              # obj = richtiger Inhalt der Zelle p1.
              { var reg5 tint type = typecode(obj);
                if (!is_unused_heap(type) && !in_old_generation(obj,type,?))
                  if (is_cons_heap(type))
                    # Zwei-Pointer-Objekt
                    { if ((aint)pointable(obj) > p1) # Pointer nach rechts?
                        { # Für spätere Aktualisierung
                          # p2 in die Liste der Pointer auf obj einhängen:
                          *(object*)p2 = *(object*)pointable(obj);
                          *(object*)pointable(obj) = with_mark_bit(as_object(p2));
                        }
                      elif ((aint)pointable(obj) == p1) # Pointer auf sich selbst?
                        { *(object*)p2 = as_object(p2); }
                      else
                        { *(object*)p2 = obj; }
                    }
                    else
                    # Objekt variabler Länge
                    { if (marked(ThePointer(obj))) # markiert?
                        *(object*)p2 = type_untype_object(type,untype(*(object*)ThePointer(obj)));
                        else
                        *(object*)p2 = obj;
                    }
                  else # unverschieblich oder Pointer in die alte Generation -> nichts tun
                  { *(object*)p2 = obj; }
              }
              p2 += sizeof(object);
            }
          p1 += sizeof(object);
        }
      # p2 = neue obere Grenze des Cons-Bereiches
      if (!(p2 == page->page_end - page->page_gcpriv.d)) abort();
      page->page_end = p2;
    }

 #endif

#endif

# Den Selbstpointer eines Objekts variabler Länge modifizieren:
# set_GCself(p,type,addr);
# setzt p->GCself auf type_pointer_object(type,addr).
  #if !(exact_uint_size_p(oint_type_len) && ((oint_type_shift%hfintsize)==0) && (tint_type_mask == bit(oint_type_len)-1))
    #ifdef MAP_MEMORY
      # addr enthält Typinfo
      #define set_GCself(p,type,addr)  \
        ((Varobject)(p))->GCself = type_pointer_object((type)&(tint_type_mask),(addr)&(oint_addr_mask))
    #else
      # addr enthält keine Typinfo
      #define set_GCself(p,type,addr)  \
        ((Varobject)(p))->GCself = type_pointer_object((type)&(tint_type_mask),addr)
    #endif
  #else # besser: zwar zwei Speicherzugriffe, jedoch weniger Arithmetik
    #define set_GCself(p,type,addr)  \
      ((Varobject)(p))->GCself = type_pointer_object(0,addr), \
      ((Varobject)(p))->header_flags = (type)
  #endif

# Objekte variabler Länge zwischen page->page_start und page->page_end zur
# Zusammenschiebung nach unten vorbereiten. Dabei wird in jedes markierte
# Objekt vorne der Pointer auf die Stelle eingetragen, wo das
# Objekt später stehen wird (samt Typinfo). Ist das darauffolgende
# Objekt unmarkiert, so wird in dessen erstem Pointer die Adresse
# des nächsten markierten Objekts eingetragen.
  #ifdef SPVW_PURE
  local aint gc_sweep1_varobject_page (uintL heapnr, aint start, aint end, object* firstmarked, aint dest);
  local aint gc_sweep1_varobject_page PARM5(heapnr,start,end,firstmarked,dest,
    var reg6 uintL heapnr,
    var aint start,
    var aint end,
    var object* firstmarked,
    var aint dest)
  #elif defined(GENERATIONAL_GC)
  local aint gc_sweep1_varobject_page (aint start, aint end, object* firstmarked, aint dest);
  local aint gc_sweep1_varobject_page PARM4(start,end,firstmarked,dest,
    var aint start,
    var aint end,
    var object* firstmarked,
    var aint dest)
  #else
  local void gc_sweep1_varobject_page (Page* page);
  local void gc_sweep1_varobject_page PARM1(page,
    var reg6 Page* page)
  #endif
    {
      #if defined(SPVW_PURE) || defined(GENERATIONAL_GC)
      var reg4 object* last_open_ptr = firstmarked;
      var reg2 aint p2 = start; # Source-Pointer
      var reg5 aint p2end = end; # obere Grenze des Source-Bereiches
      var reg3 aint p1 = dest; # Ziel-Pointer
      #else
      var reg4 object* last_open_ptr = &page->page_gcpriv.firstmarked;
        # In *last_open_ptr ist stets die Adresse des nächsten markierten
        # Objekts (als oint) einzutragen.
        # Durch verkettete-Liste-Mechanismus: Am Schluß enthält
        # page->gcpriv.firstmarked die Adresse des 1. markierten Objekts
      var reg2 aint p2 = page->page_start; # Source-Pointer
      var reg5 aint p2end = page->page_end; # obere Grenze des Source-Bereiches
      var reg3 aint p1 = p2; # Ziel-Pointer
      #endif
      # start <= p1 <= p2 <= end, p1 und p2 wachsen, p2 schneller als p1.
      var_speicher_laenge_;
      sweeploop1:
        # Nächstes markiertes Objekt suchen.
        # Adresse des nächsten markierten Objekts in *last_open_ptr eintragen.
        if (p2==p2end) goto sweepok1; # obere Grenze erreicht -> fertig
        { var reg2 tint flags = mtypecode(((Varobject)p2)->GCself);
          # Typinfo (und Flags bei Symbolen) retten
          var reg1 uintL laenge = calc_speicher_laenge(p2); # Byte-Länge bestimmen
          if (!marked(p2)) # Objekt unmarkiert?
            { p2 += laenge; goto sweeploop1; } # ja -> zum nächsten Objekt
          # Objekt markiert
          *last_open_ptr = type_pointer_object(0,p2); # Adresse ablegen
          set_GCself(p2, flags,p1); # neue Adresse eintragen, mit alter
                         # Typinfo (darin ist auch das Markierungsbit enthalten)
          p2 += laenge; # Sourceadresse für nächstes Objekt
          p1 += laenge; # Zieladresse für nächstes Objekt
        }
      sweeploop2:
        # Nächstes unmarkiertes Objekt suchen.
        if (p2==p2end) goto sweepok2; # obere Grenze erreicht -> fertig
        { var reg2 tint flags = mtypecode(((Varobject)p2)->GCself);
          # Typinfo (und Flags bei Symbolen) retten
          var reg1 uintL laenge = calc_speicher_laenge(p2); # Byte-Länge bestimmen
          if (!marked(p2)) # Objekt unmarkiert?
            { last_open_ptr = (object*)p2; # ja -> Hier den nächsten Pointer ablegen
              p2 += laenge; goto sweeploop1; # und zum nächsten Objekt
            }
          # Objekt markiert
          set_GCself(p2, flags,p1); # neue Adresse eintragen, mit alter
                         # Typinfo (darin ist auch das Markierungsbit enthalten)
          p2 += laenge; # Sourceadresse für nächstes Objekt
          p1 += laenge; # Zieladresse für nächstes Objekt
          goto sweeploop2;
        }
      sweepok1: *last_open_ptr = type_pointer_object(0,p2);
      sweepok2: ;
      #if defined(SPVW_PURE) || defined(GENERATIONAL_GC)
      return p1;
      #endif
    }

# Aktualisierungsphase:
  # Der gesamte LISP-Speicher wird durchgegangen und dabei alte durch
  # neue Adressen ersetzt.
  # Aktualisierung eines Objekts *objptr :
    #if !defined(MORRIS_GC)
      #define aktualisiere(objptr)  \
        { var reg2 tint type = mtypecode(*(object*)objptr);                     \
          if (!immediate_type_p(type)) # unverschieblich -> nichts tun          \
            { var reg1 object obj = *(object*)objptr; # fragliches Objekt       \
              if (!in_old_generation(obj,type,mem.heapnr_from_type[type]))      \
                # ältere Generation -> nichts zu tun (Objekt blieb stehen)      \
                if (marked(ThePointer(obj))) # markiert?                        \
                  # nein -> nichts zu tun (Objekt blieb stehen)                 \
                  # ja -> neue Adresse eintragen und Typinfobyte (incl.         \
                  #       evtl. Symbol-Bindungsflags) zurückschreiben           \
                  *(object*)objptr =                                            \
                    type_untype_object(type,untype(*(object*)ThePointer(obj))); \
        }   }
    #else # defined(MORRIS_GC)
      #if defined(SPVW_MIXED_BLOCKS)
        #define aktualisiere(objptr)  \
          { var reg2 tint type = mtypecode(*(object*)objptr);                     \
            if (!immediate_type_p(type)) # unverschieblich -> nichts tun          \
              switch (type)                                                       \
                { default: # Objekt variabler Länge                               \
                    { var reg1 object obj = *(object*)objptr; # fragliches Objekt \
                      if (!in_old_generation(obj,type,0))                         \
                        if (marked(ThePointer(obj))) # markiert?                  \
                          *(object*)objptr = type_untype_object(type,untype(*(object*)ThePointer(obj))); \
                    }                                                             \
                    break;                                                        \
                  case_cons: case_ratio: case_complex: # Zwei-Pointer-Objekt      \
                    { var reg1 object obj = *(object*)objptr; # fragliches Objekt \
                      if (!in_old_generation(obj,type,1))                         \
                        { # Für spätere Aktualisierung in dessen Liste einhängen: \
                          *(object*)objptr = *(object*)ThePointer(obj);           \
                          *(object*)ThePointer(obj) = with_mark_bit(type_pointer_object(type,objptr)); \
                    }   }                                                         \
                    break;                                                        \
          }     }
      #else # defined(SPVW_PURE_BLOCKS) # && defined(SINGLEMAP_MEMORY)
        #define aktualisiere(objptr)  \
          { var reg2 tint type = mtypecode(*(object*)objptr);                 \
            if (!is_unused_heap(type)) # unverschieblich -> nichts tun        \
              { var reg1 object obj = *(object*)objptr; # fragliches Objekt   \
                if (!in_old_generation(obj,type,?))                           \
                  # ältere Generation -> nichts zu tun (Objekt blieb stehen)  \
                  if (is_varobject_heap(type))                                \
                    # Objekt variabler Länge                                  \
                    { if (marked(ThePointer(obj))) # markiert?                \
                        *(object*)objptr = type_untype_object(type,untype(*(object*)ThePointer(obj))); \
                    }                                                         \
                    else                                                      \
                    # Zwei-Pointer-Objekt                                     \
                    { # Für spätere Aktualisierung in dessen Liste einhängen: \
                      *(object*)objptr = *(object*)ThePointer(obj);           \
                      *(object*)ThePointer(obj) = with_mark_bit(type_pointer_object(0,objptr)); \
                    }                                                         \
          }   }
      #endif
    #endif
  # Durchlaufen durch alle LISP-Objekte und aktualisieren:
    # Pointer im LISP-Stack aktualisieren:
      local void aktualisiere_STACK (void);
      local void aktualisiere_STACK()
        { var reg3 object* objptr = &STACK_0; # Pointer, der durch den STACK läuft
          until (eq(*objptr,nullobj)) # bis STACK zu Ende ist:
            { if ( *((oint*)objptr) & wbit(frame_bit_o) ) # Beginnt hier ein Frame?
               { if (( *((oint*)objptr) & wbit(skip2_bit_o) ) == 0) # Ohne skip2-Bit?
                  objptr skipSTACKop 2; # ja -> um 2 weiterrücken
                  else
                  objptr skipSTACKop 1; # nein -> um 1 weiterrücken
               }
               else
               { # normales Objekt, aktualisieren:
                 switch (mtypecode(*objptr))
                   { case_symbolflagged: # Symbol mit evtl. Flags
                       #ifndef NO_symbolflags
                       { var reg6 object obj1 = *objptr;
                         var reg4 object obj2 = symbol_without_flags(obj1);
                         var reg5 oint flags = as_oint(obj1) ^ as_oint(obj2);
                         *objptr = obj2; # vorerst Flags löschen
                         aktualisiere(objptr); # dann aktualisieren
                         *(oint*)objptr |= flags; # dann Flags wieder rein
                         break;
                       }
                       #endif
                     default: aktualisiere(objptr); break;
                   }
                 objptr skipSTACKop 1; # weiterrücken
        }   }  }
    # Die folgenden Macros rufen den Macro aktualisiere() auf.
    # Programmkonstanten aktualisieren:
      #define aktualisiere_subr_tab()  \
        for_all_subrs(                                                   \
          { var reg3 object* p = (object*)((aint)ptr+subr_const_offset); \
            var reg4 uintC c;                                            \
            dotimespC(c,subr_const_anz, { aktualisiere(p); p++; } );     \
          }                                                              \
          );
      #define aktualisiere_symbol_tab()  \
        for_all_constsyms( # symbol_tab durchgehen  \
          { var reg3 object* p;                     \
            p = &ptr->symvalue; aktualisiere(p);    \
            p = &ptr->symfunction; aktualisiere(p); \
            p = &ptr->proplist; aktualisiere(p);    \
            p = &ptr->pname; aktualisiere(p);       \
            p = &ptr->homepackage; aktualisiere(p); \
          }                                         \
          );
      #define aktualisiere_object_tab()  \
        for_all_constobjs( aktualisiere(objptr); ); # object_tab durchgehen
      #define aktualisiere_tab()  \
        { aktualisiere_subr_tab();   \
          aktualisiere_symbol_tab(); \
          aktualisiere_object_tab(); \
        }
    # Pointer in den Cons-Zellen aktualisieren:
      #define aktualisiere_conses()  \
        for_each_cons_page(page,                      \
          { var reg3 aint objptr = page->page_start;  \
            var reg4 aint objptrend = page->page_end; \
            # alle Pointer im (neuen) CONS-Bereich start <= Adresse < end aktualisieren: \
            until (objptr==objptrend)                 \
              { aktualisiere((object*)objptr);        \
                objptr += sizeof(object);             \
                aktualisiere((object*)objptr);        \
                objptr += sizeof(object);             \
          }   }                                       \
          );
    # Pointer in den Objekten variabler Länge aktualisieren:
    #   #define aktualisiere_page ...
    #   aktualisiere_varobjects();
    #   #undef aktualisiere_page
      #define aktualisiere_page_normal(page,aktualisierer)  \
        { var reg2 aint ptr = page->page_start;                        \
          var reg6 aint ptrend = page->page_end;                       \
          # alle Objekte mit Adresse >=ptr, <ptrend durchgehen:        \
          until (ptr==ptrend) # solange bis ptr am Ende angekommen ist \
            { # nächstes Objekt mit Adresse ptr (< ptrend) durchgehen: \
              aktualisierer(typecode_at(ptr)); # und weiterrücken      \
        }   }
      # aktualisiert das Objekt bei 'ptr', dessen Typcode durch 'type_expr'
      # gegeben wird, und rückt ptr weiter:
      #ifdef SPVW_MIXED
      #define aktualisiere_varobject(type_expr)  \
        { var reg5 tint type = (type_expr); # Typinfo                                         \
          var reg7 uintL laenge = calc_speicher_laenge(ptr); # Länge bestimmen                \
          var reg8 aint newptr = ptr+laenge; # Zeiger auf nächstes Objekt                     \
          # Fallunterscheidung nach:                                                          \
            # Symbol; Simple-Vector; Nicht-simpler Array;                                     \
            # Record (insbes. Hash-Table); Rest.                                              \
          switch (type)                                                                       \
            { case_symbolwithflags:                                                           \
                # Symbol: alle Pointer innerhalb eines Symbols aktualisieren                  \
                { var reg3 object* p = (object*)pointerplus(ptr,symbol_objects_offset);       \
                  var reg4 uintC count;                                                       \
                  dotimespC(count,((sizeof(symbol_)-symbol_objects_offset)/sizeof(object)),   \
                    { aktualisiere(p); p++; } );                                              \
                }                                                                             \
                break;                                                                        \
              case_svector:                                                                   \
                # Simple-vector: alle Pointer innerhalb eines Simple-vector aktualisieren     \
                { var reg3 uintL count = ((Svector)ptr)->length;                              \
                  if (!(count==0))                                                            \
                    {var reg4 object* p = &((Svector)ptr)->data[0];                           \
                     dotimespL(count,count, { aktualisiere(p); p++; } );                      \
                }   }                                                                         \
                break;                                                                        \
              case_array1: case_obvector: case_ostring: case_ovector:                         \
                # nicht-simpler Array: Datenvektor aktualisieren                              \
                { var reg3 object* p = &((Array)ptr)->data;                                   \
                  aktualisiere(p);                                                            \
                }                                                                             \
                break;                                                                        \
              case_record:                                                                    \
                # Record: alle Pointer innerhalb eines Record aktualisieren                   \
                { # Beim Aktualisieren von Pointern verliert der Aufbau von                   \
                  # Hash-Tables seine Gültigkeit (denn die Hashfunktion eines                 \
                  # Objekts hängt von seiner Adresse ab, die sich ja jetzt                    \
                  # verändert).                                                               \
                  if (((Record)ptr)->rectype == Rectype_Hashtable) # eine Hash-Table ?        \
                    { mark_ht_invalid((Hashtable)ptr); } # ja -> für Reorganisation vormerken \
                  elif (aktualisiere_fpointer_invalid && (((Record)ptr)->rectype == Rectype_Fpointer)) # Foreign-Pointer ? \
                    { mark_fp_invalid((Record)ptr); } # ja -> evtl. ungültig machen           \
                 {var reg3 uintC count = (((Record)ptr)->rectype < 0 ? ((Srecord)ptr)->reclength : ((Xrecord)ptr)->reclength); \
                  if (!(count==0))                                                            \
                    { var reg4 object* p = &((Record)ptr)->recdata[0];                        \
                      dotimespC(count,count, { aktualisiere(p); p++; } );                     \
                }}  }                                                                         \
                break;                                                                        \
              default:                                                                        \
                break; # alle anderen enthalten keine zu aktualisierenden Pointer             \
                       # -> nichts tun                                                        \
            }                                                                                 \
          # zum nächsten Objekt weiterrücken                                                  \
          ptr = newptr;                                                                       \
        }
      #define aktualisiere_varobjects()  \
        for_each_varobject_page(page,                    \
          aktualisiere_page(page,aktualisiere_varobject) \
          );
      #endif
      #ifdef SPVW_PURE
      #define aktualisiere_symbol(type_expr)  # ignoriert type_expr \
        { var reg7 uintL laenge = speicher_laenge_symbol((void*)ptr); # Länge bestimmen \
          var reg8 aint newptr = ptr+laenge; # Zeiger auf nächstes Objekt               \
          # Symbol: alle Pointer innerhalb eines Symbols aktualisieren                  \
          { var reg3 object* p = (object*)pointerplus(ptr,symbol_objects_offset);       \
            var reg4 uintC count;                                                       \
            dotimespC(count,((sizeof(symbol_)-symbol_objects_offset)/sizeof(object)),   \
              { aktualisiere(p); p++; } );                                              \
          }                                                                             \
          ptr = newptr; # zum nächsten Objekt weiterrücken                              \
        }
      #define aktualisiere_svector(type_expr)  # ignoriert type_expr \
        { var reg7 uintL laenge = speicher_laenge_svector((void*)ptr); # Länge bestimmen \
          var reg8 aint newptr = ptr+laenge; # Zeiger auf nächstes Objekt                \
          # Simple-vector: alle Pointer innerhalb eines Simple-vector aktualisieren      \
          { var reg3 uintL count = ((Svector)ptr)->length;                               \
            if (!(count==0))                                                             \
              {var reg4 object* p = &((Svector)ptr)->data[0];                            \
               dotimespL(count,count, { aktualisiere(p); p++; } );                       \
          }   }                                                                          \
          ptr = newptr; # zum nächsten Objekt weiterrücken                               \
        }
      #define aktualisiere_array(type_expr)  # ignoriert type_expr \
        { var reg7 uintL laenge = speicher_laenge_array((void*)ptr); # Länge bestimmen \
          var reg8 aint newptr = ptr+laenge; # Zeiger auf nächstes Objekt              \
          # nicht-simpler Array: Datenvektor aktualisieren                             \
          { var reg3 object* p = &((Array)ptr)->data;                                  \
            aktualisiere(p);                                                           \
          }                                                                            \
          ptr = newptr; # zum nächsten Objekt weiterrücken                             \
        }
      #define aktualisiere_record(type_expr)  # ignoriert type_expr \
        { var reg7 uintL laenge = speicher_laenge_record((void*)ptr); # Länge bestimmen \
          var reg8 aint newptr = ptr+laenge; # Zeiger auf nächstes Objekt               \
          # Record: alle Pointer innerhalb eines Record aktualisieren                   \
          { # Beim Aktualisieren von Pointern verliert der Aufbau von                   \
            # Hash-Tables seine Gültigkeit (denn die Hashfunktion eines                 \
            # Objekts hängt von seiner Adresse ab, die sich ja jetzt                    \
            # verändert).                                                               \
            if (((Record)ptr)->rectype == Rectype_Hashtable) # eine Hash-Table ?        \
              { mark_ht_invalid((Hashtable)ptr); } # ja -> für Reorganisation vormerken \
            elif (aktualisiere_fpointer_invalid && (((Record)ptr)->rectype == Rectype_Fpointer)) # Foreign-Pointer ? \
              { mark_fp_invalid((Record)ptr); } # ja -> evtl. ungültig machen           \
           {var reg3 uintC count = (((Record)ptr)->rectype < 0 ? ((Srecord)ptr)->reclength : ((Xrecord)ptr)->reclength); \
            if (!(count==0))                                                            \
              { var reg4 object* p = &((Record)ptr)->recdata[0];                        \
                dotimespC(count,count, { aktualisiere(p); p++; } );                     \
          }}  }                                                                         \
          ptr = newptr; # zum nächsten Objekt weiterrücken                              \
        }
      #define aktualisiere_varobjects()  \
        for_each_varobject_page(page,                                               \
          { # Fallunterscheidung nach:                                              \
              # Symbol; Simple-Vector; Nicht-simpler Array;                         \
              # Record (insbes. Hash-Table); Rest.                                  \
            switch (heapnr)                                                         \
              { case_symbol:                                                        \
                  aktualisiere_page(page,aktualisiere_symbol); break;               \
                case_svector:                                                       \
                  aktualisiere_page(page,aktualisiere_svector); break;              \
                case_array1: case_obvector: case_ostring: case_ovector:             \
                  aktualisiere_page(page,aktualisiere_array); break;                \
                case_record:                                                        \
                  aktualisiere_page(page,aktualisiere_record); break;               \
                default:                                                            \
                  break; # alle anderen enthalten keine zu aktualisierenden Pointer \
                         # -> nichts tun                                            \
          }   }                                                                     \
          );
      #endif
    #ifdef GENERATIONAL_GC
    # Pointer in den Objekten der alten Generation aktualisieren:
      local void aktualisiere_old_generation (void);
      local void aktualisiere_at (object* ptr);
      local void aktualisiere_at(ptr)
        var reg3 object* ptr;
        { aktualisiere(ptr); }
      local void aktualisiere_old_generation()
        { var reg7 uintL heapnr;
          for (heapnr=0; heapnr<heapcount; heapnr++)
            if (is_heap_containing_objects(heapnr)) # Objekte, die keine Pointer enthalten,
                                                    # braucht man nicht zu durchlaufen.
              { var reg6 Heap* heap = &mem.heaps[heapnr];
                var reg4 aint gen0_start = heap->heap_gen0_start;
                var reg5 aint gen0_end = heap->heap_gen0_end;
                if (gen0_start < gen0_end)
                  if (heap->physpages==NULL)
                    { walk_area_(heapnr,gen0_start,gen0_end,aktualisiere_at); } # fallback
                    else
                    { var reg3 physpage_state* physpage = heap->physpages;
                      gen0_start &= -physpagesize;
                      do { if ((physpage->protection == PROT_NONE)
                               || (physpage->protection == PROT_READ)
                              )
                             # Cache ausnutzen, gecachte Pointer aktualisieren:
                             { var reg2 uintL count = physpage->cache_size;
                               if (count > 0)
                                 { var reg1 old_new_pointer* ptr = physpage->cache;
                                   dotimespL(count,count, { aktualisiere(&ptr->o); ptr++; } );
                                   if (!(physpage->protection == PROT_NONE))
                                     { xmmprotect(gen0_start,physpagesize,PROT_NONE);
                                       physpage->protection = PROT_NONE;
                             }   }   }
                             else
                             # ganzen Page-Inhalt aktualisieren:
                             { walk_physpage_(heapnr,physpage,gen0_start+physpagesize,gen0_end,aktualisiere_at); }
                           gen0_start += physpagesize;
                           physpage++;
                         }
                         while (gen0_start < gen0_end);
        }     }     }
      #undef aktualisiere_at
    #endif

# Zweite SWEEP-Phase:
  # Verschiebung eines Objekts variabler Länge, p1 und p2 weiterrücken:
  # move_aligned_p1_p2(count);
  #if (varobject_alignment==1)
    #define uintV  uintB
  #elif (varobject_alignment==2)
    #define uintV  uintW
  #elif (varobject_alignment==4)
    #define uintV  uintL
  #elif (varobject_alignment==8)
    #define uintV  uintL2
  #else
    #error "Unbekannter Wert von 'varobject_alignment'!"
  #endif
  #ifdef GNU # so läßt sich's besser optimieren
    #ifdef fast_dotimesL
      #define move_aligned_p1_p2(count)  \
        dotimespL(count,count/varobject_alignment, *((uintV*)p2)++ = *((uintV*)p1)++; )
    #else
      #define move_aligned_p1_p2(count)  \
        do { *((uintV*)p2)++ = *((uintV*)p1)++; count -= varobject_alignment; } until (count==0)
    #endif
  #else # andere Compiler akzeptieren ((type*)p)++ nicht.
    # Wie effizient ist das hier ??
    #define move_aligned_p1_p2(count)  \
      do { *(uintV*)p2 = *(uintV*)p1;                            \
           p1 += varobject_alignment; p2 += varobject_alignment; \
           count -= varobject_alignment;                         \
         }                                                                              \
         until (count==0)
  #endif
  # Die Objekte variabler Länge werden an die vorher berechneten
  # neuen Plätze geschoben.
  #ifdef SPVW_PURE
  local void gc_sweep2_varobject_page (Page* page, uintL heapnr);
  local void gc_sweep2_varobject_page PARM2(page,heapnr,
    var reg5 Page* page,
    var reg6 uintL heapnr)
  #else
  local void gc_sweep2_varobject_page (Page* page);
  local void gc_sweep2_varobject_page PARM1(page,
    var reg5 Page* page)
  #endif
    # Von unten nach oben durchgehen und dabei runterschieben:
    { var reg1 aint p1 = (aint)type_pointable(0,page->page_gcpriv.firstmarked); # Source-Pointer, erstes markiertes Objekt
      var reg4 aint p1end = page->page_end;
      var reg2 aint p2 = page->page_start; # Ziel-Pointer
      var_speicher_laenge_;
      until (p1==p1end) # obere Grenze erreicht -> fertig
        { # nächstes Objekt hat Adresse p1
          if (marked(p1)) # markiert?
            { unmark(p1); # Markierung löschen
              # Objekt behalten und verschieben:
             {var reg3 uintL count = calc_speicher_laenge(p1); # Länge (durch varobject_alignment teilbar, >0)
              if (!(p1==p2)) # falls Verschiebung nötig
                { move_aligned_p1_p2(count); } # verschieben und weiterrücken
                else # sonst nur weiterrücken:
                { p1 += count; p2 += count; }
            }}
            else
            { p1 = (aint)type_pointable(0,*(object*)p1); } # mit Pointer (Typinfo=0) zum nächsten markierten Objekt
        }
      page->page_end = p2; # obere Grenze der Objekte variabler Länge neu setzen
    }

#ifdef GENERATIONAL_GC

  # Baut einen Cache aller Pointer in der alten Generation.
  # Die neue Generation ist leer; Pointer in die neue Generation gibt es daher keine!
  local void build_old_generation_cache (uintL heapnr);
  local void build_old_generation_cache(heapnr)
    var reg10 uintL heapnr;
    { if (is_heap_containing_objects(heapnr)) # Objekte, die keine Pointer enthalten, brauchen keinen Cache.
        { var reg8 Heap* heap = &mem.heaps[heapnr];
          var reg6 aint gen0_start = heap->heap_gen0_start;
          var reg7 aint gen0_end = heap->heap_gen0_end;
          var reg10 aint gen0_start_pa = gen0_start & -physpagesize; # page-aligned
          var reg10 aint gen0_end_pa = (gen0_end + (physpagesize-1)) & -physpagesize; # page-aligned
         {var reg9 uintL physpage_count = (gen0_end_pa - gen0_start_pa) >> physpageshift;
          if (physpage_count==0)
            { xfree(heap->physpages); heap->physpages = NULL; }
            else
            { heap->physpages = xrealloc(heap->physpages,physpage_count*sizeof(physpage_state));
              if (!(heap->physpages==NULL))
                { # Wenn wir fertig sind, wird sowohl Cache als auch Speicherinhalt
                  # gültig sein:
                  xmmprotect(gen0_start_pa, gen0_end_pa-gen0_start_pa, PROT_READ);
                  # heap->physpages[0..physpage_count-1] füllen:
                  { var reg1 physpage_state* physpage = heap->physpages;
                    var reg2 uintL count;
                    dotimespL(count,physpage_count,
                      { physpage->protection = PROT_READ;
                        physpage->cache_size = 0; physpage->cache = NULL;
                        physpage++;
                      });
                  }
                  if (is_cons_heap(heapnr))
                    # Conses u.ä.
                    { # Von gen0_start bis gen0_end sind alles Pointer.
                      var reg1 physpage_state* physpage = heap->physpages;
                      var reg2 uintL count;
                      #ifndef SPVW_MIXED_BLOCKS_OPPOSITE
                      # Alle Seiten bis auf die letzte voll, die letzte teilweise voll.
                      dotimesL(count,physpage_count-1,
                        { # für i=0,1,...:
                          #   gen0_start = heap->heap_gen0_start + i*physpagesize
                          #   physpage = &heap->physpages[i]
                          physpage->continued_addr = (object*)gen0_start;
                          physpage->continued_count = physpagesize/sizeof(object);
                          gen0_start += physpagesize;
                          physpage->firstobject = gen0_start;
                          physpage++;
                        });
                      physpage->continued_addr = (object*)gen0_start;
                      physpage->continued_count = (gen0_end-gen0_start)/sizeof(object);
                      physpage->firstobject = gen0_end;
                      #else
                      # Alle Seiten bis auf die erste voll, die erste teilweise voll.
                      physpage->continued_addr = (object*)gen0_start;
                      physpage->continued_count = ((gen0_start_pa+physpagesize)-gen0_start)/sizeof(object);
                      physpage->firstobject = gen0_start = gen0_start_pa+physpagesize;
                      dotimesL(count,physpage_count-1,
                        { physpage++;
                          # für i=1,...:
                          #   gen0_start = (heap->heap_gen0_start & -physpagesize) + i*physpagesize
                          #   physpage = &heap->physpages[i]
                          physpage->continued_addr = (object*)gen0_start;
                          physpage->continued_count = physpagesize/sizeof(object);
                          gen0_start += physpagesize;
                          physpage->firstobject = gen0_start;
                        });
                      #endif
                    }
                    else
                    # is_varobject_heap(heapnr), Objekte variabler Länge
                    { var reg1 physpage_state* physpage = heap->physpages;
                      var reg5 aint objptr = gen0_start;
                      # Für i=0,1,... ist
                      #   gen0_start = heap->heap_gen0_start + i*physpagesize
                      #   physpage = &heap->physpages[i]
                      # Mit wachsendem i geht man von einer Seite zur nächsten.
                      # Gleichzeitig geht man von einem Objekt zum nächsten und markiert
                      # alle Pointer zwischen objptr (Pointer auf das aktuelle Objekt)
                      # und nextptr (Pointer auf das nächste Objekt). Glücklicherweise
                      # kommen in allen unseren Objekten die Pointer am Stück:
                      # ab ptr kommen count Pointer.
                      # Das Intervall ptr...ptr+count*sizeof(object) wird nun zerlegt.
                      #ifdef SPVW_PURE
                      switch (heapnr)
                        { case_symbol: # Symbol
                            physpage->continued_addr = (object*)gen0_start; # irrelevant
                            physpage->continued_count = 0;
                            physpage->firstobject = gen0_start;
                            gen0_start += physpagesize; physpage++;
                            while (objptr < gen0_end)
                              { var reg4 aint nextptr = objptr + size_symbol();
                                # Hier ist gen0_start-physpagesize <= objptr < gen0_start.
                                if (nextptr >= gen0_start)
                                  { var reg2 aint ptr = objptr+symbol_objects_offset;
                                    var reg3 uintC count = (sizeof(symbol_)-symbol_objects_offset)/sizeof(object);
                                    if (ptr < gen0_start)
                                      { physpage->continued_addr = (object*)gen0_start;
                                        physpage->continued_count = count - (gen0_start-ptr)/sizeof(object);
                                      }
                                      else
                                      { physpage->continued_addr = (object*)ptr;
                                        physpage->continued_count = count;
                                      }
                                    physpage->firstobject = nextptr;
                                    # Man überquert höchstens eine Seitengrenze auf einmal.
                                    gen0_start += physpagesize; physpage++;
                                  }
                                objptr = nextptr;
                              }
                            if (!(objptr == gen0_end)) abort();
                            break;
                          case_array1: case_obvector: case_ostring: case_ovector: # nicht-simple Arrays:
                            physpage->continued_addr = (object*)gen0_start; # irrelevant
                            physpage->continued_count = 0;
                            physpage->firstobject = gen0_start;
                            gen0_start += physpagesize; physpage++;
                            while (objptr < gen0_end)
                              { var reg3 aint nextptr = objptr + speicher_laenge_array((Array)objptr);
                                # Hier ist gen0_start-physpagesize <= objptr < gen0_start.
                                if (nextptr >= gen0_start)
                                  { var reg2 aint ptr = (aint)&((Array)objptr)->data;
                                    # count = 1;
                                    if (ptr < gen0_start)
                                      { physpage->continued_addr = (object*)gen0_start; # irrelevant
                                        physpage->continued_count = 0;
                                      }
                                      else
                                      { physpage->continued_addr = (object*)ptr;
                                        physpage->continued_count = 1;
                                      }
                                    # Man überquerte höchstens eine Seitengrenze.
                                    # Danach kommen (bis nextptr) keine Pointer mehr.
                                    loop
                                      { physpage->firstobject = nextptr;
                                        gen0_start += physpagesize; physpage++;
                                        if (nextptr < gen0_start) break;
                                        physpage->continued_addr = (object*)gen0_start; # irrelevant
                                        physpage->continued_count = 0;
                                      }
                                  }
                                objptr = nextptr;
                              }
                            if (!(objptr == gen0_end)) abort();
                            break;
                          case_svector: # simple-vector
                            physpage->continued_addr = (object*)gen0_start; # irrelevant
                            physpage->continued_count = 0;
                            physpage->firstobject = gen0_start;
                            gen0_start += physpagesize; physpage++;
                            while (objptr < gen0_end)
                              { var reg3 uintL count = ((Svector)objptr)->length;
                                var reg4 aint nextptr = objptr + size_svector(count);
                                # Hier ist gen0_start-physpagesize <= objptr < gen0_start.
                                if (nextptr >= gen0_start)
                                  { var reg2 aint ptr = (aint)&((Svector)objptr)->data[0];
                                    if (ptr < gen0_start)
                                      { var reg3 uintL count_thispage = (gen0_start-ptr)/sizeof(object);
                                        if ((varobject_alignment == sizeof(object)) # das erzwingt count >= count_thispage
                                            || (count >= count_thispage)
                                           )
                                          { count -= count_thispage; }
                                          else
                                          { count = 0; }
                                        ptr = gen0_start;
                                      }
                                    do { physpage->continued_addr = (object*)ptr;
                                         gen0_start += physpagesize;
                                        {var reg3 uintL count_thispage = (gen0_start-ptr)/sizeof(object);
                                         if (count >= count_thispage)
                                           { physpage->continued_count = count_thispage;
                                             count -= count_thispage;
                                           }
                                           else
                                           { physpage->continued_count = count; count = 0; }
                                         physpage->firstobject = nextptr;
                                         physpage++;
                                         ptr = gen0_start;
                                       }}
                                       until (nextptr < gen0_start);
                                  }
                                objptr = nextptr;
                              }
                            if (!(objptr == gen0_end)) abort();
                            break;
                          case_record: # Record
                            physpage->continued_addr = (object*)gen0_start; # irrelevant
                            physpage->continued_count = 0;
                            physpage->firstobject = gen0_start;
                            gen0_start += physpagesize; physpage++;
                            while (objptr < gen0_end)
                              { var reg3 uintC count;
                                var reg4 aint nextptr;
                                if (((Record)objptr)->rectype < 0)
                                  { count = ((Srecord)objptr)->reclength; nextptr = objptr + size_srecord(count); }
                                  else
                                  { count = ((Xrecord)objptr)->reclength; nextptr = objptr + size_xrecord(count,((Xrecord)objptr)->recxlength); }
                                if (nextptr >= gen0_start)
                                  { var reg2 aint ptr = (aint)&((Record)objptr)->recdata[0];
                                    if (ptr < gen0_start)
                                      { var reg3 uintL count_thispage = (gen0_start-ptr)/sizeof(object);
                                        if ((varobject_alignment == sizeof(object)) # das erzwingt count >= count_thispage
                                            || (count >= count_thispage)
                                           )
                                          { count -= count_thispage; }
                                          else
                                          { count = 0; }
                                        ptr = gen0_start;
                                      }
                                    do { physpage->continued_addr = (object*)ptr;
                                         gen0_start += physpagesize;
                                        {var reg3 uintL count_thispage = (gen0_start-ptr)/sizeof(object);
                                         if (count >= count_thispage)
                                           { physpage->continued_count = count_thispage;
                                             count -= count_thispage;
                                           }
                                           else
                                           { physpage->continued_count = count; count = 0; }
                                         physpage->firstobject = nextptr;
                                         physpage++;
                                         ptr = gen0_start;
                                       }}
                                       until (nextptr < gen0_start);
                                  }
                                objptr = nextptr;
                              }
                            if (!(objptr == gen0_end)) abort();
                            break;
                          default:
                            # Solche Objekte kommen nicht vor.
                            abort();
                        }
                      #else # SPVW_MIXED
                      physpage->continued_addr = (object*)gen0_start; # irrelevant
                      physpage->continued_count = 0;
                      physpage->firstobject = gen0_start;
                      gen0_start += physpagesize; physpage++;
                      while (objptr < gen0_end)
                        { switch (typecode_at(objptr)) # Typ des nächsten Objekts
                            { case_symbolwithflags: # Symbol
                                { var reg4 aint nextptr = objptr + size_symbol();
                                  # Hier ist gen0_start-physpagesize <= objptr < gen0_start.
                                  if (nextptr >= gen0_start)
                                    { var reg2 aint ptr = objptr+symbol_objects_offset;
                                      var reg3 uintC count = (sizeof(symbol_)-symbol_objects_offset)/sizeof(object);
                                      if (ptr < gen0_start)
                                        { physpage->continued_addr = (object*)gen0_start;
                                          physpage->continued_count = count - (gen0_start-ptr)/sizeof(object);
                                        }
                                        else
                                        { physpage->continued_addr = (object*)ptr;
                                          physpage->continued_count = count;
                                        }
                                      physpage->firstobject = nextptr;
                                      # Man überquert höchstens eine Seitengrenze auf einmal.
                                      gen0_start += physpagesize; physpage++;
                                    }
                                  objptr = nextptr;
                                }
                                break;
                              case_array1: case_obvector: case_ostring: case_ovector: # nicht-simple Arrays:
                                { var reg3 aint nextptr = objptr + speicher_laenge((Array)objptr);
                                  # Hier ist gen0_start-physpagesize <= objptr < gen0_start.
                                  if (nextptr >= gen0_start)
                                    { var reg2 aint ptr = (aint)&((Array)objptr)->data;
                                      # count = 1;
                                      if (ptr < gen0_start)
                                        { physpage->continued_addr = (object*)gen0_start; # irrelevant
                                          physpage->continued_count = 0;
                                        }
                                        else
                                        { physpage->continued_addr = (object*)ptr;
                                          physpage->continued_count = 1;
                                        }
                                      # Man überquerte höchstens eine Seitengrenze.
                                      # Danach kommen (bis nextptr) keine Pointer mehr.
                                      loop
                                        { physpage->firstobject = nextptr;
                                          gen0_start += physpagesize; physpage++;
                                          if (nextptr < gen0_start) break;
                                          physpage->continued_addr = (object*)gen0_start; # irrelevant
                                          physpage->continued_count = 0;
                                        }
                                    }
                                  objptr = nextptr;
                                }
                                break;
                              case_svector: # simple-vector
                                { var reg3 uintL count = ((Svector)objptr)->length;
                                  var reg4 aint nextptr = objptr + size_svector(count);
                                  # Hier ist gen0_start-physpagesize <= objptr < gen0_start.
                                  if (nextptr >= gen0_start)
                                    { var reg2 aint ptr = (aint)&((Svector)objptr)->data[0];
                                      if (ptr < gen0_start)
                                        { var reg3 uintL count_thispage = (gen0_start-ptr)/sizeof(object);
                                          if ((varobject_alignment == sizeof(object)) # das erzwingt count >= count_thispage
                                              || (count >= count_thispage)
                                             )
                                            { count -= count_thispage; }
                                            else
                                            { count = 0; }
                                          ptr = gen0_start;
                                        }
                                      do { physpage->continued_addr = (object*)ptr;
                                           gen0_start += physpagesize;
                                          {var reg3 uintL count_thispage = (gen0_start-ptr)/sizeof(object);
                                           if (count >= count_thispage)
                                             { physpage->continued_count = count_thispage;
                                               count -= count_thispage;
                                             }
                                             else
                                             { physpage->continued_count = count; count = 0; }
                                           physpage->firstobject = nextptr;
                                           physpage++;
                                           ptr = gen0_start;
                                         }}
                                         until (nextptr < gen0_start);
                                    }
                                  objptr = nextptr;
                                }
                                break;
                              case_record: # Record
                                { var reg3 uintC count;
                                  var reg4 aint nextptr;
                                  if (((Record)objptr)->rectype < 0)
                                    { count = ((Srecord)objptr)->reclength; nextptr = objptr + size_srecord(count); }
                                    else
                                    { count = ((Xrecord)objptr)->reclength; nextptr = objptr + size_xrecord(count,((Xrecord)objptr)->recxlength); }
                                  if (nextptr >= gen0_start)
                                    { var reg2 aint ptr = (aint)&((Record)objptr)->recdata[0];
                                      if (ptr < gen0_start)
                                        { var reg3 uintL count_thispage = (gen0_start-ptr)/sizeof(object);
                                          if ((varobject_alignment == sizeof(object)) # das erzwingt count >= count_thispage
                                              || (count >= count_thispage)
                                             )
                                            { count -= count_thispage; }
                                            else
                                            { count = 0; }
                                          ptr = gen0_start;
                                        }
                                      do { physpage->continued_addr = (object*)ptr;
                                           gen0_start += physpagesize;
                                          {var reg3 uintL count_thispage = (gen0_start-ptr)/sizeof(object);
                                           if (count >= count_thispage)
                                             { physpage->continued_count = count_thispage;
                                               count -= count_thispage;
                                             }
                                             else
                                             { physpage->continued_count = count; count = 0; }
                                           physpage->firstobject = nextptr;
                                           physpage++;
                                           ptr = gen0_start;
                                         }}
                                         until (nextptr < gen0_start);
                                    }
                                  objptr = nextptr;
                                }
                                break;
                              default: # simple-bit-vector, simple-string, bignum, float
                                # Keine Pointer.
                                objptr += speicher_laenge((Varobject)objptr);
                                while (objptr >= gen0_start)
                                  { physpage->continued_addr = (object*)gen0_start; # irrelevant
                                    physpage->continued_count = 0;
                                    physpage->firstobject = objptr;
                                    gen0_start += physpagesize; physpage++;
                                  }
                                break;
                        }   }
                      if (!(objptr == gen0_end)) abort();
                      #endif
                    }
                }
    }   }}  }

  # Baut einen Cache aller Pointer von der alten in die neue Generation.
  local void rebuild_old_generation_cache (uintL heapnr);
  local void rebuild_old_generation_cache(heapnr)
    var reg10 uintL heapnr;
    { if (is_heap_containing_objects(heapnr)) # Objekte, die keine Pointer enthalten, brauchen keinen Cache.
        { var reg9 Heap* heap = &mem.heaps[heapnr];
          var reg6 aint gen0_start = heap->heap_gen0_start;
          var reg7 aint gen0_end = heap->heap_gen0_end;
          if ((gen0_start < gen0_end) && !(heap->physpages==NULL))
            { var reg5 physpage_state* physpage = heap->physpages;
              gen0_start &= -physpagesize;
              do { if (physpage->protection == PROT_READ_WRITE)
                     { var DYNAMIC_ARRAY(reg8,cache_buffer,old_new_pointer,physpagesize/sizeof(object));
                       var reg4 old_new_pointer* cache_ptr = &cache_buffer[0];
                       #define cache_at(obj)  \
                         { var reg1 tint type = mtypecode(obj);                              \
                           if (!immediate_type_p(type)) # unverschieblich?                   \
                             if (!in_old_generation(obj,type,mem.heapnr_from_type[type]))    \
                               # obj ist ein Pointer in die neue Generation -> merken        \
                               { cache_ptr->p = &(obj); cache_ptr->o = (obj); cache_ptr++; } \
                         }
                       walk_physpage(heapnr,physpage,gen0_start+physpagesize,gen0_end,cache_at);
                       #undef cache_at
                      {var reg3 uintL cache_size = cache_ptr - &cache_buffer[0];
                       if (cache_size <= (physpagesize/sizeof(object))/4)
                         # Wir cachen eine Seite nur, falls maximal 25% mit Pointern auf
                         # die neue Generation belegt ist. Sonst ist das Anlegen eines Cache
                         # Platzverschwendung.
                         { physpage->cache_size = cache_size;
                           if (cache_size == 0)
                             { xfree(physpage->cache); physpage->cache = NULL; }
                             else
                             { physpage->cache = (old_new_pointer*) xrealloc(physpage->cache,cache_size*sizeof(old_new_pointer));
                               if (physpage->cache == NULL)
                                 goto no_cache;
                               { var reg2 old_new_pointer* ptr1 = &cache_buffer[0];
                                 var reg1 old_new_pointer* ptr2 = physpage->cache;
                                 dotimespL(cache_size,cache_size, { *ptr2++ = *ptr1++; } );
                             } }
                           xmmprotect(gen0_start,physpagesize,PROT_READ);
                           physpage->protection = PROT_READ;
                         }
                         else
                         { xfree(physpage->cache); physpage->cache = NULL;
                           no_cache: ;
                         }
                       FREE_DYNAMIC_ARRAY(cache_buffer);
                     }}
                   gen0_start += physpagesize;
                   physpage++;
                 }
                 while (gen0_start < gen0_end);
    }   }   }

#endif

#if defined(DEBUG_SPVW) && defined(GENERATIONAL_GC)
  # Kontrolle des Cache der old_new_pointer:
  #define CHECK_GC_CACHE()  gc_cache_check()
  local void gc_cache_check (void);
  local void gc_cache_check()
    { var reg10 uintL heapnr;
      for (heapnr=0; heapnr<heapcount; heapnr++)
        if (is_heap_containing_objects(heapnr))
          { var reg7 Heap* heap = &mem.heaps[heapnr];
            var reg3 aint gen0_start = heap->heap_gen0_start;
            var reg5 aint gen0_end = heap->heap_gen0_end;
            var reg8 aint gen0_start_pa = gen0_start & -physpagesize; # page-aligned
            var reg9 aint gen0_end_pa = (gen0_end + (physpagesize-1)) & -physpagesize; # page-aligned
            var reg6 uintL physpage_count = (gen0_end_pa - gen0_start_pa) >> physpageshift;
            if (physpage_count > 0)
              { var reg1 physpage_state* physpage = heap->physpages;
                if (!(physpage==NULL))
                  { var reg4 uintL count;
                    dotimespL(count,physpage_count,
                      { var reg2 aint end = (gen0_start & -physpagesize) + physpagesize;
                        if (gen0_end < end) { end = gen0_end; }
                        if (physpage->firstobject < end) { end = physpage->firstobject; }
                        if (!(gen0_start <= (aint)physpage->continued_addr)) abort();
                        if (!((aint)physpage->continued_addr + physpage->continued_count*sizeof(object) <= end)) abort();
                        gen0_start &= -physpagesize;
                        gen0_start += physpagesize;
                        physpage++;
                      });
    }     }   }   }
  # Kontrolle, ob alle Pointer im Cache aufgeführt sind und nicht in den Wald zeigen.
  #define CHECK_GC_GENERATIONAL()  gc_overall_check()
  local void gc_overall_check (void);
    # Kontrolle eines einzelnen Pointers:
    local boolean gc_check_at (object* objptr);
    local boolean gc_check_at(objptr)
      var reg5 object* objptr;
      { var reg4 object obj = *objptr;
        var reg3 tint type = typecode(obj);
        #ifdef SPVW_PURE
        if (is_unused_heap(type))
          return FALSE;
        #else
        if (immediate_type_p(type))
          return FALSE;
        #endif
       {var reg2 aint addr = canonaddr(obj);
        var reg1 Heap* heap;
        #ifdef SPVW_PURE
        heap = &mem.heaps[type];
        #else # SPVW_MIXED
        heap = &mem.heaps[mem.heapnr_from_type[type]];
        #endif
        if ((addr >= heap->heap_gen0_start) && (addr < heap->heap_gen0_end))
          return FALSE;
        #ifdef SPVW_MIXED_BLOCKS_OPPOSITE
        if (is_cons_heap(mem.heapnr_from_type[type]))
          { if ((addr >= heap->heap_start) && (addr < heap->heap_gen1_end))
              return TRUE; # Pointer in die neue Generation
          }
          else
        #endif
          { if ((addr >= heap->heap_gen1_start) && (addr < heap->heap_end))
              return TRUE; # Pointer in die neue Generation
          }
        if ((type == symbol_type)
            && (as_oint(obj) - as_oint(symbol_tab_ptr_as_object(&symbol_tab))
                < (sizeof(symbol_tab)<<(oint_addr_shift-addr_shift))
           )   )
          return FALSE;
        abort();
      }}
  local void gc_overall_check()
    { var reg8 uintL heapnr;
      for (heapnr=0; heapnr<heapcount; heapnr++)
        if (is_heap_containing_objects(heapnr))
          { var reg6 Heap* heap = &mem.heaps[heapnr];
            var reg5 aint gen0_start = heap->heap_gen0_start;
            var reg7 aint gen0_end = heap->heap_gen0_end;
            if (gen0_start < gen0_end)
              if (heap->physpages==NULL)
                { walk_area_(heapnr,gen0_start,gen0_end,gc_check_at); } # fallback
                else
                { var reg4 physpage_state* physpage = heap->physpages;
                  gen0_start &= -physpagesize;
                  do { if (physpage->protection == PROT_READ)
                         # Stimmen die Pointer im Cache und in der Seite überein?
                         { var reg3 uintL count = physpage->cache_size;
                           if (count > 0)
                             { var reg1 old_new_pointer* ptr = physpage->cache;
                               var reg2 aint last_p = gen0_start-1;
                               dotimespL(count,count,
                                 { if (!eq(*(ptr->p),ptr->o))
                                     abort();
                                   if (!(last_p < (aint)ptr->p))
                                     abort();
                                   last_p = (aint)ptr->p;
                                   ptr++;
                                 });
                         }   }
                       gen0_start += physpagesize;
                       if (physpage->protection == PROT_NONE)
                         # Cache ausnutzen, gecachte Pointer durchlaufen:
                         { var reg2 uintL count = physpage->cache_size;
                           if (count > 0)
                             { var reg1 old_new_pointer* ptr = physpage->cache;
                               dotimespL(count,count, { gc_check_at(&ptr->o); ptr++; } );
                         }   }
                         else
                         # ganzen Page-Inhalt durchlaufen:
                         { walk_physpage_(heapnr,physpage,gen0_start,gen0_end,gc_check_at); }
                       physpage++;
                     }
                     while (gen0_start < gen0_end);
    }     }     }
  # Zur Fehlersuche: Verwaltungsdaten vor und nach der GC retten.
  #define SAVE_GC_DATA()  save_gc_data()
  local void save_gc_data (void);
  typedef struct gc_data { struct gc_data * next; Heap heaps[heapcount]; } *
          gc_data_list;
  local var gc_data_list gc_history;
  local void save_gc_data()
    { # Kopiere die aktuellen GC-Daten an den Kopf der Liste gc_history :
      var reg10 gc_data_list new_data = (struct gc_data *) malloc(sizeof(struct gc_data));
      if (!(new_data==NULL))
        { var reg9 uintL heapnr;
          for (heapnr=0; heapnr<heapcount; heapnr++)
            { var reg8 Heap* heap = &new_data->heaps[heapnr];
              *heap = mem.heaps[heapnr];
              if (!(heap->physpages==NULL))
                { var reg7 uintL physpagecount =
                    (((heap->heap_gen0_end + (physpagesize-1)) & -physpagesize)
                     - (heap->heap_gen0_start & -physpagesize)
                    ) >> physpageshift;
                  var reg6 physpage_state* physpages = NULL;
                  if (physpagecount > 0)
                    physpages = (physpage_state*) malloc(physpagecount*sizeof(physpage_state));
                  if (!(physpages==NULL))
                    { var reg5 uintL i;
                      for (i=0; i<physpagecount; i++)
                        { physpages[i] = heap->physpages[i];
                          if (!(physpages[i].cache==NULL))
                            { var reg4 uintC cache_size = physpages[i].cache_size;
                              if (cache_size > 0)
                                { var reg2 old_new_pointer* cache = (old_new_pointer*) malloc(cache_size*sizeof(old_new_pointer));
                                  if (!(cache==NULL))
                                    { var reg3 old_new_pointer* old_cache = physpages[i].cache;
                                      var reg1 uintC j;
                                      for (j=0; j<cache_size; j++)
                                        { cache[j] = old_cache[j]; }
                                    }
                                  physpages[i].cache = cache;
                    }   }   }   }
                  heap->physpages = physpages;
            }   }
          new_data->next = gc_history;
          gc_history = new_data;
    }   }
#else
  #define CHECK_GC_CACHE()
  #define CHECK_GC_GENERATIONAL()
  #define SAVE_GC_DATA()
#endif

#if defined(DEBUG_SPVW) && !defined(GENERATIONAL_GC)
  # Kontrolle, ob auch alles unmarkiert ist:
  #define CHECK_GC_UNMARKED()  gc_unmarkcheck()
  local void gc_unmarkcheck (void);
  local void gc_unmarkcheck()
    { for_each_varobject_page(page,
        # Von unten nach oben durchgehen:
        { var reg1 aint p1 = page->page_start;
          var reg4 aint p1end = page->page_end;
          var_speicher_laenge_;
          until (p1==p1end) # obere Grenze erreicht -> fertig
            { # nächstes Objekt hat Adresse p1
              if (marked(p1)) # markiert?
                { 
                  asciz_out(NLstring);
                  //: DEUTSCH "Objekt"
                  //: ENGLISH "Objekt"
                  //: FRANCAIS "Objekt"
                  asciz_out(GETTEXT("Objekt"));
                  asciz_out(" 0x");
                  hex_out(p1);
                  //: DEUTSCH " markiert!!"
                  //: ENGLISH " markiert!!"
                  //: FRANCAIS " markiert!!"
                  asciz_out(GETTEXT(" markiert!!"));
                  asciz_out(NLstring);
                  abort();
                }
              p1 += calc_speicher_laenge(p1);
        }   }
        );
      for_each_cons_page(page,
        # Von unten nach oben durchgehen:
        { var reg1 aint p1 = page->page_start;
          var reg4 aint p1end = page->page_end;
          until (p1==p1end) # obere Grenze erreicht -> fertig
            { # nächstes Objekt hat Adresse p1
              if (marked(p1)) # markiert?
                { asciz_out(NLstring);
                  //: DEUTSCH "Objekt"
                  //: ENGLISH "Objekt"
                  //: FRANCAIS "Objekt"
                  asciz_out(GETTEXT("Objekt"));
                  asciz_out(" 0x"); 
                  hex_out(p1);
                  //: DEUTSCH " markiert!!"
                  //: ENGLISH " markiert!!"
                  //: FRANCAIS " markiert!!"
                  asciz_out(GETTEXT(" markiert!!"));
                  asciz_out(NLstring);
                  abort();
                }
              p1 += sizeof(cons_);
        }   }
        );
    }
#else
  #define CHECK_GC_UNMARKED()
#endif

#ifdef DEBUG_SPVW
  # Kontrolle gegen Nullpointer:
  #define CHECK_NULLOBJ()  nullobjcheck(FALSE)
  local void nullobjcheck (boolean in_gc);
  local void nullobjcheck_range (aint p1, aint p1end, boolean in_gc);
  local void nullobjcheck_range(p1,p1end,in_gc)
    var reg1 aint p1;
    var reg2 aint p1end;
    var reg3 boolean in_gc;
    { until (p1==p1end) # obere Grenze erreicht -> fertig
        { # nächstes Objekt hat Adresse p1
          if (eq(((Cons)p1)->cdr,nullobj) || eq(((Cons)p1)->car,nullobj))
            if (!(in_gc && eq(((Cons)p1)->cdr,nullobj) && eq(((Cons)p1)->car,nullobj)))
              abort();
          p1 += sizeof(cons_);
    }   }
  local void nullobjcheck(in_gc)
    var reg4 boolean in_gc;
    { # Von unten nach oben durchgehen:
      #ifdef GENERATIONAL_GC
      #ifdef SPVW_MIXED_BLOCKS_OPPOSITE
      for_each_cons_heap(heap,
        { nullobjcheck_range(heap->heap_start,heap->heap_gen1_end,in_gc);
          nullobjcheck_range(heap->heap_gen0_start,heap->heap_gen0_end,in_gc);
        });
      #else
      for_each_cons_heap(heap,
        { nullobjcheck_range(heap->heap_gen0_start,heap->heap_gen0_end,in_gc);
          nullobjcheck_range(heap->heap_gen1_start,heap->heap_end,in_gc);
        });
      #endif
      #else
      for_each_cons_page(page,
        { nullobjcheck_range(page->page_start,page->page_end,in_gc); });
      #endif
    }
#else
  #define CHECK_NULLOBJ()
#endif

#ifdef SPVW_PAGES
  # Überflüssige Pages freigeben:
  # Falls nach einer GC der Platz, der uns in mem.free_pages zur Verfügung
  # steht, mehr als 25% dessen ausmacht, was wir momentan brauchen, wird der
  # Rest ans Betriebssystem zurückgegeben.
  local void free_some_unused_pages (void);
  local void free_some_unused_pages()
    { var reg5 uintL needed_space = floor(mem.last_gcend_space,4); # 25%
      var reg4 uintL accu_space = 0;
      var reg2 Pages* pageptr = &mem.free_pages;
      var reg1 Pages page = *pageptr;
      until (page==NULL)
        { var reg3 Pages nextpage = page->page_gcpriv.next;
          if (accu_space < needed_space)
            # page behalten
            { accu_space += page->page_room;
              pageptr = (Pages*)&page->page_gcpriv.next; page = nextpage;
            }
            else
            # page freigeben
            { free_page(page); page = *pageptr = nextpage; }
    }   }
#endif

# GC-Timer ein- und ausschalten: gc_timer_on(); ... gc_timer_off();
# Die dazwischen verstrichene Zeit wird auf gc_time addiert.
  #define gc_timer_on()  \
    { var internal_time gcstart_time; \
      get_running_time(gcstart_time); # aktuelle verbrauchte Zeit abfragen und retten
  #define gc_timer_off()  \
     {var internal_time gcend_time;                           \
      get_running_time(gcend_time);                           \
      # Differenz von gcend_time und gcstart_time bilden:     \
      sub_internal_time(gcend_time,gcstart_time, gcend_time); \
      # diese Differenz zu gc_time addieren:                  \
      add_internal_time(gc_time,gcend_time, gc_time);         \
    }}

# GC-bedingt Signale disablen: gc_signalblock_on(); ... gc_signalblock_off();
  #if defined(HAVE_SIGNALS) && defined(SIGWINCH) && !defined(NO_ASYNC_INTERRUPTS)
    # Signal SIGWINCH blockieren, denn eine Veränderung des Wertes von
    # SYS::*PRIN-LINELENGTH* können wir während der GC nicht brauchen.
    # Dann Signal SIGWINCH wieder freigeben.
    #define gc_signalblock_on()  signalblock_on(SIGWINCH)
    #define gc_signalblock_off()  signalblock_off(SIGWINCH)
  #else
    #define gc_signalblock_on()
    #define gc_signalblock_off()
  #endif

# GC-bedingt Immutabilität von Objekten aufheben:
  #ifndef MULTIMAP_MEMORY
    #define immutable_off()
    #define immutable_on()
  #endif

#if (defined(SPVW_PURE_BLOCKS) || defined(TRIVIALMAP_MEMORY)) && defined(VIRTUAL_MEMORY) && defined(HAVE_MUNMAP)
  nonreturning_function(local, fehler_munmap_failed, (void));
  local void fehler_munmap_failed()
    {
      //: DEUTSCH "munmap() klappt nicht."
      //: ENGLISH "munmap() failed."
      //: FRANCAIS "munmap() ne fonctionne pas."
      asciz_out(GETTEXT("munmap() failed"));
      errno_out(errno);
      abort();
    }
#endif


# Normale Garbage Collection durchführen:
  local void gar_col_normal(void);
  local void gar_col_normal()
    { var uintL gcstart_space; # belegter Speicher bei GC-Start
      var uintL gcend_space; # belegter Speicher bei GC-Ende
      var object all_finalizers; # Liste der Finalisierer
      #ifdef GC_CLOSES_FILES
      var object files_to_close; # Liste der zu schließenden Files
      #endif
      set_break_sem_1(); # BREAK während Garbage Collection sperren
      gc_signalblock_on(); # Signale während Garbage Collection sperren
      gc_timer_on();
      gcstart_space = used_space(); # belegten Speicherplatz ermitteln
      #ifdef WINDOWS
      windows_note_gc_start();
      #endif
      #ifdef HAVE_VADVISE
        begin_system_call();
        vadvise(VA_ANOM); # Paging-Verhalten wird jetzt etwas ungewöhnlich
        end_system_call();
      #endif
      immutable_off(); # immutable Objekte werden jetzt modifizierbar
      CHECK_GC_UNMARKED(); CHECK_NULLOBJ(); CHECK_GC_CACHE(); CHECK_GC_GENERATIONAL(); SAVE_GC_DATA();
      #ifdef SPVW_PAGES
        { var reg4 uintL heapnr;
          for (heapnr=0; heapnr<heapcount; heapnr++)
            { AVL_map(mem.heaps[heapnr].inuse,page,
                      page->page_room += page->page_end;
                     );
              # In page_room steht jetzt jeweils das Ende des benutzbaren Speichers.
        }   }
      #endif
      #ifdef GENERATIONAL_GC
      if (generation == 0)
        # Alte Generation mit Hilfe des Cache auf den aktuellen Stand bringen:
        { prepare_old_generation(); }
        else
        # Nur die neue Generation behandeln. Alte Generation verstecken:
        #ifdef SPVW_MIXED_BLOCKS_OPPOSITE
        { mem.varobjects.heap_start = mem.varobjects.heap_gen1_start;
          mem.conses.heap_end = mem.conses.heap_gen1_end;
        }
        #else
        { var reg4 uintL heapnr;
          for (heapnr=0; heapnr<heapcount; heapnr++)
            mem.heaps[heapnr].heap_start = mem.heaps[heapnr].heap_gen1_start;
        }
        #endif
      #endif
      CHECK_GC_GENERATIONAL();
      # Markierungsphase:
        all_finalizers = O(all_finalizers); O(all_finalizers) = NIL;
        #ifdef GC_CLOSES_FILES
        files_to_close = O(open_files); O(open_files) = NIL; # O(files_to_close) = NIL;
        #endif
        gc_markphase();
        # (noch unmarkierte Liste all_finalizers aufspalten in zwei Listen:
        { var reg1 object Lu = all_finalizers;
          var reg3 object* L1 = &O(all_finalizers);
          var reg2 object* L2 = &O(pending_finalizers);
          until (msymbolp(*L2)) # eigentlich: until (nullp(*L2))
            { L2 = &TheFinalizer(*L2)->fin_cdr; }
          until (symbolp(Lu)) # eigentlich: until (nullp(Lu))
            { # Wenn fin_alive tot ist, wird der Finalisierer weggeworfen,
              # ohne ausgeführt zu werden:
              if (!alive(TheFinalizer(Lu)->fin_alive))
                { Lu = TheFinalizer(Lu)->fin_cdr; }
                else
                { # Wenn fin_trigger stirbt, wird der Finalisierer ausgeführt:
                  if (alive(TheFinalizer(Lu)->fin_trigger)) # Lebt fin_trigger noch?
                    # ja -> in O(all_finalizers) übernehmen:
                    { *L1 = Lu; L1 = &TheFinalizer(Lu)->fin_cdr; Lu = *L1; }
                    else
                    # nein -> in O(pending_finalizers) übernehmen:
                    { *L2 = Lu; L2 = &TheFinalizer(Lu)->fin_cdr; Lu = *L2; }
                }
            }
          *L1 = NIL; *L2 = NIL;
        }
        gc_mark(O(all_finalizers)); gc_mark(O(pending_finalizers)); # Beide Listen jetzt markieren
        #ifdef GC_CLOSES_FILES
        # (noch unmarkierte) Liste files_to_close aufspalten in zwei Listen:
        { var reg1 object Lu = files_to_close;
          var reg2 object* L1 = &O(open_files);
          var reg3 object* L2 = &O(files_to_close);
          while (consp(Lu))
            { if (in_old_generation(Car(Lu),stream_type,0)
                  || marked(TheStream(Car(Lu))) # (car Lu) markiert?
                 )
                # ja -> in O(open_files) übernehmen:
                { *L1 = Lu; L1 = &Cdr(Lu); Lu = *L1; }
                else
                # nein -> in O(files_to_close) übernehmen:
                { *L2 = Lu; L2 = &Cdr(Lu); Lu = *L2; }
            }
          *L1 = NIL; *L2 = NIL;
        }
        gc_mark(O(open_files)); gc_mark(O(files_to_close)); # Beide Listen jetzt markieren
        #endif
      # Jetzt sind alle aktiven Objekte markiert:
      # Aktive Objekte variabler Länge wie auch aktive Zwei-Pointer-Objekte tragen
      # in ihrem ersten Byte ein gesetztes Markierungsbit, aktive SUBRs tragen
      # in ihrem ersten Konstantenpointer ein gesetztes Markierungsbit, sonst sind
      # alle Markierungsbits gelöscht.
      # "Sweep"-Phase:
        # Die CONSes u.ä. (Objekte mit 2 Pointern) werden kompaktiert.
        # Von den Objekten variabler Länge werden die Zielplätze für die
        # Phase 4 errechnet und abgespeichert.
        # SUBRs und feste Symbole (sie sind alle aktiv) werden als erstes demarkiert:
          unmark_fixed_varobjects();
        #ifndef MORRIS_GC
        # CONS-Zellen kompaktieren:
        for_each_cons_page(page, { gc_compact_cons_page(page); } );
        #endif
        # Objekte variabler Länge zur Zusammenschiebung nach unten vorbereiten:
          #ifdef SPVW_PURE
          #ifdef GENERATIONAL_GC
          if (generation == 0)
            { for_each_varobject_heap(heap,
                { if (heap->heap_gen0_end < heap->heap_gen1_start)
                    # Lücke durch einen Pointer überspringen
                    { var object secondmarked;
                      var reg1 aint tmp =
                        gc_sweep1_varobject_page(heapnr,
                                                 heap->heap_gen0_start,heap->heap_gen0_end,
                                                 &heap->pages.page_gcpriv.firstmarked,
                                                 heap->heap_gen0_start);
                      gc_sweep1_varobject_page(heapnr,
                                               heap->heap_gen1_start,heap->heap_end,
                                               (object*)(heap->heap_gen0_end),
                                               tmp);
                    }
                    else
                    # keine Lücke
                    { gc_sweep1_varobject_page(heapnr,
                                               heap->heap_gen0_start,heap->heap_end,
                                               &heap->pages.page_gcpriv.firstmarked,
                                               heap->heap_gen0_start);
                    }
                });
            }
            else
          #endif
          for_each_varobject_page(page,
            { gc_sweep1_varobject_page(heapnr,
                                       page->page_start,page->page_end,
                                       &page->page_gcpriv.firstmarked,
                                       page->page_start);
            });
          #else # SPVW_MIXED
          #ifdef GENERATIONAL_GC
          if (generation == 0)
            { for_each_varobject_heap(heap,
                { if (heap->heap_gen0_end < heap->heap_gen1_start)
                    # Lücke durch einen Pointer überspringen
                    { var object secondmarked;
                      var reg1 aint tmp =
                        gc_sweep1_varobject_page(heap->heap_gen0_start,heap->heap_gen0_end,
                                                 &heap->pages.page_gcpriv.firstmarked,
                                                 heap->heap_gen0_start);
                      gc_sweep1_varobject_page(heap->heap_gen1_start,heap->heap_end,
                                               (object*)(heap->heap_gen0_end),
                                               tmp);
                    }
                    else
                    # keine Lücke
                    { gc_sweep1_varobject_page(heap->heap_gen0_start,heap->heap_end,
                                               &heap->pages.page_gcpriv.firstmarked,
                                               heap->heap_gen0_start);
                    }
                });
            }
            else
            for_each_varobject_page(page,
              { gc_sweep1_varobject_page(page->page_start,page->page_end,
                                         &page->page_gcpriv.firstmarked,
                                         page->page_start);
              });
          #else
          for_each_varobject_page(page, { gc_sweep1_varobject_page(page); } );
          #endif
          #endif
      # Jetzt sind alle aktiven Objekte für die Aktualisierung vorbereitet:
      # Bei aktiven Objekten variabler Länge A2 ist (A2).L die Adresse, wo das
      # Objekt nach der GC stehen wird (incl. Typinfo und Markierungsbit und evtl.
      # Symbol-Flags). Bei aktiven Zwei-Pointer-Objekten A2 bleibt entweder A2
      # stehen (dann ist das Markierungsbit in (A2) gelöscht), oder A2 wird
      # verschoben (dann ist (A2).L die neue Adresse, ohne Typinfo, aber incl.
      # Markierungsbit).
      # Aktualisierungsphase:
        # Der gesamte LISP-Speicher wird durchgegangen und dabei alte durch
        # neue Adressen ersetzt.
        #ifdef MORRIS_GC
         for_each_cons_page(page, { gc_morris1(page); } );
        #endif
        # Durchlaufen durch alle LISP-Objekte und aktualisieren:
          # Pointer im LISP-Stack aktualisieren:
            aktualisiere_STACK();
          # Programmkonstanten aktualisieren:
            aktualisiere_tab();
          #ifndef MORRIS_GC
          # Pointer in den Cons-Zellen aktualisieren:
            aktualisiere_conses();
          #endif
          # Pointer in den Objekten variabler Länge aktualisieren:
            #define aktualisiere_page(page,aktualisierer)  \
              { var reg2 aint ptr = (aint)type_pointable(0,page->page_gcpriv.firstmarked); \
                var reg6 aint ptrend = page->page_end;                                     \
                # alle Objekte mit Adresse >=ptr, <ptrend durchgehen:                      \
                until (ptr==ptrend) # solange bis ptr am Ende angekommen ist               \
                  { # nächstes Objekt mit Adresse ptr (< ptrend) durchgehen:               \
                    if (marked(ptr)) # markiert?                                           \
                      # Typinfo ohne Markierungsbit nehmen!                                \
                      { aktualisierer(typecode_at(ptr) & ~bit(garcol_bit_t)); }            \
                      else                                                                 \
                      # mit Pointer (Typinfo=0) zum nächsten markierten Objekt             \
                      { ptr = (aint)type_pointable(0,*(object*)ptr); }                     \
              }   }
            #define aktualisiere_fpointer_invalid  FALSE
            aktualisiere_varobjects();
            #undef aktualisiere_fpointer_invalid
            #undef aktualisiere_page
          #ifdef GENERATIONAL_GC
          # Pointer in den Objekten der alten Generation aktualisieren:
            if (generation > 0)
              { aktualisiere_old_generation(); }
          #endif
        #ifdef MORRIS_GC
        # Zum Schluß werden die Conses verschoben und gleichzeitig alle
        # Pointer auf sie (z.Zt. in Listen geführt!) aktualisiert.
        for_each_cons_page_reversed(page, { gc_morris2(page); } );
        for_each_cons_page(page, { gc_morris3(page); } );
        #endif
      # Jetzt sind alle aktiven Objekte mit korrektem Inhalt versehen (alle darin
      # vorkommenden Pointer zeigen auf die nach der GC korrekten Adressen).
      # Die aktiven Zwei-Pointer-Objekte sind bereits am richtigen Ort und
      # unmarkiert; die Objekte variabler Länge sind noch am alten Ort und
      # markiert, falls aktiv.
      # Zweite SWEEP-Phase:
        # Die Objekte variabler Länge werden an die vorher berechneten
        # neuen Plätze geschoben.
        #if !defined(GENERATIONAL_GC)
        #ifdef SPVW_MIXED
        for_each_varobject_page(page, { gc_sweep2_varobject_page(page); } );
        #else # SPVW_PURE
        for_each_varobject_page(page, { gc_sweep2_varobject_page(page,heapnr); } );
        #endif
        #else # defined(GENERATIONAL_GC)
        { var reg4 uintL heapnr;
          for (heapnr=0; heapnr<heapcount; heapnr++)
            { var reg3 Heap* heap = &mem.heaps[heapnr];
              if (!is_unused_heap(heapnr))
                { if (is_varobject_heap(heapnr))
                    {
                      #ifdef SPVW_MIXED
                      gc_sweep2_varobject_page(&heap->pages);
                      #else # SPVW_PURE
                      gc_sweep2_varobject_page(&heap->pages,heapnr);
                      #endif
                    }
                  if (generation == 0)
                    { # Alles Übriggebliebene bildet die neue Generation 0.
                      #ifdef SPVW_MIXED_BLOCKS_OPPOSITE
                      if (is_cons_heap(heapnr))
                        { var reg1 aint start = heap->heap_start;
                          heap->heap_gen0_start = start;
                          start = start & -physpagesize;
                          heap->heap_start = heap->heap_gen1_end = start;
                        }
                        else
                      #endif
                        { var reg1 aint end = heap->heap_end;
                          heap->heap_gen0_end = end;
                          end = (end + (physpagesize-1)) & -physpagesize;
                          heap->heap_gen1_start = heap->heap_end = end;
                        }
                      build_old_generation_cache(heapnr);
                    }
                    else
                    { rebuild_old_generation_cache(heapnr); }
                }
              #ifdef SPVW_MIXED_BLOCKS_OPPOSITE
              if (is_cons_heap(heapnr))
                { heap->heap_end = heap->heap_gen0_end; }
                else
              #endif
                { heap->heap_start = heap->heap_gen0_start; }
        }   }
        #endif
      # Jetzt sind alle aktiven Objekte mit korrektem Inhalt versehen, am richtigen
      # Ort und wieder unmarkiert.
      #ifdef SPVW_PAGES
        { var reg5 uintL heapnr;
          for (heapnr=0; heapnr<heapcount; heapnr++)
            { var reg4 Pages* heapptr = &mem.heaps[heapnr].inuse;
              AVL_map(*heapptr,page,
                      page->page_room -= page->page_end;
                     );
              # In page_room steht jetzt jeweils wieder der verfügbare Platz.
              # Pages wieder nach dem verfügbaren Platz sortieren:
              *heapptr = AVL(AVLID,sort)(*heapptr);
        }   }
        for_each_cons_heap(heap, { heap->lastused = dummy_lastused; } );
        # .reserve behandeln??
      #endif
      CHECK_AVL_CONSISTENCY();
      CHECK_GC_CONSISTENCY();
      CHECK_GC_UNMARKED(); CHECK_NULLOBJ(); CHECK_GC_CACHE(); CHECK_GC_GENERATIONAL(); SAVE_GC_DATA();
      CHECK_PACK_CONSISTENCY();
      # Ende der Garbage Collection.
      #ifdef HAVE_VADVISE
        begin_system_call();
        vadvise(VA_NORM); # Paging-Verhalten wird ab jetzt wieder normal
        end_system_call();
      #endif
      #ifdef WINDOWS
      windows_note_gc_end();
      #endif
      gc_count += 1; # GCs mitzählen
      # belegten Speicherplatz ermitteln:
      #ifdef SPVW_PAGES
      recalc_space(FALSE);
      #endif
      gcend_space = used_space();
      #ifdef SPVW_PAGES
      mem.last_gcend_space = gcend_space;
      # Um bis zu 25% lassen wir den benutzten Platz anwachsen, dann erst
      # kommt die nächste GC:
      { var reg1 uintL total_room = floor(mem.last_gcend_space,4);
        if (total_room < 512*1024) { total_room = 512*1024; } # mindestens 512 KB
        mem.gctrigger_space = mem.last_gcend_space + total_room;
      }
      #endif
      #if (defined(SPVW_PURE_BLOCKS) || defined(TRIVIALMAP_MEMORY)) && !defined(GENERATIONAL_GC)
      # Um bis zu 50% lassen wir den benutzten Platz anwachsen, dann erst
      # kommt die nächste GC:
      #define set_total_room(space_used_now)  \
        { mem.total_room = floor(space_used_now,2); # 50% des jetzt benutzten Platzes       \
          if (mem.total_room < 512*1024) { mem.total_room = 512*1024; } # mindestens 512 KB \
        }
      set_total_room(gcend_space);
      #endif
      #if defined(GENERATIONAL_GC)
      # Um bis zu 25% lassen wir den benutzten Platz anwachsen, dann erst
      # kommt die nächste GC:
      #define set_total_room_(space_used_now)  \
        { mem.total_room = floor(space_used_now,4); # 25% des jetzt benutzten Platzes       \
          if (mem.total_room < 512*1024) { mem.total_room = 512*1024; } # mindestens 512 KB \
        }
      #ifdef SPVW_MIXED_BLOCKS_OPPOSITE
      # make_space() erwartet, daß mem.total_room <= Länge der großen Lücke.
      #define set_total_room(space_used_now)  \
        { set_total_room_(space_used_now);                                      \
          if (mem.total_room > mem.conses.heap_start-mem.varobjects.heap_end)   \
            { mem.total_room = mem.conses.heap_start-mem.varobjects.heap_end; } \
        }
      #else
      #define set_total_room  set_total_room_
      #endif
      { var reg4 uintL gen0_sum = 0; # momentane Größe der alten Generation
        var reg4 uintL gen1_sum = 0; # momentane Größe der neuen Generation
        for_each_heap(heap,
          { gen0_sum += heap->heap_gen0_end - heap->heap_gen0_start; });
        #ifdef SPVW_MIXED_BLOCKS_OPPOSITE
        gen1_sum += mem.varobjects.heap_end - mem.varobjects.heap_gen1_start;
        gen1_sum += mem.conses.heap_gen1_end - mem.conses.heap_start;
        #else
        for_each_heap(heap,
          { gen1_sum += heap->heap_end - heap->heap_gen1_start; });
        #endif
        # NB: gcend_space == gen0_sum + gen1_sum.
        set_total_room(gen0_sum);
        mem.last_gcend_space0 = gen0_sum;
        mem.last_gcend_space1 = gen1_sum;
      }
      #endif
      { var reg1 uintL freed = gcstart_space - gcend_space; # von dieser GC
                                       # wiederbeschaffter Speicherplatz
        # dies zum 64-Bit-Akku gc_space addieren:
        #ifdef intQsize
        gc_space += freed;
        #else
        gc_space.lo += freed;
        if (gc_space.lo < freed) # Übertrag?
          gc_space.hi += 1;
        #endif
      }
      #ifdef SPVW_PAGES
      free_some_unused_pages();
      #endif
      #if (defined(SPVW_PURE_BLOCKS) || defined(TRIVIALMAP_MEMORY)) && defined(VIRTUAL_MEMORY) && defined(HAVE_MUNMAP)
      # Ungebrauchte, leere Seiten freigeben, damit sie vom Betriebssystem
      # nicht irgendwann auf den Swapspace verbracht werden müssen:
      for_each_heap(heap,
        { var reg1 aint needed_limit = round_up(heap->heap_end,map_pagesize);
          if (needed_limit > heap->heap_limit)
            abort();
          if (needed_limit < heap->heap_limit)
            { if (munmap((MMAP_ADDR_T)needed_limit,heap->heap_limit-needed_limit) < 0)
                fehler_munmap_failed();
              heap->heap_limit = needed_limit;
        }   });
      #endif
      immutable_on();
      # von dieser GC benötigte Zeit zur GC-Gesamtzeit addieren:
      gc_timer_off();
      #ifdef GC_CLOSES_FILES
      close_some_files(O(files_to_close)); # vorher unmarkierte Files schließen
      O(files_to_close) = NIL;
      #endif
      #ifdef GENERATIONAL_GC
      O(gc_count) = fixnum_inc(O(gc_count),1); # GCs mitzählen
      #endif
      gc_signalblock_off(); # Signale wieder freigeben
      clr_break_sem_1(); # BREAK wieder ermöglichen
    }

# Ende einer Garbage Collection.
# kann GC auslösen!
  local void gar_col_done (void);
  local void gar_col_done()
    { # Finalisierer-Funktionen abarbeiten:
      until (msymbolp(O(pending_finalizers))) # eigentlich: until (nullp(...))
        { var reg1 object obj = O(pending_finalizers);
          O(pending_finalizers) = TheFinalizer(obj)->fin_cdr;
          pushSTACK(TheFinalizer(obj)->fin_trigger);
          if (eq(TheFinalizer(obj)->fin_alive,unbound))
            { funcall(TheFinalizer(obj)->fin_function,1); } # (FUNCALL function trigger)
            else
            { pushSTACK(TheFinalizer(obj)->fin_alive);
              funcall(TheFinalizer(obj)->fin_function,2); # (FUNCALL function trigger alive)
        }   }
    }

#ifdef SPVW_PAGES

# Eine kleine Sortier-Routine:
#define SORTID  spvw
#define SORT_ELEMENT  Pages
#define SORT_KEY  uintL
#define SORT_KEYOF(page)  (page)->page_gcpriv.l
#define SORT_COMPARE(key1,key2)  (sintL)((key1)-(key2))
#define SORT_LESS(key1,key2)  ((key1) < (key2))
#include "sort.c"

# Kompaktierung einer Page durch Umfüllen in andere Pages derselben Art:
  #ifdef SPVW_PURE
  local void gc_compact_from_varobject_page (Heap* heapptr, Page* page, uintL heapnr);
  local void gc_compact_from_varobject_page(heapptr,page,heapnr)
    var reg9 Heap* heapptr;
    var reg8 Page* page;
    var reg10 uintL heapnr;
  #else
  local void gc_compact_from_varobject_page (Heap* heapptr, Page* page);
  local void gc_compact_from_varobject_page(heapptr,page)
    var reg9 Heap* heapptr;
    var reg8 Page* page;
  #endif
    { var reg1 aint p1 = page->page_start;
      var reg7 aint p1end = page->page_end;
      var_speicher_laenge_;
     {var reg4 Pages new_page = EMPTY; # Page, in die gefüllt wird
      var AVL(AVLID,stack) stack; # Weg von der Wurzel bis zu ihr
      var reg2 aint p2; # Cache von new_page->page_end
      var reg5 uintL l2; # Cache von new_page->page_room
      # Versuche alle Objekte zwischen p1 und p1end zu kopieren:
      loop
        { if (p1==p1end) break; # obere Grenze erreicht -> fertig
         {var reg3 uintL laenge = calc_speicher_laenge(p1); # Byte-Länge bestimmen
          # Suche eine Page, die noch mindestens laenge Bytes frei hat:
          if ((new_page == EMPTY) || (l2 < laenge))
            { if (!(new_page == EMPTY)) # Cache leeren?
                { new_page->page_end = p2;
                  new_page->page_room = l2;
                  AVL(AVLID,move)(&stack);
                }
              new_page = AVL(AVLID,least)(laenge,&heapptr->inuse,&stack);
              if (new_page==EMPTY) break;
              new_page->page_gcpriv.d = -1L; # new_page als "zu füllend" kennzeichnen
              p2 = new_page->page_end;
              l2 = new_page->page_room;
            }
          {var reg6 aint old_p1 = p1;
           var reg6 aint old_p2 = p2;
           # Kopiere das Objekt:
           l2 -= laenge; move_aligned_p1_p2(laenge);
           # Hinterlasse einen Pointer auf die neue Position:
           *(object*)old_p1 = with_mark_bit(type_pointer_object(0,old_p2));
           # p1 = Sourceadresse für nächstes Objekt
        }}}
      if (!(new_page == EMPTY)) # Cache leeren?
        { new_page->page_end = p2;
          new_page->page_room = l2;
          AVL(AVLID,move)(&stack);
        }
     }
     # Die nicht kopierten Objekte erfahren eine konstante Verschiebung nach unten:
     {var reg4 aint p2 = page->page_start;
      page->page_gcpriv.d = p1 - p2; # Verschiebung
      page->page_start = p1; # jetziger Anfang der Page
      if (!(p1==p2)) # falls Verschiebung nötig
        until (p1==p1end) # obere Grenze erreicht -> fertig
          { var reg3 uintL laenge = calc_speicher_laenge(p1); # Byte-Länge bestimmen
            var reg2 tint flags = mtypecode(((Varobject)p1)->GCself); # Typinfo (und Flags bei Symbolen) retten
            set_GCself(p1, flags,p2); # neue Adresse eintragen, mit alter Typinfo
            mark(p1); # mit Markierungsbit
            p1 += laenge; p2 += laenge;
          }
    }}
  local void gc_compact_from_cons_page (Heap* heapptr, Page* page);
  local void gc_compact_from_cons_page(heapptr,page)
    var reg7 Heap* heapptr;
    var reg6 Page* page;
    { var reg1 aint p1 = page->page_end;
      var reg5 aint p1start = page->page_start;
     {var reg3 Pages new_page = EMPTY; # Page, in die gefüllt wird
      var AVL(AVLID,stack) stack; # Weg von der Wurzel bis zu ihr
      var reg2 aint p2; # Cache von new_page->page_end
      var reg4 uintL l2; # Cache von new_page->page_room
      # Versuche alle Objekte zwischen p1start und p1 zu kopieren:
      loop
        { if (p1==p1start) break; # untere Grenze erreicht -> fertig
          # Suche eine Page, die noch mindestens sizeof(cons_) Bytes frei hat:
          if ((new_page == EMPTY) || (l2 == 0)) # l2 < sizeof(cons_) bedeutet l2 = 0
            { if (!(new_page == EMPTY)) # Cache leeren?
                { new_page->page_end = p2;
                  new_page->page_room = l2;
                  AVL(AVLID,move)(&stack);
                }
              new_page = AVL(AVLID,least)(sizeof(cons_),&heapptr->inuse,&stack);
              if (new_page==EMPTY) break;
              new_page->page_gcpriv.d = -1L; # new_page als "zu füllend" kennzeichnen
              p2 = new_page->page_end;
              l2 = new_page->page_room;
            }
          p1 -= sizeof(cons_); # p1 = Sourceadresse für nächstes Objekt
          # Kopiere das Objekt:
          ((object*)p2)[0] = ((object*)p1)[0];
          ((object*)p2)[1] = ((object*)p1)[1];
          # Hinterlasse einen Pointer auf die neue Position:
          *(object*)p1 = with_mark_bit(type_pointer_object(0,p2));
          p2 += sizeof(cons_); l2 -= sizeof(cons_);
        }
      if (!(new_page == EMPTY)) # Cache leeren?
        { new_page->page_end = p2;
          new_page->page_room = l2;
          AVL(AVLID,move)(&stack);
        }
     }
     # Die nicht kopierten Objekte bleiben an Ort und Stelle.
     page->page_gcpriv.d = page->page_end - p1; # Zugewinn
     page->page_end = p1; # jetziges Ende der Page
    }

# Kompaktierung aller Pages einer bestimmten Art:
  #ifdef SPVW_PURE
  local void gc_compact_heap (Heap* heapptr, sintB heaptype, uintL heapnr);
  local void gc_compact_heap(heapptr,heaptype,heapnr)
    var reg4 Heap* heapptr;
    var reg5 sintB heaptype;
    var reg5 uintL heapnr;
  #else
  local void gc_compact_heap (Heap* heapptr, sintB heaptype);
  local void gc_compact_heap(heapptr,heaptype)
    var reg4 Heap* heapptr;
    var reg5 sintB heaptype;
  #endif
    { # Erst eine Liste aller Pages erstellen, aufsteigend sortiert
      # nach der Anzahl der belegten Bytes:
      var reg10 uintL pagecount = 0;
      map_heap(*heapptr,page,
               { page->page_gcpriv.l = page->page_end - page->page_start; # Anzahl der belegten Bytes
                 pagecount++;
               }
              );
      # pagecount = Anzahl der Pages.
     {var DYNAMIC_ARRAY(reg6,pages_sorted,Pages,pagecount);
      {var reg4 uintL index = 0;
       map_heap(*heapptr,page, { pages_sorted[index++] = page; } );
      }
      # pages_sorted = Array der Pages.
      SORT(SORTID,sort)(pages_sorted,pagecount);
      # pages_sorted = Array der Pages, sortiert nach der Anzahl der belegten Bytes.
      # In jeder Page bedeutet page_gcpriv.d die Verschiebung nach unten,
      # die der Page in Phase 3 zuteil werden muß (>=0).
      # page_gcpriv.d = -1L für die zu füllenden Pages.
      # page_gcpriv.d = -2L für die noch unbehandelten Pages.
      map_heap(*heapptr,page, { page->page_gcpriv.d = -2L; } ); # alle Pages noch unbehandelt
      {var reg3 uintL index;
       for (index=0; index<pagecount; index++) # Durch alle Pages durchlaufen
         { var reg2 Pages page = pages_sorted[index]; # nächste Page
           if (page->page_gcpriv.d == -2L) # noch unbehandelt und
                                           # noch nicht als "zu füllend" markiert?
             { # page wird geleert.
               heapptr->inuse = AVL(AVLID,delete1)(page,heapptr->inuse); # page herausnehmen
               # page leeren:
               if (heaptype==0)
                 { gc_compact_from_cons_page(heapptr,page); }
                 else
                 #ifdef SPVW_PURE
                 { gc_compact_from_varobject_page(heapptr,page,heapnr); }
                 #else
                 { gc_compact_from_varobject_page(heapptr,page); }
                 #endif
      }  }   }
      CHECK_AVL_CONSISTENCY();
      CHECK_GC_CONSISTENCY_2();
      {var reg2 uintL index;
       for (index=0; index<pagecount; index++) # Durch alle Pages durchlaufen
         { var reg1 Pages page = pages_sorted[index]; # nächste Page
           if (!(page->page_gcpriv.d == -1L)) # eine zu leerende Page
             { page->page_room += page->page_gcpriv.d; # So viel Platz haben wir nun gemacht
               if (page->page_start == page->page_end)
                 # Page ganz geleert
                 { # Page freigeben:
                   if (page->m_length > min_page_size_brutto)
                     # Übergroße Page
                     { free_page(page); } # ans Betriebssystem zurückgeben
                     else
                     # Normalgroße Page
                     { # wieder initialisieren (page->page_room bleibt gleich!):
                       page->page_start = page->page_end = page_start0(page);
                       # in den Pool mem.free_pages einhängen:
                       page->page_gcpriv.next = mem.free_pages;
                       mem.free_pages = page;
                 }   }
                 else
                 # Page konnte nicht ganz geleert werden
                 { heapptr->inuse = AVL(AVLID,insert1)(page,heapptr->inuse); } # Page wieder rein
      }  }   }
      FREE_DYNAMIC_ARRAY(pages_sorted);
      CHECK_AVL_CONSISTENCY();
      CHECK_GC_CONSISTENCY_2();
    }}

# Kompaktierende Garbage Collection durchführen.
# Wird aufgerufen, nachdem gar_col_simple() nicht genügend Platz am Stück
# besorgen konnte.
  local void gar_col_compact (void);
  local void gar_col_compact()
    { # Es werden Lisp-Objekte von fast leeren Pages in andere Pages
      # umgefüllt, um die ganz leer machen und zurückgeben zu können.
      # 1. Für jede Page-Art:
      #    Pages unterteilen in zu leerende und zu füllende Pages und dabei
      #    soviel Daten wie möglich von den zu leerenden in die zu füllenden
      #    Pages umkopieren. Kann eine Page nicht ganz geleert werden, so
      #    wird sie so gelassen, wie sie ist, und in ihr werden dann nachher
      #    die übrigen Daten nur nach unten geschoben.
      #    Rückgabe der ganz geleerten Pages.
      # 2. Aktualisierung der Pointer.
      # 3. Durchführung der Verschiebungen in den nicht ganz geleerten Pages.
      set_break_sem_1(); # BREAK während Garbage Collection sperren
      gc_signalblock_on(); # Signale während Garbage Collection sperren
      gc_timer_on();
      immutable_off(); # immutable Objekte werden jetzt modifizierbar
      CHECK_GC_UNMARKED(); CHECK_NULLOBJ();
      { var reg1 uintL heapnr;
        for (heapnr=0; heapnr<heapcount; heapnr++)
          if (!is_unused_heap(heapnr))
            #ifdef SPVW_PURE
            { gc_compact_heap(&mem.heaps[heapnr],mem.heaptype[heapnr],heapnr); }
            #endif
            #ifdef SPVW_MIXED
            { gc_compact_heap(&mem.heaps[heapnr],1-heapnr); }
            #endif
      }
      # Aktualisierungsphase:
        # Der gesamte LISP-Speicher wird durchgegangen und dabei alte durch
        # neue Adressen ersetzt.
        # Durchlaufen durch alle LISP-Objekte und aktualisieren:
          # Pointer im LISP-Stack aktualisieren:
            aktualisiere_STACK();
          # Programmkonstanten aktualisieren:
            aktualisiere_tab();
          # Pointer in den Cons-Zellen aktualisieren:
            aktualisiere_conses();
          # Pointer in den Objekten variabler Länge aktualisieren:
            #define aktualisiere_page(page,aktualisierer)  \
              { var reg2 aint ptr = page->page_start;                        \
                var reg6 aint ptrend = page->page_end;                       \
                # alle Objekte mit Adresse >=ptr, <ptrend durchgehen:        \
                until (ptr==ptrend) # solange bis ptr am Ende angekommen ist \
                  { # nächstes Objekt mit Adresse ptr (< ptrend) durchgehen: \
                    aktualisierer(typecode_at(ptr) & ~bit(garcol_bit_t)); # und weiterrücken \
              }   }
            #define aktualisiere_fpointer_invalid  FALSE
            aktualisiere_varobjects();
            #undef aktualisiere_fpointer_invalid
            #undef aktualisiere_page
      # Durchführung der Verschiebungen in den nicht ganz geleerten Pages:
        for_each_varobject_page(page,
          { if (!(page->page_gcpriv.d == -1L))
              { var reg2 aint p1 = page->page_start;
                var reg4 aint p1end = page->page_end;
                var reg1 aint p2 = p1 - page->page_gcpriv.d;
                if (!(p1==p2)) # falls Verschiebung nötig
                  { var_speicher_laenge_;
                    page->page_start = p2;
                    until (p1==p1end) # obere Grenze erreicht -> fertig
                      { # nächstes Objekt hat Adresse p1, ist markiert
                        unmark(p1); # Markierung löschen
                        # Objekt behalten und verschieben:
                       {var reg3 uintL count = calc_speicher_laenge(p1); # Länge (durch varobject_alignment teilbar, >0)
                        move_aligned_p1_p2(count); # verschieben und weiterrücken
                      }}
                    page->page_end = p2;
          }   }   }
          );
      for_each_cons_heap(heap, { heap->lastused = dummy_lastused; } );
      recalc_space(TRUE);
      free_some_unused_pages();
      CHECK_AVL_CONSISTENCY();
      CHECK_GC_CONSISTENCY();
      CHECK_GC_UNMARKED(); CHECK_NULLOBJ();
      CHECK_PACK_CONSISTENCY();
      immutable_on();
      gc_timer_off();
      gc_signalblock_off(); # Signale wieder freigeben
      clr_break_sem_1(); # BREAK wieder ermöglichen
    }

#endif

# Garbage Collection durchführen:
  local void gar_col_simple (void);
  local void gar_col_simple()
    { var uintC saved_mv_count = mv_count; # mv_count retten
      pushSTACK(subr_self); # subr_self retten
      #if !defined(GENERATIONAL_GC)
      gar_col_normal();
      #ifdef SPVW_PAGES
      #if defined(UNIX) || defined(AMIGAOS) || defined(RISCOS) || defined(WIN32_UNIX)
      # Wenn der in Pages allozierte, aber unbelegte Speicherplatz
      # mehr als 25% dessen ausmacht, was belegt ist, lohnt sich wohl eine
      # Kompaktierung, denn fürs Betriebssystem kostet eine halbleere Page
      # genausoviel wie eine volle Page:
      if (free_space() > floor(mem.last_gcend_space,4))
        { gar_col_compact(); mem.last_gc_compacted = TRUE; }
        else
      #endif
        { mem.last_gc_compacted = FALSE; }
      #endif
      #else # defined(GENERATIONAL_GC)
      # Wenn nach der letzten GC die Objekte in der neuen Generation
      # mehr als 25% der Objekte in der alten Generation ausmachten,
      # dann machen wir diesmal eine volle Garbage-Collection (beide
      # Generationen auf einmal.)
      if (mem.last_gcend_space1 > floor(mem.last_gcend_space0,4))
        { generation = 0; gar_col_normal(); mem.last_gc_full = TRUE; }
        else
        { generation = 1; gar_col_normal(); mem.last_gc_full = FALSE; }
      #endif
      gar_col_done();
      subr_self = popSTACK(); # subr_self zurück
      mv_count = saved_mv_count; # mv_count zurück
    }

# Volle Garbage Collection durchführen:
  global void gar_col (void);
  global void gar_col()
    { var uintC saved_mv_count = mv_count; # mv_count retten
      pushSTACK(subr_self); # subr_self retten
      #if !defined(GENERATIONAL_GC)
      gar_col_normal();
      #ifdef SPVW_PAGES
      gar_col_compact(); mem.last_gc_compacted = TRUE;
      #endif
      #else # defined(GENERATIONAL_GC)
      generation = 0; gar_col_normal(); mem.last_gc_full = TRUE;
      #endif
      gar_col_done();
      subr_self = popSTACK(); # subr_self zurück
      mv_count = saved_mv_count; # mv_count zurück
    }

# Macro aktualisiere jetzt unnötig:
  #undef aktualisiere

#if defined(SPVW_MIXED_BLOCKS_OPPOSITE) && RESERVE

# Zur Reorganisation des Objektspeichers nach GC oder vor und nach EXECUTE:
  # Unterprogramm zum Verschieben der Conses.
  # move_conses(delta);
  # Der Reservespeicher wird um delta Bytes (durch varobject_alignment
  # teilbar) verkleinert, dabei die Conses um delta Bytes nach oben geschoben.
  local void move_conses (sintL delta);
  local void move_conses (delta)
    var reg4 sintL delta;
    { if (delta==0) return; # keine Verschiebung nötig?
      set_break_sem_1(); # BREAK währenddessen sperren
      gc_signalblock_on(); # Signale währenddessen sperren
      gc_timer_on();
      if (delta>0)
        # aufwärts schieben, von oben nach unten
        { var reg1 object* source = (object*) mem.conses.heap_end;
          var reg3 object* source_end = (object*) mem.conses.heap_start;
          #if !(defined(MIPS) && !defined(GNU))
          var reg2 object* dest = (object*) (mem.conses.heap_end += delta);
          #else # IRIX 4 "cc -ansi" Compiler-Bug umgehen ??
          var reg2 object* dest = (mem.conses.heap_end += delta, (object*)mem.conses.heap_end);
          #endif
          mem.conses.heap_start += delta;
          until (source==source_end)
            { *--dest = *--source; # ein ganzes Cons nach oben kopieren
              *--dest = *--source;
        }   }
        else # delta<0
        # abwärts schieben, von unten nach oben
        { var reg1 object* source = (object*) mem.conses.heap_start;
          var reg3 object* source_end = (object*) mem.conses.heap_end;
          #if !(defined(MIPS) && !defined(GNU))
          var reg2 object* dest = (object*) (mem.conses.heap_start += delta);
          #else # IRIX 4 "cc -ansi" Compiler-Bug umgehen ??
          var reg2 object* dest = (mem.conses.heap_start += delta, (object*)mem.conses.heap_start);
          #endif
          mem.conses.heap_end += delta;
          until (source==source_end)
            { *dest++ = *source++; # ein ganzes Cons nach oben kopieren
              *dest++ = *source++;
        }   }
      # Pointer auf Conses u.ä. aktualisieren:
      { var reg4 soint odelta = (soint)delta<<(oint_addr_shift-addr_shift); # Offset im oint
        # Der gesamte LISP-Speicher wird durchgegangen und dabei alte durch
        # neue Adressen ersetzt.
        # Aktualisierung eines Objekts *objptr :
          #define aktualisiere(objptr)  \
            { switch (mtypecode(*(object*)(objptr)))                          \
                { case_cons: case_ratio: case_complex: # Zwei-Pointer-Objekt? \
                    *(oint*)(objptr) += odelta; break;                        \
                  default: break;                                             \
            }   }
        # Durchlaufen durch alle LISP-Objekte und aktualisieren:
          # Pointer im LISP-Stack aktualisieren:
            { var reg2 object* objptr = &STACK_0; # Pointer, der durch den STACK läuft
              until (eq(*objptr,nullobj)) # bis STACK zu Ende ist:
                { if ( *((oint*)objptr) & wbit(frame_bit_o) ) # Beginnt hier ein Frame?
                   { if (( *((oint*)objptr) & wbit(skip2_bit_o) ) == 0) # Ohne skip2-Bit?
                      objptr skipSTACKop 2; # ja -> um 2 weiterrücken
                      else
                      objptr skipSTACKop 1; # nein -> um 1 weiterrücken
                   }
                   else
                   { aktualisiere(objptr); # normales Objekt, aktualisieren
                     objptr skipSTACKop 1; # weiterrücken
            }   }  }
          # Programmkonstanten aktualisieren:
            aktualisiere_tab();
          # Pointer in den Cons-Zellen aktualisieren:
            aktualisiere_conses();
          # Pointer in den Objekten variabler Länge aktualisieren:
            #define aktualisiere_page  aktualisiere_page_normal
            #define aktualisiere_fpointer_invalid  FALSE
            aktualisiere_varobjects();
            #undef aktualisiere_fpointer_invalid
            #undef aktualisiere_page
        # Macro aktualisiere jetzt unnötig:
          #undef aktualisiere
      }
      # Ende des Verschiebens und Aktualisierens.
      # benötigte Zeit zur GC-Gesamtzeit addieren:
      gc_timer_off();
      gc_signalblock_off(); # Signale wieder freigeben
      clr_break_sem_1(); # BREAK wieder ermöglichen
    }

#endif

# ------------------------------------------------------------------------------
#                 Speicherbereitstellungsfunktionen

# Fehlermeldung wegen vollen Speichers
  nonreturning_function(local, fehler_speicher_voll, (void));
  local void fehler_speicher_voll()
    { dynamic_bind(S(use_clcs),NIL); # SYS::*USE-CLCS* an NIL binden
      //: DEUTSCH "Speicherplatz für LISP-Objekte ist voll."
      //: ENGLISH "No more room for LISP objects"
      //: FRANCAIS "Il n'y a plus de place pour des objets LISP."
      fehler(storage_condition,GETTEXT("no more room for LISP objects"));
    }

# Stellt fest, ob eine Adresse im Intervall [0..2^oint_addr_len-1] liegt:
  #if (oint_addr_len==32) && !defined(WIDE_HARD) # d.h. defined(WIDE_SOFT)
    #define pointable_usable_test(a)  TRUE
  #else
    #define pointable_usable_test(a)  \
      ((void*)pointable(type_pointer_object(0,a)) == (void*)(a))
  #endif

# Holt Speicher vom Betriebssystem
  local void* mymalloc (uintL need);
  local void* mymalloc(need)
    var reg3 uintL need;
    {
      var reg1 void* addr;
      begin_system_call();
      addr = malloc(need);
      end_system_call();
      if (addr==NULL) return NULL;
      # Intervall [addr,addr+need-1] muß in [0..2^oint_addr_len-1] liegen:
      { var reg2 aint a = (aint)addr; # a = untere Intervallgrenze
        if (pointable_usable_test(a))
          { a = round_down(a + need-1,bit(addr_shift)); # a = obere Intervallgrenze
            if (pointable_usable_test(a))
              { return addr; }
      }   }
      # Mit diesem Stück Speicher können wir nichts anfangen, wieder zurückgeben:
      begin_system_call();
      free(addr);
      end_system_call();
      #if defined(AMIGAOS) && !(defined(WIDE) || defined(MC68000))
      # Wir machen einen zweiten Versuch mit veränderten Flags.
      if (!(default_allocmemflag == retry_allocmemflag))
        { addr = allocmem(need,retry_allocmemflag);
          if (addr==NULL) return NULL;
          # Intervall [addr,addr+need-1] muß in [0..2^oint_addr_len-1] liegen:
          { var reg2 aint a = (aint)addr; # a = untere Intervallgrenze
            if (pointable_usable_test(a))
              { a = round_down(a + need-1,bit(addr_shift)); # a = obere Intervallgrenze
                if (pointable_usable_test(a))
                  { return addr; }
          }   }
          # Auch mit diesem Stück Speicher können wir nichts anfangen, wieder zurückgeben:
          freemem(addr);
        }
      #endif
      return NULL;
    }

#ifdef SPVW_MIXED_BLOCKS_OPPOSITE

# Schafft Platz für ein neues Objekt.
# Falls keiner vorhanden -> Fehlermeldung.
# make_space(need);
# > uintL need: angeforderter Platz in Bytes (eine Variable oder Konstante)
  # Der Test, ob Platz vorhanden ist, als Macro, der Rest als Funktion:
  #define make_space(need)  \
    { if (not_enough_room_p(need)) make_space_gc(need); }
  #if !defined(GENERATIONAL_GC)
    #define not_enough_room_p(need)  (mem.conses.heap_start-mem.varobjects.heap_end < (uintP)(need))
  #else
    #define not_enough_room_p(need)  (mem.total_room < (uintL)(need))
  #endif
  local void make_space_gc (uintL need);
  local void make_space_gc(need)
    var reg1 uintL need;
    { # (mem.conses.heap_start-mem.varobjects.heap_end < need)  bzw.
      # (mem.total_room < need)  ist schon abgeprüft, also
        # Nicht genügend Platz
        not_enough_room:
        { gar_col_simple(); # Garbage Collector aufrufen
          doing_gc:
          # Teste auf Tastatur-Unterbrechung
          interruptp(
            { pushSTACK(S(gc)); tast_break();
              if (not_enough_room_p(need)) goto not_enough_room;
                else
                return;
            });
          if (mem.conses.heap_start-mem.varobjects.heap_end < (uintP)(need)) # und wieder testen
            # Wirklich nicht genügend Platz da.
            # [Unter UNIX mit 'realloc' arbeiten??]
            # Abhilfe: man versucht eine volle GC.
            {
              #ifdef GENERATIONAL_GC
              if (!mem.last_gc_full)
                { gar_col(); goto doing_gc; }
                else
              #endif
                # Abhilfe: Reservespeicher wird halbiert.
                {
                  #if RESERVE
                  var reg1 uintL reserve = mem.MEMTOP - mem.MEMRES; # noch freie Reserve
                  if (reserve>=8) # Reservespeicher auch voll?
                    # nein -> Reservespeicher anzapfen und Fehlermeldung ausgeben
                    # halbe Reserve
                    { move_conses(round_down(floor(reserve,2),varobject_alignment));
                      # halbierte Reserve, aligned: um soviel die Conses nach oben schieben
                      fehler_speicher_voll();
                    }
                    else
                  #endif
                    # ja -> harte Fehlermeldung
                    { 
                      //: DEUTSCH "Speicherplatz für LISP-Objekte ist voll: RESET"
                      //: ENGLISH "No more room for LISP objects: RESET"
                      //: FRANCAIS "Il n'y a plus de place pour des objets LISP : RAZ"
                      err_asciz_out(GETTEXT("no more room for LISP objects"));
                      reset(); # und zum letzten Driver-Frame zurück
                    }
                }
            }
            else
            # Jetzt ist genügend Platz da. Vielleicht sogar genug, den
            # Reservespeicher auf normale Größe zu bringen?
            {
              #if RESERVE
              var reg2 uintL free = (mem.conses.heap_start-mem.varobjects.heap_end) - need;
                                # soviel Bytes noch frei
              var reg2 uintL free_reserve = mem.MEMTOP-mem.MEMRES;
                                # soviel Bytes noch in der Reserve frei, <=RESERVE
              var reg2 uintL free_total = free + free_reserve;
                                # freier Objektspeicher + freie Reserve
              if (free_total >= RESERVE) # mindestens Normalwert RESERVE ?
                # ja -> Reservespeicher auf normale Größe bringen, indem
                # die Conses um (RESERVE - free_reserve) nach unten geschoben
                # werden:
                move_conses(free_reserve-RESERVE);
                # Dadurch bleibt genügend für need frei.
              #endif
              # Jetzt ist sicher (mem.conses.heap_start-mem.varobjects.heap_end >= need).
              #ifdef GENERATIONAL_GC
              # Falls (mem.total_room < need), ignorieren wir das:
              if (mem.total_room < need) { mem.total_room = need; }
              #endif
            }
    }   }

#endif

#if defined(SPVW_PURE_BLOCKS) || defined(TRIVIALMAP_MEMORY) # <==> SINGLEMAP_MEMORY || TRIVIALMAP_MEMORY

# Schafft Platz für ein neues Objekt.
# Falls keiner vorhanden -> Fehlermeldung.
# make_space(need,heapptr);
# > uintL need: angeforderter Platz in Bytes (eine Variable oder Konstante)
# > Heap* heapptr: Pointer auf den Heap, dem der Platz entnommen werden soll
  # Der Test, ob Platz vorhanden ist, als Macro, der Rest als Funktion:
  #define make_space(need,heapptr)  \
    { if ((mem.total_room < (uintL)(need))                                 \
          || ((heapptr)->heap_limit - (heapptr)->heap_end < (uintP)(need)) \
         )                                                                 \
        make_space_gc(need,heapptr);                                       \
    }
  local void make_space_gc (uintL need, Heap* heapptr);
  local void make_space_gc(need,heapptr)
    var reg2 uintL need;
    var reg1 Heap* heapptr;
    { # (mem.total_room < need) || (heapptr->heap_limit - heapptr->heap_end < need)
      # ist schon abgeprüft, also nicht genügend Platz.
      not_enough_room:
     {var reg4 boolean done_gc = FALSE;
      if (mem.total_room < need)
        do_gc:
        { gar_col_simple(); # Garbage Collector aufrufen
          doing_gc:
          # Teste auf Tastatur-Unterbrechung
          interruptp(
            { pushSTACK(S(gc)); tast_break();
              if ((mem.total_room < need) || (heapptr->heap_limit - heapptr->heap_end < need))
                goto not_enough_room;
                else
                return;
            });
          done_gc = TRUE;
        }
      # Entweder ist jetzt (mem.total_room >= need), oder aber wir haben gerade
      # eine GC durchgeführt. In beiden Fällen konzentrieren wir uns nun
      # darauf, heapptr->heap_limit zu vergrößern.
      { var reg3 aint needed_limit = heapptr->heap_end + need;
        if (needed_limit <= heapptr->heap_limit) # hat die GC ihre Arbeit getan?
          return; # ja -> fertig
        # Aufrunden bis zur nächsten Seitengrenze:
        #ifndef GENERATIONAL_GC
        needed_limit = round_up(needed_limit,map_pagesize); # sicher > heapptr->heap_limit
        #else # map_pagesize bekanntermaßen eine Zweierpotenz
        needed_limit = (needed_limit + map_pagesize-1) & -map_pagesize; # sicher > heapptr->heap_limit
        #endif
        # neuen Speicher allozieren:
        if (zeromap((void*)(heapptr->heap_limit),needed_limit - heapptr->heap_limit) <0)
          { if (!done_gc)
              goto do_gc;
            #ifdef GENERATIONAL_GC
            if (!mem.last_gc_full)
              { gar_col(); goto doing_gc; }
            #endif
            fehler_speicher_voll();
          }
        heapptr->heap_limit = needed_limit;
      }
      # Jetzt ist sicher (heapptr->heap_limit - heapptr->heap_end >= need).
      # Falls (mem.total_room < need), ignorieren wir das:
      if (mem.total_room < need) { mem.total_room = need; }
    }}

#endif

#ifdef SPVW_PAGES

# Schafft Platz für ein neues Objekt.
# Falls keiner vorhanden -> Fehlermeldung.
# make_space(need,heap_ptr,stack_ptr, page);
# > uintL need: angeforderter Platz in Bytes (eine Variable oder Konstante)
# > Heap* heap_ptr: Adresse des Heaps, aus dem der Platz genommen werden soll
# > AVL(AVLID,stack) * stack_ptr: Adressen eines lokalen Stacks,
#   für ein späteres AVL(AVLID,move)
# < Pages page: gefundene Page, wo der Platz ist
  # Der Test, ob Platz vorhanden ist, als Macro, der Rest als Funktion:
  #define make_space(need,heap_ptr,stack_ptr,pagevar)  \
    { pagevar = AVL(AVLID,least)(need,&(heap_ptr)->inuse,stack_ptr);    \
      if (pagevar==EMPTY)                                               \
        { pagevar = make_space_gc(need,&(heap_ptr)->inuse,stack_ptr); } \
    }
  local Pages make_space_gc (uintL need, Pages* pages_ptr, AVL(AVLID,stack) * stack_ptr);
  local Pages make_space_gc(need,pages_ptr,stack_ptr)
    var reg2 uintL need;
    var reg3 Pages* pages_ptr;
    var reg4 AVL(AVLID,stack) * stack_ptr;
    { # AVL(AVLID,least)(need,pages_ptr,stack_ptr) == EMPTY
      # ist schon abgeprüft, also
        # Nicht genügend Platz
        not_enough_room:
        #define handle_interrupt_after_gc()  \
          { # Teste auf Tastatur-Unterbrechung                                    \
            interruptp(                                                           \
              { pushSTACK(S(gc)); tast_break();                                   \
               {var reg1 Pages page = AVL(AVLID,least)(need,pages_ptr,stack_ptr); \
                if (page==EMPTY) goto not_enough_room;                            \
                  else                                                            \
                  return page;                                                    \
              }});                                                                \
          }
        #if !defined(AVL_SEPARATE)
        #define make_space_using_malloc()  \
          # versuche, beim Betriebssystem Platz zu bekommen:                        \
          { var reg5 uintL size1 = round_up(need,sizeof(cons_));                    \
            if (size1 < std_page_size) { size1 = std_page_size; }                   \
           {var reg7 uintL size2 = size1 + sizeof(NODE) + (varobject_alignment-1);  \
            var reg6 aint addr = (aint)mymalloc(size2);                             \
            if (!((void*)addr == NULL))                                             \
              { # Page vom Betriebssystem bekommen.                                 \
                var reg1 Pages page = (Pages)addr;                                  \
                page->m_start = addr; page->m_length = size2;                       \
                # Initialisieren:                                                   \
                page->page_start = page->page_end = page_start0(page);              \
                page->page_room = size1;                                            \
                # Diesem Heap zuschlagen:                                           \
                *pages_ptr = AVL(AVLID,insert1)(page,*pages_ptr);                   \
                if (!(AVL(AVLID,least)(need,pages_ptr,stack_ptr) == page)) abort(); \
                mem.total_space += size1;                                           \
                return page;                                                        \
          }}  }
        #else # AVL_SEPARATE
        #define make_space_using_malloc()  \
          # versuche, beim Betriebssystem Platz zu bekommen:                            \
          { var reg5 uintL size1 = round_up(need,sizeof(cons_));                        \
            if (size1 < std_page_size) { size1 = std_page_size; }                       \
            begin_system_call();                                                        \
           {var reg1 Pages page = (NODE*)malloc(sizeof(NODE));                          \
            end_system_call();                                                          \
            if (!(page == NULL))                                                        \
              { var reg7 uintL size2 = size1 + (varobject_alignment-1);                 \
                var reg6 aint addr = (aint)mymalloc(size2);                             \
                if (!((void*)addr == NULL))                                             \
                  { # Page vom Betriebssystem bekommen.                                 \
                    page->m_start = addr; page->m_length = size2;                       \
                    # Initialisieren:                                                   \
                    page->page_start = page->page_end = page_start0(page);              \
                    page->page_room = size1;                                            \
                    # Diesem Heap zuschlagen:                                           \
                    *pages_ptr = AVL(AVLID,insert1)(page,*pages_ptr);                   \
                    if (!(AVL(AVLID,least)(need,pages_ptr,stack_ptr) == page)) abort(); \
                    mem.total_space += size1;                                           \
                    return page;                                                        \
                  }                                                                     \
                  else                                                                  \
                  { begin_system_call(); free(page); end_system_call(); }               \
          }}  }
        #endif
        if ((need <= std_page_size) && !(mem.free_pages == NULL))
          { # Eine normalgroße Page aus dem allgemeinen Pool entnehmen:
            var reg1 Pages page = mem.free_pages;
            mem.free_pages = page->page_gcpriv.next;
            # page ist bereits korrekt initialisiert:
            # page->page_start = page->page_end = page_start0(page);
            # page->page_room =
            #   round_down(page->m_start + page->m_length,varobject_alignment)
            # und diesem Heap zuschlagen:
            *pages_ptr = AVL(AVLID,insert1)(page,*pages_ptr);
            if (!(AVL(AVLID,least)(need,pages_ptr,stack_ptr) == page)) abort();
            mem.total_space += page->page_room;
            return page;
          }
        if (used_space()+need < mem.gctrigger_space)
          # Benutzter Platz ist seit der letzten GC noch nicht einmal um 25%
          # angewachsen -> versuche es erstmal beim Betriebssystem;
          # die GC machen wir, wenn die 25%-Grenze erreicht ist.
          { make_space_using_malloc(); }
        { gar_col_simple(); # Garbage Collector aufrufen
          handle_interrupt_after_gc();
          # und wieder testen:
         {var reg1 Pages page = AVL(AVLID,least)(need,pages_ptr,stack_ptr);
          if (page==EMPTY)
            { if (!mem.last_gc_compacted)
                { gar_col_compact(); # kompaktierenden Garbage Collector aufrufen
                  handle_interrupt_after_gc();
                  page = AVL(AVLID,least)(need,pages_ptr,stack_ptr);
                }
              if (page==EMPTY)
                # versuche es nun doch beim Betriebssystem:
                { make_space_using_malloc();
                  fehler_speicher_voll();
            }   }
          # .reserve behandeln??
          return page;
        }}
        #undef make_space_using_malloc
        #undef handle_interrupt_after_gc
    }

#endif

# Macro zur Speicher-Allozierung eines Lisp-Objekts:
# allocate(type,flag,size,ptrtype,ptr,statement)
# > type: Expression, die den Typcode liefert
# > flag: ob Objekt variabler Länge oder nicht
# > size: Expression (constant oder var), die die Größe des benötigten
#         Speicherstücks angibt
# ptrtype: C-Typ von ptr
# ptr: C-Variable
# Ein Speicherstück der Länge size, passend zu einem Lisp-Objekt vom Typ type,
# wird geholt und ptr auf seine Anfangsadresse gesetzt. Dann wird statement
# ausgeführt (Initialisierung des Speicherstücks) und schließlich ptr,
# mit der korrekten Typinfo versehen, als Ergebnis geliefert.
  #ifdef SPVW_BLOCKS
   #if defined(SPVW_PURE_BLOCKS) || defined(TRIVIALMAP_MEMORY) || defined(GENERATIONAL_GC)
    #define decrement_total_room(amount)  mem.total_room -= (amount);
   #else
    #define decrement_total_room(amount)
   #endif
   #ifdef SPVW_MIXED_BLOCKS_OPPOSITE
    #define allocate(type_expr,flag,size_expr,ptrtype,ptrvar,statement)  \
      allocate_##flag (type_expr,size_expr,ptrtype,ptrvar,statement)
    # Objekt variabler Länge:
    #define allocate_TRUE(type_expr,size_expr,ptrtype,ptrvar,statement)  \
      { make_space(size_expr);                                                        \
        set_break_sem_1(); # Break sperren                                            \
       {var reg1 ptrtype ptrvar;                                                      \
        var reg4 object obj;                                                          \
        ptrvar = (ptrtype) mem.varobjects.heap_end; # Pointer auf Speicherstück       \
        mem.varobjects.heap_end += (size_expr); # Speicheraufteilung berichtigen      \
        decrement_total_room(size_expr);                                              \
        ptrvar->GCself = obj = type_pointer_object(type_expr,ptrvar); # Selbstpointer \
        statement; # Speicherstück initialisieren                                     \
        clr_break_sem_1(); # Break ermöglichen                                        \
        CHECK_GC_CONSISTENCY();                                                       \
        return obj;                                                                   \
      }}
    # Cons o.ä.:
    #define allocate_FALSE(type_expr,size_expr,ptrtype,ptrvar,statement)  \
      { make_space(size_expr);                                                              \
        set_break_sem_1(); # Break sperren                                                  \
       {var reg1 ptrtype ptrvar;                                                            \
        ptrvar = (ptrtype)(mem.conses.heap_start -= size_expr); # Pointer auf Speicherstück \
        decrement_total_room(size_expr);                                                    \
        statement; # Speicherstück initialisieren                                           \
        clr_break_sem_1(); # Break ermöglichen                                              \
        CHECK_GC_CONSISTENCY();                                                             \
        return type_pointer_object(type_expr,ptrvar);                                       \
      }}
   #endif
   #if defined(SPVW_MIXED_BLOCKS) && defined(TRIVIALMAP_MEMORY)
    #define allocate(type_expr,flag,size_expr,ptrtype,ptrvar,statement)  \
      allocate_##flag (type_expr,size_expr,ptrtype,ptrvar,statement)
    # Objekt variabler Länge:
    #define allocate_TRUE(type_expr,size_expr,ptrtype,ptrvar,statement)  \
      { make_space(size_expr,&mem.varobjects);                                        \
        set_break_sem_1(); # Break sperren                                            \
       {var reg1 ptrtype ptrvar;                                                      \
        var reg4 object obj;                                                          \
        ptrvar = (ptrtype) mem.varobjects.heap_end; # Pointer auf Speicherstück       \
        mem.varobjects.heap_end += (size_expr); # Speicheraufteilung berichtigen      \
        decrement_total_room(size_expr);                                              \
        ptrvar->GCself = obj = type_pointer_object(type_expr,ptrvar); # Selbstpointer \
        statement; # Speicherstück initialisieren                                     \
        clr_break_sem_1(); # Break ermöglichen                                        \
        CHECK_GC_CONSISTENCY();                                                       \
        return obj;                                                                   \
      }}
    # Cons o.ä.:
    #define allocate_FALSE(type_expr,size_expr,ptrtype,ptrvar,statement)  \
      { make_space(size_expr,&mem.conses);                                                   \
        set_break_sem_1(); # Break sperren                                                   \
       {var reg1 ptrtype ptrvar = (ptrtype) mem.conses.heap_end; # Pointer auf Speicherstück \
        mem.conses.heap_end += (size_expr); # Speicheraufteilung berichtigen                 \
        decrement_total_room(size_expr);                                                     \
        statement; # Speicherstück initialisieren                                            \
        clr_break_sem_1(); # Break ermöglichen                                               \
        CHECK_GC_CONSISTENCY();                                                              \
        return type_pointer_object(type_expr,ptrvar);                                        \
      }}
   #endif
   #ifdef SPVW_PURE
    #define allocate(type_expr,flag,size_expr,ptrtype,ptrvar,statement)  \
      { var reg4 tint _type = (type_expr);                                 \
        var reg3 Heap* heapptr = &mem.heaps[_type];                        \
        make_space(size_expr,heapptr);                                     \
        set_break_sem_1(); # Break sperren                                 \
       {var reg1 ptrtype ptrvar = (ptrtype)(heapptr->heap_end); # Pointer auf Speicherstück \
        heapptr->heap_end += (size_expr); # Speicheraufteilung berichtigen \
        decrement_total_room(size_expr);                                   \
        allocate_##flag (ptrvar);                                          \
        statement; # Speicherstück initialisieren                          \
        clr_break_sem_1(); # Break ermöglichen                             \
        CHECK_GC_CONSISTENCY();                                            \
        return as_object((oint)ptrvar);                                    \
      }}
    # Objekt variabler Länge:
    #define allocate_TRUE(ptrvar)  \
      ptrvar->GCself = as_object((oint)ptrvar); # Selbstpointer eintragen
    # Cons o.ä.:
    #define allocate_FALSE(ptrvar)
   #endif
  #endif
  #ifdef SPVW_PAGES
    #define allocate(type_expr,flag,size_expr,ptrtype,ptrvar,statement)  \
      allocate_##flag (type_expr,size_expr,ptrtype,ptrvar,statement)
   #ifdef SPVW_MIXED
    # Objekt variabler Länge:
    #define allocate_TRUE(type_expr,size_expr,ptrtype,ptrvar,statement)  \
      { # Suche nach der Page mit dem kleinsten page_room >= size_expr:               \
        var AVL(AVLID,stack) stack;                                                   \
        var reg2 Pages page;                                                          \
        make_space(size_expr,&mem.varobjects,&stack, page);                           \
        set_break_sem_1(); # Break sperren                                            \
       {var reg1 ptrtype ptrvar =                                                     \
          (ptrtype)(page->page_end); # Pointer auf Speicherstück                      \
        var reg4 object obj;                                                          \
        ptrvar->GCself = obj = type_pointer_object(type_expr,ptrvar); # Selbstpointer \
        statement; # Speicherstück initialisieren                                     \
        page->page_room -= (size_expr); # Speicheraufteilung berichtigen              \
        page->page_end += (size_expr);                                                \
        mem.used_space += (size_expr);                                                \
        AVL(AVLID,move)(&stack); # Page wieder an die richtige Position hängen        \
        clr_break_sem_1(); # Break ermöglichen                                        \
        CHECK_AVL_CONSISTENCY();                                                      \
        CHECK_GC_CONSISTENCY();                                                       \
        return obj;                                                                   \
      }}
    # Cons o.ä.:
    #define allocate_FALSE(type_expr,size_expr,ptrtype,ptrvar,statement)  \
      { # Suche nach der Page mit dem kleinsten page_room >= size_expr = 8: \
        var reg2 Pages page;                                                \
        # 1. Versuch: letzte benutzte Page                                  \
        page = mem.conses.lastused;                                         \
        if (page->page_room == 0) # Test auf page->page_room < size_expr = sizeof(cons_) \
          { var AVL(AVLID,stack) stack;                                     \
            # 2. Versuch:                                                   \
            make_space(size_expr,&mem.conses,&stack, page);                 \
            mem.conses.lastused = page;                                     \
          }                                                                 \
        set_break_sem_1(); # Break sperren                                  \
       {var reg1 ptrtype ptrvar =                                           \
          (ptrtype)(page->page_end); # Pointer auf Speicherstück            \
        statement; # Speicherstück initialisieren                           \
        page->page_room -= (size_expr); # Speicheraufteilung berichtigen    \
        page->page_end += (size_expr);                                      \
        mem.used_space += (size_expr);                                      \
        # Da page_room nun =0 geworden oder >=sizeof(cons_) geblieben ist,  \
        # ist die Sortierreihenfolge der Pages unverändert geblieben.       \
        clr_break_sem_1(); # Break ermöglichen                              \
        CHECK_AVL_CONSISTENCY();                                            \
        CHECK_GC_CONSISTENCY();                                             \
        return type_pointer_object(type_expr,ptrvar);                       \
      }}
   #endif
   #ifdef SPVW_PURE
    # Objekt variabler Länge:
    #define allocate_TRUE(type_expr,size_expr,ptrtype,ptrvar,statement)  \
      { # Suche nach der Page mit dem kleinsten page_room >= size_expr:           \
        var AVL(AVLID,stack) stack;                                               \
        var reg2 Pages page;                                                      \
        var reg4 tint _type = (type_expr);                                        \
        make_space(size_expr,&mem.heaps[_type],&stack, page);                     \
        set_break_sem_1(); # Break sperren                                        \
       {var reg1 ptrtype ptrvar =                                                 \
          (ptrtype)(page->page_end); # Pointer auf Speicherstück                  \
        var reg5 object obj;                                                      \
        ptrvar->GCself = obj = type_pointer_object(_type,ptrvar); # Selbstpointer \
        statement; # Speicherstück initialisieren                                 \
        page->page_room -= (size_expr); # Speicheraufteilung berichtigen          \
        page->page_end += (size_expr);                                            \
        mem.used_space += (size_expr);                                            \
        AVL(AVLID,move)(&stack); # Page wieder an die richtige Position hängen    \
        clr_break_sem_1(); # Break ermöglichen                                    \
        CHECK_AVL_CONSISTENCY();                                                  \
        CHECK_GC_CONSISTENCY();                                                   \
        return obj;                                                               \
      }}
    # Cons o.ä.:
    #define allocate_FALSE(type_expr,size_expr,ptrtype,ptrvar,statement)  \
      { # Suche nach der Page mit dem kleinsten page_room >= size_expr = 8: \
        var reg2 Pages page;                                                \
        var reg4 tint _type = (type_expr);                                  \
        var reg3 Heap* heapptr = &mem.heaps[_type];                         \
        # 1. Versuch: letzte benutzte Page                                  \
        page = heapptr->lastused;                                           \
        if (page->page_room == 0) # Test auf page->page_room < size_expr = sizeof(cons_) \
          { var AVL(AVLID,stack) stack;                                     \
            # 2. Versuch:                                                   \
            make_space(size_expr,heapptr,&stack, page);                     \
            heapptr->lastused = page;                                       \
          }                                                                 \
        set_break_sem_1(); # Break sperren                                  \
       {var reg1 ptrtype ptrvar =                                           \
          (ptrtype)(page->page_end); # Pointer auf Speicherstück            \
        statement; # Speicherstück initialisieren                           \
        page->page_room -= (size_expr); # Speicheraufteilung berichtigen    \
        page->page_end += (size_expr);                                      \
        mem.used_space += (size_expr);                                      \
        # Da page_room nun =0 geworden oder >=sizeof(cons_) geblieben ist,  \
        # ist die Sortierreihenfolge der Pages unverändert geblieben.       \
        clr_break_sem_1(); # Break ermöglichen                              \
        CHECK_AVL_CONSISTENCY();                                            \
        CHECK_GC_CONSISTENCY();                                             \
        return type_pointer_object(_type,ptrvar);                           \
      }}
   #endif
  #endif

# UP, beschafft ein Cons
# allocate_cons()
# < ergebnis: Pointer auf neues CONS, mit CAR und CDR =NIL
# kann GC auslösen
  global object allocate_cons (void);
  global object allocate_cons()
    { allocate(cons_type,FALSE,sizeof(cons_),Cons,ptr,
               { ptr->cdr = NIL; ptr->car = NIL; }
              )
    }

# UP: Liefert ein neu erzeugtes uninterniertes Symbol mit gegebenem Printnamen.
# make_symbol(string)
# > string: Simple-String
# < ergebnis: neues Symbol mit diesem Namen, mit Home-Package=NIL.
# kann GC auslösen
  global object make_symbol (object string);
  global object make_symbol(string)
    var reg3 object string;
    {
      #ifdef IMMUTABLE_ARRAY
      string = make_imm_array(string); # String immutabel machen
      #endif
      pushSTACK(string); # String retten
      allocate(symbol_type,TRUE,size_symbol(),Symbol,ptr,
               { ptr->symvalue = unbound; # leere Wertzelle
                 ptr->symfunction = unbound; # leere Funktionszelle
                 ptr->proplist = NIL; # leere Propertyliste
                 ptr->pname = popSTACK(); # Namen eintragen
                 ptr->homepackage = NIL; # keine Home-Package
               }
              )
    }

# UP, beschafft Vektor
# allocate_vector(len)
# > len: Länge des Vektors
# < ergebnis: neuer Vektor (Elemente werden mit NIL initialisiert)
# kann GC auslösen
  global object allocate_vector (uintL len);
  global object allocate_vector (len)
    var reg2 uintL len;
    { var reg3 uintL need = size_svector(len); # benötigter Speicherplatz
      allocate(svector_type,TRUE,need,Svector,ptr,
               { ptr->length = len;
                {var reg1 object* p = &ptr->data[0];
                 dotimesL(len,len, { *p++ = NIL; } ); # Elemente mit NIL vollschreiben
               }}
              )
    }

# UP, beschafft Bit-Vektor
# allocate_bit_vector(len)
# > len: Länge des Bitvektors (in Bits)
# < ergebnis: neuer Bitvektor (LISP-Objekt)
# kann GC auslösen
  global object allocate_bit_vector (uintL len);
  global object allocate_bit_vector (len)
    var reg2 uintL len;
    { var reg3 uintL need = size_sbvector(len); # benötigter Speicherplatz in Bytes
      allocate(sbvector_type,TRUE,need,Sbvector,ptr,
               { ptr->length = len; } # Keine weitere Initialisierung
              )
    }

# UP, beschafft String
# allocate_string(len)
# > len: Länge des Strings (in Bytes)
# < ergebnis: neuer Simple-String (LISP-Objekt)
# kann GC auslösen
  global object allocate_string (uintL len);
  global object allocate_string (len)
    var reg2 uintL len;
    { var reg4 uintL need = size_sstring(len); # benötigter Speicherplatz in Bytes
      allocate(sstring_type,TRUE,need,Sstring,ptr,
               { ptr->length = len; } # Keine weitere Initialisierung
              )
    }

# UP, beschafft Array
# allocate_array(flags,rank,type)
# > uintB flags: Flags
# > uintC rank: Rang
# > tint type: Typinfo
# < ergebnis: LISP-Objekt Array
# kann GC auslösen
  global object allocate_array (uintB flags, uintC rank, tint type);
  global object allocate_array(flags,rank,type)
    var reg3 uintB flags;
    var reg5 uintC rank;
    var reg6 tint type;
    { var reg2 uintL need = rank;
      if (flags & bit(arrayflags_fillp_bit)) { need += 1; }
      if (flags & bit(arrayflags_dispoffset_bit)) { need += 1; }
      need = size_array(need);
      allocate(type,TRUE,need,Array,ptr,
               { ptr->flags = flags; ptr->rank = rank; # Flags und Rang eintragen
                 ptr->data = NIL; # Datenvektor mit NIL initialisieren
               }
              )
    }

# UP, beschafft Simple-Record
# allocate_srecord_(flags_rectype,reclen,type)
# > uintW flags_rectype: Flags, nähere Typinfo
# > uintC reclen: Länge
# > tint type: Typinfo
# < ergebnis: LISP-Objekt Record (Elemente werden mit NIL initialisiert)
# kann GC auslösen
  global object allocate_srecord_ (uintW flags_rectype, uintC reclen, tint type);
  global object allocate_srecord_(flags_rectype,reclen,type)
    var reg3 uintW flags_rectype;
    var reg2 uintC reclen;
    var reg5 tint type;
    { ASSERT(!((flags_rectype & bit(BIG_ENDIAN_P ? intBsize-1 : 2*intBsize-1)) == 0)); # rectype < 0
     {var reg2 uintL need = size_srecord(reclen);
      allocate(type,TRUE,need,Srecord,ptr,
               { *(uintW*)pointerplus(ptr,offsetof(record_,recflags)) = flags_rectype; # Flags, Typ eintragen
                 ptr->reclength = reclen; # Länge eintragen
                {var reg1 object* p = &ptr->recdata[0];
                 dotimespC(reclen,reclen, { *p++ = NIL; } ); # Elemente mit NIL vollschreiben
               }}
              )
    }}

# UP, beschafft Extended-Record
# allocate_xrecord_(flags_rectype,reclen,recxlen,type)
# > uintW flags_rectype: Flags, nähere Typinfo
# > uintC reclen: Länge
# > uintC recxlen: Extra-Länge
# > tint type: Typinfo
# < ergebnis: LISP-Objekt Record (Elemente werden mit NIL bzw. 0 initialisiert)
# kann GC auslösen
  global object allocate_xrecord_ (uintW flags_rectype, uintC reclen, uintC recxlen, tint type);
  global object allocate_xrecord_(flags_rectype,reclen,recxlen,type)
    var reg4 uintW flags_rectype;
    var reg2 uintC reclen;
    var reg3 uintC recxlen;
    var reg6 tint type;
    { ASSERT((flags_rectype & bit(BIG_ENDIAN_P ? intBsize-1 : 2*intBsize-1)) == 0); # rectype >= 0
     {var reg2 uintL need = size_xrecord(reclen,recxlen);
      allocate(type,TRUE,need,Xrecord,ptr,
               { *(uintW*)pointerplus(ptr,offsetof(record_,recflags)) = flags_rectype; # Flags, Typ eintragen
                 ptr->reclength = reclen; ptr->recxlength = recxlen; # Längen eintragen
                {var reg1 object* p = &ptr->recdata[0];
                 dotimesC(reclen,reclen, { *p++ = NIL; } ); # Elemente mit NIL vollschreiben
                 {var reg1 uintB* q = (uintB*)p;
                  dotimesC(recxlen,recxlen, { *q++ = 0; } ); # Extra-Elemente mit 0 vollschreiben
               }}}
              )
    }}

#ifndef case_stream

# UP, beschafft Stream
# allocate_stream(strmflags,strmtype,reclen)
# > uintB strmflags: Flags
# > uintB strmtype: nähere Typinfo
# > uintC reclen: Länge
# < ergebnis: LISP-Objekt Stream (Elemente werden mit NIL initialisiert)
# kann GC auslösen
  global object allocate_stream (uintB strmflags, uintB strmtype, uintC reclen);
  global object allocate_stream(strmflags,strmtype,reclen)
    var reg3 uintB strmflags;
    var reg4 uintB strmtype;
    var reg2 uintC reclen;
    { var reg1 object obj = allocate_xrecord(0,Rectype_Stream,reclen,0,orecord_type);
      TheRecord(obj)->recdata[0] = Fixnum_0; # Fixnum als Platz für strmflags und strmtype
      TheStream(obj)->strmflags = strmflags; TheStream(obj)->strmtype = strmtype;
      return obj;
    }

#endif

#ifdef FOREIGN

# UP, beschafft Foreign-Pointer-Verpackung
# allocate_fpointer(foreign)
# > foreign: vom Typ FOREIGN
# < ergebnis: LISP-Objekt, das foreign enthält
# kann GC auslösen
  global object allocate_fpointer (FOREIGN foreign);
  global object allocate_fpointer(foreign)
    var reg2 FOREIGN foreign;
    { var reg1 object result = allocate_xrecord(0,Rectype_Fpointer,fpointer_length,fpointer_xlength,orecord_type);
      TheFpointer(result)->fp_pointer = foreign;
      return result;
    }

#endif

#ifdef FOREIGN_HANDLE

# UP, beschafft Handle-Verpackung
# allocate_handle(handle)
# < ergebnis: LISP-Objekt, das handle enthält
  global object allocate_handle (Handle handle);
  global object allocate_handle(handle)
    var reg2 Handle handle;
    { var reg1 object result = allocate_bit_vector(sizeof(Handle)*8);
      TheHandle(result) = handle;
      return result;
    }

#endif

# UP, beschafft Bignum
# allocate_bignum(len,sign)
# > uintC len: Länge der Zahl (in Digits)
# > sintB sign: Flag für Vorzeichen (0 = +, -1 = -)
# < ergebnis: neues Bignum (LISP-Objekt)
# kann GC auslösen
  global object allocate_bignum (uintC len, sintB sign);
  global object allocate_bignum(len,sign)
    var reg3 uintC len;
    var reg5 sintB sign;
    { var reg4 uintL need = size_bignum(len); # benötigter Speicherplatz in Bytes
      allocate(bignum_type | (sign & bit(sign_bit_t)),TRUE,need,Bignum,ptr,
               { ptr->length = len; } # Keine weitere Initialisierung
              )
    }

# UP, beschafft Single-Float
# allocate_ffloat(value)
# > ffloat value: Zahlwert (Bit 31 = Vorzeichen)
# < ergebnis: neues Single-Float (LISP-Objekt)
# kann GC auslösen
  global object allocate_ffloat (ffloat value);
  #ifndef WIDE
  global object allocate_ffloat(value)
    var reg3 ffloat value;
    { allocate(ffloat_type | ((sint32)value<0 ? bit(sign_bit_t) : 0) # Vorzeichenbit aus value
               ,TRUE,size_ffloat(),Ffloat,ptr,
               { ptr->float_value = value; }
              )
    }
  #else
  global object allocate_ffloat(value)
    var reg3 ffloat value;
    { return
        type_data_object(ffloat_type | ((sint32)value<0 ? bit(sign_bit_t) : 0), # Vorzeichenbit aus value
                         value
                        );
    }
  #endif

# UP, beschafft Double-Float
#ifdef intQsize
# allocate_dfloat(value)
# > dfloat value: Zahlwert (Bit 63 = Vorzeichen)
# < ergebnis: neues Double-Float (LISP-Objekt)
# kann GC auslösen
  global object allocate_dfloat (dfloat value);
  global object allocate_dfloat(value)
    var reg3 dfloat value;
    { allocate(dfloat_type | ((sint64)value<0 ? bit(sign_bit_t) : 0) # Vorzeichenbit aus value
               ,TRUE,size_dfloat(),Dfloat,ptr,
               { ptr->float_value = value; }
              )
    }
#else
# allocate_dfloat(semhi,mlo)
# > semhi,mlo: Zahlwert (Bit 31 von semhi = Vorzeichen)
# < ergebnis: neues Double-Float (LISP-Objekt)
# kann GC auslösen
  global object allocate_dfloat (uint32 semhi, uint32 mlo);
  global object allocate_dfloat(semhi,mlo)
    var reg3 uint32 semhi;
    var reg5 uint32 mlo;
    { allocate(dfloat_type | ((sint32)semhi<0 ? bit(sign_bit_t) : 0) # Vorzeichenbit aus value
               ,TRUE,size_dfloat(),Dfloat,ptr,
               { ptr->float_value.semhi = semhi; ptr->float_value.mlo = mlo; }
              )
    }
#endif

# UP, beschafft Long-Float
# allocate_lfloat(len,expo,sign)
# > uintC len: Länge der Mantisse (in Digits)
# > uintL expo: Exponent
# > signean sign: Vorzeichen (0 = +, -1 = -)
# < ergebnis: neues Long-Float, noch ohne Mantisse
# Ein LISP-Objekt liegt erst dann vor, wenn die Mantisse eingetragen ist!
# kann GC auslösen
  global object allocate_lfloat (uintC len, uintL expo, signean sign);
  global object allocate_lfloat(len,expo,sign)
    var reg3 uintC len;
    var reg6 uintL expo;
    var reg5 signean sign;
    { var reg4 uintL need = size_lfloat(len); # benötigter Speicherplatz in Bytes
      allocate(lfloat_type | ((tint)sign & bit(sign_bit_t))
               ,TRUE,need,Lfloat,ptr,
               { ptr->len = len; ptr->expo = expo; } # Keine weitere Initialisierung
              )
    }

# UP, erzeugt Bruch
# make_ratio(num,den)
# > object num: Zähler (muß Integer /= 0 sein, relativ prim zu den)
# > object den: Nenner (muß Integer > 1 sein)
# < ergebnis: Bruch
# kann GC auslösen
  global object make_ratio (object num, object den);
  global object make_ratio(num,den)
    var reg4 object num;
    var reg5 object den;
    { pushSTACK(den); pushSTACK(num); # Argumente sichern
     {var reg3 tint type = # Vorzeichen von num übernehmen
        #ifdef fast_mtypecode
        ratio_type | (mtypecode(STACK_0) & bit(sign_bit_t))
        #else
        ratio_type | (typecode(num) & bit(sign_bit_t))
        #endif
        ;
      allocate(type,FALSE,sizeof(ratio_),Ratio,ptr,
               { ptr->rt_num = popSTACK(); # Zähler eintragen
                 ptr->rt_den = popSTACK(); # Nenner eintragen
               }
              )
    }}

# UP, erzeugt komplexe Zahl
# make_complex(real,imag)
# > real: Realteil (muß reelle Zahl sein)
# > imag: Imaginärteil (muß reelle Zahl /= Fixnum 0 sein)
# < ergebnis: komplexe Zahl
# kann GC auslösen
  global object make_complex (object real, object imag);
  global object make_complex(real,imag)
    var reg4 object real;
    var reg5 object imag;
    { pushSTACK(imag); pushSTACK(real);
      allocate(complex_type,FALSE,sizeof(complex_),Complex,ptr,
               { ptr->c_real = popSTACK(); # Realteil eintragen
                 ptr->c_imag = popSTACK(); # Imaginärteil eintragen
               }
              )
    }

# ------------------------------------------------------------------------------
#                   Zirkularitätenfeststellung

# UP: Liefert eine Tabelle aller Zirkularitäten innerhalb eines Objekts.
# (Eine Zirkularität ist ein in diesem Objekt enthaltenes Teil-Objekt,
# auf den es mehr als einen Zugriffsweg gibt.)
# get_circularities(obj,pr_array,pr_closure)
# > object obj: Objekt
# > boolean pr_array: Flag, ob Arrayelemente rekursiv als Teilobjekte gelten
# > boolean pr_closure: Flag, ob Closurekomponenten rekursiv als Teilobjekte gelten
# < ergebnis: T falls Stacküberlauf eintrat,
#             NIL falls keine Zirkularitäten vorhanden,
#             #(0 ...) ein (n+1)-elementiger Vektor, der die Zahl 0 und die n
#                      Zirkularitäten als Elemente enthält, n>0.
# kann GC auslösen
# Methode:
# Markiere rekursiv das Objekt, lege dabei die Zirkularitäten auf den STACK,
# demarkiere rekursiv das Objekt,
# alloziere Vektor für die Zirkularitäten (kann GC auslösen!),
# fülle die Zirkularitäten vom STACK in den Vektor um.
  global object get_circularities (object obj, boolean pr_array, boolean pr_closure);
  typedef struct { boolean pr_array;
                   boolean pr_closure;
                   uintL counter;
                   jmp_buf abbruch_context;
                   object* abbruch_STACK;
                 }
          get_circ_global;
  # Darauf muß man aus den zwei lokalen Routinen heraus zugreifen.
  local void get_circ_mark (object obj, get_circ_global* env);
  local void get_circ_unmark (object obj, get_circ_global* env);
  global object get_circularities(obj,pr_array,pr_closure)
    var object obj;
    var boolean pr_array;
    var boolean pr_closure;
    { var get_circ_global my_global; # Zähler und Kontext (incl. STACK-Wert)
                                     # für den Fall eines Abbruchs
      set_break_sem_1(); # Break unmöglich machen
      if (!setjmp(my_global.abbruch_context)) # Kontext abspeichern
        { my_global.pr_array = pr_array;
          my_global.pr_closure = pr_closure;
          my_global.counter = 0; # Zähler := 0
          my_global.abbruch_STACK = STACK;
          # Die Kontext-Konserve my_global ist jetzt fertig.
          get_circ_mark(obj,&my_global); # Objekt markieren, mehrfache
                                         # Strukturen auf dem STACK ablegen
                                         # in my_global.counter zählen
          get_circ_unmark(obj,&my_global); # Markierungen wieder löschen
          clr_break_sem_1(); # Break wieder möglich
          { var reg2 uintL n = my_global.counter; # Anzahl der Objekte auf dem STACK
            if (n==0)
              return(NIL); # keine da -> NIL zurück und fertig
              else
              { var reg3 object vector = allocate_vector(n+1); # Vektor mit n+1 Elementen
                # füllen:
                var reg1 object* ptr = &TheSvector(vector)->data[0];
                *ptr++ = Fixnum_0; # erstes Element = Fixnum 0
                # restliche Elemente eintragen (mindestens eins):
                dotimespL(n,n, { *ptr++ = popSTACK(); } );
                return(vector); # Vektor als Ergebnis
        } }   }
        else
        # nach Abbruch wegen SP- oder STACK-Überlauf
        { setSTACK(STACK = my_global.abbruch_STACK); # STACK wieder zurücksetzen
          # Der Kontext ist jetzt wiederhergestellt.
          get_circ_unmark(obj,&my_global); # Markierungen wieder löschen
          clr_break_sem_1(); # Break wieder möglich
          return(T); # T als Ergebnis
        }
    }
# UP: markiert das Objekt obj, legt auftretende Zirkularitäten auf den STACK
# und zählt sie in env->counter mit.
  local void get_circ_mark(obj,env)
    var reg3 object obj;
    var reg4 get_circ_global* env;
    { entry:
      switch (typecode(obj)) # je nach Typ
        { case cons_type:
            if (marked(TheCons(obj))) goto m_schon_da; # markiert?
            { var reg2 object obj_cdr = Cdr(obj); # Komponenten (ohne Markierungsbit)
              var reg1 object obj_car = Car(obj);
              mark(TheCons(obj)); # markieren
              if (SP_overflow()) # SP-Tiefe überprüfen
                longjmp(env->abbruch_context,TRUE); # Abbruch
              get_circ_mark(obj_car,env); # CAR markieren (rekursiv)
              obj = obj_cdr; goto entry; # CDR markieren (tail-end-rekursiv)
            }
          #ifdef IMMUTABLE_CONS
          case imm_cons_type:
            if (marked(TheCons(obj))) goto m_schon_da; # markiert?
            { var reg2 object obj_cdr = Cdr(obj); # Komponenten (ohne Markierungsbit)
              var reg1 object obj_car = Car(obj);
              mark(TheImmCons(obj)); # markieren
              if (SP_overflow()) # SP-Tiefe überprüfen
                longjmp(env->abbruch_context,TRUE); # Abbruch
              get_circ_mark(obj_car,env); # CAR markieren (rekursiv)
              obj = obj_cdr; goto entry; # CDR markieren (tail-end-rekursiv)
            }
          #endif
          case_symbol:
            if (marked(TheSymbol(obj))) # markiert?
              if (eq(Symbol_package(obj),NIL)) # uninterniertes Symbol?
                goto m_schon_da; # ja -> war schon da, merken
                else
                goto m_end; # nein -> war zwar schon da, aber unberücksichtigt lassen
            # bisher unmarkiertes Symbol
            mark(TheSymbol(obj)); # markieren
            goto m_end;
          case sbvector_type: case bvector_type: # Bit-Vector
          case sstring_type: case string_type: # String
          case_bignum: # Bignum
          #ifndef WIDE
          case_ffloat: # Single-Float
          #endif
          case_dfloat: # Double-Float
          case_lfloat: # Long-Float
          case_ratio: # Ratio
          case_complex: # Complex
            # Objekt ohne Komponenten, die ausgegeben werden:
            if (marked(ThePointer(obj))) goto m_schon_da; # markiert?
            # bisher unmarkiert
            mark(ThePointer(obj)); # markieren
            goto m_end;
          #ifdef IMMUTABLE_ARRAY
          case imm_sbvector_type: case imm_bvector_type: # immutabler Bit-Vector
          case imm_sstring_type: case imm_string_type: # immutabler String
            # immutables Objekt ohne Komponenten, die ausgegeben werden:
            if (marked(ThePointer(obj))) goto m_schon_da; # markiert?
            # bisher unmarkiert
            mark(TheImmArray(obj)); # markieren
            goto m_end;
          #endif
          case svector_type: # Simple-Vector
            if (marked(TheSvector(obj))) goto m_schon_da; # markiert?
            # bisher unmarkiert
            mark(TheSvector(obj)); # markieren
            m_svector:
            if (env->pr_array) # Komponenten weiterzuverfolgen?
              { var reg2 uintL count = TheSvector(obj)->length;
                if (!(count==0))
                  # markiere count>0 Komponenten
                  { var reg1 object* ptr = &TheSvector(obj)->data[0];
                    if (SP_overflow()) # SP-Tiefe überprüfen
                      longjmp(env->abbruch_context,TRUE); # Abbruch
                    dotimespL(count,count, { get_circ_mark(*ptr++,env); } ); # markiere Komponenten (rekursiv)
              }   }
            goto m_end;
          case array_type: case vector_type:
            # Nicht-simpler Array mit Komponenten, die Objekte sind:
            if (marked(TheArray(obj))) goto m_schon_da; # markiert?
            # bisher unmarkiert
            mark(TheArray(obj)); # markieren
            m_array:
            if (env->pr_array) # Komponenten weiterzuverfolgen?
              { obj=TheArray(obj)->data; goto entry; } # Datenvektor (tail-end-rekursiv) markieren
              else
              goto m_end;
          #ifdef IMMUTABLE_ARRAY
          case imm_svector_type: # immutabler Simple-Vector
            if (marked(TheSvector(obj))) goto m_schon_da; # markiert?
            # bisher unmarkiert
            mark(TheImmSvector(obj)); # markieren
            goto m_svector;
          case imm_array_type: case imm_vector_type:
            # immutabler nicht-simpler Array mit Komponenten, die Objekte sind:
            if (marked(TheArray(obj))) goto m_schon_da; # markiert?
            # bisher unmarkiert
            mark(TheImmArray(obj)); # markieren
            goto m_array;
          #endif
          case_closure: # Closure
            if (marked(TheClosure(obj))) goto m_schon_da; # markiert?
            # bisher unmarkiert
            mark(TheClosure(obj)); # markieren
            if (env->pr_closure) # Komponenten weiterzuverfolgen?
              goto m_record_components; # alle Komponenten werden ausgeben (s. unten)
              else # nur den Namen (tail-end-rekursiv) markieren
              { obj=TheClosure(obj)->clos_name; goto entry; }
          case_structure: # Structure
            if (marked(TheStructure(obj))) goto m_schon_da; # markiert?
            # bisher unmarkiert
            mark(TheStructure(obj)); # markieren
            goto m_record_components;
          case_stream: # Stream
            if (marked(TheStream(obj))) goto m_schon_da; # markiert?
            # bisher unmarkiert
            mark(TheStream(obj));
            switch (TheStream(obj)->strmtype)
              { case strmtype_broad:
                case strmtype_concat:
                  goto m_record_components;
                default:
                  goto m_end;
              }
          case_instance: # CLOS-Instanz
            if (marked(TheInstance(obj))) goto m_schon_da; # markiert?
            # bisher unmarkiert
            mark(TheInstance(obj)); # markieren
            goto m_record_components;
          case_orecord: # sonstigen Record markieren:
            if (marked(TheRecord(obj))) goto m_schon_da; # markiert?
            # bisher unmarkiert
            mark(TheRecord(obj)); # markieren
            switch (TheRecord(obj)->rectype)
              { case Rectype_Hashtable:
                  # Hash-Table: je nach Array-Ausgabe-Flag
                  if (env->pr_array) break; else goto m_end;
                case Rectype_Package:
                  # Packages werden nicht komponentenweise ausgegeben
                  goto m_end;
                case Rectype_Readtable:
                  # Readtables werden nicht komponentenweise ausgegeben
                  goto m_end;
                #ifndef case_structure
                case Rectype_Structure: goto case_structure;
                #endif
                #ifndef case_stream
                case Rectype_Stream: goto case_stream;
                #endif
                default: break;
              }
            # Pathnames, Random-States, Bytes, Fsubrs, Loadtimeevals,
            # Symbol-Macros und evtl. Hash-Tables werden evtl.
            # komponentenweise ausgegeben.
            m_record_components: # Komponenten eines Records markieren:
              { var reg2 uintC count = Record_length(obj);
                if (!(count==0))
                  # markiere count>0 Komponenten
                  { var reg1 object* ptr = &TheRecord(obj)->recdata[0];
                    if (SP_overflow()) # SP-Tiefe überprüfen
                      longjmp(env->abbruch_context,TRUE); # Abbruch
                    dotimespC(count,count, { get_circ_mark(*ptr++,env); } ); # markiere Komponenten (rekursiv)
              }   }
            goto m_end;
          m_schon_da:
            # Objekt wurde markiert, war aber schon markiert.
            # Es ist eine Zirkularität.
            if (STACK_overflow()) # STACK-Tiefe überprüfen
              longjmp(env->abbruch_context,TRUE); # Abbruch
            # Objekt mit gelöschtem garcol_bit im STACK ablegen:
            pushSTACK(without_mark_bit(obj));
            env->counter++; # und mitzählen
            goto m_end;
          case_machine: # Maschinenpointer
          case_char: # Character
          case_subr: # Subr
          case_system: # Frame-pointer, Read-label, system
          case_fixnum: # Fixnum
          case_sfloat: # Short-Float
          #ifdef WIDE
          case_ffloat: # Single-Float
          #endif
          default:
            # Objekt kann nicht markiert werden -> fertig
            goto m_end;
          m_end: ; # fertig
    }   }
# UP: Demarkiert Objekt obj.
  local void get_circ_unmark(obj,env)
    var reg2 object obj;
    var reg3 get_circ_global* env;
    { entry:
      switch (typecode(obj) & ~bit(garcol_bit_t)) # je nach Typinfo ohne garcol_bit
        { case cons_type:
            if (!marked(TheCons(obj))) goto u_end; # schon demarkiert?
            unmark(TheCons(obj)); # demarkieren
            get_circ_unmark(Car(obj),env); # CAR demarkieren (rekursiv)
            obj=Cdr(obj); goto entry; # CDR demarkieren (tail-end-rekursiv)
          #ifdef IMMUTABLE_CONS
          case imm_cons_type:
            if (!marked(TheCons(obj))) goto u_end; # schon demarkiert?
            unmark(TheImmCons(obj)); # demarkieren
            get_circ_unmark(Car(obj),env); # CAR demarkieren (rekursiv)
            obj=Cdr(obj); goto entry; # CDR demarkieren (tail-end-rekursiv)
          #endif
          case_symbol:
            # Symbol demarkieren. Wertzelle etc. für PRINT unwesentlich.
          case sbvector_type: case bvector_type: # Bit-Vector
          case sstring_type: case string_type: # String
          case_bignum: # Bignum
          #ifndef WIDE
          case_ffloat: # Single-Float
          #endif
          case_dfloat: # Double-Float
          case_lfloat: # Long-Float
          case_ratio: # Ratio
          case_complex: # Complex
            # Objekt demarkieren, das keine markierten Komponenten hat:
            unmark(ThePointer(obj)); # demarkieren
            goto u_end;
          #ifdef IMMUTABLE_ARRAY
          case imm_sbvector_type: case imm_bvector_type: # immutabler Bit-Vector
          case imm_sstring_type: case imm_string_type: # immutabler String
            # immutables Objekt demarkieren, das keine markierten Komponenten hat:
            unmark(TheImmArray(obj)); # demarkieren
            goto u_end;
          #endif
          case svector_type:
            # Simple-Vector demarkieren, seine Komponenten ebenfalls:
            if (!marked(TheSvector(obj))) goto u_end; # schon demarkiert?
            unmark(TheSvector(obj)); # demarkieren
            u_svector:
            if (env->pr_array) # wurden die Komponenten weiterverfolgt?
              { var reg2 uintL count = TheSvector(obj)->length;
                if (!(count==0))
                  # demarkiere count>0 Komponenten
                  { var reg1 object* ptr = &TheSvector(obj)->data[0];
                    dotimespL(count,count, { get_circ_unmark(*ptr++,env); } ); # demarkiere Komponenten (rekursiv)
              }   }
            goto u_end;
          case array_type: case vector_type:
            # Nicht-simpler Array mit Komponenten, die Objekte sind:
            if (!marked(TheArray(obj))) goto u_end; # schon demarkiert?
            unmark(TheArray(obj)); # demarkieren
            u_array:
            if (env->pr_array) # wurden die Komponenten weiterverfolgt?
              { obj=TheArray(obj)->data; goto entry; } # Datenvektor (tail-end-rekursiv) demarkieren
              else
              goto u_end;
          #ifdef IMMUTABLE_ARRAY
          case imm_svector_type:
            # immutablen Simple-Vector demarkieren, seine Komponenten ebenfalls:
            if (!marked(TheSvector(obj))) goto u_end; # schon demarkiert?
            unmark(TheImmSvector(obj)); # demarkieren
            goto u_svector;
          case imm_array_type: case imm_vector_type:
            # immutabler nicht-simpler Array mit Komponenten, die Objekte sind:
            if (!marked(TheArray(obj))) goto u_end; # schon demarkiert?
            unmark(TheImmArray(obj)); # demarkieren
            goto u_array;
          #endif
          case_closure: # Closure demarkieren
            if (!marked(TheClosure(obj))) goto u_end; # schon demarkiert?
            unmark(TheClosure(obj)); # demarkieren
            if (env->pr_closure) # wurden Komponenten weiterverfolgt?
              goto u_record_components; # alle Komponenten werden ausgeben (s. unten)
              else # nur den Namen (tail-end-rekursiv) demarkieren
              { obj=TheClosure(obj)->clos_name; goto entry; }
          case_structure: # Structure demarkieren:
            if (!marked(TheStructure(obj))) goto u_end; # schon demarkiert?
            unmark(TheStructure(obj)); # demarkieren
            goto u_record_components;
          case_stream: # Stream demarkieren:
            if (!marked(TheStream(obj))) goto u_end; # schon demarkiert?
            unmark(TheStream(obj)); # demarkieren
            switch (TheStream(obj)->strmtype)
              { case strmtype_broad:
                case strmtype_concat:
                  goto u_record_components;
                default:
                  goto u_end;
              }
          case_instance: # CLOS-Instanz demarkieren:
            if (!marked(TheInstance(obj))) goto u_end; # schon demarkiert?
            unmark(TheInstance(obj)); # demarkieren
            goto u_record_components;
          case_orecord: # sonstigen Record demarkieren:
            if (!marked(TheRecord(obj))) goto u_end; # schon demarkiert?
            unmark(TheRecord(obj)); # demarkieren
            switch (TheRecord(obj)->rectype)
              { case Rectype_Hashtable:
                  # Hash-Table: je nach Array-Ausgabe-Flag
                  if (env->pr_array) break; else goto u_end;
                case Rectype_Package:
                  # Packages werden nicht komponentenweise ausgegeben
                  goto u_end;
                case Rectype_Readtable:
                  # Readtables werden nicht komponentenweise ausgegeben
                  goto u_end;
                #ifndef case_structure
                case Rectype_Structure: goto case_structure;
                #endif
                #ifndef case_stream
                case Rectype_Stream: goto case_stream;
                #endif
                default: break;
              }
            # Pathnames, Random-States, Bytes, Fsubrs, Loadtimeevals,
            # Symbol-Macros und evtl. Hash-Tables werden evtl.
            # komponentenweise ausgegeben.
            u_record_components: # Komponenten eines Records demarkieren:
              { var reg2 uintC count = Record_length(obj);
                if (!(count==0))
                  # demarkiere count>0 Komponenten
                  { var reg1 object* ptr = &TheRecord(obj)->recdata[0];
                    dotimespC(count,count, { get_circ_unmark(*ptr++,env); } ); # demarkiere Komponenten (rekursiv)
              }   }
            goto u_end;
          case_machine: # Maschinenpointer
          case_char: # Character
          case_subr: # Subr
          case_system: # Frame-pointer, Read-label, system
          case_fixnum: # Fixnum
          case_sfloat: # Short-Float
          #ifdef WIDE
          case_ffloat: # Single-Float
          #endif
          default:
            # Objekt demarkieren, das gar keine Markierung haben kann:
            goto u_end;
          u_end: ; # fertig
    }   }

# UP: Entflicht #n# - Referenzen im Objekt *ptr mit Hilfe der Aliste alist.
# > *ptr : Objekt
# > alist : Aliste (Read-Label --> zu substituierendes Objekt)
# < *ptr : Objekt mit entflochtenen Referenzen
# < ergebnis : fehlerhafte Referenz oder nullobj falls alles OK
  global object subst_circ (object* ptr, object alist);
#
# Zirkularitätenberücksichtigung ist nötig, damit die Substitution sich von
# zyklischen Strukturen, wie sie sich bei #. (insbesondere #.(FIND-CLASS 'FOO))
# ergeben können, nicht durcheinanderbringen läßt.

#if 0 # ohne Zirkularitätenberücksichtigung

  local void subst (object* ptr);
  local object subst_circ_alist;
  local jmp_buf subst_circ_jmpbuf;
  local object subst_circ_bad;
  global object subst_circ(ptr,alist)
    var reg1 object* ptr;
    var reg2 object alist;
    { subst_circ_alist = alist;
      if (!setjmp(subst_circ_jmpbuf))
        { subst(ptr); return nullobj; }
        else
        # Abbruch wegen fehlerhafter Referenz
        { return subst_circ_bad; }
    }
  local void subst(ptr)
    var reg2 object ptr;
    { check_SP();
      enter_subst:
     {var reg1 object obj = *ptr;
      # Fallunterscheidung nach Typ:
      # Objekte ohne Teilobjekte (Maschinenpointer, Bit-Vektoren,
      # Strings, Characters, SUBRs, Integers, Floats) enthalten
      # keine Referenzen. Ebenso Symbole und rationale Zahlen (bei ihnen
      # können die Teilobjekte nicht in #n= - Syntax eingegeben worden
      # sein) und komplexe Zahlen (für ihre Komponenten sind nur
      # Integers, Floats, rationale Zahlen zugelassen, also Objekte,
      # die ihrerseits keine Referenzen enthalten können).
      switch (mtypecode(*ptr))
        { case svector_type: # Simple-Vector
            # alle Elemente durchlaufen:
            { var reg4 uintL len = TheSvector(obj)->length;
              if (!(len==0))
                { var reg3 object* objptr = &TheSvector(obj)->data[0];
                  dotimespL(len,len, { subst(&(*objptr++)); } );
            }   }
            break;
          case array_type:
          case vector_type:
            # nicht-simpler Array, kein String oder Bit-Vektor
            # Datenvektor durchlaufen: endrekursiv subst(Datenvektor)
            ptr = &TheArray(obj)->data; goto enter_subst;
          #ifdef IMMUTABLE_ARRAY
          case imm_svector_type: # immutabler Simple-Vector
            # alle Elemente durchlaufen:
            { var reg4 uintL len = TheSvector(obj)->length;
              if (!(len==0))
                { var reg3 object* objptr = &TheImmSvector(obj)->data[0];
                  dotimespL(len,len, { subst(&(*objptr++)); } );
            }   }
            break;
          case imm_array_type:
          case imm_vector_type:
            # nicht-simpler Array, kein String oder Bit-Vektor
            # Datenvektor durchlaufen: endrekursiv subst(Datenvektor)
            ptr = &TheImmArray(obj)->data; goto enter_subst;
          #endif
          case_record: # Record
            # alle Elemente durchlaufen:
            { var reg4 uintC len = Record_length(obj);
              if (!(len==0))
                { var reg3 object* objptr = &TheRecord(obj)->recdata[0];
                  dotimespC(len,len, { subst(&(*objptr++)); } );
            }   }
            break;
          case_system: # Frame-Pointer oder Read-Label oder System
            if (as_oint(obj) & wbit(0+oint_addr_shift))
              # Read-Label oder System
              if (as_oint(obj) & wbit(oint_data_len-1+oint_addr_shift))
                {} # System
                else
                # Read-Label
                { # Read-Label obj in der Aliste suchen:
                  var reg4 object alist = subst_circ_alist;
                  while (consp(alist))
                    { var reg3 object acons = Car(alist);
                      if (eq(Car(acons),obj))
                        # gefunden
                        { # *ptr = obj = (car acons) durch (cdr acons) ersetzen:
                          *ptr = Cdr(acons);
                          return;
                        }
                      alist = Cdr(alist);
                    }
                  # nicht gefunden -> Abbruch
                  subst_circ_bad = obj;
                  longjmp(subst_circ_jmpbuf,TRUE);
                }
              else
              # Frame-Pointer
              {}
            break;
          case cons_type: # Cons
            # rekursiv: subst(&Car(obj))
            subst(&Car(obj));
            # endrekursiv: subst(&Cdr(obj))
            ptr = &Cdr(obj); goto enter_subst;
          #ifdef IMMUTABLE_CONS
          case imm_cons_type: # immutables Cons
            # rekursiv: subst(&Car(obj))
            subst(&TheImmCons(obj)->car);
            # endrekursiv: subst(&Cdr(obj))
            ptr = &TheImmCons(obj)->cdr; goto enter_subst;
          #endif
          case_machine: # Maschinenpointer
          case_bvector: # Bit-Vektor
          case_string: # String
          case_char: # Character
          case_subr: # SUBR
          case_number: # Zahl
          case_symbol: # Symbol
            # Objekt enthält keine Referenzen -> nichts zu tun
            break;
          default: NOTREACHED
    }}  }

#else # mit Zirkularitätenberücksichtigung

# Methode:
# Markiere rekursiv die Objekte, in denen die Substitution gerade durchgeführt
# wird/wurde. Danach demarkiere rekursiv das Objekt.

  local void subst_circ_mark (object* ptr);
  local void subst_circ_unmark (object* ptr);
  local object subst_circ_alist;
  local jmp_buf subst_circ_jmpbuf;
  local object subst_circ_bad;
  global object subst_circ(ptr,alist)
    var object* ptr;
    var reg1 object alist;
    { subst_circ_alist = alist;
      set_break_sem_1(); # Break unmöglich machen
      if (!setjmp(subst_circ_jmpbuf))
        { subst_circ_mark(ptr); # markieren und substituieren
          subst_circ_unmark(ptr); # Markierungen wieder löschen
          clr_break_sem_1(); # Break wieder möglich
          return nullobj;
        }
        else
        # Abbruch aus subst_circ_mark() heraus
        { subst_circ_unmark(ptr); # erst alles demarkieren
          clr_break_sem_1(); # Break wieder möglich
          if (!eq(subst_circ_bad,nullobj)) # wegen fehlerhafter Referenz?
            { return subst_circ_bad; }
            else # sonst war's SP-Überlauf
            { SP_ueber(); }
    }   }
  local void subst_circ_mark(ptr)
    var reg2 object* ptr;
    { if (SP_overflow()) # SP-Tiefe überprüfen
        { subst_circ_bad = nullobj; longjmp(subst_circ_jmpbuf,TRUE); } # Abbruch
      enter_subst:
     {var reg1 object obj = without_mark_bit(*ptr);
      # Fallunterscheidung nach Typ:
      # Objekte ohne Teilobjekte (Maschinenpointer, Bit-Vektoren,
      # Strings, Characters, SUBRs, Integers, Floats) enthalten
      # keine Referenzen. Ebenso Symbole und rationale Zahlen (bei ihnen
      # können die Teilobjekte nicht in #n= - Syntax eingegeben worden
      # sein) und komplexe Zahlen (für ihre Komponenten sind nur
      # Integers, Floats, rationale Zahlen zugelassen, also Objekte,
      # die ihrerseits keine Referenzen enthalten können).
      switch (typecode(obj))
        { case svector_type: # Simple-Vector
            if (marked(TheSvector(obj))) return; # Objekt schon markiert?
            mark(TheSvector(obj)); # markieren
            # alle Elemente durchlaufen:
            { var reg4 uintL len = TheSvector(obj)->length;
              if (!(len==0))
                { var reg3 object* objptr = &TheSvector(obj)->data[0];
                  dotimespL(len,len, { subst_circ_mark(&(*objptr++)); } );
            }   }
            return;
          case array_type:
          case vector_type:
            # nicht-simpler Array, kein String oder Bit-Vektor
            if (marked(TheArray(obj))) return; # Objekt schon markiert?
            mark(TheArray(obj)); # markieren
            # Datenvektor durchlaufen: endrekursiv subst_circ_mark(Datenvektor)
            ptr = &TheArray(obj)->data; goto enter_subst;
          #ifdef IMMUTABLE_ARRAY
          case imm_svector_type: # immutabler Simple-Vector
            if (marked(TheSvector(obj))) return; # Objekt schon markiert?
            mark(TheImmSvector(obj)); # markieren
            # alle Elemente durchlaufen:
            { var reg4 uintL len = TheSvector(obj)->length;
              if (!(len==0))
                { var reg3 object* objptr = &TheImmSvector(obj)->data[0];
                  dotimespL(len,len, { subst_circ_mark(&(*objptr++)); } );
            }   }
            return;
          case imm_array_type:
          case imm_vector_type:
            # nicht-simpler Array, kein String oder Bit-Vektor
            if (marked(TheArray(obj))) return; # Objekt schon markiert?
            mark(TheImmArray(obj)); # markieren
            # Datenvektor durchlaufen: endrekursiv subst_circ_mark(Datenvektor)
            ptr = &TheImmArray(obj)->data; goto enter_subst;
          #endif
          case_record: # Record
            if (marked(TheRecord(obj))) return; # Objekt schon markiert?
            mark(TheRecord(obj)); # markieren
            # Beim Ersetzen von Read-Labels in Hash-Tables verliert deren
            # Aufbau seinen Gültigkeit (denn die Hashfunktion der in ihr
            # gespeicherten Objekte verändert sich).
            if (TheRecord(obj)->rectype == Rectype_Hashtable) # eine Hash-Table ?
              { mark_ht_invalid(TheHashtable(obj)); } # ja -> für Reorganisation vormerken
            # alle Elemente durchlaufen:
            { var reg4 uintC len = Record_length(obj);
              if (!(len==0))
                { var reg3 object* objptr = &TheRecord(obj)->recdata[0];
                  dotimespC(len,len, { subst_circ_mark(&(*objptr++)); } );
            }   }
            return;
          case_system: # Frame-Pointer oder Read-Label oder System
            if (as_oint(obj) & wbit(0+oint_addr_shift))
              # Read-Label oder System
              if (as_oint(obj) & wbit(oint_data_len-1+oint_addr_shift))
                {} # System
                else
                # Read-Label
                { # Read-Label obj in der Aliste suchen:
                  var reg4 object alist = subst_circ_alist;
                  while (consp(alist))
                    { var reg3 object acons = Car(alist);
                      if (eq(Car(acons),obj))
                        # gefunden
                        { # *ptr = obj = (car acons) durch (cdr acons) ersetzen,
                          # dabei aber das Markierungsbit unverändert lassen:
                          *ptr = (marked(ptr) ? with_mark_bit(Cdr(acons)) : Cdr(acons));
                          return;
                        }
                      alist = Cdr(alist);
                    }
                  # nicht gefunden -> Abbruch
                  subst_circ_bad = obj;
                  longjmp(subst_circ_jmpbuf,TRUE);
                }
              else
              # Frame-Pointer
              {}
            return;
          case cons_type: # Cons
            if (marked(TheCons(obj))) return; # Objekt schon markiert?
            mark(TheCons(obj)); # markieren
            # rekursiv: subst_circ_mark(&Car(obj))
            subst_circ_mark(&Car(obj));
            # endrekursiv: subst_circ_mark(&Cdr(obj))
            ptr = &Cdr(obj); goto enter_subst;
          #ifdef IMMUTABLE_CONS
          case imm_cons_type: # immutables Cons
            if (marked(TheCons(obj))) return; # Objekt schon markiert?
            mark(TheImmCons(obj)); # markieren
            # rekursiv: subst_circ_mark(&Car(obj))
            subst_circ_mark(&TheImmCons(obj)->car);
            # endrekursiv: subst_circ_mark(&Cdr(obj))
            ptr = &TheImmCons(obj)->cdr; goto enter_subst;
          #endif
          case_machine: # Maschinenpointer
          case_bvector: # Bit-Vektor
          case_string: # String
          case_char: # Character
          case_subr: # SUBR
          case_number: # Zahl
          case_symbol: # Symbol
            # Objekt enthält keine Referenzen -> nichts zu tun
            return;
          default: NOTREACHED
    }}  }
  local void subst_circ_unmark(ptr)
    var reg2 object* ptr;
    { enter_subst:
     {var reg1 object obj = *ptr;
      # Fallunterscheidung nach Typ, wie oben:
      switch (typecode(obj))
        { case svector_type: # Simple-Vector
            if (!marked(TheSvector(obj))) return; # schon demarkiert?
            unmark(TheSvector(obj)); # demarkieren
            # alle Elemente durchlaufen:
            { var reg4 uintL len = TheSvector(obj)->length;
              if (!(len==0))
                { var reg3 object* objptr = &TheSvector(obj)->data[0];
                  dotimespL(len,len, { subst_circ_unmark(&(*objptr++)); } );
            }   }
            return;
          case array_type:
          case vector_type:
            # nicht-simpler Array, kein String oder Bit-Vektor
            if (!marked(TheArray(obj))) return; # schon demarkiert?
            unmark(TheArray(obj)); # demarkieren
            # Datenvektor durchlaufen: endrekursiv subst_circ_unmark(Datenvektor)
            ptr = &TheArray(obj)->data; goto enter_subst;
          #ifdef IMMUTABLE_ARRAY
          case imm_svector_type: # immutabler Simple-Vector
            if (!marked(TheSvector(obj))) return; # schon demarkiert?
            unmark(TheImmSvector(obj)); # demarkieren
            # alle Elemente durchlaufen:
            { var reg4 uintL len = TheSvector(obj)->length;
              if (!(len==0))
                { var reg3 object* objptr = &TheImmSvector(obj)->data[0];
                  dotimespL(len,len, { subst_circ_unmark(&(*objptr++)); } );
            }   }
            return;
          case imm_array_type:
          case imm_vector_type:
            # nicht-simpler Array, kein String oder Bit-Vektor
            if (!marked(TheArray(obj))) return; # schon demarkiert?
            unmark(TheImmArray(obj)); # demarkieren
            # Datenvektor durchlaufen: endrekursiv subst_circ_unmark(Datenvektor)
            ptr = &TheImmArray(obj)->data; goto enter_subst;
          #endif
          case_record: # Record
            if (!marked(TheRecord(obj))) return; # schon demarkiert?
            unmark(TheRecord(obj)); # demarkieren
            # alle Elemente durchlaufen:
            { var reg4 uintC len = Record_length(obj);
              if (!(len==0))
                { var reg3 object* objptr = &TheRecord(obj)->recdata[0];
                  dotimespC(len,len, { subst_circ_unmark(&(*objptr++)); } );
            }   }
            return;
          case cons_type: # Cons
            if (!marked(TheCons(obj))) return; # schon demarkiert?
            unmark(TheCons(obj)); # demarkieren
            # rekursiv: subst_circ_unmark(&Car(obj))
            subst_circ_unmark(&Car(obj));
            # endrekursiv: subst_circ_unmark(&Cdr(obj))
            ptr = &Cdr(obj); goto enter_subst;
          #ifdef IMMUTABLE_CONS
          case imm_cons_type: # immutables Cons
            if (!marked(TheCons(obj))) return; # schon demarkiert?
            unmark(TheImmCons(obj)); # demarkieren
            # rekursiv: subst_circ_unmark(&Car(obj))
            subst_circ_unmark(&TheImmCons(obj)->car);
            # endrekursiv: subst_circ_unmark(&Cdr(obj))
            ptr = &TheImmCons(obj)->cdr; goto enter_subst;
          #endif
          case_system: # Frame-Pointer oder Read-Label oder System
          case_machine: # Maschinenpointer
          case_bvector: # Bit-Vektor
          case_string: # String
          case_char: # Character
          case_subr: # SUBR
          case_number: # Zahl
          case_symbol: # Symbol
            # Objekt enthält keine Referenzen -> nichts zu tun
            return;
          default: NOTREACHED
    }}  }

#endif

# ------------------------------------------------------------------------------
#                  Elementare Stringfunktionen

# Ausgabe eines konstanten ASCIZ-Strings, direkt übers Betriebssystem:
# asciz_out(string);
# > char* asciz: ASCIZ-String
  global void asciz_out (const char * asciz);
  global void asciz_out(asciz)
    var reg3 const char * asciz;
    {
      #ifdef AMIGAOS
        begin_system_call();
        Write(Output_handle,asciz,asciz_length(asciz));
        end_system_call();
      #endif
      #if (defined(UNIX) && !defined(NEXTAPP)) || (defined(MSDOS) && !defined(WINDOWS)) || defined(RISCOS) || defined(WIN32_UNIX)
        begin_system_call();
        full_write(stdout_handle,asciz,asciz_length(asciz));
        end_system_call();
      #endif
      #ifdef NEXTAPP
        begin_system_call();
        nxterminal_write_string(asciz);
        end_system_call();
      #endif
      #if defined(WINDOWS)
        # Low-Level Debug Output kann nicht über Windows gehen, sondern muß
        # ein File zum Ziel haben. Da unter DOS offene Files die Länge 0
        # haben, müssen wir das File sofort wieder schließen.
        #ifdef EMUNIX
          # open(), close() usw. ruft bei RSX direkt DOS auf.
          static int fd = -1;
          begin_system_call();
          if (fd<0)
            { fd = open("c:/lisp.out",O_RDWR|O_CREAT|O_TRUNC|O_TEXT,my_open_mask); }
          if (fd>=0)
            { write(fd,asciz,asciz_length(asciz));
              close(dup(fd)); # effectively fsync(fd)
            }
          end_system_call();
        #else
          var int fd;
          static char buf[] = "c:/temp/lisp0000.out";
          static uintL count = 0;
          buf[12] = ((count >> 9) & 7) + '0';
          buf[13] = ((count >> 6) & 7) + '0';
          buf[14] = ((count >> 3) & 7) + '0';
          buf[15] = ((count >> 0) & 7) + '0';
          count++;
          begin_system_call();
          #ifndef WATCOM
            fd = open(buf,O_RDWR|O_CREAT|O_TRUNC|O_TEXT,my_open_mask);
            if (fd>=0) { write(fd,asciz,asciz_length(asciz)); close(fd); }
          #else # WATCOM
            # Das normale open(), close() schließt nicht richtig, wenn das
            # Programm anschließend abstürzt.
            { var unsigned int written;
              fd = 0; _dos_creatnew(buf,0,&fd);
              _dos_write(fd,asciz,asciz_length(asciz),&written);
              _dos_close(fd);
            }
          #endif
          end_system_call();
        #endif
      #endif
    }

  global void err_asciz_out (const char * asciz);
  global void err_asciz_out(asciz)
    var reg3 const char * asciz;
    {
      asciz_out(CRLFstring "*** - ");
      asciz_out(asciz);
    }

# UP: Liefert einen LISP-String mit vorgegebenem Inhalt.
# make_string(charptr,len)
# > uintB* charptr: Adresse einer Zeichenfolge
# > uintL len: Länge der Zeichenfolge
# < ergebnis: Simple-String mit den len Zeichen ab charptr als Inhalt
# kann GC auslösen
  global object make_string (const uintB* charptr, uintL len);
  global object make_string(charptr,len)
    var reg2 const uintB* charptr;
    var reg3 uintL len;
    { var reg4 object obj = allocate_string(len); # String allozieren
      var reg1 uintB* ptr = &TheSstring(obj)->data[0];
      # Zeichenfolge von charptr nach ptr kopieren:
      dotimesL(len,len, { *ptr++ = *charptr++; } );
      return(obj);
    }

#ifndef asciz_length
# UP: Liefert die Länge eines ASCIZ-Strings.
# asciz_length(asciz)
# > char* asciz: ASCIZ-String
#       (Adresse einer durch ein Nullbyte abgeschlossenen Zeichenfolge)
# < ergebnis: Länge der Zeichenfolge (ohne Nullbyte)
  global uintL asciz_length (const char * asciz);
  global uintL asciz_length(asciz)
    var reg3 const char* asciz;
    { var reg1 const char* ptr = asciz;
      var reg2 uintL len = 0;
      # Nullbyte suchen und dabei Länge hochzählen:
      while (!( *ptr++ == 0 )) { len++; }
      return len;
    }
#endif

#ifndef asciz_equal
# UP: Vergleicht zwei ASCIZ-Strings.
# asciz_equal(asciz1,asciz2)
# > char* asciz1: erster ASCIZ-String
# > char* asciz2: zweiter ASCIZ-String
# < ergebnis: TRUE falls die Zeichenfolgen gleich sind
  global boolean asciz_equal (const char * asciz1, const char * asciz2);
  global boolean asciz_equal(asciz1,asciz2)
    var reg2 const char* asciz1;
    var reg3 const char* asciz2;
    { # Bytes vergleichen, solange bis das erste Nullbyte kommt:
      loop
        { var reg1 char ch1 = *asciz1++;
          if (!(ch1 == *asciz2++)) goto no;
          if (ch1 == '\0') goto yes;
        }
      yes: return TRUE;
      no: return FALSE;
    }
#endif

# UP: Wandelt einen ASCIZ-String in einen LISP-String um.
# asciz_to_string(asciz)
# > char* asciz: ASCIZ-String
#       (Adresse einer durch ein Nullbyte abgeschlossenen Zeichenfolge)
# < ergebnis: String mit der Zeichenfolge (ohne Nullbyte) als Inhalt
# kann GC auslösen
  global object asciz_to_string (const char * asciz);
  global object asciz_to_string(asciz)
    var reg1 const char* asciz;
    { return make_string((const uintB*)asciz,asciz_length(asciz)); }

# UP: Wandelt einen String in einen ASCIZ-String um.
# string_to_asciz(obj)
# > object obj: String
# < ergebnis: Simple-String mit denselben Zeichen und einem Nullbyte mehr am Schluß
# kann GC auslösen
  global object string_to_asciz (object obj);
  global object string_to_asciz (obj)
    var reg5 object obj;
    { # (vgl. copy_string in CHARSTRG)
      pushSTACK(obj); # String retten
     {var reg4 object new = allocate_string(vector_length(obj)+1);
          # neuer Simple-String mit einem Byte mehr Länge
      obj = popSTACK(); # String zurück
      { var uintL len;
        var reg1 uintB* sourceptr = unpack_string(obj,&len);
        # Source-String: Länge in len, Bytes ab sourceptr
        var reg2 uintB* destptr = &TheSstring(new)->data[0];
        # Destination-String: Bytes ab destptr
        { # Kopierschleife:
          var reg3 uintL count;
          dotimesL(count,len, { *destptr++ = *sourceptr++; } );
          *destptr++ = 0; # Nullbyte anfügen
      } }
      return(new);
    }}

# ------------------------------------------------------------------------------
#                  Andere globale Hilfsfunktionen

#if (int_bitsize < long_bitsize)
# Übergabewert an setjmpl() von longjmpl():
  global long jmpl_value;
#endif

#ifndef SP
# Bestimmung (einer Approximation) des SP-Stackpointers.
  global void* SP (void);
  global void* SP()
    { var long dummy;
      return &dummy;
    }
#endif

# Fehlermeldung wegen Erreichen einer unerreichbaren Programmstelle.
# Kehrt nicht zurück.
# fehler_notreached(file,line);
# > file: Filename (mit Anführungszeichen) als konstanter ASCIZ-String
# > line: Zeilennummer
  nonreturning_function(global, fehler_notreached, (const char * file, uintL line));
  global void fehler_notreached(file,line)
    var reg2 const char * file;
    var reg1 uintL line;
    { pushSTACK(fixnum(line));
      pushSTACK(asciz_to_string(file));
      { 
        //: DEUTSCH "Interner Fehler: Anweisung in File ~, Zeile ~ wurde ausgeführt!!"
        //: ENGLISH "Internal error: statement in file ~, line ~ has been reached!!"
        //: FRANCAIS "Erreur interne : Dans le fichier ~, la ligne ~ fut exécutée!"        
        var const char *line1 = GETTEXT("internal error in file ~, line ~");
        //: DEUTSCH "Bitte schicken Sie eine Mitteilung an die Programm-Autoren, "
        //: ENGLISH "Please send the authors of the program, "
        //: FRANCAIS "Veuillez signaler aux auteurs du programme comment " 
        var const char *line2 = GETTEXT("Please send the authors of the program");
        //: DEUTSCH "mit der Beschreibung, wie Sie diesen Fehler erzeugt haben!"
        //: ENGLISH "a description how you produced this error!"
        //: FRANCAIS "vous avez pu faire apparaître cette erreur, s.v.p.!"
        var const char *line3=GETTEXT("a description how you produced this error!");
        fehler5(serious_condition,line1,NLstring,line2,NLstring,line3);
      }
    }

#ifndef LANGUAGE_STATIC

  # Sprache, in der mit dem Benutzer kommuniziert wird:
    global uintC language;

  # Initialisiert die Sprache, gegeben die Sprachbezeichnung.
    local boolean init_language_from (const char* langname);
    local boolean init_language_from(langname)
      var reg1 const char* langname;
      { if (asciz_equal(langname,"ENGLISH") || asciz_equal(langname,"english"))
          { language = language_english; return TRUE; }
        if (asciz_equal(langname,"DEUTSCH") || asciz_equal(langname,"deutsch")
            || asciz_equal(langname,"GERMAN") || asciz_equal(langname,"german")
           )
          { language = language_deutsch; return TRUE; }
        if (asciz_equal(langname,"FRANCAIS") || asciz_equal(langname,"francais")
            #ifndef ASCII_CHS
            || asciz_equal(langname,"FRANÇAIS") || asciz_equal(langname,"français")
            #endif
            || asciz_equal(langname,"FRENCH") || asciz_equal(langname,"french")
           )
          { language = language_francais; return TRUE; }
        return FALSE;
      }

  # Initialisiert die Sprache.
    local void init_language (const char* argv_language);
    local void init_language(argv_language)
      var reg2 const char* argv_language;
      { # Sprache wird so festgelegt, mit Prioritäten in dieser Reihenfolge:
        #   1. Fest eingebaut, LANGUAGE_STATIC
        #   2. -L Kommandozeilen-Argument
        #   3. Environment-Variable CLISP_LANGUAGE
        #   4. Environment-Variable LANG
        #   5. Default: Englisch
        if (argv_language)
          { if (init_language_from(argv_language)) return; }
        #ifdef HAVE_ENVIRONMENT
        { var reg1 const char* langname = getenv("CLISP_LANGUAGE");
          if (langname)
            { if (init_language_from(langname)) return; }
          #ifdef AMIGAOS
          langname = getenv("Language"); # since OS 3.0
            { if (init_language_from(langname)) return; }
          #endif
        }
        { var reg1 const char* lang = getenv("LANG");
          if (lang)
            { # LANG hat i.a. die Syntax Sprache[_Land][.Zeichensatz]
              if (lang[0]=='e' && lang[1]=='n' && !alphanumericp((uintB)lang[2])) # "en"
                { language = language_english; return; }
              if (lang[0]=='d' && lang[1]=='e' && !alphanumericp((uintB)lang[2])) # "de"
                { language = language_deutsch; return; }
              if (lang[0]=='f' && lang[1]=='r' && !alphanumericp((uintB)lang[2])) # "fr"
                { language = language_francais; return; }
        }   }
        #endif

        # Default: Englisch
        language = language_english;
      }

#endif

# ------------------------------------------------------------------------------
#                       Tastatur-Unterbrechung

# ------------------------------------------------------------------------------
#                        Initialisierung

# Name des Programms (für Fehlermeldungszwecke)
  global char* program_name;

# Flag, ob System vollständig geladen (für Fehlermeldungsbehandlung)
  local boolean everything_ready = FALSE;

# Flag, ob SYS::READ-FORM sich ILISP-kompatibel verhalten soll:
  global boolean ilisp_mode = FALSE;

#if defined(UNIX) || defined(WIN32_UNIX)

# Real User ID des laufenden Prozesses.
  global uid_t user_uid;

#endif

#ifdef PENDING_INTERRUPTS
  # Flag, ob eine Unterbrechung anliegt.
  global uintB interrupt_pending = FALSE;
#endif

#ifdef HAVE_SIGNALS

# Paßt den Wert von SYS::*PRIN-LINELENGTH* an die aktuelle Breite des
# Terminal-Fensters an.
# update_linelength();
  local void update_linelength (void);
  local void update_linelength()
    { # SYS::*PRIN-LINELENGTH* := Breite des Terminal-Fensters - 1
      #if !defined(NEXTAPP)
      # [vgl. 'term.c' in 'calc' von Hans-J. Böhm, Vernon Lee, Alan J. Demers]
      if (isatty(stdout_handle)) # Standard-Output ein Terminal?
        { /* var reg2 int lines = 0; */
          var reg1 int columns = 0;
          #ifdef TIOCGWINSZ
          # Probiere erst ioctl:
          { var struct winsize stdout_window_size;
            if (!( ioctl(stdout_handle,TIOCGWINSZ,&stdout_window_size) <0))
              { /* lines = stdout_window_size.ws_row; */
                columns = stdout_window_size.ws_col;
          }   }
          # Das kann - entgegen der Dokumentation - scheitern!
          if (/* (lines > 0) && */ (columns > 0)) goto OK;
          #endif
          #if !defined(WATCOM) && !defined(WIN32_DOS) && !defined(WIN32_UNIX)
          # Nun probieren wir's über termcap:
          { var reg3 char* term_name = getenv("TERM");
            if (term_name==NULL) { term_name = "unknown"; }
           {var char termcap_entry_buf[10000];
            if ( tgetent(&!termcap_entry_buf,term_name) ==1)
              { /* lines = tgetnum("li"); if (lines<0) { lines = 0; } */
                columns = tgetnum("co"); if (columns<0) { columns = 0; }
              }
          }}
          #endif
          # Hoffentlich enthält columns jetzt einen vernünftigen Wert.
          if (/* (lines > 0) && */ (columns > 0)) goto OK;
          if (FALSE)
            { OK:
              # Wert von SYS::*PRIN-LINELENGTH* verändern:
              set_Symbol_value(S(prin_linelength),fixnum(columns-1));
            }
        }
      #else # defined(NEXTAPP)
      if (nxterminal_line_length > 0)
        # Wert von SYS::*PRIN-LINELENGTH* verändern:
        { set_Symbol_value(S(prin_linelength),fixnum(nxterminal_line_length-1)); }
      #endif
    }
#if defined(SIGWINCH) && !defined(NO_ASYNC_INTERRUPTS)
# Signal-Handler für Signal SIGWINCH:
  local void sigwinch_handler (int sig);
  local void sigwinch_handler(sig)
    var int sig; # sig = SIGWINCH
    { signal_acknowledge(SIGWINCH,&sigwinch_handler);
      update_linelength();
    }
#endif

# Our general policy with child processes - in particular child processes
# to which we are connected through pipes - is not to wait for them, but
# instead do what init(1) would do in case our process terminates before
# the child: perform a non-blocking waitpid() and ignore the child's
# termination status.
#   void handle_child () { while (waitpid(-1,NULL,WNOHANG) > 0); }
#   SIGNAL(SIGCLD,handle_child);
# The following is equivalent (but better, since it doesn't interrupt system
# calls):
#   SIGNAL(SIGCLD,SIG_IGN);

  local void install_sigcld_handler (void);
  local void install_sigcld_handler ()
    {
      #if defined(SIGCLD)
        SIGNAL(SIGCLD,SIG_IGN);
      #endif
    }

  global void begin_want_sigcld ()
    {
      #if defined(SIGCLD)
        SIGNAL(SIGCLD,SIG_DFL);
      #endif
    }
  global void end_want_sigcld ()
    {
      #if defined(SIGCLD)
        SIGNAL(SIGCLD,SIG_IGN);
        # Try to remove zombies which may have been created since the last
        # begin_want_sigcld() call.
        #ifdef HAVE_WAITPID
          while (waitpid(-1,NULL,WNOHANG) > 0);
        #endif
      #endif
    }

# Eine Tastatur-Unterbrechung (Signal SIGINT, erzeugt durch Ctrl-C)
# wird eine Sekunde lang aufgehoben. In dieser Zeit kann sie mittels
# 'interruptp' auf fortsetzbare Art behandelt werden. Nach Ablauf dieser
# Zeit wird das Programm nichtfortsetzbar unterbrochen.
# Signal-Handler für Signal SIGINT:
  local void interrupt_handler (int sig);
  local void interrupt_handler(sig)
    var int sig; # sig = SIGINT
    { signal_acknowledge(SIGINT,&interrupt_handler);
  #ifdef PENDING_INTERRUPTS
      if (!interrupt_pending) # Liegt schon ein Interrupt an -> nichts zu tun
        { interrupt_pending = TRUE; # Flag für 'interruptp' setzen
          #ifdef HAVE_UALARM
          # eine halbe Sekunde warten, dann jede 1/20 sec probieren
          ualarm(ticks_per_second/2,ticks_per_second/20);
          #else
          alarm(1); # eine Sekunde warten, weiter geht's dann bei alarm_handler
          #endif
        }
    }
  local void alarm_handler (int sig);
  local void alarm_handler(sig)
    var int sig; # sig = SIGALRM
    { # Die Zeit ist nun abgelaufen.
      #if defined(EMUNIX) || defined(WIN32_DOS) # Verhindere Programm-Beendigung durch SIGALRM
      #ifndef HAVE_UALARM
      #ifdef EMUNIX_OLD_8h # EMX-Bug umgehen
      alarm(1000);
      #endif
      alarm(0); # SIGALRM-Timer abbrechen
      #endif
      #endif
      signal_acknowledge(SIGALRM,&alarm_handler);
  #endif # PENDING_INTERRUPTS (!)
    #ifndef NO_ASYNC_INTERRUPTS
      # Warten, bis Unterbrechung erlaubt:
      if (!(break_sems.gesamt == 0))
    #endif
        {
          #ifndef WATCOM
          #ifndef HAVE_UALARM
          alarm(1); # Probieren wir's in einer Sekunde nochmal
          #endif
          #endif
          return; # Nach kurzer Zeit wird wieder ein SIGALRM ausgelöst.
        }
    #ifndef NO_ASYNC_INTERRUPTS
      # Wir springen jetzt aus dem signal-Handler heraus, weder mit 'return'
      # noch mit 'longjmp'.
      #
      # Hans-J. Boehm <boehm@parc.xerox.com> weist darauf hin, daß dies
      # Probleme bringen kann, wenn das Signal ein laufendes malloc() oder
      # free() unterbrochen hat und die malloc()-Library nicht reentrant ist.
      # Abhilfe: statt malloc() stets xmalloc() verwenden, das eine Break-
      # Semaphore setzt? Aber was ist mit malloc()-Aufrufen, die von Routinen
      # wie opendir(), getpwnam(), tgetent(), ... abgesetzt werden? Soll man
      # malloc() selber definieren und darauf hoffen, daß es von allen Library-
      # funktionen aufgerufen wird (statisch gelinkt oder per DLL)??
      #
      #if defined(SIGNAL_NEED_UNBLOCK) || (defined(GNU_READLINE) && (defined(SIGNALBLOCK_BSD) || defined(SIGNALBLOCK_POSIX)))
      # Falls entweder [SIGNAL_NEED_UNBLOCK] mit signal() installierte Handler
      # sowieso mit blockiertem Signal aufgerufen werden - das sind üblicherweise
      # BSD-Systeme -, oder falls andere unsichere Komponenten [GNU_READLINE]
      # per sigaction() o.ä. das Blockieren des Signals beim Aufruf veranlassen
      # können, müssen wir das gerade blockierte Signal entblockieren:
        #if defined(SIGNALBLOCK_POSIX)
          { var sigset_t sigblock_mask;
            sigemptyset(&sigblock_mask); sigaddset(&sigblock_mask,SIGALRM);
            sigprocmask(SIG_UNBLOCK,&sigblock_mask,NULL);
          }
        #elif defined(SIGNALBLOCK_BSD)
          sigsetmask(sigblock(0) & ~sigmask(SIGALRM));
        #endif
      #endif
      #ifdef HAVE_SAVED_STACK
      # STACK auf einen sinnvollen Wert setzen:
      if (!(saved_STACK==NULL)) { setSTACK(STACK = saved_STACK); }
      #endif
      # Über 'fehler' in eine Break-Schleife springen:
      //: DEUTSCH "Ctrl-C: Tastatur-Interrupt"
      //: ENGLISH "Ctrl-C: User break"
      //: FRANCAIS "Ctrl-C : Interruption clavier"
      fehler(serious_condition,GETTEXT("ctrl-c user break"));
    #endif
    }

#if defined(IMMUTABLE) && !defined(GENERATIONAL_GC)
# Signal-Handler für Signal SIGSEGV:
  local void sigsegv_handler (int sig);
  local void sigsegv_handler(sig)
    var int sig; # sig = SIGSEGV
    { signal_acknowledge(SIGSEGV,&sigsegv_handler);
      break_sems.gesamt = 0; # Sehr gefährlich!!
      #ifdef SIGNAL_NEED_UNBLOCK # Unter Linux nicht nötig, unter SunOS4 nötig.
      # gerade blockiertes Signal entblockieren:
      sigsetmask(sigblock(0) & ~sigmask(SIGSEGV));
      #endif
      #ifdef HAVE_SAVED_STACK
      # STACK auf einen sinnvollen Wert setzen:
      if (!(saved_STACK==NULL)) { setSTACK(STACK = saved_STACK); }
      #endif
      # Über 'fehler' in eine Break-Schleife springen:
      fehler_immutable();
    }
  #define install_segv_handler()  \
    SIGNAL(SIGSEGV,&sigsegv_handler)
#endif

#ifdef GENERATIONAL_GC

  local void install_segv_handler (void);

  #ifdef UNIX_NEXTSTEP

    # Die Fehler-Adresse bekommen wir als subcode zu einer Mach-Exception.
    # Dazu läuft ein Thread, der am Exception-Port horcht.

    #include <mach/exception.h>
    #include <mach/exc_server.h>
    #include <mach/cthreads.h>

    # Die Behandlungs-Methode, wird von exc_server() aufgerufen:
    global kern_return_t catch_exception_raise (port_t exception_port, port_t thread, port_t task, int exception, int code, int subcode);
    local boolean exception_handled = FALSE;
    global kern_return_t catch_exception_raise(exception_port,thread,task,exception,code,subcode)
      var port_t exception_port;
      var port_t thread;
      var port_t task;
      var reg1 int exception;
      var int code;
      var reg2 int subcode;
      { if ((exception == EXC_BAD_ACCESS)
            # siehe <mach/exception.h>:
            #   Could not access memory
            #   Code contains kern_return_t describing error.
            #   Subcode contains bad memory address.
            && (handle_fault((aint)subcode) == handler_done)
           )
          { exception_handled = TRUE; return KERN_SUCCESS; }
          else
          { exception_handled = FALSE; return KERN_FAILURE; }
      }

    local port_t main_thread_port;
    local port_t old_exception_port;
    local port_t new_exception_port;

    # Haupt-Funktion des Threads:
    local any_t exception_thread_main (void* dummy);
    local any_t exception_thread_main(dummy)
      var void* dummy;
      { var char in_msg_data[excMaxRequestSize]; # siehe <mach/exc_server.h>
        var char out_msg_data[excMaxReplySize]; # siehe <mach/exc_server.h>
        #define in_msg  (*((msg_header_t*)&in_msg_data[0]))
        #define out_msg  (*((msg_header_t*)&out_msg_data[0]))
        var reg1 kern_return_t retval;
        loop
          { # Auf Message am Exception-Port warten:
            in_msg.msg_size = excMaxRequestSize;
            in_msg.msg_local_port = new_exception_port;
            retval = msg_receive(&in_msg,MSG_OPTION_NONE,0);
            if (!(retval==KERN_SUCCESS))
              { 
                //: DEUTSCH "Mach msg_receive didn't succeed."
                //: ENGLISH "Mach msg_receive didn't succeed."
                //: FRANCAIS "Mach msg_receive didn't succeed."
                asciz_out(GETTEXT("Mach msg_receive didn't succeed."));
                asciz_out(CRLFstring);
                abort(); 
              }
            # Exception-Handler 1 aufrufen, der liefert in out_msg eine Antwort:
            if (!exc_server(&in_msg,&out_msg))
              { 
                //: DEUTSCH "Mach exc_server didn't succeed."
                //: ENGLISH "Mach exc_server didn't succeed."
                //: FRANCAIS "Mach exc_server didn't succeed."
                asciz_out(GETTEXT("Mach exc_server didn't succeed."));
                asciz_out(CRLFstring);
                abort(); 
              }
            # Antwort weiterleiten:
            retval = msg_send(&out_msg,MSG_OPTION_NONE,0);
            if (!(retval==KERN_SUCCESS))
              {
                //: DEUTSCH "Mach msg_send didn't succeed."
                //: ENGLISH "Mach msg_send didn't succeed."
                //: FRANCAIS "Mach msg_send didn't succeed."
                asciz_out(GETTEXT("Mach msg_send didn't succeed."));
                asciz_out(CRLFstring); 
                abort(); 
              }
            # Rückgabewert von handle_fault() anschauen:
            if (exception_handled)
              { exception_handled = FALSE; }
              else
              { # Exception-Handler 2 aufrufen:
                in_msg.msg_remote_port = old_exception_port;
                in_msg.msg_local_port = main_thread_port;
                retval = msg_send(&in_msg,MSG_OPTION_NONE,0);
                if (!(retval==KERN_SUCCESS))
                  { 
                    //: DEUTSCH "Mach msg_send to old_exception_port didn't succeed."
                    //: ENGLISH "Mach msg_send to old_exception_port didn't succeed."
                    //: FRANCAIS "Mach msg_send to old_exception_port didn't succeed."
                    asciz_out(GETTEXT("Mach msg_send to old_exception_port didn't succeed."));
                    asciz_out(CRLFstring);
                    abort(); 
                  }
              }
      }   }

    local void install_segv_handler()
      { local var boolean already_installed = FALSE;
        if (already_installed)
          return;
        # Alten Exception-Port retten:
        if (!(task_get_exception_port(task_self(),&old_exception_port)==KERN_SUCCESS))
          {
            //: DEUTSCH "Mach task_get_exception_port fails."
            //: ENGLISH "Mach task_get_exception_port fails."
            //: FRANCAIS "Mach task_get_exception_port fails."
            asciz_out(GETTEXT("Mach task_get_exception_port fails."));
            asciz_out(CRLFstring);
            abort(); 
          }
        # Neuen Exception-Port installieren:
        if (!(port_allocate(task_self(),&new_exception_port)==KERN_SUCCESS))
          { 
            //: DEUTSCH "Mach port_allocate fails."
            //: ENGLISH "Mach port_allocate fails."
            //: FRANCAIS "Mach port_allocate fails."
            asciz_out(GETTEXT("Mach port_allocate fails."));
            asciz_out(CRLFstring);
            abort(); 
          }
        if (!(task_set_exception_port(task_self(),new_exception_port)==KERN_SUCCESS))
          { 
            //: DEUTSCH "Mach task_set_exception_port fails."
            //: ENGLISH "Mach task_set_exception_port fails."
            //: FRANCAIS "Mach task_set_exception_port fails."
            asciz_out(GETTEXT("Mach task_set_exception_port fails."));
            asciz_out(CRLFstring);
            abort(); 
          }
        # Exception-Behandlungs-Thread aufsetzen:
        cthread_detach(cthread_fork(&exception_thread_main,NULL));
        already_installed = TRUE;
      }

  #else

    local void install_sigsegv_handler (int sig);

    # Signal-Handler für Signal SIGSEGV u.ä.:
    local void sigsegv_handler (FAULT_HANDLER_ARGLIST)
      FAULT_HANDLER_ARGDECL
      { var char* address = (char*)(FAULT_ADDRESS);
        switch (handle_fault((aint)address))
          { case handler_done:
              # erfolgreich
              #ifdef SIGNAL_NEED_REINSTALL
              install_sigsegv_handler(sig);
              #endif
              break;
            case handler_immutable:
              if (sig == SIGSEGV)
                {
                  #ifdef IMMUTABLE
                  #ifdef SIGNAL_NEED_REINSTALL
                  install_sigsegv_handler(sig);
                  #endif
                  break_sems.gesamt = 0; # Sehr gefährlich!!
                  # gerade blockierte Signale entblockieren:
                  #ifdef HAVE_SIGACTION
                    #if defined(SIGNALBLOCK_POSIX)
                    { var sigset_t sigblock_mask;
                      sigemptyset(&sigblock_mask);
                      sigaddset(&sigblock_mask,sig);
                      sigaddset(&sigblock_mask,SIGINT);
                      sigaddset(&sigblock_mask,SIGALRM);
                      #ifdef SIGWINCH
                      sigaddset(&sigblock_mask,SIGWINCH);
                      #endif
                      sigprocmask(SIG_UNBLOCK,&sigblock_mask,NULL);
                    }
                    #elif defined(SIGNALBLOCK_SYSV)
                      sigrelse(sig);
                      sigrelse(SIGINT);
                      sigrelse(SIGALRM);
                      #ifdef SIGWINCH
                      sigrelse(SIGWINCH);
                      #endif
                    #elif defined(SIGNALBLOCK_BSD)
                    { var sigset_t sigblock_mask = sigblock(0);
                      sigblock_mask &= ~sigmask(sig);
                      sigblock_mask &= ~sigmask(SIGINT);
                      sigblock_mask &= ~sigmask(SIGALRM);
                      #ifdef SIGWINCH
                      sigblock_mask &= ~sigmask(SIGWINCH);
                      #endif
                      sigsetmask(sigblock_mask);
                    }
                    #endif
                  #else
                    #ifdef SIGNAL_NEED_UNBLOCK # Unter SunOS4 nötig.
                    sigsetmask(sigblock(0) & ~sigmask(sig));
                    #endif
                  #endif
                  #ifdef HAVE_SAVED_STACK
                  # STACK auf einen sinnvollen Wert setzen:
                  if (!(saved_STACK==NULL)) { setSTACK(STACK = saved_STACK); }
                  #endif
                  # Über 'fehler' in eine Break-Schleife springen:
                  fehler_immutable();
                  #endif
                }
              /* fallthrough */
            case handler_failed:
              # erfolglos 
              //: DEUTSCH "SIGSEGV kann nicht behoben werden. Fehler-Adresse = 0x"
              //: ENGLISH "SIGSEGV cannot be cured. Fault address = 0x"
              //: FRANCAIS "SIGSEGV ne peut être relevé. Adresse fautive = 0x"
              err_asciz_out(GETTEXT("segfault cannot be cured"));
              hex_out(address);
              //: DEUTSCH "."
              //: ENGLISH "."
              //: FRANCAIS "."
              asciz_out(GETTEXT("[end]segfault cannot be cured"));
              asciz_out(CRLFstring);
              # Der Default-Handler wird uns in den Debugger führen.
              SIGNAL(sig,SIG_DFL);
              break;
          }
      }

    # Signal-Handler sorgfältig installieren:
    local void install_sigsegv_handler(sig)
      var reg1 int sig;
      {
        #ifdef HAVE_SIGACTION
          struct sigaction action;
          action.sa_handler = &sigsegv_handler;
          # Während einer SIGSEGV-Behandlung sollten alle Signale blockiert
          # sein, deren Behandlung auf Lisp-Objekte zugreifen muß.
          sigemptyset(&action.sa_mask);
          sigaddset(&action.sa_mask,SIGINT);
          sigaddset(&action.sa_mask,SIGALRM);
          #ifdef SIGWINCH
          sigaddset(&action.sa_mask,SIGWINCH);
          #endif
          # Eventuell muß das Betriebssystem dem Handler
          # ein "siginfo_t" übergeben:
          action.sa_flags =
                            #ifdef FAULT_ADDRESS_FROM_SIGINFO
                            SA_SIGINFO |
                            #endif
                            0;
          sigaction(sig,&action,(struct sigaction *)0);
        #else
          SIGNAL(sig,&sigsegv_handler);
        #endif
      }

    # Alle Signal-Handler installieren:
    local void install_segv_handler()
      {
        #define FAULT_HANDLER(sig)  install_sigsegv_handler(sig);
        WP_SIGNAL
        #undef FAULT_HANDLER
      }

  #endif

#endif

#endif

# Umwandlung der Argumenttypen eines FSUBR in einen Code:
  local fsubr_argtype_ fsubr_argtype (uintW req_anz, uintW opt_anz, fsubr_body_ body_flag);
  local fsubr_argtype_ fsubr_argtype(req_anz,opt_anz,body_flag)
    var reg1 uintW req_anz;
    var reg2 uintW opt_anz;
    var reg3 fsubr_body_ body_flag;
    { switch (body_flag)
        { case fsubr_nobody:
            switch (opt_anz)
              { case 0:
                  switch (req_anz)
                    { case 1: return(fsubr_argtype_1_0_nobody);
                      case 2: return(fsubr_argtype_2_0_nobody);
                      default: goto illegal;
                    }
                case 1:
                  switch (req_anz)
                    { case 1: return(fsubr_argtype_1_1_nobody);
                      case 2: return(fsubr_argtype_2_1_nobody);
                      default: goto illegal;
                    }
                default: goto illegal;
              }
          case fsubr_body:
            switch (opt_anz)
              { case 0:
                  switch (req_anz)
                    { case 0: return(fsubr_argtype_0_body);
                      case 1: return(fsubr_argtype_1_body);
                      case 2: return(fsubr_argtype_2_body);
                      default: goto illegal;
                    }
                default: goto illegal;
              }
          default: goto illegal;
        }
      illegal:
        //: DEUTSCH "Unbekannter FSUBR-Argumenttyp"
        //: ENGLISH "Unknown signature of a FSUBR"
        //: FRANCAIS "Type d'argument inconnu pour FSUBR"
        asciz_out(GETTEXT("unknown signature of a fsubr")); 
        asciz_out(CRLFstring);
        quit_sofort(1);
    }

# Umwandlung der Argumenttypen eines SUBR in einen Code:
  local subr_argtype_ subr_argtype (uintW req_anz, uintW opt_anz, subr_rest_ rest_flag, subr_key_ key_flag);
  local subr_argtype_ subr_argtype(req_anz,opt_anz,rest_flag,key_flag)
    var reg1 uintW req_anz;
    var reg2 uintW opt_anz;
    var reg3 subr_rest_ rest_flag;
    var reg4 subr_key_ key_flag;
    { switch (key_flag)
        { case subr_nokey:
            switch (rest_flag)
              { case subr_norest:
                  switch (opt_anz)
                    { case 0:
                        switch (req_anz)
                          { case 0: return(subr_argtype_0_0);
                            case 1: return(subr_argtype_1_0);
                            case 2: return(subr_argtype_2_0);
                            case 3: return(subr_argtype_3_0);
                            case 4: return(subr_argtype_4_0);
                            case 5: return(subr_argtype_5_0);
                            case 6: return(subr_argtype_6_0);
                            default: goto illegal;
                          }
                      case 1:
                        switch (req_anz)
                          { case 0: return(subr_argtype_0_1);
                            case 1: return(subr_argtype_1_1);
                            case 2: return(subr_argtype_2_1);
                            case 3: return(subr_argtype_3_1);
                            case 4: return(subr_argtype_4_1);
                            default: goto illegal;
                          }
                      case 2:
                        switch (req_anz)
                          { case 0: return(subr_argtype_0_2);
                            case 1: return(subr_argtype_1_2);
                            case 2: return(subr_argtype_2_2);
                            default: goto illegal;
                          }
                      case 3:
                        switch (req_anz)
                          { case 0: return(subr_argtype_0_3);
                            default: goto illegal;
                          }
                      case 4:
                        switch (req_anz)
                          { case 0: return(subr_argtype_0_4);
                            default: goto illegal;
                          }
                      case 5:
                        switch (req_anz)
                          { case 0: return(subr_argtype_0_5);
                            default: goto illegal;
                          }
                      default: goto illegal;
                    }
                case subr_rest:
                  switch (opt_anz)
                    { case 0:
                        switch (req_anz)
                          { case 0: return(subr_argtype_0_0_rest);
                            case 1: return(subr_argtype_1_0_rest);
                            case 2: return(subr_argtype_2_0_rest);
                            case 3: return(subr_argtype_3_0_rest);
                            default: goto illegal;
                          }
                      default: goto illegal;
                    }
                default: goto illegal;
              }
          case subr_key:
            switch (rest_flag)
              { case subr_norest:
                  switch (opt_anz)
                    { case 0:
                        switch (req_anz)
                          { case 0: return(subr_argtype_0_0_key);
                            case 1: return(subr_argtype_1_0_key);
                            case 2: return(subr_argtype_2_0_key);
                            case 3: return(subr_argtype_3_0_key);
                            case 4: return(subr_argtype_4_0_key);
                            default: goto illegal;
                          }
                      case 1:
                        switch (req_anz)
                          { case 0: return(subr_argtype_0_1_key);
                            case 1: return(subr_argtype_1_1_key);
                            default: goto illegal;
                          }
                      case 2:
                        switch (req_anz)
                          { case 1: return(subr_argtype_1_2_key);
                            default: goto illegal;
                          }
                      default: goto illegal;
                    }
                case subr_rest:
                default: goto illegal;
              }
          case subr_key_allow: goto illegal;
          default: goto illegal;
        }
      illegal:
        //: DEUTSCH "Unbekannter SUBR-Argumenttyp"
        //: ENGLISH "Unknown signature of a SUBR"
        //: FRANCAIS "Type d'argument inconnu pour SUBR"
        asciz_out(GETTEXT("unknown signature of a SUBR"));
        asciz_out(CRLFstring);
        quit_sofort(1);
    }

# Initialisierungs-Routinen für die Tabellen
# während des 1. Teils der Initialisierungsphase:
  # subr_tab initialisieren:
    local void init_subr_tab_1 (void);
    local void init_subr_tab_1()
      {
        #if defined(INIT_SUBR_TAB)
          #ifdef MAP_MEMORY_TABLES
            # Tabelle in den vorgesehenen Bereich kopieren:
            subr_tab = subr_tab_data;
          #endif
          #if !NIL_IS_CONSTANT
          # Erst noch den name-Slot initialisieren:
          { var reg1 subr_* ptr = (subr_*)&subr_tab; # subr_tab durchgehen
            #define LISPFUN  LISPFUN_E
            #include "subr.c"
            #undef LISPFUN
          }
          # und den keywords-Slot vorläufig initialisieren:
          { var reg1 subr_* ptr = (subr_*)&subr_tab; # subr_tab durchgehen
            var reg2 uintC count = subr_anz;
            dotimesC(count,subr_anz, { ptr->keywords = NIL; ptr++; });
          }
          #endif
          # Durch SPVWTABF sind schon alle Slots außer keywords und argtype
          # initialisiert.
          # Nun den argtype-Slot initialisieren:
          { var reg1 subr_* ptr = (subr_*)&subr_tab; # subr_tab durchgehen
            var reg2 uintC count;
            dotimesC(count,subr_anz,
              { ptr->argtype =
                  (uintW)subr_argtype(ptr->req_anz,ptr->opt_anz,ptr->rest_flag,ptr->key_flag);
                ptr++;
              });
          }
        #else
          # Alle Slots außer keywords initialisieren:
          { var reg1 subr_* ptr = (subr_*)&subr_tab; # subr_tab durchgehen
            #define LISPFUN  LISPFUN_D
            #include "subr.c"
            #undef LISPFUN
          }
        #endif
        { var reg3 module_* module;
          for_modules(all_other_modules,
            { var reg1 subr_* ptr = module->stab; # subr_tab durchgehen
              var reg2 uintC count;
              dotimesC(count,*module->stab_size,
                { ptr->argtype =
                    (uintW)subr_argtype(ptr->req_anz,ptr->opt_anz,ptr->rest_flag,ptr->key_flag);
                  ptr++;
                });
            });
        }
        #ifdef MAP_MEMORY_TABLES
        # Andere Tabellen ebenfalls in den gemappten Bereich kopieren:
        { var reg2 subr_* newptr = (subr_*)&subr_tab;
          var reg4 module_* module;
          main_module.stab = newptr; newptr += subr_anz;
          for_modules(all_other_modules,
            { var reg1 subr_* oldptr = module->stab;
              var reg3 uintC count;
              module->stab = newptr;
              dotimesC(count,*module->stab_size, { *newptr++ = *oldptr++; } );
            });
          ASSERT(newptr == (subr_*)&subr_tab + total_subr_anz);
        }
        #endif
      }
  # symbol_tab initialisieren:
    local void init_symbol_tab_1 (void);
    local void init_symbol_tab_1()
      {
        #if defined(INIT_SYMBOL_TAB) && NIL_IS_CONSTANT
          #ifdef MAP_MEMORY_TABLES
            # Tabelle in den vorgesehenen Bereich kopieren:
            symbol_tab = symbol_tab_data;
          #endif
        #else
          #if 0 # wozu so viel Code produzieren?
            { var reg1 symbol_* ptr = (symbol_*)&symbol_tab; # symbol_tab durchgehen
              #define LISPSYM  LISPSYM_B
              #include "constsym.c"
              #undef LISPSYM
            }
          #else
            { var reg1 symbol_* ptr = (symbol_*)&symbol_tab; # symbol_tab durchgehen
              var reg2 uintC count;
              dotimesC(count,symbol_anz,
                { ptr->GCself = symbol_tab_ptr_as_object(ptr);
                  ptr->symvalue = unbound;
                  ptr->symfunction = unbound;
                  ptr->proplist = NIL;
                  ptr->pname = NIL;
                  ptr->homepackage = NIL;
                  ptr++;
                });
              #undef ptr_as_symbol
            }
          #endif
        #endif
      }
  # object_tab initialisieren:
    local void init_object_tab_1 (void);
    local void init_object_tab_1()
      { var reg3 module_* module;
        #if defined(INIT_OBJECT_TAB) && NIL_IS_CONSTANT # object_tab schon vorinitialisiert?
          for_modules(all_other_modules,
            { var reg1 object* ptr = module->otab; # object_tab durchgehen
              var reg2 uintC count;
              dotimesC(count,*module->otab_size, { *ptr++ = NIL; });
            });
        #else
          for_modules(all_modules,
            { var reg1 object* ptr = module->otab; # object_tab durchgehen
              var reg2 uintC count;
              dotimesC(count,*module->otab_size, { *ptr++ = NIL; });
            });
        #endif
      }
  # andere Module grob initialisieren:
    local void init_other_modules_1 (void);
    local void init_other_modules_1()
      { var reg3 module_* module;
        for_modules(all_other_modules,
          { # Pointer in der Subr-Tabelle mit NIL füllen, damit GC möglich wird:
            var reg1 subr_* ptr = module->stab;
            var reg2 uintC count;
            dotimesC(count,*module->stab_size,
              { ptr->name = NIL; ptr->keywords = NIL; ptr++; }
              );
            # Die Pointer in der Objekt-Tabelle hat init_object_tab_1() schon vorinitialisiert.
          });
      }

# Initialisierungs-Routinen für die Tabellen
# während des 2. Teils der Initialisierungsphase:
  # subr_tab fertig initialisieren: Keyword-Vektoren eintragen.
    local void init_subr_tab_2 (void);
    local void init_subr_tab_2()
      #if 0
        # Ich hätt's gern so einfach, aber
        # bei TURBO-C reicht der Speicher zum Compilieren nicht!
        { # subr_tab durchgehen
          var reg2 object vec;
          var reg1 object* vecptr;
          #define LISPFUN  LISPFUN_H
          #define kw(name)  *vecptr++ = S(K##name)
          #include "subr.c"
          #undef LISPFUN
          #undef kw
        }
      #else
        { # Keyword-Vektoren einzeln erzeugen:
          var reg2 object vec;
          var reg1 object* vecptr;
          # füllt ein einzelnes Keyword mehr in den Vektor ein:
            #define kw(name)  *vecptr++ = S(K##name)
          # bildet Vektor mit gegebenen Keywords:
            #define v(key_anz,keywords)  \
              vec = allocate_vector(key_anz); \
              vecptr = &TheSvector(vec)->data[0]; \
              keywords;
          # setzt den Vektor als Keyword-Vektor zum SUBR name fest:
            #define s(name)  subr_tab.D_##name.keywords = vec;
          #include "subrkw.c"
          #undef s
          #undef v
          #undef kw
        }
      #endif
  # symbol_tab zu Ende initialisieren: Printnamen und Home-Package eintragen.
    local void init_symbol_tab_2 (void);
    local void init_symbol_tab_2()
      { # Tabelle der Printnamen:
        local char* pname_table[symbol_anz] =
          {
            #define LISPSYM  LISPSYM_D
            #include "constsym.c"
            #undef LISPSYM
          };
        # Tabelle der Packages:
        enum { # Die Werte dieser Aufzählung sind der Reihe nach 0,1,2,...
               enum_lisp_index,
               enum_user_index,
               enum_system_index,
               enum_keyword_index,
               #define LISPPACK  LISPPACK_A
               #include "constpack.c"
               #undef LISPPACK
               enum_dummy_index
          };
        #define package_anz  ((uintL)enum_dummy_index)
        local uintB package_index_table[symbol_anz] =
          {
            #define LISPSYM  LISPSYM_E
            #include "constsym.c"
            #undef LISPSYM
          };
        {var reg1 object list = O(all_packages); # Liste der Packages
         # kurz nach der Initialisierung:
         # (#<PACKAGE LISP> #<PACKAGE USER> #<PACKAGE SYSTEM> #<PACKAGE KEYWORD> ...)
         var reg2 uintC count;
         dotimespC(count,package_anz, { pushSTACK(Car(list)); list = Cdr(list); });
        }
       {var reg3 symbol_* ptr = (symbol_*)&symbol_tab; # symbol_tab durchgehen
        var reg4 char** pname_ptr = &pname_table[0]; # pname_table durchgehen
        var reg5 uintB* index_ptr = &package_index_table[0]; # package_index_table durchgehen
        var reg6 uintC count;
        dotimesC(count,symbol_anz,
          { ptr->pname = make_imm_array(asciz_to_string(*pname_ptr++)); # Printnamen eintragen
           {var reg2 uintB index = *index_ptr++;
            var reg1 object* package_ = &STACK_(package_anz-1) STACKop -(uintP)index; # Pointer auf Package
            pushSTACK(symbol_tab_ptr_as_object(ptr)); # Symbol
            import(&STACK_0,package_); # erst normal importieren
            if (index == (uintB)enum_lisp_index) # in #<PACKAGE LISP> ?
              { export(&STACK_0,package_); } # ja -> auch exportieren
            Symbol_package(popSTACK()) = *package_; # und die Home-Package setzen
            ptr++;
          }});
        skipSTACK(package_anz);
      }}
  # FSUBRs/SUBRs in ihre Symbole eintragen:
    local void init_symbol_functions (void);
    local void init_symbol_functions()
      {# FSUBRs eintragen:
       {typedef struct {
                        #if defined(INIT_SUBR_TAB) && NIL_IS_CONSTANT
                          #define LISPSPECFORM LISPSPECFORM_F
                          object name;
                          #define fsubr_name(p)  (p)->name
                        #else
                          #define LISPSPECFORM LISPSPECFORM_E
                          uintL name_offset;
                          #define fsubr_name(p)  symbol_tab_ptr_as_object((char*)&symbol_tab+(p)->name_offset)
                        #endif
                        uintW req_anz;
                        uintW opt_anz;
                        uintW body_flag;
                       }
                fsubr_data;
        local fsubr_data fsubr_data_tab[] = {
                                              #include "fsubr.c"
                                            };
        #undef LISPSPECFORM
        var reg4 fsubr_* ptr1 = (fsubr_*)&fsubr_tab; # fsubr_tab durchgehen
        var reg2 fsubr_data* ptr2 = &fsubr_data_tab[0]; # fsubr_data_tab durchgehen
        var reg5 uintC count;
        dotimesC(count,fsubr_anz,
          { var reg3 object sym = fsubr_name(ptr2);
            var reg1 object obj = allocate_fsubr();
            TheFsubr(obj)->name = sym;
            TheFsubr(obj)->argtype = fixnum((uintW)fsubr_argtype(ptr2->req_anz,ptr2->opt_anz,ptr2->body_flag));
            TheFsubr(obj)->function = type_pointer_object(machine_type,*ptr1);
            Symbol_function(sym) = obj;
            ptr1++; ptr2++;
          });
       }
       # SUBRs eintragen:
       {var reg1 subr_* ptr = (subr_*)&subr_tab; # subr_tab durchgehen
        var reg2 uintC count;
        dotimesC(count,subr_anz,
          { Symbol_function(ptr->name) = subr_tab_ptr_as_object(ptr);
            ptr++;
          });
      }}
  # Konstanten/Variablen ihre Werte zuweisen:
    local void init_symbol_values (void);
    local void init_symbol_values()
      { # Hilfsmacro: Konstante := wert+1
        #define define_constant_UL1(symbol,wert)  \
          { var reg1 object x = # wert+1 als Integer             \
              ( ((uintL)(wert) < (uintL)(bitm(oint_data_len)-1)) \
                ? fixnum(wert+1)                                 \
                : I_1_plus_I(UL_to_I(wert))                      \
              );                                                 \
            define_constant(symbol,x);                           \
          }
        # allgemein:
        define_constant(S(nil),S(nil));                 # NIL := NIL
        define_constant(S(t),S(t));                     # T := T
        # zu EVAL/CONTROL:
        define_constant_UL1(S(lambda_parameters_limit),lp_limit_1); # LAMBDA-PARAMETERS-LIMIT := lp_limit_1 + 1
        define_constant_UL1(S(call_arguments_limit),ca_limit_1); # CALL-ARGUMENTS-LIMIT := ca_limit_1 + 1
        define_constant(S(multiple_values_limit),       # MULTIPLE-VALUES-LIMIT
          fixnum(mv_limit));      # := mv_limit
        define_constant(S(jmpbuf_size),                 # SYS::*JMPBUF-SIZE* := Größe eines jmp_buf
          fixnum(jmpbufsize));
        define_constant(S(big_endian),(BIG_ENDIAN_P ? T : NIL)); # SYS::*BIG-ENDIAN* := NIL bzw. T
        define_variable(S(macroexpand_hook),L(pfuncall)); # *MACROEXPAND-HOOK* := #'SYS::%FUNCALL
        define_variable(S(evalhookstern),NIL);          # *EVALHOOK*
        define_variable(S(applyhookstern),NIL);         # *APPLYHOOK*
        # zu PACKAGE:
        define_variable(S(packagestern),Car(O(all_packages))); # *PACKAGE* := '#<PACKAGE LISP>
        # zu SYMBOL:
        define_variable(S(gensym_counter),Fixnum_1);    # *GENSYM-COUNTER* := 1
        # zu LISPARIT:
        init_arith(); # definiert folgende:
        # define_variable(S(pi),_EMA_);                      # PI
        # define_constant(S(most_positive_fixnum),_EMA_);    # MOST-POSITIVE-FIXNUM
        # define_constant(S(most_negative_fixnum),_EMA_);    # MOST-NEGATIVE-FIXNUM
        # define_constant(S(most_positive_short_float),_EMA_); # MOST-POSITIVE-SHORT-FLOAT
        # define_constant(S(least_positive_short_float),_EMA_); # LEAST-POSITIVE-SHORT-FLOAT
        # define_constant(S(least_negative_short_float),_EMA_); # LEAST-NEGATIVE-SHORT-FLOAT
        # define_constant(S(most_negative_short_float),_EMA_); # MOST-NEGATIVE-SHORT-FLOAT
        # define_constant(S(most_positive_single_float),_EMA_); # MOST-POSITIVE-SINGLE-FLOAT
        # define_constant(S(least_positive_single_float),_EMA_); # LEAST-POSITIVE-SINGLE-FLOAT
        # define_constant(S(least_negative_single_float),_EMA_); # LEAST-NEGATIVE-SINGLE-FLOAT
        # define_constant(S(most_negative_single_float),_EMA_); # MOST-NEGATIVE-SINGLE-FLOAT
        # define_constant(S(most_positive_double_float),_EMA_); # MOST-POSITIVE-DOUBLE-FLOAT
        # define_constant(S(least_positive_double_float),_EMA_); # LEAST-POSITIVE-DOUBLE-FLOAT
        # define_constant(S(least_negative_double_float),_EMA_); # LEAST-NEGATIVE-DOUBLE-FLOAT
        # define_constant(S(most_negative_double_float),_EMA_); # MOST-NEGATIVE-DOUBLE-FLOAT
        # define_variable(S(most_positive_long_float),_EMA_); # MOST-POSITIVE-LONG-FLOAT
        # define_variable(S(least_positive_long_float),_EMA_); # LEAST-POSITIVE-LONG-FLOAT
        # define_variable(S(least_negative_long_float),_EMA_); # LEAST-NEGATIVE-LONG-FLOAT
        # define_variable(S(most_negative_long_float),_EMA_); # MOST-NEGATIVE-LONG-FLOAT
        # define_constant(S(short_float_epsilon),_EMA_);     # SHORT-FLOAT-EPSILON
        # define_constant(S(single_float_epsilon),_EMA_);    # SINGLE-FLOAT-EPSILON
        # define_constant(S(double_float_epsilon),_EMA_);    # DOUBLE-FLOAT-EPSILON
        # define_variable(S(long_float_epsilon),_EMA_);      # LONG-FLOAT-EPSILON
        # define_constant(S(short_float_negative_epsilon),_EMA_); # SHORT-FLOAT-NEGATIVE-EPSILON
        # define_constant(S(single_float_negative_epsilon),_EMA_); # SINGLE-FLOAT-NEGATIVE-EPSILON
        # define_constant(S(double_float_negative_epsilon),_EMA_); # DOUBLE-FLOAT-NEGATIVE-EPSILON
        # define_variable(S(long_float_negative_epsilon),_EMA_); # LONG-FLOAT-NEGATIVE-EPSILON
        # define_variable(S(read_default_float_format),_EMA_); # *READ-DEFAULT-FLOAT-FORMAT*
        # define_variable(S(random_state),_EMA_);            # *RANDOM-STATE*
        # zu ARRAY:
        define_constant_UL1(S(array_total_size_limit),arraysize_limit_1); # ARRAY-TOTAL-SIZE-LIMIT := arraysize_limit_1 + 1
        define_constant_UL1(S(array_dimension_limit),arraysize_limit_1); # ARRAY-DIMENSION-LIMIT := arraysize_limit_1 + 1
        define_constant_UL1(S(array_rank_limit),arrayrank_limit_1); # ARRAY-RANK-LIMIT := arrayrank_limit_1 + 1
        # zu DEBUG:
        define_variable(S(plus),NIL);                   # +
        define_variable(S(plus2),NIL);                  # ++
        define_variable(S(plus3),NIL);                  # +++
        define_variable(S(minus),NIL);                  # -
        define_variable(S(mal),NIL);                    # *
        define_variable(S(mal2),NIL);                   # **
        define_variable(S(mal3),NIL);                   # ***
        define_variable(S(durch),NIL);                  # /
        define_variable(S(durch2),NIL);                 # //:
        define_variable(S(durch3),NIL);                 # //:/
        define_variable(S(driverstern),NIL);            # *DRIVER* := NIL
        define_variable(S(break_driver),NIL);           # *BREAK-DRIVER* := NIL
        define_variable(S(break_count),Fixnum_0);       # SYS::*BREAK-COUNT* := 0
        define_variable(S(recurse_count_standard_output),Fixnum_0); # SYS::*RECURSE-COUNT-STANDARD-OUTPUT* := 0
        define_variable(S(load_input_stream),NIL);
        # zu STREAM:
        # später: init_streamvars(); # definiert folgende:
        # define_variable(S(standard_input),_EMA_);          # *STANDARD-INPUT*
        # define_variable(S(standard_output),_EMA_);         # *STANDARD-OUTPUT*
        # define_variable(S(error_output),_EMA_);            # *ERROR-OUTPUT*
        # define_variable(S(query_io),_EMA_);                # *QUERY-IO*
        # define_variable(S(debug_io),_EMA_);                # *DEBUG-IO*
        # define_variable(S(terminal_io),_EMA_);             # *TERMINAL-IO*
        # define_variable(S(trace_output),_EMA_);            # *TRACE-OUTPUT*
        # define_variable(S(keyboard_input),_EMA_);          # *KEYBOARD-INPUT*
        define_variable(S(default_pathname_defaults),unbound); # *DEFAULT-PATHNAME-DEFAULTS*
        define_variable(S(read_pathname_p),NIL);
        # zu IO:
        init_reader(); # definiert folgende:
        # define_variable(S(read_base),_EMA_);               # *READ-BASE* := 10
        # define_variable(S(read_suppress),_EMA_);           # *READ-SUPPRESS* := NIL
        # define_variable(S(readtablestern),_EMA_);          # *READTABLE*
        define_variable(S(read_preserve_whitespace),unbound); # SYS::*READ-PRESERVE-WHITESPACE*
        define_variable(S(read_recursive_p),unbound);   # SYS::*READ-RECURSIVE-P*
        define_variable(S(read_reference_table),unbound); # SYS::*READ-REFERENCE-TABLE*
        define_variable(S(backquote_level),unbound);    # SYS::*BACKQUOTE-LEVEL*
        define_variable(S(compiling),NIL);              # SYS::*COMPILING* ;= NIL
        define_variable(S(print_case),S(Kupcase));      # *PRINT-CASE* := :UPCASE
        define_variable(S(print_level),NIL);            # *PRINT-LEVEL* := NIL
        define_variable(S(print_length),NIL);           # *PRINT-LENGTH* := NIL
        define_variable(S(print_gensym),T);             # *PRINT-GENSYM* := T
        define_variable(S(print_escape),T);             # *PRINT-ESCAPE* := T
        define_variable(S(print_radix),NIL);            # *PRINT-RADIX* := NIL
        define_variable(S(print_base),fixnum(10));      # *PRINT-BASE* := 10
        define_variable(S(print_array),T);              # *PRINT-ARRAY* := T
        define_variable(S(print_circle),NIL);           # *PRINT-CIRCLE* := NIL
        define_variable(S(print_pretty),NIL);           # *PRINT-PRETTY* := NIL
        define_variable(S(print_closure),NIL);          # *PRINT-CLOSURE* := NIL
        define_variable(S(print_readably),NIL);         # *PRINT-READABLY* := NIL
        define_variable(S(print_rpars),T);              # *PRINT-RPARS* := T
        define_variable(S(print_indent_lists),fixnum(2)); # *PRINT-INDENT-LISTS* := 2
        define_variable(S(print_circle_table),unbound); # SYS::*PRINT-CIRCLE-TABLE*
        define_variable(S(prin_level),unbound);         # SYS::*PRIN-LEVEL*
        define_variable(S(prin_stream),unbound);        # SYS::*PRIN-STREAM*
        define_variable(S(prin_linelength),fixnum(79)); # SYS::*PRIN-LINELENGTH* := 79 (vorläufig)
        define_variable(S(prin_l1),unbound);            # SYS::*PRIN-L1*
        define_variable(S(prin_lm),unbound);            # SYS::*PRIN-LM*
        define_variable(S(prin_rpar),unbound);          # SYS::*PRIN-RPAR*
        define_variable(S(prin_jblocks),unbound);       # SYS::*PRIN-JBLOCKS*
        define_variable(S(prin_jbstrings),unbound);     # SYS::*PRIN-JBSTRINGS*
        define_variable(S(prin_jbmodus),unbound);       # SYS::*PRIN-JBMODUS*
        define_variable(S(prin_jblpos),unbound);        # SYS::*PRIN-JBLPOS*
        # zu EVAL:
        define_variable(S(evalhookstern),NIL);          # *EVALHOOK* := NIL
        define_variable(S(applyhookstern),NIL);         # *APPLYHOOK* := NIL
        # zu MISC:
        define_constant(S(internal_time_units_per_second),  # INTERNAL-TIME-UNITS-PER-SECOND
          fixnum(ticks_per_second) ); # := 200 bzw. 1000000
        # zu ERROR:
        define_variable(S(use_clcs),NIL);               # SYS::*USE-CLCS* := NIL
        define_variable(S(recursive_error_count),Fixnum_0); # SYS::*RECURSIVE-ERROR-COUNT* := 0
        define_variable(S(error_handler),NIL);          # *ERROR-HANDLER* := NIL
        # zu SPVW:
        define_variable(S(init_hooks),NIL);             # SYS::*INIT-HOOKS* := NIL
        define_variable(S(quiet),NIL);                  # SYS::*QUIET* := NIL
        # zu FOREIGN:
        #ifdef DYNAMIC_FFI
        define_constant(S(fv_flag_readonly),fixnum(fv_readonly));  # FFI::FV-FLAG-READONLY
        define_constant(S(fv_flag_malloc_free),fixnum(fv_malloc)); # FFI::FV-FLAG-MALLOC-FREE
        define_constant(S(ff_flag_alloca),fixnum(ff_alloca));      # FFI::FF-FLAG-ALLOCA
        define_constant(S(ff_flag_malloc_free),fixnum(ff_malloc)); # FFI::FF-FLAG-MALLOC-FREE
        define_constant(S(ff_flag_out),fixnum(ff_out));            # FFI::FF-FLAG-OUT
        define_constant(S(ff_flag_in_out),fixnum(ff_inout));       # FFI::FF-FLAG-IN-OUT
        define_constant(S(ff_language_asm),fixnum(ff_lang_asm));       # FFI::FF-LANGUAGE-ASM
        define_constant(S(ff_language_c),fixnum(ff_lang_c));           # FFI::FF-LANGUAGE-C
        define_constant(S(ff_language_ansi_c),fixnum(ff_lang_ansi_c)); # FFI::FF-LANGUAGE-ANSI-C
        #endif
        # zu PATHNAME:
        #ifdef LOGICAL_PATHNAMES
        { # SYS::*LOGICAL-PATHNAME-TRANSLATIONS* := (MAKE-HASH-TABLE :TEST #'EQUAL)
          pushSTACK(S(Ktest)); pushSTACK(L(equal)); funcall(L(make_hash_table),2);
          define_variable(S(logpathname_translations),value1);
        }
        O(empty_logical_pathname) = allocate_logpathname();
        #endif
        # *DEFAULT-PATHNAME-DEFAULTS* vorläufig initialisieren:
        define_variable(S(default_pathname_defaults),allocate_pathname());
        #undef define_constant_UL1
      }
  # sonstige Objekte kreieren und Objekttabelle füllen:
    local void init_object_tab (void);
    local void init_object_tab()
      { # Tabelle mit Initialisierungsstrings:
        local var char* object_initstring_tab []
          = {
             #define LISPOBJ LISPOBJ_C
             #include "constobj.c"
             #undef LISPOBJ
            };
        # *FEATURES* initialisieren:
        { var reg2 char* features_initstring =
            "(CLISP CLTL1 COMMON-LISP INTERPRETER"
            #ifdef FAST_SP
              " SYSTEM::CLISP2"
            #else
              " SYSTEM::CLISP3"
            #endif
            #ifdef LOGICAL_PATHNAMES
              " LOGICAL-PATHNAMES"
            #endif
            #ifdef DYNAMIC_FFI
              " FFI"
            #endif
            #ifdef ENABLE_NLS
              " NLS"
            #endif
            #ifdef AMIGA
              " AMIGA"
            #endif
            #ifdef SUN3
              " SUN3"
            #endif
            #ifdef SUN386
              " SUN386"
            #endif
            #ifdef SUN4
              " SUN4"
            #endif
            #ifdef PC386
              " PC386"
            #endif
            #ifdef MSDOS
             #ifdef OS2
              " OS/2"
             #else
              " DOS"
             #endif
            #endif
            #ifdef WIN32_DOS
             " WIN32-DOS"
            #endif
            #ifdef WIN32_UNIX
                " WIN32-UNIX"
            #endif
            #ifdef RISCOS
              " ACORN-RISCOS"
            #endif
            #ifdef UNIX
              " UNIX"
            #endif
            ")"
            ;
          pushSTACK(asciz_to_string(features_initstring));
         {var reg1 object list = (funcall(L(read_from_string),1), value1);
          define_variable(S(features),list);             # *FEATURES*
        }}
        # Objekte aus den Strings lesen:
        { var reg1 object* objptr = (object*)&object_tab; # object_tab durchgehen
          var reg2 char** stringptr = &object_initstring_tab[0]; # Stringtabelle durchgehen
          var reg3 uintC count;
          dotimesC(count,object_anz,
            { pushSTACK(asciz_to_string(*stringptr++)); # String
              funcall(L(make_string_input_stream),1); # in Stream verpacken
              pushSTACK(value1);
             {var reg4 object obj = read(&STACK_0,NIL,NIL); # Objekt lesen
              skipSTACK(1);
              if (!eq(obj,dot_value)) { *objptr = obj; } # und eintragen (außer ".")
              objptr++;
            }});
        }
        TheSstring(O(null_string))->data[0] = 0; # Nullbyte in den Null-String einfügen
        Car(O(top_decl_env)) = O(declaration_types); # Toplevel-Deklarations-Environment bauen
      }

    #ifdef DYNBIND_LIST
    local void init_dynbind_list (void);
    local void init_dynbind_list()
      {
        define_variable(S(dynamic_and_special_frames),NIL);
        define_variable(S(dynamic_bindings),NIL);
        define_variable(S(special_bindings),NIL);
        define_variable(S(transitions_to_dynamic_bindings),NIL);
        define_variable(S(transitions_to_special_bindings),NIL);
      }
    #endif

    local void init_derived_strings (void);
    local void init_derived_strings()
      {
        pushSTACK(O(lisp_implementation_version_date_string));
        pushSTACK(O(space_string));
        pushSTACK(O(left_paren_string));
        pushSTACK(OL(lisp_implementation_version_month_string));
        pushSTACK(O(space_string));
        pushSTACK(O(lisp_implementation_version_year_string));
        pushSTACK(O(right_paren_string));          
        define_variable(S(lisp_implementation_version_string),string_concat(7));
        pushSTACK(OL(c_compiler_version_string));
        pushSTACK(O(space_string));
        pushSTACK(O(c_compiler_version_number_string));
        define_variable(S(software_version_string),string_concat(3));
      }

  # Zu-Fuß-Initialisierung aller LISP-Daten:
    local void initmem (void);
    local void initmem()
      { init_symbol_tab_1(); # symbol_tab initialisieren
        init_object_tab_1(); # object_tab initialisieren
        init_other_modules_1(); # andere Module grob initialisieren
        # Jetzt sind die Tabellen erst einmal grob initialisiert, bei GC
        # kann nichts passieren.
        # subr_tab fertig initialisieren:
        init_subr_tab_2();
        # Packages initialisieren:
        init_packages();
        # symbol_tab fertig initialisieren:
        init_symbol_tab_2();
        # SUBRs/FSUBRs in ihre Symbole eintragen:
        init_symbol_functions();
        # Konstanten/Variablen: Wert in die Symbole eintragen:
        init_symbol_values();
        # sonstige Objekte kreieren:
        #ifdef DYNBIND_LIST
        init_dynbind_list();
        #endif
        init_object_tab();
      }

    local void err_module_needs_package (const char *module_name,const char *package_name);
    local void err_module_needs_package (module_name,package_name)
      var const char *module_name;
      var const char *package_name;
      {
        //: DEUTSCH "Modul `"
        //: ENGLISH "module `"
        //: FRANCAIS "Pas de module «"
        asciz_out(GETTEXT("module"));
        asciz_out(module_name);
        //: DEUTSCH "' benötigt Package "
        //: ENGLISH "' requires package "
        //: FRANCAIS "» sans le paquetage "
        asciz_out(GETTEXT("requires package"));
        asciz_out(package_name);
        //: DEUTSCH "."
        //: ENGLISH "."
        //: FRANCAIS "."
        asciz_out(GETTEXT("[end]requires package"));
        asciz_out(CRLFstring);
      }

  # Laden vom MEM-File:
    local void loadmem (char* filename); # siehe unten
  # Initialiserung der anderen, noch nicht initialisierten Module:
    local void init_other_modules_2 (void);
    local void init_other_modules_2()
      { var reg5 module_* module; # modules durchgehen
        for_modules(all_other_modules,
          { if (!module->initialized)
              { # Objekt-Tabelle mit NIL füllen, damit GC möglich wird:
                var reg1 object* object_ptr = module->otab;
                var reg2 uintC count;
                dotimesC(count,*module->otab_size, { *object_ptr++ = NIL; } );
              }
          });
      }
    local void init_other_modules_3 (void);
    local void init_other_modules_3()
      { var reg7 module_* module; # modules durchgehen
        for_modules(all_other_modules,
          { if (!module->initialized)
              { # Subr-Symbole eintragen:
                { var reg2 subr_* subr_ptr = module->stab;
                  var reg1 subr_initdata* init_ptr = module->stab_initdata;
                  var reg3 uintC count;
                  dotimesC(count,*module->stab_size,
                    { var reg5 char* packname = init_ptr->packname;
                      var reg6 object symname = asciz_to_string(init_ptr->symname);
                      var object symbol;
                      if (packname==NULL)
                        { symbol = make_symbol(symname); }
                        else
                        { var reg4 object pack = find_package(asciz_to_string(packname));
                          if (nullp(pack)) # Package nicht gefunden?
                            { err_module_needs_package(module->name,packname);
                              quit_sofort(1);
                            }
                          intern(symname,pack,&symbol);
                        }
                      subr_ptr->name = symbol; # Subr komplett machen
                      Symbol_function(symbol) = subr_tab_ptr_as_object(subr_ptr); # Funktion definieren
                      init_ptr++; subr_ptr++;
                    });
                }
                # Objekte eintragen:
                { var reg2 object* object_ptr = module->otab;
                  var reg1 object_initdata* init_ptr = module->otab_initdata;
                  var reg3 uintC count;
                  dotimesC(count,*module->otab_size,
                    { pushSTACK(asciz_to_string(init_ptr->initstring)); # String
                      funcall(L(make_string_input_stream),1); # in Stream verpacken
                      pushSTACK(value1);
                      *object_ptr = read(&STACK_0,NIL,NIL); # Objekt lesen
                      skipSTACK(1);
                      object_ptr++; init_ptr++;
                    });
                }
                # Initialisierungsfunktion aufrufen:
                (*module->initfunction1)(module);
              }
          });
      }

#ifdef AMIGAOS

  # Diese beiden Variablen werden, wenn man Glück hat, vom Startup-System
  # (von dem main() aufgerufen wird) sinnvoll vorbesetzt:
  global Handle Input_handle = Handle_NULL;    # low-level stdin Eingabekanal
  global Handle Output_handle = Handle_NULL;   # low-level stdout Ausgabekanal

  global BPTR orig_dir_lock = BPTR_NONE; # das Current Directory beim Programmstart
  # wird verwendet von PATHNAME

  # Initialisierung, ganz zuerst in main() durchzuführen:
    local void init_amiga (void);
    local void init_amiga()
      {
        cpu_is_68000 = ((SysBase->AttnFlags & (AFF_68020|AFF_68030|AFF_68040)) == 0);
        #ifdef MC68000
        # Diese Version benötigt einen 68000. (Wegen addressbus_mask.)
        if (!cpu_is_68000)
          { exit(RETURN_FAIL); }
        #endif
        #ifdef MC680Y0
        # Diese Version benötigt mindestens einen 68020, läuft nicht auf 68000.
        # (Wegen ari68020.d, einiger asm()s und wegen gcc-Option -m68020.)
        if (cpu_is_68000)
          { exit(RETURN_FAIL); }
        #endif
        # Wir wollen uns nicht mehr mit OS Version 1.x beschäftigen
	if (SysBase->LibNode.lib_Version < 36) { exit(RETURN_FAIL); }
        if (Input_handle==Handle_NULL) { Input_handle = Input(); }
        if (Output_handle==Handle_NULL) { Output_handle = Output(); }
        # Abfrage, ob Workbench-Aufruf ohne besonderen Startup:
        if ((Input_handle==Handle_NULL) || (Output_handle==Handle_NULL))
          { exit(RETURN_FAIL); }
        # Benutzter Speicher muß in [0..2^oint_addr_len-1] liegen:
        if (!(pointable_usable_test((aint)&init_amiga) # Code-Segment überprüfen
              && pointable_usable_test((aint)&symbol_tab) # Daten-Segment überprüfen
           ) )
          { 
            //: DEUTSCH "Diese CLISP-Version muß in Speicher mit niedrigen Adressen ablaufen."
            //: ENGLISH "This version of CLISP runs only in low address memory."
            //: FRANCAIS "Cette version de CLISP ne marche qu'en mémoire à adresse basse."
            asciz_out(GETTEXT("this version of CLISP runs only in low address memory"));
            asciz_out(CRLFstring);
            asciz_out("CODE: "); hex_out((aint)&init_amiga);
            asciz_out(", DATA: "); hex_out((aint)&symbol_tab);
            asciz_out("." CRLFstring);
            exit(RETURN_FAIL);
          }
        #if !(defined(WIDE) || defined(MC68000))
        # Ein Flag, das uns hilft, Speicher mit niedrigen Adressen zu bekommen:
        retry_allocmemflag =
          (CPU_IS_68000              # der 68000 hat nur 24 Bit Adreßbereich,
           ? MEMF_ANY                # nie ein zweiter Versuch nötig
           : MEMF_24BITDMA           # sonst Flag MEMF_24BITDMA
          );
        #endif
      }

  # Rückgabe aller Ressourcen und Programmende:
  nonreturning_function(local, exit_amiga, (sintL code));
  local void exit_amiga(code)
    var reg3 sintL code;
    { begin_system_call();
      # Zurück ins Verzeichnis, in das wir beim Programmstart waren:
      if (!(orig_dir_lock == BPTR_NONE)) # haben wir das Verzeichnis je gewechselt?
        { var reg1 BPTR lock = CurrentDir(orig_dir_lock); # zurück ins alte
          UnLock(lock); # dieses nun freigeben
        }
      # Speicher freigeben:
      { var reg1 MemBlockHeader* memblocks = allocmemblocks;
        until (memblocks==NULL)
          { var reg2 MemBlockHeader* next = memblocks->next;
            FreeMem(memblocks,memblocks->size);
            memblocks = next;
      }   }
      # Programmende:
      exit(code);
    }

#endif

# Hauptprogramm trägt den Namen 'main'.
  #ifdef NEXTAPP
    # main() existiert schon in Lisp_main.m
    #define main  clisp_main
  #endif
  #if defined(EMUNIX) && defined(WINDOWS)
    # main() existiert bereits in libwin.a
    #define main  clisp_main
  #endif
  #ifndef argc_t
    #define argc_t int  # Typ von argc ist meist 'int'.
  #endif
  global int main (argc_t argc, char* argv[]);
  local boolean argv_quiet = FALSE; # ob beim Start Quiet-Option angegeben
  global int main(argc,argv)
    var reg1 argc_t argc;
    var reg1 char* * argv;
    { # Initialisierung der Speicherverwaltung.
      # Gesamtvorgehen:
      # Command-Line-Argumente verarbeiten.
      # Speicheraufteilung bestimmen.
      # Commandstring anschauen und entweder LISP-Daten vom .MEM-File
      #   laden oder zu Fuß erzeugen und statische LISP-Daten initialisieren.
      # Interrupt-Handler aufbauen.
      # Begrüßung ausgeben.
      # In den Driver springen.
      #
      #ifdef AMIGAOS
      init_amiga();
      #endif
      #ifdef EMUNIX
      # Wildcards und Response-Files in der Kommandozeile expandieren:
      _response(&argc,&argv);
      _wildcard(&argc,&argv);
      #endif
      #ifdef DJUNIX
      # Ctrl-Break verbieten, so weit es geht:
      local var int cbrk;
      cbrk = getcbrk();
      if (cbrk) { setcbrk(0); }
      # Ctrl-Break wollen wir abfangen:
      _go32_want_ctrl_break(1);
      #endif
      #ifdef WIN32_DOS
      # Auf stdin und stdout im Text-Modus zugreifen:
      begin_system_call();
      setmode(stdin_handle,O_TEXT);
      setmode(stdout_handle,O_TEXT);
      end_system_call();
      #endif
      #ifdef RISCOS
      # Disable UnixLib's automatic name munging:
      __uname_control = 1;
      #endif
      #if defined(UNIX) || defined(WIN32_UNIX)
      user_uid = getuid();
      #ifdef GRAPHICS_SWITCH
      # Programm muß mit "setuid root"-Privileg installiert werden:
      # (chown root, chmod 4755). Vom root-Privileg befreien wir uns so schnell
      # wie möglich - sicherheitshalber.
      { extern uid_t root_uid;
        root_uid = geteuid();
        setreuid(root_uid,user_uid);
      }
      #endif
      find_executable(argv[0]);
      #endif
     {var uintL argv_memneed = 0;
      #ifndef NO_SP_MALLOC
      var uintL argv_stackneed = 0;
      #endif
      #ifdef MULTIMAP_MEMORY_VIA_FILE
      var local char* argv_tmpdir = NULL;
      #endif
      var local char* argv_memfile = NULL;
      var local uintL argv_init_filecount = 0;
      var local char** argv_init_files;
      var local boolean argv_compile = FALSE;
      var local boolean argv_compile_listing = FALSE;
      var local uintL argv_compile_filecount = 0;
      typedef struct { char* input_file; char* output_file; } argv_compile_file;
      var local argv_compile_file* argv_compile_files;
      var local char* argv_package = NULL;
      var local char* argv_expr = NULL;
      var local char* argv_language = NULL;
      var local char* argv_localedir = NULL;
      {var DYNAMIC_ARRAY(,argv_init_files_array,char*,(uintL)argc); # maximal argc Init-Files
       argv_init_files = argv_init_files_array;
      {var DYNAMIC_ARRAY(,argv_compile_files_array,argv_compile_file,(uintL)argc); # maximal argc File-Argumente
       argv_compile_files = argv_compile_files_array;
      if (!(setjmp(&!original_context) == 0)) goto end_of_main;
      # Argumente argv[0..argc-1] abarbeiten:
      #   -h              Help
      #   -m size         Memory size (size = xxxxxxxB oder xxxxKB oder xMB)
      #   -s size         Stack size (size = xxxxxxxB oder xxxxKB oder xMB)
      #   -t directory    temporäres Directory
      #   -M file         MEM-File laden
      #   -L language     sets the user language
      #   -q              quiet: keine Copyright-Meldung
      #   -I              ILISP-freundlich
      #   -i file ...     LISP-File zur Initialisierung laden
      #   -c file ...     LISP-Files compilieren, dann LISP verlassen
      #   -l              Beim Compilieren: Listings anlegen
      #   -p package      *PACKAGE* setzen
      #   -x expr         LISP-Expressions ausführen, dann LISP verlassen
      program_name = argv[0]; # argv[0] ist der Programmname
      if (FALSE)
        { usage:
          //: DEUTSCH "Usage:  "
          //: ENGLISH "Usage:  "
          //: FRANCAIS "Usage:  "
          asciz_out(GETTEXT("Usage:  "));
          asciz_out(program_name);
          asciz_out(" [-h] [-m memsize]");
          #ifndef NO_SP_MALLOC
          asciz_out(" [-s stacksize]");
          #endif
          #ifdef MULTIMAP_MEMORY_VIA_FILE
          asciz_out(" [-t tmpdir]");
          #endif
          asciz_out(" [-M memfile] [-L language] [-q] [-I] [-i initfile ...]"
                    " [-c [-l] lispfile [-o outputfile] ...] [-p packagename]"
                    " [-x expression]" CRLFstring);
          quit_sofort(1); # anormales Programmende
        }
     {var reg2 char** argptr = &argv[1];
      var reg3 char** argptr_limit = &argv[argc];
      var reg5 enum { illegal, for_init, for_compile } argv_for = illegal;
      # Durchlaufen und Optionen abarbeiten, alles Abgearbeitete durch NULL
      # ersetzen:
      while (argptr < argptr_limit)
        { var reg1 char* arg = *argptr++; # nächstes Argument
          if (arg[0] == '-')
            { switch (arg[1])
                { case 'h': # Help
                    goto usage;
                  # Liefert nach einem einbuchstabigen Kürzel den Rest der
                  # Option in arg. Evtl. Space wird übergangen.
                  #define OPTION_ARG  \
                    if (arg[2] == '\0') \
                      { if (argptr < argptr_limit) arg = *argptr++; else goto usage; } \
                      else { arg = &arg[2]; }
                  # Parst den Rest einer Option, die eine Byte-Größe angibt.
                  # Überprüft auch, ob gewisse Grenzen eingehalten werden.
                  #define SIZE_ARG(docstring,sizevar,limit_low,limit_high)  \
                    # arg sollte aus einigen Dezimalstellen, dann   \
                    # evtl. K oder M, dann evtl. B oder W bestehen. \
                    {var reg4 uintL val = 0;                        \
                     while ((*arg >= '0') && (*arg <= '9'))         \
                       { val = 10*val + (uintL)(*arg++ - '0'); }    \
                     switch (*arg)                                  \
                       { case 'k': case 'K': # Angabe in Kilobytes  \
                           val = val * 1024; arg++; break;          \
                         case 'm': case 'M': # Angabe in Megabytes  \
                           val = val * 1024*1024; arg++; break;     \
                       }                                            \
                     switch (*arg)                                  \
                       { case 'w': case 'W': # Angabe in Worten     \
                           val = val * sizeof(object);              \
                         case 'b': case 'B': # Angabe in Bytes      \
                           arg++; break;                            \
                       }                                            \
                     if (!(*arg == '\0')) # Argument zu Ende?       \
                       {                                            \
                         asciz_out("Syntax for ");                  \
                         asciz_out(docstring);                      \
                         asciz_out(": nnnnnnn or nnnnKB or nMB");   \
                         asciz_out(CRLFstring);                     \
                         goto usage;                                \
                       }                                            \
                     if (!((val >= limit_low) && (val <= limit_high))) \
                       { asciz_out(docstring);                      \
                         asciz_out(" out of range");       \
                         asciz_out(CRLFstring);                     \
                         goto usage;                                \
                       }                                            \
                     # Bei mehreren -m bzw. -s Argumenten zählt nur das letzte. \
                     sizevar = val;                                 \
                    }
                  case 'm': # Memory size
                    OPTION_ARG
                    //: DEUTSCH "memory size"
                    //: ENGLISH "memory size"
                    //: FRANCAIS "memory size"
                    SIZE_ARG(GETTEXT("memory size"),argv_memneed,100000,
                             (oint_addr_len+addr_shift < intLsize-1 # memory size begrenzt durch
                              ? bitm(oint_addr_len+addr_shift)      # Adreßraum in oint_addr_len+addr_shift Bits
                              : (uintL)bit(intLsize-1)-1            # (bzw. große Dummy-Grenze)
                            ))
                    break;
                  #ifndef NO_SP_MALLOC
                  case 's': # Stack size
                    OPTION_ARG
                    //: DEUTSCH "stack size"
                    //: ENGLISH "stack size"
                    //: FRANCAIS "stack size"
                    SIZE_ARG(GETTEXT("stack size"),argv_stackneed,40000,8*1024*1024)
                    break;
                  #endif
                  #ifdef MULTIMAP_MEMORY_VIA_FILE
                  case 't': # temporäres Directory
                    OPTION_ARG
                    if (!(argv_tmpdir == NULL)) goto usage;
                    argv_tmpdir = arg;
                    break;
                  #endif
                  case 'M': # MEM-File
                    OPTION_ARG
                    # Bei mehreren -M Argumenten zählt nur das letzte.
                    argv_memfile = arg;
                    break;
                  case 'L': # Language
                    OPTION_ARG
                    # Bei mehreren -L Argumenten zählt nur das letzte.
                    argv_language = arg;
                    break;
                  #ifdef ENABLE_NLS
                  case 'N': # NLS MO path
                    OPTION_ARG
                    argv_localedir = arg;
                    break;
                  #endif
                  case 'q': # keine Copyright-Meldung
                    argv_quiet = TRUE;
                    if (!(arg[2] == '\0')) goto usage;
                    break;
                  case 'I': # ILISP-freundlich
                    ilisp_mode = TRUE;
                    if (!(arg[2] == '\0')) goto usage;
                    break;
                  case 'i': # Initialisierungs-Files
                    argv_for = for_init;
                    if (!(arg[2] == '\0')) goto usage;
                    break;
                  case 'c': # Zu compilierende Files
                    argv_compile = TRUE;
                    argv_for = for_compile;
                    if (arg[2] == 'l')
                      { argv_compile_listing = TRUE;
                        if (!(arg[3] == '\0')) goto usage;
                      }
                      else
                      { if (!(arg[2] == '\0')) goto usage; }
                    break;
                  case 'l': # Compilate und Listings
                    argv_compile_listing = TRUE;
                    if (!(arg[2] == '\0')) goto usage;
                    break;
                  case 'o': # Ziel für zu compilierendes File
                    if (!(arg[2] == '\0')) goto usage;
                    OPTION_ARG
                    if (!((argv_compile_filecount > 0) && (argv_compile_files[argv_compile_filecount-1].output_file==NULL))) goto usage;
                    argv_compile_files[argv_compile_filecount-1].output_file = arg;
                    break;
                  case 'p': # Package
                    OPTION_ARG
                    # Bei mehreren -p Argumenten zählt nur das letzte.
                    argv_package = arg;
                    break;
                  case 'x': # LISP-Expression ausführen
                    OPTION_ARG
                    if (!(argv_expr == NULL)) goto usage;
                    argv_expr = arg;
                    break;
                  case '-': # -- Optionen im GNU-Stil
                    if (asciz_equal(&arg[2],"help"))
                      goto usage;
                    elif (asciz_equal(&arg[2],"version"))
                      { if (!(argv_expr == NULL)) goto usage;
                        argv_quiet = TRUE;
                        argv_expr = "(PROGN (FORMAT T \"CLISP ~A\" (LISP-IMPLEMENTATION-VERSION)) (EXIT))";
                        break;
                      }
                    elif (asciz_equal(&arg[2],"quiet") || asciz_equal(&arg[2],"silent"))
                      { argv_quiet = TRUE; break; }
                    else
                      goto usage; # Unbekannte Option
                    break;
                  default: # Unbekannte Option
                    goto usage;
            }   }
            else
            # keine Option,
            # wird als zu ladendes / zu compilerendes File interpretiert
            { switch (argv_for)
                { case for_init:
                    argv_init_files[argv_init_filecount++] = arg; break;
                  case for_compile:
                    argv_compile_files[argv_compile_filecount].input_file = arg;
                    argv_compile_files[argv_compile_filecount].output_file = NULL;
                    argv_compile_filecount++;
                    break;
                  case illegal:
                  default:
                    goto usage;
            }   }
        }
      # Optionen semantisch überprüfen und Defaults eintragen:
      if (argv_memneed == 0)
        #if defined(SPVW_MIXED_BLOCKS_OPPOSITE) && defined(GENERATIONAL_GC)
        # Wegen GENERATIONAL_GC wird der Speicherbereich kaum ausgeschöpft.
        { argv_memneed = 3584*1024*sizeof(object); } # 3584 KW = 14 MB Default
        #else 
        # normalerweise
        { argv_memneed = 512*1024*sizeof(object); } # 512 KW = 2 MB Default
        #endif
      #ifdef MULTIMAP_MEMORY_VIA_FILE
      if (argv_tmpdir == NULL)
        { argv_tmpdir = getenv("TMPDIR"); # Environment-Variable probieren
          if (argv_tmpdir == NULL)
            { argv_tmpdir = "/tmp"; }
        }
      #endif
      if (!argv_compile)
        # Manche Optionen sind nur zusammen mit '-c' sinnvoll:
        { if (argv_compile_listing) goto usage; }
        else
        # Andere Optionen sind nur ohne '-c' sinnvoll:
        { if (!(argv_expr == NULL)) goto usage; }
     }
     #ifndef LANGUAGE_STATIC
     init_language(argv_language);
     #ifdef ENABLE_NLS
     setlocale (LC_ALL,"");
     if (language == language_deutsch)
      { setenv_ ("LANG","de");
        setlocale (LC_MESSAGES,"de");
      }
     elif (language == language_english) 
       { # setenv_ ("LANG","en");
         setlocale (LC_MESSAGES,"en");
       }
     elif (language == language_francais) 
       { setenv_ ("LANG","fr");
         setlocale (LC_MESSAGES,"fr");
       }
     else
       { # setenv_ ("LANG","en");
         setlocale (LC_MESSAGES, "en");
       }
     if (argv_localedir == NULL)
       argv_localedir = LOCALEDIR;
     { var struct stat statbuf;
       if (stat(argv_localedir,&statbuf) >= 0)
         {
           bindtextdomain (PACKAGE,argv_localedir);
           textdomain(PACKAGE);
         }
     }
     #endif
     #endif
     # Tabelle von Fehlermeldungen initialisieren:
     if (init_errormsg_table()<0) goto no_mem;
     # <ctype.h>-Funktionen 8-bit clean machen, sofern die Environment-Variable
     # LC_CTYPE passend gesetzt ist:
     # (Wir verwenden diese Funktionen zwar nicht direkt, aber Zusatzmodule wie
     # z.B. regexp profitieren davon.)
     #ifdef HAVE_LOCALE_H
     { var reg1 const char * locale;
       { locale = getenv("CLISP_LC_CTYPE");
         if (!locale)
           { locale = getenv("GNU_LC_CTYPE");
             if (!locale)
               { locale = getenv("LC_CTYPE"); }
       }   }
       if (locale)
         { setlocale(LC_CTYPE,locale); }
     }
     #endif
     # Speicher holen:
     #ifdef SPVW_PURE
     { var reg1 uintL heapnr;
       for (heapnr=0; heapnr<heapcount; heapnr++)
         { switch (heapnr)
             { # NB: IMMUTABLE spielt hier keine Rolle, denn die Heaps zu
               # case_imm_array  und  case imm_cons_type  werden immer leer
               # bleiben, da für sie keine allocate()-Anforderungen kommen.
               case_sstring:
               case_sbvector:
               case_bignum:
               #ifndef WIDE
               case_ffloat:
               #endif
               case_dfloat:
               case_lfloat:
                 mem.heaptype[heapnr] = 2; break;
               case_ostring:
               case_obvector:
               case_vector:
               case_array1:
               case_record:
               case_symbol:
                 mem.heaptype[heapnr] = 1; break;
               case_cons:
               case_ratio:
               case_complex:
                 mem.heaptype[heapnr] = 0; break;
               default:
                 mem.heaptype[heapnr] = -1; break;
         }   }
     }
     init_speicher_laengen();
     #endif
     #if defined(SPVW_MIXED_BLOCKS) && defined(GENERATIONAL_GC)
     { var reg1 uintL type;
       for (type = 0; type < typecount; type++)
         {
           #ifdef MULTIMAP_MEMORY
           switch (type)
             { MM_TYPECASES break;
               default: mem.heapnr_from_type[type] = -1; continue;
             }
           #endif
           switch (type)
             { case_cons: case_ratio: case_complex: mem.heapnr_from_type[type] = 1; break;
               default:                             mem.heapnr_from_type[type] = 0; break;
     }   }   }
     #endif
     #ifdef MAP_MEMORY_TABLES
     # total_subr_anz bestimmen:
     { var reg2 uintC total = 0;
       var reg1 module_* module;
       for_modules(all_modules, { total += *module->stab_size; } );
       total_subr_anz = total;
     }
     #endif
     {# Aufteilung des Gesamtspeichers in Teile:
      #define teile             16  # 16/16
        #ifdef NO_SP_MALLOC # wird SP vom Betriebssystem bereitgestellt?
        #define teile_SP         0
        #else
        #define teile_SP         2  # 2/16 (1/16 reicht oft nicht)
        #endif
        #define teile_STACK      2  # 2/16
        #ifdef HAVE_NUM_STACK
        #define teile_NUM_STACK  1  # 1/16
        #else
        #define teile_NUM_STACK  0
        #endif
        #define teile_stacks     (teile_SP + teile_STACK + teile_NUM_STACK)
        #ifdef SPVW_MIXED_BLOCKS
        #define teile_objects    (teile - teile_stacks)  # Rest
        #else
        #define teile_objects    0
        #endif
      var reg4 uintL pagesize = # Länge einer Speicherseite
        #if defined(MULTIMAP_MEMORY_VIA_FILE)
        getpagesize()
        #elif defined(MULTIMAP_MEMORY_VIA_SHM)
        SHMLBA
        #elif (defined(SINGLEMAP_MEMORY) || defined(TRIVIALMAP_MEMORY)) && defined(HAVE_MACH_VM)
        vm_page_size
        #elif defined(GENERATIONAL_GC)
          # UNIX_SUNOS5 hat doch tatsächlich mmap(), aber kein getpagesize() !
          #if defined(HAVE_GETPAGESIZE)
          getpagesize()
          #elif defined(UNIX_SUNOS5)
          PAGESIZE # siehe <sys/param.h>
          #else
          ??
          #endif
        #else # wenn die System-Speicherseiten-Länge keine Rolle spielt
        teile*varobject_alignment
        #endif
        ;
      var reg5 uintL memneed = argv_memneed; # benötigter Speicher
      var reg6 aint memblock; # untere Adresse des bereitgestellten Speicherblocks
      #ifndef SPVW_MIXED_BLOCKS_OPPOSITE
      memneed = teile_stacks*floor(memneed,teile); # noch keinen Speicher für objects berechnen
      #undef teile
      #define teile  teile_stacks
      #endif
      #ifndef NO_SP_MALLOC
      if (!(argv_stackneed==0))
        { memneed = memneed*(teile-teile_SP)/teile;
          # Die mit Option -s angegebene SP-Größe ist noch nicht in memneed inbegriffen.
          memneed = memneed + argv_stackneed;
        }
      #endif
      #if defined(MULTIMAP_MEMORY_VIA_SHM) && (defined(UNIX_SUNOS4) || defined(UNIX_SUNOS5))
      # SunOS 4 weigert sich, ein shmat() in einen vorher mallozierten Bereich
      # hinein zu machen, selbst wenn dawischen ein munmap() liegt:
      # errno = EINVAL. Auch das Umgekehrte, erst shmat() zu machen und dann
      # mit sbrk() oder brk() den belegten Bereich dem Datensegment einzu-
      # verleiben, scheitert mit errno = ENOMEM.
      # Der einzige Ausweg ist, sich den benötigten Speicher von weit weg,
      # möglichst außer Reichweite von malloc(), zu holen.
      { var reg1 uintL memhave = round_down(bit(oint_addr_len) - (aint)sbrk(0),SHMLBA);
        if (memhave < memneed) { memneed = memhave; }
        memblock = round_down(bit(oint_addr_len) - memneed,SHMLBA);
      }
      #else
      loop
        { memblock = (aint)mymalloc(memneed); # Speicher allozieren versuchen
          if (!((void*)memblock == NULL)) break; # gelungen -> OK
          memneed = floor(memneed,8)*7; # sonst mit 7/8 davon nochmals versuchen
          if (memneed < MINIMUM_SPACE+RESERVE) # aber mit weniger als MINIMUM_SPACE
            # geben wir uns nicht zufrieden:
            {
              //: DEUTSCH "Nur "
              //: ENGLISH "Only "
              //: FRANCAIS "Seuls "
              asciz_out(GETTEXT("only"));
              dez_out(memneed);
              //: DEUTSCH " Bytes verfügbar."
              //: ENGLISH " bytes available."
              //: FRANCAIS " octets libres."
              asciz_out(GETTEXT("bytes available"));
              asciz_out(CRLFstring);
              goto no_mem;
        }   }
      #endif
      #ifdef MULTIMAP_MEMORY
      # Wir brauchen zwar nur diesen Adreßraum und nicht seinen Inhalt, dürfen
      # ihn aber nicht freigeben, da er in unserer Kontrolle bleiben soll.
      #endif
      # Aufrunden zur nächsten Speicherseitengrenze:
      {var reg1 uintL unaligned = (uintL)(-memblock) % pagesize;
       memblock += unaligned; memneed -= unaligned;
      }
      # Abrunden zur letzen Speicherseitengrenze:
      {var reg1 uintL unaligned = memneed % pagesize;
       memneed -= unaligned;
      }
      # Der Speicherbereich [memblock,memblock+memneed-1] ist nun frei,
      # und seine Grenzen liegen auf Speicherseitengrenzen.
      #ifdef MULTIMAP_MEMORY
        map_pagesize = pagesize;
        #ifdef MULTIMAP_MEMORY_VIA_FILE
        if ( initmap(argv_tmpdir) <0) goto no_mem;
        #else
        if ( initmap() <0) goto no_mem;
        #endif
        #ifdef NORMAL_MULTIMAP_MEMORY
        multimap(case_machine: MM_TYPECASES, IMM_TYPECASES, TRUE, memblock, memneed, FALSE);
        #else # MINIMAL_MULTIMAP_MEMORY
        multimap(case_machine: case imm_type:, case imm_type:, TRUE, memblock, memneed, FALSE);
        #endif
        #ifdef MAP_MEMORY_TABLES
        # Dazu noch symbol_tab an die Adresse 0 legen:
        {var reg3 uintL memneed = round_up(sizeof(symbol_tab),pagesize); # Länge aufrunden
         multimap(case_symbolflagged: ,_EMA_, FALSE, 0, memneed, FALSE);
        }
        # Dazu noch subr_tab an die Adresse 0 legen:
        if ( zeromap(&subr_tab,round_up(total_subr_anz*sizeof(subr_),pagesize)) <0) goto no_mem;
        #elif defined(NORMAL_MULTIMAP_MEMORY)
        # Dazu noch symbol_tab und subr_tab multimappen:
        # Die symbol_tab und subr_tab behalten dabei ihre Adresse. Der Bereich,
        # in dem sie liegen (im Datensegment des Programms!!), wird zu Shared
        # Memory bzw. Shared-mmap-Attach gemacht. Was für ein Hack!
        # Dies ist mit der Existenz externer Module unvereinbar! ??
        {var reg5 aint symbol_tab_start = round_down((aint)&symbol_tab,pagesize);
         var reg6 aint symbol_tab_end = round_up((aint)&symbol_tab+sizeof(symbol_tab),pagesize);
         var reg7 aint subr_tab_start = round_down((aint)&subr_tab,pagesize);
         var reg8 aint subr_tab_end = round_up((aint)&subr_tab+sizeof(subr_tab),pagesize);
         if ((symbol_tab_end <= subr_tab_start) || (subr_tab_end <= symbol_tab_start))
           # zwei getrennte Intervalle
           { multimap(case_machine: case_symbolflagged: ,_EMA_, FALSE, symbol_tab_start, symbol_tab_end-symbol_tab_start, TRUE);
             multimap(case_machine: case_subr: ,_EMA_, FALSE, subr_tab_start, subr_tab_end-subr_tab_start, TRUE);
           }
           else
           # die Tabellen überlappen sich!
           { var reg3 aint tab_start = (symbol_tab_start < subr_tab_start ? symbol_tab_start : subr_tab_start);
             var reg4 aint tab_end = (symbol_tab_end > subr_tab_end ? symbol_tab_end : subr_tab_end);
             multimap(case_machine: case_symbolflagged: case_subr: ,_EMA_, FALSE, tab_start, tab_end-tab_start, TRUE);
           }
        }
        #endif
        #ifdef MULTIMAP_MEMORY_VIA_FILE
        if ( CLOSE(zero_fd) <0)
          { 
            //: DEUTSCH "Kann /dev/zero nicht schließen."
            //: ENGLISH "Cannot close /dev/zero ."
            //: FRANCAIS "Ne peux pas fermer /dev/zero ."
            asciz_out(GETTEXT("cannot close /dev/zero"));
            errno_out(errno);
            goto no_mem;
          }
        #endif
      #endif
      #if defined(SINGLEMAP_MEMORY) || defined(TRIVIALMAP_MEMORY) # <==> SPVW_PURE_BLOCKS || TRIVIALMAP_MEMORY
        map_pagesize = # Länge einer Hardware-Speicherseite
          # UNIX_SUNOS5 hat doch tatsächlich mmap(), aber kein getpagesize() !
          #if defined(HAVE_GETPAGESIZE)
          getpagesize()
          #elif defined(HAVE_MACH_VM)
          vm_page_size
          #elif defined(HAVE_SHM)
          SHMLBA
          #elif defined(UNIX_SUNOS5)
          PAGESIZE # siehe <sys/param.h>
          #else
          4096
          #endif
          ;
        if ( initmap() <0) goto no_mem;
        #ifdef SINGLEMAP_MEMORY
        # Alle Heaps vor-initialisieren:
        { var reg2 uintL heapnr;
          for (heapnr=0; heapnr<heapcount; heapnr++)
            { var reg1 Heap* heapptr = &mem.heaps[heapnr];
              heapptr->heap_limit = (aint)type_zero_oint(heapnr);
        }   }
        # Dazu noch symbol_tab, subr_tab an die Adresse 0 legen:
        # (Hierzu muß case_symbolflagged mit case_symbol äquivalent sein!)
        #define map_tab(tab,size)  \
          { var reg1 uintL map_len = round_up(size,map_pagesize); \
            if ( zeromap(&tab,map_len) <0) goto no_mem;           \
            mem.heaps[typecode(as_object((oint)&tab))].heap_limit += map_len; \
          }
        map_tab(symbol_tab,sizeof(symbol_tab));
        map_tab(subr_tab,total_subr_anz*sizeof(subr_));
        #endif
        #ifdef TRIVIALMAP_MEMORY
        # Alle Heaps als leer initialisieren.
        # Dabei den gesamten zur Verfügung stehenden Platz im Verhältnis 1:1 aufteilen.
        { var reg3 void* malloc_addr = malloc(1);
          var reg1 aint start = round_up((aint)malloc_addr+1*1024*1024,map_pagesize); # 1 MB Reserve für malloc()
          #if !defined(SUN4_29)
          var reg2 aint end = bitm(oint_addr_len+addr_shift);
          #else # defined(SUN4_29) -> Zugriff nur auf Adressen < 2^29 möglich
          var reg2 aint end = bitm(oint_addr_len+addr_shift < 29 ? oint_addr_len+addr_shift : 29);
          #endif
          mem.heaps[0].heap_limit = start;
          mem.heaps[1].heap_limit = start + round_down(floor(end-start,2),map_pagesize);
          free(malloc_addr);
        }
        #endif
        # Alle Heaps als leer initialisieren:
        { var reg2 uintL heapnr;
          for (heapnr=0; heapnr<heapcount; heapnr++)
            { var reg1 Heap* heapptr = &mem.heaps[heapnr];
              heapptr->heap_start = heapptr->heap_end = heapptr->heap_limit;
              #ifdef GENERATIONAL_GC
              heapptr->heap_gen0_start = heapptr->heap_gen0_end = heapptr->heap_gen1_start = heapptr->heap_limit;
              heapptr->physpages = NULL;
              #endif
        }   }
       #ifdef SINGLEMAP_MEMORY_STACK
        # STACK initialisieren:
        { var reg1 uintL map_len = round_up(memneed * teile_STACK/teile, map_pagesize);
          # Der Stack belegt das Intervall von 0 bis map_len bei Typcode = system_type:
          var reg2 aint low = (aint)type_zero_oint(system_type);
          var reg3 aint high = low + map_len;
          if ( zeromap((void*)low,map_len) <0) goto no_mem;
          #ifdef STACK_DOWN
            STACK_bound = (object*)(low + 0x100); # 64 Pointer Sicherheitsmarge
            setSTACK(STACK = (object*)high); # STACK initialisieren
          #endif
          #ifdef STACK_UP
            setSTACK(STACK = (object*)low); # STACK initialisieren
            STACK_bound = (object*)(high - 0x100); # 64 Pointer Sicherheitsmarge
          #endif
        }
        #undef teile_STACK
        #define teile_STACK 0  # brauche keinen Platz mehr für den STACK
        #if (teile==0)
          #undef teile
          #define teile 1  # Division durch 0 vermeiden
        #endif
       #endif
      #endif
      #ifdef GENERATIONAL_GC
      #ifdef MAP_MEMORY
      physpagesize = map_pagesize;
      #else
      physpagesize = pagesize;
      #endif
      # physpageshift = log2(physpagesize);
      { var reg1 uintL x = physpagesize;
        var reg2 uintL i = 0;
        until ((x >>= 1) == 0) { i++; }
        if (!((1UL << i) == physpagesize)) abort();
        physpageshift = i;
      }
      #endif
      # Speicherblock aufteilen:
      { var reg3 uintL free_reserved; # Anzahl reservierter Bytes
        #ifndef NO_SP_MALLOC
        var reg10 void* initial_SP; # Initialwert für SP-Stackpointer
        var reg9 uintL for_SP = 0; # Anzahl Bytes für SP-Stack
        #define min_for_SP  40000 # minimale SP-Stack-Größe
        #endif
        var reg7 uintL for_STACK; # Anzahl Bytes für Lisp-STACK
        var reg9 uintL for_NUM_STACK; # Anzahl Bytes für Zahlen-STACK
        var reg8 uintL for_objects; # Anzahl Bytes für Lisp-Objekte
        # Der STACK braucht Alignment, da bei Frame-Pointern das letzte Bit =0 sein muß:
        #define STACK_alignment  bit(addr_shift+1)
        #define alignment  (varobject_alignment>STACK_alignment ? varobject_alignment : STACK_alignment)
        free_reserved = memneed;
        #ifndef NO_SP_MALLOC
        if (!(argv_stackneed==0))
          if (2*argv_stackneed <= free_reserved) # nicht zu viel für den SP-Stack reservieren
            { for_SP = round_down(argv_stackneed,varobject_alignment);
              free_reserved -= argv_stackneed;
            }
        #endif
        # Durch teile*alignment teilbar machen, damit jedes Sechzehntel aligned ist:
        free_reserved = round_down(free_reserved,teile*alignment);
        free_reserved = free_reserved - RESERVE;
       {var reg2 uintL teil = free_reserved/teile; # ein Teilblock, ein Sechzehntel des Platzes
        var reg1 aint ptr = memblock;
        mem.MEMBOT = ptr;
        #ifndef NO_SP_MALLOC
        # SP allozieren:
        if (for_SP==0)
          { for_SP = teile_SP*teil; } # 2/16 für Programmstack
          else
          # Platz für SP ist schon abgezwackt.
          { # teile := teile-teile_SP; # geht nicht mehr, stattdessen:
            teil = round_down(free_reserved/(teile-teile_SP),alignment);
          }
        if (for_SP < min_for_SP) { for_SP = round_up(min_for_SP,alignment); } # aber nicht zu wenig
        #ifdef SP_DOWN
          SP_bound = (void*)(ptr + 0x800); # 512 Pointer Sicherheitsmarge
          ptr += for_SP;
          initial_SP = (void*)ptr;
        #endif
        #ifdef SP_UP
          initial_SP = (void*)ptr;
          ptr += for_SP;
          SP_bound = (void*)(ptr - 0x800); # 512 Pointer Sicherheitsmarge
        #endif
        #else
          # The default C stack size is too low on some systems. Enlarge it.
          #ifdef UNIX_NEXTSTEP
            { struct rlimit rl;
              long need = 0x800000; # 8 Megabyte
              getrlimit(RLIMIT_STACK, &rl);
              if (rl.rlim_max < need)
                need = rl.rlim_max;
              if (rl.rlim_cur < need)
                { rl.rlim_cur = need; setrlimit(RLIMIT_STACK,&rl); }
            }
          #endif
        #endif
        # STACK allozieren:
        #ifdef SINGLEMAP_MEMORY_STACK
        for_STACK = 0; # STACK ist schon woanders alloziert.
        #else
        #ifdef STACK_DOWN
          STACK_bound = (object*)(ptr + 0x100); # 64 Pointer Sicherheitsmarge
          ptr += for_STACK = teile_STACK*teil; # 2/16 für Lisp-STACK
          setSTACK(STACK = (object*)ptr); # STACK initialisieren
        #endif
        #ifdef STACK_UP
          setSTACK(STACK = (object*)ptr); # STACK initialisieren
          ptr += for_STACK = teile_STACK*teil; # 2/16 für Lisp-STACK
          STACK_bound = (object*)(ptr - 0x100); # 64 Pointer Sicherheitsmarge
        #endif
        #endif
        #ifdef HAVE_NUM_STACK
        # NUM_STACK allozieren:
        #ifdef NUM_STACK_DOWN
          NUM_STACK_bound = (uintD*)ptr;
          ptr += for_NUM_STACK = teile_NUM_STACK*teil; # 1/16 für Zahlen-STACK
          NUM_STACK = NUM_STACK_normal = (uintD*)round_down(ptr,sizeof(uintD)); # NUM_STACK initialisieren
        #endif
        #ifdef NUM_STACK_UP
          NUM_STACK = NUM_STACK_normal = (uintD*)round_up(ptr,sizeof(uintD)); # NUM_STACK initialisieren
          ptr += for_NUM_STACK = teile_NUM_STACK*teil; # 1/16 für Zahlen-STACK
          NUM_STACK_bound = (uintD*)ptr;
        #endif
        #else
        for_NUM_STACK = 0; # kein Zahlen-Stack vorhanden
        #endif
        #ifdef SPVW_MIXED_BLOCKS_OPPOSITE
        # Nun fangen die Lisp-Objekte an:
        #ifdef GENERATIONAL_GC
        mem.varobjects.heap_gen0_start = mem.varobjects.heap_gen0_end =
          mem.varobjects.heap_gen1_start =
            mem.varobjects.heap_start = (ptr + (physpagesize-1)) & -physpagesize;
        #else
        mem.varobjects.heap_start = ptr;
        #endif
        mem.varobjects.heap_end = mem.varobjects.heap_start; # Noch gibt es keine Objekte variabler Länge
        # Rest (14/16 oder etwas weniger) für Lisp-Objekte:
        for_objects = memblock+free_reserved - ptr; # etwa = teile_objects*teil
        ptr += for_objects;
        #ifdef GENERATIONAL_GC
        mem.conses.heap_gen0_start = mem.conses.heap_gen0_end =
          mem.conses.heap_gen1_end =
            mem.conses.heap_end = ptr & -physpagesize;
        #else
        mem.conses.heap_end = ptr;
        #endif
        mem.conses.heap_start = mem.conses.heap_end; # Noch gibt es keine Conses
        # ptr = memblock+free_reserved, da 2/16 + 14/16 = 1
        # Reservespeicher allozieren:
        ptr += RESERVE;
        # oberes Speicherende erreicht.
        mem.MEMTOP = ptr;
        # Darüber (weit weg) der Maschinenstack.
        #endif
        #if defined(SPVW_PURE_BLOCKS) || defined(TRIVIALMAP_MEMORY) || defined(GENERATIONAL_GC)
        mem.total_room = 0;
        #ifdef GENERATIONAL_GC
        mem.last_gcend_space0 = 0;
        mem.last_gcend_space1 = 0;
        #endif
        #endif
        #ifdef SPVW_PAGES
        for_each_heap(heap, { heap->inuse = EMPTY; } );
        for_each_cons_heap(heap, { heap->lastused = dummy_lastused; } );
        dummy_lastused->page_room = 0;
        mem.free_pages = NULL;
        mem.total_space = 0;
        mem.used_space = 0;
        mem.last_gcend_space = 0;
        mem.gctrigger_space = 0;
        #endif
        # Stacks initialisieren:
        #ifdef NO_SP_MALLOC
          #ifdef AMIGAOS
          { var struct Process * myprocess = (struct Process *)FindTask(NULL);
            var aint original_SP = process->pr_ReturnAddr; # SP beim Programmstart
            # Die Shell legt die Stackgröße vor dem Start auf den SP.
            ptr = original_SP - *(CLISP_ULONG*)original_SP;
            SP_bound = ptr + 0x1000; # 1024 Pointer Sicherheitsmarge
          }
          #endif
        #else
          #ifdef GNU
            # eine kleine Dummy-Aktion, die ein hinausgezögertes Aufräumen des SP
            # zu einem späteren Zeitpunkt verhindert:
            if (mem.MEMBOT) { asciz_out(""); }
          #endif
          #if defined(EMUNIX) && defined(WINDOWS)
          SP_start = SP(); # Für System-Calls müssen wir auf diesen Stack zurück!!
          #endif
          setSP(initial_SP); # SP setzen! Dabei gehen alle lokalen Variablen verloren!
        #endif
        pushSTACK(nullobj); pushSTACK(nullobj); # Zwei Nullpointer als STACKende-Kennung
     }}}
      init_subr_tab_1(); # subr_tab initialisieren
      if (argv_memfile==NULL)
        # Zu-Fuß-Initialisierung:
        { initmem(); 
          set_Symbol_value(S(image_pathname),NIL);
        }
        else
        # Speicherfile laden:
        { loadmem(argv_memfile); 
          pushSTACK(asciz_to_string(argv_memfile));
          funcall(L(parse_namestring),1);
          set_Symbol_value(S(image_pathname),value1);
        }
      init_other_modules_2();
      init_derived_strings();
      # aktuelle Evaluator-Environments auf den Toplevel-Wert setzen:
      aktenv.var_env   = NIL;
      aktenv.fun_env   = NIL;
      aktenv.block_env = NIL;
      aktenv.go_env    = NIL;
      aktenv.decl_env  = O(top_decl_env);
      # Alles fertig initialisiert.
      subr_self = NIL; # irgendein gültiges Lisp-Objekt
      set_break_sem_1(); clr_break_sem_2(); clr_break_sem_3(); clr_break_sem_4();
      everything_ready = TRUE;
      # Interrupt-Handler einrichten:
      #if defined(HAVE_SIGNALS)
        #if defined(SIGWINCH) && !defined(NO_ASYNC_INTERRUPTS)
        # Eine veränderte Größe des Terminal-Fensters soll sich auch sofort
        # in SYS::*PRIN-LINELENGTH* bemerkbar machen:
        SIGNAL(SIGWINCH,&sigwinch_handler);
        #endif
        # Die Größe des Terminal-Fensters auch jetzt beim Programmstart erfragen:
        begin_system_call();
        update_linelength();
        end_system_call();
      #endif
      #if defined(MSDOS) && defined(WINDOWS)
        { var int width;
          var int height;
          get_text_size(main_window,&width,&height);
          if (width > 0)
            { # Wert von SYS::*PRIN-LINELENGTH* verändern:
              set_Symbol_value(S(prin_linelength),fixnum(width-1));
        }   }
      #endif
      #if defined(MSDOS) && !defined(WINDOWS) && !defined(WIN32_DOS)
        # Die Breite des Bildschirms im aktuellen Bildschirm-Modus
        # jetzt beim Programmstart erfragen:
        if (isatty(stdout_handle)) # Standard-Output ein Terminal?
          { extern uintW v_cols(); # siehe STREAM.D
            #ifdef EMUNIX_PORTABEL
            var int scrsize[2];
            var reg1 uintL columns;
            #ifdef EMUNIX_OLD_8d
            if (_osmode == DOS_MODE)
              /* unter DOS */ { columns = v_cols(); }
              else
              /* unter OS/2 */
            #endif
            columns = (_scrsize(&!scrsize), scrsize[0]);
            #else
            var reg1 uintL columns = v_cols();
            #endif
            if (columns > 0)
              { # Wert von SYS::*PRIN-LINELENGTH* verändern:
                set_Symbol_value(S(prin_linelength),fixnum(columns-1));
          }   }
      #endif
      #if defined(AMIGAOS) && 0
        # frage beim console.driver nach??
        if (IsInteractive(Input_handle) && IsInteractive(Output_handle)) # ??
          { var reg1 uintL len;
            var uintB question[4] = { CSI, '0', ' ', 'q' };
            var uintB response[30+1];
            Write(Output_handle,question,4);
            len = Read(Input_handle,response,30);
            response[len] = `\0`; sscanf(&response[5],"%d;%d", &lines, &columns); # ??
          }
      #endif
      #if defined(HAVE_SIGNALS)
      #if defined(UNIX) || defined(EMUNIX) || defined(RISCOS) || defined(WIN32_DOS) || defined(WIN32_UNIX)
        # Ctrl-C-Handler einsetzen:
        SIGNAL(SIGINT,&interrupt_handler);
        #ifdef PENDING_INTERRUPTS
        SIGNAL(SIGALRM,&alarm_handler);
        #endif
        #if defined(IMMUTABLE) || defined(GENERATIONAL_GC)
        install_segv_handler();
        #endif
      #endif
      install_sigcld_handler();
      #endif
      # Zeitvariablen initialisieren:
      init_time();
      # Stream-Variablen initialisieren:
      init_streamvars();
      #ifdef NEXTAPP
      # nxterminal-Stream funktionsfähig machen:
      if (nxterminal_init())
        { final_exitcode = 17; quit(); }
      #endif
      # Break ermöglichen:
      end_system_call();
      clr_break_sem_1();
      # Pathnames initialisieren:
      init_pathnames();
      #ifdef REXX
      # Rexx-Interface initialisieren:
      init_rexx();
      # Auf eine Fehlermeldung im Falle des Scheiterns verzichten wir.
      # Deswegen wollen wir das CLISP doch nicht unbrauchbar machen!
      #endif
      #ifdef DYNAMIC_FFI
      # FFI initialisieren:
      init_ffi();
      #endif
      # Modul-Initialisierungen:
      init_other_modules_3();
      { var reg7 module_* module; # modules durchgehen
        for_modules(all_other_modules,
          { if (module->initfunction2)
              # Initialisierungsfunktion aufrufen:
              (*module->initfunction2)(module);
          });
      }
      # Sonstige Initialisierungen:
      { pushSTACK(Symbol_value(S(init_hooks))); # SYS::*INIT-HOOKS*
        while (mconsp(STACK_0)) # abarbeiten
          { var reg1 object obj = STACK_0;
            STACK_0 = Cdr(obj); funcall(Car(obj),0);
          }
        skipSTACK(1);
      }
      # Begrüßung ausgeben:
      if (!sym_nullp(S(quiet))) # SYS::*QUIET* /= NIL ?
        { argv_quiet = TRUE; } # verhindert die Begrüßung
      if (!argv_quiet)
        { local char* banner[] = { # einige Zeilen à 66 Zeichen
          #  |Spalte 0           |Spalte 20                                    |Spalte 66
            "  i i i i i i i       ooooo    o        ooooooo   ooooo   ooooo   " NLstring,
            "  I I I I I I I      8     8   8           8     8     o  8    8  " NLstring,
            "  I I I I I I I      8         8           8     8        8    8  " NLstring,
            "  I I I I I I I      8         8           8      ooooo   8oooo   " NLstring,
           "  I  \\ `+' /  I      8         8           8           8  8       " NLstring,
           "   \\  `-+-'  /       8     o   8           8     o     8  8       " NLstring,
            "    `-__|__-'         ooooo    8oooooo  ooo8ooo   ooooo   8       " NLstring,
            "        |                                                         " NLstring,
            "  ------+------  Copyright (c) Bruno Haible, Michael Stoll 1992, 1993" NLstring,
            "                 Copyright (c) Bruno Haible, Marcus Daniels 1994, 1995, 1996" NLstring,
            };
          #ifdef AMIGA
          //: DEUTSCH  "                    Amiga-Version: Jörg Höhle                     "
          //: ENGLISH  "                    Amiga version: Jörg Höhle                     "
          //: FRANCAIS "                    version Amiga: Jörg Höhle                     "
          var char* banner2 = GETTEXT("amiga banner");
          #endif
          #ifdef DJUNIX
          //: DEUTSCH  "                    DOS-Portierung: Jürgen Weber, Bruno Haible    "
          //: ENGLISH  "                    DOS port: Jürgen Weber, Bruno Haible          "
          //: FRANCAIS "                    adapté à DOS par Jürgen Weber et Bruno Haible "
          var char* banner2 = GETTEXT("dos banner");
          #endif
          local char* banner3 =
            "                                                                  ";
          var reg3 uintL offset = (posfixnum_to_L(Symbol_value(S(prin_linelength))) >= 73 ? 0 : 20);
          var reg1 char** ptr = &banner[0];
          var reg2 uintC count;
          pushSTACK(var_stream(S(standard_output),strmflags_wr_ch_B)); # auf *STANDARD-OUTPUT*
          dotimesC(count,sizeof(banner)/sizeof(banner[0]),
            { write_sstring(&STACK_0,asciz_to_string(&(*ptr++)[offset])); }
            );
          #if defined(AMIGA) || defined(DJUNIX)
          write_sstring(&STACK_0,asciz_to_string(&banner2[offset]));
          write_sstring(&STACK_0,asciz_to_string(NLstring));
          #endif
          write_sstring(&STACK_0,asciz_to_string(&banner3[offset]));
          write_sstring(&STACK_0,asciz_to_string(NLstring));
          skipSTACK(1);
        }
      if (argv_compile || !(argv_expr == NULL))
        # '-c' oder '-x' angegeben -> LISP läuft im Batch-Modus:
        { # (setq *debug-io*
          #   (make-two-way-stream (make-string-input-stream "") *query-io*)
          # )
          funcall(L(make_concatenated_stream),0); # (MAKE-CONCATENATED-STREAM)
          pushSTACK(value1); # leerer Input-Stream
         {var reg1 object stream = var_stream(S(query_io),strmflags_wr_ch_B);
          set_Symbol_value(S(debug_io),make_twoway_stream(popSTACK(),stream));
        }}
      if (!(argv_package == NULL))
        # (IN-PACKAGE packagename) ausführen:
        { var reg1 object packname = asciz_to_string(argv_package);
          pushSTACK(packname); funcall(L(in_package),1);
        }
      # für jedes initfile (LOAD initfile) ausführen:
      { var reg1 char** fileptr = &argv_init_files[0];
        var reg2 uintL count;
        dotimesL(count,argv_init_filecount,
          { var reg3 object filename = asciz_to_string(*fileptr++);
            pushSTACK(filename); funcall(S(load),1);
          });
      }
      if (argv_compile)
        # für jedes File
        #   (EXIT-ON-ERROR
        #     (APPEASE-CERRORS
        #       (COMPILE-FILE (setq file (MERGE-PATHNAMES file (MERGE-PATHNAMES '#".lsp" (CD))))
        #                     [:OUTPUT-FILE (setq output-file (MERGE-PATHNAMES (MERGE-PATHNAMES output-file (MERGE-PATHNAMES '#".fas" (CD))) file))]
        #                     [:LISTING (MERGE-PATHNAMES '#".lis" (or output-file file))]
        #   ) ) )
        # durchführen:
        { var reg3 argv_compile_file* fileptr = &argv_compile_files[0];
          var reg6 uintL count;
          dotimesL(count,argv_compile_filecount,
            { var reg4 uintC argcount = 1;
              var reg5 object filename = asciz_to_string(fileptr->input_file);
              pushSTACK(S(compile_file));
              pushSTACK(filename);
              pushSTACK(O(source_file_type)); # #".lsp"
              funcall(L(cd),0); pushSTACK(value1); # (CD)
              funcall(L(merge_pathnames),2); # (MERGE-PATHNAMES '#".lsp" (CD))
              pushSTACK(value1);
              funcall(L(merge_pathnames),2); # (MERGE-PATHNAMES file ...)
              pushSTACK(value1);
              if (fileptr->output_file)
                { filename = asciz_to_string(fileptr->output_file);
                  pushSTACK(S(Koutput_file));
                  pushSTACK(filename);
                  pushSTACK(O(compiled_file_type)); # #".fas"
                  funcall(L(cd),0); pushSTACK(value1); # (CD)
                  funcall(L(merge_pathnames),2); # (MERGE-PATHNAMES '#".fas" (CD))
                  pushSTACK(value1);
                  funcall(L(merge_pathnames),2); # (MERGE-PATHNAMES output-file ...)
                  pushSTACK(value1);
                  pushSTACK(STACK_2); # file
                  funcall(L(merge_pathnames),2); # (MERGE-PATHNAMES ... file)
                  pushSTACK(value1);
                  argcount += 2;
                }
              if (argv_compile_listing)
                { pushSTACK(S(Klisting));
                  pushSTACK(O(listing_file_type)); # #".lis"
                  pushSTACK(STACK_2); # (or output-file file)
                  funcall(L(merge_pathnames),2); # (MERGE-PATHNAMES '#".lis" ...)
                  pushSTACK(value1);
                  argcount += 2;
                }
              # Alle Argumente quotieren:
             {var reg1 object* ptr = args_end_pointer;
              var reg2 uintC c;
              dotimesC(c,argcount,
                { pushSTACK(S(quote)); pushSTACK(Before(ptr));
                  BEFORE(ptr) = listof(2);
                });
             }
             {var reg1 object form = listof(1+argcount); # `(COMPILE-FILE ',...)
              pushSTACK(S(batchmode_errors));
              pushSTACK(form);
              form = listof(2); # `(SYS::BATCHMODE-ERRORS (COMPILE-FILE ',...))
              eval_noenv(form); # ausführen
              fileptr++;
            }});
          quit();
        }
      if (!(argv_expr == NULL))
        # *STANDARD-INPUT* auf einen Stream setzen, der argv_expr produziert:
        { pushSTACK(asciz_to_string(argv_expr));
          funcall(L(make_string_input_stream),1);
          set_Symbol_value(S(standard_input),value1);
          # Dann den Driver aufrufen. Stringende -> EOF -> Programmende.
        }
      # Read-Eval-Print-Schleife aufrufen:
      driver();
      quit();
      /*NOTREACHED*/
      # Falls der Speicher nicht ausreichte:
      no_mem:
      asciz_out(program_name); asciz_out(": ");
      //: DEUTSCH "Nicht genug Speicher für LISP"
      //: ENGLISH "Not enough memory for Lisp."
      //: FRANCAIS "Il n'y a pas assez de mémoire pour LISP."
      asciz_out(GETTEXT("not enough memory for Lisp"));
      asciz_out(CRLFstring);
      quit_sofort(1);
      /*NOTREACHED*/
     # Beendigung des Programms durch quit_sofort():
      end_of_main:
      #ifdef MULTIMAP_MEMORY
      exitmap();
      #endif
      FREE_DYNAMIC_ARRAY(argv_compile_files); }
      FREE_DYNAMIC_ARRAY(argv_init_files); }
      #ifdef GRAPHICS_SWITCH
      switch_text_mode(); # Rückkehr zum normalen Text-Modus
      #endif
      #if (defined(UNIX) && !defined(NEXTAPP)) || defined(AMIGAOS) || defined(RISCOS)
      terminal_sane(); # Terminal wieder in Normalzustand schalten
      #endif
      #ifdef DJUNIX
      if (cbrk) { setcbrk(cbrk); } # Ctrl-Break wieder zulassen
      _go32_want_ctrl_break(0); # Ctrl-Break wieder normal
      #endif
      #if defined(UNIX) || (defined(MSDOS) && !defined(WINDOWS)) || defined(RISCOS) || defined(WIN32_UNIX)
        _exit(exitcode);
      #endif
      #ifdef AMIGAOS
        exit_amiga(exitcode ? RETURN_FAIL : RETURN_OK);
      #endif
      # Wenn das nichts geholfen haben sollte:
      return exitcode;
    }}

# LISP-Interpreter verlassen
# > final_exitcode: 0 bei normalem Ende, 1 bei Abbruch
  nonreturning_function(global, quit, (void));
  global boolean final_exitcode = 0;
  global void quit()
    { # Erst den STACK bis STACK-Ende "unwinden":
      value1 = NIL; mv_count=0; # Bei UNWIND-PROTECT-Frames keine Werte retten
      unwind_protect_to_save.fun = (restart)&quit;
      loop
        { # Hört der STACK hier auf?
          if (eq(STACK_0,nullobj) && eq(STACK_1,nullobj)) break;
          if (mtypecode(STACK_0) & bit(frame_bit_t))
            # Bei STACK_0 beginnt ein Frame
            { unwind(); } # Frame auflösen
            else
            # STACK_0 enthält ein normales LISP-Objekt
            { skipSTACK(1); }
        }
      # Dann eine Abschiedsmeldung:
      { funcall(L(fresh_line),0); # (FRESH-LINE [*standard-output*])
        if (!argv_quiet)
          { # (WRITE-LINE "Bye." [*standard-output*]) :
            pushSTACK(OL(bye_string)); funcall(L(write_line),1);
      }   }
      close_all_files(); # alle Files schließen
      #ifdef DYNAMIC_FFI
      exit_ffi(); # FFI herunterfahren
      #endif
      #ifdef REXX
      close_rexx(); # Rexx-Kommunikation herunterfahren
      #endif
      #ifdef NEXTAPP
      nxterminal_exit(); # Terminal-Stream-Kommunikation herunterfahren
      #endif
      quit_sofort(final_exitcode); # Programm verlassen
    }

# ------------------------------------------------------------------------------
#                  Speichern und Laden von MEM-Files

#if defined(UNIX) || defined(DJUNIX) || defined(EMUNIX) || defined(WATCOM) || defined(RISCOS) || defined(WIN32_DOS) || defined(WIN32_UNIX)
  # Betriebssystem-Funktion read sichtbar machen:
    #undef read
#endif

# Flags, von denen das Format eines MEM-Files abhängt:
  local uint32 memflags =
    # Typcodeverteilung:
    #ifdef STANDARD_TYPECODES
      bit(0) |
    #endif
    #ifdef PACKED_TYPECODES
      bit(1) |
    #endif
    #ifdef SEVENBIT_TYPECODES
      bit(2) |
    #endif
    #ifdef SIXBIT_TYPECODES
      bit(3) |
    #endif
    #ifdef case_structure
      bit(4) |
    #endif
    #ifdef case_stream
      bit(5) |
    #endif
    #ifdef IMMUTABLE
      bit(6) |
    #endif
    # Codierung von Zahlen:
    #ifdef FAST_FLOAT
      bit(7) |
    #endif
    #ifdef FAST_DOUBLE
      bit(8) |
    #endif
    # Codierung von Streams:
    #ifdef STRM_WR_SS
      bit(9) |
    #endif
    # Codierung von strmtype:
    #ifdef HANDLES
      bit(10) |
    #endif
    #ifdef KEYBOARD
      bit(11) |
    #endif
    #ifdef SCREEN
      bit(12) |
    #endif
    #ifdef PRINTER
      bit(13) |
    #endif
    #ifdef PIPES
      bit(14) |
    #endif
    #ifdef XSOCKETS
      bit(15) |
    #endif
    #ifdef GENERIC_STREAMS
      bit(16) |
    #endif
    #ifdef SOCKET_STREAMS
      bit(17) |
    #endif
    0;

# Format:
# ein Header:
  typedef struct { uintL _magic; # Erkennung
                     #define memdump_magic  0x70768BD2UL
                   oint _oint_type_mask;
                   oint _oint_addr_mask;
                   tint _cons_type, _complex_type, _symbol_type, _system_type;
                   uintC _varobject_alignment;
                   uintC _hashtable_length;
                   uintC _pathname_length;
                   uintC _intDsize;
                   uint32 _memflags;
                   uintC _module_count;
                   uintL _module_names_size;
                   uintC _fsubr_anz;
                   uintC _pseudofun_anz;
                   uintC _symbol_anz;
                   uintL _page_alignment;
                   aint _subr_tab_addr;
                   aint _symbol_tab_addr;
                   #ifdef SPVW_MIXED_BLOCKS_OPPOSITE
                   aint _mem_varobjects_start;
                   aint _mem_varobjects_end;
                   aint _mem_conses_start;
                   aint _mem_conses_end;
                   #endif
                   #ifndef SPVW_MIXED_BLOCKS_OPPOSITE
                   uintC _heapcount;
                   #endif
                 }
          memdump_header;
  # dann die Modulnamen,
  # dann fsubr_tab, pseudofun_tab, symbol_tab,
  # und zu jedem Modul subr_addr, subr_anz, object_anz, subr_tab, object_tab,
#ifdef SPVW_MIXED_BLOCKS_OPPOSITE
  # dann die Objekte variabler Länge (zwischen mem.varobjects.heap_start und mem.varobjects.heap_end),
  # dann die Conses (zwischen mem.conses.heap_start und mem.conses.heap_end).
#else
  #if defined(SPVW_PURE_BLOCKS) || defined(TRIVIALMAP_MEMORY)
    # dann zu jedem Heap (Block) die Start- und Endadresse,
  #endif
  #ifdef SPVW_PAGES
    # SPVW_PAGES: dann zu jedem Heap die Anzahl der Pages,
    # dann zu jedem Heap und zu jeder Page des Heaps die Start- und Endadresse,
  #endif
  typedef struct { aint _page_start; aint _page_end; } memdump_page;
  # dann der Inhalt der Pages in derselben Reihenfolge.
#endif

# page_alignment = Alignment für die Page-Inhalte im File.
#if ((defined(SPVW_PURE_BLOCKS) && defined(SINGLEMAP_MEMORY)) || defined(TRIVIALMAP_MEMORY)) && defined(HAVE_MMAP)
  #define page_alignment  map_pagesize
  #define WRITE_page_alignment(position)  \
    { var reg4 uintL aligncount = (uintL)(-position) % page_alignment; \
      if (aligncount > 0)                                              \
        { # Ein Stück durchgenullten Speicher besorgen:                \
          var DYNAMIC_ARRAY(reg5,zeroes,uintB,aligncount);             \
          var reg1 uintB* ptr = &zeroes[0];                            \
          var reg2 uintL count;                                        \
          dotimespL(count,aligncount, { *ptr++ = 0; } );               \
          # und schreiben:                                             \
          WRITE(&zeroes[0],aligncount);                                \
          FREE_DYNAMIC_ARRAY(zeroes);                                  \
    }   }
  #define READ_page_alignment(position)  \
    { var reg4 uintL aligncount = (uintL)(-position) % page_alignment; \
      if (aligncount > 0)                                              \
        { var DYNAMIC_ARRAY(reg5,dummy,uintB,aligncount);              \
          READ(&dummy[0],aligncount);                                  \
          FREE_DYNAMIC_ARRAY(dummy);                                   \
    }   }
#else
  #define page_alignment  1
  #define WRITE_page_alignment(position)
  #define READ_page_alignment(position)
#endif

#ifdef AMIGA
  nonreturning_function(local, fehler_device_possibly_full, (object stream));
  local void fehler_device_possibly_full(stream)
    var reg2 object stream;
    {
      pushSTACK(TheStream(stream)->strm_file_truename); # Wert für Slot PATHNAME von FILE-ERROR
      //: DEUTSCH "Datenträger vermutlich voll."
      //: ENGLISH "device possibly full" 
      //: FRANCAIS "Disque peut-être plein."
      fehler(file_error,GETTEXT("device possibly full"));
    }
#endif
#if defined(UNIX) || defined(DJUNIX) || defined(EMUNIX) || defined(WATCOM) || defined(RISCOS)  || defined(WIN32_DOS) || defined(WIN32_UNIX)
  nonreturning_function(local, fehler_device_full, (object stream));
  local void fehler_device_full(stream)
    var reg2 object stream;
    {
      pushSTACK(TheStream(stream)->strm_file_truename); # Wert für Slot PATHNAME von FILE-ERROR
      //: DEUTSCH "Diskette/Platte voll."
      //: ENGLISH "disk full"
      //: FRANCAIS "Disque plein."
      fehler(file_error,GETTEXT("device full"));
    }
#endif

# UP, speichert Speicherabbild auf Diskette
# savemem(stream);
# > object stream: offener File-Output-Stream, wird geschlossen
# kann GC auslösen
  global void savemem (object stream);
  global void savemem(stream)
    var reg4 object stream;
    { # Wir brauchen den Stream nur wegen des für ihn bereitgestellten Handles.
      # Wir müssen ihn aber im Fehlerfalle schließen (der Aufrufer macht kein
      # WITH-OPEN-FILE, sondern nur OPEN). Daher bekommen wir den ganzen
      # Stream übergeben, um ihn schließen zu können.
      var reg3 Handle handle = TheHandle(TheStream(stream)->strm_file_handle);
      pushSTACK(stream); # Stream retten
      # Erst eine GC ausführen:
      gar_col();
      #ifdef AMIGAOS
        #define WRITE(buf,len)  \
          { begin_system_call();                                      \
           {var reg1 sintL ergebnis = Write(handle,(void*)buf,len);   \
            if (!(ergebnis==(sintL)(len)))                            \
              { stream_close(&STACK_0);                               \
                if (ergebnis<0) { OS_error(); } # Fehler aufgetreten? \
                fehler_device_possibly_full(STACK_0);                 \
              }                                                       \
            end_system_call();                                        \
          }}
      #endif
      #if defined(UNIX) || defined(DJUNIX) || defined(EMUNIX) || defined(WATCOM) || defined(RISCOS)  || defined(WIN32_DOS) || defined(WIN32_UNIX)
        #define WRITE(buf,len)  \
          { begin_system_call();                                            \
           {var reg1 sintL ergebnis = full_write(handle,(RW_BUF_T)buf,len); \
            if (!(ergebnis==(sintL)(len)))                                  \
              { stream_close(&STACK_0);                                     \
                if (ergebnis<0) { OS_error(); } # Fehler aufgetreten?       \
                fehler_device_full(STACK_0);                                \
              }                                                             \
            end_system_call();                                              \
          }}
      #endif
      # Grundinformation rausschreiben:
     {var memdump_header header;
      var reg7 uintL module_names_size;
      header._magic = memdump_magic;
      header._oint_type_mask = oint_type_mask;
      header._oint_addr_mask = oint_addr_mask;
      header._cons_type    = cons_type;
      header._complex_type = complex_type;
      header._symbol_type  = symbol_type;
      header._system_type  = system_type;
      header._varobject_alignment = varobject_alignment;
      header._hashtable_length = hashtable_length;
      header._pathname_length = pathname_length;
      header._intDsize = intDsize;
      header._memflags = memflags;
      header._module_count = module_count;
      { var reg1 module_* module;
        module_names_size = 0;
        for_modules(all_modules,
          { module_names_size += asciz_length(module->name)+1; }
          );
        module_names_size = round_up(module_names_size,varobject_alignment);
      }
      header._module_names_size = module_names_size;
      header._fsubr_anz     = fsubr_anz;
      header._pseudofun_anz = pseudofun_anz;
      header._symbol_anz    = symbol_anz;
      header._page_alignment = page_alignment;
      header._subr_tab_addr   = (aint)(&subr_tab);
      header._symbol_tab_addr = (aint)(&symbol_tab);
      #ifdef SPVW_MIXED_BLOCKS_OPPOSITE
      #if !defined(GENERATIONAL_GC)
      header._mem_varobjects_start = mem.varobjects.heap_start;
      header._mem_varobjects_end   = mem.varobjects.heap_end;
      header._mem_conses_start     = mem.conses.heap_start;
      header._mem_conses_end       = mem.conses.heap_end;
      #else # defined(GENERATIONAL_GC)
      header._mem_varobjects_start = mem.varobjects.heap_gen0_start;
      header._mem_varobjects_end   = mem.varobjects.heap_gen0_end;
      header._mem_conses_start     = mem.conses.heap_gen0_start;
      header._mem_conses_end       = mem.conses.heap_gen0_end;
      #endif
      #endif
      #ifndef SPVW_MIXED_BLOCKS_OPPOSITE
      header._heapcount = heapcount;
      #endif
      WRITE(&header,sizeof(header));
      # Modulnamen rausschreiben:
      { var DYNAMIC_ARRAY(_EMA_,module_names_buffer,char,module_names_size);
       {var reg2 char* ptr2 = &module_names_buffer[0];
        var reg3 module_* module;
        var reg4 uintC count;
        for_modules(all_modules,
          { var reg1 char* ptr1 = module->name;
            until ((*ptr2++ = *ptr1++) == '\0') ;
          });
        dotimesC(count,&module_names_buffer[module_names_size] - ptr2,
          { *ptr2++ = 0; }
          );
        WRITE(module_names_buffer,module_names_size);
        FREE_DYNAMIC_ARRAY(module_names_buffer);
      }}
      # fsubr_tab, pseudofun_tab, symbol_tab rausschreiben:
      WRITE(&fsubr_tab,sizeof(fsubr_tab));
      WRITE(&pseudofun_tab,sizeof(pseudofun_tab));
      WRITE(&symbol_tab,sizeof(symbol_tab));
      # Zu jedem Modul subr_addr, subr_anz, object_anz, subr_tab, object_tab rausschreiben:
      { var reg2 module_* module;
        for_modules(all_modules,
          { WRITE(&module->stab,sizeof(subr_*));
            WRITE(module->stab_size,sizeof(uintC));
            WRITE(module->otab_size,sizeof(uintC));
            WRITE(module->stab,*module->stab_size*sizeof(subr_));
            WRITE(module->otab,*module->otab_size*sizeof(object));
          });
      }
      #ifdef SPVW_MIXED_BLOCKS_OPPOSITE
      # Objekte variabler Länge rausschreiben:
      {var reg2 uintL len = header._mem_varobjects_end - header._mem_varobjects_start;
       WRITE(header._mem_varobjects_start,len);
      }
      # Conses rausschreiben:
      {var reg2 uintL len = header._mem_conses_end - header._mem_conses_start;
       WRITE(header._mem_conses_start,len);
      }
      #endif
      #ifndef SPVW_MIXED_BLOCKS_OPPOSITE
      #ifdef SPVW_PAGES
      {var reg6 uintL heapnr;
       for (heapnr=0; heapnr<heapcount; heapnr++)
         { var uintC pagecount = 0;
           map_heap(mem.heaps[heapnr],page, { pagecount++; } );
           WRITE(&pagecount,sizeof(pagecount));
      }  }
      #endif
      {var reg6 uintL heapnr;
       for (heapnr=0; heapnr<heapcount; heapnr++)
         {
           #if !defined(GENERATIONAL_GC)
           map_heap(mem.heaps[heapnr],page,
             { var memdump_page _page;
               _page._page_start = page->page_start;
               _page._page_end = page->page_end;
               WRITE(&_page,sizeof(_page));
             });
           #else # defined(GENERATIONAL_GC)
           var reg4 Heap* heap = &mem.heaps[heapnr];
           var memdump_page _page;
           _page._page_start = heap->heap_gen0_start;
           _page._page_end = heap->heap_gen0_end;
           WRITE(&_page,sizeof(_page));
           #endif
      }  }
      #if (defined(SPVW_PURE_BLOCKS) && defined(SINGLEMAP_MEMORY)) || defined(TRIVIALMAP_MEMORY)
       #if defined(HAVE_MMAP) # sonst ist page_alignment sowieso = 1
        # Alignment verwirklichen:
        { begin_system_call();
         {var reg1 sintL ergebnis = lseek(handle,0,SEEK_CUR); # File-Position holen
          end_system_call();
          if (ergebnis<0) { stream_close(&STACK_0); OS_error(); } # Fehler?
          WRITE_page_alignment(ergebnis);
        }}
       #endif
      #endif
      {var reg6 uintL heapnr;
       for (heapnr=0; heapnr<heapcount; heapnr++)
         {
           #if !defined(GENERATIONAL_GC)
           map_heap(mem.heaps[heapnr],page,
             { var reg2 uintL len = page->page_end - page->page_start;
               WRITE(page->page_start,len);
               WRITE_page_alignment(len);
             });
           #else # defined(GENERATIONAL_GC)
           var reg4 Heap* heap = &mem.heaps[heapnr];
           var reg2 uintL len = heap->heap_gen0_end - heap->heap_gen0_start;
           WRITE(heap->heap_gen0_start,len);
           WRITE_page_alignment(len);
           #endif
      }  }
      #endif
      #undef WRITE
      # Stream schließen (Stream-Buffer ist unverändert, aber dadurch wird
      # auch das Handle beim Betriebssystem geschlossen):
      stream_close(&STACK_0);
      skipSTACK(1);
    }}

# UP, lädt Speicherabbild von Diskette
# loadmem(filename);
# Zerstört alle LISP-Daten.
  #if defined(UNIX) || defined(WIN32_UNIX)
  local void loadmem_from_handle (int handle);
  #endif
  # Aktualisierung eines Objektes im Speicher:
  #ifdef SPVW_MIXED_BLOCKS_OPPOSITE
  local var oint offset_varobjects_o;
  local var oint offset_conses_o;
  #endif
  #ifdef TRIVIALMAP_MEMORY
  local var oint offset_heaps_o[heapcount];
  #define offset_varobjects_o  offset_heaps_o[0]
  #define offset_conses_o      offset_heaps_o[1]
  #endif
  #ifdef SPVW_PAGES
  local var struct { aint old_page_start; oint offset_page_o; } *offset_pages;
  #define addr_mask  ~(((oint_addr_mask>>oint_addr_shift) & ~ (wbit(oint_addr_relevant_len)-1)) << addr_shift) # meist = ~0
  #define pagenr_of(addr)  floor(addr,min_page_size_brutto)
  #define offset_pages_len  (pagenr_of((wbit(oint_addr_relevant_len)-1)<<addr_shift)+1)
  #endif
  #if !defined(SINGLEMAP_MEMORY)
  local var oint offset_symbols_o;
  #if !defined(MULTIMAP_MEMORY_TABLES)
  local var oint old_symbol_tab_o;
  #endif
  #endif
  typedef struct { oint low_o; oint high_o; oint offset_o; } offset_subrs_t;
  local var offset_subrs_t* offset_subrs;
  local var uintC offset_subrs_anz;
  local var struct fsubr_tab_ old_fsubr_tab;
  local var struct pseudofun_tab_ old_pseudofun_tab;
  local void loadmem_aktualisiere (object* objptr);
  local void loadmem_aktualisiere(objptr)
    var reg3 object* objptr;
    { switch (mtypecode(*objptr))
        { case_symbol: # Symbol
            #ifndef SPVW_PURE_BLOCKS
            #if !defined(MULTIMAP_MEMORY_TABLES)
            if (as_oint(*objptr) - old_symbol_tab_o
                < ((oint)sizeof(symbol_tab)<<(oint_addr_shift-addr_shift))
               )
              # Symbol aus symbol_tab
              { *(oint*)objptr += offset_symbols_o; break; }
            #else
            if (as_oint(*objptr) - (oint)(&symbol_tab)
                < (sizeof(symbol_tab)<<(oint_addr_shift-addr_shift))
               )
              # Symbol aus symbol_tab erfährt keine Verschiebung
              { break; }
            #endif
            # sonstige Symbole sind Objekte variabler Länge.
            #endif
          case_array:
          case_record:
          case_bignum:
          #ifndef WIDE
          case_ffloat:
          #endif
          case_dfloat:
          case_lfloat:
  