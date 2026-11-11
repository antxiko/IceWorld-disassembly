# Una partida: la barra en el titulo (cuadro 300) lleva a KEYWORD; se escribe VANIL (cuadro 420), se elige la
# fase 6 con la barra (600 y 700); despues la palanca cambia de direccion cada 40 cuadros (derecha, abajo,
# izquierda, arriba, en ese orden con saltos) y la barra (el golpe) cada 30. 14000 cuadros.
proc pulsa {n a f b} {
    if {$n == $a} { keymatrixdown $f $b }
    if {$n == $a + 5} { keymatrixup $f $b }
}
set ::dirs {0x80 0x40 0x10 0x20 0x80 0x20 0x40 0x10 0x40 0x80}
proc guion {n} {
    pulsa $n 300 8 0x01
    if {$n == 420} { type "vanil" }
    pulsa $n 600 8 0x01
    pulsa $n 700 8 0x01
    if {$n > 900} {
        if {$n % 40 == 0} {
            keymatrixup 8 0xF0
            keymatrixdown 8 [lindex $::dirs [expr {($n / 40) % [llength $::dirs]}]]
        }
        if {$n % 30 == 0} { keymatrixdown 8 0x01 }
        if {$n % 30 == 5} { keymatrixup 8 0x01 }
    }
    return [expr {$n >= 14000}]
}
