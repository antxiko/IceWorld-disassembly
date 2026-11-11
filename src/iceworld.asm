; ==========================================================================
; ICE WORLD - ROM de 16 KB en 0x8000
; ==========================================================================
; Generado por tools/mkasm.py a partir del trazado de flujo real.
; Los comentarios provienen de tools/../src/*.notes y estan anclados a
; direccion, de modo que sobreviven a un retrazado.
; ==========================================================================

	org 0x08000


; ----------------------------------------------------------------------
; DATOS cabecera: "AB", INIT (0x8010) y el resto de la cabecera a cero
;   0x8000..0x8010  (16 bytes)
DATA_cabecera:
	defb 041h,042h	; 8000
	defw 08010h,00000h,00000h,00000h,00000h,00000h,00000h	; 8002

; ======================================================================
; CODIGO 0x8010..0x8862  (2130 bytes)
; ======================================================================


init:		; El arranque: la pila, la interrupcion en H.TIMI, SCREEN 2, las letras de la BIOS en los tres tercios, los colores, los sprites y el titulo
	di			;8010   ; sin interrupciones
	call 00041h		;8011   ; DISSCR
	ld sp,0f000h		;8014   ; la pila
	ld hl,09d95h		;8017   ; la interrupcion (0x9D95)...
	ld a,l			;801a
	ld (0fda0h),a		;801b   ; ...en H.TIMI...
	ld a,h			;801e
	ld (0fda1h),a		;801f   ; ...0xFDA0-0xFDA1
	ld a,0c3h		;8022   ; ...con su "jp"
	ld (0fd9fh),a		;8024   ; ...0xFD9F
	call 0007eh		;8027   ; SETGRP: SCREEN 2
	xor a			;802a   ; fondo y borde negros...
	ld (0f3eah),a		;802b   ; BAKCLR = 0
	ld (0f3ebh),a		;802e   ; BDRCLR = 0
	dec a			;8031   ; ...letras blancas (0xFF)
	ld (0f3e9h),a		;8032   ; FORCLR = 0xFF
	call 00062h		;8035   ; CHGCLR
	ld de,00000h		;8038   ; las letras de la BIOS (0x30-0x5F) en el primer tercio...
	call letras		;803b
	ld de,00800h		;803e   ; ...en el segundo...
	call letras		;8041
	ld de,01000h		;8044   ; ...y en el tercero
	call letras		;8047
	ld de,00180h		;804a   ; los caracteres 0x20-0x2F de la BIOS, en la casilla 0x30 de cada tercio
	call letras_20		;804d
	ld de,00980h		;8050   ; el segundo tercio
	call letras_20		;8053
	ld de,01180h		;8056   ; el tercero
	call letras_20		;8059
	xor a			;805c   ; el color 0 a la casilla 0x10 (el espacio) en los tres tercios
	ld hl,00080h		;805d
	call colores8		;8060
	ld hl,00880h		;8063
	call colores8		;8066
	ld hl,01080h		;8069
	call colores8		;806c
	ld hl,02000h		;806f   ; los colores de todo a 0xF0
	ld bc,01800h		;8072   ; 0x1800 bytes
	ld a,0f0h		;8075   ; 0xF0: blanco sobre transparente
	call 00056h		;8077   ; FILVRM
	call sprites_dibujos		;807a   ; los dibujos de los sprites
	ld hl,0fbf0h		;807d   ; el buffer del teclado vacio
	ld (0f3f8h),hl		;8080   ; GETPNT = PUTPNT: nada en el buffer
	ld (0f3fah),hl		;8083
	ld a,0a2h		;8086   ; el registro 1 a 0xA2: la pantalla apagada, sprites de 16 x 16
	ld b,a			;8088   ; el valor
	ld c,001h		;8089   ; el registro 1
	call 00047h		;808b   ; WRTVDP
	call tiempo_lleno		;808e   ; el marcador
	call pantalla_borra		;8091   ; la pantalla en blanco
	call ram_borra		;8094   ; la fase...
	inc a			;8097   ; ...1
	ld (0e00ah),a		;8098   ; 0xE00A = 1
	call sonido_calla_pide		;809b   ; el sonido callado
	ei			;809e   ; con interrupciones
	call casillas_juego		;809f   ; las casillas del juego
	ld de,00600h		;80a2   ; las casillas del titulo en los tres tercios
	call casillas_titulo		;80a5
	ld de,00e00h		;80a8   ; el segundo tercio
	call casillas_titulo		;80ab
	ld de,01600h		;80ae   ; el tercero
	call casillas_titulo		;80b1
	ld hl,02e88h		;80b4   ; los colores del titulo: azul claro...
	ld bc,00170h		;80b7   ; 0x170 bytes
	ld a,070h		;80ba   ; 0x70
	call 00056h		;80bc   ; FILVRM
	ld hl,02688h		;80bf   ; ...verde...
	ld bc,00170h		;80c2   ; 0x170 bytes
	ld a,0a0h		;80c5   ; 0xA0
	call 00056h		;80c7   ; FILVRM
	ld hl,02600h		;80ca   ; ...el rojo de CASIO
	ld bc,00088h		;80cd   ; 0x88 bytes
	ld a,090h		;80d0   ; 0x90
	call 00056h		;80d2   ; FILVRM
	ld hl,03600h		;80d5   ; los colores de los sprites
	ld bc,00200h		;80d8   ; 0x200 bytes
	ld a,0f0h		;80db   ; 0xF0
	call 00056h		;80dd   ; FILVRM
	call 00044h		;80e0   ; ENASCR
	ld hl,09d30h		;80e3   ; CASIO en letras grandes: dos filas de 12...
	ld de,0186ah		;80e6   ; ...desde la fila 3, columna 10
	ld bc,0000ch		;80e9   ; 12 casillas
	call 0005ch		;80ec   ; LDIRVM
	ex de,hl			;80ef   ; la segunda fila de CASIO
	ld de,0188ah		;80f0   ; en la fila 4
	ld bc,0000ch		;80f3
	call 0005ch		;80f6   ; LDIRVM
	ld hl,09152h		;80f9   ; ICE WORLD: una fila de 8 y dos de 13
	ld de,0192ah		;80fc   ; en la fila 9, columna 10
	ld bc,00008h		;80ff
	call 0005ch		;8102   ; LDIRVM
	ex de,hl			;8105   ; la segunda fila
	ld de,0194ah		;8106   ; en la fila 10, columna 10
	ld bc,0000dh		;8109
	call 0005ch		;810c   ; LDIRVM
	ex de,hl			;810f   ; la tercera
	ld de,0196ah		;8110   ; en la fila 11
	ld bc,0000dh		;8113
	call 0005ch		;8116   ; LDIRVM
	ld hl,09d48h		;8119   ; PUSH TRIGGER OR SPACE en la fila 14, columna 6
	ld de,019c6h		;811c
	ld bc,00015h		;811f
	call 0005ch		;8122   ; LDIRVM
	ld hl,09d5dh		;8125   ; COPYRIGHT 1985 (c) CASIO en la fila 21, columna 5
	ld de,01aa5h		;8128
	ld bc,00016h		;812b
	call 0005ch		;812e   ; LDIRVM
	ld hl,018c4h		;8131   ; la fila de bloques de hielo del titulo: ocho...
	ld de,00002h		;8134   ; de dos en dos columnas
	ld c,044h		;8137   ; ...la casilla 0x44, de dos en dos
	ld b,008h		;8139
L_813B:
	call pieza		;813b   ; la pieza
	add hl,de			;813e
	djnz L_813B		;813f   ; ocho
	ld c,0ach		;8141   ; y el final, la 0xAC
	call pieza		;8143   ; la pieza del final
	call protagonista_sale		;8146   ; el protagonista en su sitio
	ld hl,09086h		;8149   ; la demostracion: sus mandos (0x9086)...
	ld (0e049h),hl		;814c   ; el puntero de los mandos
	ld a,087h		;814f   ; ...y su cuenta
	ld (0e048h),a		;8151   ; 0x87: hay demostracion
	ld a,003h		;8154   ; mira a la derecha
	ld (0e203h),a		;8156   ; 0xE203 = 3
	call botones_cero		;8159   ; los botones a 0
	ld (0e20bh),a		;815c   ; el empujon a 0
	ld (0e302h),a		;815f   ; 0xE302 a 0
titulo_espera:		; Espera en el titulo: el protagonista empuja la fila de hielo; con un boton, la contrasena; si no, al rato la demostracion
	ld a,(0e201h)		;8162   ; el protagonista al final de la fila?
	cp 0e0h		;8165   ; en la columna 0xE0?
	call z,titulo_fila		;8167   ; si: la fila otra vez
	ld a,003h		;816a   ; 3: el titulo
	ld (0e3c0h),a		;816c   ; 0xE3C0 = 3
	ld hl,0e018h		;816f   ; un cuadro
	call cuenta_1		;8172   ; un cuadro (0xE018)
	jr nz,titulo_espera		;8175
	ld (0e00eh),a		;8177   ; los botones...
	ld a,(0e044h)		;817a   ; ...pulsados?
	ld hl,0e046h		;817d   ; el de empezar
	add a,(hl)			;8180
	jp nz,partida		;8181   ; si: la contrasena y la partida
	ld a,(0e201h)		;8184   ; el protagonista parado?
	and a			;8187   ; parado?
	jp z,demostracion		;8188   ; si: la demostracion
	call paso_demo		;818b   ; si no, un paso con los mandos de la demostracion
	jr titulo_espera		;818e
titulo_fila:		; La fila de hielo del titulo, otra vez (0x18DE)
	ld hl,018deh		;8190   ; la fila 6, columna 30
	jp pieza_borra		;8193   ; borrada
contrasena:		; KEYWORD: cinco letras con el teclado; una de las diez de 0x9E8F da su fase, y con los cursores se elige una de las cinco siguientes
	call sonido_calla_pide		;8196   ; el sonido callado
	call botones_cero		;8199   ; los botones a 0
	ld (0e3c0h),a		;819c   ; 0xE3C0 a 0
	ld hl,0e1f0h		;819f   ; 0xE1F0-0xE1FF a cero
	ld b,010h		;81a2   ; 16 bytes
contrasena_borra:
	ld (hl),000h		;81a4
	inc hl			;81a6
	djnz contrasena_borra		;81a7
	ld hl,09e80h		;81a9   ; KEYWORD y sus corchetes (0x9E80)...
	ld de,01a29h		;81ac   ; ...en la fila 17, columna 9
	ld bc,0000fh		;81af   ; 15 casillas
	call 0005ch		;81b2   ; LDIRVM
	ld hl,01a52h		;81b5   ; el cursor (casilla 0x2E) bajo la primera letra
	ld a,02eh		;81b8   ; el cursor (0x2E)...
	call 0004dh		;81ba   ; ...en la fila 18, columna 18
	ld hl,0e1f6h		;81bd   ; las letras van a 0xE1F6
	ld (0e1feh),hl		;81c0   ; el puntero de la letra
	xor a			;81c3   ; la letra 0
	ld (0e1f5h),a		;81c4   ; la letra 0
contrasena_vacia:		; El buffer del teclado vacio
	ld hl,0fbf0h		;81c7   ; el buffer del teclado...
	ld (0f3f8h),hl		;81ca   ; ...vacio
contrasena_tecla:		; Una tecla
	ld a,(0e040h)		;81cd   ; un boton?
	ld b,a			;81d0
	ld a,(0e044h)		;81d1   ; la barra...
	or b			;81d4   ; ...o el boton 1
	jr nz,contrasena_fin		;81d5   ; si: se acaba
	ld a,(0e1fch)		;81d7   ; la palanca?
	and a			;81da   ; movida?
	jr nz,contrasena_palanca		;81db
	ld (0e1fdh),a		;81dd   ; la palanca, ya soltada
	ld a,0f0h		;81e0   ; una tecla en el buffer?
	ld hl,(0f3f8h)		;81e2   ; el puntero del buffer
	cp l			;81e5   ; vacio?
	jr nc,contrasena_tecla		;81e6
	dec hl			;81e8   ; la ultima tecla
	ld a,(hl)			;81e9   ; la tecla
	cp 041h		;81ea   ; de la A...
	jr c,contrasena_vacia		;81ec   ; menos de la A: nada
	cp 07bh		;81ee   ; ...a la z
	jr nc,contrasena_vacia		;81f0   ; mas de la z: nada
	ld b,a			;81f2
	ld a,0ffh		;81f3   ; ya hay contrasena escrita
	ld (0e1f1h),a		;81f5
	ld a,b			;81f8
	res 5,a		;81f9   ; en mayusculas...
	sub 030h		;81fb   ; ...y en casilla (0x11 la A)
	ld hl,(0e1feh)		;81fd   ; en su sitio
	ld (hl),a			;8200   ; en el buffer de la contrasena
	ld b,a			;8201
	ld a,(0e1f5h)		;8202   ; y en la pantalla, fila 16
	ld hl,01a32h		;8205   ; la fila 17, columna 18 + la letra
	add a,l			;8208
	ld l,a			;8209
	ld a,b			;820a
	call 0004dh		;820b   ; WRTVRM
	call contrasena_limpia		;820e   ; el cursor borrado
	ld a,(0e1f5h)		;8211   ; la letra siguiente (hasta la quinta)
	cp 004h		;8214   ; la quinta?
	jr nc,contrasena_cursor		;8216
	inc a			;8218
contrasena_cursor:		; El cursor bajo la letra
	ld (0e1f5h),a		;8219   ; la letra
	add a,052h		;821c   ; la columna del cursor
	ld l,a			;821e
	ld a,02eh		;821f   ; el cursor
	call 0004dh		;8221   ; WRTVRM
	ld a,(0e1f5h)		;8224   ; la letra siguiente
	add a,0f6h		;8227   ; el puntero: 0xE1F6 + la letra
	ld (0e1feh),a		;8229
	jr contrasena_vacia		;822c
contrasena_fin:		; Con el boton: si se ha escrito algo, se busca
	call contrasena_limpia		;822e   ; el cursor borrado
	ld a,(0e1f1h)		;8231   ; algo escrito?
	and a			;8234
	ret z			;8235   ; nada: se vuelve
	jp contrasena_busca		;8236   ; a buscarla
contrasena_palanca:		; La palanca mueve el cursor: 3 a la derecha, 7 a la izquierda
	ld b,a			;8239   ; la direccion
	ld a,(0e1fdh)		;823a   ; recien movida?
	and a			;823d
	jr nz,contrasena_tecla		;823e
	cpl			;8240   ; movida
	ld (0e1fdh),a		;8241
	ld a,b			;8244
	cp 003h		;8245   ; 3: derecha
	jr nz,L_8253		;8247
	ld a,(0e1f5h)		;8249
	cp 004h		;824c   ; la quinta?
	jr nc,contrasena_mueve		;824e
	inc a			;8250   ; la siguiente
	jr contrasena_mueve		;8251
L_8253:
	cp 007h		;8253   ; 7: izquierda
	jp nz,contrasena_vacia		;8255
	ld a,(0e1f5h)		;8258   ; la primera?
	and a			;825b
	jr z,contrasena_mueve		;825c
	dec a			;825e   ; la anterior
contrasena_mueve:
	push af			;825f
	call contrasena_limpia		;8260   ; el cursor borrado
	pop af			;8263
	ld h,01ah		;8264   ; la fila 17
	jr contrasena_cursor		;8266
contrasena_busca:		; Busca las cinco letras entre las diez contrasenas de 0x9E8F (6 bytes cada una)
	ld c,00ah		;8268   ; diez
	ld hl,0e1f6h		;826a   ; las letras escritas
	ld de,09e8fh		;826d   ; la tabla
L_8270:
	ld a,(de)			;8270   ; la primera letra igual?
	ld b,(hl)			;8271
	cp b			;8272   ; iguales?
	jr z,contrasena_hallada		;8273
	push hl			;8275   ; la siguiente contrasena
	ld hl,00006h		;8276   ; 6 bytes mas alla
	add hl,de			;8279
	ex de,hl			;827a
	pop hl			;827b
	dec c			;827c   ; una menos
	jr nz,L_8270		;827d
	jp contrasena		;827f   ; ninguna: otra vez
contrasena_hallada:		; La contrasena C: las otras cuatro letras tambien
	ld a,00ah		;8282   ; su numero (0-9)
	sub c			;8284   ; 10 - las que quedan
	ld (0e043h),a		;8285   ; en 0xE043
	ld c,004h		;8288   ; otras cuatro letras
contrasena_letra:
	inc de			;828a
	inc hl			;828b
	ld b,(hl)			;828c
	ld a,(de)			;828d
	cp b			;828e   ; iguales?
	jp nz,contrasena		;828f   ; no: otra vez
	dec c			;8292
	jr nz,contrasena_letra		;8293
	inc de			;8295   ; su fase: las decenas...
	ld a,(de)			;8296
	ld b,a			;8297
	and 00fh		;8298   ; las unidades
	ld (0e00ah),a		;829a
	ld e,a			;829d   ; ...y las unidades
	ld a,b			;829e
	and 0f0h		;829f   ; las decenas
	rrca			;82a1
	rrca			;82a2
	rrca			;82a3
	rrca			;82a4
	ld (0e009h),a		;82a5   ; en 0xE009
	ld d,a			;82a8
	ld hl,01a29h		;82a9   ; las cinco fases que se pueden elegir, en la fila 17: 01 02 03...
	ld b,005h		;82ac   ; cinco fases
contrasena_fases:
	ld a,d			;82ae
	call 0004dh		;82af   ; las decenas
	ld a,e			;82b2
	inc hl			;82b3
	call 0004dh		;82b4   ; las unidades
	inc hl			;82b7
	ld a,010h		;82b8
	call 0004dh		;82ba   ; un espacio
	inc hl			;82bd
	inc e			;82be   ; la fase siguiente
	djnz contrasena_fases		;82bf
	ld a,e			;82c1   ; la fase 10?
	cp 00bh		;82c2
	jr nz,contrasena_elige		;82c4
	xor a			;82c6   ; 10, no 0:10
	ld hl,01a36h		;82c7   ; 0 en las unidades...
	call 0004dh		;82ca
	ld a,(0e009h)		;82cd   ; ...y las decenas + 1
	inc a			;82d0
	ld hl,01a35h		;82d1
	call 0004dh		;82d4
contrasena_elige:		; Se elige con los cursores una de las cinco fases; el boton empieza
	ld a,(0e043h)		;82d7   ; la contrasena hallada...
	ld (0e00fh),a		;82da   ; ...en 0xE00F
	call contrasena_limpia		;82dd
	ld a,02eh		;82e0   ; el cursor bajo la primera
	ld hl,01a4ah		;82e2
	call 0004dh		;82e5   ; WRTVRM
	xor a			;82e8
	call botones_pon		;82e9   ; los botones a 0
	ld (0e1f5h),a		;82ec   ; la primera
L_82EF:
	ld a,(0e044h)		;82ef   ; un boton?
	and a			;82f2
	jp nz,contrasena_empieza		;82f3
	ld a,(0e040h)		;82f6   ; el boton 1?
	and a			;82f9
	jp nz,contrasena_empieza		;82fa
	ld a,(0e1fch)		;82fd   ; la palanca?
	and a			;8300
	jr nz,contrasena_elige_palanca		;8301
	ld (0e1fdh),a		;8303   ; la palanca, ya soltada
	jr L_82EF		;8306
contrasena_elige_palanca:		; La palanca, recien movida
	ld a,(0e1fdh)		;8308
	and a			;830b
	jr nz,L_82EF		;830c   ; ya contada
	inc a			;830e
	ld (0e1fdh),a		;830f   ; contada
	ld a,(0e1fch)		;8312   ; 3: derecha
	cp 003h		;8315   ; 3: derecha?
	jr z,contrasena_derecha		;8317
	cp 007h		;8319   ; 7: izquierda
	jr nz,L_82EF		;831b
	ld a,(0e1f5h)		;831d   ; la anterior
	dec a			;8320
	jr contrasena_vuelta		;8321
contrasena_derecha:
	ld a,(0e1f5h)		;8323   ; la siguiente
	inc a			;8326
contrasena_vuelta:		; De 4 pasa a 0, y al reves
	cp 005h		;8327   ; la sexta?
	jr nz,contrasena_vuelta2		;8329
	xor a			;832b   ; la primera
	jr contrasena_pon		;832c
contrasena_vuelta2:
	cp 0ffh		;832e   ; antes de la primera?
	jr nz,contrasena_pon		;8330
	ld a,004h		;8332   ; la quinta
contrasena_pon:		; El cursor bajo la fase elegida (de 3 en 3 columnas)
	ld (0e1f5h),a		;8334
	call contrasena_limpia		;8337   ; el cursor borrado
	ld hl,01a47h		;833a   ; desde la fila 18, columna 7...
	ld c,003h		;833d   ; ...de 3 en 3
	ld a,(0e1f5h)		;833f
	inc a			;8342
	ld b,a			;8343
	ld a,l			;8344
contrasena_columna:
	add a,c			;8345
	djnz contrasena_columna		;8346
	ld l,a			;8348
	ld a,02eh		;8349   ; el cursor
	call 0004dh		;834b   ; WRTVRM
	jp L_82EF		;834e
contrasena_empieza:		; La fase: la de la contrasena mas la elegida
	ld hl,0e00ah		;8351   ; las unidades
	ld a,(0e1f5h)		;8354   ; la elegida
	add a,(hl)			;8357   ; + la elegida
	ld (hl),a			;8358   ; + las unidades
	cp 00ah		;8359   ; pasa de 9?
	jr nz,contrasena_va		;835b
	ld (hl),000h		;835d   ; 0 y las decenas + 1
	dec hl			;835f   ; las decenas
	inc (hl)			;8360
contrasena_va:		; A la partida
	jp fase_numero		;8361   ; la fase en 0xE007
contrasena_limpia:		; La fila 18 en blanco (13 casillas)
	ld hl,01a4ah		;8364   ; la fila 18, columna 10
	ld b,00dh		;8367   ; 13 casillas
contrasena_limpia_casilla:
	ld a,010h		;8369   ; el espacio
	call 0004dh		;836b   ; WRTVRM
	inc hl			;836e
	djnz contrasena_limpia_casilla		;836f
	ret			;8371
demostracion:		; La demostracion: desde la fase 1, con sus mandos
	call sonido_calla_pide		;8372   ; el sonido callado
	xor a			;8375   ; la fase 01...
	ld (0e009h),a		;8376   ; las decenas a 0
	ld (0e007h),a		;8379   ; la fase jugada a 0
	inc a			;837c
	ld (0e00ah),a		;837d   ; ...
	ld a,087h		;8380   ; la cuenta de los mandos
	ld (0e048h),a		;8382   ; 0x87: la demostracion de la fase 1
	jr partida_casillas		;8385
partida:		; Una partida nueva: la contrasena, 4 vidas, los puntos a cero
	xor a			;8387
	ld (0e047h),a		;8388   ; sin demostracion
	ld (0e048h),a		;838b
	call contrasena		;838e   ; la contrasena
	ld a,001h		;8391   ; en partida
	ld (0e000h),a		;8393   ; 0xE000 = 1
	ld a,004h		;8396   ; 4 vidas
	ld (0e00bh),a		;8398   ; en 0xE00B
	ld hl,0e001h		;839b   ; los puntos (0xE001-0xE006) a cero
	ld b,006h		;839e   ; seis cifras
partida_borra:
	ld (hl),000h		;83a0
	inc hl			;83a2
	djnz partida_borra		;83a3
partida_casillas:		; Las casillas del juego
	call casillas_juego		;83a5
fase:		; Una fase: el laberinto, la musica 1, los bloques, el protagonista, el marcador y una espera
	call fase_pantalla		;83a8   ; el laberinto
	ld a,001h		;83ab   ; la musica 1
	call musica_pide		;83ad   ; la musica 1
	call laberinto		;83b0   ; el laberinto
	call protagonista_sale		;83b3   ; el protagonista
	call protagonista		;83b6   ; los sprites a la VRAM
	call puntos_pinta		;83b9   ; TIME
	ld a,0e0h		;83bc   ; 224 cuadros
	call espera_a		;83be   ; una espera
	ld a,(0e048h)		;83c1   ; en la demostracion de la fase 1...
	cp 087h		;83c4   ; la demostracion de la fase 1?
	jr nz,L_83CE		;83c6
	ld hl,09fc0h		;83c8   ; ...los mandos de 0x9FC0
	ld (0e049h),hl		;83cb   ; el puntero de los mandos
L_83CE:
	call botones_cero		;83ce   ; los botones a 0
	ld (0e3f6h),a		;83d1   ; el mando a 0
	ld (0e1fch),a		;83d4   ; la palanca a 0
fase_bucle:		; El bucle de la fase: un paso por cuadro; se acaba si se pierde (0xE1F3) o no queda nada por hacer (0xE3CA)
	xor a			;83d7
	ld (0e3c0h),a		;83d8   ; 0xE3C0 a 0: la fase normal
	call paso_fase		;83db   ; un paso
	call protagonista_toca		;83de   ; lo que hay bajo el protagonista
	call caminos_olvida		;83e1   ; a veces los enemigos olvidan su camino
	ld a,(0e1f3h)		;83e4   ; la fase perdida?
	and a			;83e7
	jp nz,fase_perdida		;83e8   ; si: una vida menos
	ld a,(0e3cah)		;83eb   ; queda algo?
	and a			;83ee
	jp z,fase_hecha		;83ef   ; no: fase superada
	jp fase_sigue		;83f2   ; si queda: sigue
paso:		; Un paso, uno por cuadro (0xE011): el protagonista, la pausa (F1), rendirse (F2), el tiempo y el sonido
	ld hl,0e011h		;83f5   ; un cuadro
	call cuenta_1		;83f8   ; 0xE011 a 1?
	ret nz			;83fb   ; aun no
	call agua		;83fc   ; el protagonista
	ld a,(0e1f3h)		;83ff   ; la fase perdida?
	and a			;8402
	jr nz,paso_tiempo		;8403   ; si: TIME
	ld a,(0e000h)		;8405   ; en la demostracion, sin mas
	and a			;8408
	jr z,paso_sonido		;8409   ; si: sin pausa
	ld a,(0e3c0h)		;840b   ; la fase acaba?
	and a			;840e
	jr z,paso_f1		;840f   ; la fase normal: F1
	xor a			;8411
	ld (0e1fbh),a		;8412   ; sin pausa
	jr paso_tiempo		;8415
paso_f1:		; La pausa con F1, en cuatro estados (0xE1FB): pulsada (pausa), soltada, pulsada otra vez (sigue) y soltada
	ld a,(0e1fbh)		;8417
	and a			;841a
	jr nz,paso_f1_1		;841b   ; ya pulsada antes
	call tecla_f1		;841d   ; F1 pulsada?
	jr nz,L_8426		;8420   ; no
	ld a,001h		;8422   ; 1: pulsada
	jr paso_f1_pon		;8424
L_8426:
	bit 6,a		;8426   ; F2?
	jr nz,paso_tiempo		;8428   ; no: sigue
	ld a,028h		;842a   ; si: la fase perdida (0xE1F3 = 40)...
	ld (0e1f3h),a		;842c   ; en 0xE1F3
	ld a,003h		;842f   ; ...y la musica 3
	jp musica_pide		;8431   ; la musica 3
paso_f1_1:
	cp 001h		;8434   ; 1?
	jr nz,paso_f1_2		;8436
	call tecla_f1		;8438   ; soltada?
	jr z,paso_tiempo		;843b
	ld a,002h		;843d   ; 2: soltada
	jr paso_f1_pon		;843f
paso_f1_2:
	cp 002h		;8441   ; 2?
	jr nz,paso_f1_3		;8443
	call tecla_f1		;8445   ; otra vez pulsada?
	jr nz,paso_tiempo		;8448
	xor a			;844a   ; los botones a 0
	call botones_pon		;844b   ; los botones a 0
	ld a,003h		;844e   ; 3
	jr paso_f1_pon		;8450
paso_f1_3:
	call tecla_f1		;8452   ; 3: soltada otra vez?
	jr z,paso_tiempo		;8455
	xor a			;8457   ; 0: sin pausa
paso_f1_pon:
	ld (0e1fbh),a		;8458
paso_tiempo:		; TIME
	call puntos_pinta		;845b   ; los puntos en la pantalla
paso_sonido:		; Lo que queda, el sonido y el marcador
	call tiempo		;845e   ; TIME
	call sonido		;8461   ; el sonido del cuadro
	call sprites_vram		;8464   ; los sprites a la VRAM
	ld a,(0e1fbh)		;8467   ; en pausa (F1)?
	and a			;846a
	jr z,paso_fin		;846b   ; sin pausa: sigue
	cp 003h		;846d   ; 3?
	jr nc,paso_fin		;846f
	call paso_efecto4		;8471   ; si: el efecto 4 y el protagonista
	call agua		;8474   ; los colores del agua
paso_pausa:		; En pausa: un cuadro y otra vez F1
	ld hl,0e011h		;8477   ; un cuadro
	call cuenta_1		;847a
	jr nz,paso_pausa		;847d
	jr paso_f1		;847f
paso_fin:		; El sonido segun la fase: 0xE3C0 = 2 la musica 5, 1 nada; perdida la musica 3; si queda algo el efecto 4; si no, la musica 4
	ld a,(0e3c0h)		;8481
	cp 002h		;8484   ; el final?
	jr z,paso_musica5		;8486
	cp 001h		;8488   ; el descanso?
	ret z			;848a   ; nada
	ld a,(0e1f3h)		;848b   ; perdida?
	and a			;848e
	jr nz,paso_musica3		;848f
	ld a,(0e3cah)		;8491   ; queda algo por hacer?
	and a			;8494
	jr z,paso_musica4		;8495
paso_efecto4:		; El efecto 4
	ld a,004h		;8497   ; el efecto 4
	jp efecto_pide		;8499
paso_musica5:
	ld a,005h		;849c   ; la musica 5
	jr paso_musica		;849e
paso_musica3:
	ld a,003h		;84a0   ; la musica 3
	jr paso_musica		;84a2
paso_musica4:
	ld a,004h		;84a4   ; la musica 4
paso_musica:
	jp musica_pide		;84a6
fase_sigue:		; En la demostracion, un boton vuelve al titulo
	ld a,(0e000h)		;84a9   ; en partida, sigue
	and a			;84ac   ; en partida
	jp nz,fase_bucle		;84ad
	ld a,(0e046h)		;84b0   ; el boton de empezar?
	and a			;84b3   ; el de empezar?
	jp z,fase_bucle		;84b4
	call sonido_calla_pide		;84b7   ; el sonido callado...
	jp init		;84ba   ; ...y al arranque
tecla_f1:		; SNSMAT de la fila 6: Z si F1 (bit 5 a 0) esta pulsada; el bit 6 es F2
	ld a,006h		;84bd   ; la fila 6
	call 00141h		;84bf   ; SNSMAT
	bit 5,a		;84c2   ; F1
	ret			;84c4
casillas_juego:		; Las casillas y sus colores del juego en los tres tercios
	call pantalla_borra		;84c5
	ld de,00200h		;84c8   ; el primer tercio, desde la casilla 0x40
	call casillas_tercio		;84cb
	ld de,00a00h		;84ce   ; el segundo
	call casillas_tercio		;84d1
	ld de,01200h		;84d4   ; el tercero
	call casillas_tercio		;84d7
	ld de,02200h		;84da   ; los colores del primer tercio
	call colores_tercio		;84dd
	ld de,02a00h		;84e0   ; del segundo
	call colores_tercio		;84e3
	ld de,03200h		;84e6   ; del tercero
	call colores_tercio		;84e9
	jp tiempo_lleno		;84ec   ; TIME
protagonista_pon:		; El protagonista en su sitio de salida (Y 0x18, X 0x08), mirando a la derecha
	ld a,018h		;84ef   ; Y 0x18
	ld (0e200h),a		;84f1   ; la Y del protagonista
	ld (0e3c1h),a		;84f4   ; y la del golpe
	ld a,008h		;84f7   ; X 0x08
	ld (0e201h),a		;84f9   ; la X
	ld (0e3c2h),a		;84fc   ; y la del golpe
	ld a,004h		;84ff   ; el dibujo 4
	ld (0e204h),a		;8501   ; el dibujo
	ld a,008h		;8504   ; el color 8
	ld (0e205h),a		;8506   ; el color
	ld a,003h		;8509   ; mira a la derecha (3)
	ld (0e203h),a		;850b   ; la direccion
	jp prota_dibujo		;850e
espera_a:		; Espera A cuadros (0xE011) con el sonido sonando
	ld (0e1f4h),a		;8511   ; cuantos
	xor a			;8514
	ld (0e010h),a		;8515   ; las cuentas a 0
	ld (0e011h),a		;8518
espera_cuadro:
	ld hl,0e010h		;851b   ; un cuadro
	call cuenta_1		;851e
	jr nz,espera_cuadro		;8521
	call sonido		;8523   ; el sonido
	ld a,(0e1f4h)		;8526   ; cuantos...
	ld b,a			;8529
	ld a,(0e011h)		;852a
	cp b			;852d   ; ...ya?
	jr c,espera_cuadro		;852e
	ret			;8530
fase_perdida:		; La fase perdida (0xE1F3, que baja de 40 a 12 cada 5 cuadros): una vida menos; sin vidas, GAME OVER
	ld hl,0e01ch		;8531   ; cada 5 cuadros
	call cuenta_5		;8534   ; cada 5 cuadros
	jp nz,fase_bucle		;8537
	ld a,(0e1f3h)		;853a   ; la cuenta, uno menos
	dec a			;853d   ; uno menos
	ld (0e1f3h),a		;853e
	cp 00ch		;8541   ; aun no
	jp nc,fase_bucle		;8543
	xor a			;8546   ; a 0
	ld (0e1f3h),a		;8547
	call sonido_calla_pide		;854a   ; el sonido callado
	call fase_borra		;854d   ; la RAM de la fase a cero
	ld a,(0e00bh)		;8550   ; quedan vidas?
	and a			;8553   ; 0?
	jp z,game_over		;8554
	dec a			;8557   ; una menos
	ld (0e00bh),a		;8558   ; una menos
	call tiempo_lleno		;855b   ; TIME lleno
	jp fase		;855e   ; y la fase otra vez
fase_borra:		; 0xE100-0xE12E a cero y TIME
	ld hl,0e100h		;8561   ; los sprites (0xE100)...
	ld b,02fh		;8564   ; ...47 bytes...
fase_borra_byte:
	ld (hl),000h		;8566   ; ...a cero
	inc hl			;8568
	djnz fase_borra_byte		;8569
	jp sprites_vram		;856b   ; y a la VRAM
game_over:		; GAME OVER (0x9174) en la fila 9, columna 12, la musica 2, una espera y al arranque
	ld de,0192ch		;856e   ; en la fila 9, columna 12
	ld hl,09174h		;8571   ; GAME OVER
	ld bc,00009h		;8574   ; 9 casillas
	call 0005ch		;8577   ; LDIRVM
	ld a,002h		;857a   ; la musica 2
	call musica_pide		;857c   ; la musica 2
	ld a,0f8h		;857f   ; 248 cuadros
	call espera_a		;8581   ; espera
	jp init		;8584   ; y al arranque
fase_hecha:		; La fase superada: el tiempo que queda a puntos, una espera y la siguiente; cada cinco fases, el descanso
	ld a,044h		;8587   ; las casillas 0x44 (los bloques)...
	ld (0e32dh),a		;8589
	ld a,001h		;858c   ; ...100 puntos cada una
	ld (0e30ch),a		;858e
	call cuenta_casillas		;8591   ; el protagonista
	call espera_240		;8594   ; 240 cuadros
	ld a,(0e007h)		;8597   ; una fase jugada mas
	inc a			;859a
	ld (0e007h),a		;859b   ; la fase jugada
	cp 033h		;859e   ; la 51?
	jp z,descanso		;85a0   ; la 51: el final
	ld a,(0e00ah)		;85a3   ; la fase acaba en 5...
	cp 005h		;85a6
	jp z,descanso		;85a8   ; si: el descanso
	and a			;85ab   ; ...o en 0?
	jp z,descanso		;85ac   ; si: el descanso
	call fase_siguiente		;85af   ; la fase siguiente
fase_hecha_sigue:
	call tiempo_puntos		;85b2   ; TIME a los puntos
	jp fase		;85b5   ; la fase siguiente
fase_siguiente:		; La fase + 1 (0xE00A); al pasar de 9, 0 y 0xE00B + 1
	ld hl,0e00ah		;85b8
	inc (hl)			;85bb   ; las unidades
	ld a,(hl)			;85bc
	cp 00ah		;85bd   ; 10?
	ret nz			;85bf
	ld (hl),000h		;85c0   ; 0...
	inc hl			;85c2   ; 0xE00B
	inc (hl)			;85c3   ; ...y 0xE00B + 1
	ld a,(hl)			;85c4
	cp 00ah		;85c5   ; 10?
	ret nz			;85c7
	ld (hl),000h		;85c8   ; 10 es 0
	ret			;85ca
tiempo_puntos:		; TIME (las cuatro cifras de 0xE080) a los puntos
	ld a,(0e080h)		;85cb   ; las unidades de TIME...
	ld b,a			;85ce
	ld a,(0e081h)		;85cf   ; ...y las decenas
	rlca			;85d2   ; en la mitad alta
	rlca			;85d3
	rlca			;85d4
	rlca			;85d5
	add a,b			;85d6   ; en BCD
	call puntos		;85d7   ; a los puntos
	ld a,(0e082h)		;85da   ; las centenas...
	ld b,a			;85dd
	ld a,(0e083h)		;85de   ; ...y los millares
	rlca			;85e1
	rlca			;85e2
	rlca			;85e3
	rlca			;85e4
	add a,b			;85e5
	call puntos_centenas		;85e6   ; a las centenas de los puntos
	jp tiempo_lleno		;85e9   ; TIME otra vez
espera_240:		; 240 cuadros con los pasos del juego
	xor a			;85ec
	ld (0e019h),a		;85ed   ; la cuenta a 0
espera_240_paso:
	call paso		;85f0   ; un paso
	ld a,(0e019h)		;85f3
	cp 0f0h		;85f6   ; 240?
	jr c,espera_240_paso		;85f8
	ret			;85fa
tiempo:		; TIME baja: una unidad cada 32 cuadros (0xE010); a cero, OVER y la fase perdida
	ld a,(0e3cah)		;85fb   ; queda algo en la fase?
	and a			;85fe
	ret z			;85ff
	ld a,(0e1f3h)		;8600   ; la fase ya perdida?
	and a			;8603
	ret nz			;8604
	ld a,(0e1f2h)		;8605   ; ya sin tiempo?
	and a			;8608
	ret nz			;8609
	ld hl,0e010h		;860a   ; cada 32 cuadros
	call cuenta_32		;860d
	jp nz,tiempo_vram		;8610   ; aun no: solo la pantalla
	ld hl,0e080h		;8613   ; las unidades a 0?
	cp (hl)			;8616   ; 0?
	jr nz,tiempo_unidad		;8617
	inc hl			;8619   ; las decenas?
	cp (hl)			;861a   ; 0?
	jr nz,tiempo_decena		;861b
	inc hl			;861d   ; las centenas?
	cp (hl)			;861e   ; 0?
	jr nz,tiempo_centena		;861f
	inc hl			;8621   ; los millares?
	cp (hl)			;8622   ; 0?
	jr nz,tiempo_millar		;8623
	inc a			;8625   ; todo a 0: sin tiempo
	ld (0e1f2h),a		;8626   ; sin tiempo
	ld a,(0e3c0h)		;8629   ; si la fase no acaba de otra forma...
	and a			;862c
	jr nz,tiempo_over		;862d
	ld a,028h		;862f   ; ...perdida (0xE1F3 = 40)
	ld (0e1f3h),a		;8631
tiempo_over:		; OVER (0x9D79) en el sitio de las cifras
	ld hl,09d79h		;8634
	jp tiempo_vram_hl		;8637   ; cuatro casillas
tiempo_millar:		; Un millar menos y las de abajo a 9
	dec (hl)			;863a   ; el millar
	ld a,009h		;863b   ; y las otras a 9
	dec hl			;863d
	ld (hl),a			;863e
tiempo_nueve2:
	dec hl			;863f
	ld (hl),a			;8640
tiempo_nueve1:
	dec hl			;8641
	ld (hl),a			;8642
	jr tiempo_pinta		;8643
tiempo_centena:		; Una centena menos
	dec (hl)			;8645   ; la centena
	ld a,009h		;8646
	jr tiempo_nueve2		;8648
tiempo_decena:		; Una decena menos
	dec (hl)			;864a   ; la decena
	ld a,009h		;864b
	jr tiempo_nueve1		;864d
tiempo_unidad:		; Una unidad menos
	dec (hl)			;864f   ; la unidad
tiempo_pinta:		; TIME en la pantalla: las cifras al reves en 0xE084 y los ceros de la izquierda, espacios (0x10)
	ld b,004h		;8650   ; cuatro cifras...
	ld de,0e087h		;8652   ; al reves...
	ld hl,0e080h		;8655   ; ...al reves...
tiempo_copia:
	ld a,(hl)			;8658   ; una cifra
	ld (de),a			;8659   ; ...en 0xE084-0xE087
	inc hl			;865a
	dec de			;865b
	djnz tiempo_copia		;865c   ; cuatro
	ld bc,00410h		;865e   ; los ceros de la izquierda: B = 4, C = 0x10 (el espacio)
	xor a			;8661
tiempo_ceros:
	cp (hl)			;8662   ; 0?
	jr nz,tiempo_vram		;8663
	ld (hl),c			;8665   ; un espacio
	inc hl			;8666   ; la siguiente
	djnz tiempo_ceros		;8667
tiempo_vram:		; Cuatro casillas de 0xE084...
	ld hl,0e084h		;8669   ; las cifras
tiempo_vram_hl:		; ...o de HL en la fila 1, columna 18
	ld de,01832h		;866c   ; en la fila 1, columna 18
	ld bc,00004h		;866f   ; LDIRVM
	jp 0005ch		;8672   ; LDIRVM
tiempo_lleno:		; TIME al empezar: 100 (en la demostracion de la fase 1, 200)
	ld a,(0e048h)		;8675   ; la demostracion de la fase 1?
	cp 087h		;8678   ; 0x87?
	jr z,tiempo_cien		;867a
	call tiempo_borra		;867c   ; no: todo a 0...
	ld a,002h		;867f   ; ...y las centenas a 2
	ld (0e084h),a		;8681   ; 200
	ld (0e083h),a		;8684
	ret			;8687
tiempo_cien:		; 100
	call tiempo_borra		;8688   ; todo a 0
	inc a			;868b   ; las centenas a 1
	ld (0e082h),a		;868c   ; 100
	ld (0e085h),a		;868f
	xor a			;8692   ; las otras a 0
	ld (0e083h),a		;8693
	ld (0e084h),a		;8696
	ret			;8699
tiempo_borra:		; Las cifras de TIME y su copia a 0
	xor a			;869a
	ld (0e087h),a		;869b   ; la copia...
	ld (0e086h),a		;869e
	ld (0e085h),a		;86a1
	ld (0e080h),a		;86a4   ; ...y las cifras
	ld (0e081h),a		;86a7
	ld (0e082h),a		;86aa
	ret			;86ad
fase_pinta:		; La fase (0xE009-0xE00A) en la fila 0, columna 29
	ld hl,0e009h		;86ae   ; la fase...
	ld de,0181dh		;86b1   ; ...en la fila 0, columna 29
	ld bc,00002h		;86b4
	jp 0005ch		;86b7   ; LDIRVM
puntos_pinta:		; Los puntos (seis cifras, 0xE001) en la fila 0, columna 16
	ld hl,0e001h		;86ba   ; las seis cifras...
	ld de,01810h		;86bd   ; ...en la fila 0, columna 16
	ld bc,00006h		;86c0
	jp 0005ch		;86c3   ; LDIRVM
puntos:		; Los puntos + A (BCD) en las unidades y decenas (0xE00E), con acarreo
	ld b,a			;86c6
	ld a,(0e00eh)		;86c7   ; + A...
	add a,b			;86ca
	daa			;86cb   ; ...en BCD
	ld (0e00eh),a		;86cc   ; las unidades y decenas
	jr nc,puntos_cifras		;86cf   ; sin acarreo
	ld a,001h		;86d1   ; se lleva una
puntos_centenas:		; + A en las centenas y millares (0xE00D)
	ld b,a			;86d3
	ld a,(0e00dh)		;86d4   ; las centenas y millares
	add a,b			;86d7
	daa			;86d8
	ld (0e00dh),a		;86d9
	jr nc,puntos_cifras		;86dc   ; sin acarreo
	ld a,001h		;86de   ; se lleva una a 0xE00C
	ld b,a			;86e0
	ld a,(0e00ch)		;86e1   ; las decenas y centenas de millar
	add a,b			;86e4
	daa			;86e5
	ld (0e00ch),a		;86e6
	jr nc,puntos_cifras		;86e9
puntos_cifras:		; Las seis cifras sueltas de los puntos (0xE001), de los tres bytes BCD
	ld hl,0e001h		;86eb   ; las seis cifras...
	ld de,0e00ch		;86ee   ; ...de los tres bytes BCD
	ld b,003h		;86f1   ; tres bytes
puntos_cifra:		; Un byte: la mitad alta...
	ld a,(de)			;86f3
	ld c,a			;86f4
	and 0f0h		;86f5   ; la alta
	rrca			;86f7
	rrca			;86f8
	rrca			;86f9
	rrca			;86fa
	ld (hl),a			;86fb
	inc hl			;86fc
	ld a,c			;86fd   ; la baja
	and 00fh		;86fe
	ld (hl),a			;8700   ; la baja
	inc hl			;8701
	inc de			;8702
	djnz puntos_cifra		;8703
	ret			;8705
ram_borra:		; 0xE000-0xEEFF a cero
	ld hl,0e000h		;8706
	ld bc,00f00h		;8709   ; 0xF00 bytes
	jr ram_borra_byte		;870c
ram_borra_fase:		; 0xE100-0xEDFF a cero
	ld hl,0e100h		;870e
	ld bc,00e00h		;8711   ; 0xE00 bytes
ram_borra_byte:
	ld (hl),000h		;8714   ; a cero
	inc hl			;8716
	dec c			;8717   ; C bytes...
	jr nz,ram_borra_byte		;8718
	djnz ram_borra_byte		;871a   ; ...B veces
	ret			;871c
pantalla_borra:		; La pantalla en blanco (la casilla 0x10) y los sprites fuera
	ld a,010h		;871d   ; el espacio
	ld hl,01800h		;871f   ; toda la tabla de nombres
	ld bc,00300h		;8722   ; 768 casillas
	call 00056h		;8725   ; FILVRM
	jp fase_borra		;8728
letras:		; Las letras de la BIOS: 0x180 bytes desde 0x1D3F (los caracteres 0x30-0x5F) a la casilla 0 del tercio DE
	ld hl,01d3fh		;872b   ; la fuente de la BIOS, desde el caracter 0x30...
	ld bc,00180h		;872e   ; ...48 caracteres
	jp 0005ch		;8731
letras_20:		; Los caracteres 0x20-0x2F de la BIOS (0x1CBF) en DE
	ld hl,01cbfh		;8734   ; desde el caracter 0x20...
	ld bc,00080h		;8737   ; ...16 caracteres
	jp 0005ch		;873a
casillas_tercio:		; Las casillas del juego (0xA800, 0x600 bytes) en el tercio DE y despues las de 0xB34C en tramos
	push de			;873d
	ld hl,0a800h		;873e   ; 192 casillas
	ld bc,00600h		;8741   ; 0x600 bytes
	call 0005ch		;8744   ; LDIRVM
	pop de			;8747
	ld hl,001c0h		;8748   ; + 0x1C0: la casilla 0x78
	add hl,de			;874b
	ld de,0b34ch		;874c   ; los tramos de 0xB34C
	jr tramos		;874f
colores_tercio:		; Los colores del tercio DE, en tramos (0xB000)
	ex de,hl			;8751
	ld de,0b000h		;8752   ; los tramos de 0xB000
tramos:		; Tramos de DE en la VRAM HL: cuantos y el byte, hasta 0xFF
	ld a,(de)			;8755
	cp 0ffh		;8756   ; el final?
	ret z			;8758   ; el final
	ld b,a			;8759   ; cuantos...
	inc de			;875a
	ld a,(de)			;875b   ; ...el byte
tramos_byte:		; WRTVRM
	call 0004dh		;875c   ; WRTVRM
	inc hl			;875f
	djnz tramos_byte		;8760
	inc de			;8762
	jr tramos		;8763
colores8:		; FILVRM: 8 bytes de A en HL
	ld bc,00008h		;8765
	jp 00056h		;8768
sprites_dibujos:		; Los dibujos de los sprites (0xB800, 0x800 bytes) en 0x3800
	ld de,03800h		;876b
	ld hl,0b800h		;876e   ; de 0xB800...
	ld bc,00800h		;8771   ; ...0x800 bytes
	jp 0005ch		;8774
casillas_titulo:		; Las casillas del titulo en DE: los tramos de 0xB41D y 0x160 bytes de 0xAE00
	ex de,hl			;8777
	ld de,0b41dh		;8778   ; los tramos de 0xB41D
	call tramos		;877b
	ex de,hl			;877e
	ld hl,0ae00h		;877f   ; y 0x160 bytes de 0xAE00...
	ld bc,00160h		;8782
	push hl			;8785
	ld hl,00018h		;8786   ; ...24 bytes mas alla
	add hl,de			;8789
	ex de,hl			;878a
	pop hl			;878b
	jp 0005ch		;878c
casillas_b251:		; Los tramos de 0xB251 en DE
	ex de,hl			;878f
	ld de,0b251h		;8790   ; los tramos de 0xB251
	jr tramos		;8793
sprites_vram:		; Los atributos de los sprites (0xE100, 128 bytes) a la VRAM (0x1B00)
	ld de,01b00h		;8795
	ld hl,0e100h		;8798   ; desde 0xE100...
	ld bc,00080h		;879b   ; ...32 sprites
	jp 0005ch		;879e
protagonista_toca:		; Lo que hay bajo el protagonista (sus cuatro casillas): algo de 0x10 o mas lo mata (0xE1F3 = 48); menos de 0x10, se lo come: 0x40 puntos
	ld a,(0e1f3h)		;87a1   ; la fase ya perdida?
	and a			;87a4   ; si: nada
	ret nz			;87a5
	ld a,(0e20bh)		;87a6   ; 0xE20B: 16 o mas, nada
	cp 010h		;87a9
	ret nc			;87ab   ; empujando: nada
	call prota_vram		;87ac   ; su sitio en la pantalla
	call 0004ah		;87af   ; RDVRM
	cp 010h		;87b2   ; un espacio?
	jr nz,protagonista_toca_algo		;87b4
	inc hl			;87b6   ; la de la derecha
	call 0004ah		;87b7
	cp 010h		;87ba   ; un espacio?
	jr nz,protagonista_toca_algo		;87bc
	call abajo1		;87be   ; la de abajo
	call 0004ah		;87c1
	cp 010h		;87c4   ; un espacio?
	jr nz,protagonista_toca_algo		;87c6
	dec hl			;87c8   ; la de abajo a la izquierda
	call 0004ah		;87c9
	cp 010h		;87cc   ; un espacio?
	jr nz,protagonista_toca_algo		;87ce
	ret			;87d0   ; todo libre
protagonista_toca_algo:		; Algo
	cp 010h		;87d1   ; menos de 0x10?
	jr c,protagonista_come		;87d3
	xor a			;87d5   ; no: perdida...
	ld (0e20fh),a		;87d6   ; 0xE20F a 0
	ld a,030h		;87d9   ; ...0xE1F3 = 48
	ld (0e1f3h),a		;87db
	ret			;87de
protagonista_come:		; La casilla, borrada, y 0x40 puntos
	call pieza_borra		;87df   ; la pieza borrada
	ld a,040h		;87e2   ; 0x40 puntos
	jp puntos		;87e4   ; + 0x40 puntos
cuentas_4:		; Cuatro bloques de 10 bytes en 0xE3D3: su cuenta (+4) sube; a 0xF0, el bloque a cero
	ld ix,0e3d3h		;87e7
	ld de,0000ah		;87eb   ; de 10 en 10 bytes
	ld b,004h		;87ee   ; cuatro
L_87F0:
	inc (ix+004h)		;87f0   ; la cuenta + 1
	ld a,(ix+004h)		;87f3
	cp 0f0h		;87f6   ; 0xF0?
	call nc,bloque_borra		;87f8   ; a 0xF0: borrado
	add ix,de		;87fb   ; el siguiente
	djnz L_87F0		;87fd
	ret			;87ff
bloque_borra:		; Los 9 primeros bytes de IX a cero
	push bc			;8800
	push ix		;8801
	pop hl			;8803
	ld b,009h		;8804   ; nueve bytes
	xor a			;8806
bloque_borra_byte:
	ld (hl),a			;8807
	inc hl			;8808
	djnz bloque_borra_byte		;8809
	pop bc			;880b
	ret			;880c
protagonista_parpadea:		; Cada 4 cuadros cambia el dibujo: 0x60 o 0x6C
	ld a,(0e20eh)		;880d   ; la cuenta del parpadeo
	inc a			;8810
	ld (0e20eh),a		;8811
	bit 2,a		;8814   ; cada cuatro cuadros
	jr z,L_881D		;8816
	ld a,060h		;8818   ; el dibujo 0x60...
	jp prota_sprites		;881a
L_881D:
	ld a,06ch		;881d   ; ...o el 0x6C
	jp prota_sprites		;881f
protagonista:		; El protagonista cada cuadro: las cuentas, los sprites de los bloques que se mueven, y la palanca: se mueve de 8 en 8 puntos y empuja lo que tiene delante
	ld iy,0e200h		;8822   ; el protagonista (0xE200)
	call cuentas_4		;8826   ; las cuentas de 0xE3D3
	ld hl,0e110h		;8829   ; los sprites 4-11 (0xE110)...
	ld c,008h		;882c   ; ...ocho...
	ld de,0e3d3h		;882e   ; ...de los bloques de 0xE3D3
protagonista_sprite:		; Un sprite: 4 bytes...
	ld b,004h		;8831   ; cuatro bytes
protagonista_sprite_byte:
	ld a,(de)			;8833
	ld (hl),a			;8834   ; al sprite
	inc hl			;8835
	inc de			;8836
	djnz protagonista_sprite_byte		;8837
	inc de			;8839   ; ...de cada 5
	dec c			;883a   ; el siguiente
	jr nz,protagonista_sprite		;883b
	ld a,(0e1f3h)		;883d   ; la fase perdida?
	and a			;8840
	jr nz,protagonista_parpadea		;8841   ; si: parpadea
	ld hl,(0e200h)		;8843   ; la Y y la X del protagonista...
	ld (0e104h),hl		;8846   ; ...en sus otros tres sprites
	ld (0e108h),hl		;8849   ; el segundo
	ld (0e10ch),hl		;884c   ; el tercero
	ld a,(0e20bh)		;884f   ; 0xE20B: 16 o mas...
	cp 010h		;8852   ; 16 o mas?
	jp nc,bloque_va		;8854   ; ...otra cosa
	ld a,(0e1fch)		;8857   ; la palanca...
	and 007h		;885a   ; ...movida?
	jr z,$+9		;885c   ; sin palanca
	set 0,a		;885e   ; la direccion, impar
	jr $+5		;8860   ; (salta por encima de los 3 bytes de 0x8862)

; ----------------------------------------------------------------------
; DATOS byte_8862: "ld a,(0xE203)", la direccion de antes: los dos saltos de
;   0x885C y 0x8860 caen detras y no se llega aqui
;   0x8862..0x8865  (3 bytes)
DATA_byte_8862:
	defb 03ah,003h,0e2h	; 8862

; ======================================================================
; CODIGO 0x8865..0x8888  (35 bytes)
; ======================================================================


protagonista_dir:		; C = la direccion (0 sin palanca)
	ld c,a			;8865   ; la direccion
	ld a,(0e200h)		;8866   ; la Y + la X...
	add a,(iy+001h)		;8869   ; + la X
	and 007h		;886c   ; ...en el borde de una casilla?
	jr nz,$+41		;886e   ; no: sigue moviendose
	inc (iy+002h)		;8870   ; si: el paso del dibujo
	ld a,c			;8873   ; la direccion
protagonista_casilla:		; La casilla del protagonista; con direccion, hacia ella (la tabla de 0x8888)
	call prota_vram		;8874   ; su sitio en la pantalla
	and a			;8877   ; sin direccion?
	jr z,$+24		;8878   ; sin direccion, nada
	ld (0e203h),a		;887a   ; la direccion, apuntada
	push hl			;887d
	push af			;887e
	ld a,003h		;887f   ; el efecto 3 (un paso)
	call efecto_b_pide		;8881   ; un paso
	pop af			;8884
	call salta_dir		;8885   ; segun la direccion: 1 arriba, 3 derecha, 5 abajo, 7 izquierda

; ----------------------------------------------------------------------
; DATOS tabla_dir: Los cuatro destinos de 0x9F59 para el protagonista: arriba
;   (0x889C), derecha (0x8A4D), abajo (0x8969) e izquierda (0x8B29)
;   0x8888..0x8890  (8 bytes)
DATA_tabla_dir:
	defw 0889ch,08a4dh,08969h,08b29h	; 8888  -> prota_arriba prota_derecha prota_abajo prota_izquierda

; ======================================================================
; CODIGO 0x8890..0x88af  (31 bytes)
; ======================================================================


protagonista_dibujo:		; El dibujo segun la direccion
	call empujon_cero		;8890   ; el empujon a 0
	ld (iy+002h),a		;8893   ; el paso del dibujo
	ret			;8896
protagonista_igual:		; La direccion de antes
	ld a,(iy+003h)		;8897   ; la direccion de antes
	jr $-38		;889a
prota_arriba:		; Arriba: si la casilla de arriba esta libre, sube; si no, lo que haya (la tabla de 0x88AF)
	pop hl			;889c   ; fuera la vuelta
	call libre_arriba		;889d   ; la casilla de arriba, libre?
	jr nz,prota_arriba_algo		;88a0   ; no: lo que hay
prota_sube:		; Un punto arriba
	dec (iy+000h)		;88a2   ; un punto arriba
	jp prota_paso		;88a5   ; y su sprite
prota_arriba_algo:		; Lo que hay arriba
	call tipo_arriba		;88a8   ; su tipo (3-6)
	push hl			;88ab
	call salta_tipo		;88ac   ; por el tipo

; ----------------------------------------------------------------------
; DATOS tabla_arriba: Los cuatro destinos de 0x91A5 hacia arriba, por el tipo
;   de casilla (3-6)
;   0x88af..0x88b7  (8 bytes)
DATA_tabla_arriba:
	defw 0894bh,08952h,088e9h,088b7h	; 88af  -> prota_tipo1 prota_tipo2 prota_arriba_bloque2 prota_arriba_bloque

; ======================================================================
; CODIGO 0x88b7..0x897f  (200 bytes)
; ======================================================================


prota_arriba_bloque:		; Un bloque arriba: se empuja si detras hay sitio
	pop hl			;88b7   ; fuera la vuelta
	call arriba2_cero		;88b8   ; dos filas arriba
	call casillas_arriba		;88bb   ; sus dos casillas
	ld a,b			;88be   ; la casilla de detras, libre?
	cp 010h		;88bf
	jp nz,prota_quieto		;88c1   ; algo: quieto
	ld a,c			;88c4   ; el bloque 0xA7?
	cp 0a7h		;88c5   ; 0xA7?
	jr z,prota_bloque_a		;88c7
	cp 0a4h		;88c9   ; o 0xA4?
	jp z,prota_bloque_c		;88cb   ; 0xA4?
	ld (0e32dh),a		;88ce   ; el bloque...
	ld a,0a8h		;88d1   ; ...y la casilla 0xA8
	ld (0e30ch),a		;88d3   ; la casilla nueva
	inc hl			;88d6   ; la de la derecha
	call 0004ah		;88d7   ; la de su derecha, libre?
	dec hl			;88da
	cp 010h		;88db
	jp nz,prota_quieto		;88dd   ; algo: quieto
	call bloque_mueve		;88e0   ; el bloque se mueve
	inc hl			;88e3   ; la de la derecha
	ld a,(0e32dh)		;88e4   ; el bloque en su sitio nuevo
	jr prota_bloque_pon		;88e7
prota_arriba_bloque2:		; La otra mitad del bloque arriba
	pop hl			;88e9   ; fuera la vuelta
	call arriba2_cero		;88ea   ; dos filas arriba
	call casillas_arriba		;88ed   ; sus dos casillas
	cp 010h		;88f0   ; la casilla de detras, libre?
	jp nz,prota_quieto		;88f2   ; algo: quieto
	ld a,b			;88f5   ; el bloque 0xA2?
	cp 0a2h		;88f6   ; 0xA2?
	jr z,prota_bloque_a		;88f8
	cp 0a1h		;88fa   ; o 0xA1?
	jr z,prota_bloque_b		;88fc   ; 0xA1?
	ld (0e32dh),a		;88fe   ; el bloque
	ld a,0ach		;8901   ; la casilla 0xAC
	ld (0e30ch),a		;8903   ; la casilla nueva
	call 0004ah		;8906   ; RDVRM: libre?
	cp 010h		;8909
	jp nz,prota_quieto		;890b   ; algo: quieto
	call bloque_mueve		;890e   ; el bloque se mueve
	ld a,(0e32dh)		;8911   ; el bloque
prota_bloque_pon:		; El bloque en la VRAM y el protagonista sube
	call 0004dh		;8914   ; WRTVRM
	jp prota_sube		;8917   ; y sube
bloque_mueve:		; El bloque: sus casillas borradas y el sprite que se mueve (0xE30C)
	call pieza_borra		;891a   ; la pieza borrada
	call arriba1		;891d   ; una fila arriba
	ld a,(0e30ch)		;8920   ; la casilla nueva...
	ld c,a			;8923
	jp pieza		;8924   ; ...la pieza
prota_bloque_a:		; El bloque 0xA7 o 0xA2: borrado y a 0x8BF1
	call pieza_borra		;8927   ; la pieza borrada
	call arriba1		;892a   ; una fila arriba
	call encaja_arriba		;892d   ; encaja arriba
	jp prota_sube		;8930
prota_bloque_b:		; El bloque 0xA1: 0x8C00
	call pieza_borra		;8933   ; la pieza borrada
	call arriba1		;8936
	call encaja_izquierda		;8939   ; encaja a la izquierda
	jp prota_sube		;893c
prota_bloque_c:		; El bloque 0xA4: 0x8BFB
	call pieza_borra		;893f   ; la pieza borrada
	call arriba1		;8942
	call encaja_derecha		;8945   ; encaja a la derecha
	jp prota_sube		;8948
prota_tipo1:		; El tipo 1 (0xE20C = 1)
	pop hl			;894b   ; fuera la vuelta
	ld (iy+00ch),001h		;894c   ; el empujon del tipo 1
	jr prota_tipo_va		;8950
prota_tipo2:		; El tipo 2
	pop hl			;8952   ; fuera la vuelta
	ld (iy+00ch),002h		;8953   ; el empujon del tipo 2
prota_tipo_va:
	call arriba2		;8957   ; dos filas arriba
	call libre_arriba		;895a   ; libre?
	jp nz,prota_dibujo		;895d   ; no: el dibujo
	call abajo2		;8960   ; vuelta abajo
	call prota_empuja		;8963   ; el empujon + 1
	jp prota_dibujo		;8966
prota_abajo:		; Abajo: como arriba
	pop hl			;8969   ; fuera la vuelta
	call libre_abajo		;896a   ; la casilla de abajo, libre?
	jr nz,prota_abajo_algo		;896d   ; no: lo que hay
prota_baja:		; Un punto abajo
	inc (iy+000h)		;896f   ; un punto abajo
	jp prota_paso		;8972
prota_abajo_algo:		; Lo que hay abajo (la tabla de 0x897F)
	call prota_ajusta_y		;8975   ; la Y en su casilla
	call tipo_abajo		;8978   ; el tipo de abajo
	push hl			;897b
	call salta_tipo		;897c   ; por el tipo

; ----------------------------------------------------------------------
; DATOS tabla_abajo: Los cuatro destinos de 0x91A5 hacia abajo
;   0x897f..0x8987  (8 bytes)
DATA_tabla_abajo:
	defw 08987h,089c7h,08a39h,08a32h	; 897f  -> prota_abajo_bloque prota_abajo_bloque2 prota_tipo6 prota_tipo5

; ======================================================================
; CODIGO 0x8987..0x8a63  (220 bytes)
; ======================================================================


prota_abajo_bloque:		; Un bloque abajo
	pop hl			;8987   ; fuera la vuelta
	call abajo2_cero		;8988   ; dos filas abajo
	call casillas_abajo		;898b   ; sus dos casillas
	ld a,b			;898e   ; la casilla de detras, libre?
	cp 010h		;898f
	jp nz,prota_dibujo		;8991   ; algo: el dibujo
	ld a,c			;8994   ; el bloque 0xAD?
	cp 0adh		;8995   ; 0xAD?
	jp z,prota_abajo_a		;8997
	cp 0aeh		;899a   ; o 0xAE?
	jp z,prota_abajo_c		;899c   ; 0xAE?
	ld (0e32dh),a		;899f   ; el bloque...
	ld a,0a0h		;89a2   ; ...y la casilla 0xA0
	ld (0e30ch),a		;89a4   ; la casilla nueva
	call abajo1		;89a7
	inc hl			;89aa
	call 0004ah		;89ab   ; RDVRM
	dec hl			;89ae
	call arriba1		;89af
	cp 010h		;89b2   ; libre?
	jp nz,prota_dibujo		;89b4
	call bloque_mueve_abajo		;89b7   ; el bloque se mueve
	call abajo1		;89ba   ; una fila abajo
	inc hl			;89bd
	ld a,(0e32dh)		;89be
	call 0004dh		;89c1   ; WRTVRM
	jp prota_baja		;89c4   ; y baja
prota_abajo_bloque2:		; La otra mitad abajo
	pop hl			;89c7   ; fuera la vuelta
	call abajo2_cero		;89c8   ; dos filas abajo
	call casillas_abajo		;89cb   ; sus dos casillas
	cp 010h		;89ce   ; libre?
	jp nz,prota_dibujo		;89d0
	ld a,b			;89d3   ; 0xA8?
	cp 0a8h		;89d4   ; 0xA8?
	jr z,prota_abajo_a		;89d6
	cp 0abh		;89d8   ; 0xAB?
	jr z,prota_abajo_b		;89da   ; 0xAB?
	ld (0e32dh),a		;89dc   ; el bloque
	ld a,0a4h		;89df   ; la casilla 0xA4
	ld (0e30ch),a		;89e1   ; la casilla nueva
	call abajo1		;89e4
	call 0004ah		;89e7   ; RDVRM
	call arriba1		;89ea
	cp 010h		;89ed   ; libre?
	jp nz,prota_dibujo		;89ef
	call bloque_mueve_abajo		;89f2   ; el bloque se mueve
	call abajo1		;89f5
	ld a,(0e32dh)		;89f8   ; el bloque
	call 0004dh		;89fb   ; WRTVRM
	jp prota_baja		;89fe   ; y baja
bloque_mueve_abajo:		; El bloque de abajo: borrado y el sprite que se mueve
	call pieza_borra		;8a01   ; la pieza borrada
	call abajo1		;8a04   ; una fila abajo
	ld a,(0e30ch)		;8a07   ; la casilla nueva...
	ld c,a			;8a0a
	jp pieza		;8a0b   ; ...la pieza
prota_abajo_a:		; El bloque 0xAD/0xA8 abajo: 0x8BF6
	call pieza_borra		;8a0e   ; la pieza borrada
	call abajo1		;8a11
	call encaja_abajo		;8a14   ; encaja abajo
	jp prota_baja		;8a17
prota_abajo_b:		; El bloque 0xAB abajo: 0x8C00
	call pieza_borra		;8a1a   ; la pieza borrada
	call abajo1		;8a1d
	call encaja_izquierda		;8a20   ; encaja a la izquierda
	jp prota_baja		;8a23
prota_abajo_c:		; El bloque 0xAE abajo: 0x8BFB
	call pieza_borra		;8a26   ; la pieza borrada
	call abajo1		;8a29
	call encaja_derecha		;8a2c   ; encaja a la derecha
	jp prota_baja		;8a2f
prota_tipo5:		; El tipo 5 (0xE20C = 5)
	pop hl			;8a32
	ld (iy+00ch),005h		;8a33   ; el empujon del tipo 5
	jr prota_tipo_abajo		;8a37
prota_tipo6:		; El tipo 6
	pop hl			;8a39
	ld (iy+00ch),006h		;8a3a   ; el empujon del tipo 6
prota_tipo_abajo:
	call abajo2		;8a3e   ; dos filas abajo
	call libre_abajo		;8a41   ; libre?
	jp nz,prota_dibujo		;8a44
	call prota_empuja		;8a47   ; el empujon + 1
	jp prota_dibujo		;8a4a
prota_derecha:		; Derecha: si la casilla esta libre, un punto a la derecha; si no, lo que haya (la tabla de 0x8A63)
	pop hl			;8a4d   ; fuera la vuelta
	call libre_derecha		;8a4e   ; la casilla de la derecha, libre?
	jr nz,prota_derecha_algo		;8a51   ; no: lo que hay
prota_avanza:		; Un punto a la derecha
	inc (iy+001h)		;8a53   ; un punto a la derecha
	jp prota_paso		;8a56
prota_derecha_algo:		; Lo que hay a la derecha
	call prota_ajusta_x		;8a59   ; la X en su casilla
	call tipo_derecha		;8a5c   ; el tipo de la derecha
	push hl			;8a5f
	call salta_tipo		;8a60   ; por el tipo

; ----------------------------------------------------------------------
; DATOS tabla_derecha: Los cuatro destinos de 0x91A5 hacia la derecha
;   0x8a63..0x8a6b  (8 bytes)
DATA_tabla_derecha:
	defw 08a6bh,08b05h,08b0ch,08aa9h	; 8a63  -> prota_derecha_bloque prota_tipo3 prota_tipo4 prota_derecha_bloque2

; ======================================================================
; CODIGO 0x8a6b..0x8b3c  (209 bytes)
; ======================================================================


prota_derecha_bloque:		; Un bloque a la derecha
	pop hl			;8a6b   ; fuera la vuelta
	inc hl			;8a6c   ; dos casillas mas alla
	inc hl			;8a6d
	call derecha_cero		;8a6e   ; sus dos casillas
	ld a,b			;8a71
	cp 010h		;8a72   ; libre?
	jp nz,prota_dibujo		;8a74   ; algo: el dibujo
	ld a,c			;8a77   ; el bloque 0xAD?
	cp 0adh		;8a78   ; 0xAD?
	jp z,prota_derecha_a		;8a7a
	cp 0aeh		;8a7d   ; o 0xAE?
	jr z,prota_derecha_c		;8a7f   ; 0xAE?
	ld (0e32dh),a		;8a81   ; el bloque...
	ld a,0a0h		;8a84   ; ...y la casilla 0xA0
	ld (0e30ch),a		;8a86   ; la casilla nueva
	inc hl			;8a89
	call abajo1		;8a8a
	call 0004ah		;8a8d   ; RDVRM
	call arriba1		;8a90
	dec hl			;8a93
	cp 010h		;8a94   ; libre?
	jp nz,prota_dibujo		;8a96
	call bloque_mueve_derecha		;8a99   ; el bloque se mueve
	inc hl			;8a9c
	call abajo1		;8a9d
	ld a,(0e32dh)		;8aa0   ; el bloque en su sitio nuevo
	call 0004dh		;8aa3   ; WRTVRM
	jp prota_avanza		;8aa6   ; y avanza
prota_derecha_bloque2:		; La otra mitad a la derecha
	pop hl			;8aa9   ; fuera la vuelta
	inc hl			;8aaa
	inc hl			;8aab
	call derecha_cero		;8aac   ; sus dos casillas
	cp 010h		;8aaf   ; libre?
	jp nz,prota_dibujo		;8ab1   ; algo: el dibujo
	ld a,b			;8ab4   ; 0xA7?
	cp 0a7h		;8ab5   ; 0xA7?
	jr z,prota_derecha_b		;8ab7
	cp 0a4h		;8ab9   ; 0xA4?
	jr z,prota_derecha_c		;8abb   ; 0xA4?
	ld (0e32dh),a		;8abd   ; el bloque
	ld a,0a8h		;8ac0   ; la casilla 0xA8
	ld (0e30ch),a		;8ac2   ; la casilla nueva
	inc hl			;8ac5
	call 0004ah		;8ac6   ; RDVRM
	dec hl			;8ac9
	cp 010h		;8aca   ; libre?
	jp nz,prota_dibujo		;8acc
	call bloque_mueve_derecha		;8acf   ; el bloque se mueve
	inc hl			;8ad2
	ld a,(0e32dh)		;8ad3   ; el bloque
	call 0004dh		;8ad6   ; WRTVRM
	jp prota_avanza		;8ad9   ; y avanza
bloque_mueve_derecha:		; El bloque de la derecha: borrado y el sprite que se mueve
	call pieza_borra		;8adc   ; la pieza borrada
	inc hl			;8adf   ; una columna a la derecha
	ld a,(0e30ch)		;8ae0   ; la casilla nueva...
	ld c,a			;8ae3
	jp pieza		;8ae4   ; ...la pieza
prota_derecha_c:		; 0x8BFB
	call pieza_borra		;8ae7   ; la pieza borrada
	inc hl			;8aea
	call encaja_derecha		;8aeb   ; encaja a la derecha
	jp prota_avanza		;8aee
prota_derecha_a:		; 0x8BF6
	call pieza_borra		;8af1   ; la pieza borrada
	inc hl			;8af4
	call encaja_abajo		;8af5   ; encaja abajo
	jp prota_avanza		;8af8
prota_derecha_b:		; 0x8BF1
	call pieza_borra		;8afb   ; la pieza borrada
	inc hl			;8afe
	call encaja_arriba		;8aff   ; encaja arriba
	jp prota_avanza		;8b02
prota_tipo3:		; El tipo 3 (0xE20C = 3)
	pop hl			;8b05
	ld (iy+00ch),003h		;8b06   ; el empujon del tipo 3
	jr prota_tipo_derecha		;8b0a
prota_tipo4:		; El tipo 4
	pop hl			;8b0c
	ld (iy+00ch),004h		;8b0d   ; el empujon del tipo 4
prota_tipo_derecha:
	inc hl			;8b11   ; dos columnas a la derecha
	inc hl			;8b12
	call libre_derecha		;8b13   ; libre?
	jp nz,prota_dibujo		;8b16
	call prota_empuja		;8b19   ; el empujon + 1
	jp prota_dibujo		;8b1c
prota_empuja:		; La cuenta del empujon (+0x0B), hasta 16
	ld a,(iy+00bh)		;8b1f
	cp 010h		;8b22   ; 16?
	ret nc			;8b24   ; ya 16
	inc (iy+00bh)		;8b25
	ret			;8b28
prota_izquierda:		; Izquierda: si la casilla esta libre, un punto a la izquierda; si no, lo que haya (la tabla de 0x8B3C)
	pop hl			;8b29   ; fuera la vuelta
	call libre_izquierda		;8b2a   ; la casilla de la izquierda, libre?
	jr nz,prota_izquierda_algo		;8b2d   ; no: lo que hay
prota_retrocede:		; Un punto a la izquierda
	dec (iy+001h)		;8b2f   ; un punto a la izquierda
	jp prota_paso		;8b32
prota_izquierda_algo:		; Lo que hay a la izquierda
	call tipo_izquierda		;8b35   ; el tipo de la izquierda
	push hl			;8b38
	call salta_tipo		;8b39   ; por el tipo

; ----------------------------------------------------------------------
; DATOS tabla_izquierda: Los cuatro destinos de 0x91A5 hacia la izquierda
;   0x8b3c..0x8b44  (8 bytes)
DATA_tabla_izquierda:
	defw 08bd7h,08b44h,08b7eh,08bdeh	; 8b3c  -> prota_tipo7 prota_izquierda_bloque prota_izquierda_bloque2 prota_tipo8

; ======================================================================
; CODIGO 0x8b44..0x8c5f  (283 bytes)
; ======================================================================


prota_izquierda_bloque:		; Un bloque a la izquierda
	pop hl			;8b44   ; fuera la vuelta
	dec hl			;8b45   ; dos casillas mas alla
	dec hl			;8b46
	call izquierda_cero		;8b47   ; sus dos casillas
	ld a,b			;8b4a
	cp 010h		;8b4b   ; libre?
	jp nz,prota_quieto		;8b4d   ; algo: quieto
	ld a,c			;8b50   ; el bloque 0xAB?
	cp 0abh		;8b51   ; 0xAB?
	jr z,prota_izquierda_b		;8b53
	cp 0a8h		;8b55   ; o 0xA8?
	jr z,prota_izquierda_a		;8b57   ; 0xA8?
	ld (0e32dh),a		;8b59   ; el bloque...
	ld a,0a4h		;8b5c   ; ...y la casilla 0xA4
	ld (0e30ch),a		;8b5e   ; la casilla nueva
	call abajo1		;8b61
	call 0004ah		;8b64   ; RDVRM
	call arriba1		;8b67
	cp 010h		;8b6a   ; libre?
	jp nz,prota_quieto		;8b6c
	call bloque_mueve_izquierda		;8b6f   ; el bloque se mueve
	call abajo1		;8b72
	ld a,(0e32dh)		;8b75
	call 0004dh		;8b78   ; WRTVRM
	jp prota_retrocede		;8b7b   ; y retrocede
prota_izquierda_bloque2:		; La otra mitad a la izquierda
	pop hl			;8b7e   ; fuera la vuelta
	dec hl			;8b7f   ; dos columnas a la izquierda
	dec hl			;8b80
	call izquierda_cero		;8b81   ; sus dos casillas
	cp 010h		;8b84   ; libre?
	jp nz,prota_quieto		;8b86   ; algo: quieto
	ld a,b			;8b89   ; 0xA2?
	cp 0a2h		;8b8a   ; 0xA2?
	jr z,prota_izquierda_c		;8b8c
	cp 0a1h		;8b8e   ; 0xA1?
	jr z,prota_izquierda_b		;8b90   ; 0xA1?
	ld (0e32dh),a		;8b92   ; el bloque
	ld a,0ach		;8b95   ; la casilla 0xAC
	ld (0e30ch),a		;8b97   ; la casilla nueva
	call 0004ah		;8b9a   ; RDVRM
	cp 010h		;8b9d   ; libre?
	jp nz,prota_quieto		;8b9f
	call bloque_mueve_izquierda		;8ba2   ; el bloque se mueve
	ld a,(0e32dh)		;8ba5   ; el bloque
	call 0004dh		;8ba8   ; WRTVRM
	jp prota_retrocede		;8bab   ; y retrocede
prota_izquierda_b:		; 0x8C00
	call pieza_borra		;8bae   ; la pieza borrada
	dec hl			;8bb1
	call encaja_izquierda		;8bb2   ; encaja a la izquierda
	jp prota_retrocede		;8bb5
prota_izquierda_a:		; 0x8BF6
	call pieza_borra		;8bb8   ; la pieza borrada
	dec hl			;8bbb
	call encaja_abajo		;8bbc   ; encaja abajo
	jp prota_retrocede		;8bbf
prota_izquierda_c:		; 0x8BF1
	call pieza_borra		;8bc2   ; la pieza borrada
	dec hl			;8bc5
	call encaja_arriba		;8bc6   ; encaja arriba
	jp prota_retrocede		;8bc9
bloque_mueve_izquierda:		; El bloque de la izquierda: borrado y el sprite que se mueve
	call pieza_borra		;8bcc   ; la pieza borrada
	dec hl			;8bcf   ; una columna a la izquierda
	ld a,(0e30ch)		;8bd0
	ld c,a			;8bd3
	jp pieza		;8bd4   ; la pieza
prota_tipo7:		; El tipo 7 (0xE20C = 7)
	pop hl			;8bd7
	ld (iy+00ch),007h		;8bd8   ; el empujon del tipo 7
	jr prota_tipo_izquierda		;8bdc
prota_tipo8:		; El tipo 8
	pop hl			;8bde
	ld (iy+00ch),008h		;8bdf   ; el empujon del tipo 8
prota_tipo_izquierda:
	dec hl			;8be3   ; dos columnas a la izquierda
	dec hl			;8be4
	call libre_izquierda		;8be5   ; libre?
	jp nz,prota_dibujo		;8be8
	call prota_empuja		;8beb   ; el empujon + 1
	jp prota_dibujo		;8bee
encaja_arriba:		; La casilla de arriba (-32)...
	ld de,0ffe0h		;8bf1
	jr encaja		;8bf4
encaja_abajo:		; ...la de abajo (+32)...
	ld de,00020h		;8bf6
	jr encaja		;8bf9
encaja_derecha:		; ...la de la derecha (+1)...
	ld de,00001h		;8bfb
	jr encaja		;8bfe
encaja_izquierda:		; ...o la de la izquierda (-1)
	ld de,0ffffh		;8c00
encaja:		; La pieza de al lado pasa a 0x68: una menos por hacer (0xE3CA), 100 puntos y su numero
	ld c,068h		;8c03   ; la casilla 0x68
	add hl,de			;8c05   ; la pieza de al lado
	call pieza		;8c06   ; en su sitio
	call por_hacer_menos		;8c09   ; una menos por hacer
	ld a,001h		;8c0c   ; 100 puntos
	push hl			;8c0e
	call puntos_centenas		;8c0f   ; + 100 puntos
	pop hl			;8c12
	ld a,0d4h		;8c13   ; el sprite de los puntos (0xD4)
	call numero_sale		;8c15   ; su numero
	ret			;8c18
agua:		; Cada 4 cuadros (0xE01E), los colores de tres franjas cambian: el color de 0x2340 + 0x10
	ld hl,0e01eh		;8c19
	call cuenta_4		;8c1c   ; cada 4 cuadros
	ret nz			;8c1f
	ld de,007c0h		;8c20   ; de 0x7C0 en 0x7C0
	ld a,003h		;8c23   ; tres franjas
	ld (0e3cbh),a		;8c25   ; la cuenta
	ld hl,02340h		;8c28   ; el color de ahora (RDVRM)...
	call 0004ah		;8c2b   ; RDVRM
	add a,010h		;8c2e   ; ...el siguiente
	ld (0e3cch),a		;8c30   ; apuntado
agua_franja:		; Una franja: 32 bytes, y otros 32 dos filas mas abajo
	ld a,(0e3cch)		;8c33
	ld bc,00020h		;8c36   ; 32 bytes
	call 00056h		;8c39   ; FILVRM
	push de			;8c3c
	ld de,00040h		;8c3d   ; dos filas mas abajo
	add hl,de			;8c40
	pop de			;8c41
	ld bc,00020h		;8c42   ; 32 bytes
	call 00056h		;8c45   ; FILVRM
	add hl,de			;8c48   ; la franja siguiente
	ld a,(0e3cbh)		;8c49   ; una franja menos
	dec a			;8c4c   ; una menos
	ld (0e3cbh),a		;8c4d
	and a			;8c50
	ret z			;8c51
	jr agua_franja		;8c52
prota_paso:		; El protagonista ya movido: el empujon a 0 y su dibujo
	call empujon_cero		;8c54   ; el empujon a 0
	jr $+11		;8c57
prota_quieto:		; No puede moverse: el empujon a 0 y su dibujo
	pop hl			;8c59   ; fuera la vuelta
	call empujon_cero		;8c5a   ; el empujon a 0
	jr $+5		;8c5d   ; (salta por encima de los 3 bytes de 0x8C5F)

; ----------------------------------------------------------------------
; DATOS byte_8c5f: "call 0xB49A": los dos saltos de 0x8C57 y 0x8C5D caen
;   detras y no se llega aqui
;   0x8c5f..0x8c62  (3 bytes)
DATA_byte_8c5f:
	defb 0cdh,09ah,0b4h	; 8c5f

; ======================================================================
; CODIGO 0x8c62..0x8cbe  (92 bytes)
; ======================================================================


prota_dibujo:		; El dibujo del protagonista: cada 4 pasos el otro de la pareja de su direccion (0x8CBE)
	ld iy,0e200h		;8c62   ; el protagonista
	ld a,(iy+002h)		;8c66   ; el paso
	cp 008h		;8c69   ; 8 o mas: a 0
	jr nc,prota_dibujo_cero		;8c6b   ; a 0
	ld hl,08cbeh		;8c6d   ; la pareja de su direccion (+3)
	ld e,(iy+003h)		;8c70   ; la direccion - 1
	dec e			;8c73
	ld d,000h		;8c74
	add hl,de			;8c76
	inc (iy+002h)		;8c77   ; el paso siguiente
	bit 2,(iy+002h)		;8c7a   ; del 4 al 7, el segundo
	jr z,prota_dibujo_pon		;8c7e
	inc hl			;8c80   ; el segundo de la pareja
prota_dibujo_pon:
	ld a,(hl)			;8c81   ; el dibujo
prota_sprites:		; Los tres sprites del protagonista (0xE106) con los dibujos A, A + 4, A + 8 y sus colores (0x8CC8)
	ld ix,08cc8h		;8c82   ; los colores
	ld hl,0e106h		;8c86   ; desde el sprite 1 (0xE104 + 2)
	ld b,003h		;8c89   ; tres sprites
prota_sprites_uno:
	ld (hl),a			;8c8b   ; el dibujo
	inc hl			;8c8c
	ld d,(ix+000h)		;8c8d   ; el color
	ld (hl),d			;8c90
	inc hl			;8c91
	inc hl			;8c92
	inc hl			;8c93
	inc ix		;8c94
	add a,004h		;8c96   ; el siguiente dibujo
	djnz prota_sprites_uno		;8c98   ; los tres
	ret			;8c9a
prota_ajusta_y:		; La Y del protagonista al borde de la casilla (de 8 en 8)
	ld a,(0e200h)		;8c9b   ; la Y...
	and 007h		;8c9e
	ret z			;8ca0
	ld a,(0e200h)		;8ca1
	and 0f8h		;8ca4   ; ...de 8 en 8
	ld (0e200h),a		;8ca6
	ret			;8ca9
prota_ajusta_x:		; La X, igual
	ld a,(0e201h)		;8caa   ; la X...
	and 007h		;8cad
	ret z			;8caf
	ld a,(0e201h)		;8cb0
	and 0f8h		;8cb3   ; ...de 8 en 8
	ld (0e201h),a		;8cb5
	ret			;8cb8
prota_dibujo_cero:		; El paso a 0
	ld (iy+002h),000h		;8cb9
	ret			;8cbd

; ----------------------------------------------------------------------
; DATOS prota_dibujos: Los dibujos del protagonista, una pareja por direccion
;   (8 bytes), y los colores de sus tres sprites (0x8CC8: 15, 14 y 8)
;   0x8cbe..0x8ccb  (13 bytes)
DATA_prota_dibujos:
	defb 048h,054h	; 8cbe
	defb 018h,024h	; 8cc0
	defb 030h,03ch	; 8cc2
	defb 000h,00ch	; 8cc4
	defb 060h,06ch,00fh	; 8cc6
	defb 00eh,008h	; 8cc9

; ======================================================================
; CODIGO 0x8ccb..0x8d3d  (114 bytes)
; ======================================================================


bloque_va:		; Un bloque empujado: cada 5 cuadros (0xE019) avanza (la tabla 0x8D57) y deja sus casillas detras
	ld hl,0e019h		;8ccb   ; cada 5 cuadros
	call cuenta_5		;8cce
	ret nz			;8cd1
	ld a,002h		;8cd2   ; el efecto 2
	call efecto_b_pide		;8cd4   ; el efecto 2
	ld a,(0e20bh)		;8cd7   ; el empujon...
	cp 010h		;8cda   ; ...16?
	jr nz,bloque_va_sitio		;8cdc
bloque_va_sitio:		; Su sitio en la pantalla, + lo que avanza en su direccion (0x8D3D)
	ld hl,(0e206h)		;8cde   ; su sitio
	ld a,(0e203h)		;8ce1   ; su direccion
	push hl			;8ce4
	ld hl,08d3dh		;8ce5   ; la tabla
	ld e,a			;8ce8
	dec e			;8ce9
	ld d,000h		;8cea
	add hl,de			;8cec
	ld e,(hl)			;8ced   ; lo que se suma
	inc hl			;8cee
	ld d,(hl)			;8cef
	pop hl			;8cf0
	add hl,de			;8cf1   ; sumado
	inc (iy+00eh)		;8cf2   ; cada 3 veces
	ld a,(iy+00eh)		;8cf5
	cp 003h		;8cf8   ; 3?
	ret c			;8cfa
	push hl			;8cfb
	ld (iy+00eh),000h		;8cfc   ; la cuenta a 0
	ld a,(iy+00ch)		;8d00   ; su tipo (+0x0C, 1-8)...
	ld hl,08d57h		;8d03   ; ...en la tabla de 8 bytes 0x8D57
	ld de,00008h		;8d06   ; 8 bytes por tipo
bloque_va_tipo:
	dec a			;8d09
	jr z,bloque_va_mueve		;8d0a
	add hl,de			;8d0c
	jr bloque_va_tipo		;8d0d
bloque_va_mueve:		; Y y X del protagonista + los dos primeros bytes
	ld a,(0e200h)		;8d0f
	add a,(hl)			;8d12   ; + lo de la tabla
	ld (0e200h),a		;8d13
	inc hl			;8d16
	ld a,(0e201h)		;8d17
	add a,(hl)			;8d1a   ; + lo de la tabla
	ld (0e201h),a		;8d1b
	inc hl			;8d1e
	ld a,(0e20bh)		;8d1f   ; el empujon: 16, 15 o 14...
	cp 010h		;8d22   ; 16?
	jr z,bloque_va_casilla		;8d24
	inc hl			;8d26
	dec a			;8d27
	cp 010h		;8d28   ; 15?
	jr z,bloque_va_casilla		;8d2a
	inc hl			;8d2c
	dec a			;8d2d
	cp 010h		;8d2e   ; 14?
	jr z,bloque_va_casilla		;8d30
	jr $+19		;8d32   ; si no, se acaba
bloque_va_casilla:		; Las casillas del bloque segun el empujon
	ld c,(hl)			;8d34   ; la casilla
	pop hl			;8d35
	call pieza		;8d36   ; la pieza
	inc (iy+00bh)		;8d39   ; el empujon, uno mas
	ret			;8d3c

; ----------------------------------------------------------------------
; DATOS bloque_pasos: Lo que se mueve en la pantalla por direccion: -64
;   (arriba), +2, +64 (abajo), -2
;   0x8d3d..0x8d45  (8 bytes)
DATA_bloque_pasos:
	defw 0ffc0h,00002h,00040h,0fffeh	; 8d3d

; ======================================================================
; CODIGO 0x8d45..0x8d57  (18 bytes)
; ======================================================================


bloque_para:		; El bloque se para: sus ultimas casillas
	call empujon_cero		;8d45
	ld (0e20ch),a		;8d48   ; 0xE20C a 0
	inc hl			;8d4b
	ld c,(hl)			;8d4c   ; la casilla
	ex de,hl			;8d4d
	pop hl			;8d4e
	jp pieza		;8d4f   ; la pieza
empujon_cero:		; El empujon (0xE20B) a 0
	xor a			;8d52
	ld (0e20bh),a		;8d53   ; a 0
	ret			;8d56

; ----------------------------------------------------------------------
; DATOS bloque_tipos: Por tipo de empujon (1-8), 8 bytes: lo que se mueven la
;   Y y la X, cuatro casillas y dos bytes mas
;   0x8d57..0x8d97  (64 bytes)
DATA_bloque_tipos:
	defb 0f8h,000h,090h,098h,08ch,0a8h,080h,0ffh	; 8d57  ........
	defb 0f8h,000h,09ch,098h,094h,0ach,080h,0ffh	; 8d5f  ........
	defb 000h,008h,088h,084h,080h,0a0h,004h,000h	; 8d67  ........
	defb 000h,008h,07ch,084h,078h,0a8h,004h,000h	; 8d6f  ..|.x...
	defb 008h,000h,08ch,098h,090h,0a0h,080h,000h	; 8d77  ........
	defb 008h,000h,094h,098h,09ch,0a4h,080h,000h	; 8d7f  ........
	defb 000h,0f8h,080h,084h,088h,0a4h,0fch,0ffh	; 8d87  ........
	defb 000h,0f8h,078h,084h,07ch,0ach,0fch,0ffh	; 8d8f  ..x.|...

; ======================================================================
; CODIGO 0x8d97..0x9005  (622 bytes)
; ======================================================================


fase_pantalla:		; La pantalla de la fase: en blanco, el laberinto (0x9CD0), TIME, SCORE y STAGE arriba
	call botones_cero		;8d97   ; los botones a 0
	call ram_borra_fase		;8d9a   ; la RAM de la fase a cero
	call pantalla_borra		;8d9d   ; la pantalla en blanco
	call marco		;8da0   ; el laberinto
	ld hl,09d73h		;8da3   ; TIME : en la fila 1, columna 10
	ld de,0182ah		;8da6   ; en la fila 1, columna 10
	ld bc,00006h		;8da9
	call 0005ch		;8dac   ; LDIRVM
	ld hl,09d7dh		;8daf   ; SCORE:000000 en la fila 0, columna 10
	ld de,0180ah		;8db2   ; en la fila 0, columna 10
	ld bc,0000ch		;8db5
	call 0005ch		;8db8   ; LDIRVM
	ld hl,09d89h		;8dbb   ; STAGE: en la fila 0, columna 23
	ld de,01817h		;8dbe   ; en la fila 0, columna 23
	ld bc,00006h		;8dc1
	call 0005ch		;8dc4   ; LDIRVM
	call fase_pinta		;8dc7   ; el numero de la fase
	xor a			;8dca
	ld (0e010h),a		;8dcb   ; la cuenta a 0
	ret			;8dce
descanso:		; Cada cinco fases, la fase de premio: un campo de bloques, TIME 100; al acabar, cada clase de casilla que queda da sus puntos
	ld a,(0e007h)		;8dcf   ; la fase 51?
	cp 033h		;8dd2   ; si: el final
	jp z,final		;8dd4   ; el final
	call tiempo_cien		;8dd7   ; TIME 100
	call descanso_clave		;8dda   ; los bloques
	call fase_pantalla		;8ddd   ; la pantalla de la fase
	call sonido_calla_pide		;8de0   ; el sonido callado
	call protagonista_sale		;8de3   ; el protagonista
	ld hl,018c3h		;8de6   ; desde la fila 6, columna 3...
	ld c,044h		;8de9   ; ...la casilla 0x44 (el bloque)...
	ld d,007h		;8deb   ; ...siete filas...
descanso_fila:		; ...de trece bloques
	ld b,00dh		;8ded   ; trece
descanso_bloque:
	push bc			;8def
	call pieza		;8df0   ; un bloque
	inc hl			;8df3   ; dos columnas mas alla
	inc hl			;8df4
	pop bc			;8df5
	djnz descanso_bloque		;8df6   ; la fila
	push de			;8df8
	ld de,00006h		;8df9   ; la fila siguiente (dos mas abajo)
	add hl,de			;8dfc
	pop de			;8dfd
	call abajo1		;8dfe   ; una fila mas
	dec d			;8e01   ; siete
	jr nz,descanso_fila		;8e02
	ld hl,01881h		;8e04   ; un hueco arriba a la izquierda
	call pieza_borra		;8e07   ; el hueco
	call protagonista_pon		;8e0a   ; el protagonista
	call marco		;8e0d   ; el marco
	call puntos_pinta		;8e10   ; los puntos
	ld a,009h		;8e13   ; 9 por hacer
	ld (0e3cah),a		;8e15   ; en 0xE3CA
descanso_bucle:		; Hasta que TIME llega a 0
	ld a,001h		;8e18
	ld (0e3c0h),a		;8e1a   ; 0xE3C0 = 1
	call paso_cada4		;8e1d   ; un paso cada 4 cuadros
	ld a,(0e080h)		;8e20   ; TIME a 0?
	and a			;8e23
	jr nz,descanso_bucle		;8e24
	ld a,(0e081h)		;8e26   ; las decenas?
	and a			;8e29
	jr nz,descanso_bucle		;8e2a
	ld a,(0e082h)		;8e2c   ; las centenas?
	and a			;8e2f
	jr nz,descanso_bucle		;8e30
	ld a,048h		;8e32   ; las casillas 0x48: 100 puntos cada una
	ld (0e32dh),a		;8e34
	ld a,001h		;8e37
	ld (0e30ch),a		;8e39
	call cuenta_casillas		;8e3c   ; las cuenta
	ld a,0b0h		;8e3f   ; las 0xB0: 500
	ld (0e32dh),a		;8e41
	ld a,005h		;8e44
	ld (0e30ch),a		;8e46
	call cuenta_casillas		;8e49   ; las cuenta
	ld a,0e0h		;8e4c   ; las 0xE0: 300
	ld (0e32dh),a		;8e4e
	ld a,003h		;8e51
	ld (0e30ch),a		;8e53
	call cuenta_casillas		;8e56   ; las cuenta
	ld a,068h		;8e59   ; las 0x68: 1000
	ld (0e32dh),a		;8e5b
	ld a,010h		;8e5e
	ld (0e30ch),a		;8e60
	call cuenta_casillas		;8e63   ; las cuenta
	xor a			;8e66   ; una espera
	ld (0e01bh),a		;8e67   ; la cuenta a 0
descanso_espera:		; 96 cuadros
	call paso		;8e6a   ; un paso
	ld a,(0e01bh)		;8e6d
	cp 060h		;8e70   ; 96?
	jr c,descanso_espera		;8e72
	call tiempo_lleno		;8e74   ; TIME lleno
	call fase_borra		;8e77   ; la RAM de la fase a cero
	call sonido_calla_pide		;8e7a   ; el sonido callado
	call pantalla_borra		;8e7d   ; la pantalla en blanco
	call fase_siguiente		;8e80   ; la fase siguiente
	ld a,(0e007h)		;8e83   ; la fase 50?
	cp 032h		;8e86   ; si: el final
	jp z,final		;8e88   ; si: el final
	call contrasena		;8e8b   ; la contrasena
	jp fase_hecha_sigue		;8e8e   ; la fase siguiente
cuenta_casillas:		; Busca en la pantalla la casilla de 0xE32D: cada una, sus puntos (0xE30C x 100) y su sonido
	ld a,004h		;8e91   ; la musica 4
	call musica_pide		;8e93   ; la musica 4
	ld hl,01861h		;8e96   ; desde la fila 3
cuenta_casillas_una:
	push hl			;8e99
	call paso		;8e9a   ; un paso
	pop hl			;8e9d
	call 0004ah		;8e9e   ; RDVRM
	ld c,a			;8ea1
	ld a,(0e32dh)		;8ea2   ; la buscada?
	cp c			;8ea5   ; la buscada?
	call z,cuenta_casilla		;8ea6   ; si: sus puntos
	inc hl			;8ea9   ; la casilla siguiente
	ld a,h			;8eaa   ; la fila 24?
	cp 01bh		;8eab   ; hasta el final de la pantalla
	jr nz,cuenta_casillas_una		;8ead
cuenta_casillas_espera:		; 40 cuadros
	call paso		;8eaf   ; un paso
	ld a,(0e015h)		;8eb2
	cp 028h		;8eb5   ; 40?
	jr c,cuenta_casillas_espera		;8eb7
	ret			;8eb9
cuenta_casilla:		; Una: sus puntos, el efecto 4, borrada y 24 cuadros
	push hl			;8eba
	call paso		;8ebb   ; un paso
	ld a,(0e30ch)		;8ebe   ; los puntos
	call puntos_centenas		;8ec1   ; x 100 puntos
	ld a,004h		;8ec4   ; el efecto 4
	call efecto_b_pide		;8ec6   ; el efecto 4
	pop hl			;8ec9
	call pieza_borra		;8eca   ; borrada
	push hl			;8ecd
	ld hl,0e015h		;8ece   ; la cuenta 0xE015...
	ld (hl),000h		;8ed1   ; ...a 0
cuenta_casilla_espera:
	push hl			;8ed3
	call paso		;8ed4   ; un paso
	pop hl			;8ed7
	ld a,(hl)			;8ed8
	cp 018h		;8ed9   ; 24?
	jr c,cuenta_casilla_espera		;8edb
	pop hl			;8edd
	ret			;8ede
libre_arriba:		; Z si las casillas de arriba estan libres (segun la fase: 0xE3C0)
	call casillas_arriba		;8edf   ; las de arriba
	jr libre		;8ee2
libre_abajo:		; ...las de abajo...
	call casillas_abajo		;8ee4   ; las de abajo
	jr libre		;8ee7
libre_izquierda:		; ...las de la izquierda...
	call casillas_izquierda		;8ee9   ; las de la izquierda
	jr libre		;8eec
libre_derecha:		; ...las de la derecha
	call casillas_derecha		;8eee   ; las de la derecha
libre:		; Libre: en la fase normal, las dos casillas son el espacio
	ld (0e3d0h),a		;8ef1   ; la primera
	ld a,(0e3c0h)		;8ef4   ; el final (2)?
	cp 002h		;8ef7
	jr z,libre_final		;8ef9
	cp 003h		;8efb   ; el descanso (3)?
	jr z,libre_descanso		;8efd
	ld a,(0e3d0h)		;8eff   ; un espacio...
	cp 010h		;8f02   ; la primera, libre?
	ret nz			;8f04
	ld a,b			;8f05   ; ...y otro?
	cp 010h		;8f06   ; la segunda?
	ret nz			;8f08
	jr libre_si		;8f09
libre_final:		; En el final: el espacio o una casilla de 0x6C o mas
	ld a,(0e3d0h)		;8f0b
	cp 010h		;8f0e   ; un espacio?
	jr z,libre_si		;8f10
	cp 06ch		;8f12   ; 0x6C o mas?
	ret c			;8f14
	jr libre_si		;8f15
libre_descanso:		; En el descanso: menos de 0x40 o 0xAF o mas
	ld a,(0e3d0h)		;8f17
	cp 040h		;8f1a   ; menos de 0x40?
	jr c,libre_si		;8f1c
	cp 0afh		;8f1e   ; 0xAF o mas?
	jr nc,libre_si		;8f20
	ret			;8f22   ; NZ: tapado
libre_si:		; Z
	xor a			;8f23   ; Z: libre
	ret			;8f24
final:		; El final, tras la fase 50: un campo de bloques, la musica 5 y el texto (0x9068) letra a letra; el protagonista sale por arriba y vuelta a la fase 1
	ld de,00680h		;8f25   ; las casillas del final (0xB251) en los tres tercios
	call casillas_b251		;8f28
	ld de,00e80h		;8f2b   ; el segundo tercio
	call casillas_b251		;8f2e
	ld de,01680h		;8f31   ; el tercero
	call casillas_b251		;8f34
	ld hl,02e80h		;8f37   ; sus colores
	ld bc,00180h		;8f3a   ; 0x180 bytes
	ld a,090h		;8f3d   ; 0x90
	call 00056h		;8f3f   ; FILVRM
	ld a,002h		;8f42   ; 0xE3C0 = 2: el final
	ld (0e3c0h),a		;8f44
	call fase_pantalla		;8f47   ; la pantalla de la fase
	ld a,005h		;8f4a   ; la musica 5
	call musica_pide		;8f4c
	ld a,003h		;8f4f   ; tres filas...
	ld (0e210h),a		;8f51
	ld hl,01909h		;8f54   ; ...desde la fila 8, columna 9...
	ld de,00040h		;8f57   ; de dos en dos filas
	ld c,044h		;8f5a   ; ...de bloques
final_fila:		; Siete bloques
	ld b,007h		;8f5c   ; siete
	push hl			;8f5e
final_bloque:
	call pieza		;8f5f   ; un bloque
	inc hl			;8f62   ; dos columnas mas alla
	inc hl			;8f63
	djnz final_bloque		;8f64
	pop hl			;8f66
	add hl,de			;8f67   ; dos filas mas abajo
	ld a,(0e210h)		;8f68
	dec a			;8f6b   ; una menos
	ld (0e210h),a		;8f6c
	jr nz,final_fila		;8f6f
	call protagonista_sale		;8f71   ; el protagonista
	ld ix,0e210h		;8f74   ; tres lineas de texto (0xE210, 0xE220, 0xE230)...
	ld hl,09068h		;8f78   ; ...de 0x9068: su sitio y su texto
	ld de,00010h		;8f7b   ; de 16 en 16
	ld b,003h		;8f7e   ; tres
final_linea:
	ld a,(hl)			;8f80
	ld (ix+001h),a		;8f81   ; su sitio...
	inc hl			;8f84
	ld a,(hl)			;8f85
	ld (ix+002h),a		;8f86
	inc hl			;8f89
	ld a,(hl)			;8f8a
	ld (ix+003h),a		;8f8b   ; su texto...
	inc hl			;8f8e
	ld a,(hl)			;8f8f
	ld (ix+004h),a		;8f90
	inc hl			;8f93
	add ix,de		;8f94   ; la siguiente
	djnz final_linea		;8f96
	ld hl,09073h		;8f98   ; los mandos del final (0x9073)
	ld (0e049h),hl		;8f9b   ; el puntero
	ld a,087h		;8f9e   ; con mandos
	ld (0e048h),a		;8fa0
	xor a			;8fa3
	ld (0e3cdh),a		;8fa4   ; sin golpe
final_bucle:		; Un paso cada cuadro hasta que el protagonista sale por arriba (Y 0xE0)
	ld a,002h		;8fa7
	ld (0e3c0h),a		;8fa9
	ld hl,0e01ah		;8fac   ; un cuadro
	call cuenta_1		;8faf
	jr c,final_bucle		;8fb2
	call paso_cada4		;8fb4   ; el protagonista con los mandos
	call final_lineas		;8fb7   ; las tres lineas
	ld a,(0e201h)		;8fba   ; arriba del todo?
	cp 0e0h		;8fbd   ; arriba del todo?
	jr nz,final_bucle		;8fbf
	xor a			;8fc1   ; todo a cero: la fase 1
	ld (0e007h),a		;8fc2
	ld (0e047h),a		;8fc5
	ld (0e048h),a		;8fc8
	xor a			;8fcb
	ld (0e009h),a		;8fcc   ; las decenas a 0
	ld (0e007h),a		;8fcf
	ld (0e00fh),a		;8fd2
	inc a			;8fd5
	ld (0e00ah),a		;8fd6   ; la fase 1
	call contrasena		;8fd9   ; la contrasena
	jp partida_casillas		;8fdc   ; las casillas y la partida
final_lineas:		; Las tres lineas de texto
	ld ix,0e210h		;8fdf   ; la primera
	call final_linea_paso		;8fe3
	ld ix,0e220h		;8fe6   ; la segunda
	call final_linea_paso		;8fea
	ld ix,0e230h		;8fed   ; la tercera
	jp final_linea_paso		;8ff1
final_linea_paso:		; Una: segun su paso (+0), 0x9005
	ld l,(ix+001h)		;8ff4   ; su sitio
	ld h,(ix+002h)		;8ff7
	push hl			;8ffa
	ld a,(ix+000h)		;8ffb   ; su paso
	cp 006h		;8ffe   ; 6 o mas: nada
	jr nc,$+17		;9000
	call salta_a		;9002   ; segun el paso

; ----------------------------------------------------------------------
; DATOS tabla_final: Los seis destinos de 0x9F53 para cada linea del final,
;   por su paso (0-5)
;   0x9005..0x9011  (12 bytes)
DATA_tabla_final:
	defw 09013h,09025h,09029h,0902dh,09031h,09041h	; 9005

; ======================================================================
; CODIGO 0x9011..0x9068  (87 bytes)
; ======================================================================


final_nada:		; (el paso 6 y mas no llega aqui)
	pop hl			;9011   ; fuera su sitio
	ret			;9012
final_espera:		; El paso 0: espera a que pase el protagonista (la casilla 0x54)
	pop hl			;9013   ; su sitio
	call 0004ah		;9014   ; RDVRM
	cp 054h		;9017   ; 0x54?
	ret nz			;9019
	inc (ix+000h)		;901a   ; el paso siguiente
	xor a			;901d   ; los bloques rotos a 0
	ld (0e300h),a		;901e
	ld (0e302h),a		;9021
	ret			;9024
final_borra1:		; Los pasos 1-4: la fila de bloques se cambia por las casillas 0x54, 0x58, 0x5C, 0x60...
	ld c,054h		;9025   ; la casilla 0x54
	jr final_fila_casillas		;9027
final_borra2:
	ld c,058h		;9029   ; la 0x58
	jr final_fila_casillas		;902b
final_borra3:
	ld c,05ch		;902d   ; la 0x5C
	jr final_fila_casillas		;902f
final_borra4:
	ld c,060h		;9031   ; la 0x60
final_fila_casillas:		; ...siete de cada
	pop hl			;9033   ; su sitio
	inc (ix+000h)		;9034   ; el paso siguiente
	ld b,007h		;9037   ; siete
final_fila_casilla:
	call pieza		;9039   ; la pieza
	inc hl			;903c
	inc hl			;903d
	djnz final_fila_casilla		;903e
	ret			;9040
final_texto:		; El paso 5: su texto, 14 casillas
	pop hl			;9041
	ld e,(ix+003h)		;9042   ; su texto
	ld d,(ix+004h)		;9045
	ld (ix+005h),001h		;9048   ; dos filas
final_texto_fila:
	ld b,00eh		;904c   ; 14 casillas
	push hl			;904e
final_texto_casilla:
	ld a,(de)			;904f
	call 0004dh		;9050   ; WRTVRM
	inc hl			;9053
	inc de			;9054
	djnz final_texto_casilla		;9055
	pop hl			;9057
	push de			;9058
	ld de,00020h		;9059   ; la fila siguiente
	add hl,de			;905c
	pop de			;905d
	dec (ix+005h)		;905e   ; una menos
	ld a,(ix+005h)		;9061
	and a			;9064
	jr z,final_texto_fila		;9065
	ret			;9067

; ----------------------------------------------------------------------
; DATOS final_lineas: Las tres lineas del final: su sitio en la pantalla y su
;   texto (0x909E, 0x90BA, 0x90D6); el ultimo byte (0x90) es el primero de los
;   mandos
;   0x9068..0x9073  (11 bytes)
DATA_final_lineas:
	defw 01909h,0909eh	; 9068  -> 0x1909 DATA_final_textos
	defw 01949h,090bah	; 906c
	defw 01989h	; 9070
	defb 0d6h	; 9072

; ----------------------------------------------------------------------
; DATOS mandos: Los mandos grabados, en parejas (direccion y cuadros): los del
;   final desde 0x9073 y los de la demostracion del titulo desde 0x9086
;   0x9073..0x909e  (43 bytes)
DATA_mandos:
	defb 090h	; 9073
	defb 023h,055h,053h,01bh,017h,025h,023h,01bh,017h,025h,023h,01bh,047h,035h,033h,047h	; 9074  #US..%#..%#.G53G
	defb 015h,0f3h	; 9084
	defb 0f3h,035h,023h,01bh,023h,01bh,023h,01bh,023h,01bh,023h,01bh,023h,01bh,023h,01bh	; 9086  .5#.#.#.#.#.#.#.
	defb 023h,01bh,0f3h,041h,047h,045h,0f3h,0f3h	; 9096  #..AGE..

; ----------------------------------------------------------------------
; DATOS final_textos: Los tres textos del final: dos filas de 14 casillas
;   propias cada uno
;   0x909e..0x90f2  (84 bytes)
DATA_final_textos:
	defb 010h,010h,0d0h,010h,010h,0d0h,010h,010h,010h,0d0h,010h,010h,0d0h,010h	; 909e  ..............
	defb 010h,0d1h,0d2h,0d3h,0d4h,0d5h,0d6h,010h,0d7h,0d8h,0d9h,0d2h,0d5h,0d2h	; 90ac  ..............
	defb 010h,010h,0dah,0dbh,0dch,0d8h,0ddh,010h,010h,0d0h,0deh,0dfh,0d8h,0e0h	; 90ba  ..............
	defb 010h,0e1h,0e2h,0e3h,0e4h,0d0h,0e5h,010h,0e6h,0e7h,0e8h,0e9h,010h,0eah	; 90c8  ..............
	defb 010h,0f3h,0d0h,010h,0d2h,0d5h,0d2h,010h,010h,0d0h,010h,0ebh,0ech,0edh	; 90d6  ..............
	defb 010h,010h,0d0h,010h,010h,0d0h,010h,010h,0eeh,0f4h,0eeh,0efh,0f0h,0f1h	; 90e4  ..............

; ----------------------------------------------------------------------
; DATOS bytes_90f2: "ld b,a / ld c,0 / jp LDIRVM": seis bytes de codigo a los
;   que no se llega
;   0x90f2..0x90f8  (6 bytes)
DATA_bytes_90f2:
	defb 047h,00eh,000h,0c3h,05ch,000h	; 90f2

; ======================================================================
; CODIGO 0x90f8..0x9133  (59 bytes)
; ======================================================================


descanso_clave:		; Al empezar el descanso: KEYWORD [.....] y la contrasena siguiente (0x9E8F + 6 x 0xE00F), 240 cuadros
	call pantalla_borra		;90f8   ; la pantalla en blanco
	call sonido_calla_pide		;90fb   ; el sonido callado
	ld hl,09133h		;90fe   ; KEYWORD [     ]...
	ld de,0194ah		;9101   ; ...en la fila 10, columna 10
	ld bc,0000fh		;9104   ; 15 casillas
	call 0005ch		;9107   ; LDIRVM
	ld hl,09e89h		;910a   ; la tabla de contrasenas, 6 antes
	ld a,(0e00fh)		;910d   ; la siguiente (0xE00F + 1)
	inc a			;9110
	ld (0e00fh),a		;9111   ; apuntada
	ld b,a			;9114
descanso_clave_busca:		; 6 bytes por contrasena
	ld a,006h		;9115   ; 6 bytes...
	add a,l			;9117
	jr nc,L_911B		;9118
	inc hl			;911a
L_911B:
	ld l,a			;911b
	djnz descanso_clave_busca		;911c   ; ...por contrasena
	ld de,01953h		;911e   ; sus cinco letras en la fila 10, columna 19
	ld bc,00005h		;9121   ; cinco letras
	call 0005ch		;9124   ; LDIRVM
	xor a			;9127   ; 240 cuadros
	ld (0e011h),a		;9128   ; la cuenta a 0
descanso_clave_espera:
	ld a,(0e011h)		;912b
	cp 0f0h		;912e   ; 240?
	jr c,descanso_clave_espera		;9130
	ret			;9132

; ----------------------------------------------------------------------
; DATOS texto_keyword2: KEYWORD [     ] (15 casillas), el del descanso
;   0x9133..0x9142  (15 bytes)
DATA_texto_keyword2:
	defb 01bh,015h,029h,027h,01fh,022h,014h,010h,038h,010h,010h,010h,010h,010h,039h	; 9133  ..)'."..8.....9

; ======================================================================
; CODIGO 0x9142..0x9152  (16 bytes)
; ======================================================================


sonido_calla_pide:		; Pide callar el sonido (0xE1C3 = 0xFF) y lo calla
	ld a,0ffh		;9142
	ld (0e1c3h),a		;9144   ; en 0xE1C3...
	jp psg_mezcla		;9147   ; ...y al registro 7
por_hacer_menos:		; Una cosa menos por hacer en la fase (0xE3CA)
	ld a,(0e3cah)		;914a
	dec a			;914d   ; una menos
	ld (0e3cah),a		;914e
	ret			;9151

; ----------------------------------------------------------------------
; DATOS titulo_grande: ICE WORLD en letras grandes: una fila de 8 casillas y
;   dos de 13
;   0x9152..0x9174  (34 bytes)
DATA_titulo_grande:
	defb 0e5h,010h,010h,010h,010h,0ech,0edh,0eeh	; 9152  ........
	defb 0e6h,0d8h,0e7h,0e8h,010h,0efh,0f0h,0d6h,0d7h,0f1h,0f2h,0f3h,0f4h	; 915a  .............
	defb 0e9h,0e2h,0eah,0ebh,010h,0f5h,0f6h,0f7h,0f8h,0f9h,0fah,0fbh,0fch	; 9167  .............

; ----------------------------------------------------------------------
; DATOS texto_game_over: GAME OVER
;   0x9174..0x917d  (9 bytes)
DATA_texto_game_over:
	defb 017h,011h,01dh,015h,010h,01fh,026h,015h,022h	; 9174  ......&."

; ======================================================================
; CODIGO 0x917d..0x93b8  (571 bytes)
; ======================================================================


paso_cada4:		; Un paso cada 4 cuadros (0xE014)
	ld hl,0e014h		;917d
	call cuenta_1		;9180   ; cada 4 cuadros
	ret nz			;9183
paso_demo:		; Un paso con los mandos grabados: el protagonista, los bloques y los enemigos
	call paso		;9184   ; un paso
	call protagonista		;9187   ; el protagonista
	call bloques_rotos		;918a   ; los bloques que se rompen
	call boton		;918d   ; el boton
	jp golpe_sprite		;9190   ; el sprite del golpe
paso_fase:		; El paso de la fase: cada 4 cuadros, y los enemigos cada 24
	ld hl,0e014h		;9193
	call cuenta_1		;9196   ; cada 4 cuadros
	ret nz			;9199
	call enemigos		;919a   ; los enemigos
	jr paso_demo		;919d
protagonista_sale:		; El protagonista en su sitio y los sprites
	call protagonista_pon		;919f   ; en su sitio
	jp sprites_vram		;91a2   ; los sprites a la VRAM
salta_tipo:		; La tabla de saltos de detras de la llamada por el tipo de casilla A (3-6); 8 o mas, 0x8C59
	pop hl			;91a5   ; la tabla
	cp 008h		;91a6   ; 8 o mas?
	jp nc,prota_quieto		;91a8
	sub 003h		;91ab   ; (A - 3) x 2
	rlca			;91ad
	push de			;91ae
	jp salta		;91af   ; a la tabla
prota_vram:		; HL = el sitio del protagonista en la pantalla (0xE206), calculado cuando esta justo en una casilla
	push af			;91b2
	push de			;91b3
	ld a,(0e20bh)		;91b4   ; empujando?
	and a			;91b7
	jr nz,prota_vram_va		;91b8
	ld a,(0e200h)		;91ba   ; la Y en el borde de una casilla?
	and 007h		;91bd
	jr nz,prota_vram_va		;91bf
	ld a,(0e201h)		;91c1   ; la X?
	and 007h		;91c4
	jr nz,prota_vram_va		;91c6
	ld h,018h		;91c8   ; 0x1800...
	ld a,(0e201h)		;91ca   ; ...+ X / 8...
	and 0f8h		;91cd
	rrca			;91cf
	rrca			;91d0
	rrca			;91d1
	ld l,a			;91d2   ; la columna
	ld de,00000h		;91d3
	ld a,(0e200h)		;91d6   ; ...+ la Y / 8 x 32
	and 0c0h		;91d9   ; los bits altos de la fila...
	rlca			;91db
	rlca			;91dc
	ld d,a			;91dd   ; ...en D
	ld a,(0e200h)		;91de
	and 038h		;91e1   ; los bajos...
	rlca			;91e3
	rlca			;91e4
	ld e,a			;91e5   ; ...x 32 en E
	add hl,de			;91e6
	ld (0e206h),hl		;91e7   ; apuntado
prota_vram_va:
	ld hl,(0e206h)		;91ea   ; el sitio
	pop de			;91ed
	pop af			;91ee
	ret			;91ef
iy_sitio:		; HL = el sitio de IY (+0, +1)
	ld l,(iy+000h)		;91f0
	ld h,(iy+001h)		;91f3
	ret			;91f6
cuenta_1:		; Z si la cuenta (HL) ha llegado a 1, y la pone a 0
	ld a,001h		;91f7   ; 1
	jr cuenta_mira		;91f9
cuenta_4:		; ...a 4
	ld a,004h		;91fb   ; 4
	jr cuenta_mira		;91fd
cuenta_5:		; ...a 5
	ld a,005h		;91ff   ; 5
	jr cuenta_mira		;9201
cuenta_32:		; ...a 32
	ld a,020h		;9203
cuenta_mira:
	cp (hl)			;9205
	jr z,cuenta_cero		;9206
	jr c,cuenta_cero		;9208
	ret			;920a
cuenta_cero:
	xor a			;920b
	ld (hl),a			;920c
	ret			;920d
botones_cero:		; Los botones a 0 y 0xE3CD
	xor a			;920e
	ld (0e3cdh),a		;920f
botones_pon:		; Los botones (0xE044 y 0xE040) a A
	ld (0e044h),a		;9212
	ld (0e040h),a		;9215
	ret			;9218
ix_sitio:		; HL = (IX+0, IX+1)
	ld l,(ix+000h)		;9219
	ld h,(ix+001h)		;921c
	ret			;921f
ix_sitio_pon:		; (IX+0, IX+1) = HL
	ld (ix+000h),l		;9220
	ld (ix+001h),h		;9223
	ret			;9226
enemigos:		; Cada 24 cuadros (0xE015), los quince enemigos (0xE210, 16 bytes cada uno)
	ld a,(0e015h)		;9227
	cp 018h		;922a   ; 24?
	ret c			;922c
	xor a			;922d
	ld (0e015h),a		;922e
	ld iy,0e200h		;9231   ; desde 0xE210
	ld de,00010h		;9235
	ld b,00fh		;9238   ; quince
enemigos_uno:
	add iy,de		;923a
	push de			;923c
	push bc			;923d
	call iy_sitio		;923e   ; su sitio
	call enemigo		;9241
	pop bc			;9244
	pop de			;9245
	djnz enemigos_uno		;9246
	ret			;9248
enemigo:		; Uno: segun su estado (+4): 0 un huevo, 1 y 2 sale, 3 aplastado, 4 o mas se rompe
	ld a,(iy+000h)		;9249   ; esta?
	and a			;924c
	jr nz,L_9256		;924d
	ld a,(iy+001h)		;924f
	and a			;9252
	jr nz,L_9256		;9253
	ret			;9255
L_9256:
	bit 2,(iy+00dh)		;9256   ; el bit 2 de +0x0D cambia cada vez: el dibujo
	jr z,L_9262		;925a
	res 2,(iy+00dh)		;925c
	jr L_9266		;9260
L_9262:
	set 2,(iy+00dh)		;9262
L_9266:
	ld a,(iy+00ch)		;9266   ; empujado (+0x0C de 16 o mas)?
	cp 010h		;9269
	jr nc,enemigo_aplastado		;926b
	ld a,(iy+004h)		;926d   ; el estado
	and a			;9270
	jp z,huevo		;9271
	cp 001h		;9274
	jp z,enemigo_estado1		;9276
	cp 002h		;9279
	jp z,enemigo_estado2		;927b
	cp 003h		;927e
	jp z,enemigo_estado3		;9280
	jp enemigo_rompe		;9283
enemigo_aplastado:		; Empujado contra algo: aplastado (3)
	ld (iy+00ch),000h		;9286
	ld (iy+004h),003h		;928a
	ret			;928e
enemigo_estado3:		; Aplastado: el efecto 1, sus dibujos y, al acabar, sus puntos
	ld a,001h		;928f   ; el efecto 1
	call efecto_pide		;9291
	inc (iy+00eh)		;9294   ; la cuenta (+0x0E)
	ld a,(iy+00eh)		;9297
	cp 008h		;929a
	jr nc,enemigo_estado3_paso		;929c
	dec (iy+00eh)		;929e
	call enemigo_dibujo		;92a1
enemigo_estado3_paso:
	cp 008h		;92a4
	jp z,enemigo_rompe1		;92a6
	cp 009h		;92a9
	jp z,enemigo_rompe2		;92ab
	cp 00ah		;92ae
	jp z,enemigo_rompe3		;92b0
	ret c			;92b3
	push hl			;92b4
	ld a,(iy+004h)		;92b5   ; en el estado 0 no da puntos
	and a			;92b8
	jr z,enemigo_fuera		;92b9
	ld a,(iy+003h)		;92bb   ; la Y: abajo (0xD8)?
	cp 0d8h		;92be
	jr nc,enemigo_500		;92c0
	ld a,0cch		;92c2   ; el sprite de 1000 puntos (0xCC)...
	call numero_sale		;92c4
	ld a,010h		;92c7
	jr enemigo_puntos		;92c9
enemigo_500:		; ...o el de 500 (0xD0)
	ld a,0d0h		;92cb
	call numero_sale		;92cd
	ld a,005h		;92d0
enemigo_puntos:		; x 100 puntos
	call puntos_centenas		;92d2
enemigo_fuera:		; Borrado y fuera
	pop hl			;92d5
	call pieza_borra		;92d6
	jp enemigo_borra		;92d9
enemigo_dibujo:		; Su casilla: +3 + el bit de +0x0D + 0x20, y la cuenta + 1
	ld a,(iy+003h)		;92dc   ; su dibujo
	add a,(iy+00dh)		;92df   ; + el bit del parpadeo
	add a,020h		;92e2   ; + 0x20
	ld c,a			;92e4
	call iy_sitio		;92e5
	call pieza		;92e8   ; la pieza
	inc (iy+00eh)		;92eb
	ld a,(iy+00eh)		;92ee
	ret			;92f1
enemigo_rompe:		; El estado 4: se rompe en cuatro pasos (0x58, 0x5C, 0x60) y 50 puntos
	inc (iy+00ch)		;92f2   ; un paso mas
	ld a,(iy+00ch)		;92f5
	cp 004h		;92f8   ; el cuarto?
	jr z,enemigo_roto		;92fa
	cp 001h		;92fc   ; el primero?
	jr z,enemigo_rompe1		;92fe
	cp 002h		;9300
	jr z,enemigo_rompe2		;9302
	jr enemigo_rompe3		;9304
enemigo_roto:		; Roto: 50 puntos y fuera
	ld a,032h		;9306   ; 50 puntos
	push hl			;9308
	call puntos		;9309
	pop hl			;930c
	call pieza_borra		;930d   ; la pieza borrada
	jp enemigo_borra		;9310   ; y el enemigo fuera
enemigo_rompe1:
	ld c,058h		;9313
	jr enemigo_rompe_pon		;9315
enemigo_rompe2:
	ld c,05ch		;9317
	jr enemigo_rompe_pon		;9319
enemigo_rompe3:
	ld c,060h		;931b
enemigo_rompe_pon:
	call iy_sitio		;931d
	jp pieza		;9320
huevo:		; El estado 0, el huevo: si hay bloques a los dos lados (arriba y abajo o derecha e izquierda), se rompe (4); si no, va madurando (0x48, 0x4C, 0x50) y sale
	call tipo_derecha2		;9323   ; arriba...
	and 00fh		;9326
	jr z,huevo_lados		;9328
	call tipo_izquierda2		;932a   ; ...y abajo?
	and 00fh		;932d
	jr nz,huevo_rompe		;932f
huevo_lados:		; ...o derecha...
	call tipo_arriba2		;9331
	and 00fh		;9334
	jr z,huevo_madura		;9336
	call tipo_abajo2		;9338   ; ...e izquierda?
	and 00fh		;933b
	jr z,huevo_madura		;933d
huevo_rompe:		; Entre dos: se rompe
	ld (iy+004h),004h		;933f
	ld (iy+00ch),000h		;9343
	ld (iy+00eh),000h		;9347
	ret			;934b
huevo_madura:
	ld a,(0e1f3h)		;934c   ; la fase perdida?
	and a			;934f
	jr nz,huevo_cuenta		;9350
	call hay_0f		;9352   ; una casilla 0x0F en la pieza?
	call iy_sitio		;9355
	and a			;9358
	jr z,huevo_cuenta		;9359
	jr huevo_vuelve		;935b
huevo_cuenta:		; La cuenta: en la demostracion de la fase 1 madura enseguida
	dec (iy+00eh)		;935d   ; la espera, uno menos
	ld a,(0e048h)		;9360   ; la demostracion de la fase 1?
	cp 087h		;9363
	jr z,huevo_paso		;9365
	ld a,(iy+00eh)		;9367   ; acabada?
	cp 002h		;936a
	ret nc			;936c
huevo_paso:		; Un paso mas: la casilla siguiente (0x93B8)
	ld (iy+00eh),00ah		;936d
	inc (iy+005h)		;9371
	ld a,(iy+005h)		;9374   ; el tercero?
	cp 003h		;9377
	jr z,huevo_sale		;9379
	cp 003h		;937b
	jr z,huevo_abre		;937d
	ld e,a			;937f
	ld d,000h		;9380
	ld hl,093b8h		;9382   ; la casilla del paso
	add hl,de			;9385
	ld c,(hl)			;9386
	call iy_sitio		;9387
huevo_pon:		; Su casilla y el efecto 2
	call pieza		;938a
	ld a,002h		;938d
	jp efecto_pide		;938f
huevo_abre:
	call iy_sitio		;9392   ; su sitio
	ld a,(iy+003h)		;9395   ; su dibujo + el parpadeo...
	add a,(iy+00dh)		;9398
	add a,010h		;939b   ; ...+ 0x10
	ld c,a			;939d
	jr huevo_pon		;939e
huevo_vuelve:		; Con una 0x0F en la pieza: otra vez entero (0x48)
	call iy_sitio		;93a0
	ld c,048h		;93a3
	ld (iy+005h),000h		;93a5
	ld (iy+00eh),00ah		;93a9
	jp pieza		;93ad
huevo_sale:		; Sale: el estado 1
	ld (iy+002h),005h		;93b0
	inc (iy+004h)		;93b4
	ret			;93b7

; ----------------------------------------------------------------------
; DATOS huevo_casillas: Las casillas del huevo: entero (0x48), roto (0x4C) y
;   mas roto (0x50)
;   0x93b8..0x93bb  (3 bytes)
DATA_huevo_casillas:
	defb 048h,04ch,050h	; 93b8

; ======================================================================
; CODIGO 0x93bb..0x950e  (339 bytes)
; ======================================================================


enemigo_estado2:		; Saliendo: sus dibujos; si esta abajo (0xD8), el estado 1; si no, 100 puntos
	call enemigo_dibujo		;93bb
	cp 020h		;93be
	ret c			;93c0
	ld a,(iy+003h)		;93c1
	cp 0d8h		;93c4   ; abajo?
	jr nz,L_93CD		;93c6
	ld (iy+004h),001h		;93c8
	ret			;93cc
L_93CD:
	call iy_sitio		;93cd
	ld c,040h		;93d0   ; la casilla 0x40
	call pieza		;93d2
	ld a,0d4h		;93d5   ; el sprite de los puntos
	call numero_sale		;93d7
	call enemigo_borra		;93da
	ld a,001h		;93dd   ; 100 puntos
	jp puntos_centenas		;93df
enemigo_estado1:		; El estado 1: si hay una 0x0F en su pieza, el estado 2
	call iy_sitio		;93e2   ; su sitio
	ld (iy+00eh),000h		;93e5   ; la cuenta a 0
	ld a,(0e1f3h)		;93e9   ; la fase perdida?
	and a			;93ec
	jr nz,enemigo_anda		;93ed
	call hay_0f		;93ef   ; una 0x0F en la pieza?
	and a			;93f2
	jr z,enemigo_anda		;93f3
	ld (iy+004h),002h		;93f5
	ret			;93f9
enemigo_anda:
	call iy_sitio		;93fa
	call iy_pieza		;93fd   ; su casilla en la pantalla
	ld a,(iy+003h)		;9400   ; abajo del todo (0xD8)?
	cp 0d8h		;9403
	jr c,enemigo_mira		;9405
	inc (iy+00fh)		;9407   ; alli, un paso de cada tres
	ld a,(iy+00fh)		;940a
	cp 003h		;940d
	ret c			;940f
	ld (iy+00fh),000h		;9410
enemigo_mira:		; Lo que tiene alrededor, en los bits de +6: 3 arriba, 1 abajo, 2 derecha, 0 izquierda
	ld a,(iy+006h)		;9414   ; los bits bajos a 0
	and 0f0h		;9417
	ld (iy+006h),a		;9419
	call iy_sitio		;941c
	xor a			;941f
	ld (0e32dh),a		;9420
	call tipo_arriba2		;9423   ; arriba: algo?
	cp 010h		;9426
	jr z,enemigo_mira_abajo		;9428
	set 3,(iy+006h)		;942a   ; el bit 3
	ld (0e32dh),a		;942e
enemigo_mira_abajo:		; Abajo
	call tipo_abajo2		;9431
	cp 010h		;9434
	jr z,enemigo_mira_lados		;9436
	set 1,(iy+006h)		;9438   ; el bit 1
	ld c,a			;943c
	ld a,(0e32dh)		;943d   ; arriba + abajo: entre 6 y 10...
	add a,c			;9440
	cp 006h		;9441
	jr c,enemigo_mira_lados		;9443
	cp 00bh		;9445
	jr nc,enemigo_mira_lados		;9447
	bit 0,a		;9449   ; ...e impar: aplastado entre dos bloques
	jr nz,enemigo_entre		;944b
enemigo_mira_lados:		; A los lados
	xor a			;944d
	ld (0e32dh),a		;944e
	call tipo_derecha2		;9451   ; la derecha
	cp 010h		;9454
	jr z,enemigo_mira_izq		;9456
	set 2,(iy+006h)		;9458   ; el bit 2
	ld (0e32dh),a		;945c
enemigo_mira_izq:		; La izquierda
	call tipo_izquierda2		;945f
	cp 010h		;9462
	jr z,enemigo_busca		;9464
	set 0,(iy+006h)		;9466   ; el bit 0
	ld c,a			;946a
	ld a,(0e32dh)		;946b   ; derecha + izquierda: entre 6 y 11, impar?
	add a,c			;946e
	cp 006h		;946f
	jr c,enemigo_busca		;9471
	cp 00ch		;9473
	jr nc,enemigo_busca		;9475
	bit 0,a		;9477
	jr nz,enemigo_entre		;9479
	jr enemigo_busca		;947b
enemigo_entre:		; Entre dos: aplastado (el estado 3)
	ld (iy+004h),003h		;947d
	ret			;9481
enemigo_busca:		; Hacia el protagonista: su fila y su columna contra las del enemigo dan la direccion (1-8, 0xE32E)
	ld c,000h		;9482
	call prota_vram		;9484   ; la casilla del protagonista
	ex de,hl			;9487
	ld a,e			;9488   ; su fila (0-23)
	and 0e0h		;9489
	rlca			;948b
	rlca			;948c
	rlca			;948d
	ld e,a			;948e
	ld a,d			;948f
	and 003h		;9490
	rlca			;9492
	rlca			;9493
	rlca			;9494
	add a,e			;9495
	ld e,a			;9496
	call iy_sitio		;9497   ; la del enemigo
	ld a,l			;949a
	and 0e0h		;949b
	rlca			;949d
	rlca			;949e
	rlca			;949f
	ld l,a			;94a0
	ld a,h			;94a1
	and 003h		;94a2
	rlca			;94a4
	rlca			;94a5
	rlca			;94a6
	add a,l			;94a7
	ld l,a			;94a8
	cp e			;94a9   ; mas arriba, igual o mas abajo?
	push hl			;94aa
	call prota_vram		;94ab
	ex de,hl			;94ae
	pop hl			;94af
	call iy_sitio		;94b0
	jr c,enemigo_busca_arriba		;94b3
	jr z,enemigo_busca_igual		;94b5
	jr enemigo_busca_abajo		;94b7
enemigo_busca_arriba:		; El protagonista mas arriba: 4, 5 o 6 segun la columna
	ld a,e			;94b9   ; la columna del protagonista
	and 01fh		;94ba
	ld e,a			;94bc
	ld a,l			;94bd   ; la del enemigo
	and 01fh		;94be
	cp e			;94c0   ; mas a la izquierda, igual o mas a la derecha?
	jr c,enemigo_dir4		;94c1
	jr z,enemigo_dir5		;94c3
	jr enemigo_dir6		;94c5
enemigo_dir4:
	ld a,004h		;94c7
	jr enemigo_dir		;94c9
enemigo_dir5:
	ld a,005h		;94cb
	jr enemigo_dir		;94cd
enemigo_dir6:
	ld a,006h		;94cf
	jr enemigo_dir		;94d1
enemigo_busca_igual:		; En la misma fila: 7 o 3
	ld a,e			;94d3   ; la columna del protagonista
	and 01fh		;94d4
	ld e,a			;94d6
	ld a,l			;94d7   ; la del enemigo
	and 01fh		;94d8
	cp e			;94da   ; a la izquierda?
	jr c,enemigo_dir3		;94db
	ld a,007h		;94dd
	jr enemigo_dir		;94df
enemigo_dir3:
	ld a,003h		;94e1
	jr enemigo_dir		;94e3
enemigo_busca_abajo:		; Mas abajo: 2, 1 u 8
	ld a,e			;94e5   ; la columna del protagonista
	and 01fh		;94e6
	ld e,a			;94e8
	ld a,l			;94e9   ; la del enemigo
	and 01fh		;94ea
	cp e			;94ec   ; a la izquierda, igual o a la derecha?
	jr c,enemigo_dir2		;94ed
	jr z,enemigo_dir1		;94ef
	jr enemigo_dir8		;94f1
enemigo_dir2:
	ld a,002h		;94f3
	jr enemigo_dir		;94f5
enemigo_dir1:
	ld a,001h		;94f7
	jr enemigo_dir		;94f9
enemigo_dir8:
	ld a,008h		;94fb
enemigo_dir:		; La direccion buscada
	ld (0e32eh),a		;94fd
	ld a,(iy+009h)		;9500   ; sin camino apuntado...
	and a			;9503
	call z,camino_nuevo		;9504   ; ...el camino nuevo
	ld a,(iy+002h)		;9507   ; segun hacia donde va (+2): la tabla de 0x950E
	push hl			;950a
	call salta_dir		;950b

; ----------------------------------------------------------------------
; DATOS tabla_enemigo: Los cuatro destinos de 0x9F59 segun la direccion del
;   enemigo: arriba (0x9516), derecha (0x95E1), abajo (0x959D) e izquierda
;   (0x9626)
;   0x950e..0x9516  (8 bytes)
DATA_tabla_enemigo:
	defw 09516h,095e1h,0959dh,09626h	; 950e  -> enemigo_arriba enemigo_derecha enemigo_abajo enemigo_izquierda

; ======================================================================
; CODIGO 0x9516..0x9551  (59 bytes)
; ======================================================================


enemigo_arriba:		; Hacia arriba: si no hay nada, sube; si lo hay, busca otro lado
	pop hl			;9516
	bit 3,(iy+006h)		;9517   ; algo arriba?
	jr nz,enemigo_arriba_tapado		;951b
	call enemigo_sube		;951d   ; no: un paso arriba
	jr enemigo_camino		;9520
enemigo_arriba_tapado:
	call camino_apunta		;9522   ; apuntado en el camino
	ld a,(iy+008h)		;9525   ; la direccion buscada: 5 o mas?
	cp 005h		;9528
	jp nc,enemigo_arriba_izq		;952a
	call gira_der		;952d   ; si no, a la derecha...
	ld (iy+002h),003h		;9530
	call camino_apunta		;9534
	call camino_menos_izq		;9537   ; ...o a la izquierda
	ld (iy+002h),007h		;953a
	call camino_mas_abajo		;953e
	ret			;9541
enemigo_camino:		; Sigue el camino apuntado (0x9F42): la direccion siguiente
	call camino		;9542   ; el camino
	dec e			;9545   ; el paso - 1
	ld d,000h		;9546
	add hl,de			;9548
	ld a,(hl)			;9549   ; la direccion apuntada
	call iy_sitio		;954a
	push hl			;954d
	call salta_dir		;954e

; ----------------------------------------------------------------------
; DATOS tabla_camino: Los cuatro destinos de 0x9F59 por la direccion del
;   camino apuntado: arriba (0x9559), derecha (0x955F), abajo (0x9565) e
;   izquierda (0x956B)
;   0x9551..0x9559  (8 bytes)
DATA_tabla_camino:
	defw 09559h,0955fh,09565h,0956bh	; 9551  -> camino_arriba camino_derecha camino_abajo camino_izquierda

; ======================================================================
; CODIGO 0x9559..0x9708  (431 bytes)
; ======================================================================


camino_arriba:		; Libre arriba?
	pop hl			;9559
	call casillas_arriba		;955a
	jr camino_libre		;955d
camino_derecha:		; ...a la derecha?
	pop hl			;955f
	call casillas_derecha		;9560
	jr camino_libre		;9563
camino_abajo:		; ...abajo?
	pop hl			;9565
	call casillas_abajo		;9566
	jr camino_libre		;9569
camino_izquierda:		; ...a la izquierda?
	pop hl			;956b
	call casillas_izquierda		;956c
camino_libre:		; Libre: el camino, un paso menos; a los 8 pasos, se olvida
	cp 010h		;956f   ; las dos casillas, libres?
	ret nz			;9571
	ld a,b			;9572
	cp 010h		;9573
	ret nz			;9575
	ld a,(iy+009h)		;9576   ; hay camino?
	and a			;9579
	ret z			;957a
	inc (iy+005h)		;957b   ; un paso mas
	ld a,(iy+005h)		;957e
	cp 008h		;9581   ; 8?
	jp nc,camino_olvida		;9583
	set 7,(iy+006h)		;9586   ; el bit 7 de +6
	dec (iy+009h)		;958a   ; uno menos en el camino
	call camino		;958d
	ld d,000h		;9590
	add hl,de			;9592
	ld a,(hl)			;9593   ; la direccion apuntada
	ld (iy+002h),a		;9594
	ret			;9597
camino_olvida:		; El camino, a 0
	ld (iy+009h),000h		;9598
	ret			;959c
enemigo_abajo:		; Hacia abajo: igual
	pop hl			;959d
	bit 1,(iy+006h)		;959e   ; algo abajo?
	jr nz,enemigo_abajo_tapado		;95a2
	call enemigo_baja		;95a4   ; no: un paso abajo
	jp enemigo_camino		;95a7
enemigo_abajo_tapado:
	call camino_apunta		;95aa   ; apuntado en el camino
	ld a,(iy+008h)		;95ad   ; la direccion buscada: 5 o mas?
	cp 005h		;95b0   ; 5 o mas?
	jr nc,enemigo_abajo_izq		;95b2
	call gira_der		;95b4   ; a la derecha?
	ld (iy+002h),003h		;95b7
	call camino_apunta		;95bb   ; apuntado
	call camino_menos_izq		;95be
	ld (iy+002h),007h		;95c1
	call camino_mas_arriba		;95c5
	ret			;95c8
enemigo_abajo_izq:
	call gira_izq		;95c9   ; a la izquierda?
	ld (iy+002h),007h		;95cc   ; hacia la izquierda
	call camino_apunta		;95d0   ; apuntado
	call camino_menos_der		;95d3
	ld (iy+002h),003h		;95d6   ; hacia la derecha
	call camino_mas_arriba		;95da
	jp z,enemigo_va_arriba		;95dd
	ret			;95e0
enemigo_derecha:		; Hacia la derecha
	pop hl			;95e1
	bit 2,(iy+006h)		;95e2   ; algo a la derecha?
	jr nz,enemigo_derecha_tapado		;95e6
	call enemigo_derecha1		;95e8   ; no: un paso a la derecha
	jp enemigo_camino		;95eb
enemigo_derecha_tapado:
	call camino_apunta		;95ee   ; apuntado en el camino
	ld a,(iy+008h)		;95f1   ; la direccion buscada: de 3 a 6?
	cp 007h		;95f4   ; 7 o mas?
	jr nc,enemigo_derecha_abajo		;95f6
	cp 003h		;95f8   ; menos de 3?
	jr c,enemigo_derecha_abajo		;95fa
	call gira_abajo		;95fc   ; abajo?
	ld (iy+002h),005h		;95ff
	call camino_apunta		;9603
	call camino_menos_arriba		;9606
	ld (iy+002h),001h		;9609
	call camino_mas_izq		;960d
	ret			;9610
enemigo_derecha_abajo:
	call gira_arriba		;9611   ; arriba?
	ld (iy+002h),001h		;9614   ; hacia arriba
	call camino_apunta		;9618   ; apuntado
	call camino_menos_abajo		;961b
	ld (iy+002h),005h		;961e   ; hacia abajo
	call camino_mas_izq		;9622
	ret			;9625
enemigo_izquierda:		; Hacia la izquierda
	pop hl			;9626
	bit 0,(iy+006h)		;9627   ; algo a la izquierda?
	jr nz,enemigo_izquierda_tapado		;962b
	call enemigo_izquierda1		;962d   ; no: un paso a la izquierda
	jp enemigo_camino		;9630
enemigo_izquierda_tapado:
	call camino_apunta		;9633   ; apuntado en el camino
	ld a,(iy+008h)		;9636   ; la direccion buscada: de 3 a 6?
	cp 007h		;9639   ; 7 o mas?
	jr nc,enemigo_izquierda_abajo		;963b
	cp 003h		;963d   ; menos de 3?
	jr c,enemigo_izquierda_abajo		;963f
	call gira_abajo		;9641   ; abajo?
	ld (iy+002h),005h		;9644
	call camino_apunta		;9648
	call camino_menos_arriba		;964b
	ld (iy+002h),001h		;964e
	call camino_mas_der		;9652
	ret			;9655
enemigo_izquierda_abajo:
	call gira_arriba		;9656   ; arriba?
	ld (iy+002h),001h		;9659   ; hacia arriba
	call camino_apunta		;965d   ; apuntado
	call camino_menos_abajo		;9660
	ld (iy+002h),005h		;9663   ; hacia abajo
	call camino_mas_der		;9667
	ret			;966a
enemigo_arriba_izq:
	call gira_izq		;966b   ; a la izquierda?
	ld (iy+002h),007h		;966e   ; hacia la izquierda
	call camino_apunta		;9672   ; apuntado
	call camino_menos_der		;9675
	ld (iy+002h),003h		;9678   ; hacia la derecha
	call camino_mas_abajo		;967c
	ret			;967f
camino_nuevo:		; Un camino nuevo: la direccion buscada; hacia donde va: 1, 3, 5 o 7
	ld a,(iy+006h)		;9680
	res 7,(iy+006h)		;9683   ; el bit 7 de +6, a 0
	bit 7,a		;9687
	ret nz			;9689
	ld (iy+005h),000h		;968a   ; los pasos a 0
	ld a,(0e32eh)		;968e   ; la direccion buscada
	ld (iy+008h),a		;9691
	ld a,(iy+008h)		;9694
	cp 001h		;9697   ; 1: arriba
	jr z,camino_arriba1		;9699
	cp 005h		;969b   ; 2-4: derecha; 5: abajo; 6-8: izquierda
	jr c,camino_derecha3		;969d
	jr z,camino_abajo5		;969f
	ld (iy+002h),007h		;96a1
	ret			;96a5
camino_arriba1:
	ld (iy+002h),001h		;96a6
	ret			;96aa
camino_derecha3:
	ld (iy+002h),003h		;96ab
	ret			;96af
camino_abajo5:
	ld (iy+002h),005h		;96b0
	ret			;96b4
camino_apunta:		; Apunta la direccion (+2) en el camino (hasta 7)
	push af			;96b5
	inc (iy+009h)		;96b6   ; uno mas
	ld a,(iy+009h)		;96b9
	cp 008h		;96bc   ; 8?
	jr nc,camino_lleno		;96be
	push hl			;96c0
	push de			;96c1
	call camino		;96c2   ; su sitio en el camino
	dec e			;96c5
	ld d,000h		;96c6
	add hl,de			;96c8
	ld a,(iy+002h)		;96c9   ; la direccion
	ld (hl),a			;96cc
	pop af			;96cd
	pop de			;96ce
	pop hl			;96cf
	ret			;96d0
camino_lleno:		; Lleno: otra vez desde 1
	pop af			;96d1
	ld (iy+009h),001h		;96d2
	ret			;96d6
enemigo_va_abajo:		; Hacia abajo (5)
	ld (iy+002h),005h		;96d7
	jp enemigo_baja		;96db
enemigo_va_arriba:		; Hacia arriba (1)
	ld (iy+002h),001h		;96de
	jp enemigo_sube		;96e2
enemigo_va_izq:		; Hacia la izquierda (7)
	ld (iy+002h),007h		;96e5
	jp enemigo_izquierda1		;96e9
enemigo_va_der:		; Hacia la derecha (3)
	ld (iy+002h),003h		;96ec
enemigo_va:
	jp enemigo_derecha1		;96f0
enemigo_borra:		; Sus 16 bytes a cero
	push iy		;96f3
	ld b,010h		;96f5
enemigo_borra_byte:
	ld (iy+000h),000h		;96f7
	inc iy		;96fb
	djnz enemigo_borra_byte		;96fd
	pop iy		;96ff
	ret			;9701
tipo_arriba:		; El tipo de lo que hay arriba (las dos casillas de 0xB4BD): un bloque 3-6, 0x30 otra cosa o 0x10 libre
	call casillas_arriba		;9702
	call tipo_busca		;9705

; ----------------------------------------------------------------------
; DATOS tipos_arriba: Las parejas (casilla, tipo) de 0x9702 y los dos tipos de
;   mas: 0x30 algo, 0x10 libre
;   0x9708..0x9712  (10 bytes)
DATA_tipos_arriba:
	defb 0a7h,004h	; 9708
	defb 0afh,005h	; 970a
	defb 0a2h,003h	; 970c
	defb 0aah,006h	; 970e
	defb 030h	; 9710
	defb 010h	; 9711

; ======================================================================
; CODIGO 0x9712..0x9718  (6 bytes)
; ======================================================================


tipo_arriba2:		; Igual, para un enemigo: solo dos clases de bloque
	call casillas_arriba		;9712
	call tipo_busca		;9715

; ----------------------------------------------------------------------
; DATOS tipos_arriba2: Sus parejas
;   0x9718..0x9722  (10 bytes)
DATA_tipos_arriba2:
	defb 0a7h,004h	; 9718
	defb 0afh,030h	; 971a
	defb 0a2h,003h	; 971c
	defb 0aah,030h	; 971e
	defb 030h	; 9720
	defb 010h	; 9721

; ======================================================================
; CODIGO 0x9722..0x9728  (6 bytes)
; ======================================================================


tipo_abajo:		; Lo de abajo (0xB4C3)
	call casillas_abajo		;9722
	call tipo_busca		;9725

; ----------------------------------------------------------------------
; DATOS tipos_abajo: Sus parejas
;   0x9728..0x9732  (10 bytes)
DATA_tipos_abajo:
	defb 0adh,005h	; 9728
	defb 0a5h,004h	; 972a
	defb 0a8h,006h	; 972c
	defb 0a0h,003h	; 972e
	defb 030h	; 9730
	defb 010h	; 9731

; ======================================================================
; CODIGO 0x9732..0x9738  (6 bytes)
; ======================================================================


tipo_abajo2:		; Lo de abajo, para un enemigo
	call casillas_abajo		;9732
	call tipo_busca		;9735

; ----------------------------------------------------------------------
; DATOS tipos_abajo2: Sus parejas
;   0x9738..0x9742  (10 bytes)
DATA_tipos_abajo2:
	defb 0adh,005h	; 9738
	defb 0a5h,030h	; 973a
	defb 0a8h,006h	; 973c
	defb 0a0h,030h	; 973e
	defb 030h	; 9740
	defb 010h	; 9741

; ======================================================================
; CODIGO 0x9742..0x9748  (6 bytes)
; ======================================================================


tipo_izquierda:		; Lo de la izquierda (0xB4D7)
	call casillas_izquierda		;9742
	call tipo_busca		;9745

; ----------------------------------------------------------------------
; DATOS tipos_izquierda: Sus parejas
;   0x9748..0x9752  (10 bytes)
DATA_tipos_izquierda:
	defb 0abh,006h	; 9748
	defb 0afh,005h	; 974a
	defb 0a1h,003h	; 974c
	defb 0a5h,004h	; 974e
	defb 030h	; 9750
	defb 010h	; 9751

; ======================================================================
; CODIGO 0x9752..0x9758  (6 bytes)
; ======================================================================


tipo_izquierda2:		; Lo de la izquierda, para un enemigo
	call casillas_izquierda		;9752
	call tipo_busca		;9755

; ----------------------------------------------------------------------
; DATOS tipos_izquierda2: Sus parejas
;   0x9758..0x9762  (10 bytes)
DATA_tipos_izquierda2:
	defb 0abh,006h	; 9758
	defb 0afh,030h	; 975a
	defb 0a1h,003h	; 975c
	defb 0a5h,030h	; 975e
	defb 030h	; 9760
	defb 010h	; 9761

; ======================================================================
; CODIGO 0x9762..0x9768  (6 bytes)
; ======================================================================


tipo_derecha:		; Lo de la derecha (0xB4CF)
	call casillas_derecha		;9762
	call tipo_busca		;9765

; ----------------------------------------------------------------------
; DATOS tipos_derecha: Sus parejas
;   0x9768..0x9772  (10 bytes)
DATA_tipos_derecha:
	defb 0aeh,005h	; 9768
	defb 0aah,006h	; 976a
	defb 0a4h,004h	; 976c
	defb 0a0h,003h	; 976e
	defb 030h	; 9770
	defb 010h	; 9771

; ======================================================================
; CODIGO 0x9772..0x9778  (6 bytes)
; ======================================================================


tipo_derecha2:		; Lo de la derecha, para un enemigo
	call casillas_derecha		;9772
	call tipo_busca		;9775

; ----------------------------------------------------------------------
; DATOS tipos_derecha2: Sus parejas
;   0x9778..0x9782  (10 bytes)
DATA_tipos_derecha2:
	defb 0aeh,005h	; 9778
	defb 0aah,030h	; 977a
	defb 0a4h,004h	; 977c
	defb 0a0h,030h	; 977e
	defb 030h	; 9780
	defb 010h	; 9781

; ======================================================================
; CODIGO 0x9782..0x9896  (276 bytes)
; ======================================================================


tipo_busca:		; La tabla de detras de la llamada (pop ix): la casilla A en las dos primeras parejas, la B en las otras dos; si no, 0x30, o 0x10 si las dos estan libres; vuelve al de antes
	pop ix		;9782   ; la tabla
	call tipo_pareja		;9784
	inc ix		;9787
	call tipo_pareja		;9789
	ld a,b			;978c   ; la casilla B
	inc ix		;978d
	call tipo_pareja		;978f   ; tercera
	inc ix		;9792
	call tipo_pareja		;9794   ; cuarta
	inc ix		;9797
	cp 010h		;9799   ; las dos libres?
	jr nz,tipo_da		;979b
	ld a,c			;979d
	cp 010h		;979e
	jr nz,tipo_da		;97a0
	inc ix		;97a2   ; si: 0x10
tipo_da:		; A = C = el tipo
	ld c,(ix+000h)		;97a4
	ld a,c			;97a7
	ret			;97a8
tipo_pareja:		; Si A es la casilla de la pareja, su tipo y vuelve al que llamo a 0x9782
	cp (ix+000h)		;97a9
	inc ix		;97ac
	ret nz			;97ae
	pop de			;97af   ; fuera la vuelta a 0x9782
	jr tipo_da		;97b0
bloques_rotos:		; Cada 3 cuadros (0xE017), los tres bloques que se rompen (0xE300, 4 bytes cada uno)
	ld a,(0e017h)		;97b2
	cp 003h		;97b5
	ret c			;97b7
	xor a			;97b8
	ld (0e017h),a		;97b9
	ld ix,0e300h		;97bc   ; el primero
	call bloque_roto		;97c0
	ld ix,0e304h		;97c3   ; el segundo
	call bloque_roto		;97c7
	ld ix,0e308h		;97ca   ; el tercero
bloque_roto:		; Uno: sus cuatro pasos (las casillas 0x54-0x60); al acabar, 16 puntos y, en el descanso, algo al azar en su sitio
	ld a,(ix+000h)		;97ce
	and a			;97d1
	ret z			;97d2
	ld a,(ix+002h)		;97d3   ; su paso
	and a			;97d6
	ret z			;97d7
	call ix_sitio		;97d8
	ld a,(ix+002h)		;97db
	cp 002h		;97de
	jr nz,L_97E2		;97e0
L_97E2:
	inc (ix+002h)		;97e2   ; el siguiente
	dec a			;97e5   ; (paso - 1) x 4
	rlca			;97e6
	rlca			;97e7
	cp 010h		;97e8   ; el ultimo?
	jr z,bloque_roto_fin		;97ea
	add a,054h		;97ec   ; la casilla 0x54 + eso
	ld c,a			;97ee
	jp pieza		;97ef
bloque_roto_fin:		; Acabado: borrado y 16 puntos
	ld (ix+002h),000h		;97f2
	call pieza_borra		;97f6
	ld a,010h		;97f9   ; 16 puntos
	push hl			;97fb
	call puntos		;97fc
	pop hl			;97ff
	ld a,(0e3c0h)		;9800   ; en el descanso (0xE3C0 = 1)...
	cp 001h		;9803
	ret nz			;9805
	ld a,r		;9806   ; ...al azar (el registro R)
	cp 002h		;9808   ; 0-1: 0x68 (1000 puntos)
	jr c,bloque_roto_68		;980a
	cp 063h		;980c   ; 2-0x62: nada
	ret c			;980e
	and 007h		;980f
	cp 006h		;9811   ; 6-7: 0xE0 (300)
	jr nc,bloque_roto_e0		;9813
	cp 004h		;9815   ; 4-5: 0xB0 (500)
	jr nc,bloque_roto_b0		;9817
	ld c,048h		;9819   ; si no, 0x48 (100)
	jp pieza		;981b
bloque_roto_68:
	ld c,068h		;981e
	jp pieza		;9820
bloque_roto_e0:
	ld c,0e0h		;9823
	jp pieza		;9825
bloque_roto_b0:
	ld c,0b0h		;9828
	jp pieza		;982a
boton:		; El boton: un golpe (0xE3CD); en el borde de una casilla, el protagonista golpea delante
	ld hl,0e044h		;982d   ; un boton pulsado?
	ld a,(0e040h)		;9830
	add a,(hl)			;9833
	jr z,golpe		;9834
	xor a			;9836
	ld (0e044h),a		;9837
	ld (0e040h),a		;983a
	inc a			;983d   ; apuntado
	ld (0e3cdh),a		;983e
golpe:		; Justo en una casilla?
	ld hl,0e200h		;9841
	ld a,(0e201h)		;9844
	add a,(hl)			;9847
	and 007h		;9848
	ret nz			;984a
	ld a,(0e3cdh)		;984b   ; un golpe pedido?
	and a			;984e
	ret z			;984f
	xor a			;9850
	ld (0e3cdh),a		;9851
	call prota_vram		;9854   ; su casilla
	ld a,(0e3c3h)		;9857   ; el golpe libre (0xE3C3 = 1)?
	cp 001h		;985a
	ret nz			;985c
	call delante		;985d   ; la casilla de delante
	call 0004ah		;9860   ; RDVRM: libre?
	cp 010h		;9863
	jp nz,golpe_bloque		;9865   ; no: a romper
	ld (0e3c5h),hl		;9868   ; libre: sale el golpe hacia alli (0xE3C3 = 3)
	ld hl,(0e200h)		;986b
	ld (0e3c1h),hl		;986e
	xor a			;9871
	ld (0e3c8h),a		;9872
	ld (0e3c7h),a		;9875
	ld a,(0e203h)		;9878   ; en su direccion
	ld (0e3c4h),a		;987b
	ld a,003h		;987e
	ld (0e3c3h),a		;9880
	ret			;9883
delante:		; HL + lo que hay que sumar para la casilla de delante (0x9896)
	ld a,(0e203h)		;9884   ; la direccion
	push hl			;9887
	ld e,a			;9888
	ld d,000h		;9889
	dec e			;988b   ; - 1
	ld hl,09896h		;988c   ; la tabla
	add hl,de			;988f
	ld e,(hl)			;9890
	inc hl			;9891
	ld d,(hl)			;9892
	pop hl			;9893
	add hl,de			;9894
	ret			;9895

; ----------------------------------------------------------------------
; DATOS delante_pasos: Lo que se suma por direccion: -32, +2, +64, -1
;   0x9896..0x989e  (8 bytes)
DATA_delante_pasos:
	defw 0ffe0h,00002h,00040h,0ffffh	; 9896

; ======================================================================
; CODIGO 0x989e..0x9929  (139 bytes)
; ======================================================================


golpe_bloque:		; Delante hay algo: el golpe (2), el efecto 1, y si es un bloque (0x44-0x47) se rompe en uno de los tres huecos (0xE300)
	ld a,(0e3c3h)		;989e
	cp 001h		;98a1
	ret nz			;98a3
	ld a,001h		;98a4   ; el efecto 1
	call efecto_b_pide		;98a6
	xor a			;98a9
	ld (0e3c8h),a		;98aa
	ld a,002h		;98ad   ; el golpe pegando
	ld (0e3c3h),a		;98af
	ld a,(0e203h)		;98b2   ; su sprite segun la direccion (0x99BD)
	dec a			;98b5
	rlca			;98b6
	rlca			;98b7
	ld e,a			;98b8
	ld d,000h		;98b9
	ld hl,099bdh		;98bb
	add hl,de			;98be
	ld de,00004h		;98bf
	add hl,de			;98c2
	call golpe_sitio		;98c3
	call prota_vram		;98c6
	call delante		;98c9
	call 0004ah		;98cc   ; un bloque (0x44-0x47)?
	cp 044h		;98cf
	ret c			;98d1
	cp 048h		;98d2
	ret nc			;98d4
	cp 044h		;98d5   ; la esquina de arriba a la izquierda
	jr z,golpe_hueco		;98d7
	cp 045h		;98d9
	jr z,golpe_esquina1		;98db
	cp 046h		;98dd
	jr z,golpe_esquina2		;98df
	call arriba1		;98e1
	dec hl			;98e4
	jr golpe_hueco		;98e5
golpe_esquina1:
	dec hl			;98e7
	jr golpe_hueco		;98e8
golpe_esquina2:
	call arriba1		;98ea
golpe_hueco:		; Un hueco de 0xE300 libre
	ld ix,0e300h		;98ed
	ld de,00004h		;98f1
	ld b,003h		;98f4
golpe_hueco_mira:
	ld a,(ix+002h)		;98f6   ; libre?
	and a			;98f9
	jr z,golpe_rompe		;98fa
	add ix,de		;98fc   ; el siguiente
	djnz golpe_hueco_mira		;98fe
	ret			;9900
golpe_rompe:		; El bloque se rompe: el efecto 3 y su sitio
	push hl			;9901
	ld a,003h		;9902   ; el efecto 3
	call efecto_pide		;9904
	pop hl			;9907
	call ix_sitio_pon		;9908
	ld (ix+002h),001h		;990b
	ld (ix+003h),000h		;990f
	ret			;9913
golpe_sprite:		; El sprite del golpe (0xE100), segun su estado (la tabla de 0x9929)
	ld a,009h		;9914   ; color 9
	ld (0e103h),a		;9916
	ld ix,0e3c1h		;9919
	ld hl,(0e3c1h)		;991d
	ld (0e100h),hl		;9920
	ld a,(0e3c3h)		;9923
	call salta_a		;9926

; ----------------------------------------------------------------------
; DATOS tabla_golpe: Los cinco destinos de 0x9F53 por el estado del golpe
;   (0-4)
;   0x9929..0x9933  (10 bytes)
DATA_tabla_golpe:
	defw 09933h,09933h,099ddh,099f1h,0995ah	; 9929

; ======================================================================
; CODIGO 0x9933..0x99b5  (130 bytes)
; ======================================================================


golpe_libre:		; Libre: pegado al protagonista
	ld a,001h		;9933   ; libre
	ld (0e3c3h),a		;9935
	ld a,(0e203h)		;9938   ; la direccion del protagonista
	dec a			;993b
	rlca			;993c   ; x 4
	rlca			;993d
	ld e,a			;993e
	ld d,000h		;993f
	ld hl,099bdh		;9941
	add hl,de			;9944
golpe_sitio:		; El sitio del golpe: el del protagonista + la tabla (HL) y su dibujo
	ld a,(0e200h)		;9945   ; la Y del protagonista...
	add a,(hl)			;9948   ; ...+ la de la tabla
	ld (0e3c1h),a		;9949
	inc hl			;994c
	ld a,(0e201h)		;994d   ; la X...
	add a,(hl)			;9950   ; ...+ la de la tabla
	ld (0e3c2h),a		;9951
	inc hl			;9954
	ld a,(hl)			;9955
	ld (0e102h),a		;9956
	ret			;9959
golpe_va:		; El estado 4: vuelve, 8 pasos; cerca del protagonista, libre
	ld a,(0e3c9h)		;995a
	inc a			;995d   ; un paso mas
	cp 008h		;995e   ; 8?
	jr z,golpe_cerca		;9960
	ld (0e3c9h),a		;9962
	ld a,(0e3c4h)		;9965   ; su direccion
	ld hl,099b5h		;9968
	dec a			;996b
	ld e,a			;996c
	ld d,000h		;996d
	add hl,de			;996f
	ld c,(hl)			;9970
	ld a,(0e3c1h)		;9971
	add a,c			;9974
	ld (0e3c1h),a		;9975
	inc hl			;9978
	ld c,(hl)			;9979
	ld a,(0e3c2h)		;997a
	add a,c			;997d
	ld (0e3c2h),a		;997e
golpe_cerca:		; A menos de 9 puntos en Y...
	ld a,(0e200h)		;9981   ; la Y del protagonista
	ld c,a			;9984
	ld a,(0e3c1h)		;9985   ; menos la del golpe
	sub c			;9988
	jr nc,golpe_cerca_y		;9989
	ld a,(0e3c1h)		;998b   ; al reves
	ld c,a			;998e
	ld a,(0e200h)		;998f
	sub c			;9992
golpe_cerca_y:
	jr z,golpe_cerca_x		;9993
	cp 009h		;9995
	ret nc			;9997
golpe_cerca_x:		; ...y en X: libre
	ld a,(0e201h)		;9998   ; la X del protagonista
	ld c,a			;999b
	ld a,(0e3c2h)		;999c   ; menos la del golpe
	sub c			;999f
	jr nc,golpe_cerca_x2		;99a0
	ld a,(0e3c2h)		;99a2   ; al reves
	ld c,a			;99a5
	ld a,(0e201h)		;99a6
	sub c			;99a9
golpe_cerca_x2:
	jr z,golpe_vuelto		;99aa
	cp 009h		;99ac
	ret nc			;99ae
golpe_vuelto:
	ld a,001h		;99af
	ld (0e3c3h),a		;99b1
	ret			;99b4

; ----------------------------------------------------------------------
; DATOS golpe_tabla: Lo que se mueve el golpe por direccion (2 bytes x 4) y su
;   sitio y su dibujo por direccion (4 bytes x 8)
;   0x99b5..0x99dd  (40 bytes)
DATA_golpe_tabla:
	defb 001h,000h,000h,0ffh,0ffh,000h,000h,001h	; 99b5  ........
	defb 001h,0feh,0b4h,004h	; 99bd
	defb 0fah,0feh,0ach,004h	; 99c1
	defb 0fch,0fdh,0ach,004h	; 99c5
	defb 0fch,002h,0a8h,004h	; 99c9
	defb 0feh,0fch,0ach,004h	; 99cd
	defb 005h,000h,0b4h,004h	; 99d1
	defb 0fch,002h,0a8h,004h	; 99d5
	defb 0fch,0feh,0ach,004h	; 99d9

; ======================================================================
; CODIGO 0x99dd..0x9a10  (51 bytes)
; ======================================================================


golpe_pega:		; El estado 2: 4 cuadros y libre
	ld a,(0e3c8h)		;99dd
	inc a			;99e0   ; un cuadro mas
	ld (0e3c8h),a		;99e1
	cp 004h		;99e4   ; 4?
	ret c			;99e6
	ld a,001h		;99e7   ; libre
	ld (0e3c3h),a		;99e9
	xor a			;99ec
	ld (0e01bh),a		;99ed
	ret			;99f0
golpe_sale:		; El estado 3: los dibujos (0xB8 + 4 x paso)
	ld a,(0e3c8h)		;99f1
	inc a			;99f4   ; un paso mas
	ld (0e3c8h),a		;99f5
	and 003h		;99f8   ; cuatro dibujos
	rlca			;99fa   ; x 4
	rlca			;99fb
	add a,0b8h		;99fc   ; + 0xB8: el dibujo
	ld (0e102h),a		;99fe
	ld ix,0e3c1h		;9a01
	ld a,001h		;9a05
	call efecto_b_pide		;9a07
	ld a,(0e3c4h)		;9a0a
	call salta_dir		;9a0d

; ----------------------------------------------------------------------
; DATOS tabla_golpe_dir: Los cuatro destinos de 0x9F59 por la direccion del
;   golpe (0xE3C4): arriba (0x9A18), derecha (0x9A30), abajo (0x9A45) e
;   izquierda (0x9A5D)
;   0x9a10..0x9a18  (8 bytes)
DATA_tabla_golpe_dir:
	defw 09a18h,09a30h,09a45h,09a5dh	; 9a10  -> golpe_arriba golpe_derecha golpe_abajo golpe_izquierda

; ======================================================================
; CODIGO 0x9a18..0x9bed  (469 bytes)
; ======================================================================


golpe_arriba:		; El golpe hacia arriba (la tabla de 0x9A10): dos puntos y las dos casillas de delante
	ld a,(0e3c1h)		;9a18   ; dos puntos arriba
	dec a			;9a1b
	dec a			;9a1c
	ld (0e3c1h),a		;9a1d
	ld hl,(0e3c5h)		;9a20
	call arriba1		;9a23
	push hl			;9a26
	call abajo1		;9a27
	push hl			;9a2a
	ld hl,0a4a1h		;9a2b   ; las casillas que no lo paran (0xA1, 0xA4)
	jr golpe_mira		;9a2e
golpe_derecha:		; Hacia la derecha
	ld a,(0e3c2h)		;9a30
	inc a			;9a33   ; dos puntos a la derecha
	inc a			;9a34
	ld (0e3c2h),a		;9a35
	ld hl,(0e3c5h)		;9a38   ; su casilla
	inc hl			;9a3b
	push hl			;9a3c
	dec hl			;9a3d
	dec hl			;9a3e
	push hl			;9a3f
	ld hl,0ada7h		;9a40   ; las que no lo paran (0xA7, 0xAD)
	jr golpe_mira		;9a43
golpe_abajo:		; Hacia abajo
	ld a,(0e3c1h)		;9a45
	inc a			;9a48   ; dos puntos abajo
	inc a			;9a49
	ld (0e3c1h),a		;9a4a
	ld hl,(0e3c5h)		;9a4d   ; su casilla
	call abajo1		;9a50
	push hl			;9a53
	call arriba2		;9a54
	push hl			;9a57
	ld hl,0aeabh		;9a58   ; las que no lo paran (0xAB, 0xAE)
	jr golpe_mira		;9a5b
golpe_izquierda:		; Hacia la izquierda
	ld a,(0e3c2h)		;9a5d
	dec a			;9a60
	dec a			;9a61
	ld (0e3c2h),a		;9a62
	ld hl,(0e3c5h)		;9a65
	dec hl			;9a68
	push hl			;9a69
	inc hl			;9a6a
	push hl			;9a6b
	ld hl,0a8a2h		;9a6c   ; las que no lo paran (0xA2, 0xA8)
golpe_mira:		; Lo que hay delante: libre, sigue (cada 4 pasos, una casilla mas); si no, lo que es
	ld (0e3d1h),hl		;9a6f
	pop hl			;9a72
	call 0004ah		;9a73   ; RDVRM
	pop de			;9a76
	cp 010h		;9a77   ; libre?
	jr nz,golpe_choca		;9a79
	inc (ix+006h)		;9a7b   ; un paso mas
	ld a,(ix+006h)		;9a7e
	cp 004h		;9a81
	ret c			;9a83
	ld (ix+006h),000h		;9a84   ; a la casilla siguiente
	ld (0e3c5h),de		;9a88
	ret			;9a8c
golpe_choca:		; Choca con algo: si es de las que no lo paran o 0xAF o mas, vuelve con 0xE3C9 = 0xF8
	push af			;9a8d
	ld c,a			;9a8e
	xor a			;9a8f
	ld (0e3c9h),a		;9a90
	ld a,(0e3d1h)		;9a93
	cp c			;9a96
	call z,golpe_ida		;9a97
	ld a,(0e3d2h)		;9a9a
	cp c			;9a9d
	call z,golpe_ida		;9a9e
	ld a,c			;9aa1
	cp 0afh		;9aa2
	call nc,golpe_ida		;9aa4
	pop af			;9aa7
	cp 048h		;9aa8   ; menos de 0x48: vuelve
	jr c,golpe_vuelve		;9aaa
	cp 054h		;9aac   ; 0x48-0x53 (los huevos y las piezas): lo come
	jr c,golpe_come		;9aae
	cp 0b0h		;9ab0   ; hasta 0xAF: vuelve
	jr c,golpe_vuelve		;9ab2
	cp 0d0h		;9ab4   ; 0xB0-0xCF: lo come
	jr c,golpe_come		;9ab6
	cp 0d8h		;9ab8   ; 0xD0-0xD7: vuelve
	jr c,golpe_vuelve		;9aba
	cp 0f8h		;9abc   ; 0xD8-0xF7: lo come
	jr c,golpe_come		;9abe
	jr golpe_vuelve		;9ac0
golpe_vuelve:		; El golpe vuelve (el estado 4)
	ld a,004h		;9ac2
	ld (0e3c3h),a		;9ac4
	ret			;9ac7
golpe_come:		; En una fase normal, la casilla pasa a 0x0F y vuelve
	ld a,(0e3c0h)		;9ac8   ; en el descanso o el final, no
	and a			;9acb
	jr nz,golpe_vuelve		;9acc
	ld a,00fh		;9ace   ; la casilla 0x0F
	call 0004dh		;9ad0
	jr golpe_vuelve		;9ad3
golpe_ida:		; 0xE3C9 = 0xF8
	ld a,0f8h		;9ad5
	ld (0e3c9h),a		;9ad7
	ret			;9ada
laberinto:		; El laberinto de la fase (0xE007): lo que hay por hacer, los sitios de los enemigos y las paredes del mapa de bits de 0xA960
	ld b,000h		;9adb   ; la fase jugada...
	ld a,(0e007h)		;9add
	cp 032h		;9ae0   ; ...la 50?
	jr z,laberinto_50		;9ae2
	cp 033h		;9ae4   ; ...la 51?
	jr z,laberinto_51		;9ae6
	ld c,005h		;9ae8   ; si no, por hacer: (fase / 5) + 1
laberinto_cinco:
	inc b			;9aea
	sub c			;9aeb
	jr nc,laberinto_cinco		;9aec
	ld a,b			;9aee
	jr laberinto_hacer		;9aef
laberinto_50:		; La 50: 4
	ld a,004h		;9af1
	jr laberinto_hacer		;9af3
laberinto_51:		; La 51: 1
	ld a,001h		;9af5
laberinto_hacer:
	ld (0e3cah),a		;9af7
	ld a,(0e007h)		;9afa   ; las unidades de la fase
	and 00fh		;9afd
	ld e,a			;9aff
	ld d,000h		;9b00
	ld a,049h		;9b02   ; 0xE30D = 0x49
	ld (0e30dh),a		;9b04
	ld hl,0e330h		;9b07   ; los dieciseis bloques de 0xE20A (16 bytes): sus caminos en 0xE330, de 8 en 8
	ld ix,0e20ah		;9b0a
	ld b,010h		;9b0e
laberinto_caminos:
	call ix_sitio_pon		;9b10   ; su sitio
	ld de,00010h		;9b13   ; el bloque siguiente (16 bytes)
	add ix,de		;9b16
	ld de,00008h		;9b18   ; el camino siguiente (8 bytes)
	add hl,de			;9b1b
	djnz laberinto_caminos		;9b1c
	xor a			;9b1e
	ld (0e20ah),a		;9b1f
	ld (0e20bh),a		;9b22
	ld iy,00000h		;9b25
	ld a,(0e007h)		;9b29   ; la fase x 2...
	ld l,a			;9b2c
	ld h,000h		;9b2d
	sla l		;9b2f
	jr nc,L_9B34		;9b31
	inc h			;9b33
L_9B34:
	ld de,0a960h		;9b34   ; ...en la tabla de 0xA960: su mapa
	add hl,de			;9b37
	ld e,(hl)			;9b38
	inc hl			;9b39
	ld d,(hl)			;9b3a
	ld c,040h		;9b3b   ; la casilla 0x40 (la pared)
	ld hl,01861h		;9b3d   ; desde la fila 3, columna 1
laberinto_byte:		; Un byte del mapa: 0xFF salta, el bit 7 dice si se corre una casilla, los otros siete son siete paredes
	xor a			;9b40
	ld (0e32dh),a		;9b41
	ld a,(de)			;9b44   ; 0xFF?
	cp 0ffh		;9b45
	call z,laberinto_ff		;9b47
	ld b,007h		;9b4a   ; siete bits
	rlca			;9b4c   ; el bit 7
	call c,laberinto_corre		;9b4d
laberinto_bit:		; Un bit: una pared de 2 x 2
	rlca			;9b50
	call c,laberinto_pared		;9b51
	inc hl			;9b54
	inc hl			;9b55
	djnz laberinto_bit		;9b56
	bit 4,l		;9b58   ; al final de la fila...
	jr z,laberinto_sig		;9b5a
	inc hl			;9b5c
	inc hl			;9b5d
	call abajo1		;9b5e   ; ...la fila siguiente
laberinto_sig:		; El byte siguiente: 0xFF otra fila, 0xF0-0xFE se acaba el mapa
	inc hl			;9b61
	inc de			;9b62   ; el byte siguiente
	ld a,(de)			;9b63
	cp 0ffh		;9b64   ; otra fila?
	jr z,laberinto_byte		;9b66
	and 0f0h		;9b68   ; 0xF0-0xFE?
	cp 0f0h		;9b6a
	jr z,laberinto_mas		;9b6c
	ld a,(de)			;9b6e
	jr laberinto_byte		;9b6f
laberinto_corre:		; El bit 7: corrida una casilla
	push af			;9b71
	ld a,001h		;9b72
	ld (0e32dh),a		;9b74
	pop af			;9b77
	ret			;9b78
laberinto_pared:		; Una pared (0x9C09), corrida o no
	push af			;9b79
	ld a,(0e32dh)		;9b7a   ; corrida?
	and a			;9b7d
	jr nz,laberinto_pared_corrida		;9b7e
	call pieza		;9b80   ; la pieza
	pop af			;9b83
	ret			;9b84
laberinto_pared_corrida:
	inc hl			;9b85
	call pieza		;9b86
	dec hl			;9b89
	pop af			;9b8a
	ret			;9b8b
laberinto_mas:		; 0xF0: casillas sueltas en la fila 3, columna 15: cuantas se salta y cual
	ld a,(de)			;9b8c
	cp 0f0h		;9b8d
	jr nz,laberinto_cosas		;9b8f
	ld hl,0186fh		;9b91   ; desde la fila 3, columna 15
	inc de			;9b94
laberinto_mas_una:
	ld a,(de)			;9b95
	and a			;9b96
	jr z,laberinto_mas_pon		;9b97
	ld b,a			;9b99
laberinto_mas_salta:
	call abajo1		;9b9a
	djnz laberinto_mas_salta		;9b9d
laberinto_mas_pon:
	call pieza		;9b9f   ; la pieza
	inc de			;9ba2   ; el byte siguiente
	ld a,(de)			;9ba3
	and 0f0h		;9ba4
	cp 0f0h		;9ba6   ; se acaba?
	jr z,laberinto_cosas		;9ba8
	ld hl,0186fh		;9baa
	jr laberinto_mas_una		;9bad
laberinto_cosas:		; Las cosas del laberinto (0xF1 en adelante): por clase de 0x9BF1, su casilla y su sitio; los huevos (0x48) van a los enemigos (0xE210)
	ld a,0f1h		;9baf
	ld (0e32dh),a		;9bb1
	ld ix,09bf1h		;9bb4   ; la tabla de clases
laberinto_cosa:
	ld a,(ix+000h)		;9bb8
	cp 048h		;9bbb   ; un huevo?
	jr z,laberinto_huevo		;9bbd
	ld iy,00000h		;9bbf
	jr laberinto_clase		;9bc3
laberinto_huevo:
	ld iy,0e210h		;9bc5
laberinto_clase:		; La clase siguiente
	ld a,(0e32dh)		;9bc9
	ld c,a			;9bcc
	inc a			;9bcd
	ld (0e32dh),a		;9bce
	ld a,(de)			;9bd1   ; el final?
	cp 0ffh		;9bd2
	ret z			;9bd4
	cp c			;9bd5   ; de esta clase?
	jr nz,laberinto_clase_salta		;9bd6
	ld c,(ix+000h)		;9bd8   ; su casilla...
	inc ix		;9bdb
	ld h,018h		;9bdd   ; ...y su sitio (fila 0)
	ld l,(ix+000h)		;9bdf
	call cosas_pon		;9be2
laberinto_clase_sig:
	inc ix		;9be5
	jr laberinto_cosa		;9be7
laberinto_clase_salta:
	inc ix		;9be9
	jr laberinto_clase_sig		;9beb

; ----------------------------------------------------------------------
; DATOS clases: Las casillas de las esquinas que se dibujan de otra forma (4
;   bytes, 0x9BED) y las clases de cosas del laberinto: la casilla y su sitio
;   (12 parejas)
;   0x9bed..0x9c09  (28 bytes)
DATA_clases:
	defb 0ach,0a9h,0a3h,0a6h	; 9bed
	defb 044h,061h	; 9bf1
	defb 044h,081h	; 9bf3
	defb 044h,062h	; 9bf5
	defb 044h,082h	; 9bf7
	defb 048h,061h	; 9bf9
	defb 040h,061h	; 9bfb
	defb 040h,062h	; 9bfd
	defb 040h,082h	; 9bff
	defb 0a8h,061h	; 9c01
	defb 0ach,061h	; 9c03
	defb 0a4h,061h	; 9c05
	defb 0a0h,061h	; 9c07

; ======================================================================
; CODIGO 0x9c09..0x9d30  (295 bytes)
; ======================================================================


pieza:		; Una pieza de 2 x 2 casillas en HL: C, C + 1, C + 2 y C + 3 (o la misma C si 0xE3F7); las esquinas de 0x9BED con el espacio
	xor a			;9c09
	ld (0e3f7h),a		;9c0a   ; las cuatro distintas
pieza_va:
	push hl			;9c0d
	push de			;9c0e
	push af			;9c0f
	push ix		;9c10
	push bc			;9c12
	ld ix,09bedh		;9c13   ; las esquinas especiales
	ld a,c			;9c17
	cp (ix+000h)		;9c18   ; la de arriba a la izquierda?
	call z,pieza_espacio		;9c1b
	call 0004dh		;9c1e   ; WRTVRM
	inc hl			;9c21
	call pieza_mas		;9c22   ; la siguiente casilla
	ld a,c			;9c25
	cp (ix+001h)		;9c26   ; la de arriba a la derecha?
	call z,pieza_espacio		;9c29
	call 0004dh		;9c2c   ; WRTVRM
	call abajo1		;9c2f   ; la fila de abajo
	call pieza_mas		;9c32
	call pieza_mas		;9c35
	ld a,c			;9c38
	cp (ix+002h)		;9c39   ; abajo a la derecha?
	call z,pieza_espacio		;9c3c
	call 0004dh		;9c3f   ; WRTVRM
	dec hl			;9c42
	call pieza_menos		;9c43
	ld a,c			;9c46
	cp (ix+003h)		;9c47   ; abajo a la izquierda?
	call z,pieza_espacio		;9c4a
	call 0004dh		;9c4d   ; WRTVRM
	pop bc			;9c50
	pop ix		;9c51
	pop af			;9c53
	pop de			;9c54
	pop hl			;9c55
	ret			;9c56
pieza_mas:		; C + 1, si no es la misma
	ld a,(0e3f7h)		;9c57
	and a			;9c5a
	ret nz			;9c5b
	inc c			;9c5c
	ret			;9c5d
pieza_menos:		; C - 1, si no es la misma
	ld a,(0e3f7h)		;9c5e
	and a			;9c61
	ret nz			;9c62
	dec c			;9c63
	ret			;9c64
pieza_espacio:		; A = el espacio
	ld a,010h		;9c65
	ret			;9c67
cosas_pon:		; Las cosas de una clase: cada byte, cuantas columnas (de 2) y filas se salta, hasta 0xF0; los huevos (IY) apuntan su sitio, su dibujo y su espera
	push hl			;9c68
cosas_una:
	pop hl			;9c69
	push hl			;9c6a
	inc de			;9c6b
	ld a,(de)			;9c6c
	and 0f0h		;9c6d
	cp 0f0h		;9c6f   ; el final de la clase?
	jr z,cosas_fin		;9c71
	rrca			;9c73   ; la mitad alta: columnas
	rrca			;9c74
	rrca			;9c75
	rrca			;9c76
	ld b,a			;9c77
	and a			;9c78
	jr z,cosas_filas		;9c79
cosas_columnas:
	inc hl			;9c7b
	inc hl			;9c7c
	djnz cosas_columnas		;9c7d
cosas_filas:		; La mitad baja: filas
	ld a,(de)			;9c7f
	and 00fh		;9c80
	ld b,a			;9c82
	and a			;9c83
	jr z,cosas_pieza		;9c84
cosas_fila:
	call abajo2		;9c86
	djnz cosas_fila		;9c89
cosas_pieza:		; La pieza
	call pieza		;9c8b
	push hl			;9c8e   ; un huevo (IY no es 0)?
	push iy		;9c8f
	pop hl			;9c91
	ld a,h			;9c92
	pop hl			;9c93
	and a			;9c94
	jr z,cosas_una		;9c95
	call iy_sitio_pon		;9c97   ; su sitio
	ld a,(0e30dh)		;9c9a   ; uno si y otro no (los bits de 0xE30D)...
	rrca			;9c9d
	ld (0e30dh),a		;9c9e
	jr nc,cosas_huevo_b		;9ca1
	ld (iy+003h),0b0h		;9ca3   ; ...el dibujo 0xB0 y una espera de 32-63...
	ld a,r		;9ca7
	and 01fh		;9ca9
	add a,020h		;9cab
	ld (iy+00eh),a		;9cad
	jr cosas_huevo_sig		;9cb0
cosas_huevo_b:		; ...o el 0xD8 y una espera de 48-79
	ld (iy+003h),0d8h		;9cb2
	ld a,r		;9cb6
	and 01fh		;9cb8
	add a,030h		;9cba
	ld (iy+00eh),a		;9cbc
cosas_huevo_sig:		; El enemigo siguiente (16 bytes)
	push de			;9cbf
	ld de,00010h		;9cc0
	add iy,de		;9cc3
	pop de			;9cc5
	jr cosas_una		;9cc6
cosas_fin:
	pop hl			;9cc8
	ret			;9cc9
laberinto_ff:		; 0xFF: una fila mas abajo y el byte siguiente
	call arriba1		;9cca
	inc de			;9ccd
	ld a,(de)			;9cce
	ret			;9ccf
marco:		; El marco del laberinto: la fila de abajo (0x42/0x43), la de arriba (0x40/0x41), los lados, y las vidas que quedan arriba a la izquierda
	ld hl,01ae0h		;9cd0   ; la fila 23: 0x42 y 0x43
	ld b,020h		;9cd3
	ld a,042h		;9cd5
	call marco_fila		;9cd7
	ld hl,01840h		;9cda   ; la fila 2: 0x40 y 0x41
	ld a,040h		;9cdd
	ld b,020h		;9cdf
	call marco_fila		;9ce1
	ld hl,01840h		;9ce4   ; la columna 0: 0x40 y 0x42
	ld a,040h		;9ce7
	ld b,018h		;9ce9
	call marco_columna		;9ceb
	ld hl,0187fh		;9cee   ; la columna 31: 0x43 y 0x41
	ld a,043h		;9cf1
	ld b,018h		;9cf3
	call marco_columna		;9cf5
	ld a,(0e00bh)		;9cf8   ; las vidas
	and a			;9cfb
	ret z			;9cfc
	ld b,a			;9cfd
	ld c,064h		;9cfe   ; la pieza 0x64...
	ld hl,01808h		;9d00   ; ...desde la fila 0, columna 8, hacia la izquierda
marco_vida:
	call pieza		;9d03
	dec hl			;9d06
	dec hl			;9d07
	djnz marco_vida		;9d08
	ret			;9d0a
marco_fila:		; B casillas seguidas, una A y otra A + 1
	call 0004dh		;9d0b   ; WRTVRM
	inc hl			;9d0e
	bit 0,a		;9d0f   ; una y otra
	jr nz,marco_fila_par		;9d11
	set 0,a		;9d13
	jr marco_fila_sig		;9d15
marco_fila_par:
	res 0,a		;9d17
marco_fila_sig:
	djnz marco_fila		;9d19
	ret			;9d1b
marco_columna:		; B casillas hacia abajo, una A y otra A + 2
	ld de,00020h		;9d1c   ; de fila en fila
	call 0004dh		;9d1f   ; WRTVRM
	add hl,de			;9d22
	bit 1,a		;9d23   ; una y otra
	jr nz,marco_columna_par		;9d25
	set 1,a		;9d27
	jr marco_columna_sig		;9d29
marco_columna_par:
	res 1,a		;9d2b
marco_columna_sig:
	djnz marco_columna		;9d2d
	ret			;9d2f

; ----------------------------------------------------------------------
; DATOS casio_grande: CASIO en letras grandes: dos filas de 12 casillas
;   propias
;   0x9d30..0x9d48  (24 bytes)
DATA_casio_grande:
	defb 0c1h,0c2h,010h,0c3h,0c4h,010h,0c5h,0c6h,0c7h,0c8h,0c1h,0c9h	; 9d30  ............
	defb 0cah,0cbh,010h,0cch,0cdh,010h,0ceh,0cfh,0c7h,0c8h,0cah,0d0h	; 9d3c  ............

; ----------------------------------------------------------------------
; DATOS texto_push: PUSH TRIGGER OR SPACE
;   0x9d48..0x9d5d  (21 bytes)
DATA_texto_push:
	defb 020h,025h,023h,018h,010h,024h,022h,019h,017h,017h,015h,022h,010h,01fh,022h,010h	; 9d48   %#..$"...."..".
	defb 023h,020h,011h,013h,015h	; 9d58

; ----------------------------------------------------------------------
; DATOS texto_copyright: COPYRIGHT 1985 (c) CASIO; la (c) es la casilla 0xC0
;   0x9d5d..0x9d73  (22 bytes)
DATA_texto_copyright:
	defb 013h,01fh,020h,029h,022h,019h,017h,018h,024h,010h,001h,009h,008h,005h,010h,0c0h	; 9d5d  .. )"...$.......
	defb 010h,013h,011h,023h,019h,01fh	; 9d6d

; ----------------------------------------------------------------------
; DATOS texto_time: TIME :
;   0x9d73..0x9d79  (6 bytes)
DATA_texto_time:
	defb 024h,019h,01dh,015h,010h,00ah	; 9d73

; ----------------------------------------------------------------------
; DATOS texto_over: OVER, en el sitio de las cifras de TIME
;   0x9d79..0x9d7d  (4 bytes)
DATA_texto_over:
	defb 01fh,026h,015h,022h	; 9d79

; ----------------------------------------------------------------------
; DATOS texto_score: SCORE:000000
;   0x9d7d..0x9d89  (12 bytes)
DATA_texto_score:
	defb 023h,013h,01fh,022h,015h,00ah,000h,000h,000h,000h,000h,000h	; 9d7d  #.."........

; ----------------------------------------------------------------------
; DATOS texto_stage: STAGE: y seis bytes mas: tres espacios y las cifras 0 0 1
;   0x9d89..0x9d95  (12 bytes)
DATA_texto_stage:
	defb 023h,024h,011h,017h,015h,00ah	; 9d89
	defb 010h,010h,010h,000h,000h,001h	; 9d8f

; ======================================================================
; CODIGO 0x9d95..0x9e80  (235 bytes)
; ======================================================================


interrupcion:		; La interrupcion (H.TIMI): las dieciseis cuentas de cuadros (0xE010-0xE01F), los botones y la palanca; en la demostracion, los mandos grabados
	ld hl,0e010h		;9d95   ; las cuentas...
	ld b,010h		;9d98
interrupcion_cuenta:		; ...una mas cada una
	inc (hl)			;9d9a
	inc hl			;9d9b
	djnz interrupcion_cuenta		;9d9c
	ld a,(0e048h)		;9d9e   ; la demostracion?
	cp 087h		;9da1
	jr z,demo_mandos		;9da3
	ld de,0e040h		;9da5   ; el boton 1 (0xE040)
	ld hl,0e041h		;9da8
	call boton_mando		;9dab
	ld de,0e044h		;9dae   ; la barra (0xE044)
	ld hl,0e045h		;9db1
	call boton_barra		;9db4
	ld a,(0e3c0h)		;9db7   ; en el final, sin palanca
	cp 002h		;9dba
	ret nc			;9dbc
	xor a			;9dbd   ; la palanca: los cursores (GTSTCK 0)...
	call 000d5h		;9dbe
	ld (0e1f0h),a		;9dc1
	ld a,001h		;9dc4   ; ...y el mando 1 (GTSTCK 1)
	call 000d5h		;9dc6
	ld c,a			;9dc9
	ld a,(0e1f0h)		;9dca   ; juntos en 0xE1FC
	add a,c			;9dcd
	ld (0e1fch),a		;9dce
	ret			;9dd1
boton_mando:		; GTTRIG 1: lo recien pulsado en (DE) y lo sostenido en (HL)
	ld a,001h		;9dd2
	call 000d8h		;9dd4   ; GTTRIG
	and a			;9dd7
	jr nz,boton_nuevo		;9dd8
boton_suelto:
	ld (hl),000h		;9dda
	ret			;9ddc
boton_nuevo:		; Recien pulsado: (HL) y (DE) a 1
	ld a,(hl)			;9ddd   ; ya estaba pulsado?
	and a			;9dde
	ret nz			;9ddf
	inc a			;9de0
	ld (hl),a			;9de1
	ld (de),a			;9de2
	ret			;9de3
boton_barra:		; La barra (fila 8, bit 0)
	ld a,008h		;9de4
	call 00141h		;9de6   ; SNSMAT
	rrca			;9de9   ; la barra
	jr nc,boton_nuevo		;9dea
	jr boton_suelto		;9dec
demo_mandos:		; En la demostracion: los botones de verdad dan el de empezar (0xE046); la palanca sale de los mandos grabados (0xE049)
	ld de,0e046h		;9dee   ; la barra...
	ld hl,0e045h		;9df1
	call boton_barra		;9df4
	ld a,(de)			;9df7
	ld (0e1f1h),a		;9df8
	ld hl,0e041h		;9dfb   ; ...o el boton 1
	call boton_mando		;9dfe
	ld a,(de)			;9e01
	ld b,a			;9e02
	ld a,(0e1f1h)		;9e03
	or b			;9e06
	ld (de),a			;9e07
	ld a,(0e3c3h)		;9e08   ; el golpe en marcha?
	cp 002h		;9e0b
	ret nc			;9e0d
	ld hl,0e200h		;9e0e   ; el protagonista justo en una casilla...
	ld a,(hl)			;9e11
	inc hl			;9e12
	add a,(hl)			;9e13
	and 007h		;9e14
	ld c,a			;9e16
	ld a,(0e302h)		;9e17   ; ...y sin nada en marcha?
	add a,c			;9e1a
	ld c,a			;9e1b
	ld a,(0e20bh)		;9e1c
	add a,c			;9e1f
	and 007h		;9e20
	ret nz			;9e22
	ld a,(0e3f6h)		;9e23   ; la cuenta de este mando acabada?
	and 0f0h		;9e26
	jr nz,demo_mando		;9e28
	ld hl,(0e049h)		;9e2a   ; el siguiente: la mitad alta, cuantas casillas; la baja, la direccion
	inc hl			;9e2d
	ld a,(hl)			;9e2e
	ld (0e3f6h),a		;9e2f
	ld (0e049h),hl		;9e32
demo_mando:
	ld hl,0e3f6h		;9e35
	bit 3,(hl)		;9e38   ; el bit 3: el boton
	call nz,demo_boton		;9e3a
	ld a,(hl)			;9e3d   ; la direccion
	and 00fh		;9e3e
	ld (0e1fch),a		;9e40
	ld a,0f0h		;9e43   ; una casilla menos
	add a,(hl)			;9e45
	ld (hl),a			;9e46
	ret			;9e47
demo_boton:		; El boton de la demostracion
	res 3,(hl)		;9e48
	ld a,001h		;9e4a
	ld (0e3cdh),a		;9e4c
	ret			;9e4f
fase_numero:		; La fase en BCD (0xE009-0xE00A) a 0xE007: la fase - 1 en binario
	ld a,(0e009h)		;9e50   ; las decenas...
	and 00fh		;9e53
	rlca			;9e55
	rlca			;9e56
	rlca			;9e57
	rlca			;9e58
	ld b,a			;9e59
	ld a,(0e00ah)		;9e5a   ; ...y las unidades: la fase en BCD
	and 00fh		;9e5d
	add a,b			;9e5f
	ld b,016h		;9e60   ; de 16 en 16
	ld c,000h		;9e62
fase_numero_16:
	cp b			;9e64
	jr c,fase_numero_resto		;9e65
	sub b			;9e67
	daa			;9e68   ; en BCD
	inc c			;9e69
	jr fase_numero_16		;9e6a
fase_numero_resto:
	cp 010h		;9e6c
	jr c,fase_numero_pon		;9e6e
	sub 006h		;9e70
fase_numero_pon:
	rlc c		;9e72
	rlc c		;9e74
	rlc c		;9e76
	rlc c		;9e78
	add a,c			;9e7a
	dec a			;9e7b   ; - 1
	ld (0e007h),a		;9e7c
	ret			;9e7f

; ----------------------------------------------------------------------
; DATOS texto_keyword: KEYWORD [     ] (15 casillas)
;   0x9e80..0x9e8f  (15 bytes)
DATA_texto_keyword:
	defb 01bh,015h,029h,027h,01fh,022h,014h,010h,038h,010h,010h,010h,010h,010h,039h	; 9e80  ..)'."..8.....9

; ----------------------------------------------------------------------
; DATOS contrasenas: Las diez contrasenas: cinco letras y la fase en BCD
;   (CASIO 01, VANIL 06, DENWA 11, JUNMK 16, PAZZL 21, KIYOK 26, FIREF 31,
;   MORIY 36, YATTA 41, LASTE 46)
;   0x9e8f..0x9ecb  (60 bytes)
DATA_contrasenas:
	defb 013h,011h,023h,019h,01fh	; 9e8f
	defb 001h	; 9e94
	defb 026h	; 9e95
	defb 011h	; 9e96
	defb 01eh	; 9e97
	defb 019h	; 9e98
	defb 01ch	; 9e99
	defb 006h	; 9e9a
	defb 014h	; 9e9b
	defb 015h	; 9e9c
	defb 01eh	; 9e9d
	defb 027h	; 9e9e
	defb 011h	; 9e9f
	defb 011h	; 9ea0
	defb 01ah	; 9ea1
	defb 025h	; 9ea2
	defb 01eh	; 9ea3
	defb 01dh	; 9ea4
	defb 01bh	; 9ea5
	defb 016h	; 9ea6
	defb 020h	; 9ea7
	defb 011h	; 9ea8
	defb 02ah	; 9ea9
	defb 02ah	; 9eaa
	defb 01ch	; 9eab
	defb 021h	; 9eac
	defb 01bh	; 9ead
	defb 019h	; 9eae
	defb 029h	; 9eaf
	defb 01fh	; 9eb0
	defb 01bh	; 9eb1
	defb 026h	; 9eb2
	defb 016h	; 9eb3
	defb 019h	; 9eb4
	defb 022h	; 9eb5
	defb 015h	; 9eb6
	defb 016h	; 9eb7
	defb 031h	; 9eb8
	defb 01dh	; 9eb9
	defb 01fh	; 9eba
	defb 022h	; 9ebb
	defb 019h	; 9ebc
	defb 029h	; 9ebd
	defb 036h	; 9ebe
	defb 029h	; 9ebf
	defb 011h	; 9ec0
	defb 024h	; 9ec1
	defb 024h	; 9ec2
	defb 011h	; 9ec3
	defb 041h	; 9ec4
	defb 01ch	; 9ec5
	defb 011h	; 9ec6
	defb 023h	; 9ec7
	defb 024h	; 9ec8
	defb 015h	; 9ec9
	defb 046h	; 9eca

; ======================================================================
; CODIGO 0x9ecb..0x9fc1  (246 bytes)
; ======================================================================


camino_menos_abajo:		; Los giros del enemigo: el camino un paso menos (+9) o mas; si el lado esta libre, va hacia alli y no vuelve
	dec (iy+009h)		;9ecb
	jr gira_abajo		;9ece
camino_mas_abajo:
	inc (iy+009h)		;9ed0
gira_abajo:		; Abajo libre (bit 1 de +6)?
	bit 1,(iy+006h)		;9ed3
	jr z,gira_abajo_va		;9ed7   ; tapado: sigue
	ret			;9ed9
gira_abajo_va:		; Libre: hacia abajo, sin volver al que llamo
	pop de			;9eda
	jp enemigo_va_abajo		;9edb
camino_menos_arriba:
	dec (iy+009h)		;9ede
	jr gira_arriba		;9ee1
camino_mas_arriba:
	inc (iy+009h)		;9ee3
gira_arriba:		; Arriba libre (bit 3)?
	bit 3,(iy+006h)		;9ee6
	jr z,gira_arriba_va		;9eea
	ret			;9eec
gira_arriba_va:
	pop de			;9eed
	jp enemigo_va_arriba		;9eee
camino_menos_der:
	dec (iy+009h)		;9ef1
	jr gira_der		;9ef4
camino_mas_der:
	inc (iy+009h)		;9ef6
gira_der:		; La derecha libre (bit 2)?
	bit 2,(iy+006h)		;9ef9
	jr z,gira_der_va		;9efd
	ret			;9eff
gira_der_va:
	pop de			;9f00
	jp enemigo_va_der		;9f01
camino_menos_izq:
	dec (iy+009h)		;9f04
	jr gira_izq		;9f07
camino_mas_izq:
	inc (iy+009h)		;9f09
gira_izq:		; La izquierda libre (bit 0)?
	bit 0,(iy+006h)		;9f0c
	jr z,gira_izq_va		;9f10
	ret			;9f12
gira_izq_va:
	pop de			;9f13
	jp enemigo_va_izq		;9f14
enemigo_sube:		; El enemigo una casilla arriba (-32)...
	ld de,0ffe0h		;9f17
	jr enemigo_pasa		;9f1a
enemigo_baja:		; ...abajo (+32)...
	ld de,00020h		;9f1c
	jr enemigo_pasa		;9f1f
enemigo_derecha1:		; ...a la derecha (+1)...
	ld de,00001h		;9f21
	jr enemigo_pasa		;9f24
enemigo_izquierda1:		; ...o a la izquierda (-1)
	ld de,0ffffh		;9f26
enemigo_pasa:		; Borra su pieza, la pone en su sitio nuevo y Z
	call iy_borra		;9f29   ; borrada
	add hl,de			;9f2c   ; el sitio nuevo
	call iy_sitio_pon		;9f2d
	call iy_pieza		;9f30   ; la pieza alli
	xor a			;9f33
	ret			;9f34
iy_borra:		; La pieza de IY, borrada
	call iy_sitio		;9f35
pieza_borra:		; La pieza de HL: cuatro espacios
	ld a,010h		;9f38   ; todas la misma...
	ld (0e3f7h),a		;9f3a
	ld c,010h		;9f3d   ; ...el espacio
	jp pieza_va		;9f3f
camino:		; HL = el camino del enemigo (+0x0A) y E = sus pasos (+9)
	ld l,(iy+00ah)		;9f42
	ld h,(iy+00bh)		;9f45
	ld e,(iy+009h)		;9f48
	ret			;9f4b
iy_sitio_pon:		; (IY+0, IY+1) = HL
	ld (iy+000h),l		;9f4c
	ld (iy+001h),h		;9f4f
	ret			;9f52
salta_a:		; La tabla de saltos de detras de la llamada, por A (A x 2): no vuelve
	pop hl			;9f53   ; la tabla
	push de			;9f54
	sla a		;9f55   ; A x 2
	jr salta		;9f57
salta_dir:		; La tabla de detras de la llamada por la direccion (A and 6: 0, 2, 4 o 6)
	pop hl			;9f59   ; la tabla
	push de			;9f5a
	and 007h		;9f5b   ; la direccion...
	res 0,a		;9f5d   ; ...par
salta:		; La palabra A de la tabla HL, y alli
	ld e,a			;9f5f
	ld d,000h		;9f60
	add hl,de			;9f62
	ld e,(hl)			;9f63   ; el destino
	inc hl			;9f64
	ld d,(hl)			;9f65
	ex de,hl			;9f66
	pop de			;9f67
	jp (hl)			;9f68   ; alli
numero_sale:		; Los puntos en la pantalla: un hueco de los cuatro de 0xE3D3 (10 bytes), con el dibujo A, encima de la casilla HL
	ld ix,0e3d3h		;9f69
	push hl			;9f6d
	push af			;9f6e
	ld de,0000ah		;9f6f   ; de 10 en 10 bytes
	ld b,004h		;9f72   ; cuatro
numero_hueco:
	ld a,(ix+000h)		;9f74
	and a			;9f77   ; libre?
	jr z,numero_pon		;9f78
	add ix,de		;9f7a
	djnz numero_hueco		;9f7c
	pop af			;9f7e
	pop hl			;9f7f
	ret			;9f80
numero_pon:		; Sus dos sprites (A y A + 4), blancos, en la X de la casilla - 8 y + 8, y en su Y
	pop af			;9f81
	ld (ix+002h),a		;9f82   ; el dibujo de la izquierda
	ld (ix+007h),0c8h		;9f85   ; el de la derecha (0xC8)
	ld (ix+003h),00fh		;9f89   ; blancos
	ld (ix+008h),00fh		;9f8d
	ld a,l			;9f91   ; la columna x 8 - 8: la X
	and 01fh		;9f92
	rlca			;9f94
	rlca			;9f95
	rlca			;9f96
	sub 008h		;9f97
	ld (ix+001h),a		;9f99
	add a,010h		;9f9c   ; + 16 la otra
	ld (ix+006h),a		;9f9e
	ld a,l			;9fa1   ; la fila x 8: la Y
	and 0e0h		;9fa2
	rrca			;9fa4
	rrca			;9fa5
	ld c,a			;9fa6
	ld a,h			;9fa7
	and 003h		;9fa8
	rrca			;9faa
	rrca			;9fab
	add a,c			;9fac
	ld (ix+000h),a		;9fad
	ld (ix+005h),a		;9fb0
	ld (ix+004h),000h		;9fb3
	ld (ix+009h),000h		;9fb7
	ld (ix+004h),080h		;9fbb   ; la cuenta (+4) desde 0x80
	pop hl			;9fbf
	ret			;9fc0

; ----------------------------------------------------------------------
; DATOS demo_fase1: Los mandos grabados de la demostracion en la fase 1 (desde
;   0x9FC1: el puntero empieza en 0x9FC0)
;   0x9fc1..0x9fde  (29 bytes)
DATA_demo_fase1:
	defb 083h,035h,01dh,031h,0c3h,025h,02dh,051h,017h,01fh,0d3h,0a5h,0b7h,083h,0f5h,057h	; 9fc1  .5.1.%-Q.......W
	defb 083h,0d1h,051h,0d7h,045h,045h,065h,087h,07dh,045h,097h,043h,0f5h	; 9fd1  ..Q.EEe.}E.C.

; ======================================================================
; CODIGO 0x9fde..0xa2fd  (799 bytes)
; ======================================================================


efecto_b_pide:		; Pide el efecto A del canal B (0xE1C0); si ya hay uno, se queda el de numero mas bajo
	ld b,a			;9fde
	ld a,(0e1c0h)		;9fdf   ; ya hay uno?
	and a			;9fe2
	jr z,efecto_b_pon		;9fe3
	cp b			;9fe5   ; el de antes, mas bajo: se queda
	jr nc,efecto_b_pon		;9fe6
	ret			;9fe8
efecto_b_pon:
	ld a,b			;9fe9
	ld (0e1c0h),a		;9fea
	ret			;9fed
efecto_pide:		; Pide el efecto A (0xE1C2); el 4 solo en partida
	ld b,a			;9fee
	cp 004h		;9fef   ; el 4...
	jr nz,efecto_mira		;9ff1
	ld a,(0e000h)		;9ff3   ; ...en partida?
	and a			;9ff6
	ret z			;9ff7
efecto_mira:
	ld a,(0e1c2h)		;9ff8   ; ya hay uno?
	and a			;9ffb
	jr z,efecto_pon		;9ffc
	cp b			;9ffe   ; el de antes, mas bajo: se queda
	jr nc,efecto_pon		;9fff
	ret			;a001
efecto_pon:
	ld a,b			;a002
	ld (0e1c2h),a		;a003
	ret			;a006
musica_pide:		; Pide la musica A (0xE1BE); salvo la 1, solo en partida
	ld b,a			;a007
	cp 001h		;a008   ; la 1...
	jr z,musica_mira		;a00a
	ld a,(0e000h)		;a00c   ; ...las otras en partida?
	and a			;a00f
	ret z			;a010
musica_mira:
	ld a,(0e1beh)		;a011   ; ya hay una?
	and a			;a014
	jr z,musica_pon		;a015
	cp b			;a017   ; la de antes, mas baja: se queda
	jr nc,musica_pon		;a018
	ret			;a01a
musica_pon:
	ld a,b			;a01b
	ld (0e1beh),a		;a01c
	ret			;a01f
sonido:		; El sonido de cada cuadro (desde el bucle del juego): una musica nueva o un efecto nuevo (del canal A o de los B y C) empiezan; los tres canales (0xE180, 0xE192, 0xE1A4, 18 bytes) siguen
	ld hl,0e1bdh		;a020   ; una musica sonando?
	xor a			;a023
	cp (hl)			;a024
	jr nz,sonido_musica_va		;a025
	inc hl			;a027   ; una pedida?
	cp (hl)			;a028
	jp nz,musica_empieza		;a029
	inc hl			;a02c
	cp (hl)			;a02d
	jr nz,sonido_efecto_va		;a02e
	inc hl			;a030
	cp (hl)			;a031
	jp nz,efecto_a_empieza		;a032
L_A035:
	xor a			;a035
	inc hl			;a036   ; un efecto sonando?
	cp (hl)			;a037
	jr nz,L_A04F		;a038
	inc hl			;a03a   ; uno pedido?
	cp (hl)			;a03b
	jp nz,efecto_bc_empieza		;a03c
sonido_musica_va:
	call prioridad		;a03f   ; la pedida puede mas?
	jp c,musica_empieza		;a042
	jr sonido_canal_a		;a045
sonido_efecto_va:
	call prioridad		;a047   ; el pedido puede mas?
	jp c,efecto_a_empieza		;a04a
	jr L_A035		;a04d
L_A04F:
	call prioridad		;a04f
	jp c,efecto_bc_empieza		;a052
sonido_canal_a:		; El canal A: su bloque a 0xE1C4, un paso y de vuelta
	ld a,(0e1bdh)		;a055   ; la musica?
	and a			;a058
	jr nz,sonido_canal_a_va		;a059
	ld a,(0e1bfh)		;a05b   ; o un efecto que use el canal A?
	and a			;a05e
	jp z,sonido_canal_b		;a05f
sonido_canal_a_va:
	ld hl,0e180h		;a062   ; el canal A
	call canal_a_trabajo		;a065
	ld bc,00008h		;a068   ; sus registros 0 y 8
	xor a			;a06b
	ld (0e1d6h),a		;a06c
	call canal_paso		;a06f   ; el canal 0
	push af			;a072
	ld de,0e180h		;a073   ; de vuelta
	call canal_de_trabajo		;a076
	pop af			;a079
	and a			;a07a   ; sigue
	jr z,sonido_canal_b		;a07b
	cp 001h		;a07d   ; 1: se acaba
	jp z,musica_acaba		;a07f
	cp 002h		;a082   ; 2: calla
	jp z,efecto_a_acaba		;a084
sonido_canal_b:		; El canal B
	ld a,(0e1bdh)		;a087   ; la musica o un efecto?
	and a			;a08a
	jr nz,sonido_canal_b_va		;a08b
	ld a,(0e1c1h)		;a08d
	and a			;a090
	jp z,sonido_fin		;a091
sonido_canal_b_va:
	ld hl,0e192h		;a094   ; el canal B
	call canal_a_trabajo		;a097
	ld bc,00209h		;a09a   ; los registros 2 y 9
	ld a,(0e1c3h)		;a09d   ; los bits del canal B
	rrca			;a0a0
	ld (0e1c3h),a		;a0a1
	ld a,001h		;a0a4   ; el canal 1
	ld (0e1d6h),a		;a0a6
	call canal_paso		;a0a9
	push af			;a0ac
	ld de,0e192h		;a0ad   ; de vuelta
	call canal_de_trabajo		;a0b0
	pop af			;a0b3
	cp 003h		;a0b4   ; 3: sigue
	jr z,sonido_canal_c		;a0b6
	ld b,a			;a0b8
	ld a,(0e1c3h)		;a0b9   ; los bits de vuelta
	rlca			;a0bc
	ld (0e1c3h),a		;a0bd
	ld a,b			;a0c0
	and a			;a0c1
	jp nz,efecto_bc_acaba		;a0c2   ; acabado
sonido_canal_c:		; El canal C
	ld hl,0e1a4h		;a0c5   ; el canal C
	call canal_a_trabajo		;a0c8
	ld bc,0040ah		;a0cb   ; los registros 4 y 10
	ld a,(0e1c3h)		;a0ce   ; los bits del canal C
	rrca			;a0d1
	rrca			;a0d2
	ld (0e1c3h),a		;a0d3
	ld a,002h		;a0d6   ; el canal 2
	ld (0e1d6h),a		;a0d8
	call canal_paso		;a0db
	push af			;a0de
	ld de,0e1a4h		;a0df   ; de vuelta
	call canal_de_trabajo		;a0e2
	pop af			;a0e5
	cp 003h		;a0e6   ; 3: sigue
	jp z,ruido_barrido		;a0e8
	ld b,a			;a0eb
	ld a,(0e1c3h)		;a0ec
	rlca			;a0ef
	rlca			;a0f0
	ld (0e1c3h),a		;a0f1
	ld a,b			;a0f4
	and a			;a0f5   ; acabado
	jp nz,efecto_bc_acaba		;a0f6
	jp ruido_barrido		;a0f9   ; el barrido del ruido
canal_a_trabajo:		; Copia el bloque del canal (HL, 18 bytes) a 0xE1C4
	ld de,0e1c4h		;a0fc   ; al canal de trabajo
copia18:
	ld bc,00012h		;a0ff   ; 18 bytes
	ldir		;a102
	ret			;a104
canal_de_trabajo:		; Y de vuelta a DE
	ld hl,0e1c4h		;a105
	jr copia18		;a108
canal_paso:		; Un paso del canal de trabajo: si la nota sigue, nada; si no, el byte siguiente de la pieza: una nota (menos de 0xF0) o una orden
	ld hl,0e1ceh		;a10a   ; la nota sigue?
	ld a,(hl)			;a10d
	and a			;a10e
	jr z,L_A116		;a10f
	call canal_cuenta		;a111   ; su cuenta
	and a			;a114
	ret z			;a115   ; sigue
L_A116:
	ld ix,0e1ceh		;a116
	ld hl,(0e1c4h)		;a11a   ; por donde va
	ld a,(hl)			;a11d
	cp 0f0h		;a11e   ; una orden?
	jr nc,canal_orden		;a120
	call nota_pon		;a122   ; la nota
	call nota_periodo		;a125   ; su periodo
	ld (0e1c4h),hl		;a128
	ld a,(0e1c3h)		;a12b   ; el canal con tono, sin ruido
	res 0,a		;a12e
	set 3,a		;a130
canal_mezcla:
	ld c,a			;a132
	ld a,(0e1d6h)		;a133   ; corrido al canal
	and a			;a136
	ld b,a			;a137
	ld a,c			;a138
	jr z,canal_mezcla_pon		;a139
canal_mezcla_corre:
	rlca			;a13b
	djnz canal_mezcla_corre		;a13c
canal_mezcla_pon:
	ld (0e1c3h),a		;a13e   ; el registro 7
	call psg_mezcla		;a141
	ld a,003h		;a144   ; 3: sigue
	ret			;a146
canal_orden:		; Las ordenes: 0xF0, 0xFF el final (1), 0xF7 (2), 0xFE...
	jp z,canal_ruido		;a147   ; 0xF0: ruido
	cp 0ffh		;a14a   ; 0xFF: el final
	jr nz,canal_orden_f7		;a14c
	ld a,001h		;a14e
	ret			;a150
canal_orden_f7:
	cp 0f7h		;a151   ; 0xF7: callar
	jr nz,canal_orden_fe		;a153
	ld a,002h		;a155
	ret			;a157
canal_orden_fe:
	cp 0feh		;a158   ; 0xFE: al principio
	jr nz,canal_orden_fd		;a15a
	ld hl,(0e1c6h)		;a15c
	ld (0e1c4h),hl		;a15f
	jr L_A116		;a162
canal_orden_fd:		; 0xFD n: la marca 1 y cuantas veces
	cp 0fdh		;a164
	jr nz,canal_orden_fc		;a166
	inc hl			;a168   ; cuantas veces...
	ld a,(hl)			;a169
	ld (ix+005h),a		;a16a
	inc hl			;a16d
	ld (0e1c8h),hl		;a16e   ; la marca 1
canal_orden_sigue:		; Sigue leyendo
	ld (0e1c4h),hl		;a171   ; por donde va
	jr L_A116		;a174
canal_orden_fc:		; 0xFC: vuelve a la marca 1 si quedan
	cp 0fch		;a176
	jr nz,canal_orden_fb		;a178
	dec (ix+005h)		;a17a
	jr nz,canal_orden_fc_vuelve		;a17d
	inc hl			;a17f   ; ya: sigue
	ld (0e1c4h),hl		;a180
	jr L_A116		;a183
canal_orden_fc_vuelve:
	ld hl,(0e1c8h)		;a185   ; a la marca 1
	ld (0e1c4h),hl		;a188
	jr L_A116		;a18b
canal_orden_fb:		; 0xFB n: la marca 2
	cp 0fbh		;a18d
	jr nz,canal_orden_fa		;a18f
	inc hl			;a191   ; cuantas veces...
	ld a,(hl)			;a192
	ld (ix+006h),a		;a193
	inc hl			;a196
	ld (0e1cah),hl		;a197   ; la marca 2
	ld (0e1c4h),hl		;a19a
	jp L_A116		;a19d
canal_orden_fa:		; 0xFA: vuelve a la marca 2 si quedan
	cp 0fah		;a1a0   ; 0xFA?
	jr nz,canal_orden_f9		;a1a2
	dec (ix+006h)		;a1a4   ; una vez menos
	jr nz,canal_orden_fa_vuelve		;a1a7
	inc hl			;a1a9   ; ya: sigue
	ld (0e1c4h),hl		;a1aa
	jp L_A116		;a1ad
canal_orden_fa_vuelve:
	ld hl,(0e1cah)		;a1b0   ; a la marca 2
	ld (0e1c4h),hl		;a1b3
	jp L_A116		;a1b6
canal_orden_f9:		; 0xF9 n: la marca 3
	cp 0f9h		;a1b9   ; 0xF9?
	jr nz,canal_orden_f8		;a1bb
	inc hl			;a1bd   ; cuantas veces...
	ld a,(hl)			;a1be
	ld (ix+007h),a		;a1bf   ; ...en +7
	inc hl			;a1c2
	ld (0e1cch),hl		;a1c3   ; la marca 3
	ld (0e1c4h),hl		;a1c6
	jp L_A116		;a1c9
canal_orden_f8:		; 0xF8 (o mas): vuelve a la marca 3 si quedan
	dec (ix+007h)		;a1cc   ; una vez menos
	jr nz,canal_orden_f8_vuelve		;a1cf
	inc hl			;a1d1   ; ya: sigue
	ld (0e1c4h),hl		;a1d2
	jp L_A116		;a1d5
canal_orden_f8_vuelve:
	ld hl,(0e1cch)		;a1d8   ; a la marca 3
	ld (0e1c4h),hl		;a1db
	jp L_A116		;a1de
canal_ruido:		; 0xF0: una nota de ruido (el periodo y su barrido) y su duracion; el canal, a ruido en el registro 7
	call ruido_pon		;a1e1   ; el ruido
	inc hl			;a1e4
	call nota_pon		;a1e5   ; la duracion y el volumen
	inc hl			;a1e8
	ld (0e1c4h),hl		;a1e9   ; por donde va
	ld a,(0e1c3h)		;a1ec   ; el canal con ruido, sin tono
	res 3,a		;a1ef
	set 0,a		;a1f1
	jp canal_mezcla		;a1f3
ruido_barrido:		; El barrido del ruido: cada tantos cuadros, el periodo + el paso, unas cuantas veces
	ld a,(0e1b6h)		;a1f6   ; hay ruido?
	and a			;a1f9
	jr z,sonido_fin		;a1fa
	ld a,(0e1b7h)		;a1fc   ; con barrido?
	and a			;a1ff
	jr z,sonido_fin		;a200
	ld a,(0e1b9h)		;a202   ; quedan pasos?
	and a			;a205
	jr z,sonido_fin		;a206
	ld a,(0e1bbh)		;a208   ; la espera...
	dec a			;a20b   ; ...un cuadro menos
	ld (0e1bbh),a		;a20c
	jr nz,sonido_fin		;a20f
	ld a,(0e1b9h)		;a211   ; un paso menos
	dec a			;a214
	ld (0e1b9h),a		;a215
	ld a,(0e1bah)		;a218   ; otra vez la espera
	ld (0e1bbh),a		;a21b
	ld a,(0e1b8h)		;a21e   ; el periodo...
	ld b,a			;a221
	ld a,(0e1bch)		;a222   ; ...mas el paso
	add a,b			;a225
	ld (0e1b8h),a		;a226
	call psg_ruido		;a229   ; un paso
sonido_fin:
	ret			;a22c
prioridad:		; C si el sonido de (HL+1) es de numero menor que el de (HL)
	ld b,(hl)			;a22d   ; el que suena
	inc hl			;a22e
	ld a,(hl)			;a22f   ; el pedido: ninguno?
	and a			;a230
	ret z			;a231
	cp b			;a232   ; C si es menor
	ret			;a233
ruido_pon:		; El ruido: su periodo fijo o con barrido (periodo, cuantas veces, cada cuanto, el paso)
	ld (ix+000h),a		;a234   ; la nota
	inc hl			;a237
	ld a,(hl)			;a238   ; con barrido?
	ld (0e1b7h),a		;a239
	and a			;a23c
	jr nz,ruido_barre		;a23d
	inc hl			;a23f
	ld a,(hl)			;a240   ; el periodo...
	ld (0e1b8h),a		;a241
	call psg_ruido		;a244   ; ...registro 6
	xor a			;a247   ; sin barrido
	ld (0e1b9h),a		;a248
	ld (0e1bah),a		;a24b
	ld (0e1bbh),a		;a24e
	ld (0e1bch),a		;a251
	inc a			;a254   ; hay ruido
	ld (0e1b6h),a		;a255
	ret			;a258
ruido_barre:		; Con barrido: el paso, el periodo, cuantas veces y cada cuanto
	ld (0e1b6h),a		;a259   ; hay ruido con barrido
	ld (0e1bch),a		;a25c   ; el paso
	inc hl			;a25f
	ld a,(hl)			;a260   ; el periodo...
	ld (0e1b8h),a		;a261
	call psg_ruido		;a264   ; ...registro 6
	inc hl			;a267
	ld a,(hl)			;a268   ; cuantas veces...
	ld (0e1b9h),a		;a269
	inc hl			;a26c
	ld a,(hl)			;a26d   ; ...cada cuanto
	ld (0e1bah),a		;a26e
	ld (0e1bbh),a		;a271
	ret			;a274
canal_cuenta:		; La nota: la duracion baja; el volumen baja cada tanto (la envolvente); a 0, A = 1
	inc hl			;a275
	dec (hl)			;a276   ; la duracion, uno menos
	jp z,canal_cuenta_fin		;a277   ; acabada
	inc hl			;a27a
	ld a,(hl)			;a27b   ; el volumen: 0?
	and a			;a27c
	jp z,canal_cuenta_sigue		;a27d
	cp 00fh		;a280   ; 15: la envolvente corta
	jr z,canal_cuenta_15		;a282
	inc hl			;a284
	dec (hl)			;a285   ; la cuenta de la envolvente
	jr nz,canal_cuenta_sigue		;a286
	dec hl			;a288
	ld a,(hl)			;a289   ; la espera...
	inc hl			;a28a
	ld (hl),a			;a28b   ; ...otra vez
	inc hl			;a28c
	dec (hl)			;a28d   ; el volumen, uno menos
	ld a,(hl)			;a28e
	call psg_c		;a28f   ; al PSG
	and a			;a292
	jr nz,canal_cuenta_sigue		;a293
	dec hl			;a295
	dec hl			;a296
	ld (hl),a			;a297
canal_cuenta_sigue:
	xor a			;a298
	ret			;a299
canal_cuenta_15:
	inc hl			;a29a
	dec (hl)			;a29b   ; la cuenta
	jr nz,canal_cuenta_sigue		;a29c
	xor a			;a29e
	dec hl			;a29f
	ld (hl),a			;a2a0   ; el volumen a 0
	call psg_c		;a2a1
	ret			;a2a4
canal_cuenta_fin:
	dec hl			;a2a5
	xor a			;a2a6
	ld (hl),a			;a2a7   ; acabada: A = 1
	ld a,001h		;a2a8
	ret			;a2aa
nota_pon:		; Una nota: el byte de arriba es la duracion (0xA2FD, o el byte siguiente con 0xE), el de abajo el volumen (15: la mitad)
	ld a,(hl)			;a2ab   ; la nota...
	ld (ix+000h),a		;a2ac
	and 00fh		;a2af   ; ...el volumen (la mitad baja)
	ld (ix+002h),a		;a2b1
	ld a,(hl)			;a2b4   ; la duracion (la mitad alta)...
	and 0f0h		;a2b5
	rrca			;a2b7
	rrca			;a2b8
	rrca			;a2b9
	rrca			;a2ba
	cp 00eh		;a2bb   ; ...0xE: en el byte siguiente
	jr z,nota_duracion_byte		;a2bd
	ld de,0a2fdh		;a2bf   ; la tabla de duraciones
	add a,e			;a2c2
	jr nc,nota_duracion		;a2c3
	inc d			;a2c5
nota_duracion:
	ld e,a			;a2c6
	ld a,(de)			;a2c7   ; la duracion
	jr nota_volumen		;a2c8
nota_duracion_byte:
	inc hl			;a2ca
	ld a,(hl)			;a2cb
nota_volumen:
	ld (ix+001h),a		;a2cc   ; la duracion
	ld a,(ix+002h)		;a2cf   ; volumen 15?
	cp 00fh		;a2d2
	jr nz,nota_cuenta		;a2d4
	ld a,(ix+001h)		;a2d6   ; la duracion...
	push bc			;a2d9
	ld c,a			;a2da
	srl a		;a2db   ; ...menos la mitad: la espera
	ld b,a			;a2dd
	ld a,c			;a2de
	sub b			;a2df
	pop bc			;a2e0
nota_cuenta:
	ld (ix+003h),a		;a2e1   ; la cuenta de la envolvente
	ld a,00fh		;a2e4   ; el volumen 15
	ld (ix+004h),a		;a2e6
	call psg_c		;a2e9   ; al PSG
	ret			;a2ec
nota_periodo:		; El periodo: un byte (menos de 0x10, la parte alta) y otro
	inc hl			;a2ed
	ld a,(hl)			;a2ee   ; el byte
	cp 010h		;a2ef   ; menos de 0x10: la parte alta
	jr nc,nota_periodo_bajo		;a2f1
	call psg_b1		;a2f3   ; al registro B + 1
	inc hl			;a2f6
	ld a,(hl)			;a2f7   ; la parte baja
nota_periodo_bajo:
	call psg_b		;a2f8   ; al registro B
	inc hl			;a2fb
	ret			;a2fc

; ----------------------------------------------------------------------
; DATOS duraciones: Las 14 duraciones de las notas (de 128 a 1 cuadros)
;   0xa2fd..0xa30b  (14 bytes)
DATA_duraciones:
	defb 080h,060h,040h,030h,020h,018h,010h,00ch,008h,006h,004h,003h,002h,001h	; a2fd  .`@0 .........

; ======================================================================
; CODIGO 0xa30b..0xa440  (309 bytes)
; ======================================================================


psg_c:		; WRTPSG: el registro C
	ld e,a			;a30b   ; el valor...
	ld a,c			;a30c   ; ...el registro C
psg:		; WRTPSG
	call 00093h		;a30d   ; WRTPSG
	ret			;a310
psg_b:		; El registro B
	ld e,a			;a311   ; el registro B
	ld a,b			;a312
	jr psg		;a313
psg_b1:		; El registro B + 1
	ld e,a			;a315   ; el registro B + 1
	ld a,b			;a316
	inc a			;a317
	jr psg		;a318
psg_mezcla:		; El registro 7
	ld e,a			;a31a   ; el registro 7
	ld a,007h		;a31b
	jr psg		;a31d
psg_ruido:		; El registro 6
	ld e,a			;a31f   ; el registro 6
	ld a,006h		;a320
	jr psg		;a322
musica_empieza:		; Una musica: los tres canales de la tabla 0xA440 (6 bytes por musica)
	ld hl,0a440h		;a324   ; la tabla de musicas
	ld a,(0e1beh)		;a327   ; la musica pedida...
	ld (0e1bdh),a		;a32a   ; ...es la que suena
	ld b,a			;a32d   ; x 6
	add a,b			;a32e
	add a,b			;a32f
	add a,b			;a330
	add a,b			;a331
	add a,b			;a332
	add a,l			;a333
	jr nc,musica_tabla		;a334
	inc h			;a336
musica_tabla:		; Los tres canales de la musica: sus piezas, por principio y por donde van
	ld l,a			;a337
	ld e,(hl)			;a338   ; la pieza del canal A...
	inc hl			;a339
	ld d,(hl)			;a33a
	ld (0e180h),de		;a33b   ; ...por donde va...
	ld (0e182h),de		;a33f   ; ...y su principio
	inc hl			;a343
	ld e,(hl)			;a344
	inc hl			;a345
	ld d,(hl)			;a346
	ld (0e192h),de		;a347
	ld (0e194h),de		;a34b
	inc hl			;a34f
	ld e,(hl)			;a350
	inc hl			;a351
	ld d,(hl)			;a352
	ld (0e1a4h),de		;a353
	ld (0e1a6h),de		;a357
	xor a			;a35b
	ld (0e18ah),a		;a35c
	ld (0e19ch),a		;a35f
	ld (0e1aeh),a		;a362
	ld (0e1beh),a		;a365   ; la pedida, gastada
	ld a,0f8h		;a368   ; los tres canales con tono
sonido_mezcla:
	ld (0e1c3h),a		;a36a
	call psg_mezcla		;a36d
	jp sonido_canal_a		;a370
musica_acaba:		; El canal A acaba: si hay otra musica pedida, empieza; si no, todo callado
	ld a,(0e1beh)		;a373   ; otra pedida?
	and a			;a376
	jr nz,musica_empieza		;a377
	ld (0e1bdh),a		;a379   ; sin musica
	dec a			;a37c   ; 0xFF: todo callado...
sonido_calla:		; Todo callado: el registro 7 a 0xFF y los canales (0xE180, 67 bytes) a cero
	ld (0e1c3h),a		;a37d
	call psg_mezcla		;a380   ; ...registro 7
	ld hl,0e180h		;a383   ; los canales...
	ld b,043h		;a386   ; ...67 bytes...
borra_b2:
	ld (hl),000h		;a388   ; ...a cero
	inc hl			;a38a
	djnz borra_b2		;a38b
	ret			;a38d
efecto_a_empieza:		; Un efecto del canal A: su pieza de la tabla 0xA464 (2 bytes por efecto)
	ld hl,0a464h		;a38e   ; la tabla
	ld a,(0e1c0h)		;a391   ; el pedido...
	ld (0e1bfh),a		;a394
	ld b,a			;a397
	add a,b			;a398
	add a,l			;a399
	jr nc,efecto_a_tabla		;a39a
	inc hl			;a39c
efecto_a_tabla:
	ld l,a			;a39d
	ld e,(hl)			;a39e   ; la pieza del canal A...
	inc hl			;a39f
	ld d,(hl)			;a3a0
	ld (0e180h),de		;a3a1   ; ...por donde va...
	ld (0e182h),de		;a3a5   ; ...y su principio
	xor a			;a3a9
	ld (0e18ah),a		;a3aa
	ld (0e1c0h),a		;a3ad
	ld a,(0e1c3h)		;a3b0   ; el canal A con tono
	res 0,a		;a3b3
	ld (0e1c3h),a		;a3b5
	call psg_mezcla		;a3b8
	ld hl,0e1c0h		;a3bb
	jp L_A035		;a3be
efecto_a_acaba:		; El canal A acaba: otro efecto pedido o el canal A callado
	ld a,(0e1c0h)		;a3c1
	and a			;a3c4   ; otro pedido?
	jr nz,efecto_a_empieza		;a3c5
	ld (0e1bfh),a		;a3c7
	ld hl,0e180h		;a3ca   ; el canal A (18 bytes) a cero
	ld b,012h		;a3cd
efecto_a_borra:
	ld (hl),000h		;a3cf
	inc hl			;a3d1
	djnz efecto_a_borra		;a3d2
	ld a,(0e1c3h)		;a3d4   ; el canal A callado (los bits 0 y 3)
	or 009h		;a3d7
	ld (0e1c3h),a		;a3d9
	call psg_mezcla		;a3dc
	ret			;a3df
efecto_bc_empieza:		; Un efecto de los canales B y C: sus dos piezas de la tabla 0xA46E (4 bytes por efecto)
	ld hl,0a46eh		;a3e0   ; la tabla
	ld a,(0e1c2h)		;a3e3   ; el pedido...
	ld (0e1c1h),a		;a3e6
	ld b,a			;a3e9   ; ...x 4
	add a,b			;a3ea
	add a,b			;a3eb
	add a,b			;a3ec
	add a,l			;a3ed
	jr nc,efecto_bc_tabla		;a3ee
	inc h			;a3f0
efecto_bc_tabla:
	ld l,a			;a3f1
	ld e,(hl)			;a3f2   ; la pieza del canal B...
	inc hl			;a3f3
	ld d,(hl)			;a3f4
	ld (0e192h),de		;a3f5   ; ...por donde va...
	ld (0e194h),de		;a3f9   ; ...y su principio
	inc hl			;a3fd
	ld e,(hl)			;a3fe
	inc hl			;a3ff
	ld d,(hl)			;a400
	ld (0e1a4h),de		;a401
	ld (0e1a6h),de		;a405
	xor a			;a409
	ld (0e19ch),a		;a40a
	ld (0e1aeh),a		;a40d
	ld (0e1c2h),a		;a410
	ld a,(0e1c3h)		;a413   ; los canales B y C con tono
	and 0f9h		;a416
	ld (0e1c3h),a		;a418
	call psg_mezcla		;a41b
	jp sonido_canal_a		;a41e
efecto_bc_acaba:		; Los canales B y C acaban: otro efecto pedido o callados
	ld a,(0e1c2h)		;a421
	and a			;a424   ; otro pedido?
	jr nz,efecto_bc_empieza		;a425
	ld (0e1c1h),a		;a427
	ld hl,0e192h		;a42a   ; los canales B y C (36 bytes) a cero
	ld b,024h		;a42d
efecto_bc_borra:
	ld (hl),000h		;a42f   ; a cero
	inc hl			;a431
	djnz efecto_bc_borra		;a432
	ld a,(0e1c3h)		;a434   ; los canales B y C callados (los bits 1, 2, 4 y 5)
	or 036h		;a437
	ld (0e1c3h),a		;a439
	call psg_mezcla		;a43c
	ret			;a43f

; ----------------------------------------------------------------------
; DATOS musicas: Las seis musicas: los tres canales de cada una (la 0 es
;   ninguna)
;   0xa440..0xa464  (36 bytes)
DATA_musicas:
	defw 0a486h,0a486h,0a486h	; a440
	defw 0a48ah,0a4b3h,0a4cdh	; a446
	defw 0a59bh,0a5b6h,0a5cfh	; a44c
	defw 0a5ddh,0a60bh,0a617h	; a452
	defw 0a633h,0a633h,0a4b3h	; a458
	defw 0a65bh,0a633h,0a4cdh	; a45e

; ----------------------------------------------------------------------
; DATOS efectos_a: Los cinco efectos del canal A: su pieza
;   0xa464..0xa46e  (10 bytes)
DATA_efectos_a:
	defw 0a482h,0a56eh,0a586h,0a590h,0a597h	; a464

; ----------------------------------------------------------------------
; DATOS efectos_bc: Los cinco efectos de los canales B y C: sus dos piezas
;   0xa46e..0xa482  (20 bytes)
DATA_efectos_bc:
	defw 0a486h,0a486h	; a46e
	defw 0a50bh,0a4f8h	; a472
	defw 0a512h,0a522h	; a476
	defw 0a534h,0a538h	; a47a
	defw 0a53fh,0a543h	; a47e

; ----------------------------------------------------------------------
; DATOS piezas: Las piezas de las musicas y los efectos: notas (duracion y
;   volumen, y el periodo) y ordenes desde 0xF0
;   0xa482..0xa677  (501 bytes)
DATA_piezas:
	defb 000h,000h,000h,0f7h,000h,000h,000h,0ffh,063h,001h,0ach,061h,000h,0d6h,063h,0aah	; a482  ........c..a..c.
	defb 062h,0beh,062h,0aah,081h,08fh,081h,0a0h,081h,0a0h,081h,0d6h,081h,0beh,081h,0d6h	; a492  b.b.............
	defb 081h,0beh,081h,0aah,081h,0beh,081h,0aah,081h,0beh,064h,08fh,082h,0a0h,064h,06bh	; a4a2  ..........d...dk
	defb 0ffh,0fdh,002h,0f0h,000h,003h,081h,0fch,0f0h,000h,010h,061h,0fdh,002h,0f0h,000h	; a4b2  ...........a....
	defb 001h,081h,0fch,0fdh,002h,0f0h,000h,018h,081h,0fch,0feh,0fdh,004h,053h,003h,057h	; a4c2  .............S.W
	defb 082h,004h,075h,081h,003h,0c0h,081h,004h,075h,081h,003h,0c0h,081h,004h,075h,0fch	; a4d2  ..u.....u.....u.
	defb 0fdh,002h,053h,002h,081h,081h,003h,057h,081h,002h,0cfh,081h,003h,057h,081h,002h	; a4e2  ..S....W.....W..
	defb 0cfh,081h,002h,0fah,0fch,0feh,0d1h,000h,050h,0d1h,001h,010h,0d1h,000h,080h,0d1h	; a4f2  ........P.......
	defb 001h,080h,0d1h,000h,0f0h,0d1h,001h,0f0h,0feh,0f0h,002h,001h,01fh,002h,040h,0ffh	; a502  ..............@.
	defb 0a3h,000h,0d6h,0a3h,0beh,0a3h,0aah,0a3h,097h,0a3h,087h,0a3h,078h,0a3h,06bh,0ffh	; a512  ............x.k.
	defb 0c0h,000h,000h,0a3h,0d7h,0a3h,0bfh,0a3h,0abh,0a3h,098h,0a3h,088h,0a3h,079h,0a3h	; a522  ..............y.
	defb 06ch,0ffh,000h,000h,000h,0feh,0f0h,0ffh,010h,008h,002h,046h,0ffh,000h,000h,000h	; a532  l..........F....
	defb 0feh,0fdh,004h,055h,001h,0a9h,084h,002h,039h,084h,001h,0ddh,084h,002h,039h,084h	; a542  ...U....9.....9.
	defb 001h,0dch,084h,002h,039h,0fch,0fdh,002h,055h,001h,03dh,084h,001h,0aah,084h,001h	; a552  ....9...U.=.....
	defb 066h,084h,001h,0aah,081h,001h,066h,084h,001h,07bh,0fch,0ffh,0d1h,000h,0f0h,0d1h	; a562  f.....f..{......
	defb 0e0h,0d1h,0d0h,0d1h,0c0h,0d1h,0b0h,0d1h,0a0h,0d1h,090h,0d1h,080h,0d1h,070h,0d1h	; a572  ..............p.
	defb 060h,0d1h,050h,0f7h,0c1h,002h,000h,0c1h,0f0h,0c1h,040h,0c1h,080h,0f7h,0a1h,000h	; a582  `.P.......@.....
	defb 0d0h,0a1h,001h,000h,0f7h,081h,000h,080h,0f7h,04ch,001h,0ach,04ch,001h,01dh,066h	; a592  .........L..L..f
	defb 001h,040h,066h,001h,053h,066h,001h,01dh,066h,001h,07dh,04ch,001h,0ach,066h,07dh	; a5a2  .@f.Sf..f.}L..f}
	defb 030h,001h,0ach,0ffh,0fdh,004h,081h,002h,03bh,0fch,0fdh,004h,081h,002h,081h,0fch	; a5b2  0.......;.......
	defb 0fdh,004h,081h,002h,0a7h,0fch,0fdh,004h,081h,002h,0fah,0fch,0feh,062h,001h,0ach	; a5c2  .............b..
	defb 062h,01dh,081h,040h,081h,07dh,081h,040h,081h,07dh,0feh,082h,001h,0ach,082h,001h	; a5d2  b..@.}.@.}......
	defb 01dh,082h,001h,0ach,082h,001h,0c5h,082h,001h,040h,082h,001h,0c5h,082h,001h,0fch	; a5e2  .........@......
	defb 082h,001h,053h,082h,001h,0fch,082h,002h,03bh,082h,001h,07dh,082h,002h,03bh,064h	; a5f2  ..S.....;..}..;d
	defb 001h,0ach,082h,001h,0c5h,054h,001h,0ach,0ffh,0f0h,000h,01fh,081h,0fdh,002h,0f0h	; a602  .....T..........
	defb 000h,004h,081h,0fch,0feh,0fdh,003h,081h,000h,0aah,0fch,0fdh,003h,081h,000h,02eh	; a612  ................
	defb 0fch,0fdh,003h,081h,000h,0d6h,0fch,0fdh,003h,081h,000h,0e2h,0fch,035h,000h,0aah	; a622  .............5..
	defb 0ffh,0fdh,002h,054h,003h,057h,082h,004h,075h,082h,002h,0fah,082h,002h,0a7h,082h	; a632  ...T.W..u.......
	defb 002h,081h,082h,002h,03bh,054h,002h,081h,082h,001h,0fch,082h,002h,0fah,082h,002h	; a642  ....;T..........
	defb 0a7h,082h,002h,081h,082h,002h,03bh,0fch,0ffh,0fdh,002h,063h,001h,0ach,063h,0ach	; a652  ......;....c..c.
	defb 082h,0fch,082h,002h,03bh,082h,081h,053h,0a7h,063h,0a7h,082h,03bh,082h,001h,0fch	; a662  ....;..S.c..;...
	defb 063h,07dh,0fch,0ffh,0ffh	; a672

; ----------------------------------------------------------------------
; DATOS mapas_42: Los mapas de las fases 42 a 48: las paredes en bits (siete
;   por byte, 0xFF otra fila), 0xF0 y las cosas sueltas, y desde 0xF1 cada
;   clase de cosa
;   0xa677..0xa800  (393 bytes)
DATA_mapas_42:
	defb 000h,000h,03fh,0e0h,002h,000h,002h,000h,022h,09ch,020h,090h,020h,090h,03fh,0e3h	; a677  ..?.....". . .?.
	defb 0f0h,002h,00eh,0f1h,0b1h,0c1h,0d1h,0d4h,0f5h,055h,058h,068h,0d2h,0d3h,0f6h,0a1h	; a687  .........UXh....
	defb 0a7h,0f9h,024h,094h,0a9h,0fah,013h,019h,064h,0b7h,0d5h,0fbh,010h,044h,084h,0a2h	; a697  ..$.....d....D..
	defb 0a8h,0fch,012h,018h,074h,0a3h,0c7h,0ffh,000h,082h,02eh,0e8h,022h,088h,03ah,088h	; a6a7  ....t.......".:.
	defb 002h,082h,00bh,0a2h,028h,0a2h,02eh,0a2h,068h,0beh,0f0h,002h,004h,006h,00ah,00eh	; a6b7  ....(...h.......
	defb 0f1h,014h,039h,0b0h,0f5h,0d1h,036h,0f6h,067h,0a1h,0f9h,007h,076h,0c4h,0fah,043h	; a6c7  ..9...6.g...v..C
	defb 061h,079h,099h,0a4h,0b7h,034h,0fbh,070h,0b4h,0c1h,0fch,019h,015h,074h,078h,092h	; a6d7  ay...4.p.....tx.
	defb 0ffh,000h,080h,000h,0b6h,022h,082h,023h,0c2h,000h,0d0h,00fh,0c9h,002h,000h,003h	; a6e7  .....".#........
	defb 082h,000h,0beh,0f0h,000h,00eh,0f1h,020h,040h,031h,0f5h,007h,059h,0a7h,0f9h,032h	; a6f7  ....... @1..Y..2
	defb 062h,025h,019h,0b9h,0fah,041h,0e3h,0fbh,030h,0c2h,036h,047h,0e7h,099h,0fch,090h	; a707  b%...A..0.6G....
	defb 021h,0b1h,043h,094h,0ffh,000h,000h,000h,000h,03eh,0beh,000h,000h,000h,080h,010h	; a717  !.C......>......
	defb 088h,013h,0ech,000h,000h,000h,090h,010h,088h,013h,0ech,000h,000h,000h,090h,0f0h	; a727  ................
	defb 004h,008h,00ch,0f5h,055h,075h,095h,078h,0f9h,013h,093h,024h,0fah,053h,0d3h,0e5h	; a737  ....Uu.x...$.S..
	defb 046h,077h,079h,0fbh,051h,0d1h,062h,0fch,070h,011h,091h,082h,073h,005h,0ffh,000h	; a747  Fwy.Q.b.p...s...
	defb 000h,00fh,0ech,000h,000h,00ah,0aah,00ah,0aah,00ah,0aah,00ah,0aah,00ah,0aah,0f0h	; a757  ................
	defb 006h,008h,00ah,00ch,00eh,0f1h,084h,0a4h,0c4h,0f5h,032h,072h,0b2h,0f6h,0a1h,0f9h	; a767  ..........2r....
	defb 004h,025h,045h,065h,085h,0a5h,0c5h,0fah,0e4h,006h,038h,058h,078h,0b8h,0d8h,098h	; a777  .%Ee......8Xx...
	defb 0fch,080h,052h,092h,0d2h,023h,0ffh,009h,000h,000h,098h,02ch,090h,004h,0b2h,000h	; a787  ..R..#.....,....
	defb 082h,048h,0eah,007h,000h,004h,098h,003h,000h,000h,084h,0f0h,002h,006h,00ch,0f1h	; a797  .H..............
	defb 034h,0d1h,0f5h,029h,065h,0a9h,0f9h,011h,053h,0fah,013h,0c5h,0e5h,0d6h,097h,0fbh	; a7a7  4..)e...S.......
	defb 033h,0fch,050h,031h,081h,0b2h,003h,083h,0e3h,005h,015h,0a5h,086h,057h,0ffh,000h	; a7b7  3.P1.........W..
	defb 000h,000h,082h,01ch,0bch,020h,082h,000h,000h,03dh,0deh,000h,000h,000h,000h,004h	; a7c7  ..... ...=......
	defb 090h,00eh,09eh,0f0h,002h,004h,00ah,00ch,012h,0f1h,056h,096h,0f5h,073h,055h,095h	; a7d7  ..........V..sU.
	defb 0f9h,021h,024h,036h,0e7h,068h,0fah,070h,0d0h,0c1h,0a3h,007h,088h,0fbh,051h,0e3h	; a7e7  .!$6.h.p......Q.
	defb 074h,0b6h,0fch,010h,080h,091h,003h,043h,0ffh	; a7f7  t......C.

; ----------------------------------------------------------------------
; DATOS casillas: Los dibujos de las casillas del juego desde la 0x40 (8 bytes
;   cada una); la carga sigue por la tabla y los mapas de detras
;   0xa800..0xa960  (352 bytes)
DATA_casillas:
	defb 01fh,02bh,07fh,0fbh,0edh,0dah,0ffh,0ebh	; a800  .+......
	defb 0fch,0deh,0abh,0f7h,0fbh,02bh,0cfh,055h	; a808  .....+.U
	defb 0dfh,0e6h,0ffh,0f7h,0aah,0d5h,06bh,01fh	; a810  ......k.
	defb 0fbh,0d5h,0d9h,0d5h,0abh,0d6h,0eeh,0f8h	; a818  ........
	defb 01fh,07fh,0feh,02bh,0d6h,0edh,0aah,0dah	; a820  ...+....
	defb 0f8h,0feh,016h,0aah,0d5h,055h,0beh,065h	; a828  .....U.e
	defb 06ch,0d2h,095h,0e9h,0d4h,0aah,03fh,01fh	; a830  l.....?.
	defb 008h,069h,057h,029h,0a5h,0ffh,0feh,0f8h	; a838  .iW)....
	defb 000h,000h,000h,003h,00fh,03ch,07fh,07fh	; a840  .....<..
	defb 000h,000h,000h,0f0h,0fch,09eh,0eeh,0ffh	; a848  ........
	defb 0ffh,0ffh,0ffh,07fh,06fh,033h,00fh,003h	; a850  ....o3..
	defb 0ffh,0ffh,0ffh,0ffh,0feh,0feh,0fch,0f0h	; a858  ........
	defb 000h,000h,000h,003h,00eh,03ch,07dh,0fch	; a860  .....<}.
	defb 000h,000h,000h,030h,03ch,09eh,0eeh,0ffh	; a868  ...0<...
	defb 0feh,0ffh,0ffh,07fh,06fh,033h,00fh,003h	; a870  ....o3..
	defb 0ffh,07fh,0ffh,0ffh,0feh,0feh,0fch,0f0h	; a878  ........
	defb 000h,000h,000h,002h,00eh,03eh,07ch,0fch	; a880  .....>|.
	defb 000h,000h,000h,030h,07ch,01eh,06eh,0dfh	; a888  ...0|.n.
	defb 0fch,0fch,0feh,0feh,06fh,033h,00eh,003h	; a890  ....o3..
	defb 0dfh,0ffh,07fh,07fh,07eh,03eh,0bch,0d0h	; a898  ....~>..
	defb 01eh,07eh,0feh,0fdh,0fdh,0f1h,0c7h,0b7h	; a8a0  .~......
	defb 0f8h,0fch,07fh,07fh,03fh,0bfh,0dfh,0cfh	; a8a8  ....?...
	defb 0fbh,0fdh,0a9h,09ch,0dbh,0f6h,07fh,01fh	; a8b0  ........
	defb 0e7h,0ebh,0efh,091h,0c7h,003h,0feh,0f8h	; a8b8  ........
	defb 000h,000h,00eh,005h,00dh,031h,047h,037h	; a8c0  .....1G7
	defb 000h,000h,000h,070h,020h,0ach,0deh,0cch	; a8c8  ...p ...
	defb 0fbh,0f4h,017h,047h,0efh,0e3h,068h,00ch	; a8d0  ...G..h.
	defb 065h,06bh,02fh,093h,0a3h,029h,068h,0d8h	; a8d8  ek/..)h.
	defb 000h,000h,000h,000h,000h,000h,011h,000h	; a8e0  ........
	defb 000h,000h,000h,000h,000h,040h,070h,000h	; a8e8  .....@p.
	defb 016h,041h,02dh,016h,03dh,045h,015h,055h	; a8f0  .A-.=E.U
	defb 04ch,0d2h,057h,0a4h,05ch,032h,0eah,0c9h	; a8f8  L.W.\2..
	defb 000h,000h,000h,000h,000h,000h,000h,000h	; a900  ........
	defb 000h,000h,000h,000h,000h,000h,000h,000h	; a908  ........
	defb 000h,000h,002h,006h,008h,025h,00ah,052h	; a910  .....%.R
	defb 000h,000h,070h,080h,090h,038h,0c4h,012h	; a918  ..p..8..
	defb 000h,000h,000h,003h,000h,007h,00fh,00eh	; a920  ........
	defb 000h,000h,000h,070h,0d8h,088h,0d8h,0f0h	; a928  ...p....
	defb 01eh,01fh,00fh,007h,003h,000h,000h,000h	; a930  ........
	defb 078h,0f8h,0f0h,0f0h,0e0h,000h,000h,000h	; a938  x.......
	defb 004h,084h,040h,000h,03fh,07fh,080h,0ffh	; a940  ..@.?...
	defb 040h,041h,002h,000h,0fch,0e2h,041h,0c1h	; a948  @A....A.
	defb 000h,0ffh,0e3h,0e3h,0f7h,0f7h,07fh,000h	; a950  ........
	defb 000h,0bfh,0bfh,0bfh,0bfh,0bfh,0beh,000h	; a958  ........

; ----------------------------------------------------------------------
; DATOS tabla_mapas: El mapa de cada fase (52 palabras, por 0xE007): las fases
;   1-11 en 0xA9C8, 12-28 en 0xB4E9, 29-35 en 0xBBDF, 36-41 en 0xBEC0, 42-48
;   en 0xA677 y 49-52 en 0xAF68
;   0xa960..0xa9c8  (104 bytes)
DATA_tabla_mapas:
	defw 0a9c8h,0a9e9h,0aa0fh,0aa39h,0aa61h,0aa87h,0aab0h,0aad7h	; a960
	defw 0ab00h,0ab27h,0ab52h,0b4e9h,0b514h,0b53fh,0b56bh,0b59ch	; a970
	defw 0b5c8h,0b5f7h,0b623h,0b64fh,0b677h,0b6b1h,0b6e0h,0b712h	; a980
	defw 0b740h,0b772h,0b7a3h,0b7cfh,0bbdfh,0bc11h,0bc3eh,0bc72h	; a990
	defw 0bca4h,0bcd7h,0bd06h,0bec0h,0befah,0bf2dh,0bf64h,0bf97h	; a9a0
	defw 0bfcdh,0a677h,0a6afh,0a6e8h,0a71ch,0a756h,0a78eh,0a7c6h	; a9b0
	defw 0af68h,0afa1h,0afa1h,0afddh	; a9c0  -> DATA_mapas_49 0xafa1 0xafa1 0xafdd

; ----------------------------------------------------------------------
; DATOS mapas_1: Los mapas de las fases 1 a 11
;   0xa9c8..0xab7e  (438 bytes)
DATA_mapas_1:
	defb 000h,000h,039h,0e0h,021h,000h,03bh,0e0h,000h,000h,003h,0e0h,000h,0c0h,003h,0c0h	; a9c8  ..9.!.;.........
	defb 0f0h,002h,00eh,0f1h,042h,046h,074h,0a2h,0f5h,022h,056h,092h,0f9h,054h,0fbh,094h	; a9d8  ....BFt.."V..T..
	defb 0ffh,020h,09ch,00fh,0c6h,008h,0d0h,022h,09eh,01eh,0d0h,008h,0e7h,06eh,084h,028h	; a9e8  . .....".....n.(
	defb 0e5h,003h,090h,003h,090h,0f0h,00ah,0f1h,096h,091h,033h,0f5h,0c8h,0e8h,079h,0f6h	; a9f8  ..........3...y.
	defb 0a5h,0a7h,0fah,0a6h,0fbh,0a1h,0ffh,000h,000h,01bh,0eeh,000h,000h,01fh,0ech,000h	; aa08  ................
	defb 000h,03fh,0ech,000h,000h,017h,0eeh,000h,000h,0f0h,006h,0f1h,041h,071h,075h,077h	; aa18  .?..........Aquw
	defb 0a1h,0f5h,009h,019h,029h,0c9h,0d9h,0e9h,0f6h,0a3h,0a5h,0a7h,0fah,0c2h,0fbh,0e8h	; aa28  ....)...........
	defb 0ffh,001h,0ceh,03ch,0c4h,021h,000h,028h,0bah,00dh,08bh,048h,000h,06bh,08eh,002h	; aa38  ...<.!.(...H.k..
	defb 0a0h,028h,0abh,03dh,088h,0f0h,000h,008h,00ch,0f1h,092h,095h,096h,0c4h,0f5h,046h	; aa48  .(.=...........F
	defb 0b1h,0c8h,0f6h,0e0h,0fah,0c3h,0fbh,0d2h,0ffh,028h,0a4h,00ah,0a4h,00ah,000h,021h	; aa58  .........(.....!
	defb 08eh,03ch,0e1h,001h,084h,06ch,08eh,020h,0a2h,03ah,08ah,0f0h,000h,002h,006h,008h	; aa68  .<...l. .:......
	defb 00eh,012h,0f1h,027h,066h,0f5h,008h,079h,099h,0e2h,0f9h,026h,0fbh,081h,0ffh,000h	; aa78  ...'f..y...&....
	defb 000h,06eh,0eeh,028h,088h,021h,0a3h,02ah,0aah,003h,098h,07ah,0c0h,000h,08dh,059h	; aa88  .n.(.!.*...z...Y
	defb 0a0h,059h,0a0h,0f0h,002h,006h,00ah,0f1h,024h,046h,050h,077h,0f5h,017h,057h,0c8h	; aa98  .Y......$FPw..W.
	defb 0f9h,021h,078h,0fah,0c5h,0fbh,076h,0ffh,024h,0c4h,004h,084h,015h,0d4h,080h,0c0h	; aaa8  .!x...v.$.......
	defb 016h,0a5h,010h,09ch,01eh,000h,000h,084h,01eh,0a5h,011h,0a5h,0f0h,000h,008h,00ah	; aab8  ................
	defb 00ch,0f1h,0d3h,0f5h,0d0h,0e1h,0e3h,0f9h,019h,081h,0fah,0d9h,0fbh,0d1h,0ffh,022h	; aac8  ..............."
	defb 08ah,008h,0aah,02eh,0a0h,020h,0aah,00dh,080h,040h,0b4h,017h,080h,043h,0ddh,078h	; aad8  ..... ...@...C.x
	defb 000h,0f0h,002h,004h,00eh,010h,0f1h,024h,025h,075h,096h,0d4h,0f5h,058h,0c1h,0a9h	; aae8  .......$%u...X..
	defb 0fah,0c8h,0fbh,030h,0d5h,0fch,051h,0ffh,007h,09eh,020h,000h,00eh,0dch,054h,0c8h	; aaf8  ...0..Q... ...T.
	defb 000h,0e1h,02eh,0dch,023h,091h,008h,084h,021h,0e5h,008h,0a1h,0f0h,004h,006h,010h	; ab08  ....#...!.......
	defb 0f1h,0d9h,063h,0f5h,069h,089h,077h,0f9h,0d8h,0fbh,086h,0c6h,0fch,080h,0ffh,001h	; ab18  ..c.i.w.........
	defb 0c2h,02dh,0dah,024h,0d2h,025h,0d0h,03dh,0d6h,000h,0c2h,07ah,0e2h,00ah,000h,03ah	; ab28  .-.$.%.=...z...:
	defb 0eah,000h,082h,0f0h,000h,008h,010h,0f1h,046h,079h,092h,0c3h,0f5h,047h,0b9h,0c5h	; ab38  ........Fy...G..
	defb 0f6h,0a8h,0fah,0d3h,0fbh,0e6h,0fch,093h,0b3h,0ffh,000h,088h,03bh,0aah,000h,000h	; ab48  ............;...
	defb 022h,0eeh,02ah,000h,02ah,0aah,000h,000h,03bh,0ech,000h,08ch,000h,08ch,0f0h,000h	; ab58  ".*.*...;.......
	defb 008h,00ah,00eh,0f1h,045h,0a5h,0d4h,0d7h,0f5h,060h,0c9h,009h,0fah,0e5h,0fbh,036h	; ab68  ....E....`.....6
	defb 078h,085h,0fch,023h,0c5h,0ffh	; ab78

; ----------------------------------------------------------------------
; DATOS casillas2: Mas dibujos de casillas: los que la carga de 0xA800 lleva a
;   las casillas de detras
;   0xab7e..0xae00  (642 bytes)
DATA_casillas2:
	defb 0fch,000h,03fh,01fh,020h,03fh,03fh,03fh	; ab7e  ..?. ???
	defb 03fh,07fh,0fch,0f8h,004h,0fch,0fch,0fch	; ab86  ?.......
	defb 0fch,0feh,0bfh,0dfh,067h,03fh,01fh,00ch	; ab8e  ....g?..
	defb 007h,007h,0fdh,0fbh,0e6h,0fch,004h,03eh	; ab96  .......>
	defb 0feh,0ffh,01fh,03fh,01fh,020h,03fh,03fh	; ab9e  ...?. ??
	defb 07fh,0bfh,0f8h,0fch,0f8h,004h,0fch,0fch	; aba6  ........
	defb 0feh,0fdh,0bfh,0dfh,067h,03fh,020h,078h	; abae  ....g? x
	defb 07fh,0ffh,0fdh,0fbh,0e6h,0fch,0f8h,010h	; abb6  ........
	defb 0e0h,0e0h,00fh,07fh,0ffh,0ffh,07fh,07fh	; abbe  ........
	defb 07fh,03fh,0e0h,0e0h,0f0h,0f0h,0f1h,0f6h	; abc6  .?......
	defb 0f8h,0e0h,03fh,0f8h,017h,031h,031h,078h	; abce  ..?..11x
	defb 003h,003h,0dch,0c4h,044h,060h,07ch,0fch	; abd6  ....D`|.
	defb 0fch,0f8h,01fh,07fh,0ffh,0ffh,0ffh,07fh	; abde  ........
	defb 07fh,03fh,0c0h,0e0h,0e0h,0f0h,0f0h,0f3h	; abe6  .?......
	defb 0fch,0e0h,03fh,007h,01eh,03eh,03eh,01fh	; abee  ..?..>>.
	defb 03fh,0c1h,0f4h,014h,084h,088h,0ech,01ch	; abf6  ?.......
	defb 0fch,0f8h,01fh,03fh,03fh,03fh,03fh,03fh	; abfe  ...?????
	defb 0bfh,07fh,0f8h,0fch,0fch,0fch,0fch,0fch	; ac06  ........
	defb 0fdh,0feh,031h,028h,028h,02eh,071h,00fh	; ac0e  ..1((.q.
	defb 007h,007h,088h,088h,0b8h,0c4h,0feh,0fch	; ac16  ........
	defb 0f8h,0e0h,03fh,03fh,03fh,03fh,03fh,03fh	; ac1e  ..??????
	defb 03fh,000h,0fch,0fch,0fch,0fch,0fch,0fch	; ac26  ?.......
	defb 0fch,000h,011h,011h,01dh,023h,07fh,03fh	; ac2e  .....#.?
	defb 01fh,007h,00ch,044h,044h,074h,08eh,0f0h	; ac36  ...DDt..
	defb 0e0h,0e0h,007h,007h,00fh,00fh,00fh,0cfh	; ac3e  ........
	defb 03fh,007h,0f0h,0feh,0ffh,0ffh,0feh,0feh	; ac46  ?.......
	defb 0feh,0fch,023h,023h,03ah,006h,03eh,03fh	; ac4e  ..##:.>?
	defb 03fh,01fh,0fch,01fh,08ch,08ch,0ech,01eh	; ac56  ?.......
	defb 0c0h,0c0h,003h,007h,007h,00fh,08fh,06fh	; ac5e  .......o
	defb 01fh,007h,0f8h,0feh,0ffh,0ffh,0ffh,0feh	; ac66  ........
	defb 0feh,0fch,02fh,028h,027h,014h,034h,038h	; ac6e  ../('.48
	defb 03fh,01fh,0fch,0e0h,07ch,07ch,07ch,0f8h	; ac76  ?...|||.
	defb 0fch,083h,000h,000h,000h,03fh,01fh,020h	; ac7e  .....?. 
	defb 03fh,03fh,000h,000h,000h,0fch,0f8h,004h	; ac86  ??......
	defb 0fch,0fch,03fh,03fh,03fh,03fh,0bfh,04fh	; ac8e  ..????.O
	defb 0b0h,030h,0fch,0fch,0fch,0fch,0fdh,0f2h	; ac96  .0......
	defb 00dh,00ch,000h,000h,000h,000h,000h,000h	; ac9e  ........
	defb 000h,01fh,000h,000h,000h,000h,000h,000h	; aca6  ........
	defb 000h,0f8h,020h,03fh,03fh,03fh,03fh,03fh	; acae  .. ?????
	defb 080h,07fh,004h,0fch,0fch,0fch,0fch,0fch	; acb6  ........
	defb 001h,0feh,000h,003h,00fh,01fh,03fh,07fh	; acbe  ......?.
	defb 07fh,07fh,000h,0c0h,0f0h,098h,0ech,0feh	; acc6  ........
	defb 0feh,0feh,0ffh,0dfh,0dfh,0efh,073h,03fh	; acce  ......s?
	defb 007h,0ceh,0ffh,0ffh,0ffh,0ffh,0feh,0fch	; acd6  ........
	defb 0e0h,073h,003h,00fh,01fh,03fh,07fh,07fh	; acde  .s...?..
	defb 07fh,0ffh,0c0h,0f0h,098h,0ech,0f6h,0feh	; ace6  ........
	defb 0feh,0ffh,0dfh,0dfh,0efh,0f3h,07fh,03fh	; acee  .......?
	defb 007h,073h,0ffh,0ffh,0ffh,0ffh,0feh,0fch	; acf6  .s......
	defb 0e0h,0ceh,000h,007h,01ch,03bh,037h,07fh	; acfe  .....;7.
	defb 07fh,0ffh,000h,0e0h,0f0h,0f8h,0fch,0fch	; ad06  ........
	defb 0feh,0feh,0feh,0fch,0f8h,0d9h,088h,080h	; ad0e  ........
	defb 07fh,0ceh,03bh,011h,089h,08dh,021h,0fch	; ad16  ..;...!.
	defb 0feh,073h,000h,007h,01eh,03bh,037h,07fh	; ad1e  .s...;7.
	defb 07fh,0ffh,000h,0e0h,070h,0f8h,0fch,0fch	; ad26  ....p...
	defb 0feh,0feh,0feh,0fch,0f8h,0f9h,0c8h,0c0h	; ad2e  ........
	defb 07fh,09ch,03bh,011h,089h,005h,021h,0fch	; ad36  ..;...!.
	defb 0feh,0e4h,000h,003h,00fh,01fh,03fh,06fh	; ad3e  ......?o
	defb 05fh,05fh,000h,0c0h,0f0h,098h,0ech,0feh	; ad46  __......
	defb 0feh,0feh,0ffh,0e3h,0c5h,0cch,0c1h,07fh	; ad4e  ........
	defb 0ffh,0ceh,0ffh,0c7h,0a3h,033h,083h,0feh	; ad56  .....3..
	defb 0ffh,073h,000h,000h,003h,00fh,01fh,03fh	; ad5e  .s.....?
	defb 06fh,05fh,000h,000h,0c0h,030h,0e8h,0fch	; ad66  o_...0..
	defb 0feh,0feh,0dfh,0e3h,0c5h,0c8h,0c1h,0ffh	; ad6e  ........
	defb 07fh,099h,0ffh,0c7h,0a3h,013h,083h,0ffh	; ad76  ........
	defb 0feh,099h,000h,007h,00fh,01fh,03fh,03fh	; ad7e  ......??
	defb 07fh,07fh,000h,0e0h,038h,0dch,0ech,0feh	; ad86  ....8...
	defb 0feh,0ffh,0dch,088h,091h,0b1h,084h,03fh	; ad8e  .......?
	defb 07fh,0ceh,07fh,03fh,01fh,09bh,011h,001h	; ad96  ...?....
	defb 0feh,073h,000h,007h,00eh,01fh,03fh,03fh	; ad9e  .s....??
	defb 07fh,07fh,000h,0e0h,078h,0dch,0ech,0feh	; ada6  ....x...
	defb 0feh,0ffh,0dch,088h,091h,0a0h,084h,03fh	; adae  .......?
	defb 07fh,027h,07fh,03fh,01fh,09fh,013h,003h	; adb6  .'.?....
	defb 0feh,039h,000h,000h,000h,000h,000h,003h	; adbe  .9......
	defb 00fh,01fh,000h,000h,000h,000h,000h,0c0h	; adc6  ........
	defb 0f0h,098h,03fh,06fh,05fh,07fh,0ffh,0ffh	; adce  ..?o_...
	defb 0e3h,0c1h,0ech,0f6h,0feh,0feh,0ffh,0ffh	; add6  ........
	defb 0c7h,083h,000h,000h,000h,000h,000h,000h	; adde  ........
	defb 000h,000h,000h,000h,000h,000h,000h,000h	; ade6  ........
	defb 000h,000h,002h,00eh,01eh,03dh,07bh,07bh	; adee  .....={{
	defb 07fh,0e3h,0c0h,0f0h,078h,07ch,09eh,0deh	; adf6  ....x|..
	defb 0deh,0c7h	; adfe

; ----------------------------------------------------------------------
; DATOS casillas_titulo_datos: Los dibujos de las casillas del titulo (0x160
;   bytes)
;   0xae00..0xaf60  (352 bytes)
DATA_casillas_titulo_datos:
	defb 00fh,01fh,01fh,03fh,03fh,03fh,03dh,03ch	; ae00  ...???=<
	defb 007h,08fh,0dfh,0ffh,0ffh,0ffh,0fdh,0f9h	; ae08  ........
	defb 0e1h,0e3h,0e7h,0e7h,0efh,0efh,0efh,0efh	; ae10  ........
	defb 0f0h,0f8h,0fch,0fch,0beh,01eh,01eh,01eh	; ae18  ........
	defb 01fh,03fh,07fh,07fh,0f8h,0f8h,0f0h,0f0h	; ae20  .?......
	defb 08ch,0deh,0deh,09eh,01eh,01eh,01eh,01eh	; ae28  ........
	defb 0c1h,0e3h,0e7h,0c7h,00fh,00fh,00fh,00fh	; ae30  ........
	defb 060h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; ae38  `.......
	defb 03ch,03ch,03ch,03ch,03ch,03ch,03ch,018h	; ae40  <<<<<<<.
	defb 071h,001h,001h,001h,001h,001h,001h,000h	; ae48  q.......
	defb 0efh,0efh,0efh,0efh,0efh,0efh,0efh,0c6h	; ae50  ........
	defb 01eh,0feh,0feh,0feh,01eh,01eh,01eh,00ch	; ae58  ........
	defb 0f7h,0f3h,0fbh,0f9h,07fh,07fh,03fh,01fh	; ae60  ......?.
	defb 09eh,0deh,0deh,0deh,0deh,0deh,0deh,08ch	; ae68  ........
	defb 0f0h,0f0h,0f8h,0f8h,07fh,07fh,03fh,01fh	; ae70  ......?.
	defb 00fh,00fh,00fh,00fh,0cfh,0efh,0efh,0c6h	; ae78  ........
	defb 000h,000h,000h,000h,0c0h,0e0h,0e0h,0c0h	; ae80  ........
	defb 000h,000h,000h,000h,01ch,03eh,03eh,03eh	; ae88  .....>>>
	defb 03eh,03eh,03eh,03eh,03eh,03eh,03eh,03eh	; ae90  >>>>>>>>
	defb 0c7h,0efh,0efh,0cfh,00fh,00fh,00fh,00fh	; ae98  ........
	defb 0fch,0feh,0feh,0fch,080h,080h,0fch,0feh	; aea0  ........
	defb 03eh,03eh,03eh,03eh,03eh,03eh,03eh,01ch	; aea8  >>>>>>>.
	defb 00fh,00fh,00fh,00fh,0cfh,0efh,0efh,0c7h	; aeb0  ........
	defb 0feh,0fch,080h,080h,0fch,0feh,0feh,0fch	; aeb8  ........
	defb 000h,000h,000h,000h,070h,0f9h,0f9h,0f9h	; aec0  ....p...
	defb 000h,000h,000h,000h,0e1h,0f3h,0f3h,0f3h	; aec8  ........
	defb 000h,000h,000h,000h,0c0h,0e0h,0e0h,0e0h	; aed0  ........
	defb 0f9h,0f9h,0f9h,0f9h,0f9h,0f9h,0f9h,0fbh	; aed8  ........
	defb 0f3h,0f3h,0f3h,0f3h,0f3h,0f3h,0f3h,0fbh	; aee0  ........
	defb 07fh,0ffh,0ffh,0ffh,0f3h,0f1h,0f3h,0ffh	; aee8  ........
	defb 086h,0cfh,0cfh,0efh,0efh,0efh,0efh,0efh	; aef0  ........
	defb 007h,00fh,00fh,00fh,00fh,00fh,00fh,00fh	; aef8  ........
	defb 0f0h,0f8h,0fch,0fch,03eh,03eh,01eh,01eh	; af00  ....>>..
	defb 0ffh,0ffh,0ffh,0ffh,07fh,07fh,03fh,01eh	; af08  ......?.
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0bfh,01fh,00fh	; af10  ........
	defb 0efh,0efh,0efh,0efh,0c7h,0c7h,083h,001h	; af18  ........
	defb 01eh,01eh,01eh,0beh,0fch,0fch,0f8h,0f0h	; af20  ........
	defb 0ffh,0ffh,0ffh,0ffh,0f7h,0f7h,0f3h,061h	; af28  .......a
	defb 0cfh,0cfh,08fh,00fh,087h,0c7h,0e3h,0c1h	; af30  ........
	defb 00fh,00fh,08fh,083h,0f9h,0fdh,0fdh,0f9h	; af38  ........
	defb 01eh,01eh,01eh,03eh,0fch,0fch,0f8h,0f0h	; af40  ...>....
	defb 081h,0c3h,0c7h,0e7h,0efh,0efh,0efh,0efh	; af48  ........
	defb 03ch,042h,099h,0a5h,0b9h,0a5h,042h,03ch	; af50  <B....B<
	defb 081h,042h,024h,018h,018h,024h,042h,081h	; af58  .B$..$B.

; ----------------------------------------------------------------------
; DATOS dibujo_af60: Ocho bytes de dibujo: la (c)
;   0xaf60..0xaf68  (8 bytes)
DATA_dibujo_af60:
	defb 03ch,042h,099h,0a1h,0a1h,099h,042h,03ch	; af60  <B....B<

; ----------------------------------------------------------------------
; DATOS mapas_49: Los mapas de las fases 49 y 50 (la 51 usa el de la 50) y el
;   del final
;   0xaf68..0xaff4  (140 bytes)
DATA_mapas_49:
	defb 000h,0a2h,055h,0e8h,004h,000h,009h,0a8h,008h,000h,060h,0afh,002h,0e0h,00ah,0a8h	; af68  ..U.......`.....
	defb 000h,088h,040h,098h,0f0h,012h,0f1h,023h,043h,078h,062h,027h,0f5h,0d8h,0e9h,0c7h	; af78  ..@....#Cxb'....
	defb 0f9h,002h,004h,006h,053h,083h,0fah,022h,058h,080h,0a7h,0c3h,0e2h,0e4h,0fbh,011h	; af88  ....S.."X.......
	defb 036h,085h,0a0h,0fch,038h,050h,065h,0b4h,0ffh,000h,000h,03eh,0bch,022h,084h,00ah	; af98  6...8Pe....>."..
	defb 0e0h,008h,084h,008h,0bdh,02fh,084h,022h,094h,02ah,090h,000h,090h,0f0h,002h,006h	; afa8  ...../.".*......
	defb 008h,00ah,00ch,010h,012h,0f1h,072h,085h,0f5h,0c3h,013h,008h,0f9h,028h,055h,063h	; afb8  ......r......(Uc
	defb 097h,0d5h,0fah,039h,048h,077h,090h,0c9h,0e1h,0fbh,010h,023h,092h,094h,0a6h,0d7h	; afc8  ...9Hw.....#....
	defb 0fch,043h,0d0h,0b7h,0ffh,000h,000h,03bh,090h,024h,0edh,022h,088h,002h,0bch,000h	; afd8  .C.....;.$."....
	defb 000h,00eh,0f1h,071h,0f5h,059h,0b9h,0fah,095h,0fch,033h,0ffh	; afe8  ...q.Y....3.

; ----------------------------------------------------------------------
; DATOS dibujo_aff4: Doce bytes de dibujo (aspas) detras del ultimo mapa
;   0xaff4..0xb000  (12 bytes)
DATA_dibujo_aff4:
	defb 018h,024h,042h,081h,081h,042h,024h,018h,018h,024h,042h,081h	; aff4  .$B..B$..$B.

; ----------------------------------------------------------------------
; DATOS colores_datos: Los colores de las casillas, en tramos (cuantos y el
;   color) hasta 0xFF
;   0xb000..0xb251  (593 bytes)
DATA_colores_datos:
	defb 003h,040h	; b000
	defb 005h,045h	; b002
	defb 002h,040h	; b004
	defb 003h,04fh	; b006
	defb 001h,040h	; b008
	defb 001h,045h	; b00a
	defb 001h,040h	; b00c
	defb 004h,045h	; b00e
	defb 001h,040h	; b010
	defb 001h,045h	; b012
	defb 002h,040h	; b014
	defb 002h,045h	; b016
	defb 001h,040h	; b018
	defb 002h,045h	; b01a
	defb 003h,040h	; b01c
	defb 003h,070h	; b01e
	defb 002h,07fh	; b020
	defb 001h,073h	; b022
	defb 001h,074h	; b024
	defb 001h,073h	; b026
	defb 001h,0f0h	; b028
	defb 001h,070h	; b02a
	defb 003h,07fh	; b02c
	defb 001h,077h	; b02e
	defb 001h,07fh	; b030
	defb 001h,03fh	; b032
	defb 001h,074h	; b034
	defb 001h,073h	; b036
	defb 001h,07fh	; b038
	defb 003h,073h	; b03a
	defb 001h,070h	; b03c
	defb 001h,030h	; b03e
	defb 005h,037h	; b040
	defb 003h,030h	; b042
	defb 020h,0f0h	; b044
	defb 020h,0f0h	; b046
	defb 020h,0f0h	; b048
	defb 012h,0f0h	; b04a
	defb 004h,0f7h	; b04c
	defb 005h,0f0h	; b04e
	defb 003h,0f7h	; b050
	defb 002h,0f0h	; b052
	defb 020h,0f0h	; b054
	defb 006h,050h	; b056
	defb 001h,0f0h	; b058
	defb 007h,050h	; b05a
	defb 001h,0f8h	; b05c
	defb 001h,050h	; b05e
	defb 001h,0f0h	; b060
	defb 001h,050h	; b062
	defb 001h,0f0h	; b064
	defb 004h,050h	; b066
	defb 001h,0f0h	; b068
	defb 001h,0f8h	; b06a
	defb 001h,050h	; b06c
	defb 001h,0f8h	; b06e
	defb 001h,058h	; b070
	defb 001h,0f8h	; b072
	defb 002h,050h	; b074
	defb 001h,0f8h	; b076
	defb 011h,050h	; b078
	defb 002h,0f0h	; b07a
	defb 001h,050h	; b07c
	defb 001h,0f0h	; b07e
	defb 005h,050h	; b080
	defb 001h,0f0h	; b082
	defb 001h,050h	; b084
	defb 001h,0f0h	; b086
	defb 001h,050h	; b088
	defb 002h,0d0h	; b08a
	defb 020h,0b0h	; b08c
	defb 080h,000h	; b08e
	defb 007h,0b8h	; b090
	defb 001h,0b0h	; b092
	defb 007h,080h	; b094
	defb 001h,0b0h	; b096
	defb 008h,0b8h	; b098
	defb 008h,080h	; b09a
	defb 007h,0b0h	; b09c
	defb 001h,080h	; b09e
	defb 007h,0b8h	; b0a0
	defb 001h,008h	; b0a2
	defb 008h,0b0h	; b0a4
	defb 008h,0b8h	; b0a6
	defb 008h,0b8h	; b0a8
	defb 008h,080h	; b0aa
	defb 001h,0b0h	; b0ac
	defb 007h,0b8h	; b0ae
	defb 001h,0b0h	; b0b0
	defb 007h,080h	; b0b2
	defb 011h,0b0h	; b0b4
	defb 001h,080h	; b0b6
	defb 007h,0b0h	; b0b8
	defb 001h,080h	; b0ba
	defb 006h,0b0h	; b0bc
	defb 008h,0b0h	; b0be
	defb 008h,0b8h	; b0c0
	defb 001h,080h	; b0c2
	defb 007h,0b0h	; b0c4
	defb 001h,008h	; b0c6
	defb 007h,0b8h	; b0c8
	defb 003h,000h	; b0ca
	defb 005h,008h	; b0cc
	defb 007h,0b0h	; b0ce
	defb 001h,0b8h	; b0d0
	defb 002h,008h	; b0d2
	defb 006h,0b0h	; b0d4
	defb 004h,0b8h	; b0d6
	defb 004h,0b0h	; b0d8
	defb 006h,008h	; b0da
	defb 002h,0b0h	; b0dc
	defb 004h,008h	; b0de
	defb 004h,0b8h	; b0e0
	defb 008h,0b0h	; b0e2
	defb 001h,0b8h	; b0e4
	defb 007h,080h	; b0e6
	defb 007h,0b0h	; b0e8
	defb 001h,0b8h	; b0ea
	defb 003h,000h	; b0ec
	defb 005h,008h	; b0ee
	defb 004h,0b8h	; b0f0
	defb 004h,0b0h	; b0f2
	defb 002h,008h	; b0f4
	defb 006h,0b0h	; b0f6
	defb 004h,0b0h	; b0f8
	defb 004h,0b8h	; b0fa
	defb 008h,0b0h	; b0fc
	defb 004h,0b8h	; b0fe
	defb 00ch,0b0h	; b100
	defb 004h,008h	; b102
	defb 004h,0b8h	; b104
	defb 006h,008h	; b106
	defb 002h,0b0h	; b108
	defb 001h,0b8h	; b10a
	defb 007h,080h	; b10c
	defb 008h,0b0h	; b10e
	defb 002h,008h	; b110
	defb 006h,0b8h	; b112
	defb 002h,008h	; b114
	defb 005h,0b8h	; b116
	defb 001h,008h	; b118
	defb 007h,0b8h	; b11a
	defb 001h,008h	; b11c
	defb 008h,000h	; b11e
	defb 002h,008h	; b120
	defb 005h,0b8h	; b122
	defb 003h,008h	; b124
	defb 006h,0b8h	; b126
	defb 008h,000h	; b128
	defb 007h,0b8h	; b12a
	defb 001h,008h	; b12c
	defb 002h,008h	; b12e
	defb 006h,0b8h	; b130
	defb 008h,000h	; b132
	defb 007h,0b8h	; b134
	defb 003h,008h	; b136
	defb 005h,0b8h	; b138
	defb 001h,008h	; b13a
	defb 00ah,008h	; b13c
	defb 006h,0b8h	; b13e
	defb 002h,008h	; b140
	defb 005h,0b8h	; b142
	defb 001h,008h	; b144
	defb 007h,0b8h	; b146
	defb 001h,008h	; b148
	defb 002h,090h	; b14a
	defb 006h,080h	; b14c
	defb 002h,090h	; b14e
	defb 00bh,080h	; b150
	defb 003h,05bh	; b152
	defb 004h,080h	; b154
	defb 002h,05bh	; b156
	defb 002h,050h	; b158
	defb 003h,090h	; b15a
	defb 005h,080h	; b15c
	defb 004h,090h	; b15e
	defb 008h,080h	; b160
	defb 002h,05bh	; b162
	defb 002h,050h	; b164
	defb 005h,080h	; b166
	defb 001h,00bh	; b168
	defb 002h,05bh	; b16a
	defb 012h,080h	; b16c
	defb 003h,050h	; b16e
	defb 001h,080h	; b170
	defb 002h,05bh	; b172
	defb 006h,050h	; b174
	defb 002h,05bh	; b176
	defb 011h,080h	; b178
	defb 001h,05bh	; b17a
	defb 003h,050h	; b17c
	defb 002h,080h	; b17e
	defb 001h,05bh	; b180
	defb 008h,050h	; b182
	defb 010h,080h	; b184
	defb 005h,050h	; b186
	defb 003h,05bh	; b188
	defb 005h,050h	; b18a
	defb 002h,05bh	; b18c
	defb 001h,050h	; b18e
	defb 007h,080h	; b190
	defb 001h,00bh	; b192
	defb 007h,080h	; b194
	defb 001h,00bh	; b196
	defb 005h,050h	; b198
	defb 002h,05bh	; b19a
	defb 006h,050h	; b19c
	defb 003h,05bh	; b19e
	defb 010h,080h	; b1a0
	defb 006h,050h	; b1a2
	defb 002h,05bh	; b1a4
	defb 002h,080h	; b1a6
	defb 003h,050h	; b1a8
	defb 001h,080h	; b1aa
	defb 002h,05bh	; b1ac
	defb 010h,080h	; b1ae
	defb 008h,050h	; b1b0
	defb 001h,080h	; b1b2
	defb 001h,05bh	; b1b4
	defb 003h,050h	; b1b6
	defb 002h,080h	; b1b8
	defb 001h,05bh	; b1ba
	defb 005h,090h	; b1bc
	defb 003h,080h	; b1be
	defb 005h,090h	; b1c0
	defb 004h,080h	; b1c2
	defb 001h,0f0h	; b1c4
	defb 005h,080h	; b1c6
	defb 001h,05bh	; b1c8
	defb 001h,080h	; b1ca
	defb 001h,0f0h	; b1cc
	defb 005h,080h	; b1ce
	defb 001h,05bh	; b1d0
	defb 010h,090h	; b1d2
	defb 001h,0f0h	; b1d4
	defb 001h,080h	; b1d6
	defb 001h,0f0h	; b1d8
	defb 001h,080h	; b1da
	defb 001h,0f0h	; b1dc
	defb 003h,080h	; b1de
	defb 001h,0f0h	; b1e0
	defb 001h,080h	; b1e2
	defb 001h,0f0h	; b1e4
	defb 001h,080h	; b1e6
	defb 001h,0f0h	; b1e8
	defb 003h,080h	; b1ea
	defb 008h,0f0h	; b1ec
	defb 002h,0e0h	; b1ee
	defb 00bh,0f0h	; b1f0
	defb 002h,0f8h	; b1f2
	defb 001h,080h	; b1f4
	defb 005h,0f0h	; b1f6
	defb 002h,0f8h	; b1f8
	defb 001h,080h	; b1fa
	defb 015h,0f0h	; b1fc
	defb 002h,0f8h	; b1fe
	defb 001h,080h	; b200
	defb 005h,0f0h	; b202
	defb 002h,0f8h	; b204
	defb 001h,080h	; b206
	defb 015h,0f0h	; b208
	defb 001h,0f8h	; b20a
	defb 002h,080h	; b20c
	defb 004h,0f0h	; b20e
	defb 004h,080h	; b210
	defb 015h,0f0h	; b212
	defb 001h,0f8h	; b214
	defb 002h,080h	; b216
	defb 004h,0f0h	; b218
	defb 004h,080h	; b21a
	defb 014h,0f0h	; b21c
	defb 004h,080h	; b21e
	defb 004h,0f0h	; b220
	defb 004h,080h	; b222
	defb 014h,0f0h	; b224
	defb 004h,080h	; b226
	defb 004h,0f0h	; b228
	defb 004h,080h	; b22a
	defb 014h,0f0h	; b22c
	defb 004h,080h	; b22e
	defb 005h,0f0h	; b230
	defb 001h,0f8h	; b232
	defb 002h,080h	; b234
	defb 014h,0f0h	; b236
	defb 004h,080h	; b238
	defb 005h,0f0h	; b23a
	defb 001h,0f8h	; b23c
	defb 002h,080h	; b23e
	defb 017h,0f0h	; b240
	defb 001h,0f8h	; b242
	defb 007h,0f0h	; b244
	defb 001h,0f8h	; b246
	defb 017h,0f0h	; b248
	defb 001h,0f8h	; b24a
	defb 007h,0f0h	; b24c
	defb 001h,0f8h	; b24e
	defb 0ffh	; b250

; ----------------------------------------------------------------------
; DATOS casillas_final: Las casillas del final, en tramos hasta 0xFF
;   0xb251..0xb34c  (251 bytes)
DATA_casillas_final:
	defb 008h,03ch	; b251
	defb 004h,01fh	; b253
	defb 004h,000h	; b255
	defb 004h,0ffh	; b257
	defb 004h,000h	; b259
	defb 008h,0f8h	; b25b
	defb 004h,0ffh	; b25d
	defb 004h,0f0h	; b25f
	defb 004h,0ffh	; b261
	defb 004h,03ch	; b263
	defb 004h,0ffh	; b265
	defb 004h,00fh	; b267
	defb 004h,000h	; b269
	defb 004h,01fh	; b26b
	defb 004h,03ch	; b26d
	defb 004h,0ffh	; b26f
	defb 004h,000h	; b271
	defb 004h,0f8h	; b273
	defb 002h,001h	; b275
	defb 002h,003h	; b277
	defb 002h,007h	; b279
	defb 001h,00fh	; b27b
	defb 001h,01fh	; b27d
	defb 002h,0f0h	; b27f
	defb 002h,0e0h	; b281
	defb 002h,0c0h	; b283
	defb 002h,080h	; b285
	defb 004h,0f0h	; b287
	defb 004h,0ffh	; b289
	defb 004h,00fh	; b28b
	defb 004h,0ffh	; b28d
	defb 004h,000h	; b28f
	defb 001h,008h	; b291
	defb 001h,018h	; b293
	defb 001h,038h	; b295
	defb 001h,0f8h	; b297
	defb 004h,000h	; b299
	defb 004h,07fh	; b29b
	defb 004h,000h	; b29d
	defb 004h,0fch	; b29f
	defb 003h,000h	; b2a1
	defb 001h,001h	; b2a3
	defb 001h,003h	; b2a5
	defb 001h,007h	; b2a7
	defb 001h,00fh	; b2a9
	defb 001h,07fh	; b2ab
	defb 001h,03fh	; b2ad
	defb 001h,07fh	; b2af
	defb 005h,0ffh	; b2b1
	defb 001h,0bbh	; b2b3
	defb 003h,000h	; b2b5
	defb 001h,080h	; b2b7
	defb 001h,0c0h	; b2b9
	defb 001h,0e0h	; b2bb
	defb 001h,0f0h	; b2bd
	defb 001h,0f8h	; b2bf
	defb 008h,0f0h	; b2c1
	defb 008h,00fh	; b2c3
	defb 003h,000h	; b2c5
	defb 002h,00fh	; b2c7
	defb 003h,007h	; b2c9
	defb 002h,03fh	; b2cb
	defb 003h,0ffh	; b2cd
	defb 002h,0fch	; b2cf
	defb 001h,03ch	; b2d1
	defb 002h,0f8h	; b2d3
	defb 001h,0f0h	; b2d5
	defb 001h,0c0h	; b2d7
	defb 004h,000h	; b2d9
	defb 004h,01eh	; b2db
	defb 002h,01fh	; b2dd
	defb 002h,00fh	; b2df
	defb 005h,03ch	; b2e1
	defb 002h,078h	; b2e3
	defb 001h,0f8h	; b2e5
	defb 002h,007h	; b2e7
	defb 002h,003h	; b2e9
	defb 002h,001h	; b2eb
	defb 002h,000h	; b2ed
	defb 001h,080h	; b2ef
	defb 002h,0c1h	; b2f1
	defb 001h,0e3h	; b2f3
	defb 001h,0f7h	; b2f5
	defb 002h,0ffh	; b2f7
	defb 001h,07eh	; b2f9
	defb 002h,0f0h	; b2fb
	defb 002h,0e0h	; b2fd
	defb 001h,0c0h	; b2ff
	defb 001h,080h	; b301
	defb 006h,000h	; b303
	defb 004h,007h	; b305
	defb 001h,000h	; b307
	defb 001h,003h	; b309
	defb 001h,01fh	; b30b
	defb 002h,0ffh	; b30d
	defb 001h,0feh	; b30f
	defb 001h,0f8h	; b311
	defb 001h,0c0h	; b313
	defb 003h,0ffh	; b315
	defb 001h,0e7h	; b317
	defb 001h,081h	; b319
	defb 004h,000h	; b31b
	defb 001h,080h	; b31d
	defb 001h,0e0h	; b31f
	defb 001h,0f8h	; b321
	defb 001h,0ffh	; b323
	defb 001h,0feh	; b325
	defb 001h,03ch	; b327
	defb 001h,00ch	; b329
	defb 001h,0f8h	; b32b
	defb 001h,070h	; b32d
	defb 001h,020h	; b32f
	defb 005h,000h	; b331
	defb 001h,0feh	; b333
	defb 001h,07ch	; b335
	defb 001h,030h	; b337
	defb 001h,020h	; b339
	defb 004h,000h	; b33b
	defb 002h,03ch	; b33d
	defb 001h,07ch	; b33f
	defb 001h,0fch	; b341
	defb 002h,0f8h	; b343
	defb 001h,0f0h	; b345
	defb 001h,0c0h	; b347
	defb 018h,000h	; b349
	defb 0ffh	; b34b

; ----------------------------------------------------------------------
; DATOS casillas_tramos: Mas casillas del juego, en tramos hasta 0xFF (encima
;   de las de 0xA800, desde la 0x78)
;   0xb34c..0xb41d  (209 bytes)
DATA_casillas_tramos:
	defb 007h,0f0h	; b34c
	defb 001h,0ffh	; b34e
	defb 007h,080h	; b350
	defb 001h,0f8h	; b352
	defb 008h,0fch	; b354
	defb 008h,0f8h	; b356
	defb 007h,001h	; b358
	defb 001h,01fh	; b35a
	defb 007h,0f0h	; b35c
	defb 001h,000h	; b35e
	defb 008h,01fh	; b360
	defb 008h,0c0h	; b362
	defb 008h,0fch	; b364
	defb 008h,0f8h	; b366
	defb 001h,0ffh	; b368
	defb 007h,0f0h	; b36a
	defb 001h,0f8h	; b36c
	defb 007h,080h	; b36e
	defb 008h,01fh	; b370
	defb 008h,0f8h	; b372
	defb 001h,01fh	; b374
	defb 007h,00fh	; b376
	defb 001h,0f8h	; b378
	defb 007h,0f0h	; b37a
	defb 008h,01fh	; b37c
	defb 008h,0c0h	; b37e
	defb 001h,01fh	; b380
	defb 007h,001h	; b382
	defb 001h,000h	; b384
	defb 007h,0f0h	; b386
	defb 00bh,000h	; b388
	defb 005h,080h	; b38a
	defb 002h,000h	; b38c
	defb 006h,0ffh	; b38e
	defb 004h,080h	; b390
	defb 004h,0ffh	; b392
	defb 006h,000h	; b394
	defb 002h,0ffh	; b396
	defb 004h,000h	; b398
	defb 004h,07fh	; b39a
	defb 005h,0ffh	; b39c
	defb 003h,000h	; b39e
	defb 001h,07fh	; b3a0
	defb 004h,080h	; b3a2
	defb 003h,000h	; b3a4
	defb 003h,000h	; b3a6
	defb 005h,001h	; b3a8
	defb 008h,000h	; b3aa
	defb 004h,001h	; b3ac
	defb 004h,0ffh	; b3ae
	defb 002h,000h	; b3b0
	defb 006h,0ffh	; b3b2
	defb 003h,000h	; b3b4
	defb 001h,001h	; b3b6
	defb 004h,0fdh	; b3b8
	defb 003h,000h	; b3ba
	defb 005h,0ffh	; b3bc
	defb 004h,0fdh	; b3be
	defb 001h,001h	; b3c0
	defb 003h,000h	; b3c2
	defb 005h,0ffh	; b3c4
	defb 003h,000h	; b3c6
	defb 004h,000h	; b3c8
	defb 004h,0feh	; b3ca
	defb 006h,000h	; b3cc
	defb 002h,0ffh	; b3ce
	defb 001h,0feh	; b3d0
	defb 004h,001h	; b3d2
	defb 003h,000h	; b3d4
	defb 005h,0ffh	; b3d6
	defb 003h,000h	; b3d8
	defb 002h,000h	; b3da
	defb 005h,07fh	; b3dc
	defb 001h,07ch	; b3de
	defb 002h,000h	; b3e0
	defb 005h,0fch	; b3e2
	defb 001h,000h	; b3e4
	defb 007h,07ch	; b3e6
	defb 009h,000h	; b3e8
	defb 002h,000h	; b3ea
	defb 005h,07fh	; b3ec
	defb 001h,000h	; b3ee
	defb 002h,000h	; b3f0
	defb 005h,0fch	; b3f2
	defb 001h,07ch	; b3f4
	defb 008h,000h	; b3f6
	defb 007h,07ch	; b3f8
	defb 001h,000h	; b3fa
	defb 002h,000h	; b3fc
	defb 006h,07ch	; b3fe
	defb 008h,000h	; b400
	defb 002h,07ch	; b402
	defb 005h,07fh	; b404
	defb 003h,000h	; b406
	defb 005h,0fch	; b408
	defb 001h,000h	; b40a
	defb 00ah,000h	; b40c
	defb 006h,07ch	; b40e
	defb 002h,000h	; b410
	defb 005h,07fh	; b412
	defb 001h,000h	; b414
	defb 002h,07ch	; b416
	defb 005h,0fch	; b418
	defb 001h,000h	; b41a
	defb 0ffh	; b41c

; ----------------------------------------------------------------------
; DATOS casillas_titulo_tramos: Las casillas del titulo, en tramos hasta 0xFF
;   0xb41d..0xb47c  (95 bytes)
DATA_casillas_titulo_tramos:
	defb 001h,03ch	; b41d
	defb 001h,042h	; b41f
	defb 001h,099h	; b421
	defb 002h,0a1h	; b423
	defb 001h,099h	; b425
	defb 001h,042h	; b427
	defb 001h,03ch	; b429
	defb 002h,03fh	; b42b
	defb 006h,0c0h	; b42d
	defb 002h,0ffh	; b42f
	defb 006h,000h	; b431
	defb 001h,00fh	; b433
	defb 001h,03fh	; b435
	defb 001h,030h	; b437
	defb 004h,0c0h	; b439
	defb 001h,0ffh	; b43b
	defb 001h,0f0h	; b43d
	defb 001h,0fch	; b43f
	defb 001h,00ch	; b441
	defb 004h,003h	; b443
	defb 001h,0ffh	; b445
	defb 002h,03fh	; b447
	defb 005h,0c0h	; b449
	defb 001h,03fh	; b44b
	defb 002h,0ffh	; b44d
	defb 005h,000h	; b44f
	defb 001h,0fch	; b451
	defb 008h,001h	; b453
	defb 008h,080h	; b455
	defb 002h,0fch	; b457
	defb 006h,003h	; b459
	defb 006h,0c0h	; b45b
	defb 002h,03fh	; b45d
	defb 006h,000h	; b45f
	defb 002h,0ffh	; b461
	defb 001h,0ffh	; b463
	defb 007h,0c0h	; b465
	defb 001h,0ffh	; b467
	defb 007h,003h	; b469
	defb 001h,03fh	; b46b
	defb 005h,000h	; b46d
	defb 002h,0ffh	; b46f
	defb 001h,0fch	; b471
	defb 005h,003h	; b473
	defb 002h,0fch	; b475
	defb 006h,003h	; b477
	defb 002h,0fch	; b479
	defb 0ffh	; b47b

; ======================================================================
; CODIGO 0xb47c..0xb4e7  (107 bytes)
; ======================================================================


caminos_olvida:		; Con la palanca movida, a veces (el registro R de 0x30 o mas) los quince enemigos olvidan su camino (+9 a 0)
	ld a,r		;b47c   ; al azar
	cp 030h		;b47e
	ret c			;b480
	ld a,(0e1fch)		;b481   ; la palanca?
	and a			;b484
	ret z			;b485
	ld hl,0e219h		;b486   ; el camino de cada enemigo...
	ld de,00010h		;b489
	ld b,00fh		;b48c
caminos_olvida_uno:
	ld (hl),000h		;b48e
	add hl,de			;b490
	djnz caminos_olvida_uno		;b491
	ret			;b493
abajo2_cero:		; El empujon a 0 y dos filas abajo
	call empujon_cero		;b494
abajo2:		; HL dos filas abajo (+64)...
	call abajo1		;b497
abajo1:		; ...o una (+32)
	push de			;b49a
	ld de,00020h		;b49b
suma_de:
	add hl,de			;b49e
	pop de			;b49f
	ret			;b4a0
arriba2_cero:		; El empujon a 0 y dos filas arriba
	call empujon_cero		;b4a1
arriba2:		; HL dos filas arriba...
	call arriba1		;b4a4
arriba1:		; ...o una (-32)
	push de			;b4a7
	ld de,0ffe0h		;b4a8
	jr suma_de		;b4ab
iy_pieza:		; La pieza del enemigo IY: (+2 - 1) x 4 + 3 + el bit de +0x0D
	ld a,(iy+002h)		;b4ad   ; la direccion - 1...
	dec a			;b4b0
	rlca			;b4b1   ; ...x 4
	rlca			;b4b2
	add a,(iy+003h)		;b4b3   ; + el dibujo
	add a,(iy+00dh)		;b4b6   ; + el parpadeo
	ld c,a			;b4b9
	jp pieza		;b4ba
casillas_arriba:		; B y C = las dos casillas de la fila de arriba de HL
	push hl			;b4bd
	call arriba1		;b4be
	jr casillas_lado		;b4c1
casillas_abajo:		; ...las de dos filas abajo
	push hl			;b4c3
	call abajo2		;b4c4
casillas_lado:
	ld de,00001h		;b4c7
	jr casillas_lee		;b4ca
derecha_cero:		; El empujon a 0 y...
	call empujon_cero		;b4cc
casillas_derecha:		; ...B y C = las dos casillas de la columna de la derecha (dos mas alla)
	push hl			;b4cf
	inc hl			;b4d0
	inc hl			;b4d1
	jr casillas_columna		;b4d2
izquierda_cero:		; El empujon a 0 y...
	call empujon_cero		;b4d4
casillas_izquierda:		; ...las de la columna de la izquierda
	push hl			;b4d7
	dec hl			;b4d8
casillas_columna:
	ld de,00020h		;b4d9
casillas_lee:		; RDVRM de HL y de HL + DE
	call 0004ah		;b4dc   ; RDVRM
	ld b,a			;b4df
	add hl,de			;b4e0
	call 0004ah		;b4e1   ; RDVRM
	ld c,a			;b4e4
	pop hl			;b4e5
	ret			;b4e6

; ----------------------------------------------------------------------
; DATOS bytes_b4e7: "pop hl / ret": dos bytes de codigo a los que no se llega
;   0xb4e7..0xb4e9  (2 bytes)
DATA_bytes_b4e7:
	defb 0e1h,0c9h	; b4e7

; ----------------------------------------------------------------------
; DATOS mapas_12: Los mapas de las fases 12 a 28
;   0xb4e9..0xb800  (791 bytes)
DATA_mapas_12:
	defb 024h,090h,027h,000h,000h,0dfh,017h,088h,010h,088h,001h,0dah,058h,000h,013h,0dch	; b4e9  $.'.........X...
	defb 000h,0d1h,010h,0d1h,0f0h,006h,008h,00ah,00eh,0f1h,028h,060h,096h,0f5h,009h,099h	; b4f9  ..........(`....
	defb 0c1h,0fah,068h,093h,0d6h,0fbh,064h,095h,0fch,050h,0ffh,036h,000h,003h,0beh,058h	; b509  ..h...d..P.6...X
	defb 000h,052h,0b5h,016h,081h,000h,0b2h,061h,09bh,00ch,090h,025h,0c4h,061h,0e4h,0f0h	; b519  .R.....a...%.a..
	defb 006h,008h,00ah,00ch,010h,0f1h,080h,090h,0f5h,0a0h,0b0h,0c0h,0fah,0c6h,081h,0fbh	; b529  ................
	defb 065h,0fch,034h,052h,012h,0ffh,01ch,092h,001h,080h,015h,0d6h,044h,0c4h,055h,0d5h	; b539  e.4R........D.U.
	defb 010h,090h,01dh,0d4h,001h,0a6h,001h,084h,001h,084h,0f0h,010h,0f1h,021h,037h,058h	; b549  .............!7X
	defb 070h,0a1h,0c5h,0f5h,0e6h,0d6h,0e9h,0d9h,0fah,098h,0a3h,023h,0fbh,041h,080h,0fch	; b559  p..........#.A..
	defb 060h,0ffh,020h,0c0h,02dh,0c2h,000h,0eah,02dh,0ceh,029h,082h,038h,092h,023h,0d6h	; b569  `. .-...-.).8.#.
	defb 038h,090h,00eh,0e6h,000h,084h,0f0h,002h,006h,008h,00ch,010h,0f1h,032h,039h,065h	; b579  8............29e
	defb 077h,084h,0f5h,036h,0a4h,0c2h,0f6h,068h,0a2h,0a8h,0f9h,012h,024h,0fbh,042h,051h	; b589  w..6...h....$.BQ
	defb 053h,062h,0ffh,020h,0c0h,028h,0deh,006h,0c0h,075h,084h,000h,095h,019h,0ech,00dh	; b599  Sb. .(...u......
	defb 0a0h,008h,08dh,000h,081h,004h,08ch,0f0h,006h,00eh,010h,012h,0f1h,034h,0f5h,026h	; b5a9  .............4.&
	defb 0a5h,089h,0f9h,044h,0fah,061h,0b4h,0d7h,0fbh,060h,0fch,091h,053h,015h,0ffh,010h	; b5b9  ...D.a...`..S...
	defb 000h,007h,0a3h,032h,0b8h,020h,082h,033h,0bah,002h,0a3h,030h,0b0h,020h,000h,060h	; b5c9  ...2. .3...0. .`
	defb 000h,000h,0a0h,0f0h,002h,008h,0f1h,002h,028h,093h,0d2h,0f5h,038h,056h,079h,098h	; b5d9  ........(...8Vy.
	defb 0b6h,0f9h,053h,0b1h,039h,0fah,021h,0d6h,0fbh,081h,0d0h,0fch,025h,0ffh,02fh,09bh	; b5e9  ..S.9.!.....%./.
	defb 020h,091h,023h,000h,032h,084h,034h,0c5h,000h,0c5h,001h,09dh,062h,091h,000h,0c1h	; b5f9   .#.2.4.....b...
	defb 004h,087h,0f0h,00ah,0f1h,032h,045h,064h,058h,0f5h,026h,098h,0c1h,0f9h,091h,0fah	; b609  .....2EdX.&.....
	defb 042h,015h,047h,018h,0fbh,077h,0c7h,0fch,0b4h,0ffh,00fh,0cfh,028h,089h,028h,0c9h	; b619  B.G..w......(.(.
	defb 02bh,0e9h,028h,000h,008h,0a8h,00fh,0b8h,002h,098h,000h,099h,03fh,08fh,0f0h,000h	; b629  +.(.........?...
	defb 00ch,0f1h,020h,081h,086h,0f5h,0d1h,045h,009h,0f9h,023h,077h,0fah,052h,015h,0c7h	; b639  .. ....E..#w.R..
	defb 0fbh,0d4h,028h,0fch,091h,0ffh,010h,098h,011h,090h,010h,090h,03ah,0a3h,010h,084h	; b649  ..(.........:...
	defb 03ah,0a2h,011h,095h,011h,098h,000h,0c8h,000h,0c2h,0f0h,006h,00ah,0f5h,014h,065h	; b659  :..............e
	defb 009h,0f9h,063h,0b6h,0fah,0a4h,017h,0fbh,082h,047h,0fch,0d1h,042h,0ffh,000h,080h	; b669  ..c......G..B...
	defb 006h,0b5h,003h,080h,030h,0d4h,020h,080h,02eh,0e4h,000h,080h,028h,0eeh,001h,0a0h	; b679  ....0. .....(...
	defb 028h,0a8h,0f0h,002h,004h,006h,008h,00ah,00eh,010h,0f1h,025h,006h,067h,070h,0b8h	; b689  (..........%.gp.
	defb 0c0h,081h,0f5h,061h,0e0h,056h,089h,0f6h,0a5h,0f9h,011h,081h,093h,0a7h,0a4h,0fah	; b699  ...a.V..........
	defb 0e7h,0fbh,007h,030h,0fch,005h,066h,0ffh,004h,000h,000h,000h,033h,0d8h,001h,0c8h	; b6a9  ...0..f.....3...
	defb 017h,08ch,000h,000h,05eh,0c0h,048h,098h,040h,0c0h,060h,0d0h,0f1h,018h,034h,042h	; b6b9  ....^.H.@.`...4B
	defb 087h,090h,0a8h,0f5h,043h,066h,091h,0c7h,0f9h,021h,028h,032h,098h,0fah,053h,075h	; b6c9  ....Cf...!(2..Su
	defb 0fbh,092h,0b1h,0c6h,0fch,047h,0ffh,000h,0b8h,03ah,080h,00ah,0eah,028h,082h,022h	; b6d9  .....G...:...(."
	defb 0eeh,03ah,088h,002h,0bbh,038h,082h,00bh,0aah,000h,080h,0f0h,000h,004h,008h,00ah	; b6e9  .:...8..........
	defb 00ch,00eh,010h,0f1h,053h,097h,0c8h,0f5h,036h,0d0h,0d9h,0f9h,043h,086h,093h,0fah	; b6f9  ....S...6...C...
	defb 016h,039h,057h,0b7h,0fch,0b1h,0c2h,050h,0ffh,029h,084h,001h,090h,00dh,090h,049h	; b709  .9W....P.).....I
	defb 0cch,010h,085h,053h,0e8h,00ah,0c8h,000h,000h,004h,088h,040h,091h,0f0h,010h,012h	; b719  ...S.......@....
	defb 0f1h,073h,093h,0a0h,0b7h,0f5h,069h,099h,019h,0fah,041h,053h,081h,0e2h,0c9h,0fbh	; b729  .s....i...AS....
	defb 043h,082h,0a3h,0fch,088h,0c2h,0ffh,008h,000h,020h,000h,03bh,0eah,002h,082h,072h	; b739  C........ .;...r
	defb 0eah,000h,088h,032h,0eah,022h,08ah,037h,0eah,000h,082h,0f0h,004h,008h,00ch,010h	; b749  ...2.".7........
	defb 0f1h,035h,038h,0f5h,015h,029h,0e3h,0f6h,0a2h,0a8h,0f9h,093h,0a6h,0d5h,0fah,055h	; b759  .58..).........U
	defb 073h,069h,0fbh,040h,075h,0fch,051h,095h,0ffh,014h,0a0h,010h,000h,005h,0eeh,009h	; b769  si.@u.Q.........
	defb 0c2h,02ah,096h,002h,0d0h,072h,093h,00bh,000h,000h,0b4h,008h,000h,0f0h,000h,00ah	; b779  .*...r..........
	defb 010h,0f1h,071h,073h,0b5h,0f5h,018h,0e0h,086h,0f9h,015h,024h,061h,077h,079h,093h	; b789  ..qs.......$awy.
	defb 0fah,052h,038h,0fbh,0b6h,0fch,072h,066h,0b4h,0ffh,000h,000h,02dh,0d3h,021h,090h	; b799  .R8...rf....-.!.
	defb 035h,0d4h,010h,0c0h,03fh,0d5h,021h,091h,000h,0d8h,01ah,0c0h,002h,092h,0f0h,002h	; b7a9  5...?.!.........
	defb 0f1h,022h,0f5h,009h,0e9h,079h,0f9h,033h,042h,044h,082h,089h,093h,0a8h,0fah,039h	; b7b9  ."...y.3BD.....9
	defb 0fch,001h,021h,0c1h,0d2h,0ffh,000h,000h,028h,08ah,02bh,0ebh,038h,0a8h,003h,0aeh	; b7c9  ..!.....(.+.8...
	defb 038h,0a2h,00bh,0aah,00ah,08ah,03ah,0eah,0f0h,004h,008h,00ch,010h,0f1h,005h,091h	; b7d9  8.....:.........
	defb 097h,0e8h,0f5h,017h,051h,029h,0f9h,019h,0c1h,0fah,043h,0a6h,0d9h,0fbh,014h,030h	; b7e9  ....Q)....C....0
	defb 075h,0d0h,0fch,068h,086h,0a4h,0ffh	; b7f9

; ----------------------------------------------------------------------
; DATOS sprites_datos: Los dibujos de los sprites (la carga de 0x800 bytes de
;   0xB800 sigue por el codigo de 0xBBC0, los mapas y los dibujos de 0xBD3A)
;   0xb800..0xbbc0  (960 bytes)
DATA_sprites_datos:
	defb 001h,000h,003h,007h,006h,00eh,00fh,007h,003h,001h,000h,000h,000h,000h,000h,000h	; b800  ................
	defb 0b8h,06ch,0c4h,0ech,0f8h,07ch,0fch,0f8h,098h,050h,0e0h,0c0h,000h,000h,000h,000h	; b810  .l...|...P......
	defb 000h,001h,000h,000h,000h,000h,000h,000h,000h,006h,004h,000h,000h,000h,000h,000h	; b820  ................
	defb 000h,090h,038h,010h,000h,080h,000h,000h,060h,020h,000h,000h,000h,000h,000h,000h	; b830  ..8.....` ......
	defb 000h,000h,000h,000h,000h,010h,000h,000h,000h,000h,003h,037h,037h,037h,03bh,000h	; b840  ...........777;.
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,080h,010h,030h,0f0h,0f6h,0ceh,03ch	; b850  ...........0...<
	defb 003h,000h,003h,007h,006h,00eh,00fh,007h,003h,001h,008h,018h,000h,000h,000h,000h	; b860  ................
	defb 070h,0d8h,088h,0d8h,0fch,07ch,0fch,0f8h,098h,050h,0e0h,0c0h,000h,000h,000h,000h	; b870  p....|...P......
	defb 000h,003h,000h,000h,000h,000h,000h,000h,000h,006h,014h,000h,000h,000h,000h,000h	; b880  ................
	defb 000h,020h,070h,020h,000h,080h,000h,000h,060h,020h,000h,000h,000h,000h,000h,000h	; b890  . p ....` ......
	defb 000h,000h,000h,000h,000h,010h,000h,000h,000h,000h,003h,007h,007h,007h,01ah,00dh	; b8a0  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,080h,010h,030h,0f0h,080h,078h,0f0h	; b8b0  ...........0..x.
	defb 01dh,036h,023h,037h,01fh,03eh,03fh,01fh,019h,00ah,007h,003h,000h,000h,000h,000h	; b8c0  .6#7.>?.........
	defb 080h,000h,0c0h,0e0h,060h,070h,0f0h,0e0h,0c0h,080h,000h,000h,000h,000h,000h,000h	; b8d0  ....`p..........
	defb 000h,009h,01ch,008h,000h,001h,000h,000h,006h,004h,000h,000h,000h,000h,000h,000h	; b8e0  ................
	defb 000h,080h,000h,000h,000h,000h,000h,000h,000h,060h,020h,000h,000h,000h,000h,000h	; b8f0  .........` .....
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,001h,008h,00ch,00fh,06fh,073h,03ch	; b900  .............os<
	defb 000h,000h,000h,000h,000h,008h,000h,000h,000h,000h,0c0h,0ech,0ech,0ech,0dch,000h	; b910  ................
	defb 00eh,01bh,011h,01bh,03fh,03eh,03fh,01fh,019h,00ah,007h,003h,000h,000h,000h,000h	; b920  ....?>?.........
	defb 0c0h,000h,0c0h,0e0h,060h,070h,0f0h,0e0h,0c0h,080h,018h,010h,000h,000h,000h,000h	; b930  ....`p..........
	defb 000h,004h,00eh,004h,000h,001h,000h,000h,006h,004h,000h,000h,000h,000h,000h,000h	; b940  ................
	defb 000h,0c0h,000h,000h,000h,000h,000h,000h,000h,060h,020h,008h,000h,000h,000h,000h	; b950  .........` .....
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,001h,008h,00ch,00fh,001h,01eh,00fh	; b960  ................
	defb 000h,000h,000h,000h,000h,008h,000h,000h,000h,000h,0c0h,0e0h,0e0h,0e0h,058h,0b0h	; b970  ..............X.
	defb 01ch,032h,027h,02fh,01dh,019h,01eh,00eh,007h,001h,000h,000h,000h,000h,000h,000h	; b980  .2'/............
	defb 038h,04ch,0e4h,0f4h,0b8h,098h,078h,070h,0e6h,08eh,00ch,008h,000h,000h,000h,000h	; b990  8L....xp........
	defb 000h,00ch,018h,010h,000h,024h,020h,011h,008h,016h,031h,070h,060h,000h,000h,000h	; b9a0  .....$ ...1p`...
	defb 000h,030h,018h,008h,000h,024h,004h,088h,010h,060h,080h,000h,000h,000h,000h,000h	; b9b0  .0...$...`......
	defb 000h,000h,000h,000h,000h,000h,001h,000h,000h,008h,00eh,00fh,00fh,001h,01eh,01eh	; b9c0  ................
	defb 000h,000h,000h,000h,000h,000h,080h,000h,000h,010h,070h,0f0h,0f0h,0e0h,000h,000h	; b9d0  ..........p.....
	defb 01ch,032h,027h,02fh,01dh,018h,01eh,00dh,007h,011h,038h,03ch,01ch,000h,000h,000h	; b9e0  .2'/......8<....
	defb 038h,04ch,0e4h,0f4h,0b8h,018h,078h,0b0h,0e6h,08eh,00ch,008h,000h,000h,000h,000h	; b9f0  8L....x.........
	defb 000h,00ch,018h,010h,000h,025h,020h,012h,008h,006h,001h,000h,000h,000h,000h,000h	; ba00  .....% .........
	defb 000h,030h,018h,008h,000h,0a4h,004h,048h,010h,060h,080h,000h,000h,000h,000h,000h	; ba10  .0.....H.`......
	defb 000h,000h,000h,000h,000h,000h,001h,000h,000h,008h,006h,003h,003h,007h,000h,000h	; ba20  ................
	defb 000h,000h,000h,000h,000h,000h,080h,000h,000h,010h,070h,0f0h,0f0h,080h,078h,078h	; ba30  ..........p...xx
	defb 01ch,038h,03fh,02fh,00fh,01fh,01fh,00fh,007h,010h,030h,070h,060h,000h,000h,000h	; ba40  .8?/......0p`...
	defb 038h,01ch,0fch,0f4h,0f0h,0f8h,0f8h,0f0h,0e6h,00eh,00ch,008h,000h,000h,000h,000h	; ba50  8...............
	defb 000h,006h,000h,010h,010h,020h,020h,010h,008h,017h,030h,070h,060h,000h,000h,000h	; ba60  .....  ...0p`...
	defb 000h,060h,000h,008h,008h,004h,004h,008h,016h,0eeh,00ch,008h,000h,000h,000h,000h	; ba70  .`..............
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,008h,00fh,00fh,00fh,007h,000h,000h	; ba80  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,010h,0f0h,0f0h,0f0h,080h,078h,078h	; ba90  ..............xx
	defb 01ch,038h,01fh,00fh,00fh,01fh,01fh,00fh,007h,010h,030h,030h,010h,000h,000h,000h	; baa0  .8........00....
	defb 038h,01ch,0f8h,0f0h,0f0h,0f8h,0f8h,0f0h,0e6h,00eh,00ch,008h,000h,000h,000h,000h	; bab0  8...............
	defb 000h,006h,020h,030h,010h,020h,020h,010h,008h,007h,000h,000h,000h,000h,000h,000h	; bac0  .. 0.  .........
	defb 000h,060h,004h,00ch,008h,004h,004h,008h,010h,0e0h,000h,000h,000h,000h,000h,000h	; bad0  .`..............
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,008h,00fh,00fh,00fh,001h,01eh,01eh	; bae0  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,010h,0f0h,0f0h,0f0h,0e0h,000h,000h	; baf0  ................
	defb 002h,000h,000h,000h,000h,000h,000h,000h,001h,003h,001h,00eh,01eh,001h,000h,000h	; bb00  ................
	defb 0aah,010h,0a8h,040h,020h,000h,060h,0f8h,0fdh,0ddh,0aeh,0abh,0f1h,0fbh,0feh,070h	; bb10  ...@ .`........p
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,010h,000h,000h,000h,000h	; bb20  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,002h,002h,000h,004h,00eh,004h,000h,000h	; bb30  ................
	defb 000h,000h,000h,000h,000h,000h,078h,078h,020h,01ch,03eh,021h,0c1h,0deh,0ech,0c0h	; bb40  ......xx .>!....
	defb 000h,000h,000h,000h,000h,010h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; bb50  ................
	defb 002h,000h,000h,000h,000h,000h,000h,000h,001h,003h,005h,00eh,006h,001h,000h,000h	; bb60  ................
	defb 0aah,040h,0a8h,010h,020h,000h,060h,0f8h,0fdh,0adh,0deh,0abh,0f1h,0fbh,0feh,070h	; bb70  .@.. .`........p
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,008h,000h,000h,000h,000h,000h	; bb80  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,002h,002h,000h,004h,00eh,004h,000h,000h	; bb90  ................
	defb 000h,000h,000h,000h,000h,020h,070h,0e0h,040h,03ch,032h,0d1h,0d9h,0deh,0dch,000h	; bba0  ..... p.@<2.....
	defb 000h,000h,000h,000h,000h,010h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; bbb0  ................

; ======================================================================
; CODIGO 0xbbc0..0xbbdf  (31 bytes)
; ======================================================================


hay_0f:		; Z si alguna de las cuatro casillas de la pieza HL es la 0x0F
	call 0004ah		;bbc0   ; RDVRM
	cp 00fh		;bbc3
	ret z			;bbc5
	inc hl			;bbc6
	call 0004ah		;bbc7   ; la de la derecha
	cp 00fh		;bbca
	ret z			;bbcc
	call abajo1		;bbcd   ; abajo
	call 0004ah		;bbd0
	cp 00fh		;bbd3
	ret z			;bbd5
	dec hl			;bbd6   ; abajo a la izquierda
	call 0004ah		;bbd7
	cp 00fh		;bbda
	ret z			;bbdc
	xor a			;bbdd   ; ninguna: A = 0
	ret			;bbde

; ----------------------------------------------------------------------
; DATOS mapas_29: Los mapas de las fases 29 a 35
;   0xbbdf..0xbd3a  (347 bytes)
DATA_mapas_29:
	defb 025h,0c8h,004h,000h,02dh,0a8h,021h,0ebh,06ch,0a0h,008h,0bah,02bh,000h,002h,088h	; bbdf  %...-.!.l...+...
	defb 030h,0a8h,021h,088h,0f0h,006h,008h,00ch,00eh,012h,0f1h,0b1h,0c3h,0f5h,029h,059h	; bbef  0.!...........)Y
	defb 089h,0f9h,0b6h,0a7h,0d9h,0fah,0d6h,0fbh,0a0h,061h,0e1h,052h,043h,0e5h,0fch,050h	; bbff  .........a.RC..P
	defb 084h,0ffh,028h,0c0h,009h,0cch,028h,086h,000h,0e8h,02ah,0adh,008h,0c1h,07bh,09ch	; bc0f  ..(...(...*...{.
	defb 011h,0c8h,011h,0c8h,004h,082h,0f0h,00ah,0f1h,013h,022h,0f5h,007h,017h,0d8h,0fah	; bc1f  ..........".....
	defb 092h,084h,069h,0fbh,060h,091h,0a1h,0fch,040h,023h,0c3h,0a4h,086h,077h,0ffh,02ah	; bc2f  ..i.`...@#...w.*
	defb 0aah,02ah,0aah,02ah,0aah,028h,08ah,020h,082h,023h,0e2h,002h,0a0h,002h,0a0h,0f0h	; bc3f  .*.*.(. .#......
	defb 000h,002h,00ah,0f1h,021h,041h,061h,081h,0a1h,0c1h,0e1h,0f5h,066h,067h,076h,086h	; bc4f  ....!Aa.....fgv.
	defb 087h,0f9h,016h,034h,053h,078h,093h,0b4h,0d6h,0fbh,020h,060h,0a0h,0e0h,0fch,040h	; bc5f  ...4Sx.... `...@
	defb 080h,0c0h,0ffh,000h,000h,02ah,0ebh,020h,082h,03bh,0ceh,000h,000h,03bh,0dch,022h	; bc6f  .....*. .;...;."
	defb 090h,022h,0c5h,03eh,0e0h,0f0h,006h,00ah,0f1h,034h,094h,0f5h,019h,060h,0e5h,0f6h	; bc7f  .".>.....4...`..
	defb 0a1h,0a8h,0f9h,059h,0fah,052h,0b2h,0c6h,0e0h,0e9h,0fbh,036h,086h,0a7h,0fch,032h	; bc8f  ...Y.R.....6...2
	defb 050h,080h,082h,0d7h,0ffh,000h,000h,031h,0c6h,018h,08ch,00dh,0d8h,000h,000h,000h	; bc9f  P......1........
	defb 000h,00dh,0d8h,018h,08ch,031h,0c6h,0f0h,004h,008h,00ah,00eh,012h,0f1h,035h,0a5h	; bcaf  .....1........5.
	defb 0f5h,034h,050h,097h,0a4h,0f9h,008h,019h,080h,093h,0fah,053h,0d9h,0e8h,0fbh,010h	; bcbf  .4P........S....
	defb 056h,060h,0d0h,0e1h,0fch,001h,096h,0ffh,000h,000h,027h,0eah,025h,0cah,020h,082h	; bccf  V`........'.%. .
	defb 03dh,0deh,001h,0c0h,02fh,0c2h,020h,0eah,03fh,082h,0f1h,071h,074h,0f5h,033h,096h	; bcdf  =.../. .?..qt.3.
	defb 0d9h,0f6h,0a1h,0a7h,0f9h,006h,023h,0b6h,043h,067h,069h,083h,0d5h,0fah,063h,0b3h	; bcef  ......#.Cgi...c.
	defb 0fbh,080h,0e1h,0fch,010h,0b0h,0ffh,020h,0c4h,02eh,0c4h,022h,094h,020h,0e0h,000h	; bcff  ....... ...". ..
	defb 083h,07ch,000h,010h,0cbh,014h,0b8h,014h,000h,004h,088h,0f0h,006h,00ah,00eh,0f1h	; bd0f  .|..............
	defb 067h,082h,0f5h,069h,094h,006h,0f6h,0a3h,0f9h,030h,0b5h,0fah,074h,057h,0a8h,0d3h	; bd1f  g..i.....0..tW..
	defb 0fbh,050h,087h,0a0h,0d1h,0d5h,042h,0fch,053h,0d6h,0ffh	; bd2f  .P....B.S..

; ----------------------------------------------------------------------
; DATOS sprites_datos2: Mas dibujos de los sprites: los del golpe (0xB8), los
;   puntos (0xC8-0xD4)...
;   0xbd3a..0xbec0  (390 bytes)
DATA_sprites_datos2:
	defb 024h,018h,018h,024h,042h,081h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; bd3a  $..$B...........
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,018h,03ch,07eh,07fh,03fh,01eh,00ch	; bd4a  ..........<~.?..
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,018h,03ch,07eh,0feh,0fch,078h,030h	; bd5a  ..........<~..x0
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; bd6a  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; bd7a  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,008h,01ch,03eh	; bd8a  ...............>
	defb 07fh,0feh,0fch,078h,030h,000h,000h,000h,000h,000h,000h,000h,000h,000h,030h,078h	; bd9a  ...x0.........0x
	defb 0fch,0feh,07eh,03eh,01ch,008h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; bdaa  ..~>............
	defb 000h,000h,000h,000h,000h,000h,0e0h,0e0h,0f3h,0fch,070h,070h,070h,000h,000h,000h	; bdba  ..........ppp...
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; bdca  ................
	defb 000h,000h,000h,000h,000h,000h,01eh,0feh,0feh,0f8h,010h,010h,020h,020h,000h,000h	; bdda  ............  ..
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; bdea  ................
	defb 000h,000h,000h,000h,000h,000h,00eh,00eh,00eh,01fh,0e7h,007h,007h,000h,000h,000h	; bdfa  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; be0a  ................
	defb 000h,000h,000h,000h,000h,000h,020h,020h,010h,0f0h,0feh,0feh,01eh,000h,000h,000h	; be1a  ......  ........
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; be2a  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,031h,06bh,06bh,06bh,06bh,06bh	; be3a  ..........1kkkkk
	defb 06bh,031h,000h,000h,000h,000h,000h,000h,000h,000h,080h,040h,040h,040h,040h,040h	; be4a  k1.........@@@@@
	defb 040h,080h,000h,000h,000h,000h,000h,000h,000h,000h,000h,001h,000h,000h,000h,000h	; be5a  @...............
	defb 000h,001h,000h,000h,000h,000h,000h,000h,000h,000h,0c6h,0cdh,0cdh,0cdh,0cdh,0cdh	; be6a  ................
	defb 0cdh,0e6h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; be7a  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,00fh,00ch,00ch,00eh,001h,001h	; be8a  ................
	defb 001h,00eh,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; be9a  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,006h,00eh,006h,006h,006h,006h	; beaa  ................
	defb 006h,00fh,000h,000h,000h,000h	; beba

; ----------------------------------------------------------------------
; DATOS mapas_36: Los mapas de las fases 36 a 41
;   0xbec0..0xc000  (320 bytes)
DATA_mapas_36:
	defb 008h,088h,008h,088h,008h,088h,02ah,0aah,01ch,09ch,008h,088h,001h,0c0h,00ah,0a8h	; bec0  ......*.........
	defb 000h,080h,000h,080h,0f0h,006h,00ah,00ch,00eh,010h,012h,0f1h,036h,074h,0b6h,0f5h	; bed0  ............6t..
	defb 039h,052h,059h,092h,099h,0f9h,038h,054h,063h,0b8h,0a7h,0fah,094h,0c7h,0fbh,014h	; bee0  9RY...8Tc.......
	defb 025h,027h,058h,083h,0a5h,0fch,045h,098h,0d4h,0ffh,000h,000h,01fh,0ech,010h,084h	; bef0  %'X...E.........
	defb 017h,0e4h,014h,0c4h,011h,094h,017h,0e4h,010h,084h,01fh,0ech,0f1h,071h,078h,0f5h	; bf00  .............qx.
	defb 040h,0a0h,0a9h,0f6h,0a1h,0a3h,0a6h,0a8h,0f9h,008h,064h,067h,0d1h,0c9h,0fah,018h	; bf10  @.........dg....
	defb 029h,087h,0b5h,0fbh,020h,0c0h,0e1h,082h,085h,0fch,034h,062h,0ffh,000h,000h,007h	; bf20  )... .....4b....
	defb 0e0h,030h,096h,025h,0d4h,024h,084h,025h,0d4h,030h,096h,007h,0e0h,004h,090h,0f0h	; bf30  .0.%.$.%.0......
	defb 002h,006h,00ah,00eh,0f1h,053h,055h,084h,0f5h,034h,079h,0e4h,0f6h,0a1h,0a7h,0f9h	; bf40  .....SU..4y.....
	defb 032h,049h,095h,0fah,046h,062h,0a9h,0e6h,0fbh,040h,042h,066h,074h,0e2h,0fch,036h	; bf50  2I..Fb...@Bft..6
	defb 093h,0a0h,0a4h,0ffh,000h,000h,03dh,0deh,020h,082h,024h,092h,000h,000h,00fh,0e8h	; bf60  ......=. .$.....
	defb 008h,088h,028h,08ah,03dh,0deh,0f0h,002h,006h,010h,0f1h,0a5h,0f5h,072h,009h,0e9h	; bf70  ..(.=........r..
	defb 0f6h,0a5h,0f9h,020h,080h,067h,0fah,027h,087h,069h,0c9h,0c7h,0fbh,060h,0c0h,051h	; bf80  ... .g.'.i...`.Q
	defb 0c2h,0fch,022h,091h,029h,089h,0ffh,008h,000h,02ah,0a0h,03ah,0eeh,003h,088h,060h	; bf90  ..".)....*.:...`
	defb 08ah,02ah,0bbh,02ah,0a0h,00bh,0adh,03ah,088h,0f0h,004h,006h,008h,00ah,00eh,0f1h	; bfa0  .*.*...:........
	defb 048h,054h,087h,0d3h,0f5h,034h,090h,098h,0f9h,045h,0b9h,059h,078h,0b1h,0d7h,0fah	; bfb0  HT...4...E.Yx...
	defb 017h,025h,065h,0a4h,0fbh,013h,085h,0a7h,0fch,006h,050h,093h,0ffh,000h,000h,030h	; bfc0  .%e.......P....0
	defb 086h,020h,082h,000h,000h,000h,000h,000h,000h,000h,000h,020h,082h,030h,086h,0f3h	; bfd0  . ......... .0..
	defb 060h,069h,0f5h,022h,027h,065h,074h,0c2h,0c7h,0f9h,035h,046h,057h,068h,0fah,078h	; bfe0  `i."'et...5FWh.x
	defb 087h,096h,0a5h,075h,0fbh,071h,082h,093h,0a4h,0fch,034h,043h,052h,061h,064h,0ffh	; bff0  ...u.q....4CRad.
