require 'spec_helper'
require 'yaml'

describe "Manipulating Special:UploadWizard" do
  context "Log in is required" do
    it "should have a link to log in and have correct login credentials" do
      visit_page(UploadWizardPage)
      @current_page.logged_in
      @current_page.text.should include "Log in / create account"
      config = YAML.load_file('config.yml')
      username = config['tests']['username']
      password = config['tests']['password']
      on_page(LoginPage).login_with(username, password)
    end
  end

  context "Navigate to UW should work after login" do
    it "should be on UW" do
      visit_page(UploadWizardPage)
      @current_page.text.include? "Thanks for using our new upload tool!Help with translations"
      @current_page.tutorial_map.should be_true
    end
  end
 
  context "Check Learn screen elements and navigate to Upload" do
    it "should have a skip box and a Next" do
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
      on_page(UploadWizardPage) do |arg|
        @page = arg

        config = YAML.load_file('config.yml')
        files = config['tests']['files']
        @page.select_file = files['never_uploaded']

        #sleep 5
        #refactor these waits
        @page.wait_until(20) do
          @page.text.include? "All uploads were successful!"
        end
        @page.continue_button
        #own work
        @page.wait_until(5) do 
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
      on_page(UploadWizardPage) do |arg|
        @page = arg
        @page.next_button_element.click
        # improve this, like a regex for "glob:This field is required*Source*This field is required*Author"
        @page.wait_until(5) do
          @page.text.include? "This field is required"
        end
        #@page.text.should include "This field is required"
      end
    end
  end

  context "Title, Description, etc. are in place" do
    it "should be able to type into Title, Description, check language and category link" do
      on_page(UploadWizardPage) do |arg|
        @page = arg
        @page.own_work_button_element.click
        @page.next_button_element.click
        @page.wait_until(5) do
          @page.text.include? "Description"
        end

        @page.title_field_element.click
        @page.title_field_element.clear
        @page.title_field_element.send_keys "DSC_002"
        @page.title_label_element.click
# This test is broken.
#        @page.wait_until(5) do
#          # There are two possible values, depending on the blacklist entries for the site.
#          @page.text.include? "Please choose a different, descriptive title." or @page.text.include? "Please make this title more meaningful."
#        end

        @page.title_field_element.send_keys("Automated test title")
        @page.description_field_element.send_keys("Automated testing created this description")
        @page.language.should include "English"
        @page.date_created_element.send_keys("Automated test")
        @page.categories.should be_true
        @page.add_categories_element.send_keys("Automated test")
        @page.latitude_element.click
        @page.latitude_element.send_keys("Automated test")
        @page.longitude_element.click
        @page.text.should include "The latitude needs to be between -90 and 90"
        @page.longitude_element.send_keys("Automated test")
        @page.other_information_element.click
        @page.text.should include "The longitude needs to be between -180 and 180"
        @page.other_information_element.send_keys("Automated test")
      end
    end
  end

  context "Navigate to UW should still work after previous tests" do
    it "should be on UW" do
      on_page(UploadWizardPage) do |newpage|
        # Prevent alert from firing
        newpage.browser.execute_script 'window.onbeforeunload = function () {};'
      end
      visit_page(UploadWizardPage)
      on_page(UploadWizardPage) do |newpage|
        newpage.tutorial_map.should be_true
        newpage.next_element.click
      end
    end
  end

  context "Upload two files and check messages" do
    it "should pluralize messages properly with multiple files" do
      on_page(UploadWizardPage) do |arg|
        @page = arg

        config = YAML.load_file('config.yml')
        files = config['tests']['files']
        @page.select_file = files['never_uploaded']

        @page.wait_until(5) do
          @page.text.include? "All uploads were successful!"
        end

        @page.select_file = files['another_never_uploaded']

        @page.wait_until(5) do
          @page.text.include? "All uploads were successful!"
        end

        @page.continue_button
        #own work
        @page.wait_until(5) do 
          @page.text.include? "This site requires you to provide copyright information for these works, to make sure everyone can legally reuse them"
        end
        @page.select_own_work_button
        @page.text.should include "the copyright holder of these works, irrevocably grant anyone the right to use these works under the Creative Commons Attribution ShareAlike 3.0 license"

        # I don't really care about the copyright stuff in this test, I already made sure it worked before.
        @page.select_cca_sa
        @page.next_button_element.click

        @page.wait_until(5) do
          @page.text.include? "Description"
        end

        @page.categories.should be_true

        @page.copymeta.should be_true
        @page.text.should include 'Copy title'
      end
    end
  end
end
