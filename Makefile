# Parameteric Commands for TeX Maker (separate them with | ):
#
# xelatex -halt-on-error -shell-escape -interaction=nonstopmode -synctex=-1 -output-driver='xdvipdfmx -E -V 5 ' %.tex
# bibtex %
# xindy --language persian --codepage utf8 --input-markup xindy --module % --log-file %.fa.glg --out-file %.fa.gls %.fa.glo
# xindy --language english --codepage utf8 --input-markup xindy --module % --log-file %.en.glg --out-file %.en.gls %.en.glo
# xelatex -halt-on-error -shell-escape -interaction=nonstopmode -synctex=-1 -output-driver='xdvipdfmx -E -V 5 ' %.tex
# xelatex -halt-on-error -shell-escape -interaction=nonstopmode -synctex=-1 -output-driver='xdvipdfmx -E -V 5 ' %.tex
# xelatex -halt-on-error -shell-escape -interaction=nonstopmode -synctex=-1 -output-driver='xdvipdfmx -E -V 5 ' %.tex
#
# Plain Commands for command line:
#
# xelatex -halt-on-error -shell-escape -interaction=nonstopmode -synctex=-1  -output-driver='xdvipdfmx -E -V 5 ' proposal.tex 
# bibtex proposal
# xindy --language persian --codepage utf8 --input-markup xindy --module proposal --log-file proposal.fa.glg --out-file proposal.fa.gls proposal.fa.glo
# xindy --language english --codepage utf8 --input-markup xindy --module proposal --log-file proposal.en.glg --out-file proposal.en.gls proposal.en.glo
# xelatex -halt-on-error -shell-escape -interaction=nonstopmode -synctex=-1  -output-driver='xdvipdfmx -E -V 5 ' proposal.tex 
# xelatex -halt-on-error -shell-escape -interaction=nonstopmode -synctex=-1  -output-driver='xdvipdfmx -E -V 5 ' proposal.tex 
# xelatex -halt-on-error -shell-escape -interaction=nonstopmode -synctex=-1  -output-driver='xdvipdfmx -E -V 5 ' proposal.tex 

# To convert a PDF file to a PNG file, use convert in ImageMagick package:
# -density <dpi>
# -transparent <color>
# convert -density 300 -transparent white file.pdf file.png

# To convert all proposal-figure*.pdfs to the corresponding pngs:
# for FIG in proposal-figure*.pdf ; do convert -density 300 -transparent white $FIG ${FIG%.pdf}.png; done

# To combine multiple pdfs:
# gs -dNOPAUSE -sDEVICE=pdfwrite -sOUTPUTFILE=output.pdf -dBATCH 1.pdf 2.pdf 3.pdf
# SEE PDFTK too

# To extract specific pages from a PDF:
# gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -dFirstPage=441 -dLastPage=445 -sOutputFile=output.pdf input.pdf
# SEE PDFTK too

# To find the repository location:
# svn info .

#To reduce color map size
# convert page1.png -colors 32 page1b.png

#To convert multiple PNG files to PDF 
# convert page*.png mydoc.pdf 
#If you get an incorrect page count (recently I saw this when converting two PNG files to a PDF, it gave me page count of 1), you can try the following: 
#
#    convert page*.png mydoc.ps
#    ps2pdf13 mydoc.ps
#    if stuff from a scanned A4 page does not show up correctly, you can try:
#    ps2pdf13 -sPAPERSIZE=a4 mydoc.ps 

# $(call ...) can be used to create make functions

# Create and apply patches (including binary files)
# DIFF: svn diff --force --diff-cmd /usr/bin/diff -x "-au --binary" > binarydiff-from-r426.diff
# PATCH: patch -p0 --binary -i binarydiff-from-r426.diff
# Note: the diff command above doesn't consider files that are not uncer version control

# to convert libreoffice files to other files: http://ask.libreoffice.org/en/question/2641/convert-to-command-line-parameter/

# pdfcrop can ei­ther trim pages of any whites­pace bor­der, or trim them of a fixed bor­der.
# SEE PDFTK too


