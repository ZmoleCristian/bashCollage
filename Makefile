PREFIX = /usr/local

collage: collage.sh
	cat collage.sh > $@

	chmod +x $@

test: collage.sh
	shellcheck -s sh collage.sh

clean:
	rm -f collage

install: collage
	./installReq.sh
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f collage $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/collage

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/collage

.PHONY: test clean install uninstall