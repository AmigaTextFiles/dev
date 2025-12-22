OPT MODULE

MODULE 'libraries/mui', 'libraries/iffparse',
       'intuition/intuition',
       'utility/hooks'

EXPORT OBJECT muip_callhook
  methodid:LONG
  hook:PTR TO hook
  param1:LONG
ENDOBJECT

EXPORT OBJECT muip_export
  methodid:LONG
  dataspace:LONG
ENDOBJECT

EXPORT OBJECT muip_findudata
  methodid:LONG
  udata:LONG
ENDOBJECT

EXPORT OBJECT muip_getconfigitem
  methodid:LONG
  id:LONG
  storage:PTR TO LONG
ENDOBJECT

EXPORT OBJECT muip_getudata
  methodid:LONG
  udata:LONG
  attr:LONG
  storage:PTR TO LONG
ENDOBJECT

EXPORT OBJECT muip_import
  methodid:LONG
  dataspace:LONG
ENDOBJECT

EXPORT OBJECT muip_killnotify
  methodid:LONG
  trigattr:LONG
ENDOBJECT

EXPORT OBJECT muip_killnotifyobj
  methodid:LONG
  trigattr:LONG
  dest:LONG
ENDOBJECT

EXPORT OBJECT muip_multiset
  methodid:LONG
  attr:LONG
  val:LONG
  obj:LONG
ENDOBJECT

EXPORT OBJECT muip_nonotifyset
  methodid:LONG
  attr:LONG
  format:PTR TO CHAR
  val:LONG
ENDOBJECT

EXPORT OBJECT muip_notify
  methodid:LONG
  trigattr:LONG
  trigval:LONG
  destobj:LONG
  followparams:LONG
ENDOBJECT

EXPORT OBJECT muip_set
  methodid:LONG
  attr:LONG
  val:LONG
ENDOBJECT

EXPORT OBJECT muip_setasstring
  methodid:LONG
  attr:LONG
  format:PTR TO CHAR
  val:LONG
ENDOBJECT

EXPORT OBJECT muip_setudata
  methodid:LONG
  udata:LONG
  attr:LONG
  val:LONG
ENDOBJECT

EXPORT OBJECT muip_setudataonce
  methodid:LONG
  udata:LONG
  attr:LONG
  val:LONG
ENDOBJECT

EXPORT OBJECT muip_writelong
  methodid:LONG
  val:LONG
  memory:PTR TO LONG
ENDOBJECT

EXPORT OBJECT muip_writestring
  methodid:LONG
  str:PTR TO CHAR
  memory:PTR TO CHAR
ENDOBJECT

EXPORT OBJECT muip_family_addhead
  methodid:LONG
  obj:PTR TO LONG
ENDOBJECT

EXPORT OBJECT muip_family_addtail
  methodid:LONG
  obj:PTR TO LONG
ENDOBJECT

EXPORT OBJECT muip_family_insert
  methodid:LONG
  obj:PTR TO LONG
  pred:PTR TO LONG
ENDOBJECT

EXPORT OBJECT muip_family_remove
  methodid:LONG
  obj:PTR TO LONG
ENDOBJECT

EXPORT OBJECT muip_family_sort
  methodid:LONG
  obj:PTR TO LONG
ENDOBJECT

EXPORT OBJECT muip_family_transfer
  methodid:LONG
  family:PTR TO LONG
ENDOBJECT

EXPORT OBJECT muip_application_aboutmui
  methodid:LONG
  refwindow:LONG
ENDOBJECT

EXPORT OBJECT muip_application_addinputhandler
  methodid:LONG
  ihnode:PTR TO mui_inputhandlernode
ENDOBJECT

EXPORT OBJECT muip_application_checkrefresh
  methodid:LONG
ENDOBJECT

EXPORT OBJECT muip_application_getmenucheck
  methodid:LONG
  menuid:LONG
ENDOBJECT

EXPORT OBJECT muip_application_getmenustate
  methodid:LONG
  menuid:LONG
ENDOBJECT

EXPORT OBJECT muip_application_input
  methodid:LONG
  signal:LONG
ENDOBJECT

EXPORT OBJECT muip_application_inputbuffered
  methodid:LONG
ENDOBJECT

EXPORT OBJECT muip_application_load
  methodid:LONG
  name:LONG
ENDOBJECT

EXPORT OBJECT muip_application_newinput
  methodid:LONG
  signal:LONG
ENDOBJECT

EXPORT OBJECT muip_application_openconfigwindow
  methodid:LONG
  flags:LONG
ENDOBJECT

EXPORT OBJECT muip_application_pushmethod
  methodid:LONG
  dest:LONG
  count:LONG
ENDOBJECT

EXPORT OBJECT muip_application_reminputhandler
  methodid:LONG
  ihnode:PTR TO mui_inputhandlernode
ENDOBJECT

EXPORT OBJECT muip_application_returnid
  methodid:LONG
  retid:LONG
ENDOBJECT

EXPORT OBJECT muip_application_save
  methodid:LONG
  name:LONG
ENDOBJECT

EXPORT OBJECT muip_application_setconfigitem
  methodid:LONG
  item:LONG
  data:LONG
