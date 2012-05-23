
require 'spec_helper'

describe "Manipulating Special:UploadWizard" do
  
  
  context "Log in is required" do
    it "should have a link to log in" do
      visit_page(UploadWizardPage)
        @current_page.logged_in 
        @current_page.login_with('user','pass')
      end
    end
    
  context "Navigate to UW should work after login" do
    it "should be on UW" do
      visit_page(UploadWizardPage)
      @current_page.tutorial_map.should be_true
    end
  end
      
    
    
  end
      