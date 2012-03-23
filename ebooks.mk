lang=zhcn
lang2=cn
src=zh-cn
ver=$(shell date +'%Y.%m.%d')
title=agentzh的Nginx教程（$(ver)版）
name=agentzh-nginx-tutorials-$(lang)
tutfiles=$(sort $(wildcard $(src)/*.tut))
wikifiles=$(patsubst %.tut,wiki/%.wiki,$(tutfiles))
htmlfiles=$(patsubst %.tut,html/%.html,$(tutfiles))

.PHONY: all mobi epub pdf html

.PRECIOUS: $(wikifiles) $(htmlfiles)

all: mobi epub pdf html
	
mobi: $(name).mobi
	
epub: $(name).epub
	
pdf: $(name).pdf

html: $(name).html

%.pdf: $(name).html
	ebook-convert $< $@ \
	    --margin-bottom 30 \
	    --margin-top 30 \
	    --margin-left 20 \
	    --margin-right 20 \
	    --no-chapters-in-toc \
	    --book-producer 'agentzh' \
	    --output-profile kindle \
	    --title "$(title)" --publisher 'agentzh' \
	    --language $(lang2) --authors 'agentzh'

%.mobi: $(name).html
	ebook-convert $< $@ \
	    --output-profile kindle_dx --no-inline-toc \
	    --title "$(title)" --publisher 'agentzh' \
	    --language $(lang2) --authors 'agentzh'

%.epub: $(name).html
	ebook-convert $< $@ \
	    --no-default-epub-cover \
	    --output-profile kindle_dx \
	    --title "$(title)" --publisher 'agentzh' \
	    --language $(lang2) --authors 'agentzh'

$(name).html: $(htmlfiles)
	./utils/gen-html-index-$(lang2).pl -v $(ver) -o $@ $^

html/%.html: wiki/%.wiki ./utils/wiki2html-$(lang2).pl
	mkdir -p $(dir $@)
	./utils/wiki2html-$(lang2).pl -o $@ $<

wiki/%.wiki: %.tut ./utils/tut2wiki-$(lang2).pl
	mkdir -p $(dir $@)
	./utils/tut2wiki-$(lang2).pl -o $@ $<

#test: ; echo $(htmlfiles)

