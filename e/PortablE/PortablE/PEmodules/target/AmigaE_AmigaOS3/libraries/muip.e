OPT NATIVE
PUBLIC MODULE 'target/libraries/mui'
MODULE 'target/exec/types', 'target/dos/dos', 'target/intuition/classes', 'target/intuition/screens', 'target/intuition'
MODULE 'target/exec/libraries', 'target/exec/lists', 'target/exec/nodes', 'target/exec/tasks', 'target/utility/hooks', 'target/graphics/rastport', 'target/graphics/text', 'target/intuition/intuition', 'target/intuition/screens', 'target/intuition/classes', 'target/libraries/iffparse', 'target/utility/tagitem'
{MODULE 'libraries/muip'}

NATIVE {muip_callhook} OBJECT muip_callhook
	{methodid}	methodid	:ULONG
	{hook}	hook	:PTR TO hook
	{param1}	param1	:ULONG /* ... */
ENDOBJECT
NATIVE {muip_export} OBJECT muip_export
	{methodid}	methodid	:ULONG
	{dataspace}	dataspace	:PTR TO INTUIOBJECT
ENDOBJECT
NATIVE {muip_findudata} OBJECT muip_findudata
	{methodid}	methodid	:ULONG
	{udata}	udata	:ULONG
ENDOBJECT
NATIVE {muip_getconfigitem} OBJECT muip_getconfigitem
	{methodid}	methodid	:ULONG
	{id}	id	:ULONG
	{storage}	storage	:PTR TO ULONG
ENDOBJECT
NATIVE {muip_getudata} OBJECT muip_getudata
	{methodid}	methodid	:ULONG
	{udata}	udata	:ULONG
	{attr}	attr	:ULONG
	{storage}	storage	:PTR TO ULONG
ENDOBJECT
NATIVE {muip_import} OBJECT muip_import
	{methodid}	methodid	:ULONG
	{dataspace}	dataspace	:PTR TO INTUIOBJECT
ENDOBJECT
NATIVE {muip_killnotify} OBJECT muip_killnotify
	{methodid}	methodid	:ULONG
	{trigattr}	trigattr	:ULONG
ENDOBJECT
NATIVE {muip_killnotifyobj} OBJECT muip_killnotifyobj
	{methodid}	methodid	:ULONG
	{trigattr}	trigattr	:ULONG
	{dest}	dest	:PTR TO INTUIOBJECT
ENDOBJECT
NATIVE {muip_multiset} OBJECT muip_multiset
	{methodid}	methodid	:ULONG
	{attr}	attr	:ULONG
	{val}	val	:ULONG
	{obj}	obj	:APTR /* ... */
ENDOBJECT
NATIVE {muip_nonotifyset} OBJECT muip_nonotifyset
	{methodid}	methodid	:ULONG
	{attr}	attr	:ULONG
	{format}	format	:ARRAY OF CHAR
	{val}	val	:ULONG /* ... */
ENDOBJECT
NATIVE {muip_notify} OBJECT muip_notify
	{methodid}	methodid	:ULONG
	{trigattr}	trigattr	:ULONG
	{trigval}	trigval	:ULONG
	{destobj}	destobj	:APTR
	{followparams}	followparams	:ULONG /* ... */
ENDOBJECT
NATIVE {muip_set} OBJECT muip_set
	{methodid}	methodid	:ULONG
	{attr}	attr	:ULONG
	{val}	val	:ULONG
ENDOBJECT
NATIVE {muip_setasstring} OBJECT muip_setasstring
	{methodid}	methodid	:ULONG
	{attr}	attr	:ULONG
	{format}	format	:ARRAY OF CHAR
	{val}	val	:ULONG /* ... */
ENDOBJECT
NATIVE {muip_setudata} OBJECT muip_setudata
	{methodid}	methodid	:ULONG
	{udata}	udata	:ULONG
	{attr}	attr	:ULONG
	{val}	val	:ULONG
ENDOBJECT
NATIVE {muip_setudataonce} OBJECT muip_setudataonce
	{methodid}	methodid	:ULONG
	{udata}	udata	:ULONG
	{attr}	attr	:ULONG
	{val}	val	:ULONG
