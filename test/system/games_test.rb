require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  test "Going to /new gives us a new random grid to play with" do
    visit new_url
    assert test: "New game"
    puts "Check ok : Grid got 10 letters" if assert_selector "td", count: 10
  end

  test "Fill with bonjour" do
    visit new_url
    fill_in "attempt", with: "opihihupiuh"
    click_on "Try it"
    puts "Check ok : Score got 4 keys" if assert_selector "li", count: 4
    puts "Check ok when letters not in grid" if assert_selector "#result", text: "Letters are not in the grid"
  end

  test "Fill with single consomn" do
    visit new_url
    letters = all("td").map(&:text)
    puts letters.inspect
    fill_in "attempt", with: "v"
    click_on "Try it"
    if letters.include?("v")
      puts "Check ok : Not an english word" if assert_selector "#result", text: "Not an english word"
    else
      puts "Check ok when letters not in grid" if assert_selector "#result", text: "Letters are not in the grid"
    end
  end

  test "Check reel word" do
    visit new_url
    letters = all("td").map(&:text)
    puts letters.inspect
    fill_in "attempt", with: "cat"
    click_on "Try it"
    puts "Check ok when english word found !" if assert_selector "#result", text: "Well Done"
  end
end
