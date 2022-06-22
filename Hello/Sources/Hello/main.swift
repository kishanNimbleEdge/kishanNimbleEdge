print("Hello, world!")
let main = Hello()

import Alamofire
import Foundation
public struct Hello {
    public private(set) var text = "Hello, World!"
    let connectionLayerViewModel = ConnectionLayerViewModel()
    public init() {
        self.header()
    }
    func header() {
        connectionLayerViewModel.sendRequest(serverAddress: "43.205.11.213", endpoint: "/register", port: 2608, reqBody: "{\"device-id\": \"abcd1\"}", reqHeaders: "{\"Content-Type\": \"application/json\"}")
    }
}
