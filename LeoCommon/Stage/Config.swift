//
//  LocalConfig.swift
//  LeoCommon
//
//  Created by 李理 on 2017/4/12.
//  Copyright © 2017年 李理. All rights reserved.
//

import Foundation

let ConfigDiskKey = "com.leo.common.config"

final public class Config {
    
    public static let shared: Config = Config()
    
    public var env:String? {
        return Bundle.main.infoDictionary?["env"] as? String
    }
    
    //默认配置项，随项目发布
    private var config:Dictionary<String, Any> {
        let path = Bundle.main.path(forResource: "config", ofType: "json")
        guard path != nil else { return [:] }
        let data = try?Data(contentsOf: URL.init(fileURLWithPath: path!))
        guard data != nil else { return [:] }
        let json = try?JSONSerialization.jsonObject(with: data!, options: .allowFragments)
        guard json != nil else { return [:] }
        let settings = json as! Dictionary<String, Any>
        var normal = settings["default"] as! Dictionary<String, Any>
        guard self.env != nil else { return normal }
        let local = settings[self.env!] as? Dictionary<String, Any>
        guard local != nil else { return normal }
        local!.forEach { (key, value) in
            normal[key] = value
        }
        return normal
    }
    //缓存配置项
    private var memory: Dictionary<String, Any> = [:]
    //持久化配置项
    private var disk: Dictionary<String, Any>
    
    private init() {
        let result = Storage.shared.value(ConfigDiskKey)
        let value = (try?result.dematerialize()) ?? [:]
        self.disk = value as! Dictionary<String, Any>
    }
    
    public func config(_ forKey:String) -> Any? {
        var value = self.memory[forKey]
        guard value == nil else { return value}
        value = self.disk[forKey]
        guard value == nil else { return value}
        return self.config[forKey]
    }
    
    public func config(_ value:Any, forKey:String, saveToDisk:Bool?) -> Void {
        if let saveToDisk = saveToDisk, saveToDisk {
            self.memory.removeValue(forKey: forKey)
            self.disk[forKey] = value
            Storage.shared.save(self.disk, forKey: ConfigDiskKey)
        } else {
            self.memory[forKey] = value
        }
    }
}
