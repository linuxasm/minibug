;--------------------------------------------------------------
;>1 syscall
; sys_inotify_init1 - kernel function                       
;
;    INPUTS 
;     see AsmRef function -> sys_inotify_init1                                   
;
;    Note: functon call consists of four instructions
;          
;          sys_inotify_init1:                                
;              mov  eax,332    
;              int  byte 80h
;              or   eax,eax
;              ret
;<;
;------------------------------------------------------------------
  [section .text align=1]

  global sys_inotify_init1
sys_inotify_init1:
	mov	eax,332
	int	byte 80h
	or	eax,eax
	ret