Rails.configuration.stripe = {
  :publishable_key => 'pk_test_NXs0K70M3efuHVchvD22VmHI',
  :secret_key      => 'sk_test_91JySYNtGMfMR6q4HaeIMPNN' 
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
