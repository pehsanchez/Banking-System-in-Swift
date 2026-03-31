import Foundation

// MARK: - 1. Modelo de Dados
struct Conta {
    let numero: String
    let titular: String
    var senha: String
    var saldo: Double
    var isAdmin: Bool = false
}

// MARK: - 2. Funções de Lógica
func criarConta(banco: inout [Conta]) {
    print("\n--- Cadastro de Nova Conta ---")
    print("Número da conta: ", terminator: "")
    let numero = readLine() ?? ""
    
    if banco.contains(where: { $0.numero == numero }) {
        print("Erro: Já existe uma conta com este número.")
        return
    }
    
    print("Nome do titular: ", terminator: "")
    let titular = readLine() ?? ""
    print("Defina uma senha: ", terminator: "")
    let senha = readLine() ?? ""
    print("Saldo inicial: ", terminator: "")
    let saldoStr = readLine() ?? "0"
    let saldoInicial = Double(saldoStr) ?? 0.0
    
    let novaConta = Conta(numero: numero, titular: titular, senha: senha, saldo: saldoInicial)
    banco.append(novaConta)
    print("Conta de \(titular) criada com sucesso!")
}

// MARK: - 3. Menus de Sessão

func menuAdmin(banco: inout [Conta]) {
    var logado = true
    while logado {
        print("\n--- PAINEL ADMIN ---")
        print("1. Listar Todas as Contas\n2. Remover Conta\n3. Logout")
        print("Escolha: ", terminator: "")
        
        switch readLine() {
        case "1":
            print("\n--- Relatório Bancário ---")
            for conta in banco {
                print("Titular: \(conta.titular) | Nº: \(conta.numero) | Saldo: R$\(conta.saldo)")
            }
        case "2":
            print("Número da conta para excluir: ", terminator: "")
            if let num = readLine() {
                if let index = banco.firstIndex(where: { $0.numero == num && !$0.isAdmin }) {
                    banco.remove(at: index)
                    print("Conta removida.")
                } else {
                    print("Erro: Conta inexistente ou é Admin.")
                }
            }
        case "3": logado = false
        default: print("Opção inválida.")
        }
    }
}

// Alterado para receber o ÍNDICE para evitar erro de overlapping access
func menuUsuario(indiceLogado: Int, banco: inout [Conta]) {
    var logado = true
    while logado {
        let titular = banco[indiceLogado].titular
        print("\n--- MENU USUÁRIO: \(titular) ---")
        print("1. Ver Saldo\n2. Depositar\n3. Transferir\n4. Alterar Senha\n5. Logout")
        print("Escolha: ", terminator: "")
        
        switch readLine() {
        case "1":
            print("Saldo atual: R$\(banco[indiceLogado].saldo)")
        case "2":
            print("Valor do depósito: ", terminator: "")
            if let v = readLine(), let valor = Double(v) {
                banco[indiceLogado].saldo += valor
                print("Saldo atualizado!")
            }
        case "3":
            print("\nNúmero da conta de destino: ", terminator: "")
            if let numDestino = readLine(), 
               let indexDestino = banco.firstIndex(where: { $0.numero == numDestino }) {
                print("Valor da transferência: ", terminator: "")
                if let vStr = readLine(), let valor = Double(vStr), valor > 0 {
                    if banco[indiceLogado].saldo >= valor {
                        banco[indiceLogado].saldo -= valor
                        banco[indexDestino].saldo += valor
                        print("Transferência realizada!")
                    } else { print("Saldo insuficiente.") }
                }
            } else { print("Conta destino não encontrada.") }
        case "4":
            print("Nova senha: ", terminator: "")
            banco[indiceLogado].senha = readLine() ?? banco[indiceLogado].senha
            print("Senha alterada!")
        case "5": logado = false
        default: print("Opção inválida.")
        }
    }
}

// MARK: - 4. Loop Principal
func iniciarSistema() {
    var bancoDeContas: [Conta] = [
        Conta(numero: "0000", titular: "Admin", senha: "admin", saldo: 0, isAdmin: true)
    ]
    
    var rodando = true
    while rodando {
        print("\n--- BEM-VINDO AO BANCO SWIFT ---")
        print("1. Criar Conta\n2. Login\n3. Sair")
        print("Opção: ", terminator: "")
        
        switch readLine() {
        case "1":
            criarConta(banco: &bancoDeContas)
        case "2":
            print("Nº da Conta: ", terminator: "")
            let num = readLine() ?? ""
            print("Senha: ", terminator: "")
            let pass = readLine() ?? ""
            
            if let index = bancoDeContas.firstIndex(where: { $0.numero == num && $0.senha == pass }) {
                if bancoDeContas[index].isAdmin {
                    menuAdmin(banco: &bancoDeContas)
                } else {
                    // RESOLUÇÃO DO ERRO: Passamos apenas o índice e o banco
                    menuUsuario(indiceLogado: index, banco: &bancoDeContas)
                }
            } else { print("Login ou senha incorretos.") }
        case "3":
            print("Encerrando...")
            rodando = false
        default: print("Opção inválida.")
        }
    }
}

iniciarSistema()