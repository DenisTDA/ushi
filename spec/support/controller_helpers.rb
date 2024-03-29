module ControllerHelpers
  OmniAuth.config.test_mode = true

  def login(user)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in(user)
  end

  def mock_auth_hash(provider, email:)
    OmniAuth.config.mock_auth[provider.to_sym] = OmniAuth::AuthHash.new({ 'provider' => provider,
                                                                          'uid' => '555555',
                                                                          'info' => {
                                                                            'email' => email
                                                                          },
                                                                          'credentials' => {
                                                                            'token' => 'mock_token',
                                                                            'secret' => 'mock_secret'
                                                                          } })
  end
end
