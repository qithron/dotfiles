#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define NODE_SIZE 255

#define VAL(x) (x - 48 - 7 * (x >= 65) - 32 * (x >= 97))
#define CHR(x, y) (VAL(x) * 16 + VAL(y))
#define HEX(x) ((0x30 <= x && x <= 0x39) || \
                (0x41 <= x && x <= 0x46) || \
                (0x61 <= x && x <= 0x66))

#define NODE_INIT \
    buffer->data = malloc(NODE_SIZE+1); \
    buffer->next = NULL;

#define PUTCHAR(a) \
    if (*a == sep_i) putchar(sep_o); \
    else putchar(*a);

#define BUFF_CHK(a) \
    if (!a) { \
        a = &buffer->data[i++]; \
        if (!*a) { a=NULL; break; } \
    } \

#define BUFF_LST(a) if (a) {PUTCHAR(a);}

struct Node {
    char *data;
    struct Node *next;
};

int main(int argc, char *argv[])
{
    char sep_i = 10;
    char sep_o = 10;
    int i;
	for (i = 1; i < argc; i++) {
        if (!strcmp(argv[i], "-0")) { // output delimiter is NUL
            sep_o = 0;
        } else if (!strcmp(argv[i], "-z")) { // input delimiter is NUL
            sep_i = 0;
        } else {
            printf("usage: %s [-z]\n", argv[0]);
            return 1;
        }
    }

    struct Node *root = malloc(sizeof(struct Node));
    struct Node *buffer = &*root;
    NODE_INIT;

    int ch;
    i = 0;
    while ((ch=getchar()) != EOF) {
        buffer->data[i] = ch;
        i++;
        if (i == NODE_SIZE) {
            buffer->next = malloc(sizeof(struct Node));
            buffer = &*buffer->next;
            NODE_INIT;
            i = 0;
        }
    }

    buffer = &*root;
    char *x=NULL, *y=NULL, *z=NULL;
    while (buffer != NULL) {
        i = 0;
        while (i < NODE_SIZE) {
            BUFF_CHK(x); BUFF_CHK(y); BUFF_CHK(z);
            if (*x == 37 && HEX(*y) && HEX(*z)) {
                putchar(CHR(*y, *z));
                x=NULL; y=NULL; z=NULL;
            } else {
                PUTCHAR(x);
                x = &*y;
                y = &*z;
                z = NULL;
            }
        }
        buffer = &*buffer->next;
    }
    BUFF_LST(x); BUFF_LST(y); BUFF_LST(z);

    buffer = &*root;
    struct Node *temp = buffer;
    while (buffer != NULL) {
        buffer = &*buffer->next;
        free(temp->data);
        free(temp);
        temp = buffer;
    }

    return 0;
}
