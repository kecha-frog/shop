//
//  ProductService.swift
//  shop
//
//  Created by Ke4a on 07.09.2022.
//

import Foundation

/// Product Service.
final class ProductService<Parser: DecoderResponseProtocol> {
    // MARK: - Private Properties

    private(set) var productId: Int
    private(set) var data: Parser.Model?

    private let network: NetworkProtocol
    private let decoder: Parser

    // MARK: - Initialization
    
    init(_ network: NetworkProtocol, _ decoder: Parser) {
        self.network = network
        self.decoder = decoder

        self.productId = 123
    }

    // MARK: - Public Methods

    /// Fetch async data.
    /// The decoded models are written to the date property.
    func fetchAsync() {
        DispatchQueue.global(qos: .background).async {
            self.network.fetch(.product(self.productId)) {
                // Отключил пока вызывается в appDelegate, так как там не сохраняется
                // [weak self]
                result in

                // guard let self = self else { return }

                do {
                    switch result {
                    case .success(let data):
                        let response = try self.decoder.decode(data: data)
                        self.data = response
                    case .failure(let error):
                        switch error {
                        case .clientError(let status, let data):
                            let decodeError = try self.decoder.decodeError(data: data)
                            print("status: \(status) \n\(decodeError)")
                        default:
                            throw error
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}
