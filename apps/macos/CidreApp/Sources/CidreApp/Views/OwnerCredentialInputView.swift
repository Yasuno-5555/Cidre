import SwiftUI

/// Collects the macOS owner's username and password for bless/bputil authentication.
/// Credentials are held only in memory - never persisted to disk or UserDefaults.
struct OwnerCredentialInputView: View {
    @Binding var credentials: OwnerCredentials?

    @State private var username: String = NSUserName()
    @State private var password: String = ""
    @State private var showPassword: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Owner Authentication")
                .font(.headline)

            Text("Your macOS login credentials are needed once to authorize the boot policy change. They are not stored.")
                .font(.caption)
                .foregroundColor(.secondary)

            HStack {
                Text("User:")
                    .frame(width: 60, alignment: .trailing)
                TextField("macOS username", text: $username)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()
            }

            HStack {
                Text("Password:")
                    .frame(width: 60, alignment: .trailing)
                if showPassword {
                    TextField("macOS password", text: $password)
                        .textFieldStyle(.roundedBorder)
                } else {
                    SecureField("macOS password", text: $password)
                        .textFieldStyle(.roundedBorder)
                }
                Button(action: { showPassword.toggle() }) {
                    Image(systemName: showPassword ? "eye.slash" : "eye")
                }
                .buttonStyle(.borderless)
            }
        }
        .padding()
        .onChange(of: username) { _ in updateCredentials() }
        .onChange(of: password) { _ in updateCredentials() }
    }

    private func updateCredentials() {
        if !username.isEmpty && !password.isEmpty {
            credentials = OwnerCredentials(username: username, password: password)
        } else {
            credentials = nil
        }
    }
}
