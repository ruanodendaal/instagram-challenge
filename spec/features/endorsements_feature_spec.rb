feature 'endorsing pictures' do
  before do
    sign_up
    create_picture(name: 'Selfie')
  end

  scenario 'a user can endorse a picture, which updates the picture endorsement count' do
    visit '/pictures'
    click_link 'LIKE'
    expect(page).to have_content('1 like')
  end

end