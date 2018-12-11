#include <locale.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <mruby.h>
#include <mruby/array.h>

int
main(int argc, char **argv)
{
  mrb_state *mrb = mrb_open();
  struct RClass *scimre_class;
  mrb_value scimre;
  mrb_value arg_array;
  int i;
  
  setlocale(LC_CTYPE, "");
  if (mrb == NULL) {
    fputs("Invalid mrb_state, exiting scimre\n", stderr);
    return EXIT_FAILURE;
  }
  arg_array = mrb_ary_new(mrb);
  for (i = 1; i < argc; i++) {
    mrb_ary_push(mrb, arg_array, mrb_str_new_cstr(mrb, argv[i]));
  }
  scimre_class = mrb_class_get_under(mrb, mrb_module_get(mrb, "Mrbmacs"), "Application");
  scimre = mrb_funcall(mrb, mrb_obj_value(scimre_class), "new", 1, arg_array);
  mrb_funcall(mrb, scimre, "run", 0);

  return 0;
}
