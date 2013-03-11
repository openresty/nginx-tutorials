ver=$(shell date +'%Y.%m.%d')

.PHONY: all zhcn en clean html

all: zhcn en

zhcn:
	$(MAKE) -f ebooks.mk lang=$@ lang2=cn src=zh-cn title="agentzh的Nginx教程（$(ver)版）"

en:
	$(MAKE) -f ebooks.mk

html:
	$(MAKE) -f ebooks.mk lang=cn lang2=cn src=zh-cn title="agentzh的Nginx教程（$(ver)版）" html
	$(MAKE) -f ebooks.mk html

clean:
	rm -rf html/ wiki/ index*.html *.mobi *.epub *.pdf agentzh-nginx-tutorials-*.html

