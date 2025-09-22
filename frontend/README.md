# FastSaaS Frontend Authentication

A modern React TypeScript frontend application with authentication features including registration, login, Google OAuth, and email verification.

## Features

- ✅ User Registration with email verification
- ✅ Email/Password Login
- ✅ Google OAuth Login (placeholder implementation)
- ✅ Email Verification via link
- ✅ Protected Dashboard
- ✅ Responsive Design with Tailwind CSS
- ✅ TypeScript for type safety
- ✅ Feature-based architecture
- ✅ Clean component structure

## Tech Stack

- **React 19** - UI library
- **TypeScript** - Type safety
- **Vite 6** - Build tool
- **React Router 7** - Client-side routing
- **Tailwind CSS 4** - Styling
- **Google Identity Services** - OAuth integration

## Project Structure

```
src/
├── features/
│   └── authentication/
│       ├── components/         # Authentication UI components
│       ├── hooks/              # Authentication React hooks
│       ├── services/           # API communication services
│       └── types/              # TypeScript type definitions
├── shared/
│   ├── components/             # Reusable UI components
│   ├── services/               # Shared services (API client)
│   └── types/                  # Shared TypeScript types
├── routes/                     # Page components
└── types/                      # Global type declarations
```

## Getting Started

### Prerequisites

- Node.js 20.11+
- npm or yarn
- Backend API running on `http://localhost:8000`

### Installation

1. Install dependencies:
```bash
npm install
```

2. Start the development server:
```bash
npm run dev
```

3. Open http://localhost:5173 in your browser

## Available Pages

### Authentication Flow

1. **Login Page** (`/login`)
   - Email/password authentication
   - Google OAuth button (requires setup)
   - Link to registration page

2. **Registration Page** (`/register`)
   - Create new account
   - Email verification email sent after registration
   - Link to login page

3. **Email Verification** (`/verify-email?token=...`)
   - Verifies email when user clicks verification link
   - Automatic verification process
   - Success/error states

4. **Dashboard** (`/dashboard`)
   - Protected route (requires authentication)
   - Shows user information
   - Logout functionality

## API Integration

The frontend communicates with the FastAPI backend using these endpoints:

- `POST /auth/register` - User registration
- `POST /auth/login` - Email/password login
- `POST /auth/google-login` - Google OAuth login
- `GET /auth/verify-email?token=...` - Email verification

## Authentication State Management

Authentication state is managed using a custom React hook (`useAuthentication`) that provides:

- User information and authentication status
- Loading states for async operations
- Error handling and display
- Token persistence in localStorage
- Automatic session restoration

## Component Architecture

The application follows the smart/dumb component pattern:

- **Smart Components** (Pages): Handle business logic and state
- **Dumb Components** (UI Components): Focus on presentation only
- **Hooks**: Manage stateful logic and side effects
- **Services**: Handle API communication

## Google OAuth Setup

To enable Google OAuth:

1. Create a Google Cloud Project
2. Enable Google Identity Services
3. Configure OAuth consent screen
4. Get OAuth 2.0 client ID
5. Update the Google login component with your client ID

## Environment Variables

Create a `.env` file for configuration:

```env
VITE_API_BASE_URL=http://localhost:8000
VITE_GOOGLE_CLIENT_ID=your_google_client_id
```

## Building for Production

```bash
npm run build
```

The built application will be in the `dist/` directory.

## Development Guidelines

- Follow TypeScript strict mode
- Use functional components with hooks
- Implement proper error boundaries
- Add loading states for async operations
- Ensure accessibility (ARIA attributes, semantic HTML)
- Mobile-first responsive design
- Follow feature-based architecture

## Testing the Authentication Flow

1. **Registration**:
   - Go to `/register`
   - Fill in email and password
   - Check email for verification link
   - Click verification link

2. **Login**:
   - Go to `/login`
   - Use registered credentials
   - Should redirect to dashboard

3. **Email Verification**:
   - Click link from registration email
   - Should show success message
   - Can then login normally

4. **Session Persistence**:
   - Login and refresh page
   - Should remain logged in
   - Check localStorage for token

## Troubleshooting

### Common Issues

1. **CORS Errors**: Ensure backend allows frontend origin
2. **API Connection**: Verify backend is running on port 8000
3. **Google OAuth**: Check Google Client ID configuration
4. **Email Verification**: Verify email service is configured in backend

### Development Tips

- Use browser DevTools to inspect network requests
- Check Console for JavaScript errors
- Verify localStorage for authentication tokens
- Test with different email addresses

## Future Enhancements

- [ ] Password reset functionality
- [ ] Remember me option
- [ ] Multi-factor authentication
- [ ] Social login with other providers
- [ ] User profile management
- [ ] Account settings page
