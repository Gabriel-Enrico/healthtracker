//
//  ContentView.swift
//  HealthTrackerAlice
//
//  Created by Turma01-19 on 13/05/25.
//

import SwiftUI

struct ContentView: View {
    
    var recebe:Paciente
    @StateObject var viewModel = ViewModel()
    @State private var searchText = ""
    @State var pacientes: [Paciente] = []
    
    var searchResults: [Paciente] {
        if searchText.isEmpty {
            return viewModel.paciente
        } else {
            return viewModel.paciente.filter {
                $0.nome.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        
        NavigationStack() {
            
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
                            Text("Pacientes")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .shadow(color: .verde01, radius: 8)
                            Spacer()
                        }
                        
                        // search bar
                        TextField("Buscar pacientes", text: $searchText)
                            .padding()
                            .frame(height: 40)
                            .background(.white.opacity(0.7))
                            .cornerRadius(10)
                            .padding(.vertical)
                        
                        // pacientes
                        ForEach(searchResults, id: \.self) { i in
                            if(i.isMedico == 0){
                                NavigationLink(destination: PacienteView(recebe: i, medico: recebe)) {
                                    HStack() {
                                        
                                        AsyncImage(url: URL(string: i.foto),
                                                   content: { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 100, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                        },
                                                   placeholder: {
                                            ProgressView()
                                        }).frame(width: 120, height: 120)
                                        
                                        Text(i.nome)
                                        Spacer()
                                    }
                                }
                                .foregroundStyle(.black)
                                .padding(25)
                                .background(
                                    RoundedRectangle(cornerRadius: 16.0)
                                        .shadow(color: .verde05, radius: 20)
                                        .foregroundStyle(.white)
                                ).padding(.vertical)
                            }
                        }
                        
                        Spacer()
                        
                    }.padding() // vstack
                    
                } // scrollview
                
            } // zstack
            
        } // navigation stack
        .onAppear(){
            viewModel.fetch()
        }
    }
}

#Preview{
    ContentView(recebe: Paciente(_id: "sad",_rev: "adwa", isMedico: 1, nome: "João Silva", data_nascimento: "78", sexo: "M", peso: 89, altura: 1.78, tipo_sanguineo: "A", foto: "yrwd", ficha_medica: [FichasMedicas(arquivos: "pf", consultas: ["poy"], exames: ["dsfns"], orientacoes:  ["bfebofu"], idpaciente: "123")]))
}
