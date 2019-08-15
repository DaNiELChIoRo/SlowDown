//
//  SlowDown_Tests.swift
//  SlowDown!Tests
//
//  Created by Daniel Meneses on 8/2/19.
//  Copyright © 2019 Daniel Meneses. All rights reserved.
//

import XCTest
@testable import SlowDown_

class SlowDown_Tests_Home: XCTestCase {

    var presenter: HomePresenter!
    var mockHomeView: MockHomeView!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let url = URL(string: "https://datos.cdmx.gob.mx/api/v1/dataset=fotocivicas")
        
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        let session = URLSession(configuration: config)
        // attach that to some fixed data in our protocol handler
        URLProtocolMock.testURLs = [url: Data("Hacking with Swift!".utf8)]
        let api = API(network: Network(config: config, session: session))
        let coordinator = MainCoordinator(navigationController: UINavigationController())
        mockHomeView = MockHomeView()
        presenter = HomePresenter(api: api, coordinator: coordinator)
        presenter.attach(view: mockHomeView as HomeViewable)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mockHomeView = nil
        presenter = nil
    }

    func testFetcCamera() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        presenter.fetchCameras()
    }    

}

class MockHomeView: HomeViewable {
    func setup(presenter: HomePresentable) {
        print("Setup")
    }
    
    func showListButton(action: @escaping () -> Void) {
        
    }
    
    func draw(pins: [Camera]) {
        print("drawpins")
    }
}

class URLProtocolMock: URLProtocol {
    // this dictionary maps URLs to test data
    static var testURLs = [URL?: Data]()
    
    // say we want to handle all types of request
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    // ignore this method; just send back what we were given
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        // if we have a valid URL…
        if let url = request.url {
            // …and if we have test data for that URL…
            if let data = URLProtocolMock.testURLs[url] {
                // …load it immediately.
                self.client?.urlProtocol(self, didLoad: data)
            }
        }
        
        // mark that we've finished
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    // this method is required but doesn't need to do anything
    override func stopLoading() { }
}
