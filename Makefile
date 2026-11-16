# HHME Installation Manager

# directories
SRC_DIR          := src
BUILD_MAKEF_DIR  := $(SRC_DIR)

# input
export TARGET    :=

# version info
VER              := 0.1
VER_MAJOR        := 0

AVAILABLE_TARGETS := 32v1

# installation paths
PREFIX           ?= /usr/local
INSTALL_DIR      := $(PREFIX)
INSTALL_BIN_DIR  := $(INSTALL_DIR)/bin
INSTALL_LIB_DIR  := $(INSTALL_DIR)/lib
INSTALL_INCLUDE_DIR := $(INSTALL_DIR)/include

# tools
INSTALL          := install
RM               := rm
LN               := ln
FIND             := find

# output names
export BIN_FILE              := hhme-$(TARGET)-$(VER)
export CONF_BIN_FILE         := hhme-$(TARGET)-config-$(VER)
export LIB_SO_FILE           := libHHME-$(TARGET).so.$(VER)
export LIB_A_FILE            := libHHME-$(TARGET).a.$(VER)

BIN_FILE_UNVERSIONED         := hhme-$(TARGET)
CONF_BIN_FILE_UNVERSIONED    := hhme-$(TARGET)-config
LIB_SO_FILE_MAJOR            := libHHME-$(TARGET).so.$(VER_MAJOR)
LIB_A_FILE_MAJOR             := libHHME-$(TARGET).a.$(VER_MAJOR)
LIB_SO_FILE_UNVERSIONED      := libHHME-$(TARGET).so
LIB_A_FILE_UNVERSIONED       := libHHME-$(TARGET).a

# headers
HEADER_DIR       := HHME
HEADER_FILES     := $(SRC_DIR)/api/*
ARCH_HEADER_FILES := $(SRC_DIR)/hca/$(TARGET)/api/*


.PHONY: all help available-targets version build install uninstall uninstall-all is-valid clean


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
	@echo "  PREFIX                     Installation prefix (default: /usr/local)."
	@echo "  DESTDIR                    Staging directory for packaging (default: empty)."
	@echo "  INSTALL_DIR                '$(INSTALL_DIR)'"
	@echo "  INSTALL_BIN_DIR            '$(INSTALL_BIN_DIR)'"
	@echo "  INSTALL_LIB_DIR            '$(INSTALL_LIB_DIR)'"
	@echo "  INSTALL_INCLUDE_DIR        '$(INSTALL_INCLUDE_DIR)'"
	@echo
	@echo "Options:"
	@echo "  help                       Shows this help."
	@echo "  available-targets          Shows all available emulator targets."
	@echo "  version                    Shows the current version."
	@echo "  build                      Builds the emulator for the given TARGET."
	@echo "  install                    Installs the emulator for the given TARGET."
	@echo "  uninstall                  Uninstalls the emulator for the given TARGET."
	@echo "  uninstall-all              Uninstalls all installed HHME files."
	@echo "  is-valid                   Checks if the given TARGET is valid."
	@echo "  clean                      Removes build artifacts."

available-targets:
	@echo $(AVAILABLE_TARGETS)

version:
	@echo $(VER)


is-valid:
	@if [ -z "$(TARGET)" ]; then \
		echo "Error: TARGET not set."; \
		exit 1; \
	fi
	@if printf '%s\n' $(AVAILABLE_TARGETS) | grep -wqF ' \)(TARGET)'; then \
		echo "Error: invalid TARGET '$(TARGET)'."; \
		echo "Available targets: $(AVAILABLE_TARGETS)"; \
		exit 1; \
	fi


build: is-valid
	@$(MAKE) -C $(BUILD_MAKEF_DIR) build

install: is-valid build
	$(INSTALL) -m 755 $(SRC_DIR)/$(BIN_FILE) $(INSTALL_BIN_DIR)/$(BIN_FILE)
	$(INSTALL) -m 755 $(SRC_DIR)/$(CONF_BIN_FILE) $(INSTALL_BIN_DIR)/$(CONF_BIN_FILE)
	$(LN) -sfn $(BIN_FILE) $(INSTALL_BIN_DIR)/$(BIN_FILE_UNVERSIONED)
	$(LN) -sfn $(CONF_BIN_FILE) $(INSTALL_BIN_DIR)/$(CONF_BIN_FILE_UNVERSIONED)
	$(INSTALL) -m 755 $(SRC_DIR)/$(LIB_SO_FILE) $(INSTALL_LIB_DIR)/$(LIB_SO_FILE)
	$(INSTALL) -m 644 $(SRC_DIR)/$(LIB_A_FILE) $(INSTALL_LIB_DIR)/$(LIB_A_FILE)
	$(LN) -sfn $(LIB_SO_FILE) $(INSTALL_LIB_DIR)/$(LIB_SO_FILE_MAJOR)
	$(LN) -sfn $(LIB_A_FILE) $(INSTALL_LIB_DIR)/$(LIB_A_FILE_MAJOR)
	$(LN) -sfn $(LIB_SO_FILE_MAJOR) $(INSTALL_LIB_DIR)/$(LIB_SO_FILE_UNVERSIONED)
	$(LN) -sfn $(LIB_A_FILE_MAJOR) $(INSTALL_LIB_DIR)/$(LIB_A_FILE_UNVERSIONED)
	$(INSTALL) -d -m 755 $(INSTALL_INCLUDE_DIR)/$(HEADER_DIR)/$(VER)
	$(INSTALL) -m 644 $(HEADER_FILES) $(INSTALL_INCLUDE_DIR)/$(HEADER_DIR)/$(VER)
	$(INSTALL) -d -m 755 $(INSTALL_INCLUDE_DIR)/$(HEADER_DIR)/$(VER)/$(TARGET)
	$(INSTALL) -m 644 $(ARCH_HEADER_FILES) $(INSTALL_INCLUDE_DIR)/$(HEADER_DIR)/$(VER)/$(TARGET)
	$(LN) -sfn $(VER) $(INSTALL_INCLUDE_DIR)/$(HEADER_DIR)/$(VER_MAJOR)

uninstall: is-valid
	$(RM) -f \
		$(INSTALL_BIN_DIR)/(BIN_FILE) \
		$(INSTALL_BIN_DIR)/(CONF_BIN_FILE) \
		$(INSTALL_BIN_DIR)/(BIN_FILE_UNVERSIONED) \
		$(INSTALL_BIN_DIR)/(CONF_BIN_FILE_UNVERSIONED) \
		$(INSTALL_LIB_DIR)/(LIB_SO_FILE) \
		$(INSTALL_LIB_DIR)/(LIB_A_FILE) \
		$(INSTALL_LIB_DIR)/(LIB_SO_FILE_MAJOR) \
		$(INSTALL_LIB_DIR)/(LIB_A_FILE_MAJOR) \
		$(INSTALL_LIB_DIR)/(LIB_SO_FILE_UNVERSIONED) \
		$(INSTALL_LIB_DIR)/(LIB_A_FILE_UNVERSIONED)
	$(RM) -rf $(INSTALL_INCLUDE_DIR)/(HEADER_DIR)/$(VER)/(TARGET)

uninstall-all:
	$(RM) -f $(INSTALL_BIN_DIR)/hhme-* $(INSTALL_BIN_DIR)/hhme-*-config*
	$(RM) -f $(INSTALL_LIB_DIR)/libHHME-*
	$(RM) -rf $(INSTALL_INCLUDE_DIR)/$(HEADER_DIR)


clean:
	@$(MAKE) -C $(BUILD_MAKEF_DIR) clean