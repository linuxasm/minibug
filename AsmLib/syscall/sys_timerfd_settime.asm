;--------------------------------------------------------------
;>1 syscall
; sys_timerfd_settime - kernel function                     
;
;    INPUTS 
;     see AsmRef function -> sys_timerfd_settime                                 
;
;    Note: functon call consists of four instructions
;          
;          sys_timerfd_settime:                              
;              mov  eax,325    
;              int  byte 80h
;              or   eax,eax
;              ret
;<;
;------------------------------------------------------------------
  [section .text align=1]

  global sys_timerfd_settime
sys_timerfd_settime:
	mov	eax,325
	int	byte 80h
	or	eax,eax
	ret