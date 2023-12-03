import Foundation

enum APIError: Error {
    case networkError
    case invalidResponse
   
}

class APIClient  {
    let baseURL: URL

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    func fetchData(path: String, parameters: [String: Any]) throws -> Data {
        
        let url = baseURL.appendingPathComponent(path)

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        if !parameters.isEmpty {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: String(describing: $0.value)) }
            request.url = components?.url
        }

        // Synkront....
        let semaphore = DispatchSemaphore(value: 0)
        var responseData: Data?
        var responseError: Error?

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            responseData = data
            responseError = error
            semaphore.signal()
        }.resume()

        semaphore.wait()
        
        if let error = responseError {
            throw error
        }

        guard let data = responseData else {
            throw APIError.invalidResponse
        }

        return data
    }
}
