# installation manager

# input
TARGET=

# information
VER= 0.1
VER_MAJOR= 0

AVAILABLE_TARGETS= 32v1

# installation path
INSTALL_DIR= $(shell if [ -n "$$PREFIX" ]; then echo $$PREFIX; else echo /usr/local; fi)
INSTALL_BIN_DIR= $(INSTALL_DIR)/bin
INSTALL_LIB_DIR= $(INSTALL_DIR)/lib
INSTALL_INCLUDE_DIR= $(INSTALL_DIR)/include

# tools
INSTALL= install
RM= rm
LN= ln

# ouputs
export BIN_FILE= hhme$(TARGET)
export CONF_BIN_FILE= hhme$(TARGET)-config
export LIB_SO_FILE= libHHME.so.$(VER)
export LIB_A_FILE= libHHME.a.$(VER)
LIB_SO_FILE_VERSIONED= libHHME.so.$(VER)
LIB_A_FILE_VERSIONED= libHHME.a.$(VER)
LIB_SO_FILE_VERSIONED_MAJOR= libHHME.so.$(VER_MAJOR)
LIB_A_FILE_VERSIONED_MAJOR= libHHME.a.$(VER_MAJOR)
LIB_SO_FILE_UNVERSIONED= libHHME.so
LIB_A_FILE_UNVERSIONED= libHHME.a

# headers
HEADER_DIR= HHME
HEADER_FILES=
ARCH_HEADER_FILES=

# other
SRC_DIR= src
BUILD_MAKEF_DIR= $(SRC_DIR)


.PHONY: all help


all: help


help:
	@echo "HHME Installation Manager"
	@echo
	@echo "Usage:"
	@echo "  make [OPTION]... TARGET=[HCA]..."
	@echo
	@echo "Available targets:"
	@echo "  $(AVAILABLE_TARGETS)"
	@echo
	@echo "Variables:"
	@echo "  TARGET                     The target to manage."
	@echo "  INSTALL_DIR                '$(INSTALL_DIR)' is the installation path. It uses \$$PREFIX if it exists and isn't empty, otherwise '/usr/local/' by default."
	@echo "  INSTALL_BIN_DIR            '$(INSTALL_BIN_DIR)'"
	@echo "  INSTALL_LIB_DIR            '$(INSTALL_LIB_DIR)'"
	@echo "  INSTALL_INCLUDE_DIR        '$(INSTALL_INCLUDE_DIR)'"
	@echo
	@echo "Options:"
	@echo "  help                       Shows help information."
	@echo "  available-targets          Shows all the available emulator targets."
	@echo "  version                    Shows the current version of this HHME project."
	@echo "  build                      Builds the emulator for the given TARGET."
	@echo "  install                    Install the emulator for the given TARGET."
	@echo "  uninstall                  Uninstall the emulator for the given TARGET."
	@echo "  uninstall-all              Uninstalls all the installed emulators."
	@echo "  is-installed               Checks if the emulator for the given TARGET is installed."
	@echo "  is-valid                   Checks if the given TARGET is valid."
	@echo "  clean                      Removes build artifacts including binaries."

available-targets:
	@echo $(AVAILABLE_TARGETS)

version:
	@echo $(VER)


build: is-valid
	@make -C $(BUILD_MAKEF_DIR) build

install: is-valid build
	$(INSTALL) -m 755 $(SRC_DIR)/$(BIN_FILE) $(INSTALL_BIN_DIR)/$(BIN_FILE)
	$(INSTALL) -m 755 $(SRC_DIR)/$(CONF_BIN_FILE) $(INSTALL_BIN_DIR)/$(CONF_BIN_FILE)
	$(LN) -s $(INSTALL_BIN_DIR)/$(BIN_FILE)-$(VER) $(INSTALL_BIN_DIR)/$(BIN_FILE)
	$(LN) -s $(INSTALL_BIN_DIR)/$(CONF_BIN_FILE)-$(VER) $(INSTALL_BIN_DIR)/$(BIN_FILE)
	$(INSTALL) -m 755 $(SRC_DIR)/$(LIB_SO_FILE) $(INSTALL_LIB_DIR)/$(LIB_SO_FILE)
	$(INSTALL) -m 664 $(SRC_DIR)/$(LIB_A_FILE) $(INSTALL_LIB_DIR)/$(LIB_A_FILE)
	$(LN) -s $(INSTALL_LIB_DIR)/$(LIB_SO_FILE) $(INSTALL_LIB_DIR)/$(LIB_SO_FILE_VERSIONED_MAJOR)
	$(LN) -s $(INSTALL_LIB_DIR)/$(LIB_A_FILE) $(INSTALL_LIB_DIR)/$(LIB_A_FILE_VERSIONED_MAJOR)
	$(LN) -s $(INSTALL_LIB_DIR)/$(LIB_SO_FILE_VERSIONED_MAJOR) $(INSTALL_LIB_DIR)/$(LIB_SO_FILE_UNVERSIONED)
	$(LN) -s $(INSTALL_LIB_DIR)/$(LIB_A_FILE_VERSIONED_MAJOR) $(INSTALL_LIB_DIR)/$(LIB_A_FILE_UNVERSIONED)
	$(INSTALL) -d -m 755 $(INSTALL_INCLUDE_DIR)/$(HEADER_DIR)
	$(INSTALL) -d -m 755 $(INSTALL_INCLUDE_DIR)/$(HEADER_DIR)/$(VER)
	$(LN) -s $(INSTALL_INCLUDE_DIR)/$(HEADER_DIR)/$(VER_MAJOR) $(INSTALL_INCLUDE_DIR)/$(HEADER_DIR)/$(VER)
	$(INSTALL) -m 664 $(HEADER_FILES) $(INSTALL_INCLUDE_DIR)/$(HEADER_DIR)/$(VER)
	$(INSTALL) -d -m 755 $(INSTALL_INCLUDE_DIR)/$(HEADER_DIR)/$(VER)/$(TARGET)
	$(INSTALL) -m 644 $(ARCH_HEADER_FILES) $(INSTALL_INCLUDE_DIR)/$(HEADER_DIR)/$(VER)/$(TARGET)

uninstall: is-valid
	$(RM) -rf \
		$(INSTALL_BIN_DIR)/$(BIN_FILE) \
		$(INSTALL_BIN_DIR)



is-valid:
	@if [ -z "$(TARGET)" ]; then \
		echo "Target not set."; \
		exit 1; \
	fi
	@if printf '%s\n' "$(AVAILABLE_TARGETS)" | grep -wqF '$(TARGET)'; then \
		echo "The given TARGET is valid."; \
	else \
		echo "The given TARGET is invalid."; \
		exit 1 \
	fi

clean:
	@make -C $(BUILD_MAKEF_DIR) clean

