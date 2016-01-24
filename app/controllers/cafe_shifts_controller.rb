# encoding:UTF-8
class CafeShiftsController < ApplicationController
  load_permissions_and_authorize_resource

  def show
    @cafe_shift = CafeShift.find(params[:id])
    @cafe_shift.cafe_worker || @cafe_shift.build_cafe_worker
    @councils = Council.titles
  end

  def feed
    render json: CafeQueries.between(params[:start], params[:end]).
      as_json(user: current_user)
  end

  private

  def cafe_worker_params
    params.require(:cafe_worker).permit(:user_id, :competition, :group, :council_ids)
  end
end