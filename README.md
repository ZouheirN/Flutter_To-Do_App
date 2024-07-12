# Todo Buddy

A to-do list app that focuses on security.

## Security Measures

- Encouraging users to choose a strong password on sign up
- Verifying user's email by sending an OTP
- Password Encryption using bcrypt algorithm with salt
- Prevention of taking screenshots in the app
- Jailbeak and root protection
- Requesting only notification permissions and not unecessary permissions
- Securing storage of JWT using flutter_secure_storage package
- Storing secrets (API URL) while compiling using dart define
- Two-factor authentication and biometric authentication
- Code obfuscation

## Getting Started

Clone the repository and run the app by doing:
```
flutter run --dart-define=API_URL=(put url here, ending with /api)
```
