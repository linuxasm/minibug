;--------------------------------------------------------------
;>1 syscall
; sys_signalfd4 - kernel function                           
;
;    INPUTS 
;     see AsmRef function -> sys_signalfd4                                       
;
;    Note: functon call consists of four instructions
;          
;          sys_signalfd4:                                    
;              mov  eax,327    
;              int  byte 80h
;              or   eax,eax
;              ret
;<;
;------------------------------------------------------------------
  [section .text align=1]

  global sys_signalfd4
sys_signalfd4:
	mov	eax,327
	int	byte 80h
	or	eax,eax
	ret