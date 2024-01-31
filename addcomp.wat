(component
    (core module $LengthCoreWasm
        (func $length (param $ptr i32) (param $len i32) (result i32)
            local.get $len
        )
        (global $ptr (mut i32) (i32.const 0))
        (func $realloc
            (param $originalPtr i32) (param $originalSize i32)
            (param $alignment i32) (param $newSize i32)
            (result i32)

            (local $t1 i32)
            (local $dest i32)

            ;; calculate the remainder
            global.get $ptr
            local.get $alignment
            i32.rem_u
            local.set $t1
            ;; calculate the offset
            local.get $alignment
            local.get $t1
            i32.sub
            local.set $t1
            ;; add the offset
            global.get $ptr
            local.get $t1
            i32.add
            global.set $ptr
            ;; return value
            global.get $ptr
            local.tee $dest
            ;; update the pointer
            global.get $ptr
            local.get $newSize
            i32.add
            global.set $ptr

            ;; min size
            local.get $newSize
            local.get $originalSize
            local.get $newSize
            local.get $originalSize
            i32.le_u
            select
            local.set $t1

            ;; copy the data
            local.get $dest
            local.get $originalPtr
            local.get $t1
            memory.copy
        )
        (func $run (result i32)
            i32.const 10
            i32.const 50
            call $length
            drop
            i32.const 0
        )
        (memory $mem 1)
        (export "mem" (memory $mem))
        (export "length" (func $length))
        (export "realloc" (func $realloc))
        (export "run" (func $run))
    )
    (core instance $length_instance (instantiate $LengthCoreWasm))
    (func (export "length") (param "input" string) (result u32)
        (canon lift
            (core func $length_instance "length")
            (memory $length_instance "mem")
            (realloc (func $length_instance "realloc"))
        )
    )
    (func $run (export "run") (result (result))
        (canon lift
            (core func $length_instance "run")
            (memory $length_instance "mem")
            (realloc (func $length_instance "realloc"))
        )
    )
    (instance (export "wasi:cli/run@0.2.0")
        (export "run" (func $run))
    )
)