ENDOBJECT
NATIVE {muip_writelong} OBJECT muip_writelong
	{methodid}	methodid	:ULONG
	{val}	val	:ULONG
	{memory}	memory	:PTR TO ULONG
ENDOBJECT
NATIVE {muip_writestring} OBJECT muip_writestring
	{methodid}	methodid	:ULONG
	{str}	str	:ARRAY OF CHAR
	{memory}	memory	:ARRAY OF CHAR
ENDOBJECT

NATIVE {muip_family_addhead} OBJECT muip_family_addhead
	{methodid}	methodid	:ULONG
	{obj}	obj	:PTR TO INTUIOBJECT
ENDOBJECT
NATIVE {muip_family_addtail} OBJECT muip_family_addtail
	{methodid}	methodid	:ULONG
	{obj}	obj	:PTR TO INTUIOBJECT
ENDOBJECT
NATIVE {muip_family_insert} OBJECT muip_family_insert
	{methodid}	methodid	:ULONG
	{obj}	obj	:PTR TO INTUIOBJECT
	{pred}	pred	:PTR TO INTUIOBJECT
ENDOBJECT
NATIVE {muip_family_remove} OBJECT muip_family_remove
	{methodid}	methodid	:ULONG
	{obj}	obj	:PTR TO INTUIOBJECT
ENDOBJECT
NATIVE {muip_family_sort} OBJECT muip_family_sort
	{methodid}	methodid	:ULONG
	{obj}	obj	:ARRAY OF PTR TO INTUIOBJECT
ENDOBJECT
NATIVE {muip_family_transfer} OBJECT muip_family_transfer
	{methodid}	methodid	:ULONG
	{family}	family	:PTR TO INTUIOBJECT
ENDOBJECT

NATIVE {muip_application_aboutmui} OBJECT muip_application_aboutmui
	{methodid}	methodid	:ULONG
	{refwindow}	refwindow	:PTR TO INTUIOBJECT
ENDOBJECT
NATIVE {muip_application_addinputhandler} OBJECT muip_application_addinputhandler
	{methodid}	methodid	:ULONG
	{ihnode}	ihnode	:PTR TO mui_inputhandlernode
ENDOBJECT
NATIVE {muip_application_checkrefresh} OBJECT muip_application_checkrefresh
	{methodid}	methodid	:ULONG
ENDOBJECT
NATIVE {muip_application_getmenucheck} OBJECT muip_application_getmenucheck
	{methodid}	methodid	:ULONG
	{menuid}	menuid	:ULONG
ENDOBJECT
NATIVE {muip_application_getmenustate} OBJECT muip_application_getmenustate
	{methodid}	methodid	:ULONG
	{menuid}	menuid	:ULONG
ENDOBJECT
NATIVE {muip_application_input} OBJECT muip_application_input
	{methodid}	methodid	:ULONG
	{signal}	signal	:PTR TO LONGBITS
ENDOBJECT
NATIVE {muip_application_inputbuffered} OBJECT muip_application_inputbuffered
	{methodid}	methodid	:ULONG
ENDOBJECT
NATIVE {muip_application_load} OBJECT muip_application_load
	{methodid}	methodid	:ULONG
	{name}	name	:/*STRPTR*/ ARRAY OF CHAR
ENDOBJECT
NATIVE {muip_application_newinput} OBJECT muip_application_newinput
	{methodid}	methodid	:ULONG
	{signal}	signal	:PTR TO LONGBITS
ENDOBJECT
NATIVE {muip_application_openconfigwindow} OBJECT muip_application_openconfigwindow
	{methodid}	methodid	:ULONG
	{flags}	flags	:ULONG
ENDOBJECT
NATIVE {muip_application_pushmethod} OBJECT muip_application_pushmethod
	{methodid}	methodid	:ULONG
	{dest}	dest	:PTR TO INTUIOBJECT
	{count}	count	:VALUE /* ... */
ENDOBJECT
NATIVE {muip_application_reminputhandler} OBJECT muip_application_reminputhandler
	{methodid}	methodid	:ULONG
	{ihnode}	ihnode	:PTR TO mui_inputhandlernode
ENDOBJECT
NATIVE {muip_application_returnid} OBJECT muip_application_returnid
	{methodid}	methodid	:ULONG
	{retid}	retid	:ULONG
