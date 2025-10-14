//
//  FoundationManager.swift
//  Challenge09
//
//  Created by Ana Luisa Teixeira Coleone Reis on 14/10/25.
//

import Foundation
import FoundationModels

struct FoundationManager {
    private let instructions = """
        You are a weather companion. Write a short, friendly and uplifting message based on today’s weather. Respond only with the final message, no explanations.
        """
    
    // Pega o input e aplica as instruções que passamos para o modelo
    public func generateWeatherMessage(for input: String) async throws -> String {
        // Verifica a disponibilidade no dispositivo
        guard SystemLanguageModel.default.isAvailable else {
            return input
        }
        
        let session = LanguageModelSession(instructions: instructions)
        
        let seed = UInt64(Calendar.current.component(.dayOfYear, from: .now))
        
        // Mantém a mesma recomendação durante o dia usando uma seed estável, a cada novo dia a seed muda e gera uma nova resposta
        let sampling = GenerationOptions.SamplingMode.random(top: 10, seed: seed)
        
        // Os parâmetros sampling e temperature controlam a forma como o modelo escolhe a resposta final e a criatividade
        let options = GenerationOptions(sampling: sampling, temperature: 0.7)
        
        // Obtem o conteúdo do texto retornado pelo modelo
        let response = try await session.respond(to: input, options: options)
        return response.content
        
    }
}