SRC = $(basename $(shell egrep -l '^[^%]*\\begin\{document\}' *.tex))

ifneq "$(words $(SRC))" "1"
$(error "More than one targets or no target found: $(SRC)")
endif

$(info ================ Make file for: $(SRC).tex ================)

#Options that are set only by the user:
# $(OTHERFILES)

#############################
##   Commands and options  ##
#############################
TEX=xelatex
BIB=bibtex
XINDY=xindy

# Output PDF minor version - Uncomment to take effect
#PDFMINORVER=5

# Options for quiet execution
BIBOPTIONS=-terse
XINDYOPTIONS=-q

# Base TeX options
# Shell-escape is needed for pgf/tikz externalization environment.
TEXOPTIONS=-halt-on-error -interaction=batchmode -shell-escape
#TEXOPTIONS=-halt-on-error -interaction=batchmode

# Draftoptions: must not output any pdf
TEXDRAFTOPTIONS=$(TEXOPTIONS) -no-pdf

# The following options can be used in the .tex file to control PDF creation:
#	\pdfcompresslevel=9
#	\pdfdecimaldigits=3
#	\pdfhorigin=1 true in
#	\pdfoutput=1
#	\pdfpageheight=297 true mm
#	\pdfpagewidth=210 true mm
#	\pdfminorversion=5
#	\pdfpkresolution=600
#	\pdfvorigin=1 true in
# see http://tex.stackexchange.com/questions/78248/how-to-force-pdfminorversion-globally
ifdef $(PDFMINORVER)
TEXFINALOPTIONS=$(TEXOPTIONS) -synctex=-1 -output-driver='xdvipdfmx -E -V $(PDFMINORVER) '
else
TEXFINALOPTIONS=$(TEXOPTIONS) -synctex=-1
endif

SUFF = >/dev/null

#############################
##          Files          ##
#############################
# Included tex files (including the source)
TEXSRC=$(wildcard *.tex)

# Biblography items
BIBSRC=$(wildcard *.bib)

IMAGEDIR=images

