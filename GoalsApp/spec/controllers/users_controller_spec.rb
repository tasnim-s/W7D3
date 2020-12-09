require "rails_helper"

RSpec.describe UsersController, type: :controller do
    describe "GET #new" do
        it "brings up the form to make new user" do
            get :new
            expect(response).to render_template(:new)
        end
    end

    describe "POST #create" do
        context "with valid params" do
            it "redirects to the sign up on success" do
                post :create, params: {user: {username: "Joshua", password: "password"}}
                expect(response).to redirect_to(new_session_url)
            end
        end

        context "with invalid params" do
            it "validates the presence of the user's username and password" do
                post :create, params: {user: {username: "Joshua", password: ""}}
                expect(response).to render_template(:new)
                expect(flash[:errors]).to be_present
            end

            it "validates the password is at least 6 characters long" do
                post :create, params: {user: {username: "Joshua", password: "1234"}}
                expect(response).to render_template(:new)
                expect(flash[:errors]).to be_present
            end
        end
        
    end
end