ENDOBJECT
NATIVE {muip_application_save} OBJECT muip_application_save
	{methodid}	methodid	:ULONG
	{name}	name	:/*STRPTR*/ ARRAY OF CHAR
ENDOBJECT
NATIVE {muip_application_setconfigitem} OBJECT muip_application_setconfigitem
	{methodid}	methodid	:ULONG
	{item}	item	:ULONG
	{data}	data	:APTR
ENDOBJECT
NATIVE {muip_application_setmenucheck} OBJECT muip_application_setmenucheck
	{methodid}	methodid	:ULONG
	{menuid}	menuid	:ULONG
	{stat}	stat	:VALUE
ENDOBJECT
NATIVE {muip_application_setmenustate} OBJECT muip_application_setmenustate
	{methodid}	methodid	:ULONG
	{menuid}	menuid	:ULONG
	{stat}	stat	:VALUE
ENDOBJECT
NATIVE {muip_application_showhelp} OBJECT muip_application_showhelp
	{methodid}	methodid	:ULONG
	{window}	window	:PTR TO INTUIOBJECT
	{name}	name	:ARRAY OF CHAR
	{node}	node	:ARRAY OF CHAR
	{line}	line	:VALUE
ENDOBJECT

NATIVE {muip_window_addeventhandler} OBJECT muip_window_addeventhandler
	{methodid}	methodid	:ULONG
	{ehnode}	ehnode	:PTR TO mui_eventhandlernode
ENDOBJECT
NATIVE {muip_window_getmenucheck} OBJECT muip_window_getmenucheck
	{methodid}	methodid	:ULONG
	{menuid}	menuid	:ULONG
ENDOBJECT
NATIVE {muip_window_getmenustate} OBJECT muip_window_getmenustate
	{methodid}	methodid	:ULONG
	{menuid}	menuid	:ULONG
ENDOBJECT
NATIVE {muip_window_remeventhandler} OBJECT muip_window_remeventhandler
	{methodid}	methodid	:ULONG
	{ehnode}	ehnode	:PTR TO mui_eventhandlernode
ENDOBJECT
NATIVE {muip_window_screentoback} OBJECT muip_window_screentoback
	{methodid}	methodid	:ULONG
ENDOBJECT
NATIVE {muip_window_screentofront} OBJECT muip_window_screentofront
	{methodid}	methodid	:ULONG
ENDOBJECT
NATIVE {muip_window_setcyclechain} OBJECT muip_window_setcyclechain
	{methodid}	methodid	:ULONG
	{obj}	obj	:ARRAY OF PTR TO INTUIOBJECT
ENDOBJECT
NATIVE {muip_window_setmenucheck} OBJECT muip_window_setmenucheck
	{methodid}	methodid	:ULONG
	{menuid}	menuid	:ULONG
	{stat}	stat	:VALUE
ENDOBJECT
NATIVE {muip_window_setmenustate} OBJECT muip_window_setmenustate
	{methodid}	methodid	:ULONG
	{menuid}	menuid	:ULONG
	{stat}	stat	:VALUE
ENDOBJECT
NATIVE {muip_window_snapshot} OBJECT muip_window_snapshot
	{methodid}	methodid	:ULONG
	{flags}	flags	:VALUE
ENDOBJECT
NATIVE {muip_window_toback} OBJECT muip_window_toback
	{methodid}	methodid	:ULONG
ENDOBJECT
NATIVE {muip_window_tofront} OBJECT muip_window_tofront
	{methodid}	methodid	:ULONG
ENDOBJECT

NATIVE {muip_askminmax} OBJECT muip_askminmax
	{methodid}	methodid	:ULONG
	{minmaxinfo}	minmaxinfo	:PTR TO mui_minmax
ENDOBJECT /* Custom Class */
NATIVE {muip_cleanup} OBJECT muip_cleanup
	{methodid}	methodid	:ULONG
ENDOBJECT /* Custom Class */
NATIVE {muip_contextmenubuild} OBJECT muip_contextmenubuild
	{methodid}	methodid	:ULONG
	{mx}	mx	:VALUE
	{my}	my	:VALUE
ENDOBJECT
NATIVE {muip_contextmenuchoice} OBJECT muip_contextmenuchoice
	{methodid}	methodid	:ULONG
	{item}	item	:PTR TO INTUIOBJECT
