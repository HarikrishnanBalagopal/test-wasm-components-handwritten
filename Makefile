.PHONY: clean
clean:
	rm -f *.wasm

.PHONY: build
build:
	wat2wasm add.wat -o add.wasm

.PHONY: wit
wit:
	wasm-tools component wit --out-dir wit addcomp.wat

.PHONY: build-comp
build-comp:
	wasm-tools parse addcomp.wat -o addcomp.wasm