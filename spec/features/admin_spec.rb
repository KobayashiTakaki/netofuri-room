require "rails_helper"
RSpec.feature "admin feature" do
  let(:user) { create(:user) }
  let(:admin_user) { create(:user, admin: true) }
  let(:video_set) { create(:video_set) }
  background do
    3.times do
      create(:video, video_set: video_set)
    end
    video_set.create_upcoming_viewings
  end

  context "User is not admin" do
    background do
      visit root_path
      click_link "ログイン"
      fill_in "session_name", with: user.name
      fill_in "session_password", with: "password"
      click_button "ログイン"
    end

    scenario "User visits admin pages" do
      visit new_admin_video_set_path
      expect(page).to have_current_path(root_path)
      visit new_admin_video_path
      expect(page).to have_current_path(root_path)
    end
  end

  context "User is admin" do
    background do
      visit root_path
      click_link "ログイン"
      fill_in "session_name", with: admin_user.name
      fill_in "session_password", with: "password"
      click_button "ログイン"
    end

    scenario "User visits admin pages" do
      visit new_admin_video_set_path
      expect(page).to have_current_path(new_admin_video_set_path)
      visit new_admin_video_path
      expect(page).to have_current_path(new_admin_video_path)
    end
  end
end
