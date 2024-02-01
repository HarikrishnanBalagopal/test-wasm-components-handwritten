# README copied from WASM runtime host repo

Handwritten WASM components. The point is to learn the WASM component model https://github.com/WebAssembly/component-model/blob/main/design/mvp/Explainer.md

## Overview

Based on this tutorial https://ifcoltransglinks.wordpress.com/2024/01/24/creating-a-webassembly-component-with-wat-and-wit/

Host for the manually written WASM component.
The `wit` is generated from the `addcomp.wat` file in the `manual` folder.

```shell
$ wasm-tools component wit addcomp.wat
package root:component;

world root {
  export length: func(input: string) -> u32;
}
```

To produce the WASM component binary we use

```shell
$ wasm-tools parse addcomp.wat -o addcomp.wasm
```
