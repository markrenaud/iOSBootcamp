import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

// 📌 Requirement:
// ✅ A struct for coding the JSON response from https://catfact.ninja/fact

struct CatFact: Codable {
    let fact: String
    let length: Int
}

struct CatFactService {
    
    static let defaultEndpoint = URL(string: "https://catfact.ninja/fact")!
    
    /// The API endpoint for Cat Facts
    let endpoint: URL
    
    init(endpoint: URL = defaultEndpoint) {
        self.endpoint = endpoint
    }
    
    /// Retrieves a random CatFact from catfact.ninja using URLSession.shared.
    func retrieveFact() async throws -> CatFact {
        let (data, _) = try await URLSession.shared.data(from: endpoint)
        return try JSONDecoder().decode(CatFact.self, from: data)
    }
    
}

// 📌 Requirement:
// ✅ A struct for the AsyncSequence

struct CatFactSequence: AsyncSequence {
    typealias Element = CatFact
    
    /// The CatFactService to use
    let service: CatFactService
    /// The maximum number of cat facts to be emitted before terminating the sequence.
    let maxFacts: UInt
    
    init(maxFacts: UInt, using service: CatFactService = CatFactService()) {
        self.service = service
        self.maxFacts = maxFacts
    }
    
    // 📌 Requirement:
    // ✅ A struct for the Iterator
    
    struct CatFactIterator: AsyncIteratorProtocol {
        /// The maximum number of cat facts to be emitted before terminating the sequence.
        let maxFacts: UInt
        /// The CatFactService to use
        let service: CatFactService
        
        private var factsReturned = 0
        
        init(maxFacts: UInt, service: CatFactService) {
            self.maxFacts = maxFacts
            self.service = service
        }
        
        mutating func next() async throws -> CatFact? {
            // double-check task has not been cancelled - throw if it has
            try Task.checkCancellation()
            // Check if max cat facts has been reached.
            // If max cat facts have been emitted, end the sequence
            // by returning nil
            guard factsReturned < maxFacts else { return nil }
            // retrieve a random cat fact
            let fact = try await service.retrieveFact()
            // if we have successfully retrieved, increment
            // counter and return the fact to the sequence
            factsReturned += 1
            return fact
        }
    }
    
    func makeAsyncIterator() -> CatFactIterator {
        return CatFactIterator(maxFacts: maxFacts, service: service)
    }
}

// 📌 Requirement:
// ✅ A function that uses the iterator to get Cat Facts.
// ✅ The function must have a parameter that allows the user to set the number of Cat Facts to get.

/// Prints a specified number of cat facts to the console.
func logCatFacts(count: UInt) {
    Task {
        do {
            for try await catFact in CatFactSequence(maxFacts: count) {
                print(catFact.fact)
            }
        } catch {
            print("An error occured retrieving cat facts:", error.localizedDescription)
        }
    }
}

logCatFacts(count: 5)
