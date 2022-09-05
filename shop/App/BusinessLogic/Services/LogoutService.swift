//
//  LogoutService.swift
//  shop
//
//  Created by Ke4a on 05.09.2022.
//

import Foundation

class LogoutService<Parser: ResponseParserProtocol> {
    var requestData: String?
    var data: Parser.Model?

    private let network: NetworkProtocol
    private let decoder: Parser

    init(_ network: NetworkProtocol, _ decoder: Parser) {
        self.network = network
        self.decoder = decoder

        requestData = "1234"
    }

    func fetchAsync() {
        guard let requestData = requestData else { return }

        DispatchQueue.global(qos: .background).async {
            self.network.fetch(.logout(requestData)) {
                // Отключил пока вызывается в appDelegate, так как там не сохраняется
                // [weak self]
                result in

                // guard let self = self else { return }

                switch result {
                case .success(let data):
                    do {
                        let response = try self.decoder.decode(data: data)
                        self.data = response
                        print(self.data)
                    } catch {
                        print(error)
                    }

                case .failure:
                    break
                }
            }
        }
    }
}
