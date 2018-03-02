
//  Authentication.swift
//  LinComm
//
//  Created by lin on 12/01/2018.
//  Copyright © 2018 lin. All rights reserved.
//

import Foundation
import LinUtil

public protocol Authentication{
    func auth()->String
    func badAuth();
}

public class BaseAuthentication : Authentication{
    
    fileprivate var username:String!;
    fileprivate var password:String!;
    
    public init(username:String,password:String){
        self.username = username;
        self.password = password;
    }
    
    public func auth() -> String {
        
        let data = "\(username ?? ""):\(password ?? "")".data(using: String.Encoding.utf8);
        let s = data?.base64EncodedString() ?? "";
        return "Basic \(s)";
    }
    
    public func badAuth(){}
}

public protocol OAuth2TokenStore{
    func store(token:OAuth2Token!)
    func load()->OAuth2Token!
}

public class LocaleOAuth2TokenStore : OAuth2TokenStore{
    
    private let store:KeyValueStorage;
    public init(name:String){
        store = KeyValueStorage.init(name: name)
    }
    public func store(token: OAuth2Token!) {
        store.setItem(key: "oauth2_token", value: token?.toString() ?? "")
    }
    
    public func load() -> OAuth2Token! {
        return OAuth2Token.loadToken(store.getItem(key: "oauth2_token") ?? "")
    }
    
    
}

public class OAuth2Token{
    
    private var _accessToken:String?
    private var _tokenType:String?
    private var _refreshToken:String?
    private var _scope:String?
    private var _expiresIn:Int64?
    private var _jti:String?
    private var _openId:String?
    
    private var _type = OAuth2GrantType.password
    
    public var type:OAuth2GrantType{
        return _type
    }
    public var accessToken:String{
        return _accessToken ?? ""
    }
    public var tokenType:String{
        return _tokenType ?? ""
    }
    public var refreshToken:String{
        return _refreshToken ?? ""
    }
    public var scope:String{
        return _scope ?? ""
    }
    public var expiresIn:Int64{
        return _expiresIn ?? 0
    }
    public var jti:String{
        return _jti ?? ""
    }
    public var openId:String{
        return _openId ?? ""
    }
    
    private var str:String?;
    
    public func toString()->String{
        return str ?? "";
    }
    
    public class func loadToken(_ str :String)->OAuth2Token!{
        return loadToken(str, type: nil)
    }
    
    fileprivate class func loadToken(_ str :String,type:OAuth2GrantType?)->OAuth2Token!{
        let json = Json.init(string: str)
        if json.isError {
            return nil;
        }
        
        let token = OAuth2Token();
        token._accessToken = json["access_token"].asString("")
        token._refreshToken = json["refresh_token"].asString("")
        token._tokenType = json["token_type"].asString("basic")
        token._jti = json["jti"].asString("")
        token._scope = json["scope"].asString("")
        token._openId = json["openId"].asString("")
        
        var exp = json["expires_in"].asInt64(0)
        
        if exp < 300 {
            exp = exp / 2
        }else{
            exp -= 300
        }
        if exp < 60 {
            exp = 60
        }
        
        exp += Int64(Date.init().timeIntervalSince1970)
        
        token._expiresIn = exp;
        
        if let type = type {
            json.setValue(type.rawValue, forName: "type")
            token._type = type;
            token.str = json.description
        }else{
            if json["type"].asString == "password"{
                token._type = .password
            }else{
                token._type = .client
            }
            token.str = str
        }
        
        return token;
    }
}

public enum OAuth2GrantType : String{
    case password = "password"
    case client = "client_credentials"
}

public class OAuth2Authentication : Authentication{
    
    fileprivate class InMoneryOAuth2TokenStore : OAuth2TokenStore{
        func store(token: OAuth2Token!) {
            
        }
        
        func load()->OAuth2Token!{
            return nil;
        }
    }
    
    private let base = BaseAuthentication(username: "", password: "")
    public var clientId:String = ""{
        didSet{
            base.username = clientId;
        }
    }
    public var secret:String = ""{
        didSet{
            base.password = secret;
        }
    }
    public var username:String = ""
    public var password:String = ""
    
