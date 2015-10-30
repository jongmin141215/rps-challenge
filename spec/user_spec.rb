describe User do
  let(:user) do
    User.create(name: 'Jongmin', password: 'password', password_confirmation: 'password')
  end

  it 'authenticates when given a valid name and password' do
    authenticated_user = User.authenticate(user.name, user.password)
    expect(authenticated_user).to eq(user)
  end

  it 'does not authenticate when given an incorrect password' do
    expect(User.authenticate(user.name, 'hi')).to be_nil
  end
end
