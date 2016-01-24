require 'rails_helper'

RSpec.describe Admin::CafeShiftsController, type: :controller do
  let(:user) { create(:user) }
  let(:shift) { create(:cafe_shift, pass: 3) }

  allow_user_to :manage, CafeShift

  before(:each) do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #show' do
    it 'assigns the requested cafe_shift as @cafe_shift' do
      get :show, id: shift.to_param
      assigns(:cafe_shift).should eq(shift)
      assigns(:councils).should eq(Council.titles)
      assigns(:users).should eq(User.all_firstname)
      response.status.should eq(200)
    end

    it 'error cafe_shift is not found' do
      lambda do
        get :show, id: 9999777
      end.should raise_error(ActionController::RoutingError)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested cafe_shift as @cafe_shift' do
      get :edit, id: shift.to_param
      assigns(:cafe_shift).should eq(shift)
      response.status.should eq(200)
    end

    it 'error cafe_shift is not found' do
      lambda do
        get :show, id: 9999777
      end.should raise_error(ActionController::RoutingError)
    end
  end

  describe 'GET #new' do
    it 'assigns a new cafe_shift as @cafe_shift' do
      get(:new)
      assigns(:cafe_shift).new_record?.should be_truthy
      assigns(:cafe_shift).instance_of?(CafeShift).should be_truthy
    end
  end

  describe 'POST #create' do
    it 'valid params' do
      lambda do
        post :create, cafe_shift: attributes_for(:cafe_shift)
      end.should change(CafeShift, :count).by(1)

      response.should redirect_to([:admin, CafeShift.last])
    end

    it 'invalid params' do
      lambda do
        post :create, cafe_shift: { start: nil }
      end.should change(CafeShift, :count).by(0)

      response.should render_template(:new)
      response.status.should eq(422)
    end
  end

  describe 'PATCH #update' do
    it 'valid params' do
      post :update, id: shift.to_param, cafe_shift: { pass: 4 }
      shift.reload

      response.should redirect_to([:admin, shift])
      shift.pass.should eq(4)
    end

    it 'valid params' do
      post :update, id: shift.to_param, cafe_shift: { pass: nil }

      response.should render_template(:edit)
      response.status.should eq(422)
      shift.reload
      shift.pass.should eq(3)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys record' do
      shift.reload
      lambda do
        delete :destroy, id: shift.to_param
      end.should change(CafeShift, :count).by(-1)
    end
  end

  describe 'GET #setup' do
    it 'assigns a new cafe_shift as @cafe_shift' do
      get(:setup)
      assigns(:cafe_shift).new_record?.should be_truthy
      assigns(:cafe_shift).instance_of?(CafeShift).should be_truthy
    end
  end

  describe 'POST #setup_create' do
    it 'creates multiple cafe_shifts' do
      lambda do
        post(:setup_create, cafe_shift: { lv: 1,
                                          lv_last: 1,
                                          start: Time.zone.now.change(hour: 8),
                                          lp: 4 })
      end.should change(CafeShift, :count).by(20)
      response.should redirect_to(admin_cafe_shifts_path)

      assigns(:cafe_shift).new_record?.should be_truthy
      assigns(:cafe_shift).instance_of?(CafeShift).should be_truthy
    end
  end
end