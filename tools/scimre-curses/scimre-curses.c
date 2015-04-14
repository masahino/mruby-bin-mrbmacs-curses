#include <locale.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "mruby.h"


int
main(int argc, char **argv)
{
  mrb_state *mrb = mrb_open();
  struct RClass *scimre_class;
  mrb_value scimre;
  
  setlocale(LC_CTYPE, "");
  if (mrb == NULL) {
    fputs("Invalid mrb_state, exiting scimre\n", stderr);
    return EXIT_FAILURE;
  }
  if (argc < 2) {
    return 0;
  } 
  scimre_class = mrb_class_get_under(mrb, mrb_module_get(mrb, "Scimre"), "Application");
  scimre = mrb_funcall(mrb, mrb_obj_value(scimre_class), "new", 1, mrb_str_new_cstr(mrb, argv[1]));
  mrb_funcall(mrb, scimre, "run", 0);
  return 0;
}
