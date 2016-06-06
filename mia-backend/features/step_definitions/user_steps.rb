Given /^I am a logged in user$/ do
  @user = FactoryGirl.create(:user)
  expect(@user).to be_valid
  visit ember_sign_in_path
  fill_in :email, :with => @user.email
  fill_in :password, :with => 'password'
  click_link_or_button 'Submit'
  expect(page).not_to have_content("Sign In")
end

When /^I sign out$/ do
  find('.dropdown').click
  find('a.sign-out').click
end

When /^I go to sign in$/ do
  find('a.sign-in').click
end

When /^I go to edit my profile$/ do
  visit ember_users_edit_path
end

When /^I change my full name$/ do
  fill_in 'user[first_name]', with: "Bill"
  fill_in 'user[last_name]', with: "Ted"
end

Then /^I should be on my profile$/ do
  expect(page).to have_content('Your videos')
end

Then /^my profile should have been updated$/ do
  @user.reload
  expect(@user.first_name).to eq('Bill')
  expect(@user.last_name).to eq('Ted')
end

Then /^my profile should include the avatar$/ do
  expect(@user.avatar_url).to include('camera.png')
end

When /^I click forgot my password$/ do
  click_link 'Forgot your password?'
end

When /^I enter my email$/ do
  fill_in :email, :with => @user.email
end

Given /^there is a video$/ do
  @video = create(:uploaded_video, :owner => @user || create(:user))
  expect(@video).to be_valid
  step "the uploaded video has finished processing"
  @video.reload
end

Given /^there is an unpublished video$/ do
  @unpublished_video = create(:uploaded_video, :published => false, :owner => @user || create(:user))
  expect(@unpublished_video).to be_valid
  step "the uploaded video has finished processing"
  @unpublished_video.reload
end

When /^I visit the search page$/ do
  visit ember_search_path
  expect(page).to have_content('Cancel')
end

When /^I visit the video index$/ do
  visit ember_videos_path
end

When /^I visit my profile$/ do
  visit ember_users_show_path(:id => @user.id)
end

Then /^I should see the video title$/ do
  expect(page).to have_content(@video.title)
end

Then /^I should not see the video title$/ do
  expect(page).not_to have_content(@video.title)
end

Given /^the video has the child motif between (\d+) and (\d+)/ do |start_time_ms, end_time_ms|
  expect(create(:video_motif, :video => @video, :motif => @motif, :start_time_ms => start_time_ms, :end_time_ms => end_time_ms)).to be_valid
  @video.reload
end

Given /^the video has the root motif between (\d+) and (\d+)/ do |start_time_ms, end_time_ms|
  expect(create(:video_motif, :video => @video, :motif => @root_motif, :start_time_ms => start_time_ms, :end_time_ms => end_time_ms)).to be_valid
  @video.reload
end

When /^I search for the child motif$/ do
  step "I search for the motif named '#{@motif.name}'"
end

When /^I search for the root motif$/ do
  step "I search for the motif named '#{@root_motif.name}'"
end

When /^I execute the search$/ do
  find('a.do-search').click
end

Then /^I should see the video in the search results$/ do
  find('.top-level-nav').hover
  expect(page).to have_css('.meta-data h2', :text => @video.title)
end

When /^I search for the motif named '(.*)'$/ do |name|
  step "I enter the motif named '#{name}'"
  expect(page).to have_css('a', :text => name)
end

Then /^I should not see the unpublished video title$/ do
  expect(page).not_to have_content(@unpublished_video.title)
end

Given /^there is a root motif$/ do
  @root_motif = create(:motif)
  expect(@root_motif).to be_valid
  @root_motif_child = create(:motif, :parent => @root_motif)
  expect(@root_motif_child).to be_valid
end

Given /^the root motif has a related motif$/ do
  step "there is a child motif"
  rm = create(:related_motif, :motif1 => @root_motif, :motif2 => @motif)
  expect(rm).to be_persisted
end

