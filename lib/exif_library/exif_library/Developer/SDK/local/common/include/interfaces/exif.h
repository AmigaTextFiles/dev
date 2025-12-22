#ifndef EXIF_INTERFACE_DEF_H
#define EXIF_INTERFACE_DEF_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef EXEC_EXEC_H
#include <exec/exec.h>
#endif
#ifndef EXEC_INTERFACES_H
#include <exec/interfaces.h>
#endif

#include <libexif/exif-byte-order.h>
#include <libexif/exif-content.h>
#include <libexif/exif-data.h>
#include <libexif/exif-data-type.h>
#include <libexif/exif-entry.h>
#include <libexif/exif-format.h>
#include <libexif/exif-ifd.h>
#include <libexif/exif-loader.h>
#include <libexif/exif-log.h>
#include <libexif/exif-mem.h>
#include <libexif/exif-mnote-data.h>
#include <libexif/exif-tag.h>
#include <libexif/exif-utils.h>

#ifdef __cplusplus
#ifdef __USE_AMIGAOS_NAMESPACE__
namespace AmigaOS {
#endif
extern "C" {
#endif

struct ExifIFace
{
	struct InterfaceData Data;

	uint32 APICALL (*Obtain)(struct ExifIFace *Self);
	uint32 APICALL (*Release)(struct ExifIFace *Self);
	void APICALL (*Expunge)(struct ExifIFace *Self);
	struct Interface * APICALL (*Clone)(struct ExifIFace *Self);
	const char *(*exif_byte_order_get_name)(ExifByteOrder order);
	ExifContent *(*exif_content_new)(void);
	ExifContent *(*exif_content_new_mem)(ExifMem *mem);
	void (*exif_content_ref)(ExifContent *content);
	void (*exif_content_unref)(ExifContent *content);
	void (*exif_content_free)(ExifContent *content);
	void (*exif_content_add_entry)(ExifContent *c, ExifEntry *entry);
	void (*exif_content_remove_entry)(ExifContent *c, ExifEntry *e);
	ExifEntry *(*exif_content_get_entry)(ExifContent *content, ExifTag tag);
	void (*exif_content_fix)(ExifContent *c);
	void (*exif_content_foreach_entry)(ExifContent *content, ExifContentForeachEntryFunc func, void *user_data);
	ExifIfd (*exif_content_get_ifd)(ExifContent *c);
	void (*exif_content_dump)(ExifContent *content, unsigned int indent);
	void (*exif_content_log)(ExifContent *content, ExifLog *log);
	ExifData *(*exif_data_new)(void);
	ExifData *(*exif_data_new_mem)(ExifMem *mem);
	ExifData *(*exif_data_new_from_file)(const char *path);
	ExifData *(*exif_data_new_from_data)(const unsigned char *data, unsigned int size);
	void (*exif_data_load_data)(ExifData *data, const unsigned char *d, unsigned int size);
	void (*exif_data_save_data)(ExifData *data, unsigned char **d, unsigned int *ds);
	void (*exif_data_ref)(ExifData *data);
	void (*exif_data_unref)(ExifData *data);
	void (*exif_data_free)(ExifData *data);
	ExifByteOrder (*exif_data_get_byte_order)(ExifData *data);
	void (*exif_data_set_byte_order)(ExifData *data, ExifByteOrder order);
	ExifMnoteData *(*exif_data_get_mnote_data)(ExifData *d);
	void (*exif_data_fix)(ExifData *d);
	void (*exif_data_foreach_content)(ExifData *data, ExifDataForeachContentFunc func, void *user_data);
	const char *(*exif_data_option_get_name)(ExifDataOption o);
	const char *(*exif_data_option_get_description)(ExifDataOption o);
	void (*exif_data_set_option)(ExifData *d, ExifDataOption o);
	void (*exif_data_unset_option)(ExifData *d, ExifDataOption o);
	void (*exif_data_set_data_type)(ExifData *d, ExifDataType dt);
	ExifDataType (*exif_data_get_data_type)(ExifData *d);
	void (*exif_data_dump)(ExifData *data);
	void (*exif_data_log)(ExifData *data, ExifLog *log);
	ExifEntry *(*exif_entry_new)(void);
	ExifEntry *(*exif_entry_new_mem)(ExifMem *mem);
	void (*exif_entry_ref)(ExifEntry *entry);
	void (*exif_entry_unref)(ExifEntry *entry);
	void (*exif_entry_free)(ExifEntry *entry);
	void (*exif_entry_initialize)(ExifEntry *e, ExifTag tag);
	void (*exif_entry_fix)(ExifEntry *entry);
	const char *(*exif_entry_get_value)(ExifEntry *entry, char *val, unsigned int maxlen);
	void (*exif_entry_dump)(ExifEntry *entry, unsigned int indent);
	const char *(*exif_format_get_name)(ExifFormat format);
	unsigned char (*exif_format_get_size)(ExifFormat format);
	const char *(*exif_ifd_get_name)(ExifIfd ifd);
	ExifLoader *(*exif_loader_new)(void);
	ExifLoader *(*exif_loader_new_mem)(ExifMem *mem);
	void (*exif_loader_ref)(ExifLoader *loader);
	void (*exif_loader_unref)(ExifLoader *loader);
	void (*exif_loader_write_file)(ExifLoader *loader, const char *fname);
	unsigned char (*exif_loader_write)(ExifLoader *loader, unsigned char *buf, unsigned int sz);
	void (*exif_loader_reset)(ExifLoader *loader);
	ExifData *(*exif_loader_get_data)(ExifLoader *loader);
	void (*exif_loader_get_buf)(ExifLoader *loader, const unsigned char **buf, unsigned int *buf_size);
	void (*exif_loader_log)(ExifLoader *loader, ExifLog *log);
	ExifLog *(*exif_log_new)(void);
	ExifLog *(*exif_log_new_mem)(ExifMem *mem);
	void (*exif_log_ref)(ExifLog *log);
	void (*exif_log_unref)(ExifLog *log);
	void (*exif_log_free)(ExifLog *log);
	const char *(*exif_log_code_get_title)(ExifLogCode code);
	const char *(*exif_log_code_get_message)(ExifLogCode code);
	void (*exif_log_set_func)(ExifLog *log, ExifLogFunc func, void *data);
	void (*exif_log)(ExifLog *log, ExifLogCode code, const char *domain, const char *format, ...);
	void (*exif_logv)(ExifLog *log, ExifLogCode code, const char *domain, const char *format, va_list args);
	ExifMem *(*exif_mem_new)(ExifMemAllocFunc a, ExifMemReallocFunc r, ExifMemFreeFunc f);
	void (*exif_mem_ref)(ExifMem *m);
	void (*exif_mem_unref)(ExifMem *m);
	void *(*exif_mem_alloc)(ExifMem *m, ExifLong s);
	void *(*exif_mem_realloc)(ExifMem *m, void *p, ExifLong s);
	void (*exif_mem_free)(ExifMem *m, void *p);
	ExifMem *(*exif_mem_new_default)(void);
	void (*exif_mnote_data_ref)(ExifMnoteData *d);
	void (*exif_mnote_data_unref)(ExifMnoteData *d);
	void (*exif_mnote_data_load)(ExifMnoteData *d, const unsigned char *buf, unsigned int buf_siz);
	void (*exif_mnote_data_save)(ExifMnoteData *d, unsigned char **buf, unsigned int *buf_siz);
	unsigned int (*exif_mnote_data_count)(ExifMnoteData *d);
	unsigned int (*exif_mnote_data_get_id)(ExifMnoteData *d, unsigned int n);
	const char *(*exif_mnote_data_get_name)(ExifMnoteData *d, unsigned int n);
	const char *(*exif_mnote_data_get_title)(ExifMnoteData *d, unsigned int n);
	const char *(*exif_mnote_data_get_description)(ExifMnoteData *d, unsigned int n);
	char *(*exif_mnote_data_get_value)(ExifMnoteData *d, unsigned int n, char *val, unsigned int maxlen);
	void (*exif_mnote_data_log)(ExifMnoteData *d, ExifLog *log);
	ExifTag (*exif_tag_from_name)(const char *name);
	const char *(*exif_tag_get_name_in_ifd)(ExifTag tag, ExifIfd ifd);
	const char *(*exif_tag_get_title_in_ifd)(ExifTag tag, ExifIfd ifd);
	const char *(*exif_tag_get_description_in_ifd)(ExifTag tag, ExifIfd ifd);
	ExifSupportLevel (*exif_tag_get_support_level_in_ifd)(ExifTag tag, ExifIfd ifd, ExifDataType t);
	const char *(*exif_tag_get_name)(ExifTag tag);
	const char *(*exif_tag_get_title)(ExifTag tag);
	const char *(*exif_tag_get_description)(ExifTag tag);
	ExifTag (*exif_tag_table_get_tag)(unsigned int n);
	const char *(*exif_tag_table_get_name)(unsigned int n);
	unsigned int (*exif_tag_table_count)(void);
	ExifShort (*exif_get_short)(const unsigned char *b, ExifByteOrder order);
	ExifSShort (*exif_get_sshort)(const unsigned char *b, ExifByteOrder order);
	ExifLong (*exif_get_long)(const unsigned char *b, ExifByteOrder order);
	ExifSLong (*exif_get_slong)(const unsigned char *b, ExifByteOrder order);
	ExifRational (*exif_get_rational)(const unsigned char *b, ExifByteOrder order);
	ExifSRational (*exif_get_srational)(const unsigned char *b, ExifByteOrder order);
	void (*exif_set_short)(unsigned char *b, ExifByteOrder order, ExifShort value);
	void (*exif_set_sshort)(unsigned char *b, ExifByteOrder order, ExifSShort value);
	void (*exif_set_long)(unsigned char *b, ExifByteOrder order, ExifLong value);
	void (*exif_set_slong)(unsigned char *b, ExifByteOrder order, ExifSLong value);
	void (*exif_set_rational)(unsigned char *b, ExifByteOrder order, ExifRational value);
	void (*exif_set_srational)(unsigned char *b, ExifByteOrder order, ExifSRational value);
	void (*exif_convert_utf16_to_utf8)(char *out, const unsigned short *in, int maxlen);
	void (*exif_array_set_byte_order)(ExifFormat f, unsigned char *b, unsigned int n, ExifByteOrder o_orig, ExifByteOrder o_new);
};

#ifdef __cplusplus
}
#ifdef __USE_AMIGAOS_NAMESPACE__
}
#endif
#endif

#endif /* EXIF_INTERFACE_DEF_H */
