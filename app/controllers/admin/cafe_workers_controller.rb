# encoding: UTF-8
class Admin::CafeWorkersController < ApplicationController
  load_permissions_and_authorize_resource
  load_and_authorize_resource :cafe_shift, parent: true

  def create
    cafe_shift = CafeShift.find(params[:cafe_shift_id])
    cafe_shift.build_cafe_worker(cafe_worker_params)
    if cafe_shift.cafe_worker.save!
      redirect_to(cafe_shift_path(cafe_shift), notice: alert_create(CafeWorker))
    else
      render controller: :cafe_shifts, action: :show
    end
  end

  def update
    cafe_shift = CafeShift.find(params[:cafe_shift_id])
    cafe_worker = CafeWorker.find(params[:id])
    if cafe_worker.update(cafe_worker_params)
      redirect_to(cafe_shift_path(cafe_shift), notice: alert_update(CafeWorker))
    else
      render controller: :cafe_shifts, action: :show
    end
  end

  def destroy
    cafe_shift = CafeShift.find(params[:cafe_shift_id])
    cafe_worker = CafeWorker.find(params[:id])
    if cafe_worker.destroy!
      redirect_to(cafe_shift_path(cafe_shift), notice: alert_destroy(CafeWorker))
    else
      redirect_to(cafe_shift_path(cafe_shift))
    end
  end

  private

  def cafe_worker_params
    params.require(:cafe_worker).permit(:user_id, :competition, group_ids: [])
  end
end
