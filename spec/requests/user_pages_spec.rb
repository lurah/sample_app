require 'spec_helper'

describe "User Pages" do

	subject { page }

	describe "profile page" do
		let(:user) { FactoryGirl.create(:user) }
		before { visit user_path(user) }

		it { should have_selector('h1',    text: user.name) }
		it { should have_selector('title', text: user.name) }
	end

	describe "signup page" do
		before { visit new_user_path }
		let(:submit) { "Create my account" }

		describe "dengan data yang salah" do
			it "harus tidak merubah jumlah user" do
				expect { click_button submit }.not_to change(User, :count)
			end
			
			describe "halaman salanya" do
				before { click_button submit }

				it { should have_selector('title', text: 'Sign Up') }
				it { should have_content('error') }
			end
		end

		
		describe "dengan data yang benar" do
			before do
				fill_in "Name",         with: "Adrie T"
				fill_in "Email",        with: "adrie@belogix.com"
				fill_in "Password",     with: "password"
				fill_in "Confirmation", with: "password"
			end

			it "harus merubah jumlah user" do
				expect { click_button submit }.to change(User, :count).by(1)
			end

			describe "halaman benarnya" do
				before { click_button submit }
				let(:user) { User.find_by_email('adrie@belogix.com') }

				it { should have_selector('title', text: user.name) }
				it { should have_selector('div.alert.alert-success', text: 'Welcome') }
				it { should have_link('Sign out') }
			end
		end
	end

end
