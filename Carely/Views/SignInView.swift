//
//  SignInView.swift
//  Carely
//
//  Created by Daniele Fontana on 13/03/25.
//

import SwiftUI

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

                    Text("If you’re the Caregiver, add your email or the Care-Reciever email in order to start your journey with Carely.")
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

                    Text("It's the same for both Caregiver and Care-Receiver accounts.")
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

#Preview {
    SignInView(user: user, isPresented: .constant(true))
}