ENDOBJECT
NATIVE {muip_createbubble} OBJECT muip_createbubble
	{methodid}	methodid	:ULONG
	{x}	x	:VALUE
	{y}	y	:VALUE
	{txt}	txt	:ARRAY OF CHAR
	{flags}	flags	:ULONG
ENDOBJECT
NATIVE {muip_createshorthelp} OBJECT muip_createshorthelp
	{methodid}	methodid	:ULONG
	{mx}	mx	:VALUE
	{my}	my	:VALUE
ENDOBJECT
NATIVE {muip_deletebubble} OBJECT muip_deletebubble
	{methodid}	methodid	:ULONG
	{bubble}	bubble	:APTR
ENDOBJECT
NATIVE {muip_deleteshorthelp} OBJECT muip_deleteshorthelp
	{methodid}	methodid	:ULONG
	{help}	help	:/*STRPTR*/ ARRAY OF CHAR
ENDOBJECT
NATIVE {muip_dragbegin} OBJECT muip_dragbegin
	{methodid}	methodid	:ULONG
	{obj}	obj	:PTR TO INTUIOBJECT
ENDOBJECT
NATIVE {muip_dragdrop} OBJECT muip_dragdrop
	{methodid}	methodid	:ULONG
	{obj}	obj	:PTR TO INTUIOBJECT
	{x}	x	:VALUE
	{y}	y	:VALUE
ENDOBJECT
NATIVE {muip_dragfinish} OBJECT muip_dragfinish
	{methodid}	methodid	:ULONG
	{obj}	obj	:PTR TO INTUIOBJECT
ENDOBJECT
NATIVE {muip_dragquery} OBJECT muip_dragquery
	{methodid}	methodid	:ULONG
	{obj}	obj	:PTR TO INTUIOBJECT
ENDOBJECT
NATIVE {muip_dragreport} OBJECT muip_dragreport
	{methodid}	methodid	:ULONG
	{obj}	obj	:PTR TO INTUIOBJECT
	{x}	x	:VALUE
	{y}	y	:VALUE
	{update}	update	:VALUE
ENDOBJECT
NATIVE {muip_draw} OBJECT muip_draw
	{methodid}	methodid	:ULONG
	{flags}	flags	:ULONG
ENDOBJECT /* Custom Class */
NATIVE {muip_drawbackground} OBJECT muip_drawbackground
	{methodid}	methodid	:ULONG
	{left}	left	:VALUE
	{top}	top	:VALUE
	{width}	width	:VALUE
	{height}	height	:VALUE
	{xoffset}	xoffset	:VALUE
	{yoffset}	yoffset	:VALUE
	{flags}	flags	:VALUE
ENDOBJECT
NATIVE {muip_handleevent} OBJECT muip_handleevent
	{methodid}	methodid	:ULONG
	{imsg}	imsg	:PTR TO intuimessage
	{muikey}	muikey	:VALUE
ENDOBJECT /* Custom Class */
NATIVE {muip_handleinput} OBJECT muip_handleinput
	{methodid}	methodid	:ULONG
	{imsg}	imsg	:PTR TO intuimessage
	{muikey}	muikey	:VALUE
ENDOBJECT /* Custom Class */
NATIVE {muip_hide} OBJECT muip_hide
	{methodid}	methodid	:ULONG
ENDOBJECT /* Custom Class */
NATIVE {muip_setup} OBJECT muip_setup
	{methodid}	methodid	:ULONG
	{renderinfo}	renderinfo	:PTR TO mui_renderinfo
ENDOBJECT /* Custom Class */
OBJECT muip_show
	methodid	:ULONG
ENDOBJECT /* Custom Class */

NATIVE {muip_prop_decrease} OBJECT muip_prop_decrease
	{methodid}	methodid	:ULONG
	{amount}	amount	:VALUE
ENDOBJECT
NATIVE {muip_prop_increase} OBJECT muip_prop_increase
	{methodid}	methodid	:ULONG
	{amount}	amount	:VALUE
ENDOBJECT

NATIVE {muip_list_clear} OBJECT muip_list_clear
	{methodid}	methodid	:ULONG
