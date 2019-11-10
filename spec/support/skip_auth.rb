# spec/support/skip_auth.rb
RSpec.shared_context 'Skip Auth' do
  let(:admin_user) { create(:admin) }
  let(:api_key) { ApiKey.first || create(:api_key) }
  let(:access_token) { create(:access_token, user: admin_user, api_key: api_key) }

  before do
    allow_any_instance_of(ApplicationController).to(
      receive(:validate_auth_scheme).and_return(true))
    allow_any_instance_of(ApplicationController).to(
      receive(:authenticate_client).and_return(true))
    allow_any_instance_of(ApplicationController).to(
      receive(:authenticate_user).and_return(true))
    allow_any_instance_of(ApplicationController).to(
      receive(:access_token).and_return(access_token))
    allow_any_instance_of(ApplicationController).to(
      receive(:current_user).and_return(admin_user))
  end
end