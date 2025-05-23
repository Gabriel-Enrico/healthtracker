//
//  LoginView.swift
//  HealthTrackerAlice
//
//  Created by Turma01-9 on 21/05/25.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack{
            ZStack{
                
                LinearGradient(gradient: Gradient(stops: [
                    .init(color: .verde05, location: 0),
                    .init(color: .verde02, location: 0.62),
                    .init(color: .verde03, location: 1)
                ]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                
                
                VStack{
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300)
                    Spacer()
                    Text("Forma de login:")
                        .foregroundStyle(.white)
                        .bold()
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 40)
                        .shadow(color: .verde01, radius: 8)

                    Spacer()
                    VStack{
                        if let paciente = viewModel.paciente.first(where: {$0.isMedico == 0}) {
                            
                            NavigationLink(destination: PacienteView(recebe: paciente, medico: paciente)) {
                                Text("Paciente")
                                    .foregroundStyle(.verde05)
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 16.0)
                                    .shadow(color: .verde05, radius: 20)
                                    .foregroundStyle(.white)
                                    .frame(width: 168)
                                
                            )
                            .padding(.bottom, 32)
                        }
                 
                        if let medico = viewModel.paciente.first(where: {$0.isMedico == 1}) {
                            
                            NavigationLink(destination: ContentView(recebe: medico)) {
                                Text("Médico")
                                    .foregroundStyle(.verde05)
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 16.0)
                                    .shadow(color: .verde05, radius: 20)
                                    .foregroundStyle(.white)
                                    .frame(width: 168)
                                
                            )
                        }
                    }.padding(.bottom, 90)
                    Spacer()
                }
            }
        }
        .onAppear(){
            viewModel.fetch()
        }
    }
}

#Preview {
    LoginView()
}
