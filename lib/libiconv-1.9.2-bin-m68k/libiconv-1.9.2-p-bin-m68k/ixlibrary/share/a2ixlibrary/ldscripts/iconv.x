/*  */
__shared_textfunctions_start_libiconv = ___shared_lib_ptr + 1000;
___shared_lib_ptr = __shared_textfunctions_start_libiconv;
__shared_datafunctions_start_libiconv = ___shared_lib_ptr + 2;
___shared_lib_ptr = __shared_datafunctions_start_libiconv;
_libiconv_open = ___shared_lib_ptr + 0x0ad76c - 0x0ad76c + 10;
___shared_lib_ptr = _libiconv_open;
_libiconv = ___shared_lib_ptr + 0x0ada4e - 0x0ad76c + 10;
___shared_lib_ptr = _libiconv;
_libiconv_close = ___shared_lib_ptr + 0x0ada98 - 0x0ada4e + 10;
___shared_lib_ptr = _libiconv_close;
_libiconvctl = ___shared_lib_ptr + 0x0adab8 - 0x0ada98 + 10;
___shared_lib_ptr = _libiconvctl;
_libiconvlist = ___shared_lib_ptr + 0x0adbdc - 0x0adab8 + 10;
___shared_lib_ptr = _libiconvlist;
_aliases_lookup = ___shared_lib_ptr + 0x0adcbc - 0x0adbdc + 10;
___shared_lib_ptr = _aliases_lookup;
_libiconv_set_relocation_prefix = ___shared_lib_ptr + 0x0adf1e - 0x0adcbc + 10;
___shared_lib_ptr = _libiconv_set_relocation_prefix;
_libiconv_relocate = ___shared_lib_ptr + 0x0adf3e - 0x0adf1e + 10;
___shared_lib_ptr = _libiconv_relocate;
_locale_charset = ___shared_lib_ptr + 0x0ae254 - 0x0adf3e + 10;
___shared_lib_ptr = _locale_charset;

__shared_textfunctions_end_libiconv = ___shared_lib_ptr + 0x0ae3dc - 0x0ae254 + 10;
___shared_lib_ptr = __shared_textfunctions_end_libiconv;
__shared_datafunctions_end_libiconv = ___shared_lib_ptr;
__shared_textdata_start_libiconv = ___shared_lib_ptr + 1000;
___shared_lib_ptr = __shared_textdata_start_libiconv;
__shared_datadata_start_libiconv = ___shared_lib_ptr + 2;
___shared_lib_ptr = __shared_datadata_start_libiconv;
__libiconv_version = ___shared_lib_ptr + 0x02496e - 0x02496e + 10;
___shared_lib_ptr = __libiconv_version;

__shared_textdata_end_libiconv = ___shared_lib_ptr + 0x0ae3dc - 0x02496e + 10;
___shared_lib_ptr = __shared_textdata_end_libiconv;
__shared_datadata_end_libiconv = ___shared_lib_ptr;
