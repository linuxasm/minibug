
;   Copyright (C) 2007 Jeff Owens
;
;   This program is free software: you can redistribute it and/or modify
;   it under the terms of the GNU General Public License as published by
;   the Free Software Foundation, either version 3 of the License, or
;   (at your option) any later version.
;
;   This program is distributed in the hope that it will be useful,
;   but WITHOUT ANY WARRANTY; without even the implied warranty of
;   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;   GNU General Public License for more details.
;
;   You should have received a copy of the GNU General Public License
;   along with this program.  If not, see <http://www.gnu.org/licenses/>.


  [section .text align=1]

  [section .text]
    
;>1 crt
;   reset_soft - terminal soft reset
; INPUTS
;    none
; OUTPUT
;   none
; NOTES
;    source file reset_soft.asm
;<
;  * ---------------------------------------------------
;*******
  extern crt_str

  global reset_soft
reset_soft:
  mov	ecx,strings
  call	crt_str
  ret

  [section .data]
strings:
 db 1bh,'[!p'	;soft reset
 db 1bh,'[?4l' ;normal scroll
 db 1bh,'[4l'	;replace mode
 db 1bh,'>'	;normal keypad
 db 1bh,'[0m'	;default color
 db 1bh,'[H'	;move cursor to 1;1
 db 1bh,'[r'	;default scroll region
 db 1bh,'(B'	;G0 char set = ascii
 db 1bh,')0'	;G1 char set = draw
 db 0fh		;enable G0 char set
 db 1bh,'[2J'	;clear screen
 db 0

  [section .text]

;esc [!p 	soft reset
;esc [?3;4l  	80 column, normal scroll
;esc [4l	replace mode
;esc >		normal keypad
