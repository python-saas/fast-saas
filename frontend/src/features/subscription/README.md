# Subscription Feature

This feature handles subscription management, payment methods, and billing for the FastSaaS application.

## Structure

```
subscription/
├── types/
│   └── subscriptionTypes.ts      # TypeScript interfaces for subscription data
├── services/
│   └── subscriptionService.ts    # API service layer for subscription operations
├── hooks/
│   └── useSubscription.ts        # React hook for subscription state management
├── components/
│   ├── SubscriptionOverview.tsx  # Current subscription and plan management
│   ├── PaymentMethodsSection.tsx # Payment method management with Stripe
│   ├── AddPaymentMethodModal.tsx # Modal for adding new payment methods
│   └── InvoicesSection.tsx       # Billing history and invoice downloads
└── README.md                     # This file
```

## Features

### Subscription Management
- View current subscription details
- Change subscription plans
- Cancel subscriptions
- Track subscription status and billing periods

### Payment Methods
- Add payment methods using Stripe Elements
- Remove payment methods
- Set default payment method
- View card details (last 4 digits, expiry, brand)

### Billing History
- View invoice history
- Download paid invoices
- Track payment status
- See invoice details and amounts

## Usage

### Basic Usage

```tsx
import { useSubscription } from '../features/subscription/hooks/useSubscription';

function SubscriptionComponent() {
  const subscription = useSubscription();

  // Access subscription data
  const { currentSubscription, paymentMethods, invoices, isLoading } = subscription;

  // Perform actions
  const handleCreateSubscription = async (planId: string) => {
    await subscription.actions.createSubscription({ planId });
  };

  return (
    // Your component JSX
  );
}
```

### Adding Payment Methods

The `AddPaymentMethodModal` component uses Stripe Elements for secure payment method collection:

```tsx
<AddPaymentMethodModal
  isOpen={showModal}
  onClose={() => setShowModal(false)}
  onAddPaymentMethod={handleAddPaymentMethod}
  isLoading={isLoading}
/>
```

## Dependencies

- `@stripe/stripe-js` - Stripe JavaScript SDK
- `@stripe/react-stripe-js` - React components for Stripe

## Environment Variables

Required environment variables for the frontend:

```env
VITE_STRIPE_PUBLISHABLE_KEY=pk_test_your_stripe_publishable_key_here
```

## API Endpoints

The subscription service calls the following backend endpoints:

- `GET /payments/plans` - Get available subscription plans
- `GET /payments/tenants/{uuid}/subscription` - Get current subscription
- `POST /payments/tenants/{uuid}/subscription` - Create subscription
- `PATCH /payments/tenants/{uuid}/subscription` - Update subscription
- `DELETE /payments/tenants/{uuid}/subscription` - Cancel subscription
- `GET /payments/tenants/{uuid}/payment-methods` - Get payment methods
- `POST /payments/tenants/{uuid}/payment-methods` - Add payment method
- `DELETE /payments/tenants/{uuid}/payment-methods/{id}` - Remove payment method
- `PATCH /payments/tenants/{uuid}/payment-methods/{id}/set-default` - Set default payment method
- `GET /payments/tenants/{uuid}/invoices` - Get invoices
- `GET /payments/tenants/{uuid}/invoices/{id}/download` - Download invoice

## Security

- Payment method data is handled securely through Stripe Elements
- Payment method IDs are used instead of raw card data
- All API calls are authenticated with Bearer tokens
- Sensitive card information is not stored in the frontend state

## Error Handling

- Network errors are caught and displayed to users
- Stripe errors are handled in the payment method modal
- Loading states prevent duplicate operations
- User-friendly error messages are shown for common scenarios
