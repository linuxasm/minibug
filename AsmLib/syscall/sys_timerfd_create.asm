;--------------------------------------------------------------
;>1 syscall
; sys_timerfd_create - kernel function                      
;
;    INPUTS 
;     see AsmRef function -> sys_timerfd_create                                  
;
;    Note: functon call consists of four instructions
;          
;          sys_timerfd_create:                               
;              mov  eax,322    
;              int  byte 80h
;              or   eax,eax
;              ret
;<;
;------------------------------------------------------------------
  [section .text align=1]

  global sys_timerfd_create
sys_timerfd_create:
	mov	eax,322
	int	byte 80h
	or	eax,eax
	ret