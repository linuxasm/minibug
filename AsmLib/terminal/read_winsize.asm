
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

;  extern kbuf
  extern ascii_to_dword
;  extern lib_buf
  extern sys_open
  extern delay
  extern poll_fd
  extern signal_mask_block
  extern signal_mask_unblock

struc wnsize_struc
.ws_row:resw 1
.ws_col:resw 1
.ws_xpixel:resw 1
.ws_ypixel:resw 1
endstruc
;wnsize_struc_size

struc termio_struc
.c_iflag: resd 1
.c_oflag: resd 1
.c_cflag: resd 1
.c_lflag: resd 1
.c_line: resb 1
.c_cc: resb 19
endstruc
;termio_struc_size:
    
;>1 terminal
;   read_winsize_0 - save stdin window size
; INPUTS
;    edx = ptr to winsize struc, size = 8 bytes
;   
;    struc wnsize_struc
;    .ws_row:resw 1
;    .ws_col:resw 1
;    .ws_xpixel:resw 1
;    .ws_ypixel:resw 1
;    endstruc
;    wnsize_struc_size
; OUTPUT
;    structure at edx filled in
; NOTES
;    source file /xterm/read_winsize.asm
;
;<
;  * ---------------------------------------------------
;*******
    
;>1 terminal
;   read_winsize_x - read (fd) window size
; INPUTS
;    ebx = fd (file descriptor) of terminal
;    edx = ptr to winsize struc, size = 8 bytes
;   
;    struc wnsize_struc
;    .ws_row:resw 1
;    .ws_col:resw 1
;    .ws_xpixel:resw 1
;    .ws_ypixel:resw 1
;    endstruc
;    wnsize_struc_size
; OUTPUT
;   structure at edx filled in
; NOTES
;    source file /xterm/read_winsize.asm
;
;<
;  * ---------------------------------------------------
;*******
  extern term_type

  global read_winsize_0
  global read_winsize_x
read_winsize_0:
  xor	ebx,ebx		;get code for stdin
read_winsize_x:
  mov	ecx,5413h
; mov edx,winsize
  mov	eax,54
  int	80h
  ret

;-------------------------------------------------------
    
;>1 terminal
;   isatty - check if fd is a tty
; INPUTS
;    ebx = fd to check    
; OUTPUT
;  if jns (then) is a tty 
;  if js (then) not a tty
; NOTES
;<
;-------------------------------------------------------
; input: ebx = fd to check
;        flags set js (not tty) jns (is tty)
  global isatty
isatty:
  mov eax,54
  mov	ecx,5401h
  mov	edx,key_buf
  int	80h
  or	eax,eax
  ret
;-------------------------------------------------
;sets tty_fd to 0 or x, 0=stdin
open_readonly_tty:
  cmp	[tty_readonly_fd],byte 2
  ja	ot_exit		;exit if already open
  mov	ebx,tty_dev
  mov	ecx,0		;mode = read only
  mov	edx,0666h	;premissions
  call	sys_open
  or	eax,eax
  js	ot_exit		;jmp if no /dev/tty
  mov	[tty_readonly_fd],eax
ot_exit:
  mov	ebx,[tty_readonly_fd]
  ret

;close tty if tty_fd not = 0
close_readonly_tty:
  mov	ebx,[tty_readonly_fd]
  cmp	ebx,dword 2
  jbe	ct_exit		;jmp if tty ok
  mov	[tty_readonly_fd],dword 01
  mov	eax,6		;close
  int	byte 80h
ct_exit:
  ret
;-----------------
  [section .data]
tty_readonly_fd: dd 0	;default is stdin
tty_dev	db '/dev/tty',0
  [section .text]
;-------------------------------------

    
;>1 terminal
;   read_window_size - set global window size info
; INPUTS
;    none                 
; OUTPUT
;  if jns (then)
;  edx = pointer to structure as follows:
;    [crt_rows]      dword       number of rows on terminal
;    [crt_columns]   dword       number of columns on terminal
;    [root_pix_rows] dword       height in pixels, x root window
;    [root_pix_cols] dword       width  in pixels, x root window
;  if js (then) error, edx points to empty struc
; NOTES
;<

  global read_window_size
