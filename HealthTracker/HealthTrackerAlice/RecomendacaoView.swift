//
//  RecomendacaoView.swift
//  HealthTrackerAlice
//
//  Created by Turma01-19 on 16/05/25.
//

import SwiftUI

struct RecomendacaoView: View {
    
    var recebe: Paciente
    @State var recebeAux: FichasMedicas = FichasMedicas(arquivos: "", consultas: [], exames: [], orientacoes: [], idpaciente: "")
    var medico: Paciente
    @StateObject var viewModel = ViewModel()
    @State var consultas: String = ""
    @State var exames: String = ""
    @State var orientacoes: String = ""
    @State var revAux: String = ""
    @State var consultaAux: [String] = []
    @State var exameAux: [String] = []
    @State var orientacaoAux: [String] = []
    @State private var presentalert = false
    
    // struct da checkbox
    struct iOSCheckboxToggleStyle: ToggleStyle {
        func makeBody(configuration: Configuration) -> some View {
            Button(action: {
                configuration.isOn.toggle()

            }, label: {
                HStack {
                    Image(systemName: configuration.isOn ? "checkmark.square" : "square")

                    configuration.label
                }
            })
        }
    }
    
    struct ToggleStatesC{
        var oneIsOn: Bool = false
        var twoIsOn: Bool = false
        var topExpanded: Bool = false
    }
    struct ToggleStatesE{
        var oneIsOn: Bool = false
        var twoIsOn: Bool = false
        var topExpanded: Bool = false
    }
    
    @State private var toggleStatesC = ToggleStatesC()
    @State private var toggleStatesE = ToggleStatesE()
    
