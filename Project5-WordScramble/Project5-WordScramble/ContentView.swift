//
//  ContentView.swift
//  Project5-WordScramble
//
//  Created by Daniel Braga Barbosa on 16/08/24.
//

import SwiftUI

struct ContentView: View 
{
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var score: Int = 0
    
    var body: some View
    {
        NavigationStack
        {
            List
            {
                Section
                {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                
                Section
                {
                    ForEach(usedWords, id: \.self) { word in
                        HStack
                        {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) { }
            message:
            {
                Text(errorMessage)
            }
            .toolbar
            {
                Button("Restart", action: startGame)
                Text("Score: \(score)")
            }
        }
    }
    
    func addNewWord()
    {
        // lowercase and trim the word, to make sure we don't add duplicate with case differences
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // exit if the remaining string is empty
        guard answer.count > 0 else { return }
        
        // extra validation
        guard isOriginal(word: answer) else
        {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        
        guard isPossible(word: answer) else
        {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }
        
        guard isReal(word: answer) else
        {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        guard isMoreThanThreeLetters(word: answer) else
        {
            wordError(title: "Word not accepted", message: "Your word don't have more than 3 letters")
            return
        }
        
        guard isNotTheStartWord(word: answer) else
        {
            wordError(title: "Word is equal the root", message: "Your word is equal the start word")
            return
        }
        
        withAnimation
        {
            usedWords.insert(answer, at: 0)
        }
        
        newWord = ""
        score += answer.count
    }
    
    func startGame()
    {
        score = 0
        
        if let startWordsURl = Bundle.main.url(forResource: "start", withExtension: "txt")
        {
            if let startWords = try? String(contentsOf: startWordsURl)
            {
                let allWords = startWords.components(separatedBy: "\n")
                
                rootWord = allWords.randomElement() ?? "silkworm"
                
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle.")
    }
    
    func isOriginal(word: String) -> Bool
    {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool
    {
        var tempWord = rootWord
        
        for letter in word
        {
            if let pos = tempWord.firstIndex(of: letter)
            {
                tempWord.remove(at: pos)
            }
            else
            {
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool
    {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func isMoreThanThreeLetters(word: String) -> Bool
    {
        let countLetters = word.count
        if countLetters < 4
        {
            return false
        }
        
        return true
    }
    
    func isNotTheStartWord(word: String) -> Bool
    {
        if word == rootWord
        {
            return false
        }
        
        return true
    }
    
    func wordError(title: String, message: String)
    {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
}

#Preview {
    ContentView()
}
