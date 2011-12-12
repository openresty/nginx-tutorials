ver=$(shell date +'%Y.%m.%d')
name=agentzh-nginx-tutorials-zhcn-$(ver)
zhcn_tutfiles=$(sort $(wildcard zh-cn/*.tut))
zhcn_wikifiles=$(patsubst %.tut,wiki/%.wiki,$(zhcn_tutfiles))
zhcn_htmlfiles=$(patsubst %.tut,html/%.html,$(zhcn_tutfiles))

.PHONY: all
.PRECIOUS: $(zhcn_wikifiles) $(zhcn_htmlfiles)

#test: ; echo $(htmlfiles)

all: $(name).mobi $(name).epub

%.mobi: index-zhcn.html
	ebook-convert $< $@ \
	    --output-profile kindle_dx --no-inline-toc \
	    --title "$(name)" --publisher agentzh \
	    --language "cn" --authors 'agentzh'

%.epub: index-zhcn.html
	ebook-convert $< $@ \
	    --output-profile kindle_dx \
	    --title "$(name)" --publisher agentzh \
	    --language "cn" --authors 'agentzh'

index-zhcn.html: $(zhcn_htmlfiles)
	./utils/gen-html-index.pl -o $@ $^

html/%.html: wiki/%.wiki
	mkdir -p $(dir $@)
	./utils/wiki2html.pl -o $@ $<

wiki/%.wiki: %.tut
	mkdir -p $(dir $@)
	./utils/tut2wiki.pl -o $@ $<

clean:
	rm -rf html/ wiki/ index*.html *.mobi *.epub

