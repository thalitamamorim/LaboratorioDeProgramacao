; ==============================================================================
; Laboratório de Programação - 2026/1
; Sistema Especialista para Diagnóstico de Falhas Automotivas (Paradigma Funcional)
; Docente: Prof. Sofiane Ben El Hedi Labidi
; Alunos: Deborah Sophia, Samira Farias, Samuel Carvalho, Thalita Amorim
; ==============================================================================

; ==========================================================================
; Base de conhecimento
; Cada falha possui:
; (nome_da_falha (lista_de_sintomas) "acao recomendada")
; ==========================================================================

(defparameter *falhas*
  '(
    (bateria_descarregada
      (motor_nao_liga luz_bateria_acesa motor_gira_lento)
      "Verificar bateria, cabos e terminais.")

    (alternador_defeituoso
      (luz_bateria_acesa motor_gira_lento)
      "Verificar alternador e sistema de carga.")

    (motor_arranque_defeituoso
      (motor_nao_liga motor_gira_lento ruido_metalico)
      "Verificar motor de arranque.")

    (superaquecimento_motor
      (superaquecimento fumaca_branca)
      "Verificar radiador, liquido de arrefecimento e junta do cabecote.")

    (falha_injecao_eletronica
      (luz_injecao_acesa motor_falhando consumo_alto cheiro_combustivel)
      "Verificar sensores, bicos injetores e modulo de injecao.")

    (falha_ignicao
      (motor_falhando consumo_alto)
      "Verificar velas, cabos e bobinas.")

    (vazamento_combustivel
      (cheiro_combustivel consumo_alto)
      "Verificar mangueiras, conexoes e bomba de combustivel.")
   ))

; ==========================================================================
; Funcoes auxiliares
; ==========================================================================

(defun nome-falha (falha)
  (first falha))

(defun sintomas-falha (falha)
  (second falha))

(defun acao-falha (falha)
  (third falha))

; ==========================================================================
; Conta, de forma recursiva, quantos sintomas informados pelo usuario
; pertencem a determinada falha.
; ==========================================================================

(defun contar-sintomas (sintomas sintomas-falha)

  (cond

    ((null sintomas)
     0)

    ((member (first sintomas) sintomas-falha)
     (+ 1
        (contar-sintomas
          (rest sintomas)
          sintomas-falha)))

    (t
     (contar-sintomas
       (rest sintomas)
       sintomas-falha))))

; ==========================================================================
; Associa uma pontuacao para cada falha.
; ==========================================================================

(defun pontuar-falha (sintomas falha)

  (list

    falha

    (contar-sintomas
      sintomas
      (sintomas-falha falha))))

; ==========================================================================
; Utiliza MAPCAR para pontuar todas as falhas.
; ==========================================================================

(defun pontuar-falhas (sintomas)

  (mapcar

    (lambda (falha)

      (pontuar-falha sintomas falha))

    *falhas*))

; ==========================================================================
; Ordena as falhas pela maior pontuacao.
; ==========================================================================

(defun ordenar-falhas (lista)

  (sort lista #'> :key #'second))

; ==========================================================================
; Seleciona o melhor diagnostico.
; ==========================================================================

(defun melhor-diagnostico (sintomas)

  (first

    (ordenar-falhas

      (pontuar-falhas sintomas))))

; ==========================================================================
; Exibe o diagnostico encontrado.
; ==========================================================================

(defun diagnosticar (sintomas)

  (let*

      ((resultado (melhor-diagnostico sintomas))

       (falha (first resultado))

       (pontuacao (second resultado)))

    (if (> pontuacao 0)

        (progn

          (format t "~%=====================================")
          (format t "~%Diagnostico encontrado")
          (format t "~%=====================================~%")

          (format t "~%Falha: ~A"
                  (nome-falha falha))

          (format t "~%Quantidade de sintomas compativeis: ~A"
                  pontuacao)

          (format t "~%Acao recomendada: ~A~%"
                  (acao-falha falha)))

        (format t "~%Nenhuma falha compativel encontrada.~%"))))

; ==========================================================================
; Interface com o usuario
; ==========================================================================

(defun executar-sistema ()

  (format t "~%==============================================")
  (format t "~% Sistema Especialista de Diagnostico Automotivo")
  (format t "~%==============================================~%")

  (format t "~%Sintomas disponiveis:~%~%")

  (format t "motor_nao_liga~%")
  (format t "luz_bateria_acesa~%")
  (format t "motor_gira_lento~%")
  (format t "ruido_metalico~%")
  (format t "superaquecimento~%")
  (format t "fumaca_branca~%")
  (format t "consumo_alto~%")
  (format t "motor_falhando~%")
  (format t "cheiro_combustivel~%")
  (format t "luz_injecao_acesa~%")

  (format t "~%Digite os sintomas entre parenteses.~%")
  (format t "Exemplo:~%")
  (format t "(motor_nao_liga luz_bateria_acesa motor_gira_lento)~%~%")

  (format t "Sintomas: ")

  (let ((sintomas (read)))

    (diagnosticar sintomas)))

; ==========================================================================
; Inicio do programa
; ==========================================================================

(executar-sistema)
