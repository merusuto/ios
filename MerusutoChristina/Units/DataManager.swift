import Reachability
import SwiftyJSON
import UIKit

class DataManager: NSObject {
    class func loadJSONWithSuccess(key: String, success: @escaping ((_ data: JSON?) -> Void)) {
        checkVersionWithSuccess("\(key).json") { (needUpdate) -> Void in
            if needUpdate {
                loadGithubDataWithSuccess(key: "\(key).json") { (data) -> Void in
                    success(JSON(data: data!))
                }
            } else {
                loadDataWithSuccess(key: "\(key).json") { (data) -> Void in
                    success(JSON(data: data!))
                }
            }
        }
    }

    class func loadImageWithSuccess(key: String, success: @escaping ((_ data: UIImage) -> Void)) {
        loadDataWithSuccess(key: "\(key).png") { (data) -> Void in
            success(UIImage(data: data!)!)
        }
    }

    class func checkVersionWithSuccess(_ key: String, success: @escaping ((_ needUpdate: Bool) -> Void)) {
        if Reachability.forLocalWiFi().currentReachabilityStatus() != NetworkStatus.ReachableViaWiFi {
            success(false)
            return
        }

        let localFileUrl = getLocalFileURL("\(key).version")
        loadDataFromURL(url: localFileUrl) { (data, _) -> Void in
            if let localData = data {
                loadGithubDataWithSuccess(key: "\(key).version") { (data) -> Void in
                    if localData == data {
                        success(false)
                    } else {
                        success(true)
                    }
                }
            } else {
                loadGithubDataWithSuccess(key: "\(key).version") { (_) -> Void in }
                success(true)
            }
        }
    }

    class func loadDataWithSuccess(key: String, success: @escaping ((_ data: Data?) -> Void)) {
        let localFileUrl = getLocalFileURL(key)
        loadDataFromURL(url: localFileUrl) { (data, _) -> Void in
            if let localData = data {
                print("Read file from Local System: \(localFileUrl)")
                success(localData)
            } else {
                loadGithubDataWithSuccess(key: key, success: success)
            }
        }
    }

    class func loadGithubDataWithSuccess(key: String, success: @escaping ((_ data: Data?) -> Void)) {
        let localFileUrl = getLocalFileURL(key)
        let githubUrl = getGithubURL(key)

        loadDataFromURL(url: githubUrl) { (data, _) -> Void in
            if let remoteData = data {
                print("Read file from Github: ", githubUrl)
                success(remoteData)

                try? FileManager.default.createDirectory(at: localFileUrl.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
                try? remoteData.write(to: localFileUrl, options: Data.WritingOptions.atomic)
            } else {
                // 如果还是失败，尝试读取本地文件
                loadDataFromURL(url: localFileUrl) { (data, _) -> Void in
                    if let localData = data {
                        print("Github unavailable, read file from Local System: \(localFileUrl)")
                        success(localData)
                    } else {
                        print("Github and Local System unavailable, Game over!")
                    }
                }
            }
        }
    }

    class func getLocalFileURL(_ key: String) -> URL {
        let baseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return baseURL.appendingPathComponent(key)
    }

    @objc class func getGithubURL(_ key: String) -> URL {
        return URL(string: "https://merusuto.github.io/data/")!.appendingPathComponent(key)
    }

    class func loadDataFromURL(url: URL, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        let loadDataTask = URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
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
        }

        loadDataTask.resume()
    }
}
