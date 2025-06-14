PACKAGE_NAME = count-files
VERSION = 1.0
RELEASE = 1

BUILD_DIR = build
RPM_BUILD_DIR = $(BUILD_DIR)/rpm
DEB_BUILD_DIR = $(BUILD_DIR)/deb
SOURCES_DIR = $(RPM_BUILD_DIR)/SOURCES
SPECS_DIR = $(RPM_BUILD_DIR)/SPECS

.PHONY: all clean rpm deb prepare-rpm prepare-deb

all: rpm deb

prepare-rpm:
	mkdir -p $(SOURCES_DIR) $(SPECS_DIR)
	mkdir -p $(RPM_BUILD_DIR)/{BUILD,BUILDROOT,RPMS,SRPMS}
	
	mkdir -p $(PACKAGE_NAME)-$(VERSION)
	cp count_files.sh $(PACKAGE_NAME)-$(VERSION)/
	tar czf $(SOURCES_DIR)/$(PACKAGE_NAME)-$(VERSION).tar.gz $(PACKAGE_NAME)-$(VERSION)
	rm -rf $(PACKAGE_NAME)-$(VERSION)
	
	cp $(PACKAGE_NAME).spec $(SPECS_DIR)/

rpm: prepare-rpm
	rpmbuild --define "_topdir $(PWD)/$(RPM_BUILD_DIR)" \
		-ba $(SPECS_DIR)/$(PACKAGE_NAME).spec

prepare-deb:
	mkdir -p $(DEB_BUILD_DIR)
	cp -r debian $(DEB_BUILD_DIR)/
	cp count_files.sh $(DEB_BUILD_DIR)/
	chmod +x $(DEB_BUILD_DIR)/debian/rules

deb: prepare-deb
	cd $(DEB_BUILD_DIR) && debuild -us -uc

clean:
	rm -rf $(BUILD_DIR)
	rm -rf $(PACKAGE_NAME)-$(VERSION)
	rm -f *.deb *.rpm *.tar.gz

install-deps:
	sudo apt-get update
	sudo apt-get install -y build-essential devscripts debhelper rpm

test:
	bash count_files.sh
