//
//  ProspectsView.swift
//  Project16-HotProspects
//
//  Created by Daniel Braga Barbosa on 21/03/25.
//

import SwiftUI
import SwiftData

struct ProspectsView: View
{
    @Query(sort: \Prospect.name) var prospects: [Prospect]
    @Environment(\.modelContext) var modelContext
    
    enum FilterType
    {
        case none
        case contacted
        case uncontacted
    }
    
    let filter: FilterType
    
    var title: String
    {
        switch filter
        {
            case .none:
                "Everyone"
                
            case .contacted:
                "Contacted people"
                
            case .uncontacted:
                "Uncontacted people"
        }
    }
    
    init(filter: FilterType)
    {
        self.filter = filter
        
        if filter != .none
        {
            let showContactedOnly = filter == .contacted
            
            _prospects = Query(filter: #Predicate
                               {
                $0.isContacted == showContactedOnly
            }, sort: [SortDescriptor(\Prospect.name)])
        }
    }
    
    var body: some View
    {
        NavigationStack
        {
//            Text("People: \(prospects.count)")
            List(prospects)
            { prospect in
                
                VStack(alignment: .leading)
                {
                    Text(prospect.name)
                        .font(.headline)
                    
                    Text(prospect.emailAddress)
                        .foregroundStyle(.secondary)
                }
            }
                .navigationTitle(title)
                .toolbar
                {
                    Button("Scan", systemImage: "qrcode.viewfinder")
                    {
                        let prospect = Prospect(name: "Paul Hudson", emailAddress: "paul@hackingwithswift.com", isContacted: false)
                        
                        modelContext.insert(prospect)
                    }
                }
        }
    }
}

#Preview
{
    ProspectsView(filter: .none)
        .modelContainer(for: Prospect.self)
}
