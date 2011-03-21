include Rules.make
include Makefile.KM.Android

.PHONY: all

clean: clean_km

all: all_km 

install: install_km

############################# HELP ##################################
help:
	@echo ""
	@echo "Update Rules.make file"
	@echo "Usage (for build): make"
	@echo "Usage (for install): make OMAPES={2.x | 3.x | 5.x | 6.x} install"
	@echo "OMAPES=3.x for OMAP3530, OMAPES=5.x for OMAP3730, OMAPES=6.x for TI8168"
	@echo "--> See online Graphics Getting Started Guide for further details."
	@echo ""

###########################################################################

