//
//  File.swift
//  
//
//  Created by Mark Hoath on 15/11/2023.
//

import Foundation

public struct CodeInterpreterTool: Codable {
    public let type: String
}

public struct RetrievalTool: Codable {
    public let type: String
}

public struct ParamJSONObject: Codable {
    public let properties: String
}

public struct FunctionObject: Codable {
    public let description: String
    public let name: String
    public let parameters: ParamJSONObject
}

public struct FunctionTool: Codable {
    public let type: String
    public let function: FunctionObject
}

public struct Tools: Codable {
    public let codeInterpreterTool: CodeInterpreterTool?
    public let retrievalTool: RetrievalTool?
    public let functionTool: FunctionTool?

    enum CodingKeys: String, CodingKey {
        case type, function = "functionTool"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let functionTool = functionTool {
            try container.encode("function", forKey: .type)
            try container.encode(functionTool, forKey: .function)
        }
        // Todo: Add similar handling for codeInterpreterTool and retrievalTool.
    }
}

public struct AssistantObject: Codable {
    public let id: String
    public let object: String
    public let created_at: Int
    public let name: String?
    public let description: String?
    public let model: String
    public let instructions: String?
    public let tools: [Tools]
    public let file_ids: [String]
    public let metadata: [String:String]
}

public struct AssistantBody: Codable {
    public let model: String
    public let name: String?
    public let description: String?
    public let instructions: String?
    public let tools: [Tools]?
    public let file_ids: [String]?
    public let metadata: [String:String]?
}

public struct ListAssistantParams: Codable {
    public let limit: Int?
    public let order: String?
    public let after: String?
    public let before: String?
}
