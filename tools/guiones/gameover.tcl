# Una partida sin contrasena (la barra en el cuadro 300 y en el 600: la fase 1) en la que se pulsa F2 (fila 6,
# bit 6: rendirse) cada 700 cuadros desde el 1200, hasta GAME OVER. 6000 cuadros.
proc pulsa {n a f b} {
    if {$n == $a} { keymatrixdown $f $b }
    if {$n == $a + 5} { keymatrixup $f $b }
}
proc guion {n} {
    pulsa $n 300 8 0x01
    pulsa $n 600 8 0x01
    if {$n >= 1200 && $n % 700 == 0} { keymatrixdown 6 0x40 }
    if {$n >= 1200 && $n % 700 == 10} { keymatrixup 6 0x40 }
    return [expr {$n >= 6000}]
}
