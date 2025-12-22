 {      Namespace definitions      }


Type
{ The named object structure }
 NamedObject = Record
    no_Object       : Address;       { Your pointer, for whatever you want }
 end;
 NamedObjectPtr = ^NamedObject;

const
{ Tags for AllocNamedObject() }
 ANO_NameSpace  = 4000;    { Tag to define namespace      }
 ANO_UserSpace  = 4001;    { tag to define userspace      }
 ANO_Priority   = 4002;    { tag to define priority       }
 ANO_Flags      = 4003;    { tag to define flags          }

{ Flags for tag ANO_Flags }
 NSB_NODUPS     = 0;
 NSB_CASE       = 1;

 NSF_NODUPS     = 1;      { Default allow duplicates }
 NSF_CASE       = 2;      { Default to caseless... }

