feature 'Sign out' do
  before do
    User.create(name: 'Jongmin', password: 'password', password_confirmation: 'password')
    visit '/sign_in'
    fill_in 'Name', with: 'Jongmin'
    fill_in 'Password', with: 'password'
    click_button 'Log in'
  end
  scenario 'while being signed in' do
    expect(page).to have_button('Sign out')
    click_button 'Sign out'
    expect(page).to have_link('Sign in')
  end
end
