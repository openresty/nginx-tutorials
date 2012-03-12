ver=$(shell date +'%Y.%m.%d')
name=agentzh-nginx-tutorials-zhcn
zhcn_tutfiles=$(sort $(wildcard zh-cn/*.tut))
zhcn_wikifiles=$(patsubst %.tut,wiki/%.wiki,$(zhcn_tutfiles))
zhcn_htmlfiles=$(patsubst %.tut,html/%.html,$(zhcn_tutfiles))

.PHONY: all mobi clean epub pdf html

.PRECIOUS: $(zhcn_wikifiles) $(zhcn_htmlfiles)

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
	    --title "agentzh的Nginx教程（$(ver)版）" --publisher 'agentzh' \
	    --language "cn" --authors 'agentzh'

%.mobi: $(name).html
	ebook-convert $< $@ \
	    --output-profile kindle_dx --no-inline-toc \
	    --title "agentzh的Nginx教程（$(ver)版）" --publisher '章亦春 (agentzh)' \
	    --language "cn" --authors '章亦春 (agentzh)'

%.epub: $(name).html
	ebook-convert $< $@ \
	    --no-default-epub-cover \
	    --output-profile kindle_dx \
	    --title "agentzh的Nginx教程（$(ver)版）" --publisher '章亦春 (agentzh)' \
	    --language "cn" --authors '章亦春 (agentzh)'

$(name).html: $(zhcn_htmlfiles)
	./utils/gen-html-index.pl -v $(ver) -o $@ $^

html/%.html: wiki/%.wiki
	mkdir -p $(dir $@)
	./utils/wiki2html.pl -o $@ $<

wiki/%.wiki: %.tut
	mkdir -p $(dir $@)
	./utils/tut2wiki.pl -o $@ $<

clean:
	rm -rf html/ wiki/ index*.html *.mobi *.epub *.pdf

#test: ; echo $(zhcn_htmlfiles)

