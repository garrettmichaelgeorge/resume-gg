# Based on:
# https://tex.stackexchange.com/a/40759
# https://github.com/dnadales/nix-latex-template/blob/3acf1e24186cfa7af069072c6223c263d364bc79/Makefile

DOCNAME = document
LATEX_BACKEND = -xelatex

# You want latexmk to *always* run, because make does not have all the info.
# Also, include non-file targets in .PHONY so they are run regardless of any
# file of the given name existing.
.PHONY: $(DOCNAME).pdf all watch clean install

# The first rule in a Makefile is the one executed by default ("make"). It
# should always be the "all" rule, so that "make" and "make all" are identical.
all: $(DOCNAME).pdf

# CUSTOM BUILD RULES

# In case you didn't know, '$@' is a variable holding the name of the target,
# and '$<' is a variable holding the (first) dependency of a rule.
# "raw2tex" and "dat2tex" are just placeholders for whatever custom steps
# you might have.

%.tex: %.raw
	./raw2tex $< > $@

%.tex: %.dat
	./dat2tex $< > $@

# MAIN LATEXMK RULE

# -pdf tells latexmk to generate PDF directly (instead of DVI).
# -xelatex tells latexmk to call a specific backend with specific options.
# -use-make tells latexmk to call make for generating missing files.
# -interaction=nonstopmode keeps the pdflatex backend from stopping at a
# missing file reference and interactively asking you for an alternative.

$(DOCNAME).pdf: $(DOCNAME).tex
	latexmk -pdf -time $(LATEX_BACKEND) -interaction=nonstopmode -use-make $(DOCNAME).tex

watch: $(DOCNAME).tex
	latexmk -pvc -pdf $(LATEX_BACKEND) -interaction=nonstopmode -use-make -synctex=1 $(DOCNAME).tex

clean:
	latexmk -CA

install:
	mkdir -pv ${out}/nix-support/
	cp $(DOCNAME).pdf ${out}/
