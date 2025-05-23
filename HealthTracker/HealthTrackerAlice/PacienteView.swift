//
//  PacienteView.swift
//  HealthTrackerAlice
//
//  Created by Turma01-19 on 16/05/25.
//

import SwiftUI

struct PacienteView: View {
    
    @State var remedioAux: MedicamentosPaciente = MedicamentosPaciente(_id: "", _rev: "", nome: "", funcao: "", periodo: "", horario: "", intervalo: "", idpaciente: "")
    
    var recebe: Paciente
    var medico: Paciente
    
    @StateObject var viewModel = ViewModel()
    
    // @State private var toggleStates = ToggleStates()
    @State private var topExpanded: Bool = true
    // @StateObject var viewModel = ViewModel()
    @State var idAux: String = ""
    @State var horario: String = ""
    @State var periodo: String = ""
    @State var intervalo: String = ""
    @State private var presentAlert = false
    @State private var mostrarRemedios = false
    @State private var mostrarAlerta = false
    
    var body: some View {
        
        NavigationStack() {
            
            ScrollView() {
            
                HStack() {
                    AsyncImage(url: URL(string: recebe.foto),
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
                    
                    Spacer()
                    
                    // header
                    VStack(alignment: .leading) {
                        Text(recebe.nome) // subs. nome da api
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(4)
                        
                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                Text("Idade: \(idade(recebe.data_nascimento) ?? 40)")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.gray)
                                    .padding(.bottom, 2)
                                
                                Text("Peso: \(recebe.peso, specifier: "%.1f")kg") // subs. peso da api
                                    .font(.system(size: 14))
                                    .foregroundStyle(.gray)
                                    .padding(.bottom, 2)
                                
                                Text("Sexo: \(recebe.sexo)") // subs. sexo da api
                                    .font(.system(size: 14))
                                    .foregroundStyle(.gray)
                            }.padding(.horizontal, 4)
                            
                            VStack(alignment: .leading) {
                                Text("Tipo sanguíneo: \(recebe.tipo_sanguineo)") // subs. tipo s. da api
                                    .font(.system(size: 14))
                                    .foregroundStyle(.gray)
                                    .padding(.bottom, 2)
                                
                                Text("Altura: \(recebe.altura, specifier: "%.2f")m") // subs. altura da api
                                    .font(.system(size: 14))
                                    .foregroundStyle(.gray)
                            }.padding(.horizontal, 4)
                        }
                    }
                }
                
                Divider()
                    .padding()
                
                // navlink monitoramento do paciente
                NavigationLink(destination: MonitoramentoView()) {
                    HStack() {
                        Image(systemName: "heart.circle")
                            .font(.system(size: 30))
                            .foregroundStyle(.verde04)
                        
                        Text("Monitoramento do paciente")
                            .foregroundStyle(.black)
                        
                        Spacer()
                    }
                }
                .padding(25)
                .background(
                    RoundedRectangle(cornerRadius: 16.0)
                        .shadow(color: .cinza02, radius: 20)
                        .foregroundStyle(.white)
                )
                .padding()
                
                // navlink recomendações
                ForEach(viewModel.paciente, id: \.self) { p in
                    ForEach(p.ficha_medica, id: \.self) { f in
                        if idAux == f.idpaciente {
                            NavigationLink(destination: RecomendacaoView(recebe: p, medico: medico)) {
                                HStack() {
                                    Image(systemName: "bubble.circle")
                                        .font(.system(size: 30))
                                        .foregroundStyle(.verde04)
                                    
                                    Text("Recomendações")
                                        .foregroundStyle(.black)
                                    
                                    Spacer()
                                }
                            }
                            .padding(25)
                            .background(
                                RoundedRectangle(cornerRadius: 16.0)
                                    .shadow(color: .cinza02, radius: 20)
                                    .foregroundStyle(.white)
                            )
                            .padding()
                            
                            // navlink fichas médicas
                            NavigationLink(destination: FichasView(recebe: p)) {
                                HStack() {
                                    Image(systemName: "book.circle")
                                        .font(.system(size: 30))
                                        .foregroundStyle(.verde04)
                                    
                                    Text("Fichas médicas")
                                        .foregroundStyle(.black)
                                    
                                    Spacer()
                                }
                            }
                            .padding(25)
                            .background(
                                RoundedRectangle(cornerRadius: 16.0)
                                    .shadow(color: .cinza02, radius: 20)
                                    .foregroundStyle(.white)
                            )
                            .padding()
                        }
                    }
                }
                
                // medicamentos
                HStack() {
                    Text("Medicamentos")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.top, 32)
                    
                    Spacer()
                }
            if (medico.isMedico == 1){
                HStack(alignment: .top) {
                    Image(systemName:"plus")
                        .padding(.top, 6)
                        .foregroundColor(.blue)
                    
                        DisclosureGroup("Adicionar remédio") {
                            ForEach(viewModel.medicamentos, id: \.self){ m in
                                DisclosureGroup(m.nome) {
                                    TextField("Digite o periodo:", text: $periodo)
                                        .padding(.top)
                                    TextField("Digite o intervalo:", text: $intervalo)
                                        .padding(.top)
                                    
                                    Button("Enviar", action: {
                                        viewModel.enviarHorario(obj: MedicamentosPaciente(_id: nil, _rev: nil, nome: m.nome, funcao: m.funcao, periodo: periodo, horario: "", intervalo: intervalo, idpaciente: recebe._id))
                                    })
                                    .foregroundStyle(.white)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .foregroundColor(.blue)
                                    )
                                    .padding(.top)
                                    
                                }.foregroundStyle(.black).padding(.top)
                                Divider()
                            }
                        }
                    }
                }
                
                // remédio
                ForEach(viewModel.medicamentos_paci, id: \.self){ i in
                    if idAux == i.idpaciente{
                        VStack(alignment: .leading) {
                            Text(i.nome)
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                                .shadow(color: .verde01, radius: 8)
                            
                            // botão adicionar horário
                            if(medico.isMedico == 0){
                                HStack() {
                                    Button(action: {
                                        presentAlert = true
                                        print(i.nome)
                                        print(i._id!)
                                        remedioAux = i
                                    }){
                                        HStack() {
                                            Image(systemName: "plus")
                                                .font(.system(size: 12))
                                            Text("Adicionar horário")
                                                .font(.system(size: 12))
                                        }
                                    }
                                    .alert("Adicionar", isPresented: $presentAlert, actions: {
                                        TextField("Horário", text: $horario)
                                        Button("Adicionar Horário"){
                                            
                                            remedioAux.horario = horario
                                            viewModel.enviarHorario(obj: remedioAux)
                                            
                                        }
                                        
                                        Button("Cancelar", role: .cancel, action: {})
                                    }, message: {
                                        Text("Digite todos os horários")
                                    })
                                }
                                .padding(4)
                                .padding(.trailing, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 16.0)
                                        .shadow(color: .verde05, radius: 20)
                                        .foregroundStyle(.white.opacity(0.8))
                                )
                            }
                            HStack{
                                Text("\(i.horario ?? "")")
                                    .font(.title2)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.white)
                                    .shadow(color: .verde01, radius: 8)
                                    .padding(1)
                                
                            }
                            HStack() {
                                Image(systemName: "clock")
                                    .font(.system(size: 20))
                                    .foregroundStyle(.verde01)
                                    .padding(.trailing, 4)
                                
                                VStack(alignment: .leading) {
                                    Text("Período")
                                        .font(.system(size: 14))
                                        .foregroundStyle(.white)
                                    
                                    Text(i.periodo)
                                        .foregroundStyle(.white)
                                }.shadow(color: .verde01, radius: 8)
                                
                                Spacer()
                                
                                Image(systemName: "pill")
                                    .font(.system(size: 20))
                                    .foregroundStyle(.verde01)
                                    .padding(.trailing, 4)
                                
                                VStack(alignment: .leading) {
                                    Text("Dosagem")
                                        .font(.system(size: 14))
                                        .foregroundStyle(.white)
                                    
                                    Text(i.intervalo)
                                        .foregroundStyle(.white)
                                }.shadow(color: .verde01, radius: 8)
                            }.padding(.top, 6)
                            
                        }
                        .padding(25)
                        .background(
                            RoundedRectangle(cornerRadius: 16.0)
                                .shadow(color: .cinza02, radius: 20)
                                .foregroundStyle(
                                    LinearGradient(gradient: Gradient(stops: [
                                        .init(color: .verde05, location: 0),
                                        .init(color: .verde02, location: 0.62),
                                        .init(color: .verde03, location: 1)
                                    ]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                        )
                        .padding()
                    }
                }
                
            }.padding() // scrollview
            
        }// navigation stack
        .onAppear(){
            viewModel.fetch()
            idAux = recebe._id
        }
    }
    func idade(_ data: String) -> Int? {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            guard let nascimento = formatter.date(from: data) else { return nil }
            return Calendar.current.dateComponents([.year], from: nascimento, to: Date()).year
        }
}

#Preview {
    PacienteView(recebe: Paciente(_id: "sad",_rev: "adwa", isMedico: 0, nome: "Maria Oliveira", data_nascimento: "78", sexo: "F", peso: 89, altura: 1.78, tipo_sanguineo: "A", foto: "yrwd", ficha_medica: [FichasMedicas(arquivos: "pf", consultas: ["poy"], exames: ["dsfns"], orientacoes:  ["bfebofu"], idpaciente: "123")]),medico: Paciente(_id: "sad",_rev: "adwa", isMedico: 1, nome: "Maria Oliveira", data_nascimento: "78", sexo: "M", peso: 89, altura: 1.78, tipo_sanguineo: "A", foto: "yrwd", ficha_medica: [FichasMedicas(arquivos: "pf", consultas: ["poy"], exames: ["dsfns"], orientacoes:  ["bfebofu"], idpaciente: "123")]))
}
