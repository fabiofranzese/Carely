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
            Spacer()
                .frame(height: UIScreen.main.bounds.height * 0.6)
               
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

struct SignInView: View {
    @ObservedObject var user: UserViewModel
    @Binding var isPresented: Bool

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("Cancel")
                            .font(.body)
                            .foregroundColor(.blue)
                    }
                    .padding(.leading, 20)
                    Spacer()
                }
                .padding(.top, 20)

                Image("ModalLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.7)
                    .padding(.top, 20)
                    .padding(.bottom, 20)

                VStack(alignment: .center, spacing: 8) {
                    HStack {
                        Image(systemName: "person")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30.0, height: 10.0)
                            .foregroundColor(.purple.opacity(1))
                        ZStack(alignment: .leading) {
                            if user.email.isEmpty {
                                Text("Email")
                                    .foregroundColor(.purple.opacity(1))
                            }
                            TextField("", text: $user.email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .foregroundColor(.purple)
                        }
                    }
                    .padding(0.02 * UIScreen.main.bounds.height)
                    .background(Color(.systemGray5))
                    .cornerRadius(12)
                    .frame(width: UIScreen.main.bounds.width * 0.9)

                    Text("If you’re the Caregiver, add the Care-Reciever email in order to start your journey with Carely.")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .frame(width: UIScreen.main.bounds.width * 0.9)
                }
                .padding(.bottom, 20)

                VStack(alignment: .center, spacing: 8) {
                    HStack {
                        Image(systemName: "lock")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30.0, height: 10.0)
                            .foregroundColor(.purple.opacity(1))
                        ZStack(alignment: .leading) {
                            if user.password.isEmpty {
                                Text("Password")
                                    .foregroundColor(.purple.opacity(1))
                            }
                            SecureField("", text: $user.password)
                                .foregroundColor(.purple)
                        }
                    }
                    .padding(0.02 * UIScreen.main.bounds.height)
                    .background(Color(.systemGray5))
                    .cornerRadius(12)
                    .frame(width: UIScreen.main.bounds.width * 0.9)

                    Text("If you’re the Caregiver, add the same password you used for your account.")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .frame(width: UIScreen.main.bounds.width * 0.9)
                }
                .padding(.bottom, 20)

                Spacer()
                    .frame(height: UIScreen.main.bounds.height * 0.2)

                Button(action: {
                    user.login()
                    if !user.alert {
                        isPresented = false
                    }
                }) {
                    Text("Sign In")
                        .foregroundColor(.white)
                        .font(.title2)
                        .bold()
                        .padding(0.025 * UIScreen.main.bounds.height)
                        .frame(width: UIScreen.main.bounds.width * 0.9)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.purple))
                }
                .buttonStyle(BorderlessButtonStyle())

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom, 20)
        }
        .alert(isPresented: $user.alert) {
            Alert(
                title: Text("Message"),
                message: Text(user.alertMessage),
                dismissButton: .destructive(Text("OK"))
            )
        }
    }
}

struct SignUpView: View {
    @ObservedObject var user: UserViewModel
    @Binding var isPresented: Bool

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("Cancel")
                            .font(.body)
                            .foregroundColor(.blue)
                    }
                    .padding(.leading, 20)
                    Spacer()
                }
                .padding(.top, 20)

                Image("ModalLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.7)
                    .padding(.top, 20)
                    .padding(.bottom, 20)

                VStack(alignment: .center, spacing: 8) {
                    HStack {
                        Image(systemName: "person")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30.0, height: 10.0)
                            .foregroundColor(.purple.opacity(1))
                        ZStack(alignment: .leading) {
                            if user.email.isEmpty {
                                Text("Email")
                                    .foregroundColor(.purple.opacity(1))
                            }
                            TextField("", text: $user.email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .foregroundColor(.purple)
                        }
                    }
                    .padding(0.02 * UIScreen.main.bounds.height)
                    .background(Color(.systemGray5))
                    .cornerRadius(12)
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                }
                .padding(.bottom, 20)

                VStack(alignment: .center, spacing: 8) {
                    HStack {
                        Image(systemName: "lock")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30.0, height: 10.0)
                            .foregroundColor(.purple.opacity(1))
                        ZStack(alignment: .leading) {
                            if user.password.isEmpty {
                                Text("Password")
                                    .foregroundColor(.purple.opacity(1))
                            }
                            SecureField("", text: $user.password)
                                .foregroundColor(.purple)
                        }
                    }
                    .padding(0.02 * UIScreen.main.bounds.height)
                    .background(Color(.systemGray5))
                    .cornerRadius(12)
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                }
                .padding(.bottom, 20)

                VStack(alignment: .center, spacing: 8) {
                    HStack {
                        Image(systemName: "person")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30.0, height: 10.0)
                            .foregroundColor(.purple.opacity(1))
                        ZStack(alignment: .leading) {
                            if user.patientEmail.isEmpty {
                                Text("Patient Email")
                                    .foregroundColor(.purple.opacity(1))
                            }
                            TextField("", text: $user.patientEmail)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .foregroundColor(.purple)
                        }
                    }
                    .padding(0.02 * UIScreen.main.bounds.height)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.purple, lineWidth: 1)
                    )
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                }
                .padding(.bottom, 20)

                Spacer()
                    .frame(height: UIScreen.main.bounds.height * 0.2)

                Button(action: {
                    user.signUp()
                    if !user.alert {
                        isPresented = false
                    }
                }) {
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .font(.title2)
                        .bold()
                        .padding(0.025 * UIScreen.main.bounds.height)
                        .frame(width: UIScreen.main.bounds.width * 0.9)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.purple))
                }
                .buttonStyle(BorderlessButtonStyle())

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom, 20)
        }
        .alert(isPresented: $user.alert) {
            Alert(
                title: Text("Message"),
                message: Text(user.alertMessage),
                dismissButton: .destructive(Text("OK"))
            )
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        InitialView()
    }
}
