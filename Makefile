bindir = /usr/bin
datadir = /usr/share
sitelib = /usr/lib/python2.6/site-packages
pixmaps = $(datadir)/pixmaps
version = 0.5.4

install = install -p
mkdir = mkdir -p
cp = cp -a

default:
	echo Nothing to do.

clean:
	rm -f po/untitled.pot
	rm -f *.tar.*
	rm -f gbirthday.desktop
	rm -rf gbirthday-$(version) BUILDROOT noarch
	rm -f gbirthday*.src.rpm

install:
	intltool-merge -d ./po ./gbirthday.desktop.in ./gbirthday.desktop
	sed -i "s|@VER@|$(version)|g" src/gbirthday/__init__.py
	$(mkdir) $(DESTDIR)$(pixmaps)
	$(install) -m 644 pics/gbirthday.png $(DESTDIR)$(pixmaps)
	$(mkdir) $(DESTDIR)$(sitelib)
	$(cp) src/gbirthday/ $(DESTDIR)$(sitelib)
	$(mkdir) $(DESTDIR)$(datadir)/applications/
	$(install) -m 644 gbirthday.desktop \
		$(DESTDIR)$(datadir)/applications/
	$(mkdir) $(DESTDIR)$(bindir)
	$(install) -m 755 src/gb $(DESTDIR)$(bindir)/gbirthday
	cd po && python install_po.py $(DESTDIR)

uninstall:
	rm -rvf $(DESTDIR)$(bindir)/gbirthday
	rm -rvf $(DESTDIR)$(datadir)/applications/gbirthday.desktop
	rm -rvf $(DESTDIR)$(datadir)/locale/*/LC_MESSAGES/gbirthday.mo
	rm -rvf $(DESTDIR)$(pixmaps)/gbirthday.png
	rm -rvf $(DESTDIR)$(sitelib)/gbirthday

tar.gz:	clean
	tar --exclude=.git \
		-zcf gbirthday-$(version).tar.gz *

tar.xz: clean
	tar --use-compress-program=xz --exclude=.git \
		-cf gbirthday-$(version).tar.xz *

pot:
	cd po && intltool-update --pot

rpm:	tar.xz
	cp gbirthday-*.tar.xz ~/rpmbuild/SOURCES
	rpmbuild -ba gbirthday.spec
