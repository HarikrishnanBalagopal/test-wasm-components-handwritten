(component
    (type $t_i_streams
        (instance
            (export (;0;) "output-stream" (type (sub resource)))
            ;; (alias outer 1 3 (type (;1;)))
            ;; (export (;2;) "error" (type (eq 1)))
            ;; (type (;3;) (own 2))
            ;; (type (;4;) (variant (case "last-operation-failed" 3) (case "closed")))
            ;; (export (;5;) "stream-error" (type (eq 4)))
            ;; (export (;6;) "input-stream" (type (sub resource)))
            ;; (type (;7;) (borrow 0))
            ;; (type (;8;) (result u64 (error 5)))
            ;; (type (;9;) (func (param "self" 7) (result 8)))
            ;; (export (;0;) "[method]output-stream.check-write" (func (type 9)))
            ;; (type (;10;) (list u8))
            ;; (type (;11;) (result (error 5)))
            ;; (type (;12;) (func (param "self" 7) (param "contents" 10) (result 11)))
            ;; (export (;1;) "[method]output-stream.write" (func (type 12)))
            ;; (export (;2;) "[method]output-stream.blocking-write-and-flush" (func (type 12)))
            ;; (type (;13;) (func (param "self" 7) (result 11)))
            ;; (export (;3;) "[method]output-stream.blocking-flush" (func (type 13)))
        )
    )
    (import "wasi:io/streams@0.2.0" (instance $instance_streams (type $t_i_streams)))
    (alias export $instance_streams "output-stream" (type $t_inter_1))
    (type $t_i_stdout
        (instance
            (alias outer 1 $t_inter_1 (type (;0;)))
            (export (;1;) "output-stream" (type (eq 0)))
            (type (;2;) (own 1))
            (type (;3;) (func (result 2)))
            (export (;0;) "get-stdout" (func (type 3)))
        )
    )
    (import "wasi:cli/stdout@0.2.0" (instance $instance_stdout (type $t_i_stdout)))

    (core module $LengthCoreWasm
        (type $t_f_get_stdout (func (result i32)))
        (import "wasi:cli/stdout@0.2.0" "get-stdout" (func $get_stdout (;20;) (type $t_f_get_stdout)))
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

    (alias export $instance_stdout "get-stdout" (func $t44))
    (core func $t33 (canon lower (func $t44)))
    (core instance $core_instance_stdout
        (export "get-stdout" (func $t33))
    )
    (core instance $length_instance
        (instantiate $LengthCoreWasm
            ;; (with "wasi:cli/stdout@0.2.0" (instance $instance_stdout))
            (with "wasi:cli/stdout@0.2.0" (instance $core_instance_stdout))
        )
    )
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