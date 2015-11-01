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

  it 'can choose :rock' do
    expect(user.choose(:rock)).to eq(:rock)
  end

  it 'can choose :scissors' do
    expect(user.choose(:scissors)).to eq(:scissors)
  end

  it 'can choose :paper' do
    expect(user.choose(:paper)).to eq(:paper)
  end
end
