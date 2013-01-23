/*
** init_ext.c - initialize extend libraries
**
** See Copyright Notice in mruby.h
*/

#include "mruby.h"

void mrb_init_require(mrb_state *mrb);
void mrb_init_errno(mrb_state *mrb);
void mrb_init_io(mrb_state *mrb);
void mrb_init_file(mrb_state *mrb);
void mrb_init_socket(mrb_state *mrb);
void mrb_init_mrblib_ext(mrb_state*);

#define DONE mrb_gc_arena_restore(mrb, 0);
void
mrb_init_ext(mrb_state *mrb)
{
#ifdef ENABLE_REQUIRE
  mrb_init_require(mrb); DONE;
#endif
#ifdef ENABLE_ERRNO
  mrb_init_errno(mrb); DONE;
#endif
#ifdef ENABLE_IO
  mrb_init_io(mrb); DONE;
  mrb_init_file(mrb); DONE;
#ifdef ENABLE_SOCKET
  mrb_init_socket(mrb); DONE;
#endif
#endif

  mrb_init_mrblib_ext(mrb);
}
