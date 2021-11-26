HH = ghc 

all: tex pdf tinfer

tex:
	lhs2TeX Eval.lhs > eval.tex

pdf:tex
	pdflatex eval.tex

tinfer: 
	$(HH) -o tinfer Main.hs Eval.lhs

clean:
	rm *.hi *.o *.tex *.aux *.log *.out *.pdf *.ptb tinfer