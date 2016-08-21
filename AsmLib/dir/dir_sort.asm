
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
;%define DEBUG

  [section .text]  
  extern sort_merge

%ifdef DEBUG

  extern dir_open_indexed
  extern dir_close

 global _start
 global main
_start:
main:    ;080487B4
  cld
  mov	eax,bss_end
  mov	ebx,pathx
  call	dir_open_indexed
  call	dir_sort
  call	dir_close
  mov	eax,1
  int	80h

pathx: db '/usr/share/doc/',0

  [section .bss]
bss_end:
  [section .text]
%endif
;-------------------------------------------


struc dir_block
.handle			resd 1 ;set by dir_open
.allocation_end		resd 1 ;end of allocated memory
.dir_start_ptr		resd 1 ;ptr to start of dir records
.dir_end_ptr		resd 1 ;ptr to end of dir records
.index_ptr		resd 1 ;set by dir_index
.record_count		resd 1 ;set by dir_index
.work_buf_ptr		resd 1 ;set by dir_sort
dir_block_struc_size:
endstruc


;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -( SEARCH  )
;>1 dir
;  dir_sort - sort a opened and indexed directory
;  INPUTS
;     eax = ptr to dir_block with status of target dir
;
;  OUTPUT     eax = negative if error, else it contains
;                   a ptr to the following block.
;
;     struc dir_block
;      .handle			;set by dir_open
;      .allocation_end		;end of allocated memory
;      .dir_start_ptr		;ptr to start of dir records
;      .dir_end_ptr		;ptr to end of dir records
;      .index_ptr		;set by dir_index
;      .record_count		;set by dir_index
;      .work_buf_ptr		;set by dir_sort
;      dir_block_struc_size
;     endstruc
;
;  NOTE
;     source file is dir_open.asm
;     related functions are: dir_open - allocate memory & read
;                            dir_index - allocate memory & index
;                            dir_open_indexed - dir_open + dir_index
;                            dir_sort - allocate memory & sort
;                            dir_open_sorted - open,index,sort
;                            dir_close_file - release file
;                            dir_close_memory - release memory
;                            dir_close - release file and memory
;
;<
;  * ----------------------------------------------

  global dir_sort
dir_sort:
  cld
  mov	[dir_block_ptr],eax	;save dir block
;allocate memory for index
  mov	ecx,[eax + dir_block.record_count]
  shl	ecx,2			;compute total bytes in index
  mov	ebx,[eax + dir_block.allocation_end]
  add	ebx,ecx			;compute end of index
  add	ebx,8			;add extra memory

  mov	eax,45
  int	80h			;allocate memory
  or	eax,eax
  js	ds_error		;jmp if allocaton  error
  mov	edx,[dir_block_ptr]
  mov	[edx + dir_block.allocation_end],eax    
  mov	eax,edx			;set eax=dir_block
;setup for sort
  mov	ebp,[eax + dir_block.index_ptr]
  mov	ebx,20		;length of sort key
  mov	ecx,[eax + dir_block.record_count]
  xor	edx,edx		;starting column for sort
  call	sort_merge
ds_error:
  ret

;------------
  [section .data]
dir_block_ptr:	dd	0
  [section .text]
