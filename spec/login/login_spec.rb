
require 'spec_helper'

describe "Logging into the system" do
  context "successful login" do
    it "should display welcome message" do
      visit_page(LoginPage).login_with('foo', 'bar')
      #@current_page.text.should include "Welcome foo"
      @current_page.text.should include "Secure your account"
      @current_page.text.should include "phishing"
      @current_page.phishing.should be_empty
    end
  end

  context "unsuccessful login" do
    it "should display an error messge" do
      visit_page(LoginPage).login_with('foo', 'badpass')
      @current_page.text.should include "Login error"
      @current_page.text.should include "Secure your account"
    end
  end
end
