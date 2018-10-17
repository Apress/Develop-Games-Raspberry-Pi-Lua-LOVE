# makefile

VER   = $(shell date +%y.%m.%d)
PDFTK = $(shell which pdftk 2>/dev/null || false)
TITLE = "love-lua"

ifeq "$(PDFTK)" ""
	PDFTK = pdf-stapler
endif

build:
	mkdir $@

help:
	@echo "make chapter=xml/foo.xml odt: Generate only foo.xml as ODT."
	@echo "make html:                    Generate book as HTML."
	@echo "make txt:                     Generate book as plain text."
	@echo "make epub:                    Generate book as an epub."
	@echo "make pdf:                     Generate book as an PDF."
	@echo "make release:                 Build a release ZIP file."
	@echo "make clean:                   Remove temporary build files."
	@echo "make nuke:                    Remove temporary build and release files."

concat: src/header.xml src/footer.xml build
	@test -d build || mkdir build
	@cat src/header.xml \
	src/start.xml \
	src/script.xml \
	src/files.xml \
	src/analogue.xml \
	src/db.xml \
	src/graphic.xml \
	src/battle.xml \
	src/mechanic.xml \
	src/power.xml \
	src/state.xml \
	src/sound.xml \
	src/rogue.xml \
	src/publish.xml \
	src/next.xml \
	src/dragndrop.xml \
	src/git.xml \
	src/footer.xml > src/tmp.xml

odt:
	@cat $(chapter) > tmp.xml
	docbook2odf tmp.xml --output-file $(notdir $(addsuffix .odt,$(basename $(chapter))))

html:	build concat
	@mkdir dist  || true
	xmlto --skip-validation -o build html-nochunks src/tmp.xml
	@mv build/tmp.html dist/$(TITLE)-$(VER).html

txt:	build concat
	@mkdir dist  || true
	xmlto --skip-validation -o build txt src/tmp.xml
	@mv build/tmp.txt dist/$(TITLE)$(VER).txt

epub:	build concat
	@mkdir build/epub || true
	xsltproc --output build/epub/ docbook/epub/docbook.xsl src/tmp.xml
	@convert img/cover/cover_front.tif build/epub/OEBPS/cover.jpeg
	@cat style/style.css > build/epub/OEBPS/style.css 
	@sed -i 's_../img/__g' build/epub/OEBPS/index.html
	@sed -i 's_../img/__g' build/epub/OEBPS/content.opf
	@sed -i 's_jpeg" media-type=""/>_jpeg" media-type="image/jpeg"/>_g' build/epub/OEBPS/content.opf
	@sed -i 's_ncx"/>_ncx"/><item id="idm0" href="Andada-Regular.ttf" media-type="application/x-font-ttf"/><item id="idm2" href="cover.jpeg" media-type="image/jpeg"/><item id="idm3" href="junction-bold.ttf" media-type="application/x-font-ttf"/><item id="idm4" href="junction-light.ttf" media-type="application/x-font-ttf"/><item id="idm5" href="junction-regular.ttf" media-type="application/x-font-ttf"/><item id="idm6" href="style.css" media-type="text/css"/><item id="idm7" href="texgyrebonum-bold.ttf" media-type="application/x-font-ttf"/><item id="idm8" href="texgyrebonum-bolditalic.ttf" media-type="application/x-font-ttf"/><item id="idm9" href="texgyrebonum-italic.ttf" media-type="application/x-font-ttf"/><item id="idm10" href="texgyrebonum-regular.ttf" media-type="application/x-font-ttf"/>_' build/epub/OEBPS/content.opf
	@find build/epub/OEBPS/ -name "*html" -exec sed -i 's_<head>_<head>\n\n_' {} \;
	@find build/epub/OEBPS/ -name "*html" -exec sed -i 's_</head>_<link rel="stylesheet" href="style.css" /></head>_' {} \;
	@mv build/epub/OEBPS .
	@mv build/epub/META-INF .
	@cat src/mimetype > mimetype
	@zip -X -0 $(TITLE)-$(VER).epub mimetype
	@rm mimetype
	@zip -X -9 $(TITLE)-$(VER).epub -r META-INF OEBPS
	@rm -rf META-INF OEBPS
	@mv $(TITLE)-$(VER).epub dist

pdf:	build concat
	@mkdir build || true
	@mkdir dist  || true
	@echo "This may take a while..."
	xsltproc --output build/tmp.fo \
	docbook/fo/docbook.xsl src/tmp.xml 
	fop build/tmp.fo build/tmp.pdf
	@mv build/tmp.pdf dist/$(TITLE)-$(VER).pdf || true

release:
	@mkdir $(TITLE)-$(VER)
	@cp dist/$(TITLE).* \
	LICENSE README.md \
	$(TITLE)-$(VER)
	@zip $(TITLE)-$(VER).zip -r \
	$(TITLE)-$(VER)

clean:
	@rm -rf build
	@rm -f src/tmp*xml
	@rm -f *.tmp
	@rm -rf OEBPS
	@rm -rf META_INF

nuke:	clean
	@rm -rf dist

