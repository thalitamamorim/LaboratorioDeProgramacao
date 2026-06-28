# ==============================================================================
# Laboratório de Programação - 2026/1
# Sistema Especialista para Diagnóstico de Falhas Automotivas (Paradigma OO)
# Docente: Prof. Sofiane Ben El Hedi Labidi
# Alunos: Deborah Sophia, Samira Farias, Samuel Carvalho, Thalita Amorim
# ==============================================================================

# 1. Classes de Entidades (Modelos de Componentes com Herança)
class Componente:
    def __init__(self, nome, sistema):
        self.nome = nome
        self.sistema = sistema  # Elétrico, Mecânico, Eletrônico

class ComponenteEletrico(Componente):
    def __init__(self, nome, voltagem=12):
        super().__init__(nome, "Elétrico")
        self.voltagem = voltagem

class ComponenteMecanico(Componente):
    def __init__(self, nome, precisa_lubrificacao=True):
        super().__init__(nome, "Mecânico")
        self.precisa_lubrificacao = precisa_lubrificacao

class Falha:
    def __init__(self, descricao, componente, sintomas):
        self.descricao = descricao      
        self.componente = componente    
        self.sintomas = sintomas        # Lista de IDs de sintomas: ["1", "2"]


# 2. Classe Gerenciadora (Responsável pela Base de Conhecimento e Inferência)
class Oficina:
    def __init__(self):
        # Estrutura: {id_falha: Falha}
        self.base_falhas = {}
        
        # Mapeamento estático de sintomas (para exibição em menu numérico)
        self.mapa_sintomas = {
            "1": "Motor não liga",
            "2": "Luz da bateria acesa",
            "3": "Motor gira lentamente",
            "4": "Ruído metálico",
            "5": "Superaquecimento",
            "6": "Fumaça branca",
            "7": "Consumo alto",
            "8": "Motor falhando",
            "9": "Cheiro de combustível",
            "10": "Luz da injeção acesa"
        }

    def cadastrar_falha(self, id_falha, falha_objeto):
        self.base_falhas[id_falha] = falha_objeto

    def exibir_menu_sintomas(self):
        print("\n--- Sintomas Disponíveis ---")
        for numero, descricao in self.mapa_sintomas.items():
            print(f"{numero} - {descricao}")
        print("-" * 28)

    # Motor de Inferência do Sistema Especialista OO
    def diagnosticar_veiculo(self, codigos_sintomas):
        if not self.base_falhas:
            print("Nenhuma falha cadastrada no banco de dados.")
            return

        print("\n" + "="*50)
        print("RESULTADO DO DIAGNÓSTICO")
        print("="*50)
        
        # Traduz os códigos numéricos para texto para exibir ao usuário
        sintomas_texto = [self.mapa_sintomas[c] for c in codigos_sintomas if c in self.mapa_sintomas]
        print(f"Sintomas observados: {', '.join(sintomas_texto)}\n")

        # Varre a base buscando a correspondência lógica
        for id_falha, falha in self.base_falhas.items():
            # SE todos os sintomas exigidos pela falha estão nos informados pelo usuário, ENTÃO infere a falha
            if all(sintoma in codigos_sintomas for sintoma in falha.sintomas):
                print(f"Falha provável: {falha.descricao}")
                print(f"Componente    : {falha.componente.nome}")
                print(f"Sistema       : {falha.componente.sistema}")
                print("="*50)
                return

        print("[AVISO] Nenhuma falha correspondente foi identificada com esses sintomas.")
        print("="*50)


# 3. Menu (Interface com o Usuário - Padrão do Professor)
def menu():
    oficina = Oficina()

    # === BASE DE DADOS EXPANDIDA ===
    bat = ComponenteEletrico("Bateria")
    mot = ComponenteMecanico("Motor de Partida")
    comb = Componente("Sistema de Combustível", "Eletrônico")
    arrefecimento = ComponenteMecanico("Sistema de Arrefecimento (Radiador)")
    injecao = Componente("Módulo de Injeção Eletrônica", "Eletrônico")
    motor_bloco = ComponenteMecanico("Bloco do Motor / Pistões")

    # Mapeamento de falhas por regras de sintomas numéricos
    oficina.cadastrar_falha(1, Falha("Bateria Descarregada/Fraca", bat, ["1", "2"]))
    oficina.cadastrar_falha(2, Falha("Motor de Partida Travado", mot, ["1", "4"]))
    oficina.cadastrar_falha(3, Falha("Vazamento de Combustível", comb, ["9"]))
    oficina.cadastrar_falha(4, Falha("Queima de Junta do Cabeçote (Passando Água)", arrefecimento, ["5", "6"]))
    oficina.cadastrar_falha(5, Falha("Problema nos Bicos Injetores", injecao, ["7", "8", "10"]))
    oficina.cadastrar_falha(6, Falha("Desgaste nos Anéis de Segmento (Queima de Óleo)", motor_bloco, ["6"]))
    oficina.cadastrar_falha(7, Falha("Alternador com Defeito", bat, ["2", "3"]))

    while True:
        print('''
===== DIAGNÓSTICO AUTOMOTIVO =====
1. Informar Sintomas e Diagnosticar
2. Ver Falhas Cadastradas no Sistema
0. Sair
''')
        opcao = input('Escolha uma opção: ')

        if opcao == '1':
            oficina.exibir_menu_sintomas()
            entrada = input('Digite os números separados por vírgula (Ex.: 1,2): ')
            
            # Limpa espaços em branco e divide as entradas pelas vírgulas
            codigos_escolhidos = [n.strip() for n in entrada.split(',') if n.strip() != '']
            
            # Valida se os números digitados realmente existem no mapa de sintomas
            codigos_validos = [c for c in codigos_escolhidos if c in oficina.mapa_sintomas]

            if not codigos_validos:
                print('Nenhum sintoma válido foi selecionado.')
            else:
                oficina.diagnosticar_veiculo(codigos_validos)

        elif opcao == '2':
            print('\n--- Banco de Dados do Sistema Especialista ---')
            for id_f, f in oficina.base_falhas.items():
                sintomas_nomes = [oficina.mapa_sintomas[s] for s in f.sintomas]
                print(f"ID: {id_f} | Diagnóstico: {f.descricao} | Requer verificar: {f.componente.nome} ({f.componente.sistema})")
                print(f"    Gatilhos (Sintomas necessários): {', '.join(sintomas_nomes)}")
            print("-" * 45)

        elif opcao == '0':
            print('Encerrando o sistema de diagnóstico. Até logo!')
            break
        else:
            print('Opção inválida. Tente novamente.')


# 4. Execução do Programa
if __name__ == "__main__":
    menu()