ENDOBJECT

EXPORT OBJECT muip_application_setmenucheck
  methodid:LONG
  menuid:LONG
  stat:LONG
ENDOBJECT

EXPORT OBJECT muip_application_setmenustate
  methodid:LONG
  menuid:LONG
  stat:LONG
ENDOBJECT

EXPORT OBJECT muip_application_showhelp
  methodid:LONG
  window:LONG
  name:PTR TO CHAR
  node:PTR TO CHAR
  line:LONG
ENDOBJECT

EXPORT OBJECT muip_window_addeventhandler
  methodid:LONG
  ehnode:PTR TO mui_eventhandlernode
ENDOBJECT

EXPORT OBJECT muip_window_getmenucheck
  methodid:LONG
  menuid:LONG
ENDOBJECT

EXPORT OBJECT muip_window_getmenustate
  methodid:LONG
  menuid:LONG
ENDOBJECT

EXPORT OBJECT muip_window_remeventhandler
  methodid:LONG
  ehnode:PTR TO mui_eventhandlernode
ENDOBJECT

EXPORT OBJECT muip_window_screentoback
  methodid:LONG
ENDOBJECT

EXPORT OBJECT muip_window_screentofront
  methodid:LONG
ENDOBJECT

EXPORT OBJECT muip_window_setcyclechain
  methodid:LONG
  obj:LONG
ENDOBJECT

EXPORT OBJECT muip_window_setmenucheck
  methodid:LONG
  menuid:LONG
  stat:LONG
ENDOBJECT

EXPORT OBJECT muip_window_setmenustate
  methodid:LONG
  menuid:LONG
  stat:LONG
ENDOBJECT

EXPORT OBJECT muip_window_snapshot
  methodid:LONG
  flags:LONG
ENDOBJECT

EXPORT OBJECT muip_window_toback
  methodid:LONG
ENDOBJECT

EXPORT OBJECT muip_window_tofront
  methodid:LONG
ENDOBJECT

EXPORT OBJECT muip_askminmax
  methodid:LONG
  minmaxinfo:PTR TO mui_minmax
ENDOBJECT

EXPORT OBJECT muip_cleanup
  methodid:LONG
ENDOBJECT

EXPORT OBJECT muip_contextmenubuild
  methodid:LONG
  mx:LONG
  my:LONG
ENDOBJECT

EXPORT OBJECT muip_contextmenuchoice
  methodid:LONG
  item:LONG
ENDOBJECT

EXPORT OBJECT muip_createbubble
  methodid:LONG
  x:LONG
  y:LONG
  txt:PTR TO CHAR
  flags:LONG
ENDOBJECT

EXPORT OBJECT muip_createshorthelp
  methodid:LONG
  mx:LONG
  my:LONG
ENDOBJECT

EXPORT OBJECT muip_deletebubble
  methodid:LONG
  bubble:LONG
ENDOBJECT

EXPORT OBJECT muip_deleteshorthelp
  methodid:LONG
  help:LONG
ENDOBJECT

EXPORT OBJECT muip_dragbegin
  methodid:LONG
  obj:LONG
ENDOBJECT

EXPORT OBJECT muip_dragdrop
  methodid:LONG
  obj:LONG
  x:LONG
  y:LONG
ENDOBJECT

EXPORT OBJECT muip_dragfinish
  methodid:LONG
  obj:LONG
ENDOBJECT

EXPORT OBJECT muip_dragquery
  methodid:LONG
  obj:LONG
ENDOBJECT

EXPORT OBJECT muip_dragreport
  methodid:LONG
  obj:LONG
  x:LONG
  y:LONG
  update:LONG
ENDOBJECT

EXPORT OBJECT muip_draw
  methodid:LONG
  flags:LONG
ENDOBJECT

EXPORT OBJECT  muip_drawbackground
  methodid:LONG
  left:LONG
  top:LONG
  width:LONG
  height:LONG
  xoffset:LONG
  yoffset:LONG
  flags:LONG
ENDOBJECT

EXPORT OBJECT muip_handleevent
  methodid:LONG
  imsg:PTR TO intuimessage
  muikey:LONG
ENDOBJECT

EXPORT OBJECT muip_handleinput
  methodid:LONG
  imsg:PTR TO intuimessage
  muikey:LONG
ENDOBJECT

EXPORT OBJECT muip_hide
  methodid:LONG
ENDOBJECT

EXPORT OBJECT muip_setup
  methodid:LONG
  renderinfo:PTR TO mui_renderinfo
ENDOBJECT

EXPORT OBJECT muip_prop_decrease
  methodid:LONG
  amount:LONG
ENDOBJECT

EXPORT OBJECT muip_prop_increase
  methodid:LONG
  amount:LONG
ENDOBJECT

EXPORT OBJECT muip_list_clear
  methodid:LONG
ENDOBJECT


EXPORT OBJECT muip_list_createimage
  methodid:LONG
  obj:LONG
  flags:LONG
ENDOBJECT

EXPORT OBJECT muip_list_deleteimage
  methodid:LONG
  listimg:LONG