Given /^there is a root motif with an icon$/ do
  @motif = create(:motif, :icon => File.open(Rails.root.join('spec','fixtures','ajax-loader.gif')) )
  expect(@motif).to be_valid
end

Given /^there is a child motif$/ do
  @motif = create(:motif, :parent => create(:motif))
  expect(@motif).to be_valid
end

Given /^the motif has an image$/ do

end

When /^I visit the child motif$/ do
  visit ember_motifs_show_path(:id => @motif.id)
  expect(page).to have_content(@motif.name)
end

Given /^there is a video with the motif$/ do
  step "there is a video"
  vm = create(:video_motif, :video => @video, :motif => @motif)
  @video.reload
  expect(vm.valid?).to be_truthy
  expect(vm.persisted?).to be_truthy
end

Given /^there is a video with a timestamped motif$/ do
  step "there is a video"
  vm = create(:video_motif, :video => @video, :motif => @motif, :start_time_ms => @video.duration_ms / 2, :end_time_ms => @video.duration_ms)
  @video.reload
  expect(vm).to be_valid
end

When /^I visit the motifs index$/ do
  visit ember_motifs_path
end

When /^I visit the discover page$/ do
  visit ember_discover_path
end

Then /^I should see the latest video motif$/ do
  expect(page).to have_content(VideoMotif.last.motif.name)
end

Then /^I should see the child motif name$/ do
  expect(page).to have_content(@motif.name)
end

Then /^I should not see the child motif name$/ do
  expect(page).not_to have_content(@motif.name)
end

Then /^I should see the root motif name$/ do
  expect(page).to have_content(@root_motif.name)
end

Then /^I should not see the root motif name$/ do
  expect(page).not_to have_content(@root_motif.name)
end

When /^I visit the root motif$/ do
  visit ember_motifs_show_path(:id => @root_motif.id)
  expect(page).to have_css('h1', :text => @root_motif.name)
end

When /^I delete the motif$/ do
  accept_dialog
  find('a.delete').click
end

When /^I click add related motif$/ do
  first('a.add-related-motif').click
end

When /^I remove the first related motif$/ do
  first('a.remove-related-motif').click
end

When /^I click the motif edit$/ do
  find('a.edit').click
end

Then /^I should see the root motif details$/ do
  step "I should see the root motif name"
  expect(page).to have_content(@root_motif_child.name)
end

When /^I view the video$/ do
  visit ember_videos_show_path(:id => @video.id)
  expect(page).to have_content(@video.title)
end

When /^I edit the video$/ do
  visit ember_videos_show_edit_path(:id => @video.id)
  expect(page).to have_content(@video.title)
end

When /^I edit the unpublished video$/ do
  visit ember_videos_show_edit_path(:id => @unpublished_video.id)
  expect(page).to have_content(@unpublished_video.title)
end

When /^I enter the video title "(.*)"$/ do |title|
  fill_in :'video[title]', :with => title
end

When /^I save the video$/ do
  click_button 'Update Video'
end

When /^I click on the first general motif$/ do
  find('.general-motifs a.motif-item:first-child').click
end

When /^I click on the first timestamped motif$/ do
  find(".video-motif-duration:first-child").click
end

When /^I click the motif name$/ do
  click_link @motif.name
end

When /^I delete the video motif$/ do
  within '.right-col' do
    click_link 'Delete'
  end
end

When /^I delete the video$/ do
  accept_dialog
  click_link 'Delete'
end

Then /^I should see the icon$/ do
  expect(page).to have_css('img[src*="ajax-loader.gif"]')
end

When /^I view the video at time (\d+)$/ do |time|
  visit ember_videos_show_path(:id => @video.id, t: time)
  expect(page).to have_content(@video.title)
end

When /^I go to add a timestamped motif to the video$/ do
  within '.left-col' do
    expect(page).to have_css('.add-motif-button')
    first('.add-motif-button').click
  end
end

