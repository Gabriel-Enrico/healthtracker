//
//  MonitoramentoView.swift
//  HealthTrackerAlice
//
//  Created by Turma01-19 on 14/05/25.
//

import SwiftUI
import Charts

struct BPMData {
    let value: Int
    let time: Date
}

struct MonitoramentoView: View {
    @State private var bpmData: [BPMData] = []
    @State private var timer: Timer?
    @State private var media: Int = 0
    @StateObject var viewModel = SonoViewModel()
    @StateObject var pressaoModel = PressaoViewModel()
    
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
                        Text("Monitoramento do paciente")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .shadow(color: .verde01, radius: 8)
                        Spacer()
                    }
                    
                    
                    // monitoramento cardíaco
                    HStack() {
                        Text("Monitoramento cardíaco")                      .font(.system(size: 24))
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                            .shadow(color: .verde01, radius: 8)
                        Spacer()
                    }.padding(.top, 32)
                    
                    // frequência cardíaca
                    HStack(alignment: .top) {
                        
                        Image(systemName: "cross")
                            .foregroundStyle(.verde04)
                            .padding(.top, 4)
                        
                        DisclosureGroup("Frequência cardíaca") {
                            VStack(alignment: .center) {
                                Text("\(media) BPM")
                                    .font(.title)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .padding()
                                
                                Chart {
                                    ForEach(bpmData.indices, id: \.self) { index in
                                    //linha do grafico
                                        LineMark(
                                            x: .value("Tempo", bpmData[index].time),
                                            y: .value("BPM", bpmData[index].value)
                                        )
                                        .interpolationMethod(.monotone)
                                        .foregroundStyle(.red)
                                    //pontinhos no grafico
                                        PointMark(
                                            x: .value("Tempo", bpmData[index].time),
                                            y: .value("BPM", bpmData[index].value)
                                        )
                                        .symbolSize(9)
                                        .foregroundStyle(.black)
                                    }
                                }
                                .chartYScale(domain: 50...100)
                                .frame(height: 200)
                                .padding()
                                
                                Button(action: {
                                    if timer == nil {
                                        comecarmonitorar()
                                    } else {
                                        Pararmonitoramento()
                                    }
                                }) {
                                    Text(timer == nil ? "Iniciar" : "Parar")
                                        .padding()
                                        .background(timer == nil ? Color.blue : Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                            }
                            .padding(.vertical)
                            .padding(.leading, -40)
                            .onAppear {
                                generateInitialData()
                                calculateAverage()
                            }
                            
                        }.foregroundStyle(.black)
                        
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16.0)
                            .shadow(color: .verde05, radius: 20)
                            .foregroundStyle(.white)
                    ).padding(.top)
                    
                    // pressão do sangue
                    HStack(alignment: .top) {
                        Image(systemName: "cross")
                            .foregroundStyle(.verde04)
                            .padding(.top, 4)
                        
                        DisclosureGroup("Pressão do sangue") {
                            VStack (alignment: .center) {
                                Text("Pressão Arterial")
                                    .font(.title3.bold())
                                    .padding(.bottom)
                                
                                // Gráfico permanente
                                Chart(pressaoModel.medicoes) { medicao in
                                    BarMark(
                                        x: .value("Data", medicao.dataFormatada),
                                        y: .value("mmHg", medicao.valor)
                                    )
                                    .foregroundStyle(medicao.tipo == "sistolica" ? .red : .blue)
                                    .position(by: .value("Tipo", medicao.tipo))
                                    .annotation(position: .top) {
                                        Text("\(medicao.valor)")
                                            .font(.system(size: 12))
                                            .foregroundColor(.black)
                                    }
                                }
                                .chartYAxis {
                                    AxisMarks(position: .leading) { value in
                                        AxisGridLine()
                                        AxisValueLabel("\(value.as(Int.self) ?? 0)")
                                    }
                                }
                                .frame(height: 300)
                                .padding()
                                
                                
                                
                                // Legenda
                                HStack(spacing: 20) {
                                    HStack(spacing: 6) {
                                        Circle()
                                            .fill(.red)
                                            .frame(width: 20, height: 10)
                                        Text("Sistólica")
                                            .font(.caption)
                                    }
                                    
                                    HStack(spacing: 6) {
                                        Circle()
                                            .fill(.blue)
                                            .frame(width: 20, height: 10)
                                        Text("Diastólica")
                                            .font(.caption)
                                    }
                                }
                                .padding(.top)
                                
                                // Botão de simulação
                                Button(action: {
                                    pressaoModel.gerarNovosDados()
                                }) {
                                    HStack {
                                        Image(systemName: "play.fill")
                                        Text(pressaoModel.simulando ? "Monitorando" : "Iniciar Monitoramento")
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .background(pressaoModel.simulando ? Color.gray : Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                }
                                .disabled(pressaoModel.simulando)
                            }
                            .padding(.vertical)
                            .padding(.leading, -40)
                        }.foregroundStyle(.black)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16.0)
                            .shadow(color: .verde05, radius: 20)
                            .foregroundStyle(.white)
                    ).padding(.vertical)
                    
                    
                    // sono
                    // título
                    HStack() {
                        Text("Sono")                      
                            .font(.system(size: 24))
                            .fontWeight(.medium)
                            .padding(.top, 32)
                            .foregroundStyle(.white)
                            .shadow(color: .verde01, radius: 8)
                        Spacer()
                    }
                    
                    // gráfico
                    VStack(spacing: 20) {
                        // Cabeçalho
                        Text("Análise de Sono")
                            .font(.title2)
                        
                        // Seletor de Modo
                        Picker("Modo", selection: $viewModel.modoSelecionado) {
                            Text("Duração").tag(0)
                            Text("Fases").tag(1)
                            Text("Cronograma").tag(2)
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                        
                        // Gráfico Principal
                        ZStack {
                            
                            if viewModel.modoSelecionado == 0 {
                                Chart(viewModel.sessoes) { sessao in
                                    BarMark(
                                        x: .value("Dia", sessao.diaDaSemana),
                                        y: .value("Horas", sessao.horasTotais)
                                    )
                                    .foregroundStyle(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(red: 0.08, green: 0.35, blue: 0.72),  // Azul marinho profundo
                                                Color(red: 0.25, green: 0.65, blue: 0.95),   // Azul médio
                                                Color(red: 0.45, green: 0.85, blue: 1.00),    // Azul céu
                                                Color(red: 0.75, green: 0.92, blue: 1.00)     // Azul gelo claro
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .cornerRadius(6)
                                    .shadow(color: .blue.opacity(0.15), radius: 4, y: 3)
                                    .annotation(position: .top) {
                                        Text("\(sessao.horasTotais, specifier: "%.1f")h")
                                            .font(.system(size: 14))
                                            .foregroundStyle(.black)
                                    }
                                }
                                .frame(height: 280)
                                .padding()
                            } else if viewModel.modoSelecionado == 1 {
                                Chart {
                                    ForEach(FaseSono.allCases, id: \.self) { fase in
                                        BarMark(
                                            x: .value("Fase", fase.rawValue),
                                            y: .value("Horas", viewModel.horasPorFase(fase))
                                        )
                                        .foregroundStyle({
                                            switch fase {
                                            case .profundo: return Color(red: 0.12, green: 0.32, blue: 0.68)
                                            case .leve: return Color(red: 0.38, green: 0.75, blue: 0.97)
                                            case .rem: return Color(red: 0.52, green: 0.23, blue: 0.89)
                                            case .acordado: return Color(red: 0.96, green: 0.51, blue: 0.21)
                                            }
                                        }())
                                    }
                                }
                                .frame(height: 280)
                                .padding()
                            } else {
                                Chart {
                                    ForEach(viewModel.sessoes) { sessao in
                                        ForEach(FaseSono.allCases, id: \.self) { fase in
                                            if let tempo = sessao.tempoPorFase[fase] {
                                                BarMark(
                                                    x: .value("Dia", sessao.diaDaSemana),
                                                    y: .value("Horas", tempo / 3600)
                                                )
                                                .foregroundStyle({
                                                    switch fase {
                                                    case .profundo: return Color(red: 0.12, green: 0.32, blue: 0.68)
                                                    case .leve: return Color(red: 0.38, green: 0.75, blue: 0.97)
                                                    case .rem: return Color(red: 0.52, green: 0.23, blue: 0.89)
                                                    case .acordado: return Color(red: 0.96, green: 0.51, blue: 0.21)
                                                    }
                                                }())
                                            }
                                        }
                                    }
                                }
                                .frame(height: 280)
                                .padding()
                            }
                        }
                        
                        // Legenda
                        HStack(spacing: 20) {
                            ForEach(FaseSono.allCases, id: \.self) { fase in
                                HStack(spacing: 6) {
                                    Circle()
                                        .fill({
                                            switch fase {
                                            case .profundo: return Color(red: 0.12, green: 0.32, blue: 0.68)
                                            case .leve: return Color(red: 0.38, green: 0.75, blue: 0.97)
                                            case .rem: return Color(red: 0.52, green: 0.23, blue: 0.89)
                                            case .acordado: return Color(red: 0.96, green: 0.51, blue: 0.21)
                                            }
                                        }())
                                        .frame(width: 12, height: 12)
                                    Text(fase.rawValue)
                                        .font(.system(size: 12))
                                }
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16.0)
                            .shadow(color: .verde05, radius: 20)
                            .foregroundStyle(.white)
                    ).padding(.vertical)
                    
                }.padding()
                
            } // scrollview
        }
    }
    
    func generateInitialData() {
        let now = Date()
        let baseValue = 80
        for i in 0..<10 {
            let time = now.addingTimeInterval(Double(-(10 - i) * 2))
            let variation = Int.random(in: -2...2)
            let value = baseValue + variation
            bpmData.append(BPMData(value: value, time: time))
        }
    }
    
    func comecarmonitorar() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                if bpmData.count > 20 {
                    bpmData.removeFirst()
                }
                let lastValue = bpmData.last?.value ?? 72
                let variation = Int.random(in: -3...3)
                let newValue = max(min(lastValue + variation, 100), 70)
                
                bpmData.append(BPMData(value: newValue, time: Date()))
                calculateAverage()
            }
        }
    }
    
    func Pararmonitoramento() {
        timer?.invalidate()
        timer = nil
    }
    
    // Calcula a média dos últimos 5 valores
    func calculateAverage() {
        let lastValues = bpmData.suffix(10).map { $0.value }
        let sum = lastValues.reduce(0, +)
        media = sum / lastValues.count
    }
    
}

struct SimpleBPMView_Previews: PreviewProvider {
    static var previews: some View {
        MonitoramentoView()
    }
}

#Preview {
    MonitoramentoView()
}
