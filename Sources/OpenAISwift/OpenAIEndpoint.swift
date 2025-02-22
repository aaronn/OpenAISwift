//
//  Created by Adam Rush - OpenAISwift
//

import Foundation
#if canImport(FoundationNetworking) && canImport(FoundationXML)
import FoundationNetworking
import FoundationXML
#endif

public struct OpenAIEndpointProvider {
    public enum API {
        case completions
        case edits
        case chat
        case images
        case embeddings
        case moderations
        case imageedits
        case imagevariations
    }
    
    public enum Source {
        case openAI
        case proxy(path: ((API) -> String), method: ((API) -> String))
    }
    
    public let source: Source
    
    public init(source: OpenAIEndpointProvider.Source) {
        self.source = source
    }
    
    func getPath(api: API) -> String {
        switch source {
        case .openAI:
            switch api {
                case .completions:
                    return "/v1/completions"
                case .edits:
                    return "/v1/edits"
                case .chat:
                    return "/v1/chat/completions"
                case .images:
                    return "/v1/images/generations"
                case .embeddings:
                    return "/v1/embeddings"
                case .moderations:
                    return "/v1/moderations"
                case .imageedits:
                    return "/v1/images/edits"
                case .imagevariations:
                    return "/v1/images/variations"
            }
        case let .proxy(path: pathClosure, method: _):
            return pathClosure(api)
        }
    }
    
    func getMethod(api: API) -> String {
        switch source {
        case .openAI:
            switch api {
            case .completions, .edits, .chat, .images, .embeddings, .moderations, .imageedits, .imagevariations:
                return "POST"
            }
        case let .proxy(path: _, method: methodClosure):
            return methodClosure(api)
        }
    }
}
