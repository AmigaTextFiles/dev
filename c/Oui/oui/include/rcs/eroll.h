head	1.1;
access;
symbols;
locks
	dlorre:1.1; strict;
comment	@ * @;


1.1
date	96.08.22.02.05.49;	author dlorre;	state Exp;
branches;
next	;


desc
@Oui.lib -- Object User Interface
Projet créé en 1994
Auteur: Dominique Lorre
@


1.1
log
@Initial revision
@
text
@// eroll.h
// créé le 16/11/94
// auteur : Dominique Lorre

#define RO_Min      (TAG_USER + 1)  // min Value
#define RO_Max      (TAG_USER + 2)  // max Value
#define RO_Level    (TAG_USER + 3)  // level displayed (min<=level<=max)
#define RO_Full     (TAG_USER + 4)  // 360° angle
@
