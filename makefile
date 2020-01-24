BUILD_DIR = build
OPTIONS = -output-directory ${BUILD_DIR} -shell-escape

FILE=report

all:
	pdflatex $(OPTIONS) "$(FILE).tex" && \
		bibtex "${BUILD_DIR}/$(FILE)" && \
		makeglossaries -d $(BUILD_DIR) "$(FILE)" && \
		pdflatex $(OPTIONS) "$(FILE).tex" && \
		pdflatex $(OPTIONS) "$(FILE).tex"

clean:
	rm -rf ${BUILD_DIR} *.aux *.log *.out *.pdf *.bbl *.blg *.gls *.glo *.glg *.ist *.xdy *.lof *.symg *.syms *.symo *.spl
