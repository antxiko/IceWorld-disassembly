# FORZADA: la barra en el titulo, la contrasena CASIO y la quinta fase de las cinco (la palanca a la derecha
# cuatro veces); a los 1000 cuadros, lo que queda por hacer (0xE3CA) se pone a 0, como lo deja el juego cuando se
# hace todo: la fase acaba bien y sigue lo que venga, el descanso. Alli, desde el cuadro 1600, la palanca cambia de
# direccion cada 40 cuadros y la barra (el golpe) cada 30, como en partida.tcl. 6000 cuadros.
proc pulsa {n a f b} {
    if {$n == $a} { keymatrixdown $f $b }
    if {$n == $a + 5} { keymatrixup $f $b }
}
set ::dirs {0x80 0x40 0x10 0x20 0x80 0x20 0x40 0x10 0x40 0x80}
proc guion {n} {
    pulsa $n 300 8 0x01
    if {$n == 420} { type "casio" }
    pulsa $n 600 8 0x01
    foreach a {660 680 700 720} { pulsa $n $a 8 0x80 }
    pulsa $n 780 8 0x01
    if {$n == 1000} { debug write memory 0xE3CA 0 }
    if {$n > 1600} {
        if {$n % 40 == 0} {
            keymatrixup 8 0xF0
            keymatrixdown 8 [lindex $::dirs [expr {($n / 40) % [llength $::dirs]}]]
        }
        if {$n % 30 == 0} { keymatrixdown 8 0x01 }
        if {$n % 30 == 5} { keymatrixup 8 0x01 }
    }
    return [expr {$n >= 6000}]
}
