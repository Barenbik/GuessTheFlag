//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Tony Sharples on 21/11/2023.
//

import SwiftUI

struct FlagImage : View {
    var country = ""
    
    var body: some View {
        Image(country)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreText = ""
    @State private var score = 0
    @State private var questionsAsked = 0
    @State private var gameCompleted = false
    @State private var selectedFlagNumber: Int? = nil
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { flagNumber in
                        Button {
                            withAnimation {
                                flagTapped(flagNumber)
                            }
                        } label: {
                            FlagImage(country: countries[flagNumber])
                        }
                        .rotation3DEffect(.degrees(selectedFlagNumber == flagNumber ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                        .opacity(selectedFlagNumber == nil ? 1.0 : flagNumber == selectedFlagNumber ? 1.0 : 0.25)
                        .scaleEffect(selectedFlagNumber == nil ? 1.0 : flagNumber == selectedFlagNumber ? 1.0 : 0.75)
                        .animation(.default, value: selectedFlagNumber)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text(scoreText)
        }
        .alert("Game Over", isPresented: $gameCompleted) {
            Button("Reset", action: resetGame)
        } message: {
            Text("You finished the game with a score of \(score)")
        }
    }
    
    func flagTapped(_ flagNumber: Int) {
        if flagNumber == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            scoreText = "Your score is \(score)"
        } else {
            scoreTitle = "Wrong"
            scoreText = "Thats the flag of \(countries[flagNumber])"
        }
        
        selectedFlagNumber = flagNumber
        questionsAsked += 1
        showingScore = true
    }
    
    func askQuestion() {
        if questionsAsked == 5 {
            gameCompleted = true
        } else {
            shuffleFlags()
        }
        
        selectedFlagNumber = nil
    }
    
    func resetGame() {
        scoreTitle = ""
        scoreText = ""
        score = 0
        questionsAsked = 0
        
        shuffleFlags()
    }
    
    func shuffleFlags() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

#Preview {
    ContentView()
}
