require 'spec_helper'

feature "Sign up" do
  before do
    visit "/sign_up"
  end

  scenario "You can register your name" do
    fill_in 'Name', with: 'Jongmin'
    fill_in 'Password', with: 'password'
    fill_in 'Confirmation', with: 'password'
    click_button 'Sign up'
    expect(page).to have_content 'Welcome, Jongmin!'
    expect(User.first.name).to eq('Jongmin')
  end

  scenario "It asks you to fill in the form if nothing is typed" do
    fill_in("Name", with: "")
    fill_in 'Password', with: 'password'
    fill_in 'Confirmation', with: 'password'
    click_button("Sign up")
    expect(current_path).to eq("/sign_up")
  end

  scenario 'requires a matching confirmation password' do
    fill_in 'Name', with: 'Jongmin'
    fill_in 'Password', with: 'password'
    fill_in 'Confirmation', with: 'passw0rd'
    click_button 'Sign up'
    expect(current_path).to eq("/sign_up")
    expect(page).to have_content('Password and Confirmation do not match')
    expect(User.first).to be_nil
  end

  scenario 'cannot sign up with an existing email' do
    fill_in 'Name', with: 'Jongmin'
    fill_in 'Password', with: 'password'
    fill_in 'Confirmation', with: 'password'
    click_button 'Sign up'
    # click_link "Sign out"
    visit "/sign_up"
    fill_in 'Name', with: 'Jongmin'
    fill_in 'Password', with: 'password'
    fill_in 'Confirmation', with: 'password'
    click_button 'Sign up'
    expect(page).to have_content('Name is already taken')
  end
  # scenario "It displays welcome message when your register your name" do
  #   visit "/sign_up"
  #   fill_in("username", with: "Jongmin")
  #   click_button("Sign Up")
  #   expect(page).to have_content("Thank you for signing up, Jongmin!")
  # end
  #
  # scenario "You can choose one option out of two" do
  #   visit "/welcome"
  #   expect(page).to have_content("Play with computer")
  #   expect(page).to have_content("Play with friends")
  # end


end
