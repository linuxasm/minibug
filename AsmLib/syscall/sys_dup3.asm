;--------------------------------------------------------------
;>1 syscall
; sys_dup3 - kernel function                                
;
;    INPUTS 
;     see AsmRef function -> sys_dup3                                            
;
;    Note: functon call consists of four instructions
;          
;          sys_dup3:                                         
;              mov  eax,330    
;              int  byte 80h
;              or   eax,eax
;              ret
;<;
;------------------------------------------------------------------
  [section .text align=1]

  global sys_dup3
sys_dup3:
	mov	eax,330
	int	byte 80h
	or	eax,eax
	ret