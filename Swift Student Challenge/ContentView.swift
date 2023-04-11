//
//  ContentView.swift
//  Swift Student Challenge
//
//  Created by caleb on 11/4/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            FlashcardView()
                .tabItem() {
                    Image(systemName: "book.closed.fill")
                    Text("Flashcards")
                }
            Quiz()
                .tabItem() {
                    Image(systemName: "brain")
                    Text("Quiz")
                }
            CameraView()
                .tabItem(){
                    Image(systemName: "brain")
                    Text("Quiz")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
