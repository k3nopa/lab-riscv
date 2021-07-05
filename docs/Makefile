build:
	platex -output-directory=out main.tex
	dvipdfm ./out/main.dvi
	if [ -f "main.pdf" ]; then open main.pdf; fi
clean:
	rm -rf *.aux *.log *.dvi *.pdf
	cd ./out && rm -rf *.aux *.log *.dvi *.pdf
