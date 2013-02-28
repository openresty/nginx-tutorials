ver=$(shell date +'%Y.%m.%d')

.PHONY: all zhcn en clean

all: zhcn en

zhcn:
	$(MAKE) -f ebooks.mk

en:
	$(MAKE) -f ebooks.mk lang=$@ lang2=en src=en title="agentzh's Nginx Tutorials (ver $(ver))"

clean:
	rm -rf html/ wiki/ index*.html *.mobi *.epub *.pdf agentzh-nginx-tutorials-*.html