# SVG graphics
SVG0=$(wildcard $(IMAGEDIR)/*.svg)

SVGOUT=$(addsuffix .pdf,$(basename $(SVGSRC))) \
	$(addsuffix .pdf_tex,$(basename $(SVGSRC)))

BACKUPFILES=Makefile $(BIBSRC) $(TEXSRC) $(IMAGEDIR) $(OTHERFILES)

#############################
##          Rules          ##
#############################
pdf: $(SRC).pdf

# remove the PDF file.
rmpdf:
	rm -fv $(SRC).pdf

# If any source file changed, do rmpdf and then do preprocess
all: rmpdf $(SRC).pdf

# Convert SVG files to PDF+LaTeX
images/%.pdf images/%.pdf_tex: images/%.svg
	inkscape --export-area-drawing --without-gui --file=$< --export-pdf=$(addsuffix .pdf,$(basename $@)) --export-latex $(SUFF)

# Persian glossaries
%.fa.gls: %.fa.glo
	$(XINDY) $(XINDYOPTIONS) --language persian-variant1 --codepage utf8 --input-markup xindy --module $* --log-file $@.log --out-file $@ $< $(SUFF)

# English glossaries
%.en.gls: %.en.glo
	$(XINDY) $(XINDYOPTIONS) --language english --codepage utf8 --input-markup xindy --module $* --log-file $@.log --out-file $@ $< $(SUFF)

%.bbl: %.aux $(BIBSRC)
	$(BIB) $(BIBOPTIONS) $* $(SUFF)
	$(TEX) $(TEXDRAFTOPTIONS) $* $(SUFF)

%.aux %.fa.glo %.en.glo: %.tex $(MAKEFILE_LIST) $(SVGOUT) $(TEXSRC)
	$(TEX) $(TEXDRAFTOPTIONS) $* $(SUFF)

%.pdf: %.tex $(MAKEFILE_LIST) $(SVGOUT) $(TEXSRC) %.aux %.fa.gls %.en.gls %.bbl
	$(TEX) $(TEXFINALOPTIONS) $* $(SUFF)
	
	@while ( grep "Rerun to get" $*.log > /dev/null ); do \
		$(TEX) $(TEXFINALOPTIONS) $* $(SUFF); \
	done
	
# Touch the output files to be newer than the aux file to prevent useless compilations 
# the order is relevant as gls will be recreated if glo is newer!
	touch --no-create $*.en.glo $*.fa.glo $*.en.gls $*.fa.gls $*.bbl $*.pdf 
	
# Show relevant log parts
	@echo "\n===========================\n  Summary of log file\n===========================\n"
	@grep --initial-tab --ignore-case 'Warning' $(<:%.tex=%.blg); true
	@grep --line-number --initial-tab --ignore-case "(Reference\|Citation).*undefined\|Warning\|Error\|Underful\|Overful" $(<:%.tex=%.log) ; true

draft once:
	$(TEX) $(TEXFINALOPTIONS) $(SRC) $(SUFF)

view: $(SRC).pdf
	okular $< &

status: 
	svn status | sort -t'	' -h

commit: $(BACKUPFILES)
	@echo "\n==== Supply a comment using COMMENT=""some comment"" make commit ====\n"
	svn commit -m "$(COMMENT)" ./
	svn update

# Repository location (output of "svn info .") 
# SVN_REPO: Repository Root (no slash at the end)
# SVN_PRJ: the folder in the repository containing the trunk, tags, and branches folders without slashes.
#SVN_REPO=file:///media/PortableLinux/svn_repository
#SVN_PRJ=proposal

#tag:
#	@echo "\n==== TAG must not containg any spaces. ====\n"
#	@echo "==== Supply the tag name using TAG='' make tag ====\n"
#	svn copy $(SVN_REPO)/$(SVN_PRJ)/trunk $(SVN_REPO)/$(SVN_PRJ)/tags/$(TAG) -m "TAG: $(TAG)"

update:
	svn update

log:
	svn log -v | less

cleanall: clean cleansvg cleanfig

# do not remove .md5 and .dpth files as they are needed for externalized figures to work correctly.
clean:
	rm -fv $(SRC).pdf *.log *.aux *.auxlock *.bbl *.blg *.out *.dvi *.synctex *.toc *.lof *.lot *.maf *.mtc* *.glg *.glo *.gls $(SRC).xdy *~ images/*~ $(SRC)-gnuplottex-fig* *.dep $(SRC)-figure*.xdy *.backup *.glsdefs *.xdv

cleansvg:
	rm -fv $(SVGOUT)

cleanfig:
	rm -fv $(SRC)-figure*.pdf $(SRC)-figure*.md5 $(SRC)-figure*.dpth 

NOW=`date +%F_%H-%M-%S`

backup:
	tar -cjf backups/$(SRC)-$(NOW).tar.bz2 --atime-preserve $(BACKUPFILES)

#SVN:IGNORE LIST
define SVNIGNORELIST
*.log
*.aux
*.auxlock
*.bbl
*.blg
*.out
*.dvi
*.toc
*.lof
*.lot
*.maf
*.mtc*
*.glg
*.glo
*.gls
*.xdv
$(SRC).xdy
*~
$(SRC)-gnuplottex-fig*
**.dpth
$(SRC)-figure*.xdy
*.spl
endef
#Make the list accessible from the shell
export SVNIGNORELIST

setignore:
	svn propset svn:ignore "$$SVNIGNORELIST" .

#bundle:
#	bundledoc --config=bundledoc-linux.cfg --localonly --listdeps=only,rel $(SRC).dep
#	tar -cjf backups/$(SRC)-$(NOW).tar.bz2 --atime-preserve --files-from a.list
#	tar -uf $(SRC).tar --atime-preserve $(BACKUPFILES)
#	bzip2 $(SRC).tar
#	mv $(SRC).tar.bz2 backups/$(SRC)-bundle-$(NOW).tar.bz2

# PHONY targets - make no output file
.PHONY : all pdf rmpdf view clean cleanfig cleanall backup setignore log update commit status draft once
