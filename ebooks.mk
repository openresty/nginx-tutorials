lang= en
lang2= en
src= en
ver= $(shell date +'%Y.%m.%d')
title= agentzh's Nginx Tutorials (ver $(ver))
name= agentzh-nginx-tutorials-$(lang)
tutfiles= $(sort $(wildcard $(src)/*.tut))
wikifiles= $(patsubst %.tut,wiki/%.wiki,$(tutfiles))
htmlfiles= $(patsubst %.tut,html/%.html,$(tutfiles))

.PHONY: all mobi epub pdf html

.PRECIOUS: $(wikifiles) $(htmlfiles)

all: mobi epub pdf html
	
mobi: $(name).mobi
	
epub: $(name).epub
	
pdf: $(name).pdf

html: $(name).html

%.pdf: $(name).html
	cp tutorial-simple.css tutorial.css
	ebook-convert $< $@ \
	    --margin-bottom 25 \
	    --margin-top 25 \
	    --margin-left 20 \
	    --margin-right 20 \
	    --no-chapters-in-toc \
	    --book-producer 'agentzh' \
	    --pdf-default-font-size 1 \
	    --pdf-mono-font-size 1 \
	    --paper-size a4 \
	    --output-profile kindle \
	    --title "$(title)" --publisher 'agentzh' \
	    --language $(lang2) --authors 'agentzh'
	git co tutorial.css

%.mobi: $(name).html
	cp tutorial-simple.css tutorial.css
	ebook-convert $< $@ \
	    --output-profile kindle_dx --no-inline-toc \
	    --title "$(title)" --publisher 'agentzh' \
	    --language $(lang2) --authors 'agentzh'
	git co tutorial.css

%.epub: $(name).html
	cp tutorial-simple.css tutorial.css
	ebook-convert $< $@ \
	    --no-default-epub-cover \
	    --output-profile kindle_dx \
	    --title "$(title)" --publisher 'agentzh' \
	    --language $(lang2) --authors 'agentzh'
	git co tutorial.css

$(name).html: $(htmlfiles) ./utils/gen-html-index-$(lang2).pl
	./utils/gen-html-index-$(lang2).pl -v $(ver) -o $@ $(htmlfiles)

html/%.html: wiki/%.wiki ./utils/wiki2html-$(lang2).pl
	mkdir -p $(dir $@)
	./utils/wiki2html-$(lang2).pl -o $@ $<

wiki/%.wiki: %.tut ./utils/tut2wiki-$(lang2).pl
	mkdir -p $(dir $@)
	./utils/tut2wiki-$(lang2).pl -o $@ $<

#test: ; echo $(htmlfiles)
