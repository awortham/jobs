require './test/test_helper'

class UserInteractsWithAnApplication < ActionDispatch::IntegrationTest
  def test_user_can_view_the_details_of_an_application
    person = create(:person)
    app = person.applications.create!(company: "Basecamp",
    url: "http://basecamp.com",
    location: "Chicago, IL",
    status: "applied")

    page.set_rack_session(user_id: person.id)
    visit dashboard_path
    within("#application_#{app.id}") do
      click_link_or_button app.company
    end

    assert page.has_content? app.url
  end

  def test_editing_the_details_of_an_application
    person = create(:person)
    app = person.applications.create!(company: "Basecamp",
    status: "applied"   )

    page.set_rack_session(user_id: person.id)
    visit application_path(app)
    click_link_or_button("edit_application_#{app.id}")

    fill_in "application_company", with: "Trello"
    save_application

    refute page.has_content? "Basecamp"
    assert page.has_content? "Trello"
  end

  private

  def save_application
    click_link_or_button "Save"
  end
end