read_window_size:
  call	open_readonly_tty	;returns tty in ebx
rws_x2:
  mov	ecx,request
  call	terminal_report ;input ebx=tty fd
  or	eax,eax		;any errors?
  js	rws_exit	;jmp if error
  mov	esi,key_buf+2
  call	ascii_to_dword
  jecxz	rws_exit   	;jmp if error
  mov	[crt_rows],ecx
  call	ascii_to_dword
  mov	[crt_columns],ecx
  xor	eax,eax		;clear sign
;this is a x_window
rws_exit:
  pushf
  call	close_readonly_tty	;if non-zero, close
  mov	edx,crt_rows
  popf
  ret
;----------------------
  [section .data]
;win_size:  times 8 db 0

global crt_rows,crt_columns

crt_rows	dd 0 ; value  number of rows on terminal
crt_columns	dd 0 ; number of columns on terminal
root_pix_rows	dd 0 ; height in pixels, x root window
root_pix_cols	dd 0 ; width  in pixels, x root window
                dd 0,0
request: db 1bh,'[r'
	db  1bh,'[999;999H'
	db  1bh,'[6n',0
key_buf times 12 db 0
  [section .text]
;--------------------------------------------
; input:  ecx = string ptr
; output: key_buf has report if eax=0 or positive
;
terminal_report:
  push	ecx
  call	raw_set1
;we block SIGIO incase it is connected to tty
;and resulting signal will read data before we
;get to it.
  mov	ecx,signal_block_mask
  call	signal_mask_block
  pop	ecx
  call	write_tty_string		;send string
  mov	ecx,20
gr_loop:
  push	ecx
  mov	eax,10
  call	delay
  mov	eax,[tty_readonly_fd]
  mov	edx,2			;milisecond wait
  call	poll_fd
  pop	ecx
  jnz	gr_ready
  loop	gr_loop			;keep waiting
  xor	eax,eax
  dec	eax			;set fail code (-1)
  jmp	short gr_exit
;a key is ready
gr_ready:
  mov	ecx,key_buf
  mov	eax,3
  mov	ebx,[tty_readonly_fd]
  mov	edx,20
  int	byte 80h	;read tty	
gr_exit:
  push	eax
  call	raw_unset1
  mov	ecx,signal_block_mask
  call	signal_mask_unblock
  pop	eax
  ret

;------------------------------
raw_set1:
  mov	ebx,[tty_readonly_fd]
  mov	ecx,5401h
  mov	edx,t_buf1
  mov eax,54
  int	80h

  mov	ebx,[tty_readonly_fd]
  mov	ecx,5401h
  mov	edx,t_buf2
  mov eax,54
  int	80h

  and	byte [edx + termio_struc.c_lflag],~0bh ;set raw mode
  or	byte [edx + termio_struc.c_iflag +1],01 ;
  and	byte [edx + termio_struc.c_iflag+1],~14h ;disable IXON,IXOFF
  mov	ebx,[tty_readonly_fd]
  mov	ecx,5402h
  mov	eax,54
  int	80h
  ret  

raw_unset1:
  mov	ebx,[tty_readonly_fd]
  mov	ecx,5402h
  mov	edx,t_buf1
  mov	eax,54
  int	80h
  ret  
;-----------------
  [section .data]
signal_block_mask: dd 0ff000000h ;block common signals
t_buf1:	times 70 db 0
t_buf2:	times 70 db 0
  [section .text]
;-------------------------------------
;ecx=string
write_tty_string:
  xor edx, edx
.count_again:	
  cmp [ecx + edx], byte 0x0
  je .done_count
  inc edx
  jmp .count_again
.done_count:	
  mov eax, 0x4			; system call 0x4 (write)
  mov ebx, 2			;write to stderr
  int 0x80
  ret

    
  [section .text]
;-------------------------------------