    var body: some View {
        
        ZStack() {
            
            LinearGradient(gradient: Gradient(stops: [
                .init(color: .verde05, location: 0),
                .init(color: .verde02, location: 0.62),
                .init(color: .verde03, location: 1)
            ]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            ScrollView() {
                
                VStack{
                    
                    // título
                    HStack() {
                        Text("Recomendações")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .shadow(color: .verde01, radius: 8)
                        Spacer()
                    }
                    
                    // agendamentos
                    HStack() {
                        Text("Agendamentos")                      .font(.system(size: 24))
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                            .shadow(color: .verde01, radius: 8)
                        Spacer()
                    }.padding(.top, 32)
                    
                    // consultas
                    HStack(alignment: .top){
                        Image(systemName:"stethoscope")
                            .padding(.top, 4)
                            .foregroundColor(.verde04)
                        
                        DisclosureGroup("Consultas", isExpanded: $toggleStatesC.topExpanded){
                            
                            ForEach(recebeAux.consultas, id: \.self) { f in
                                HStack {
                                    Text(f)
                                    Spacer()
                                    Button {
                                        if let index = recebeAux.consultas.firstIndex(of: f) {
                                            recebeAux.consultas.remove(at: index)
                                        }
                                        viewModel.enviarFichaMedica(obj: Paciente(_id: recebe._id, _rev: recebe._rev, isMedico: recebe.isMedico, nome: recebe.nome, data_nascimento: recebe.data_nascimento, sexo: recebe.sexo, peso: recebe.peso, altura: recebe.altura, tipo_sanguineo: recebe.tipo_sanguineo, foto: recebe.foto, ficha_medica: [FichasMedicas(arquivos: recebeAux.arquivos, consultas: recebeAux.consultas, exames: recebeAux.exames, orientacoes: recebeAux.orientacoes, idpaciente: recebeAux.idpaciente)]))
                                    } label: {
                                        Image(systemName: "minus")
                                            .foregroundStyle(.red)
                                    }
                                }
                            }
                            
                            // botão adicionar consulta
                        if (medico.isMedico == 1){
                            HStack() {
                                Button(action: {
                                    presentalert = true
                                }) {
                                    HStack() {
                                        Image(systemName: "plus")
                                        Text("Adicionar consulta")
                                    }
                                }
                                .alert("Adicionar consulta", isPresented: $presentalert, actions: {
                                    
                                    ForEach(recebe.ficha_medica, id: \.self) { f in
                                        TextField("Digite a consulta", text: $consultas)
                                        Button("OK"){
                                            
                                            consultaAux.append(consultas)
                                            
                                            viewModel.enviarFichaMedica(obj: Paciente(_id: recebe._id, _rev: revAux, isMedico: recebe.isMedico, nome: recebe.nome, data_nascimento: recebe.data_nascimento, sexo: recebe.sexo, peso: recebe.peso, altura: recebe.altura, tipo_sanguineo: recebe.tipo_sanguineo, foto: recebe.foto, ficha_medica: [FichasMedicas(arquivos: f.arquivos, consultas: consultaAux, exames: exameAux, orientacoes: orientacaoAux, idpaciente: f.idpaciente)]))
                                            
                                            print(consultaAux)
                                        }
                                    }
                                    Button("Cancelar", role: .cancel, action: {})
                                })
                                
                                Spacer()
                            }
                            .padding(.top)
                            .foregroundStyle(.blue)
                        }
                            
                        }
                        .foregroundColor(.black)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16.0)
                            .shadow(color: .verde05, radius: 20)
                            .foregroundStyle(.white)
                    ).padding(.top)
                    
                    // exames
                    HStack(alignment: .top){
                        Image(systemName:"heart.text.square")
                            .padding(.top, 4)
                            .foregroundColor(.verde04)
                        
                        DisclosureGroup("Exames", isExpanded: $toggleStatesE.topExpanded){
                            // checkbox
                            ForEach(recebeAux.exames, id: \.self) { f in
                                HStack {
                                    Text(f)
                                    Spacer()
                                    Button {
                                        if let index = recebeAux.exames.firstIndex(of: f) {
                                            recebeAux.exames.remove(at: index)
                                        }
                                        viewModel.enviarFichaMedica(obj: Paciente(_id: recebe._id, _rev: recebe._rev, isMedico: recebe.isMedico, nome: recebe.nome, data_nascimento: recebe.data_nascimento, sexo: recebe.sexo, peso: recebe.peso, altura: recebe.altura, tipo_sanguineo: recebe.tipo_sanguineo, foto: recebe.foto, ficha_medica: [FichasMedicas(arquivos: recebeAux.arquivos, consultas: recebeAux.consultas, exames: recebeAux.exames, orientacoes: recebeAux.orientacoes, idpaciente: recebeAux.idpaciente)]))
                                    } label: {
                                        Image(systemName: "minus")
                                            .foregroundStyle(.red)
                                    }
                                }
                            }
                            
                            // botão adicionar exame
                        if (medico.isMedico == 1) {
                            HStack() {
                                Button(action: {
                                    presentalert = true
                                }) {
                                    HStack() {
                                        Image(systemName: "plus")
                                        Text("Adicionar exame")
                                    }
                                }
                                .alert("Adicionar exame", isPresented: $presentalert, actions: {
                                    
                                    ForEach(recebe.ficha_medica, id: \.self) { f in
                                        TextField("Digite o exame", text: $exames)
                                        Button("OK"){
                                            
                                            consultaAux.append(exames)
                                            
                                            viewModel.enviarFichaMedica(obj: Paciente(_id: recebe._id, _rev: revAux, isMedico: recebe.isMedico, nome: recebe.nome, data_nascimento: recebe.data_nascimento, sexo: recebe.sexo, peso: recebe.peso, altura: recebe.altura, tipo_sanguineo: recebe.tipo_sanguineo, foto: recebe.foto, ficha_medica: [FichasMedicas(arquivos: f.arquivos, consultas: consultaAux, exames: exameAux, orientacoes: orientacaoAux, idpaciente: f.idpaciente)]))
                                        }
                                    }
                                    Button("Cancelar", role: .cancel, action: {})
                                })
                                
                                Spacer()
                            }
                            .padding(.top)
                            .foregroundColor(.blue)
                        }
                            
                        }.foregroundColor(.black)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16.0)
                            .shadow(color: .verde05, radius: 20)
                            .foregroundStyle(.white)
                    ).padding(.top)
                    
                    // orientações
                    // título
                    HStack() {
                        Text("Orientações")
                            .font(.system(size: 24))
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                            .shadow(color: .verde01, radius: 8)
                        
                        Spacer()
                        
                        // botão
                        if (medico.isMedico == 1){
                        HStack() {
                            Button(action: {
                                presentalert = true
                            }) {
                                HStack() {
                                    Image(systemName: "plus")
                                    Text("Adicionar")
                                }
                            }
                            .alert("Adicionar orientação", isPresented: $presentalert, actions: {
                                
                                ForEach(recebe.ficha_medica, id: \.self) { f in
                                    TextField("Digite a orientação", text: $orientacoes)
                                    Button("OK"){
                                        
                                        orientacaoAux.append(orientacoes)
                                        
                                        viewModel.enviarFichaMedica(obj: Paciente(_id: recebe._id, _rev: revAux, isMedico: recebe.isMedico, nome: recebe.nome, data_nascimento: recebe.data_nascimento, sexo: recebe.sexo, peso: recebe.peso, altura: recebe.altura, tipo_sanguineo: recebe.tipo_sanguineo, foto: recebe.foto, ficha_medica: [FichasMedicas(arquivos: f.arquivos, consultas: consultaAux, exames: exameAux, orientacoes: orientacaoAux, idpaciente: f.idpaciente)]))
                                    }
                                }
                                Button("Cancelar", role: .cancel, action: {})
                            })
                        }
                        .padding(6)
                        .padding(.trailing)
                        .background(
                            RoundedRectangle(cornerRadius: 16.0)
                                .shadow(color: .verde05, radius: 20)
                                .foregroundStyle(.white.opacity(0.8))
                        ).padding(.horizontal)
                    }
                    }
                    .padding(.top, 32)
                    
                    // botão
                    ForEach(recebeAux.orientacoes, id: \.self) { f in
                        HStack {
                            HStack{
                                Image(systemName: "exclamationmark.circle")
                                    .foregroundColor(.verde04)
                                    .font(.system(size: 24))
                                
                                Text(f)
                                
                                Spacer()
                                
                                Button {
                                    if let index = recebeAux.orientacoes.firstIndex(of: f) {
                                        recebeAux.orientacoes.remove(at: index)
                                    }
                                    viewModel.enviarFichaMedica(obj: Paciente(_id: recebe._id, _rev: recebe._rev, isMedico: recebe.isMedico, nome: recebe.nome, data_nascimento: recebe.data_nascimento, sexo: recebe.sexo, peso: recebe.peso, altura: recebe.altura, tipo_sanguineo: recebe.tipo_sanguineo, foto: recebe.foto, ficha_medica: [FichasMedicas(arquivos: recebeAux.arquivos, consultas: recebeAux.consultas, exames: recebeAux.exames, orientacoes: recebeAux.orientacoes, idpaciente: recebeAux.idpaciente)]))
                                } label: {
                                    Image(systemName: "minus")
                                        .foregroundStyle(.red)
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16.0)
                                    .shadow(color: .verde05, radius: 20)
                                    .foregroundStyle(.white)
                            ).padding(.top)
                        }
                    }
                    
                    Spacer()
                    
                }.padding() // vstack
                
            } // scrollview
            
        }
        // zstack
        .onAppear(){
            
            for i in recebe.ficha_medica {
                recebeAux = i
            }
            
                Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
                    viewModel.fetchPaciente()
                    for i in viewModel.paciente {
                        if recebe._id == i._id {
                            revAux = i._rev
                            for e in i.ficha_medica{
                                consultaAux = e.consultas
                                exameAux = e.exames
                                orientacaoAux = e.orientacoes
                                print(e.consultas)
                            }
                        }
                    }
                }
            }
        
    }
}

#Preview {
    RecomendacaoView(recebe: Paciente(_id: "sad",_rev: "adwa", isMedico: 1, nome: "Maria Oliveira", data_nascimento: "78", sexo: "F", peso: 89, altura: 1.78, tipo_sanguineo: "A", foto: "yrwd", ficha_medica: [FichasMedicas(arquivos: "pf", consultas: ["poy"], exames: ["dsfns"], orientacoes:  ["bfebofu"], idpaciente: "123")]),medico: Paciente(_id: "sad",_rev: "adwa", isMedico: 1, nome: "Maria Oliveira", data_nascimento: "78", sexo: "M", peso: 89, altura: 1.78, tipo_sanguineo: "A", foto: "yrwd", ficha_medica: [FichasMedicas(arquivos: "pf", consultas: ["poy"], exames: ["dsfns"], orientacoes:  ["bfebofu"], idpaciente: "123")]))
}
