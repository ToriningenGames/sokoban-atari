#include <stdio.h>
#include <string.h>
#include <stdarg.h>

#ifndef DEBUG
#define DEBUG 0
#endif

void status(const char *file, int line, const char *func, const char *format, ...)
{
        if (!DEBUG) return;
        fprintf(stderr, "Notif in %s:%d, func %s: ", file, line, func);
        va_list args;
        va_start(args, format);
        vfprintf(stderr, format, args);
        va_end(args);
}
#define logstate(message, ...) status(__FILE__, __LINE__, __func__, message, __VA_ARGS__)


unsigned char pack(char left, char leftmid, char rightmid, char right)
{
        return ((unsigned char)left)<<6 | leftmid<<4 | rightmid<<2 | right;
}

int main(int argc, char **argv)
{
        char level[8*8];
        memset(level, '#', 8*8);
        //First line is all wall; this can be safely skipped, and can be used to determine level width
        int width = -2;
        int height = 0;
        while (fgetc(stdin) == '#')
                width++;
        for (int y = 0; y < 8; y++) {
                //Skip the borders
                fgetc(stdin);
                for (int x = 0; x < width; x++) {
                        int inp = fgetc(stdin);
                        if (x == 0 && inp == '\n') {
                                height = y-1;
                                y = 999;
                                break;
                        }
                        if (inp == '\n') break;
                        level[y*8+x] = inp;
                }
                fgetc(stdin);
        }
        //Width and height indicate the meaningful size of the level, but it's in the top-left corner
        //Translate and center the level into Atari format
        char levelpack[8*8];
        memset(levelpack, 3, 8*8);
        int start = (8-height)/2*8;
        unsigned char playerpos;
        for (int y = 0; y < height; y++) {
                for (int x = 0; x < width; x++) {
                        char pack = 3;
                        logstate("Placing character '%c' at %d to %d\n", level[y*8+x], y*8+x, start+y*8+x+(8-width)/2);
                        switch (level[y*8+x]) {
                                case '@' :
                                        playerpos = (((8-height)/2+y) * 0x10) + ((8-width)/2+x);
                                case ' ' :
                                        pack = 0;
                                        break;
                                case '$' :
                                        pack = 1;
                                        break;
                                case '+' :
                                        playerpos = (((8-height)/2+y) * 0x10) + ((8-width)/2+x);
                                case '.' :
                                        pack = 2;
                                        break;
                                case '*' :
                                case '#' :
                                default :
                                        pack = 3;
                                        break;
                        }
                        levelpack[start+y*8+x+(8-width)/2] = pack;
                }
        }
        putchar(playerpos);
        for (int i = 0; i < 8*8; i+=4) {
                putchar(pack(levelpack[i], levelpack[i+1], levelpack[i+2], levelpack[i+3]));
        }
        return 0;
}
