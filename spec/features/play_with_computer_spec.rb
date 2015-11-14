feature 'Playing with computer' do
  before do
    visit '/sign_up'
    fill_in 'name', with: 'Jongmin'
    fill_in 'password', with: 'password'
    fill_in 'password_confirmation', with: 'password'
    click_button 'Sign up'
  end

  scenario 'user can see RPSbot' do
    expect(page).to have_content 'RPSbot'
  end

  scenario 'user can challenge RPSbot' do
    click_button 'Challenge'
    expect(current_path).to eq('/vs_computer')
    expect(page).to have_content('Jongmin vs. Computer')
  end

  scenario 'user can make a choice' do
    click_button 'Challenge'
    choose 'rock'
    click_button 'Play'
    expect(current_path).to eq('/results')
  end
end
