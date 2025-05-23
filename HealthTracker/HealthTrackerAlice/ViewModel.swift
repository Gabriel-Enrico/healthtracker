//
//  ViewModel.swift
//  HealthTrackerAlice
//
//  Created by Turma01-19 on 16/05/25.
//

import Foundation

class ViewModel: ObservableObject{
    
    @Published var paciente: [Paciente] = []
    @Published var medicamentos: [Medicamentos] = []
    @Published var medicamentos_paci: [MedicamentosPaciente] = []
    
    func fetch(){
        
        guard let url = URL(string: "http://192.168.128.116:1880/lerpacientes") else {
            return
        }
        guard let url2 = URL(string: "http://192.168.128.116:1880/lermedicamento") else {
            return
        }
        guard let url3 = URL(string: "http://192.168.128.116:1880/lermedpaci") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url){ [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do{
                
                let parsed = try JSONDecoder().decode([Paciente].self, from: data)
                
                DispatchQueue.main.async {
                    self?.paciente = parsed
                }
            } catch {
                print(error)
            }
        }
        task.resume()
        
        let task2 = URLSession.shared.dataTask(with: url2){ [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do{
                
                let parsed = try JSONDecoder().decode([Medicamentos].self, from: data)
                
                DispatchQueue.main.async {
                    self?.medicamentos = parsed
                }
            } catch {
                print(error)
            }
        }
        task2.resume()
        
        let task3 = URLSession.shared.dataTask(with: url3){ [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do{
                
                let parsed = try JSONDecoder().decode([MedicamentosPaciente].self, from: data)
                
                DispatchQueue.main.async {
                    self?.medicamentos_paci = parsed
                }
            } catch {
                print(error)
            }
        }
        task3.resume()
    }
    
    func fetchPaciente(){
        
        guard let url = URL(string: "http://192.168.128.116:1880/lerpacientes") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url){ [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do{
                
                let parsed = try JSONDecoder().decode([Paciente].self, from: data)
                
                DispatchQueue.main.async {
                    self?.paciente = parsed
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func enviarHorario(obj: MedicamentosPaciente) {
        guard let url = URL(string: "http://192.168.128.116:1880/salvarmedpaci") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try? JSONEncoder().encode(obj)

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("Erro: \(error.localizedDescription)")
            } else {
                print("Atualização enviada com sucesso")
            }
        }.resume()
    }
    
    func enviarFichaMedica(obj: Paciente) {
        guard let url = URL(string: "http://192.168.128.116:1880/salvarpacientes") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try? JSONEncoder().encode(obj)

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("Erro: \(error.localizedDescription)")
            } else {
                print("Atualização enviada com sucesso")
            }
        }.resume()
    }
}

class SonoViewModel: ObservableObject {
    @Published var sessoes = [SessaoSono]()
    @Published var modoSelecionado = 0
    
    init() {
        gerarDadosExemplo()
    }
    
    private func gerarDadosExemplo() {
        var novasSessoes = [SessaoSono]()
        let calendario = Calendar.current
        
        for dias in 0..<7 {
            guard let data = calendario.date(byAdding: .day, value: -dias, to: Date()) else { continue }
            
            let duracaoTotal = Double.random(in: 6...9) * 3600
            
            let tempoPorFase: [FaseSono: TimeInterval] = [
                .profundo: duracaoTotal * 0.25,
                .leve: duracaoTotal * 0.55,
                .rem: duracaoTotal * 0.15,
                .acordado: duracaoTotal * 0.05
            ]
            
            novasSessoes.append(SessaoSono(
                data: data,
                duracaoTotal: duracaoTotal,
                tempoPorFase: tempoPorFase
            ))
        }
        
        sessoes = novasSessoes.sorted { $0.data < $1.data }
    }
    
    func horasPorFase(_ fase: FaseSono) -> Double {
        sessoes.reduce(0) { $0 + ($1.tempoPorFase[fase] ?? 0) } / 3600
    }
}

class PressaoViewModel: ObservableObject {
    @Published var medicoes: [MedicaoPressao] = []
    @Published var simulando = false
    
    init() {
        gerarDadosIniciais() // Carrega dados iniciais
    }
    
    private func gerarDadosIniciais() {
        let calendario = Calendar.current
        var dados: [MedicaoPressao] = []
        
        for dia in 0..<7 {
            guard let data = calendario.date(byAdding: .day, value: -dia, to: Date()) else { continue }
            
            dados.append(contentsOf: [
                MedicaoPressao(
                    data: data,
                    tipo: "sistolica",
                    valor: Int.random(in: 110...130)
                ),
                MedicaoPressao(
                    data: data,
                    tipo: "diastolica",
                    valor: Int.random(in: 70...85)
                )
            ])
        }
        
        medicoes = dados.sorted { $0.data < $1.data }
    }
    
    func gerarNovosDados() {
        simulando = true
        medicoes.removeAll()
        
        Task {
            let calendario = Calendar.current
            for dia in 0..<7 {
                guard let data = calendario.date(byAdding: .day, value: -dia, to: Date()) else { continue }
                
                let novosValores = [
                    MedicaoPressao(
                        data: data,
                        tipo: "sistolica",
                        valor: Int.random(in: 110...130)
                    ),
                    MedicaoPressao(
                        data: data,
                        tipo: "diastolica",
                        valor: Int.random(in: 70...85)
                    )
                ]
                
                try await Task.sleep(nanoseconds: 500_000_000)
                
                await MainActor.run {
                    medicoes.append(contentsOf: novosValores)
                }
            }
            await MainActor.run {
                simulando = false
            }
        }
    }
}
