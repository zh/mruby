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
void mrb_init_dir(mrb_state *mrb);
void mrb_init_process(mrb_state *mrb);
void mrb_init_digest(mrb_state *mrb);
void mrb_init_env(mrb_state *mrb);
void mrb_init_pack(mrb_state *mrb);
void mrb_init_syslog(mrb_state *mrb);
void mrb_init_random(mrb_state *mrb);
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
#ifdef ENABLE_DIR
  mrb_init_dir(mrb); DONE;
#endif
#ifdef ENABLE_PROCESS
  mrb_init_process(mrb); DONE;
#endif
#ifdef ENABLE_DIGEST
  mrb_init_digest(mrb); DONE;
#endif
#ifdef ENABLE_ENV
  mrb_init_env(mrb); DONE;
#endif
#ifdef ENABLE_PACK
  mrb_init_pack(mrb); DONE;
#endif
#ifdef ENABLE_SYSLOG
  mrb_init_syslog(mrb); DONE;
#endif
#ifdef ENABLE_RANDOM
  mrb_init_random(mrb); DONE;
#endif

  mrb_init_mrblib_ext(mrb);
}
