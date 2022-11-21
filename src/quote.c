#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int safe_new_arr(char **arr, char arg[])
{
    char c;
    int i = 0;
    int j = 0;
    while ((c = arg[i]) != 0) {
        i++;
        if (c == 92 && arg[i] != 92)
            j += 3;
    }
    i -= j + 1;
    *arr = malloc(i);
    strcpy(*arr, arg);
    return *arr == NULL;
}

int main(int argc, char *argv[])
{
    char *safe_mode = "";
    char *safe = NULL;
    if (safe_new_arr(&safe, "/"))
        return 1;
    char sep_i = 10;
    char sep_o = 10;
    int i;
	for (i = 1; i < argc; i++) {
        if (!strcmp(argv[i], "-s")) { // safe chars
            free(safe);
            if (safe_new_arr(&safe, argv[++i]))
                return 1;
        } else if (!strcmp(argv[i], "-z")) { // input delimiter is NUL
            sep_i = 0;
        } else if (!strcmp(argv[i], "-0")) { // output delimiter is NUL
            sep_o = 0;
        } else if (!strcmp(argv[i], "-u")) { // url mode
            safe_mode = " \"<>[\\]^`{|}";
        } else {
            printf("usage: %s [-z]\n", argv[0]);
            return 1;
        }
    }

    int c;
    char u;
    while ((c = getchar()) != EOF) {
        if (c == sep_i) {
            putchar(sep_o);
            continue;
        } else if (safe_mode[0]) {
            i = 0;
            while ((u = safe_mode[i]) != 0) {
                i++;
                if (c == u) {
                    printf("%%%02X", c);
                    i = 0;
                    break;
                }
            }
            if (!i)
                continue;
        }
        if (31 < c && c != 37 && c < 127)
            putchar(c);
        else
            printf("%%%02X", c);
    }
    free(safe);
    return 0;
}
