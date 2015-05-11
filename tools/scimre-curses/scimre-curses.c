#include <locale.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "mruby.h"

const char init_file_name[] = ".scimrerc";

char *
get_init_file_path(mrb_state *mrb)
{
  char *path = NULL;
  char *home = getenv("HOME");
  int len, n;
  size_t size;
  
  if (home != NULL) {
    len = snprintf(NULL, 0, "%s/%s", home, init_file_name);
    if (len >= 0) {
      size = len + 1;
      path = (char *)mrb_malloc_simple(mrb, size);
      if (path != NULL) {
        n = snprintf(path, size, "%s/%s", home, init_file_name);
        if (n != len) {
          mrb_free(mrb, path);
          path = NULL;
        }
      }
    }
  }
  return path;
}

int
main(int argc, char **argv)
{
  mrb_state *mrb = mrb_open();
  struct RClass *scimre_class;
  mrb_value scimre;
  char *fname = NULL;
  char *init_path = NULL;
  
  setlocale(LC_CTYPE, "");
  if (mrb == NULL) {
    fputs("Invalid mrb_state, exiting scimre\n", stderr);
    return EXIT_FAILURE;
  }
  init_path = get_init_file_path(mrb);
  if (argc > 1) {
    fname = argv[1];
  } 
  scimre_class = mrb_class_get_under(mrb, mrb_module_get(mrb, "Scimre"), "Application");
  scimre = mrb_funcall(mrb, mrb_obj_value(scimre_class), "new", 1, mrb_str_new_cstr(mrb, init_path));

  if (argc < 2) {
    mrb_funcall(mrb, scimre, "run", 0);
  } else {
    mrb_funcall(mrb, scimre, "run", 1, mrb_str_new_cstr(mrb, fname));
  }
  return 0;
}
