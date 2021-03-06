require 'rails_helper'

feature 'pictures' do

  context 'no pictures have been added' do
    scenario 'should display a prompt to add a picture' do
      visit '/pictures'
      expect(page).to have_content 'No pictures yet'
      expect(page).to have_link 'Add a picture'
    end
  end

  context 'pictures have been added' do
    before do
      sign_up
      create_picture
    end

    scenario 'display pictures' do
      visit '/pictures'
      expect(page).to have_content('Me')
      expect(page).not_to have_content('No pictures yet')
    end
  end

  context 'creating pictures' do
    scenario 'prompts user to fill out a form, then displays the new picture' do
      sign_up
      visit '/pictures'
      click_link 'Add a picture'
      fill_in 'Name', with: 'Golf club'
      fill_in 'Description', with: 'Look how empty the course is!'
      click_button 'Upload picture'
      expect(page).to have_content 'Golf club'
      expect(current_path).to eq '/pictures'
    end

    context 'an invalid picture' do
    scenario 'does not let you submit a name that is too short' do
      sign_up
      visit '/pictures'
      click_link 'Add a picture'
      fill_in 'Name', with: 'A'
      click_button 'Upload picture'
      expect(page).not_to have_css 'h2', text: 'A'
      expect(page).to have_content 'error'
    end
  end
  end

  context 'viewing pictures' do
    scenario 'lets a user view a picture' do
      sign_up
      create_picture(name: 'My new car', description: 'Awesome pic!')
      click_link 'My new car'
      expect(page).to have_content 'Awesome pic!'
      expect(current_path).to eq "/pictures/#{Picture.last.id}"
    end
  end

  context 'editing pictures' do
    scenario 'let a user edit a pictures description' do
      sign_up
      create_picture
      visit root_path
      click_link 'Edit'
      fill_in 'Description', with: 'A great selfie'
      click_button 'Upload picture'

      click_link 'Me'
      expect(page).to have_content 'A great selfie'
      expect(page).not_to have_content 'Awesome pic'
      expect(current_path).to eq "/pictures/#{Picture.last.id}"
    end
  end

  context 'deleting pictures' do
    before do
      sign_up
      create_picture
    end

    scenario 'removes a picture when user clicks delete link' do
      visit root_path
      click_link 'Delete'
      expect(page).not_to have_content 'Me'
      expect(page).to have_content 'Picture deleted successfully'
    end
  end
end
