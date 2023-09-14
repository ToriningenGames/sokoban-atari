#include <stdio.h>


struct unpacked {
        unsigned char left;
        unsigned char midleft;
        unsigned char midright;
        unsigned char right;
};

struct unpacked unpack(char pack)
{
        return (struct unpacked){pack>>6&0x03, pack>>4&0x03, pack>>2&0x03, pack&0x03};
}

void spit(unsigned char val)
{
        switch (val) {
                case 0 :
                        printf(" ");
                        break;
                case 1 :
                        printf("$");
                        break;
                case 2 :
                        printf(".");
                        break;
                case 3 :
                        printf("#");
                        break;
                case 4 :
                        printf("@");
                        break;
                case 6 :
                        printf("+");
                        break;
                default :
                        printf("?");
                        break;
        }
}

int main(int argc, char **argv)
{
        unsigned char pos = fgetc(stdin);
        int xpos = (pos & 0x0F);
        int ypos = (pos & 0xF0)>>4;
        for (int y = 0; y < 8; y++) {
                for (int x = 0; x < 2; x++) {
                        struct unpacked vals = unpack(fgetc(stdin));
                        spit(vals.left | (y == ypos && x*4 == xpos)<<2);
                        spit(vals.midleft | (y == ypos && x*4+1 == xpos)<<2);
                        spit(vals.midright | (y == ypos && x*4+2 == xpos)<<2);
                        spit(vals.right | (y == ypos && x*4+3 == xpos)<<2);
                }
                puts("");
        }
        return 0;
}
