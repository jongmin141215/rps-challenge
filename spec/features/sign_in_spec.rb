feature 'Sign in' do
  before do
    visit '/sign_up'
    fill_in 'Name', with: 'Jongmin'
    fill_in 'Password', with: 'password'
    fill_in 'Confirmation', with: 'password'
    click_button 'Sign up'
  end

  context 'with correct credentials' do
    scenario 'user can sign in' do
      visit '/sign_in'
      fill_in 'Name', with: 'Jongmin'
      fill_in 'Password', with: 'password'
      click_button 'Log in'
      expect(page).to have_content 'Lobby'
    end
  end

  context 'with incorrect credentials' do
    scenario 'cannot log in with incorrect password' do
      visit '/sign_in'
      fill_in 'Name', with: 'Jongmin'
      fill_in 'Password', with: ''
      click_button 'Log in'
      expect(page).to have_content 'invalid email or password'
    end
  end
end
