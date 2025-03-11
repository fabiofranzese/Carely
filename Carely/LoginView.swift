//
//  LoginView.swift
//  Carely
//
//  Created by Daniele Fontana on 06/03/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject var user = UserViewModel()
    @State private var signUpView : Bool = false
    var body: some View {
        let loginView = VStack {
          // Login title
          Text("Login".uppercased())
            .font(.title)

          Spacer()
            .frame(idealHeight: 0.1 * UIScreen.main.bounds.height)
            .fixedSize()

          // Email textfield
          let emailInputField = HStack {
              Image(systemName: "person")
              .resizable()
              .scaledToFit()
              .frame(width: 30.0, height: 30.0)
              .opacity(0.5)
            let emailTextField = TextField("Email", text: $user.email)
          emailTextField
            .keyboardType(.emailAddress)
            .autocapitalization(UITextAutocapitalizationType.none)
          }
          .padding(0.02 * UIScreen.main.bounds.height)

        emailInputField
          .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
          .frame(width: UIScreen.main.bounds.width * 0.8)

          // Password textfield
          let passwordInputField = HStack {
              Image(systemName: "lock")
              .resizable()
              .scaledToFit()
              .frame(width: 30.0, height: 30.0)
              .opacity(0.5)
            SecureField("Password", text: $user.password)
          }
          .padding(0.02 * UIScreen.main.bounds.height)

        passwordInputField
          .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
          .frame(width: UIScreen.main.bounds.width * 0.8)

          Spacer()
            .frame(idealHeight: 0.05 * UIScreen.main.bounds.height)
            .fixedSize()

          // Login button
          let loginButton = Button(action: user.login) {
            Text("Login".uppercased())
              .foregroundColor(.white)
              .font(.title2)
              .bold()
          }
          .padding(0.025 * UIScreen.main.bounds.height)
          .background(Capsule().fill(Color(.systemTeal)))

        loginButton
          .buttonStyle(BorderlessButtonStyle())

        Spacer()
            .frame(idealHeight: 0.05 * UIScreen.main.bounds.height)
            .fixedSize()

          // Navigation text
          HStack {
            Text("Don't have an account?")
            let signUpButton = Button(action: {
              signUpView = true
            }) {
              Text("Sign up".uppercased())
                .bold()
            }
            .sheet(isPresented: $signUpView) {
              SignUpView(user: user, isPresented: $signUpView)
            }
        signUpButton
            .buttonStyle(BorderlessButtonStyle())
          }
        }
        .alert(isPresented: $user.alert, content: {
          Alert(
            title: Text("Message"),
            message: Text(user.alertMessage),
            dismissButton: .destructive(Text("OK"))
          )
        })
      loginView
      }
}

struct SignUpView: View {
    @ObservedObject var user: UserViewModel
    @Binding var isPresented: Bool
    var body: some View {
        let signUpView = VStack {
              // Sign up title
              Text("Sign up".uppercased())
                .font(.title)

              Spacer()
                .frame(idealHeight: 0.1 * UIScreen.main.bounds.height)
                .fixedSize()
              // Email textfield
              let emailInputField = HStack {
                  Image(systemName: "person")
                  .resizable()
                  .scaledToFit()
                  .frame(width: 30.0, height: 30.0)
                  .opacity(0.5)
                let emailTextField = TextField("Email", text: $user.email)
              emailTextField
                .keyboardType(.emailAddress)
                .autocapitalization(UITextAutocapitalizationType.none)
              }
              .padding(0.02 * UIScreen.main.bounds.height)

            emailInputField
              .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
              .frame(width: UIScreen.main.bounds.width * 0.8)

              // Password textfield
              let passwordInputField = HStack {
                  Image(systemName: "lock")
                  .resizable()
                  .scaledToFit()
                  .frame(width: 30.0, height: 30.0)
                  .opacity(0.5)
                SecureField("Password", text: $user.password)
              }
              .padding(0.02 * UIScreen.main.bounds.height)

            passwordInputField
              .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
              .frame(width: UIScreen.main.bounds.width * 0.8)

              Spacer()
                .frame(idealHeight: 0.05 * UIScreen.main.bounds.height)
                .fixedSize()
                HStack {
                  Image("person")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30.0, height: 30.0)
                    .opacity(0.5)
                    TextField("Patient Email", text: $user.patientEmail)
                  .keyboardType(.emailAddress)
                  .autocapitalization(UITextAutocapitalizationType.none)
                }
                .padding(0.02 * UIScreen.main.bounds.height)
            Text(user.patientEmail)
                Text(user.email)
            let signUpButton =
                Button(action: user.signUp) {
                    Text("Sign up".uppercased())
                        .foregroundColor(.white)
                        .font(.title2)
                        .bold()
                }
                .padding(0.025 * UIScreen.main.bounds.height)
                .background(Capsule().fill(Color(.systemTeal)))

            signUpButton
              .buttonStyle(BorderlessButtonStyle())

              Spacer()
                .frame(idealHeight: 0.05 * UIScreen.main.bounds.height)
                .fixedSize()
            }
            .alert(isPresented: $user.alert, content: {
              Alert(
                title: Text("Message"),
                message: Text(user.alertMessage),
                dismissButton: .destructive(Text("Ok"))
              )
            })
        signUpView
    }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    LoginView(user: user)
  }
}

