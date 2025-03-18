//
//  LoginView.swift
//  Carely
//
//  Created by Daniele Fontana on 06/03/25.
//


import SwiftUI

struct InitialView: View {
    @State private var showSignInView = false
    @State private var showSignUpView = false

    var body: some View {
        VStack {
            VStack(spacing: 8) {
                Text("Welcome to Carely")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text("Your personal assistant for caregiving tasks.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 40)
            .padding(.horizontal, 20)

            Spacer()

            Button(action: {
                showSignInView = true
            }) {
                Text("Sign In")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.purple))
            }

            Text("Don't you have an account?")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top, 20)

            Button(action: {
                showSignUpView = true
            }) {
                Text("Sign Up")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
            }
            Spacer()
                .frame(height: UIScreen.main.bounds.height * 0.0)
        }
        .sheet(isPresented: $showSignInView) {
            SignInView(user: UserViewModel(), isPresented: $showSignInView)
        }
        .sheet(isPresented: $showSignUpView) {
            SignUpView(user: UserViewModel(), isPresented: $showSignUpView)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        InitialView()
    }
}
