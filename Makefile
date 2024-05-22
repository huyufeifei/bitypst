build:
	typst compile thesis.typ --font-path template/fonts

clean:
	rm *.pdf

.PHONY: build clean
