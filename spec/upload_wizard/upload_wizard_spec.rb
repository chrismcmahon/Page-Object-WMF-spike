
require 'spec_helper'

describe "Manipulating Special:UploadWizard" do
  
  
  context "Log in is required" do
    it "should have a link to log in" do
      visit_page(UploadWizardPage)
        @current_page.logged_in
        @current_page.text.should include "Log in / create account" 
        on_page(LoginPage).login_with('user', 'pass')
      end
    end
    
  context "Navigate to UW should work after login" do
    it "should be on UW" do
      visit_page(UploadWizardPage)
      @current_page.tutorial_map.should be_true
    end
  end
  
  context "Check Learn screen elements and navigate to Upload" do
    it"should have a skip box and a Next" do
      on_page(UploadWizardPage) do |page|
        page.skip_radio_element.when_visible
        page.check_skip_radio
        page.skip_radio_checked?.should be_true
        page.uncheck_skip_radio
        page.skip_radio_checked?.should be_false
        page.next_element.click
      end
    end
  end
  
  context "Upload a file and check license info" do
    it "should make all license choices available upon upload" do
      on_page(UploadWizardPage) do |@page|
        @page.select_file="/Users/christophermcmahon/Desktop/uke.jpg"
        #sleep 5
        #refactor these waits
        @page.wait_until do
          @page.text.include? "All uploads were successful!"
        end
        @page.continue_button
        #own work
        @page.wait_until do 
          @page.text.include? "This site requires you to provide copyright information for this work, to make sure everyone can legally reuse it"
        end
        @page.select_own_work_button
        @page.text.should include "the copyright holder of this work, irrevocably grant anyone the right to use this work under the Creative Commons Attribution ShareAlike 3.0 license"
        @page.legal_code_recommended_element.should be_true
        @page.next_element.should be_true
        @page.author_element.should be_true
        @page.different_license
        
        #refactor this, see below
        @page.legal_code_cc_sa3_element.should be_true
        @page.legal_code_cca3_element.should be_true
        @page.legal_code_cc_waiver_element.should be_true
        
        @page.select_cca_sa
        @page.select_cca3
        @page.select_cc_cc
        #third party
        @page.select_third_party_button
        sleep 3
        @page.cc
        @page.flickr
        @page.expired
        @page.us_govt
        @page.not_mentioned
        @page.found_it
        
        #refactor this 
        @page.legal_code_cc_sa3_element.should be_true
        @page.legal_code_cca3_element.should be_true
        @page.legal_code_cc_waiver_element.should be_true
        @page.legal_code_cc_sa25_element.should be_true
        @page.legal_code_cca25_element.should be_true
        
        @page.believe_free_selected?
        @page.select_cca_sa3
        @page.select_cca_sa2
        @page.select_cca3_2
        @page.select_cca2
        @page.select_cc_waiver
        @page.select_cca_sa20
        @page.select_cca_2_2
        @page.select_us_govt_2
        @page.select_pre_1923
        @page.select_repro
        @page.select_us_govt_3
        @page.select_nasa
        @page.select_free_form
        @page.free_lic_element.should be_true
      end
    end    
  end
  
  context "Source and Author are required" do
    it "should display error messages for empty Source and Author fields" do
      on_page(UploadWizardPage) do |@page|
        @page.next_button_element.click
        # improve this, like a regex for "glob:This field is required*Source*This field is required*Author"
        @page.wait_until do
          @page.text.include? "This field is required"
        end
        #@page.text.should include "This field is required"
      end
    end
  end
  
  context "Title, Description, etc. are in place" do
    it "should be able to type into Title, Description, check language and category link" do
      on_page(UploadWizardPage) do |@page|
        @page.own_work_button_element.click
        @page.next_button_element.click
        @page.wait_until do
          @page.text.include? "Description"
        end
        @page.title_field_element.send_keys("Automated test title")
        @page.description_field_element.send_keys("Automated testing created this description")
        @page.language.should include "English"
        @page.date_created_element.send_keys("Autamated test")
        @page.categories.should be_true
        @page.add_categories_element.send_keys("Automated test")
        @page.latitude_element.send_keys("Automated test")
        @page.longitude_element.send_keys("Automated test")
        @page.altitude_element.send_keys("Automated test")
        @page.other_information_element.send_keys("Automated test")
        @page.wait_until do
          @page.text.include? "The latitude needs to be between -90 and 90"
        end
        @page.text.should include "The longitude needs to be between -180 and 180"
        @page.text.should include "The altitude needs to be a number"
      end
    end
  end
        
  
  end
      