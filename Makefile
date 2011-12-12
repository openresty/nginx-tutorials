ver=$(shell date +'%Y.%m.%d')
name=agentzh-nginx-tutorials-$(ver)
tutfiles=$(sort $(wildcard zh-cn/*.tut))
wikifiles=$(patsubst %.tut,wiki/%.wiki,$(tutfiles))
htmlfiles=$(patsubst %.tut,html/%.html,$(tutfiles))

.PHONY: all
.PRECIOUS: $(wikifiles) $(htmlfiles)

#test: ; echo $(htmlfiles)

all: $(name).mobi $(name).epub

%.mobi: index.html
	ebook-convert $< $@ \
	    --output-profile kindle_dx --no-inline-toc \
	    --title "$(name)" --publisher agentzh \
	    --language "cn" --authors 'agentzh'

%.epub: index.html
	ebook-convert $< $@ \
	    --output-profile kindle_dx --no-inline-toc \
	    --title "$(name)" --publisher agentzh \
	    --language "cn" --authors 'agentzh'

index.html: $(htmlfiles)
	./utils/gen-html-index.pl -o $@ $|

html/%.html: wiki/%.wiki
	mkdir -p $(dir $@)
	./utils/wiki2html.pl -o $@ $<

wiki/%.wiki: %.tut
	mkdir -p $(dir $@)
	./utils/tut2wiki.pl -o $@ $<

