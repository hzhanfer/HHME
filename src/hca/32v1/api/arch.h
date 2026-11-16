#ifndef __HHME_32V1
#define __HHME_32V1


#include <stdint.h>


typedef uint32_t HHME_32V1Word;
#define HHME_32V1_WORD_MAX UINT32_MAX
#define HHME_32V1_WORD_MIN 0
typedef int32_t HHME_32V1SWord;
#define HHME_32V1_SWORD_MAX INT32_MAX
#define HHME_32V1_SWORD_MIN INT32_MIN


typedef enum HHME_32V1RegisterIndex {
    HHME_32V1_LR = 13,
    HHME_32V1_SP,
    HHME_32V1_PC,
    HHME_32V1_MAX_REGS,

    HHME_32V1_PSTATE = 0,
    HHME_32V1_MAX_SREGS
} HHME_32V1RegisterIndex;


typedef struct HHME_32V1 HHME_32V1;
#define HHME_CPUCore HHME_32V1


#endif