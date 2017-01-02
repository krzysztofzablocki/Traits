//
//  TraitsProvider+FileDaemon.swift
//  Pods
//
//  Created by Krzysztof Zabłocki on 28/07/16.
//
//

import Foundation
import ObjectMapper
import KZFileWatchers

public extension TraitsProvider {

    /**
     Starts a file daemon observing the file with name `filename` on desktop directory, it will automatically create the file with current specification if it doesn't exist.

     - parameter filename: Name of the file on the user desktop folder. defaults to `traits.json`
     */
    public static func setupDesktopDaemon(_ filename: String = "traits.json") {
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            do {
                let specifications = Mapper().toJSONString(TraitsProvider.currentSpec, prettyPrint: true)
                let path = "/Users/\(FileWatcher.Local.simulatorOwnerUsername())/Desktop/\(filename)"
                if !FileManager.default.fileExists(atPath: path) {
                    try specifications?.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
                }

                let fw = FileWatcher.Local(path: path)
                try fw.start { changes in
                    switch changes {
                    case .noChanges:
                        break
                    case .updated(let data):
                        _ = try? self.reloadSpec(data)
                    }
                }
            } catch {
                print("Unable to start file daemon \(error)")
            }
        #endif
    }

    /**
     Starts a file daemon observing the remote URL.

     - parameter url: URL of the file to observe.
     */
    public static func setupRemoteDaemon(_ url: URL) {
        do {

            let fw = FileWatcher.Remote(url: url)
            try fw.start { changes in
                switch changes {
                case .noChanges:
                    break
                case .updated(let data):
                    _ = try? self.reloadSpec(data)
                }
            }
        } catch {
            print("Unable to start file daemon \(error)")
        }
    }
}
