;--------------------------------------------------------------
;>1 syscall
; sys_stat - kernel function                                
;
;    INPUTS 
;     ebx = ptr to name
;     ecx = buffer                                       
;
;    Note: functon call consists of four instructions
;          
;          sys_stat:                                         
;              mov  eax,106    
;              int  byte 80h
;              or   eax,eax
;              ret
;<;
;------------------------------------------------------------------
  [section .text align=1]

  global sys_stat
sys_stat:
	mov	eax,106
	int	byte 80h
	or	eax,eax
	ret