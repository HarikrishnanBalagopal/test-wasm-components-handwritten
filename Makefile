.PHONY: clean
clean:
	rm -f *.wasm

.PHONY: build
build:
	wat2wasm add.wat -o add.wasm

.PHONY: wit
wit:
	# wasm-tools component wit --out-dir wit addcomp.wat
	wasm-tools component wit --out-dir witcommand command.wat

.PHONY: wat
wat:
	wasm-tools print command.wasm -o command.wat

.PHONY: build-comp
build-comp:
	wasm-tools parse addcomp.wat -o addcomp.wasm

.PHONY: run
run:
	wasmtime run --wasm component-model addcomp.wasm

.PHONY: full
full: clean build build-comp run

.PHONY: foo
foo:
	wasm-tools parse foocomp.wat -o foocomp.wasm


.PHONY: bar
bar:
	wasm-tools parse barcomp.wat -o barcomp.wasm
