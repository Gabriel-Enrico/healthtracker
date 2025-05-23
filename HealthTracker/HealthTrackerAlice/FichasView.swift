//
//  FichasView.swift
//  HealthTrackerAlice
//
//  Created by Turma01-19 on 16/05/25.
//

import SwiftUI

struct FichasView: View {
    
    var recebe: Paciente
    @StateObject var viewModel = ViewModel()
    @State var consultas: String = ""
    @State var exames: String = ""
    @State var orientacoes: String = ""
    @State var revAux: String = ""
    @State var consultaAux: [String] = []
    @State var exameAux: [String] = []
    @State var orientacaoAux: [String] = []
    @State private var presentalert = false
    
    var body: some View {
        
        ZStack() {
            
            LinearGradient(gradient: Gradient(stops: [
                .init(color: .verde05, location: 0),
                .init(color: .verde02, location: 0.62),
                .init(color: .verde03, location: 1)
            ]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            ScrollView() {
                
                VStack() {
                    // título
                    HStack() {
                        Text("Fichas médicas")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .shadow(color: .verde01, radius: 8)
                        Spacer()
                    }
                    
                    HStack() {
                        Button(action: {presentalert = true}) {
                            HStack() {
                                Image(systemName: "plus")
                                Text("Adicionar ficha")
                            }
                        }
                        .alert("Adicionar ficha", isPresented: $presentalert, actions: {
                                TextField("Digite a URL da ficha médica", text: $exames)
                                Button("OK"){}
                                Button("Cancelar", role: .cancel, action: {})
                            })
                        .padding(6)
                        .padding(.trailing)
                        .background(
                            RoundedRectangle(cornerRadius: 16.0)
                                .shadow(color: .verde05, radius: 20)
                                .foregroundStyle(.white.opacity(0.8))
                        )
                        
                        Spacer()
                    }
                    .padding(.top)
                    .foregroundColor(.blue)
                    
                    // especialidade
                    
                    HStack(alignment: .top) {
                        Image(systemName: "book.pages")
                            .foregroundStyle(.verde04)
                            .padding(.top, -2)
                        
                        Link("Ficha 23-02-2019", destination: URL(string: "https://heyzine.com/flip-book/bbfda0a91c.html")!)
                        
                        Spacer()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16.0)
                            .shadow(color: .verde05, radius: 20)
                            .foregroundStyle(.white)
                    ).padding(.top)
                                        
                }.padding() // vstack
                
            } // scrollview
            
        } // zstack
        
    }
}

#Preview {
    FichasView(recebe: Paciente(_id: "sad",_rev: "adwa",isMedico: 1, nome: "Joao", data_nascimento: "fsf", sexo: "wqeq", peso: 121.2, altura: 321.2, tipo_sanguineo: "A", foto: "yrwd", ficha_medica: [FichasMedicas(arquivos: "pf", consultas: ["poy"], exames: ["dsfns"], orientacoes:  ["bfebofu"], idpaciente: "123")]))
}
