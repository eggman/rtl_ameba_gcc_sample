#include "rtl8195a.h"

int main(void)
{
    int i=0;

    while (1) {
        DiagPrintf("Hello World : %d\r\n", i++);
        HalDelayUs(1000000);
    }
}

