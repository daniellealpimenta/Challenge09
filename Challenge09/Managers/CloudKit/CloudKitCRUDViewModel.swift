//
//  CloudKitCRUDViewModel.swift
//  PushWithFoundation
//
//  Created by Filipi Romão on 21/10/25.
//


import CloudKit
import Combine
import Foundation

struct PasseioModel: Hashable {
    let record: CKRecord
    let local: String
    let descricaoEvento: String
    let name: String
    let date: String
    let temperature: Double
    var precipitationChance: Double
    let humidity: Double
    let uvIndex: Int
    var condition: String
    let symbolWeather: String
    let recommendationDegree: Int
    

    func toCKRecord() -> CKRecord {
        let record = CKRecord(recordType: "Roles")
        record["name"] = name as CKRecordValue
        record["date"] = date as CKRecordValue
        record["local"] = local as CKRecordValue
        record["descricaoEvento"] = descricaoEvento as CKRecordValue
        record["temperature"] = temperature as CKRecordValue
        record["humidity"] = humidity as CKRecordValue
        record["uvIndex"] = uvIndex as CKRecordValue
        record["condition"] = condition as CKRecordValue
        record["symbolWeather"] = symbolWeather as CKRecordValue
        record["recommendationDegree"] = recommendationDegree as CKRecordValue
        record["preciptationChance"] = precipitationChance as CKRecordValue
        return record
    }
}

class CloudKitCRUDViewModel: ObservableObject {

    @Published var name: String = ""
    @Published var date: String = ""
    @Published var local: String = ""
    @Published var descricaoEvento: String = ""
    @Published var temperature: Double = 0.0
    @Published var humidity: Double = 0.0
    @Published var uvIndex: Int = 0
    @Published var symbolWeather: String = ""
    @Published var condition: String = ""
    @Published var recommendationDegree: Int = 0
    @Published var preciptationChance: Double = 0.0
    
    @Published var passeios: [PasseioModel] = []
    
    init() {
        fetchItems()
    }

    func addItem() {
        let novoPasseio = CKRecord(recordType: "Roles")
        novoPasseio["name"] = name
        novoPasseio["local"] = local
        novoPasseio["data"] = date
        novoPasseio["descricaoEvento"] = descricaoEvento
        novoPasseio["temperatura"] = temperature
        novoPasseio["humidity"] = humidity
        novoPasseio["uvIndex"] = uvIndex
        novoPasseio["condition"] = condition
        novoPasseio["symbolWeather"] = symbolWeather
        novoPasseio["recommendationDegree"] = recommendationDegree
        novoPasseio["preciptationChance"] = preciptationChance

        saveItem(record: novoPasseio)
    }

    func saveItem(record: CKRecord) {
        CKContainer.default().publicCloudDatabase.save(record) {
            returnedRecord,
            returnedError in
            print("record: \(String(describing: returnedRecord))")

        }
    }
    
    func fetchItems() {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Roles", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "data", ascending: false)]
        
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.resultsLimit = 50  // opcional
        
        var fetchedPasseios: [PasseioModel] = []
        
        queryOperation.recordFetchedBlock = { record in
            guard let name = record["name"] as? String else{return}
            guard let date = record["data"] as? String else{return}
            guard let local = record["local"] as? String else{return}
            guard let descricaoEvento = record["descricaoEvento"] as? String else{return}
            guard let temperature = record["temperatura"] as? Double else{return}
            guard let humidity = record["humidity"] as? Double else{return}
            guard let uvIndex = record["uvIndex"] as? Int else{return}
            guard let condition = record["condition"] as? String else{return}
            guard let symbolWeather = record["symbolWeather"] as? String else{return}
            guard let recommedationDegree = record["recommendationDegree"] as? Int else{return}
            guard let preciptationChance = record["preciptationChance"] as? Double else{return}
            
             fetchedPasseios.append(PasseioModel(record: record, local: local, descricaoEvento: descricaoEvento, name: name, date: date, temperature: temperature, precipitationChance: preciptationChance, humidity: humidity, uvIndex: uvIndex, condition: condition, symbolWeather: symbolWeather, recommendationDegree: recommedationDegree))
            print("Fetched record: \(record.recordID.recordName)")
        }
        
        queryOperation.queryResultBlock = { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("✅ Fetch concluído. Total: \(fetchedPasseios.count)")
                    self.passeios = fetchedPasseios
                case .failure(let error):
                    print("❌ Erro ao buscar registros: \(error.localizedDescription)")
                }
            }
        }
        
        CKContainer.default().publicCloudDatabase.add(queryOperation)
    }


}