ENDOBJECT
NATIVE {muip_list_createimage} OBJECT muip_list_createimage
	{methodid}	methodid	:ULONG
	{obj}	obj	:PTR TO INTUIOBJECT
	{flags}	flags	:ULONG
ENDOBJECT
NATIVE {muip_list_deleteimage} OBJECT muip_list_deleteimage
	{methodid}	methodid	:ULONG
	{listimg}	listimg	:APTR
ENDOBJECT
NATIVE {muip_list_exchange} OBJECT muip_list_exchange
	{methodid}	methodid	:ULONG
	{pos1}	pos1	:VALUE
	{pos2}	pos2	:VALUE
ENDOBJECT
NATIVE {muip_list_getentry} OBJECT muip_list_getentry
	{methodid}	methodid	:ULONG
	{pos}	pos	:VALUE
	{entry}	entry	:PTR TO APTR
ENDOBJECT
NATIVE {muip_list_insert} OBJECT muip_list_insert
	{methodid}	methodid	:ULONG
	{entries}	entries	:PTR TO APTR
	{count}	count	:VALUE
	{pos}	pos	:VALUE
ENDOBJECT
NATIVE {muip_list_insertsingle} OBJECT muip_list_insertsingle
	{methodid}	methodid	:ULONG
	{entry}	entry	:APTR
	{pos}	pos	:VALUE
ENDOBJECT
NATIVE {muip_list_jump} OBJECT muip_list_jump
	{methodid}	methodid	:ULONG
	{pos}	pos	:VALUE
ENDOBJECT
NATIVE {muip_list_move} OBJECT muip_list_move
	{methodid}	methodid	:ULONG
	{from}	from	:VALUE
	{to}	to	:VALUE
ENDOBJECT
NATIVE {muip_list_nextselected} OBJECT muip_list_nextselected
	{methodid}	methodid	:ULONG
	{pos}	pos	:PTR TO VALUE
ENDOBJECT
NATIVE {muip_list_redraw} OBJECT muip_list_redraw
	{methodid}	methodid	:ULONG
	{pos}	pos	:VALUE
ENDOBJECT
NATIVE {muip_list_remove} OBJECT muip_list_remove
	{methodid}	methodid	:ULONG
	{pos}	pos	:VALUE
ENDOBJECT
NATIVE {muip_list_select} OBJECT muip_list_select
	{methodid}	methodid	:ULONG
	{pos}	pos	:VALUE
	{seltype}	seltype	:VALUE
	{state}	state	:PTR TO VALUE
ENDOBJECT
NATIVE {muip_list_sort} OBJECT muip_list_sort
	{methodid}	methodid	:ULONG
ENDOBJECT
NATIVE {muip_list_testpos} OBJECT muip_list_testpos
	{methodid}	methodid	:ULONG
	{x}	x	:VALUE
	{y}	y	:VALUE
	{res}	res	:PTR TO mui_list_testpos_result
ENDOBJECT

NATIVE {muip_dirlist_reread} OBJECT muip_dirlist_reread
	{methodid}	methodid	:ULONG
ENDOBJECT

NATIVE {muip_numeric_decrease} OBJECT muip_numeric_decrease
	{methodid}	methodid	:ULONG
	{amount}	amount	:VALUE
ENDOBJECT
NATIVE {muip_numeric_increase} OBJECT muip_numeric_increase
	{methodid}	methodid	:ULONG
	{amount}	amount	:VALUE
ENDOBJECT
NATIVE {muip_numeric_scaletovalue} OBJECT muip_numeric_scaletovalue
	{methodid}	methodid	:ULONG
	{scalemin}	scalemin	:VALUE
	{scalemax}	scalemax	:VALUE
	{scale}	scale	:VALUE
ENDOBJECT
NATIVE {muip_numeric_setdefault} OBJECT muip_numeric_setdefault
	{methodid}	methodid	:ULONG
ENDOBJECT
NATIVE {muip_numeric_stringify} OBJECT muip_numeric_stringify
	{methodid}	methodid	:ULONG
	{value}	value	:VALUE
ENDOBJECT
NATIVE {muip_numeric_valuetoscale} OBJECT muip_numeric_valuetoscale
	{methodid}	methodid	:ULONG
	{scalemin}	scalemin	:VALUE
	{scalemax}	scalemax	:VALUE
