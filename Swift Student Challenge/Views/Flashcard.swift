//
//  Flashcard.swift
//  Swift Student Challenge
//
//  Created by caleb on 11/4/23.
//

import SwiftUI

struct Flashcard: View {
    var term: Image
    var definition: String
    
    @State private var isShowingDefinition = false
    
    var body: some View {
        VStack {
            ZStack {
                term
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                    .opacity(isShowingDefinition ? 0 : 1)
                    .rotation3DEffect(
                        .degrees(0),
                        axis: (x: 0, y: 0, z: 0)
                    )
                Text(definition)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                    .padding()
                    .opacity(isShowingDefinition ? 1 : 0)
                    .rotation3DEffect(
                        .degrees(180),
                        axis: (x: 1.0, y: 0.0, z: 0.0)
                    )
            }
            .frame(width: 400, height: 300) // adjusted flashcard size
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .rotation3DEffect(
                .degrees(isShowingDefinition ? 180 : 0),
                axis: (x: 1.0, y: 0.0, z: 0.0)
            )
            .onTapGesture {
                withAnimation(.easeInOut) {
                    isShowingDefinition.toggle()
                }
            }
        }
    }
}



struct FlashcardView: View {
    @State private var currentIndex = 0
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
        Flashcard(term: Image("no-u-turn"), definition: "No U-turn")]
    var body: some View {
            VStack {
                flashcards[currentIndex]
                    .padding()
                HStack {
                    Spacer()
                    Button(action: {
                        if currentIndex > 0 {
                            currentIndex -= 1
                        }
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(currentIndex == 0 ? .gray : .blue) // Set color to gray when at the beginning
                    }
                    Spacer()
                    Button(action: {
                        if currentIndex < flashcards.count - 1 {
                            currentIndex += 1
                        }
                    }) {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(currentIndex == flashcards.count - 1 ? .gray : .blue) // Set color to gray when at the end
                    }
                    Spacer()
                }

            }
        }
    }


struct Flashcard_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardView()
    }
}