    private var _grantType = OAuth2GrantType.password
    public var grantType:OAuth2GrantType{
        get{return _grantType}
        set{
            if _grantType == newValue {
                return
            }
            _grantType = newValue
            token = nil
        }
    }
    public var scope = "";
    
    private var tokenUrl:String;
    private var refreshUrl:String?;
    
    public var tokenStore:OAuth2TokenStore = InMoneryOAuth2TokenStore(){
        didSet{
            _token = tokenStore.load()
            _grantType = _token?.type ?? .password
        }
    }
    
    private var _token:OAuth2Token?
    private var token:OAuth2Token?{
        get{return _token;}
        set{
            _token = newValue;
            tokenStore.store(token: token);
        }
    }
    private var refreshing = false
    
    public init(tokenUrl:String,refreshUrl:String? = nil){
        self.tokenUrl = tokenUrl
        self.refreshUrl = refreshUrl
    }
    
    public func auth() -> String {
        if let token = token {
            if Double(token.expiresIn) < Date.init().timeIntervalSince1970 {
                Queue.asynQueue {[weak self] in
                    if token.type == .password {
                        self?.refreshToken()
                    }else{
                        self?.getToken(.client)
                    }
                }
            }
            return "\(token.tokenType) \(token.accessToken)"
        }
        getToken(self.grantType);
        if let token = token {
            return "\(token.tokenType) \(token.accessToken)"
        }
        return "";
    }
    
    public func badAuth() {
        self.token = nil;
    }
    private func refreshToken(){
        if refreshing {
            return
        }
        objc_sync_enter(self)
        if refreshing {
            objc_sync_exit(self)
            return
        }
        refreshing = true;
        objc_sync_exit(self)
        
        let semaphore = tokenImpl(type:.password,queryString: "grant_type=refresh_token&refresh_token=\(token?.refreshToken ?? "")")
        _ = semaphore.wait(timeout: DispatchTime.init(uptimeNanoseconds: DispatchTime.now().uptimeNanoseconds + 20 * 1000 * 1000 * 1000))
        
        objc_sync_enter(self)
        refreshing = false
        objc_sync_exit(self)
    }
    private func tokenImpl(type : OAuth2GrantType,queryString:String)->DispatchSemaphore{
        let url = URL.init(string: tokenUrl)
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0);
        
        request.httpMethod = "POST";
        
        request.setValue("application/x-www-form-urlencoded; charset=utf-8",forHTTPHeaderField:"Content-Type")
        
        request.setValue(base.auth(),forHTTPHeaderField:"Authorization")
        request.httpBody = queryString.data(using: String.Encoding.utf8)
        
        let config:URLSessionConfiguration = URLSessionConfiguration.default;
        let session = Foundation.URLSession(configuration: config, delegate: nil, delegateQueue: nil)
        
        let semaphore = DispatchSemaphore(value: 0)
        
        session.dataTask(with: request) {[weak self] (data, response, error) in
            
            if error != nil {
                self?.token = nil;
            }else{
                let resp = response as! HTTPURLResponse;
                if resp.statusCode == 200 {
                    let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as String? ?? ""
                    self?.token = OAuth2Token.loadToken(str,type: type);
                }else{
                    self?.token = nil;
                }
            }
            
            semaphore.signal();
            
            }.resume();
        
        return semaphore;
    }
    
    private func getToken(_ type : OAuth2GrantType){
        let queryString:String!;
        if grantType == OAuth2GrantType.password {
            queryString = "grant_type=\(grantType)&username=\(username)&password=\(password)&scope=\(scope)"
        }else{
            queryString = "grant_type=client_credentials"
        }
        let semaphore = tokenImpl(type:type,queryString: queryString)
        _ = semaphore.wait(timeout: DispatchTime.init(uptimeNanoseconds: DispatchTime.now().uptimeNanoseconds + 5 * 1000 * 1000 * 1000))
    }
}


