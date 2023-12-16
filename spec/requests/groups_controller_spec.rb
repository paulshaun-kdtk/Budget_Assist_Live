require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  describe 'GET #index' do
    it 'assigns user and groups' do
      user = User.create(name: 'John Doe', email: 'john@example.com', password: 'password')
      group = Group.create(name: 'Group 1', user: user)

      get :index
      expect(assigns(:user)).to eq(user)
      expect(assigns(:groups)).to eq([group])
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    it 'assigns group, recent_payments, and total_amount' do
      user = User.create(name: 'John Doe', email: 'john@example.com', password: 'password')
      group = Group.create(name: 'Group 1', user: user)

      get :show, params: { id: group.id }
      expect(assigns(:group)).to eq(group)
      expect(assigns(:recent_payments)).to eq(group.recent_payments)
      expect(assigns(:total_amount)).to eq(group.total_amount)
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    it 'assigns user and a new group' do
      user = User.create(name: 'John Doe', email: 'john@example.com', password: 'password')

      get :new
      expect(assigns(:user)).to eq(user)
      expect(assigns(:group)).to be_a_new(Group)
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new group' do
        user = User.create(name: 'John Doe', email: 'john@example.com', password: 'password')

        expect do
          post :create, params: { group: { name: 'New Group', user: user.name } }
        end.to change(Group, :count).by(1)

        expect(assigns(:group).user).to eq(user.name)
        expect(response).to redirect_to(users_path)
        expect(flash[:notice]).to eq('Group was successfully created.')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new group' do
        user = User.create(name: 'John Doe', email: 'john@example.com', password: 'password')

        expect do
          post :create, params: { group: { name: nil, user: user.name } }
        end.not_to change(Group, :count)

        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns group' do
      user = User.create(name: 'John Doe', email: 'john@example.com', password: 'password')
      group = Group.create(name: 'Group 1', user: user)

      get :edit, params: { id: group.id }
      expect(assigns(:group)).to eq(group)
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH #update' do
    it 'updates the group' do
      user = User.create(name: 'John Doe', email: 'john@example.com', password: 'password')
      group = Group.create(name: 'Group 1', user: user)

      patch :update, params: { id: group.id, group: { name: 'Updated Group', user: user.name } }
      group.reload
      expect(group.name).to eq('Updated Group')
      expect(response).to redirect_to(users_path)
      expect(flash[:notice]).to eq('Group was successfully updated.')
    end

    it 'does not update the group with invalid parameters' do
      user = User.create(name: 'John Doe', email: 'john@example.com', password: 'password')
      group = Group.create(name: 'Group 1', user: user)

      patch :update, params: { id: group.id, group: { name: nil, user: user.name } }
      expect(response).to render_template(:edit)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the group' do
      user = User.create(name: 'John Doe', email: 'john@example.com', password: 'password')
      group = Group.create(name: 'Group 1', user: user)

      expect do
        delete :destroy, params: { id: group.id }
      end.to change(Group, :count).by(-1)

      expect(response).to redirect_to(users_path)
      expect(flash[:notice]).to eq('Group was successfully destroyed.')
    end
  end
end