When /^I add a general motif to the video$/ do
  within '.general-motifs' do
    expect(page).to have_css('.add-motif-button')
    first('.add-motif-button').click
  end
  step %(I enter the root motif)
  expect(page).to have_css('.results-container .motif-item .motif-letterbox')
end

Then /^I should be on the add video motif page at time (\d+)$/ do |time|
  expect(page).to have_current_path( ember_videos_show_path(:id => @video.id, :t => time) )
end

Then /^I should be on the video index$/ do
  expect(page).to have_current_path( ember_videos_path(:refresh => true) )
end

When /^I scrub to the middle of the video$/ do
  find('.timeline ul li:nth-child(3)').click()
  expect(page).to_not have_content('Current time: 0')
end

When /^I enter the root motif$/ do
  step "I enter the motif named '#{@root_motif.name}'"
  expect(page).to have_content(@root_motif.name)
end

When /^I enter the child motif$/ do
  step "I enter the motif named '#{@motif.name}'"
  expect(page).to have_content(@motif.name)
end

When /^I add the related motif$/ do
  click_button 'Add'
end

When /^I save the video motif$/ do
  click_link 'Save'
  expect(page).not_to have_css('.mia-input')
end

When /^I cancel the video motif edit$/ do
  click_link 'Cancel'
end

Then /^the root motif should be a general motif$/ do
  within '.general-motifs' do
    expect(page).to have_content(@root_motif.name)
  end
end

Then /^I should see the scrub with the root motif$/ do
  within '.right-col' do
    expect(page).to have_content(@root_motif.name)
  end
end

Then /^I should see the scrub with the motif$/ do
  within '.right-col' do
    expect(page).to have_content(@motif.name)
  end
end

Then /^I should be on the video page at time (\d+)$/ do |time|
  expect(page).to have_current_path( ember_videos_show_path(:id => @video.id, :t => time) )
end

Then /^I should be on the root motif page$/ do
  expect(page).to have_current_path( ember_motifs_show_path(:id => @root_motif.id) )
end

Then /^there should be a video motif at time (\d+)$/ do |time|
  vm = VideoMotif.last
  expect(vm.video).to eq(@video)
  expect(vm.motif).to eq(@root_motif)
  expect(vm.start_time_ms).to eq(time.to_i)
  expect(vm.end_time_ms).to eq(@video.duration_ms)
end

Then /^there should be a video motif from (\d+) to (\d+)$/ do |start_time, end_time|
  vm = VideoMotif.last
  expect(vm.video).to eq(@video)
  expect(vm.motif).to eq(@root_motif)
  expect(vm.start_time_ms).to eq(start_time.to_i)
  expect(vm.end_time_ms).to eq(end_time.to_i)
end

When /^I enter the motif named '(.*)'$/ do |motif_name|
  fill_in :'motif-input', :with => motif_name
  find('.tt-suggestion:first-child').click()
end

When /^I go to add a video$/ do
  visit ember_videos_new_path
  expect(page).to have_content("Add a Video")
end

When /^I open the add video dialog$/ do
  find(".add-video-button").click
end

When /^I click "(.*)"$/ do |link_text|
  click_link_or_button link_text
end

Then /^the page should have css "(.*)"$/ do |css|
  expect(page).to have_css(css)
end

When /^I click the upload tab$/ do
  click_link "Upload"
end

When /^I fill in the video title with "(.*)"$/ do |title|
  fill_in :'video[title]', :with => title
end

When /^the uploaded video has finished processing$/ do
  VideoUpload.last.update_attributes!({
      :status => VideoUpload::STATUS_COMPLETE,
      :duration_ms => 3000,
      :webm_video_url => "http://video.webmfiles.org/big-buck-bunny_trailer.webm",
      :mp4_video_url => "http://video.blendertestbuilds.de/download.blender.org/peach/trailer_480p.mov"
                               })
  if @video
    @video.reload
  end
end

When /^I view the uploaded video$/ do
  visit ember_videos_show_path(:id => Video.last.id)
end

Then /^I should see the video upload$/ do
  expect(page).to have_css('video')
