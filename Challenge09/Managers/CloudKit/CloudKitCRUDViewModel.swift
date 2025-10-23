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
    let name: String
    let record: CKRecord
    let data: Date
    let local: String
    let descricaoEvento: String
    let weatherContent: String
    let temperatura: Double
    let humidity: Double
    let uvIndex: Int
    let symbolWeather: String
    let recommendationDegree: Int
    let preciptationChance: Double
    

    func toCKRecord() -> CKRecord {
        let record = CKRecord(recordType: "Passeio")
        record["name"] = name as CKRecordValue
        record["data"] = data as CKRecordValue
        record["local"] = local as CKRecordValue
        record["descricaoEvento"] = descricaoEvento as CKRecordValue
        record["weatherContent"] = weatherContent as CKRecordValue
        record["temperatura"] = weatherContent as CKRecordValue
        record["humidity"] = weatherContent as CKRecordValue
        record["uvIndex"] = weatherContent as CKRecordValue
        record["symbolWeather"] = weatherContent as CKRecordValue
        record["recommendationDegree"] = weatherContent as CKRecordValue
        record["preciptationChance"] = weatherContent as CKRecordValue
        return record
    }
}

class CloudKitCRUDViewModel: ObservableObject {

    @Published var text: String = ""
    @Published var local: String = ""
    @Published var passeios: [PasseioModel] = []
    @Published var temperatura: Double = 0.0
    @Published var humidity: Double = 0.0
    @Published var uvIndex: Int = 0
    @Published var symbolWeather: String = ""
    @Published var recommendationDegree: Int = 0
    @Published var preciptationChance: Double = 0.0
    
    init(){
        fetchItems()
    }

    func addItem() {
        let novoPasseio = CKRecord(recordType: "Passeios")
        novoPasseio["name"] = text
        novoPasseio["local"] = local
        let data = Date.now
        novoPasseio["data"] = data
        novoPasseio["descricaoEvento"] = "Passeio ao ar livre"
        novoPasseio["weatherContent"] = "parcialmente nublado"
        novoPasseio["temperatura"] = temperatura
        novoPasseio["humidity"] = humidity
        novoPasseio["uvIndex"] = uvIndex
        novoPasseio["symbolWeather"] = symbolWeather
        novoPasseio["recommendationDegree"] = recommendationDegree
        novoPasseio["preciptationChance"] = preciptationChance

        saveItem(record: novoPasseio)
    }

    func saveItem(record: CKRecord) {
        CKContainer.default().publicCloudDatabase.save(record) {
            returnedRecord,
            returnedError in
            print("record: \(returnedRecord)")

            DispatchQueue.main.async {
                self.text = ""
                self.local = ""
            }
        }
    }
    
    func fetchItems() {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Passeios", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "data", ascending: false)]
        
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.resultsLimit = 50  // opcional
        
        var fetchedPasseios: [PasseioModel] = []
        
        queryOperation.recordFetchedBlock = { record in
            guard let name = record["name"] as? String else{return}
            guard let data = record["data"] as? Date else{return}
            guard let local = record["local"] as? String else{return}
            guard let descricaoEvento = record["descricaoEvento"] as? String else{return}
            guard let weatherContent = record["weatherContent"] as? String else{return}
            guard let temperatura = record["temperatura"] as? Double else{return}
            guard let humidity = record["humidity"] as? Double else{return}
            guard let uvIndex = record["uvIndex"] as? Int else{return}
            guard let symbolWeather = record["symbolWeather"] as? String else{return}
            guard let recommedationDegree = record["recommedationDegree"] as? Int else{return}
            guard let preciptationChance = record["preciptationChance"] as? Double else{return}
            
             fetchedPasseios.append(PasseioModel(name: name, record: record, data: data, local: local, descricaoEvento: descricaoEvento, weatherContent: weatherContent, temperatura: temperatura, humidity: humidity, uvIndex: uvIndex, symbolWeather: symbolWeather, recommendationDegree: recommedationDegree, preciptationChance: preciptationChance))
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
