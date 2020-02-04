BUILD_DIR = build
OPTIONS = -output-directory ${BUILD_DIR} -shell-escape

FILES = report

OUTPUTS = $(patsubst %,build/%.pdf,$(FILES))

.PHONY: all
all: $(OUTPUTS)

$(OUTPUTS): build/%.pdf: %.tex bibliography.bib
	rm -rf build
	mkdir -p build
	docker run \
		--rm \
		-v "$$(pwd):/mnt" \
		-w /mnt \
		adnrv/texlive:full \
		bash -x -o pipefail -c '\
			pdflatex $(OPTIONS) $< && \
			bibtex "${BUILD_DIR}"/$* && \
			makeglossaries -d $(BUILD_DIR) "$*" && \
			pdflatex $(OPTIONS) $< && \
			pdflatex $(OPTIONS) $< \
			'

.PHONY: chktex
chktex:
	find . -maxdepth 1 -type f -name '*.tex' -exec \
		docker run \
			--rm \
			-v "$$(pwd):/mnt" \
			-w /mnt \
			adnrv/texlive:full \
			bash -c "chktex {} | tee build/chktex && [ $$(cat build/chktex | wc -l) -le 0 ]" \;

.PHONY: clean
clean:
	rm -rf ${BUILD_DIR} *.aux *.log *.out *.pdf *.bbl *.blg *.gls *.glo *.glg *.ist *.xdy *.lof *.symg *.syms *.symo *.spl
