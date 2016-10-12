all: ch0.pdf ch1.pdf


full:
	$(eval TEMPDIR=build/$(basename $<))
	mkdir -p $(TEMPDIR)
	$(eval PDFLARGS=-interaction=batchmode -output-directory $(TEMPDIR))
	cat header.txt ch0.tex ch1.tex footer.txt > full-thesis-merge.tex
	pdflatex $(PDFLARGS) full-thesis-merge.tex
	bibtex $(TEMPDIR)/bu1
	pdflatex $(PDFLARGS) full-thesis-merge.tex
	pdflatex $(PDFLARGS) full-thesis-merge.tex
	cp $(TEMPDIR)/full-thesis-merge.pdf full-thesis.pdf


%.pdf: %.tex header.txt footer.txt
	$(eval TEMPDIR=build/$(basename $<))
	mkdir -p $(TEMPDIR)
	$(eval PDFLARGS=-interaction=batchmode -output-directory $(TEMPDIR))
	cat header.txt $< footer.txt > $(basename $<)-merge.tex
	#Make sure aux file exists and backup aux for change test
	touch $(TEMPDIR)/bu1.aux
	cp -f $(TEMPDIR)/bu1.aux $(TEMPDIR)/bu1old.aux
	#Do at least 1 compile step
	pdflatex $(PDFLARGS) $(basename $<)-merge.tex
	#Check if aux has changed, if so do bibtex plus 2 more compiles
	@if cmp -s "$(TEMPDIR)/bu1.aux" "$(TEMPDIR)/bu1old.aux"; then \
		echo "Hooray... we are done quickly!"; \
	else \
		bibtex $(TEMPDIR)/bu1; \
		pdflatex $(PDFLARGS) $(basename $<)-merge.tex; \
		pdflatex $(PDFLARGS) $(basename $<)-merge.tex; \
		echo "Dang it!  Had to run full compile cycle"; \
	fi
	cp $(TEMPDIR)/$(basename $<)-merge.pdf $(basename $<).pdf

clean:
	rm -rf build/
	rm *merge*
	touch *tex
