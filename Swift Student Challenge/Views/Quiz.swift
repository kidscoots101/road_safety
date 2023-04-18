//
//  Quiz.swift
//  Swift Student Challenge
//
//  Created by caleb on 11/4/23.
//

import SwiftUI

struct Flashcards {
    let term: Image
    let definition: String
}

struct QuizView: View {
    @State private var currentFlashcard = 0
    @State private var options = [String]()
    @State private var isCorrect = false
    @State private var showAlert = false
    
    let flashcards = [
        Flashcard(term: Image("stop-sign"), definition: "Stop at intersection"),
        Flashcard(term: Image("yield-sign"), definition: "Yield to oncoming traffic"),
        Flashcard(term: Image("speed-limit"), definition: "Maximum speed limit"),
        Flashcard(term: Image("pedestrian-crossing"), definition: "Pedestrian crossing"),
        Flashcard(term: Image("school-crossing"), definition: "School crossing"),
        Flashcard(term: Image("railroad-crossing"), definition: "Railroad crossing"),
        Flashcard(term: Image("no-parking"), definition: "No parking"),
        Flashcard(term: Image("no-stopping"), definition: "No stopping or standing"),
        Flashcard(term: Image("do-not-enter"), definition: "Do not enter"),
        Flashcard(term: Image("no-u-turn"), definition: "No U-turn")
    ]
    
    func selectRandomAnswers(correctAnswer: String) -> [String] {
        var randomAnswers = [String]()
        while randomAnswers.count < 3 {
            let randomIndex = Int.random(in: 0..<flashcards.count)
            let randomAnswer = flashcards[randomIndex].definition
            if randomAnswer != correctAnswer && !randomAnswers.contains(randomAnswer) {
                randomAnswers.append(randomAnswer)
            }
        }
        randomAnswers.append(correctAnswer)
        return randomAnswers.shuffled()
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.white, Color.purple]), startPoint: .top, endPoint: .bottom)
            
            VStack {
                Text("Quiz time!")
                    .font(.system(size: 100))
                    .fontWeight(.bold)
                    .foregroundColor(Color(hue: 0.77, saturation: 0.985, brightness: 0.598))
                Text("What does this sign mean?")
                    .font(.system(size: 30))
                    .bold()
                    .padding()
                
                flashcards[currentFlashcard].term
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)
                    .padding()
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 30) {
                    ForEach(0..<options.count, id: \.self) { index in
                        Button(action: {
                            if options[index] == flashcards[currentFlashcard].definition {
                                isCorrect = true
                            } else {
                                isCorrect = false
                            }
                            showAlert = true
                        }) {
                            Text(options[index])
                                .bold()
                                .font(.system(size: 25))
                        }
                        .padding(30)
                        .foregroundColor(.white)
                        .background(isCorrect ? Color.green : Color.red)
                        .cornerRadius(10)
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text(isCorrect ? "Correct!" : "Incorrect"), message: Text(flashcards[currentFlashcard].definition), dismissButton: .default(Text("Next Sign")) {
                                currentFlashcard += 1
                                options = selectRandomAnswers(correctAnswer: flashcards[currentFlashcard].definition)
                                isCorrect = false
                            })
                        }
                    }
                }
            }
            .onAppear {
                options = selectRandomAnswers(correctAnswer: flashcards[currentFlashcard].definition)
            }
            .padding()
        }
    }
}



struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView()
    }
}
