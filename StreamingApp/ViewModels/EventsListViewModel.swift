//
//  EventViewModel.swift
//  StreamingApp
//
//  Created by Kuda Zata on 24/6/2022.
//

import Foundation

protocol EventsDelegate {
    func didFetchEvents()
    func errorFetchingEvents(error: NetworkError)
}

class EventsListViewModel {
    
    init(eventsNetworkService: EventsNetworkServiceProtocol) {
        self.eventsNetworkService = eventsNetworkService
    }
    
    var events = [Event]()
    var eventsDelegate: EventsDelegate?
    var eventsNetworkService: EventsNetworkServiceProtocol?
    
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return events.count
    }
    
    func eventAtIndex(_ index: Int) -> EventViewModel {
        let event = self.events[index]
        return EventViewModel(event)
    }
    
    func getEvents() {
        
        eventsNetworkService?.getEvents { events, error in
            
            if let error = error {
                self.eventsDelegate?.errorFetchingEvents(error: error)
                return
            }
        
            if let events = events {
                self.events = events
                self.eventsDelegate?.didFetchEvents()
            }
            else {
                self.eventsDelegate?.errorFetchingEvents(error: .decodingError)
            }
        }
            
    }
}
