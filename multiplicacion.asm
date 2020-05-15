CPU "8085.TBL"
HOF "INT8"
ORG 1000h

 
       LDA 1800H   ; (1800) -> A   |
       MOV B,A     ; A -> B        |  CARGA UNO DE LOS DOS NUMEROS
       LDA 1801H   ; (1801) -> A   |  DE LA MULTIPLICACION QUE VA A
       MOV C,A     ; A -> C        |  SERVIR DE CONTADOR

       LDA 1900H   ; (1900) -> A   | 
       MOV D,A     ; A -> D        |  CARGA EL OTRO NUMERO DE LA MULT.
       LDA 1901H   ; (1901) -> A   |  QUE VA A SER EL SUMANDO
       MOV E,A     ; A -> E        |
      
       MVI H, 00h  ; 00H -> H      |  PONEMOS A 0 EL RESULTADO DE LA
       MVI L, 00h  ; 00H -> L      |  MULT.

       XRA A       ; 00H -> A      |
       STA 1700h   ; A -> (1700)   |  PONEMOS A 0 EL ACARREO DEL 
       XRA A       ; 00H -> A      |  RESULTADO QUE VENDRA EN ESTA
       STA 1701h   ; A -> (1701)   |  POSICION DE MEMORIA

MULT:  DAD D       ; HL+DE -> HL   |  SUMA Y SE DEJA EN EL RESULTADO

       JNC SALTO   ; SI NO ACARREO SALTO

       LDA 1701h   ; (1701) -> A   |  SI HAY ACARREO SE SUMA UNO A LA 
       INR A       ; A+1 -> A      |  POSICION DE MEMORIA DEL ACARR.
       STA 1701h   ; A -> 1701H    |  DE MENOR PESO
 
       CPI 00h     ; A-00H         |  LA ANTER. OPER. NO AFECTA AL 
                                   |  INDIC. DEL ACARR. CON ESTA OPER.
                                   |  AFECTA IND. CERO Y VEMOS SI ACARR

       JNZ SALTO   ; SI NO CERO SALTO  | SI NO CERO (ACARR) SALTO

       LDA 1700h   ; (1700) -> A   |  SI HAY ACARR. SE SUMA UNO A LA
       INR A       ; A+1 -> A      |  POS. DE MEM. DE MAYOR PESO
       STA 1700h   ; A -> (1700)   |

SALTO: DCX B       ; BC-1 -> BC    |  SE DECREMENTA UNO EL CONTADOR

       XRA A       ; 00H -> A          |  COMPARACION 00 B
       CMP B       ; COMPARACION B 00H |

       JNZ MULT    ; SI NO CERO MULT   |  SI EL CONTADOR DE MYOR PESO
                                       |  NO ESTA A 00 IR A MULT
  
       XRA A       ; 00H -> A          |  COMPARACION 00 C
       CMP C       ; COMPARACION C 00H |

       JNZ MULT    ; SI NO CERO MULT   |  SI EL CONTADOR DE MNOR PESO
                                       |  NO ESTA A 00 IR A MULT

       JZ FINAL    ; SI CERO FINAL     |  SI EL CONTADOR DE MNOR PESO
                                       |  ESTA A 00 IR A FINAL

FINAL: MOV A, H    ; H -> A       |
       STA 1702h   ; A -> (1702)  |  ALMACENAR EL RESULT. NO EL ACARR.
       MOV A, L    ; L -> A       |  QUE ESTA YA ALMACENADO
       STA 1703h   ; A -> (1703)  |

       END
        

;  MULTIPLICACION DE 16 BITS
;
;  LOS ELEMENTOS DE LA MULTIPLICACION ESTA EN LAS POS. MEM. 1900-01H Y  
;  1800-01H EL RESULT. SE DEJA EN 1700-01-02-03 (LA DOS PRIMERAS POS.
;  MEM. SON PARA EL ACARREO DEL RESULTADO 
;
;  EJEM: 1234H * 4321H = 4C5F4B4
;
;  OBS: TENER CUIDADO AL INTRODUCIR LOS DATOS CON LOS ELEM. DE MAYOR Y
;       MENOR PESO