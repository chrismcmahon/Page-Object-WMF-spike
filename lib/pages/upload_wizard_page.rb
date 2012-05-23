
class UploadWizardPage
  include PageObject
  page_url 'https://commons.wikipedia.org/wiki/Special:UploadWizard'
  link(:logged_in, :link_text => 'logged in')
  div(:tutorial_map, :id => 'mwe-upwiz-tutorial')
end