.PHONY: main.pdf all clean clean-all run

# should always be the "all" rule, so that "make" and "make all" are identical.
all: main.pdf

main.pdf: main.tex logs
	latexmk -pdflatex=lualatex -pdf -interaction=nonstopmode --shell-escape -file-line-error -f -jobname=logs/main main.tex
	# latexmk -pdflatex=latex -pdf -interaction=nonstopmode --shell-escape -file-line-error -f -jobname=logs/main main.tex
	cp ./logs/main.pdf ./main.pdf

clean:
	rm ./logs/main*

clean-all: clean
	# rm -f main.bbl
	# rm -f main-blx.bib
	# rm -f main.run.xml
	# rm -f main.tdo
	# rm -f main.unq