ver=$(shell date +'%Y.%m.%d')

.PHONY: all zhcn en clean

all: zhcn en

zhcn:
	$(MAKE) -f ebooks.mk lang=$@ lang2=cn src=zh-cn title="agentzh的Nginx教程（$(ver)版）"
	$(MAKE) -f ebooks.mk

en:
	$(MAKE) -f ebooks.mk

clean:
	rm -rf html/ wiki/ index*.html *.mobi *.epub *.pdf agentzh-nginx-tutorials-*.html

