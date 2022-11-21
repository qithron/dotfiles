#include <stdio.h>
#include <string.h>

int main(int argc, char *argv[])
{
    char *url_mode = "\0";
    char sep_i = 10;
    char sep_o = 10;
    int i;
	for (i = 1; i < argc; i++) {
        if (!strcmp(argv[i], "-0")) { // output delimiter is NUL
            sep_o = 0;
        } else if (!strcmp(argv[i], "-z")) { // input delimiter is NUL
            sep_i = 0;
        } else if (!strcmp(argv[i], "-u")) { // url mode, not uri
            url_mode = " \"<>[\\]^`{|}:;?#";
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
        }
        if (url_mode[0]) {
            i = 0;
            while ((u = url_mode[i++]) != 0) {
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
    return 0;
}
