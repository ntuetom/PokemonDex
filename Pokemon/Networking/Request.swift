//
//  Request.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/3/29.
//

import Moya
import RxSwift

let requestShared = PokemonRequest.shared
public class PokemonRequest: NSObject {
    
    static let shared = PokemonRequest()
    var provider: MoyaProvider<PokeAPI>!
    
    override init() {
        super.init()
        let plugins = [logPluging]
        provider = MoyaProvider<PokeAPI>(plugins: plugins)
    }
    
    lazy var logPluging: PokemonRequestPlugin = {
        return PokemonRequestPlugin()
    }()
    
    
//    lazy var loadingPluging = NetworkActivityPlugin{ (type, target) in
//        switch type{
//        case .began:
//            k_RefreshView.toggle(isOn: true)
//        case .ended:
//            k_RefreshView.toggle(isOn: false)
//        }
//    }
    
    func request<T: Decodable>(target: PokeAPI) -> Single<Result<T,ParseResponseError>> {
        return Single.create{ [unowned self] single in
            self.provider.request(target) { responseResult in
                switch responseResult{
                case let .success(response):
                    if response.statusCode == 200 {
                        do {
                            let tempObj = try JSONDecoder().decode(T.self, from: response.data)
                            single(.success(.success(tempObj)))
                        } catch (let error) {
                            let _error = ParseResponseError.parseError(errMsg: error.localizedDescription)
                            single(.failure(_error))
                        }
                    } else {
                        let _error = ParseResponseError.respnseError(errCode: "\(response.statusCode)", errMsg: response.description)
                        single(.failure(_error))
                    }
                case let .failure(error):
                    let _error = ParseResponseError.respnseError(errCode: "", errMsg: error.localizedDescription)
                    single(.failure(_error))
                }
            }
            return Disposables.create()
        }
    }
}

struct PokemonRequestPlugin: PluginType {
    func willSend(_ request: RequestType, target: TargetType) {
        print("start")
        print(request.request?.url ?? "")
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        print("end")
        switch result {
        case .success(let response):
            print("end success")
            print(response.request?.url ?? "")
        case .failure(let error):
            print("end failure")
            print(error)
        }
    }
}