ENDOBJECT

EXPORT OBJECT muip_list_exchange
  methodid:LONG
  pos1:LONG
  pos2:LONG
ENDOBJECT

EXPORT OBJECT muip_list_getentry
  methodid:LONG
  pos:LONG
  entry:PTR TO LONG
ENDOBJECT

EXPORT OBJECT muip_list_insert
  methodid:LONG
  entries:PTR TO LONG
  count:LONG
  pos:LONG
ENDOBJECT

EXPORT OBJECT muip_list_insertsingle
  methodid:LONG
  entry:LONG
  pos:LONG
ENDOBJECT

EXPORT OBJECT muip_list_jump
  methodid:LONG
  pos:LONG
ENDOBJECT

EXPORT OBJECT muip_list_move
  methodid:LONG
  from:LONG
  to:LONG
ENDOBJECT

EXPORT OBJECT muip_list_nextselected
  methodid:LONG
  pos:PTR TO LONG
ENDOBJECT

EXPORT OBJECT muip_list_redraw
  methodid:LONG
  pos:LONG
ENDOBJECT

EXPORT OBJECT muip_list_remove
  methodid:LONG
  pos:LONG
ENDOBJECT

EXPORT OBJECT muip_list_select
  methodid:LONG
  pos:LONG
  seltype:LONG
  state:PTR TO LONG
ENDOBJECT

EXPORT OBJECT muip_list_sort
  methodid:LONG
ENDOBJECT

EXPORT OBJECT muip_list_testpos
  methodid:LONG
  x:LONG
  y:LONG
  res:PTR TO mui_list_testpos_result
ENDOBJECT

EXPORT OBJECT muip_dirlist_reread
  methodid:LONG
ENDOBJECT

EXPORT OBJECT muip_numeric_decrease
  methodid:LONG
  amount:LONG
ENDOBJECT

EXPORT OBJECT muip_numeric_increase
  methodid:LONG
  amount:LONG
ENDOBJECT

EXPORT OBJECT muip_numeric_scaletovalue
  methodid:LONG
  scalemin:LONG
  scalemax:LONG
  scale:LONG
ENDOBJECT

EXPORT OBJECT muip_numeric_setdefault
  methodid:LONG
ENDOBJECT

EXPORT OBJECT muip_numeric_stringify
  methodid:LONG
  value:LONG
ENDOBJECT

EXPORT OBJECT muip_numeric_valuetoscale
  methodid:LONG
  scalemin:LONG
  scalemax:LONG
ENDOBJECT

EXPORT OBJECT muip_pendisplay_setcolormap
  methodid:LONG
  colormap:LONG
ENDOBJECT

EXPORT OBJECT muip_pendisplay_setmuipen
  methodid:LONG
  muipen:LONG
ENDOBJECT

EXPORT OBJECT muip_pendisplay_setrgb
  methodid:LONG
  red:LONG
  green:LONG
  blue:LONG
ENDOBJECT

EXPORT OBJECT muip_group_exitchange
  methodid:LONG
ENDOBJECT

EXPORT OBJECT muip_group_initchange
  methodid:LONG
ENDOBJECT

EXPORT OBJECT muip_group_sort
  methodid:LONG
  obj:LONG
ENDOBJECT

EXPORT OBJECT muip_settingsgroup_configtogadgets
  methodid:LONG
  configdata:LONG
ENDOBJECT

EXPORT OBJECT muip_settingsgroup_gadgetstoconfig
  methodid:LONG
  configdata:LONG
ENDOBJECT

EXPORT OBJECT muip_popstring_close
  methodid:LONG
  result:LONG
ENDOBJECT

EXPORT OBJECT muip_popstring_open
  methodid:LONG
ENDOBJECT

EXPORT OBJECT muip_semaphore_attempt
  methodid:LONG
ENDOBJECT

EXPORT OBJECT muip_semaphore_attemptshared
  methodid:LONG
ENDOBJECT

EXPORT OBJECT muip_semaphore_obtain
  methodid:LONG
ENDOBJECT

EXPORT OBJECT muip_semaphore_obtainshared
  methodid:LONG
ENDOBJECT

EXPORT OBJECT muip_semaphore_release
  methodid:LONG
ENDOBJECT

EXPORT OBJECT muip_dataspace_add
  methodid:LONG
  data:LONG
  len:LONG
  id:LONG
ENDOBJECT

EXPORT OBJECT muip_dataspace_clear
  methodid:LONG
ENDOBJECT

EXPORT OBJECT muip_dataspace_find
  methodid:LONG
  id:LONG
ENDOBJECT

EXPORT OBJECT muip_dataspace_merge
  methodid:LONG
  dataspace:LONG
ENDOBJECT

EXPORT OBJECT muip_dataspace_readiff
  methodid:LONG
  handle:PTR TO iffhandle
ENDOBJECT

EXPORT OBJECT muip_dataspace_remove
  methodid:LONG
  id:LONG
ENDOBJECT

EXPORT OBJECT muip_dataspace_writeiff
  methodid:LONG
  handle:PTR TO iffhandle
  type:LONG
  id:LONG
ENDOBJECT

