require 'spec_helper'
require 'rails_helper'

# Test New User
describe 'User specs' do
  before do
    allow_any_instance_of(User).to receive(:get_info_from_ldap) do |user|
      user.uid = 'ac1arx'
      user.email = 'a.ragni@sheffield.ac.uk'
      user.username = 'ac1arx'
      user.dn = 'uid=aca20sf,ou=Undergraduates,ou=Students,ou=Users,dc=sheffield,dc=ac,dc=uk'
    end
  end
  describe 'user' do
    # log in as a student
    it 'logs is and visits new user page ' do
      visit '/users/sign_in'
      login_as(FactoryBot.create(:student))
      visit '/ecfs'
      expect(page).to have_content 'Listing'
    end
  end

  describe 'user' do
    # log in as a module leader
    it 'logs is and visits new user page ' do
      visit '/users/sign_in'
      login_as(FactoryBot.create(:module_leader))
      visit '/ecfs'
      expect(page).to have_content 'Listing'
    end
  end

  describe 'user' do
    # log in as a scrutiny panel member
    it 'logs is as scrutiny panel ' do
      visit '/users/sign_in'
      login_as(FactoryBot.create(:scrutiny_panel))
      visit '/ecfs'
      expect(page).to have_content 'Listing'
    end
  end

  describe 'user' do
    # log in as a admin
    it 'log in as admin ' do
      visit '/users/sign_in'
      login_as(FactoryBot.create(:admin))
      visit '/users'
      expect(page).to have_content 'Listing users'
    end
  end

  describe 'user' do
    # log in as a user
    it 'creates new user as admin ' do
      visit '/users/sign_in'
      login_as(FactoryBot.create(:admin))
      visit '/users/new'
      fill_in 'email', with: 'a.ragni@sheffield.ac.uk'
      select 'Admin', from: 'role', visible: false
      click_button 'submit'
      visit '/users'
      expect(page).to have_content 'ac1arx'

      click_link 'Show', match: :first
      expect(page).to have_content 'User ID:'
      visit '/users'
      click_link 'Edit', match: :first
      expect(page).to have_content 'Edit user role here'
      select 'Admin', from: 'user[role]', visible: false
      click_button 'Update User'
      expect(page).to have_content 'Listing users'
    end
  end
  # test doesnt work due to needing mock of ldap username
  describe 'user' do
    it 'creates new user as admin ', js: true do
      visit '/users/sign_in'
      login_as(FactoryBot.create(:admin))
      visit '/users/new'
      fill_in 'email', with: 'a.ragni@sheffield.ac.uk'
      click_button 'submit'
      expect(page).to have_content 'User was successfully created with role'
    end
  end

  # test doesnt work due to needing mock of ldap username
  describe 'user', js: true do
    it 'tries to create pre-existing user with email ', js: true do
      visit '/users/sign_in'
      login_as(FactoryBot.create(:admin))
      visit '/users/new'
      fill_in 'email', with: 'a.ragni@sheffield.ac.uk'
      select 'Admin', from: 'role'
      click_button 'submit'
      visit '/users/new'
      fill_in 'email', with: 'a.ragni@sheffield.ac.uk'
      select 'Admin', from: 'role'
      click_button 'submit'
      expect(page).to have_content 'This user already exists in the database.'
    end
  end

  # tests non existing email
  # describe 'user' do
  #   # log in as a user
  #   it 'creates new user as admin ' do
  #     visit '/users/sign_in'
  #     login_as(FactoryBot.create(:admin))
  #     visit '/users/new'
  #     fill_in 'email', with: 'a.ragni@sheffield.ac.uk'
  #     select 'Admin', from: 'role'
  #     click_button 'submit'
  #     expect(page).to have_content 'User could not be found with email'
  #   end
  # end

  describe 'user' do
    # log in as a user
    it 'tests new user link ' do
      visit '/users/sign_in'
      login_as(FactoryBot.create(:admin))
      visit '/users'
      click_link 'New User'
      expect(page).to have_content 'New user'
    end
  end

  describe 'user' do
    it 'tests user upload ', js: true do
      # login
      visit"/users/sign_in"
      login_as(FactoryBot.create(:admin))
      visit"/users/new"
      # fill_in "email", with: "sfansur1@sheffield.ac.uk"
      fill_in "email", with: "a.ragni@sheffield.ac.uk"
      click_button "submit"
      expect(page).to have_content "User was successfully created with role"
    end
  end

  describe 'user' do
    it 'tests csv user upload', js: true do
      # login
      visit '/users/sign_in'
      login_as(FactoryBot.create(:admin))
      visit '/users'
      click_link 'CSV Upload'
      expect(page).to have_content 'File'
      attach_file('user[file]', Rails.root + 'spec/features/csv_test.csv')
      # save users
      click_button 'Import users'
      expect(page).to have_content 'Users imported successfully.'
    end
  end

  describe 'user' do
    it 'tests csv user upload failed due to wrong file format', js: true do
      # login
      visit '/users/sign_in'
      login_as(FactoryBot.create(:admin))
      visit '/users'
      click_link 'CSV Upload'
      expect(page).to have_content 'File'
      attach_file('user[file]', Rails.root + 'spec/features/csv_test_fail.csv')
      # save users
      click_button 'Import users'
      expect(page).to have_content 'Failed to upload users - CSV file is of the incorrect format.'
    end
  end

  describe 'user' do
    it 'tests the departments drop down box for search', js: true do
      # login
      visit '/users/sign_in'
      login_as(FactoryBot.create(:student2))
      logout(:student)
      login_as(FactoryBot.create(:student3))
      logout(:student3)
      login_as(FactoryBot.create(:admin))
      visit '/users'
      expect(page).to have_content 'aca20sf'
      expect(page).to have_content 'ab1ast'
      expect(page).to have_content 'JNL'
      expect(page).to have_content 'COM'
      find(:xpath, '/html/body/main/div/div/div/table/tbody[2]/tr/td[2]/select').set('COM')
      click_button 'Search'
      expect(page).to have_content 'COM'
      visit '/users'
      find(:xpath, '/html/body/main/div/div/div/table/tbody[2]/tr/td[2]/select').set('JNL')
      click_button 'Search'
      expect(page).to have_content 'JNL'
    end
  end
end

#tests non existing email
describe 'user' do
  # log in as a user
  it 'creates new user as admin ' do
    visit '/users/sign_in'
    login_as(FactoryBot.create(:admin))
    visit '/users/new'
    fill_in 'email', with: 'a.ragni@sheffield.ac.uk'
    select 'Admin', from: 'role'
    click_button 'submit'
    expect(page).to have_content 'User could not be found with email'
  end
end
