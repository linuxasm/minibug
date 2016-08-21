;--------------------------------------------------------------
;>1 syscall
; sys_eventfd2 - kernel function                            
;
;    INPUTS 
;     see AsmRef function -> sys_eventfd2                                        
;
;    Note: functon call consists of four instructions
;          
;          sys_eventfd2:                                     
;              mov  eax,328    
;              int  byte 80h
;              or   eax,eax
;              ret
;<;
;------------------------------------------------------------------
  [section .text align=1]

  global sys_eventfd2
sys_eventfd2:
	mov	eax,328
	int	byte 80h
	or	eax,eax
	ret