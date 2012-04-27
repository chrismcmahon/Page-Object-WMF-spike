
require 'spec_helper'

describe "check Edit tools" do
  context "click Edit and exercise Edit tools" do
  it "should affect the display upon clicking each Edit tool" do
    visit_page(ProofreadPage)
    @current_page.text.should include "This page has not been proofread"
    @current_page.edit
    @current_page.text.should include "Warning: You are not logged in"
    @current_page.article_text.should be_true
    #checking Bold button
    @current_page.bold.should be_true
    @current_page.bold_element.click
    @current_page.article_text.should include "'''Bold text'''"
    #checking Italics button 
    @current_page.article_text_element.send_keys :arrow_right, :arrow_right, :arrow_right, :arrow_right, :arrow_right
    @current_page.italic_element.click
    @current_page.article_text.should include "''Italic text''"
    #checking Embedded file
    @current_page.article_text_element.send_keys :arrow_right, :arrow_right, :arrow_right, :arrow_right, :arrow_right
    @current_page.embedded_element.click
    @current_page.article_text.should include "[[File:Example.jpg]]"
    
  end
end

end #describe
    
  
 