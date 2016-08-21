
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
;----------------------------------------------------------
;>1 sound
;  metronome - repeat tone until done or key press
; INPUTS
;    esi = ptr to control block
;       dd tone frequency
;       dd tone length in ms
;       dd repeat every xx ms
;       dd repeat xx times
; OUTPUT:
;    eax = negative if parameter error
; NOTES
;   source file: metronome.asm
;<
; * ----------------------------------------------
  extern get_raw_time
  extern make_sound
  extern key_poll
  extern raw_set1,raw_unset1
  extern delay

  global metronome
metronome:
  call	raw_set1
  mov	edi,local_block
  movsd
  movsd
  movsd
  movsd
  mov	eax,-3
  call	delay			;wait 3 seconds

  call	get_raw_mili_seconds
  mov	[ms_time_next_tone],eax

tone_loop:
  mov	ebx,[tone]		;freq
  mov	eax,[tone_len]		;lenght ms
  call	make_sound
  call	key_poll		;was key pressed
  jnz	m_exit			;exit if key pressed
;compute next tone time
  mov	eax,[repeat_rate]
  add	[ms_time_next_tone],eax ;next tone time
delay_loop:
  call	get_raw_mili_seconds
  cmp	eax,[ms_time_next_tone]
  jb	delay_loop		;loop till time elapsed
;check if all tones sounded
  dec	dword [repeat_count]
  jnz	tone_loop		;jmp if more tones to sound
m_exit:
  call	raw_unset1
  ret

;------------
  [section .data]
local_block:
tone:         dd 0	;tone frequency
tone_len:     dd 0	;tone length in ms
repeat_rate   dd 0	;repeat every xx ms
repeat_count  dd 0	;repeat xx times

ms_time_next_tone: dd 0
  [section .text]

;----------------------------------------------------------
; inputs: none:
; output: eax = millisecond counter
;
get_raw_mili_seconds:
  call	get_raw_time	;eax=seconds ebx=micro seconds
  mov	ecx,[grm_sec]
  or	ecx,ecx		;initialized?
  jnz	grm_05		;jmp if initialized already
  mov	[grm_sec],eax	;save seconds

grm_05:
  sub	eax,[grm_sec]	;compute base seconds
;multilpy seconds by 1000 to get miliseconds
  mov	ecx,1000
  mul	ecx		;compute miliseconds
  push	eax		;save ms
;convert micro seconds from raw_time to miliseconds
  xor	edx,edx
  cmp	ebx,ecx		;check if 0 miliseconds
  ja	grms_10		;jmp if 1+ miliseconds
  pop	eax
  jmp	grms_exit	;exit if no miliseconds

grms_10:
  mov	eax,ebx		;get raw micro seconds
  div	ecx		;convert to miliseconds
;
  pop	edx  
  add	eax,edx		;add in current mili seconds
grms_exit:
  ret
;--------------
  [section .data]
grm_sec:	dd 0	;initial second count
  [section .text]  
;----
