require 'rails_helper'

RSpec.describe API::ApplicationController, type: :controller do

    let!(:active_user) { FactoryBot.create(:user, active: true) }
    let!(:nonactive_user) { FactoryBot.create(:user, username: 'erick') }
    let(:invalid_headers) { { 'Authorization' => nil } }

    describe "#authenticate_request" do
        context "when token is passed" do
            context "when user is active" do
                before { allow(request).to receive(:headers).and_return(headers(active_user.id).except("Content-Type")) }
            
                it "sets the current user" do
                    expect(subject.instance_eval { authenticate_request }).to eq(active_user)
                end
            end

            context "when user is not active" do
                before { allow(request).to receive(:headers).and_return(headers(nonactive_user.id).except("Content-Type")) }
            
                it "raises Account not valid error" do
                    expect { subject.instance_eval { authenticate_request } }.
                    to raise_error(API::ExceptionHandler::InactiveAccount, /Account not active/)
                end
            end
        end

        context "when auth token is not passed" do
            before do
                allow(request).to receive(:headers).and_return(invalid_headers)
            end
            it "raises MissingToken error" do
                expect { subject.instance_eval { authenticate_request } }.
                to raise_error(API::ExceptionHandler::MissingToken, /Missing token/)
            end
        end
    end
end
