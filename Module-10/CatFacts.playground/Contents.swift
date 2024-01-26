import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

struct CatFact: Codable {
    let fact: String
    let length: Int
}

protocol CatFactService {
    func retrieveFact() async throws -> CatFact
    func logFacts(maxFacts: UInt) async throws
}

extension CatFactService {
    func logFacts(maxFacts: UInt) async throws {
        var count = 0
        let sequence = CatFactSequence(service: self) {
            count += 1
            return count <= maxFacts
        }
        for try await catFact in sequence {
            print(catFact.fact)
        }
    }
}

struct CatFactNinja: CatFactService {
    /// Retrieves a random CatFact from catfact.ninja using URLSession.shared.
    func retrieveFact() async throws -> CatFact {
        let endpoint = URL(string: "https://catfact.ninja/fact")!
        let (data, _) = try await URLSession.shared.data(from: endpoint)
        return try JSONDecoder().decode(CatFact.self, from: data)
    }
}

struct CatFactSequence: AsyncSequence {
    typealias Element = CatFact
    /// The CatFactService to use
    let service: CatFactService
    
    let hasNext: () -> Bool

    init(service: CatFactService, hasNext: @escaping () -> Bool = { true }) {
        self.service = service
        self.hasNext = hasNext
    }
    
    func makeAsyncIterator() -> CatFactIterator {
        return CatFactIterator(service: service, hasNext: hasNext)
    }
}

struct CatFactIterator: AsyncIteratorProtocol {
    /// The CatFactService to use
    let service: CatFactService
    
    let hasNext: () -> Bool

    mutating func next() async throws -> CatFact? {
        // double-check task has not been cancelled - throw if it has
        try Task.checkCancellation()
        // confirm we should continue against any passed in predicate
        // return nil to end sequence if iterator should not continue.
        if !hasNext() { return nil }
        // retrieve a random cat fact
        let fact = try await service.retrieveFact()
        return fact
    }
}

Task {
    let service = CatFactNinja()
    try await service.logFacts(maxFacts: 5)
}
