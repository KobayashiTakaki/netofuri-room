require "rails_helper"
RSpec.feature "sessions feature" do
  let(:user) { create(:user) }
  let(:video_set) { create(:video_set) }
  background do
    3.times do
      create(:video, video_set: video_set)
    end
    video_set.create_upcoming_viewings
  end

  context "User goes to login page from root" do
    background do
      visit root_path
      click_link "ログイン"
    end

    scenario "login/logout" do
      fill_in "session_name", with: user.name
      fill_in "session_password", with: "password"
      click_button "ログイン"
      expect(page).to have_current_path(root_path)
      visit room_path(video_set.room)
      click_link "ログアウト"
      expect(page).to have_current_path(root_path)
    end
  end

  context "User goes to login page from room" do
    background do
      visit room_path(video_set.room)
      click_link "ログイン"
    end

    scenario "login/logout" do
      fill_in "session_name", with: user.name
      fill_in "session_password", with: "password"
      click_button "ログイン"
      expect(page).to have_current_path(room_path(video_set.room))
      click_link "ログアウト"
      expect(page).to have_current_path(root_path)
    end
  end
end
