require_relative "../spec_helper"
require 'rails_helper'


#search sql injection test (temp)
describe "search" do
    #log in as a user
    it "fills out and submits meetings " do
        #Create an ECF to test deletion
        login_as(FactoryBot.create(:student))
        visit"/ecfs"
        click_link "Create New ECF"
        fill_in "Details", with: "Example User2"
        fill_in "Unit code", with: "COM2008"
        fill_in "Assessment type", with: "Exam"
        select "DEX - Deadline Extension", from: "Requested action ", visible: false
        click_button "Create Ecf"
        expect(page).to have_content "aca20sf"
        login_as(FactoryBot.create(:admin))
        visit"/ecfs"
        expect(page).to have_content "aca20sf" #first ecf check
        # #Test search functionality
        find_field('q[status_cont]').set("http://www.example.com/articles.php?id=-1; DROP ALL TABLES; --")
        find_field('q_user_givenname_or_user_sn_cont').set("http://www.example.com/articles.php?id=-1; DROP ALL TABLES; --")
        click_button "Search"
        Ecf.any? #chcks if anything in Ecf model in database
        find_field('q[status_cont]').set("")
        find_field('q_user_givenname_or_user_sn_cont').set("")
        click_button "Search"
        expect(page).to have_content "aca20sf" #second ecf check

    end
end
