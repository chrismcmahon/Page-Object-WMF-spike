
require 'spec_helper'


describe "Manipulating Special:UploadWizard" do
  
  context "Log in is required" do
    it "should have a link to log in" do
      visit_page(UploadWizardPage)
        @current_page.logged_in
      end
    end
    
  end
      