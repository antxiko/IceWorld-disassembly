# FORZADA: la barra en el titulo, la contrasena LASTE y la quinta fase de las cinco (la palanca a la derecha
# cuatro veces); a los 1000 cuadros, lo que queda por hacer (0xE3CA) se pone a 0, como lo deja el juego cuando se
# hace todo: la fase acaba bien y sigue lo que venga. 16000 cuadros.
proc pulsa {n a f b} {
    if {$n == $a} { keymatrixdown $f $b }
    if {$n == $a + 5} { keymatrixup $f $b }
}
proc guion {n} {
    pulsa $n 300 8 0x01
    if {$n == 420} { type "laste" }
    pulsa $n 600 8 0x01
    foreach a {660 680 700 720} { pulsa $n $a 8 0x80 }
    pulsa $n 780 8 0x01
    if {$n == 1000} { debug write memory 0xE3CA 0 }
    return [expr {$n >= 16000}]
}
