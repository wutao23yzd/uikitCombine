//
//  AuthClient.swift
//  instagram_clone
//
//  Created by admin on 2025/6/17.
//

import Foundation
import ComposableArchitecture

struct User: Equatable, Codable, Hashable, Identifiable {
    let id: UUID
    var username: String
    var profileImageUrl: String?
    var fullname: String
    var bio: String?
    let email: String
}

extension User {
    static var MOCK_USERS: [User] = [
        User(id: UUID(), username: "钢铁侠", profileImageUrl: "iron_man", fullname: "钢铁侠", bio: "凡人之躯，肩比神明", email: "stack@gmail.com"),
        User(id: UUID(), username: "雷神", profileImageUrl: "ls", fullname: "索尔", bio: "今天天气真好！", email: "sewr@gmail.com"),
        User(id: UUID(), username: "美国队长", profileImageUrl: "mgdz", fullname: "美国队长", bio: "天佑美国！", email: "dfsdf@gmail.com"),
        User(id: UUID(), username: "海王", profileImageUrl: "iron_man", fullname: "海王", bio: "明天的天气很热，准备去海边散步玩耍，海水海水比较凉快", email: "sdfdf@gmail.com"),
        
        User(id: UUID(), username: "黑寡妇", profileImageUrl: "hgf", fullname: "斯佳丽", bio: "勇往之前，无所畏惧", email: "nindfdf@gmail.com"),
        User(id: UUID(), username: "鹰眼", profileImageUrl: "iron_man", fullname: "鹰眼", bio: "后面一周都会下雨，天气潮湿难耐", email: "oijkkdfr@gmail.com"),
        User(id: UUID(), username: "超人", profileImageUrl: "iron_man", fullname: "超人", bio: "高高的朝天门呢", email: "df00eeeesdf@gmail.com"),
        User(id: UUID(), username: "绿巨人", profileImageUrl: "iron_man", fullname: "绿巨人", bio: "SwiftUI + TCA 🚀", email: "sdfd423ddf@gmail.com"),
        
        User(id: UUID(), username: "蚁人", profileImageUrl: "iron_man", fullname: "微观世界，管中窥豹", bio: "🍕 > 🥗 你们觉得呢？", email: "43984rrck@gmail.com"),
        User(id: UUID(), username: "奇异博士", profileImageUrl: "iron_man", fullname: "遇见未来", bio: "天亮了，该起床吃早餐了", email: "soiew4wr@gmail.com"),
    ]
}

enum AuthError: LocalizedError, Equatable {
    case invalidCredentials
    case networkUnavailable
    case serverError
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "邮箱或密码错误"
        case .networkUnavailable:
            return "当前网络不可用"
        case .serverError:
            return "服务器开小差，请稍后再试"
        }
    }
}

struct AuthClient: Sendable {
    /// 登录: 成功回`User`， 失败抛`AuthError`
    var login: @Sendable (_ email: String, _ password: String) async throws -> User
    
    /// 登出
    var logout: @Sendable () async throws -> Void
}

enum AuthClientKey: DependencyKey {
    
    static let liveValue = AuthClient(
        login: { email, password in
            
            try await Task.sleep(nanoseconds: 1_000_000_000)
            
            return User(id: UUID(), username: "钢铁侠", profileImageUrl: "iron_man", fullname: "钢铁侠", bio: "凡人之躯，肩比神明", email: email)
            /*
            let dice = Int.random(in: 1...10)
            switch dice {
            case 1: throw AuthError.networkUnavailable
            case 2: throw AuthError.invalidCredentials
            default:
                return User(id: UUID(), username: "钢铁侠", profileImageUrl: "iron_man", fullname: "钢铁侠", bio: "凡人之躯，肩比神明", email: email)
            }
            */
        }, logout: {
            try await Task.sleep(nanoseconds: 300_000_000)
        }
    )
    
    static let previewValue = AuthClient(
        login: { email, _ in
            User(id: UUID(), username: "钢铁侠", profileImageUrl: "iron_man", fullname: "钢铁侠", bio: "凡人之躯，肩比神明", email: email)
        },
        logout: {})
}

extension DependencyValues {
    var authClient: AuthClient {
        get { self[AuthClientKey.self] }
        set { self[AuthClientKey.self] = newValue }
    }
}
