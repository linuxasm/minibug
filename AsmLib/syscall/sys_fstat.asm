;--------------------------------------------------------------
;>1 syscall
; sys_fstat - kernel function                               
;
;    INPUTS 
;     ebx = ptr to name
;     ecx = buffer
;
;    Note: functon call consists of four instructions
;          
;          sys_fstat:                                        
;              mov  eax,108    
;              int  byte 80h
;              or   eax,eax
;              ret
;<;
;------------------------------------------------------------------
  [section .text align=1]

  global sys_fstat
sys_fstat:
	mov	eax,108
	int	byte 80h
	or	eax,eax
	ret