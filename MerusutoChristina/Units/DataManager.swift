import UIKit
import SwiftyJSON
import Reachability
import SystemConfiguration

class DataManager: NSObject {

    static var switchToReserve = false

    class func loadJSONWithSuccess(key: String, success: @escaping ((_ data: JSON?) -> Void)) {
        checkVersionWithSuccess("\(key).json", success: { (needUpdate) -> Void in
            if needUpdate {
                self.loadGithubDataWithSuccess(key: "\(key).json", success: { (data) -> Void in
                    success(JSON(data: data!))
                })
            } else {
                self.loadDataWithSuccess(key: "\(key).json", success: { (data) -> Void in
                    success(JSON(data: data!))
                })
            }
        })
    }

    class func loadImageWithSuccess(key: String, success: @escaping ((_ data: UIImage) -> Void)) {
        loadDataWithSuccess(key: "\(key).png", success: { (data) -> Void in
            success(UIImage(data: data!)!)
        })
    }

    class func checkVersionWithSuccess(_ key: String, success: @escaping ((_ needUpdate: Bool) -> Void)) {
        if Reachability.forLocalWiFi().currentReachabilityStatus() != NetworkStatus.ReachableViaWiFi {
            success(false)
            return
        }

        let localFileUrl = self.getLocalFileURL("\(key).version")
        loadDataFromURL(url: localFileUrl, completion: { (data, readError) -> Void in
            if let localData = data {
                self.loadGithubDataWithSuccess(key: "\(key).version", success: { (data) -> Void in
                    if localData == data {
                        success(false)
                    } else {
                        success(true)

                    }
                })
            } else {

                self.loadGithubDataWithSuccess(key: "\(key).version", success: { (data) -> Void in })
                success(true)
            }
        })
    }

    class func loadDataWithSuccess(key: String, success: @escaping ((_ data: Data?) -> Void)) {
        let localFileUrl = self.getLocalFileURL(key)
        loadDataFromURL(url: localFileUrl, completion: { (data, readError) -> Void in
            if let localData = data {
                print("Read file from Local System: \(localFileUrl)")
                success(localData)
            } else {
                self.loadGithubDataWithSuccess(key: key, success: success)
            }
        })
    }

    class func loadGithubDataWithSuccess(key: String, success: @escaping ((_ data: Data?) -> Void)) {
        let localFileUrl = self.getLocalFileURL(key)
        var githubUrl = self.getGithubURL(key)
        loadDataFromURL(url: githubUrl, completion: { (data, responseError) -> Void in
            if let remoteData = data {
                print("Read file from Github: ", githubUrl)
                success(remoteData)

                do {
                    try FileManager.default.createDirectory(at: localFileUrl.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)

                } catch {
                    print(error)
                }

                try! remoteData.write(to: localFileUrl, options: Data.WritingOptions.atomic)

            } else {

                // 如果加载失败，切换到备用服务器再尝试加载
                switchToReserve = true
                githubUrl = self.getGithubURL(key)
                print("Switch to reserve")

                loadDataFromURL(url: githubUrl, completion: { (data, error) -> Void in
                    if let remoteData = data {
                        print("Read file from Reserve: \(githubUrl)")
                        success(remoteData)

                        do {
                            try FileManager.default.createDirectory(at: localFileUrl.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
                        } catch {
                            print(error)
                        }

                        try! remoteData.write(to: localFileUrl, options: Data.WritingOptions.atomic)
                    } else {
                        // 如果还是失败，尝试读取本地文件
                        self.loadDataFromURL(url: localFileUrl, completion: { (data, error) -> Void in
                            if let localData = data {
                                print("Github unavailable, read file from Local System: \(localFileUrl)")
                                success(localData)
                            } else {
                                print("Github and Local System unavailable, Game over!")
                            }
                        })
                    }
                })
            }
        })
    }

    class func getLocalFileURL(_ key: String) -> URL {
        let baseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return baseURL.appendingPathComponent(key)
    }

    //此地址可以用JSPatch来修改，避免小伙伴们又换服务器地址
    dynamic class func getGithubURL(_ key: String) -> URL {
        return URL(string: "https://merusuto.oschina.io/data/")!.appendingPathComponent(key)
    }

    class func loadDataFromURL(url: URL, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        let loadDataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            if let responseError = error {
                completion(nil, responseError)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    let statusError = NSError(domain: "com.bbtfr", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP status code has unexpected value."])
                    completion(data, statusError)
                } else {
                    completion(data, nil)
                }
            } else {
                completion(data, nil)
            }
        })

        loadDataTask.resume()
    }
}
