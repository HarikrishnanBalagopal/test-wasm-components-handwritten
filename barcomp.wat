(component $C
  (type $T (list (tuple string bool)))
  (type $U (option $T))
  (type $G (func (param "x" (list $T)) (result $U)))
  (type $D (component
    (alias outer $C $T (type $C_T))
    (type $L (list $C_T))
    (import "f" (func (param "x" $L) (result (list u8))))
    (import "g" (func (type $G)))
    (export "g2" (func (type $G)))
    (export "h" (func (result $U)))
    (import "T" (type $T (sub resource)))
    (import "i" (func (param "x" (list (own $T)))))
    (export $T' "T2" (type (eq $T)))
    (export $U' "U" (type (sub resource)))
    (export "j" (func (param "x" (borrow $T')) (result (own $U'))))
  ))
)