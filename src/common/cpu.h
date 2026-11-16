#ifndef CPU_H
#define CPU_H


#include <stdlib.h>
#include "api/cpu.h"
#include "arch.h"


struct HHME_CPU {
    HHME_Board* brd;

    HHME_CPUCore* cores;
    size_t core_cnt;
};


#endif