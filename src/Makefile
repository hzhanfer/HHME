# build

# folders
MAIN_DIR := main

# tools
CC  := clang
LD  := $(CC)
AR  := ar

# flags
CC_FLAGS := \
	-std=c99 -pedantic \
	-Wall -Wextra \
	-O2 \
	-ffunction-sections -fdata-sections \
	-fPIC \
	-MMD -MP \
	-I. \
	-Ihca/$(TARGET)

LD_FLAGS := \
	-Wl,--gc-sections -Wl,--strip-all

LIB_SO_FLAGS := \
	$(LD_FLAGS) \
	-shared

# build artifacts
C_FILES := $(shell find -type f -name '*.c')
O_FILES := $(C_FILES:.c=.o)
D_FILES := $(O_FILES:.o=.d)

BIN_O_FILE      := ./$(MAIN_DIR)/main.o
CONF_BIN_O_FILE := ./$(MAIN_DIR)/conf-main.o

BIN_O_FILES  := $(filter-out $(CONF_BIN_O_FILE),$(O_FILES))
CONF_O_FILES := $(filter-out $(BIN_O_FILE),$(O_FILES))


.PHONY: all clean build


all: build


build: $(BIN_FILE) $(CONF_BIN_FILE) $(LIB_SO_FILE) $(LIB_A_FILE)


$(BIN_FILE): $(BIN_O_FILES)
	$(LD) $^ -o $@ $(LD_FLAGS)

$(CONF_BIN_FILE): $(CONF_O_FILES)
	$(LD) $^ -o $@ $(LD_FLAGS)

$(LIB_SO_FILE): $(filter-out $(BIN_O_FILE),$(O_FILES))
	$(LD) $^ -o $@ $(LIB_SO_FLAGS)

$(LIB_A_FILE): $(filter-out $(CONF_BIN_O_FILE),$(O_FILES))
	$(AR) rcs $@ $^


%.o: %.c
	$(CC) -c $< -o $@ $(CC_FLAGS)

-include $(D_FILES)


clean:
	rm -f $(O_FILES) $(D_FILES) $(BIN_FILE) $(CONF_BIN_FILE) $(LIB_SO_FILE) $(LIB_A_FILE)
	rm -f hhme-* libHHME-*