ENDOBJECT

NATIVE {muip_pendisplay_setcolormap} OBJECT muip_pendisplay_setcolormap
	{methodid}	methodid	:ULONG
	{colormap}	colormap	:VALUE
ENDOBJECT
NATIVE {muip_pendisplay_setmuipen} OBJECT muip_pendisplay_setmuipen
	{methodid}	methodid	:ULONG
	{muipen}	muipen	:VALUE
ENDOBJECT
NATIVE {muip_pendisplay_setrgb} OBJECT muip_pendisplay_setrgb
	{methodid}	methodid	:ULONG
	{red}	red	:ULONG
	{green}	green	:ULONG
	{blue}	blue	:ULONG
ENDOBJECT

NATIVE {muip_group_exitchange} OBJECT muip_group_exitchange
	{methodid}	methodid	:ULONG
ENDOBJECT
NATIVE {muip_group_initchange} OBJECT muip_group_initchange
	{methodid}	methodid	:ULONG
ENDOBJECT
NATIVE {muip_group_sort} OBJECT muip_group_sort
	{methodid}	methodid	:ULONG
	{obj}	obj	:ARRAY OF PTR TO INTUIOBJECT
ENDOBJECT

NATIVE {muip_settingsgroup_configtogadgets} OBJECT muip_settingsgroup_configtogadgets
	{methodid}	methodid	:ULONG
	{configdata}	configdata	:PTR TO INTUIOBJECT
ENDOBJECT
NATIVE {muip_settingsgroup_gadgetstoconfig} OBJECT muip_settingsgroup_gadgetstoconfig
	{methodid}	methodid	:ULONG
	{configdata}	configdata	:PTR TO INTUIOBJECT
ENDOBJECT

NATIVE {muip_popstring_close} OBJECT muip_popstring_close
	{methodid}	methodid	:ULONG
	{result}	result	:VALUE
ENDOBJECT
NATIVE {muip_popstring_open} OBJECT muip_popstring_open
	{methodid}	methodid	:ULONG
ENDOBJECT

NATIVE {muip_semaphore_attempt} OBJECT muip_semaphore_attempt
	{methodid}	methodid	:ULONG
ENDOBJECT
NATIVE {muip_semaphore_attemptshared} OBJECT muip_semaphore_attemptshared
	{methodid}	methodid	:ULONG
ENDOBJECT
NATIVE {muip_semaphore_obtain} OBJECT muip_semaphore_obtain
	{methodid}	methodid	:ULONG
ENDOBJECT
NATIVE {muip_semaphore_obtainshared} OBJECT muip_semaphore_obtainshared
	{methodid}	methodid	:ULONG
ENDOBJECT
NATIVE {muip_semaphore_release} OBJECT muip_semaphore_release
	{methodid}	methodid	:ULONG
ENDOBJECT

NATIVE {muip_dataspace_add} OBJECT muip_dataspace_add
	{methodid}	methodid	:ULONG
	{data}	data	:APTR
	{len}	len	:VALUE
	{id}	id	:ULONG
ENDOBJECT
NATIVE {muip_dataspace_clear} OBJECT muip_dataspace_clear
	{methodid}	methodid	:ULONG
ENDOBJECT
NATIVE {muip_dataspace_find} OBJECT muip_dataspace_find
	{methodid}	methodid	:ULONG
	{id}	id	:ULONG
ENDOBJECT
NATIVE {muip_dataspace_merge} OBJECT muip_dataspace_merge
	{methodid}	methodid	:ULONG
	{dataspace}	dataspace	:PTR TO INTUIOBJECT
ENDOBJECT
NATIVE {muip_dataspace_readiff} OBJECT muip_dataspace_readiff
	{methodid}	methodid	:ULONG
	{handle}	handle	:PTR TO iffhandle
ENDOBJECT
NATIVE {muip_dataspace_remove} OBJECT muip_dataspace_remove
	{methodid}	methodid	:ULONG
	{id}	id	:ULONG
ENDOBJECT
NATIVE {muip_dataspace_writeiff} OBJECT muip_dataspace_writeiff
	{methodid}	methodid	:ULONG
	{handle}	handle	:PTR TO iffhandle
	{type}	type	:ULONG
	{id}	id	:ULONG
ENDOBJECT
