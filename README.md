# About This Project
Template of my PhD thesis.

This is the correct texlive directory structure to put files in.

In order to use this package without installing it, use these commands in your Makefile (../mystyle is the dir containing this README file):

```bash
# Configure TeXLive to refer to the style dir 
STYLEDIR=../mystyle/texmf
# := is assignment and expansion
TEXMFHOME:={$(TEXMFHOME),$(STYLEDIR)}
BIBINPUTS:=$(BIBINPUTS);$(MYSTYLEDIR)/bibtex/bib//
export TEXMFHOME
export BIBINPUTS
```

## Type 1 Fonts
Tex/LaTeX generated PostScript files utilize Type 3 Computer Modern fonts, which are installed by default. Type 3 fonts render good results on high-resolution printers, but look fuzzy on computer displays and thermal printers. On the other hand, Type 1 fonts are scalable, look great on any screen and provide the highest possible quality printout on all kinds of printers.

CM-Super package, which contains Type 1 Computer Modern font, is freely available from CTAN’s Comprehensive TeX Archive. However, most GNU/Linux distributions already provide cm-super package from their default package repositories, just use the distributions’ default package management system to install the package. When creating PDF files, GhostScript and pdfTeX will embed Type 1 fonts if they are available, otherwise they will use Type 3 fonts.

## XDVIPDFMX-ERROR
[http://stackoverflow.com/questions/4110035/import-pdf-file-into-xelatex-gives-pdf-link-obj-passed-invalid-object-error]

pdftk images/fig2-access-sets.pdf output images/fig2-access-sets2.pdf
