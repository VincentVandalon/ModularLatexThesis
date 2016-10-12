PDFLARGS = -interaction=batchmode

all: ch0.pdf ch1.pdf

makebib:
	bibtex bu1

full:
	cat header.txt ch0.tex ch1.tex footer.txt > full-thesis-merge.tex
	pdflatex $(PDFLARGS) full-thesis-merge.tex
	bibtex bu1
	pdflatex $(PDFLARGS) full-thesis-merge.tex
	pdflatex $(PDFLARGS) full-thesis-merge.tex
	cp full-thesis-merge.pdf full-thesis.pdf


%.pdf: %.tex header.txt footer.txt
	cat header.txt $< footer.txt > $(basename $<)-merge.tex
	#Make sure aux file exists and backup aux for change test
	touch bu1.aux
	cp -f bu1.aux bu1old.aux
	#Do at least 1 compile step
	pdflatex $(PDFLARGS) $(basename $<)-merge.tex
	#Check if aux has changed, if so do bibtex plus 2 more compiles
	@if cmp -s "bu1.aux" "bu1old.aux"; then \
		echo "Hooray... we are done quickly!"; \
	else \
		bibtex bu1; \
		pdflatex $(PDFLARGS) $(basename $<)-merge.tex; \
		pdflatex $(PDFLARGS) $(basename $<)-merge.tex; \
		echo "Dang it!  Had to run full compile cycle"; \
	fi
	mv $(basename $<)-merge.pdf $(basename $<).pdf

clean:
	rm -f *aux *log *gz *bbl *blg 
	touch *tex