end

Then /^I should see "(.*)"$/ do |content|
  expect(page).to have_content(content)
end

Then /^I should see the unpublished video title$/ do
  expect(page).to have_content(@unpublished_video.title)
end

When /^I view the unpublished video$/ do
  visit ember_videos_show_path(:id => @unpublished_video.id)
  expect(page).to have_content(@unpublished_video.title)
end

When /^I publish the video$/ do
  click_link 'Publish'
  expect(page).to have_content('Unpublish')
end

When /^I unpublish the video$/ do
  click_link 'Unpublish'
  expect(page).to have_content('Publish')
end

When /^I upload a video$/ do
  click_link 'Select Video' #sets up the correct field name
  attach_file_for_direct_upload( Rails.root.join('features','fixtures','sample_mpeg4.mp4') )
  expect(page).to have_content('Uploaded: sample_mpeg4.mp4')
end

When /^I submit the video form$/ do
  within 'form.add-video' do
    click_link_or_button 'Add Video'
  end
end

When /^I submit the form$/ do
  find('input[type="submit"]').click
end

When /^I enter my password$/ do
  fill_in 'user[current_password]', with: 'password'
end

When /^I set a profile image$/ do
  click_link 'Select an Avatar' #sets up the correct field name
  attach_file_for_direct_upload( Rails.root.join('features','fixtures','camera.png') )
  expect(page).to have_content('Uploaded: camera.png')
end

When /^I submit the main form$/ do
  within '.form-container' do
    find('input[type="submit"]').click
  end
end

Then /^I should see the password reset confirmation$/ do
  expect(page).to have_content("If you have an account with us you'll receive a password reset email shortly")
end

Then /^I should receive a password reset email$/ do
  expect(ActionMailer::Base.deliveries).to_not be_empty
  message = ActionMailer::Base.deliveries.last
  expect(message.to).to eq([@user.email])
  expect(message.subject).to include('Reset password')
end

When /^I visit the reset password link$/ do
  message = ActionMailer::Base.deliveries.last
  match_data = /reset_password_token=(.*)">/.match(message.body.to_s)
  expect(match_data).to_not be_nil
  visit ember_users_password_edit_path(:reset_password_token => match_data[1])
end

Then /^I fill in a new password$/ do
  fill_in :password, :with => 'asdfasdf'
  fill_in :password_confirmation, :with => 'asdfasdf'
end

Then /^I should be on the sign in page$/ do
  expect(page).to have_css('h1', :text => 'Sign In')
end

When /^I sign in with the new credentials$/ do
  fill_in :email, :with => @user.email
  fill_in :password, :with => 'asdfasdf'
  step "I submit the main form"
end

Then /^I should be signed in$/ do
  expect(page).not_to have_content("Sign In")
end

Then /^I should be on the video page$/ do
  expect(page).to have_content(Video.last.title)
  expect(page).to have_css('.video-panel')
  expect(page.current_path).to eq( ember_videos_show_path(:id => Video.last.id))
end

Then /^I should see the scrub for the general motif$/ do
  within '.right-col' do
    expect(page).to have_content(@motif.name)
  end
end

When /^I click the video motif edit$/ do
  within '.right-col' do
    find('a.edit').click
  end
end

When /^pry$/ do
  binding.pry
end

Given /^I am an anonymous user$/ do
  @user = FactoryGirl.build(:user)
end

When /^I visit the landing page$/ do
  visit ember_root_path
  expect(page).to have_css('.twitter-typeahead')
end

When /^I visit the sign up page$/ do
  visit ember_sign_up_path
  expect(page).to have_css('h1', :text => "Sign Up")
end

When /^I log in$/ do
  fill_in :email, :with => @user.email
  fill_in :password, :with => 'password'
  click_button 'Submit'
end

When /^I sign up with my account details$/ do
  fill_in 'user[email]', :with => @user.email
  fill_in 'user[first_name]', :with => @user.first_name
  fill_in 'user[last_name]', :with => @user.last_name
  fill_in 'user[password]', :with => 'password'
  fill_in 'user[password_confirmation]', :with => 'password'
  click_button 'Sign Up'
