/*
** compile.c
**
** See Copyright Notice in mruby.h
*/

#include "mruby.h"

#include "mruby/string.h"
#include "mruby/dump.h"
#include "mruby/proc.h"
#include "mruby/compile.h"

#include "opcode.h"

mrb_value
mrb_yield_internal(mrb_state *mrb, mrb_value b, int argc, mrb_value *argv, mrb_value self, struct RClass *c);

static void
replace_stop_with_return(mrb_state *mrb, mrb_irep *irep)
{
  if (irep->iseq[irep->ilen - 1] == MKOP_A(OP_STOP, 0)) {
    irep->iseq = mrb_realloc(mrb, irep->iseq, (irep->ilen + 1) * sizeof(mrb_code));
    irep->iseq[irep->ilen - 1] = MKOP_A(OP_LOADNIL, 0);
    irep->iseq[irep->ilen] = MKOP_AB(OP_RETURN, 0, OP_R_NORMAL);
    irep->ilen++;
  }
}


static mrb_value
mrb_compile(mrb_state *mrb, mrb_value src)
{
  mrb_value bin;
  mrb_value nvalue;
  mrbc_context *c;
  int n;
  int irep_len = mrb->irep_len;
  mrb_state *mrb2 = mrb_open();

  /* parse & compile ruby source */
  c = mrbc_context_new(mrb2);
  c->no_exec = 1;
  // c->filename = filename;
  nvalue = mrb_load_nstring_cxt(mrb2, mrb_string_value_ptr(mrb, src), RSTRING_LEN(src), c);
  n = mrb_fixnum(nvalue);

  /* dump mrb_state */
  mrb2->irep += n;
  mrb2->irep_len -= n;
  bin = mrb_dump_irep_str(mrb2, 0, 1);
  mrb2->irep -= n;
  mrb2->irep_len += n;

  bin = mrb_str_new(mrb, RSTRING_PTR(bin), RSTRING_LEN(bin));

  mrb_close(mrb2);

  return bin;
}

mrb_value
mrb_f_compile(mrb_state *mrb, mrb_value self)
{
  mrb_value src;

  mrb_get_args(mrb, "o", &src);
  if (mrb_type(src) != MRB_TT_STRING) {
    mrb_raisef(mrb, E_TYPE_ERROR, "can't convert %s into String",
        mrb_obj_classname(mrb, src));
    return mrb_nil_value();
  }

  return mrb_compile(mrb, src);
}

void
mrb_init_compile(mrb_state *mrb)
{
  struct RClass *krn;
  krn = mrb->kernel_module;

  mrb_define_method(mrb, krn, "compile",                    mrb_f_compile,         ARGS_REQ(1));

}

