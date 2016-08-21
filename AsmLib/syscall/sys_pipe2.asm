;--------------------------------------------------------------
;>1 syscall
; sys_pipe2 - kernel function                               
;
;    INPUTS 
;     see AsmRef function -> sys_pipe2                                           
;
;    Note: functon call consists of four instructions
;          
;          sys_pipe2:                                        
;              mov  eax,331    
;              int  byte 80h
;              or   eax,eax
;              ret
;<;
;------------------------------------------------------------------
  [section .text align=1]

  global sys_pipe2
sys_pipe2:
	mov	eax,331
	int	byte 80h
	or	eax,eax
	ret