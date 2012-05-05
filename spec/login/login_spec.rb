
require 'spec_helper'

describe "Logging into the system" do
  before(:each) do
    visit_page LoginPage
  end

  context "successful login" do
    it "should display welcome message" do
      on_page(LoginPage) do |page|
        page.login_with('foo', 'bar')
        #page.text.should include "Welcome foo"
        page.text.should include "Secure your account"
        page.text.should include "phishing"
      end
    end
  end

  context "unsuccessful login" do
    it "should display an error messge" do
      on_page(LoginPage) do |page|
        page.login_with('foo', 'badpass')
        page.text.should include "Login error"
        page.text.should include "Secure your account"
      end
    end
  end
  
  context "check login page links" do
    it "should demonstrate all the defined links exist" do 
      on_page(LoginPage) do |page|
        page.phishing_element.should be_true
        page.password_strength_element.should be_true
      end
    end
  end
  
  context "visit login page links" do
    it "should follow all the defined links" do 
      on_page(LoginPage) do |page|
        page.phishing.should be_true
        page.text.should include "Not to be confused with"
      end
      visit_page(LoginPage) do |page|
        page.password_strength.should be_true
        page.text.should include "measure of the effectiveness"
      end
    end
  end
  
end