end

Then /^I should see the sign up thank you page$/ do
  expect(page).to have_content('Thank you for signing up!')
end

When /^I confirm my account$/ do
  expect(ActionMailer::Base.deliveries).to_not be_empty
  last = ActionMailer::Base.deliveries.last
  expect(last.subject).to eq('Confirmation instructions')
  match = /href="http:\/\/localhost:3000(.*)"/.match(last.body.to_s)
  expect(match).to_not be_nil
  visit match[1]
  expect(page).to have_css('h1', :text => 'Sign In')
end

Then /^I should be logged in$/ do
  expect(page).not_to have_content("Sign In")
end

Given /^I have created a motif$/ do
  @motif = create(:motif, :owner => @user)
  expect(@motif).to be_valid
end

When /^I visit the motif$/ do
  visit ember_motifs_show_path(:id => @motif.id)
  expect(page).to have_content(@motif.name)
end

When /^I edit the root motif$/ do
  visit ember_motifs_show_edit_path(:id => @root_motif.id)
  expect(page).to have_content("Editing #{@root_motif.name}")
end

When /^I edit the motif$/ do
  visit ember_motifs_show_edit_path(:id => @motif.id)
  expect(page).to have_content("Editing #{@motif.name}")
end

When /^I upload a motif video$/ do
  click_link 'Select Video' #sets up the correct field name
  attach_file_for_direct_upload( Rails.root.join('features','fixtures','sample_mpeg4.mp4') )
  expect(page).to have_content('Uploaded: sample_mpeg4.mp4')
end

When /^I set a motif as the parent$/ do
  step "I enter the motif parent '#{@motif.name}'"
end

When /^I remove the parent$/ do
  click_link 'Remove'
  expect(page).not_to have_content("Remove")
end

When /^I upload a new image$/ do
  within '.mia-input.image' do
    click_link 'Select Image'
  end
  attach_file_for_direct_upload( Rails.root.join('features','fixtures','camera.png') )
  within '.mia-input.image' do
    expect(page).to have_content('Uploaded: camera.png')
  end
end

When /^I upload a new icon$/ do
  within '.mia-input.icon' do
    click_link 'Select Icon' #sets up the correct field name
  end
  attach_file_for_direct_upload( Rails.root.join('features','fixtures','camera.png') )
  within '.mia-input.icon' do
    expect(page).to have_content('Uploaded: camera.png')
  end
end

When /^I update the motif$/ do
  click_button 'Update Motif'
end

Then /^I should see the new motif name$/ do
  expect(page).to have_content('NewMotif')
end

Then /^I should be on the motif page$/ do
  expect(page).to have_css('h1')
  expect(page).to have_content('SEARCH MOTIFS...')
end

Then /^I should see the new icon$/ do
  expect(page).to have_css('img[src*="camera.png"]')
end

When /^I go to add a motif$/ do
  visit ember_motifs_new_path
  expect(page).to have_css(".motif-form-fields")
end

When /^I enter a motif name$/ do
  fill_in :'motif[name]', :with => 'NewMotif'
end

When /^I enter the motif parent$/ do
  step "I enter the motif parent '#{@root_motif.name}'"
end

When /^I enter the motif parent '(.*)'$/ do |name|
  within '.twitter-typeahead' do
    fill_in 'motif-parent', :with => name
    find('.tt-suggestion:first-child').click()
  end
  expect(page).to have_content("Parent: #{name}")
end

When /^I submit the motif form$/ do
  click_button 'Create Motif'
end

Then /^I should see the new root motif$/ do
  expect(page).to have_content('NewMotif')
end

Then /^I should see the new sub-motif$/ do
  expect(page).to have_css('h1', :text => 'NewMotif')
  expect(page).to have_content(@root_motif.children.last.name)
end

When /^I click Add...$/ do
  click_link('Add...')
end
