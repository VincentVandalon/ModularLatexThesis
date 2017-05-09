all: ch0.pdf ch1.pdf ch2.pdf 

cont:
	ls -d /home/vvandalon/phdRepos/Thesis/* | entr make -j
	#while inotifywait -m /home/vvandalon/phdRepos/Thesis/* do; make -j 

full-test:
	#Useful for testing layout changes but not recompiling the whole document
	$(eval TEMPDIR=build/)
	mkdir -p $(TEMPDIR)
	$(eval PDFLARGS=-interaction=batchmode -output-directory $(TEMPDIR))
	cat header.txt ch0.tex ch1.tex ch2.tex footer.txt > $(TEMPDIR)/full-thesis-merge.tex
	pdflatex $(PDFLARGS) $(TEMPDIR)/full-thesis-merge.tex
	bibtex $(TEMPDIR)/bu1
	bibtex $(TEMPDIR)/bu2
	pdflatex $(PDFLARGS) $(TEMPDIR)/full-thesis-merge.tex
	pdflatex $(PDFLARGS) $(TEMPDIR)/full-thesis-merge.tex
	cp $(TEMPDIR)/full-thesis-merge.pdf full-thesis.pdf

full:
	$(eval TEMPDIR=build/)
	mkdir -p $(TEMPDIR)
	$(eval PDFLARGS= -interaction=batchmode -output-directory $(TEMPDIR))
	cat header.txt ch0.tex ch1.tex ch2.tex footer.txt > $(TEMPDIR)/full-thesis-merge.tex
	pdflatex $(PDFLARGS) $(TEMPDIR)/full-thesis-merge.tex
	bibtex $(TEMPDIR)/bu1
	bibtex $(TEMPDIR)/bu2
	pdflatex $(PDFLARGS) $(TEMPDIR)/full-thesis-merge.tex
	pdflatex $(PDFLARGS) $(TEMPDIR)/full-thesis-merge.tex
	cp $(TEMPDIR)/full-thesis-merge.pdf full-thesis.pdf

%.pdf: %.tex header.txt footer.txt
	$(eval TEMPDIR=build/$(basename $<))
	mkdir -p $(TEMPDIR)
	$(eval PDFLARGS=-interaction=batchmode -output-directory $(TEMPDIR))
	cat header.txt $< footer.txt > $(TEMPDIR)/$(basename $<)-merge.tex
	#Make sure aux file exists and backup aux for change test
	touch $(TEMPDIR)/bu1.aux
	cp -f $(TEMPDIR)/bu1.aux $(TEMPDIR)/bu1old.aux
	#Do at least 1 compile step
	pdflatex $(PDFLARGS) $(TEMPDIR)/$(basename $<)-merge.tex
	#Check if aux has changed, if so do bibtex plus 2 more compiles
	@if cmp -s "$(TEMPDIR)/bu1.aux" "$(TEMPDIR)/bu1old.aux"; then \
		echo "Hooray... we are done quickly!"; \
	else \
		bibtex $(TEMPDIR)/bu1; \
		pdflatex $(PDFLARGS) $(TEMPDIR)/$(basename $<)-merge.tex; \
		pdflatex $(PDFLARGS) $(TEMPDIR)/$(basename $<)-merge.tex; \
		echo "Dang it!  Had to run full compile cycle"; \
	fi
	cp $(TEMPDIR)/$(basename $<)-merge.pdf $(basename $<).pdf

clean:
	rm -rf build/
	touch *tex
