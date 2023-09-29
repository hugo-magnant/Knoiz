require "rails_helper"

RSpec.describe CheckoutSessionController, type: :controller do
  let(:user) { double("User") }
  let(:subscription) { double("Subscription", active?: false, stripe_user_id: "stripe_user_1") }
  let(:stripe_service_double) { double("StripeServices::SubscriptionService") }
  let(:billing_service_double) { double("StripeServices::BillingPortalService") }

  before do
    controller.instance_variable_set(:@current_user, user) # Définir @current_user
    allow(user).to receive(:subscription).and_return(subscription)
  end

  describe "POST #create" do
    context "when subscription creation fails" do
      it "redirects to error path" do
        allow(stripe_service_double).to receive(:create_subscription).and_return({ error: "Some error" })
        allow(StripeServices::SubscriptionService).to receive(:new).with(user, StripePrice).and_return(stripe_service_double)

        post :create

        expect(response).to redirect_to(error_path)
        expect(flash[:alert]).to eq("Some error")
      end
    end

    context "when subscription creation succeeds" do
      it "redirects to Stripe URL" do
        allow(stripe_service_double).to receive(:create_subscription).and_return({ redirect_url: "stripe_url" })
        allow(StripeServices::SubscriptionService).to receive(:new).with(user, StripePrice).and_return(stripe_service_double)

        post :create

        expect(response).to redirect_to("stripe_url")
      end
    end

    context "when Stripe is down" do
      it "redirects to error path" do
        allow(stripe_service_double).to receive(:create_subscription).and_raise(Stripe::StripeError)
        allow(StripeServices::SubscriptionService).to receive(:new).with(user, StripePrice).and_return(stripe_service_double)

        post :create

        expect(response).to redirect_to(error_path)
        expect(flash[:alert]).to eq("Stripe service is currently unavailable.")
      end
    end
  end

  describe "POST #create_portal_session" do
    context "when portal session creation fails" do
      it "redirects to error path" do
        allow(billing_service_double).to receive(:create_billing_portal_session).and_return({ error: "Some error" })
        allow(StripeServices::BillingPortalService).to receive(:new).with(user).and_return(billing_service_double)

        post :create_portal_session

        expect(response).to redirect_to(error_path)
        expect(flash[:alert]).to eq("Some error")
      end
    end

    context "when portal session creation succeeds" do
      it "redirects to Stripe URL" do
        allow(billing_service_double).to receive(:create_billing_portal_session).and_return({ redirect_url: "stripe_portal_url" })
        allow(StripeServices::BillingPortalService).to receive(:new).with(user).and_return(billing_service_double)

        post :create_portal_session

        expect(response).to redirect_to("stripe_portal_url")
      end
    end
  end
end
