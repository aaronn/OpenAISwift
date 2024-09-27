//
//  File.swift
//  
//
//  Created by Mark Hoath on 15/11/2023.
//

import Foundation

public struct CodeInterpreterTool: Codable {
    public let type: String

    public init(type: String) {
        self.type = type
    }
}

public struct RetrievalTool: Codable {
    public let type: String

    public init(type: String) {
        self.type = type
    }
}

public struct ParamJSONObject: Codable {
    public let type: String //
    public let properties: [String: [String: String]]
    public let required: [String]

    public init(type: String = "object", properties: [String: [String: String]] = [:], required: [String] = []) {
        self.type = type
        self.properties = properties
        self.required = required
    }
}

public struct FunctionObject: Codable {
    public let description: String
    public let name: String
    public let parameters: ParamJSONObject

    public init(description: String, name: String, parameters: ParamJSONObject) {
        self.description = description
        self.name = name
        self.parameters = parameters
    }
}

public struct FunctionTool: Codable {
    public let type: String
    public let function: FunctionObject

    public init(type: String, function: FunctionObject) {
        self.type = type
        self.function = function
    }
}

public struct Tool: Codable {
    public let codeInterpreterTool: CodeInterpreterTool?
    public let retrievalTool: RetrievalTool?
    public let functionTool: FunctionTool?

    enum CodingKeys: String, CodingKey {
        case type, function
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        switch type {
        case "function":
            let function = try container.decode(FunctionObject.self, forKey: .function)
            self.functionTool = FunctionTool(type: type, function: function)
            self.codeInterpreterTool = nil
            self.retrievalTool = nil
        // Add cases for other tool types
        default:
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Unknown tool type")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let functionTool = functionTool {
            try container.encode("function", forKey: .type)
            try container.encode(functionTool.function, forKey: .function)
        }
        // Todo: Add similar handling for codeInterpreterTool and retrievalTool.
    }

    public init(codeInterpreterTool: CodeInterpreterTool?, retrievalTool: RetrievalTool?, functionTool: FunctionTool?) {
        self.codeInterpreterTool = codeInterpreterTool
        self.retrievalTool = retrievalTool
        self.functionTool = functionTool
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
    public let tools: [Tool]
    public let file_ids: [String]
    public let metadata: [String:String]
}

public struct AssistantBody: Codable {
    public let model: String
    public let name: String?
    public let description: String?
    public let instructions: String?
    public let tools: [Tool]?
    public let file_ids: [String]?
    public let metadata: [String:String]?
}

public struct ListAssistantParams: Codable {
    public let limit: Int?
    public let order: String?
    public let after: String?
    public let before: String?
}
