#ifndef ARCH32V1_H
#define ARCH32V1_H


#include "api/arch.h"


typedef struct HHME_Board HHME_Board;
typedef struct HHME_CPU HHME_CPU;


struct HHME_32V1 {
    HHME_Board* brd;
    HHME_CPU* cpu;

    HHME_32V1Word
        regs[HHME_32V1_MAX_REGS],
        sregs[HHME_32V1_MAX_SREGS];
}


#endif