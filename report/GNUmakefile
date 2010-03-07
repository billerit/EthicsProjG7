

ORIG:=handin
PROJECT:=output

BIBFILE:=bibliography.bib

TEX_FILES:=$(shell find . -name "*.tex" | grep -v "/\.")

SHELL:=/bin/bash

LATEX:=latex --file-line-error --interaction=nonstopmode
PDFLATEX:=pdflatex --file-line-error --interaction=nonstopmode

NONUMPAGES:=/formalia/

.PHONY: all pdf ps clean distclean

all: pdf

pdf: $(PROJECT).pdf
ps: $(PROJECT).ps
dvi: $(PROJECT).dvi


.GNUmakefile.dep: $(TEX_FILES) $(BIBFILE) GNUmakefile
	echo _$(PROJECT).dvi _$(PROJECT).pdf: $^ > $@

include .GNUmakefile.dep

_%.tex: %.tex
	if [ -h $@ ]; then rm $@; fi
	ln -s $< $@

_%.dvi _%.pdf: _%.tex
	lhs2TeX --poly $(ORIG).tex  > $(PROJECT).tex
	if echo $@ | grep 'pdf$$' >/dev/null;\
	  then export CMD="$(PDFLATEX)";\
	  else export CMD="$(LATEX)";\
	fi;\
	$$CMD _$*;\
	cat _$*.aux  | grep '^\\citation' | sort | uniq > _$*.new_cite;\
	if diff -q _$*.new_cite _$*.cite 2>&1 >/dev/null \
	    && [ _$*.cite -nt $(BIBFILE) ];\
	  then echo "bibtex unnecessary";\
	  else echo "running bibtex"; bibtex _$*; $$CMD _$*;\
	fi;\
	mv _$*.new_cite _$*.cite;\
	while grep -i rerun _$*.log;\
	  do $$CMD _$*;\
	done;\
	echo -e "\nFiles changed: $?\n";\
	if cat _$*.log | \
	  grep -v '$(NONUMPAGES).*\.tex:[0-9]\+: pdfTeX warning (ext4): destination ' | \
	  grep -v '_$*\.tex:[0-9]\+: pdfTeX warning (ext4): destination ' | \
	  grep -q '\.tex:[0-9]\+:';\
	then rm $@;\
	  echo -e "\n\nErrors in input:";\
	  cat _$*.log | \
	  grep -v '$(NONUMPAGES).*\.tex:[0-9]\+: pdfTeX warning (ext4): destination ' | \
	  grep -v '_$*\.tex:[0-9]\+: pdfTeX warning (ext4): destination ' | \
	  grep -A 9 '\.tex:[0-9]\+:' | sed -n '/tex:[0-9]\+:/,/^ *$$/ p';\
	  false;\
	fi

_%.ps: _%.dvi
	lhs2TeX --poly $(ORIG).tex  > $(PROJECT).tex
	dvips -o $@ $<

%.dvi: _%.dvi
	cp $< $@

%.pdf: _%.pdf
	cp $< $@
	if [ 0 -lt `ps xf | grep "xpdf -remote $(PROJECT)" \
	  | grep -v "grep xpdf -remote $(PROJECT)" | wc -l` ]; \
	then xpdf -remote $(PROJECT) -reload; \
	fi

%.ps: _%.ps
	cp $< $@



clean:
	rm -f _*
	rm -f .GNUmakefile.dep

distclean: clean
	if [ -n "`find . -name .auto`" ];\
	  then find . -name .auto -print | xargs rm -r;\
	fi
	find . -name "*~" -delete
	rm -f $(PROJECT).pdf $(PROJECT).ps
