//
//  MissionView.swift
//  Project8-Moonshot
//
//  Created by Daniel Braga Barbosa on 14/10/24.
//

import SwiftUI

struct CrewMember
{
    let role: String
    let astronaut: Astronaut
}

struct MissionView: View
{
    let mission: Mission
    let crew: [CrewMember]
    
    init(mission: Mission, astronauts: [String: Astronaut])
    {
        self.mission = mission
        
        self.crew = mission.crew.map
        { member in
            if let astronaut = astronauts[member.name]
            {
                return CrewMember(role: member.role, astronaut: astronaut)
            }
            else
            {
                fatalError("Missing \(member.name)")
            }
        }
    }
    
    var body: some View
    {
        ScrollView
        {
            VStack
            {
                Image(mission.image)
                    .resizable()
                    .scaledToFit()
                    .containerRelativeFrame(.horizontal) { width, axis in
                        width * 0.6
                    }
                    .padding(.top)
                    .padding(.bottom)
                
                Text("Launch date: \(mission.formattedLaunchDate)")
                    .font(.title2)
                    .foregroundStyle(.white)
                
                VStack(alignment: .leading)
                {
                    MyDivider()
                    
                    Text("Mission Highlights")
                        .font(.title.bold())
                        .padding(.bottom, 5)
                    
                    Text(mission.description)
                    
                    MyDivider()
                    
                    Text("Crew")
                        .font(.title.bold())
                        .padding(.bottom, 5)
                }
                .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false)
                {
                    HStack
                    {
                        ForEach(crew, id: \.role)
                        { crewMember in
                            NavigationLink
                            {
//                                Text("Astronaut details")
                                AstronautView(astronaut: crewMember.astronaut)
                            }
                            label:
                            {
                                HStack
                                {
                                    Image(crewMember.astronaut.id)
                                        .resizable()
                                        .frame(width: 104, height: 72)
                                        .clipShape(.capsule)
                                        .overlay(
                                            Capsule()
                                                .strokeBorder(.white, lineWidth: 1))

                                    VStack(alignment: .leading)
                                    {
                                        Text(crewMember.astronaut.name)
                                            .foregroundStyle(.white)
                                            .font(.headline)
                                        
                                        Text(crewMember.role)
                                            .foregroundStyle(.white.opacity(0.5))
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                
            }
            .padding(.bottom)
        }
        .navigationTitle(mission.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkBackground)
    }
}

struct MyDivider: View
{
    var body: some View
    {
        Rectangle()
            .frame(height: 2)
            .foregroundStyle(.lightBackground)
            .padding(.vertical)
    }
}

struct HorizontalScrollView: View
{
    var body: some View
    {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
    }
}


#Preview
{
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
    return MissionView(mission: missions[0], astronauts: astronauts)
        .preferredColorScheme(.dark)
}
