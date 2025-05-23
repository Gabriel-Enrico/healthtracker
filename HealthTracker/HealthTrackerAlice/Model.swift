import Foundation

struct Paciente: Codable, Hashable{
    let _id: String
    let _rev: String
    let isMedico: Int
    let nome: String
    let data_nascimento: String
    let sexo: String
    let peso: Double
    let altura: Double
    let tipo_sanguineo: String
    let foto: String
    var ficha_medica: [FichasMedicas]
}

struct Medicamentos: Decodable, Hashable{
    let nome: String
    let funcao: String
}

struct MedicamentosPaciente: Codable, Hashable{
    let _id: String?
    let _rev: String?
    let nome: String
    let funcao: String
    let periodo: String
    var horario: String?
    let intervalo: String
    let idpaciente: String
}

struct FichasMedicas: Codable, Hashable{
    var arquivos: String
    var consultas: [String]
    var exames: [String]
    var orientacoes: [String]
    var idpaciente: String
}

enum FaseSono: String, CaseIterable {
    case profundo = "Profundo"
    case leve = "Leve"
    case rem = "REM"
    case acordado = "Acordado"
}

struct SessaoSono: Identifiable {
    let id = UUID()
    let data: Date
    let duracaoTotal: TimeInterval
    let tempoPorFase: [FaseSono: TimeInterval]
    
    var horasTotais: Double {
        duracaoTotal / 3600
    }
    
    var diaDaSemana: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt-BR")
        formatter.dateFormat = "EEE"
        return formatter.string(from: data)
    }
}

struct MedicaoPressao: Identifiable {
    let id = UUID()
    let data: Date
    let tipo: String // "sistolica" ou "diastolica"
    let valor: Int
    
    var dataFormatada: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter.string(from: data)
    }
}
