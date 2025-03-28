//
//  ProspectsView.swift
//  Project16-HotProspects
//
//  Created by Daniel Braga Barbosa on 21/03/25.
//

import SwiftUI
import SwiftData
import CodeScanner
import UserNotifications

struct ProspectsView: View
{
    @Query(sort: \Prospect.name) var prospects: [Prospect]
    @Query() var prospectsByMostRecents: [Prospect]
    
    @State private var shouldShowSortedByName = true
    
    var sortTypeToBeUSed: [Prospect]
    {
        if shouldShowSortedByName
        {
            return prospects
        }
        
        return prospectsByMostRecents
    }
    
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
    
    @State private var isShowingScanner = false
    
    @State private var selectedProspects = Set<Prospect>()
    
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
//            List(prospects, selection: $selectedProspects)
            List(sortTypeToBeUSed, selection: $selectedProspects)
            { prospect in
                
                HStack
                {
                    VStack(alignment: .leading)
                    {
                        Text(prospect.name)
                            .font(.headline)
                        
                        Text(prospect.emailAddress)
                            .foregroundStyle(.secondary)
                    }
                    
                    if prospect.isContacted
                    {
                        Spacer()
                        
                        Image(systemName: "person.crop.circle.badge.xmark")
                            .tint(.blue)
                    }
                    else
                    {
                        Spacer()
                        
                        Image(systemName: "person.crop.circle.fill.badge.checkmark")
                    }
                }
                .swipeActions
                {
                    Button("Delete", systemImage: "trash", role: .destructive)
                    {
                        modelContext.delete(prospect)
                    }
                    
                    if prospect.isContacted
                    {
                        Button("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark")
                        {
                            prospect.isContacted.toggle()
                        }
                        .tint(.blue)
                    }
                    else
                    {
                        Button("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark")
                        {
                            prospect.isContacted.toggle()
                        }
                        .tint(.green)
                        
                        Button("Remind Me", systemImage: "bell")
                        {
                            addNotification(for: prospect)
                        }
                        .tint(.orange)
                    }
                }
                .tag(prospect)
            }
                .navigationTitle(title)
                .toolbar
                {
                    ToolbarItem(placement: .topBarTrailing)
                    {
                        Button("Change sort")
                        {
                            shouldShowSortedByName.toggle()
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing)
                    {
                        Button("Scan", systemImage: "qrcode.viewfinder")
                        {
                            //                        let prospect = Prospect(name: "Paul Hudson", emailAddress: "paul@hackingwithswift.com", isContacted: false)
                            //
                            //                        modelContext.insert(prospect)
                            
                            isShowingScanner = true
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading)
                    {
                        EditButton()
                    }
                    
                    if selectedProspects.isEmpty == false
                    {
                        ToolbarItem(placement: .bottomBar)
                        {
                            Button("Delete Selected", action: delete)
                        }
                    }
                }
                .sheet(isPresented: $isShowingScanner)
                {
                    CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: handleScan)
                }
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>)
    {
        isShowingScanner = false
        
        switch result
        {
            case .success(let result):
                let details = result.string.components(separatedBy: "\n")
                guard details.count == 2 else { return }
                
                let person = Prospect(name: details[0], emailAddress: details[1], isContacted: false)
                
                modelContext.insert(person)
                
            case .failure(let error):
                print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    func delete()
    {
        for prospect in selectedProspects
        {
            modelContext.delete(prospect)
        }
    }
    
    func addNotification(for prospect: Prospect)
    {
        let center = UNUserNotificationCenter.current()
        
        let addRequest =
        {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            center.add(request)
        }
        
        center.getNotificationSettings
        { settings in
            
            if settings.authorizationStatus == .authorized
            {
                addRequest()
            }
            else
            {
                center.requestAuthorization(options: [.alert, .badge, .sound])
                { success, error in
                    
                    if success
                    {
                        addRequest()
                    }
                    else if let error
                    {
                        print(error.localizedDescription)
                    }
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
