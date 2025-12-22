/***************************************
*  console/functions.h v1.15
*  © Copyright 1988 Timm Martin
*  All Rights Reserved
****************************************/

#ifndef CONSOLE_FUNCTIONS_H
#define CONSOLE_FUNCTIONS_H

#include <exec/types.h>

void buffer_char_delete();
void buffer_char_insert();
void con_char_backspace();
void con_char_delete();
void con_char_insert();
void con_char_mult_delete();
void con_display_erase();
void con_events();
void con_graphic_rend();
void con_left_offset();
void con_line_erase();
void con_line_length();
void con_line_next();
void con_line_prev();
void con_line_scroll_down();
void con_line_scroll_up();
long con_open();
void con_page_length();
void con_put_char();
void con_put_line();
void con_put_string();
ULONG con_read();
void con_top_offset();
void con_write();
void console_close();
int console_input();
long console_open();
void cursor_invisible();
void cursor_jump_left();
void cursor_jump_right();
void cursor_left();
void cursor_place();
void cursor_pos();
void cursor_right();
void cursor_visible();
int field_add_list();
void field_char_backspace();
void field_char_delete();
void field_char_type();
int field_clear();
struct Field *field_click();
void field_close();
void field_copy();
void field_cursor_left();
void field_cursor_right();
void field_cut();
void field_delete();
void field_delete_backward();
void field_delete_forward();
void field_disable();
int field_display();
void field_dup();
void field_enable();
void field_goto();
int field_input();
void field_left();
struct Field *field_link();
int field_open();
void field_paste();
int field_redisplay();
int field_refresh();
int field_remove_list();
int field_reshow();
void field_restore();
void field_right();
void field_tab_backward();
void field_tab_forward();
void mask_chars();
void mask_entire();
void mask_range();

#endif
