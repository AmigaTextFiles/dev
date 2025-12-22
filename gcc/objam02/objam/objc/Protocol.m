/*
** ObjectiveAmiga: Implementation of class Protocol
** See GNU:lib/libobjam/ReadMe for details
*/


#include <objc/Protocol.h>
#include <objc/objc-api.h>

/* Method description list */
struct objc_method_description_list {
        int count;
        struct objc_method_description list[1];
};


@implementation Protocol
{
@private
        char *protocol_name;
        struct objc_protocol_list *protocol_list;
        struct objc_method_description_list *instance_methods, *class_methods; 
}

/* Obtaining attributes intrinsic to the protocol */

- (const char *)name
{
  return protocol_name;
}

/* Testing protocol conformance */

- (BOOL) conformsTo: (Protocol *)aProtocolObject
{
  int i;
  struct objc_protocol_list* proto_list;

  if (!strcmp(aProtocolObject->protocol_name, self->protocol_name))
    return YES;

  for (proto_list = protocol_list; proto_list; proto_list = proto_list->next)
    {
      for (i=0; i < proto_list->count; i++)
	{
	  if ([proto_list->list[i] conformsTo: aProtocolObject])
	    return YES;
	}
    }

  return NO;
}

/* Looking up information specific to a protocol */

- (struct objc_method_description *) descriptionForInstanceMethod:(SEL)aSel
{
  int i;
  struct objc_protocol_list* proto_list;
  const char* name = sel_get_name (aSel);
  struct objc_method_description *result;

  for (i = 0; i < instance_methods->count; i++)
    {
      if (!strcmp ((char*)instance_methods->list[i].name, name))
	return &(instance_methods->list[i]);
    }

  for (proto_list = protocol_list; proto_list; proto_list = proto_list->next)
    {
      for (i=0; i < proto_list->count; i++)
	{
	  if ((result = [proto_list->list[i]
			 descriptionForInstanceMethod: aSel]))
	    return result;
	}
    }

  return NULL;
}

- (struct objc_method_description *) descriptionForClassMethod:(SEL)aSel;
{
  int i;
  struct objc_protocol_list* proto_list;
  const char* name = sel_get_name (aSel);
  struct objc_method_description *result;

  for (i = 0; i < class_methods->count; i++)
    {
      if (!strcmp ((char*)class_methods->list[i].name, name))
	return &(class_methods->list[i]);
    }

  for (proto_list = protocol_list; proto_list; proto_list = proto_list->next)
    {
      for (i=0; i < proto_list->count; i++)
	{
	  if ((result = [proto_list->list[i]
			 descriptionForClassMethod: aSel]))
	    return result;
	}
    }

  return NULL;
}

@end
