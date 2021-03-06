;
; Der Langrisser Window Patches
;
; This files contains Super Nintendo code for repositioning and resizing
; all the menus and windows in Der Langrisser's user interface.
;
; Version:   1.0
; Author:    byuu
; Copyright: (c) 2006, 2016 DL Team
; Website:   https://github.com/sobodash/derlangrisser/
; License:   BSD License <http://opensource.org/licenses/bsd-license.php>
;

lorom

; ----------------------------------------------------------------------------
; Primary Windows

; Name entry window (cannot be x,y repositioned)
org $01dee6 : lda #$0f ; height
org $01defa : lda #$0f ; height

; Window color
org $00fba5 : dw $3063

; Enemy's () unit.
org $03895e : lda #$0b
org $038962 : lda #$11
org $038966 : lda #$14
org $038948 : lda #$14

; NPC's () unit.
org $0388fd : lda #$0b
org $038901 : lda #$11
org $038905 : lda #$14
org $0388e7 : lda #$14

; Turn ended for () unit.
org $0389cb : lda #$05
org $0389cf : lda #$11
org $0389d3 : lda #$16
org $0389b5 : lda #$16

; Save Game?
org $03ba2e : lda #$0a
org $03ba32 : lda #$05
org $03ba36 : lda #$0a
org $03ba18 : lda #$0a

; Saved.
org $03bb53 : lda #$0d
org $03bb57 : lda #$05
org $03bb5b : lda #$06
org $03bb47 : lda #$06

; Yes/No
org $03ba7f : lda #$0e
org $03ba83 : lda #$08
org $03ba87 : lda #$06
org $03ba73 : lda #$06

; Yes/No
org $07db7d : ldx #$02
org $07db7f : ldy #$0b
org $07db85 : lda #$06
org $07db48 : lda #$06

; Yes/No ("Unable to equip, will you still purchase this?")
org $03f2b4 : lda #$15
org $03f2b8 : lda #$0b
org $03f2bc : lda #$06
org $03f2a8 : lda #$06

; This scenario has a forced arrangement.
org $03f39e : lda #$08
org $03f3a2 : lda #$05
org $03f3a6 : lda #$0f
org $03f392 : lda #$0f

; Which item will you discard?
org $03daab : lda #$04
org $03daaf : lda #$03
org $03dab3 : lda #$17
org $03da9f : lda #$17

; Press a button.
org $01eae3 : lda #$0a
org $01eae7 : lda #$05
org $01eaeb : lda #$0c
org $01ead7 : lda #$0c


; ----------------------------------------------------------------------------
; Magic List

org $039265 : lda #$04
org $039269 : lda #$04
org $03926d : lda #$0d
org $039259 : lda #$0d

; 12x12
org $0392f1 : lda #$05
org $0392f6 : lda #$05
org $0392fb : lda #$0b
org $039305 : lda #$0a ; Cursor position

; Not enough MP
org $039418 : lda #$10
org $03941c : lda #$0a
org $039420 : lda #$0c
org $03940c : lda #$0c


; ----------------------------------------------------------------------------
; Summon List

org $03982a : lda #$04
org $03982e : lda #$04
org $039832 : lda #$0d
org $03981e : lda #$0d
; 12x12

org $0398b8 : lda #$05
org $0398bd : lda #$05
org $0398c2 : lda #$0b
org $0398cc : lda #$0a ; Cursor position

; Not enough MP
org $0399d5 : lda #$10
org $0399d9 : lda #$0a
org $0399dd : lda #$0c
org $0399c9 : lda #$0c


; ----------------------------------------------------------------------------
; Features Select

org $21e034 : lda #$0a
org $21e038 : lda #$0a
org $21e03c : lda #$0c ; Width
org $21e024 : lda #$0c ; Width
org $21e030 : lda #$08 ; Height
org $21e028 : lda #$08 ; Height
org $21e075 : lda #$03 ; Menu option count

org $21e018 : lda.b #features_menu
org $21e01c : lda.b #features_menu>>8
org $21e020 : lda.b #features_menu>>16


; ----------------------------------------------------------------------------
; BGM/SFX/Battle Test

org $21e0fc : lda #$03
org $21e100 : lda #$05
org $21e104 : lda #$1a ; Width
org $21e0f0 : lda #$1a ; Width

;12x12
org $21e296 : lda #$04
org $21e29b : lda #$06
org $21e2a0 : lda #$18 ; Width
org $21e2aa : lda #$17 ; Cursor position

; Remove 8x8 numerical listing
org $21e729 : jsl setup_bgm_window : jmp $e793


; ----------------------------------------------------------------------------
; Introduction Text

; Move VRAM position of intro text from pixel 40 to 32 to allow centering
org $1bfaea
  lda #$84 : sta $7f7005
  lda #$05 : sta $7f7006


; ----------------------------------------------------------------------------
; Window Translucency Option

org $00c2d4 : db $83 ; Written to $2131 - add/sub mode
org $00c2b4 : jsl load_window_colors : jmp $c2c9

loadpc build/dl.xpc


; ----------------------------------------------------------------------------
; features_menu:
;
; Reprograms features menu to enable the dummied out Battle Test

features_menu:
  db $fa,$ff,$00,$21,$f1,$ff,$fc,$ff
  db $02,$fb,$ff,$02,$01,$ef,$ff,$53
  db $ee,$ff,$02,$00,$fe,$ff
  db $ee,$ff,$03,$00,$fe,$ff
  db $ee,$ff,$04,$00,$ff,$ff


; ----------------------------------------------------------------------------
; window_colors:
; 
; Turns the Text Speed option (no longer used) into a new Window Color option.
; * font12.asm disables text speed setting
; * window.asm enables window color setting
;
; $001a04 = Option 2 Default Setting
; #$01    = Remix Colors (left option)
; #$00    = Original Colors (right option)

load_window_colors() {
  lda $001a04 : bne load_window_colors_new

load_window_colors_old:
  lda window_colors_old+0,x : sta $2132
  lda window_colors_old+1,x : sta $2132
  lda window_colors_old+2,x : sta $2132
  rtl

load_window_colors_new:
  lda window_colors_new+0,x : sta $2132
  lda window_colors_new+1,x : sta $2132
  lda window_colors_new+2,x : sta $2132
  rtl
}

window_colors_old:
  db $30,$50,$81 ; Ally Window
  db $30,$4b,$8b ; NPC Window
  db $2d,$50,$87 ; Enemy Window

window_colors_new:
  db $3f,$4c,$80 ; Ally Window
  db $3b,$45,$9b ; NPC Window
  db $25,$4f,$8f ; Enemy Window

setup_bgm_window() {
  lda #$fff3 : sta $7f1003,x : inx #2
  lda #$fff8 : sta $7f1003,x : inx #2
  lda #$fff9 : sta $7f1003,x : inx #2
  lda #$fff0 : sta $7f1003,x : inx #2
  tya : sta $7f1003,x : inx #2
  lda #$fffe : sta $7f1003,x : inx #2
  iny
  inc $19
  dec $17
  bne setup_bgm_window
  rtl
}

savepc build/dl.xpc
